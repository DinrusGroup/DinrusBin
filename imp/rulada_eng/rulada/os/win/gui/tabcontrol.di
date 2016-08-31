// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.tabcontrol;

private import os.win.gui.x.dlib;

private import os.win.gui.control, os.win.gui.panel, os.win.gui.x.winapi, os.win.gui.drawing;
private import os.win.gui.application, os.win.gui.event, os.win.gui.base, os.win.gui.collections;


private extern(Windows) void _initTabcontrol();


///
class TabPage: Panel
{
	///
	this(Dstring tabText);
	
	/+
	/// ditto
	this(Object v) ;
	+/
	
	/// ditto
	this();
	
	override Dstring toString();
	
	
	override Dequ opEquals(Object o);
	
	Dequ opEquals(Dstring val);
	
	override int opCmp(Object o);
	
	int opCmp(Dstring val);
	
	// imageIndex
	
	
	override void text(Dstring newText);
	alias Panel.text text; // Overload with Panel.text.
	
	
	/+
	final void toolTipText(Dstring ttt) ;
	
	final Dstring toolTipText() ;
	+/
	
	
	/+ package +/ /+ protected +/ int _rtype() // package
	{
		return 4;
	}
	
	
	protected override void setBoundsCore(int x, int y, int width, int height, BoundsSpecified specified);
	
	package final void realBounds(Rect r) ;
	
	protected override void setVisibleCore(bool byes);
	
	package final void realVisible(bool byes);
}


package union TcItem
{
	TC_ITEMW tciw;
	TC_ITEMA tcia;
	struct
	{
		UINT mask;
		UINT lpReserved1;
		UINT lpReserved2;
		private void* pszText;
		int cchTextMax;
		int iImage;
		LPARAM lParam;
	}
}


///
class TabPageCollection
{
	protected this(TabControl owner);
	
	private:
	
	TabControl tc;
	TabPage[] _pages = null;
	
	
	void doPages();
	
	
	package final bool created();
	
	void _added(size_t idx, TabPage val);
	
	void _removed(size_t idx, TabPage val);
	
	
	public:
	
	mixin ListWrapArray!(TabPage, _pages,
		_blankListCallback!(TabPage), _added,
		_blankListCallback!(TabPage), _removed,
		true, false, false,
		true); // CLEAR_EACH
}


///
enum TabAlignment: ubyte
{
	TOP, ///
	BOTTOM, /// ditto
	LEFT, /// ditto
	RIGHT, /// ditto
}


///
enum TabAppearance: ubyte
{
	NORMAL, ///
	BUTTONS, /// ditto
	FLAT_BUTTONS, /// ditto
}


///
enum TabDrawMode: ubyte
{
	NORMAL, ///
	OWNER_DRAW_FIXED, /// ditto
}


///
class TabControlBase: ControlSuperClass
{
	this();
	
	
	///
	final void drawMode(TabDrawMode dm) ;
	/// ditto
	final TabDrawMode drawMode() ;
	
	override Rect displayRectangle() ;
	
	
	protected override Size defaultSize() ;
	
	
	///
	final Rect getTabRect(int i);
	
	// drawItem event.
	//EventHandler selectedIndexChanged;
	Event!(TabControlBase, EventArgs) selectedIndexChanged; ///
	//CancelEventHandler selectedIndexChanging;
	Event!(TabControlBase, CancelEventArgs) selectedIndexChanging; ///
	
	
	protected override void createParams(inout CreateParams cp);
	
	///
	protected void onSelectedIndexChanged(EventArgs ea);
	
	
	///
	protected void onSelectedIndexChanging(CancelEventArgs ea);
	
	protected override void prevWndProc(inout Message msg);
	
	protected override void wndProc(inout Message m);
	
	protected override void onReflectedMessage(inout Message m);
}


///
class TabControl: TabControlBase // docmain
{
	this();	
	///
	final void alignment(TabAlignment talign) ;
	/// ditto
	final TabAlignment alignment() ;	
	///
	final void appearance(TabAppearance tappear) ;
	/// ditto
	final TabAppearance appearance() ;
		
	///
	final void padding(Point pad) ;
	
	/// ditto
	final Point padding() ;
	
	///
	final TabPageCollection tabPages();
	
	///
	final void multiline(bool byes);
	/// ditto
	final bool multiline() ;
	///
	final int rowCount();
	
	
	///
	final int tabCount() ;
	
	///
	final void selectedIndex(int i);
	/// ditto
	// Returns -1 if there are no tabs selected.
	final int selectedIndex();
	
	///
	final void selectedTab(TabPage page);
	/// ditto
	final TabPage selectedTab();
	
	/+
	///
	final void showToolTips(bool byes);
	/// ditto
	final bool showToolTips() ;
	+/
	
	
	protected override void onHandleCreated(EventArgs ea);
	
	
	protected override void onLayout(LayoutEventArgs ea);
	
	/+
	protected override void wndProc(inout Message m);
	+/
	
	
	protected override void onReflectedMessage(inout Message m);
	
	/+
	/+ package +/ /+ protected +/ override int _rtype() // package
	{
		return 0x20;
	}
	+/
	
	
	private:
	Point _pad = {x: 6, y: 3};
	TabPageCollection tchildren;
	
	
	void tabToFront(TabPage page);
	
	
	void updateTabText(TabPage page, Dstring newText);
}

