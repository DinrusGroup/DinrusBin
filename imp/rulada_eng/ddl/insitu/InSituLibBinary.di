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
module ddl.insitu.InSituLibBinary;

private import std.zlib;

private import ddl.FileBuffer;
private import ddl.DDLReader;
private import ddl.DDLWriter;
private import ddl.ExportSymbol;
private import ddl.Utils;

private import ddl.insitu.InSituBinary;

private import mango.io.GrowBuffer;
debug private import mango.io.Stdout;

class InSituLibBinary : InSituBinary{
	protected static const char[] magicString = "DDLSITU!";
	protected static const uint InSituVersion = 0x00010001;
	protected static const uint BufferSize = 4096;
	
	ExportSymbol[char[]] allSymbols;
	
	public this(){
		// do nothing
	}
	
	public ExportSymbol[char[]] getAllSymbols(){
		return allSymbols;
	}
	
	public void setAllSymbols(ExportSymbol[char[]] newSymbols){
		allSymbols = newSymbols;
	}
		
	public void load(FileBuffer file){
		ubyte[] magic;
		uint fileVersion;
		uint symbolCount;
		void[] binaryData;
		DDLReader reader = new DDLReader(file);		
						
		// read the magic
		reader.get(magic,8);
		reader.get(fileVersion);
		
		assert(magic == cast(ubyte[])magicString);
		assert(fileVersion == InSituVersion);
				
		// read symbol count
		reader.get(symbolCount);
		
		debug debugLog("%d symbols",symbolCount);
		
		// read compressed data area
		reader.getAll(binaryData);
		reader = new DDLReader(uncompress(binaryData));
		
		debug debugLog("reading decompressed data");
				
		// read symbols
		for(uint i=0; i<symbolCount; i++){
			uint address;
			ExportSymbol sym;
			
			reader.get(address);
			reader.get(sym.name);
						
			sym.address = cast(void*)address;
			sym.type = SymbolType.Strong;
					
			allSymbols[sym.name] = sym;
		}
	}
	
	public void save(FileBuffer file,ubyte compressionLevel){
		DDLWriter zipWriter = new DDLWriter(new GrowBuffer());
		assert(compressionLevel <= 9);

		// write everything to the buffer
		foreach(ExportSymbol sym; allSymbols.values){
			zipWriter.put(cast(uint)sym.address);
			zipWriter.put(sym.name);
		}
		
		// compress the data
		ubyte[] binaryData = cast(ubyte[])compress(zipWriter.getBuffer.toString,compressionLevel);

		// write the actual file
		DDLWriter writer = new DDLWriter(file);
		writer.getBuffer.append(cast(void[])magicString);
		writer.put(InSituVersion);
		writer.put(allSymbols.length);
		writer.getBuffer.append(cast(void[])binaryData);
	}
}

/+
	InSituLibBinary ::= header compressedData 
	header ::= magicString fileVersion symbolCount
	fileVersion ::= uint
	symbolCount ::= uint
	
	compressedData ::= zlib-compressed(data)
	data ::= symbol | symbol data
	symbol ::= address name newline
	address ::= uint
	
	newline ::= '\n'
	name ::= string
	string ::= length char(length)
	length ::= uint	
	
	hexchar ::= [0-9] | [a-f] | [A-F]
+/
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
