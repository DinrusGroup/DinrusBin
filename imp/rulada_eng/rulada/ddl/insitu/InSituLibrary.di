/+
	Copyright (c) 2005 Eric Anderton
        
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
module ddl.insitu.InSituLibrary;

private import ddl.ExportSymbol;
private import ddl.DynamicLibrary;
private import ddl.DynamicModule;
private import ddl.Utils;
private import ddl.insitu.InSituBinary;
private import ddl.insitu.InSituModule;

//TODO: In-Situ should be upgraded to split symbols into a C-level module and a D-level module.
class InSituLibrary : DynamicLibrary{
	DynamicModule[] modules;
	DynamicModule[char[]] crossReference; // modules by symbol name
	ExportSymbolPtr[char[]] dictionary; // symbols by symbol name
	char[] filename;
	
	public this(){
	}
	
	public this(char[] filename,InSituBinary binary){
		this.filename = filename;
		addModule(new InSituModule(binary.getAllSymbols));
	}
	
	public this(InSituBinary binary){
		addModule(new InSituModule(binary.getAllSymbols));
	}	
		
	public char[] getType(){
		return "SITU";
	}
	
	public char[][char[]] getAttributes(){
		return (char[][char[]]).init; //TODO: support this
	}		
	
	public ExportSymbolPtr getSymbol(char[] name){
		return dictionary[name];
	}
	
	public DynamicModule[] getModules(){
		return this.modules;
	}
			
	public DynamicModule getModuleForSymbol(char[] name){
		debug debugLog("[SITU] looking for: %s (xref size: %d)",name,crossReference.length);
		DynamicModule* mod = name in crossReference;
		debug debugLog("[SITU] result: %0.8X",cast(void*)mod);
		if(mod) return *mod;
		return null;
	}
	
	public ubyte[] getResource(char[] name){
		return (ubyte[]).init;
	}	
	
	package void addModule(DynamicModule mod){
		this.modules ~= mod;
		auto symbols = mod.getSymbols();
		for(uint i=0; i<symbols.length; i++){
			ExportSymbolPtr exp = &(symbols[i]);
			dictionary[exp.name] = exp;
			crossReference[exp.name] = mod;
		}
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
