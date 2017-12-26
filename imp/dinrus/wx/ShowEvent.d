
module wx.ShowEvent;
public import wx.common;

public import wx.Event;

		//! \cond EXTERN
		static extern (C) IntPtr wxShowEvent_ctor(int winid, bool show);
		static extern (C) bool wxShowEvent_GetShow(IntPtr self);
		static extern (C) void wxShowEvent_SetShow(IntPtr self, bool show);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias ShowEvent wxShowEvent;
	public class ShowEvent : Event
	{
		public this(IntPtr wxobj) ;
		public this(int winid = 0, bool show = false);
		public bool Show() ;
		public void Show(bool value);
		private static Event New(IntPtr obj) ;
		static this();
	}
