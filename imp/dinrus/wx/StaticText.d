module wx.StaticText;
public import wx.common;
public import wx.Control;

		//! \cond EXTERN
		static extern (C) IntPtr wxStaticText_ctor();
		static extern (C) bool   wxStaticText_Create(IntPtr self, IntPtr parent, int id, string label, inout Point pos, inout Size size, uint style, string name);
		static extern (C) void   wxStaticText_Wrap(IntPtr self, int width);
		//! \endcond

		//---------------------------------------------------------------------
		
	alias StaticText wxStaticText;
	public class StaticText : Control
	{
		public const int wxST_NO_AUTORESIZE = 0x0001;
	
		public const string wxStaticTextNameStr = "message";
	
		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent, int id, string label, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, string name = wxStaticTextNameStr);
		public static wxObject New(IntPtr wxobj);
		public this(Window parent, string label, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, string name = wxStaticTextNameStr);
		public bool Create(Window parent, int id, string label, inout Point pos, inout Size size, int style, string name);
		public void Wrap(int width);
	}
