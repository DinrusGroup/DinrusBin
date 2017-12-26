module wx.NotebookSizer;
public import wx.common;
public import wx.Sizer;
public import wx.Notebook;

		//! \cond EXTERN
		static extern (C) IntPtr wxNotebookSizer_ctor(IntPtr nb);
		static extern (C) void wxNotebookSizer_RecalcSizes(IntPtr self);
		static extern (C) void wxNotebookSizer_CalcMin(IntPtr self, inout Size size);
		static extern (C) IntPtr wxNotebookSizer_GetNotebook(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------

	alias NotebookSizer wxNotebookSizer;
	/*deprecated*/ public class NotebookSizer : Sizer
	{
		public this(IntPtr wxobj);
		public this(Notebook nb);
		public override void RecalcSizes();
		public override Size CalcMin();
		public Notebook notebook() ;
	}
