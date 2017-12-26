module wx.SizeEvent;
public import wx.common;
public import wx.Event;

		//! \cond EXTERN
		static extern (C) IntPtr wxSizeEvent_ctor();
		static extern (C) IntPtr wxSizeEvent_ctorSize(inout Size sz,int winid);
		static extern (C) IntPtr wxSizeEvent_ctorRect(inout Rect sz,int winid);
		static extern (C) void wxSizeEvent_GetSize(IntPtr self, out Size size);
		static extern (C) void wxSizeEvent_GetRect(IntPtr self, out Rect rect);
		static extern (C) void wxSizeEvent_SetRect(IntPtr self, inout Rect rect);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias SizeEvent wxSizeEvent;
	public class SizeEvent : Event
	{
		public this(IntPtr wxobj) ;
		public this();
		public this(Size sz,int winid = 0);
		public this(Rectangle rect,int winid = 0);
		public Size size();
		public Rectangle rect();
		public void rect(Rectangle rect);
		private static Event New(IntPtr obj) ;
		static this();
	}
