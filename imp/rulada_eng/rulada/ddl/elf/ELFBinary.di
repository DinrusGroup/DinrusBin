/+
    Copyright (c) 2005-2006 Lars Ivar Igesund, Eric Anderton

    Permission is hereby granted, free of charge, to any person
    obtaining a copy of this software and associated documentation
    files (the "Software"), to deal in the Software without
    restriction, including without limitation the rights to use,
    copy, modify, merge, publish, distribute, sublicense, and/or
    sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following
    conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
    OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
    HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
    OTHER DEALINGS IN THE SOFTWARE.
+/
/**
    Authors: Lars Ivar Igesund, Eric Anderton
    License: BSD Derivative (see source for details)
    Copyright: 2005-2006 Lars Ivar Igesund, Eric Anderton
*/
module ddl.elf.ELFBinary;

private import ddl.ExportSymbol;
private import ddl.Attributes;
private import ddl.Utils;
private import ddl.DDLException;

private import ddl.elf.ELFHeaders;
private import ddl.elf.ELFReader;
private import ddl.elf.ELFPrinter;

private import mango.io.model.IBuffer;
private import mango.io.model.IConduit;

private import mango.convert.Integer;

//TODO: the efficency of this parser/class can be *greatly* enhanced by the use of some C programming idioms
//TODO: read in the entire file into a flat memory buffer, and cast offset fields to pointers to move around
//TODO: avoid copying the data - just point and use look-aside hashtables for D compatibility

class ELFBinary{
public:
	Elf32_Ehdr elfhdr;
	Elf32_Shdr[] sechdrs;
	Elf32_Phdr[] proghdrs;
	Elf32_Sym[] globalSymbols;
	Elf32_Sym[] localSymbols;
	Elf32_Sym[] weakSymbols;
	
	Elf32_Sym[] symbols;
	
	ExportSymbol[char[]] exports;
	ExportSymbol[] unresolvedSymbols;
	
	char[] shnames;
	char[] dynsymnames;
	char[] symtabnames;
	
	bit dynamic;
	
	Attributes attributes;
	
    /**
        Constructor.
    */
    this(){
    }

    /**
        Loads an ELF object file from the provided reader.

        Params: reader = an ELFReader object containing the data to
                            be read
    */
    void parse(ELFReader reader){
        // Read ELF Header
        reader.get(elfhdr);

        // Checking sanity of ELF magic string
        if(elfhdr.e_ident[0..4] != cast(ubyte[])"\x7fELF"){
            throw new DDLException("Not a valid ELF Object file");
        }

        // Check the ELFCLASS
        switch (elfhdr.e_ident[EI_CLASS]) {
        case ELFCLASSNONE:
            throw new DDLException("Invalid ELFCLASS");
            break;
        case ELFCLASS32:
            // Do nothing, it is the only currently supported path according to the docs, but it sounds strange ... maybe the document is old
            break;
        case ELFCLASS64:
            throw new DDLException("ELFCLASS64 is not implemented and currently not defined");
            break;
        default:
            throw new DDLException("Unknown ELFCLASS");
            break;
        }

        // Check how data is encoded 
        if (elfhdr.e_ident[EI_DATA] == ELFDATANONE) {
            throw new DDLException("Invalid data encoding.");
        }

        // Check the version of the specification the file use
        uint elfversion = elfhdr.e_ident[EI_VERSION];
        if (elfversion == EV_NONE || elfversion > EV_CURRENT) {
            throw new DDLException("Invalid specification version.");
        }
        else if (elfversion > DDL_ELFVERSION_SUPP) {
            throw new DDLException("This version of the specification is still to be implemented.");
        }

        version(X86){
            if ((elfhdr.e_ident[EI_CLASS] != ELFCLASS32) ||
                (elfhdr.e_ident[EI_DATA] != ELFDATA2LSB) ||
                (elfhdr.e_machine != EM_386)) {
                throw new DDLException("Object file not supported on this platform.");
            } 
        }
        else{
            throw new DDLException("This hardware platform is not yet supported.");
        }

        if ((proghdrs.length = elfhdr.e_phnum) > 0) {
            // Move ahead to program header table
            reader.setPosition(elfhdr.e_phoff);
           
            debug debugLog("program headers: %d",proghdrs.length);
           
            // Read program headers
            for (int i = 0; i < proghdrs.length; i++) {
                Elf32_Phdr ephdr;
                reader.get(ephdr);
                proghdrs[i] = ephdr;
            }
        }

        //TODO: should this ignore the e_shentsize when reading sections?
        if ((sechdrs.length = elfhdr.e_shnum) > 0) {
            // Move ahead to section header table
            reader.setPosition(elfhdr.e_shoff);
            
            debug debugLog("section headers: %d",sechdrs.length);
            
            // Read section headers
            for (int i = 0; i < sechdrs.length; i++) {
                Elf32_Shdr eshdr;
                reader.get(eshdr);
                sechdrs[i] = eshdr;
            }
        }
        
        debug{
	        debugLog("type: %d",elfhdr.e_type);
	        debugLog("machine: %d",elfhdr.e_machine);
	        debugLog("flags: %0.8x",elfhdr.e_flags);
	        debugLog("section header size: %d",elfhdr.e_shentsize);
        }
	
        // section header index for symbol table
        uint symtableidx = -1;

        // Load section names
        reader.setPosition(sechdrs[elfhdr.e_shstrndx].sh_offset);        
        reader.get(shnames,sechdrs[elfhdr.e_shstrndx].sh_size);
        
        // parse sections
        for(int i = 0; i < sechdrs.length; i++) {
	        Elf32_Shdr thisSection = sechdrs[i];
	        	        
	        switch(thisSection.sh_type){
		    case SHT_NULL: 
		    /*This value marks the section header as inactive; it does not have an associated section.
			Other members of the section header have undefined values */
		    	break;
		    	
			case SHT_PROGBITS: 
			/*The section holds information defined by the program, whose format and meaning are
			determined solely by the program.*/
				break;
				
			case SHT_SYMTAB:
			/* symbol table */
				// get associated string table
				Elf32_Shdr stringSection = sechdrs[thisSection.sh_link];
				char[] stringTable;
				
				reader.setPosition(stringSection.sh_offset);
				reader.get(stringTable,stringSection.sh_size);
				
				char[][uint] symbolNames = crackStringTable(stringTable);

				// read in the symbols
				reader.setPosition(thisSection.sh_offset);
				parseSYMTAB(thisSection.sh_info, symbolNames, reader);
				break;
				
			case SHT_STRTAB: 
			/*The section holds a string table. An object file may have multiple string table sections. */
				break;
				
			case SHT_RELA: 
			/*The section holds relocation entries with explicit addends, such as type Elf32_Rela
			for the 32-bit class of object files. An object file may have multiple relocation sections.*/
				break;
				
			case SHT_HASH: break;
			case SHT_DYNAMIC: break;
			
			case SHT_NOTE: 
			/*The section holds information that marks the file in some way. 
			See "Note Section" in Part 2 for details.*/
				
				break;
				
			case SHT_NOBITS: break;
			case SHT_REL: 
			/* The section holds relocation entries without explicit addends, such as type
			Elf32_Rel for the 32-bit class of object files. An object file may have multiple relocation
			sections. */
				break;
				
			case SHT_SHLIB: break;
			case SHT_DYNSYM: break;
			case SHT_LOPROC: break;
			case SHT_HIPROC: break;
			case SHT_LOUSER: break;
			case SHT_HIUSER: break;
		    default:
	        }
        }
        loadSymTable(symtableidx, reader);
    }
    
    protected char[][uint] crackStringTable(char[] data){
	    char[][uint] table;
        debug debugLog("* String table length is %s", data.length);
	    for(uint i = 0, last = 0; i<data.length; i++){
		    if(data[i] == '\0'){
			    table[last] = data[last..i];
                debug debugLog("* Symbol %s found, idx %s", table[last], last);
			    i++;
			    last = i;
		    }
	    }
        debug debugLog("* Found %s symbols in stringtable", table.length);
	    return table;
    }

	protected void loadSymTable(uint idx, ELFReader reader) {

	}
	
	protected void parseSYMTAB(uint symbols, char[][uint] symbolNames,ELFReader reader){
		for(int i=0; i<symbols; i++){
			Elf32_Sym sym;
			reader.get(sym);
		    
			//TODO: refer to STB_LOCAL to ensure that symbols don't overlap
		    
			ExportSymbol exportSym;
			debug debugLog("* Symbol name: %s", sym.st_name);
			exportSym.name = symbolNames[sym.st_name];
			debug debugLog("* Extracted symbol %s", exportSym.name);
		    
			//TODO: resolve symbol data address by cracking the sym fields per the specification
		}
	}
	
	public Attributes getAttributes(){
		if(this.attributes != Attributes.init){
			return this.attributes;
		}
		
		return attributes;
	}
    
	char[] toString(){
		char[] result = "";
		ELFPrinter printer = new ELFPrinter();

		result ~= "Header:\n" ~ printer.printElfHeader(elfhdr);
		result ~= "\n" ~ printer.printProgramHeaders(proghdrs);
		result ~= "\n" ~ printer.printSectionHeaders(sechdrs);
		result ~= "\n" ~ printer.printSymbols(symbols);
		
		return result;
	}
}

private ubyte ELF32_ST_BIND(ubyte i){
    return i >> 4;
}

private ubyte ELF32_ST_TYPE(ubyte i){
    return i & 0xf;
}

private ubyte ELF32_ST_INFO(ubyte b, ubyte t){
    return (b << 4) + (t & 0xf);
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-ddl");
        } else version (DigitalMars) {
            pragma(link, "mango");
        } else {
            pragma(link, "DO-ddl");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-ddl");
        } else version (DigitalMars) {
            pragma(link, "mango");
        } else {
            pragma(link, "DO-ddl");
        }
    }
}
