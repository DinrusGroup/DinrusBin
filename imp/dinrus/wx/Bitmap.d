module wx.Bitmap;
public import wx.common;
public import wx.GDIObject;
public import wx.Colour;
public import wx.Palette;
public import wx.Image;
public import wx.Icon;

		//! \cond EXTERN
		static extern (C) IntPtr wxBitmap_ctor();
		static extern (C) IntPtr wxBitmap_ctorByImage(IntPtr image, int depth);
		static extern (C) IntPtr wxBitmap_ctorByName(string name, BitmapType type);
		static extern (C) IntPtr wxBitmap_ctorBySize(int width, int height, int depth);
		static extern (C) IntPtr wxBitmap_ctorByBitmap(IntPtr bitmap);
		//static extern (C) void   wxBitmap_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
		
		static extern (C) IntPtr wxBitmap_ConvertToImage(IntPtr self);
		static extern (C) bool   wxBitmap_LoadFile(IntPtr self, string name, BitmapType type);
		static extern (C) bool   wxBitmap_SaveFile(IntPtr self, string name, BitmapType type, IntPtr palette);
		static extern (C) bool   wxBitmap_Ok(IntPtr self);
	
		static extern (C) int    wxBitmap_GetHeight(IntPtr self);
		static extern (C) void   wxBitmap_SetHeight(IntPtr self, int height);
	
		static extern (C) int    wxBitmap_GetWidth(IntPtr self);
		static extern (C) void   wxBitmap_SetWidth(IntPtr self, int width);
		
		static extern (C) int    wxBitmap_GetDepth(IntPtr self);
		static extern (C) void   wxBitmap_SetDepth(IntPtr self, int depth);
		
		static extern (C) IntPtr wxBitmap_GetSubBitmap(IntPtr self, inout Rectangle rect);
		
		static extern (C) IntPtr wxBitmap_GetMask(IntPtr self);
		static extern (C) IntPtr wxBitmap_SetMask(IntPtr self, IntPtr mask);
		
		static extern (C) IntPtr wxBitmap_GetPalette(IntPtr self);
		static extern (C) bool   wxBitmap_CopyFromIcon(IntPtr self, IntPtr icon);
		
		static extern (C) IntPtr wxBitmap_GetColourMap(IntPtr self);
		//! \endcond
	
		//---------------------------------------------------------------------

	alias Bitmap wxBitmap;
	public class Bitmap : GDIObject
	{
		public static Bitmap wxNullBitmap;

		public this();
		public this(Image image);
		public this(Image image, int depth);
		public this(string name);
		public this(string name, BitmapType type);
		public this(int width, int height);
		public this(int width, int height, int depth);
		public this(Bitmap bitmap);
		public this(IntPtr wxobj) ;
		public Image ConvertToImage();
		public int Height();
		public void Height(int value) ;
		public bool LoadFile(string name, BitmapType type);
		public bool SaveFile(string name, BitmapType type);
		public bool SaveFile(string name, BitmapType type, Palette palette);
		public int Width();
		public void Width(int value) ;
		public /+virtual+/ bool Ok();
		public int Depth() ;
		public void Depth(int value);
		public Bitmap GetSubBitmap(Rectangle rect);
		public Mask mask() ;
		public void mask(Mask value) ;
		public Palette palette() ;
		public Palette ColourMap() ;
		public bool CopyFromIcon(Icon icon);
		public static wxObject New(IntPtr ptr) ;
	}

	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxMask_ctor();
		static extern (C) IntPtr wxMask_ctorByBitmpaColour(IntPtr bitmap, IntPtr colour);
		static extern (C) IntPtr wxMask_ctorByBitmapIndex(IntPtr bitmap, int paletteIndex);
		static extern (C) IntPtr wxMask_ctorByBitmap(IntPtr bitmap);
		
		static extern (C) bool wxMask_CreateByBitmapColour(IntPtr self, IntPtr bitmap, IntPtr colour);
		static extern (C) bool wxMask_CreateByBitmapIndex(IntPtr self, IntPtr bitmap, int paletteIndex);
		static extern (C) bool wxMask_CreateByBitmap(IntPtr self, IntPtr bitmap);
		//! \endcond
		
		//---------------------------------------------------------------------
	alias Mask wxMask;
	public class Mask : wxObject
	{
		
		public this();
		public this(Bitmap bitmap, Colour colour);
		public this(Bitmap bitmap, int paletteIndex);
		public this(Bitmap bitmap);
		public this(IntPtr wxobj);
		public bool Create(Bitmap bitmap, Colour colour);
		public bool Create(Bitmap bitmap, int paletteIndex);
		public bool Create(Bitmap bitmap);
	}
