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
    Copyright: 2005-2006 Lars Ivar Igesund
*/
module ddl.elf.ELFModule;

private import ddl.Utils;
private import ddl.DynamicModule;
private import ddl.ExportSymbol;
private import ddl.FileBuffer;
private import ddl.Attributes;

private import ddl.elf.ELFBinary;
private import ddl.elf.ELFReader;
private import ddl.elf.ELFPrinter;

/**
    An implementation of the abstract class DynamicModule for use 
    with ELF (Executable and Linkable Format) object files. 
*/
class ELFModule : DynamicModule{
	struct SegmentImage{
		void[] data;
	}
	
	struct Fixup{
		uint targetIndex;
		bool isExternStyleFixup;
		bool isSegmentRelative;
		void* destAddress;
	}
	
	alias ExportSymbol* ExportSymbolPtr;
	alias SegmentImage* SegmentImagePtr;

	Fixup[] fixups;
	SegmentImage[] segmentImages;
	ExportSymbol[] symbols;
	ExportSymbolPtr[char[]] symbolXref;
	char[] moduleName;
	bool resolved;
	
	debug ELFBinary binary;

	this(FileBuffer buffer){
		resolved = false;
		loadBinary(new ELFReader(buffer));
	}
		
	this(ELFReader reader){
		resolved = false;
		loadBinary(reader);
	}
	
	public char[] getName(){
		return moduleName;
	}
	
	public ExportSymbol[] getSymbols(){
		return symbols;
	}
	
	public ExportSymbol* getSymbol(char[] name){
		if(name in symbolXref) return symbolXref[name];
		else return &ExportSymbol.NONE;
	}
	
	public void resolveFixups(){
		Fixup[] remainingFixups;
		
		foreach(idx,fix; fixups) with(fix){
			uint fixupValue;
		}
		
		this.fixups = remainingFixups;
	}
	
	public bool isResolved(){
		if(resolved) return true;
		
		if(fixups.length > 0) return false;
		foreach(sym; symbols){
			if(sym.type != SymbolType.Strong) return false;
		}
		resolved = true;
		return true;
	}
	
	protected void loadBinary(ELFReader reader){
//		debug() else{
//			ELFBinary binary;
//		}
		
		//TODO: analyze 
	}
    
	char[] toString(){
		char[] result = "";
		ExtSprintClass sprint = new ExtSprintClass(1024);
	
		debug{
			result = "ELF Binary Data: \n" ~ binary.toString();
		}
	
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
