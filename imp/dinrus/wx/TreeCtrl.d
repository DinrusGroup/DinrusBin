module wx.TreeCtrl;
public import wx.common;
public import wx.Control;
public import wx.ClientData;
public import wx.ImageList;
public import wx.KeyEvent;

	public enum TreeItemIcon
	{
		wxTreeItemIcon_Normal,
		wxTreeItemIcon_Selected,
		wxTreeItemIcon_Expanded,
		wxTreeItemIcon_SelectedExpanded,
		wxTreeItemIcon_Max
	}
	
	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxTreeItemData_ctor();
		static extern (C) void   wxTreeItemData_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
		static extern (C) void   wxTreeItemData_dtor(IntPtr self);
		static extern (C) IntPtr wxTreeItemData_GetId(IntPtr self);
		static extern (C) void   wxTreeItemData_SetId(IntPtr self, IntPtr param);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias TreeItemData wxTreeItemData;
	public class TreeItemData : ClientData
	{
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this();
		override protected void dtor();
		public TreeItemId Id() ;
		public void Id(TreeItemId value) ;
	}
	
	//-----------------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxTreeItemAttr_ctor();
		static extern (C) IntPtr wxTreeItemAttr_ctor2(IntPtr colText, IntPtr colBack, IntPtr font);
		static extern (C) void   wxTreeItemAttr_dtor(IntPtr self);
		static extern (C) void   wxTreeItemAttr_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
		static extern (C) void   wxTreeItemAttr_SetTextColour(IntPtr self, IntPtr colText);
		static extern (C) void   wxTreeItemAttr_SetBackgroundColour(IntPtr self, IntPtr colBack);
		static extern (C) void   wxTreeItemAttr_SetFont(IntPtr self, IntPtr font);
		static extern (C) bool   wxTreeItemAttr_HasTextColour(IntPtr self);
		static extern (C) bool   wxTreeItemAttr_HasBackgroundColour(IntPtr self);
		static extern (C) bool   wxTreeItemAttr_HasFont(IntPtr self);
		static extern (C) IntPtr wxTreeItemAttr_GetTextColour(IntPtr self);
		static extern (C) IntPtr wxTreeItemAttr_GetBackgroundColour(IntPtr self);
		static extern (C) IntPtr wxTreeItemAttr_GetFont(IntPtr self);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias TreeItemAttr wxTreeItemAttr;
	public class TreeItemAttr : wxObject
	{
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this();
		public this(Colour colText, Colour colBack, Font font);
		override protected void dtor() ;
		public Colour TextColour() ;
		public void TextColour(Colour value) ;
		public Colour BackgroundColour() ;
		public void BackgroundColour(Colour value) ;
		public Font font() ;
		public void font(Font value);
		public bool HasTextColour();
		public bool HasBackgroundColour() ;
		public bool HasFont() ;
	}
	
	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxTreeItemId_ctor();
		static extern (C) IntPtr wxTreeItemId_ctor2(void* pItem);
		static extern (C) void   wxTreeItemId_dtor(IntPtr self);
		static extern (C) void   wxTreeItemId_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
		static extern (C) bool   wxTreeItemId_Equal(IntPtr item1, IntPtr item2);
		static extern (C) bool   wxTreeItemId_IsOk(IntPtr self);
		//! \endcond
		
		//---------------------------------------------------------------------

	//[StructLayout(LayoutKind.Sequential)]
	alias TreeItemId wxTreeItemId;
	public class TreeItemId : wxObject
	{
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this();
		public this(/*ClientData*/void* pItem);
		override protected void dtor() ;

version (D_Version2) // changed in DMD 2.016
{
		public override bool opEquals(Object o);
}
else // D_Version1
{
		public override int opEquals(Object o);
}
		
		public override hash_t toHash();
		public bool IsOk();
	}
	
	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		extern (C) {
		alias int function(TreeCtrl obj, IntPtr item1, IntPtr item2) Virtual_OnCompareItems;
		}
		
		static extern (C) uint   wxTreeCtrl_GetDefaultStyle();
		static extern (C) IntPtr wxTreeCtrl_ctor();
		static extern (C) void   wxTreeCtrl_RegisterVirtual(IntPtr self,TreeCtrl obj, Virtual_OnCompareItems onCompareItems);
		static extern (C) int    wxTreeCtrl_OnCompareItems(IntPtr self, IntPtr item1, IntPtr item2);
		static extern (C) IntPtr wxTreeCtrl_AddRoot(IntPtr self, string text, int image, int selImage, IntPtr data);
		static extern (C) IntPtr wxTreeCtrl_AppendItem(IntPtr self, IntPtr parent, string text, int image, int selImage, IntPtr data);
		static extern (C) void   wxTreeCtrl_AssignImageList(IntPtr self, IntPtr imageList);
		static extern (C) void   wxTreeCtrl_AssignStateImageList(IntPtr self, IntPtr imageList);
		//static extern (C) void   wxTreeCtrl_AssignButtonsImageList(IntPtr self, IntPtr imageList);
		static extern (C) bool   wxTreeCtrl_Create(IntPtr self, IntPtr parent, int id, inout Point pos, inout Size size, uint style, IntPtr val, string name);
		static extern (C) IntPtr wxTreeCtrl_GetImageList(IntPtr self);
		static extern (C) IntPtr wxTreeCtrl_GetStateImageList(IntPtr self);
		//static extern (C) IntPtr wxTreeCtrl_GetButtonsImageList(IntPtr self);
		static extern (C) void   wxTreeCtrl_SetImageList(IntPtr self, IntPtr imageList);
		static extern (C) void   wxTreeCtrl_SetStateImageList(IntPtr self, IntPtr imageList);
		//static extern (C) void   wxTreeCtrl_SetButtonsImageList(IntPtr self, IntPtr imageList);
		static extern (C) void   wxTreeCtrl_SetItemImage(IntPtr self, IntPtr item, int image, TreeItemIcon which);
		static extern (C) int    wxTreeCtrl_GetItemImage(IntPtr self, IntPtr item, TreeItemIcon which);

		static extern (C) void   wxTreeCtrl_DeleteAllItems(IntPtr self);
		static extern (C) void   wxTreeCtrl_Delete(IntPtr self, IntPtr item);
		static extern (C) void   wxTreeCtrl_DeleteChildren(IntPtr self, IntPtr item);

		static extern (C) void   wxTreeCtrl_Unselect(IntPtr self);
		static extern (C) void   wxTreeCtrl_UnselectAll(IntPtr self);

		static extern (C) bool   wxTreeCtrl_IsSelected(IntPtr self, IntPtr item);
		static extern (C) IntPtr wxTreeCtrl_GetSelection(IntPtr self);
		static extern (C) void   wxTreeCtrl_SelectItem(IntPtr self, IntPtr item);

		static extern (C) IntPtr wxTreeCtrl_GetItemText(IntPtr self, IntPtr item);
		static extern (C) void   wxTreeCtrl_SetItemText(IntPtr self, IntPtr item, string text);

		static extern (C) IntPtr wxTreeCtrl_HitTest(IntPtr self, inout Point pt, inout int flags);

		static extern (C) void   wxTreeCtrl_SetItemData(IntPtr self, IntPtr item, IntPtr data);
		static extern (C) IntPtr wxTreeCtrl_GetItemData(IntPtr self, IntPtr item);

		static extern (C) IntPtr wxTreeCtrl_GetRootItem(IntPtr self);
		static extern (C) IntPtr wxTreeCtrl_GetItemParent(IntPtr self, IntPtr item);

		static extern (C) IntPtr wxTreeCtrl_GetFirstChild(IntPtr self, IntPtr item);
		static extern (C) IntPtr wxTreeCtrl_GetNextChild(IntPtr self, IntPtr item);
		static extern (C) IntPtr wxTreeCtrl_GetLastChild(IntPtr self, IntPtr item);

		static extern (C) IntPtr wxTreeCtrl_GetNextSibling(IntPtr self, IntPtr item);
		static extern (C) IntPtr wxTreeCtrl_GetPrevSibling(IntPtr self, IntPtr item);

		static extern (C) IntPtr wxTreeCtrl_GetFirstVisibleItem(IntPtr self);
		static extern (C) IntPtr wxTreeCtrl_GetNextVisible(IntPtr self, IntPtr item);
		static extern (C) IntPtr wxTreeCtrl_GetPrevVisible(IntPtr self, IntPtr item);

		static extern (C) void   wxTreeCtrl_Expand(IntPtr self, IntPtr item);

		static extern (C) void   wxTreeCtrl_Collapse(IntPtr self, IntPtr item);
		static extern (C) void   wxTreeCtrl_CollapseAndReset(IntPtr self, IntPtr item);

		static extern (C) void   wxTreeCtrl_Toggle(IntPtr self, IntPtr item);

		static extern (C) void   wxTreeCtrl_EnsureVisible(IntPtr self, IntPtr item);
		static extern (C) void   wxTreeCtrl_ScrollTo(IntPtr self, IntPtr item);

		static extern (C) int    wxTreeCtrl_GetChildrenCount(IntPtr self, IntPtr item, bool recursively);
		static extern (C) int    wxTreeCtrl_GetCount(IntPtr self);

		static extern (C) bool   wxTreeCtrl_IsVisible(IntPtr self, IntPtr item);

		static extern (C) bool   wxTreeCtrl_ItemHasChildren(IntPtr self, IntPtr item);

		static extern (C) bool   wxTreeCtrl_IsExpanded(IntPtr self, IntPtr item);
		
		static extern (C) uint   wxTreeCtrl_GetIndent(IntPtr self);
		static extern (C) void   wxTreeCtrl_SetIndent(IntPtr self, uint indent);
		
		static extern (C) uint   wxTreeCtrl_GetSpacing(IntPtr self);
		static extern (C) void   wxTreeCtrl_SetSpacing(IntPtr self, uint indent);
		
		static extern (C) IntPtr wxTreeCtrl_GetItemTextColour(IntPtr self, IntPtr item);
		static extern (C) IntPtr wxTreeCtrl_GetItemBackgroundColour(IntPtr self, IntPtr item);
		static extern (C) IntPtr wxTreeCtrl_GetItemFont(IntPtr self, IntPtr item);
		
		static extern (C) void   wxTreeCtrl_SetItemHasChildren(IntPtr self, IntPtr item, bool has);
		static extern (C) void   wxTreeCtrl_SetItemBold(IntPtr self, IntPtr item, bool bold);
		static extern (C) void   wxTreeCtrl_SetItemTextColour(IntPtr self, IntPtr item, IntPtr col);
		static extern (C) void   wxTreeCtrl_SetItemBackgroundColour(IntPtr self, IntPtr item, IntPtr col);
		
		static extern (C) void   wxTreeCtrl_EditLabel(IntPtr self, IntPtr item);
		
		static extern (C) bool   wxTreeCtrl_GetBoundingRect(IntPtr self, IntPtr item, inout Rectangle rect, bool textOnly);
		
		static extern (C) IntPtr wxTreeCtrl_InsertItem(IntPtr self, IntPtr parent, IntPtr idPrevious, string text, int image, int selectedImage, IntPtr data);
		static extern (C) IntPtr wxTreeCtrl_InsertItem2(IntPtr self, IntPtr parent, int before, string text, int image, int selectedImage, IntPtr data);
		
		static extern (C) bool   wxTreeCtrl_IsBold(IntPtr self, IntPtr item);
		
		static extern (C) IntPtr wxTreeCtrl_PrependItem(IntPtr self, IntPtr parent, string text, int image, int selectedImage, IntPtr data);
		
		static extern (C) void   wxTreeCtrl_SetItemSelectedImage(IntPtr self, IntPtr item, int selImage);
		
		static extern (C) void   wxTreeCtrl_ToggleItemSelection(IntPtr self, IntPtr item);
		
		static extern (C) void   wxTreeCtrl_UnselectItem(IntPtr self, IntPtr item);
		
		static extern (C) IntPtr wxTreeCtrl_GetMyCookie(IntPtr self);
		static extern (C) void   wxTreeCtrl_SetMyCookie(IntPtr self, IntPtr newval);
		
		static extern (C) IntPtr wxTreeCtrl_GetSelections(IntPtr self);
		
		static extern (C) void   wxTreeCtrl_SetItemFont(IntPtr self, IntPtr item, IntPtr font);
		static extern (C) void   wxTreeCtrl_SortChildren(IntPtr self, IntPtr item);
		//! \endcond

		//---------------------------------------------------------------------

	alias TreeCtrl wxTreeCtrl;
	public class TreeCtrl : Control
	{
		public const int wxTR_NO_BUTTONS                = 0x0000;
		public const int wxTR_HAS_BUTTONS                = 0x0001;
		public const int wxTR_TWIST_BUTTONS            = 0x0010;
		public const int wxTR_NO_LINES                    = 0x0004;
		public const int wxTR_LINES_AT_ROOT             = 0x0008;
		public const int wxTR_MAC_BUTTONS                = 0; // deprecated
		public const int wxTR_AQUA_BUTTONS                = 0; // deprecated

		public const int wxTR_SINGLE                    = 0x0000;
		public const int wxTR_MULTIPLE                    = 0x0020;
		public const int wxTR_EXTENDED                    = 0x0040;
		public const int wxTR_FULL_ROW_HIGHLIGHT         = 0x2000;

		public const int wxTR_EDIT_LABELS                = 0x0200;
		public const int wxTR_ROW_LINES                = 0x0400;
		public const int wxTR_HIDE_ROOT                = 0x0800;
		public const int wxTR_HAS_VARIABLE_ROW_HEIGHT    = 0x0080;

		public static /*readonly*/ int wxTR_DEFAULT_STYLE;

		static this()
		{
			wxTR_DEFAULT_STYLE    = wxTreeCtrl_GetDefaultStyle();
		}

		//-----------------------------------------------------------------------------

		public const int wxTREE_HITTEST_ABOVE           = 0x0001;
		public const int wxTREE_HITTEST_BELOW           = 0x0002;
		public const int wxTREE_HITTEST_NOWHERE         = 0x0004;
		public const int wxTREE_HITTEST_ONITEMBUTTON    = 0x0008;
		public const int wxTREE_HITTEST_ONITEMICON      = 0x0010;
		public const int wxTREE_HITTEST_ONITEMINDENT    = 0x0020;
		public const int wxTREE_HITTEST_ONITEMLABEL     = 0x0040;
		public const int wxTREE_HITTEST_ONITEMRIGHT     = 0x0080;
		public const int wxTREE_HITTEST_ONITEMSTATEICON = 0x0100;
		public const int wxTREE_HITTEST_TOLEFT          = 0x0200;
		public const int wxTREE_HITTEST_TORIGHT         = 0x0400;
		public const int wxTREE_HITTEST_ONITEMUPPERPART = 0x0800;
		public const int wxTREE_HITTEST_ONITEMLOWERPART = 0x1000;

		public const int wxTREE_HITTEST_ONITEM = wxTREE_HITTEST_ONITEMICON | wxTREE_HITTEST_ONITEMLABEL;
		
		public const string wxTreeCtrlNameStr = "treeCtrl";
		//-----------------------------------------------------------------------------
		
		public this(IntPtr wxobj);
		public this();
		public this(Window parent, int id /*= wxID_ANY*/, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxTR_HAS_BUTTONS | wxTR_LINES_AT_ROOT, Validator val = null, string name = wxTreeCtrlNameStr);
		public static wxObject New(IntPtr wxobj);
		public this(Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxTR_HAS_BUTTONS | wxTR_LINES_AT_ROOT, Validator val = null, string name = wxTreeCtrlNameStr);
		public bool Create(Window parent, int id, inout Point pos, inout Size size, int style, Validator val, string name);
		static extern (C) private int staticDoOnCompareItems(TreeCtrl obj, IntPtr item1, IntPtr item2);
		public /+virtual+/ int OnCompareItems(TreeItemId item1, TreeItemId item2);
		public TreeItemId AddRoot(string text);
		public TreeItemId AddRoot(string text, int image);
		public TreeItemId AddRoot(string text, int image, int selImage);
		public TreeItemId AddRoot(string text, int image, int selImage, TreeItemData data);
		public TreeItemId AppendItem(TreeItemId parentId, string text);
		public TreeItemId AppendItem(TreeItemId parentId, string text, int image);
		public TreeItemId AppendItem(TreeItemId parentId, string text, int image, int selImage);
		public TreeItemId AppendItem(TreeItemId parentId, string text, int image, int selImage, TreeItemData data);
		public void AssignImageList(ImageList imageList);
		public void AssignStateImageList(ImageList imageList);
		public ImageList imageList() ;			
		public void imageList(ImageList value) ;
		public void SetImageList(ImageList imageList);
		public ImageList StateImageList() ;
		public void StateImageList(ImageList value) ;
		public void SetItemImage(TreeItemId item, int image);
		public void SetItemImage(TreeItemId item, int image, TreeItemIcon which);
		public int GetItemImage(TreeItemId item);
		public int GetItemImage(TreeItemId item, TreeItemIcon which);
		public void DeleteAllItems();
		public void Delete(TreeItemId item);
		public void DeleteChildren(TreeItemId item);
		public void Unselect();
		public void UnselectAll();
		public bool IsSelected(TreeItemId item);
		public void SelectItem(TreeItemId item);
		public TreeItemId Selection();
		public void Selection(TreeItemId value) ;
		public void SetItemText(TreeItemId item, string text);
		public string GetItemText(TreeItemId item);
		public void SetItemData(TreeItemId item, TreeItemData data);
		public TreeItemData GetItemData(TreeItemId item);
		public TreeItemId HitTest(Point pt, out int flags);
		public TreeItemId RootItem() ;
		public TreeItemId GetItemParent(TreeItemId item);
		public TreeItemId GetFirstChild(TreeItemId item, inout IntPtr cookie);
		public TreeItemId GetNextChild(TreeItemId item, inout IntPtr cookie);
		public TreeItemId GetLastChild(TreeItemId item);
		public TreeItemId GetNextSibling(TreeItemId item);
		public TreeItemId GetPrevSibling(TreeItemId item);
		public TreeItemId GetFirstVisibleItem();
		public TreeItemId GetNextVisible(TreeItemId item);
		public TreeItemId GetPrevVisible(TreeItemId item);
		public void Expand(TreeItemId item);
		public void Collapse(TreeItemId item);
		public void CollapseAndReset(TreeItemId item);
		public void Toggle(TreeItemId item);
		public void EnsureVisible(TreeItemId item);
		public void ScrollTo(TreeItemId item);
		public int GetChildrenCount(TreeItemId item);
		public int GetChildrenCount(TreeItemId item, bool recursively);
		public int Count() ;
		public bool IsVisible(TreeItemId item);
		public bool ItemHasChildren(TreeItemId item);
		public bool IsExpanded(TreeItemId item);
		public bool HasChildren(TreeItemId item);
		public TreeItemId[] SelectionsOld();
		public TreeItemId[] Selections();
		public TreeItemId[] SelectionsAtOrBelow(TreeItemId parent_item);
		public TreeItemId[] SelectionsBelow(TreeItemId parent_item);
		public TreeItemId[] AllItems();
		public TreeItemId[] AllItemsAtOrBelow(TreeItemId parent_item);
		public TreeItemId[] AllItemsBelow(TreeItemId parent_item);
		private enum GetItemsMode
		{
			Selections,
			All,
		}

		private TreeItemId[] Get_Items(GetItemsMode mode, TreeItemId parent_item, 
			bool skip_parent);
		private void Add_Items(GetItemsMode mode, TreeItemId parent, 
			TreeItemId[] list, IntPtr cookie, bool skip_parent);
		public uint Indent();
		public void Indent(uint value);
		public uint Spacing();
		public void Spacing(uint value) ;
		public Colour GetItemTextColour(TreeItemId item);
		public Colour GetItemBackgroundColour(TreeItemId item);
		public Font GetItemFont(TreeItemId item);
		public void SetItemFont(TreeItemId item, Font font);
		public void SetItemHasChildren(TreeItemId item);
		public void SetItemHasChildren(TreeItemId item, bool has);
		public void SetItemBold(TreeItemId item);
		public void SetItemBold(TreeItemId item, bool bold);
		public void SetItemTextColour(TreeItemId item, Colour col);
		public void SetItemBackgroundColour(TreeItemId item, Colour col);
		public void EditLabel(TreeItemId item);
		public bool GetBoundingRect(TreeItemId item, inout Rectangle rect);
		public bool GetBoundingRect(TreeItemId item, inout Rectangle rect, bool textOnly);
		public TreeItemId InsertItem(TreeItemId parent, TreeItemId previous, string text);
		public TreeItemId InsertItem(TreeItemId parent, TreeItemId previous, string text, int image);
		public TreeItemId InsertItem(TreeItemId parent, TreeItemId previous, string text, int image, int sellimage);
		public TreeItemId InsertItem(TreeItemId parent, TreeItemId previous, string text, int image, int sellimage, TreeItemData data);
		public TreeItemId InsertItem(TreeItemId parent, int before, string text);
		public TreeItemId InsertItem(TreeItemId parent, int before, string text, int image);
		public TreeItemId InsertItem(TreeItemId parent, int before, string text, int image, int sellimage);
		public TreeItemId InsertItem(TreeItemId parent, int before, string text, int image, int sellimage, TreeItemData data);
		public bool IsBold(TreeItemId item);
		public TreeItemId PrependItem(TreeItemId parent, string text);
		public TreeItemId PrependItem(TreeItemId parent, string text, int image);
		public TreeItemId PrependItem(TreeItemId parent, string text, int image, int sellimage);
		public TreeItemId PrependItem(TreeItemId parent, string text, int image, int sellimage, TreeItemData data);
		public void SetItemSelectedImage(TreeItemId item, int selImage);
		public void ToggleItemSelection(TreeItemId item);
		public void UnselectItem(TreeItemId item);
		public void SortChildren(TreeItemId item);
		public void BeginDrag_Add(EventListener value) ;
		public void BeginDrag_Remove(EventListener value) ;
		public void BeginRightDrag_Add(EventListener value) ;
		public void BeginRightDrag_Remove(EventListener value) ;
		public void BeginLabelEdit_Add(EventListener value) ;
		public void BeginLabelEdit_Remove(EventListener value) ;
		public void EndLabelEdit_Add(EventListener value) ;
		public void EndLabelEdit_Remove(EventListener value) ;
		public void DeleteItem_Add(EventListener value) ;
		public void DeleteItem_Remove(EventListener value) ;
		public void GetInfo_Add(EventListener value);
		public void GetInfo_Remove(EventListener value) ;
		public void SetInfo_Add(EventListener value) ;
		public void SetInfo_Remove(EventListener value) ;
		public void ItemExpand_Add(EventListener value) ;
		public void ItemExpand_Remove(EventListener value) ;
		public void ItemExpanding_Add(EventListener value) ;
		public void ItemExpanding_Remove(EventListener value) ;
		public void ItemCollapse_Add(EventListener value) ;
		public void ItemCollapse_Remove(EventListener value) ;
		public void ItemCollapsing_Add(EventListener value) ;
		public void ItemCollapsing_Remove(EventListener value) ;
		public void SelectionChange_Add(EventListener value) ;
		public void SelectionChange_Remove(EventListener value) ;
		public void SelectionChanging_Add(EventListener value) ;
		public void SelectionChanging_Remove(EventListener value);
		public override void KeyDown_Add(EventListener value) ;
		public override void KeyDown_Remove(EventListener value) ;
		public void ItemActivate_Add(EventListener value) ;
		public void ItemActivate_Remove(EventListener value) ;
		public void ItemRightClick_Add(EventListener value) ;
		public void ItemRightClick_Remove(EventListener value) ;
		public void ItemMiddleClick_Add(EventListener value) ;
		public void ItemMiddleClick_Remove(EventListener value) ;
		public void EndDrag_Add(EventListener value);
		public void EndDrag_Remove(EventListener value) ;

	}
	
	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxTreeEvent_ctor(int commandType, int id);
		static extern (C) IntPtr wxTreeEvent_GetItem(IntPtr self);
		static extern (C) void   wxTreeEvent_SetItem(IntPtr self, IntPtr item);
		static extern (C) IntPtr wxTreeEvent_GetOldItem(IntPtr self);
		static extern (C) void   wxTreeEvent_SetOldItem(IntPtr self, IntPtr item);
		static extern (C) void   wxTreeEvent_GetPoint(IntPtr self, inout Point pt);
		static extern (C) void   wxTreeEvent_SetPoint(IntPtr self, inout Point pt);
		static extern (C) IntPtr wxTreeEvent_GetKeyEvent(IntPtr self);
		static extern (C) int    wxTreeEvent_GetKeyCode(IntPtr self);
		static extern (C) void   wxTreeEvent_SetKeyEvent(IntPtr self, IntPtr evt);
		static extern (C) IntPtr wxTreeEvent_GetLabel(IntPtr self);
		static extern (C) void   wxTreeEvent_SetLabel(IntPtr self, string label);
		static extern (C) bool   wxTreeEvent_IsEditCancelled(IntPtr self);
		static extern (C) void   wxTreeEvent_SetEditCanceled(IntPtr self, bool editCancelled);
		//static extern (C) int    wxTreeEvent_GetCode(IntPtr self);
		static extern (C) void   wxTreeEvent_Veto(IntPtr self);
		static extern (C) void   wxTreeEvent_Allow(IntPtr self);
		static extern (C) bool   wxTreeEvent_IsAllowed(IntPtr self);       
		
		static extern (C) void   wxTreeEvent_SetToolTip(IntPtr self, string toolTip);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias TreeEvent wxTreeEvent;
	public class TreeEvent : Event
	{
		public this(IntPtr wxobj);
		public this(int commandType, int id);
		public TreeItemId Item() ;
		public void Item(TreeItemId value) ;
		public TreeItemId OldItem() ;
		public void OldItem(TreeItemId value) ;
		public Point point();
		public void point(Point value);
		public KeyEvent keyEvent();
		public void keyEvent(KeyEvent value) ;
		public int KeyCode();
		public string Label() ;
		public void Label(string value) ;
		public bool IsEditCancelled() ;
		public void IsEditCancelled(bool value) ;
		public void ToolTip(string value) ;
		public void Veto();
		public void Allow();
		public bool Allowed() ;
		private static Event New(IntPtr obj) ;
		static this();
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxArrayTreeItemIds_ctor();
		static extern (C) void   wxArrayTreeItemIds_dtor(IntPtr self);
		static extern (C) void   wxArrayTreeItemIds_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
		static extern (C) void   wxArrayTreeItemIds_Add(IntPtr self, IntPtr toadd);
		static extern (C) IntPtr wxArrayTreeItemIds_Item(IntPtr self, int num);
		static extern (C) int    wxArrayTreeItemIds_GetCount(IntPtr self);
		//! \endcond
		
		//---------------------------------------------------------------------

	alias ArrayTreeItemIds wxArrayTreeItemIds;
	public class ArrayTreeItemIds : wxObject
	{
		public this(IntPtr wxobj);			
		private this(IntPtr wxobj, bool memOwn);
		public this();
		public TreeItemId[] toArray();
		public TreeItemId Item(int num);
		public void Add(TreeItemId toadd);
		public int Count() ;
		override protected void dtor();
	}
