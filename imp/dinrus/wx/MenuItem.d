module wx.MenuItem;
public import wx.common;
public import wx.Accelerator;
public import wx.Menu;
public import wx.Bitmap;
public import wx.EvtHandler;

		//! \cond EXTERN
		static extern (C) IntPtr wxMenuItem_GetMenu(IntPtr self);
		static extern (C) void   wxMenuItem_SetMenu(IntPtr self, IntPtr menu);
		static extern (C) void   wxMenuItem_SetId(IntPtr self, int id);
		static extern (C) int    wxMenuItem_GetId(IntPtr self);
		static extern (C) bool   wxMenuItem_IsSeparator(IntPtr self);
		static extern (C) void   wxMenuItem_SetText(IntPtr self, string str);
		static extern (C) IntPtr wxMenuItem_GetLabel(IntPtr self);
		static extern (C) IntPtr wxMenuItem_GetText(IntPtr self);
		static extern (C) IntPtr wxMenuItem_GetLabelFromText(IntPtr self, string text);
		static extern (C) int    wxMenuItem_GetKind(IntPtr self);
		static extern (C) void   wxMenuItem_SetCheckable(IntPtr self, bool checkable);
		static extern (C) bool   wxMenuItem_IsCheckable(IntPtr self);
		static extern (C) bool   wxMenuItem_IsSubMenu(IntPtr self);
		static extern (C) void   wxMenuItem_SetSubMenu(IntPtr self, IntPtr menu);
		static extern (C) IntPtr wxMenuItem_GetSubMenu(IntPtr self);
		static extern (C) void   wxMenuItem_Enable(IntPtr self, bool enable);
		static extern (C) bool   wxMenuItem_IsEnabled(IntPtr self);
		static extern (C) void   wxMenuItem_Check(IntPtr self, bool check);
		static extern (C) bool   wxMenuItem_IsChecked(IntPtr self);
		static extern (C) void   wxMenuItem_Toggle(IntPtr self);
		static extern (C) void   wxMenuItem_SetHelp(IntPtr self, string str);
		static extern (C) IntPtr wxMenuItem_GetHelp(IntPtr self);
		static extern (C) IntPtr wxMenuItem_GetAccel(IntPtr self);
		static extern (C) void   wxMenuItem_SetAccel(IntPtr self, IntPtr accel);
		static extern (C) void   wxMenuItem_SetName(IntPtr self, string str);
		static extern (C) IntPtr wxMenuItem_GetName(IntPtr self);
		static extern (C) IntPtr wxMenuItem_NewCheck(IntPtr parentMenu, int id, string text, string help, bool isCheckable, IntPtr subMenu);
		static extern (C) IntPtr wxMenuItem_New(IntPtr parentMenu, int id, string text, string help, int kind, IntPtr subMenu);
		//static extern (C) void   wxMenuItem_SetBitmap(IntPtr self, IntPtr bitmap);
		//static extern (C) IntPtr wxMenuItem_GetBitmap(IntPtr self);
		static extern (C) IntPtr wxMenuItem_ctor(IntPtr parentMenu, int id, string text, string help, int kind, IntPtr subMenu);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias MenuItem wxMenuItem;
	public class MenuItem : wxObject
	{
		public this(IntPtr wxobj);
		public  this(Menu parentMenu = null, int id =  wxID_SEPARATOR, string text = "", string help = "", ItemKind kind = ItemKind.wxITEM_NORMAL, Menu subMenu = null);
		public static wxObject New2(IntPtr ptr) ;
		public static MenuItem New(Menu parentMenu = null, int id = wxID_SEPARATOR, string text = "", string help = "", ItemKind kind=ItemKind.wxITEM_NORMAL, Menu subMenu = null);
		public Menu menu();
		public void menu(Menu value);
		public int ID();
		public void ID(int value);
		public bool IsSeparator();
		public void Text(string value);
		public string Text() ;
		public string Label();
		public string GetLabelFromText(string text);
		public ItemKind Kind();
		public void Checkable(bool value);
		public bool Checkable() ;
		public bool IsSubMenu() ;
		public void SubMenu(Menu value) ;
		public Menu SubMenu();
		public void Enabled(bool value);
		public bool Enabled();
		public void Checked(bool value) ;
		public bool Checked() ;
		public void Toggle();
		public void Help(string value);
		public string Help() ;
		public AcceleratorEntry Accel() ;
		public void Accel(AcceleratorEntry value) ;
		public void Name(string value) ;
		public string Name() ;
		//public void bitmap(Bitmap value);
		public void Click_Add(EventListener value) ;
		public void Click_Remove(EventListener value);
        public void Select_Add(EventListener value);
        public void Select_Remove(EventListener value);
	}

