module wx.StaticLine;
public import wx.common;
public import wx.Control;

		//! \cond EXTERN
		static extern (C) IntPtr wxStaticLine_ctor();
		static extern (C) bool wxStaticLine_Create(IntPtr self, IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
		static extern (C) bool wxStaticLine_IsVertical(IntPtr self);
		static extern (C) int  wxStaticLine_GetDefaultSize(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------

	alias StaticLine wxStaticLine;
	public class StaticLine : Control
	{
		enum {
			wxLI_HORIZONTAL	= Orientation.wxHORIZONTAL,
			wxLI_VERTICAL		= Orientation.wxVERTICAL,
		}
		
		public const string wxStaticTextNameStr = "message";
		//---------------------------------------------------------------------
		
		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent, int id, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxLI_HORIZONTAL, string name = wxStaticTextNameStr);
		public static wxObject New(IntPtr wxobj) ;
		public this(Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxLI_HORIZONTAL, string name = wxStaticTextNameStr);
		public bool Create(Window parent, int id, inout Point pos, inout Size size, int style, string name);
		public bool IsVertical();
		public int DefaultSize() ;
	}
