module wx.ImageList;
public import wx.common;
public import wx.Bitmap;
public import wx.DC;

	// Flag values for Set/GetImageList
	enum
	{
		wxIMAGE_LIST_NORMAL, // Normal icons
		wxIMAGE_LIST_SMALL,  // Small icons
		wxIMAGE_LIST_STATE   // State icons: unimplemented (see WIN32 documentation)
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxImageList_ctor(int width, int height, bool mask, int initialCount);
		static extern (C) IntPtr wxImageList_ctor2();
		static extern (C) int    wxImageList_AddBitmap1(IntPtr self, IntPtr bmp, IntPtr mask);
		static extern (C) int    wxImageList_AddBitmap(IntPtr self, IntPtr bmp, IntPtr maskColour);
		static extern (C) int    wxImageList_AddIcon(IntPtr self, IntPtr icon);
		static extern (C) int    wxImageList_GetImageCount(IntPtr self);
		
		static extern (C) bool   wxImageList_Draw(IntPtr self, int index, IntPtr dc, int x, int y, int flags, bool solidBackground);
		
		static extern (C) bool   wxImageList_Create(IntPtr self, int width, int height, bool mask, int initialCount);
		
		static extern (C) bool   wxImageList_Replace(IntPtr self, int index, IntPtr bitmap);
		
		static extern (C) bool   wxImageList_Remove(IntPtr self, int index);
		static extern (C) bool   wxImageList_RemoveAll(IntPtr self);
		
		//static extern (C) IntPtr wxImageList_GetBitmap(IntPtr self, int index);
		
		static extern (C) bool   wxImageList_GetSize(IntPtr self, int index, inout int width, inout int height);
		//! \endcond

		//---------------------------------------------------------------------

	alias ImageList wxImageList;
	public class ImageList : wxObject
	{
		public const int wxIMAGELIST_DRAW_NORMAL	= 0x0001;
		public const int wxIMAGELIST_DRAW_TRANSPARENT	= 0x0002;
		public const int wxIMAGELIST_DRAW_SELECTED	= 0x0004;
		public const int wxIMAGELIST_DRAW_FOCUSED	= 0x0008;
		
		//---------------------------------------------------------------------
	
		public this(int width, int height, bool mask = true, int initialCount=1);
		public this(IntPtr wxobj) ;
		public this();
		public static wxObject New(IntPtr ptr);
		public int Add(Bitmap bitmap);
		public int Add(Bitmap bitmap, Bitmap mask);
		public int Add(Icon icon);
		public int Add(Bitmap bmp, Colour maskColour);
		public bool Create(int width, int height);
		public bool Create(int width, int height, bool mask);
		public bool Create(int width, int height, bool mask, int initialCount);
		public int ImageCount() ;
		public bool Draw(int index, DC dc, int x, int y);
		public bool Draw(int index, DC dc, int x, int y, int flags);
		public bool Draw(int index, DC dc, int x, int y, int flags, bool solidBackground);
		public bool Replace(int index, Bitmap bitmap);
		public bool Remove(int index);
		public bool RemoveAll();
		//public Bitmap GetBitmap(int index);
		public bool GetSize(int index, inout int width, inout int height);
	}
