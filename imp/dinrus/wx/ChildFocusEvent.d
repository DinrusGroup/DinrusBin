module wx.ChildFocusEvent;
public import wx.common;

public import wx.CommandEvent;
public import wx.Window;

		//! \cond EXTERN
		static extern (C) IntPtr wxChildFocusEvent_ctor(IntPtr win);
		static extern (C) IntPtr wxChildFocusEvent_GetWindow(IntPtr self);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias ChildFocusEvent wxChildFocusEvent;
	public class ChildFocusEvent : CommandEvent
	{
		public this(IntPtr wxobj);
		public this(Window win);
		public Window window() ;
		private static Event New(IntPtr obj) ;
		    static this()
    {
        AddEventType(wxEVT_CHILD_FOCUS,				&ChildFocusEvent.New);
    }
	}
