module wx.MouseEvent;
public import wx.common;
public import wx.Event;

public import wx.DC;

		//! \cond EXTERN
        static extern (C) IntPtr wxMouseEvent_ctor(int mouseType);
        static extern (C) bool   wxMouseEvent_IsButton(IntPtr self);
        static extern (C) bool   wxMouseEvent_ButtonDown(IntPtr self);
	static extern (C) bool   wxMouseEvent_ButtonDown2(IntPtr self, int button);
        static extern (C) bool   wxMouseEvent_ButtonDClick(IntPtr self, int but);
        static extern (C) bool   wxMouseEvent_ButtonUp(IntPtr self, int but);
        static extern (C) bool   wxMouseEvent_Button(IntPtr self, int but);
        static extern (C) bool   wxMouseEvent_ButtonIsDown(IntPtr self, int but);
        static extern (C) int    wxMouseEvent_GetButton(IntPtr self);
        static extern (C) bool   wxMouseEvent_ControlDown(IntPtr self);
        static extern (C) bool   wxMouseEvent_MetaDown(IntPtr self);
        static extern (C) bool   wxMouseEvent_AltDown(IntPtr self);
        static extern (C) bool   wxMouseEvent_ShiftDown(IntPtr self);
        static extern (C) bool   wxMouseEvent_LeftDown(IntPtr self);
        static extern (C) bool   wxMouseEvent_MiddleDown(IntPtr self);
        static extern (C) bool   wxMouseEvent_RightDown(IntPtr self);
        static extern (C) bool   wxMouseEvent_LeftUp(IntPtr self);
        static extern (C) bool   wxMouseEvent_MiddleUp(IntPtr self);
        static extern (C) bool   wxMouseEvent_RightUp(IntPtr self);
        static extern (C) bool   wxMouseEvent_LeftDClick(IntPtr self);
        static extern (C) bool   wxMouseEvent_MiddleDClick(IntPtr self);
        static extern (C) bool   wxMouseEvent_RightDClick(IntPtr self);
        static extern (C) bool   wxMouseEvent_LeftIsDown(IntPtr self);
        static extern (C) bool   wxMouseEvent_MiddleIsDown(IntPtr self);
        static extern (C) bool   wxMouseEvent_RightIsDown(IntPtr self);
        static extern (C) bool   wxMouseEvent_Dragging(IntPtr self);
        static extern (C) bool   wxMouseEvent_Moving(IntPtr self);
        static extern (C) bool   wxMouseEvent_Entering(IntPtr self);
        static extern (C) bool   wxMouseEvent_Leaving(IntPtr self);
        static extern (C) void   wxMouseEvent_GetPosition(IntPtr self, inout Point pos);
        static extern (C) void   wxMouseEvent_LogicalPosition(IntPtr self, IntPtr dc, inout Point pos);
        static extern (C) int    wxMouseEvent_GetWheelRotation(IntPtr self);
        static extern (C) int    wxMouseEvent_GetWheelDelta(IntPtr self);
        static extern (C) int    wxMouseEvent_GetLinesPerAction(IntPtr self);
        static extern (C) bool   wxMouseEvent_IsPageScroll(IntPtr self);
		//! \endcond

		//----------------------------------------------------------------------------

    alias MouseEvent wxMouseEvent;
    public class MouseEvent : Event
    {
		public this(IntPtr wxobj) ;
        public this(EventType mouseType);
        public bool IsButton() ;
	public bool ButtonDown(MouseButton but);
	public bool ButtonDClick();
        public bool ButtonDClick(MouseButton but);
	public bool ButtonUp();
        public bool ButtonUp(MouseButton but);
        public bool Button(int but);
        public bool ButtonIsDown(int but);
        public int Button();
        public bool ControlDown() ;
        public bool MetaDown() ;
        public bool AltDown() ;
        public bool ShiftDown() ;
        public bool LeftDown() ;
        public bool MiddleDown();
        public bool RightDown();
        public bool LeftUp() ;
        public bool MiddleUp();
        public bool RightUp() ;
        public bool LeftDClick() ;
        public bool MiddleDClick() ;
        public bool RightDClick();
        public bool LeftIsDown() ;
        public bool MiddleIsDown();
        public bool RightIsDown() ;
        public bool Dragging() ;
        public bool Moving() ;
        public bool Entering() ;
        public bool Leaving();
        public Point Position();
        public Point LogicalPosition(DC dc);
        public int WheelRotation() ;
        public int WheelDelta() ;
        public int LinesPerAction();
        public bool IsPageScroll() ;
		private static Event New(IntPtr obj);

		static this()
		{
			AddEventType(wxEVT_LEFT_UP,                         &MouseEvent.New);
			AddEventType(wxEVT_RIGHT_UP,                        &MouseEvent.New);
			AddEventType(wxEVT_MIDDLE_UP,                       &MouseEvent.New);
			AddEventType(wxEVT_ENTER_WINDOW,                    &MouseEvent.New);
			AddEventType(wxEVT_LEAVE_WINDOW,                    &MouseEvent.New);
			AddEventType(wxEVT_LEFT_DOWN,                       &MouseEvent.New);
			AddEventType(wxEVT_MIDDLE_DOWN,                     &MouseEvent.New);
			AddEventType(wxEVT_RIGHT_DOWN,                      &MouseEvent.New);
			AddEventType(wxEVT_LEFT_DCLICK,                     &MouseEvent.New);
			AddEventType(wxEVT_RIGHT_DCLICK,                    &MouseEvent.New);
			AddEventType(wxEVT_MIDDLE_DCLICK,                   &MouseEvent.New);
			AddEventType(wxEVT_MOUSEWHEEL,                      &MouseEvent.New);
			AddEventType(wxEVT_MOTION,                              &MouseEvent.New);  
        }
    }

