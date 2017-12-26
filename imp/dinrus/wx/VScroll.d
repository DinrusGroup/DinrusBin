module wx.VScroll;
public import wx.common;
public import wx.Panel;
public import wx.SizeEvent;

		//-----------------------------------------------------------------------------
		
		//! \cond EXTERN
		extern (C) {
		alias int function(VScrolledWindow obj, int n) Virtual_IntInt;
		}

		static extern (C) IntPtr wxVScrolledWindow_ctor();
		static extern (C) IntPtr wxVScrolledWindow_ctor2(IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
		static extern (C) void wxVScrolledWindow_RegisterVirtual(IntPtr self, VScrolledWindow obj, Virtual_IntInt onGetLineHeight);
		static extern (C) bool wxVScrolledWindow_Create(IntPtr self,IntPtr parent, int id, inout Point pos, inout Size size, int style, string name);
		static extern (C) void wxVScrolledWindow_SetLineCount(IntPtr self, int count);
		static extern (C) bool wxVScrolledWindow_ScrollToLine(IntPtr self, int line);
		static extern (C) bool wxVScrolledWindow_ScrollLines(IntPtr self, int lines);
		static extern (C) bool wxVScrolledWindow_ScrollPages(IntPtr self, int pages);
		static extern (C) void wxVScrolledWindow_RefreshLine(IntPtr self, int line);
		static extern (C) void wxVScrolledWindow_RefreshLines(IntPtr self, int from, int to);
		static extern (C) int wxVScrolledWindow_HitTest(IntPtr self, int x, int y);
		static extern (C) int wxVScrolledWindow_HitTest2(IntPtr self, inout Point pt);
		static extern (C) void wxVScrolledWindow_RefreshAll(IntPtr self);
		static extern (C) int wxVScrolledWindow_GetLineCount(IntPtr self);
		static extern (C) int wxVScrolledWindow_GetFirstVisibleLine(IntPtr self);
		static extern (C) int wxVScrolledWindow_GetLastVisibleLine(IntPtr self);
		static extern (C) bool wxVScrolledWindow_IsVisible(IntPtr self, int line);
		//! \endcond
		
		//-----------------------------------------------------------------------------
		
	public abstract class VScrolledWindow : Panel
	{
		public this(IntPtr wxobj);
		public this() ;
		public this(Window parent, int id /*= wxID_ANY*/, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style=0, string name = wxPanelNameStr);
		public this(Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style=0, string name = wxPanelNameStr);
		public override bool Create(Window parent, int id, inout Point pos, inout Size size, int style, string name);
		static extern(C) private int staticOnGetLineHeight(VScrolledWindow obj, int n);
		protected abstract int OnGetLineHeight(int n);		
		public void LineCount(int value) ;
		public int LineCount();		
		public void ScrollToLine(int line);
		public override bool ScrollLines(int lines);
		public override bool ScrollPages(int pages);
		public void RefreshLine(int line);
		public void RefreshLines(int from, int to);
		public int HitTest(int x, int y);
		public int HitTest(Point pt);
		public /+virtual+/ void RefreshAll();
		public int GetFirstVisibleLine();
		public int GetLastVisibleLine();
		public bool IsVisible(int line);
	}
