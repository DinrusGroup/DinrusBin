module wx.GridBagSizer;
public import wx.common;
public import wx.SizerItem;
public import wx.FlexGridSizer;

//version(LDC) { pragma(ldc, "verbose") }

		//! \cond EXTERN
        static extern (C) IntPtr wxGBSizerItem_ctor(int width, int height, IntPtr pos, IntPtr span, int flag, int border, IntPtr userData);
        static extern (C) IntPtr wxGBSizerItem_ctorWindow(IntPtr window, IntPtr pos, IntPtr span, int flag, int border, IntPtr userData);
        static extern (C) IntPtr wxGBSizerItem_ctorSizer(IntPtr sizer, IntPtr pos, IntPtr span, int flag, int border, IntPtr userData);
        static extern (C) IntPtr wxGBSizerItem_ctorDefault();

        static extern (C) IntPtr wxGBSizerItem_GetPos(IntPtr self);

        static extern (C) IntPtr wxGBSizerItem_GetSpan(IntPtr self);
        //static extern (C) void   wxGBSizerItem_GetSpan(IntPtr self, IntPtr rowspan, IntPtr colspan);

        static extern (C) bool   wxGBSizerItem_SetPos(IntPtr self, IntPtr pos);
        static extern (C) bool   wxGBSizerItem_SetSpan(IntPtr self, IntPtr span);

        static extern (C) bool   wxGBSizerItem_IntersectsSizer(IntPtr self, IntPtr other);
        static extern (C) bool   wxGBSizerItem_IntersectsSpan(IntPtr self, IntPtr pos, IntPtr span);

        static extern (C) void   wxGBSizerItem_GetEndPos(IntPtr self, inout int row, inout int col);
        static extern (C) IntPtr wxGBSizerItem_GetGBSizer(IntPtr self);
        static extern (C) void   wxGBSizerItem_SetGBSizer(IntPtr self, IntPtr sizer);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias GBSizerItem wxGBSizerItem;
    public class GBSizerItem : SizerItem
    {
        public this(int width, int height, GBPosition pos, GBSpan span, int flag, int border, wxObject userData);
        public this(Window window, GBPosition pos, GBSpan span, int flag, int border, wxObject userData);
        public this(Sizer sizer, GBPosition pos, GBSpan span, int flag, int border, wxObject userData);
        public this();
        public this(IntPtr wxobj) ;
        public GBPosition Pos();
        public void Pos(GBPosition value) ;
        public GBSpan Span() ;
        public void Span(GBSpan value) ;
        public bool Intersects(GBSizerItem other);
        public bool Intersects(GBPosition pos, GBSpan span);
        public void GetEndPos(inout int row, inout int col);
        public GridBagSizer GBSizer() ;
        public void GBSizer(GridBagSizer value) ;
	public static wxObject New(IntPtr ptr) ;
    }

		//! \cond EXTERN
        static extern (C) IntPtr wxGBSpan_ctorDefault();
        static extern (C) IntPtr wxGBSpan_ctor(int rowspan, int colspan);

        static extern (C) void   wxGBSpan_SetRowspan(IntPtr self, int rowspan);
        static extern (C) int    wxGBSpan_GetRowspan(IntPtr self);
        static extern (C) int    wxGBSpan_GetColspan(IntPtr self);
        static extern (C) void   wxGBSpan_SetColspan(IntPtr self, int colspan);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias GBSpan wxGBSpan;
    public class GBSpan : wxObject
    {
        public this();
        public this(int rowspan, int colspan);
        private this(IntPtr ptr);
	public static wxObject New(IntPtr ptr);
        public int Rowspan() ;
        public void Rowspan(int value) ;
        public int Colspan();
        public void Colspan(int value) ;
    }

		//! \cond EXTERN
        static extern (C) IntPtr wxGridBagSizer_ctor(int vgap, int hgap);
        static extern (C) bool   wxGridBagSizer_AddWindow(IntPtr self, IntPtr window, IntPtr pos, IntPtr span, int flag, int border, IntPtr userData);
        static extern (C) bool   wxGridBagSizer_AddSizer(IntPtr self, IntPtr sizer, IntPtr pos, IntPtr span, int flag, int border, IntPtr userData);
        static extern (C) bool   wxGridBagSizer_Add(IntPtr self, int width, int height, IntPtr pos, IntPtr span, int flag, int border, IntPtr userData);
        static extern (C) bool   wxGridBagSizer_AddItem(IntPtr self, IntPtr item);

        static extern (C) void   wxGridBagSizer_GetEmptyCellSize(IntPtr self, inout Size size);
        static extern (C) void   wxGridBagSizer_SetEmptyCellSize(IntPtr self, inout Size sz);
        static extern (C) void   wxGridBagSizer_GetCellSize(IntPtr self, int row, int col, inout Size size);

        static extern (C) IntPtr wxGridBagSizer_GetItemPositionWindow(IntPtr self, IntPtr window);
        static extern (C) IntPtr wxGridBagSizer_GetItemPositionSizer(IntPtr self, IntPtr sizer);
        static extern (C) IntPtr wxGridBagSizer_GetItemPositionIndex(IntPtr self, int index);
        static extern (C) bool   wxGridBagSizer_SetItemPositionWindow(IntPtr self, IntPtr window, IntPtr pos);
        static extern (C) bool   wxGridBagSizer_SetItemPositionSizer(IntPtr self, IntPtr sizer, IntPtr pos);
        static extern (C) bool   wxGridBagSizer_SetItemPositionIndex(IntPtr self, int index, IntPtr pos);

        static extern (C) IntPtr wxGridBagSizer_GetItemSpanWindow(IntPtr self, IntPtr window);
        static extern (C) IntPtr wxGridBagSizer_GetItemSpanSizer(IntPtr self, IntPtr sizer);
        static extern (C) IntPtr wxGridBagSizer_GetItemSpanIndex(IntPtr self, int index);
        static extern (C) bool   wxGridBagSizer_SetItemSpanWindow(IntPtr self, IntPtr window, IntPtr span);
        static extern (C) bool   wxGridBagSizer_SetItemSpanSizer(IntPtr self, IntPtr sizer, IntPtr span);
        static extern (C) bool   wxGridBagSizer_SetItemSpanIndex(IntPtr self, int index, IntPtr span);

        static extern (C) IntPtr wxGridBagSizer_FindItemWindow(IntPtr self, IntPtr window);
        static extern (C) IntPtr wxGridBagSizer_FindItemSizer(IntPtr self, IntPtr sizer);
        static extern (C) IntPtr wxGridBagSizer_FindItemAtPosition(IntPtr self, IntPtr pos);
        static extern (C) IntPtr wxGridBagSizer_FindItemAtPoint(IntPtr self, inout Point pt);
        static extern (C) IntPtr wxGridBagSizer_FindItemWithData(IntPtr self, IntPtr userData);

        static extern (C) bool   wxGridBagSizer_CheckForIntersectionItem(IntPtr self, IntPtr item, IntPtr excludeItem);
        static extern (C) bool   wxGridBagSizer_CheckForIntersectionPos(IntPtr self, IntPtr pos, IntPtr span, IntPtr excludeItem);
		//! \endcond

    alias GridBagSizer wxGridBagSizer;
    public class GridBagSizer : FlexGridSizer
    {
        //-----------------------------------------------------------------------------

        public this(int vgap, int hgap);
	    private this(IntPtr ptr);
    	public static wxObject New(IntPtr ptr) ;
        public bool Add(Window window, GBPosition pos, GBSpan span, int flag, int border, wxObject userData);
        public bool Add(Sizer sizer, GBPosition pos, GBSpan span, int flag, int border, wxObject userData);
        public bool Add(int width, int height, GBPosition pos, GBSpan span, int flag, int border, wxObject userData);
        public bool Add(GBSizerItem item);
        public Size EmptyCellSize() ;
        public void EmptyCellSize(Size value);
        public Size GetCellSize(int row, int col);
        public GBPosition GetItemPosition(Window window);
        public GBPosition GetItemPosition(Sizer sizer);
        public GBPosition GetItemPosition(int index);
        public bool SetItemPosition(Window window, GBPosition pos);
        public bool SetItemPosition(Sizer sizer, GBPosition pos);
        public bool SetItemPosition(int index, GBPosition pos);
        public GBSpan GetItemSpan(Window window);
        public GBSpan GetItemSpan(Sizer sizer);
        public GBSpan GetItemSpan(int index);
        public bool SetItemSpan(Window window, GBSpan span);
        public bool SetItemSpan(Sizer sizer, GBSpan span);
        public bool SetItemSpan(int index, GBSpan span);
        public GBSizerItem FindItem(Window window);
        public GBSizerItem FindItem(Sizer sizer);
        public GBSizerItem FindItemAtPosition(GBPosition pos);
        public GBSizerItem FindItemAtPoint(Point pt);
        public GBSizerItem FindItemWithData(wxObject userData);
        public bool CheckForIntersection(GBSizerItem item, GBSizerItem excludeItem);
        public bool CheckForIntersection(GBPosition pos, GBSpan span, GBSizerItem excludeItem);
    }

		//! \cond EXTERN
        static extern (C) IntPtr wxGBPosition_ctor();
        static extern (C) IntPtr wxGBPosition_ctorPos(int row, int col);
        static extern (C) int    wxGBPosition_GetRow(IntPtr self);
        static extern (C) int    wxGBPosition_GetCol(IntPtr self);
        static extern (C) void   wxGBPosition_SetRow(IntPtr self, int row);
        static extern (C) void   wxGBPosition_SetCol(IntPtr self, int col);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias GBPosition wxGBPosition;
    public class GBPosition : wxObject
    {
	private this(IntPtr ptr);
        public this();
        //public this(int row, int col);
        public int GetRow();
        public int GetCol();
        public void SetRow(int row);
        public void SetCol(int col);
	public static wxObject New(IntPtr ptr);
    }

