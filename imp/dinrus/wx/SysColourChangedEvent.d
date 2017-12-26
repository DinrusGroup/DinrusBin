
module wx.SysColourChangedEvent;
public import wx.common;

public import wx.Event;

		//! \cond EXTERN
		static extern (C) IntPtr wxSysColourChangedEvent_ctor();
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias SysColourChangedEvent wxSysColourChangedEvent;
	public class SysColourChangedEvent : Event
	{
		public this(IntPtr wxobj) ;
		public this();
		private static Event New(IntPtr obj) ;
		static this();
	}
