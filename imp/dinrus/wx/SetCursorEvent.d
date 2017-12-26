module wx.SetCursorEvent;
public import wx.common;

public import wx.Event;

public import wx.Cursor;

		//! \cond EXTERN
		static extern (C) IntPtr	wxSetCursorEvent_ctor(int x,int y);
		static extern (C) int		wxSetCursorEvent_GetX(IntPtr self);
		static extern (C) int		wxSetCursorEvent_GetY(IntPtr self);
		static extern (C) void		wxSetCursorEvent_SetCursor(IntPtr self, IntPtr cursor);
		static extern (C) IntPtr	wxSetCursorEvent_GetCursor(IntPtr self);
		static extern (C) bool		wxSetCursorEvent_HasCursor(IntPtr self);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias SetCursorEvent wxSetCursorEvent;
	public class SetCursorEvent : Event
	{
		public this(IntPtr wxobj) ;
		public this(int x=0,int y=0);
		public int X();
		public int Y();
		public Cursor cursor();
		public void cursor(Cursor value) ;
		public bool HasCursor();
		private static Event New(IntPtr obj);
		static this();
	}
