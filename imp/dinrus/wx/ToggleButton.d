module wx.ToggleButton;
public import wx.common;
public import wx.Control;

		//! \cond EXTERN
		static extern (C) IntPtr wxToggleButton_ctor();
		static extern (C) bool   wxToggleButton_Create(IntPtr self, IntPtr parent,
			int id, string label, inout Point pos, inout Size size, uint style,
			IntPtr validator, string name);
		static extern (C) bool wxToggleButton_GetValue(IntPtr self);
		static extern (C) bool wxToggleButton_SetValue(IntPtr self, bool state);
		//! \endcond

		//---------------------------------------------------------------------
		
	alias ToggleButton wxToggleButton;
	public class ToggleButton : Control
	{
		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent, int id, string label, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, Validator validator = null, string name = "checkbox");
	public static wxObject New(IntPtr ptr) ;
		public this(Window parent, string label, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, Validator validator = null, string name = "checkbox");
		public bool Create(Window parent, int id, string label, inout Point pos, inout Size size,
			int style, Validator validator, string name);
		public bool State() ;
		public void State(bool value);
		public void Click_Add(EventListener value) ;
		public void Click_Remove(EventListener value) ;
	}

