
module wx.InitDialogEvent;
public import wx.common;
public import wx.Event;

		//! \cond EXTERN
		static extern (C) IntPtr wxInitDialogEvent_ctor(int Id);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias InitDialogEvent wxInitDialogEvent;
	public class InitDialogEvent : Event
	{
		public this(IntPtr wxobj) ;
		public this(int Id = 0);
		private static Event New(IntPtr obj);
		static this()
		{
			AddEventType(wxEVT_INIT_DIALOG,				&InitDialogEvent.New);
		}
	}
