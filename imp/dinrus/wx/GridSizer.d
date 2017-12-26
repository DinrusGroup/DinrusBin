module wx.GridSizer;
public import wx.common;
public import wx.Sizer;

		//! \cond EXTERN
		static extern (C) IntPtr wxGridSizer_ctor(int rows, int cols, int vgap, int hgap);
		static extern (C) void wxGridSizer_RecalcSizes(IntPtr self);
		static extern (C) void wxGridSizer_CalcMin(IntPtr self, inout Size size);
		static extern (C) void wxGridSizer_SetCols(IntPtr self, int cols);
		static extern (C) void wxGridSizer_SetRows(IntPtr self, int rows);
		static extern (C) void wxGridSizer_SetVGap(IntPtr self, int gap);
		static extern (C) void wxGridSizer_SetHGap(IntPtr self, int gap);
		static extern (C) int wxGridSizer_GetCols(IntPtr self);
		static extern (C) int wxGridSizer_GetRows(IntPtr self);
		static extern (C) int wxGridSizer_GetVGap(IntPtr self);
		static extern (C) int wxGridSizer_GetHGap(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------

	alias GridSizer wxGridSizer;
	public class GridSizer : Sizer
	{
		public this(IntPtr wxobj);
		public this(int rows, int cols, int vgap, int hgap);
		public this(int cols, int vgap = 0, int hgap = 0);
		public override void RecalcSizes();
		public override Size CalcMin();
		public void Cols(int value);
		public int Cols() ;
		public void Rows(int value) ;
		public int Rows() ;
		public void VGap(int value) ;
		public int VGap() ;
		public void HGap(int value) ;
		public int HGap() ;
	}
