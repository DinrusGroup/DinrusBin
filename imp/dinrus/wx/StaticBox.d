module wx.StaticBox;
public import wx.common;
public import wx.Control;

		//! \cond EXTERN
		static extern (C) IntPtr wxStaticBox_ctor();
		static extern (C) bool wxStaticBox_Create(IntPtr self, IntPtr parent, int id, string label, inout Point pos, inout Size size, uint style, string name);
		//! \endcond
	
		//---------------------------------------------------------------------

	alias StaticBox wxStaticBox;
	public class StaticBox : Control
	{
		public const string wxStaticBoxNameStr = "groupBox";

		public this();
		public this(IntPtr wxobj);
		public this(Window window, int id, string label, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, string name = wxStaticBoxNameStr);
		public static wxObject New(IntPtr wxobj);
		public this(Window window, string label, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, string name = wxStaticBoxNameStr);
		public bool Create(Window window, int id, string label, inout Point pos, inout Size size, int style, string name);
	}
