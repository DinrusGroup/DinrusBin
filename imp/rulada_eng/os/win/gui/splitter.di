// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.splitter;

private import os.win.gui.control, os.win.gui.x.winapi, os.win.gui.base, os.win.gui.drawing;
private import os.win.gui.event;


///
class SplitterEventArgs: EventArgs
{
	///
	this(int x, int y, int splitX, int splitY);
	
	///
	final int x() ;
	
	
	///
	final int y();
	
	///
	final void splitX(int val) ;
	
	/// ditto
	final int splitX();
	
	///
	final void splitY(int val);
	
	/// ditto
	final int splitY() ;
	
	private:
	int _x, _y, _splitX, _splitY;
}


///
class Splitter: Control // docmain
{
	this();
	
	
	/+
	override void anchor(AnchorStyles a);
	
	alias Control.anchor anchor; // Overload.
	+/
	
	
	override void dock(DockStyle ds) ;
	
	alias Control.dock dock; // Overload.
	
	
	package void initsplit(int sx, int sy);
	
	
	final void resumeSplit(int sx, int sy) ;
	
	// /// ditto
	final void resumeSplit();
	///
	void movingGrip(bool byes) ;
	
	/// ditto
	bool movingGrip();
	
	deprecated alias movingGrip moveingGrip;
	deprecated alias movingGrip moveGrip;
	deprecated alias movingGrip sizingGrip;
	
	
	protected override void onPaint(PaintEventArgs ea);
	
	protected override void onResize(EventArgs ea);
	
	protected override void onMouseDown(MouseEventArgs mea);
	
	protected override void onMouseMove(MouseEventArgs mea);
	
	
	protected override void onMove(EventArgs ea);
	
	final Control getSplitControl() ;
	
	protected override void onMouseUp(MouseEventArgs mea);
	
	/+
	// Not quite sure how to implement this yet.
	// Might need to scan all controls until one of:
	//    Control with opposite dock (right if left dock): stay -mextra- away from it,
	//    Control with fill dock: that control can't have less than -mextra- width,
	//    Reached end of child controls: stay -mextra- away from the edge.
	
	///
	final void minExtra(int min);
	
	/// ditto
	final int minExtra();
	+/
	
	
	///
	final void minSize(int min) ;
	
	/// ditto
	final int minSize() ;
	
	
	///
	final void splitPosition(int pos) ;
	
	/// ditto
	// -1 if not docked to a control.
	final int splitPosition() ;
	
	//SplitterEventHandler splitterMoved;
	Event!(Splitter, SplitterEventArgs) splitterMoved; ///
	//SplitterEventHandler splitterMoving;
	Event!(Splitter, SplitterEventArgs) splitterMoving; ///
	
	
	protected:
	
	override Size defaultSize() ;
	///
	void onSplitterMoving(SplitterEventArgs sea);
	
	///
	void onSplitterMoved(SplitterEventArgs sea);
	
	private:
	
	bool downing = false;
	bool mgrip = true;
	//Point downpos;
	int downpos;
	int lastpos;
	int msize = 25; // Min size of control that's being sized from the splitter.
	int mextra = 25; // Min size of the control on the opposite side.
	
	static HBRUSH hbrxor;
	
	
	static void inithbrxor();
	
	static void drawxor(HDC hdc, Rect r);
	
	void drawxorClient(HDC hdc, int x, int y);
	
	void drawxorClient(int x, int y, int xold = int.min, int yold = int.min);
}

