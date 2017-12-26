
module wx.FocusEvent;
public import wx.common;

public import wx.Window;
public import wx.Event;

		//! \cond EXTERN
		static extern (C) IntPtr wxFocusEvent_ctor(int type,int winid);
		static extern (C) IntPtr wxFocusEvent_GetWindow(IntPtr self);
		static extern (C) void   wxFocusEvent_SetWindow(IntPtr self, IntPtr win);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias FocusEvent wxFocusEvent;
	public class FocusEvent : Event
	{
		public this(IntPtr wxobj);
		public this(EventType type = wxEVT_NULL, int winid = 0);
		public Window window() ;
		public void window(Window value);
		private static Event New(IntPtr obj);
		static this()
		{
			AddEventType(wxEVT_SET_FOCUS,				&FocusEvent.New);
			AddEventType(wxEVT_KILL_FOCUS,				&FocusEvent.New);
		}
	}
