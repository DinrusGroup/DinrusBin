// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.combobox;

private import os.win.gui.x.dlib;

private import os.win.gui.listbox, os.win.gui.application, os.win.gui.base, os.win.gui.x.winapi;
private import os.win.gui.event, os.win.gui.drawing, os.win.gui.collections, os.win.gui.control,
	os.win.gui.x.utf;


private extern(Windows) void _initCombobox();


///
enum ComboBoxStyle: ubyte
{
	DROP_DOWN, ///
	DROP_DOWN_LIST, /// ditto
	SIMPLE, /// ditto
}


///
class ComboBox: ListControl // docmain
{
	this();
	
	
	///
	final void dropDownStyle(ComboBoxStyle ddstyle);
	
	/// ditto
	final ComboBoxStyle dropDownStyle() ;
	
	
	///
	final void integralHeight(bool byes) ;
	
	/// ditto
	final bool integralHeight() ;
	
	
	///
	// This function has no effect if the drawMode is OWNER_DRAW_VARIABLE.
	void itemHeight(int h) ;
	
	/// ditto
	// Return value is meaningless when drawMode is OWNER_DRAW_VARIABLE.
	int itemHeight();
	
	
	///
	void selectedIndex(int idx);
	
	/// ditto
	int selectedIndex();
	
	
	///
	final void selectedItem(Object o);
	
	/// ditto
	final void selectedItem(Dstring str) ;
	
	/// ditto
	final Object selectedItem() ;
	
	
	///
	override void selectedValue(Object val);
	
	/// ditto
	override void selectedValue(Dstring str) ;
	
	/// ditto
	override Object selectedValue();
	
	
	///
	final void sorted(bool byes) ;
	
	/// ditto
	final bool sorted() ;
	
	
	///
	final void beginUpdate();
	
	/// ditto
	final void endUpdate();
	
	
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
	final void drawMode(DrawMode dm) ;
	/// ditto
	final DrawMode drawMode();
	
	
	///
	final void selectAll();
	
	
	///
	final void maxLength(uint len) ;
	
	/// ditto
	final uint maxLength() ;
	
	
	///
	final void selectionLength(uint len) ;
	
	/// ditto
	final uint selectionLength() ;
	
	
	///
	final void selectionStart(uint pos) ;
	
	/// ditto
	final uint selectionStart() ;
	
	
	///
	// Number of characters in the textbox.
	// This does not necessarily correspond to the number of chars; some characters use multiple chars.
	// Return may be larger than the amount of characters.
	// This is a lot faster than retrieving the text, but retrieving the text is completely accurate.
	uint textLength() ;
	
	
	///
	final void droppedDown(bool byes) ;
	
	/// ditto
	final bool droppedDown() ;
	
	
	///
	final void dropDownWidth(int w);
	
	/// ditto
	final int dropDownWidth();
	
	///
	final ObjectCollection items() ;
	
	
	const int DEFAULT_ITEM_HEIGHT = 13;
	const int NO_MATCHES = CB_ERR;
	
	
	///
	static class ObjectCollection
	{
		protected this(ComboBox lbox);
		
		
		protected this(ComboBox lbox, Object[] range);
		
		
		protected this(ComboBox lbox, Dstring[] range);
		
		/+
		protected this(ComboBox lbox, ObjectCollection range);
		+/
		
		
		void add(Object value);
		
		void add(Dstring value);
		
		void addRange(Dstring[] range);
		
		void addRange(Object[] range);
		
		
		
		
		private:
		
		ComboBox lbox;
		Object[] _items;
		
		
		this();
		
		
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
	
	
	///
	protected ObjectCollection createItemCollection();
	
	protected override void onHandleCreated(EventArgs ea);
	
	package final bool hasDropList() ;
	
	
	// This is needed for the SIMPLE style.
	protected override void onPaintBackground(PaintEventArgs pea);
	
	override void createHandle();
	
	
	protected override void createParams(inout CreateParams cp);
	
	//DrawItemEventHandler drawItem;
	Event!(ComboBox, DrawItemEventArgs) drawItem;
	//MeasureItemEventHandler measureItem;
	Event!(ComboBox, MeasureItemEventArgs) measureItem;
	
	
	protected:
	override Size defaultSize() ;
	
	void onDrawItem(DrawItemEventArgs dieh);
	
	void onMeasureItem(MeasureItemEventArgs miea);
	
	package final void _WmDrawItem(DRAWITEMSTRUCT* dis);
	
	package final void _WmMeasureItem(MEASUREITEMSTRUCT* mis);
	
	override void prevWndProc(inout Message msg);
	
	
	protected override void onReflectedMessage(inout Message m);
	
	override void wndProc(inout Message msg);
	
	
	private:
	int iheight = DEFAULT_ITEM_HEIGHT;
	int dropw = -1;
	ObjectCollection icollection;
	package uint lim = 30_000; // Documented as default.
	bool _sorting = false;
	
	
	package:
	final:
	LRESULT prevwproc(UINT msg, WPARAM wparam, LPARAM lparam);
}

