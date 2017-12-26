module wx.BitmapButton;
public import wx.common;
public import wx.Bitmap;
public import wx.Button;
public import wx.Control;

		//! \cond EXTERN
		extern (C) {
		alias void function(BitmapButton obj) Virtual_OnSetBitmap;
		}
		
		static extern (C) IntPtr wxBitmapButton_ctor();
		static extern (C) void   wxBitmapButton_RegisterVirtual(IntPtr self, BitmapButton obj,Virtual_OnSetBitmap onSetBitmap);
		//static extern (C) void   wxBitmapButton_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
		static extern (C) bool   wxBitmapButton_Create(IntPtr self, IntPtr parent, int id, IntPtr label, inout Point pos, inout Size size, uint style, IntPtr validator, string name);
		static extern (C) void   wxBitmapButton_SetDefault(IntPtr self);
		
		static extern (C) void wxBitmapButton_SetLabel(IntPtr self, string label);
		static extern (C) IntPtr wxBitmapButton_GetLabel(IntPtr self);
		
		static extern (C) bool wxBitmapButton_Enable(IntPtr self, bool enable);

		static extern (C) void   wxBitmapButton_SetBitmapLabel(IntPtr self, IntPtr bitmap);
		static extern (C) IntPtr wxBitmapButton_GetBitmapLabel(IntPtr self);
		
		static extern (C) void wxBitmapButton_SetBitmapSelected(IntPtr self, IntPtr bitmap);
		static extern (C) IntPtr wxBitmapButton_GetBitmapSelected(IntPtr self);

		static extern (C) void wxBitmapButton_SetBitmapFocus(IntPtr self, IntPtr bitmap);
		static extern (C) IntPtr wxBitmapButton_GetBitmapFocus(IntPtr self);

		static extern (C) void wxBitmapButton_SetBitmapDisabled(IntPtr self, IntPtr bitmap);
		static extern (C) IntPtr wxBitmapButton_GetBitmapDisabled(IntPtr self);
		
		static extern (C) void wxBitmapButton_OnSetBitmap(IntPtr self);
		
		//static extern (C) void wxBitmapButton_ApplyParentThemeBackground(IntPtr self, IntPtr colour);
		//! \endcond

		//---------------------------------------------------------------------
		
		public const int wxBU_AUTODRAW      =  0x0004;
		
		//---------------------------------------------------------------------
		
	alias BitmapButton wxBitmapButton;
	public class BitmapButton : Control
	{
		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent, int id, Bitmap label);
		public this(Window parent, int id, Bitmap label, Point pos);
		public this(Window parent, int id, Bitmap label, Point pos, Size size);
		public this(Window parent, int id, Bitmap label, Point pos, Size size, int style);
		public this(Window parent, int id, Bitmap label, Point pos, Size size, int style, Validator validator);
		public this(Window parent, int id, Bitmap label, Point pos, Size size, int style, Validator validator, string name);
		public static wxObject New(IntPtr wxobj) ;
	
		//---------------------------------------------------------------------
		// ctors with self created id
			
		public this(Window parent, Bitmap label);
		public this(Window parent, Bitmap label, Point pos);
		public this(Window parent, Bitmap label, Point pos, Size size);
		public this(Window parent, Bitmap label, Point pos, Size size, int style);
		public this(Window parent, Bitmap label, Point pos, Size size, int style, Validator validator);
		public this(Window parent, Bitmap label, Point pos, Size size, int style, Validator validator, string name);
		//---------------------------------------------------------------------
		
		public bool Create(Window parent, int id, Bitmap label, Point pos, Size size, uint style, Validator validator, string name);
		public void SetDefault();
		public string StringLabel() ;
		public void StringLabel(string value);		
		public void SetLabel(string label);
		public string GetLabel();
		public bool Enable();
		public bool Enable(bool enable);
		public Bitmap BitmapLabel();
		public void BitmapLabel(Bitmap value) ;
/+
		public Bitmap Label() ;
		public void Label(Bitmap value) ;
+/
		
		public Bitmap BitmapSelected() ;
		public void BitmapSelected(Bitmap value);		
		public Bitmap BitmapFocus();
		public void BitmapFocus(Bitmap value);
		public Bitmap BitmapDisabled() ;
		public void BitmapDisabled(Bitmap value) ;

		//---------------------------------------------------------------------
		//! \cond EXTERN
		extern(C) private static void staticOnSetBitmap(BitmapButton obj);
		//! \endcond
		protected /+virtual+/ void OnSetBitmap();
		
		//public /+virtual+/ void ApplyParentThemeBackground(Colour bg);
	}
