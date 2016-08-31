// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.notifyicon;

private import os.win.gui.x.winapi, os.win.gui.base, os.win.gui.drawing;
private import os.win.gui.control, os.win.gui.form, os.win.gui.application;
private import os.win.gui.event, os.win.gui.x.utf, os.win.gui.x.dlib;

version(DFL_NO_MENUS)
{
}
else
{
	private import os.win.gui.menu;
}


///
class NotifyIcon // docmain
{
	version(DFL_NO_MENUS)
	{
	}
	else
	{
		///
		final void contextMenu(ContextMenu menu) ;
		
		/// ditto
		final ContextMenu contextMenu() ;
	}
	
	
	///
	final void icon(Icon ico) ;
	/// ditto
	final Icon icon() ;
	
	///
	// Must be less than 64 chars.
	// To-do: hold reference to setter's string, use that for getter.. ?
	final void text(Dstring txt);
	
	/// ditto
	final Dstring text();
	
	///
	final void visible(bool byes) ;
	/// ditto
	final bool visible() ;
	
	///
	final void show();
	
	/// ditto
	final void hide();
	
	//EventHandler click;
	Event!(NotifyIcon, EventArgs) click; ///
	//EventHandler doubleClick;
	Event!(NotifyIcon, EventArgs) doubleClick; ///
	//MouseEventHandler mouseDown;
	Event!(NotifyIcon, MouseEventArgs) mouseDown; ///
	//MouseEventHandler mouseUp;
	Event!(NotifyIcon, MouseEventArgs) mouseUp; ///
	//MouseEventHandler mouseMove;
	Event!(NotifyIcon, MouseEventArgs) mouseMove; ///
	
	
	this();
	
	~this();
	
	///
	// Extra.
	void minimize(IWindow win);
	
	///
	// Extra.
	void restore(IWindow win);
	
	private:
	
	NOTIFYICONDATA nid;
	int tipLen = 0;
	version(DFL_NO_MENUS)
	{
	}
	else
	{
		ContextMenu cmenu;
	}
	Icon _icon;
	
	
	package final void _forceAdd();
	
	package final void _forceDelete();
	
	// Returns true if min/restore animation is on.
	static bool _animation();
	
	// Gets the tray area.
	static void _area(out RECT rect);
}


package:


const UINT WM_NOTIFYICON = WM_USER + 34; // -wparam- is id, -lparam- is the mouse message such as WM_LBUTTONDBLCLK.
UINT wmTaskbarCreated;
NotifyIcon[UINT] allNotifyIcons; // Indexed by ID.
UINT lastId = 1;
NotifyIconControl ctrlNotifyIcon;


class NotifyIconControl: Control
{
	override void createHandle();
	
	protected override void wndProc(inout Message msg);
}


static ~this()
{
	// Due to all items not being destructed at program exit,
	// remove all visible notify icons because the OS won't.
	foreach(NotifyIcon ni; allNotifyIcons)
	{
		if(ni.visible)
			ni._forceDelete();
	}
	
	allNotifyIcons = null;
}


UINT allocNotifyIconID();

void _init();
