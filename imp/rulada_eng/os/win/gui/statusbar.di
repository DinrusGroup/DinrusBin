// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.statusbar;


private import os.win.gui.control, os.win.gui.base, os.win.gui.x.winapi, os.win.gui.event,
	os.win.gui.collections, os.win.gui.x.utf, os.win.gui.x.dlib, os.win.gui.application;

private import os.win.gui.x.dlib;


private extern(Windows) void _initStatusbar();


/+
enum StatusBarPanelAutoSize: ubyte
{
	NONE,
	CONTENTS,
	SPRING,
}
+/


///
enum StatusBarPanelBorderStyle: ubyte
{
	NONE, ///
	SUNKEN, /// ditto
	RAISED /// ditto
}


///
class StatusBarPanel: DObject
{
	///
	this(Dstring text);
	
	/// ditto
	this(Dstring text, int width);
	
	/// ditto
	this();
	
	override Dstring toString();
	
	
	override Dequ opEquals(Object o);
	
	Dequ opEquals(StatusBarPanel pnl);
	
	Dequ opEquals(Dstring val);
	
	
	override int opCmp(Object o);
	
	int opCmp(StatusBarPanel pnl);
	
	int opCmp(Dstring val);
	
	/+
	///
	final void alignment(HorizontalAlignment ha);
	
	/// ditto
	final HorizontalAlignment alignment() ;
	+/
	
	
	/+
	///
	final void autoSize(StatusBarPanelAutoSize asize) ;
	
	/// ditto
	final StatusBarPanelAutoSize autoSize() ;
	+/
	
	
	///
	final void borderStyle(StatusBarPanelBorderStyle bs);
	/// ditto
	final StatusBarPanelBorderStyle borderStyle();
	
	
	// icon
	
	
	/+
	///
	final void minWidth(int mw) ;
	
	/// ditto
	final int minWidth() ;
	+/
	
	
	///
	final StatusBar parent() ;
	
	// style
	
	
	///
	final void text(Dstring txt) ;
	
	/// ditto
	final Dstring text() ;
	
	/+
	///
	final void toolTipText(Dstring txt) ;
	
	/// ditto
	final Dstring toolTipText() ;
	+/
	
	
	///
	final void width(int w) ;
	
	/// ditto
	final int width() ;
	
	private:
	
	Dstring _txt = null;
	int _width = 100;
	StatusBar _parent = null;
	WPARAM _utype = 0; // StatusBarPanelBorderStyle.SUNKEN.
}


/+
///
class StatusBarPanelClickEventArgs: MouseEventArgs
{
	///
	this(StatusBarPanel sbpanel, MouseButtons btn, int clicks, int x, int y);
	
	private:
	StatusBarPanel _sbpanel;
}
+/


///
class StatusBar: ControlSuperClass // docmain
{
	///
	class StatusBarPanelCollection
	{
		protected this(StatusBar sb);
		
		private:
		
		StatusBar sb;
		package StatusBarPanel[] _panels;
		
		
		package void _fixwidths();
		
		void _fixtexts();
		
		void _setcurparts();
		
		void _removed(size_t idx, Object val);
		
		
		void _added(size_t idx, StatusBarPanel val);
		
		void _adding(size_t idx, StatusBarPanel val);
		
		public:
		
		mixin ListWrapArray!(StatusBarPanel, _panels,
			_adding, _added,
			_blankListCallback!(StatusBarPanel), _removed,
			true, /+true+/ false, false) _wraparray;
	}
	
	
	///
	this();
	
	// backColor / font / foreColor ...
	
	
	override void dock(DockStyle ds) ;
	alias Control.dock dock; // Overload.
	
	
	///
	final StatusBarPanelCollection panels();
	
	///
	final void showPanels(bool byes) ;
	
	/// ditto
	final bool showPanels() ;
	///
	final void sizingGrip(bool byes);
	/// ditto
	final bool sizingGrip() ;
	
	override void text(Dstring txt) ;
	/// ditto
	override Dstring text() ;
	
	protected override void onHandleCreated(EventArgs ea);
	
	
	protected override void createParams(inout CreateParams cp);
	
	protected override void prevWndProc(inout Message msg);
	/+
	protected override void createHandle();
	+/
	
	
	//StatusBarPanelClickEventHandler panelClick;
	//Event!(StatusBar, StatusBarPanelClickEventArgs) panelClick; ///
	
	
	protected:
	
	// onDrawItem ...
	
	
	/+
	///
	void onPanelClick(StatusBarPanelClickEventArgs ea);
	+/
	
	
	private:
	
	StatusBarPanelCollection lpanels;
	Dstring _simpletext = null;
	bool _issimple = true;
	
	
	package:
	final:
	
	LRESULT prevwproc(UINT msg, WPARAM wparam, LPARAM lparam);
	
	void _sendidxtext(int idx, WPARAM utype, Dstring txt);
}

