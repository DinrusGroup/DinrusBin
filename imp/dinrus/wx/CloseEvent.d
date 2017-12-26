module wx.CloseEvent;
public import wx.common;
public import wx.Event;

		//! \cond EXTERN
		static extern (C) IntPtr wxCloseEvent_ctor(int type,int winid);
		static extern (C) void wxCloseEvent_SetLoggingOff(IntPtr self, bool logOff);
		static extern (C) bool wxCloseEvent_GetLoggingOff(IntPtr self);
		static extern (C) void wxCloseEvent_Veto(IntPtr self, bool veto);
		static extern (C) void wxCloseEvent_SetCanVeto(IntPtr self, bool canVeto);
		static extern (C) bool wxCloseEvent_CanVeto(IntPtr self);
		static extern (C) bool wxCloseEvent_GetVeto(IntPtr self);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias CloseEvent wxCloseEvent;
	public class CloseEvent : Event
	{
		public this(IntPtr wxobj);
		public this(EventType type = wxEVT_NULL, int winid = 0);
		public bool LoggingOff();
		public void LoggingOff(bool value) ;
		public void Veto();
		public void Veto(bool veto);
		public void CanVeto(bool value);
		public bool CanVeto() ;
		public bool GetVeto() ;
		private static Event New(IntPtr obj);
		    static this()
    {
        AddEventType(wxEVT_CLOSE_WINDOW,                    &CloseEvent.New);
        AddEventType(wxEVT_END_SESSION,                     &CloseEvent.New);
        AddEventType(wxEVT_QUERY_END_SESSION,               &CloseEvent.New);
    }
	}
