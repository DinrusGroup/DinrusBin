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
module ddl.elf.ELFLibrary;

private import ddl.DynamicLibrary;
private import ddl.DynamicModule;
private import ddl.ExportSymbol;
private import ddl.Attributes;
private import ddl.Utils;
private import ddl.FileBuffer;

private import ddl.elf.ELFHeaders;
private import ddl.elf.ELFModule;
private import ddl.elf.ELFPrinter;

private import mango.io.Exception;
private import mango.io.model.IBuffer;
private import mango.io.model.IConduit;

/**
    An implementation of the abstract class DynamicLibrary for use 
    with libraries of ELF (Executable and Linkable Format) object
    files. 
*/
class ELFLibrary : DynamicLibrary{
	DynamicModule[] modules;
	DynamicModule[char[]] crossReference; // modules by symbol name
	ExportSymbolPtr[char[]] dictionary; // symbols by symbol name
	Attributes attributes;

	public this(){
		attributes["elf.filename"] = "<unknown>";
	}
	
	public this(FileBuffer file){
		attributes["elf.filename"] = file.getPath.toString();
		load(file);
	}
		
	public char[] getType(){
		return "OMF";
	}
	
	public Attributes getAttributes(){
		return attributes;
	}
	
	package void setAttributes(Attributes other){
		other.copyInto(this.attributes);
	}
	
	package void setAttribute(char[] key,char[] value){
		this.attributes[key] = value;
	}
	
	public ExportSymbolPtr getSymbol(char[] name){
		ExportSymbolPtr* sym = name in dictionary;
		if(sym) return *sym;
		else return &ExportSymbol.NONE;
	}
	
	public DynamicModule[] getModules(){
		return this.modules;
	}
		
	public DynamicModule getModuleForSymbol(char[] name){
		debug debugLog("[OMF] looking for " ~ name);
		DynamicModule* mod = name in crossReference;
		debug debugLog("[OMF] Result: %0.8X",mod);
		if(mod) return *mod;
		return null;
	}
	
	public ubyte[] getResource(char[] name){
		return (ubyte[]).init;
	}
	
	package void addModule(ELFModule mod){
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
		
	protected void load(IBuffer data){
		//TODO
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
