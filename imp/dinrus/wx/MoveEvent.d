module wx.MoveEvent;
public import wx.common;
public import wx.Event;

		//! \cond EXTERN
		static extern (C) IntPtr wxMoveEvent_ctor();
		static extern (C) IntPtr wxMoveEvent_GetPosition(IntPtr self, out Point point);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias MoveEvent wxMoveEvent;
	public class MoveEvent : Event
	{
		public this(IntPtr wxobj);
		public this();
		public Point Position() ;
		private static Event New(IntPtr obj);
		static this()
		{
			AddEventType(wxEVT_MOVE,                            &MoveEvent.New);
		}
	}
