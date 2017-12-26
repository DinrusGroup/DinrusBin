module wx.Palette;
public import wx.common;
public import wx.GDIObject;

		//! \cond EXTERN
		static extern (C) IntPtr wxPalette_ctor();
		static extern (C) void wxPalette_dtor(IntPtr self);
		static extern (C) bool wxPalette_Ok(IntPtr self);
		static extern (C) bool wxPalette_Create(IntPtr self, int n, inout ubyte red, inout ubyte green, inout ubyte blue);
		static extern (C) int wxPalette_GetPixel(IntPtr self, ubyte red, ubyte green, ubyte blue);
		static extern (C) bool wxPalette_GetRGB(IntPtr self, int pixel, out ubyte red, out ubyte green, out ubyte blue);
		//! \endcond

	alias Palette wxPalette;
	public class Palette : GDIObject
	{
		public static Palette wxNullPalette;
		//---------------------------------------------------------------------

		public this();
		public this(IntPtr wxobj);
		public this(int n, inout ubyte r, inout ubyte g, inout ubyte b);
		public bool Create(int n, inout ubyte r, inout ubyte g, inout ubyte b);
		public static wxObject New(IntPtr ptr) ;
		public bool Ok();
		public int GetPixel(ubyte red, ubyte green, ubyte blue);
		public bool GetRGB(int pixel, out ubyte red, out ubyte green, out ubyte blue);
	}

