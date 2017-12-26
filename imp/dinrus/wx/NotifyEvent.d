module wx.NotifyEvent;
public import wx.common;
public import wx.CommandEvent;


		//! \cond EXTERN
		static extern (C) IntPtr wxNotifyEvent_ctor(EventType commandtype,int winid);
		static extern (C) void   wxNotifyEvent_Veto(IntPtr self);
		static extern (C) void   wxNotifyEvent_Allow(IntPtr self);
		static extern (C) bool   wxNotifyEvent_IsAllowed(IntPtr self);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias NotifyEvent wxNotifyEvent;
	public class NotifyEvent : CommandEvent
	{

		public this(IntPtr wxobj) ;
		public this(EventType commandtype = wxEVT_NULL,int winid = 0);
		public void Veto();
		public void Allow() ;
		public void IsAllowed();
	}
