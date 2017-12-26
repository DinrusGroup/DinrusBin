module wx.ScrollBar;
public import wx.common;
public import wx.Control;

		//! \cond EXTERN
		static extern (C) IntPtr wxScrollBar_ctor();
		static extern (C) bool   wxScrollBar_Create(IntPtr self, IntPtr parent, int id, inout Point pos, inout Size size, uint style, IntPtr validator, string name);
		static extern (C) int    wxScrollBar_GetThumbPosition(IntPtr self);
		static extern (C) int    wxScrollBar_GetThumbSize(IntPtr self);
		static extern (C) int    wxScrollBar_GetPageSize(IntPtr self);
		static extern (C) int    wxScrollBar_GetRange(IntPtr self);
		static extern (C) bool   wxScrollBar_IsVertical(IntPtr self);
		static extern (C) void   wxScrollBar_SetThumbPosition(IntPtr self, int viewStart);
		static extern (C) void   wxScrollBar_SetScrollbar(IntPtr self, int position, int thumbSize, int range, int pageSize, bool refresh);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias ScrollBar wxScrollBar;
	public class ScrollBar : Control
	{
		enum {
			wxSB_HORIZONTAL   = Orientation.wxHORIZONTAL,
			wxSB_VERTICAL     = Orientation.wxVERTICAL,
		}

		public const string wxScrollBarNameStr = "scrollBar";
		//-----------------------------------------------------------------------------

		public this(IntPtr wxobj);
		public this();
		public this(Window parent, int id, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxSB_HORIZONTAL, Validator validator = null, string name = wxScrollBarNameStr);
		public static wxObject New(IntPtr wxobj) ;
		public this(Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxSB_HORIZONTAL, Validator validator = null, string name = wxScrollBarNameStr);
		public bool Create(Window parent, int id, Point pos, Size size, int style, Validator validator, string name);
		public int ThumbPosition() ;
		public void ThumbPosition(int value) ;
		public int ThumbSize() ;
		public int PageSize();
		public int Range() ;
		public bool IsVertical();
		public override void SetScrollbar(int position, int thumbSize, int range, int pageSize, bool refresh);
	}
