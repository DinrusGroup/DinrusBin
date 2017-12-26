module wx.HelpEvent;
public import wx.common;
public import wx.CommandEvent;
public import wx.Window;

		//! \cond EXTERN
		static extern (C) IntPtr wxHelpEvent_ctor(int type,int winid, inout Point pos);
		static extern (C) void   wxHelpEvent_GetPosition(IntPtr self, inout Point pos);
		static extern (C) void   wxHelpEvent_SetPosition(IntPtr self, inout Point pos);
		static extern (C) IntPtr wxHelpEvent_GetLink(IntPtr self);
		static extern (C) void   wxHelpEvent_SetLink(IntPtr self, string link);
		static extern (C) IntPtr wxHelpEvent_GetTarget(IntPtr self);
		static extern (C) void   wxHelpEvent_SetTarget(IntPtr self, string target);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias HelpEvent wxHelpEvent;
	public class HelpEvent : CommandEvent
	{
		public this(IntPtr wxobj);
		public this(EventType type = wxEVT_NULL, int winid = 0, Point pos = Window.wxDefaultPosition);
		public Point Position();
		public void Position(Point value);
		public string Link() ;
		public void Link(string value);
		public string Target() ;
		public void Target(string value);
		private static Event New(IntPtr obj);
		static this()
		{
			AddEventType(wxEVT_HELP,				&HelpEvent.New);
			AddEventType(wxEVT_DETAILED_HELP,			&HelpEvent.New);
		}
	}
