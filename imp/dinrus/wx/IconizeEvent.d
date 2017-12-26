module wx.IconizeEvent;
public import wx.common;

public import wx.Event;

		//! \cond EXTERN
		static extern (C) IntPtr wxIconizeEvent_ctor(int winid,bool iconized);
		static extern (C) bool wxIconizeEvent_Iconized(IntPtr self);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias IconizeEvent wxIconizeEvent;
	public class IconizeEvent : Event
	{
		public this(IntPtr wxobj) ;
		public this(int winid = 0, bool iconized = true);
		public bool Iconized() ;
		private static Event New(IntPtr obj) ;
		static this()
		{
			AddEventType(wxEVT_ICONIZE,				&IconizeEvent.New);
		}
	}
