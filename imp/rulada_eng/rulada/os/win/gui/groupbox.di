// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.groupbox;

private import os.win.gui.control, os.win.gui.base, os.win.gui.button, os.win.gui.drawing;
private import os.win.gui.x.winapi, os.win.gui.application, os.win.gui.event;


private extern(Windows) void _initButton();


version(NO_DRAG_DROP)
	version = DFL_NO_DRAG_DROP;


///
class GroupBox: ControlSuperClass // docmain
{
	override Rect displayRectangle();
	
	override Size defaultSize();
	
	version(DFL_NO_DRAG_DROP) {} else
	{
		void allowDrop(bool dyes) ;
		alias Control.allowDrop allowDrop; // Overload.
	}
	
	
	this();
	
	protected void onFontChanged(EventArgs ea);
	
	
	protected void onHandleCreated(EventArgs ea);
	
	protected override void createParams(inout CreateParams cp);
	
	protected override void wndProc(inout Message msg);
	
	protected override void onPaintBackground(PaintEventArgs ea);
	
	protected override void prevWndProc(inout Message msg);
	
	private:
	
	const int DEFTEXTHEIGHT_INIT = -1;
	static int _defTextHeight = DEFTEXTHEIGHT_INIT;
	int _textHeight = -1;
	
	
	void _recalcTextHeight(Font f);
	
	
	void _dispChanged();
}

