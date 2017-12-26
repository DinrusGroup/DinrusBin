module wx.DisplayChangedEvent;
public import wx.common;

public import wx.Event;

		//! \cond EXTERN
		static extern (C) IntPtr wxDisplayChangedEvent_ctor();
		//! \endcond

		//-----------------------------------------------------------------------------

	alias DisplayChangedEvent wxDisplayChangedEvent;
	public class DisplayChangedEvent : Event
	{
		public this(IntPtr wxobj) ;
		public this();
		private static Event New(IntPtr obj);
		    static this()
    {
        AddEventType(wxEVT_DISPLAY_CHANGED,			&DisplayChangedEvent.New);
    }
	}
