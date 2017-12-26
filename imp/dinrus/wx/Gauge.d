module wx.Gauge;
public import wx.common;
public import wx.Control;

		//! \cond EXTERN
		static extern (C) IntPtr wxGauge_ctor();
		static extern (C) void   wxGauge_dtor(IntPtr self);
		static extern (C) bool   wxGauge_Create(IntPtr self, IntPtr parent, int id, int range, inout Point pos, inout Size size, uint style, IntPtr validator, string name);
		static extern (C) void   wxGauge_SetRange(IntPtr self, int range);
		static extern (C) int    wxGauge_GetRange(IntPtr self);
		static extern (C) void   wxGauge_SetValue(IntPtr self, int pos);
		static extern (C) int    wxGauge_GetValue(IntPtr self);
		static extern (C) void   wxGauge_SetShadowWidth(IntPtr self, int w);
		static extern (C) int    wxGauge_GetShadowWidth(IntPtr self);
		static extern (C) void   wxGauge_SetBezelFace(IntPtr self, int w);
		static extern (C) int    wxGauge_GetBezelFace(IntPtr self);
		static extern (C) bool   wxGauge_AcceptsFocus(IntPtr self);
		static extern (C) bool   wxGauge_IsVertical(IntPtr self);
		//! \endcond
	
		//---------------------------------------------------------------------
		
	alias Gauge wxGauge;
	public class Gauge :  Control
	{
		enum {
			wxGA_HORIZONTAL       = Orientation.wxHORIZONTAL,
			wxGA_VERTICAL         = Orientation.wxVERTICAL,
			wxGA_PROGRESSBAR      = 0x0010,
		}
	
		// Windows only
		public const int wxGA_SMOOTH           = 0x0020;
	
		public const string wxGaugeNameStr = "gauge";
		//---------------------------------------------------------------------
		
		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent, int id, int range, Point pos = wxDefaultPosition, Size size = wxDefaultSize, 
				int style = wxGA_HORIZONTAL, Validator validator = null, string name = wxGaugeNameStr);
		public static wxObject New(IntPtr wxobj);
		public this(Window parent, int range, Point pos = wxDefaultPosition, Size size = wxDefaultSize, 
				int style = wxGA_HORIZONTAL, Validator validator = null, string name = wxGaugeNameStr);
		public bool Create(Window parent, int id, int range, inout Point pos, 
				inout Size size, int style, Validator validator, 
				string name);
		public int Range();
		public void Range(int value) ;
		public int Value();
		public void Value(int value) ;
		public int ShadowWidth() ;
		public void ShadowWidth(int value);
		public int BezelFace() ;
		public void BezelFace(int value) ;
		public override bool AcceptsFocus();
		public bool IsVertical() ;
	}
