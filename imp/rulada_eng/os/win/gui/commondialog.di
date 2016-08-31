// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.commondialog;

private import os.win.gui.control, os.win.gui.x.winapi, os.win.gui.base, os.win.gui.drawing,
	os.win.gui.event;
private import os.win.gui.application;

public import os.win.gui.filedialog, os.win.gui.folderdialog, os.win.gui.colordialog, os.win.gui.fontdialog;


///
abstract class CommonDialog // docmain
{
	///
	abstract void reset();
	
	///
	// Uses currently active window of the application as owner.
	abstract DialogResult showDialog();
	
	/// ditto
	abstract DialogResult showDialog(IWindow owner);
	
	
	///
	Event!(CommonDialog, HelpEventArgs) helpRequest;
	
	
	protected:
	
	///
	// See the CDN_* Windows notification messages.
	LRESULT hookProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam);
	
	// TODO: implement.
	//LRESULT ownerWndProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam)
	
	
	///
	void onHelpRequest(HelpEventArgs ea);
	
	///
	abstract bool runDialog(HWND owner);
	
	
	package final void _cantrun();
}

