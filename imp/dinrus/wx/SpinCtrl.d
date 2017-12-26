module wx.SpinCtrl;
public import wx.common;
public import wx.Control;

		//! \cond EXTERN
		static extern (C) IntPtr wxSpinCtrl_ctor();
		static extern (C) bool   wxSpinCtrl_Create(IntPtr self, IntPtr parent, int id, string value, inout Point pos, inout Size size, uint style, int min, int max, int initial, string name);
		static extern (C) int    wxSpinCtrl_GetValue(IntPtr self);
		static extern (C) int    wxSpinCtrl_GetMin(IntPtr self);
		static extern (C) int    wxSpinCtrl_GetMax(IntPtr self);
		static extern (C) void   wxSpinCtrl_SetValueStr(IntPtr self, string value);
		static extern (C) void   wxSpinCtrl_SetValue(IntPtr self, int val);
		static extern (C) void   wxSpinCtrl_SetRange(IntPtr self, int min, int max);
		//! \endcond
	
		//---------------------------------------------------------------------
		
	alias SpinCtrl wxSpinCtrl;
	public class SpinCtrl : Control 
	{
		// These are duplicated in SpinButton.cs (for easier access)
		public const int wxSP_HORIZONTAL       = Orientation.wxHORIZONTAL;
		public const int wxSP_VERTICAL         = Orientation.wxVERTICAL;
		public const int wxSP_ARROW_KEYS       = 0x1000;
		public const int wxSP_WRAP             = 0x2000;
	
		//---------------------------------------------------------------------
		
		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent,
			int id /*= wxID_ANY*/,
			string value = "",
			Point pos = wxDefaultPosition,
			Size size = wxDefaultSize,
			int style = wxSP_ARROW_KEYS,
			int min = 0, int max = 100, int initial = 0,
			string name = "SpinCtrl");
		public static wxObject New(IntPtr wxobj) ;
		public this(Window parent,
			string value = "",
			Point pos = wxDefaultPosition,
			Size size = wxDefaultSize,
			int style = wxSP_ARROW_KEYS,
			int min = 0, int max = 100, int initial = 0,
			string name = "SpinCtrl");
		public bool Create(Window parent, int id, string value, Point pos, Size size, int style, int min, int max, int initial, string name);
		public int Value();
		public void Value(int value) ;
		public void SetValue(string val);
		public int Max();
		public int Min() ;
		public void SetRange(int min, int max);
		public override void UpdateUI_Add(EventListener value) ;
		public override void UpdateUI_Remove(EventListener value) ;
	}

