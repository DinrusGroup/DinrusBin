module wx.Window;
public import wx.common;
public import wx.EvtHandler;
public import wx.Cursor;
public import wx.Font;
public import wx.Colour;
public import wx.Region;
public import wx.Validator;
public import wx.Palette;
public import wx.Accelerator;

public import wx.Caret;
public import wx.DC;
public import wx.DND;
public import wx.Sizer;
public import wx.Menu;
public import wx.ToolTip;

	public enum WindowVariant
	{
		wxWINDOW_VARIANT_NORMAL,  // Normal size
		wxWINDOW_VARIANT_SMALL,   // Smaller size (about 25 % smaller than normal)
		wxWINDOW_VARIANT_MINI,    // Mini size (about 33 % smaller than normal)
		wxWINDOW_VARIANT_LARGE,   // Large size (about 25 % larger than normal)
		wxWINDOW_VARIANT_MAX
	};

	//---------------------------------------------------------------------

	public enum BackgroundStyle
	{
		wxBG_STYLE_SYSTEM,
		wxBG_STYLE_COLOUR,
		wxBG_STYLE_CUSTOM
	};

	//---------------------------------------------------------------------

	public enum Border
	{
		wxBORDER_DEFAULT = 0,

		wxBORDER_NONE   = 0x00200000,
		wxBORDER_STATIC = 0x01000000,
		wxBORDER_SIMPLE = 0x02000000,
		wxBORDER_RAISED = 0x04000000,
		wxBORDER_SUNKEN = 0x08000000,
		wxBORDER_DOUBLE = 0x10000000,

		wxBORDER_MASK   = 0x1f200000,

		wxDOUBLE_BORDER   = wxBORDER_DOUBLE,
		wxSUNKEN_BORDER   = wxBORDER_SUNKEN,
		wxRAISED_BORDER   = wxBORDER_RAISED,
		wxBORDER          = wxBORDER_SIMPLE,
		wxSIMPLE_BORDER   = wxBORDER_SIMPLE,
		wxSTATIC_BORDER   = wxBORDER_STATIC,
		wxNO_BORDER       = wxBORDER_NONE
	};

		//! \cond EXTERN
		static extern (C) IntPtr wxVisualAttributes_ctor();
		static extern (C) void   wxVisualAttributes_dtor(IntPtr self);
		static extern (C) void   wxVisualAttributes_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
		static extern (C) void   wxVisualAttributes_SetFont(IntPtr self, IntPtr font);
		static extern (C) IntPtr wxVisualAttributes_GetFont(IntPtr self);
		static extern (C) void   wxVisualAttributes_SetColourFg(IntPtr self, IntPtr colour);
		static extern (C) IntPtr wxVisualAttributes_GetColourFg(IntPtr self);
		static extern (C) void   wxVisualAttributes_SetColourBg(IntPtr self, IntPtr colour);
		static extern (C) IntPtr wxVisualAttributes_GetColourBg(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------

	alias VisualAttributes wxVisualAttributes;
	public class VisualAttributes : wxObject
	{
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this();
		public Font font();
		public void font(Font value) ;
		public Colour colFg();
		public Colour colBg();
		override protected void dtor() ;
	}

	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxWindow_ctor(IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
		static extern (C) bool   wxWindow_Close(IntPtr self, bool force);
		static extern (C) void   wxWindow_GetBestSize(IntPtr self, out Size size);
		static extern (C) void   wxWindow_GetClientSize(IntPtr self, out Size size);
		static extern (C) int    wxWindow_GetId(IntPtr self);
		static extern (C) uint   wxWindow_GetWindowStyleFlag(IntPtr self);
		static extern (C) uint   wxWindow_Layout(IntPtr self);
		static extern (C) void   wxWindow_SetAutoLayout(IntPtr self, bool autoLayout);
		static extern (C) void   wxWindow_SetBackgroundColour(IntPtr self, IntPtr colour);
		static extern (C) IntPtr wxWindow_GetBackgroundColour(IntPtr self);
		static extern (C) void   wxWindow_SetForegroundColour(IntPtr self, IntPtr colour);
		static extern (C) IntPtr wxWindow_GetForegroundColour(IntPtr self);
		static extern (C) void   wxWindow_SetCursor(IntPtr self, IntPtr cursor);
		static extern (C) void   wxWindow_SetId(IntPtr self, int id);
		static extern (C) void   wxWindow_SetSize(IntPtr self, int x, int y, int width, int height, uint flags);
		static extern (C) void   wxWindow_SetSize2(IntPtr self, int width, int height);
		static extern (C) void   wxWindow_SetSize3(IntPtr self, inout Size size);
		static extern (C) void   wxWindow_SetSize4(IntPtr self, inout Rectangle rect);
		static extern (C) void   wxWindow_SetSizer(IntPtr self, IntPtr sizer, bool deleteOld);
		static extern (C) void   wxWindow_SetWindowStyleFlag(IntPtr self, uint style);
		static extern (C) bool   wxWindow_Show(IntPtr self, bool show);
		static extern (C) bool   wxWindow_SetFont(IntPtr self, IntPtr font);
		static extern (C) IntPtr wxWindow_GetFont(IntPtr self);
		static extern (C) void   wxWindow_SetToolTip(IntPtr self, string tip);
		static extern (C) bool 	 wxWindow_Enable(IntPtr self, bool enable);
		static extern (C) bool   wxWindow_IsEnabled(IntPtr self);

		static extern (C) int    wxWindow_EVT_TRANSFERDATAFROMWINDOW();
		static extern (C) int    wxWindow_EVT_TRANSFERDATATOWINDOW();

		//static extern (C) bool wxWindow_LoadFromResource(IntPtr self, IntPtr parent, string resourceName, IntPtr table);
		//static extern (C) IntPtr wxWindow_CreateItem(IntPtr self, IntPtr childResource, IntPtr parentResource, IntPtr table);
		static extern (C) bool   wxWindow_Destroy(IntPtr self);
		static extern (C) bool   wxWindow_DestroyChildren(IntPtr self);
		static extern (C) void   wxWindow_SetTitle(IntPtr self, string title);
		static extern (C) IntPtr wxWindow_GetTitle(IntPtr self);
		static extern (C) void   wxWindow_SetName(IntPtr self, string name);
		static extern (C) IntPtr wxWindow_GetName(IntPtr self);
		static extern (C) int    wxWindow_NewControlId();
		static extern (C) int    wxWindow_NextControlId(int id);
		static extern (C) int    wxWindow_PrevControlId(int id);
		static extern (C) void   wxWindow_Move(IntPtr self, int x, int y, int flags);
		static extern (C) void   wxWindow_Raise(IntPtr self);
		static extern (C) void   wxWindow_Lower(IntPtr self);
		static extern (C) void   wxWindow_SetClientSize(IntPtr self, int width, int height);
		static extern (C) void   wxWindow_GetPosition(IntPtr self, out Point point);
		static extern (C) void   wxWindow_GetSize(IntPtr self, out Size size);
		static extern (C) void   wxWindow_GetRect(IntPtr self, out Rectangle rect);
		static extern (C) void   wxWindow_GetClientAreaOrigin(IntPtr self, out Point point);
		static extern (C) void   wxWindow_GetClientRect(IntPtr self, out Rectangle rect);
		static extern (C) void   wxWindow_GetAdjustedBestSize(IntPtr self, out Size size);
		static extern (C) void   wxWindow_Center(IntPtr self, int direction);
		static extern (C) void   wxWindow_CenterOnScreen(IntPtr self, int dir);
		static extern (C) void   wxWindow_CenterOnParent(IntPtr self, int dir);
		static extern (C) void   wxWindow_Fit(IntPtr self);
		static extern (C) void   wxWindow_FitInside(IntPtr self);
		static extern (C) void   wxWindow_SetSizeHints(IntPtr self, int minW, int minH, int maxW, int maxH, int incW, int incH);
		static extern (C) void   wxWindow_SetVirtualSizeHints(IntPtr self, int minW, int minH, int maxW, int maxH);
		static extern (C) int    wxWindow_GetMinWidth(IntPtr self);
		static extern (C) int    wxWindow_GetMinHeight(IntPtr self);
		static extern (C) void   wxWindow_GetMinSize(IntPtr self, out Size size);
		static extern (C) void   wxWindow_SetMinSize(IntPtr self, Size* size);
		static extern (C) int    wxWindow_GetMaxWidth(IntPtr self);
		static extern (C) int    wxWindow_GetMaxHeight(IntPtr self);
		static extern (C) void   wxWindow_GetMaxSize(IntPtr self, out Size size);
		static extern (C) void   wxWindow_SetMaxSize(IntPtr self, Size* size);
		static extern (C) void   wxWindow_SetVirtualSize(IntPtr self, inout Size size);
		static extern (C) void   wxWindow_GetVirtualSize(IntPtr self, out Size size);
		static extern (C) void   wxWindow_GetBestVirtualSize(IntPtr self, out Size size);
		static extern (C) bool   wxWindow_Hide(IntPtr self);
		static extern (C) bool   wxWindow_Disable(IntPtr self);
		static extern (C) bool   wxWindow_IsShown(IntPtr self);
		static extern (C) void   wxWindow_SetWindowStyle(IntPtr self, uint style);
		static extern (C) uint   wxWindow_GetWindowStyle(IntPtr self);
		static extern (C) bool   wxWindow_HasFlag(IntPtr self, int flag);
		static extern (C) bool   wxWindow_IsRetained(IntPtr self);
		static extern (C) void   wxWindow_SetExtraStyle(IntPtr self, uint exStyle);
		static extern (C) uint   wxWindow_GetExtraStyle(IntPtr self);
		static extern (C) void   wxWindow_MakeModal(IntPtr self, bool modal);
		static extern (C) void   wxWindow_SetThemeEnabled(IntPtr self, bool enableTheme);
		static extern (C) bool   wxWindow_GetThemeEnabled(IntPtr self);
		static extern (C) void   wxWindow_SetFocus(IntPtr self);
		static extern (C) void   wxWindow_SetFocusFromKbd(IntPtr self);
		static extern (C) IntPtr wxWindow_FindFocus();
		static extern (C) bool   wxWindow_AcceptsFocus(IntPtr self);
		static extern (C) bool   wxWindow_AcceptsFocusFromKeyboard(IntPtr self);
		static extern (C) IntPtr wxWindow_GetParent(IntPtr self);
		static extern (C) IntPtr wxWindow_GetGrandParent(IntPtr self);
		static extern (C) bool   wxWindow_IsTopLevel(IntPtr self);
		static extern (C) void   wxWindow_SetParent(IntPtr self, IntPtr parent);
		static extern (C) bool   wxWindow_Reparent(IntPtr self, IntPtr newParent);
		static extern (C) void   wxWindow_AddChild(IntPtr self, IntPtr child);
		static extern (C) void   wxWindow_RemoveChild(IntPtr self, IntPtr child);
		static extern (C) IntPtr wxWindow_FindWindowId(IntPtr self, int id);
		static extern (C) IntPtr wxWindow_FindWindowName(IntPtr self, string name);
		static extern (C) IntPtr wxWindow_FindWindowById(int id, IntPtr parent);
		static extern (C) IntPtr wxWindow_FindWindowByName(string name, IntPtr parent);
		static extern (C) IntPtr wxWindow_FindWindowByLabel(string label, IntPtr parent);
		static extern (C) IntPtr wxWindow_GetEventHandler(IntPtr self);
		static extern (C) void   wxWindow_SetEventHandler(IntPtr self, IntPtr handler);
		static extern (C) void   wxWindow_PushEventHandler(IntPtr self, IntPtr handler);
		static extern (C) IntPtr wxWindow_PopEventHandler(IntPtr self, bool deleteHandler);
		static extern (C) bool   wxWindow_RemoveEventHandler(IntPtr self, IntPtr handler);
		static extern (C) void   wxWindow_SetValidator(IntPtr self, IntPtr validator);
		static extern (C) IntPtr wxWindow_GetValidator(IntPtr self);
		static extern (C) bool   wxWindow_Validate(IntPtr self);
		static extern (C) bool   wxWindow_TransferDataToWindow(IntPtr self);
		static extern (C) bool   wxWindow_TransferDataFromWindow(IntPtr self);
		static extern (C) void   wxWindow_InitDialog(IntPtr self);
		static extern (C) void   wxWindow_SetAcceleratorTable(IntPtr self, IntPtr accel);
		static extern (C) IntPtr wxWindow_GetAcceleratorTable(IntPtr self);
		static extern (C) void   wxWindow_ConvertPixelsToDialogPoint(IntPtr self, inout Point pt, out Point point);
		static extern (C) void   wxWindow_ConvertDialogToPixelsPoint(IntPtr self, inout Point pt, out Point point);
		static extern (C) void   wxWindow_ConvertPixelsToDialogSize(IntPtr self, inout Size sz, out Size size);
		static extern (C) void   wxWindow_ConvertDialogToPixelsSize(IntPtr self, inout Size sz, out Size size);
		static extern (C) void   wxWindow_WarpPointer(IntPtr self, int x, int y);
		static extern (C) void   wxWindow_CaptureMouse(IntPtr self);
		static extern (C) void   wxWindow_ReleaseMouse(IntPtr self);
		static extern (C) IntPtr wxWindow_GetCapture();
		static extern (C) bool   wxWindow_HasCapture(IntPtr self);
		static extern (C) void   wxWindow_Refresh(IntPtr self, bool eraseBackground, inout Rectangle rect);
		static extern (C) void   wxWindow_RefreshRect(IntPtr self, inout Rectangle rect);
		static extern (C) void   wxWindow_Update(IntPtr self);
		static extern (C) void   wxWindow_ClearBackground(IntPtr self);
		static extern (C) void   wxWindow_Freeze(IntPtr self);
		static extern (C) void   wxWindow_Thaw(IntPtr self);
		static extern (C) void   wxWindow_PrepareDC(IntPtr self, IntPtr dc);
		static extern (C) bool   wxWindow_IsExposed(IntPtr self, int x, int y, int w, int h);
		static extern (C) void   wxWindow_SetCaret(IntPtr self, IntPtr caret);
		static extern (C) IntPtr wxWindow_GetCaret(IntPtr self);
		static extern (C) int    wxWindow_GetCharHeight(IntPtr self);
		static extern (C) int    wxWindow_GetCharWidth(IntPtr self);
		static extern (C) void   wxWindow_GetTextExtent(IntPtr self, string str, out int x, out int y, out int descent, out int externalLeading, IntPtr theFont);
		static extern (C) void   wxWindow_ClientToScreen(IntPtr self, inout int x, inout int y);
		static extern (C) void   wxWindow_ScreenToClient(IntPtr self, inout int x, inout int y);
		static extern (C) void   wxWindow_ClientToScreen(IntPtr self, inout Point pt, out Point point);
		static extern (C) void   wxWindow_ScreenToClient(IntPtr self, inout Point pt, out Point point);
		//static extern (C) wxHitTest wxWindow_HitTest(IntPtr self, Coord x, Coord y);
		//static extern (C) wxHitTest wxWindow_HitTest(IntPtr self, inout Point pt);
		static extern (C) int    wxWindow_GetBorder(IntPtr self);
		static extern (C) int    wxWindow_GetBorderByFlags(IntPtr self, uint flags);
		static extern (C) void   wxWindow_UpdateWindowUI(IntPtr self);
		static extern (C) bool   wxWindow_PopupMenu(IntPtr self, IntPtr menu, inout Point pos);
		static extern (C) bool   wxWindow_HasScrollbar(IntPtr self, int orient);
		static extern (C) void   wxWindow_SetScrollbar(IntPtr self, int orient, int pos, int thumbvisible, int range, bool refresh);
		static extern (C) void   wxWindow_SetScrollPos(IntPtr self, int orient, int pos, bool refresh);
		static extern (C) int    wxWindow_GetScrollPos(IntPtr self, int orient);
		static extern (C) int    wxWindow_GetScrollThumb(IntPtr self, int orient);
		static extern (C) int    wxWindow_GetScrollRange(IntPtr self, int orient);
		static extern (C) void   wxWindow_ScrollWindow(IntPtr self, int dx, int dy, inout Rectangle rect);
		static extern (C) bool   wxWindow_ScrollLines(IntPtr self, int lines);
		static extern (C) bool   wxWindow_ScrollPages(IntPtr self, int pages);
		static extern (C) bool   wxWindow_LineUp(IntPtr self);
		static extern (C) bool   wxWindow_LineDown(IntPtr self);
		static extern (C) bool   wxWindow_PageUp(IntPtr self);
		static extern (C) bool   wxWindow_PageDown(IntPtr self);
		static extern (C) void   wxWindow_SetHelpText(IntPtr self, string text);
		static extern (C) void   wxWindow_SetHelpTextForId(IntPtr self, string text);
		static extern (C) IntPtr wxWindow_GetHelpText(IntPtr self);
		//static extern (C) void wxWindow_SetToolTip(IntPtr self, IntPtr tip);
		//static extern (C) IntPtr wxWindow_GetToolTip(IntPtr self);
		static extern (C) void   wxWindow_SetDropTarget(IntPtr self, IntPtr dropTarget);
		static extern (C) IntPtr wxWindow_GetDropTarget(IntPtr self);
		static extern (C) void   wxWindow_SetConstraints(IntPtr self, IntPtr constraints);
		static extern (C) IntPtr wxWindow_GetConstraints(IntPtr self);
		static extern (C) bool   wxWindow_GetAutoLayout(IntPtr self);
		static extern (C) void   wxWindow_SetSizerAndFit(IntPtr self, IntPtr sizer, bool deleteOld);
		static extern (C) IntPtr wxWindow_GetSizer(IntPtr self);
		static extern (C) void   wxWindow_SetContainingSizer(IntPtr self, IntPtr sizer);
		static extern (C) IntPtr wxWindow_GetContainingSizer(IntPtr self);
		static extern (C) IntPtr wxWindow_GetPalette(IntPtr self);
		static extern (C) void   wxWindow_SetPalette(IntPtr self, IntPtr pal);
		static extern (C) bool   wxWindow_HasCustomPalette(IntPtr self);
		static extern (C) IntPtr wxWindow_GetUpdateRegion(IntPtr self);

		static extern (C) void   wxWindow_SetWindowVariant(IntPtr self, int variant);
		static extern (C) int    wxWindow_GetWindowVariant(IntPtr self);
		static extern (C) bool   wxWindow_IsBeingDeleted(IntPtr self);
		static extern (C) void   wxWindow_InvalidateBestSize(IntPtr self);
		static extern (C) void   wxWindow_CacheBestSize(IntPtr self, Size size);
		static extern (C) void   wxWindow_GetBestFittingSize(IntPtr self, inout Size size);
		static extern (C) void   wxWindow_SetBestFittingSize(IntPtr self, inout Size size);
		static extern (C) IntPtr wxWindow_GetChildren(IntPtr self, int num);
		static extern (C) int    wxWindow_GetChildrenCount(IntPtr self);
		static extern (C) IntPtr wxWindow_GetDefaultAttributes(IntPtr self);
		static extern (C) IntPtr wxWindow_GetClassDefaultAttributes(int variant);
		static extern (C) void   wxWindow_SetBackgroundStyle(IntPtr self, int style);
		static extern (C) int    wxWindow_GetBackgroundStyle(IntPtr self);
		//static extern (C) IntPtr wxWindow_GetToolTipText(IntPtr self);
		static extern (C) IntPtr wxWindow_GetAncestorWithCustomPalette(IntPtr self);
		static extern (C) void   wxWindow_InheritAttributes(IntPtr self);
		static extern (C) bool   wxWindow_ShouldInheritColours(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------

	alias Window wxWindow;
	/// wxWindow is the base class for all windows and represents any
	/// visible object on screen. All controls, top level windows and so on
	/// are windows. Sizers and device contexts are not, however, as they don't
	/// appear on screen themselves.
	public class Window : EvtHandler
	{
		enum {
			wxVSCROLL			= cast(int)0x80000000,
			wxHSCROLL			= 0x40000000,
			wxCAPTION			= 0x20000000,

			wxCLIP_CHILDREN			= 0x00400000,
			wxMINIMIZE_BOX 			= 0x00000400,
			wxCLOSE_BOX			= 0x1000,
			wxMAXIMIZE_BOX			= 0x0200,
			wxNO_3D				= 0x00800000,
			wxRESIZE_BORDER			= 0x00000040,
			wxSYSTEM_MENU			= 0x00000800,
			wxTAB_TRAVERSAL			= 0x00008000,

			wxNO_FULL_REPAINT_ON_RESIZE	= 0x00010000,

			 wxID_OK			= 5100,
			 wxID_CANCEL			= 5101,
			 wxID_YES			= 5103,
			 wxID_NO			= 5104,

			wxID_ANY			= -1,
			wxID_ABOUT			= 5013,

			wxSTAY_ON_TOP			= 0x8000,
			wxICONIZE			= 0x4000,
			wxMINIMIZE			= wxICONIZE,
			wxMAXIMIZE			= 0x2000,

			wxTINY_CAPTION_HORIZ		= 0x0100,
			wxTINY_CAPTION_VERT		= 0x0080,

			wxDIALOG_NO_PARENT		= 0x0001,
			wxFRAME_NO_TASKBAR		= 0x0002,
			wxFRAME_TOOL_WINDOW		= 0x0004,
			wxFRAME_FLOAT_ON_PARENT		= 0x0008,
			wxFRAME_SHAPED			= 0x0010,
			wxFRAME_EX_CONTEXTHELP		= 0x00000004,

		//---------------------------------------------------------------------

			wxBORDER_DEFAULT		= 0x00000000,
			wxBORDER_NONE			= 0x00200000,
			wxBORDER_STATIC			= 0x01000000,
			wxBORDER_SIMPLE			= 0x02000000,
			wxBORDER_RAISED			= 0x04000000,
			wxBORDER_SUNKEN			= 0x08000000,
			wxBORDER_DOUBLE			= 0x10000000,
			wxBORDER_MASK			= 0x1f200000,

		// Border flags
			wxDOUBLE_BORDER			= wxBORDER_DOUBLE,
			wxSUNKEN_BORDER			= wxBORDER_SUNKEN,
			wxRAISED_BORDER			= wxBORDER_RAISED,
			wxBORDER			= wxBORDER_SIMPLE,
			wxSIMPLE_BORDER			= wxBORDER_SIMPLE,
			wxSTATIC_BORDER			= wxBORDER_STATIC,
			wxNO_BORDER			= wxBORDER_NONE,

			wxWANTS_CHARS			= 0x00040000,

			wxDEFAULT_FRAME			= wxSYSTEM_MENU | wxRESIZE_BORDER |
									wxMINIMIZE_BOX | wxMAXIMIZE_BOX | wxCAPTION |
									wxCLIP_CHILDREN | wxCLOSE_BOX,
			wxDEFAULT_FRAME_STYLE		= wxDEFAULT_FRAME,

			wxDEFAULT_DIALOG_STYLE		= wxSYSTEM_MENU | wxCAPTION | wxCLOSE_BOX,
		}

		private static int uniqueID			= 10000; // start with 10000 to not interfere with the old id system

		//---------------------------------------------------------------------

		public const Point wxDefaultPosition = {X:-1, Y:-1};
		public const Size  wxDefaultSize     = {Width:-1, Height:-1};
		const string wxPanelNameStr = "panel";

		//---------------------------------------------------------------------

		public this(Window parent, int id, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=0, string name=wxPanelNameStr);
		public this(Window parent, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=0, string name=wxPanelNameStr);
		public this(IntPtr wxobj) ;
		private this(IntPtr wxobj, bool memOwn);
		static wxObject New(IntPtr ptr);
		public /+virtual+/ void   BackgroundColour(Colour value);
		public /+virtual+/ Colour BackgroundColour();
		public /+virtual+/ Colour ForegroundColour();
		public /+virtual+/ void   ForegroundColour(Colour value);
		public /+virtual+/ void font(Font value);
		public /+virtual+/ Font font();
		public /+virtual+/ Size BestSize();
		public /+virtual+/ Size ClientSize();
		public /+virtual+/ void ClientSize(Size value);
		public /+virtual+/ bool Close();
		public /+virtual+/ bool Close(bool force);
		public /+virtual+/ int ID() ;
		public /+virtual+/ void ID(int value) ;
		public static int UniqueID();
		public /+virtual+/ void Layout();
		public /+virtual+/ void cursor(Cursor value);
		public /+virtual+/ void SetSize(int x, int y, int width, int height);
		public /+virtual+/ void SetSize(int width, int height);
		public /+virtual+/ void SetSize(Size size);
		public /+virtual+/ void SetSize(Rectangle rect);
		public /+virtual+/ void SetSizer(Sizer sizer, bool deleteOld=true);
		public /+virtual+/ bool Show(bool show=true);
		public /+virtual+/ int  StyleFlags();
		public /+virtual+/ void StyleFlags(uint value) ;
		private void OnTransferDataFromWindow(Object sender, Event e);
		private void OnTransferDataToWindow(Object sender, Event e);
		public /+virtual+/ void toolTip(string value);
		public /+virtual+/ void Enabled(bool value);
		public /+virtual+/ bool Enabled();
		public /+virtual+/ bool Destroy();
		public /+virtual+/ bool DestroyChildren();
		public /+virtual+/ void  Title(string value);
		public /+virtual+/ string Title();
		public /+virtual+/ void Name(string value);
		public /+virtual+/ string Name();
		public static int NewControlId();
		public static int NextControlId(int id);
		public static int PrevControlId(int id);
		public /+virtual+/ void Move(int x, int y, int flags);
		public /+virtual+/ void Raise();
		public /+virtual+/ void Lower();
		public /+virtual+/ Point Position();
		public /+virtual+/ void  Position(Point value);
		public /+virtual+/ Size size();
		public /+virtual+/ void size(Size value);
		public /+virtual+/ Rectangle Rect();
		public /+virtual+/ Point ClientAreaOrigin();
		public /+virtual+/ Rectangle ClientRect();
		public /+virtual+/ Size AdjustedBestSize();
		public /+virtual+/ void Centre();
		public /+virtual+/ void Center();
		public /+virtual+/ void Centre(int direction);
		public /+virtual+/ void Center(int direction);
		public /+virtual+/ void CentreOnScreen();
		public /+virtual+/ void CenterOnScreen();
		public /+virtual+/ void CentreOnScreen(int direction);
		public /+virtual+/ void CenterOnScreen(int direction);
		public /+virtual+/ void CentreOnParent();
		public /+virtual+/ void CenterOnParent();
		public /+virtual+/ void CentreOnParent(int direction);
		public /+virtual+/ void CenterOnParent(int direction);
		public /+virtual+/ void Fit();
		public /+virtual+/ void FitInside();
		public /+virtual+/ void SetSizeHints(int minW, int minH);
		public /+virtual+/ void SetSizeHints(int minW, int minH, int maxW, int maxH);
		public /+virtual+/ void SetSizeHints(int minW, int minH, int maxW, int maxH, int incW, int incH);
		public /+virtual+/ void SetVirtualSizeHints(int minW, int minH, int maxW, int maxH);
		public /+virtual+/ int MinWidth();
		public /+virtual+/ int MinHeight();
		public /+virtual+/ int MaxWidth();
		public /+virtual+/ int MaxHeight();
		public /+virtual+/ Size MinSize();
		public void MinSize(Size size);
		public /+virtual+/ Size MaxSize();
		public void MaxSize(Size size);
		public /+virtual+/ Size VirtualSize();
		public /+virtual+/ void  VirtualSize(Size value);
		public /+virtual+/ Size BestVirtualSize();
		public /+virtual+/ bool Hide();
		public /+virtual+/ bool Disable();
		public /+virtual+/ bool IsShown();
		public /+virtual+/ int WindowStyle();
		public /+virtual+/ void WindowStyle(uint value);
		public /+virtual+/ bool HasFlag(int flag);
		public /+virtual+/ bool IsRetained();
		public /+virtual+/ int ExtraStyle();
		public /+virtual+/ void ExtraStyle(uint value);
		public void MakeModal(bool value);
		public bool ThemeEnabled();
		public void ThemeEnabled(bool value);
		public /+virtual+/ void SetFocus();
		public /+virtual+/ void SetFocusFromKbd();
		public static Window FindFocus();
		public /+virtual+/ bool AcceptsFocus();
		public /+virtual+/ bool AcceptsFocusFromKeyboard();
		public /+virtual+/ Window Parent();
		public /+virtual+/ void Parent(Window value);
		public /+virtual+/ Window GrandParent();
		public /+virtual+/ bool Reparent(Window newParent);
		public /+virtual+/ bool IsTopLevel();
		public /+virtual+/ void AddChild(Window child);
		public /+virtual+/ void RemoveChild(Window child);
		public /+virtual+/ Window FindWindow(int id);
		public /+virtual+/ Window FindWindow(int id, newfunc func);
		public /+virtual+/ Window FindWindow(string name);
		public static Window FindWindowById(int id, Window parent);
		public static Window FindWindowByName(string name, Window parent);
		public static Window FindWindowByLabel(string label, Window parent);
		public EvtHandler EventHandler();
		public void EventHandler(EvtHandler value);
		public void PushEventHandler(EvtHandler handler);
		public EvtHandler PopEventHandler(bool deleteHandler);
		public bool RemoveEventHandler(EvtHandler handler);
		public /+virtual+/ Validator validator();
		public /+virtual+/ void validator(Validator value);
		public /+virtual+/ bool Validate();
		public /+virtual+/ bool TransferDataToWindow();
		public /+virtual+/ bool TransferDataFromWindow();
		public /+virtual+/ void InitDialog();
		public /+virtual+/ Point ConvertPixelsToDialog(Point pt);
		public /+virtual+/ Point ConvertDialogToPixels(Point pt);
		public /+virtual+/ Size ConvertPixelsToDialog(Size sz);
		public /+virtual+/ Size ConvertDialogToPixels(Size sz);
		public /+virtual+/ void WarpPointer(int x, int y);
		public /+virtual+/ void CaptureMouse();
		public /+virtual+/ void ReleaseMouse();
		public static Window GetCapture();
		public /+virtual+/ bool HasCapture();
		public /+virtual+/ void Refresh();
		public /+virtual+/ void Refresh(bool eraseBackground);
		public /+virtual+/ void Refresh(bool eraseBackground, Rectangle rect);
		public /+virtual+/ void RefreshRectangle(Rectangle rect);
		public /+virtual+/ void Update();
		public /+virtual+/ void ClearBackground();
		public /+virtual+/ void Freeze();
		public /+virtual+/ void Thaw();
		public /+virtual+/ void PrepareDC(DC dc);
		public /+virtual+/ bool  IsExposed(int x, int y, int w, int h);
		public /+virtual+/ Caret caret();
		public /+virtual+/ void caret(Caret value);
		public /+virtual+/ int CharHeight();
		public /+virtual+/ int CharWidth();
		public void GetTextExtent(string str, out int x, out int y, out int descent,
								  out int externalLeading, Font font);
		public void ClientToScreen(inout int x, inout int y);
		public Point ClientToScreen(Point clientPoint);
		public /+virtual+/ void ScreenToClient(inout int x, inout int y);
		public Point ScreenToClient(Point screenPoint);
		public /+virtual+/ void UpdateWindowUI();
		public /+virtual+/ bool PopupMenu(Menu menu, Point pos);
		public /+virtual+/ bool HasScrollbar(int orient);
		public /+virtual+/ void SetScrollbar(int orient, int pos, int thumbSize, int range, bool refresh);
		public /+virtual+/ void SetScrollPos(int orient, int pos, bool refresh);
		public /+virtual+/ int GetScrollPos(int orient);
		public /+virtual+/ int GetScrollThumb(int orient);
		public /+virtual+/ int GetScrollRange(int orient);
		public /+virtual+/ void ScrollWindow(int dx, int dy, Rectangle rect);
		public /+virtual+/ bool ScrollLines(int lines);
		public /+virtual+/ bool ScrollPages(int pages);
		public /+virtual+/ bool LineUp();
		public /+virtual+/ bool LineDown();
		public /+virtual+/ bool PageUp();
		public /+virtual+/ bool PageDown();
		public /+virtual+/ string HelpText();
		public /+virtual+/ void HelpText(string value);
		public /+virtual+/ void SetHelpTextForId(string text);
		//public /+virtual+/ DropTarget dropTarget();
		public /+virtual+/ void dropTarget(DropTarget value);
		public /+virtual+/ bool AutoLayout();
		public /+virtual+/ void AutoLayout(bool value);
		public /+virtual+/ void SetSizerAndFit(Sizer sizer, bool deleteOld);
		public /+virtual+/ Sizer sizer();
		public /+virtual+/ void  sizer(Sizer value);
		public /+virtual+/ Sizer ContainingSizer();
		public /+virtual+/ void  ContainingSizer(Sizer value);
		public /+virtual+/ Palette palette();
		public /+virtual+/ void palette(Palette value);
		public /+virtual+/ bool HasCustomPalette();
		public /+virtual+/ Region UpdateRegion();
		public /+virtual+/ int Top() ;
		public /+virtual+/ void Top(int value);
		public /+virtual+/ int Left();
		public /+virtual+/ void Left(int value);
		public /+virtual+/ int Right() ;
		public /+virtual+/ void Right( int value) ;
		public /+virtual+/ int Bottom();
		public /+virtual+/ void Bottom(int value) ;
		public /+virtual+/ int Width() ;
		public /+virtual+/ void Width(int value) ;
		public /+virtual+/ int Height() ;
		public /+virtual+/ void Height(int value) ;
		public WindowVariant windowVariant() ;
		public bool IsBeingDeleted();
		public void CacheBestSize(Size size);
		public void InvalidateBestSize();
		public Size BestFittingSize();
		public void BestFittingSize(Size value);
		public Window[] Children();
		public AcceleratorTable acceleratorTable() ;
		public /+virtual+/ VisualAttributes DefaultAttributes();
		public static VisualAttributes ClassDefaultAttributes();
		public static VisualAttributes ClassDefaultAttributes(WindowVariant variant);
		public /+virtual+/ BackgroundStyle backgroundStyle();
		public /+virtual+/ void backgroundStyle(BackgroundStyle value);
		public Border border() ;
		public Border BorderByFlags(uint flags);
		public Window AncestorWithCustomPalette() ;
		public /+virtual+/ void InheritAttributes();
		public /+virtual+/ bool ShouldInheritColours();
		public void LeftUp_Add(EventListener value) ;
		public void LeftUp_Remove(EventListener value) ;
		public void RightUp_Add(EventListener value);
		public void RightUp_Remove(EventListener value) ;
		public void MiddleUp_Add(EventListener value) ;
		public void MiddleUp_Remove(EventListener value) ;
		public void LeftDown_Add(EventListener value);
		public void LeftDown_Remove(EventListener value) ;
		public void MiddleDown_Add(EventListener value);
		public void MiddleDown_Remove(EventListener value) ;
		public void RightDown_Add(EventListener value);
		public void RightDown_Remove(EventListener value) ;
		public void LeftDoubleClick_Add(EventListener value) ;
		public void LeftDoubleClick_Remove(EventListener value) ;
		public void RightDoubleClick_Add(EventListener value);
		public void RightDoubleClick_Remove(EventListener value) ;
		public void MiddleDoubleClick_Add(EventListener value);
		public void MiddleDoubleClick_Remove(EventListener value);
		public void MouseMove_Add(EventListener value);
		public void MouseMove_Remove(EventListener value) ;
		public void MouseThumbTrack_Add(EventListener value) ;
		public void MouseThumbTrack_Remove(EventListener value) ;
		public void MouseEnter_Add(EventListener value);
		public void MouseEnter_Remove(EventListener value) ;
		public void MouseLeave_Add(EventListener value);
		public void MouseLeave_Remove(EventListener value) ;
		public void ScrollLineUp_Add(EventListener value) ;
		public void ScrollLineUp_Remove(EventListener value) ;
		public void ScrollLineDown_Add(EventListener value) ;
		public void ScrollLineDown_Remove(EventListener value) ;
		public void UpdateUI_Add(EventListener value) ;
		public void UpdateUI_Remove(EventListener value) ;
		public void KeyDown_Add(EventListener value);
		public void KeyDown_Remove(EventListener value);
		public void KeyUp_Add(EventListener value);
		public void KeyUp_Remove(EventListener value) ;
		public void Char_Add(EventListener value) ;
		public void Char_Remove(EventListener value);
		public void Closing_Add(EventListener value) ;
		public void Closing_Remove(EventListener value);
		public void Activated_Add(EventListener value) ;
		public void Activated_Remove(EventListener value) ;
		public void Moved_Add(EventListener value);
		public void Moved_Remove(EventListener value) ;
		public void Resized_Add(EventListener value) ;
		public void Resized_Remove(EventListener value) ;
	}

