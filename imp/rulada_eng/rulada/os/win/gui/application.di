// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.application;

private import os.win.gui.x.dlib, std.c;

private import os.win.gui.base, os.win.gui.form, os.win.gui.x.winapi, os.win.gui.event;
private import os.win.gui.control, os.win.gui.drawing, os.win.gui.label;
private import os.win.gui.button, os.win.gui.textbox, os.win.gui.x.wincom, os.win.gui.environment;
private import os.win.gui.x.utf;

version(DFL_NO_RESOURCES)
{
}
else
{
	private import os.win.gui.resources;
}

version(DFL_NO_MENUS)
{
}
else
{
	private import os.win.gui.menu;
}


version = DFL_NO_ZOMBIE_FORM;

//debug = APP_PRINT;
//debug = SHOW_MESSAGE_INFO; // Slow.

debug(APP_PRINT)
{
	pragma(msg, "os.win.gui: debug app print");
	
	version(DFL_LIB)
		static assert(0);
}


private extern(C) void abort();


///
class ApplicationContext // docmain
{
	///
	this();
	
	
	///
	// If onMainFormClose isn't overridden, the message
	// loop terminates when the main form is destroyed.
	this(Form mainForm);
	
	
	///
	final void mainForm(Form mainForm) ;
	
	/// ditto
	final Form mainForm() ;
	
	
	///
	Event!(Object, EventArgs) threadExit;
	
	
	///
	final void exitThread();
	
	
	protected:
	
	///
	void exitThreadCore();
	
	
	///
	void onMainFormClosed(Object sender, EventArgs args);
	
	
	private:
	Form mform; // The context form.
}


private extern(Windows)
{
	alias UINT function(LPCWSTR lpPathName, LPCWSTR lpPrefixString, UINT uUnique,
		LPWSTR lpTempFileName) GetTempFileNameWProc;
	alias DWORD function(DWORD nBufferLength, LPWSTR lpBuffer) GetTempPathWProc;
	alias HANDLE function(PACTCTXW pActCtx) CreateActCtxWProc;
	alias BOOL function(HANDLE hActCtx, os.win.gui.x.winapi.ULONG_PTR* lpCookie) ActivateActCtxProc;
}


version(NO_WINDOWS_HUNG_WORKAROUND)
{
}
else
{
	version = WINDOWS_HUNG_WORKAROUND;
}


// Compatibility with previous DFL versions.
// Set version=DFL_NO_COMPAT to disable.
enum DflCompat
{
	NONE = 0,
	
	// Adding to menus is the old way.
	MENU_092 = 0x1,
	
	// Controls don't recreate automatically when necessary.
	CONTROL_RECREATE_095 = 0x2,
	
	// Nothing.
	CONTROL_KEYEVENT_096 = 0x4,
	
	// When a Form is in showDialog, changing the dialogResult from NONE doesn't close the form.
	FORM_DIALOGRESULT_096 = 0x8,
	
	// Call onLoad/load and focus a control at old time.
	FORM_LOAD_096 = 0x10,
	
	// Parent controls now need to be container-controls; this removes that limit.
	CONTROL_PARENT_096 = 0x20,
}


///
final class Application // docmain
{
	private this();
	
	
	static:
	
	///
	// Should be called before creating any controls.
	// This is typically the first function called in main().
	// Does nothing if not supported.
	void enableVisualStyles();
	
	
	/+
	// ///
	bool visualStyles() // getter
	{
		// IsAppThemed:
		// "Do not call this function during DllMain or global objects contructors.
		// This may cause invalid return values in Microsoft Windows Vista and may cause Windows XP to become unstable."
	}
	+/
	
	
	/// Path of the executable including its file name.
	Dstring executablePath();
	
	/// Directory containing the executable.
	Dstring startupPath();
	
	
	// Used internally.
	Dstring getSpecialPath(Dstring name) ;
	
	
	/// Application data base directory path, usually `C:\Documents and Settings\<user>\Application Data`; this directory might not exist yet.
	Dstring userAppDataBasePath();
	
	
	///
	bool messageLoop();
	
	
	///
	void addMessageFilter(IMessageFilter mf);
	
	/// ditto
	void removeMessageFilter(IMessageFilter mf);
	
	
	package bool _doEvents(bool* keep);
	
	/// Process all messages in the message queue. Returns false if the application should exit.
	bool doEvents();
	
	
	/// Run the application.
	void run();
	/// ditto
	void run(void delegate() whileIdle);
	/// ditto
	void run(ApplicationContext appcon);
	
	/// ditto
	// -whileIdle- is called repeatedly while there are no messages in the queue.
	// Application.idle events are suppressed; however, the -whileIdle- handler
	// may manually fire the Application.idle event.
	void run(ApplicationContext appcon, void delegate() whileIdle);
	
	/// ditto
	// Makes the form -mainForm- visible.
	void run(Form mainForm, void delegate() whileIdle);
	
	/// ditto
	void run(Form mainForm);
	
	
	///
	void exit();
	
	
	/// Exit the thread's message loop and return from run.
	// Actually only stops the current run() loop.
	void exitThread();
	
	
	// Will be null if not in a successful Application.run.
	package ApplicationContext context() ;
	
	
	///
	HINSTANCE getInstance();
	
	/// ditto
	void setInstance(HINSTANCE inst);
	
	
	// ApartmentState oleRequired() ...
	
	
	private static class ErrForm: Form
	{
		protected override void onLoad(EventArgs ea);
		
		
		protected override void onClosing(CancelEventArgs cea);
		
		
		const int PADDING = 10;
		
		
		void onOkClick(Object sender, EventArgs ea);
		
		void onCancelClick(Object sender, EventArgs ea);
		
		
		this(Dstring errmsg);
		
		
		/+
		private int inThread2();
		+/
		
		bool doContinue();
		
		override Dstring toString();
		
		
		private:
		bool errdone = false;
		bool ctnu = false;
		Button okBtn;
		TextBox errBox;
	}
	
	
	///
	bool showDefaultExceptionDialog(Object e);
	
	
	///
	void onThreadException(Object e);
	
	///
	Event!(Object, EventArgs) idle; // Finished processing and is now idle.
	///
	Event!(Object, ThreadExceptionEventArgs) threadException;
	///
	Event!(Object, EventArgs) threadExit;
	
	
	// Returns null if not found.
	package Control lookupHwnd(HWND hwnd);
	
	
	// Also makes a great zombie.
	package void removeHwnd(HWND hwnd);
	
	
	version(DFL_NO_ZOMBIE_FORM)
	{
	}
	else
	{
		package const Dstring ZOMBIE_PROP = "DFL_Zombie";
		
		// Doesn't do any good since the child controls still reference this control.
		package void zombieHwnd(Control c);
		
		package void unzombieHwnd(Control c);
		
		// Doesn't need to be a zombie.
		package void zombieKill(Control c);
	}
	
	
	version(DFL_NO_MENUS)
	{
	}
	else
	{
		// Returns its new unique menu ID.
		package int addMenuItem(MenuItem menu);
		
		package void addContextMenu(ContextMenu menu);
		
		package void removeMenu(Menu menu);
		
		
		package MenuItem lookupMenuID(int menuID);
		
		
		package Menu lookupMenu(HMENU hmenu);
	}
	
	
	package void creatingControl(Control ctrl);
	
	
	version(DFL_NO_RESOURCES)
	{
	}
	else
	{
		///
		Resources resources();
	}
	
	
	private UINT gctimer = 0;
	private DWORD gcinfo = 1;
	
	
	///
	void autoCollect(bool byes);
	
	/// ditto
	bool autoCollect();
	
	
	package void _waitMsg();
	
	package deprecated alias _waitMsg waitMsg;
	
	
	///
	// Because waiting for an event enters an idle state,
	// this function fires the -idle- event.
	void waitForEvent();
	
	
	version(DFL_NO_COMPAT)
		package const DflCompat _compat = DflCompat.NONE;
	else
		package DflCompat _compat = DflCompat.NONE;
	
	
	deprecated void setCompat(DflCompat dflcompat);
	
	
	private static size_t _doref(void* p, int by);
	
	package size_t refCountInc(void* p);
	
	
	// Returns the new ref count.
	package size_t refCountDec(void* p);
	
	
	package void ppin(void* p);
	
	
	package void punpin(void* p);
	
	
	private:
	static:
	size_t[void*] _refs;
	IMessageFilter[] filters;
	DWORD tlsThreadFlags;
	DWORD tlsControl;
	DWORD tlsFilter; // IMessageFilter[]*.
	version(CUSTOM_MSG_HOOK)
		DWORD tlsHook; // HHOOK.
	Control[HWND] controls;
	HINSTANCE hinst;
	ApplicationContext ctx = null;
	
	version(DFL_NO_MENUS)
	{
	}
	else
	{
		ushort prevMenuID = FIRST_MENU_ID;
		// malloc() is needed so the menus can be garbage collected.
		uint nmenus = 0; // Number of -menus-.
		Menu* menus = null; // WARNING: malloc()'d memory!
		
		
		// Menus.
		const ushort FIRST_MENU_ID = 200;
		const ushort END_MENU_ID = 10000;
		
		// Controls.
		const ushort FIRST_CTRL_ID = END_MENU_ID + 1;
		const ushort LAST_CTRL_ID = 65500;
		
		
		// Destroy all menu handles at program exit because Windows will not
		// unless it is assigned to a window.
		// Note that this is probably just a 16bit issue, but it still appeared in the 32bit docs.
		private void sdtorFreeAllMenus();
	}
	
	
	private struct TlsFilterValue
	{
		IMessageFilter[] filters;
	}
	
	
	/+
	void filters(IMessageFilter[] filters);
	
	IMessageFilter[] filters() ;
	+/
	
	
	version(CUSTOM_MSG_HOOK)
	{
		void msghook(HHOOK hhook) ;
		
		
		HHOOK msghook() ;
	}
	
	
	Control getCreatingControl();
	
	
	// Thread flags.
	enum TF: DWORD
	{
		RUNNING = 1, // Application.run is in affect.
		STOP_RUNNING = 2,
		QUIT = 4, // Received WM_QUIT.
	}
	
	
	TF threadFlags();
	
	
	void threadFlags(TF flags) ;
	
	
	void gotMessage(inout Message msg);
}


package:


extern(Windows) void _gcTimeout(HWND hwnd, UINT uMsg, UINT idEvent, DWORD dwTime);

// Note: phobos-only.
debug(SHOW_MESSAGE_INFO)
{
	private import std.io, std.string;
	
	
	void showMessageInfo(inout Message m);
}


extern(Windows) LRESULT dflWndProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam);


version(CUSTOM_MSG_HOOK)
{
	typedef CWPRETSTRUCT CustomMsg;
	
	
	// Needs to be re-entrant.
	extern(Windows) LRESULT globalMsgHook(int code, WPARAM wparam, LPARAM lparam);
}
else
{
	/+
	struct CustomMsg
	{
		HWND hwnd;
		UINT message;
		WPARAM wParam;
		LPARAM lParam;
	}
	+/
}


const LRESULT LRESULT_DFL_INVOKE = 0x95FADF; // Magic number.


struct InvokeData
{
	Object delegate(Object[]) dg;
	Object[] args;
	Object result;
	Object exception = null;
}


struct InvokeSimpleData
{
	void delegate() dg;
	Object exception = null;
}


UINT wmDfl;

enum: WPARAM
{
	WPARAM_DFL_INVOKE = 78,
	WPARAM_DFL_DELAY_INVOKE = 79,
	WPARAM_DFL_DELAY_INVOKE_PARAMS = 80,
	WPARAM_DFL_INVOKE_SIMPLE = 81,
}

struct DflInvokeParam
{
	void function(Control, size_t[]) fp;
	size_t nparams;
	size_t[1] params;
}


version(DFL_NO_WM_GETCONTROLNAME)
{
}
else
{
	UINT wmGetControlName;
}


extern(Windows)
{
	alias BOOL function(LPTRACKMOUSEEVENT lpEventTrack) TrackMouseEventProc;
	alias BOOL function(HWND, COLORREF, BYTE, DWORD) SetLayeredWindowAttributesProc;
	
	alias HTHEME function(HWND) GetWindowThemeProc;
	alias BOOL function(HTHEME hTheme, int iPartId, int iStateId) IsThemeBackgroundPartiallyTransparentProc;
	alias HRESULT function(HWND hwnd, HDC hdc, RECT* prc) DrawThemeParentBackgroundProc;
	alias void function(DWORD dwFlags) SetThemeAppPropertiesProc;
}


// Set version = SUPPORTS_MOUSE_TRACKING if it is guaranteed to be supported.
TrackMouseEventProc trackMouseEvent;

// Set version = SUPPORTS_OPACITY if it is guaranteed to be supported.
SetLayeredWindowAttributesProc setLayeredWindowAttributes;

/+
GetWindowThemeProc getWindowTheme;
IsThemeBackgroundPartiallyTransparentProc isThemeBackgroundPartiallyTransparent;
DrawThemeParentBackgroundProc drawThemeParentBackground;
SetThemeAppPropertiesProc setThemeAppProperties;
+/


const Dstring CONTROL_CLASSNAME = "DFL_Control";
const Dstring FORM_CLASSNAME = "DFL_Form";
const Dstring TEXTBOX_CLASSNAME = "DFL_TextBox";
const Dstring LISTBOX_CLASSNAME = "DFL_ListBox";
//const Dstring LABEL_CLASSNAME = "DFL_Label";
const Dstring BUTTON_CLASSNAME = "DFL_Button";
const Dstring MDICLIENT_CLASSNAME = "DFL_MdiClient";
const Dstring RICHTEXTBOX_CLASSNAME = "DFL_RichTextBox";
const Dstring COMBOBOX_CLASSNAME = "DFL_ComboBox";
const Dstring TREEVIEW_CLASSNAME = "DFL_TreeView";
const Dstring TABCONTROL_CLASSNAME = "DFL_TabControl";
const Dstring LISTVIEW_CLASSNAME = "DFL_ListView";
const Dstring STATUSBAR_CLASSNAME = "DFL_StatusBar";
const Dstring PROGRESSBAR_CLASSNAME = "DFL_ProgressBar";

WNDPROC textBoxPrevWndProc;
WNDPROC listboxPrevWndProc;
//WNDPROC labelPrevWndProc;
WNDPROC buttonPrevWndProc;
WNDPROC mdiclientPrevWndProc;
WNDPROC richtextboxPrevWndProc;
WNDPROC comboboxPrevWndProc;
WNDPROC treeviewPrevWndProc;
WNDPROC tabcontrolPrevWndProc;
WNDPROC listviewPrevWndProc;
WNDPROC statusbarPrevWndProc;
WNDPROC progressbarPrevWndProc;

LONG textBoxClassStyle;
LONG listboxClassStyle;
//LONG labelClassStyle;
LONG buttonClassStyle;
LONG mdiclientClassStyle;
LONG richtextboxClassStyle;
LONG comboboxClassStyle;
LONG treeviewClassStyle;
LONG tabcontrolClassStyle;
LONG listviewClassStyle;
LONG statusbarClassStyle;
LONG progressbarClassStyle;

HMODULE hmodRichtextbox;

// DMD 0.93: CS_HREDRAW | CS_VREDRAW | CS_DBLCLKS is not an expression
//const UINT WNDCLASS_STYLE = CS_HREDRAW | CS_VREDRAW | CS_DBLCLKS;
//const UINT WNDCLASS_STYLE = 11;

//const UINT WNDCLASS_STYLE = CS_DBLCLKS;
// DMD 0.106: CS_DBLCLKS is not an expression
const UINT WNDCLASS_STYLE = 0x0008;


extern(Windows)
{
	alias BOOL function(LPINITCOMMONCONTROLSEX lpInitCtrls) InitCommonControlsExProc;
}


// For this to work properly on Windows 95, Internet Explorer 4.0 must be installed.
void _initCommonControls(DWORD dwControls);


extern(C)
{
	size_t C_refCountInc(void* p);
	
	
	// Returns the new ref count.
	size_t C_refCountDec(void* p);
}


static this()
{
	os.win.gui.x.utf._utfinit();
	
	Application.tlsThreadFlags = os.win.gui.x.winapi.TlsAlloc();
	Application.tlsControl = os.win.gui.x.winapi.TlsAlloc();
	Application.tlsFilter = os.win.gui.x.winapi.TlsAlloc();
	version(CUSTOM_MSG_HOOK)
		Application.tlsHook = os.win.gui.x.winapi.TlsAlloc();
	
	wmDfl = RegisterWindowMessageA("WM_DFL");
	if(!wmDfl)
		wmDfl = WM_USER + 0x7CD;
	
	version(DFL_NO_WM_GETCONTROLNAME)
	{
	}
	else
	{
		wmGetControlName = RegisterWindowMessageA("WM_GETCONTROLNAME");
	}
	
	//InitCommonControls(); // Done later. Needs to be linked with comctl32.lib.
	OleInitialize(null); // Needs to be linked with ole32.lib.
	
	HMODULE user32 = GetModuleHandleA("user32.dll");
	
	version(SUPPORTS_MOUSE_TRACKING)
	{
		pragma(msg, "os.win.gui: mouse tracking supported at compile time");
		
		trackMouseEvent = &TrackMouseEvent;
	}
	else
	{
		trackMouseEvent = cast(TrackMouseEventProc)GetProcAddress(user32, "TrackMouseEvent");
		if(!trackMouseEvent) // Must be Windows 95; check if common controls has it (IE 5.5).
			trackMouseEvent = cast(TrackMouseEventProc)GetProcAddress(GetModuleHandleA("comctl32.dll"), "_TrackMouseEvent");
	}
	
	version(SUPPORTS_OPACITY)
	{
		pragma(msg, "os.win.gui: opacity supported at compile time");
		
		setLayeredWindowAttributes = &SetLayeredWindowAttributes;
	}
	else
	{
		setLayeredWindowAttributes = cast(SetLayeredWindowAttributesProc)GetProcAddress(user32, "SetLayeredWindowAttributes");
	}
}


static ~this()
{
	version(DFL_NO_MENUS)
	{
	}
	else
	{
		Application.sdtorFreeAllMenus();
	}
	
	if(hmodRichtextbox)
		FreeLibrary(hmodRichtextbox);
}


void _unableToInit(Dstring what);


void _initInstance();


void _initInstance(HINSTANCE inst);


extern(Windows)
{
	void _initTextBox();
	
	void _initListbox();
	
	
	/+
	void _initLabel();
	+/
	
	
	void _initButton();
	
	
	void _initMdiclient();
	
	
	void _initRichtextbox();
	
	
	void _initCombobox();
	
	
	void _initTreeview();
	
	
	void _initTabcontrol();
	
	
	void _initListview();
	
	
	void _initStatusbar();
	
	
	void _initProgressbar();
}


WNDPROC _superClass(HINSTANCE hinst, Dstring className, Dstring newClassName, out WNDCLASSA getInfo) ;

public:

// Returns the old wndProc.
// This is the old, unsafe, unicode-unfriendly function for superclassing.
deprecated WNDPROC superClass(HINSTANCE hinst, Dstring className, Dstring newClassName, out WNDCLASSA getInfo) ;


deprecated WNDPROC superClass(HINSTANCE hinst, Dstring className, Dstring newClassName);


// Returns the old wndProc.
WNDPROC superClass(HINSTANCE hinst, Dstring className, Dstring newClassName, out os.win.gui.x.utf.WndClass getInfo);