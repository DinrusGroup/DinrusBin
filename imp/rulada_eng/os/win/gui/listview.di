// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.listview;

private import os.win.gui.x.dlib, std.c;

private import os.win.gui.base, os.win.gui.control, os.win.gui.x.winapi, os.win.gui.application;
private import os.win.gui.event, os.win.gui.drawing, os.win.gui.collections, os.win.gui.x.utf;

version(DFL_NO_IMAGELIST)
{
}
else
{
	private import os.win.gui.imagelist;
}


private extern(Windows) void _initListview();


///
enum ListViewAlignment: ubyte
{
	TOP, ///
	DEFAULT, /// ditto
	LEFT, /// ditto
	SNAP_TO_GRID, /// ditto
}


private union CallText
{
	Dstringz ansi;
	Dwstringz unicode;
}


private CallText getCallText(Dstring text);


package union LvColumn
{
	LV_COLUMNW lvcw;
	LV_COLUMNA lvca;
	struct
	{
		UINT mask;
		int fmt;
		int cx;
		private void* pszText;
		int cchTextMax;
		int iSubItem;
	}
}


///
class ListViewSubItem: DObject
{
	///
	this();
	/// ditto
	this(Dstring thisSubItemText);
	
	/// ditto
	this(ListViewItem owner, Dstring thisSubItemText);
	
	/+
	this(Object obj);
	+/
	
	
	package final void settextin(Dstring newText);
	
	
	override Dstring toString();
	
	override Dequ opEquals(Object o);
	
	Dequ opEquals(Dstring val);
	
	override int opCmp(Object o);
	
	int opCmp(Dstring val);
	///
	final void text(Dstring newText) ;
	/// ditto
	final Dstring text() ;
	
	private:
	package ListViewItem _item;
	Dstring _txt;
	package CallText calltxt;
}


///
class ListViewItem: DObject
{
	///
	static class ListViewSubItemCollection
	{
		protected this(ListViewItem owner);
		
		private:
		
		ListViewItem _item;
		package ListViewSubItem[] _subs;
		
		
		void _adding(size_t idx, ListViewSubItem val);
		
		public:
		
		mixin ListWrapArray!(ListViewSubItem, _subs,
			_adding, _blankListCallback!(ListViewSubItem),
			_blankListCallback!(ListViewSubItem), _blankListCallback!(ListViewSubItem),
			true, false, false);
	}
	
	
	///
	this();
	
	/// ditto
	this(Dstring text);
	
	
	private final void _setcheckstate(int thisindex, bool bchecked);
	
	private final bool _getcheckstate(int thisindex);
	
	///
	final void checked(bool byes);
	/// ditto
	final bool checked() ;
	
	package final void settextin(Dstring newText);
	
	
	override Dstring toString();
	
	override Dequ opEquals(Object o);
	
	Dequ opEquals(Dstring val);
	
	override int opCmp(Object o);
	
	int opCmp(Dstring val);
	
	///
	final Rect bounds();
	
	///
	final int index() ;
	///
	final void text(Dstring newText);
	/// ditto
	final Dstring text() ;
	///
	final void selected(bool byes);
	/// ditto
	final bool selected() ;
	
	///
	final ListView listView();
	
	///
	final void tag(Object obj);
	/// ditto
	final Object tag();
	
	final void beginEdit();
	
	///
	final ListViewSubItemCollection subItems() ;
	
	version(DFL_NO_IMAGELIST)
	{
	}
	else
	{
		///
		final void imageIndex(int index) ;
		/// ditto
		final int imageIndex() ;
	}
	
	
	private:
	package ListView lview = null;
	Object _tag = null;
	package ListViewSubItemCollection isubs = null;
	version(DFL_NO_IMAGELIST)
	{
	}
	else
	{
		int _imgidx = -1;
	}
	Dstring _txt;
	package CallText calltxt;
}


///
class ColumnHeader: DObject
{
	///
	this(Dstring text);
	
	/// ditto
	this();
	
	///
	final ListView listView() ;
	
	///
	final void text(Dstring newText);
	/// ditto
	final Dstring text() ;
	
	override Dstring toString();
	
	override Dequ opEquals(Object o);
	
	Dequ opEquals(Dstring val);
	
	override int opCmp(Object o);
	
	int opCmp(Dstring val);
	
	///
	final int index() ;
	
	///
	final void textAlign(HorizontalAlignment halign) ;
	/// ditto
	final HorizontalAlignment textAlign() ;
	
	///
	final void width(int w) ;
	
	/// ditto
	final int width();
	
	private:
	package ListView lview;
	Dstring _txt;
	int _width;
	HorizontalAlignment _align;
}


///
class LabelEditEventArgs: EventArgs
{
	///
	this(ListViewItem item, Dstring label);
	
	/// ditto
	this(ListViewItem node);
	
	///
	final ListViewItem item() ;
	///
	final Dstring label() ;
	
	
	///
	final void cancelEdit(bool byes) ;
	
	/// ditto
	final bool cancelEdit();
	
	private:
	ListViewItem _item;
	Dstring _label;
	bool _cancel = false;
}


/+
class ItemCheckEventArgs: EventArgs
{
	this(int index, CheckState newCheckState, CheckState oldCheckState);
	
	final CheckState currentValue() ;
	
	/+
	final void newValue(CheckState cs) ;
	+/
	
	
	final CheckState newValue() ;
	
	
	private:
	int _idx;
	CheckState _ncs, _ocs;
}
+/


class ItemCheckedEventArgs: EventArgs
{
	this(ListViewItem item);
	
	final ListViewItem item() ;
	
	private:
	ListViewItem _item;
}


///
class ListView: ControlSuperClass // docmain
{
	///
	static class ListViewItemCollection
	{
		protected this(ListView lv);
		
		void add(ListViewItem item);
		void add(Dstring text);
		
		// addRange must have special case in case of sorting.
		
		void addRange(ListViewItem[] range);
		
		/+
		void addRange(Object[] range);
		+/
		
		void addRange(Dstring[] range);
		
		
		private:
		
		ListView lv;
		package ListViewItem[] _items;
		
		
		package final bool created() ;
		
		package final void doListItems();
		
		void verifyNoParent(ListViewItem item);
		
		void _adding(size_t idx, ListViewItem val);
		
		void _added(size_t idx, ListViewItem val);
		
		void _removed(size_t idx, ListViewItem val);
		
		public:
		
		mixin ListWrapArray!(ListViewItem, _items,
			_adding, _added,
			_blankListCallback!(ListViewItem), _removed,
			true, false, false);
	}
	
	
	///
	static class ColumnHeaderCollection
	{
		protected this(ListView owner);
		
		private:
		ListView lv;
		ColumnHeader[] _headers;
		
		
		package final bool created();
		
		void verifyNoParent(ColumnHeader header);
		
		package final void doListHeaders() ;
		
		void _adding(size_t idx, ColumnHeader val);
		
		void _added(size_t idx, ColumnHeader val);
		
		
		void _removed(size_t idx, ColumnHeader val);
		
		public:
		
		mixin ListWrapArray!(ColumnHeader, _headers,
			_adding, _added,
			_blankListCallback!(ColumnHeader), _removed,
			true, false, false,
			true); // CLEAR_EACH
	}
	
	
	///
	static class SelectedIndexCollection
	{
		deprecated alias length count;
		
		int length() ;
		
		int opIndex(int idx);
		
		
		bool contains(int idx);
		
		int indexOf(int idx);
		
		
		int opApply(int delegate(inout int) dg);
		
		mixin OpApplyAddIndex!(opApply, int);
		
		
		protected this(ListView lv);
		
		package:
		ListView lview;
	}
	
	
	deprecated alias SelectedItemCollection SelectedListViewItemCollection;
	
	///
	static class SelectedItemCollection
	{
		deprecated alias length count;
		
		int length() ;
		
		
		ListViewItem opIndex(int idx);
		
		bool contains(ListViewItem item);
		
		int indexOf(ListViewItem item);
		
		int opApply(int delegate(inout ListViewItem) dg);
		
		mixin OpApplyAddIndex!(opApply, ListViewItem);
		
		
		protected this(ListView lv);
		
		package:
		ListView lview;
	}
	
	
	///
	static class CheckedIndexCollection
	{
		deprecated alias length count;
		
		int length() ;
		
		int opIndex(int idx);
		
		
		bool contains(int idx);
		
		int indexOf(int idx);
		
		int opApply(int delegate(inout int) dg);
		
		mixin OpApplyAddIndex!(opApply, int);
		
		
		protected this(ListView lv);
		
		package:
		ListView lview;
	}
	
	
	this();
	
	///
	final void activation(ItemActivation ia) ;
	
	/// ditto
	final ItemActivation activation() ;
	
	/+
	///
	final void alignment(ListViewAlignment lva);
	
	/// ditto
	final ListViewAlignment alignment() ;
	+/
	
	
	///
	final void allowColumnReorder(bool byes) ;
	/// ditto
	final bool allowColumnReorder() ;
	
	///
	final void autoArrange(bool byes);
	/// ditto
	final bool autoArrange() ;
	
	override void backColor(Color c) ;
	
	
	override Color backColor() ;
	
	///
	final void borderStyle(BorderStyle bs);
	
	/// ditto
	final BorderStyle borderStyle() ;
	
	///
	final void checkBoxes(bool byes) ;
	
	/// ditto
	final bool checkBoxes() ;
	
	///
	// ListView.CheckedIndexCollection
	final CheckedIndexCollection checkedIndices() ;
	
	/+
	///
	// ListView.CheckedListViewItemCollection
	final CheckedListViewItemCollection checkedItems() ;
	+/
	
	
	///
	final ColumnHeaderCollection columns();
	
	///
	// Extra.
	final int focusedIndex() ;
	///
	final ListViewItem focusedItem();
	
	override void foreColor(Color c) ;
	
	override Color foreColor();
	
	///
	final void fullRowSelect(bool byes);
	/// ditto
	final bool fullRowSelect();
	
	///
	final void gridLines(bool byes);
	/// ditto
	final bool gridLines();
	/+
	///
	final void headerStyle(ColumnHeaderStyle chs) ;
	/// ditto
	final ColumnHeaderStyle headerStyle() ;
	+/
	
	
	///
	final void hideSelection(bool byes);
	/// ditto
	final bool hideSelection();
	///
	final void hoverSelection(bool byes) ;
	/// ditto
	final bool hoverSelection();
	///
	final ListViewItemCollection items() ;
	
	
	///
	// Simple as addRow("item", "sub item1", "sub item2", "etc");
	// rowstrings[0] is the item and rowstrings[1 .. rowstrings.length] are its sub items.
	//final void addRow(Dstring[] rowstrings ...)
	final ListViewItem addRow(Dstring[] rowstrings ...);
	
	///
	final void labelEdit(bool byes) ;
	/// ditto
	final bool labelEdit() ;
	///
	final void labelWrap(bool byes);
	/// ditto
	final bool labelWrap() ;
	///
	final void multiSelect(bool byes) ;
	/// ditto
	final bool multiSelect() ;
	///
	// Note: scrollable=false is not compatible with the list or details(report) styles(views).
	// See Knowledge Base Article Q137520.
	final void scrollable(bool byes);
	/// ditto
	final bool scrollable();
	
	///
	final SelectedIndexCollection selectedIndices() ;
	///
	final SelectedItemCollection selectedItems();
	
	///
	final void view(View v);
	
	/// ditto
	final View view() ;
	
	
	///
	final void sorting(SortOrder so) ;
	
	/// ditto
	final SortOrder sorting() ;
	
	///
	final void sort();
	
	///
	final void sorter(int delegate(ListViewItem, ListViewItem) sortproc) ;
	/// ditto
	final int delegate(ListViewItem, ListViewItem) sorter();
	
	
	/+
	///
	// Gets the first visible item.
	final ListViewItem topItem() ;
	+/
	
	
	///
	final void arrangeIcons();
	/// ditto
	final void arrangeIcons(ListViewAlignment a);
	
	
	///
	final void beginUpdate();
	
	/// ditto
	final void endUpdate();
	
	
	///
	final void clear();
	
	
	///
	final void ensureVisible(int index);
	
	/+
	///
	// Returns null if no item is at this location.
	final ListViewItem getItemAt(int x, int y);
	+/
	
	
	///
	final Rect getItemRect(int index);
	
	/// ditto
	final Rect getItemRect(int index, ItemBoundsPortion ibp);
	
	version(DFL_NO_IMAGELIST)
	{
	}
	else
	{
		///
		final void largeImageList(ImageList imglist) ;
		/// ditto
		final ImageList largeImageList();
		
		///
		final void smallImageList(ImageList imglist) ;
		/// ditto
		final ImageList smallImageList() ;
		
		/+
		///
		final void stateImageList(ImageList imglist) ;
		
		/// ditto
		final ImageList stateImageList() ;
		+/
	}
	
	
	// TODO:
	//  itemActivate, itemDrag
	//CancelEventHandler selectedIndexChanging; // ?
	
	Event!(ListView, ColumnClickEventArgs) columnClick; ///
	Event!(ListView, LabelEditEventArgs) afterLabelEdit; ///
	Event!(ListView, LabelEditEventArgs) beforeLabelEdit; ///
	//Event!(ListView, ItemCheckEventArgs) itemCheck; ///
	Event!(ListView, ItemCheckedEventArgs) itemChecked; ///
	Event!(ListView, EventArgs) selectedIndexChanged; ///
	
	
	///
	protected void onColumnClick(ColumnClickEventArgs ea);
	
	///
	protected void onAfterLabelEdit(LabelEditEventArgs ea);
	
	
	///
	protected void onBeforeLabelEdit(LabelEditEventArgs ea);
	
	
	/+
	protected void onItemCheck(ItemCheckEventArgs ea);
	+/
	
	
	///
	protected void onItemChecked(ItemCheckedEventArgs ea);
	
	///
	protected void onSelectedIndexChanged(EventArgs ea);
	
	protected override Size defaultSize() ;
	
	static Color defaultBackColor() ;
	
	static Color defaultForeColor() ;
	
	protected override void createParams(inout CreateParams cp);
	
	
	protected override void prevWndProc(inout Message msg);
	
	protected override void wndProc(inout Message m);
	
	protected override void onHandleCreated(EventArgs ea);
	
	protected override void onReflectedMessage(inout Message m);
	
	private:
	DWORD wlvexstyle = 0;
	ListViewItemCollection litems;
	ColumnHeaderCollection cols;
	SelectedIndexCollection selidxcollection;
	SelectedItemCollection selobjcollection;
	SortOrder _sortorder = SortOrder.NONE;
	CheckedIndexCollection checkedis;
	int delegate(ListViewItem, ListViewItem) _sortproc;
	version(DFL_NO_IMAGELIST)
	{
	}
	else
	{
		ImageList _lgimglist, _smimglist;
		//ImageList _stimglist;
	}
	
	
	int _defsortproc(ListViewItem a, ListViewItem b);
	
	
	DWORD _lvexstyle();
	
	void _lvexstyle(DWORD flags);
	
	
	void _lvexstyle(DWORD mask, DWORD flags);
	
	
	// If -subItemIndex- is 0 it's an item not a sub item.
	// Returns the insertion index or -1 on failure.
	package final LRESULT _ins(int index, LPARAM lparam, Dstring itemText, int subItemIndex, int imageIndex = -1);
	
	package final LRESULT _ins(int index, ListViewItem item);
	
	package final LRESULT _ins(int index, ListViewSubItem subItem, int subItemIndex);
	
	package final LRESULT _ins(int index, ColumnHeader header);
	
	// If -subItemIndex- is 0 it's an item not a sub item.
	// Returns FALSE on failure.
	LRESULT updateItem(int index);
	
	LRESULT updateItemText(int index, Dstring newText, int subItemIndex = 0);
	LRESULT updateItemText(ListViewItem item, Dstring newText, int subItemIndex = 0);
	
	LRESULT updateColumnText(int colIndex, Dstring newText);
	
	
	LRESULT updateColumnText(ColumnHeader col, Dstring newText);
	
	LRESULT updateColumnAlign(int colIndex, HorizontalAlignment halign);
	
	
	LRESULT updateColumnAlign(ColumnHeader col, HorizontalAlignment halign);
	
	LRESULT updateColumnWidth(int colIndex, int w);
	
	LRESULT updateColumnWidth(ColumnHeader col, int w);
	
	int getColumnWidth(int colIndex);
	
	int getColumnWidth(ColumnHeader col);
	
	
	package:
	final:
	LRESULT prevwproc(UINT msg, WPARAM wparam, LPARAM lparam);
}

