// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.progressbar;

private import os.win.gui.base, os.win.gui.control, os.win.gui.drawing, os.win.gui.application,
	os.win.gui.event;
private import os.win.gui.x.winapi;


private extern(Windows) void _initProgressbar();


///
class ProgressBar: ControlSuperClass // docmain
{
	this();
	
	///
	final void maximum(int max) ;
	
	/// ditto
	final int maximum() ;
	
	///
	final void minimum(int min);
	
	/// ditto
	final int minimum() ;
	///
	final void step(int stepby) ;
	
	/// ditto
	final int step() ;
	
	///
	final void value(int setval) ;
	
	/// ditto
	final int value() ;
	
	///
	final void increment(int incby);
	
	
	///
	final void performStep();
	
	protected override void onHandleCreated(EventArgs ea);
	
	protected override Size defaultSize() ;
	
	static Color defaultForeColor() ;
	
	protected override void createParams(inout CreateParams cp);
	
	protected override void prevWndProc(inout Message msg);
	
	private:
	
	const int MIN_INIT = 0;
	const int MAX_INIT = 100;
	const int STEP_INIT = 10;
	const int VAL_INIT = 0;
	
	int _min = MIN_INIT, _max = MAX_INIT, _step = STEP_INIT, _val = VAL_INIT;
	
	
	package:
	final:
	LRESULT prevwproc(UINT msg, WPARAM wparam, LPARAM lparam);
}

