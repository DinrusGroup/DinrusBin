module wx.WindowDestroyEvent;
public import wx.common;

public import wx.CommandEvent;

public import wx.Window;

		//! \cond EXTERN
		static extern (C) IntPtr wxWindowDestroyEvent_ctor(IntPtr type);
		static extern (C) IntPtr wxWindowDestroyEvent_GetWindow(IntPtr self);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias WindowDestroyEvent wxWindowDestroyEvent;
	public class WindowDestroyEvent : CommandEvent
	{
		public this(IntPtr wxobj) ;
		public this(Window win = null);
		public Window Active() ;
		private static Event New(IntPtr obj);
		static this();
	}
