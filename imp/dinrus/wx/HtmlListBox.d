
module wx.HtmlListBox;
public import wx.common;
public import wx.VLBox;

		//-----------------------------------------------------------------------------

		//! \cond EXTERN
		extern (C) {
		alias void function(HtmlListBox obj) Virtual_VoidNoParams;
		alias void function(HtmlListBox obj, int n) Virtual_VoidSizeT;
		alias string function(HtmlListBox obj, int n) Virtual_wxStringSizeT;
		alias IntPtr function(HtmlListBox obj, IntPtr colour) Virtual_wxColourwxColour;
		alias void function(HtmlListBox obj, IntPtr dc, inout Rectangle rect, int n) Virtual_OnDrawItem;
		alias int function(HtmlListBox obj, int n) Virtual_OnMeasureItem;
		}

		static extern (C) IntPtr wxHtmlListBox_ctor2(IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
		static extern (C) void wxHtmlListBox_RegisterVirtual(IntPtr self,HtmlListBox obj,
			Virtual_VoidNoParams refreshAll,
			Virtual_VoidSizeT setItemCount,
			Virtual_wxStringSizeT onGetItem,
			Virtual_wxStringSizeT onGetItemMarkup,
			Virtual_wxColourwxColour getSelectedTextColour,
			Virtual_wxColourwxColour getSelectedTextBgColour,
			Virtual_OnDrawItem onDrawItem,
			Virtual_OnMeasureItem onMeasureItem,
			Virtual_OnDrawItem onDrawSeparator,
			Virtual_OnDrawItem onDrawBackground,
			Virtual_OnMeasureItem onGetLineHeight);
		static extern (C) bool wxHtmlListBox_Create(IntPtr self, IntPtr parent, int id, inout Point pos, inout Size size, int style, string name);
		static extern (C) void wxHtmlListBox_RefreshAll(IntPtr self);
		static extern (C) void wxHtmlListBox_SetItemCount(IntPtr self, int count);
		static extern (C) IntPtr wxHtmlListBox_OnGetItemMarkup(IntPtr self, int n);
		static extern (C) IntPtr wxHtmlListBox_GetSelectedTextColour(IntPtr self, IntPtr colFg);
		static extern (C) IntPtr wxHtmlListBox_GetSelectedTextBgColour(IntPtr self, IntPtr colBg);
		static extern (C) void wxHtmlListBox_OnDrawItem(IntPtr self, IntPtr dc, inout Rectangle rect, int n);
		static extern (C) int wxHtmlListBox_OnMeasureItem(IntPtr self, int n);
		static extern (C) void wxHtmlListBox_OnSize(IntPtr self, IntPtr evt);
		static extern (C) void wxHtmlListBox_Init(IntPtr self);
		static extern (C) void wxHtmlListBox_CacheItem(IntPtr self, int n);

		static extern (C) void wxHtmlListBox_OnDrawSeparator(IntPtr self, IntPtr dc, inout Rectangle rect, int n);
		static extern (C) void wxHtmlListBox_OnDrawBackground(IntPtr self, IntPtr dc, inout Rectangle rect, int n);
		static extern (C) int wxHtmlListBox_OnGetLineHeight(IntPtr self, int line);
		//! \endcond

		//-----------------------------------------------------------------------------

	public abstract class HtmlListBox : VListBox
	{
		public this(IntPtr wxobj);
		public this();
		public this(Window parent, int id /*= wxID_ANY*/, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, string name=wxVListBoxNameStr);
		public this(Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, string name=wxVListBoxNameStr);
		public override bool Create(Window parent, int id, inout Point pos, inout Size size, int style, string name);
		static extern(C) private void staticRefreshAll(HtmlListBox obj);
		public override void RefreshAll();
		static extern(C) private void staticSetItemCount(HtmlListBox obj,int count);
		public /+virtual+/ void SetItemCount(int count);
		static extern(C) private string staticOnGetItem(HtmlListBox obj,int n);
		protected abstract string OnGetItem(int n);
		static extern(C) private string staticOnGetItemMarkup(HtmlListBox obj,int n);
		protected /+virtual+/ string OnGetItemMarkup(int n);
		static extern(C) private IntPtr staticDoGetSelectedTextColour(HtmlListBox obj,IntPtr colFg);
		protected /+virtual+/ Colour GetSelectedTextColour(Colour colFg);
		static extern(C) private IntPtr staticDoGetSelectedTextBgColour(HtmlListBox obj, IntPtr colBg);
		protected /+virtual+/ Colour GetSelectedTextBgColour(Colour colBg);
		static extern(C) private void staticDoOnDrawItem(HtmlListBox obj, IntPtr dc, inout Rectangle rect, int n);
		protected override void OnDrawItem(DC dc, Rectangle rect, int n);
		static extern(C) private int staticOnMeasureItem(HtmlListBox obj, int n);
		protected override int OnMeasureItem(int n);
		protected void OnSize(SizeEvent evt);
		protected void Init();
		protected void CacheItem(int n);
		protected override void OnDrawSeparator(DC dc, Rectangle rect, int n);
		static extern(C) private void staticDoOnDrawSeparator(HtmlListBox obj,IntPtr dc, inout Rectangle rect, int n);
		protected override void OnDrawBackground(DC dc, Rectangle rect, int n);
		static extern(C) private void staticDoOnDrawBackground(HtmlListBox obj,IntPtr dc, inout Rectangle rect, int n);
		protected override int OnGetLineHeight(int line);
		static extern(C) private int staticOnGetLineHeight(HtmlListBox obj, int line);

	}
