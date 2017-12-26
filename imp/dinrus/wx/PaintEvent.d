module wx.PaintEvent;
public import wx.common;

public import wx.Event;

		//! \cond EXTERN
		static extern (C) IntPtr wxPaintEvent_ctor(int Id);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias PaintEvent wxPaintEvent;
	public class PaintEvent : Event
	{
		public this(IntPtr wxobj) ;
		public this(int Id=0);
	}
