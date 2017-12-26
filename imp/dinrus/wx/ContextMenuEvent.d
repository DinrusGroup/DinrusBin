module wx.ContextMenuEvent;
public import wx.common;

public import wx.CommandEvent;
public import wx.Window;

		//! \cond EXTERN
		static extern (C) IntPtr wxContextMenuEvent_ctor(int type,int winid, inout Point pos);
		static extern (C) void   wxContextMenuEvent_GetPosition(IntPtr self, inout Point pos);
		static extern (C) void   wxContextMenuEvent_SetPosition(IntPtr self, inout Point pos);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias ContextMenuEvent wxContextMenuEvent;
	public class ContextMenuEvent : CommandEvent
	{
		public this(IntPtr wxobj) ;
		public this(EventType type = wxEVT_NULL, int winid = 0,Point pt = Window.wxDefaultPosition);
		public Point Position() ;
		public void Position(Point value) ;
		private static Event New(IntPtr obj) ;
		    static this()
    {
        AddEventType(wxEVT_CONTEXT_MENU,			&ContextMenuEvent.New);
    }
	}
