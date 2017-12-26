module wx.Notebook;
public import wx.common;
public import wx.Event;
public import wx.Control;
public import wx.ImageList;

		//! \cond EXTERN
		static extern (C) IntPtr wxNotebookEvent_ctor(int commandType, int id, int nSel, int nOldSel);
		static extern (C) int    wxNotebookEvent_GetSelection(IntPtr self);
		static extern (C) void   wxNotebookEvent_SetSelection(IntPtr self, int nSel);
		static extern (C) int    wxNotebookEvent_GetOldSelection(IntPtr self);
		static extern (C) void   wxNotebookEvent_SetOldSelection(IntPtr self, int nOldSel);
		static extern (C) void wxNotebookEvent_Veto(IntPtr self);
		static extern (C) void wxNotebookEvent_Allow(IntPtr self);
		static extern (C) bool wxNotebookEvent_IsAllowed(IntPtr self);		
		//! \endcond

		//-----------------------------------------------------------------------------

	alias NotebookEvent wxNotebookEvent;
	public class NotebookEvent : Event
	{
		public this(IntPtr wxobj);
		public this(int commandType, int id, int nSel, int nOldSel);
		public int Selection();
		public void Selection(int value);
		public int OldSelection();
		public void OldSelection(int value);
		public void Veto();
		public void Allow();
		public bool Allowed();
		private static Event New(IntPtr obj) ;
		static this()
		{
			wxEVT_COMMAND_NOTEBOOK_PAGE_CHANGED = wxEvent_EVT_COMMAND_NOTEBOOK_PAGE_CHANGED();
			wxEVT_COMMAND_NOTEBOOK_PAGE_CHANGING = wxEvent_EVT_COMMAND_NOTEBOOK_PAGE_CHANGING();

			AddEventType(wxEVT_COMMAND_NOTEBOOK_PAGE_CHANGED,   &NotebookEvent.New);
			AddEventType(wxEVT_COMMAND_NOTEBOOK_PAGE_CHANGING,  &NotebookEvent.New);
		}
	}

		//! \cond EXTERN
		static extern (C) IntPtr wxNotebook_ctor();
		static extern (C) bool   wxNotebook_AddPage(IntPtr self, IntPtr page, string text, bool select, int imageId);
		static extern (C) bool   wxNotebook_Create(IntPtr self, IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
		static extern (C) int    wxNotebook_GetPageCount(IntPtr self);
		static extern (C) IntPtr wxNotebook_GetPage(IntPtr self, int nPage);
		static extern (C) int    wxNotebook_GetSelection(IntPtr self);
		static extern (C) bool   wxNotebook_SetPageText(IntPtr self, int nPage, string strText);
		static extern (C) IntPtr wxNotebook_GetPageText(IntPtr self, int nPage);
		static extern (C) void   wxNotebook_SetImageList(IntPtr self, IntPtr imageList);
		static extern (C) void   wxNotebook_AssignImageList(IntPtr self, IntPtr imageList);
		static extern (C) IntPtr wxNotebook_GetImageList(IntPtr self);
		static extern (C) int    wxNotebook_GetPageImage(IntPtr self, int nPage);
		static extern (C) bool   wxNotebook_SetPageImage(IntPtr self, int nPage, int nImage);
		static extern (C) int    wxNotebook_GetRowCount(IntPtr self);
		static extern (C) void   wxNotebook_SetPageSize(IntPtr self, inout Size size);
		static extern (C) void   wxNotebook_SetPadding(IntPtr self, inout Size padding);
		static extern (C) void   wxNotebook_SetTabSize(IntPtr self, inout Size sz);
		static extern (C) bool   wxNotebook_DeletePage(IntPtr self, int nPage);
		static extern (C) bool   wxNotebook_RemovePage(IntPtr self, int nPage);
		static extern (C) bool   wxNotebook_DeleteAllPages(IntPtr self);
		static extern (C) bool   wxNotebook_InsertPage(IntPtr self, int nPage, IntPtr pPage, string strText, bool bSelect, int imageId);
		static extern (C) int    wxNotebook_SetSelection(IntPtr self, int nPage);
		static extern (C) void   wxNotebook_AdvanceSelection(IntPtr self, bool forward);
		//! \endcond

		//---------------------------------------------------------------------
		
	alias Notebook wxNotebook;
	public class Notebook : Control
	{
		public const int wxNB_FIXEDWIDTH       = 0x0010;
		public const int wxNB_TOP              = 0x0000;
		public const int wxNB_LEFT             = 0x0020;
		public const int wxNB_RIGHT            = 0x0040;
		public const int wxNB_BOTTOM           = 0x0080;
		public const int wxNB_MULTILINE        = 0x0100;
	
		public const string wxNOTEBOOK_NAME = "notebook";
		//-----------------------------------------------------------------------------

		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent, int id, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, string name = wxNOTEBOOK_NAME);
		public static wxObject New(IntPtr wxobj);
		public this(Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, string name = wxNOTEBOOK_NAME);
		public bool AddPage(Window page, string text);
		public bool AddPage(Window page, string text, bool select);
		public bool AddPage(Window page, string text, bool select, int imageId);
		public void Images(ImageList value);
		public ImageList Images() ;
		public int PageCount() ;
		public Window GetPage(int page);
		public int Selection() ;
		public void Selection(int value) ;
		public void AdvanceSelection(bool forward);
		public bool SetPageText(int page, string text);
		public string GetPageText(int page);
		public void AssignImageList(ImageList imageList);
		public int GetPageImage(int page);
		public bool SetPageImage(int page, int image);
		public int RowCount() ;
		public void PageSize(Size value) ;
		public void Padding(Size value) ;
		public void TabSize(Size value);
		public bool DeletePage(int page);
		public bool RemovePage(int page);
		public bool DeleteAllPages();
		public bool InsertPage(int page, Window window, string text,
							   bool select, int image);
		public void PageChange_Add(EventListener value) ;
		public void PageChange_Remove(EventListener value) ;
		public void PageChanging_Add(EventListener value);
		public void PageChanging_Remove(EventListener value) ;
	}
