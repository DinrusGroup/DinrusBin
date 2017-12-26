module wx.ListBox;
public import wx.common;
public import wx.Control;
public import wx.ClientData;

		//! \cond EXTERN
		static extern (C) IntPtr wxListBox_ctor();
		static extern (C) void   wxListBox_dtor(IntPtr self);
		static extern (C) void   wxListBox_Clear(IntPtr self);
		static extern (C) bool   wxListBox_Create(IntPtr self, IntPtr parent, int id, inout Point pos, inout Size size, int n, string* choices, uint style, IntPtr validator, string name);
		static extern (C) void   wxListBox_InsertText(IntPtr self, string item, int pos);
		static extern (C) void   wxListBox_InsertTextData(IntPtr self, string item, int pos, IntPtr data);
		static extern (C) void   wxListBox_InsertTextClientData(IntPtr self, string item, int pos, IntPtr clientData);
		static extern (C) void   wxListBox_InsertItems(IntPtr self, int nItems, string* items, int pos);
		static extern (C) void   wxListBox_Set(IntPtr self, int n, string* items, IntPtr clientData);
		static extern (C) void   wxListBox_SetSelection(IntPtr self, int n, bool select);
		static extern (C) void   wxListBox_Select(IntPtr self, int n);
		static extern (C) void   wxListBox_Deselect(IntPtr self, int n);
		static extern (C) void   wxListBox_DeselectAll(IntPtr self, int itemToLeaveSelected);
		static extern (C) bool   wxListBox_SetStringSelection(IntPtr self, string s, bool select);
		static extern (C) IntPtr wxListBox_GetSelections(IntPtr self);
		static extern (C) void   wxListBox_SetFirstItem(IntPtr self, int n);
		static extern (C) void   wxListBox_SetFirstItemText(IntPtr self, string s);
		static extern (C) bool   wxListBox_HasMultipleSelection(IntPtr self);
		static extern (C) bool   wxListBox_IsSorted(IntPtr self);
		static extern (C) void   wxListBox_Command(IntPtr self, IntPtr evt);
		static extern (C) bool   wxListBox_Selected(IntPtr self, int n);
		static extern (C) int    wxListBox_GetSelection(IntPtr self);
		static extern (C) IntPtr wxListBox_GetStringSelection(IntPtr self);
		static extern (C) void   wxListBox_SetSingleString(IntPtr self, int n, string s);
		static extern (C) IntPtr wxListBox_GetSingleString(IntPtr self, int n);
		static extern (C) void   wxListBox_Append(IntPtr self, string item);
		static extern (C) void   wxListBox_AppendClientData(IntPtr self, string item, IntPtr cliendData);
		static extern (C) void   wxListBox_Delete(IntPtr self, int n);
		static extern (C) int    wxListBox_GetCount(IntPtr self);
		//! \endcond
	
		//---------------------------------------------------------------------
	
	alias ListBox wxListBox;
	public class ListBox : Control
	{
		enum {
			wxLB_SORT             = 0x0010,
			wxLB_SINGLE           = 0x0020,
			wxLB_MULTIPLE         = 0x0040,
			wxLB_EXTENDED         = 0x0080,
			wxLB_OWNERDRAW        = 0x0100,
			wxLB_NEED_SB          = 0x0200,
			wxLB_ALWAYS_SB        = 0x0400,
			wxLB_HSCROLL          = wxHSCROLL,
			wxLB_INT_HEIGHT       = 0x0800,
		}
	
		public const string wxListBoxNameStr = "listBox";
		//---------------------------------------------------------------------
		
		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent, int id, Point pos = wxDefaultPosition, Size size = wxDefaultSize, 
			string[] choices = null, int style = 0, Validator validator =null, string name = wxListBoxNameStr);
		public static wxObject New(IntPtr wxobj) ;
		public this(Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, 
			string[] choices = null, int style = 0, Validator validator = null, string name = wxListBoxNameStr);
		public bool Create(Window parent, int id, inout Point pos, inout Size size, int n,
				string[] choices, int style, Validator validator, string name);
		public int Selection() ;
		public void Selection(int value) ;
		public string StringSelection() ;
		public void StringSelection(string value) ;
		public void SetSelection(int n, bool select);
		public void SetSelection(string item, bool select);
		public void Clear();
		public string GetString(int n);
		public void SetString(int n, string str);
		public void Append(string item);
		public void Append(string item, ClientData data);
		public void Delete(int n);
		public void Insert(string item, int pos);
		public void Insert(string item, int pos, ClientData data);	
		//public void Insert(string item, int pos, ClientData data);
		public void InsertItems(string[] items, int pos);
		public void Set(string[] items, ClientData data);
		public void Set(string[] items);
		public bool Selected(int n);
		public bool Sorted();
		public bool HasMultipleSelection();
		public void Deselect(int n);
		public void DeselectAll(int itemToLeaveSelected);
		public int[] Selections();
		public void SetFirstItem(int n);
		public void SetFirstItem(string s);
		public void Command(Event evt);
		public int Count() ;
		public void Select_Add(EventListener value);
		public void Select_Remove(EventListener value) ;	
		public void DoubleClick_Add(EventListener value) ;
		public void DoubleClick_Remove(EventListener value);
	}
	
	//---------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxCheckListBox_ctor1();
		static extern (C) IntPtr wxCheckListBox_ctor2(IntPtr parent, 
			int id,
			inout Point pos,
			inout Size size,
			int nStrings,
			string* choices,
			uint style,
			IntPtr validator,
			string name);
		static extern (C) bool wxCheckListBox_IsChecked(IntPtr self, int index);
		static extern (C) void wxCheckListBox_Check(IntPtr self, int index, bool check);
		static extern (C) int wxCheckListBox_GetItemHeight(IntPtr self);
		//! \endcond
				
	alias CheckListBox wxCheckListBox;
	public class CheckListBox : ListBox
	{
		const string wxListBoxNameStr = "listBox";

		//---------------------------------------------------------------------
	
		public this(IntPtr wxobj);
		public this();
		public this(Window parent, int id, Point pos = wxDefaultPosition, Size size = wxDefaultSize, string[] choices = null, int style = 0, Validator validator = null, string name = wxListBoxNameStr);
		public this(Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, string[] choices = null, int style = 0, Validator validator = null, string name = wxListBoxNameStr);
		public bool IsChecked(int index);
		public void Check(int index);
		public void Check(int index, bool check);
		version(__WXMAC__) {} else
		public int ItemHeight();
		public void Checked_Add(EventListener value);
		public void Checked_Remove(EventListener value);
	}
