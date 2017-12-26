
module wx.IdleEvent;
public import wx.common;

public import wx.Event;
public import wx.Window;

	public enum IdleMode
	{
		wxIDLE_PROCESS_ALL,
		wxIDLE_PROCESS_SPECIFIED
	}
	
	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxIdleEvent_ctor();
		static extern (C) void   wxIdleEvent_RequestMore(IntPtr self, bool needMore);
		static extern (C) bool   wxIdleEvent_MoreRequested(IntPtr self);
		
		static extern (C) void   wxIdleEvent_SetMode(IdleMode mode);
		static extern (C) IdleMode wxIdleEvent_GetMode();
		static extern (C) bool   wxIdleEvent_CanSend(IntPtr win);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias IdleEvent wxIdleEvent;
	public class IdleEvent : Event
	{
		public this(IntPtr wxobj) ;
		public this();
		public void RequestMore();
		public void RequestMore(bool needMore);
		public bool MoreRequested();
		static IdleMode Mode() ;
		static void Mode(IdleMode value) ;
		public static bool CanSend(Window win);
		private static Event New(IntPtr obj);
		static this()
		{
			AddEventType(wxEVT_IDLE, 				&IdleEvent.New);
		}
	}
