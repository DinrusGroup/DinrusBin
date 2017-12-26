module wx.App;
public import wx.common;
public import wx.EvtHandler;
public import wx.Window;
public import wx.GdiCommon;
public import wx.Clipboard;
public import wx.FontMisc;


		//! \cond EXTERN
	extern (C) {
	alias bool function(App o) Virtual_OnInit;
	alias int  function(App o) Virtual_OnRun;
	alias int  function(App o) Virtual_OnExit;
	alias bool function(App o,inout int argc,char** argv) Virtual_Initialize;
	}
	
	static extern (C) IntPtr wxApp_ctor();
	static extern (C) void wxApp_RegisterVirtual(IntPtr self, App o, Virtual_OnInit onInit, Virtual_OnRun onRun, Virtual_OnExit onExit, Virtual_Initialize initalize);
	static extern (C) bool wxApp_Initialize(IntPtr self,inout int argc,char** argv);
	static extern (C) bool wxApp_OnInit(IntPtr self);
	static extern (C) bool wxApp_OnRun(IntPtr self);
	static extern (C) int wxApp_OnExit(IntPtr self);
	
        static extern (C) void   wxApp_Run(int argc, char** argv);

        static extern (C) void   wxApp_SetVendorName(IntPtr self, string name);
        static extern (C) IntPtr wxApp_GetVendorName(IntPtr self);

        static extern (C) void   wxApp_SetAppName(IntPtr self, string name);
        static extern (C) IntPtr wxApp_GetAppName(IntPtr self);

        static extern (C) void   wxApp_SetTopWindow(IntPtr self, IntPtr window);
        static extern (C) IntPtr wxApp_GetTopWindow(IntPtr self);

        static extern (C) bool   wxApp_SafeYield(IntPtr win, bool onlyIfNeeded);
        static extern (C) bool   wxApp_Yield(IntPtr self, bool onlyIfNeeded);
        static extern (C) void   wxApp_WakeUpIdle();
        static extern (C) void   wxApp_ExitMainLoop(IntPtr self);
		//! \endcond

        //---------------------------------------------------------------------

    alias App wxApp;
	/// The wxApp class represents the application itself.
	/**
	  * It is used to:
	  * - set and get application-wide properties;
	  * - implement the windowing system message or event loop;
	  * - initiate application processing via wxApp::OnInit;
	  * - allow default processing of events not handled by other objects in the application.
	  **/
    public abstract class App : EvtHandler
    {
        
        private static App app;
	private Object m_caughtException=null;
	public void catchException(Object e) ;
        protected this() ;
	extern (C) private static bool staticInitialize(App o,inout int argc,char** argv);
 	extern (C) private static bool staticOnInit(App o);
	extern (C) private static int  staticOnRun(App o);
	extern (C) private static int  staticOnExit(App o);
	private bool Initialize(inout int argc,char** argv);
	public /+virtual+/ bool OnInit();	
	public /+virtual+/ int OnRun();
	public /+virtual+/ int OnExit();
        public static App GetApp() ;
        public void Run();
        public void Run(char[][] args);
        public string VendorName();
        public void VendorName(string name) ;
        public string AppName();
        public void AppName(string name);
        public Window TopWindow();
        public void TopWindow(Window window) ;
        public static bool SafeYield() ;
        public static bool SafeYield(Window win) ;
        public static bool SafeYield(Window win, bool onlyIfNeeded) ;
        public bool Yield() ;
        public bool Yield(bool onlyIfNeeded) ;
        public static void WakeUpIdle();
		public void ExitMainLoop();
    }
