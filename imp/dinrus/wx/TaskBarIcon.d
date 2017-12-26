module wx.TaskBarIcon;
public import wx.common;
public import wx.EvtHandler;
public import wx.Icon;
public import wx.Menu;

//! \cond EXTERN
static extern (C) EventType wxTaskBarIcon_EVT_TASKBAR_MOVE();
static extern (C) EventType wxTaskBarIcon_EVT_TASKBAR_LEFT_DOWN();
static extern (C) EventType wxTaskBarIcon_EVT_TASKBAR_LEFT_UP();
static extern (C) EventType wxTaskBarIcon_EVT_TASKBAR_RIGHT_DOWN();
static extern (C) EventType wxTaskBarIcon_EVT_TASKBAR_RIGHT_UP();
static extern (C) EventType wxTaskBarIcon_EVT_TASKBAR_LEFT_DCLICK();
static extern (C) EventType wxTaskBarIcon_EVT_TASKBAR_RIGHT_DCLICK();
//! \endcond

extern (C) {
alias IntPtr function (TaskBarIcon) Virtual_CreatePopupMenu;
}
		
//! \cond EXTERN
static extern (C) IntPtr wxTaskBarIcon_ctor();
static extern (C) IntPtr wxTaskBarIcon_ctor2(int iconType);
static extern (C) void   wxTaskBarIcon_RegisterVirtual(IntPtr self, TaskBarIcon obj, 
	Virtual_CreatePopupMenu popmenu);
static extern (C) IntPtr wxTaskBarIcon_dtor(IntPtr self);

static extern (C) IntPtr wxTaskBarIcon_BaseCreatePopupMenu(IntPtr self);
static extern (C) bool wxTaskBarIcon_IsIconInstalled(IntPtr self);
static extern (C) bool wxTaskBarIcon_IsOk(IntPtr self);
static extern (C) bool wxTaskBarIcon_PopupMenu(IntPtr self, IntPtr menu);
static extern (C) bool wxTaskBarIcon_RemoveIcon(IntPtr self);
static extern (C) bool wxTaskBarIcon_SetIcon(IntPtr self, IntPtr icon, string tooltip);
//! \endcond

//! \cond EXTERN
static extern (C) IntPtr wxTaskBarIconEvent_ctor(int commandType, IntPtr tbIcon);
static extern (C) IntPtr wxTaskBarIconEvent_Clone(IntPtr self);
//! \endcond
		
//-----------------------------------------------------------------------------

alias TaskBarIconType wxTaskBarIconType;
/// type of taskbar item to create
enum TaskBarIconType
{
	 DEFAULT_TYPE
}

alias TaskBarIcon wxTaskBarIcon;
public class TaskBarIcon : EvtHandler
{
	public static /*readonly*/ EventType wxEVT_TASKBAR_MOVE;
	public static /*readonly*/ EventType wxEVT_TASKBAR_LEFT_DOWN;
	public static /*readonly*/ EventType wxEVT_TASKBAR_LEFT_UP;
	public static /*readonly*/ EventType wxEVT_TASKBAR_RIGHT_DOWN;
	public static /*readonly*/ EventType wxEVT_TASKBAR_RIGHT_UP;
	public static /*readonly*/ EventType wxEVT_TASKBAR_LEFT_DCLICK;
	public static /*readonly*/ EventType wxEVT_TASKBAR_RIGHT_DCLICK;

	static this()
	{
		wxEVT_TASKBAR_MOVE = wxTaskBarIcon_EVT_TASKBAR_MOVE();
		wxEVT_TASKBAR_LEFT_DOWN = wxTaskBarIcon_EVT_TASKBAR_LEFT_DOWN();
		wxEVT_TASKBAR_LEFT_UP = wxTaskBarIcon_EVT_TASKBAR_LEFT_UP();
		wxEVT_TASKBAR_RIGHT_DOWN = wxTaskBarIcon_EVT_TASKBAR_RIGHT_DOWN();
		wxEVT_TASKBAR_RIGHT_UP = wxTaskBarIcon_EVT_TASKBAR_RIGHT_UP();
		wxEVT_TASKBAR_LEFT_DCLICK = wxTaskBarIcon_EVT_TASKBAR_LEFT_DCLICK();
		wxEVT_TASKBAR_RIGHT_DCLICK = wxTaskBarIcon_EVT_TASKBAR_RIGHT_DCLICK();

		Event.AddEventType(wxEVT_TASKBAR_MOVE,         &TaskBarIconEvent.New);
		Event.AddEventType(wxEVT_TASKBAR_LEFT_DOWN,    &TaskBarIconEvent.New);
		Event.AddEventType(wxEVT_TASKBAR_LEFT_UP,      &TaskBarIconEvent.New);
		Event.AddEventType(wxEVT_TASKBAR_RIGHT_DOWN,   &TaskBarIconEvent.New);
		Event.AddEventType(wxEVT_TASKBAR_RIGHT_UP,     &TaskBarIconEvent.New);
		Event.AddEventType(wxEVT_TASKBAR_LEFT_DCLICK,  &TaskBarIconEvent.New);
		Event.AddEventType(wxEVT_TASKBAR_RIGHT_DCLICK, &TaskBarIconEvent.New);
	}

	public this();
	public this(TaskBarIconType iconType);
	public this(IntPtr wxobj) ;
	private this(IntPtr wxobj, bool memOwn);
	override protected void dtor();
	static extern(C) private IntPtr staticCreatePopupMenu(TaskBarIcon obj);
	protected /+virtual+/ Menu CreatePopupMenu();
	public bool IsIconInstalled();
	public bool IsOk();
	public bool PopupMenu(Menu menu);
	public bool RemoveIcon();
	public bool SetIcon(Icon icon, string tooltip = "");
	public void Move_Add(EventListener value) ;
	public void Move_Remove(EventListener value) ;
	public void LeftDown_Add(EventListener value) ;
	public void LeftDown_Remove(EventListener value) ;
	public void LeftUp_Add(EventListener value) ;
	public void LeftUp_Remove(EventListener value) ;
	public void RightDown_Add(EventListener value) ;
	public void RightDown_Remove(EventListener value) ;
	public void RightUp_Add(EventListener value) ;
	public void RightUp_Remove(EventListener value) ;
	public void LeftDClick_Add(EventListener value);
	public void LeftDClick_Remove(EventListener value) ;
	public void RightDClick_Add(EventListener value) ;
	public void RightDClick_Remove(EventListener value);
}

alias TaskBarIconEvent wxTaskBarIconEvent;
public class TaskBarIconEvent : Event
{
	public this(IntPtr wxobj);
	public this(EventType type, TaskBarIcon tbIcon);
	public Event Clone();
	private static Event New(IntPtr obj);
}
