module wx.SplashScreen;
public import wx.common;
public import wx.Frame;

		//! \cond EXTERN
        static extern (C) IntPtr wxSplashScreen_ctor(IntPtr bitmap, uint splashStyle, int milliseconds, IntPtr parent, int id, inout Point pos, inout Size size, uint style);
        static extern (C) int    wxSplashScreen_GetSplashStyle(IntPtr self);
        static extern (C) IntPtr wxSplashScreen_GetSplashWindow(IntPtr self);
        static extern (C) int    wxSplashScreen_GetTimeout(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias SplashScreen wxSplashScreen;
    public class SplashScreen : Frame
    {
	enum {
        	wxSPLASH_CENTRE_ON_PARENT   = 0x01,
        	wxSPLASH_CENTRE_ON_SCREEN   = 0x02,
        	wxSPLASH_NO_CENTRE          = 0x00,
        	wxSPLASH_TIMEOUT            = 0x04,
        	wxSPLASH_NO_TIMEOUT         = 0x00,

        	wxSPLASH_DEFAULT =  wxSIMPLE_BORDER | wxFRAME_NO_TASKBAR | wxSTAY_ON_TOP,
        }

        public this(IntPtr wxobj) ;
        public this(Bitmap bitmap, int splashStyle, int milliseconds, Window parent, int id, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=wxSPLASH_DEFAULT);
        public int SplashStyle() ;
        public SplashScreenWindow SplashWindow() ;
        public int Timeout() ;
    }
    
    //-----------------------------------------------------------------------------

		//! \cond EXTERN
        static extern (C) IntPtr wxSplashScreenWindow_ctor(IntPtr bitmap, IntPtr parent, int id, inout Point pos, inout Size size, uint style);
        static extern (C) void   wxSplashScreenWindow_SetBitmap(IntPtr self, IntPtr bitmap);
        static extern (C) IntPtr wxSplashScreenWindow_GetBitmap(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias SplashScreenWindow wxSplashScreenWindow;
    public class SplashScreenWindow : Window
    {
        public this(IntPtr wxobj) ;
        public this(Bitmap bitmap, Window parent, int id, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=wxNO_BORDER);
        public void bitmap(Bitmap value);
        public Bitmap bitmap();
    }

