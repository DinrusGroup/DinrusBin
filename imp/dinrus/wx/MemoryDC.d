module wx.MemoryDC;
public import wx.common;
public import wx.DC;

		//! \cond EXTERN
		static extern (C) IntPtr wxMemoryDC_ctor();
		static extern (C) IntPtr wxMemoryDC_ctorByDC(IntPtr dc);
		static extern (C) void   wxMemoryDC_SelectObject(IntPtr self, IntPtr bitmap);
		//! \endcond

		//---------------------------------------------------------------------

	alias MemoryDC wxMemoryDC;
	public class MemoryDC : WindowDC
	{
        public this(IntPtr wxobj) ;
        public this();
        public this(DC dc);
        public void SelectObject(Bitmap bitmap);
		//---------------------------------------------------------------------
	}

		//! \cond EXTERN
		static extern (C) IntPtr wxBufferedDC_ctor();
		static extern (C) IntPtr wxBufferedDC_ctorByBitmap(IntPtr dc, IntPtr buffer);
		static extern (C) IntPtr wxBufferedDC_ctorBySize(IntPtr dc, inout Size area);
		
		static extern (C) void   wxBufferedDC_InitByBitmap(IntPtr self, IntPtr dc, IntPtr bitmap);
		static extern (C) void   wxBufferedDC_InitBySize(IntPtr self, IntPtr dc, inout Size area);
		static extern (C) void   wxBufferedDC_UnMask(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------

	alias BufferedDC wxBufferedDC;
	public class BufferedDC : MemoryDC
	{
        public this(IntPtr wxobj) ;
 		private this(IntPtr wxobj, bool memOwn);
        public this();
        public this(DC dc, Bitmap bitmap) ;
        public this(DC dc, Size size);
		public void InitByBitmap(DC dc, Bitmap bitmap);
		public void InitBySize(DC dc, Size area);
        public void UnMask();
	}

		//! \cond EXTERN
		static extern (C) IntPtr wxBufferedPaintDC_ctor(IntPtr window, IntPtr buffer);
		//! \endcond

		//---------------------------------------------------------------------
        
	alias BufferedPaintDC wxBufferedPaintDC;
	public class BufferedPaintDC : BufferedDC
	{
        public this(IntPtr wxobj) ;
 		private this(IntPtr wxobj, bool memOwn);
       public this(Window window, Bitmap buffer);
   }

