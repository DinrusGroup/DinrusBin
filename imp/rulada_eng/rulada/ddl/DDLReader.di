/**
	Provides Mango binary Reader support, with a few enhancements
	
	Authors: Eric Anderton
	License: BSD Derivative (see source for details)
	Copyright: 2006 Eric Anderton
*/
module ddl.DDLReader;

private import ddl.Utils;

private import mango.io.Reader;
private import mango.io.Buffer;
private import mango.io.model.IBuffer;
private import mango.io.model.IConduit;

debug private import mango.io.Stdout;

public class DDLReader : Reader{
	public this(void[] data){
		super(new Buffer(data,data.length));
	}
	
	public this (IBuffer buffer){
		super(buffer);
	}
	
	public this (IConduit conduit){
		super(conduit);
	}
		
    public DDLReader peek(inout ubyte x);
    
    public DDLReader peek(inout ubyte[] x,uint elements = uint.max);
    
    //props to Kris for suggesting this method of getting 100% of the remaining data in a conduit
	DDLReader getAll(inout void[] x);
	
	bool hasMore();
	
	// perform a seek relative to the current buffer position and status using the conduit
	// NOTE: this will clear out the current buffer
	void seek(ulong offset, ISeekable.SeekAnchor anchor=ISeekable.SeekAnchor.Begin);
	
	// get the position relative to the current buffer position and status
	ulong getPosition();
	
	// override to provide debug support
	debug (REMOVE) override protected IReader decodeArray (void[]* x, uint bytes, uint width, uint type);
	
	// override to provide debug support
	debug override protected uint read (void *dst, uint bytes, uint type);
}
