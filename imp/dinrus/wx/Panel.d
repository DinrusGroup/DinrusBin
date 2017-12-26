module wx.Panel;
public import wx.common;
public import wx.Window;
public import wx.Button;

		//! \cond EXTERN
		static extern (C) IntPtr wxPanel_ctor();
		static extern (C) IntPtr wxPanel_ctor2(IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
		static extern (C) bool wxPanel_Create(IntPtr self, IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
		static extern (C) void wxPanel_InitDialog(IntPtr self);
		static extern (C) IntPtr wxPanel_GetDefaultItem(IntPtr self);
		static extern (C) void wxPanel_SetDefaultItem(IntPtr self, IntPtr btn);
		//! \endcond

	alias Panel wxPanel;
	/// A panel is a window on which controls are placed. It is usually
	/// placed within a frame. It contains minimal extra functionality over and
	/// above its parent class wxWindow; its main purpose is to be similar in
	/// appearance and functionality to a dialog, but with the flexibility of
	/// having any window as a parent.
	public class Panel : Window
	{
		//---------------------------------------------------------------------
		
		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent, int id /*= wxID_ANY*/, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxTAB_TRAVERSAL|wxNO_BORDER, string name = wxPanelNameStr);
		public this(Window parent, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=wxTAB_TRAVERSAL|wxNO_BORDER, string name=wxPanelNameStr);
		public bool Create(Window parent, int id, inout Point pos, inout Size size, int style, string name);
		public Button DefaultItem() ;
		public void DefaultItem(Button value) ;
		public override void InitDialog();
	}
