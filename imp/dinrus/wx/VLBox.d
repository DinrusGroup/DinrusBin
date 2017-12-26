module wx.VLBox;
public import wx.common;
public import wx.VScroll;

		//! \cond EXTERN
		extern (C) {
		alias int function(VListBox obj, int n) Virtual_IntInt;
		alias void function(VListBox obj, IntPtr dc, Rectangle rect, int n) Virtual_VoidDcRectSizeT;
		}

		static extern (C) IntPtr wxVListBox_ctor(IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
		static extern (C) void wxVListBox_RegisterVirtual(IntPtr self, VListBox obj,
			Virtual_VoidDcRectSizeT onDrawItem,
			Virtual_IntInt onMeasureItem,
			Virtual_VoidDcRectSizeT onDrawSeparator,
			Virtual_VoidDcRectSizeT onDrawBackground,
			Virtual_IntInt onGetLineHeight);
		static extern (C) bool wxVListBox_Create(IntPtr self,IntPtr parent, int id, inout Point pos, inout Size size, int style, string name);
		static extern (C) void wxVListBox_OnDrawSeparator(IntPtr self, IntPtr dc, inout Rectangle rect, int n);
		static extern (C) void wxVListBox_OnDrawBackground(IntPtr self, IntPtr dc, inout Rectangle rect, int n);
		static extern (C) int wxVListBox_OnGetLineHeight(IntPtr self, int line);
		static extern (C) int wxVListBox_GetItemCount(IntPtr self);
		static extern (C) bool wxVListBox_HasMultipleSelection(IntPtr self);
		static extern (C) int wxVListBox_GetSelection(IntPtr self);
		static extern (C) bool wxVListBox_IsCurrent(IntPtr self, int item);
		static extern (C) bool wxVListBox_IsSelected(IntPtr self, int item);
		static extern (C) int wxVListBox_GetSelectedCount(IntPtr self);
		static extern (C) int wxVListBox_GetFirstSelected(IntPtr self, out uint cookie);
		static extern (C) int wxVListBox_GetNextSelected(IntPtr self, inout uint cookie);
		static extern (C) void wxVListBox_GetMargins(IntPtr self, out Point pt);
		static extern (C) IntPtr wxVListBox_GetSelectionBackground(IntPtr self);
		static extern (C) void wxVListBox_SetItemCount(IntPtr self, int count);
		static extern (C) void wxVListBox_Clear(IntPtr self);
		static extern (C) void wxVListBox_SetSelection(IntPtr self, int selection);
		static extern (C) bool wxVListBox_Select(IntPtr self, int item, bool select);
		static extern (C) bool wxVListBox_SelectRange(IntPtr self, int from, int to);
		static extern (C) void wxVListBox_Toggle(IntPtr self, int item);
		static extern (C) bool wxVListBox_SelectAll(IntPtr self);
		static extern (C) bool wxVListBox_DeselectAll(IntPtr self);
		static extern (C) void wxVListBox_SetMargins(IntPtr self, inout Point pt);
		static extern (C) void wxVListBox_SetMargins2(IntPtr self, int x, int y);
		static extern (C) void wxVListBox_SetSelectionBackground(IntPtr self, IntPtr col);
		//! \endcond

	public abstract class VListBox : VScrolledWindow
	{
		const string wxVListBoxNameStr = "wxVListBox";

		public this(IntPtr wxobj);
		public this();
		public this(Window parent, int id /*= wxID_ANY*/, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, string name = wxVListBoxNameStr);
		public this(Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, string name = wxVListBoxNameStr);
		public override bool Create(Window parent, int id, inout Point pos, inout Size size, int style, string name);
		protected abstract void OnDrawItem(DC dc, Rectangle rect, int n);
		static extern(C) private void staticDoOnDrawItem(VListBox obj, IntPtr dc, Rectangle rect, int n);
		protected abstract int OnMeasureItem(int n);
		static extern(C) private int staticOnMeasureItem(VListBox obj, int n);
		protected /+virtual+/ void OnDrawSeparator(DC dc, Rectangle rect, int n);
		static extern(C) private void staticDoOnDrawSeparator(VListBox obj, IntPtr dc, Rectangle rect, int n);
		protected /+virtual+/ void OnDrawBackground(DC dc, Rectangle rect, int n);
		static extern(C) private void staticDoOnDrawBackground(VListBox obj, IntPtr dc, Rectangle rect, int n);
		protected override int OnGetLineHeight(int line);
		static extern(C) private override int staticOnGetLineHeight(VListBox obj, int line);
		public int ItemCount();
		public void ItemCount(int value);
		public bool HasMultipleSelection() ;
		public int Selection();
		public void Selection(int value) ;
		public bool IsCurrent(int item);
		public bool IsSelected(int item);
		public int SelectedCount() ;
		public int GetFirstSelected(out uint cookie);
		public int GetNextSelected(inout uint cookie);
		public Point Margins() ;
		public void Margins(Point value);
		public void SetMargins(int x, int y);
		public Colour SelectionBackground() ;
		public void SelectionBackground(Colour value);
		public void Clear();
		public bool Select(int item);
		public bool Select(int item, bool select);
		public bool SelectRange(int from, int to);
		public void Toggle(int item);
		public bool SelectAll();
		public bool DeselectAll();
	}
