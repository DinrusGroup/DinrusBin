module wx.Brush;
public import wx.common;
public import wx.Bitmap;

		//! \cond EXTERN
		static extern (C) IntPtr wxBLUE_BRUSH_Get();
		static extern (C) IntPtr wxGREEN_BRUSH_Get();
		static extern (C) IntPtr wxWHITE_BRUSH_Get();
		static extern (C) IntPtr wxBLACK_BRUSH_Get();
		static extern (C) IntPtr wxGREY_BRUSH_Get();
		static extern (C) IntPtr wxMEDIUM_GREY_BRUSH_Get();
		static extern (C) IntPtr wxLIGHT_GREY_BRUSH_Get();
		static extern (C) IntPtr wxTRANSPARENT_BRUSH_Get();
		static extern (C) IntPtr wxCYAN_BRUSH_Get();
		static extern (C) IntPtr wxRED_BRUSH_Get();
		
        	static extern (C) IntPtr wxBrush_ctor();
		static extern (C) bool   wxBrush_Ok(IntPtr self);
		static extern (C) FillStyle wxBrush_GetStyle(IntPtr self);
		static extern (C) void   wxBrush_SetStyle(IntPtr self, FillStyle style);
		static extern (C) IntPtr wxBrush_GetStipple(IntPtr self);
		static extern (C) void   wxBrush_SetStipple(IntPtr self, IntPtr stipple);
        	static extern (C) IntPtr wxBrush_GetColour(IntPtr self);
		static extern (C) void   wxBrush_SetColour(IntPtr self, IntPtr col);
		//! \endcond

		//---------------------------------------------------------------------

	alias Brush wxBrush;
	public class Brush : GDIObject
	{
		public static Brush wxBLUE_BRUSH;
		public static Brush wxGREEN_BRUSH;
		public static Brush wxWHITE_BRUSH;
		public static Brush wxBLACK_BRUSH;
		public static Brush wxGREY_BRUSH;
		public static Brush wxMEDIUM_GREY_BRUSH;
		public static Brush wxLIGHT_GREY_BRUSH;
		public static Brush wxTRANSPARENT_BRUSH;
		public static Brush wxCYAN_BRUSH;
		public static Brush wxRED_BRUSH;
		public static Brush wxNullBrush;

/+
		override public void Dispose();
+/

		public this();
		public this(IntPtr wxobj);
		public this(Colour colour) ;
		public this(Colour colour, FillStyle style);
		public this(Bitmap stippleBitmap) ;
		public this(string name) ;
		public this(string name, FillStyle style) ;
		public bool Ok() ;
		public FillStyle Style() ;
		public void Style(FillStyle value) ;
		public Bitmap Stipple() ;
		public void Stipple(Bitmap value);
		public Colour colour();
		public void colour(Colour value);
	}
