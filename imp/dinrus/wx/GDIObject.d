
module wx.GDIObject;
public import wx.common;

		//! \cond EXTERN
		static extern (C) void wxGDIObj_dtor(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------

	alias GDIObject wxGDIObject;
	public class GDIObject : wxObject
	{
		public this(IntPtr wxobj) ;
		//public override void Dispose();
	}
