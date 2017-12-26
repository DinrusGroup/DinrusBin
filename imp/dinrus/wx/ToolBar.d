module wx.ToolBar;
public import wx.common;
public import wx.Bitmap;
public import wx.Control;
public import wx.ClientData;

		//! \cond EXTERN
		static extern (C) IntPtr wxToolBarToolBase_ctor(IntPtr tbar, int toolid, string label, IntPtr bmpNormal, IntPtr bmpDisabled, int kind, IntPtr clientData, string shortHelpString, string longHelpString);
		static extern (C) IntPtr wxToolBarToolBase_ctorCtrl(IntPtr tbar, IntPtr control);
		static extern (C) int    wxToolBarToolBase_GetId(IntPtr self);
		static extern (C) IntPtr wxToolBarToolBase_GetControl(IntPtr self);
		static extern (C) IntPtr wxToolBarToolBase_GetToolBar(IntPtr self);
		static extern (C) bool   wxToolBarToolBase_IsButton(IntPtr self);
		static extern (C) bool   wxToolBarToolBase_IsControl(IntPtr self);
		static extern (C) bool   wxToolBarToolBase_IsSeparator(IntPtr self);
		static extern (C) int    wxToolBarToolBase_GetStyle(IntPtr self);
		static extern (C) int    wxToolBarToolBase_GetKind(IntPtr self);
		static extern (C) bool   wxToolBarToolBase_IsEnabled(IntPtr self);
		static extern (C) bool   wxToolBarToolBase_IsToggled(IntPtr self);
		static extern (C) bool   wxToolBarToolBase_CanBeToggled(IntPtr self);
		static extern (C) IntPtr wxToolBarToolBase_GetLabel(IntPtr self);
		static extern (C) IntPtr wxToolBarToolBase_GetShortHelp(IntPtr self);
		static extern (C) IntPtr wxToolBarToolBase_GetLongHelp(IntPtr self);
		static extern (C) IntPtr wxToolBarToolBase_GetClientData(IntPtr self);
		static extern (C) bool   wxToolBarToolBase_Enable(IntPtr self, bool enable);
		static extern (C) bool   wxToolBarToolBase_Toggle(IntPtr self, bool toggle);
		static extern (C) bool   wxToolBarToolBase_SetToggle(IntPtr self, bool toggle);
		static extern (C) bool   wxToolBarToolBase_SetShortHelp(IntPtr self, string help);
		static extern (C) bool   wxToolBarToolBase_SetLongHelp(IntPtr self, string help);
		static extern (C) void   wxToolBarToolBase_Toggle(IntPtr self);
		static extern (C) void   wxToolBarToolBase_SetNormalBitmap(IntPtr self, IntPtr bmp);
		static extern (C) void   wxToolBarToolBase_SetDisabledBitmap(IntPtr self, IntPtr bmp);
		static extern (C) void   wxToolBarToolBase_SetLabel(IntPtr self, string label);
		static extern (C) void   wxToolBarToolBase_SetClientData(IntPtr self, IntPtr clientData);
		static extern (C) void   wxToolBarToolBase_Detach(IntPtr self);
		static extern (C) void   wxToolBarToolBase_Attach(IntPtr self, IntPtr tbar);
		//! \endcond

       //---------------------------------------------------------------------
        
	alias ToolBarTool wxToolBarTool;
	public class ToolBarTool : wxObject
	{
        public this(IntPtr wxobj);
        public this(ToolBar tbar = null, int toolid = wxID_SEPARATOR, string label = "", Bitmap bmpNormal = Bitmap.wxNullBitmap, Bitmap bmpDisabled = Bitmap.wxNullBitmap, ItemKind kind = ItemKind.wxITEM_NORMAL, ClientData clientData = null, string shortHelpString = "", string longHelpString = "");
        public this(ToolBar tbar, Control control);
	public static wxObject New(IntPtr ptr);
		public int ID() ;
		public Control control() ;
		public ToolBar toolBar() ;
		public bool IsButton() ;
		bool IsControl() ;
		bool IsSeparator() ;
		public int Style() ;
		public ItemKind Kind() ;
		bool CanBeToggled();
		public string Label() ;
		public void Label(string value) ;
		public string ShortHelp() ;
		public void ShortHelp(string value) ;
		public string LongHelp() ;
		public void LongHelp(string value) ;
		public ClientData clientData();
		public void clientData(ClientData value) ;
		public void Enabled(bool value) ;
		public bool Enabled() ;
		public void Toggled(bool value) ;
		public bool Toggled() ;
		public void NormalBitmap(Bitmap value) ;
		public void DisabledBitmap(Bitmap value) ;
		void Detach();
		void Attach(ToolBar tbar);
	}

		//! \cond EXTERN
		static extern (C) IntPtr wxToolBar_ctor(IntPtr parent, int id, inout Point pos, inout Size size, uint style);
		static extern (C) IntPtr wxToolBar_AddTool1(IntPtr self, int toolid, string label, IntPtr bitmap, IntPtr bmpDisabled, int kind, string shortHelp, string longHelp, IntPtr data);
		static extern (C) IntPtr wxToolBar_AddTool2(IntPtr self, int toolid, string label, IntPtr bitmap, string shortHelp, int kind);
		static extern (C) IntPtr wxToolBar_AddCheckTool(IntPtr self, int toolid, string label, IntPtr bitmap, IntPtr bmpDisabled, string shortHelp, string longHelp, IntPtr data);
		static extern (C) IntPtr wxToolBar_AddRadioTool(IntPtr self, int toolid, string label, IntPtr bitmap, IntPtr bmpDisabled, string shortHelp, string longHelp, IntPtr data);
		static extern (C) IntPtr wxToolBar_AddControl(IntPtr self, IntPtr control);
		static extern (C) IntPtr wxToolBar_InsertControl(IntPtr self, int pos, IntPtr control);
		static extern (C) IntPtr wxToolBar_FindControl(IntPtr self, int toolid);
		static extern (C) IntPtr wxToolBar_AddSeparator(IntPtr self);
		static extern (C) IntPtr wxToolBar_InsertSeparator(IntPtr self, int pos);
		static extern (C) IntPtr wxToolBar_RemoveTool(IntPtr self, int toolid);
		static extern (C) bool   wxToolBar_DeleteToolByPos(IntPtr self, int pos);
		static extern (C) bool   wxToolBar_DeleteTool(IntPtr self, int toolid);
		static extern (C) void   wxToolBar_ClearTools(IntPtr self);
		static extern (C) bool   wxToolBar_Realize(IntPtr self);
		static extern (C) void   wxToolBar_EnableTool(IntPtr self, int toolid, bool enable);
		static extern (C) void   wxToolBar_ToggleTool(IntPtr self, int toolid, bool toggle);
		static extern (C) IntPtr wxToolBar_GetToolClientData(IntPtr self, int toolid);
		static extern (C) void   wxToolBar_SetToolClientData(IntPtr self, int toolid, IntPtr clientData);
		static extern (C) bool   wxToolBar_GetToolState(IntPtr self, int toolid);
		static extern (C) bool   wxToolBar_GetToolEnabled(IntPtr self, int toolid);
		static extern (C) void   wxToolBar_SetToolShortHelp(IntPtr self, int toolid, string helpString);
		static extern (C) IntPtr wxToolBar_GetToolShortHelp(IntPtr self, int toolid);
		static extern (C) void   wxToolBar_SetToolLongHelp(IntPtr self, int toolid, string helpString);
		static extern (C) IntPtr wxToolBar_GetToolLongHelp(IntPtr self, int toolid);
		static extern (C) void   wxToolBar_SetMargins(IntPtr self, int x, int y);
		static extern (C) void   wxToolBar_SetToolPacking(IntPtr self, int packing);
		static extern (C) void   wxToolBar_SetToolSeparation(IntPtr self, int separation);
		static extern (C) void   wxToolBar_GetToolMargins(IntPtr self, inout Size size);
		static extern (C) int    wxToolBar_GetToolPacking(IntPtr self);
		static extern (C) int    wxToolBar_GetToolSeparation(IntPtr self);
		static extern (C) void   wxToolBar_SetRows(IntPtr self, int nRows);
		static extern (C) void   wxToolBar_SetMaxRowsCols(IntPtr self, int rows, int cols);
		static extern (C) int    wxToolBar_GetMaxRows(IntPtr self);
		static extern (C) int    wxToolBar_GetMaxCols(IntPtr self);
		static extern (C) void   wxToolBar_SetToolBitmapSize(IntPtr self, inout Size size);
		static extern (C) void   wxToolBar_GetToolBitmapSize(IntPtr self, inout Size size);
		static extern (C) void   wxToolBar_GetToolSize(IntPtr self, inout Size size);
		static extern (C) IntPtr wxToolBar_FindToolForPosition(IntPtr self, int x, int y);
		static extern (C) bool   wxToolBar_IsVertical(IntPtr self);
		static extern (C) IntPtr wxToolBar_AddTool3(IntPtr self, int toolid, IntPtr bitmap, IntPtr bmpDisabled, bool toggle, IntPtr clientData, string shortHelpString, string longHelpString);
		static extern (C) IntPtr wxToolBar_AddTool4(IntPtr self, int toolid, IntPtr bitmap, string shortHelpString, string longHelpString);
		static extern (C) IntPtr wxToolBar_AddTool5(IntPtr self, int toolid, IntPtr bitmap, IntPtr bmpDisabled, bool toggle, int xPos, int yPos, IntPtr clientData, string shortHelp, string longHelp);
		static extern (C) IntPtr wxToolBar_InsertTool(IntPtr self, int pos, int toolid, IntPtr bitmap, IntPtr bmpDisabled, bool toggle, IntPtr clientData, string shortHelp, string longHelp);
		static extern (C) bool   wxToolBar_AcceptsFocus(IntPtr self);
		//! \endcond

        //---------------------------------------------------------------------

	alias ToolBar wxToolBar;
	public class ToolBar : Control
	{
		enum {
			wxTB_HORIZONTAL   = Orientation.wxHORIZONTAL,
			wxTB_VERTICAL     = Orientation.wxVERTICAL,
			wxTB_3DBUTTONS    = 0x0010,
			wxTB_FLAT         = 0x0020,
			wxTB_DOCKABLE     = 0x0040,
			wxTB_NOICONS      = 0x0080,
			wxTB_TEXT         = 0x0100,
			wxTB_NODIVIDER    = 0x0200,
			wxTB_NOALIGN      = 0x0400,
			wxTB_HORZ_LAYOUT  = 0x0800,
			wxTB_HORZ_TEXT    = wxTB_HORZ_LAYOUT | wxTB_TEXT
		}
	
		//---------------------------------------------------------------------

        public this(IntPtr wxobj) ;
        public this(Window parent, int id, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxNO_BORDER|wxTB_HORIZONTAL);
        public this(Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxNO_BORDER|wxTB_HORIZONTAL);
        public ToolBarTool AddTool(int toolid, string label, Bitmap bitmap);
        public ToolBarTool AddTool(int toolid, string label, Bitmap bitmap, Bitmap bmpDisabled, ItemKind kind, string shortHelp, string longHelp, ClientData clientData);
        public ToolBarTool AddTool(int toolid, string label, Bitmap bitmap, string shortHelp, ItemKind kind = ItemKind.wxITEM_NORMAL);
        public ToolBarTool AddTool(int toolid, Bitmap bitmap, Bitmap bmpDisabled, bool toggle, ClientData clientData, string shortHelpString, string longHelpString);
        public ToolBarTool AddTool(int toolid, Bitmap bitmap, string shortHelpString);
        public ToolBarTool AddTool(int toolid, Bitmap bitmap, string shortHelpString, string longHelpString);
        public ToolBarTool AddTool(int toolid, Bitmap bitmap, Bitmap bmpDisabled, bool toggle, int xPos, int yPos, ClientData clientData, string shortHelp, string longHelp);
        public ToolBarTool InsertTool(int pos, int toolid, Bitmap bitmap, Bitmap bmpDisabled, bool toggle, ClientData clientData, string shortHelp, string longHelp);
        public ToolBarTool AddCheckTool(int toolid, string label, Bitmap bitmap, Bitmap bmpDisabled, string shortHelp, string longHelp);
        public ToolBarTool AddRadioTool(int toolid, string label, Bitmap bitmap, Bitmap bmpDisabled, string shortHelp, string longHelp);
        public ToolBarTool AddControl(Control ctrl);
        public ToolBarTool InsertControl(int pos, Control ctrl);
        public ToolBarTool FindControl(int toolid);
        public ToolBarTool AddSeparator();
        public ToolBarTool InsertSeparator(int pos);
        public ToolBarTool RemoveTool(int toolid);
        public bool DeleteToolByPos(int pos);
        public bool DeleteTool(int toolid);
        public void ClearTools();
        public bool Realize();
        public void EnableTool(int toolid, bool enable);
        public void ToggleTool(int toolid, bool toggle);
        public void SetToolClientData(int toolid, ClientData clientData);
        public ClientData GetToolClientData(int toolid);
        public bool GetToolState(int toolid);
        public bool GetToolEnable(int toolid);
        public string GetToolShortHelp(int toolid);
        public void SetToolShortHelp(int toolid, string helpString);
        public string GetToolLongHelp(int toolid);
        public void SetToolLongHelp(int toolid, string helpString);
        public void SetMargins(int x, int y) ;
        public Size Margins();
        public void Margins(Size value) ;
        public int ToolPacking() ;
        public void ToolPacking(int value);
        public int Separation() ;
        public void Separation(int value) ;
        public void Rows(int value) ;
        public int MaxRows() ;
        public int MaxCols() ;
        public void SetMaxRowsCols(int rows, int cols);
        public Size ToolBitmapSize() ;
        public void ToolBitmapSize(Size value) ;
        public Size ToolSize() ;
        public ToolBarTool FindToolForPosition(int x, int y);
        public bool IsVertical();
        public override bool AcceptsFocus();

	}

