module wx.ScrolledWindow;
public import wx.common;
public import wx.Panel;

		//! \cond EXTERN
		static extern (C) IntPtr wxScrollWnd_ctor(IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
		static extern (C) void   wxScrollWnd_PrepareDC(IntPtr self, IntPtr dc);
		static extern (C) void   wxScrollWnd_SetScrollbars(IntPtr self, int pixX, int pixY, int numX, int numY, int x, int y, bool noRefresh);
		static extern (C) void   wxScrollWnd_GetViewStart(IntPtr self, inout int x, inout int y);
		static extern (C) void   wxScrollWnd_GetScrollPixelsPerUnit(IntPtr self, inout int xUnit, inout int yUnit);
		
		static extern (C) void   wxScrollWnd_CalcScrolledPosition(IntPtr self, int x, int y, inout int xx, inout int yy);
		static extern (C) void   wxScrollWnd_CalcUnscrolledPosition(IntPtr self, int x, int y, inout int xx, inout int yy);
		static extern (C) void   wxScrollWnd_GetVirtualSize(IntPtr self, inout int x, inout int y);
		static extern (C) void   wxScrollWnd_Scroll(IntPtr self, int x, int y);
		static extern (C) void   wxScrollWnd_SetScrollRate(IntPtr self, int xstep, int ystep);
		static extern (C) void   wxScrollWnd_SetTargetWindow(IntPtr self, IntPtr window);
		//! \endcond

		//---------------------------------------------------------------------

	alias ScrolledWindow wxScrolledWindow;
	public class ScrolledWindow : Panel
	{
		enum {
			wxScrolledWindowStyle = (wxHSCROLL | wxVSCROLL),
		}
	
		public this(IntPtr wxobj) ;
		public this(Window parent, int id /*= wxID_ANY*/, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxScrolledWindowStyle, string name = wxPanelNameStr);
		public this(Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxScrolledWindowStyle, string name = wxPanelNameStr);
		public /+virtual+/ void OnDraw(DC dc);
		public override void PrepareDC(DC dc);
		public void SetScrollbars(int pixelsPerUnitX, int pixelsPerUnitY, int noUnitsX, int noUnitsY);
		public void SetScrollbars(int pixelsPerUnitX, int pixelsPerUnitY, int noUnitsX, int noUnitsY, int x, int y);
		public void SetScrollbars(int pixelsPerUnitX, int pixelsPerUnitY, int noUnitsX, int noUnitsY, int x, int y, bool noRefresh);
		private void OnPaint(Object sender, Event e);
		public Point ViewStart();
		public void GetViewStart(inout int x, inout int y);
		public void GetScrollPixelsPerUnit(inout int xUnit, inout int yUnit);
		public void CalcScrolledPosition(int x, int y, inout int xx, inout int yy);
		public void CalcUnscrolledPosition(int x, int y, inout int xx, inout int yy);
		public void GetVirtualSize(inout int x, inout int y);
		public void Scroll(int x, int y);
		public void SetScrollRate(int xstep, int ystep);
		public void TargetWindow(Window value) ;
	}
