// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


/// Interfacing with the system clipboard for copy and paste operations.
module os.win.gui.clipboard;

private import os.win.gui.base, os.win.gui.x.winapi, os.win.gui.data, os.win.gui.x.wincom,
	os.win.gui.x.dlib;


///
class Clipboard // docmain
{
	private this();
	
	
	static:
	
	///
	os.win.gui.data.IDataObject getDataObject();
	
	/// ditto
	void setDataObject(Data obj, bool persist = false);
	/// ditto
	void setDataObject(os.win.gui.data.IDataObject obj, bool persist = false);
	
	
	///
	void setString(Dstring str, bool persist = false);
	
	/// ditto
	Dstring getString();
	
	///
	// ANSI text.
	void setText(ubyte[] ansiText, bool persist = false);
	/// ditto
	ubyte[] getText();
	
	private:
	os.win.gui.x.wincom.IDataObject comd;
	os.win.gui.data.IDataObject dd;
	Object objref; // Prevent dd from being garbage collected!
	
	
	/+
	static ~this()
	{
		Object ddd;
		ddd = cast(Object)dd;
		delete ddd;
	}
	+/
}

