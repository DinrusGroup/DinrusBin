module wx.ComboBox;
public import wx.common;
public import wx.Control;
public import wx.ClientData;

		
		//! \cond EXTERN
		static extern (C) IntPtr wxComboBox_ctor();
		static extern (C) bool   wxComboBox_Create(IntPtr self, IntPtr window, int id, string value, inout Point pos, inout Size size, int n, string* choices, uint style, IntPtr validator, string name);
		
		static extern (C) void   wxComboBox_Append(IntPtr self, string item);
		static extern (C) void   wxComboBox_AppendData(IntPtr self, string item, IntPtr data);
		
		static extern (C) void   wxComboBox_Clear(IntPtr self);
		static extern (C) void   wxComboBox_Delete(IntPtr self, int n);
		
		static extern (C) int    wxComboBox_FindString(IntPtr self, string str);
		
		static extern (C) int    wxComboBox_GetCount(IntPtr self);
		static extern (C) int    wxComboBox_GetSelection(IntPtr self);
		static extern (C) IntPtr wxComboBox_GetString(IntPtr self, int n);
		//static extern (C) void   wxComboBox_SetString(IntPtr self, int n, string text);
		
		static extern (C) IntPtr wxComboBox_GetValue(IntPtr self);
		static extern (C) void   wxComboBox_SetValue(IntPtr self, string text);
		
		static extern (C) IntPtr wxComboBox_GetStringSelection(IntPtr self);
		static extern (C) void   wxComboBox_SetStringSelection(IntPtr self, string value);
		
		static extern (C) IntPtr wxComboBox_GetClientData(IntPtr self, int n);
		static extern (C) void   wxComboBox_SetClientData(IntPtr self, int n, IntPtr data);
		
		static extern (C) void   wxComboBox_Copy(IntPtr self);
		static extern (C) void   wxComboBox_Cut(IntPtr self);
		static extern (C) void   wxComboBox_Paste(IntPtr self);
		
		static extern (C) void   wxComboBox_SetInsertionPoint(IntPtr self, uint pos);
		static extern (C) uint   wxComboBox_GetInsertionPoint(IntPtr self);
		static extern (C) void   wxComboBox_SetInsertionPointEnd(IntPtr self);
		static extern (C) uint   wxComboBox_GetLastPosition(IntPtr self);
		
		static extern (C) void   wxComboBox_Replace(IntPtr self, uint from, uint to, string value);
		static extern (C) void   wxComboBox_SetSelectionSingle(IntPtr self, int n);
		static extern (C) void   wxComboBox_SetSelectionMult(IntPtr self, uint from, uint to);
		static extern (C) void   wxComboBox_SetEditable(IntPtr self, bool editable);
		static extern (C) void   wxComboBox_Remove(IntPtr self, uint from, uint to);
		
		static extern (C) void wxComboBox_SetSelection(IntPtr self, int n);
		
		static extern (C) void wxComboBox_Select(IntPtr self, int n);
		//! \endcond
		
		//---------------------------------------------------------------------
	
	alias ComboBox wxComboBox;
	public class ComboBox : Control
	{
		public const int wxCB_SIMPLE           = 0x0004;
		public const int wxCB_SORT             = 0x0008;
		public const int wxCB_READONLY         = 0x0010;
		public const int wxCB_DROPDOWN         = 0x0020;
		
		public const string wxComboBoxNameStr = "comboBox";
		//---------------------------------------------------------------------

		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent, int id, string value="", Point pos = wxDefaultPosition, Size size = wxDefaultSize, string[] choices = null, int style = 0, Validator val = null, string name = wxComboBoxNameStr);		
		public static wxObject New(IntPtr wxobj);
		public this(Window parent);
		public this(Window parent, string value="", Point pos = wxDefaultPosition, Size size = wxDefaultSize, string[] choices = null, int style = 0, Validator val = null, string name = wxComboBoxNameStr);
		public bool Create(Window parent, int id, string value, 
				Point pos, Size size,
				string[] choices, int style, Validator validator,
				string name);
		public int Selection();
		public void Selection(int value) ;
		public string StringSelection() ;
		public void StringSelection(string value);
		public int Count();
		public string GetString(int n);
		public ClientData GetClientData(int n);
		public void SetClientData(int n, ClientData data);
		public int FindString(string str);
		public void Delete(int n);
		public void Clear();
		public void Append(string item);
		public void Append(string item, ClientData data);
		public void Copy();
		public void Cut();
		public void Paste();
		public int InsertionPoint();
		public void InsertionPoint(int value);
		public void SetInsertionPointEnd();
		public int GetLastPosition();
		public void Replace(int from, int to, string value);
		public void SetSelection(int from, int to);
		public void SetSelection(int n);
		public void Editable(bool value) ;
		public void Remove(int from, int to);
		public string Value() ;
		public void Value(string value) ;
		public void Select(int n);
		public void Selected_Add(EventListener value) ;
		public void Selected_Remove(EventListener value) ;
	}

