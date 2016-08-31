// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.colordialog;

private import os.win.gui.commondialog, os.win.gui.base, os.win.gui.x.winapi, os.win.gui.x.wincom;
private import os.win.gui.x.utf, os.win.gui.application, os.win.gui.drawing;


///
class ColorDialog: CommonDialog // docmain
{
	this();
	
	
	///
	void allowFullOpen(bool byes) ;
	
	/// ditto
	bool allowFullOpen() ;
	
	
	///
	void anyColor(bool byes) ;
	
	/// ditto
	bool anyColor() ;
	
	///
	void solidColorOnly(bool byes) ;
	/// ditto
	bool solidColorOnly() ;
	
	///
	final void color(Color c) ;
	
	/// ditto
	final Color color() ;
	
	///
	final void customColors(COLORREF[] colors) ;
	
	/// ditto
	final COLORREF[] customColors() ;
	
	///
	void fullOpen(bool byes) ;
	/// ditto
	bool fullOpen() ;
	
	
	///
	void showHelp(bool byes) ;
	/// ditto
	bool showHelp() ;
	
	///
	override DialogResult showDialog();
	
	/// ditto
	override DialogResult showDialog(IWindow owner);
	
	///
	override void reset();
	
	///
	protected override bool runDialog(HWND owner);
	
	
	private BOOL _runDialog(HWND owner);
	
	private:
	const DWORD INIT_FLAGS = CC_ENABLEHOOK;
	
	CHOOSECOLORA cc;
	COLORREF[16] _cust;
	
	
	void _initcust();
}


private extern(Windows) UINT ccHookProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam);

