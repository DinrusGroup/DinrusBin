
module wx.SashWindow;
public import wx.common;
public import wx.Window;
public import wx.CommandEvent;

	public enum SashEdgePosition 
	{
		wxSASH_TOP = 0,
		wxSASH_RIGHT,
		wxSASH_BOTTOM,
		wxSASH_LEFT,
		wxSASH_NONE = 100
	}
	
	//-----------------------------------------------------------------------------
	
	public enum SashDragStatus
	{
		wxSASH_STATUS_OK,
		wxSASH_STATUS_OUT_OF_RANGE
	}
		
	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxSashEdge_ctor();
		static extern (C) void wxSashEdge_dtor(IntPtr self);
		static extern (C) bool wxSashEdge_m_show(IntPtr self);
		static extern (C) bool wxSashEdge_m_border(IntPtr self);
		static extern (C) int wxSashEdge_m_margin(IntPtr self);
		//! \endcond
		
		//-----------------------------------------------------------------------------
	
	alias SashEdge wxSashEdge;
	public class SashEdge : wxObject
	{
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);			
		public this();
		override protected void dtor();
		public bool m_show() ;
		public bool m_border() ;
		public int m_margin() ;
	}
	
	//-----------------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxSashWindow_ctor();
		static extern (C) bool wxSashWindow_Create(IntPtr self, IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
		static extern (C) void wxSashWindow_SetSashVisible(IntPtr self, SashEdgePosition edge, bool sash);
		static extern (C) bool wxSashWindow_GetSashVisible(IntPtr self, SashEdgePosition edge);
		static extern (C) void wxSashWindow_SetSashBorder(IntPtr self, SashEdgePosition edge, bool border);
		static extern (C) bool wxSashWindow_HasBorder(IntPtr self, SashEdgePosition edge);
		static extern (C) int wxSashWindow_GetEdgeMargin(IntPtr self, SashEdgePosition edge);
		static extern (C) void wxSashWindow_SetDefaultBorderSize(IntPtr self, int width);
		static extern (C) int wxSashWindow_GetDefaultBorderSize(IntPtr self);
		static extern (C) void wxSashWindow_SetExtraBorderSize(IntPtr self, int width);
		static extern (C) int wxSashWindow_GetExtraBorderSize(IntPtr self);
		static extern (C) void wxSashWindow_SetMinimumSizeX(IntPtr self, int min);
		static extern (C) void wxSashWindow_SetMinimumSizeY(IntPtr self, int min);
		static extern (C) int wxSashWindow_GetMinimumSizeX(IntPtr self);
		static extern (C) int wxSashWindow_GetMinimumSizeY(IntPtr self);
		static extern (C) void wxSashWindow_SetMaximumSizeX(IntPtr self, int max);
		static extern (C) void wxSashWindow_SetMaximumSizeY(IntPtr self, int max);
		static extern (C) int wxSashWindow_GetMaximumSizeX(IntPtr self);
		static extern (C) int wxSashWindow_GetMaximumSizeY(IntPtr self);
		//! \endcond
		
		//-----------------------------------------------------------------------------
		
	alias SashWindow wxSashWindow;
	public class SashWindow : Window
	{
		enum {
			wxSW_NOBORDER	= 0x0000,
			wxSW_BORDER	= 0x0020,
			wxSW_3DSASH	= 0x0040,
			wxSW_3DBORDER	= 0x0080,
			wxSW_3D	= wxSW_3DSASH | wxSW_3DBORDER,
		}
		enum {
			wxSASH_DRAG_NONE	= 0,
			wxSASH_DRAG_DRAGGING	= 1,
			wxSASH_DRAG_LEFT_DOWN	= 2,
		}

		//-----------------------------------------------------------------------------
	
		public this(IntPtr wxobj);
		public this();
		public this(Window parent, int id /*= wxID_ANY*/, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=wxSW_3D|wxCLIP_CHILDREN, string name="sashWindow");
		public this(Window parent, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=wxSW_3D|wxCLIP_CHILDREN, string name="sashWindow");
		public bool Create(Window parent, int id, inout Point pos, inout Size size, int style, string name);
		public void SetSashVisible(SashEdgePosition edge, bool sash);
		public bool GetSashVisible(SashEdgePosition edge);
		public void SetSashBorder(SashEdgePosition edge, bool border);
		public int GetEdgeMargin(SashEdgePosition edge);
		public int DefaultBorderSize() ;
		public void DefaultBorderSize(int value);
		public int ExtraBorderSize();
		public void ExtraBorderSize(int value);
		public int MinimumSizeX();
		public void MinimumSizeX(int value) ;
		public int MinimumSizeY();
		public void MinimumSizeY(int value);
		public int MaximumSizeX() ;
		public void MaximumSizeX(int value) ;
		public int MaximumSizeY();
		public void MaximumSizeY(int value);
	}
	
	//-----------------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxSashEvent_ctor(int id, SashEdgePosition edge);
		static extern (C) void wxSashEvent_SetEdge(IntPtr self, SashEdgePosition edge);
		static extern (C) SashEdgePosition wxSashEvent_GetEdge(IntPtr self);
		static extern (C) void wxSashEvent_SetDragRect(IntPtr self, inout Rectangle rect);
		static extern (C) void wxSashEvent_GetDragRect(IntPtr self, out Rectangle rect);
		static extern (C) void wxSashEvent_SetDragStatus(IntPtr self, SashDragStatus status);
		static extern (C) SashDragStatus wxSashEvent_GetDragStatus(IntPtr self);
		//! \endcond
	
	alias SashEvent wxSashEvent;
	public class SashEvent : CommandEvent
	{
		public this(IntPtr wxobj);
		public this();
		public this(int id);
		public this(int id, SashEdgePosition edge);
		public SashEdgePosition Edge() ;
		public void Edge(SashEdgePosition value) ;
		public Rectangle DragRect() ;
		public void DragRect(Rectangle value) ;
		public SashDragStatus DragStatus() ;
		public void DragStatus(SashDragStatus value) ;
		private static Event New(IntPtr obj) ;
		static this();
	}
