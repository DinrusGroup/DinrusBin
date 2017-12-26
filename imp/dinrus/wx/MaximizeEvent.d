
module wx.MaximizeEvent;
public import wx.common;

public import wx.Event;

		//! \cond EXTERN
		static extern (C) IntPtr wxMaximizeEvent_ctor(int Id);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias MaximizeEvent wxMaximizeEvent;
	public class MaximizeEvent : Event
	{
		public this(IntPtr wxobj) ;
		public this(int Id = 0);
		private static Event New(IntPtr obj) ;
		static this()
		{
			AddEventType(wxEVT_MAXIMIZE,				&MaximizeEvent.New);		}
	}
