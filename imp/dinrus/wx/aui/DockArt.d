module wx.aui.DockArt;
public import wx.aui.FrameManager;
public import wx.wx;

//-----------------------------------------------------------------------------

//! \cond EXTERN
extern (C) alias int function(DockArt obj, int id) Virtual_GetMetric;
extern (C) alias void function(DockArt obj, int id, int new_val) Virtual_SetMetric;
extern (C) alias void function(DockArt obj, int id, IntPtr font) Virtual_SetFont;
extern (C) alias IntPtr function(DockArt obj, int id) Virtual_GetFont;
extern (C) alias IntPtr function(DockArt obj, int id) Virtual_GetColour;
extern (C) alias void function(DockArt obj, int id, IntPtr colour) Virtual_SetColour;
extern (C) alias IntPtr function(DockArt obj, int id) Virtual_GetColor;
extern (C) alias void function(DockArt obj, int id, IntPtr color) Virtual_SetColor;
extern (C) alias void function(DockArt obj, IntPtr dc, int orientation, inout Rectangle rect) Virtual_DrawSash;
extern (C) alias void function(DockArt obj, IntPtr dc, int orientation, inout Rectangle rect) Virtual_DrawBackground;
extern (C) alias void function(DockArt obj, IntPtr dc, string text, inout Rectangle rect, IntPtr pane) Virtual_DrawCaption;
extern (C) alias void function(DockArt obj, IntPtr dc, inout Rectangle rect, IntPtr pane) Virtual_DrawGripper;
extern (C) alias void function(DockArt obj, IntPtr dc, inout Rectangle rect, IntPtr pane) Virtual_DrawBorder;
extern (C) alias void function(DockArt obj, IntPtr dc, int button, int button_state, inout Rectangle rect, IntPtr pane) Virtual_DrawPaneButton;

//-----------------------------------------------------------------------------

static extern (C) IntPtr wxDockArt_ctor();
static extern (C) void wxDockArt_dtor(IntPtr self);
static extern (C) IntPtr wxDefaultDockArt_ctor();
static extern (C) void wxDefaultDockArt_dtor(IntPtr self);
static extern (C) void wxDockArt_RegisterVirtual(IntPtr self, DockArt obj,
                      Virtual_GetMetric getMetric,
                      Virtual_SetMetric setMetric,
                      Virtual_SetFont setFont,
                      Virtual_GetFont getFont,
                      Virtual_GetColour getColour,
                      Virtual_SetColour setColour,
                      Virtual_GetColor getColor,
                      Virtual_SetColor setColor,
                      Virtual_DrawSash drawSash,
                      Virtual_DrawBackground drawBackground,
                      Virtual_DrawCaption drawCaption,
                      Virtual_DrawGripper drawGripper,
                      Virtual_DrawBorder drawBorder,
                      Virtual_DrawPaneButton drawPaneButton);
static extern (C) int wxDockArt_GetMetric(IntPtr self, int id);
static extern (C) void wxDockArt_SetMetric(IntPtr self, int id, int new_val);
static extern (C) void wxDockArt_SetFont(IntPtr self, int id, IntPtr font);
static extern (C) IntPtr wxDockArt_GetFont(IntPtr self, int id);
static extern (C) IntPtr wxDockArt_GetColour(IntPtr self, int id);
static extern (C) void wxDockArt_SetColour(IntPtr self, int id, IntPtr colour);
static extern (C) IntPtr wxDockArt_GetColor(IntPtr self, int id);
static extern (C) void wxDockArt_SetColor(IntPtr self, int id, IntPtr color);
static extern (C) void wxDockArt_DrawSash(IntPtr self, IntPtr dc, int orientation, inout Rectangle rect);
static extern (C) void wxDockArt_DrawBackground(IntPtr self, IntPtr dc, int orientation, inout Rectangle rect);
static extern (C) void wxDockArt_DrawCaption(IntPtr self, IntPtr dc, string text, inout Rectangle rect, IntPtr pane);
static extern (C) void wxDockArt_DrawGripper(IntPtr self, IntPtr dc, inout Rectangle rect, IntPtr pane);
static extern (C) void wxDockArt_DrawBorder(IntPtr self, IntPtr dc, inout Rectangle rect, IntPtr pane);
static extern (C) void wxDockArt_DrawPaneButton(IntPtr self, IntPtr dc, int button, int button_state, inout Rectangle rect, IntPtr pane);
//! \endcond

//-----------------------------------------------------------------------------

alias DockArt wxDockArt;
/// dock art provider code - a dock provider provides all drawing
/// functionality to the wxAui dock manager.  This allows the dock
/// manager to have plugable look-and-feels
public class DockArt : wxObject
{
	IntPtr proxy;

    public this(IntPtr wxobj);
    override protected void dtor();
    extern (C) protected static int staticGetMetric(DockArt obj, int id);
    extern (C) protected static void staticSetMetric(DockArt obj, int id, int new_val) ;
    extern (C) protected static void staticSetFont(DockArt obj, int id, IntPtr font);
    extern (C) protected static IntPtr staticGetFont(DockArt obj, int id) ;
    extern (C) protected static IntPtr staticGetColour(DockArt obj, int id) ;
    extern (C) protected static void staticSetColour(DockArt obj, int id, IntPtr colour);
    extern (C) protected static IntPtr staticGetColor(DockArt obj, int id);
    extern (C) protected static void staticSetColor(DockArt obj, int id, IntPtr color);
    extern (C) protected static void staticDrawSash(DockArt obj, IntPtr dc, int orientation, inout Rectangle rect);
    extern (C) protected static void staticDrawBackground(DockArt obj, IntPtr dc, int orientation, inout Rectangle rect);
    extern (C) protected static void staticDrawCaption(DockArt obj, IntPtr dc, string text, inout Rectangle rect, IntPtr pane);
    extern (C) protected static void staticDrawGripper(DockArt obj, IntPtr dc, inout Rectangle rect, IntPtr pane);
    extern (C) protected static void staticDrawBorder(DockArt obj, IntPtr dc, inout Rectangle rect, IntPtr pane);
    extern (C) protected static void staticDrawPaneButton(DockArt obj, IntPtr dc, int button, int button_state, inout Rectangle rect, IntPtr pane);
    public int GetMetric(int id);
    public void SetMetric(int id, int new_val);
    public void SetFont(int id, wxFont font) ;
    public Font GetFont(int id);
    public Colour GetColour(int id);
    public void SetColour(int id, Colour colour) ;
    public Colour GetColor(int id);
    public void SetColor(int id, Colour color) ;
    public void DrawSash(DC dc, int orientation, Rectangle rect) ;
    public void DrawBackground(DC dc, int orientation, Rectangle rect);
    public void DrawCaption(DC dc, string text, Rectangle rect, PaneInfo pane) ;
    public void DrawGripper(DC dc, Rectangle rect, PaneInfo pane);
    public void DrawBorder(DC dc, Rectangle rect, PaneInfo pane);
    public void DrawPaneButton(DC dc, int button, int button_state, Rectangle rect, PaneInfo pane);
}

alias DefaultDockArt wxDefaultDockArt;
/// this is the default art provider for wxFrameManager.  Dock art
/// can be customized by creating a class derived from this one.
public class DefaultDockArt : DockArt
{
    public this()
    {
      super(wxDefaultDockArt_ctor());
	}
	
    override protected void dtor()
    {
      wxDefaultDockArt_dtor(wxobj);
	}
}
