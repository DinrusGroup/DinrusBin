module wx.RadioButton;
public import wx.common;
public import wx.Control;

		//! \cond EXTERN
		static extern (C) IntPtr wxRadioButton_ctor();
		static extern (C) bool   wxRadioButton_Create(IntPtr self, IntPtr parent, int id, string label, inout Point pos, inout Size size, uint style, IntPtr val, string name);
		static extern (C) bool   wxRadioButton_GetValue(IntPtr self);
		static extern (C) void   wxRadioButton_SetValue(IntPtr self, bool state);
		//! \endcond
	
		//---------------------------------------------------------------------
		
	alias RadioButton wxRadioButton;
	public class RadioButton : Control 
	{
		public const int wxRB_GROUP     = 0x0004;
		public const int wxRB_SINGLE    = 0x0008;
		
		public const string wxRadioButtonNameStr = "radioButton";
		//---------------------------------------------------------------------
	
		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent, int id, string label, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, Validator val = null, string name = wxRadioButtonNameStr);
		public static wxObject New(IntPtr wxobj) ;
		public this(Window parent, string label, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, Validator val = null, string name = wxRadioButtonNameStr);
		public bool Create(Window parent, int id, string label, inout Point pos, inout Size size, int style, Validator val, string name);
		public bool Value() ;
		public void Value(bool value);
		public void Select_Add(EventListener value) ;
		public void Select_Remove(EventListener value) ;
	}
