// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.label;

private import os.win.gui.base, os.win.gui.control, os.win.gui.x.winapi, os.win.gui.application,
	os.win.gui.event, os.win.gui.drawing, os.win.gui.x.dlib;


///
class Label: Control // docmain
{
	this();
	
	
	///
	void borderStyle(BorderStyle bs) ;
	
	/// ditto
	BorderStyle borderStyle();
	
	///
	final void useMnemonic(bool byes) ;
	
	/// ditto
	final bool useMnemonic() ;
	
	///
	Size preferredSize();
	
	private void doAutoSize(Dstring text);
	
	override void text(Dstring newText) ;
	alias Control.text text; // Overload.
	
	
	///
	void autoSize(bool byes) ;
	
	/// ditto
	bool autoSize() ;
	
	///
	void textAlign(ContentAlignment calign) ;
	/// ditto
	ContentAlignment textAlign() ;
	
	protected override Size defaultSize() ;
	
	
	protected override void onPaint(PaintEventArgs ea);
	
	/+
	protected override void onHandleCreated(EventArgs ea);
	+/
	
	
	protected override void onEnabledChanged(EventArgs ea);
	
	protected override void onFontChanged(EventArgs ea);
	protected override void wndProc(inout Message m);
	
	
	protected override bool processMnemonic(dchar charCode);
	
	private:
	TextFormat _tfmt;
	bool autosz = false;
	
	
	final void tfmt(TextFormat tf);
	
	final TextFormat tfmt() ;
}


version(LABEL_GRAYSTRING)
{
	private extern(Windows) BOOL _disabledOutputProc(HDC hdc, LPARAM lpData, int cchData);
}

