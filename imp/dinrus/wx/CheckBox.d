module wx.CheckBox;
public import wx.common;
public import wx.Control;

	public enum CheckBoxState
	{
		wxCHK_UNCHECKED,
		wxCHK_CHECKED,
		wxCHK_UNDETERMINED
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxCheckBox_ctor();
		static extern (C) bool   wxCheckBox_Create(IntPtr self, IntPtr parent, int id, string label, inout Point pos, inout Size size, uint style, IntPtr val, string name);
		static extern (C) bool   wxCheckBox_GetValue(IntPtr self);
		static extern (C) void   wxCheckBox_SetValue(IntPtr self, bool state);
		static extern (C) bool   wxCheckBox_IsChecked(IntPtr self);
		
		static extern (C) CheckBoxState wxCheckBox_Get3StateValue(IntPtr self);
		static extern (C) void wxCheckBox_Set3StateValue(IntPtr self, CheckBoxState state);
		static extern (C) bool wxCheckBox_Is3State(IntPtr self);
		static extern (C) bool wxCheckBox_Is3rdStateAllowedForUser(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------
		
	alias CheckBox wxCheckBox;
	public class CheckBox : Control
	{
		public const int wxCHK_2STATE           = 0x0000;
		public const int wxCHK_3STATE           = 0x1000;
		public const int wxCHK_ALLOW_3RD_STATE_FOR_USER           = 0x2000;
		public const string wxCheckBoxNameStr = "checkbox";
	
		public this(IntPtr wxobj);
		public this();
		public this(Window parent, int id, string label, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style =0, Validator val=null, string name = wxCheckBoxNameStr);		
		public static wxObject New(IntPtr wxobj);
		public this(Window parent, string label, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style =0, Validator val=null, string name = wxCheckBoxNameStr);
		public bool Create(Window parent, int id, string label, inout Point pos, inout Size size,
			int style, Validator val, string name);
		public bool Value();
		public void Value(bool value);
		public bool IsChecked();
		public CheckBoxState ThreeStateValue();
		public void ThreeStateValue(CheckBoxState value) ;
		public bool Is3State();
		public bool Is3rdStateAllowedForUser();
		public void Clicked_Add(EventListener value);
		public void Clicked_Remove(EventListener value) ;
	}
