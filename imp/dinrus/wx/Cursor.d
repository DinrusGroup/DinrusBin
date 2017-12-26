module wx.Cursor;
public import wx.common;
public import wx.Bitmap;

	public enum StockCursor
	{
		wxCURSOR_NONE,
		wxCURSOR_ARROW,
		wxCURSOR_RIGHT_ARROW,
		wxCURSOR_BULLSEYE,
		wxCURSOR_CHAR,
		wxCURSOR_CROSS,
		wxCURSOR_HAND,
		wxCURSOR_IBEAM,
		wxCURSOR_LEFT_BUTTON,
		wxCURSOR_MAGNIFIER,
		wxCURSOR_MIDDLE_BUTTON,
		wxCURSOR_NO_ENTRY,
		wxCURSOR_PAINT_BRUSH,
		wxCURSOR_PENCIL,
		wxCURSOR_POINT_LEFT,
		wxCURSOR_POINT_RIGHT,
		wxCURSOR_QUESTION_ARROW,
		wxCURSOR_RIGHT_BUTTON,
		wxCURSOR_SIZENESW,
		wxCURSOR_SIZENS,
		wxCURSOR_SIZENWSE,
		wxCURSOR_SIZEWE,
		wxCURSOR_SIZING,
		wxCURSOR_SPRAYCAN,
		wxCURSOR_WAIT,
		wxCURSOR_WATCH,
		wxCURSOR_BLANK,
		wxCURSOR_ARROWWAIT,
		wxCURSOR_MAX
	}

		//-----------------------------------------------------------------------------
		
		//! \cond EXTERN
		static extern (C) IntPtr wxCursor_ctorById(StockCursor id);
		static extern (C) IntPtr wxCursor_ctorImage(IntPtr image);
		static extern (C) IntPtr wxCursor_ctorCopy(IntPtr cursor);

		static extern (C) bool   wxCursor_Ok(IntPtr self);
		
		static extern (C) void   wxCursor_SetCursor(IntPtr cursor);
		//! \endcond

		//---------------------------------------------------------------------
		
	alias Cursor wxCursor;
	public class Cursor : Bitmap
	{
		public static Cursor wxSTANDARD_CURSOR;
		public static Cursor wxHOURGLASS_CURSOR;
		public static Cursor wxCROSS_CURSOR;
		public static Cursor wxNullCursor;

		public this(IntPtr wxobj);
		public this(StockCursor id);
		public this(Image image);
		public this(Cursor cursor);
		//override public void Dispose();
		public override bool Ok();
		public static void SetCursor(Cursor cursor);
	}
