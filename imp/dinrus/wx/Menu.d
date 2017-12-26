
module wx.Menu;
public import wx.common;
public import wx.Defs;
public import wx.Window;
public import wx.MenuItem;
public import wx.MenuBar;

		//! \cond EXTERN
		static extern (C) IntPtr wxMenuBase_ctor1(string titel, uint style);
		static extern (C) IntPtr wxMenuBase_ctor2(uint style);
		
		static extern (C) IntPtr wxMenuBase_Append(IntPtr self, int id, string item, string help, ItemKind kind);
		static extern (C) IntPtr wxMenuBase_AppendSubMenu(IntPtr self, int id, string item, IntPtr subMenu, string help);
		static extern (C) IntPtr wxMenuBase_AppendItem(IntPtr self, IntPtr item);
		static extern (C) IntPtr wxMenuBase_AppendSeparator(IntPtr self);
		static extern (C) IntPtr wxMenuBase_AppendCheckItem(IntPtr self, int itemid, string text, string help);
		static extern (C) IntPtr wxMenuBase_AppendRadioItem(IntPtr self, int itemid, string text, string help);
		static extern (C) int    wxMenuBase_GetMenuItemCount(IntPtr self);
		static extern (C) IntPtr wxMenuBase_GetMenuItem(IntPtr self, int index);
		static extern (C) void   wxMenuBase_Break(IntPtr self);
		
		static extern (C) IntPtr wxMenuBase_Insert(IntPtr self, int pos, IntPtr item);
		static extern (C) IntPtr wxMenuBase_Insert2(IntPtr self, int pos, int itemid, string text, string help, ItemKind kind);
		static extern (C) IntPtr wxMenuBase_InsertSeparator(IntPtr self, int pos);
		static extern (C) IntPtr wxMenuBase_InsertCheckItem(IntPtr self, int pos, int itemid, string text, string help);
		static extern (C) IntPtr wxMenuBase_InsertRadioItem(IntPtr self, int pos, int itemid, string text, string help);
		static extern (C) IntPtr wxMenuBase_InsertSubMenu(IntPtr self, int pos, int itemid, string text, IntPtr submenu, string help);
		
		static extern (C) IntPtr wxMenuBase_Prepend(IntPtr self, IntPtr item);
		static extern (C) IntPtr wxMenuBase_Prepend2(IntPtr self, int itemid, string text, string help, ItemKind kind);
		static extern (C) IntPtr wxMenuBase_PrependSeparator(IntPtr self);
		static extern (C) IntPtr wxMenuBase_PrependCheckItem(IntPtr self, int itemid, string text, string help);
		static extern (C) IntPtr wxMenuBase_PrependRadioItem(IntPtr self, int itemid, string text, string help);
		static extern (C) IntPtr wxMenuBase_PrependSubMenu(IntPtr self, int itemid, string text, IntPtr submenu, string help);
		
		static extern (C) IntPtr wxMenuBase_Remove(IntPtr self, int itemid);
		static extern (C) IntPtr wxMenuBase_Remove2(IntPtr self, IntPtr item);
		
		static extern (C) bool   wxMenuBase_Delete(IntPtr self, int itemid);
		static extern (C) bool   wxMenuBase_Delete2(IntPtr self, IntPtr item);
		
		static extern (C) bool   wxMenuBase_Destroy(IntPtr self, int itemid);
		static extern (C) bool   wxMenuBase_Destroy2(IntPtr self, IntPtr item);
		
		static extern (C) int    wxMenuBase_FindItem(IntPtr self, string item);
		static extern (C) IntPtr wxMenuBase_FindItem2(IntPtr self, int itemid, inout IntPtr menu); 
		static extern (C) IntPtr wxMenuBase_FindItemByPosition(IntPtr self, int position);
		
		static extern (C) void   wxMenuBase_Enable(IntPtr self, int itemid, bool enable);
		static extern (C) bool   wxMenuBase_IsEnabled(IntPtr self, int itemid);
		
		static extern (C) void   wxMenuBase_Check(IntPtr self, int id, bool check);
		static extern (C) bool   wxMenuBase_IsChecked(IntPtr self, int itemid);
		
		static extern (C) void   wxMenuBase_SetLabel(IntPtr self, int itemid, string label);
		static extern (C) IntPtr wxMenuBase_GetLabel(IntPtr self, int itemid);
		
		static extern (C) void   wxMenuBase_SetHelpString(IntPtr self, int itemid, string helpString);
		static extern (C) IntPtr wxMenuBase_GetHelpString(IntPtr self, int itemid);		
		
		static extern (C) void   wxMenuBase_SetTitle(IntPtr self, string title);
		static extern (C) IntPtr wxMenuBase_GetTitle(IntPtr self);		
		
		static extern (C) void   wxMenuBase_SetInvokingWindow(IntPtr self, IntPtr win);
		static extern (C) IntPtr wxMenuBase_GetInvokingWindow(IntPtr self);
		
		static extern (C) uint   wxMenuBase_GetStyle(IntPtr self);
		
		static extern (C) void   wxMenuBase_SetEventHandler(IntPtr self, IntPtr handler);
		static extern (C) IntPtr wxMenuBase_GetEventHandler(IntPtr self);
		
		static extern (C) void   wxMenuBase_UpdateUI(IntPtr self, IntPtr source);
		
		static extern (C) IntPtr wxMenuBase_GetMenuBar(IntPtr self);
		
		static extern (C) bool   wxMenuBase_IsAttached(IntPtr self);
		
		static extern (C) void   wxMenuBase_SetParent(IntPtr self, IntPtr parent);
		static extern (C) IntPtr wxMenuBase_GetParent(IntPtr self);
		
		static extern (C) IntPtr wxMenuBase_FindChildItem(IntPtr self, int itemid, out int pos);
		static extern (C) IntPtr wxMenuBase_FindChildItem2(IntPtr self, int itemid);
		static extern (C) bool   wxMenuBase_SendEvent(IntPtr self, int itemid, int xchecked);
		//! \endcond
	
	alias MenuBase wxMenuBase;
	public class MenuBase : EvtHandler
	{
		public this(IntPtr wxobj);
		public this(int style = 0);
		public this(string titel, int style = 0);
		public MenuItem Append(int id, string item);
		public MenuItem Append(int id, string item, string help);
		public MenuItem Append(int id, string item, string help, ItemKind kind);
		public MenuItem Append(int id, string item, Menu subMenu);
		public MenuItem Append(int id, string item, Menu subMenu, string help);
		public MenuItem Append(MenuItem item) ;
		public MenuItem AppendCheckItem(int id, string item);
		public MenuItem AppendCheckItem(int id, string item, string help);
		public MenuItem AppendSeparator();
		public MenuItem AppendRadioItem(int itemid, string text);
		public MenuItem AppendRadioItem(int itemid, string text, string help);
		public void Check(int id, bool check);
		public int GetMenuItemCount();
		public MenuItem GetMenuItem(int index);
		public /+virtual+/ void Break();
		public MenuItem Insert(int pos, MenuItem item);
		public MenuItem Insert(int pos, int itemid, string text);
		public MenuItem Insert(int pos, int itemid, string text, string help);
		public MenuItem Insert(int pos, int itemid, string text, string help, ItemKind kind);
		public MenuItem InsertSeparator(int pos);
		public MenuItem InsertCheckItem(int pos, int itemid, string text);
		public MenuItem InsertCheckItem(int pos, int itemid, string text, string help);
		public MenuItem InsertRadioItem(int pos, int itemid, string text);
		public MenuItem InsertRadioItem(int pos, int itemid, string text, string help);
		public MenuItem Insert(int pos, int itemid, string text, Menu submenu);
		public MenuItem Insert(int pos, int itemid, string text, Menu submenu, string help);
		public MenuItem Prepend(MenuItem item);
		public MenuItem Prepend(int itemid, string text);
		public MenuItem Prepend(int itemid, string text, string help);
		public MenuItem Prepend(int itemid, string text, string help, ItemKind kind);
		public MenuItem PrependSeparator();
		public MenuItem PrependCheckItem(int itemid, string text);
		public MenuItem PrependCheckItem(int itemid, string text, string help);
		public MenuItem PrependRadioItem(int itemid, string text);
		public MenuItem PrependRadioItem(int itemid, string text, string help);
		public MenuItem Prepend(int itemid, string text, Menu submenu);
		public MenuItem Prepend(int itemid, string text, Menu submenu, string help);
		public MenuItem Remove(int itemid);
		public MenuItem Remove(MenuItem item);
		public bool Delete(int itemid);
		public bool Delete(MenuItem item);
		public bool Destroy(int itemid);
		public bool Destroy(MenuItem item);
		public /+virtual+/ int FindItem(string item);
		public MenuItem FindItem(int itemid);
		public MenuItem FindItem(int itemid, inout Menu menu);
		public MenuItem FindItemByPosition(int position);
		public void Enable(int itemid, bool enable);
		public bool IsEnabled(int itemid);
		public bool IsChecked(int itemid);
		public void SetLabel(int itemid, string label);
		public string GetLabel(int itemid);
		public void SetHelpString(int itemid, string helpString);
		public string GetHelpString(int itemid);
		public string Title() ;
		public void Title(string value) ;
		public EvtHandler EventHandler() ;
		public void EventHandler(EvtHandler value);
		public Window InvokingWindow() ;
		public void InvokingWindow(Window value);
		public int Style();
		public void UpdateUI();
		public void UpdateUI(EvtHandler source);
		public MenuBar menuBar();
		public bool Attached();
		public Menu Parent();
		public void Parent(Menu value) ;
		public MenuItem FindChildItem(int itemid);
		public MenuItem FindChildItem(int itemid, out int pos);
		public bool SendEvent(int itemid);
		public bool SendEvent(int itemid, int xchecked);
	}
	
	//---------------------------------------------------------------------
	// helper struct, stores added EventListeners...
	
	alias MenuListener wxMenuListener;
	public class MenuListener
	{
		public EventListener listener;
		public wxObject owner;
		public int id;
		
		public this( int id, EventListener listener, wxObject owner );
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxMenu_ctor(string titel, uint style);
		static extern (C) IntPtr wxMenu_ctor2(uint style);
		//! \endcond
		
		//---------------------------------------------------------------------
		
	alias Menu wxMenu;
	public class Menu : MenuBase
	{
		public MenuListener[] eventListeners;

		// InvokingWindow does not work on Windows, so we 
		// need this...
		private Window parent = null;

		// if events were connected with Frame.MenuBar or Window.PopupMenu
		// that means with ConnectEvents(), we have a Invoking Window and can add 
		// the event directly to the EventHandler
		private bool eventsconnected = false; 
		
		//---------------------------------------------------------------------
		 
		public this();
		public this(int style);
		public this(string titel);
		public this(string titel, int style);
		public this(IntPtr wxobj);
		public static wxObject New(IntPtr wxobj);
		public void AddEvent(int inId, EventListener el, wxObject owner);
		public void ConnectEvents(Window parent);
		public MenuItem AppendWL(int id, string item, EventListener listener);
		public MenuItem AppendWL(int id, string item, string help, EventListener listener);
		public MenuItem AppendWL(int id, string item, string help, ItemKind kind, EventListener listener);
		public MenuItem AppendWL(int id, string item, Menu subMenu, EventListener listener);
		public MenuItem AppendWL(int id, string item, Menu subMenu, string help, EventListener listener);
		public MenuItem AppendWL(MenuItem item, EventListener listener) ;
	}
