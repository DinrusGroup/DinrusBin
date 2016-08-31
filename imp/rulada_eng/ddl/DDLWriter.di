/**
	Provides Mango binary Writer support, with a few enhancements
	
	Authors: Eric Anderton
	License: BSD Derivative (see source for details)
	Copyright: 2006 Eric Anderton
*/
module ddl.DDLWriter;

private import mango.io.Writer;
private import mango.io.model.IBuffer;
private import mango.io.model.IConduit;

public class DDLWriter : Writer{
	public this (IBuffer buffer){
		super(buffer);
	}
	
	public this (IConduit conduit){
		super(conduit);
	}
	
	// perform a seek relative to the current buffer position and status using the conduit
	// NOTE: this will flush the current buffer's contents
	void seek(ulong offset, ISeekable.SeekAnchor anchor=ISeekable.SeekAnchor.Begin);
	// get the position relative to the current buffer position and status
	ulong getPosition();	
}
