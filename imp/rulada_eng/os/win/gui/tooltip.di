// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.tooltip;


private import os.win.gui.x.dlib, std.c;

private import os.win.gui.control, os.win.gui.base, os.win.gui.application, os.win.gui.x.winapi,
	os.win.gui.x.utf;


///
class ToolTip // docmain
{
	package this(DWORD style);
	
	
	this();
	
	
	~this();
	
	
	///
	final HWND handle() ;
	
	
	///
	final void active(bool byes) ;
	
	/// ditto
	final bool active() ;
	
	///
	// Sets autoPopDelay, initialDelay and reshowDelay.
	final void automaticDelay(DWORD ms) ;
	
	/+
	/// ditto
	final DWORD automaticDelay() ;
	+/
	
	
	///
	final void autoPopDelay(DWORD ms);
	
	/+
	/// ditto
	final DWORD autoPopDelay() ;
	+/
	
	
	///
	final void initialDelay(DWORD ms) ;
	
	/+
	/// ditto
	final DWORD initialDelay() ;
	+/
	
	
	///
	final void reshowDelay(DWORD ms);
	
	/+
	/// ditto
	final DWORD reshowDelay();
	+/
	
	
	///
	final void showAlways(bool byes) ;
	/// ditto
	final bool showAlways();
	
	///
	// Remove all tooltip text associated with this instance.
	final void removeAll();
	
	///
	// WARNING: possible buffer overflow.
	final Dstring getToolTip(Control ctrl);
	
	/// ditto
	final void setToolTip(Control ctrl, Dstring text);
	
	
	private:
	const Dstring _TOOLTIPS_CLASSA = "tooltips_class32";
	const size_t MAX_TIP_TEXT_LENGTH = 2045;
	
	HWND hwtt; // Tooltip control handle.
	bool _active = true;
}

