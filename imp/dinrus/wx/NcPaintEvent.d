module wx.NcPaintEvent;
public import wx.common;

public import wx.Event;

		//! \cond EXTERN
		static extern (C) IntPtr wxNcPaintEvent_ctor(int Id);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias NCPaintEvent wxNCPaintEvent;
	public class NCPaintEvent : Event
	{
		public this(IntPtr wxobj);
		public this(int Id=0);
		private static Event New(IntPtr obj);
		static this()
		{
			AddEventType(wxEVT_NC_PAINT,				&NCPaintEvent.New);
		}
	}
