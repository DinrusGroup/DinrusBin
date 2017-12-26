
module wx.Accelerator;
public import wx.common;
public import wx.MenuItem;

		//! \cond EXTERN
		static extern (C) IntPtr wxAcceleratorEntry_ctor(int flags, int keyCode, int cmd, IntPtr item);
		static extern (C) void   wxAcceleratorEntry_dtor(IntPtr self);
		static extern (C) void   wxAcceleratorEntry_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
		static extern (C) void   wxAcceleratorEntry_Set(IntPtr self, int flags, int keyCode, int cmd, IntPtr item);
		static extern (C) void   wxAcceleratorEntry_SetMenuItem(IntPtr self, IntPtr item);
		static extern (C) int    wxAcceleratorEntry_GetFlags(IntPtr self);
		static extern (C) int    wxAcceleratorEntry_GetKeyCode(IntPtr self);
		static extern (C) int    wxAcceleratorEntry_GetCommand(IntPtr self);
		static extern (C) IntPtr wxAcceleratorEntry_GetMenuItem(IntPtr self);
		
		static extern (C) IntPtr wxAcceleratorEntry_GetAccelFromString(string label);
		//! \endcond
		
		//-----------------------------------------------------------------------------

	alias AcceleratorEntry wxAcceleratorEntry;
	public class AcceleratorEntry : wxObject
	{
		public const int wxACCEL_NORMAL	= 0x0000;
		public const int wxACCEL_ALT	= 0x0001;
		public const int wxACCEL_CTRL	= 0x0002;
		public const int wxACCEL_SHIFT	= 0x0004;
		
		//-----------------------------------------------------------------------------
		
		public this(IntPtr wxobj);			
		private this(IntPtr wxobj, bool memOwn);			
		public this();		
		public this(int flags);
		public this(int flags, int keyCode);
		public this(int flags, int keyCode, int cmd);
		public this(int flags, int keyCode, int cmd, MenuItem item);
		public void Set(int flags, int keyCode, int cmd);		
		public void Set(int flags, int keyCode, int cmd, MenuItem item);
		public MenuItem menuItem() ;
		public int Flags() ;
		public int KeyCode() ;
		public int Command() ;
		override protected void dtor();
		public static AcceleratorEntry GetAccelFromString(string label);
		public static wxObject New(IntPtr ptr) ;
	}
	
	//-----------------------------------------------------------------------------
	
		//! \cond EXTERN
		static extern (C) IntPtr wxAcceleratorTable_ctor();
		static extern (C) bool   wxAcceleratorTable_Ok(IntPtr self);
		//static extern (C) void   wxAcceleratorTable_Add(IntPtr self, IntPtr entry);
		//static extern (C) void   wxAcceleratorTable_Remove(IntPtr self, IntPtr entry);
		//static extern (C) IntPtr wxAcceleratorTable_GetMenuItem(IntPtr self, IntPtr evt);
		//static extern (C) int    wxAcceleratorTable_GetCommand(IntPtr self, IntPtr evt);
		//static extern (C) IntPtr wxAcceleratorTable_GetEntry(IntPtr self, IntPtr evt);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias AcceleratorTable wxAcceleratorTable;
	public class AcceleratorTable : wxObject
	{
		public this(IntPtr wxobj);
		public this();
		//public void Add(AcceleratorEntry entry);
		//public void Remove(AcceleratorEntry entry);
		//public MenuItem GetMenuItem(KeyEvent evt);
		//public AcceleratorEntry GetEntry(KeyEvent evt);
		//public int GetCommand(KeyEvent evt);
		public bool Ok() ;

		public static wxObject New(IntPtr ptr) ;
	}

