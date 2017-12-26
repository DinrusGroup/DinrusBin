module wx.LayoutWin;
public import wx.common;
public import wx.SashWindow;
public import wx.Event;
public import wx.Frame;
public import wx.MDI;

	public enum LayoutOrientation
	{
		wxLAYOUT_HORIZONTAL,
		wxLAYOUT_VERTICAL
	}
	
	//-----------------------------------------------------------------------------

	public enum LayoutAlignment
	{
		wxLAYOUT_NONE,
		wxLAYOUT_TOP,
		wxLAYOUT_LEFT,
		wxLAYOUT_RIGHT,
		wxLAYOUT_BOTTOM
	}
	
	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxSashLayoutWindow_ctor();
		static extern (C) bool wxSashLayoutWindow_Create(IntPtr self, IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
		static extern (C) LayoutAlignment wxSashLayoutWindow_GetAlignment(IntPtr self);
		static extern (C) LayoutOrientation wxSashLayoutWindow_GetOrientation(IntPtr self);
		static extern (C) void wxSashLayoutWindow_SetAlignment(IntPtr self, LayoutAlignment alignment);
		static extern (C) void wxSashLayoutWindow_SetOrientation(IntPtr self, LayoutOrientation orient);
		static extern (C) void wxSashLayoutWindow_SetDefaultSize(IntPtr self, inout Size size);
		//! \endcond
		
		//-----------------------------------------------------------------------------
	
	alias SashLayoutWindow wxSashLayoutWindow;
	public class SashLayoutWindow : SashWindow
	{
		public this(IntPtr wxobj);
		public this();
		public this(Window parent, int id /*= wxID_ANY*/, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style=wxSW_3D|wxCLIP_CHILDREN, string name = "layoutWindow");
		public this(Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style=wxSW_3D|wxCLIP_CHILDREN, string name = "layoutWindow");
		public override bool Create(Window parent, int id, inout Point pos, inout Size size, int style, string name);
		public LayoutAlignment Alignment();
		public void Alignment(LayoutAlignment value) ;
		public LayoutOrientation Orientation() ;
		public void Orientation(LayoutOrientation value) ;
		public void DefaultSize(Size value) ;
	}
	
	//-----------------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxLayoutAlgorithm_ctor();
		static extern (C) bool wxLayoutAlgorithm_LayoutMDIFrame(IntPtr self, IntPtr frame, inout Rectangle rect);
		static extern (C) bool wxLayoutAlgorithm_LayoutFrame(IntPtr self, IntPtr frame, IntPtr mainWindow);
		static extern (C) bool wxLayoutAlgorithm_LayoutWindow(IntPtr self, IntPtr frame, IntPtr mainWindow);
		//! \endcond
		
		//-----------------------------------------------------------------------------
		
	alias LayoutAlgorithm wxLayoutAlgorithm;
	public class LayoutAlgorithm : wxObject
	{
		public this(IntPtr wxobj);
		public this();
		public bool LayoutMDIFrame(MDIParentFrame frame);
		public bool LayoutMDIFrame(MDIParentFrame frame, Rectangle rect);
		public bool LayoutFrame(Frame frame);
		public bool LayoutFrame(Frame frame, Window mainWindow);
		public bool LayoutWindow(Window frame);
		public bool LayoutWindow(Window frame, Window mainWindow);
	}
	
	//-----------------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxQueryLayoutInfoEvent_ctor(int id);
		static extern (C) void wxQueryLayoutInfoEvent_SetRequestedLength(IntPtr self, int length);
		static extern (C) int wxQueryLayoutInfoEvent_GetRequestedLength(IntPtr self);
		static extern (C) void wxQueryLayoutInfoEvent_SetFlags(IntPtr self, int flags);
		static extern (C) int wxQueryLayoutInfoEvent_GetFlags(IntPtr self);
		static extern (C) void wxQueryLayoutInfoEvent_SetSize(IntPtr self, inout Size size);
		static extern (C) void wxQueryLayoutInfoEvent_GetSize(IntPtr self, out Size size);
		static extern (C) void wxQueryLayoutInfoEvent_SetOrientation(IntPtr self, LayoutOrientation orient);
		static extern (C) LayoutOrientation wxQueryLayoutInfoEvent_GetOrientation(IntPtr self);
		static extern (C) void wxQueryLayoutInfoEvent_SetAlignment(IntPtr self, LayoutAlignment alignment);
		static extern (C) LayoutAlignment wxQueryLayoutInfoEvent_GetAlignment(IntPtr self);
		//! \endcond
	
		//-----------------------------------------------------------------------------
		
	alias QueryLayoutInfoEvent wxQueryLayoutInfoEvent;
	public class QueryLayoutInfoEvent : Event
	{
		public this(IntPtr wxobj);
		public this();
		public this(int id);
		public int RequestedLength();
		public void RequestedLength(int value) ;
		public int Flags() ;
		public void Flags(int value);
		public Size size() ;
		public void size(Size value) ;
		public LayoutOrientation Orientation();
		public void Orientation(LayoutOrientation value) ;
		public LayoutAlignment Alignment() ;
		public void Alignment(LayoutAlignment value) ;
		private static Event New(IntPtr obj) ;
		static this()
		{
			wxEVT_QUERY_LAYOUT_INFO = wxEvent_EVT_QUERY_LAYOUT_INFO();

			AddEventType(wxEVT_QUERY_LAYOUT_INFO,               &QueryLayoutInfoEvent.New);
		}
	}
	
	//-----------------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxCalculateLayoutEvent_ctor(int id);
		static extern (C) void wxCalculateLayoutEvent_SetFlags(IntPtr self, int flags);
		static extern (C) int wxCalculateLayoutEvent_GetFlags(IntPtr self);
		static extern (C) void wxCalculateLayoutEvent_SetRect(IntPtr self, inout Rectangle rect);
		static extern (C) void wxCalculateLayoutEvent_GetRect(IntPtr self, out Rectangle rect);
		//! \endcond
		
		//-----------------------------------------------------------------------------
	
	alias CalculateLayoutEvent wxCalculateLayoutEvent;
	public class CalculateLayoutEvent : Event
	{
		public this(IntPtr wxobj);
		public this();
		public this(int id);
		public int Flags();
		public void Flags(int value);
		public Rectangle Rect();
		public void Rect(Rectangle value);
		private static Event New(IntPtr obj);
		static this()
		{
			wxEVT_CALCULATE_LAYOUT = wxEvent_EVT_CALCULATE_LAYOUT();

			AddEventType(wxEVT_CALCULATE_LAYOUT,                &CalculateLayoutEvent.New);
		}
	}
