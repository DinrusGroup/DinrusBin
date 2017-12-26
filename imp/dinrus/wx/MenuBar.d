module wx.MenuBar;
public import wx.common;
public import wx.EvtHandler;
public import wx.Menu;

		//! \cond EXTERN
		static extern (C) IntPtr wxMenuBar_ctor();
		static extern (C) IntPtr wxMenuBar_ctor2(uint style);
		static extern (C) bool   wxMenuBar_Append(IntPtr self, IntPtr menu, string title);
		static extern (C) void   wxMenuBar_Check(IntPtr self, int id, bool check);
		static extern (C) bool   wxMenuBar_IsChecked(IntPtr self, int id);
        	static extern (C) bool   wxMenuBar_Insert(IntPtr self, int pos, IntPtr menu, string title);
        	static extern (C) IntPtr wxMenuBar_FindItem(IntPtr self, int id, inout IntPtr menu);
		
		static extern (C) int    wxMenuBar_GetMenuCount(IntPtr self);
		static extern (C) IntPtr wxMenuBar_GetMenu(IntPtr self, int pos);
		
		static extern (C) IntPtr wxMenuBar_Replace(IntPtr self, int pos, IntPtr menu, string title);
		static extern (C) IntPtr wxMenuBar_Remove(IntPtr self, int pos);
		
		static extern (C) void   wxMenuBar_EnableTop(IntPtr self, int pos, bool enable);
		
		static extern (C) void   wxMenuBar_Enable(IntPtr self, int id, bool enable);
		
		static extern (C) int    wxMenuBar_FindMenu(IntPtr self, string title);
		static extern (C) int    wxMenuBar_FindMenuItem(IntPtr self, string menustring, string itemString);
		
		static extern (C) IntPtr wxMenuBar_GetHelpString(IntPtr self, int id);
		static extern (C) IntPtr wxMenuBar_GetLabel(IntPtr self, int id);
		static extern (C) IntPtr wxMenuBar_GetLabelTop(IntPtr self, int pos);
		
		static extern (C) bool   wxMenuBar_IsEnabled(IntPtr self, int id);
		
		static extern (C) void   wxMenuBar_Refresh(IntPtr self);
		
		static extern (C) void   wxMenuBar_SetHelpString(IntPtr self, int id, string helpstring);
		static extern (C) void   wxMenuBar_SetLabel(IntPtr self, int id, string label);
		static extern (C) void   wxMenuBar_SetLabelTop(IntPtr self, int pos, string label);
		//! \endcond

	alias MenuBar wxMenuBar;
	public class MenuBar : EvtHandler
	{
		//---------------------------------------------------------------------

		public this();
		public this(int style);
		public this(IntPtr wxobj);
		public static wxObject New(IntPtr wxobj);
		public bool Append(Menu menu, string title);
		public void Check(int id, bool check);
		public bool IsChecked(int id);
		public bool Insert(int pos, Menu menu, string title);
		public MenuItem FindItem(int id);
		public MenuItem FindItem(int id, inout Menu menu);
		public int MenuCount();
		public Menu GetMenu(int pos);
		public Menu Replace(int pos, Menu menu, string title);
		public Menu Remove(int pos);
		public void EnableTop(int pos, bool enable);
		public void Enable(int id, bool enable);
		public int FindMenu(string title);
		public int FindMenuItem(string menustring, string itemString);
		public string GetHelpString(int id);
		public string GetLabel(int id);
		public string GetLabelTop(int pos);
		public bool IsEnabled(int id);
		public void Refresh();
		public void SetHelpString(int id, string helpstring);
		public void SetLabel(int id, string label);
		public void SetLabelTop(int pos, string label);
	}
