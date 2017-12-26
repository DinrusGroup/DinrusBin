module wx.NavigationKeyEvent;
public import wx.common;

public import wx.Event;
public import wx.Window;

		//! \cond EXTERN
		static extern (C) IntPtr wxNavigationKeyEvent_ctor();
		static extern (C) bool wxNavigationKeyEvent_GetDirection(IntPtr self);
		static extern (C) void wxNavigationKeyEvent_SetDirection(IntPtr self, bool bForward);
		static extern (C) bool wxNavigationKeyEvent_IsWindowChange(IntPtr self);
		static extern (C) void wxNavigationKeyEvent_SetWindowChange(IntPtr self, bool bIs);
		static extern (C) IntPtr wxNavigationKeyEvent_GetCurrentFocus(IntPtr self);
		static extern (C) void wxNavigationKeyEvent_SetCurrentFocus(IntPtr self, IntPtr win);
		static extern (C) void wxNavigationKeyEvent_SetFlags(IntPtr self, uint flags);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias NavigationKeyEvent wxNavigationKeyEvent;
	public class NavigationKeyEvent : Event
	{
		public this(IntPtr wxobj) ;
		public this();
		public bool Direction();
		public void Direction(bool value);
		public bool WindowChange() ;
		public void WindowChange(bool value);
		public Window CurrentFocus() ;
		public void CurrentFocus(Window value) ;
		public void Flags(int value);
		private static Event New(IntPtr obj) ;
		static this()
		{
			AddEventType(wxEVT_NAVIGATION_KEY,			&NavigationKeyEvent.New);
		}
	}
