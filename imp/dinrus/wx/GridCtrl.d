module wx.GridCtrl;
public import wx.common;
public import wx.Grid;

		//! \cond EXTERN
		static extern (C) IntPtr wxGridCellDateTimeRenderer_ctor(string outformat, string informat);
		static extern (C) void wxGridCellDateTimeRenderer_dtor(IntPtr self);
		static extern (C) void wxGridCellDateTimeRenderer_Draw(IntPtr self, IntPtr grid, IntPtr attr, IntPtr dc, inout Rectangle rect, int row, int col, bool isSelected);
		static extern (C) void wxGridCellDateTimeRenderer_GetBestSize(IntPtr self, IntPtr grid, IntPtr attr, IntPtr dc, int row, int col, out Size size);
		static extern (C) IntPtr wxGridCellDateTimeRenderer_Clone(IntPtr self);
		static extern (C) void wxGridCellDateTimeRenderer_SetParameters(IntPtr self, string parameter);
		//! \endcond
		
	alias GridCellDateTimeRenderer wxGridCellDateTimeRenderer;
	public class GridCellDateTimeRenderer : GridCellStringRenderer
	{
		public this();
		public this(string outformat);
		public this(string outformat, string informat);
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		override protected void dtor() ;
		public override void SetParameters(string parameter);
		public override void Draw(Grid grid, GridCellAttr attr, DC dc, Rectangle rect, int row, int col, bool isSelected);
		public override Size GetBestSize(Grid grid, GridCellAttr attr, DC dc, int row, int col);
		public override GridCellRenderer Clone();
	}
	
	//-----------------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxGridCellEnumRenderer_ctor(int n, string* choices);
		static extern (C) void wxGridCellEnumRenderer_dtor(IntPtr self);
		static extern (C) void wxGridCellEnumRenderer_Draw(IntPtr self, IntPtr grid, IntPtr attr, IntPtr dc, inout Rectangle rect, int row, int col, bool isSelected);
		static extern (C) void wxGridCellEnumRenderer_GetBestSize(IntPtr self, IntPtr grid, IntPtr attr, IntPtr dc, int row, int col, out Size size);
		static extern (C) IntPtr wxGridCellEnumRenderer_Clone(IntPtr self);
		static extern (C) void wxGridCellEnumRenderer_SetParameters(IntPtr self, string parameter);
		//! \endcond
		
	alias GridCellEnumRenderer wxGridCellEnumRenderer;
	public class GridCellEnumRenderer : GridCellStringRenderer
	{
		public this();
		public this(string[] choices);
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		private override void dtor() ;
		public override void SetParameters(string parameter);
		public override void Draw(Grid grid, GridCellAttr attr, DC dc, Rectangle rect, int row, int col, bool isSelected);
		public override Size GetBestSize(Grid grid, GridCellAttr attr, DC dc, int row, int col);
		public override GridCellRenderer Clone();
	}
	
	//-----------------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxGridCellEnumEditor_ctor(int n, string[] choices);
		static extern (C) void wxGridCellEnumEditor_dtor(IntPtr self);
		static extern (C) void wxGridCellEnumEditor_BeginEdit(IntPtr self, int row, int col, IntPtr grid);
		static extern (C) bool wxGridCellEnumEditor_EndEdit(IntPtr self, int row, int col, IntPtr grid);
		static extern (C) IntPtr wxGridCellEnumEditor_Clone(IntPtr self);
		//! \endcond
		
	alias GridCellEnumEditor wxGridCellEnumEditor;
	public class GridCellEnumEditor : GridCellChoiceEditor
	{
		public this();
		public this(string[] choices);
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		private override void dtor();
		public override void BeginEdit(int row, int col, Grid grid);
		public override bool EndEdit(int row, int col, Grid grid);
		public override GridCellEditor Clone();
	}
	
	//-----------------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxGridCellAutoWrapStringEditor_ctor();
		static extern (C) void wxGridCellAutoWrapStringEditor_dtor(IntPtr self);
		static extern (C) void wxGridCellAutoWrapStringEditor_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
		static extern (C) void wxGridCellAutoWrapStringEditor_Create(IntPtr self, IntPtr parent, int id, IntPtr evtHandler);
		static extern (C) IntPtr wxGridCellAutoWrapStringEditor_Clone(IntPtr self);
		//! \endcond
		
	alias GridCellAutoWrapStringEditor wxGridCellAutoWrapStringEditor;
	public class GridCellAutoWrapStringEditor : GridCellTextEditor
	{
		public this();
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		override protected void dtor() ;
		public override void Create(Window parent, int id, EvtHandler evtHandler);
		public override GridCellEditor Clone();
	}
	
	//-----------------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxGridCellAutoWrapStringRenderer_ctor();
		static extern (C) void wxGridCellAutoWrapStringRenderer_dtor(IntPtr self);
		static extern (C) void   wxGridCellAutoWrapStringRenderer_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
		static extern (C) void wxGridCellAutoWrapStringRenderer_Draw(IntPtr self, IntPtr grid, IntPtr attr, IntPtr dc, inout Rectangle rect, int row, int col, bool isSelected);
		static extern (C) void wxGridCellAutoWrapStringRenderer_GetBestSize(IntPtr self, IntPtr grid, IntPtr attr, IntPtr dc, int row, int col, out Size size);
		static extern (C) IntPtr wxGridCellAutoWrapStringRenderer_Clone(IntPtr self);
		//! \endcond
		
	alias GridCellAutoWrapStringRenderer wxGridCellAutoWrapStringRenderer;
	public class GridCellAutoWrapStringRenderer : GridCellStringRenderer
	{
		public this();
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		override protected void dtor() ;
		public override void Draw(Grid grid, GridCellAttr attr, DC dc, Rectangle rect, int row, int col, bool isSelected);
		public override Size GetBestSize(Grid grid, GridCellAttr attr, DC dc, int row, int col);
		public override GridCellRenderer Clone();
	}
