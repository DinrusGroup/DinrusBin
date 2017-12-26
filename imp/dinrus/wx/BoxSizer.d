module wx.BoxSizer;
public import wx.common;
public import wx.Sizer;

		//! \cond EXTERN
		extern(C) {
		alias void function(BoxSizer obj) Virtual_voidvoid;
		alias void function(BoxSizer obj,out Size size) Virtual_wxSizevoid;
		}

		static extern (C) void wxBoxSizer_RegisterVirtual(IntPtr self, BoxSizer obj, Virtual_voidvoid recalcSizes, Virtual_wxSizevoid calcMin);
		static extern (C) void wxBoxSizer_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);

		static extern (C) IntPtr wxBoxSizer_ctor(int orient);
		static extern (C) void wxBoxSizer_RecalcSizes(IntPtr self);
		static extern (C) void wxBoxSizer_CalcMin(IntPtr self,out Size size);
		static extern (C) int wxBoxSizer_GetOrientation(IntPtr self);
		static extern (C) void wxBoxSizer_SetOrientation(IntPtr self, int orient);
		//! \endcond

		//---------------------------------------------------------------------

	alias BoxSizer wxBoxSizer;
	public class BoxSizer : Sizer
	{
		public this(IntPtr wxobj);
		public this(int orient);
		extern(C) private static void staticRecalcSizes(BoxSizer obj);
		extern(C) private static void staticCalcMin(BoxSizer obj,out Size size);
		public override void RecalcSizes();
		public override Size CalcMin();
		public int Orientation() ;
		public void Orientation(int value);
	}
