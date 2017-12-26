module wx.Control;
public import wx.common;
public import wx.Window;

		//! \cond EXTERN
		static extern (C) void   wxControl_Command(IntPtr self, IntPtr evt);
		static extern (C) IntPtr wxControl_GetLabel(IntPtr self);
		static extern (C) void   wxControl_SetLabel(IntPtr self, string label);
		
		static extern (C) int wxControl_GetAlignment(IntPtr self);
		static extern (C) bool wxControl_SetFont(IntPtr self, IntPtr font);
		//! \endcond

		//---------------------------------------------------------------------

	alias Control wxControl;
	/// This is the base class for a control or "widget".
	/// A control is generally a small window which processes user input
	/// and/or displays one or more item of data.
	public class Control : Window
	{
		const string wxControlNameStr = "control";
	
		public this(IntPtr wxobj) ;
		public this(Window parent, int id, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=0, string name=wxControlNameStr);
		public this(Window parent, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=0, string name=wxControlNameStr);
		public static wxObject New(IntPtr wxobj) ;
		public void Command();
		public string Label() ;
		public void Label(string value) ;
		public int GetAlignment();
		public bool SetFont(Font font);
	}

