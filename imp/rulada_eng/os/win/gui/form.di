// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.form;

private import os.win.gui.x.dlib;

private import os.win.gui.control, os.win.gui.x.winapi, os.win.gui.event, os.win.gui.drawing;
private import os.win.gui.application, os.win.gui.base, os.win.gui.x.utf;
private import os.win.gui.collections;

version(DFL_NO_MENUS)
{
}
else
{
	private import os.win.gui.menu;
}

version(NO_DFL_PARK_WINDOW)
{
}
else
{
	version = DFL_PARK_WINDOW;
}


version = DFL_NO_ZOMBIE_FORM;


private extern(Windows) void _initMdiclient();


///
enum FormBorderStyle: ubyte //: BorderStyle
{
	NONE = BorderStyle.NONE, ///
	
	FIXED_3D = BorderStyle.FIXED_3D, /// ditto
	FIXED_SINGLE = BorderStyle.FIXED_SINGLE, /// ditto
	FIXED_DIALOG, /// ditto
	SIZABLE, /// ditto
	FIXED_TOOLWINDOW, /// ditto
	SIZABLE_TOOLWINDOW, /// ditto
}


///
deprecated enum SizeGripStyle: ubyte
{
	AUTO, ///
	HIDE, /// ditto
	SHOW, /// ditto
}


///
enum FormStartPosition: ubyte
{
	CENTER_PARENT, ///
	CENTER_SCREEN, /// ditto
	MANUAL, /// ditto
	DEFAULT_BOUNDS, /// ditto
	WINDOWS_DEFAULT_BOUNDS = DEFAULT_BOUNDS, // deprecated
	DEFAULT_LOCATION, /// ditto
	WINDOWS_DEFAULT_LOCATION = DEFAULT_LOCATION, // deprecated
}


///
enum FormWindowState: ubyte
{
	MAXIMIZED, ///
	MINIMIZED, /// ditto
	NORMAL, /// ditto
}


///
enum MdiLayout: ubyte
{
	ARRANGE_ICONS, ///
	CASCADE, /// ditto
	TILE_HORIZONTAL, /// ditto
	TILE_VERTICAL, /// ditto
}


///
// The Form's shortcut was pressed.
class FormShortcutEventArgs: EventArgs
{
	///
	this(Keys shortcut);
	
	
	///
	final Keys shortcut() ;
	
	private:
	Keys _shortcut;
}


// DMD 0.93 crashes if this is placed in Form.
//private import os.win.gui.button;


version = OLD_MODAL_CLOSE; // New version destroys control info.


///
class Form: ContainerControl, IDialogResult // docmain
{
	///
	final void acceptButton(IButtonControl btn) ;
	
	/// ditto
	final IButtonControl acceptButton() ;
	
	///
	final void cancelButton(IButtonControl btn);
	
	/// ditto
	final IButtonControl cancelButton() ;
	///
	// An exception is thrown if the shortcut was already added.
	final void addShortcut(Keys shortcut, void delegate(Object sender, FormShortcutEventArgs ea) pressed);
	/// ditto
	// Delegate parameter contravariance.
	final void addShortcut(Keys shortcut, void delegate(Object sender, EventArgs ea) pressed);
	/// ditto
	final void removeShortcut(Keys shortcut);
	
	///
	static Form activeForm() ;
	
	///
	final Form getActiveMdiChild() ;
	
	protected override Size defaultSize();
	
	// Note: the following 2 functions aren't completely accurate;
	// it sounds like it should return the center point, but it
	// returns the point that would center the current form.
	
	final Point screenCenter() ;
	
	final Point parentCenter() ;
	
	
	///
	final void centerToScreen();
	///
	final void centerToParent();
	
	protected override void createParams(inout CreateParams cp);
	
	protected override void createHandle();
	/+
	///
	// Focused children are scrolled into view.
	override void autoScroll(bool byes) ;
	/// ditto
	override bool autoScroll() ;
	+/
	
	
	// This only works if the windows version is
	// set to 4.0 or higher.
	
	///
	final void controlBox(bool byes) ;
	
	/// ditto
	final bool controlBox();
	
	///
	final void desktopBounds(Rect r) ;
	
	/// ditto
	final Rect desktopBounds();
	
	///
	final void desktopLocation(Point dp) ;
	
	/// ditto
	final Point desktopLocation() ;
	
	
	///
	final void dialogResult(DialogResult dr) ;
	
	/// ditto
	final DialogResult dialogResult() ;
	
	override Color backColor();
	alias Control.backColor backColor; // Overload.
	
	
	///
	final void formBorderStyle(FormBorderStyle bstyle) ;
	
	/// ditto
	final FormBorderStyle formBorderStyle();
	
	///
	// Ignored if min and max buttons are enabled.
	final void helpButton(bool byes) ;
	/// ditto
	final bool helpButton() ;
	
	private void _setIcon();
	
	///
	final void icon(Icon ico) ;
	/// ditto
	final Icon icon() ;
	
	// TODO: implement.
	// keyPreview
	
	
	///
	final bool isMdiChild() ;
	
	version(NO_MDI)
	{
		private alias Control MdiClient; // ?
	}
	
	///
	// Note: keeping this here for NO_MDI to keep the vtable.
	protected MdiClient createMdiClient();
	
	version(NO_MDI) {} else
	{
		///
		final void isMdiContainer(bool byes) ;
		
		/// ditto
		final bool isMdiContainer() ;
		
		
		///
		final Form[] mdiChildren() ;
		
		// parent is the MDI client and mdiParent is the MDI frame.
		
		
		version(NO_MDI) {} else
		{
			///
			final void mdiParent(Form frm);
		}
		
		/// ditto
		final Form mdiParent();
	}
	
	
	///
	final void maximizeBox(bool byes);
	
	/// ditto
	final bool maximizeBox();
	
	///
	final void minimizeBox(bool byes);
	/// ditto
	final bool minimizeBox();
	
	protected override void onHandleCreated(EventArgs ea);
	
	protected override void onResize(EventArgs ea);
	
	private void _getSizeGripArea(RECT* rect);
	private bool _isPaintingSizeGrip();
	
	protected override void onPaint(PaintEventArgs ea);
	
	version(DFL_NO_MENUS)
	{
	}
	else
	{
		///
		final void menu(MainMenu menu) ;
		/// ditto
		final MainMenu menu() ;
		
		/+
		///
		final MainMenu mergedMenu();
		+/
	}
	
	
	///
	final void minimumSize(Size min);
	
	/// ditto
	final Size minimumSize() ;
	
	///
	final void maximumSize(Size max);
	
	/// ditto
	final Size maximumSize() ;
	
	///
	final bool modal() ;
	///
	// If opacity and transparency are supported.
	static bool supportsOpacity() ;
	
	private static BYTE opacityToAlpha(double opa);
	///
	// 1.0 is 100%, 0.0 is 0%, 0.75 is 75%.
	// Does nothing if not supported.
	final void opacity(double opa) ;
	/// ditto
	final double opacity() ;
	
	/+
	///
	final Form[] ownedForms() ;
	+/
	
	
	// the "old owner" is the current -wowner- or -wmdiparent-.
	// If neither are set, nothing happens.
	private void _removeFromOldOwner();
	
	
	///
	final void owner(Form frm) ;
	
	/// ditto
	final Form owner() ;
	
	///
	// This function does not work in all cases.
	final void showInTaskbar(bool byes) ;
	
	/// ditto
	final bool showInTaskbar();
	
	///
	final void sizingGrip(bool byes) ;
	/// ditto
	final bool sizingGrip();
	deprecated alias sizingGrip sizeGrip;
	
	
	///
	final void startPosition(FormStartPosition startpos);
	
	/// ditto
	final FormStartPosition startPosition();
	
	///
	final void topMost(bool byes);
	
	/// ditto
	final bool topMost() ;
	///
	final void transparencyKey(Color c);
	
	/// ditto
	final Color transparencyKey();
	
	///
	final void windowState(FormWindowState state);
	/// ditto
	final FormWindowState windowState() ;
	
	protected override void setVisibleCore(bool byes);
	
	protected override void onVisibleChanged(EventArgs ea);
	
	///
	final void activate();
	
	
	override void destroyHandle();
	
	///
	final void close();
	
	///
	final void layoutMdi(MdiLayout lay);
	
	///
	final void setDesktopBounds(int x, int y, int width, int height);
	
	///
	final void setDesktopLocation(int x, int y);
	
	
	///
	final DialogResult showDialog();
	
	/// ditto
	final DialogResult showDialog(IWindow iwsowner);
	
	// Used internally.
	package final void showDialog2();
	
	version(DFL_NO_ZOMBIE_FORM)
	{
	}
	else
	{
		package final bool nozombie();
	}
	
	
	//EventHandler activated;
	Event!(Form, EventArgs) activated; ///
	//EventHandler deactivate;
	Event!(Form, EventArgs) deactivate; ///
	//EventHandler closed;
	Event!(Form, EventArgs) closed; ///
	//CancelEventHandler closing;
	Event!(Form, CancelEventArgs) closing; ///
	//EventHandler load;
	Event!(Form, EventArgs) load; ///
	
	
	///
	protected void onActivated(EventArgs ea);
	
	///
	protected void onDeactivate(EventArgs ea);
	
	/+
	///
	protected void onInputLanguageChanged(InputLanguageChangedEventArgs ilcea);
	
	///
	protected void onInputLanguageChanging(InputLanguageChangingEventArgs ilcea);
	+/
	
	
	///
	protected void onLoad(EventArgs ea);
	
	private void _init();
	this();
	
	/+
	// Used internally.
	this(HWND hwnd);
	+/
	
	
	protected override void wndProc(inout Message msg);
	
	package final void _setSystemMenu();
	
	package final void _resetSystemMenu();
	
	
	/+ package +/ void _destroying() ;
	
	/+ package +/ /+ protected +/ int _rtype() ;
	
	
	package BOOL _isNonMdiChild(HWND hw);
	
	
	package HWND _lastSelBtn; // Last selected button (not necessarily focused), excluding accept button!
	package HWND _lastSel; // Last senected and focused control.
	package HWND _hadfocus; // Before being deactivated.
	
	
	// Returns if there was a selection.
	package final bool _selbefore();
	
	package final void _selafter(Control ctrl, bool wasselbtn);
	package final void _seldeactivate();
	package final void _selactivate();
	// Child can be nested at any level.
	package final void _selectChild(Control ctrl);
	package final void _selectChild(HWND hw);
	private void _selonecontrol();
	
	package alias os.win.gui.x.utf.defDlgProc _defFormProc;
	
	protected override void defWndProc(inout Message msg);
	
	protected:
	
	///
	void onClosing(CancelEventArgs cea);
	
	///
	void onClosed(EventArgs ea);
	
	override void setClientSizeCore(int width, int height);
	
	protected override void setBoundsCore(int x, int y, int width, int height, BoundsSpecified specified);
	// Must be called before handle creation.
	protected final void noMessageFilter() ;
	
	version(NO_MDI) {} else
	{
		protected final MdiClient mdiClient() ;
	}
	
	
	private:
	IButtonControl acceptBtn, cancelBtn;
	bool autoscale = true;
	Size autoscaleBase;
	DialogResult fresult = DialogResult.NONE;
	Icon wicon, wiconSm;
	version(DFL_NO_MENUS)
	{
	}
	else
	{
		MainMenu wmenu;
	}
	Size minsz, maxsz; // {0, 0} means none.
	bool wmodal = false;
	bool sownerEnabled;
	HWND sowner;
	double opa = 1.0; // Opacity.
	Color transKey;
	bool grip = false;
	FormStartPosition startpos = FormStartPosition.DEFAULT_LOCATION;
	//FormMessageFilter mfilter;
	const FormMessageFilter mfilter;
	bool _loaded = false;
	void delegate(Object sender, FormShortcutEventArgs ea)[Keys] _shortcuts;
	Form[] _owned, _mdiChildren; // Always set because they can be created and destroyed at any time.
	Form wowner = null, wmdiparent = null;
	//bool _closingvisible;
	bool nofilter = false;
	
	version(NO_MDI) {} else
	{
		MdiClient _mdiClient = null; // null == not MDI container.
	}
	
	
	package static bool wantsAllKeys(HWND hwnd);
	
	private static class FormMessageFilter: IMessageFilter
	{
		protected bool preFilterMessage(inout Message m);
		
		this(Form form);
		
		private:
		Form form;
	}
	
	
	/+
	package final bool _dlgescape();
	+/
	
	
	final void _recalcClientSize();
}


version(NO_MDI) {} else
{
	///
	class MdiClient: ControlSuperClass
	{
		private this();
		
		
		///
		void borderStyle(BorderStyle bs);
		/// ditto
		BorderStyle borderStyle();
		
		///
		final void hScroll(bool byes);

		/// ditto
		final bool hScroll();


		///
		final void vScroll(bool byes);
		
		/+
		override void createHandle();
		+/
		
		
		protected override void createParams(inout CreateParams cp);
		
		
		static Color defaultBackColor() ;
		
		override Color backColor();
		
		alias Control.backColor backColor; // Overload.
		
		
		/+
		static Color defaultForeColor();
		+/
		
		
		protected override void prevWndProc(inout Message msg);
		
		
		private:
		CLIENTCREATESTRUCT ccs;
	}
}


private:

version(DFL_PARK_WINDOW)
{
	HWND getParkHwnd();
	
	void _makePark();
	
	
	const Dstring PARK_CLASSNAME = "DFL_Parking";
	
	HWND _hwPark; // Don't use directly; use getParkHwnd().
}

