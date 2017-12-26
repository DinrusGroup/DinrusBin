module wx.ActivateEvent;
public import wx.common;
public import wx.Event;

		//! \cond EXTERN
		static extern (C) IntPtr wxActivateEvent_ctor(int type, bool active,int Id);
		static extern (C) bool wxActivateEvent_GetActive(IntPtr self);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias ActivateEvent wxActivateEvent;
	public class ActivateEvent : Event
	{
		public this(IntPtr wxobj);
		public this(EventType type = wxEVT_NULL, bool active = true, int Id = 0);
		public bool Active() ;
		private static Event New(IntPtr obj);
		    static this()
    {
        AddEventType(wxEVT_ACTIVATE,                        &ActivateEvent.New);
    }
	}
