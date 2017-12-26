module wx.FlexGridSizer;
public import wx.common;
public import wx.GridSizer;

public enum FlexSizerGrowMode{
  NONE = 0,
  SPECIFIED,
  ALL
}

		//! \cond EXTERN
		static extern (C) IntPtr wxFlexGridSizer_ctor(int rows, int cols, int vgap, int hgap);
		static extern (C) void wxFlexGridSizer_dtor(IntPtr self);
		static extern (C) void wxFlexGridSizer_RecalcSizes(IntPtr self);
		static extern (C) void wxFlexGridSizer_CalcMin(IntPtr self, inout Size size);
		static extern (C) void wxFlexGridSizer_AddGrowableRow(IntPtr self, uint idx);
		static extern (C) void wxFlexGridSizer_RemoveGrowableRow(IntPtr self, uint idx);
		static extern (C) void wxFlexGridSizer_AddGrowableCol(IntPtr self, uint idx);
		static extern (C) void wxFlexGridSizer_RemoveGrowableCol(IntPtr self, uint idx);
                static extern (C) int wxFlexGridSizer_GetFlexibleDirection(IntPtr self);
                static extern (C) void wxFlexGridSizer_SetFlexibleDirection(IntPtr self, int direction);
static extern (C) FlexSizerGrowMode wxFlexGridSizer_GetNonFlexibleGrowMode(IntPtr self);
static extern (C) void wxFlexGridSizer_SetNonFlexibleGrowMode(IntPtr self,FlexSizerGrowMode mode);
		//! \endcond

		//---------------------------------------------------------------------

	alias FlexGridSizer wxFlexGridSizer;
	public class FlexGridSizer : GridSizer
	{
		public this(IntPtr wxobj);
        public this(int cols, int vgap, int hgap);
		public this(int rows, int cols, int vgap, int hgap);
		public override void RecalcSizes();
		public override Size CalcMin();
		public void AddGrowableRow(int idx);
		public void RemoveGrowableRow(int idx);
		public void AddGrowableCol(int idx);
		public void RemoveGrowableCol(int idx);
		public void SetFlexibleDirection(int direction);
		public int GetFlexibleDirection();
		public void SetNonFlexibleGrowMode(FlexSizerGrowMode mode);
		public FlexSizerGrowMode  GetNonFlexibleGrowMode();
	}
