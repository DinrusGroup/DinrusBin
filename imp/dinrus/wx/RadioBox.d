module wx.RadioBox;
public import wx.common;
public import wx.Control;

		//! \cond EXTERN
		static extern (C) IntPtr wxRadioBox_ctor();
		static extern (C) bool   wxRadioBox_Create(IntPtr self, IntPtr parent, int id,
		                                                           string label, inout Point pos, inout Size size,
		                                                           int n, string* choices, int majorDimension,
		                                                           uint style, IntPtr val, string name);

		static extern (C) void   wxRadioBox_SetSelection(IntPtr self, int n);
		static extern (C) int    wxRadioBox_GetSelection(IntPtr self);

		static extern (C) IntPtr wxRadioBox_GetStringSelection(IntPtr self);
		static extern (C) bool   wxRadioBox_SetStringSelection(IntPtr self, string s);

		static extern (C) int    wxRadioBox_GetCount(IntPtr self);
		static extern (C) int    wxRadioBox_FindString(IntPtr self, string s);

		static extern (C) IntPtr wxRadioBox_GetString(IntPtr self, int n);
		static extern (C) void   wxRadioBox_SetString(IntPtr self, int n, string label);

		static extern (C) void   wxRadioBox_Enable(IntPtr self, int n, bool enable);
		static extern (C) void   wxRadioBox_Show(IntPtr self, int n, bool show);
		
		static extern (C) IntPtr wxRadioBox_GetLabel(IntPtr self);
		static extern (C) void   wxRadioBox_SetLabel(IntPtr self, string label);
		//! \endcond

		//---------------------------------------------------------------------
		
	alias RadioBox wxRadioBox;
	public class RadioBox : Control
	{
		enum {
			wxRA_LEFTTORIGHT    = 0x0001,
			wxRA_TOPTOBOTTOM    = 0x0002,
			wxRA_SPECIFY_COLS   = Orientation.wxHORIZONTAL,
			wxRA_SPECIFY_ROWS   = Orientation.wxVERTICAL,
			wxRA_HORIZONTAL     = Orientation.wxHORIZONTAL,
			wxRA_VERTICAL       = Orientation.wxVERTICAL,
		}

		public const string wxRadioBoxNameStr = "radioBox";
		//---------------------------------------------------------------------
        
		public this(IntPtr wxobj);
		public this(Window parent, int id, string label, Point pos = wxDefaultPosition, Size size = wxDefaultSize, string[] choices = null, int majorDimension = 0, int style = wxRA_HORIZONTAL, Validator val = null, string name = wxRadioBoxNameStr);
		public static wxObject New(IntPtr wxobj);
		public this(Window parent, string label, Point pos = wxDefaultPosition, Size size = wxDefaultSize, string[] choices = null, int majorDimension = 0, int style = wxRA_HORIZONTAL, Validator val = null, string name = wxRadioBoxNameStr);
		public void Selection(int value);
		public int Selection() ;
		public void StringSelection(string value) ;
		public string StringSelection() ;
		public int Count() ;
		public int FindString(string s);
		public string GetString(int n);
		public void SetString(int n, string label);
		public void Enable(int n, bool enable);
		public void Show(int n, bool show);
		public override string Label() ;
		public override void Label(string value) ;
		public void Select_Add(EventListener value) ;
		public void Select_Remove(EventListener value) ;
	}
