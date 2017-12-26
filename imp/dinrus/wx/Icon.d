
module wx.Icon;
public import wx.common;
public import wx.Bitmap;


		//! \cond EXTERN
		static extern (C) IntPtr wxIcon_ctor();
		static extern (C) void   wxIcon_CopyFromBitmap(IntPtr self, IntPtr bitmap);
		static extern (C) bool   wxIcon_LoadFile(IntPtr self, string name, BitmapType type);
		//! \endcond

		//---------------------------------------------------------------------

	alias Icon wxIcon;
	public class Icon : Bitmap
	{
		public static Icon wxNullIcon;
		public this(string name);
		public this(string name, BitmapType type);
		public this();
		
		public this(IntPtr wxobj) ;
		public void CopyFromBitmap(Bitmap bitmap);
	}
