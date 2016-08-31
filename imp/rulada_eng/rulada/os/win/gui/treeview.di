// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.treeview;

private import os.win.gui.x.dlib;

private import os.win.gui.control, os.win.gui.application, os.win.gui.base, os.win.gui.x.winapi;
private import os.win.gui.event, os.win.gui.drawing, os.win.gui.collections, os.win.gui.x.utf;

version(DFL_NO_IMAGELIST)
{
}
else
{
	private import os.win.gui.imagelist;
}


private extern(Windows) void _initTreeview();


///
enum TreeViewAction: ubyte
{
	UNKNOWN, ///
	COLLAPSE, /// ditto
	EXPAND, /// ditto
	BY_KEYBOARD, /// ditto
	BY_MOUSE, /// ditto
}


///
class TreeViewCancelEventArgs: CancelEventArgs
{
	///
	this(TreeNode node, bool cancel, TreeViewAction action);
	
	///
	final TreeViewAction action();
	
	
	///
	final TreeNode node() ;
	
	private:
	TreeNode _node;
	TreeViewAction _action;
}


///
class TreeViewEventArgs: EventArgs
{
	///
	this(TreeNode node, TreeViewAction action);
	
	/// ditto
	this(TreeNode node);
	
	///
	final TreeViewAction action();
	
	
	///
	final TreeNode node() ;
	
	
	private:
	TreeNode _node;
	TreeViewAction _action = TreeViewAction.UNKNOWN;
}


///
class NodeLabelEditEventArgs: EventArgs
{
	///
	this(TreeNode node, Dstring label);
	
	/// ditto
	this(TreeNode node);
	
	
	///
	final TreeNode node() ;
	
	
	///
	final Dstring label();
	
	
	///
	final void cancelEdit(bool byes);
	
	/// ditto
	final bool cancelEdit() ;
	
	
	private:
	TreeNode _node;
	Dstring _label;
	bool _cancel = false;
}


///
class TreeNode: DObject
{
	///
	this(Dstring labelText);
	
	/// ditto
	this(Dstring labelText, TreeNode[] children);
	
	/// ditto
	this();
	
	this(Object val) ;
	
	
	/+
	///
	final void backColor(Color c) ;
	/// ditto
	final Color backColor() ;
	+/
	
	
	///
	final Rect bounds() ;
	
	
	///
	final TreeNode firstNode() ;
	
	
	/+
	///
	final void foreColor(Color c) ;
	
	/// ditto
	final Color foreColor() ;
	+/
	
	
	///
	// Path from the root to this node.
	final Dstring fullPath() ;
	
	
	///
	final HTREEITEM handle() ;
	
	
	///
	// Index of this node in the parent node.
	final int index();
	
	
	/+
	///
	final bool isEditing() ;
	+/
	
	
	///
	final bool isExpanded();
	
	
	///
	final bool isSelected();
	
	
	/+
	///
	final bool isVisible() ;
	+/
	
	
	///
	final TreeNode lastNode();
	
	
	///
	// Next sibling node.
	final TreeNode nextNode() ;
	
	
	/+
	///
	final void nodeFont(Font f);
	
	/// ditto
	final Font nodeFont();
	+/
	
	
	///
	final TreeNodeCollection nodes() ;
	
	
	///
	final TreeNode parent() ;
	
	
	///
	// Previous sibling node.
	final TreeNode prevNode();
	
	
	///
	final void tag(Object o) ;
	
	/// ditto
	final Object tag();
	
	
	///
	final void text(Dstring newText) ;
	
	/// ditto
	final Dstring text() ;
	
	
	///
	// Get the TreeView control this node belongs to.
	final TreeView treeView();
	
	
	///
	final void beginEdit();
	
	
	/+
	///
	final void endEdit(bool cancel);
	+/
	
	
	///
	final void ensureVisible();
	
	
	///
	final void collapse();
	
	
	///
	final void expand();
	
	
	///
	final void expandAll();
	
	
	///
	static TreeNode fromHandle(TreeView tree, HTREEITEM handle);
	
	///
	final void remove();
	
	
	///
	final void toggle();
	
	
	version(DFL_NO_IMAGELIST)
	{
	}
	else
	{
		///
		final void imageIndex(int index);
		
		/// ditto
		final int imageIndex() ;
	}
	
	
	override Dstring toString();
	
	
	override Dequ opEquals(Object o);
	
	Dequ opEquals(TreeNode node);
	
	Dequ opEquals(Dstring val);
	
	
	override int opCmp(Object o);
	
	int opCmp(TreeNode node);
	
	int opCmp(Dstring val);
	
	
	private:
	Dstring ttext;
	TreeNode tparent;
	TreeNodeCollection tchildren;
	Object ttag;
	HTREEITEM hnode;
	TreeView tview;
	version(DFL_NO_IMAGELIST)
	{
	}
	else
	{
		int _imgidx = -1;
	}
	/+
	Color bcolor, fcolor;
	Font tfont;
	+/
	
	
	package final bool created();
	
	
	bool isState(UINT state);
	
	
	void _reset();
}


///
class TreeNodeCollection
{
	void add(TreeNode node);
	
	void add(Dstring text);
	
	void add(Object val);
	
	
	void addRange(Object[] range);
	
	void addRange(TreeNode[] range);
	
	void addRange(Dstring[] range);
	
	
	// Like clear but doesn't bother removing stuff from the lists.
	// Used when a parent is being removed and the children only
	// need to be reset.
	private void _reset();
	
	
	// Clear node handles when the TreeView window is destroyed so
	// that it can be reconstructed.
	private void _resetHandles();
	
	
	private:
	
	TreeView tview; // null if not assigned to a TreeView yet.
	TreeNode tparent; // null if root. The parent of -_nodes-.
	TreeNode[] _nodes;
	
	
	void verifyNoParent(TreeNode node);
	
	
	package this(TreeView treeView, TreeNode parentNode);
	
	package final void setTreeView(TreeView treeView);
	
	
	package final bool created() ;
	
	
	package void populateInsertChildNode(inout Message m, inout TV_ITEMA dest, TreeNode node);
	
	
	void doNodes();
	
	void _added(size_t idx, TreeNode val);
	
	void _removing(size_t idx, TreeNode val);
	
	
	void _removed(size_t idx, TreeNode val);
	
	
	public:
	
	mixin ListWrapArray!(TreeNode, _nodes,
		_blankListCallback!(TreeNode), _added,
		_removing, _removed,
		true, /+true+/ false, false) _wraparray;
}


///
class TreeView: ControlSuperClass // docmain
{
	this();
	
	/+
	~this();
	+/
	
	
	static Color defaultBackColor() ;
	
	override Color backColor();
	
	
	override void backColor(Color b) ;
	
	static Color defaultForeColor();	
	
	override Color foreColor() ;
	alias Control.foreColor foreColor; // Overload.
	
	
	final void borderStyle(BorderStyle bs) ;
	
	
	final BorderStyle borderStyle();
	
	
	/+
	///
	final void checkBoxes(bool byes) ;
	
	/// ditto
	final bool checkBoxes() ;
	+/
	
	
	///
	final void fullRowSelect(bool byes) ;
	
	/// ditto
	final bool fullRowSelect();
	
	
	///
	final void hideSelection(bool byes);
	
	/// ditto
	final bool hideSelection();
	
	
	deprecated alias hoverSelection hotTracking;
	
	///
	final void hoverSelection(bool byes);
	
	/// ditto
	final bool hoverSelection();
	
	
	///
	final void indent(int newIndent) ;
	
	/// ditto
	final int indent() ;
	
	
	///
	final void itemHeight(int h) ;
	
	/// ditto
	final int itemHeight() ;
	
	
	///
	final void labelEdit(bool byes);
	
	/// ditto
	final bool labelEdit() ;
	
	///
	final TreeNodeCollection nodes() ;
	
	
	///
	final void pathSeparator(dchar sep);
	
	/// ditto
	final dchar pathSeparator() ;
	
	
	///
	final void scrollable(bool byes) ;
	
	/// ditto
	final bool scrollable() ;
	
	
	///
	final void selectedNode(TreeNode node);
	
	/// ditto
	final TreeNode selectedNode() ;
	
	///
	final void showLines(bool byes) ;
	
	/// ditto
	final bool showLines() ;
	
	///
	final void showPlusMinus(bool byes);
	
	/// ditto
	final bool showPlusMinus() ;
	
	///
	// -showPlusMinus- should be false.
	final void singleExpand(bool byes) ;
	
	/// ditto
	final bool singleExpand();
	
	
	///
	final void showRootLines(bool byes) ;
	
	/// ditto
	final bool showRootLines() ;
	
	///
	final void sorted(bool byes) ;
	
	/// ditto
	final bool sorted() ;
	
	
	///
	// First visible node, based on the scrolled position.
	final TreeNode topNode() ;
	
	
	///
	// Number of visible nodes, including partially visible.
	final int visibleCount() ;
	
	
	///
	final void beginUpdate();
	
	/// ditto
	final void endUpdate();
	
	///
	final void collapseAll();
	
	
	///
	final void expandAll();
	
	///
	final TreeNode getNodeAt(int x, int y);
	
	/// ditto
	final TreeNode getNodeAt(Point pt);
	
	/+
	///
	// TODO: finish.
	final int getNodeCount(bool includeSubNodes);
	+/
	
	
	version(DFL_NO_IMAGELIST)
	{
	}
	else
	{
		///
		final void imageList(ImageList imglist) ;
		
		/// ditto
		final ImageList imageList();
		
		
		/+
		///
		// Default image index (if -1 use this).
		final void imageIndex(int index);
		
		/// ditto
		final int imageIndex() ;
		+/
		
		
		///
		final void selectedImageIndex(int index);
		/// ditto
		final int selectedImageIndex() ;
	}
	
	
	protected override Size defaultSize() ;
	
	/+
	override void createHandle();
	+/
	
	
	protected override void createParams(inout CreateParams cp);
	
	
	protected override void onHandleCreated(EventArgs ea);
	
	protected override void onHandleDestroyed(EventArgs ea);
	
	protected override void wndProc(inout Message m);
	
	protected override void prevWndProc(inout Message msg);
	
	//TreeViewEventHandler afterCollapse;
	Event!(TreeView, TreeViewEventArgs) afterCollapse; ///
	//TreeViewEventHandler afterExpand;
	Event!(TreeView, TreeViewEventArgs) afterExpand; ///
	//TreeViewEventHandler afterSelect;
	Event!(TreeView, TreeViewEventArgs) afterSelect; ///
	//NodeLabelEditEventHandler afterLabelEdit;
	Event!(TreeView, NodeLabelEditEventArgs) afterLabelEdit; ///
	//TreeViewCancelEventHandler beforeCollapse;
	Event!(TreeView, TreeViewCancelEventArgs) beforeCollapse; ///
	//TreeViewCancelEventHandler beforeExpand;
	Event!(TreeView, TreeViewCancelEventArgs) beforeExpand; ///
	//TreeViewCancelEventHandler beforeSelect;
	Event!(TreeView, TreeViewCancelEventArgs) beforeSelect; ///
	//NodeLabelEditEventHandler beforeLabelEdit;
	Event!(TreeView, NodeLabelEditEventArgs) beforeLabelEdit; ///
	
	
	///
	protected void onAfterCollapse(TreeViewEventArgs ea);
	
	
	///
	protected void onAfterExpand(TreeViewEventArgs ea);
	
	
	///
	protected void onAfterSelect(TreeViewEventArgs ea);
	
	///
	protected void onAfterLabelEdit(NodeLabelEditEventArgs ea);
	
	
	///
	protected void onBeforeCollapse(TreeViewCancelEventArgs ea);
	
	///
	protected void onBeforeExpand(TreeViewCancelEventArgs ea);
	
	
	///
	protected void onBeforeSelect(TreeViewCancelEventArgs ea);
	
	
	///
	protected void onBeforeLabelEdit(NodeLabelEditEventArgs ea);
	
	protected override void onReflectedMessage(inout Message m);
	
	private:
	TreeNodeCollection tchildren;
	int ind = 19; // Indent.
	dchar pathsep = '\\';
	bool _sort = false;
	int iheight = 16;
	version(DFL_NO_IMAGELIST)
	{
	}
	else
	{
		ImageList _imglist;
		int _selimgidx = -1; //0;
	}
	
	
	TreeNode treeNodeFromHandle(HTREEITEM hnode);
	
	package:
	final:
	LRESULT prevwproc(UINT msg, WPARAM wparam, LPARAM lparam);
}

