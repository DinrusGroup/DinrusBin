
module wx.Listbook;
public import wx.common;
public import wx.Control;
public import wx.ImageList;

		//! \cond EXTERN
		static extern (C) IntPtr wxListbookEvent_ctor(int commandType, int id, int nSel, int nOldSel);
		static extern (C) int    wxListbookEvent_GetSelection(IntPtr self);
		static extern (C) void   wxListbookEvent_SetSelection(IntPtr self, int nSel);
		static extern (C) int    wxListbookEvent_GetOldSelection(IntPtr self);
		static extern (C) void   wxListbookEvent_SetOldSelection(IntPtr self, int nOldSel);
		static extern (C) void wxListbookEvent_Veto(IntPtr self);
		static extern (C) void wxListbookEvent_Allow(IntPtr self);
		static extern (C) bool wxListbookEvent_IsAllowed(IntPtr self);		
		//! \endcond

		//-----------------------------------------------------------------------------

	alias ListbookEvent wxListbookEvent;
	public class ListbookEvent : Event
	{
		public this(IntPtr wxobj);
		public this(EventType commandType, int id, int nSel, int nOldSel);
		static Event New(IntPtr ptr);
		public int Selection() ;
		public void Selection(int value) ;
		public int OldSelection();
		public void OldSelection(int value);
		public void Veto();
		public void Allow();
		public bool Allowed() ;
		static this()
		{
			wxEVT_COMMAND_LISTBOOK_PAGE_CHANGED = wxEvent_EVT_COMMAND_LISTBOOK_PAGE_CHANGED();
			wxEVT_COMMAND_LISTBOOK_PAGE_CHANGING = wxEvent_EVT_COMMAND_LISTBOOK_PAGE_CHANGING();

			AddEventType(wxEVT_COMMAND_LISTBOOK_PAGE_CHANGED,   &ListbookEvent.New);
			AddEventType(wxEVT_COMMAND_LISTBOOK_PAGE_CHANGING,  &ListbookEvent.New);
		}
	}
	
	//-----------------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxListbook_ctor();
		static extern (C) bool wxListbook_Create(IntPtr self, IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
		static extern (C) int wxListbook_GetSelection(IntPtr self);
		static extern (C) bool wxListbook_SetPageText(IntPtr self, int n, string strText);
		static extern (C) IntPtr wxListbook_GetPageText(IntPtr self, int n);
		static extern (C) int wxListbook_GetPageImage(IntPtr self, int n);
		static extern (C) bool wxListbook_SetPageImage(IntPtr self, int n, int imageId);
		static extern (C) void wxListbook_CalcSizeFromPage(IntPtr self, inout Size sizePage, out Size outSize);
		static extern (C) bool wxListbook_InsertPage(IntPtr self, int n, IntPtr page, string text, bool bSelect, int imageId);
		static extern (C) int wxListbook_SetSelection(IntPtr self, int n);
		static extern (C) void wxListbook_SetImageList(IntPtr self, IntPtr imageList);
		static extern (C) bool wxListbook_IsVertical(IntPtr self);
		static extern (C) int wxListbook_GetPageCount(IntPtr self);
		static extern (C) IntPtr wxListbook_GetPage(IntPtr self, int n);
		static extern (C) void wxListbook_AssignImageList(IntPtr self, IntPtr imageList);
		static extern (C) IntPtr wxListbook_GetImageList(IntPtr self);
		static extern (C) void wxListbook_SetPageSize(IntPtr self, inout Size size);
		static extern (C) bool wxListbook_DeletePage(IntPtr self, int nPage);
		static extern (C) bool wxListbook_RemovePage(IntPtr self, int nPage);
		static extern (C) bool wxListbook_DeleteAllPages(IntPtr self);
		static extern (C) bool wxListbook_AddPage(IntPtr self, IntPtr page, string text, bool bselect, int imageId);
		static extern (C) void wxListbook_AdvanceSelection(IntPtr self, bool forward);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias Listbook wxListbook;
	public class Listbook : Control
	{
		public const int wxLB_DEFAULT		= 0;
		public const int wxLB_TOP		= 0x1;
		public const int wxLB_BOTTOM		= 0x2;
		public const int wxLB_LEFT		= 0x4;
		public const int wxLB_RIGHT		= 0x8;
		public const int wxLB_ALIGN_MASK	= 0xf;
		
		//-----------------------------------------------------------------------------

		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent, int id, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, string name = "");
		public static wxObject New(IntPtr wxobj);
		public this(Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, string name = "");
		public int Selection();
		public void Selection(int value) ;
		public bool SetPageText(int n, string strText);
		public string GetPageText(int n);
		public int GetPageImage(int n);
		public bool SetPageImage(int n, int imageId);
		public Size CalcSizeFromPage(Size sizePage);		
		public bool InsertPage(int n, Window page, string text);
		public bool InsertPage(int n, Window page, string text, bool bSelect);
		public bool InsertPage(int n, Window page, string text, bool bSelect, int imageId);
		public void imageList(ImageList value) ;
		public ImageList imageList() ;
		public bool Vertical() ;
		public int PageCount() ;
		public Window GetPage(int n);
		public void AssignImageList(ImageList imageList);
		public void PageSize(Size value);
		public bool DeletePage(int nPage);
		public bool RemovePage(int nPage);
		public bool DeleteAllPages();
		public bool AddPage(Window page, string text, bool bSelect, int imageId);
		public void AdvanceSelection(bool forward);
		public void PageChange_Add(EventListener value);
		public void PageChange_Remove(EventListener value) ;
		public void PageChanging_Add(EventListener value);
		public void PageChanging_Remove(EventListener value);
	}
