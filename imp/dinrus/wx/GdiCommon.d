module wx.GdiCommon;
public import wx.common;
public import wx.Bitmap;
public import wx.Cursor;
public import wx.Icon;
public import wx.Pen;
public import wx.Brush;
public import wx.Font;
public import wx.Colour;

		//! \cond EXTERN
		static extern (C) IntPtr wxSTANDARD_CURSOR_Get();
		static extern (C) IntPtr wxHOURGLASS_CURSOR_Get();
		static extern (C) IntPtr wxCROSS_CURSOR_Get();

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

		static extern (C) IntPtr wxNullBitmap_Get();
		static extern (C) IntPtr wxNullIcon_Get();
		static extern (C) IntPtr wxNullCursor_Get();
		static extern (C) IntPtr wxNullPen_Get();
		static extern (C) IntPtr wxNullBrush_Get();
		static extern (C) IntPtr wxNullPalette_Get();
		static extern (C) IntPtr wxNullFont_Get();
		static extern (C) IntPtr wxNullColour_Get();
		//! \endcond


	void InitializeStockObjects();

	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxColourDatabase_ctor();
		static extern (C) void wxColourDataBase_dtor(IntPtr self);
		static extern (C) IntPtr wxColourDatabase_Find(IntPtr self, string name);
		static extern (C) IntPtr wxColourDatabase_FindName(IntPtr self, IntPtr colour);
		static extern (C) void wxColourDatabase_AddColour(IntPtr self, string name, IntPtr colour);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias ColourDatabase wxColourDatabase;
	public class ColourDatabase : wxObject
	{
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this();
		override protected void dtor() ;
		public Colour Find(string name);
		public string FindName(Colour colour);
		public void AddColour(string name, Colour colour);
	}

	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxPenList_ctor();
		//static extern (C) void wxPenList_AddPen(IntPtr self, IntPtr pen);
		//static extern (C) void wxPenList_RemovePen(IntPtr self, IntPtr pen);
		static extern (C) IntPtr wxPenList_FindOrCreatePen(IntPtr self, IntPtr colour, int width, int style);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias PenList wxPenList;
	public class PenList : wxObject
	{
		public this(IntPtr wxobj);
		public this();
		//public void AddPen(Pen pen);
		//public void RemovePen(Pen pen);
		public Pen FindOrCreatePen(Colour colour, int width, int style);
	}

	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxBrushList_ctor();
		//static extern (C) void wxBrushList_AddBrush(IntPtr self, IntPtr brush);
		//static extern (C) void wxBrushList_RemoveBrush(IntPtr self, IntPtr brush);
		static extern (C) IntPtr wxBrushList_FindOrCreateBrush(IntPtr self, IntPtr colour, int style);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias BrushList wxBrushList;
	public class BrushList : wxObject
	{
		public this(IntPtr wxobj);
		public this();
		//public void AddBrush(Brush brush);
		//public void RemoveBrush(Brush brush);
		public Brush FindOrCreateBrush(Colour colour, int style);
	}

	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxFontList_ctor();
		//static extern (C) void wxFontList_AddFont(IntPtr self, IntPtr font);
		//static extern (C) void wxFontList_RemoveFont(IntPtr self, IntPtr font);
		static extern (C) IntPtr wxFontList_FindOrCreateFont(IntPtr self,
			int pointSize,
			int family,
			int style,
			int weight,
			bool underline,
			string face,
			FontEncoding encoding);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias FontList wxFontList;
	public class FontList : wxObject
	{
		public this(IntPtr wxobj);
		public this();
		//public void AddFont(Font font);
		//public void RemoveFont(Font font);
		public Font FindOrCreateFont(int pointSize, int family, int style, int weight);
		public Font FindOrCreateFont(int pointSize, int family, int style, int weight, bool underline);
		public Font FindOrCreateFont(int pointSize, int family, int style, int weight, bool underline, string face);
		public Font FindOrCreateFont(int pointSize, int family, int style, int weight, bool underline, string face, FontEncoding encoding);
	}

	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxBitmapList_ctor();
		static extern (C) void   wxBitmapList_AddBitmap(IntPtr self, IntPtr bitmap);
		static extern (C) void   wxBitmapList_RemoveBitmap(IntPtr self, IntPtr bitmap);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias BitmapList wxBitmapList;
	public class BitmapList : wxObject
	{
		public this(IntPtr wxobj);
		public this();
		public void AddBitmap(Bitmap bitmap);
		public void RemoveBitmap(Bitmap bitmap);
	}

	//-----------------------------------------------------------------------------
