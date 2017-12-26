module wx.Choice;
public import wx.common;
public import wx.Control;
public import wx.ClientData;
public import wx.IControlWithItems;
public import wx.ArrayString;

		//! \cond EXTERN
		static extern (C) IntPtr wxChoice_ctor();
		static extern (C) bool   wxChoice_Create(IntPtr self, IntPtr parent, int id, inout Point pos, inout Size size, int n, string* choices, int style, IntPtr validator, string name);
		static extern (C) void   wxChoice_dtor(IntPtr self);

		static extern (C) void   wxChoice_SetSelection(IntPtr self, int n);
		static extern (C) bool   wxChoice_SetStringSelection(IntPtr self, string s);
		static extern (C) IntPtr wxChoice_GetStringSelection(IntPtr self);

		static extern (C) void   wxChoice_SetColumns(IntPtr self, int n);
		static extern (C) int    wxChoice_GetColumns(IntPtr self);

		static extern (C) void   wxChoice_Command(IntPtr self, IntPtr evt);
		static extern (C) int    wxChoice_GetCount(IntPtr self);
		static extern (C) IntPtr wxChoice_GetString(IntPtr self, int n);
		static extern (C) int    wxChoice_GetSelection(IntPtr self);

		static extern (C) IntPtr wxChoice_GetClientData(IntPtr self, int n);
		static extern (C) void   wxChoice_SetClientData(IntPtr self, int n, IntPtr data);

		static extern (C) int    wxChoice_FindString(IntPtr self, string str);
		
		static extern (C) void   wxChoice_Delete(IntPtr self, int n);
		static extern (C) void   wxChoice_Clear(IntPtr self);

		static extern (C) int   wxChoice_Append(IntPtr self, string item);
		static extern (C) int   wxChoice_AppendData(IntPtr self, string item, IntPtr data);
		
		static extern (C)	void wxChoice_AppendString(IntPtr self, string item);
		
		static extern (C)	void wxChoice_AppendArrayString(IntPtr self, int n, string* strings);
		
		static extern (C)	int wxChoice_Insert(IntPtr self, string item, int pos);
		static extern (C)	int wxChoice_InsertClientData(IntPtr self, string item, int pos, IntPtr clientData);
		
		static extern (C)	IntPtr wxChoice_GetStrings(IntPtr self);
		
		static extern (C)	void wxChoice_SetClientObject(IntPtr self, int n, IntPtr clientData);
		static extern (C)	IntPtr wxChoice_GetClientObject(IntPtr self, int n);
		static extern (C)	bool wxChoice_HasClientObjectData(IntPtr self);
		static extern (C)	bool wxChoice_HasClientUntypedData(IntPtr self);
		
		static extern (C) void wxChoice_SetString(IntPtr self, int n, string text);
		
		static extern (C) void wxChoice_Select(IntPtr self, int n);
		
		static extern (C)	bool wxChoice_ShouldInheritColours(IntPtr self);
		
		static extern (C)	bool wxChoice_IsEmpty(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------
		
	alias Choice wxChoice;
	public class Choice : Control , IControlWithItems
	{
		public const string wxChoiceNameStr = "choice";
	
		public this(IntPtr wxobj) ;
		public this();
		public this(Window parent, int id, Point pos, Size size, string[] choices = null, int style = 0, Validator val = null,string name = wxChoiceNameStr);
		public static wxObject New(IntPtr wxobj);
		public this(Window parent, Point pos, Size size, string[] choices = null, int style = 0, Validator val = null,string name = wxChoiceNameStr);
		public bool Create(Window parent, int id, inout Point pos, inout Size size,
						   string[] choices, int style, Validator validator,
						   string name);
		public int Append(string item);
		public int Append(string item, ClientData clientData);
		public void AppendString(string item);
		public void Append(string[] strings);
		public int Insert(string item, int pos);
		public int Insert(string item, int pos, ClientData clientData);
		public string[] GetStrings();
		public void SetClientObject(int n, ClientData clientData);
		public ClientData GetClientObject(int n);
		public bool HasClientObjectData();
		public bool HasClientUntypedData();
		public int Selection() { return wxChoice_GetSelection(wxobj); }
		public void Selection(int value);
		public int GetSelection();
		public string StringSelection();
		public void StringSelection(string value) ;
		public int Columns() ;
		public void Columns(int value) ;
		public void Command(Event evt);
		public int Count();
		public string GetString(int n);
		public ClientData GetClientData(int n);
		public void SetClientData(int n, ClientData data);
		public int FindString(string str);
		public void Delete(int n);
		public void Clear();
		public void SetString(int n, string str);
		public void Select(int n);
		public override bool ShouldInheritColours();
		public bool Empty() ;
		public void Selected_Add(EventListener value) ;
		public void Selected_Remove(EventListener value) ;

	}
