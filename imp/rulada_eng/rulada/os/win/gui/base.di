// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.base;

private import os.win.gui.x.dlib, std.c;

private import os.win.gui.x.winapi, os.win.gui.drawing, os.win.gui.event;


alias HWND HWindow;


///
interface IWindow // docmain
{
	///
	HWindow handle(); // getter
}

alias IWindow IWin32Window; // deprecated


///
class DflException: Exception // docmain
{
	///
	this(Dstring msg);
}


///
class StringObject: DObject
{
	///
	Dstring value;
	
	
	///
	this(Dstring str);
	
	
	override Dstring toString();
	
	
	override Dequ opEquals(Object o);
	
	Dequ opEquals(StringObject s);
	
	override int opCmp(Object o);
	
	int opCmp(StringObject s);
}


///
enum Keys: uint // docmain
{
	NONE =     0, /// No keys specified.
	
	///
	SHIFT =    0x10000, /// Modifier keys.
	CONTROL =  0x20000, /// ditto
	ALT =      0x40000, /// ditto
	
	A = 'A', /// Letters.
	B = 'B', /// ditto
	C = 'C', /// ditto
	D = 'D', /// ditto
	E = 'E', /// ditto
	F = 'F', /// ditto
	G = 'G', /// ditto
	H = 'H', /// ditto
	I = 'I', /// ditto
	J = 'J', /// ditto
	K = 'K', /// ditto
	L = 'L', /// ditto
	M = 'M', /// ditto
	N = 'N', /// ditto
	O = 'O', /// ditto
	P = 'P', /// ditto
	Q = 'Q', /// ditto
	R = 'R', /// ditto
	S = 'S', /// ditto
	T = 'T', /// ditto
	U = 'U', /// ditto
	V = 'V', /// ditto
	W = 'W', /// ditto
	X = 'X', /// ditto
	Y = 'Y', /// ditto
	Z = 'Z', /// ditto
	
	D0 = '0', /// Digits.
	D1 = '1', /// ditto
	D2 = '2', /// ditto
	D3 = '3', /// ditto
	D4 = '4', /// ditto
	D5 = '5', /// ditto
	D6 = '6', /// ditto
	D7 = '7', /// ditto
	D8 = '8', /// ditto
	D9 = '9', /// ditto
	
	F1 = 112, /// F - function keys.
	F2 = 113, /// ditto
	F3 = 114, /// ditto
	F4 = 115, /// ditto
	F5 = 116, /// ditto
	F6 = 117, /// ditto
	F7 = 118, /// ditto
	F8 = 119, /// ditto
	F9 = 120, /// ditto
	F10 = 121, /// ditto
	F11 = 122, /// ditto
	F12 = 123, /// ditto
	F13 = 124, /// ditto
	F14 = 125, /// ditto
	F15 = 126, /// ditto
	F16 = 127, /// ditto
	F17 = 128, /// ditto
	F18 = 129, /// ditto
	F19 = 130, /// ditto
	F20 = 131, /// ditto
	F21 = 132, /// ditto
	F22 = 133, /// ditto
	F23 = 134, /// ditto
	F24 = 135, /// ditto
	
	NUM_PAD0 = 96, /// Numbers on keypad.
	NUM_PAD1 = 97, /// ditto
	NUM_PAD2 = 98, /// ditto
	NUM_PAD3 = 99, /// ditto
	NUM_PAD4 = 100, /// ditto
	NUM_PAD5 = 101, /// ditto
	NUM_PAD6 = 102, /// ditto
	NUM_PAD7 = 103, /// ditto
	NUM_PAD8 = 104, /// ditto
	NUM_PAD9 = 105, /// ditto
	
	ADD = 107, ///
	APPS = 93, /// Application.
	ATTN = 246, ///
	BACK = 8, /// Backspace.
	CANCEL = 3, ///
	CAPITAL = 20, ///
	CAPS_LOCK = 20, /// ditto
	CLEAR = 12, ///
	CONTROL_KEY = 17, ///
	CRSEL = 247, ///
	DECIMAL = 110, ///
	DEL = 46, ///
	DELETE = DEL, ///
	PERIOD = 190, ///
	DOT = PERIOD, /// ditto
	DIVIDE = 111, ///
	DOWN = 40, /// Down arrow.
	END = 35, ///
	ENTER = 13, ///
	ERASE_EOF = 249, ///
	ESCAPE = 27, ///
	EXECUTE = 43, ///
	EXSEL = 248, ///
	FINAL_MODE = 4, /// IME final mode.
	HANGUL_MODE = 21, /// IME Hangul mode.
	HANGUEL_MODE = 21, /// ditto
	HANJA_MODE = 25, /// IME Hanja mode.
	HELP = 47, ///
	HOME = 36, ///
	IME_ACCEPT = 30, ///
	IME_CONVERT = 28, ///
	IME_MODE_CHANGE = 31, ///
	IME_NONCONVERT = 29, ///
	INSERT = 45, ///
	JUNJA_MODE = 23, ///
	KANA_MODE = 21, ///
	KANJI_MODE = 25, ///
	LEFT_CONTROL = 162, /// Left Ctrl.
	LEFT = 37, /// Left arrow.
	LINE_FEED = 10, ///
	LEFT_MENU = 164, /// Left Alt.
	LEFT_SHIFT = 160, ///
	LEFT_WIN = 91, /// Left Windows logo.
	MENU = 18, /// Alt.
	MULTIPLY = 106, ///
	NEXT = 34, /// Page down.
	NO_NAME = 252, // Reserved for future use.
	NUM_LOCK = 144, ///
	OEM8 = 223, // OEM specific.
	OEM_CLEAR = 254,
	PA1 = 253,
	PAGE_DOWN = 34, ///
	PAGE_UP = 33, ///
	PAUSE = 19, ///
	PLAY = 250, ///
	PRINT = 42, ///
	PRINT_SCREEN = 44, ///
	PROCESS_KEY = 229, ///
	RIGHT_CONTROL = 163, /// Right Ctrl.
	RETURN = 13, ///
	RIGHT = 39, /// Right arrow.
	RIGHT_MENU = 165, /// Right Alt.
	RIGHT_SHIFT = 161, ///
	RIGHT_WIN = 92, /// Right Windows logo.
	SCROLL = 145, /// Scroll lock.
	SELECT = 41, ///
	SEPARATOR = 108, ///
	SHIFT_KEY = 16, ///
	SNAPSHOT = 44, /// Print screen.
	SPACE = 32, ///
	SPACEBAR = SPACE, // Extra.
	SUBTRACT = 109, ///
	TAB = 9, ///
	UP = 38, /// Up arrow.
	ZOOM = 251, ///
	
	// Windows 2000+
	BROWSER_BACK = 166, ///
	BROWSER_FAVORITES = 171, /// ditto
	BROWSER_FORWARD = 167, /// ditto
	BROWSER_HOME = 172, /// ditto
	BROWSER_REFRESH = 168, /// ditto
	BROWSER_SEARCH = 170, /// ditto
	BROWSER_STOP = 169, /// ditto
	LAUNCH_APPLICATION1 = 182, ///
	LAUNCH_APPLICATION2 = 183, /// ditto
	LAUNCH_MAIL = 180, /// ditto
	MEDIA_NEXT_TRACK = 176, ///
	MEDIA_PLAY_PAUSE = 179, /// ditto
	MEDIA_PREVIOUS_TRACK = 177, /// ditto
	MEDIA_STOP = 178, /// ditto
	OEM_BACKSLASH = 226, // OEM angle bracket or backslash.
	OEM_CLOSE_BRACKETS = 221,
	OEM_COMMA = 188,
	OEM_MINUS = 189,
	OEM_OPEN_BRACKETS = 219,
	OEM_PERIOD = 190,
	OEM_PIPE = 220,
	OEM_PLUS = 187,
	OEM_QUESTION = 191,
	OEM_QUOTES = 222,
	OEM_SEMICOLON = 186,
	OEM_TILDE = 192,
	SELECT_MEDIA = 181, ///
	VOLUME_DOWN = 174, ///
	VOLUME_MUTE = 173, /// ditto
	VOLUME_UP = 175, /// ditto
	
	/// Bit mask to extract key code from key value.
	KEY_CODE = 0xFFFF,
	
	/// Bit mask to extract modifiers from key value.
	MODIFIERS = 0xFFFF0000,
}


///
enum MouseButtons: uint // docmain
{
	/// No mouse buttons specified.
	NONE =      0,
	
	LEFT =      0x100000, ///
	RIGHT =     0x200000, /// ditto
	MIDDLE =    0x400000, /// ditto
	
	// Windows 2000+
	//XBUTTON1 =  0x800000,
	//XBUTTON2 =  0x1000000,
}


///
enum CheckState: ubyte
{
	UNCHECKED = BST_UNCHECKED, ///
	CHECKED = BST_CHECKED, /// ditto
	INDETERMINATE = BST_INDETERMINATE, /// ditto
}


///
struct Message // docmain
{
	union
	{
		struct
		{
			HWND hWnd; ///
			UINT msg; /// ditto
			WPARAM wParam; /// ditto
			LPARAM lParam; /// ditto
		}
		
		package MSG _winMsg; // .time and .pt are not always valid.
	}
	LRESULT result; ///
	
	
	/// Construct a Message struct.
	static Message opCall(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);
}


///
interface IMessageFilter // docmain
{
	///
	// Return false to allow the message to be dispatched.
	// Filter functions cannot modify messages.
	bool preFilterMessage(inout Message m);
}


abstract class WaitHandle
{
	const int WAIT_TIMEOUT = os.win.gui.x.winapi.WAIT_TIMEOUT; // DMD 1.028: needs fqn, otherwise conflicts with std.thread
	const HANDLE INVALID_HANDLE = .INVALID_HANDLE_VALUE;
	
	
	this();
	
	
	// Used internally.
	this(HANDLE h, bool owned = true);
	
	
	HANDLE handle();
	
	
	void handle(HANDLE h);
	
	
	void close();
	
	
	~this();
	
	
	private static DWORD _wait(WaitHandle[] handles, BOOL waitall, DWORD msTimeout);
	
	static void waitAll(WaitHandle[] handles);
	
	
	static void waitAll(WaitHandle[] handles, DWORD msTimeout);
	
	static int waitAny(WaitHandle[] handles);
	
	
	static int waitAny(WaitHandle[] handles, DWORD msTimeout);
	
	
	void waitOne();
	
	void waitOne(DWORD msTimeout);
	
	
	private:
	HANDLE h;
	bool owned = true;
}


interface IAsyncResult
{
	WaitHandle asyncWaitHandle(); // getter
	
	// Usually just returns false.
	bool completedSynchronously(); // getter
	
	// When true, it is safe to release its resources.
	bool isCompleted(); // getter
}


/+
class AsyncResult: IAsyncResult
{
}
+/


///
interface IButtonControl // docmain
{
	///
	DialogResult dialogResult(); // getter
	/// ditto
	void dialogResult(DialogResult); // setter
	
	///
	void notifyDefault(bool); // True if default button.
	
	///
	void performClick(); // Raise click event.
}


///
enum DialogResult: ubyte // docmain
{
	NONE, ///
	
	ABORT = IDABORT, ///
	CANCEL = IDCANCEL, ///
	IGNORE = IDIGNORE, ///
	NO = IDNO, ///
	OK = IDOK, ///
	RETRY = IDRETRY, ///
	YES = IDYES, ///
	
	// Extra.
	CLOSE = IDCLOSE,
	HELP = IDHELP,
}


interface IDialogResult
{
	// ///
	DialogResult dialogResult(); // getter
	// /// ditto
	void dialogResult(DialogResult); // setter
}


///
enum SortOrder: ubyte
{
	NONE, ///
	
	ASCENDING, ///
	DESCENDING, /// ditto
}


///
enum View: ubyte
{
	LARGE_ICON, ///
	SMALL_ICON, ///
	LIST, ///
	DETAILS, ///
}


///
enum ItemBoundsPortion: ubyte
{
	ENTIRE, ///
	ICON, ///
	ITEM_ONLY, /// Excludes other stuff like check boxes.
	LABEL, /// Item's text.
}


///
enum ItemActivation: ubyte
{
	STANDARD, ///
	ONE_CLICK, ///
	TWO_CLICK, ///
}


///
enum ColumnHeaderStyle: ubyte
{
	CLICKABLE, ///
	NONCLICKABLE, ///
	NONE, /// No column header.
}


///
enum BorderStyle: ubyte
{
	NONE, ///
	
	FIXED_3D, ///
	FIXED_SINGLE, /// ditto
}


///
enum FlatStyle: ubyte
{
	STANDARD, ///
	FLAT, /// ditto
	POPUP, /// ditto
	SYSTEM, /// ditto
}


///
enum Appearance: ubyte
{
	NORMAL, ///
	BUTTON, ///
}


///
enum ContentAlignment: ubyte
{
	TOP_LEFT, ///
	BOTTOM_CENTER, ///
	BOTTOM_LEFT, ///
	BOTTOM_RIGHT, ///
	MIDDLE_CENTER, ///
	MIDDLE_LEFT, ///
	MIDDLE_RIGHT, ///
	TOP_CENTER, ///
	TOP_RIGHT, ///
}


///
enum CharacterCasing: ubyte
{
	NORMAL, ///
	LOWER, ///
	UPPER, ///
}


///
// Not flags.
enum ScrollBars: ubyte
{
	NONE, ///
	
	HORIZONTAL, ///
	VERTICAL, /// ditto
	BOTH, /// ditto
}


///
enum HorizontalAlignment: ubyte
{
	LEFT, ///
	RIGHT, /// ditto
	CENTER, /// ditto
}


///
enum DrawMode: ubyte
{
	NORMAL, ///
	OWNER_DRAW_FIXED, ///
	OWNER_DRAW_VARIABLE, /// ditto
}


///
enum DrawItemState: uint
{
	NONE = 0, ///
	SELECTED = 1, /// ditto
	DISABLED = 2, /// ditto
	CHECKED = 8, /// ditto
	FOCUS = 0x10, /// ditto
	DEFAULT = 0x20, /// ditto
	HOT_LIGHT = 0x40, /// ditto
	NO_ACCELERATOR = 0x80, /// ditto
	INACTIVE = 0x100, /// ditto
	NO_FOCUS_RECT = 0x200, /// ditto
	COMBO_BOX_EDIT = 0x1000, /// ditto
}


///
enum RightToLeft: ubyte
{
	INHERIT = 2, ///
	YES = 1, /// ditto
	NO = 0, /// ditto
}


///
enum ColorDepth: ubyte
{
	DEPTH_4BIT = 0x04, ///
	DEPTH_8BIT = 0x08, /// ditto
	DEPTH_16BIT = 0x10, /// ditto
	DEPTH_24BIT = 0x18, /// ditto
	DEPTH_32BIT = 0x20, /// ditto
}


///
class PaintEventArgs: EventArgs
{
	///
	this(Graphics graphics, Rect clipRect);
	
	///
	final Graphics graphics();
	
	///
	final Rect clipRectangle() ;
	
	private:
	Graphics g;
	Rect cr;
}


///
class CancelEventArgs: EventArgs
{
	///
	// Initialize cancel to false.
	this();
	
	/// ditto
	this(bool cancel);
	
	
	///
	final void cancel(bool byes);
	
	/// ditto
	final bool cancel() ;
	
	
	private:
	bool cncl;
}


///
class KeyEventArgs: EventArgs
{
	///
	this(Keys keys);
	
	
	
	///
	final bool alt() ;
	
	
	///
	final bool control() ;
	
	
	///
	final void handled(bool byes) ;
	///
	final bool handled() ;
	
	
	///
	final Keys keyCode() ;
	
	///
	final Keys keyData() ;
	
	///
	// -keyData- as an int.
	final int keyValue() ;
	
	
	///
	final Keys modifiers() ;
	
	
	///
	final bool shift();
	
	private:
	Keys ks;
	bool hand = false;
}


///
class KeyPressEventArgs: KeyEventArgs
{
	///
	this(dchar ch);
	
	/// ditto
	this(dchar ch, Keys modifiers);
	
	
	///
	final dchar keyChar() ;
	
	private:
	dchar _keych;
}


///
class MouseEventArgs: EventArgs
{
	///
	// -delta- is mouse wheel rotations.
	this(MouseButtons button, int clicks, int x, int y, int delta);
	
	
	///
	final MouseButtons button() ;
	
	///
	final int clicks();
	
	
	///
	final int delta();
	
	
	///
	final int x() ;
	
	
	///
	final int y() ;
	
	
	private:
	MouseButtons btn;
	int clks;
	int _x, _y;
	int dlt;
}


/+
///
class LabelEditEventArgs: EventArgs
{
	///
	this(int index);
	
	/// ditto
	this(int index, Dstring labelText);
	
	
	///
	final void cancelEdit(bool byes) ;
	
	/// ditto
	final bool cancelEdit() ;
	
	
	///
	// The text of the label's edit.
	final Dstring label();
	
	
	///
	// Gets the item's index.
	final int item() ;
	
	
	private:
	int idx;
	Dstring ltxt;
	bool cancl = false;
}
+/


///
class ColumnClickEventArgs: EventArgs
{
	///
	this(int col);
	
	///
	final int column() ;
	
	
	private:
	int col;
}


///
class DrawItemEventArgs: EventArgs
{
	///
	this(Graphics g, Font f, Rect r, int i, DrawItemState dis);
	
	/// ditto
	this(Graphics g, Font f, Rect r, int i, DrawItemState dis, Color fc, Color bc);
	
	///
	final Color backColor();
	
	
	///
	final Rect bounds() ;
	
	
	///
	final Font font();
	
	
	///
	final Color foreColor() ;
	
	///
	final Graphics graphics();
	
	
	///
	final int index() ;
	
	
	///
	final DrawItemState state() ;
	
	
	///
	void drawBackground();
	
	///
	void drawFocusRectangle();
	
	
	private:
	Graphics gpx;
	Font fnt; // Suggestion; the parent's font.
	Rect rect;
	int idx;
	DrawItemState distate;
	Color fcolor, bcolor; // Suggestion; depends on item state.
}


///
class MeasureItemEventArgs: EventArgs
{
	///
	this(Graphics g, int index, int itemHeight);
	
	/// ditto
	this(Graphics g, int index);
	
	///
	final Graphics graphics() ;
	
	///
	final int index() ;
	
	
	///
	final void itemHeight(int height);
	/// ditto
	final int itemHeight();
	
	
	///
	final void itemWidth(int width) ;
	/// ditto
	final int itemWidth() ;
	
	
	private:
	Graphics gpx;
	int idx, iheight, iwidth = 0;
}


///
class Cursor // docmain
{
	private static Cursor _cur;
	
	
	// Used internally.
	this(HCURSOR hcur, bool owned = true);	
	
	~this();
	
	
	///
	override void dispose();
	
	
	///
	static void current(Cursor cur) ;
	
	/// ditto
	static Cursor current();
	
	
	///
	static void clip(Rect r);
	
	/// ditto
	static Rect clip() ;
	
	
	///
	final HCURSOR handle() ;
	
	
	/+
	// TODO:
	final Size size();
	+/
	
	
	///
	// Uses the actual size.
	final void draw(Graphics g, Point pt);
	
	/+
	/// ditto
	// Should not stretch if bigger, but should crop if smaller.
	final void draw(Graphics g, Rect r;
	+/
	
	
	///
	final void drawStretched(Graphics g, Rect r);
	
	override Dequ opEquals(Object o);
	
	Dequ opEquals(Cursor cur);
	
	
	/// Show/hide the current mouse cursor; reference counted.
	// show/hide are ref counted.
	static void hide();
	
	/// ditto
	// show/hide are ref counted.
	static void show();
	
	
	/// The position of the current mouse cursor.
	static void position(Point pt) ;
	
	/// ditto
	static Point position();
	
	
	private:
	HCURSOR hcur;
	bool owned = true;
}


///
class Cursors // docmain
{
	private this();
	
	
	static:
	
	///
	Cursor appStarting() ;
	
	Cursor arrow() ;
	///
	Cursor cross() ;
	///
	//Cursor default() // getter
	Cursor defaultCursor() ;
	///
	Cursor hand();
	
	
	///
	Cursor help();
	
	///
	Cursor hSplit();
	/// ditto
	Cursor vSplit() ;
	
	
	///
	Cursor iBeam() ;
	///
	Cursor no();
	
	///
	Cursor sizeAll() ;
	/// ditto
	Cursor sizeNESW();
	/// ditto
	Cursor sizeNS();
	/// ditto
	Cursor sizeNWSE();
	/// ditto
	Cursor sizeWE();
	
	/+
	///
	// Insertion point.
	Cursor upArrow();
	+/
	
	///
	Cursor waitCursor() ;
}

