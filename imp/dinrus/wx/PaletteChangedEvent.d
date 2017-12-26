
module wx.PaletteChangedEvent;
public import wx.common;

public import wx.Event;

public import wx.Window;

		//! \cond EXTERN
		static extern (C) IntPtr wxPaletteChangedEvent_ctor(int winid);
		static extern (C) void wxPaletteChangedEvent_SetChangedWindow(IntPtr self, IntPtr win);
		static extern (C) IntPtr wxPaletteChangedEvent_GetChangedWindow(IntPtr self);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias PaletteChangedEvent wxPaletteChangedEvent;
	public class PaletteChangedEvent : Event
	{
		public this(IntPtr wxobj) ;
		public this(int winid=0);
		public Window ChangedWindow() ;
		public void ChangedWindow(Window value);
		private static Event New(IntPtr obj);
		static this()
		{
			AddEventType(wxEVT_PALETTE_CHANGED,			&PaletteChangedEvent.New);
		}
	}
