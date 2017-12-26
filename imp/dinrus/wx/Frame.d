
module wx.Frame;
public import wx.common;
public import wx.Window;
public import wx.ToolBar;
public import wx.MenuBar;
public import wx.StatusBar;
public import wx.Icon;

		//! \cond EXTERN
		static extern (C) IntPtr wxFrame_ctor();
		static extern (C) bool   wxFrame_Create(IntPtr self, IntPtr parent, int id, string title, inout Point pos, inout Size size, uint style, string name);

		static extern (C) IntPtr wxFrame_CreateStatusBar(IntPtr self, int number, uint style, int id, string name);

		static extern (C) void   wxFrame_SendSizeEvent(IntPtr self);

		static extern (C) void   wxFrame_SetIcon(IntPtr self, IntPtr icon);

		static extern (C) void   wxFrame_SetMenuBar(IntPtr self, IntPtr menuBar);
		static extern (C) IntPtr wxFrame_GetMenuBar(IntPtr self);

		static extern (C) void   wxFrame_SetStatusText(IntPtr self, string text, int number);

		static extern (C) IntPtr wxFrame_CreateToolBar(IntPtr self, uint style, int id, string name);
		static extern (C) IntPtr wxFrame_GetToolBar(IntPtr self);
		static extern (C) void   wxFrame_SetToolBar(IntPtr self, IntPtr toolbar);

		static extern (C) bool   wxFrame_ShowFullScreen(IntPtr self, bool show, uint style);
		static extern (C) bool   wxFrame_IsFullScreen(IntPtr self);

		static extern (C) IntPtr wxFrame_GetStatusBar(IntPtr wxobj);
		static extern (C) void   wxFrame_SetStatusBar(IntPtr wxobj, IntPtr statusbar);

		static extern (C) int    wxFrame_GetStatusBarPane(IntPtr wxobj);
		static extern (C) void   wxFrame_SetStatusBarPane(IntPtr wxobj, int n);

		static extern (C) void   wxFrame_SetStatusWidths(IntPtr self, int n, int* widths);

		static extern (C) void   wxFrame_Iconize(IntPtr wxobj, bool iconize);
		static extern (C) bool   wxFrame_IsIconized(IntPtr wxobj);

		static extern (C) void   wxFrame_Maximize(IntPtr wxobj, bool maximize);
		static extern (C) bool   wxFrame_IsMaximized(IntPtr wxobj);

		//static extern (C) bool   wxFrame_SetShape(IntPtr self, IntPtr region);

		static extern (C) void   wxFrame_GetClientAreaOrigin(IntPtr self, inout Point pt);
		//! \endcond

		//---------------------------------------------------------------------

	alias Frame wxFrame;
	/// A frame is a window whose size and position can (usually) be
	/// changed by the user. It usually has thick borders and a title bar,
	/// and can optionally contain a menu bar, toolbar and status bar.
	/// A frame can contain any window that is not a frame or dialog.
	public class Frame : Window
	{
		public const int wxFULLSCREEN_NOMENUBAR   = 0x0001;
		public const int wxFULLSCREEN_NOTOOLBAR   = 0x0002;
		public const int wxFULLSCREEN_NOSTATUSBAR = 0x0004;
		public const int wxFULLSCREEN_NOBORDER    = 0x0008;
		public const int wxFULLSCREEN_NOCAPTION   = 0x0010;
		public const int wxFULLSCREEN_ALL         =
                    wxFULLSCREEN_NOMENUBAR | wxFULLSCREEN_NOTOOLBAR |
                    wxFULLSCREEN_NOSTATUSBAR | wxFULLSCREEN_NOBORDER |
                    wxFULLSCREEN_NOCAPTION;

		//-----------------------------------------------------------------------------
		const string wxFrameNameStr="frame";

		public this(IntPtr wxobj);
		public this();
		public this(Window parent, int id, string title, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=wxDEFAULT_FRAME_STYLE, string name=wxFrameNameStr);
		public this(Window parent, string title, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=wxDEFAULT_FRAME_STYLE, string name=wxFrameNameStr);
		public bool Create(Window parent, int id, string title, inout Point pos, inout Size size, int style, string name);
		public this(string title, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=wxDEFAULT_FRAME_STYLE);
		public bool ShowFullScreen(bool show, int style);
		public bool ShowFullScreen(bool show);
		public bool IsFullScreen() ;
		public StatusBar CreateStatusBar();
		public StatusBar CreateStatusBar(int number);
		public StatusBar CreateStatusBar(int number, int style);
		public StatusBar CreateStatusBar(int number, int style, int id);
		public StatusBar CreateStatusBar(int number, int style, int id, string name);
		public StatusBar statusBar() ;
		public void statusBar(StatusBar value) ;
		public int StatusBarPane();
		public void StatusBarPane(int value);
		public void SendSizeEvent();
		public void icon(Icon value) ;
		public void menuBar(MenuBar value) ;
		public MenuBar menuBar();
		public void StatusText(string value) ;
		public void SetStatusText(string text);
		public void SetStatusText(string text, int number);
		public void StatusWidths(int[] value);
		public void SetStatusWidths(int n, int[] widths);
		public ToolBar CreateToolBar();
		public ToolBar CreateToolBar(int style);
		public ToolBar CreateToolBar(int style, int id);
		public ToolBar CreateToolBar(int style, int id, string name);
		public ToolBar toolBar() ;
		public void toolBar(ToolBar value);
		public bool Iconized() ;
		public void Iconized(bool value) ;
		public bool Maximized();
		public void Maximized(bool value);
		//public bool SetShape(wx.Region region);
		public override Point ClientAreaOrigin();
		override public /+virtual+/ bool Close();
        override public /+virtual+/ bool Close(bool force);
	}
