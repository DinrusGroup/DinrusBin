module wx.StaticBitmap;
public import wx.common;
public import wx.Control;

		//! \cond EXTERN
		static extern (C) IntPtr wxStaticBitmap_ctor();
		static extern (C) bool wxStaticBitmap_Create(IntPtr self, IntPtr parent, int id, IntPtr label, inout Point pos, inout Size size, uint style, string name);
		static extern (C) void wxStaticBitmap_SetBitmap(IntPtr self, IntPtr bitmap);
		static extern (C) IntPtr wxStaticBitmap_GetBitmap(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------

	alias StaticBitmap wxStaticBitmap;
	public class StaticBitmap : Control
	{
		public const string wxStaticBitmapNameStr = "message";

		public this();
		public this(IntPtr wxobj) ;
		public this(Window parent, int id, Bitmap label, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, string name = wxStaticBitmapNameStr);
		public static wxObject New(IntPtr wxobj) ;
		public this(Window parent, Bitmap label, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, string name = wxStaticBitmapNameStr);
		public bool Create(Window parent, int id, Bitmap label, inout Point pos, inout Size size, int style, string name);
		public void bitmap(Bitmap value) ;
		public Bitmap bitmap() ;
	}
