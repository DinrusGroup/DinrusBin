module wx.Button;
public import wx.common;
public import wx.Control;
public import wx.Bitmap;

		//! \cond EXTERN
		static extern (C) IntPtr wxButton_ctor();
		static extern (C) bool   wxButton_Create(IntPtr self, IntPtr parent, int id, string label, inout Point pos, inout Size size, uint style, IntPtr validator, string name);
		static extern (C) void   wxButton_SetDefault(IntPtr self);
		static extern (C) void   wxButton_GetDefaultSize(out Size size);
		
		static extern (C) void wxButton_SetImageMargins(IntPtr self, int x, int y);
		static extern (C) void wxButton_SetImageLabel(IntPtr self, IntPtr bitmap);
		
		static extern (C) void wxButton_SetLabel(IntPtr self, string label);
		//! \endcond

		//---------------------------------------------------------------------

	alias Button wxButton;
	public class Button : Control
	{
		public const int wxBU_LEFT          =  0x0040;
		public const int wxBU_TOP           =  0x0080;
		public const int wxBU_RIGHT         =  0x0100;
		public const int wxBU_BOTTOM        =  0x0200;
		public const int wxBU_EXACTFIT      =  0x0001;

		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent, int id, string label = "", Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, Validator validator = null, string name = null);
		public static wxObject New(IntPtr wxobj);
		public this(Window parent, string label, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, Validator validator = null, string name = null);
		public bool Create(Window parent, int id, string label, Point pos, Size size, int style, Validator validator, string name);
		public void SetDefault();
		public static Size GetDefaultSize();
		public /+virtual+/ void ImageLabel(Bitmap value);
		public /+virtual+/ void SetImageMargins(int x, int y);
		public override void Label(string value);
		public void Click_Add(EventListener value) ;
		public void Click_Remove(EventListener value) ;
	}

