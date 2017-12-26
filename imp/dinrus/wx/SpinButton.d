module wx.SpinButton;
public import wx.common;
public import wx.CommandEvent;
public import wx.Control;

		//! \cond EXTERN
		static extern (C) IntPtr wxSpinEvent_ctor(int commandType, int id);
		static extern (C) int wxSpinEvent_GetPosition(IntPtr self);
		static extern (C) void wxSpinEvent_SetPosition(IntPtr self, int pos);
		static extern (C) void wxSpinEvent_Veto(IntPtr self);
		static extern (C) void wxSpinEvent_Allow(IntPtr self);
		static extern (C) bool wxSpinEvent_IsAllowed(IntPtr self);	
		//! \endcond

		//-----------------------------------------------------------------------------
	
	alias SpinEvent wxSpinEvent;
	public class SpinEvent : CommandEvent
	{
		public this(IntPtr wxobj);
		public this(int commandType, int id);
		public int Position() ;
		public void Position(int value) ;
		public void Veto();
		public void Allow();
		public bool Allowed() ;
		private static Event New(IntPtr obj) ;
		static this();
	}
	
	//-----------------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxSpinButton_ctor();
		static extern (C) bool   wxSpinButton_Create(IntPtr self, IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
		static extern (C) int    wxSpinButton_GetValue(IntPtr self);
		static extern (C) int    wxSpinButton_GetMin(IntPtr self);
		static extern (C) int    wxSpinButton_GetMax(IntPtr self);
		static extern (C) void   wxSpinButton_SetValue(IntPtr self, int val);
		static extern (C) void   wxSpinButton_SetRange(IntPtr self, int minVal, int maxVal);
		//! \endcond

		//---------------------------------------------------------------------
	alias SpinButton wxSpinButton;
	public class SpinButton : Control
	{
		// These are duplicated in SpinCtrl.cs (for easier access)
		enum {
			wxSP_HORIZONTAL       = Orientation.wxHORIZONTAL,
			wxSP_VERTICAL         = Orientation.wxVERTICAL,
			wxSP_ARROW_KEYS       = 0x1000,
			wxSP_WRAP             = 0x2000,
		}
	
		public const string wxSPIN_BUTTON_NAME = "SpinButton";
		//---------------------------------------------------------------------
        
		
		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent, int id /*= wxID_ANY*/, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxSP_VERTICAL | wxSP_ARROW_KEYS, string name = wxSPIN_BUTTON_NAME);
		public static wxObject New(IntPtr wxobj) ;
		public this(Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxSP_VERTICAL | wxSP_ARROW_KEYS, string name = wxSPIN_BUTTON_NAME);
		public bool Create(Window parent, int id, inout Point pos, inout Size size,  int style, string name);
		public int Value();
		public void Value(int value);
		public int Max() ;
		public int Min() ;
		public void SetRange(int min, int max);
	}
