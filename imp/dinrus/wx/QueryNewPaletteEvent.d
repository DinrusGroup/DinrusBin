
module wx.QueryNewPaletteEvent;
public import wx.common;

public import wx.Event;

		//! \cond EXTERN
		static extern (C) IntPtr wxQueryNewPaletteEvent_ctor(int winid);
		static extern (C) bool wxQueryNewPaletteEvent_GetPaletteRealized(IntPtr self);
		static extern (C) void wxQueryNewPaletteEvent_SetPaletteRealized(IntPtr self, bool realized);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias QueryNewPaletteEvent wxQueryNewPaletteEvent;
	public class QueryNewPaletteEvent : Event
	{
		public this(IntPtr wxobj) ;
		public this(int winid=0);
		public bool Realized();
		public void Realized(bool value);
		private static Event New(IntPtr obj) ;
		static this()
		{
			AddEventType(wxEVT_QUERY_NEW_PALETTE,			&QueryNewPaletteEvent.New);
		}
	}
