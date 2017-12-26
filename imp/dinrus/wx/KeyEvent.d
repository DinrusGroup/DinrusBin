module wx.KeyEvent;
public import wx.common;
public import wx.Event;

		//! \cond EXTERN
        static extern (C) IntPtr wxKeyEvent_ctor(int type);

        static extern (C) bool   wxKeyEvent_ControlDown(IntPtr self);
        static extern (C) bool   wxKeyEvent_ShiftDown(IntPtr self);
        static extern (C) bool   wxKeyEvent_AltDown(IntPtr self);
        static extern (C) bool   wxKeyEvent_MetaDown(IntPtr self);

        static extern (C) uint   wxKeyEvent_GetRawKeyCode(IntPtr self);
        static extern (C) int    wxKeyEvent_GetKeyCode(IntPtr self);

        static extern (C) uint   wxKeyEvent_GetRawKeyFlags(IntPtr self);
        static extern (C) bool   wxKeyEvent_HasModifiers(IntPtr self);

        static extern (C) void   wxKeyEvent_GetPosition(IntPtr self, inout Point pt);
        static extern (C) int    wxKeyEvent_GetX(IntPtr self);
        static extern (C) int    wxKeyEvent_GetY(IntPtr self);
	
	static extern (C) bool   wxKeyEvent_CmdDown(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias KeyEvent wxKeyEvent;
    public class KeyEvent : Event
    {
        public this(IntPtr wxobj) ;
        public this(EventType type = wxEVT_NULL);
        public bool ControlDown();
        public bool MetaDown() ;
        public bool ShiftDown() ;
        public bool AltDown();
	public int KeyCode() ;
        public int RawKeyCode();
        public int RawKeyFlags() ;
        public bool HasModifiers();
        public Point Position() ;
        public int X() ;
        public int Y() ;
	public bool CmdDown() ;
		private static Event New(IntPtr obj);

		static this()
		{
			AddEventType(wxEVT_KEY_DOWN,                        &KeyEvent.New);
			AddEventType(wxEVT_KEY_UP,                          &KeyEvent.New);
			AddEventType(wxEVT_CHAR,                            &KeyEvent.New);
			AddEventType(wxEVT_CHAR_HOOK,                       &KeyEvent.New);
		}
    }
