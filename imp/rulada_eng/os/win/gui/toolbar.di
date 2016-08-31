///
module os.win.gui.toolbar;

private import os.win.gui.base, os.win.gui.control, os.win.gui.drawing, os.win.gui.application,
	os.win.gui.event, os.win.gui.collections;
private import os.win.gui.x.winapi, os.win.gui.x.dlib;

version(DFL_NO_IMAGELIST)
{
}
else
{
	private import os.win.gui.imagelist;
}

version(DFL_NO_MENUS)
	version = DFL_TOOLBAR_NO_MENU;

version(DFL_TOOLBAR_NO_MENU)
{
}
else
{
	private import os.win.gui.menu;
}


///
enum ToolBarButtonStyle: ubyte
{
	PUSH_BUTTON = TBSTYLE_BUTTON, ///
	TOGGLE_BUTTON = TBSTYLE_CHECK, /// ditto
	SEPARATOR = TBSTYLE_SEP, /// ditto
	//DROP_DOWN_BUTTON = TBSTYLE_DROPDOWN, /// ditto
	DROP_DOWN_BUTTON = TBSTYLE_DROPDOWN | BTNS_WHOLEDROPDOWN, /// ditto
}


///
class ToolBarButton
{
	///
	this();
	///
	this(Dstring text);
	
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
	
	
	///
	void text(Dstring newText);
	
	/// ditto
	Dstring text();
	
	
	///
	final void style(ToolBarButtonStyle st) ;
	
	/// ditto
	final ToolBarButtonStyle style();
	
	override Dstring toString();
	
	
	override Dequ opEquals(Object o);
	
	Dequ opEquals(Dstring val);
	
	override int opCmp(Object o);
	
	int opCmp(Dstring val);
	
	///
	final void tag(Object o) ;
	
	/// ditto
	final Object tag() ;
	
	
	version(DFL_TOOLBAR_NO_MENU)
	{
	}
	else
	{
		///
		final void dropDownMenu(ContextMenu cmenu) ;
		
		/// ditto
		final ContextMenu dropDownMenu() ;
	}
	
	
	///
	final ToolBar parent();
	
	///
	final Rect rectangle();
	
	
	///
	final void visible(bool byes) ;
	/// ditto
	final bool visible() ;
	
	///
	final void enabled(bool byes);
	/// ditto
	final bool enabled();
	
	
	///
	final void pushed(bool byes) ;
	/// ditto
	final bool pushed();
	
	///
	final void partialPush(bool byes) ;
	
	/// ditto
	final bool partialPush();
	
	
	private:
	ToolBar tbar;
	int _id = 0;
	Dstring _text;
	Object _tag;
	ToolBarButtonStyle _style = ToolBarButtonStyle.PUSH_BUTTON;
	BYTE _state = TBSTATE_ENABLED;
	version(DFL_TOOLBAR_NO_MENU)
	{
	}
	else
	{
		ContextMenu _cmenu;
	}
	version(DFL_NO_IMAGELIST)
	{
	}
	else
	{
		int _imgidx = -1;
	}
}


///
class ToolBarButtonClickEventArgs: EventArgs
{
	this(ToolBarButton tbbtn);
	
	
	///
	final ToolBarButton button() ;
	
	private:
	
	ToolBarButton _btn;
}


///
class ToolBar: ControlSuperClass // docmain
{
	class ToolBarButtonCollection
	{
		protected this();
		
		private:
		
		ToolBarButton[] _buttons;
		
		
		void _adding(size_t idx, ToolBarButton val);
		
		void _added(size_t idx, ToolBarButton val);
		
		void _removed(size_t idx, ToolBarButton val);
		
		
		public:
		
		mixin ListWrapArray!(ToolBarButton, _buttons,
			_adding, _added,
			_blankListCallback!(ToolBarButton), _removed,
			true, false, false,
			true); // CLEAR_EACH
	}
	
	
	private ToolBar tbar();
	
	this();
	
	///
	final ToolBarButtonCollection buttons() ;
	
	// buttonSize...
	
	
	///
	final Size imageSize();
	
	version(DFL_NO_IMAGELIST)
	{
	}
	else
	{
		///
		final void imageList(ImageList imglist);
		
		/// ditto
		final ImageList imageList() ;
	}
	
	
	///
	Event!(ToolBar, ToolBarButtonClickEventArgs) buttonClick;
	
	
	///
	protected void onButtonClick(ToolBarButtonClickEventArgs ea);
	
	
	protected override void onReflectedMessage(inout Message m);
	
	protected override Size defaultSize() ;
	
	protected override void createParams(inout CreateParams cp);
	
	
	
	// Used internally
	/+package+/ final ToolBarButton buttomFromID(int id) ;
	
	package int _lastTbbID = 0;
	
	package final int _allocTbbID();
	
	
	protected override void onHandleCreated(EventArgs ea);
	
	
	protected override void prevWndProc(inout Message msg);
	
	private:
	
	ToolBarButtonCollection _tbuttons;
	
	version(DFL_NO_IMAGELIST)
	{
	}
	else
	{
		ImageList _imglist;
	}
	
	
	void _ins(size_t idx, ToolBarButton tbb);
	
	package:
	final:
	LRESULT prevwproc(UINT msg, WPARAM wparam, LPARAM lparam);
}


private
{
	const Dstring TOOLBAR_CLASSNAME = "DFL_ToolBar";
	
	WNDPROC toolbarPrevWndProc;
	
	LONG toolbarClassStyle;
	
	void _initToolbar();
}

