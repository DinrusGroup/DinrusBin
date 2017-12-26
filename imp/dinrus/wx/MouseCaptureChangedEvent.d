module wx.MouseCaptureChangedEvent;
public import wx.common;

public import wx.Event;

public import wx.Window;

		//! \cond EXTERN
		static extern (C) IntPtr wxMouseCaptureChangedEvent_ctor(int winid,IntPtr gainedCapture);
		static extern (C) IntPtr wxMouseCaptureChangedEvent_GetCapturedWindow(IntPtr self);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias MouseCaptureChangedEvent wxMouseCaptureChangedEvent;
	public class MouseCaptureChangedEvent : Event
	{
		public this(IntPtr wxobj) ;
		public this(int winid = 0, Window gainedCapture = null);
		public Window CapturedWindow();
		private static Event New(IntPtr obj);
		static this()
		{
			AddEventType(wxEVT_MOUSE_CAPTURE_CHANGED,		&MouseCaptureChangedEvent.New);
		}
	}
