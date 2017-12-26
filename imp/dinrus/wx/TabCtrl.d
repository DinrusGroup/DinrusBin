module wx.TabCtrl;

//! \cond VERSION
version(none) {
//! \endcond

public import wx.common;
public import wx.Event;
public import wx.Control;
public import wx.ImageList;
public import wx.wxString;

		//! \cond EXTERN
		static extern (C) IntPtr wxTabEvent_ctor(int commandType, int id, int nSel, int nOldSel);
		static extern (C) int    wxTabEvent_GetSelection(IntPtr self);
		static extern (C) void   wxTabEvent_SetSelection(IntPtr self, int nSel);
		static extern (C) int    wxTabEvent_GetOldSelection(IntPtr self);
		static extern (C) void   wxTabEvent_SetOldSelection(IntPtr self, int nOldSel);
		static extern (C) void wxTabEvent_Veto(IntPtr self);
		static extern (C) void wxTabEvent_Allow(IntPtr self);
		static extern (C) bool wxTabEvent_IsAllowed(IntPtr self);		
		//! \endcond

		//-----------------------------------------------------------------------------

	alias TabEvent wxTabEvent;
	public class TabEvent : Event
	{
		public this(IntPtr wxobj);
		public this(int commandType, int id, int nSel, int nOldSel);
		public int Selection();
		public void Selection(int value) ;
		public int OldSelection() ;
		public void OldSelection(int value) ;
		public void Veto();
		public void Allow();
		public bool Allowed();
		private static Event New(IntPtr obj);
		static this();
	}

	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxTabCtrl_ctor();
		static extern (C) IntPtr wxTabCtrl_ctor2(IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
		static extern (C) int wxTabCtrl_GetSelection(IntPtr self);
		static extern (C) int wxTabCtrl_GetCurFocus(IntPtr self);
		static extern (C) IntPtr wxTabCtrl_GetImageList(IntPtr self);
		static extern (C) int wxTabCtrl_GetItemCount(IntPtr self);
		static extern (C) bool wxTabCtrl_GetItemRect(IntPtr self, int item, out Rectangle rect);
		static extern (C) int wxTabCtrl_GetRowCount(IntPtr self);
		static extern (C) IntPtr wxTabCtrl_GetItemText(IntPtr self, int item);
		static extern (C) int wxTabCtrl_GetItemImage(IntPtr self, int item);
		static extern (C) IntPtr wxTabCtrl_GetItemData(IntPtr self, int item);
		static extern (C) int wxTabCtrl_SetSelection(IntPtr self, int item);
		static extern (C) void wxTabCtrl_SetImageList(IntPtr self, IntPtr imageList);
		static extern (C) bool wxTabCtrl_SetItemText(IntPtr self, int item, string text);
		static extern (C) bool wxTabCtrl_SetItemImage(IntPtr self, int item, int image);
		static extern (C) bool wxTabCtrl_SetItemData(IntPtr self, int item, IntPtr data);
		static extern (C) void wxTabCtrl_SetItemSize(IntPtr self, inout Size size);
		static extern (C) bool wxTabCtrl_Create(IntPtr self, IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
		static extern (C) void wxTabCtrl_SetPadding(IntPtr self, inout Size padding);
		static extern (C) bool wxTabCtrl_DeleteAllItems(IntPtr self);
		static extern (C) bool wxTabCtrl_DeleteItem(IntPtr self, int item);
		static extern (C) int wxTabCtrl_HitTest(IntPtr self, inout Point pt, out int flags);
		static extern (C) bool wxTabCtrl_InsertItem(IntPtr self, int item, string text, int imageId, IntPtr data);
		//! \endcond

	alias TabCtrl wxTabCtrl;
	public class TabCtrl : Control
	{
		//-----------------------------------------------------------------------------

		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent, int id, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style =0, string name = "tabCtrl");
		public static wxObject New(IntPtr wxobj);
		public this(Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style =0, string name = "tabCtrl");
		public bool Create(Window parent, int id, inout Point pos, inout Size size, int style, string name);
		public int Selection() ;
		public void Selection(int value);
		public int CurFocus() ;
		public wxImageList ImageList();
		public void ImageList(wxImageList value);
		public int ItemCount() ;
		public bool GetItemRect(int item, out Rectangle rect);
		public int RowCount();
		public string GetItemText(int item);
		public int GetItemImage(int item);
		public IntPtr GetItemData(int item);
		public bool SetItemText(int item, string text);
		public bool SetItemImage(int item, int image);
		public bool SetItemData(int item, IntPtr data);
		public void ItemSize(Size value) ;
		public void Padding(Size value) ;
		public bool DeleteAllItems();
		public bool DeleteItem(int item);
		public int HitTest(Point pt, out int flags);
		public bool InsertItem(int item, string text);
		public bool InsertItem(int item, string text, int imageId);
		public bool InsertItem(int item, string text, int imageId, IntPtr data);
		public void SelectionChange_Add(EventListener value);
		public void SelectionChange_Remove(EventListener value) ;
		public void SelectionChanging_Add(EventListener value);
		public void SelectionChanging_Remove(EventListener value) ;
	}

//! \cond VERSION
} // version(__WXMSW__)
//! \endcond
