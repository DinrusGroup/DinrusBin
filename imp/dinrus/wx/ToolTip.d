module wx.ToolTip;
public import wx.common;
public import wx.Window;

		//! \cond EXTERN
		static extern (C) void   wxToolTip_Enable(bool flag);
		static extern (C) void   wxToolTip_SetDelay(uint msecs);
		static extern (C) IntPtr wxToolTip_ctor(string tip);
		static extern (C) void   wxToolTip_SetTip(IntPtr self, string tip);
		static extern (C) IntPtr wxToolTip_GetTip(IntPtr self);
		static extern (C) IntPtr wxToolTip_GetWindow(IntPtr self);
		static extern (C) void   wxToolTip_SetWindow(IntPtr self,IntPtr win);
		//! \endcond

        //---------------------------------------------------------------------

	alias ToolTip wxToolTip;
	public class ToolTip : wxObject
	{
        public this(IntPtr wxobj);
        public this(string tip);
        static void Enabled(bool value) ;
        static void Delay(int value) ;
        public string Tip() ;
        public void Tip(string value) ;
        public Window window() ;
        public void window(Window win) ;
	}

