// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.timer;

private import os.win.gui.x.winapi, os.win.gui.event, os.win.gui.base, os.win.gui.application;


///
class Timer // docmain
{
	//EventHandler tick;
	Event!(Timer, EventArgs) tick; ///
	
	
	///
	void enabled(bool on);
	/// ditto
	bool enabled() ;
	
	
	///
	final void interval(size_t timeout) ;
	
	/// ditto
	final size_t interval() ;
	
	///
	final void start();
	
	/// ditto
	final void stop();
	
	///
	this();
	
	/// ditto
	this(void delegate(Timer) dg);
	/// ditto
	this(void delegate(Object, EventArgs) dg);
	/// ditto
	this(void delegate(Timer, EventArgs) dg);
	
	~this();
	
	protected:
	
	void dispose();
	
	
	///
	void onTick(EventArgs ea);
	
	private:
	DWORD _timeout = 100;
	UINT timerId = 0;
	void delegate(Timer) _dg;
	
	
	void _dgcall(Object sender, EventArgs ea);
}


private:

Timer[UINT] allTimers;


extern(Windows) void timerProc(HWND hwnd, UINT uMsg, UINT idEvent, DWORD dwTime);

