module wx.StatusBar;
public import wx.common;
public import wx.Window;


		public const int wxST_SIZEGRIP         = 0x0010;
		public const int wxST_NO_AUTORESIZE    = 0x0001;
		
		public const int wxSB_NORMAL	= 0x000;
		public const int wxSB_FLAT	= 0x001;
		public const int wxSB_RAISED	= 0x002; 
	
		//-----------------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxStatusBar_ctor();
		static extern (C) bool   wxStatusBar_Create(IntPtr self, IntPtr parent, int id, uint style, string name);
	
		static extern (C) void   wxStatusBar_SetFieldsCount(IntPtr self, int number, int* widths);
		static extern (C) bool   wxStatusBar_GetFieldRect(IntPtr self, int i, inout Rectangle rect);
		static extern (C) int    wxStatusBar_GetBorderY(IntPtr self);
		static extern (C) IntPtr wxStatusBar_GetStatusText(IntPtr self, int number);
		static extern (C) int    wxStatusBar_GetBorderX(IntPtr self);
		static extern (C) void   wxStatusBar_SetStatusText(IntPtr self, string text, int number);
		static extern (C) void   wxStatusBar_SetStatusWidths(IntPtr self, int n, int* widths);
		
		static extern (C) int    wxStatusBar_GetFieldsCount(IntPtr self);
		static extern (C) void   wxStatusBar_PopStatusText(IntPtr self, int field);
		static extern (C) void   wxStatusBar_PushStatusText(IntPtr self, string xstring, int field);
		static extern (C) void   wxStatusBar_SetMinHeight(IntPtr self, int height);
		static extern (C) void   wxStatusBar_SetStatusStyles(IntPtr self, int n, int* styles);
		//! \endcond
	
		//-----------------------------------------------------------------------------

	alias StatusBar wxStatusBar;
	public class StatusBar : Window
	{
		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent, int id /*= wxID_ANY*/, int style = wxST_SIZEGRIP, string name="");
		public this(Window parent, int style = wxST_SIZEGRIP, string name="");
		public bool Create(Window parent, int id, int style, string name);
		public void SetFieldsCount(int number, int[] widths);
		public int FieldsCount() ;
		public int BorderY();
		public int BorderX() ;
		public bool GetFieldRect(int i, inout Rectangle rect);
		public void StatusText(string value) { SetStatusText(value); }
		public string StatusText() ;
		public void SetStatusText(string text);
		public void SetStatusText(string text, int number);
		public string GetStatusText(int number);
		public void StatusWidths(int[] value);
		public void SetStatusWidths(int n, int* widths);
		public void PopStatusText();
		public void PopStatusText(int field);
		public void PushStatusText(string xstring);
		public void PushStatusText(string xstring, int field);
		public void MinHeight(int value);
		public void StatusStyles(int[] value);

	}

