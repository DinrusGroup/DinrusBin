module  wx.MDI;
public import wx.common;
public import wx.Frame;

		//! \cond EXTERN
		extern (C) {
		alias IntPtr function(MDIParentFrame obj) Virtual_OnCreateClient;
		}

		static extern (C) IntPtr wxMDIParentFrame_ctor();
		static extern (C) void wxMDIParentFrame_RegisterVirtual(IntPtr self, MDIParentFrame obj, Virtual_OnCreateClient onCreateClient);
		static extern (C) IntPtr wxMDIParentFrame_OnCreateClient(IntPtr self);
		static extern (C) bool   wxMDIParentFrame_Create(IntPtr self, IntPtr parent, int id, string title, inout Point pos, inout Size size, uint style, string name);

		static extern (C) IntPtr wxMDIParentFrame_GetActiveChild(IntPtr self);
		//static extern (C) void   wxMDIParentFrame_SetActiveChild(IntPtr self, IntPtr pChildFrame);

		static extern (C) IntPtr wxMDIParentFrame_GetClientWindow(IntPtr self);

		static extern (C) void   wxMDIParentFrame_Cascade(IntPtr self);
		static extern (C) void   wxMDIParentFrame_Tile(IntPtr self);

		static extern (C) void   wxMDIParentFrame_ArrangeIcons(IntPtr self);

		static extern (C) void   wxMDIParentFrame_ActivateNext(IntPtr self);
		static extern (C) void   wxMDIParentFrame_ActivatePrevious(IntPtr self);

		static extern (C) void   wxMDIParentFrame_GetClientSize(IntPtr self, out int width, out int height);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias MDIParentFrame wxMDIParentFrame;
	public class MDIParentFrame : Frame
	{
		enum { wxDEFAULT_MDI_FRAME_STYLE = wxDEFAULT_FRAME_STYLE | wxVSCROLL | wxHSCROLL }

		//-----------------------------------------------------------------------------

		public this(IntPtr wxobj);
		public this();
		public this(Window parent, int id, string title, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=wxDEFAULT_MDI_FRAME_STYLE, string name=wxFrameNameStr);
		public this(Window parent, string title, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=wxDEFAULT_MDI_FRAME_STYLE, string name=wxFrameNameStr);
		public override bool Create(Window parent, int id, string title, inout Point pos, inout Size size, int style, string name);
		static extern(C) private IntPtr staticDoOnCreateClient(MDIParentFrame obj);
		public /+virtual+/ MDIClientWindow OnCreateClient();
		public MDIChildFrame GetActiveChild();
		//public void SetActiveChild(MDIChildFrame pChildFrame);
		public MDIClientWindow GetClientWindow();
		public /+virtual+/ void Cascade();
		public /+virtual+/ void Tile();
		public /+virtual+/ void ArrangeIcons();
		public /+virtual+/ void ActivateNext();
		public /+virtual+/ void ActivatePrevious();
		public /+virtual+/ void GetClientSize(out int width, out int height);
	}

		//! \cond EXTERN
		static extern (C) IntPtr wxMDIChildFrame_ctor();
		static extern (C) bool   wxMDIChildFrame_Create(IntPtr self, IntPtr parent, int id, string title, inout  Point pos, inout Size size, uint style, string name);
		static extern (C) void   wxMDIChildFrame_Activate(IntPtr self);
		static extern (C) void   wxMDIChildFrame_Restore(IntPtr self);
		static extern (C) void   wxMDIChildFrame_Maximize(IntPtr self, bool maximize);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias MDIChildFrame wxMDIChildFrame;
	public class MDIChildFrame : Frame
	{
		public this(IntPtr wxobj) ;
		public this();
		public this(MDIParentFrame parent, int id, string title, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style=wxDEFAULT_FRAME_STYLE, string name=wxFrameNameStr);
		static wxObject New(IntPtr ptr);
		public this(MDIParentFrame parent, string title, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style=wxDEFAULT_FRAME_STYLE, string name=wxFrameNameStr);
		public bool Create(MDIParentFrame parent, int id, string title, inout Point pos, inout Size size, int style, string name);
		public /+virtual+/ void Activate();
		public /+virtual+/ void Restore();
		public /+virtual+/ void OnActivate(Object sender, Event e);
		public /+virtual+/ void Maximize();
	}

		//! \cond EXTERN
		static extern (C) IntPtr wxMDIClientWindow_ctor();
		static extern (C) bool   wxMDIClientWindow_CreateClient(IntPtr self, IntPtr parent, uint style);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias MDIClientWindow wxMDIClientWindow;
	public class MDIClientWindow : Window
	{
		public this(IntPtr wxobj);
		public  this();
		public this(MDIParentFrame parent, int style=0);
		static wxObject New(IntPtr ptr);
		public bool CreateClient(MDIParentFrame parent, int style);
	}

