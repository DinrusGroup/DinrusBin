// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.control;

private import os.win.gui.x.dlib, std.c;
	
private import os.win.gui.base, os.win.gui.form, os.win.gui.drawing;
private import os.win.gui.x.winapi, os.win.gui.application, os.win.gui.event, os.win.gui.label;
private import os.win.gui.x.wincom, os.win.gui.x.utf, os.win.gui.collections, os.win.gui.x.com;

alias std.c.printf cprintf;

version(NO_DRAG_DROP)
	version = DFL_NO_DRAG_DROP;

version(DFL_NO_DRAG_DROP)
{
}
else
{
	private import os.win.gui.data;
}

version(DFL_NO_MENUS)
{
}
else
{
	private import os.win.gui.menu;
}

//version = RADIO_GROUP_LAYOUT;
version = DFL_NO_ZOMBIE_FORM;


///
enum AnchorStyles: ubyte
{
	NONE = 0, ///
	TOP = 1, /// ditto
	BOTTOM = 2, /// ditto
	LEFT = 4, /// ditto
	RIGHT = 8, /// ditto
	
	/+
	// Extras:
	VERTICAL = TOP | BOTTOM,
	HORIZONTAL = LEFT | RIGHT,
	ALL = TOP | BOTTOM | LEFT | RIGHT,
	DEFAULT = TOP | LEFT,
	TOP_LEFT = TOP | LEFT,
	TOP_RIGHT = TOP | RIGHT,
	BOTTOM_LEFT = BOTTOM | LEFT,
	BOTTOM_RIGHT = BOTTOM | RIGHT,
	+/
}


/// Flags for setting control bounds.
enum BoundsSpecified: ubyte
{
	NONE = 0, ///
	X = 1, /// ditto
	Y = 2, /// ditto
	LOCATION = 1 | 2, /// ditto
	WIDTH = 4, /// ditto
	HEIGHT = 8, /// ditto
	SIZE = 4 | 8, /// ditto
	ALL = 1 | 2 | 4 | 8, /// ditto
}


/// Layout docking style.
enum DockStyle: ubyte
{
	NONE, ///
	BOTTOM, ///
	FILL, ///
	LEFT, ///
	RIGHT, ///
	TOP, ///
}


private
{
	struct GetZIndex
	{
		Control find;
		int index = -1;
		private int _tmp = 0;
	}
	
	
	extern(Windows) BOOL getZIndexCallback(HWND hwnd, LPARAM lparam);
}


/// Effect flags for drag/drop operations.
enum DragDropEffects: DWORD
{
	NONE = 0, ///
	COPY = 1, /// ditto
	MOVE = 2, /// ditto
	LINK = 4, /// ditto
	SCROLL = 0x80000000, /// ditto
	ALL = COPY | MOVE | LINK | SCROLL, /// ditto
}


/// Drag/drop action.
enum DragAction: HRESULT
{
	CONTINUE = S_OK, ///
	CANCEL = DRAGDROP_S_CANCEL, /// ditto
	DROP = DRAGDROP_S_DROP, /// ditto
}


// Flags.
deprecated enum UICues: uint
{
	NONE = 0,
	SHOW_FOCUS = 1,
	SHOW_KEYBOARD = 2,
	SHOWN = SHOW_FOCUS | SHOW_KEYBOARD,
	CHANGE_FOCUS = 4,
	CHANGE_KEYBOARD = 8, // Key mnemonic underline cues are on.
	CHANGED = CHANGE_FOCUS | CHANGE_KEYBOARD,
}


// May be OR'ed together.
/// Style flags of a control.
enum ControlStyles: uint
{
	NONE = 0, ///
	
	CONTAINER_CONTROL =                0x1, /// ditto
	
	// TODO: implement.
	USER_PAINT =                       0x2, /// ditto
	
	OPAQUE =                           0x4, /// ditto
	RESIZE_REDRAW =                    0x10, /// ditto
	//FIXED_WIDTH =                      0x20, // TODO: implement.
	//FIXED_HEIGHT =                     0x40, // TODO: implement.
	STANDARD_CLICK =                   0x100, /// ditto
	SELECTABLE =                       0x200, /// ditto
	
	// TODO: implement.
	USER_MOUSE =                       0x400, ///  ditto
	
	//SUPPORTS_TRANSPARENT_BACK_COLOR =  0x800, // Only if USER_PAINT and parent is derived from Control. TODO: implement.
	STANDARD_DOUBLE_CLICK =            0x1000, /// ditto
	ALL_PAINTING_IN_WM_PAINT =         0x2000, /// ditto
	CACHE_TEXT =                       0x4000, /// ditto
	ENABLE_NOTIFY_MESSAGE =            0x8000, // deprecated. Calls onNotifyMessage() for every message.
	//DOUBLE_BUFFER =                    0x10000, // TODO: implement.
	
	WANT_TAB_KEY = 0x01000000,
	WANT_ALL_KEYS = 0x02000000,
}


/// Control creation parameters.
struct CreateParams
{
	Dstring className; ///
	Dstring caption; /// ditto
	void* param; /// ditto
	HWND parent; /// ditto
	HMENU menu; /// ditto
	HINSTANCE inst; /// ditto
	int x; /// ditto
	int y; /// ditto
	int width; /// ditto
	int height; /// ditto
	DWORD classStyle; /// ditto
	DWORD exStyle; /// ditto
	DWORD style; /// ditto
}


deprecated class UICuesEventArgs: EventArgs
{
	deprecated:
	
	this(UICues uic);
	
	final UICues changed() ;
	
	final bool changeFocus();
	
	
	final bool changeKeyboard();
	
	
	final bool showFocus();
	
	final bool showKeyboard();
	
	private:
	UICues chg;
}


///
class ControlEventArgs: EventArgs
{
	///
	this(Control ctrl);
	
	
	///
	final Control control();
	
	private:
	Control ctrl;
}


///
class HelpEventArgs: EventArgs
{
	///
	this(Point mousePos);
	
	///
	final void handled(bool byes) ;
	/// ditto
	final bool handled() ;
	
	///
	final Point mousePos() ;
	
	private:
	Point mpos;
	bool hand = false;
}


///
class InvalidateEventArgs: EventArgs
{
	///
	this(Rect invalidRect);
	
	///
	final Rect invalidRect() ;
	
	private:
	Rect ir;
}


// ///
// New dimensions before resizing.
deprecated class BeforeResizeEventArgs: EventArgs
{
	deprecated:
	
	///
	this(int width, int height);
	
	///
	void width(int cx) ;
	
	/// ditto
	int width() ;
	///
	void height(int cy) ;
	/// ditto
	int height() ;
	
	private:
	int w, h;
}


///
class LayoutEventArgs: EventArgs
{
	///
	this(Control affectedControl);
	
	
	///
	final Control affectedControl() ;
	
	private:
	Control ac;
}


version(DFL_NO_DRAG_DROP) {} else
{
	///
	class DragEventArgs: EventArgs
	{
		///
		this(os.win.gui.data.IDataObject dataObj, int keyState, int x, int y,
			DragDropEffects allowedEffect, DragDropEffects effect);
		
		
		///
		final DragDropEffects allowedEffect() ;
		
		///
		final void effect(DragDropEffects newEffect) ;
		
		/// ditto
		final DragDropEffects effect() ;
		
		///
		final os.win.gui.data.IDataObject data() ;
		
		///
		// State of ctrl, alt, shift, and mouse buttons.
		final int keyState() ;
		
		///
		final int x() ;
		
		///
		final int y() ;
		
		private:
		os.win.gui.data.IDataObject _dobj;
		int _keyState;
		int _x, _y;
		DragDropEffects _allowedEffect, _effect;
	}
	
	
	///
	class GiveFeedbackEventArgs: EventArgs
	{
		///
		this(DragDropEffects effect, bool useDefaultCursors);
		
		
		///
		final DragDropEffects effect() ;
		
		///
		final void useDefaultCursors(bool byes);
		/// ditto
		final bool useDefaultCursors() ;
		
		private:
		DragDropEffects _effect;
		bool udefcurs;
	}
	
	
	///
	class QueryContinueDragEventArgs: EventArgs
	{
		///
		this(int keyState, bool escapePressed, DragAction action);
		
		///
		final void action(DragAction newAction) ;
		
		/// ditto
		final DragAction action() ;
		
		
		///
		final bool escapePressed() ;
		///
		// State of ctrl, alt and shift.
		final int keyState() ;
		
		
		private:
		int _keyState;
		bool escp;
		DragAction _action;
	}
}


version(NO_WINDOWS_HUNG_WORKAROUND)
{
}
else
{
	version = WINDOWS_HUNG_WORKAROUND;
}
debug
{
	version=_DFL_WINDOWS_HUNG_WORKAROUND;
}
version(WINDOWS_HUNG_WORKAROUND)
{
	version=_DFL_WINDOWS_HUNG_WORKAROUND;
}

version(_DFL_WINDOWS_HUNG_WORKAROUND)
{
	class WindowsHungDflException: DflException
	{
		this(Dstring msg);
	}
}


package alias BOOL delegate(HWND) EnumWindowsCallback;


// Callback for EnumWindows() and EnumChildWindows().
private extern(Windows) BOOL enumingWindows(HWND hwnd, LPARAM lparam);

private struct Efi
{
	HWND hwParent;
	EnumWindowsCallback dg;
}


// Callback for EnumChildWindows(). -lparam- = pointer to Efi;
private extern(Windows) BOOL enumingFirstWindows(HWND hwnd, LPARAM lparam);

package BOOL enumWindows(EnumWindowsCallback dg);

package BOOL enumChildWindows(HWND hwParent, EnumWindowsCallback dg);
// Only the parent's children, not its children.
package BOOL enumFirstChildWindows(HWND hwParent, EnumWindowsCallback dg);
///
enum ControlFont: ubyte
{
	COMPATIBLE, ///
	OLD, /// ditto
	NATIVE, /// ditto
}


debug
{
	version(Tango)
	{
	}
	else
	{
		import std.string;
	}
}


/// Control class.
class Control: DObject, IWindow // docmain
{
	///
	static class ControlCollection
	{
		protected this(Control owner);
		
		deprecated alias length count;
		
		///
		int length();	
		
		///
		Control opIndex(int i) ;		
		///
		void add(Control ctrl);		
		///
		// opIn ?
		bool contains(Control ctrl);		
		///
		int indexOf(Control ctrl);
		
		///
		void remove(Control ctrl);
		
		private void _removeCreated(HWND hwnd);
		
		package void _removeNotCreated(int i);
		
		///
		void removeAt(int i);
		
		protected final Control owner();
		
		///
		int opApply(int delegate(inout Control) dg);
		mixin OpApplyAddIndex!(opApply, Control);
		
		
		package:
		Control _owner;
		Control[] children; // Only valid if -owner- isn't created yet (or is recreating).
		
		
		/+
		final void _array_swap(int ifrom, int ito);
		+/
		
		
		final void _simple_front_one(int i);
		
		final void _simple_front_one(Control c);
		
		final void _simple_back_one(int i);
		
		final void _simple_back_one(Control c);
		final void _simple_back(int i);
		
		final void _simple_back(Control c);
		final void _simple_front(int i);
		
		
		final void _simple_front(Control c);
	}
	
	
	private void _ctrladded(ControlEventArgs cea);
	
	private void _ctrlremoved(ControlEventArgs cea);
	
	///
	protected void onControlAdded(ControlEventArgs cea);
	///
	protected void onControlRemoved(ControlEventArgs cea);
	
	///
	final HWindow handle() ;
	
	version(DFL_NO_DRAG_DROP) {} else
	{
		///
		void allowDrop(bool byes) ;
		/// ditto
		bool allowDrop() ;
	}
	
	
	/+
	deprecated void anchor(AnchorStyles a);
	
	
	deprecated AnchorStyles anchor() ;
	+/
	
	
	private void _propagateBackColorAmbience();
	
	///
	protected void onBackColorChanged(EventArgs ea);
	
	///
	void backColor(Color c) ;
	
	/// ditto
	Color backColor();
	///
	final int bottom() ;
	
	///
	final void bounds(Rect r) ;
	
	/// ditto
	final Rect bounds() ;
	
	/+
	final Rect originalBounds() ;
	+/
	
	
	///
	protected void setBoundsCore(int x, int y, int width, int height, BoundsSpecified specified);
	///
	final bool canFocus();
	///
	final bool canSelect() ;
	
	package final bool _hasSelStyle();
	
	///
	// Returns true if this control has the mouse capture.
	final bool capture() ;
	/// ditto
	final void capture(bool cyes);
	
	// When true, validating and validated events are fired when the control
	// receives focus. Typically set to false for controls such as a Help button.
	// Default is true.
	deprecated final bool causesValidation();
	
	
	deprecated protected void onCausesValidationChanged(EventArgs ea);
	
	deprecated final void causesValidation(bool vyes);
	
	
	///
	final Rect clientRectangle() ;
	
	///
	final bool contains(Control ctrl);
	
	///
	final Size clientSize() ;
	
	/// ditto
	final void clientSize(Size sz) ;
	
	///
	protected void setClientSizeCore(int width, int height);
	///
	// This window or one of its children has focus.
	final bool containsFocus() ;
	
	version(DFL_NO_MENUS)
	{
	}
	else
	{
		///
		protected void onContextMenuChanged(EventArgs ea);
		
		
		///
		void contextMenu(ContextMenu menu);
		/// ditto
		ContextMenu contextMenu();
	}
	
	
	///
	final ControlCollection controls() ;
	
	///
	final bool created() ;
	
	private void _propagateCursorAmbience();
	
	
	///
	protected void onCursorChanged(EventArgs ea);
	
	///
	void cursor(Cursor cur) ;
	
	/// ditto
	Cursor cursor();
	
	///
	static Color defaultBackColor() ;
	
	///
	static Color defaultForeColor();
	
	private static Font _deffont = null;
	
	
	private static Font _createOldFont();
	
	private static Font _createCompatibleFont();
	
	
	private static Font _createNativeFont();
	
	
	private static void _setDeffont(ControlFont cf);
	
	
	deprecated alias defaultFont controlFont;
	
	///
	static void defaultFont(ControlFont cf) ;
	/// ditto
	static void defaultFont(Font f) ;
	
	/// ditto
	static Font defaultFont() ;
	
	
	package static class SafeCursor: Cursor
	{
		this(HCURSOR hcur);
		
		override void dispose();
		
		/+
		~this();
		+/
	}
	
	
	package static Cursor _defaultCursor();
	
	///
	Rect displayRectangle() ;
	///
	//protected void onDockChanged(EventArgs ea)
	protected void onHasLayoutChanged(EventArgs ea);
	
	alias onHasLayoutChanged onDockChanged;
	
	
	private final void _alreadyLayout();	
	///
	DockStyle dock() ;
	
	/// ditto
	void dock(DockStyle ds) ;
	
	/// Get or set whether or not this control currently has its bounds managed. Fires onHasLayoutChanged as needed.
	final bool hasLayout() ;
	
	/// ditto
	final void hasLayout(bool byes) ;
	
	package final void _venabled(bool byes);	
	
	///
	final void enabled(bool byes) ;
	
	///
	final bool enabled();	
	
	private void _propagateEnabledAmbience();	
	
	///
	final void enable();
	
	/// ditto
	final void disable();
	
	///
	bool focused() ;
	
	///
	void font(Font f) ;
	
	/// ditto
	Font font() ;
	
	private void _propagateForeColorAmbience();
	
	
	///
	protected void onForeColorChanged(EventArgs ea);
	
	///
	void foreColor(Color c) ;
	
	/// ditto
	Color foreColor() ;
	
	///
	// Doesn't cause a ControlCollection to be constructed so
	// it could improve performance when walking through children.
	final bool hasChildren();
	
	///
	final void height(int h) ;
	
	/// ditto
	final int height() ;
	
	///
	final bool isHandleCreated() ;
	
	///
	final void left(int l) ;
	/// ditto
	final int left() ;
	
	/// Property: get or set the X and Y location of the control.
	final void location(Point pt) ;
	/// ditto
	final Point location() ;
	
	/// Currently depressed modifier keys.
	static Keys modifierKeys();
	/// Currently depressed mouse buttons.
	static MouseButtons mouseButtons();
	
	
	///
	static Point mousePosition() ;
	
	/// Property: get or set the name of this control used in code.
	final void name(Dstring txt) ;
	/// ditto
	final Dstring name();
	
	///
	protected void onParentChanged(EventArgs ea);
	/+
	///
	// ea is the new parent.
	protected void onParentChanging(ControlEventArgs ea);
	+/
	
	
	///
	final Form findForm();
	
	
	///
	final void parent(Control c);
	/// ditto
	final Control parent() ;
	
	
	private final Control _fetchParent();
	
	// TODO: check implementation.
	private static HRGN dupHrgn(HRGN hrgn);
	
	///
	final void region(Region rgn) ;
	/// ditto
	final Region region() ;
	
	private final Region _fetchRegion();
	///
	final int right() ;
	
	/+
	void rightToLeft(bool byes);
	
	bool rightToLeft() ;
	+/
	
	
	deprecated void rightToLeft(bool byes) ;
	
	
	package final void _fixRtol(RightToLeft val);
	
	private void _propagateRtolAmbience();
	
	
	///
	void rightToLeft(RightToLeft val);
	
	/// ditto
	// Returns YES or NO; if inherited, returns parent's setting.
	RightToLeft rightToLeft() ;
	
	package struct _FixAmbientOld
	{
		Font font;
		Cursor cursor;
		Color backColor;
		Color foreColor;
		RightToLeft rightToLeft;
		//CBits cbits;
		bool enabled;
		
		
		void set(Control ctrl);
	}
	
	
	// This is called when the inherited ambience changes.
	package final void _fixAmbient(_FixAmbientOld* oldinfo);
	
	/+
	package final void _fixAmbientChildren();
	+/
	
	
	///
	final void size(Size sz) ;
	
	/// ditto
	final Size size() ;
	
	/+
	final void tabIndex(int i) ;
	
	
	final int tabIndex() ;
	+/
	
	
	// Use -zIndex- instead.
	// -tabIndex- may return different values in the future.
	deprecated int tabIndex() ;
	
	
	///
	final int zIndex() ;
	
	
	///
	// True if control can be tabbed to.
	final void tabStop(bool byes) ;
	
	/// ditto
	final bool tabStop() ;
	
	/// Property: get or set additional data tagged onto the control.
	final void tag(Object o) ;
	
	/// ditto
	final Object tag() ;
	
	
	private final Dstring _fetchText();
	
	///
	void text(Dstring txt) ;
	
	/// ditto
	Dstring text() ;
	
	///
	final void top(int t) ;
	/// ditto
	final int top() ;
	
	/// Returns the topmost Control related to this control.
	// Returns the owner control that has no parent.
	// Returns this Control if no owner ?
	final Control topLevelControl();
	
	/+
	private DWORD _fetchVisible();
	+/
	
	
	///
	final void visible(bool byes) ;
	
	/// ditto
	final bool visible() ;
	
	///
	final void width(int w) ;
	
	/// ditto
	final int width() ;
	
	///
	final void sendToBack();
	
	
	///
	final void bringToFront();
	
	deprecated alias bringUpOne zIndexUp;
	
	///
	// Move up one.
	final void bringUpOne();
	
	deprecated alias sendBackOne zIndexDown;
	
	///
	// Move back one.
	final void sendBackOne();
	
	
	// Note: true if no children, even if this not created.
	package final bool areChildrenCreated();
	
	package final void createChildren();
	
	
	///
	// Force creation of the window and its child controls.
	final void createControl();
	
	/// Returns a new Graphics object for this control, creating the control handle if necessary.
	final Graphics createGraphics();
	
	version(DFL_NO_DRAG_DROP) {} else
	{
		private static class DropTarget: DflComObject, IDropTarget
		{
			this(Control ctrl);
			
			
			extern(Windows):
			override HRESULT QueryInterface(IID* riid, void** ppv);
			
			HRESULT DragEnter(os.win.gui.x.wincom.IDataObject pDataObject, DWORD grfKeyState, POINTL pt, DWORD *pdwEffect);
			
			HRESULT DragOver(DWORD grfKeyState, POINTL pt, DWORD *pdwEffect);
			
			HRESULT DragLeave();
			
			
			HRESULT Drop(os.win.gui.x.wincom.IDataObject pDataObject, DWORD grfKeyState, POINTL pt, DWORD *pdwEffect);
			
			
			private:
			
			Control ctrl;
			//os.win.gui.data.IDataObject dataObj;
			ComToDdataObject dataObj;
			
			
			void ensureDataObj(os.win.gui.x.wincom.IDataObject pDataObject);
			
			
			void killDataObj();
		}
		
		
		///
		protected void onDragLeave(EventArgs ea);
		
		///
		protected void onDragEnter(DragEventArgs ea);
		
		///
		protected void onDragOver(DragEventArgs ea);
		
		///
		protected void onDragDrop(DragEventArgs ea);
		
		private static class DropSource: DflComObject, IDropSource
		{
			this(Control ctrl);
			
			
			extern(Windows):
			override HRESULT QueryInterface(IID* riid, void** ppv);
			
			HRESULT QueryContinueDrag(BOOL fEscapePressed, DWORD grfKeyState);
			
			
			HRESULT GiveFeedback(DWORD dwEffect);
			
			private:
			Control ctrl;
			MouseButtons mbtns;
		}
		
		
		///
		protected void onQueryContinueDrag(QueryContinueDragEventArgs ea);
		
		///
		protected void onGiveFeedback(GiveFeedbackEventArgs ea);
		
		
		/// Perform a drag/drop operation.
		final DragDropEffects doDragDrop(os.win.gui.data.IDataObject dataObj, DragDropEffects allowedEffects);
		/// ditto
		final DragDropEffects doDragDrop(Data obj, DragDropEffects allowedEffects);
	}
	
	
	override Dequ opEquals(Object o);
	
	
	Dequ opEquals(Control ctrl);
	
	override int opCmp(Object o);
	
	int opCmp(Control ctrl);
	
	///
	final bool focus();
	
	/// Returns the Control instance from one of its window handles, or null if none.
	// Finds controls that own more than one handle.
	// A combo box has several HWNDs, this would return the
	// correct combo box control if any of those handles are
	// provided.
	static Control fromChildHandle(HWND hwChild);
	
	
	/// Returns the Control instance from its window handle, or null if none.
	static Control fromHandle(HWND hw);
	///
	final Control getChildAtPoint(Point pt);
	
	///
	final void hide();
	/// ditto
	final void show();
	
	package final void redrawEntire();
	
	
	package final void recalcEntire();
	///
	final void invalidate();
	/// ditto
	final void invalidate(bool andChildren);
	/// ditto
	final void invalidate(Rect r);
	/// ditto
	final void invalidate(Rect r, bool andChildren);
	
	/// ditto
	final void invalidate(Region rgn);
	/// ditto
	final void invalidate(Region rgn, bool andChildren);
	
	///
	// Redraws the entire control, including nonclient area.
	final void redraw();
	
	/// Returns true if the window does not belong to the current thread.
	bool invokeRequired() ;
	
	private static void badInvokeHandle();
	
	/// Synchronously calls a delegate in this Control's thread. This function is thread safe and exceptions are propagated to the caller.
	// Exceptions are propagated back to the caller of invoke().
	final Object invoke(Object delegate(Object[]) dg, Object[] args ...);
	
	/// ditto
	final void invoke(void delegate() dg);
	
	
	/** Asynchronously calls a function after the window message queue processes its current messages.
	    It is generally not safe to pass references to the delayed function.
	    Exceptions are not propagated to the caller.
	**/
	// Extra.
	// Exceptions will be passed to Application.onThreadException() and
	// trigger the threadException event or the default exception dialog.
	final void delayInvoke(void function() fn);
	/// ditto
	// Extra.
	// Exceptions will be passed to Application.onThreadException() and
	// trigger the threadException event or the default exception dialog.
	// Copy of params are passed to fn, they do not exist after it returns.
	// It is unsafe to pass references to a delayed function.
	final void delayInvoke(void function(Control, size_t[]) fn, size_t[] params ...);
	
	deprecated alias delayInvoke beginInvoke;
	
	
	///
	static bool isMnemonic(dchar charCode, Dstring text);
	
	/// Converts a screen Point to a client Point.
	final Point pointToClient(Point pt);
	
	/// Converts a client Point to a screen Point.
	final Point pointToScreen(Point pt);
	
	/// Converts a screen Rectangle to a client Rectangle.
	final Rect rectangleToClient(Rect r);
	
	/// Converts a client Rectangle to a screen Rectangle.
	final Rect rectangleToScreen(Rect r);
	
	///
	// Return true if processed.
	bool preProcessMessage(inout Message msg);
	
	///
	final Size getAutoScaleSize(Font f);
	
	/// ditto
	final Size getAutoScaleSize();
	///
	void refresh();
	///
	void resetBackColor();
	
	///
	void resetCursor();
	
	
	///
	void resetFont();
	///
	void resetForeColor();
	
	///
	void resetRightToLeft();
	
	
	///
	void resetText();
	
	///
	// Just allow layout recalc, but don't do it right now.
	final void resumeLayout();
	/// ditto
	// Allow layout recalc, only do it now if -byes- is true.
	final void resumeLayout(bool byes);
	
	
	///
	final void suspendLayout();
	
	final void performLayout(Control affectedControl);
	
	final void performLayout();
	
	/+
	// TODO: implement.
	
	// Scale both height and width to -ratio-.
	final void scale(float ratio);
	
	// Scale -width- and -height- ratios.
	final void scale(float width, float height);
	// Also scales child controls recursively.
	protected void scaleCore(float width, float height);
	+/
	
	
	private static bool _eachild(HWND hw, bool delegate(HWND hw) callback, inout size_t xiter, bool nested);
	
	package static void eachGoodChildHandle(HWND hwparent, bool delegate(HWND hw) callback, bool nested = true);
	
	private static bool _isHwndControlSel(HWND hw);
	
	
	package static void _dlgselnext(Form dlg, HWND hwcursel, bool forward,
		bool tabStopOnly = true, bool selectableOnly = false,
		bool nested = true, bool wrap = true,
		HWND hwchildrenof = null);
		
	package final void _selectNextControl(Form ctrltoplevel,
		Control ctrl, bool forward, bool tabStopOnly, bool nested, bool wrap);
	
	package final void _selectThisControl();
	
	
	// Only considers child controls of this control.
	final void selectNextControl(Control ctrl, bool forward, bool tabStopOnly, bool nested, bool wrap);
	
	///
	final void select();
	
	/// ditto
	// If -directed- is true, -forward- is used; otherwise, selects this control.
	// If -forward- is true, the next control in the tab order is selected,
	// otherwise the previous control in the tab order is selected.
	// Controls without style ControlStyles.SELECTABLE are skipped.
	void select(bool directed, bool forward);
	
	///
	final void setBounds(int x, int y, int width, int height);
	
	/// ditto
	final void setBounds(int x, int y, int width, int height, BoundsSpecified specified);
	
	
	override Dstring toString();
	
	
	///
	final void update();
	
	
	///
	// If mouseEnter, mouseHover and mouseLeave events are supported.
	// Returns true on Windows 95 with IE 5.5, Windows 98+ or Windows NT 4.0+.
	static bool supportsMouseTracking() ;
	
	package final Rect _fetchBounds();
	
	package final Size _fetchClientSize();
	
	deprecated protected void onInvalidated(InvalidateEventArgs iea);
	
	///
	protected void onPaint(PaintEventArgs pea);
	///
	protected void onMove(EventArgs ea);
	
	/+
	protected void onLocationChanged(EventArgs ea);
	+/
	alias onMove onLocationChanged;
	
	
	///
	protected void onResize(EventArgs ea);
	
	/+
	protected void onSizeChanged(EventArgs ea);
	+/
	alias onResize onSizeChanged;
	
	
	/+
	// ///
	// Allows comparing before and after dimensions, and also allows modifying the new dimensions.
	deprecated protected void onBeforeResize(BeforeResizeEventArgs ea);
	+/
	
	
	///
	protected void onMouseEnter(MouseEventArgs mea);
	
	///
	protected void onMouseMove(MouseEventArgs mea);
	
	///
	protected void onKeyDown(KeyEventArgs kea);
	///
	protected void onKeyPress(KeyPressEventArgs kea);
	///
	protected void onKeyUp(KeyEventArgs kea);
	///
	protected void onMouseWheel(MouseEventArgs mea);
	
	///
	protected void onMouseHover(MouseEventArgs mea);
	
	///
	protected void onMouseLeave(MouseEventArgs mea);
	///
	protected void onMouseDown(MouseEventArgs mea);
	
	///
	protected void onMouseUp(MouseEventArgs mea);
	
	///
	protected void onClick(EventArgs ea);
	///
	protected void onDoubleClick(EventArgs ea);
	
	///
	protected void onGotFocus(EventArgs ea);
	
	/+
	deprecated protected void onEnter(EventArgs ea);
	deprecated protected void onLeave(EventArgs ea);
	
	deprecated protected void onValidated(EventArgs ea);
	
	deprecated protected void onValidating(CancelEventArgs cea);
	+/
	
	
	///
	protected void onLostFocus(EventArgs ea);
	
	///
	protected void onEnabledChanged(EventArgs ea);
	
	///
	protected void onTextChanged(EventArgs ea);
	
	private void _propagateFontAmbience();
	
	
	///
	protected void onFontChanged(EventArgs ea);
	
	///
	protected void onRightToLeftChanged(EventArgs ea);
	
	///
	protected void onVisibleChanged(EventArgs ea);
	
	///
	protected void onHelpRequested(HelpEventArgs hea);
	
	///
	protected void onSystemColorsChanged(EventArgs ea);
	
	
	///
	protected void onHandleCreated(EventArgs ea);
	
	///
	protected void onHandleDestroyed(EventArgs ea);
	
	///
	protected void onPaintBackground(PaintEventArgs pea);
	
	
	private static MouseButtons wparamMouseButtons(WPARAM wparam);
	
	package final void prepareDc(HDC hdc);
	
	// Message copy so it cannot be modified.
	deprecated protected void onNotifyMessage(Message msg);
	/+
	/+package+/ LRESULT customMsg(inout CustomMsg msg);
	+/
	
	
	///
	protected void onReflectedMessage(inout Message m);
	
	
	// ChildWindowFromPoint includes both hidden and disabled.
	// This includes disabled windows, but not hidden.
	// Here is a point in this control, see if it's over a visible child.
	// Returns null if not even in this control's client.
	final HWND pointOverVisibleChild(Point pt);
	
	
	version(_DFL_WINDOWS_HUNG_WORKAROUND)
	{
		DWORD ldlgcode = 0;
	}
	
	
	///
	protected void wndProc(inout Message msg);
	
	package final void _wmSetFocus();
	
	
	package final void _wmKillFocus();
	
	///
	protected void defWndProc(inout Message msg);
	
	// Always called right when destroyed, before doing anything else.
	// hwnd is cleared after this step.
	void _destroying();
	
	
	// This function must be called FIRST for EVERY message to this
	// window in order to keep the correct window state.
	// This function must not throw exceptions.
	package final void mustWndProc(inout Message msg);
	
	package final void _wndProc(inout Message msg);
	
	package final void _defWndProc(inout Message msg);
	
	package final void doShow();
	
	
	package final void doHide();
	
	//EventHandler backColorChanged;
	Event!(Control, EventArgs) backColorChanged; ///
	// EventHandler backgroundImageChanged;
	/+
	deprecated EventHandler causesValidationChanged;
	deprecated InvalidateEventHandler invalidated;
	deprecated EventHandler validated;
	deprecated CancelEventHandler validating; // Once cancel is true, remaining events are suppressed (including validated).
	deprecated EventHandler enter; // Cascades up. TODO: fix implementation.
	deprecated EventHandler leave; // Cascades down. TODO: fix implementation.
	deprecated UICuesEventHandler changeUICues; // TODO: properly fire.
	+/
	//EventHandler click;
	Event!(Control, EventArgs) click; ///
	version(DFL_NO_MENUS)
	{
	}
	else
	{
		//EventHandler contextMenuChanged;
		Event!(Control, EventArgs) contextMenuChanged; ///
	}
	//ControlEventHandler controlAdded;
	Event!(Control, ControlEventArgs) controlAdded; ///
	//ControlEventHandler controlRemoved;
	Event!(Control, ControlEventArgs) controlRemoved; ///
	//EventHandler cursorChanged;
	Event!(Control, EventArgs) cursorChanged; ///
	//EventHandler disposed;
	Event!(Control, EventArgs) disposed; ///
	//EventHandler dockChanged;
	//Event!(Control, EventArgs) dockChanged; ///
	Event!(Control, EventArgs) hasLayoutChanged; ///
	alias hasLayoutChanged dockChanged;
	//EventHandler doubleClick;
	Event!(Control, EventArgs) doubleClick; ///
	//EventHandler enabledChanged;
	Event!(Control, EventArgs) enabledChanged; ///
	//EventHandler fontChanged;
	Event!(Control, EventArgs) fontChanged; ///
	//EventHandler foreColorChanged;
	Event!(Control, EventArgs) foreColorChanged; ///
	//EventHandler gotFocus; // After enter.
	Event!(Control, EventArgs) gotFocus; ///
	//EventHandler handleCreated;
	Event!(Control, EventArgs) handleCreated; ///
	//EventHandler handleDestroyed;
	Event!(Control, EventArgs) handleDestroyed; ///
	//HelpEventHandler helpRequested;
	Event!(Control, HelpEventArgs) helpRequested; ///
	//KeyEventHandler keyDown;
	Event!(Control, KeyEventArgs) keyDown; ///
	//KeyEventHandler keyPress;
	Event!(Control, KeyPressEventArgs) keyPress; ///
	//KeyEventHandler keyUp;
	Event!(Control, KeyEventArgs) keyUp; ///
	//LayoutEventHandler layout;
	Event!(Control, LayoutEventArgs) layout; ///
	//EventHandler lostFocus;
	Event!(Control, EventArgs) lostFocus; ///
	//MouseEventHandler mouseDown;
	Event!(Control, MouseEventArgs) mouseDown; ///
	//MouseEventHandler mouseEnter;
	Event!(Control, MouseEventArgs) mouseEnter; ///
	//MouseEventHandler mouseHover;
	Event!(Control, MouseEventArgs) mouseHover; ///
	//MouseEventHandler mouseLeave;
	Event!(Control, MouseEventArgs) mouseLeave; ///
	//MouseEventHandler mouseMove;
	Event!(Control, MouseEventArgs) mouseMove; ///
	//MouseEventHandler mouseUp;
	Event!(Control, MouseEventArgs) mouseUp; ///
	//MouseEventHandler mouseWheel;
	Event!(Control, MouseEventArgs) mouseWheel; ///
	//EventHandler move;
	Event!(Control, EventArgs) move; ///
	//EventHandler locationChanged;
	alias move locationChanged;
	//PaintEventHandler paint;
	Event!(Control, PaintEventArgs) paint; ///
	//EventHandler parentChanged;
	Event!(Control, EventArgs) parentChanged; ///
	//EventHandler resize;
	Event!(Control, EventArgs) resize; ///
	//EventHandler sizeChanged;
	alias resize sizeChanged;
	//EventHandler rightToLeftChanged;
	Event!(Control, EventArgs) rightToLeftChanged; ///
	// EventHandler styleChanged;
	//EventHandler systemColorsChanged;
	Event!(Control, EventArgs) systemColorsChanged; ///
	// EventHandler tabIndexChanged;
	// EventHandler tabStopChanged;
	//EventHandler textChanged;
	Event!(Control, EventArgs) textChanged; ///
	//EventHandler visibleChanged;
	Event!(Control, EventArgs) visibleChanged; ///
	
	version(DFL_NO_DRAG_DROP) {} else
	{
		//DragEventHandler dragDrop;
		Event!(Control, DragEventArgs) dragDrop; ///
		//DragEventHandler dragEnter;
		Event!(Control, DragEventArgs) dragEnter; ///
		//EventHandler dragLeave;
		Event!(Control, EventArgs) dragLeave; ///
		//DragEventHandler dragOver;
		Event!(Control, DragEventArgs) dragOver; ///
		//GiveFeedbackEventHandler giveFeedback;
		Event!(Control, GiveFeedbackEventArgs) giveFeedback; ///
		//QueryContinueDragEventHandler queryContinueDrag;
		Event!(Control, QueryContinueDragEventArgs) queryContinueDrag; ///
	}
	
	
	/// Construct a new Control instance.
	this();
	
	/// ditto
	this(Dstring text);
	
	/// ditto
	this(Control cparent, Dstring text);
	
	/// ditto
	this(Dstring text, int left, int top, int width, int height);
	
	/// ditto
	this(Control cparent, Dstring text, int left, int top, int width, int height);
	
	/+
	// Used internally.
	this(HWND hwnd);
	+/
	
	
	~this();
	
	
	/+ package +/ /+ protected +/ int _rtype() ;
	
	///
	void dispose();
	
	/// ditto
	protected void dispose(bool disposing);
	
	
	protected:
	
	///
	Size defaultSize() ;
	
	
	/+
	// TODO: implement.
	EventHandlerList events() ;
	+/
	
	
	/+
	// TODO: implement. Is this worth implementing?
	
	// Set to -1 to reset cache.
	final void fontHeight(int fh);
	
	final int fontHeight() ;
	+/
	
	
	///
	//final void resizeRedraw(bool byes) // setter
	public final void resizeRedraw(bool byes);
	/// ditto
	final bool resizeRedraw() ;
	
	/+
	// ///
	// I don't think this is reliable.
	final bool hasVisualStyle() ;
	+/
	
	
	package final void _disableVisualStyle();
	
	
	///
	public final void disableVisualStyle(bool byes = true);
	
	deprecated public final void enableVisualStyle(bool byes = true);
	
	///
	ControlCollection createControlsInstance();
	
	
	deprecated package final void createClassHandle(Dstring className);
	
	
	///
	// Override to change the creation parameters.
	// Be sure to call super.createParams() or all the create params will need to be filled.
	protected void createParams(inout CreateParams cp);
	
	///
	protected void createHandle();
	
	
	package final void _createHandle();
	
	///
	public final bool recreatingHandle() ;
	
	
	private void _setAllRecreating();
	
	///
	protected void recreateHandle();
	
	///
	void destroyHandle();
	
	private final void fillRecreationData();
	
	///
	protected void onDisposed(EventArgs ea);
	
	///
	protected final bool getStyle(ControlStyles flag);
	
	/// ditto
	protected final void setStyle(ControlStyles flag, bool value);
	
	///
	// Only for setStyle() styles that are part of hwnd and wndclass styles.
	protected final void updateStyles();
	
	///
	final bool getTopLevel();
	
	
	package final void alayout(Control ctrl, bool vcheck = true);
	
	
	// Z-order of controls has changed.
	package final void vchanged();
	
	///
	// Called after adding the control to a container.
	protected void initLayout();
	
	///
	protected void onLayout(LayoutEventArgs lea);
	
	/+
	// Not sure what to do here.
	deprecated bool isInputChar(char charCode);
	+/
	
	
	///
	void setVisibleCore(bool byes);
	
	
	package final bool _wantTabKey();
	///
	// Return true if processed.
	protected bool processKeyEventArgs(inout Message msg);
	
	
	package final bool _processKeyEventArgs(inout Message msg);
	
	/+
	bool processKeyPreview(inout Message m);
	
	protected bool processDialogChar(dchar charCode);
	+/
	
	
	///
	protected bool processMnemonic(dchar charCode);
	
	package bool _processMnemonic(dchar charCode);
	
	// Retain DFL 0.9.5 compatibility.
	public deprecated void setDFL095();
	
	
	private enum CCompat: ubyte
	{
		NONE = 0,
		DFL095 = 1,
	}
	
	version(SET_DFL_095)
		package const ubyte _compat = CCompat.DFL095;
	else version(DFL_NO_COMPAT)
		package const ubyte _compat = CCompat.NONE;
	else
		package CCompat _compat();
	
	
	package final void _crecreate();
	
	
	package:
	HWND hwnd;
	//AnchorStyles anch = cast(AnchorStyles)(AnchorStyles.TOP | AnchorStyles.LEFT);
	//bool cvalidation = true;
	version(DFL_NO_MENUS)
	{
	}
	else
	{
		ContextMenu cmenu;
	}
	DockStyle sdock = DockStyle.NONE;
	Dstring _ctrlname;
	Object otag;
	Color backc, forec;
	Rect wrect;
	//Rect oldwrect;
	Size wclientsz;
	Cursor wcurs;
	Font wfont;
	Control wparent;
	Region wregion;
	ControlCollection ccollection;
	Dstring wtext; // After creation, this isn't used unless ControlStyles.CACHE_TEXT.
	ControlStyles ctrlStyle = ControlStyles.STANDARD_CLICK | ControlStyles.STANDARD_DOUBLE_CLICK /+ | ControlStyles.RESIZE_REDRAW +/ ;
	HBRUSH _hbrBg;
	RightToLeft rtol = RightToLeft.INHERIT;
	uint _disallowLayout = 0;
	
	version(DFL_NO_DRAG_DROP) {} else
	{
		DropTarget droptarget = null;
	}
	
	// Note: WS_VISIBLE is not reliable.
	LONG wstyle = WS_CHILD | WS_VISIBLE | WS_CLIPCHILDREN | WS_CLIPSIBLINGS; // Child, visible and enabled by default.
	LONG wexstyle;
	LONG wclassStyle = WNDCLASS_STYLE;
	
	
	enum CBits: uint
	{
		NONE = 0x0,
		MENTER = 0x1, // Is mouse entered? Only valid if -trackMouseEvent- is non-null.
		KILLING = 0x2,
		OWNED = 0x4,
		//ALLOW_LAYOUT = 0x8,
		CLICKING = 0x10,
		NEED_CALC_SIZE = 0x20,
		SZDRAW = 0x40,
		OWNEDBG = 0x80,
		HANDLE_CREATED = 0x100, // debug only
		SW_SHOWN = 0x200,
		SW_HIDDEN = 0x400,
		CREATED = 0x800,
		NEED_INIT_LAYOUT = 0x1000,
		IN_LAYOUT = 0x2000,
		FVISIBLE = 0x4000,
		VISIBLE = 0x8000,
		NOCLOSING = 0x10000,
		ASCROLL = 0x20000,
		ASCALE = 0x40000,
		FORM = 0x80000,
		RECREATING = 0x100000,
		HAS_LAYOUT = 0x200000,
		VSTYLE = 0x400000, // If not forced off.
		FORMLOADED = 0x800000, // If not forced off.
		ENABLED = 0x1000000, // Enabled state, not considering the parent.
	}
	
	//CBits cbits = CBits.ALLOW_LAYOUT;
	//CBits cbits = CBits.NONE;
	CBits cbits = CBits.VISIBLE | CBits.VSTYLE | CBits.ENABLED;
	
	
	final:
	
	void menter(bool byes);
	bool menter() ;
	
	void killing(bool byes) ;
	bool killing() ;
	
	void owned(bool byes);
	bool owned() ;
	
	/+
	void _allowLayout(bool byes) ;
	bool _allowLayout() ;
	+/
	
	void _clicking(bool byes);
	bool _clicking();
	
	void needCalcSize(bool byes);
	bool needCalcSize() ;
	
	void szdraw(bool byes) ;
	bool szdraw();
	
	void ownedbg(bool byes) ;
	bool ownedbg() ;
	
	debug
	{
		void _handlecreated(bool byes) ;
		bool _handlecreated() ;
	}
	
	
	LONG _exStyle();
	
	
	void _exStyle(LONG wl);
	
	LONG _style();
	
	void _style(LONG wl);
	
	
	HBRUSH hbrBg() ;
	
	void hbrBg(HBRUSH hbr) ;
	
	void deleteThisBackgroundBrush();
	
	LRESULT defwproc(UINT msg, WPARAM wparam, LPARAM lparam);
	
	LONG _fetchClassLong();
	
	LONG _classStyle();
	
	
	package void _classStyle(LONG cl);
}


package abstract class ControlSuperClass: Control // dapi.d
{
	// Call previous wndProc().
	abstract protected void prevWndProc(inout Message msg);
	
	
	protected override void wndProc(inout Message msg);
	
	override void defWndProc(inout Message m);
	
	protected override void onPaintBackground(PaintEventArgs pea);
}


///
class ScrollableControl: Control // docmain
{
	// ///
	deprecated void autoScroll(bool byes);
	
	// /// ditto
	deprecated bool autoScroll() ;
	
	
	// ///
	deprecated final void autoScrollMargin(Size sz) ;
	
	// /// ditto
	deprecated final Size autoScrollMargin();
	
	
	// ///
	deprecated final void autoScrollMinSize(Size sz) ;
	
	// /// ditto
	deprecated final Size autoScrollMinSize() ;
	
	
	// ///
	deprecated final void autoScrollPosition(Point pt) ;
	
	// /// ditto
	deprecated final Point autoScrollPosition();
	
	
	///
	final Size autoScaleBaseSize();
	
	/// ditto
	final void autoScaleBaseSize(Size newSize) ;
	
	
	///
	final void autoScale(bool byes) ;
	
	/// ditto
	final bool autoScale() ;
	
	
	final Point scrollPosition() ;
	
	
	static Size calcScale(Size area, Size toScale, Size fromScale) ;
	
	
	Size calcScale(Size area, Size toScale);
	
	
	final void _scale(Size toScale);
	
	final void _scale();
	
	protected override void onControlAdded(ControlEventArgs ea);
	
	
	//override final Rect displayRectangle() // getter
	override Rect displayRectangle() ;
	
	
	///
	final void scrollSize(Size sz);
	
	/// ditto
	final Size scrollSize();
	
	///
	class DockPaddingEdges
	{
		private:
		
		int _left, _top, _right, _bottom;
		int _all;
		//package void delegate() changed;
		
		
		final:
		
		void changed();
		
		
		public:
		
		///
		void all(int x) ;
		/// ditto
		final int all() ;
		
		/// ditto
		void left(int x) ;
		
		/// ditto
		int left() ;
		
		/// ditto
		void top(int x) ;
		
		/// ditto
		int top() ;
		/// ditto
		void right(int x);
		
		/// ditto
		int right() ;
		/// ditto
		
		void bottom(int x) ;
		
		/// ditto
		int bottom() ;
	}
	
	
	///
	final DockPaddingEdges dockPadding();
	
	
	deprecated final void setAutoScrollMargin(int x, int y);
	
	this();
	
	const Size DEFAULT_SCALE = { 5, 13 };
	
	///
	final void hScroll(bool byes);
	
	
	/// ditto
	final bool hScroll();
	
	///
	final void vScroll(bool byes);
	/// ditto
	final bool vScroll() ;
	
	protected:
	
	
	/+
	override void onLayout(LayoutEventArgs lea);
	+/
	
	
	/+
	override void scaleCore(float width, float height);
	+/
	
	
	override void wndProc(inout Message m);
	
	
	override void onMouseWheel(MouseEventArgs ea);	
	
	override void onHandleCreated(EventArgs ea);
	
	override void onVisibleChanged(EventArgs ea);
	
	
	private void _fixScrollBounds();
	
	
	override void onResize(EventArgs ea);
	
	
	private:
	//Size scrollmargin, scrollmin;
	//Point autoscrollpos;
	DockPaddingEdges dpad;
	Size autossz = DEFAULT_SCALE;
	Size scrollsz = { 0, 0 };
	int xspos = 0, yspos = 0;
	
	
	void _init();
	
	
	void dpadChanged();
	
	
	void _adjustScrollSize(BOOL fRedraw = TRUE);
}


///
interface IContainerControl // docmain
{
	///
	Control activeControl(); // getter
	
	deprecated void activeControl(Control); // setter
	
	deprecated bool activateControl(Control);
}


///
class ContainerControl: ScrollableControl, IContainerControl // docmain
{
	///
	Control activeControl() ;
	
	/// ditto
	void activeControl(Control ctrl) ;
	
	///
	// Returns true if successfully activated.
	final bool activateControl(Control ctrl);
	
	
	///
	final Form parentForm() ;
	
	/+
	final bool validate();
	+/
	
	
	this();
	
	
	/+
	// Used internally.
	this(HWND hwnd);
	+/
	
	
	private void _init();
	
	protected:
	/+
	override bool processDialogChar(char charCode);
	+/
	
	
	/+
	deprecated protected override bool processMnemonic(dchar charCode);
	
	bool processTabKey(bool forward);
	+/
}

