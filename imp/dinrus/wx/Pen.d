module wx.Pen;
public import wx.common;
public import wx.Defs;
public import wx.GDIObject;
public import wx.Colour;

		//! \cond EXTERN
		static extern (C) IntPtr wxGDIObj_GetRedPen();
		static extern (C) IntPtr wxGDIObj_GetCyanPen();
		static extern (C) IntPtr wxGDIObj_GetGreenPen();
		static extern (C) IntPtr wxGDIObj_GetBlackPen();
		static extern (C) IntPtr wxGDIObj_GetWhitePen();
		static extern (C) IntPtr wxGDIObj_GetTransparentPen();
		static extern (C) IntPtr wxGDIObj_GetBlackDashedPen();
		static extern (C) IntPtr wxGDIObj_GetGreyPen();
		static extern (C) IntPtr wxGDIObj_GetMediumGreyPen();
		static extern (C) IntPtr wxGDIObj_GetLightGreyPen();

		static extern (C) IntPtr wxPen_ctor(IntPtr col, int width, FillStyle style);
		static extern (C) IntPtr wxPen_ctorByName(string name, int width, FillStyle style);

		static extern (C) IntPtr wxPen_GetColour(IntPtr self);
		static extern (C) void   wxPen_SetColour(IntPtr self, IntPtr col);

		static extern (C) void   wxPen_SetWidth(IntPtr self, int width);
		static extern (C) int    wxPen_GetWidth(IntPtr self);

		static extern (C) int    wxPen_GetCap(IntPtr self);
		static extern (C) int    wxPen_GetJoin(IntPtr self);
		static extern (C) int    wxPen_GetStyle(IntPtr self);
		static extern (C) bool   wxPen_Ok(IntPtr self);
		static extern (C) void   wxPen_SetCap(IntPtr self, int capStyle);
		static extern (C) void   wxPen_SetJoin(IntPtr self, int join_style);
		static extern (C) void   wxPen_SetStyle(IntPtr self, int style);

		//---------------------------------------------------------------------
		static extern (C) IntPtr wxNullPen_Get();
		//! \endcond

	alias Pen wxPen;
	public class Pen : GDIObject
	{
		public static Pen wxRED_PEN;
		public static Pen wxCYAN_PEN;
		public static Pen wxGREEN_PEN;
		public static Pen wxBLACK_PEN;
		public static Pen wxWHITE_PEN;
		public static Pen wxTRANSPARENT_PEN;
		public static Pen wxBLACK_DASHED_PEN;
		public static Pen wxGREY_PEN;
		public static Pen wxMEDIUM_GREY_PEN;
		public static Pen wxLIGHT_GREY_PEN;
		public static Pen wxNullPen;

		public this(IntPtr wxobj) ;
		public this(string name) ;
		public this(string name, int width) ;
		public this(string name, int width, FillStyle style) ;
		public this(Colour colour) ;
		public this(Colour colour, int width) ;
		public this(Colour col, int width, FillStyle style);
		public Colour colour();
		public void colour(Colour value) ;
		public int Width();
		public void Width(int value);
		public int Cap() ;
		public void Cap(int value) ;
		public int Join() ;
		public void Join(int value) ;
		public int Style() ;
		public void Style(int value) ;
		public bool Ok() ;
		static wxObject New(IntPtr ptr) ;
	}
