module wx.ListCtrl;
public import wx.common;
public import wx.Control;
public import wx.ClientData;
public import wx.ImageList;

		//! \cond EXTERN
		static extern (C) IntPtr wxListItem_ctor();
		static extern (C) void   wxListItem_Clear(IntPtr self);
		static extern (C) void   wxListItem_ClearAttributes(IntPtr self);
		static extern (C) int    wxListItem_GetAlign(IntPtr self);
		static extern (C) IntPtr wxListItem_GetBackgroundColour(IntPtr self);
		static extern (C) int    wxListItem_GetColumn(IntPtr self);
		static extern (C) IntPtr wxListItem_GetData(IntPtr self);
		static extern (C) IntPtr wxListItem_GetFont(IntPtr self);
		static extern (C) int    wxListItem_GetId(IntPtr self);
		static extern (C) int    wxListItem_GetImage(IntPtr self);
		static extern (C) int    wxListItem_GetMask(IntPtr self);
		static extern (C) int    wxListItem_GetState(IntPtr self);
		static extern (C) IntPtr wxListItem_GetText(IntPtr self);
		static extern (C) IntPtr wxListItem_GetTextColour(IntPtr self);
		static extern (C) int    wxListItem_GetWidth(IntPtr self);
		static extern (C) void   wxListItem_SetAlign(IntPtr self, int alignment);
		static extern (C) void   wxListItem_SetBackgroundColour(IntPtr self, IntPtr col);
		static extern (C) void   wxListItem_SetColumn(IntPtr self, int col);
		static extern (C) void   wxListItem_SetData(IntPtr self, IntPtr data);
		static extern (C) void   wxListItem_SetFont(IntPtr self, IntPtr font);
		static extern (C) void   wxListItem_SetId(IntPtr self, int id);
		static extern (C) void   wxListItem_SetImage(IntPtr self, int image);
		static extern (C) void   wxListItem_SetMask(IntPtr self, int mask);
		static extern (C) void   wxListItem_SetState(IntPtr self, int state);
		static extern (C) void   wxListItem_SetStateMask(IntPtr self, int stateMask);
		static extern (C) void   wxListItem_SetText(IntPtr self, string text);
		static extern (C) void   wxListItem_SetTextColour(IntPtr self, IntPtr col);
		static extern (C) void   wxListItem_SetWidth(IntPtr self, int width);
		
		static extern (C) IntPtr wxListItem_GetAttributes(IntPtr self);
		static extern (C) bool   wxListItem_HasAttributes(IntPtr self);
		//! \endcond

	alias ListItem wxListItem;
	public class ListItem : wxObject
	{
		//---------------------------------------------------------------------

		public this(IntPtr wxobj) ;
		public this() ;
		public static wxObject New(IntPtr ptr);
		public void Clear();
		public void ClearAttributes();
		public int Align();
		public void Align(int value) ;
		public Colour BackgroundColour() ;
		public void BackgroundColour(Colour value) ;
		public int Column();
		public void Column(int value) ;
		public ClientData Data() ;
		public void Data(ClientData value) ;
		public Font font() ;
		public void font(Font value);
		public int Id() ;
		public void Id(int value);
		public int Image() ;
		public void Image(int value);
		public int Mask() ;
		public void Mask(int value) ;
		public int State() ;
		public void State(int value);
		public void StateMask(int value);
		public string Text();
		public void Text(string value) ;
		public Colour TextColour();
		public void TextColour(Colour value) ;
		public int Width();
		public void Width(int value);
		public ListItemAttr Attributes() ;
		public bool HasAttributes();
	}
	
	//-----------------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxListItemAttr_ctor();
		static extern (C) IntPtr wxListItemAttr_ctor2(IntPtr colText, IntPtr colBack, IntPtr font);
		static extern (C) void   wxListItemAttr_dtor(IntPtr self);
		static extern (C) void   wxListItemAttr_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
		static extern (C) void   wxListItemAttr_SetTextColour(IntPtr self, IntPtr colText);
		static extern (C) void   wxListItemAttr_SetBackgroundColour(IntPtr self, IntPtr colBack);
		static extern (C) void   wxListItemAttr_SetFont(IntPtr self, IntPtr font);
		static extern (C) bool   wxListItemAttr_HasTextColour(IntPtr self);
		static extern (C) bool   wxListItemAttr_HasBackgroundColour(IntPtr self);
		static extern (C) bool   wxListItemAttr_HasFont(IntPtr self);
		static extern (C) IntPtr wxListItemAttr_GetTextColour(IntPtr self);
		static extern (C) IntPtr wxListItemAttr_GetBackgroundColour(IntPtr self);
		static extern (C) IntPtr wxListItemAttr_GetFont(IntPtr self);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias ListItemAttr wxListItemAttr;
	public class ListItemAttr : wxObject
	{
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this();
		public this(Colour colText, Colour colBack, Font font);
		public static wxObject New(IntPtr ptr);
		private override void dtor() ;
		public Colour TextColour() ;
		public void TextColour(Colour value) ;
		public Colour BackgroundColour();
		public void BackgroundColour(Colour value);
		public Font font();
		public void font(Font value);
		public bool HasTextColour();
		public bool HasBackgroundColour();
		public bool HasFont() ;
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		extern (C) {
		alias IntPtr function (ListCtrl, int) Virtual_OnGetItemAttr;
		alias int function (ListCtrl, int) Virtual_OnGetItemImage;
		alias int function (ListCtrl, int, int) Virtual_OnGetItemColumnImage;
		alias string function (ListCtrl, int, int) Virtual_OnGetItemText;

		alias int function(int item1, int item2, int sortData) wxListCtrlCompare;
		}
	
		static extern (C) IntPtr wxListCtrl_ctor();
		static extern (C) void   wxListCtrl_dtor(IntPtr self);
		static extern (C) void   wxListCtrl_RegisterVirtual(IntPtr self, ListCtrl obj, Virtual_OnGetItemAttr onGetItemAttr,
			Virtual_OnGetItemImage onGetItemImage,
			Virtual_OnGetItemColumnImage onGetItemColumnImage,
			Virtual_OnGetItemText onGetItemText);
		static extern (C) bool   wxListCtrl_Create(IntPtr self, IntPtr parent, int id, inout Point pos, inout Size size, uint style, IntPtr validator, string name);
		static extern (C) bool   wxListCtrl_GetColumn(IntPtr self, int col, inout IntPtr item);
		static extern (C) bool   wxListCtrl_SetColumn(IntPtr self, int col, IntPtr item);
		static extern (C) int    wxListCtrl_GetColumnWidth(IntPtr self, int col);
		static extern (C) bool   wxListCtrl_SetColumnWidth(IntPtr self, int col, int width);
		static extern (C) int    wxListCtrl_GetCountPerPage(IntPtr self);
		static extern (C) IntPtr wxListCtrl_GetItem(IntPtr self, IntPtr info, inout bool retval);
		static extern (C) bool   wxListCtrl_SetItem(IntPtr self, IntPtr info);
		static extern (C) int    wxListCtrl_SetItem_By_Row_Col(IntPtr self, int index, int col, string label, int imageId);
		static extern (C) int    wxListCtrl_GetItemState(IntPtr self, int item, int stateMask);
		static extern (C) bool   wxListCtrl_SetItemState(IntPtr self, int item, int state, int stateMask);
		static extern (C) bool   wxListCtrl_SetItemImage(IntPtr self, int item, int image, int selImage);
		static extern (C) IntPtr wxListCtrl_GetItemText(IntPtr self, int item);
		static extern (C) void   wxListCtrl_SetItemText(IntPtr self, int item, string str);
		static extern (C) IntPtr wxListCtrl_GetItemData(IntPtr self, int item);
		static extern (C) bool   wxListCtrl_SetItemData(IntPtr self, int item, IntPtr data);
		static extern (C) bool   wxListCtrl_SetItemData2(IntPtr self, int item, int data);
		static extern (C) bool   wxListCtrl_GetItemRect(IntPtr self, int item, out Rectangle rect, int code);
		static extern (C) bool   wxListCtrl_GetItemPosition(IntPtr self, int item, out Point pos);
		static extern (C) bool   wxListCtrl_SetItemPosition(IntPtr self, int item, inout Point pos);
		static extern (C) int    wxListCtrl_GetItemCount(IntPtr self);
		static extern (C) int    wxListCtrl_GetColumnCount(IntPtr self);
		static extern (C) void   wxListCtrl_SetItemTextColour(IntPtr self, int item, IntPtr col);
		static extern (C) IntPtr wxListCtrl_GetItemTextColour(IntPtr self, int item);
		static extern (C) void   wxListCtrl_SetItemBackgroundColour(IntPtr self, int item, IntPtr col);
		static extern (C) IntPtr wxListCtrl_GetItemBackgroundColour(IntPtr self, int item);
		static extern (C) int    wxListCtrl_GetSelectedItemCount(IntPtr self);
		static extern (C) IntPtr wxListCtrl_GetTextColour(IntPtr self);
		static extern (C) void   wxListCtrl_SetTextColour(IntPtr self, IntPtr col);
		static extern (C) int    wxListCtrl_GetTopItem(IntPtr self);
		static extern (C) void   wxListCtrl_SetSingleStyle(IntPtr self, uint style, bool add);
		static extern (C) void   wxListCtrl_SetWindowStyleFlag(IntPtr self, uint style);
		static extern (C) int    wxListCtrl_GetNextItem(IntPtr self, int item, int geometry, int state);
		static extern (C) IntPtr wxListCtrl_GetImageList(IntPtr self, int which);
		static extern (C) void   wxListCtrl_SetImageList(IntPtr self, IntPtr imageList, int which);
		static extern (C) void   wxListCtrl_AssignImageList(IntPtr self, IntPtr imageList, int which);
		static extern (C) bool   wxListCtrl_Arrange(IntPtr self, int flag);
		static extern (C) void   wxListCtrl_ClearAll(IntPtr self);
		static extern (C) bool   wxListCtrl_DeleteItem(IntPtr self, int item);
		static extern (C) bool   wxListCtrl_DeleteAllItems(IntPtr self);
		static extern (C) bool   wxListCtrl_DeleteAllColumns(IntPtr self);
		static extern (C) bool   wxListCtrl_DeleteColumn(IntPtr self, int col);
		static extern (C) void   wxListCtrl_SetItemCount(IntPtr self, int count);
		static extern (C) void   wxListCtrl_EditLabel(IntPtr self, int item);
		static extern (C) bool   wxListCtrl_EnsureVisible(IntPtr self, int item);
		static extern (C) int    wxListCtrl_FindItem(IntPtr self, int start, string str, bool partial);
		static extern (C) int    wxListCtrl_FindItemData(IntPtr self, int start, IntPtr data);
		static extern (C) int    wxListCtrl_FindItemPoint(IntPtr self, int start, inout Point pt, int direction);
		static extern (C) int    wxListCtrl_HitTest(IntPtr self, inout Point point, int flags);
		static extern (C) int    wxListCtrl_InsertItem(IntPtr self, IntPtr info);
		static extern (C) int    wxListCtrl_InsertTextItem(IntPtr self, int index, string label);
		static extern (C) int    wxListCtrl_InsertImageItem(IntPtr self, int index, int imageIndex);
		static extern (C) int    wxListCtrl_InsertTextImageItem(IntPtr self, int index, string label, int imageIndex);
		static extern (C) int    wxListCtrl_InsertColumn(IntPtr self, int col, IntPtr info);
		static extern (C) int    wxListCtrl_InsertTextColumn(IntPtr self, int col, string heading, int format, int width);
		static extern (C) bool   wxListCtrl_ScrollList(IntPtr self, int dx, int dy);
		static extern (C) bool   wxListCtrl_SortItems(IntPtr self, wxListCtrlCompare fn, int data);
		
		static extern (C) void   wxListCtrl_GetViewRect(IntPtr self, inout Rectangle rect);
		
		static extern (C) void   wxListCtrl_RefreshItem(IntPtr self, int item);
		static extern (C) void   wxListCtrl_RefreshItems(IntPtr self, int itemFrom, int itemTo);
		//! \endcond
	
	alias ListCtrl wxListCtrl;
	public class ListCtrl : Control
	{
		public const int wxLC_VRULES           = 0x0001;
		public const int wxLC_HRULES           = 0x0002;
	
		public const int wxLC_ICON             = 0x0004;
		public const int wxLC_SMALL_ICON       = 0x0008;
		public const int wxLC_LIST             = 0x0010;
		public const int wxLC_REPORT           = 0x0020;
	
		public const int wxLC_ALIGN_TOP        = 0x0040;
		public const int wxLC_ALIGN_LEFT       = 0x0080;
		public const int wxLC_AUTO_ARRANGE     = 0x0100;
		public const int wxLC_VIRTUAL          = 0x0200;
		public const int wxLC_EDIT_LABELS      = 0x0400;
		public const int wxLC_NO_HEADER        = 0x0800;
		public const int wxLC_NO_SORT_HEADER   = 0x1000;
		public const int wxLC_SINGLE_SEL       = 0x2000;
		public const int wxLC_SORT_ASCENDING   = 0x4000;
		public const int wxLC_SORT_DESCENDING  = 0x8000;
	
		public const int wxLC_MASK_TYPE        = (wxLC_ICON | wxLC_SMALL_ICON | wxLC_LIST | wxLC_REPORT);
		public const int wxLC_MASK_ALIGN       = (wxLC_ALIGN_TOP | wxLC_ALIGN_LEFT);
		public const int wxLC_MASK_SORT        = (wxLC_SORT_ASCENDING | wxLC_SORT_DESCENDING);
	
		public const int wxLIST_FORMAT_LEFT     = 0;
		public const int wxLIST_FORMAT_RIGHT    = 1;
		public const int wxLIST_FORMAT_CENTRE   = 2;
		public const int wxLIST_FORMAT_CENTER   = wxLIST_FORMAT_CENTRE;
	
		public const int wxLIST_MASK_STATE         = 0x0001;
		public const int wxLIST_MASK_TEXT          = 0x0002;
		public const int wxLIST_MASK_IMAGE         = 0x0004;
		public const int wxLIST_MASK_DATA          = 0x0008;
		public const int wxLIST_SET_ITEM           = 0x0010;
		public const int wxLIST_MASK_WIDTH         = 0x0020;
		public const int wxLIST_MASK_FORMAT        = 0x0040;
	
		public const int wxLIST_NEXT_ABOVE     = 1;
		public const int wxLIST_NEXT_ALL       = 2;
		public const int wxLIST_NEXT_BELOW     = 3;
		public const int wxLIST_NEXT_LEFT      = 4;
		public const int wxLIST_NEXT_RIGHT     = 5;
	
		public const int wxLIST_STATE_DONTCARE     = 0x0000;
		public const int wxLIST_STATE_DROPHILITED  = 0x0001;
		public const int wxLIST_STATE_FOCUSED      = 0x0002;
		public const int wxLIST_STATE_SELECTED     = 0x0004;
		public const int wxLIST_STATE_CUT          = 0x0008;
	
		public const int wxLIST_HITTEST_ABOVE          = 0x0001;
		public const int wxLIST_HITTEST_BELOW          = 0x0002;
		public const int wxLIST_HITTEST_NOWHERE        = 0x0004;
		public const int wxLIST_HITTEST_ONITEMICON     = 0x0020;
		public const int wxLIST_HITTEST_ONITEMLABEL    = 0x0080;
		public const int wxLIST_HITTEST_ONITEMRIGHT    = 0x0100;
		public const int wxLIST_HITTEST_ONITEMSTATEICON= 0x0200;
		public const int wxLIST_HITTEST_TOLEFT         = 0x0400;
		public const int wxLIST_HITTEST_TORIGHT        = 0x0800;
	
		public const int wxLIST_AUTOSIZE			= -1;
		public const int wxLIST_AUTOSIZE_USEHEADER	= -2;
		
		//---------------------------------------------------------------------
	
		//---------------------------------------------------------------------
        
		public this(IntPtr wxobj);
		public this();
		public this(Window parent, int id /*= wxID_ANY*/, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxLC_ICON, Validator validator = null, string name = "ListCtrl");
		public static wxObject New(IntPtr ptr);
		public this(Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxLC_ICON, Validator validator = null, string name = "ListCtrl");
		public bool Create(Window parent, int id, Point pos, Size size, int style, Validator validator, string name);
		static extern(C) private IntPtr staticOnGetItemAttr(ListCtrl obj, int item);
		protected /+virtual+/ wxListItemAttr OnGetItemAttr(int item);
		static extern(C) private int staticOnGetItemImage(ListCtrl obj, int item);
		protected /+virtual+/ int OnGetItemImage(int item);
		static extern(C) private int staticOnGetItemColumnImage(ListCtrl obj, int item, int column);
		protected /+virtual+/ int OnGetItemColumnImage(int item, int column);
		static extern(C) private string staticOnGetItemText(ListCtrl obj, int item, int column);
		protected /+virtual+/ string OnGetItemText(int item, int column);
		public bool GetColumn(int col, out ListItem item);
		public bool SetColumn(int col, ListItem item);
		public int GetColumnWidth(int col);
		public bool SetColumnWidth(int col, int width);
		public int CountPerPage();
		public bool GetItem(inout ListItem info);
		public bool SetItem(ListItem info);
		public int SetItem(int index, int col, string label);
		public int SetItem(int index, int col, string label, int imageId);
		public void SetItemText(int index, string label);
		public string GetItemText(int item);
		public int GetItemState(int item, int stateMask);
		public bool SetItemState(int item, int state, int stateMask);
		public bool SetItemImage(int item, int image, int selImage);
		public ClientData GetItemData(int item);
		public bool SetItemData(int item, ClientData data);
		public bool SetItemData(int item, int data);
		public bool GetItemRect(int item, out Rectangle rect, int code);
		public bool GetItemPosition(int item, out Point pos);
		public bool SetItemPosition(int item, Point pos);
		public int ItemCount() ;
		public void ItemCount(int value);
		public int ColumnCount() ;
		public void SetItemTextColour(int item, Colour col);
		public Colour GetItemTextColour(int item);
		public void SetItemBackgroundColour(int item, Colour col);
		public Colour GetItemBackgroundColour(int item);
		public int SelectedItemCount() ;
		public Colour TextColour() ;
		public void TextColour(Colour value);
		public int TopItem();
		public void SetSingleStyle(int style, bool add);
		public void WindowStyleFlag(int value);
		public int GetNextItem(int item, int geometry, int state);
		public ImageList GetImageList(int which);
		public void SetImageList(ImageList imageList, int which);
		public void AssignImageList(ImageList imageList, int which);
		public bool Arrange(int flag);
		public void ClearAll();
		public bool DeleteItem(int item);
		public bool DeleteAllItems();
		public bool DeleteAllColumns();
		public bool DeleteColumn(int col);
		public void EditLabel(int item);
		public bool EnsureVisible(int item);
		public int FindItem(int start, string str, bool partial);
		public int FindItem(int start, ClientData data);
		public int FindItem(int start, Point pt, int direction);
		public int HitTest(Point point, int flags);
		public int InsertItem(ListItem info);
		public int InsertItem(int index, string label);
		public int InsertItem(int index, int imageIndex);
		public int InsertItem(int index, string label, int imageIndex);
		public int InsertColumn(int col, ListItem info);
		public int InsertColumn(int col, string heading);
		public int InsertColumn(int col, string heading, int format, int width);
		public bool ScrollList(int dx, int dy);
		public Rectangle ViewRect() ;
		public void RefreshItem(int item);
		public void RefreshItems(int itemFrom, int itemTo);
		public bool SortItems(wxListCtrlCompare fn, int data);
		
		//-----------------------------------------------------------------------------

		public void BeginDrag_Add(EventListener value);
		public void BeginDrag_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------

		public void BeginRightDrag_Add(EventListener value);
		public void BeginRightDrag_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------

		public void BeginLabelEdit_Add(EventListener value) ;
		public void BeginLabelEdit_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------

		public void EndLabelEdit_Add(EventListener value) ;
		public void EndLabelEdit_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------

		public void ItemDelete_Add(EventListener value);
		public void ItemDelete_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------

		public void ItemDeleteAll_Add(EventListener value) ;
		public void ItemDeleteAll_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------
		
		public void GetInfo_Add(EventListener value) ;
		public void GetInfo_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------
		
		public void SetInfo_Add(EventListener value) ;
		public void SetInfo_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------

		public void ItemSelect_Add(EventListener value) ;
		public void ItemSelect_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------

		public void ItemDeselect_Add(EventListener value) ;
		public void ItemDeselect_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------

		public void ItemActivate_Add(EventListener value) ;
		public void ItemActivate_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------

		public void ItemFocus_Add(EventListener value) ;
		public void ItemFocus_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------

		public void ItemMiddleClick_Add(EventListener value);
		public void ItemMiddleClick_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------

		public void ItemRightClick_Add(EventListener value) ;
		public void ItemRightClick_Remove(EventListener value);
		
		//-----------------------------------------------------------------------------

		public override void KeyDown_Add(EventListener value);
		public override void KeyDown_Remove(EventListener value);
		
		//-----------------------------------------------------------------------------

		public void Insert_Add(EventListener value);
		public void Insert_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------

		public void ColumnClick_Add(EventListener value) ;
		public void ColumnClick_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------

		public void ColumnRightClick_Add(EventListener value);
		public void ColumnRightClick_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------

		public void ColumnBeginDrag_Add(EventListener value) ;
		public void ColumnBeginDrag_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------

		public void ColumnDragging_Add(EventListener value) ;
		public void ColumnDragging_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------

		public void ColumnEndDrag_Add(EventListener value) ;
		public void ColumnEndDrag_Remove(EventListener value) ;
		
		//-----------------------------------------------------------------------------

		public void CacheHint_Add(EventListener value);
		public void CacheHint_Remove(EventListener value);
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxListEvent_ctor(int commandType, int id);
		static extern (C) IntPtr wxListEvent_GetItem(IntPtr self);
		static extern (C) IntPtr wxListEvent_GetLabel(IntPtr self);
		static extern (C) int   wxListEvent_GetIndex(IntPtr self);
		static extern (C) int    wxListEvent_GetKeyCode(IntPtr self);
		static extern (C) int    wxListEvent_GetColumn(IntPtr self);
		static extern (C) void   wxListEvent_GetPoint(IntPtr self, inout Point pt);
		static extern (C) IntPtr wxListEvent_GetText(IntPtr self);
		static extern (C) int wxListEvent_GetImage(IntPtr self);
		static extern (C) int wxListEvent_GetData(IntPtr self);
		static extern (C) int wxListEvent_GetMask(IntPtr self);
		static extern (C) int wxListEvent_GetCacheFrom(IntPtr self);
		static extern (C) int wxListEvent_GetCacheTo(IntPtr self);
		static extern (C) bool wxListEvent_IsEditCancelled(IntPtr self);
		static extern (C) void wxListEvent_SetEditCanceled(IntPtr self, bool editCancelled);
		static extern (C) void wxListEvent_Veto(IntPtr self);
		static extern (C) void wxListEvent_Allow(IntPtr self);
		static extern (C) bool wxListEvent_IsAllowed(IntPtr self);			
		//! \endcond
		
		//---------------------------------------------------------------------
       
	alias ListEvent wxListEvent;
	public class ListEvent : Event 
	{
		public this(IntPtr wxobj);
		public this(int commandType, int id);
		static Event New(IntPtr ptr);
		public string Label() ;
		public int KeyCode();
		public int Index() ;
		public ListItem Item() ;
		public int Column();
		public Point point() ;
		public string Text();
		public int Image();
		public int Data() ;
		public int Mask() ;
		public int CacheFrom() ;
		public int CacheTo();
		public bool EditCancelled() ;
		public void EditCancelled(bool value);
		public void Veto();
		public void Allow();
		public bool Allowed();

		static this()
		{
			

			wxEVT_COMMAND_LIST_BEGIN_DRAG = wxEvent_EVT_COMMAND_LIST_BEGIN_DRAG();
			wxEVT_COMMAND_LIST_BEGIN_RDRAG = wxEvent_EVT_COMMAND_LIST_BEGIN_RDRAG();
			wxEVT_COMMAND_LIST_BEGIN_LABEL_EDIT = wxEvent_EVT_COMMAND_LIST_BEGIN_LABEL_EDIT();
			wxEVT_COMMAND_LIST_END_LABEL_EDIT = wxEvent_EVT_COMMAND_LIST_END_LABEL_EDIT();
			wxEVT_COMMAND_LIST_DELETE_ITEM = wxEvent_EVT_COMMAND_LIST_DELETE_ITEM();
			wxEVT_COMMAND_LIST_DELETE_ALL_ITEMS = wxEvent_EVT_COMMAND_LIST_DELETE_ALL_ITEMS();
			wxEVT_COMMAND_LIST_GET_INFO = wxEvent_EVT_COMMAND_LIST_GET_INFO();
			wxEVT_COMMAND_LIST_SET_INFO = wxEvent_EVT_COMMAND_LIST_SET_INFO();
			wxEVT_COMMAND_LIST_ITEM_SELECTED = wxEvent_EVT_COMMAND_LIST_ITEM_SELECTED();
			wxEVT_COMMAND_LIST_ITEM_DESELECTED = wxEvent_EVT_COMMAND_LIST_ITEM_DESELECTED();
			wxEVT_COMMAND_LIST_ITEM_ACTIVATED = wxEvent_EVT_COMMAND_LIST_ITEM_ACTIVATED();
			wxEVT_COMMAND_LIST_ITEM_FOCUSED = wxEvent_EVT_COMMAND_LIST_ITEM_FOCUSED();
			wxEVT_COMMAND_LIST_ITEM_MIDDLE_CLICK = wxEvent_EVT_COMMAND_LIST_ITEM_MIDDLE_CLICK();
			wxEVT_COMMAND_LIST_ITEM_RIGHT_CLICK = wxEvent_EVT_COMMAND_LIST_ITEM_RIGHT_CLICK();
			wxEVT_COMMAND_LIST_KEY_DOWN = wxEvent_EVT_COMMAND_LIST_KEY_DOWN();
			wxEVT_COMMAND_LIST_INSERT_ITEM = wxEvent_EVT_COMMAND_LIST_INSERT_ITEM();
			wxEVT_COMMAND_LIST_COL_CLICK = wxEvent_EVT_COMMAND_LIST_COL_CLICK();
			wxEVT_COMMAND_LIST_COL_RIGHT_CLICK = wxEvent_EVT_COMMAND_LIST_COL_RIGHT_CLICK();
			wxEVT_COMMAND_LIST_COL_BEGIN_DRAG = wxEvent_EVT_COMMAND_LIST_COL_BEGIN_DRAG();
			wxEVT_COMMAND_LIST_COL_DRAGGING = wxEvent_EVT_COMMAND_LIST_COL_DRAGGING();
			wxEVT_COMMAND_LIST_COL_END_DRAG = wxEvent_EVT_COMMAND_LIST_COL_END_DRAG();
			wxEVT_COMMAND_LIST_CACHE_HINT = wxEvent_EVT_COMMAND_LIST_CACHE_HINT();
		
			AddEventType(wxEVT_COMMAND_LIST_BEGIN_DRAG,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_BEGIN_RDRAG,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_BEGIN_LABEL_EDIT,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_END_LABEL_EDIT,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_DELETE_ITEM,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_DELETE_ALL_ITEMS,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_GET_INFO,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_SET_INFO,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_ITEM_SELECTED,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_ITEM_DESELECTED,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_ITEM_ACTIVATED,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_ITEM_FOCUSED,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_ITEM_MIDDLE_CLICK,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_ITEM_RIGHT_CLICK,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_KEY_DOWN,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_INSERT_ITEM,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_COL_CLICK,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_COL_RIGHT_CLICK,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_COL_BEGIN_DRAG,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_COL_DRAGGING,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_COL_END_DRAG,	&ListEvent.New);
			AddEventType(wxEVT_COMMAND_LIST_CACHE_HINT,	&ListEvent.New);
		}
	}

	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxListView_ctor();
		static extern (C) bool wxListView_Create(IntPtr self, IntPtr parent, int id, inout Point pos, inout Size size, uint style, IntPtr validator, string name);
		static extern (C) void   wxListView_RegisterVirtual(IntPtr self, ListCtrl obj, Virtual_OnGetItemAttr onGetItemAttr,
			Virtual_OnGetItemImage onGetItemImage,
			Virtual_OnGetItemColumnImage onGetItemColumnImage,
			Virtual_OnGetItemText onGetItemText);
		static extern (C) void wxListView_Select(IntPtr self, uint n, bool on);
		static extern (C) void wxListView_Focus(IntPtr self, uint index);
		static extern (C) uint wxListView_GetFocusedItem(IntPtr self);
		static extern (C) uint wxListView_GetNextSelected(IntPtr self, uint item);
		static extern (C) uint wxListView_GetFirstSelected(IntPtr self);
		static extern (C) bool wxListView_IsSelected(IntPtr self, uint index);
		static extern (C) void wxListView_SetColumnImage(IntPtr self, int col, int image);
		static extern (C) void wxListView_ClearColumnImage(IntPtr self, int col);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias ListView wxListView;
	public class ListView : ListCtrl
	{
		public this(IntPtr wxobj);
		public this();
		public this(Window parent);
		public this(Window parent, int id);
		public this(Window parent, int id, Point pos);
		public this(Window parent, int id, Point pos, Size size);
		public this(Window parent, int id, Point pos, Size size, int style);
		public this(Window parent, int id, Point pos, Size size, int style, Validator validator);
		public this(Window parent, int id, Point pos, Size size, int style, Validator validator, string name);
		public this(Window parent, Point pos);
		public this(Window parent, Point pos, Size size);
		public this(Window parent, Point pos, Size size, int style);
		public this(Window parent, Point pos, Size size, int style, Validator validator);
		public this(Window parent, Point pos, Size size, int style, Validator validator, string name);
		public override bool Create(Window parent, int id, Point pos, Size size, int style, Validator validator, string name);
		public void Select(int n);
		public void Select(int n, bool on);
		public void Focus(int index);
		public int FocusedItem() ;
		public int GetNextSelected(int item);
		public int FirstSelected();
		public bool IsSelected(int index);
		public void SetColumnImage(int col, int image);
		public void ClearColumnImage(int col);
	}
