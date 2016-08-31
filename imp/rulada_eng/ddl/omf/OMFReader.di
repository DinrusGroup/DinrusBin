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
module ddl.omf.OMFReader;

private import ddl.DDLReader;
private import ddl.Utils;

private import mango.io.Buffer;

private import mango.io.model.IBuffer;
private import mango.io.model.IConduit;
private import mango.io.model.IReader;

typedef ushort OMFIndex;
typedef uint VWord;
typedef ushort VByte;
typedef char[] LString;

/**
	Reader implementation to ease OMF Parsing.
	
	The OMFReader helps with some OMF specific behaviors, such as specalized string formats
	and special index fields.  The reader also contains the current 'type' for the current
	record, which has certain implications for the getVWord and getVByte methods.
	
	The class is abstract and is implemented directly via WordOMFREader and DWordOMFReader.
*/
public abstract class OMFReader : DDLReader{
	ubyte type;
	
	protected this(void[] buffer,ubyte type){
		super(buffer);
		this.type = type;
	} 
	
	protected this (IBuffer buffer,ubyte type){
		super(buffer);
		this.type = type;
	}
	
	protected this (IConduit conduit,ubyte type){
		super(conduit);
		this.type = type;
	}
	
	/// returns: the type of the reader as provided in the construtor.
	public ubyte getType(){
		return this.type;
	}
	
	//NOTE: workaround to help D resolve quasi-covaraint overrides
	alias DDLReader.get get; 
	
	OMFReader get(inout OMFIndex x){
		ubyte dataByte;
				
		get(dataByte);
		
		// index is bigger than one byte
		if (dataByte & 0x80){
			x = cast(OMFIndex)((dataByte & 0x7F) << 8); // preserve lower 7 bits and shift left by 8
			get(dataByte); // get next byte
			x += dataByte; // add them together
		}
		else x = cast(OMFIndex)dataByte; // the one byte will do	
		
		return this;
	}
	
	OMFReader get(inout LString x){
		// read the length
		ushort strLength;
		ubyte dataByte;
		get(dataByte);
						
		// empty string
		if(dataByte == 0){
			 x = cast(LString)"";
			 return this;
		}
		
		//NOTE: this is an undocumented extension to OMF for supporting names greater than 254 chars in length!!!
		if(dataByte == 255){
			get(dataByte); // throw away next byte (possibly high-order bytes in little-endian format - usually zero)
			get(strLength); // get the actual 16-bit length
		}
		else{
			strLength = dataByte;
		}
		
		get(x,strLength);		
		return this;
	}
	
	abstract OMFReader get(inout VWord x);
	abstract OMFReader get(inout VByte x);
}

/**
	Subclass of OMFReader that provides the getVWord and getVByte methods as appropriate
	for word-oriented (even) OMF records.
*/
class WordOMFReader : OMFReader{
	/// Constructor
	public this(void[] data, ubyte type){
		super(data,type);
	}	
	
	/// Constructor
	public this (IBuffer buffer,ubyte type){
		super(buffer,type);
	}
	
	/// Constructor
	public this (IConduit conduit,ubyte type){
		super(conduit,type);
	}
		
	alias OMFReader.get get; 
	
	/// returns: the next word in the buffer/conduit
	public override OMFReader get(inout VWord x){
		ushort wordData;
		get(wordData);
		x = cast(VWord)wordData;
		return this;
	}
	
	/// returns: the next byte in the buffer/conduit
	public override OMFReader get(inout VByte x){
		ubyte byteData;
		get(byteData);
		x = cast(VByte)byteData;		
		return this;
	}
}

/**
	Subclass of OMFReader that provides the getVWord and getVByte methods as appropriate
	for dword-oriented (odd) OMF records.
*/
class DWordOMFReader : OMFReader{
	/// Constructor
	public this (IBuffer buffer,ubyte type){
		super(buffer,type);
	}
	
	/// Constructor
	public this (IConduit conduit,ubyte type){
		super(conduit,type);
	}	
	
	/// Constructor
	public this(ubyte[] data, ubyte type){
		super(data,type);
	}
	
	alias OMFReader.get get; 
	
	/// returns: the next dword in the buffer/conduit
	public override OMFReader get(inout VWord x){
		uint wordData;
		get(wordData);
		x = cast(VWord)wordData;
		return this;
	}
	
	/// returns: the next word in the buffer/conduit
	public override OMFReader get(inout VByte x){
		ushort byteData;
		get(byteData);
		x = cast(VByte)byteData;
		return this;	
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
