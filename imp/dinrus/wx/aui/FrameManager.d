module wx.aui.FrameManager;

public import wx.wx;
public import wx.MiniFrame;
public import wx.Image;
public import wx.Event;
public import wx.EvtHandler;

public import wx.aui.DockArt;

enum wxFrameManagerDock
{
    wxAUI_DOCK_NONE = 0,
    wxAUI_DOCK_TOP = 1,
    wxAUI_DOCK_RIGHT = 2,
    wxAUI_DOCK_BOTTOM = 3,
    wxAUI_DOCK_LEFT = 4,
    wxAUI_DOCK_CENTER = 5,
    wxAUI_DOCK_CENTRE = wxAUI_DOCK_CENTER
};

enum wxFrameManagerOption
{
    wxAUI_MGR_ALLOW_FLOATING        = 1 << 0,
    wxAUI_MGR_ALLOW_ACTIVE_PANE     = 1 << 1,
    wxAUI_MGR_TRANSPARENT_DRAG      = 1 << 2,
    wxAUI_MGR_TRANSPARENT_HINT      = 1 << 3,
    wxAUI_MGR_TRANSPARENT_HINT_FADE = 1 << 4,

    wxAUI_MGR_DEFAULT = wxAUI_MGR_ALLOW_FLOATING |
                        wxAUI_MGR_TRANSPARENT_HINT |
                        wxAUI_MGR_TRANSPARENT_HINT_FADE
};

enum wxPaneDockArtSetting
{
    wxAUI_ART_SASH_SIZE = 0,
    wxAUI_ART_CAPTION_SIZE = 1,
    wxAUI_ART_GRIPPER_SIZE = 2,
    wxAUI_ART_PANE_BORDER_SIZE = 3,
    wxAUI_ART_PANE_BUTTON_SIZE = 4,
    wxAUI_ART_BACKGROUND_COLOUR = 5,
    wxAUI_ART_SASH_COLOUR = 6,
    wxAUI_ART_ACTIVE_CAPTION_COLOUR = 7,
    wxAUI_ART_ACTIVE_CAPTION_GRADIENT_COLOUR = 8,
    wxAUI_ART_INACTIVE_CAPTION_COLOUR = 9,
    wxAUI_ART_INACTIVE_CAPTION_GRADIENT_COLOUR = 10,
    wxAUI_ART_ACTIVE_CAPTION_TEXT_COLOUR = 11,
    wxAUI_ART_INACTIVE_CAPTION_TEXT_COLOUR = 12,
    wxAUI_ART_BORDER_COLOUR = 13,
    wxAUI_ART_GRIPPER_COLOUR = 14,
    wxAUI_ART_CAPTION_FONT = 15,
    wxAUI_ART_GRADIENT_TYPE = 16
};

enum wxPaneDockArtGradients
{
    wxAUI_GRADIENT_NONE = 0,
    wxAUI_GRADIENT_VERTICAL = 1,
    wxAUI_GRADIENT_HORIZONTAL = 2
};

enum wxPaneButtonState
{
    wxAUI_BUTTON_STATE_NORMAL = 0,
    wxAUI_BUTTON_STATE_HOVER = 1,
    wxAUI_BUTTON_STATE_PRESSED = 2
};

enum wxPaneInsertLevel
{
    wxAUI_INSERT_PANE = 0,
    wxAUI_INSERT_ROW = 1,
    wxAUI_INSERT_DOCK = 2
};

//-----------------------------------------------------------------------------

//! \cond EXTERN
static extern (C) IntPtr wxPaneInfo_ctor();
static extern (C) void wxPaneInfo_Copy(IntPtr self, IntPtr c);
static extern (C) bool wxPaneInfo_IsOk(IntPtr self);
static extern (C) bool wxPaneInfo_IsFixed(IntPtr self);
static extern (C) bool wxPaneInfo_IsResizable(IntPtr self);
static extern (C) bool wxPaneInfo_IsShown(IntPtr self);
static extern (C) bool wxPaneInfo_IsFloating(IntPtr self);
static extern (C) bool wxPaneInfo_IsDocked(IntPtr self);
static extern (C) bool wxPaneInfo_IsToolbar(IntPtr self);
static extern (C) bool wxPaneInfo_IsTopDockable(IntPtr self);
static extern (C) bool wxPaneInfo_IsBottomDockable(IntPtr self);
static extern (C) bool wxPaneInfo_IsLeftDockable(IntPtr self);
static extern (C) bool wxPaneInfo_IsRightDockable(IntPtr self);
static extern (C) bool wxPaneInfo_IsFloatable(IntPtr self);
static extern (C) bool wxPaneInfo_IsMovable(IntPtr self);
static extern (C) bool wxPaneInfo_HasCaption(IntPtr self);
static extern (C) bool wxPaneInfo_HasGripper(IntPtr self);
static extern (C) bool wxPaneInfo_HasBorder(IntPtr self);
static extern (C) bool wxPaneInfo_HasCloseButton(IntPtr self);
static extern (C) bool wxPaneInfo_HasMaximizeButton(IntPtr self);
static extern (C) bool wxPaneInfo_HasMinimizeButton(IntPtr self);
static extern (C) bool wxPaneInfo_HasPinButton(IntPtr self);
static extern (C) IntPtr wxPaneInfo_Window(IntPtr self, IntPtr w);
static extern (C) IntPtr wxPaneInfo_Name(IntPtr self, char[] n);
static extern (C) IntPtr wxPaneInfo_Caption(IntPtr self, char[] c);
static extern (C) IntPtr wxPaneInfo_Left(IntPtr self);
static extern (C) IntPtr wxPaneInfo_Right(IntPtr self);
static extern (C) IntPtr wxPaneInfo_Top(IntPtr self);
static extern (C) IntPtr wxPaneInfo_Bottom(IntPtr self);
static extern (C) IntPtr wxPaneInfo_Center(IntPtr self);
static extern (C) IntPtr wxPaneInfo_Centre(IntPtr self);
static extern (C) IntPtr wxPaneInfo_Direction(IntPtr self, int direction);
static extern (C) IntPtr wxPaneInfo_Layer(IntPtr self, int layer);
static extern (C) IntPtr wxPaneInfo_Row(IntPtr self, int row);
static extern (C) IntPtr wxPaneInfo_Position(IntPtr self, int pos);
static extern (C) IntPtr wxPaneInfo_BestSize(IntPtr self, inout Size size);
static extern (C) IntPtr wxPaneInfo_MinSize(IntPtr self, inout Size size);
static extern (C) IntPtr wxPaneInfo_MaxSize(IntPtr self, inout Size size);
static extern (C) IntPtr wxPaneInfo_BestSizeXY(IntPtr self, int x, int y);
static extern (C) IntPtr wxPaneInfo_MinSizeXY(IntPtr self, int x, int y);
static extern (C) IntPtr wxPaneInfo_MaxSizeXY(IntPtr self, int x, int y);
static extern (C) IntPtr wxPaneInfo_FloatingPosition(IntPtr self, inout Point pos);
static extern (C) IntPtr wxPaneInfo_FloatingPositionXY(IntPtr self, int x, int y);
static extern (C) IntPtr wxPaneInfo_FloatingSize(IntPtr self, inout Size size);
static extern (C) IntPtr wxPaneInfo_FloatingSizeXY(IntPtr self, int x, int y);
static extern (C) IntPtr wxPaneInfo_Fixed(IntPtr self);
static extern (C) IntPtr wxPaneInfo_Resizable(IntPtr self, bool resizable = true);
static extern (C) IntPtr wxPaneInfo_Dock(IntPtr self);
static extern (C) IntPtr wxPaneInfo_Float(IntPtr self);
static extern (C) IntPtr wxPaneInfo_Hide(IntPtr self);
static extern (C) IntPtr wxPaneInfo_Show(IntPtr self, bool show = true);
static extern (C) IntPtr wxPaneInfo_CaptionVisible(IntPtr self, bool visible = true);
static extern (C) IntPtr wxPaneInfo_PaneBorder(IntPtr self, bool visible = true);
static extern (C) IntPtr wxPaneInfo_Gripper(IntPtr self, bool visible = true);
static extern (C) IntPtr wxPaneInfo_CloseButton(IntPtr self, bool visible = true);
static extern (C) IntPtr wxPaneInfo_MaximizeButton(IntPtr self, bool visible = true);
static extern (C) IntPtr wxPaneInfo_MinimizeButton(IntPtr self, bool visible = true);
static extern (C) IntPtr wxPaneInfo_PinButton(IntPtr self, bool visible = true);
static extern (C) IntPtr wxPaneInfo_DestroyOnClose(IntPtr self, bool b = true);
static extern (C) IntPtr wxPaneInfo_TopDockable(IntPtr self, bool b = true);
static extern (C) IntPtr wxPaneInfo_BottomDockable(IntPtr self, bool b = true);
static extern (C) IntPtr wxPaneInfo_LeftDockable(IntPtr self, bool b = true);
static extern (C) IntPtr wxPaneInfo_RightDockable(IntPtr self, bool b = true);
static extern (C) IntPtr wxPaneInfo_Floatable(IntPtr self, bool b = true);
static extern (C) IntPtr wxPaneInfo_Movable(IntPtr self, bool b = true);
static extern (C) IntPtr wxPaneInfo_Dockable(IntPtr self, bool b = true);
static extern (C) IntPtr wxPaneInfo_DefaultPane(IntPtr self);
static extern (C) IntPtr wxPaneInfo_CentrePane(IntPtr self);
static extern (C) IntPtr wxPaneInfo_CenterPane(IntPtr self);
static extern (C) IntPtr wxPaneInfo_ToolbarPane(IntPtr self);
static extern (C) IntPtr wxPaneInfo_SetFlag(IntPtr self, uint flag, bool option_state);
static extern (C) bool wxPaneInfo_HasFlag(IntPtr self, uint flag);
static extern (C) char[] wxPaneInfo_GetName(IntPtr self);
static extern (C) char[] wxPaneInfo_GetCaption(IntPtr self);
static extern (C) IntPtr wxPaneInfo_GetWindow(IntPtr self);
static extern (C) IntPtr wxPaneInfo_GetFrame(IntPtr self);
static extern (C) uint wxPaneInfo_GetState(IntPtr self);
static extern (C) int wxPaneInfo_GetDock_Direction(IntPtr self);
static extern (C) int wxPaneInfo_GetDock_Layer(IntPtr self);
static extern (C) int wxPaneInfo_GetDock_Row(IntPtr self);
static extern (C) int wxPaneInfo_GetDock_Pos(IntPtr self);
static extern (C) void wxPaneInfo_GetBest_Size(IntPtr self, out Size size);
static extern (C) void wxPaneInfo_GetMin_Size(IntPtr self, out Size size);
static extern (C) void wxPaneInfo_GetMax_Size(IntPtr self, out Size size);
static extern (C) void wxPaneInfo_GetFloating_Pos(IntPtr self, out Point point);
static extern (C) void wxPaneInfo_GetFloating_Size(IntPtr self, out Size size);
static extern (C) int wxPaneInfo_GetDock_Proportion(IntPtr self);
static extern (C) void wxPaneInfo_GetRect(IntPtr self, out Rectangle rect);
//! \endcond

//-----------------------------------------------------------------------------

//! \cond EXTERN
static extern (C) IntPtr wxFrameManager_ctor(IntPtr frame = null, uint flags = wxFrameManagerOption.wxAUI_MGR_DEFAULT);
static extern (C) void wxFrameManager_dtor(IntPtr self);
static extern (C) void wxFrameManager_UnInit(IntPtr self);
static extern (C) void wxFrameManager_SetFlags(IntPtr self, uint flags);
static extern (C) uint wxFrameManager_GetFlags(IntPtr self);
static extern (C) void wxFrameManager_SetFrame(IntPtr self, IntPtr frame);
static extern (C) IntPtr wxFrameManager_GetFrame(IntPtr self);
static extern (C) void wxFrameManager_SetArtProvider(IntPtr self, IntPtr art_provider);
static extern (C) IntPtr wxFrameManager_GetArtProvider(IntPtr self);
static extern (C) IntPtr wxFrameManager_GetPaneByWindow(IntPtr self, IntPtr window);
static extern (C) IntPtr wxFrameManager_GetPaneByName(IntPtr self, char[] name);
static extern (C) int wxFrameManager_GetPaneCount(IntPtr self);
static extern (C) IntPtr wxFrameManager_GetPane(IntPtr self, int index);
static extern (C) bool wxFrameManager_AddPane(IntPtr self, IntPtr window, IntPtr pane_info);
static extern (C) bool wxFrameManager_AddPane2(IntPtr self, IntPtr window, int direction, string caption);
static extern (C) bool wxFrameManager_InsertPane(IntPtr self, IntPtr window, IntPtr pane_info, int insert_level = wxPaneInsertLevel.wxAUI_INSERT_PANE);
static extern (C) bool wxFrameManager_DetachPane(IntPtr self, IntPtr window);
static extern (C) char[] wxFrameManager_SavePerspective(IntPtr self);
static extern (C) bool wxFrameManager_LoadPerspective(IntPtr self, char[] perspective, bool update = true);
static extern (C) void wxFrameManager_Update(IntPtr self);

static extern (C) EventType wxEvent_EVT_AUI_PANEBUTTON();
//! \endcond

//-----------------------------------------------------------------------------

//! \cond EXTERN
static extern (C) void wxFrameManagerEvent_SetPane(IntPtr self, IntPtr p);
static extern (C) IntPtr wxFrameManagerEvent_GetPane(IntPtr self);
static extern (C) void wxFrameManagerEvent_SetButton(IntPtr self, int b);
static extern (C) int wxFrameManagerEvent_GetButton(IntPtr self);
static extern (C) IntPtr wxFrameManagerEvent_Clone(IntPtr self);
//! \endcond

//-----------------------------------------------------------------------------

alias PaneInfo wxPaneInfo;
public class PaneInfo : wxObject
{
    public this(IntPtr wxobj);
    public this();
    public this(PaneInfo c);

    public bool IsOk();
    public bool IsFixed();
    public bool IsResizable() ;
    public bool IsShown();
    public bool IsFloating();
    public bool IsDocked();
    public bool IsToolbar() ;
    public bool IsTopDockable() ;
    public bool IsBottomDockable();
    public bool IsLeftDockable() ;
    public bool IsRightDockable();
    public bool IsFloatable();
    public bool IsMovable();
    public bool HasCaption() ;
    public bool HasGripper() ;
    public bool HasBorder() ;
    public bool HasCloseButton() ;
    public bool HasMaximizeButton() ;
    public bool HasMinimizeButton() ;
    public bool HasPinButton() ;

    public PaneInfo Window(wxWindow w) ;
    public PaneInfo Name(char[] n) ;
    public PaneInfo Caption(char[] c);
    public PaneInfo Left();
    public PaneInfo Right() ;
    public PaneInfo Top();
    public PaneInfo Bottom();
    public PaneInfo Center();
    public PaneInfo Centre() ;
    public PaneInfo Direction(int direction) ;
    public PaneInfo Layer(int layer) ;
    public PaneInfo Row(int row) ;
    public PaneInfo Position(int pos);
    public PaneInfo BestSize(ref Size size);
    public PaneInfo MinSize(ref Size size) ;
    public PaneInfo MaxSize(ref Size size) ;
    public PaneInfo BestSize(int x, int y) ;
    public PaneInfo MinSize(int x, int y);
    public PaneInfo MaxSize(int x, int y) ;
    public PaneInfo FloatingPosition(ref Point pos);
    public PaneInfo FloatingPosition(int x, int y) ;
    public PaneInfo FloatingSize(ref Size size);
    public PaneInfo FloatingSize(int x, int y);
    public PaneInfo Fixed();
    public PaneInfo Resizable(bool resizable = true) ;
    public PaneInfo Dock() ;
    public PaneInfo Float();
    public PaneInfo Hide();
    public PaneInfo Show(bool show = true) ;
    public PaneInfo CaptionVisible(bool visible = true) ;
    public PaneInfo PaneBorder(bool visible = true) ;
    public PaneInfo Gripper(bool visible = true);
    public PaneInfo CloseButton(bool visible = true);
    public PaneInfo MaximizeButton(bool visible = true) ;
    public PaneInfo MinimizeButton(bool visible = true);
    public PaneInfo PinButton(bool visible = true);
    public PaneInfo DestroyOnClose(bool b = true);
    public PaneInfo TopDockable(bool b = true);
    public PaneInfo BottomDockable(bool b = true);
    public PaneInfo LeftDockable(bool b = true);
    public PaneInfo RightDockable(bool b = true) ;
    public PaneInfo Floatable(bool b = true) ;
    public PaneInfo Movable(bool b = true) ;
    public PaneInfo Dockable(bool b = true) ;
    public PaneInfo DefaultPane() ;
    public PaneInfo CentrePane() ;
    public PaneInfo CenterPane() ;
    public PaneInfo ToolbarPane() ;
    public PaneInfo SetFlag(uint flag, bool option_state) ;
    public bool HasFlag(uint flag) ;

    public char[] name();
    public char[] caption() ;

    public wxWindow window();
    public wxWindow frame();
    public uint state() ;

    public int dock_direction() ;
    public int dock_layer() ;
    public int dock_row();
    public int dock_pos() ;

    public Size best_size();
    public Size min_size();
    public Size max_size();

    public Point floating_pos();
    public Size floating_size();
    public int dock_proportion() ;

    public Rectangle rect();

    public enum wxPaneState
    {
      optionFloating        = 1 << 0,
      optionHidden          = 1 << 1,
      optionLeftDockable    = 1 << 2,
      optionRightDockable   = 1 << 3,
      optionTopDockable     = 1 << 4,
      optionBottomDockable  = 1 << 5,
      optionFloatable       = 1 << 6,
      optionMovable         = 1 << 7,
      optionResizable       = 1 << 8,
      optionPaneBorder      = 1 << 9,
      optionCaption         = 1 << 10,
      optionGripper         = 1 << 11,
      optionDestroyOnClose  = 1 << 12,
      optionToolbar         = 1 << 13,
      optionActive          = 1 << 14,

      buttonClose           = 1 << 24,
      buttonMaximize        = 1 << 25,
      buttonMinimize        = 1 << 26,
      buttonPin             = 1 << 27,
      buttonCustom1         = 1 << 28,
      buttonCustom2         = 1 << 29,
      buttonCustom3         = 1 << 30,
      actionPane            = 1 << 31  // used internally
    }
}



alias FrameManager wxFrameManager;
public class FrameManager : EvtHandler
{
    public this(IntPtr wxobj);
    public this(Frame frame = null, uint flags = wxFrameManagerOption.wxAUI_MGR_DEFAULT);
    public void UnInit();
    public void SetFlags(uint flags);
    public uint GetFlags();
    public void SetFrame(Frame frame) ;
    public Frame GetFrame();
    public void SetArtProvider(DockArt art_provider) ;
    public DockArt GetArtProvider();
    public PaneInfo GetPane(Window window);
    public PaneInfo GetPane(char[] name);
    public int GetPaneCount();
    public PaneInfo GetPane(int index);
    public bool AddPane(Window window, PaneInfo pane_info);
    public bool AddPane(Window window,
                 int direction = Direction.wxLEFT,
                 string caption = "");
    public bool InsertPane(Window window,
                 PaneInfo pane_info,
                 int insert_level = wxPaneInsertLevel.wxAUI_INSERT_PANE);
    public bool DetachPane(Window window);
    public char[] SavePerspective() ;
    public bool LoadPerspective(char[] perspective,
                 bool update = true);
    public void Update() ;

// wx event machinery

// right now the only event that works is wxEVT_AUI_PANEBUTTON. A full
// spectrum of events will be implemented in the next incremental version

    public static EventType wxEVT_AUI_PANEBUTTON;

    static this();
    public void EVT_AUI_PANEBUTTON(EventListener lsnr);
}

// event declarations/classes
alias FrameManagerEvent wxFrameManagerEvent;
public class FrameManagerEvent : Event
{
    public this(IntPtr wxobj);
    public Event Clone();
    public void SetPane(PaneInfo p);
    public void SetButton(int b) ;
    public PaneInfo GetPane();
    public int GetButton() ;
}


