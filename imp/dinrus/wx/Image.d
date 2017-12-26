
module wx.Image;
public import wx.common;
public import wx.Defs;
//public import wx.Bitmap;
public import wx.Palette;
public import wx.Colour;

		//! \cond EXTERN
		static extern (C) IntPtr wxImage_ctor();
		static extern (C) IntPtr wxImage_ctorByName(string name, BitmapType type);
		static extern (C) IntPtr wxImage_ctorintintbool(int width, int height, bool clear);
		static extern (C) IntPtr wxImage_ctorByData(int width, int height, ubyte* data, bool static_data);
		static extern (C) IntPtr wxImage_ctorByDataAlpha(int width, int height, ubyte* data, ubyte* alpha, bool static_data);
		static extern (C) IntPtr wxImage_ctorByImage(IntPtr image);
		static extern (C) IntPtr wxImage_ctorByByteArray(IntPtr data, int length, BitmapType type);
		static extern (C) void   wxImage_dtor(IntPtr self);
		
		static extern (C) void   wxImage_Destroy(IntPtr self);
		
		static extern (C) int    wxImage_GetHeight(IntPtr self);
		static extern (C) int    wxImage_GetWidth(IntPtr self);
		static extern (C) void   wxImage_InitAllHandlers();
		static extern (C) void   wxImage_Rescale(IntPtr self, int width, int height);
		static extern (C) IntPtr wxImage_Scale(IntPtr self, int width, int height);

		static extern (C) void   wxImage_SetMask(IntPtr self, bool mask);
		static extern (C) bool   wxImage_HasMask(IntPtr self);
		static extern (C) void   wxImage_SetMaskColour(IntPtr self, ubyte r, ubyte g, ubyte b);

		static extern (C) bool   wxImage_LoadFileByTypeId(IntPtr self, string name, BitmapType type, int index);
		static extern (C) bool   wxImage_LoadFileByMimeTypeId(IntPtr self, string name, string mimetype, int index);
		static extern (C) bool   wxImage_SaveFileByType(IntPtr self, string name, BitmapType type);
		static extern (C) bool   wxImage_SaveFileByMimeType(IntPtr self, string name, string mimetype);
		
		static extern (C) IntPtr wxImage_Copy(IntPtr self);
		static extern (C) IntPtr wxImage_GetSubImage(IntPtr self, inout Rectangle rect);
		
		static extern (C) void   wxImage_Paste(IntPtr self, IntPtr image, int x, int y);
		
		static extern (C) IntPtr wxImage_ShrinkBy(IntPtr self, int xFactor, int yFactor);
		
		static extern (C) IntPtr wxImage_Rotate(IntPtr self, double angle, inout Point centre_of_rotation, bool interpolating, inout Point offset_after_rotation);
		static extern (C) IntPtr wxImage_Rotate90(IntPtr self, bool clockwise);
		static extern (C) IntPtr wxImage_Mirror(IntPtr self, bool horizontally);
		
		static extern (C) void   wxImage_Replace(IntPtr self, ubyte r1, ubyte g1, ubyte b1, ubyte r2, ubyte g2, ubyte b2);
		
		static extern (C) IntPtr wxImage_ConvertToMono(IntPtr self, ubyte r, ubyte g, ubyte b);
		
		static extern (C) void   wxImage_SetRGB(IntPtr self, int x, int y, ubyte r, ubyte g, ubyte b);
		
		static extern (C) ubyte   wxImage_GetRed(IntPtr self, int x, int y);
		static extern (C) ubyte   wxImage_GetGreen(IntPtr self, int x, int y);
		static extern (C) ubyte   wxImage_GetBlue(IntPtr self, int x, int y);
		
		static extern (C) void   wxImage_SetAlpha(IntPtr self, int x, int y, ubyte alpha);
		static extern (C) ubyte   wxImage_GetAlpha(IntPtr self, int x, int y);
		
		static extern (C) bool   wxImage_FindFirstUnusedColour(IntPtr self, inout ubyte r, inout ubyte g, inout ubyte b, ubyte startR, ubyte startG, ubyte startB);
		static extern (C) bool   wxImage_SetMaskFromImage(IntPtr self, IntPtr mask, ubyte mr, ubyte mg, ubyte mb);
		
		static extern (C) bool   wxImage_ConvertAlphaToMask(IntPtr self, ubyte threshold);
		
		static extern (C) bool   wxImage_CanRead(string name);
		static extern (C) int    wxImage_GetImageCount(string name, int type);
		
		static extern (C) bool   wxImage_Ok(IntPtr self);
		//--Alex
		static extern (C) ubyte   wxImage_GetMaskRed(IntPtr self);
		static extern (C) ubyte   wxImage_GetMaskGreen(IntPtr self);
		static extern (C) ubyte   wxImage_GetMaskBlue(IntPtr self);
		
		static extern (C) bool   wxImage_HasPalette(IntPtr self);
		static extern (C) IntPtr wxImage_GetPalette(IntPtr self);
		static extern (C) void   wxImage_SetPalette(IntPtr self, IntPtr palette);
		
		static extern (C) void   wxImage_SetOption(IntPtr self, string name, string value);
		static extern (C) void   wxImage_SetOption2(IntPtr self, string name, int value);
		static extern (C) IntPtr wxImage_GetOption(IntPtr self, string name);
		static extern (C) int    wxImage_GetOptionInt(IntPtr self, string name);
		static extern (C) bool   wxImage_HasOption(IntPtr self, string name);
		
		static extern (C) uint  wxImage_CountColours(IntPtr self, uint stopafter);
		
		static extern (C) uint  wxImage_ComputeHistogram(IntPtr self, IntPtr h);
		
		static extern (C) IntPtr wxImage_GetHandlers();
		static extern (C) void   wxImage_AddHandler(IntPtr handler);
		static extern (C) void   wxImage_InsertHandler(IntPtr handler);
		static extern (C) bool   wxImage_RemoveHandler(string name);
		static extern (C) IntPtr wxImage_FindHandler(string name);
		static extern (C) IntPtr wxImage_FindHandler2(string name, uint imageType);
		static extern (C) IntPtr wxImage_FindHandler3(uint imageType);
		static extern (C) IntPtr wxImage_FindHandlerMime(string mimetype);
		
		static extern (C) IntPtr wxImage_GetImageExtWildcard();
		
		static extern (C) void   wxImage_CleanUpHandlers();
		
		static extern (C) void   wxImage_InitStandardHandlers();
		//! \endcond

		//---------------------------------------------------------------------

	alias Image wxImage;
	public class Image : wxObject
	{
		private static bool handlersLoaded = false;
		
		public static void InitAllHandlers();
		static this();		
		public this(IntPtr wxobj);
		public this();
		public this(string name);
		public this(int width, int height);
		public this(byte[] data, BitmapType type);
		public this(int width, int height, bool clear);
		public this(int width, int height, ubyte *data, bool static_data);
		public this(int width, int height, ubyte *data, ubyte *alpha, bool static_data);
		public this(Image image);
		public static wxObject New(IntPtr ptr);
		public void Destroy();
		public int Width() ;
		public int Height() ;
		public Size size();
		public bool LoadFile(string path);
		public bool LoadFile(string path, BitmapType type);
		public bool LoadFile(string path, BitmapType type, int index);
		public bool LoadFile(string name, string mimetype);
		public bool LoadFile(string name, string mimetype, int index);
        	public bool SaveFile(string path);
		public bool SaveFile(string path, BitmapType type);
		public bool SaveFile(string name, string mimetype);
		public Image Rescale(int width, int height);
		public Image Scale(int width, int height);
		public void SetMaskColour(ubyte r, ubyte g, ubyte b);
		public void MaskColour(Colour value);
		public void Mask(bool value);
		public bool Mask() ;
		public Image Copy();
		public Image SubImage(Rectangle rect);
		public void Paste(Image image, int x, int y);
		public Image ShrinkBy(int xFactor, int yFactor);
		public Image Rotate(double angle, Point centre_of_rotation);
		public Image Rotate(double angle, Point centre_of_rotation, bool interpolating);
		public Image Rotate(double angle, Point centre_of_rotation, bool interpolating, Point offset_after_rotation);
		public Image Rotate90();
		public Image Rotate90(bool clockwise);
		public Image Mirror();
		public Image Mirror(bool horizontally);
		public void Replace(ubyte r1, ubyte g1, ubyte b1, ubyte r2, ubyte g2, ubyte b2);
		public void ConvertToMono(ubyte r, ubyte g, ubyte b);
		public void SetRGB(int x, int y, ubyte r, ubyte g, ubyte b);
		public ubyte GetRed(int x, int y);
		public ubyte GetGreen(int x, int y);
		public ubyte GetBlue(int x, int y);
		public void SetAlpha(int x, int y, ubyte alpha);
		public ubyte GetAlpha(int x, int y);
		public bool FindFirstUnusedColour(inout ubyte r, inout ubyte g, inout ubyte b);
		public bool FindFirstUnusedColour(inout ubyte r, inout ubyte g, inout ubyte b, ubyte startR);
		public bool FindFirstUnusedColour(inout ubyte r, inout ubyte g, inout ubyte b, ubyte startR, ubyte startG);
		public bool FindFirstUnusedColour(inout ubyte r, inout ubyte g, inout ubyte b, ubyte startR, ubyte startG, ubyte startB);
		public bool SetMaskFromImage(Image mask, ubyte mr, ubyte mg, ubyte mb);
		public bool ConvertAlphaToMask();
		public bool ConvertAlphaToMask(ubyte threshold);
		public static bool CanRead(string name);
		public static int GetImageCount(string name);
		public static int GetImageCount(string name, BitmapType type);
		public bool Ok() ;
		public ubyte MaskRed() ;
		public ubyte MaskGreen();
		public ubyte MaskBlue() ;
		public bool HasPalette();
		public Palette palette() ;
		public void palette(Palette value) ;
		public void SetOption(string name, string value);
		public void SetOption(string name, int value);
		public string GetOption(string name);
		public int GetOptionInt(string name);
		public bool HasOption(string name);
		public uint CountColours();
		public uint CountColours(uint stopafter);
		public uint ComputeHistogram(ImageHistogram h);
		public static void AddHandler(ImageHandler handler);
		public static void InsertHandler(ImageHandler handler);
		public static bool RemoveHandler(string name);
		public static ImageHandler FindHandler(string name);
		public static ImageHandler FindHandler(string extension, int imageType);
		public static ImageHandler FindHandler(int imageType);
		public static ImageHandler FindHandlerMime(string mimetype);
		static string ImageExtWildcard();
		public static void CleanUpHandlers();
		public static void InitStandardHandlers();
	}
	
	//---------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) void   wxImageHandler_SetName(IntPtr self, string name);
		static extern (C) void   wxImageHandler_SetExtension(IntPtr self, string ext);
		static extern (C) void   wxImageHandler_SetType(IntPtr self, uint type);
		static extern (C) void   wxImageHandler_SetMimeType(IntPtr self, string type);
		static extern (C) IntPtr wxImageHandler_GetName(IntPtr self);
		static extern (C) IntPtr wxImageHandler_GetExtension(IntPtr self);
		static extern (C) uint   wxImageHandler_GetType(IntPtr self);
		static extern (C) IntPtr wxImageHandler_GetMimeType(IntPtr self);
		//! \endcond
		
		//---------------------------------------------------------------------
	
	alias ImageHandler wxImageHandler;
	public class ImageHandler : wxObject
	{
		public this(IntPtr wxobj);
		public string Name();
		public void Name(string value);
		public string Extension() ;
		public void Extension(string value) ;
		public int Type() ;
		public void Type(int value);
		public string MimeType();
		public void MimeType(string value) ;
	}
	
	//---------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxImageHistogramEntry_ctor();
		static extern (C) void   wxImageHistogramEntry_dtor(IntPtr self);
		static extern (C) uint  wxImageHistogramEntry_index(IntPtr self);
		static extern (C) void   wxImageHistogramEntry_Setindex(IntPtr self, uint v);
		static extern (C) uint  wxImageHistogramEntry_value(IntPtr self);
		static extern (C) void   wxImageHistogramEntry_Setvalue(IntPtr self, uint v);
		//! \endcond
		
		//---------------------------------------------------------------------
		
	alias ImageHistogramEntry wxImageHistogramEntry;
	public class ImageHistogramEntry : wxObject
	{
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this();
		override protected void dtor();
		public uint index();
		public void index(uint value);
		public uint value() ;
		public void value(uint value);
	}
	
	//---------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxImageHistogram_ctor();	
		static extern (C) void   wxImageHistogram_dtor(IntPtr self);
		static extern (C) uint  wxImageHistogram_MakeKey(ubyte r, ubyte g, ubyte b);
		static extern (C) bool   wxImageHistogram_FindFirstUnusedColour(IntPtr self, inout ubyte r, inout ubyte g, inout ubyte b, ubyte startR, ubyte startG, ubyte startB);
		//! \endcond
				
		//---------------------------------------------------------------------
		
	alias ImageHistogram wxImageHistogram;
	public class ImageHistogram : wxObject
	{
		public this(IntPtr wxobj);
		public this();
		public static uint MakeKey(ubyte r, ubyte g, ubyte b);
		public bool FindFirstUnusedColour(inout ubyte r, inout ubyte g, inout ubyte b);
		public bool FindFirstUnusedColour(inout ubyte r, inout ubyte g, inout ubyte b, ubyte startR);
		public bool FindFirstUnusedColour(inout ubyte r, inout ubyte g, inout ubyte b, ubyte startR, ubyte startG);
		public bool FindFirstUnusedColour(inout ubyte r, inout ubyte g, inout ubyte b, ubyte startR, ubyte startG, ubyte startB);
	}
