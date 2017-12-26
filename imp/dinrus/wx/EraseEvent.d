module wx.EraseEvent;
public import wx.common;

public import wx.Event;
public import wx.DC;

		//! \cond EXTERN
		static extern (C) IntPtr wxEraseEvent_ctor(int id, IntPtr dc);
		static extern (C) IntPtr wxEraseEvent_GetDC(IntPtr self);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias EraseEvent wxEraseEvent;
	public class EraseEvent : Event
	{
		public this(IntPtr wxobj) ;
		public this(int id=0, DC dc = null);
		public DC GetDC() ;
		private static Event New(IntPtr obj);
		static this();
	}
