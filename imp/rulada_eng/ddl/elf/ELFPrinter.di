/+
    Copyright (c) 2005-2006 Lars Ivar Igesund

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
    Authors: Lars Ivar Igesund
    License: BSD Derivative (see source for details)
    Copyright: 2005-2006 Lars Ivar Igesund
*/
module ddl.elf.ELFPrinter;

private import ddl.elf.ELFHeaders;
private import ddl.Attributes;
private import ddl.Utils;

class ELFPrinter{
	private ExtSprintClass sprint;
	
	private static char[][] sectionTypes = ["SHT_NULL", "SHT_PROGBITS", "SHT_SYMTAB",
	                     "SHT_STRTAB", "SHT_RELA", "SHT_HASH",
	                     "SHT_DYNAMIC", "SHT_NOTE", "SHT_NOBITS",
	                     "SHT_REL", "SHT_SHLIB", "SHT_DYNSYM"];
	
	private static char[][] segmentTypes = ["PT_NULL", "PT_LOAD", "PT_DYNAMIC",
	                     "PT_INTERP", "PT_NOTE", "PT_SHLIB",
	                     "PT_PHDR"];
	
	private static char[][] objectTypes = ["ET_NONE", "ET_REL (Relocatable)", 
	                    "ET_EXEC (Executable)", "ET_DYN (Dynamic)",
	                    "ET_CORE"];
	
	private static char[][] classStrings = ["ELFCLASSNONE", "ELFCLASS32", "ELFCLASS64"];
	
	private static char[][] dataStrings = ["ELFDATANONE (Invalid)", 
	                    "2's complement, little endian",
	                    "ELFDATA2MSB"];
	
	private static char[][] versionStrings = ["0", "1 (current)"];
	
	private static char[][] machineStrings = ["EM_NONE", "EM_M32", "EM_SPARC",
	                       "EM_386 (Intel 80386)", "EM_68K", "EM_88K",
	                       "EM_860", "EM_MIPS"];
	
	private char[] sectionTypeStr(uint n) {
		if (n <= SHT_DYNSYM) {
		    return sectionTypes[n];
		}
		else if (n >= SHT_LOPROC && n <= SHT_HIPROC) {
		    return "[SHT_LOPROC..SHT_HIPROC]";
		}
		else if(n >= SHT_LOUSER && n <= SHT_HIUSER) {
		    return "[SHT_LOUSER..SHT_HIUSER]";
		}
		return "";
	}
	
	private char[] segmentTypeStr(uint n) {
		if (n <= PT_SHLIB) {
		    return segmentTypes[n];
		}
		else if (n >= PT_LOPROC && n <= PT_HIPROC) {
		    return "[PT_LOPROC..PT_HIPROC]";
		}
		return "";
	}
	
	private char[] objectTypeStr(uint n) {
		if (n <= ET_CORE) {
		    return objectTypes[n];
		}
		else if (n >= ET_LOPROC && n <= ET_HIPROC) {
		    return "[ET_LOPROC..ET_HIPROC]";
		}
		return "";
	}
	
	public this(){
		sprint = new ExtSprintClass(1024);
	}
	
	public char[] printElfHeader(Elf32_Ehdr hdr){
		ubyte[] m = hdr.e_ident;
		char[] result;
		
		result ~= sprint("  Magic:\t%02X %02X %02X %02X %02X %02X %02X %02X %02X %02X %02X %02X %02X %02X %02X %02X\n", m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8], m[9], m[10], m[11], m[12], m[13], m[14], m[15]);
		result ~= sprint("  Class:\t\t\t\t%s\n", classStrings[m[EI_CLASS]]);
		result ~= sprint("  Data:\t\t\t\t\t%s\n", dataStrings[m[EI_DATA]]);
		result ~= sprint("  Version:\t\t\t\t%s\n", versionStrings[m[EI_VERSION]]);
		result ~= sprint("  Type:\t\t\t\t\t%s\n", objectTypeStr(hdr.e_type));
		result ~= sprint("  Machine:\t\t\t\t%s\n", machineStrings[hdr.e_machine]);
		result ~= sprint("  Version:\t\t\t\t0x%x\n", hdr.e_version);
		result ~= sprint("  Entry point address:\t\t\t0x%x\n", hdr.e_entry);
		result ~= sprint("  Start of program headers:\t\t%s (bytes into the file)\n", hdr.e_phoff);
		result ~= sprint("  Start of section headers:\t\t%s (bytes into the file)\n", hdr.e_shoff);
		result ~= sprint("  Flags:\t\t\t\t0x%x\n", hdr.e_flags);
		result ~= sprint("  Size of this header:\t\t\t%s (bytes)\n",  hdr.e_ehsize);
		result ~= sprint("  Size of program headers:\t\t%s (bytes)\n", hdr.e_phentsize);
		result ~= sprint("  Number of program headers:\t\t%s\n", hdr.e_phnum);
		result ~= sprint("  Size of section headers:\t\t%s (bytes)\n",hdr.e_shentsize);
		result ~= sprint("  Number of section headers:\t\t%s\n",hdr.e_shnum);
		result ~= sprint("  Section header string table index:\t%s\n\n", hdr.e_shstrndx);
		                 
		return(result);
	}

	public char[] printProgramHeader(uint n, Elf32_Phdr hdr){
		char[] result;
		
		result ~= sprint("Program header %d\n", n);
		result ~= sprint("  Type:\t\t\t\t%s\n", segmentTypeStr(hdr.p_type));
		result ~= sprint("  Offset:\t\t\t0x%x\n", hdr.p_offset);
		result ~= sprint("  Virtual address:\t\t0x%x\n", hdr.p_vaddr);
		result ~= sprint("  Physical address:\t\t0x%x\n", hdr.p_paddr);
		result ~= sprint("  Size in file:\t\t\t%d (in bytes)\n", hdr.p_filesz);
		result ~= sprint("  Size in memory:\t\t%d (in bytes)\n", hdr.p_offset);
		result ~= sprint("  Flags:\t\t\t0x%x\n", hdr.p_flags);
		result ~= sprint("  Alignment:\t\t\t%d\n", hdr.p_align);
		                 
		return(result);
	}
	
	public char[] printProgramHeaders(Elf32_Phdr[] headers){
		char[] result = sprint("Program Headers: %d\n",headers.length);
		foreach(idx,hdr; headers)  result ~= printProgramHeader(idx,hdr);
		return result;
	}
	
	public char[] printSectionHeader(uint n, char[] name, Elf32_Shdr hdr){
		char[] result;
		
		result ~= sprint("Section header %d: %s\n", n, name);
		result ~= sprint("  Type:\t\t\t\t%s\n", sectionTypeStr(hdr.sh_type));
		result ~= sprint("  Flags:\t\t\t0x%x\n", hdr.sh_flags);
		result ~= sprint("  Memory address:\t\t0x%x\n", hdr.sh_addr);
		result ~= sprint("  File offset:\t\t\t%d\n", hdr.sh_offset);
		result ~= sprint("  Size:\t\t\t\t%d (in bytes)\n", hdr.sh_size);
		result ~= sprint("  Linked section:\t\t%d\n", hdr.sh_link);
		result ~= sprint("  Info:\t\t\t\t%d\n", hdr.sh_info);
		result ~= sprint("  Alignment:\t\t\t%d\n", hdr.sh_addralign);
		result ~= sprint("  Entry size:\t\t\t%d (in bytes)\n", hdr.sh_entsize);
		                 
		return(result);
	}
	
	public char[] printSectionHeaders(Elf32_Shdr[] headers){
		char[] result = sprint("Headers: %d\n",headers.length);
		char[] name = ""; //TODO
		foreach(idx,hdr; headers)  result ~= printSectionHeader(idx,name,hdr);
		return result;
	}
	
	public char[] printSymbol(uint n, char[] name, Elf32_Sym sym){
		char[] result;
		
		result ~= sprint("Symbol %d: %s\n", n, name);
		result ~= sprint("  Value:\t\t\t0x%x\n", sym.st_value);
		result ~= sprint("  Size:\t\t\t%d\n", sym.st_size);
		result ~= sprint("  Info:\t\t\t%d\n", sym.st_info);
		result ~= sprint("  Other:\t\t\t%d\n", sym.st_other);
		result ~= sprint("  Section index:\t\t%d\n", sym.st_shndx);
		                 
		return(result);
	}
	
	public char[] printSymbols(Elf32_Sym[] symbols){
		char[] result = sprint("Symbols: %d\n",symbols.length);
		char[] name = ""; //TODO
		foreach(idx,sym; symbols)  result ~= printSymbol(idx,name,sym);
		return result;
	}
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
