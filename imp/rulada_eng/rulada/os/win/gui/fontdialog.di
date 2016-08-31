// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.fontdialog;

private import os.win.gui.base, os.win.gui.commondialog, os.win.gui.x.winapi, os.win.gui.application,
	os.win.gui.control, os.win.gui.drawing, os.win.gui.event, os.win.gui.x.utf,
	os.win.gui.x.dlib;


private extern(Windows)
{
	alias BOOL function(LPCHOOSEFONTW lpcf) ChooseFontWProc;
}


///
class FontDialog: CommonDialog
{
	this();
	
	
	override void reset();
	
	///
	final void allowSimulations(bool byes);
	
	/// ditto
	final bool allowSimulations() ;
	///
	final void allowVectorFonts(bool byes) ;
	/// ditto
	final bool allowVectorFonts();
	
	///
	final void allowVerticalFonts(bool byes);
	/// ditto
	final bool allowVerticalFonts() ;
	
	///
	final void color(Color c) ;
	/// ditto
	final Color color() ;
	
	///
	final void fixedPitchOnly(bool byes);
	/// ditto
	final bool fixedPitchOnly() ;
	
	///
	final void font(Font f) ;
	/// ditto
	final Font font() ;
	
	///
	final void fontMustExist(bool byes);
	/// ditto
	final bool fontMustExist() ;
	
	
	///
	final void maxSize(int max) ;
	/// ditto
	final int maxSize() ;
	///
	final void minSize(int min);
	/// ditto
	final int minSize() ;
	
	///
	final void scriptsOnly(bool byes) ;
	/// ditto
	final bool scriptsOnly() ;
	
	///
	final void showApply(bool byes) ;
	/// ditto
	final bool showApply() ;
	
	///
	final void showHelp(bool byes);
	/// ditto
	final bool showHelp();
	
	///
	final void showEffects(bool byes) ;
	/// ditto
	final bool showEffects() ;
	
	override DialogResult showDialog();
	
	override DialogResult showDialog(IWindow owner);
	
	///
	EventHandler apply;
	
	
	protected override LRESULT hookProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam);
	
	protected override bool runDialog(HWND owner);
	
	private BOOL _runDialog(HWND owner);
	
	private void _update();
	
	///
	protected void onApply(EventArgs ea);
	
	private:
	
	union
	{
		CHOOSEFONTW cfw;
		CHOOSEFONTA cfa;
		alias cfw cf;
		
		static assert(CHOOSEFONTW.sizeof == CHOOSEFONTA.sizeof);
		static assert(CHOOSEFONTW.Flags.offsetof == CHOOSEFONTA.Flags.offsetof);
		static assert(CHOOSEFONTW.nSizeMax.offsetof == CHOOSEFONTA.nSizeMax.offsetof);
	}
	
	union
	{
		LOGFONTW lfw;
		LOGFONTA lfa;
		
		static assert(LOGFONTW.lfFaceName.offsetof == LOGFONTA.lfFaceName.offsetof);
	}
	
	Font _fon;
	
	
	const UINT INIT_FLAGS = CF_EFFECTS | CF_ENABLEHOOK | CF_INITTOLOGFONTSTRUCT | CF_SCREENFONTS;
}


// WM_CHOOSEFONT_SETFLAGS to update flags after dialog creation ... ?


private extern(Windows) UINT fondHookProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam);
