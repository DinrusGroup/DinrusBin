/+
    Copyright (c) 2005,2006 Lars Ivar Igesund, J Duncan, Eric Anderton

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
module ddl.ar.ArchiveLibrary;

private import ddl.FileBuffer;
private import ddl.Attributes;
private import ddl.DynamicModule;
private import ddl.DynamicLibrary;
private import ddl.LoaderRegistry;
private import ddl.DefaultRegistry;
private import ddl.ExportSymbol;
private import ddl.DDLException;
private import ddl.Utils;
private import ddl.Mangle;
private import ddl.ar.ArchiveReader;

private import mango.io.model.IBuffer;
private import mango.convert.Atoi;
private import mango.text.Text;

class ArchiveLibrary : DynamicLibrary{
	const char[] ARCHID = "!<arch>\n";
	
	private ArchiveReader reader;
	private char[] stringtable;
	private uint [char[]] symbolOffsets;
	
	private LoaderRegistry registry = null;	
	private DynamicModule[] modules;
	private DynamicModule[char[]] crossReference; // modules by symbol name
	private ExportSymbolPtr[char[]] dictionary; // symbols by symbol name
	private Attributes attributes;


	public this(LoaderRegistry registry, FileBuffer file, bool loadall = true){
		this.registry = registry;
		attributes["archive.filename"] = file.getPath.toString();
		debug debugLog("* Loading the archive");
		load(file, loadall);
	}
	
	public this(FileBuffer file, bool loadall = true){
		this(new DefaultRegistry, file, loadall);
	}

    protected void loadSymbolTable(char [] symtable)
    in {
        assert (symtable.length >= 4);
    }
    body {
        debug debugLog("* Loading symbol table, size %s", symtable.length);

        uint numsyms = sgetl(cast(ubyte[])symtable[0..4]);
        uint[] offsets;
        uint offset = 4;
        debug debugLog("* Symbol table should have %s entries", numsyms);
        for (int i = 0; i < numsyms; i++) {
            offsets ~= sgetl(cast(ubyte[])symtable[offset..offset+4]);
            offset += 4;
        }
        debug debugLog("* Found %s symbol offsets in symbol table,latest offset was %s ", offsets.length, offset);
        
        uint offsetIdx = 0;
        uint symstart = offset;
        foreach (idx, c; symtable[offset..$]) {
            if (c == '\0') {
                // debug debugLog("* Storing symbol %s", symtable[offset..symstart+idx]);
                // debug debugLog("* Offset %s, idx %s", offset, idx);

                symbolOffsets[symtable[offset..symstart+idx]] = offsets[offsetIdx];
                offsetIdx++;
                offset = symstart + idx + 1;
            }
        }
    }
	// returns the name of a module - for reporting/debugging purposes
	protected char[] getModuleName(char[] filename){
		if(filename[0] == '/'){
		    uint offset = Atoi.parse(Text.trim(filename[1..$])); 
		    debug debugLog("* Finding filename in stringtable, length %s, starting at offset %s", stringtable.length, offset);
		    return stringtable[offset..Text.indexOf(stringtable[offset..$], "/")+offset];
		}
		else{
		    return filename[0..Text.indexOf(filename, r"/")];
		}
	}
	
	private void load(IBuffer data, bool loadall) {		
		//int nAddress;
		char[] signature;
		signature.length = ARCHID.length;
		
		reader = new ArchiveReader(data);
		debug debugLog("* Created an archive reader instance");
		
		// read the library signature
		reader.get(signature, signature.length);
		debug debugLog("* Read archive signature %s", signature);
		
		if(signature != ARCHID){
			throw new DDLException("Archive " ~ attributes["archive.filename"] ~ " has invalid library signature.");
		}
		
		ArchiveHeader hdr;
		char[] memberData;
		char[] fName;
		
		while(reader.hasMore())
		{
		    if (reader.getFile(hdr, memberData, fName) is null) {
			debug debugLog("* ArchiveReader.getFile() returned null");
			break;
		    }
		
		    debug debugLog("* Iterating over files, current is %s", fName); 
		    switch(fName){
		    case "/":
			// Need to check the next header
			// If it has the same name, it is a
			// PECOFF lib, otherwise it's an Ar-lib
			ArchiveHeader tmphdr;
			ubyte[] tmphdrarr;
			reader.peek(tmphdrarr, ArchiveHeader.sizeof);
			if (Text.trim(tmphdr.ar_name) == "/") {
			    // PECOFF archive
			    debug debugLog("* Found PECOFF archive");
			    reader.getFile(hdr, memberData, fName);
			    loadSymbolTable(memberData.dup);
			}
			else {  // Ar
			    loadSymbolTable(memberData.dup);
			}
			break;
		    case "//":
			debug debugLog("* Extracting stringtable");
			stringtable = memberData.dup;
			break;
		    default: 
			if (loadall) 
			    loadModule(fName, memberData);
			else return;
		    }
		}
	}
	
	private void loadModule(char[] fName, char[] memberData, uint idx = -1) {	
		if (idx > 0) {
			//TODO: allow for dynamic positioning into the input stream for lazy loading		    
			//reader.setPosition(idx);
		}
		
		debug debugLog("* Loading module %s from archive", getModuleName(fName));
		debug debugLog("* file starts with: ", memberData[0..4]);
		FileBuffer embeddedFile = new FileBuffer(getModuleName(fName),memberData);
		DynamicLibrary dl = this.registry.load(embeddedFile);
		
		foreach(mod; dl.getModules()){
			addModule(mod);
		}
	}
	
	public DynamicModule[] getModules(){
		return this.modules;
	}
	        
	public ExportSymbolPtr getSymbol(char[] name){
		ExportSymbolPtr* sym = name in dictionary;
		if(sym) return *sym;
		else return &ExportSymbol.NONE;
	}
        
	public char[] getType(){
		return "Archive";
	}

	public Attributes getAttributes(){
		if(this.attributes != Attributes.init){
		return this.attributes;
		}
	}

    
	//TODO: implement lazy loading of modules via the symbolOffsets table
	public DynamicModule getModuleForSymbol(char[] name){
		debug debugLog("[AR] looking for " ~ name);
		DynamicModule* mod = name in crossReference;
		debug debugLog("[AR] Result: %0.8X",mod);
		if(mod) return *mod;	
	}
	
	// AR files have no resources
	public ubyte[] getResource(char[] name){
		return (ubyte[]).init;
	}

	protected void addModule(DynamicModule mod){
		this.modules ~= mod;
		auto symbols = mod.getSymbols();
		for(uint i=0; i<symbols.length; i++){
			ExportSymbolPtr exp = &(symbols[i]);
			if(exp.name in crossReference){
				switch(exp.type){
				case SymbolType.Weak: // replace extern only
					if(dictionary[exp.name].type == SymbolType.Extern){
						crossReference[exp.name] = mod;
						dictionary[exp.name] = exp;
					}
					break;
				case SymbolType.Strong: // always overwrite
					crossReference[exp.name] = mod;
					dictionary[exp.name] = exp;
					break;
				default:
					// do nothing
				}
			}
			else{
				crossReference[exp.name] = mod;
				dictionary[exp.name] = exp;
			}
		}
	}
	
	/**
	    Helper function shift around the values present in the symbol table.
	    Will be used when the loadSymbolTable member is implemented.
	*/
	private uint sgetl(ubyte[] val)
	in {
	    assert(val.length == 4); 
	}
	body{
	    return (val[0] << 24) | (val[1] << 16) | (val[2] << 8) | val[3];
	} 
}

/////////////////////////////////
debug (UNITTEST) {
    private import ddl.DefaultRegistry;
    private import mango.io.Stdout;
}

unittest {
    ArchiveLibrary archlib = new ArchiveLibrary(new DefaultRegistry, 
                                         new FileBuffer("libunittest.a"), true);
    //assert (archlib.getModules().length == 8);
    Stdout.println("Correct number of files found");
    DynamicModule [] mods = archlib.getModules();
    //Stdout.println(mods[0].getName());
    //Stdout.println(mods[1].getName());
    //Stdout.println(mods[2].getName());

    char[] testtable = "thisisaverylongfilename.o/\nyetanotherlongfilename.o/\n";
    archlib.stringtable = testtable;
    assert("thisisaverylongfilename.o" == archlib.getModuleName("/0"));
    assert("yetanotherlongfilename.o" == archlib.getModuleName("/27"));
    assert("shortername.o" == archlib.getModuleName("shortername.o/foobar"));
    Stdout.println("getModuleName works");

    ubyte[] sputl(uint val)
    {
        ubyte[4] ret;
        ret[0] = val >> 24;
        ret[1] = val >> 16;
        ret[2] = val >> 8;
        ret[3] = val >> 0;
        return ret.dup;
    }

    assert(3(sputl(114)) == 114);

    //TODO: unittest loadSymbolTable
    char[] testsyms = cast(char[])sputl(4);
    testsyms ~= cast(char[])sputl(114);
    testsyms ~= cast(char[])sputl(114);
    testsyms ~= cast(char[])sputl(426);
    testsyms ~= "name\0object\0function\0";

    archlib.loadSymbolTable(testsyms);

    assert(archlib.symbolOffsets.length == 3);

    assert("name" in archlib.symbolOffsets);
    assert("object" in archlib.symbolOffsets);
    assert("function" in archlib.symbolOffsets);

    foreach(key, val; archlib.symbolOffsets) {
        Stdout.println("key %s, val %s", key, val);
    }

}

debug (UNITTEST) {
    void main(){}
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
