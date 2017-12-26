module wx.Slider;
public import wx.common;
public import wx.Control;

		//! \cond EXTERN
		static extern (C) IntPtr wxSlider_ctor();
		static extern (C) bool   wxSlider_Create(IntPtr self, IntPtr parent, int id, int value, int minValue, int maxValue, inout Point pos, inout Size size, uint style, IntPtr validator, string name);
		static extern (C) int    wxSlider_GetValue(IntPtr self);
		static extern (C) void   wxSlider_SetValue(IntPtr self, int value);
		static extern (C) void   wxSlider_SetRange(IntPtr self, int minValue, int maxValue);
		static extern (C) int    wxSlider_GetMin(IntPtr self);
		static extern (C) int    wxSlider_GetMax(IntPtr self);
		static extern (C) void   wxSlider_SetLineSize(IntPtr self, int lineSize);
		static extern (C) void   wxSlider_SetPageSize(IntPtr self, int pageSize);
		static extern (C) int    wxSlider_GetLineSize(IntPtr self);
		static extern (C) int    wxSlider_GetPageSize(IntPtr self);
		static extern (C) void   wxSlider_SetThumbLength(IntPtr self, int lenPixels);
		static extern (C) int    wxSlider_GetThumbLength(IntPtr self);
		static extern (C) void   wxSlider_SetTickFreq(IntPtr self, int n, int pos);
		static extern (C) int    wxSlider_GetTickFreq(IntPtr self);
		static extern (C) void   wxSlider_ClearTicks(IntPtr self);
		static extern (C) void   wxSlider_SetTick(IntPtr self, int tickPos);
		static extern (C) void   wxSlider_ClearSel(IntPtr self);
		static extern (C) int    wxSlider_GetSelEnd(IntPtr self);
		static extern (C) int    wxSlider_GetSelStart(IntPtr self);
		static extern (C) void   wxSlider_SetSelection(IntPtr self, int min, int max);
		//! \endcond
	
		//---------------------------------------------------------------------
		
    alias Slider wxSlider;
    public class Slider : Control
    {
		enum {
			wxSL_HORIZONTAL      = Orientation.wxHORIZONTAL,
			wxSL_VERTICAL        = Orientation.wxVERTICAL,

			wxSL_NOTIFY_DRAG     = 0x0000,
			wxSL_TICKS           = 0x0010,
			wxSL_AUTOTICKS       = wxSL_TICKS,
			wxSL_LABELS          = 0x0020,
			wxSL_LEFT            = 0x0040,
			wxSL_TOP             = 0x0080,
			wxSL_RIGHT           = 0x0100,
			wxSL_BOTTOM          = 0x0200,
			wxSL_BOTH            = 0x0400,
			wxSL_SELRANGE        = 0x0800,
		}

		public const string wxSliderNameStr = "slider";
		//---------------------------------------------------------------------

		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent, int id, int value, int minValue, int maxValue, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxSL_HORIZONTAL, Validator validator = null, string name = wxSliderNameStr);
		public static wxObject New(IntPtr wxobj);
		public this(Window parent, int value, int minValue, int maxValue, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxSL_HORIZONTAL, Validator validator = null, string name = wxSliderNameStr);
		public bool Create(Window parent, int id, int value, int minValue, int maxValue, inout Point pos, inout Size size, int style, Validator validator, string name);
		public int Value();
		public void Value(int value);
		public void SetRange(int minValue, int maxValue);
		public int Max() ;
		public int Min() ;
		public int LineSize() ;
		public void LineSize(int value);
		public int PageSize();
		public void PageSize(int value);
		public int ThumbLength() ;
		public void ThumbLength(int value) ;
		public int TickFreq();
		public void SetTickFreq(int n, int pos);
		public void SetTick(int tickPos);
		public void ClearTicks();
		public void ClearSel();
		public int SelEnd() ;
		public int SelStart() ;
		public void SetSelection(int min, int max);
		public override void UpdateUI_Add(EventListener value);
		public override void UpdateUI_Remove(EventListener value) ;
    }
