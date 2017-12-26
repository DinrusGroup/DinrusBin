module wx.SplitterWindow;
public import wx.common;
public import wx.Window;

	public enum SplitMode
	{
		wxSPLIT_HORIZONTAL	= 1,
		wxSPLIT_VERTICAL
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		extern (C) {
		alias void function(SplitterWindow obj, int x, int y) Virtual_OnDoubleClickSash;
		alias void function(SplitterWindow obj, IntPtr removed) Virtual_OnUnsplit;
		alias bool function(SplitterWindow obj, int newSashPosition) Virtual_OnSashPositionChange;
		}
		
		static extern (C) IntPtr wxSplitWnd_ctor(IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
		static extern (C) void   wxSplitWnd_RegisterVirtual(IntPtr self, SplitterWindow obj, Virtual_OnDoubleClickSash onDoubleClickSash, Virtual_OnUnsplit onUnsplit, Virtual_OnSashPositionChange onSashPositionChange);
		static extern (C) void   wxSplitWnd_OnDoubleClickSash(IntPtr self, int x, int y);
		static extern (C) void   wxSplitWnd_OnUnsplit(IntPtr self, IntPtr removed);
		static extern (C) bool   wxSplitWnd_OnSashPositionChange(IntPtr self, int newSashPosition);
		static extern (C) int    wxSplitWnd_GetSplitMode(IntPtr self);
		static extern (C) bool   wxSplitWnd_IsSplit(IntPtr self);
		static extern (C) bool   wxSplitWnd_SplitHorizontally(IntPtr self, IntPtr wnd1, IntPtr wnd2, int sashPos);
		static extern (C) bool   wxSplitWnd_SplitVertically(IntPtr self, IntPtr wnd1, IntPtr wnd2, int sashPos);
		static extern (C) bool   wxSplitWnd_Unsplit(IntPtr self, IntPtr toRemove);
		static extern (C) void   wxSplitWnd_SetSashPosition(IntPtr self, int position, bool redraw);
		static extern (C) int    wxSplitWnd_GetSashPosition(IntPtr self);
		
		static extern (C) int    wxSplitWnd_GetMinimumPaneSize(IntPtr self);
		static extern (C) IntPtr wxSplitWnd_GetWindow1(IntPtr self);
		static extern (C) IntPtr wxSplitWnd_GetWindow2(IntPtr self);
		static extern (C) void   wxSplitWnd_Initialize(IntPtr self, IntPtr window);
		static extern (C) bool   wxSplitWnd_ReplaceWindow(IntPtr self, IntPtr winOld, IntPtr winNew);
		static extern (C) void   wxSplitWnd_SetMinimumPaneSize(IntPtr self, int paneSize);
		static extern (C) void   wxSplitWnd_SetSplitMode(IntPtr self, int mode);
		static extern (C) void   wxSplitWnd_UpdateSize(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------

	alias SplitterWindow wxSplitterWindow;
	public class SplitterWindow : Window
	{
		enum {
			wxSP_3DBORDER		= 0x00000200,
			wxSP_LIVE_UPDATE	= 0x00000080,
			wxSP_3DSASH		= 0x00000100,
			wxSP_3D			= (wxSP_3DBORDER | wxSP_3DSASH),
		}
		
		//---------------------------------------------------------------------

		public this(Window parent, int id /*= wxID_ANY*/, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxSP_3D, string name="splitter");
		public this(Window parent, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=wxSP_3D, string name="splitter");
		static extern(C) private void staticOnDoubleClickSash(SplitterWindow obj, int x, int y);
		public /+virtual+/ void OnDoubleClickSash(int x, int y);
		static extern(C) private void staticDoOnUnsplit(SplitterWindow obj, IntPtr removed);
		public /+virtual+/ void OnUnsplit(Window removed);
		static extern(C) private bool staticOnSashPositionChange(SplitterWindow obj, int newSashPosition);
		public /+virtual+/ bool OnSashPositionChange(int newSashPosition);
		public bool IsSplit() ;
		public bool SplitHorizontally(Window wnd1, Window wnd2, int sashPos=0);
		public SplitMode splitMode() ;
		public void splitMode(SplitMode value);
		public bool SplitVertically(Window wnd1, Window wnd2, int sashPos=0);
		public bool Unsplit(Window toRemove=null);
		public void SashPosition(int value);
		public int SashPosition();
		public void SetSashPosition(int position, bool redraw=true);
		public int MinimumPaneSize();
		public void MinimumPaneSize(int value) ;
		public static wxObject myNew(IntPtr ptr) ;
		public Window Window1() ;
		public Window Window2();
		public void Initialize(Window window);
		public bool ReplaceWindow(Window winOld, Window winNew);
		public void UpdateSize();
	}
