// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.folderdialog;

private import os.win.gui.x.dlib, std.c;

private import os.win.gui.commondialog, os.win.gui.base, os.win.gui.x.winapi, os.win.gui.x.wincom;
private import os.win.gui.x.utf, os.win.gui.application;


private extern(Windows)
{
	alias LPITEMIDLIST function(LPBROWSEINFOW lpbi) SHBrowseForFolderWProc;
	alias BOOL function(LPCITEMIDLIST pidl, LPWSTR pszPath) SHGetPathFromIDListWProc;
}


///
class FolderBrowserDialog: CommonDialog // docmain
{
	this();
	
	~this();
	
	
	override DialogResult showDialog();
	
	override DialogResult showDialog(IWindow owner);
	
	override void reset();
	
	///
	final void description(Dstring desc) ;
	
	/// ditto
	final Dstring description() ;
	///
	final void selectedPath(Dstring selpath) ;
	
	/// ditto
	final Dstring selectedPath() ;
	
	// ///
	// Currently only works for shell32.dll version 6.0+.
	final void showNewFolderButton(bool byes) ;
	// /// ditto
	final bool showNewFolderButton() ;
	private void _errPathTooLong();
	private void _errNoGetPath();
	
	private void _errNoShMalloc();
	
	protected override bool runDialog(HWND owner);
	
	protected:
	
	/+
	override LRESULT hookProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam);
	+/
	
	
	private:
	
	union
	{
		BROWSEINFOW biw;
		BROWSEINFOA bia;
		alias biw bi;
		
		static assert(BROWSEINFOW.sizeof == BROWSEINFOA.sizeof);
		static assert(BROWSEINFOW.ulFlags.offsetof == BROWSEINFOA.ulFlags.offsetof);
	}
	
	Dstring _desc;
	Dstring _selpath;
	
	
	const UINT INIT_FLAGS = BIF_RETURNONLYFSDIRS | BIF_NEWDIALOGSTYLE;
}


private:

private extern(Windows) int fbdHookProc(HWND hwnd, UINT msg, LPARAM lparam, LPARAM lpData);

