// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.listbox;

private import os.win.gui.x.dlib;

private import os.win.gui.x.winapi, os.win.gui.control, os.win.gui.base, os.win.gui.application;
private import os.win.gui.drawing, os.win.gui.event, os.win.gui.collections;


private extern(C) void* memmove(void*, void*, size_t len);

private extern(Windows) void _initListbox();


alias StringObject ListString;


///
abstract class ListControl: ControlSuperClass // docmain
{
	///
	final Dstring getItemText(Object item);
	
	//EventHandler selectedValueChanged;
	Event!(ListControl, EventArgs) selectedValueChanged; ///
	
	
	///
	abstract void selectedIndex(int idx); // setter
	/// ditto
	abstract int selectedIndex(); // getter
	
	///
	abstract void selectedValue(Object val); // setter
	/// ditto
	
	///
	abstract void selectedValue(Dstring str); // setter
	/// ditto
	abstract Object selectedValue(); // getter
	
	
	static Color defaultBackColor();
	
	override Color backColor() ;
	
	alias Control.backColor backColor; // Overload.
	
	
	static Color defaultForeColor() ;
	
	
	override Color foreColor() ;
	alias Control.foreColor foreColor; // Overload.
	
	
	this();
	
	protected:
	
	///
	void onSelectedValueChanged(EventArgs ea);
	
	///
	// Index change causes the value to be changed.
	void onSelectedIndexChanged(EventArgs ea);
}


///
enum SelectionMode: ubyte
{
	ONE, ///
	NONE, /// ditto
	MULTI_SIMPLE, /// ditto
	MULTI_EXTENDED, /// ditto
}


///
class ListBox: ListControl // docmain
{
	///
	static class SelectedIndexCollection
	{
		deprecated alias length count;
		
		int length();
		
		int opIndex(int idx);
		
		bool contains(int idx);
		
		int indexOf(int idx);
		
		int opApply(int delegate(inout int) dg);
		
		mixin OpApplyAddIndex!(opApply, int);
		
		
		protected this(ListBox lb);
		
		package:
		ListBox lbox;
	}
	
	
	///
	static class SelectedObjectCollection
	{
		deprecated alias length count;
		
		int length() ;
		
		Object opIndex(int idx);
		
		bool contains(Object obj);
		
		bool contains(Dstring str);
		
		int indexOf(Object obj);
		
		int indexOf(Dstring str);
		
		private int myOpApply(int delegate(inout Object) dg);
		
		private int myOpApply(int delegate(inout Dstring) dg);
		
		mixin OpApplyAddIndex!(myOpApply, Dstring);
		
		mixin OpApplyAddIndex!(myOpApply, Object);
		
		// Had to do it this way because: DMD 1.028: -H is broken for mixin identifiers
		// Note that this way probably prevents opApply from being overridden.
		alias myOpApply opApply;
		
		
		protected this(ListBox lb);
		
		package:
		ListBox lbox;
	}
	
	
	///
	const int DEFAULT_ITEM_HEIGHT = 13;
	///
	const int NO_MATCHES = LB_ERR;
	
	
	protected override Size defaultSize() ;
	
	///
	void borderStyle(BorderStyle bs) ;
	
	/// ditto
	BorderStyle borderStyle();
	
	
	///
	void drawMode(DrawMode dm) ;
	
	/// ditto
	DrawMode drawMode() ;
	
	///
	final void horizontalExtent(int he);
	
	/// ditto
	final int horizontalExtent() ;
	
	
	///
	final void horizontalScrollbar(bool byes);
	
	/// ditto
	final bool horizontalScrollbar() ;
	
	///
	final void integralHeight(bool byes) ;
	/// ditto
	final bool integralHeight();
	///
	// This function has no effect if the drawMode is OWNER_DRAW_VARIABLE.
	final void itemHeight(int h) ;
	/// ditto
	// Return value is meaningless when drawMode is OWNER_DRAW_VARIABLE.
	final int itemHeight();
	
	
	///
	final ObjectCollection items();
	
	///
	final void multiColumn(bool byes);
	/// ditto
	final bool multiColumn() ;
	
	///
	final void scrollAlwaysVisible(bool byes) ;
	/// ditto
	final bool scrollAlwaysVisible();
	
	override void selectedIndex(int idx);
	override int selectedIndex();
	
	
	///
	final void selectedItem(Object o) ;
	/// ditto
	final void selectedItem(Dstring str);
	
	
	final Object selectedItem();
	
	override void selectedValue(Object val);
	override void selectedValue(Dstring str) ;
	override Object selectedValue() ;
	
	///
	final SelectedIndexCollection selectedIndices();
	
	///
	final SelectedObjectCollection selectedItems() ;
	
	///
	void selectionMode(SelectionMode selmode);
	/// ditto
	SelectionMode selectionMode();
	
	///
	final void sorted(bool byes) ;
	/// ditto
	final bool sorted() ;
	
	///
	final void topIndex(int idx) ;
	/// ditto
	final int topIndex() ;
	
	///
	final void useTabStops(bool byes);
	
	/// ditto
	final bool useTabStops() ;
	
	///
	final void beginUpdate();
	/// ditto
	final void endUpdate();
	
	package final bool isMultSel();
	
	///
	final void clearSelected();
	
	
	///
	final int findString(Dstring str, int startIndex);
	
	/// ditto
	final int findString(Dstring str);
	
	///
	final int findStringExact(Dstring str, int startIndex);
	/// ditto
	final int findStringExact(Dstring str);
	
	///
	final int getItemHeight(int idx);
	
	///
	final Rect getItemRectangle(int idx);
	
	
	///
	final bool getSelected(int idx);
	///
	final int indexFromPoint(int x, int y);
	/// ditto
	final int indexFromPoint(Point pt);
	
	///
	final void setSelected(int idx, bool byes);
	///
	protected ObjectCollection createItemCollection();
	
	///
	void sort();
	
	///
	static class ObjectCollection
	{
		protected this(ListBox lbox);
		
		protected this(ListBox lbox, Object[] range);
		
		protected this(ListBox lbox, Dstring[] range);
		
		/+
		protected this(ListBox lbox, ObjectCollection range);
		+/
		
		
		void add(Object value);
		
		void add(Dstring value);
		
		void addRange(Object[] range);
		
		void addRange(Dstring[] range);
		
		private:
		
		ListBox lbox;
		Object[] _items;
		
		
		LRESULT insert2(WPARAM idx, Dstring val);
		
		LRESULT add2(Object val);
		
		LRESULT add2(Dstring val);
		void _added(size_t idx, Object val);
		
		void _removed(size_t idx, Object val);
		
		public:
		
		mixin ListWrapArray!(Object, _items,
			_blankListCallback!(Object), _added,
			_blankListCallback!(Object), _removed,
			true, false, false) _wraparray;
	}
	
	
	this();
	
	protected override void onHandleCreated(EventArgs ea);
	
	/+
	override void createHandle();
	+/
	
	
	protected override void createParams(inout CreateParams cp);
	
	//DrawItemEventHandler drawItem;
	Event!(ListBox, DrawItemEventArgs) drawItem; ///
	//MeasureItemEventHandler measureItem;
	Event!(ListBox, MeasureItemEventArgs) measureItem; ///
	
	
	protected:
	
	///
	void onDrawItem(DrawItemEventArgs dieh);
	
	///
	void onMeasureItem(MeasureItemEventArgs miea);
	
	package final void _WmDrawItem(DRAWITEMSTRUCT* dis);
	
	package final void _WmMeasureItem(MEASUREITEMSTRUCT* mis);
	override void prevWndProc(inout Message msg)
	{
		//msg.result = CallWindowProcA(listboxPrevWndProc, msg.hWnd, msg.msg, msg.wParam, msg.lParam);
		msg.result = os.win.gui.x.utf.callWindowProc(listboxPrevWndProc, msg.hWnd, msg.msg, msg.wParam, msg.lParam);
	}
	
	
	protected override void onReflectedMessage(inout Message m);
	
	override void wndProc(inout Message msg);
	
	private:
	int hextent = 0;
	int iheight = DEFAULT_ITEM_HEIGHT;
	ObjectCollection icollection;
	SelectedIndexCollection selidxcollection;
	SelectedObjectCollection selobjcollection;
	bool _sorting = false;
	
	
	package:
	final:
	LRESULT prevwproc(UINT msg, WPARAM wparam, LPARAM lparam);
}

