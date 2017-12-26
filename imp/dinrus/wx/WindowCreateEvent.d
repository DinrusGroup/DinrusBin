module wx.WindowCreateEvent;
public import wx.common;

public import wx.CommandEvent;

public import wx.Window;

		//! \cond EXTERN
		static extern (C) IntPtr wxWindowCreateEvent_ctor(IntPtr type);
		static extern (C) IntPtr wxWindowCreateEvent_GetWindow(IntPtr self);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias WindowCreateEvent wxWindowCreateEvent;
	public class WindowCreateEvent : CommandEvent
	{
		public this(IntPtr wxobj) ;
		public this(Window win = null);
		public Window Active() ;
		private static Event New(IntPtr obj) ;
		static this();
	}
