
module wx.Grid;
public import wx.common;
public import wx.Event;
public import wx.KeyEvent;
public import wx.CommandEvent;
public import wx.Window;
public import wx.Control;
public import wx.ScrolledWindow;

    public enum GridSelectionMode
    {
        wxGridSelectCells,
        wxGridSelectRows,
        wxGridSelectColumns
    }

		//! \cond EXTERN
        static extern (C) IntPtr wxGridEvent_ctor(int id, int type, IntPtr obj, int row, int col, int x, int y, bool sel, bool control, bool shift, bool alt, bool meta);
        static extern (C) int    wxGridEvent_GetRow(IntPtr self);
        static extern (C) int    wxGridEvent_GetCol(IntPtr self);
        static extern (C) void   wxGridEvent_GetPosition(IntPtr self, inout Point pt);
        static extern (C) bool   wxGridEvent_Selecting(IntPtr self);
        static extern (C) bool   wxGridEvent_ControlDown(IntPtr self);
        static extern (C) bool   wxGridEvent_MetaDown(IntPtr self);
        static extern (C) bool   wxGridEvent_ShiftDown(IntPtr self);
        static extern (C) bool   wxGridEvent_AltDown(IntPtr self);
        static extern (C) void wxGridEvent_Veto(IntPtr self);
        static extern (C) void wxGridEvent_Allow(IntPtr self);
        static extern (C) bool wxGridEvent_IsAllowed(IntPtr self);      
		//! \endcond

        //-----------------------------------------------------------------------------

    alias GridEvent wxGridEvent;
    public class GridEvent : Event 
    {
        public this(IntPtr wxobj);
        public this(int id, int type, wxObject obj, int row, int col, int x, int y, bool sel, bool control, bool shift, bool alt, bool meta);
        public int Row() ;
        public int Col();
        public Point Position() ;
        public bool Selecting() ;
        public bool ControlDown();
        public bool MetaDown();
        public bool ShiftDown() ;
            public bool AltDown() ;
        public void Veto();
        public void Allow();
        public bool Allowed();
	private static Event New(IntPtr obj) ;
	static this()
	{
			wxEVT_GRID_CELL_LEFT_CLICK = wxEvent_EVT_GRID_CELL_LEFT_CLICK();
			wxEVT_GRID_CELL_RIGHT_CLICK = wxEvent_EVT_GRID_CELL_RIGHT_CLICK();
			wxEVT_GRID_CELL_LEFT_DCLICK = wxEvent_EVT_GRID_CELL_LEFT_DCLICK();
			wxEVT_GRID_CELL_RIGHT_DCLICK = wxEvent_EVT_GRID_CELL_RIGHT_DCLICK();
			wxEVT_GRID_LABEL_LEFT_CLICK = wxEvent_EVT_GRID_LABEL_LEFT_CLICK();
			wxEVT_GRID_LABEL_RIGHT_CLICK = wxEvent_EVT_GRID_LABEL_RIGHT_CLICK();
			wxEVT_GRID_LABEL_LEFT_DCLICK = wxEvent_EVT_GRID_LABEL_LEFT_DCLICK();
			wxEVT_GRID_LABEL_RIGHT_DCLICK = wxEvent_EVT_GRID_LABEL_RIGHT_DCLICK();
			wxEVT_GRID_CELL_CHANGE = wxEvent_EVT_GRID_CELL_CHANGE();
			wxEVT_GRID_SELECT_CELL = wxEvent_EVT_GRID_SELECT_CELL();
			wxEVT_GRID_EDITOR_SHOWN = wxEvent_EVT_GRID_EDITOR_SHOWN();
			wxEVT_GRID_EDITOR_HIDDEN = wxEvent_EVT_GRID_EDITOR_HIDDEN();
			wxEVT_GRID_EDITOR_CREATED = wxEvent_EVT_GRID_EDITOR_CREATED();

			AddEventType(wxEVT_GRID_CELL_LEFT_CLICK,            &GridEvent.New);
			AddEventType(wxEVT_GRID_CELL_RIGHT_CLICK,           &GridEvent.New);
			AddEventType(wxEVT_GRID_CELL_LEFT_DCLICK,           &GridEvent.New);
			AddEventType(wxEVT_GRID_CELL_RIGHT_DCLICK,          &GridEvent.New);
			AddEventType(wxEVT_GRID_LABEL_LEFT_CLICK,           &GridEvent.New);
			AddEventType(wxEVT_GRID_LABEL_RIGHT_CLICK,          &GridEvent.New);
			AddEventType(wxEVT_GRID_LABEL_LEFT_DCLICK,          &GridEvent.New);
			AddEventType(wxEVT_GRID_LABEL_RIGHT_DCLICK,         &GridEvent.New);
			AddEventType(wxEVT_GRID_CELL_CHANGE,                &GridEvent.New);
			AddEventType(wxEVT_GRID_SELECT_CELL,                &GridEvent.New);
			AddEventType(wxEVT_GRID_EDITOR_SHOWN,               &GridEvent.New);
			AddEventType(wxEVT_GRID_EDITOR_HIDDEN,              &GridEvent.New);
	}
    }
    
    //-----------------------------------------------------------------------------

		//! \cond EXTERN
	extern (C) {
        alias void   function(GridCellEditor obj, IntPtr parent, int id, IntPtr evtHandler) Virtual_Create;
        alias void   function(GridCellEditor obj, int row, int col, IntPtr grid) Virtual_BeginEdit;
        alias bool   function(GridCellEditor obj, int row, int col, IntPtr grid) Virtual_EndEdit;
        alias void   function(GridCellEditor obj) Virtual_Reset;
        alias IntPtr function(GridCellEditor obj) Virtual_Clone;
        alias void   function(GridCellEditor obj, Rectangle rect) Virtual_SetSize;
        alias void   function(GridCellEditor obj, bool show, IntPtr attr) Virtual_Show;
        alias void   function(GridCellEditor obj, Rectangle rect, IntPtr attr) Virtual_PaintBackground;
        alias bool   function(GridCellEditor obj, IntPtr evt) Virtual_IsAcceptedKey;
        alias void   function(GridCellEditor obj, IntPtr evt) Virtual_StartingKey;
        alias void   function(GridCellEditor obj) Virtual_StartingClick;
        alias void   function(GridCellEditor obj, IntPtr evt) Virtual_HandleReturn;
        alias void   function(GridCellEditor obj) Virtual_Destroy;
        alias string function(GridCellEditor obj) Virtual_GetValue;
	}

        static extern (C) IntPtr wxGridCellEditor_ctor();
	static extern (C) void wxGridCellEditor_dtor(IntPtr self);
        static extern (C) void wxGridCellEditor_RegisterVirtual(IntPtr self, GridCellEditor obj,
            Virtual_Create create, 
            Virtual_BeginEdit beginEdit, 
            Virtual_EndEdit endEdit, 
            Virtual_Reset reset, 
            Virtual_Clone clone,
            Virtual_SetSize setSize,
            Virtual_Show show,
            Virtual_PaintBackground paintBackground,
            Virtual_IsAcceptedKey isAcceptedKey,
            Virtual_StartingKey startingKey,
            Virtual_StartingClick startingClick,
            Virtual_HandleReturn handleReturn,
            Virtual_Destroy destroy,
            Virtual_GetValue getvalue);
        static extern (C) bool   wxGridCellEditor_IsCreated(IntPtr self);
        static extern (C) void   wxGridCellEditor_SetSize(IntPtr self, inout Rectangle rect);
        static extern (C) void   wxGridCellEditor_Show(IntPtr self, bool show, IntPtr attr);
        static extern (C) void   wxGridCellEditor_PaintBackground(IntPtr self, inout Rectangle rectCell, IntPtr attr);
        static extern (C) bool   wxGridCellEditor_IsAcceptedKey(IntPtr self, IntPtr evt);
        static extern (C) void   wxGridCellEditor_StartingKey(IntPtr self, IntPtr evt);
        static extern (C) void   wxGridCellEditor_StartingClick(IntPtr self);
        static extern (C) void   wxGridCellEditor_HandleReturn(IntPtr self, IntPtr evt);
        static extern (C) void   wxGridCellEditor_Destroy(IntPtr self);
        static extern (C) IntPtr wxGridCellEditor_GetValue(IntPtr self);
		//! \endcond
	
        //-----------------------------------------------------------------------------
        
    public abstract class GridCellEditor : GridCellWorker
    {
        public this(IntPtr wxobj);
    	private this(IntPtr wxobj, bool memOwn);
        public this();
        //	public static wxObject New(IntPtr ptr) ;
	   override protected void dtor();
        public bool IsCreated();
        static extern(C) private void staticDoCreate(GridCellEditor obj, IntPtr parent, int id, IntPtr evtHandler);
        public abstract void Create(Window parent, int id, EvtHandler evtHandler);
        static extern(C) private void staticSetSize(GridCellEditor obj, Rectangle rect);
        public /+virtual+/ void SetSize(Rectangle rect);
        static extern(C) private void staticDoShow(GridCellEditor obj, bool show, IntPtr attr);
        public /+virtual+/ void Show(bool show, GridCellAttr attr);
        static extern(C) private void staticDoPaintBackground(GridCellEditor obj, Rectangle rectCell, IntPtr attr);
        public /+virtual+/ void PaintBackground(Rectangle rectCell, GridCellAttr attr);
        static extern(C) private void staticDoBeginEdit(GridCellEditor obj, int row, int col, IntPtr grid);
        public abstract void BeginEdit(int row, int col, Grid grid);        
        static extern(C) private bool staticDoEndEdit(GridCellEditor obj, int row, int col, IntPtr grid);
        public abstract bool EndEdit(int row, int col, Grid grid);
        static extern(C) private void staticReset(GridCellEditor obj);
        public abstract void Reset();
        static extern(C) private bool staticDoIsAcceptedKey(GridCellEditor obj, IntPtr evt);
        public /+virtual+/ bool IsAcceptedKey(KeyEvent evt);
        static extern(C) private void staticDoStartingKey(GridCellEditor obj, IntPtr evt);
        public /+virtual+/ void StartingKey(KeyEvent evt);
	    static extern(C) private void staticStartingClick(GridCellEditor obj);
        public /+virtual+/ void StartingClick();
        static extern(C) private void staticDoHandleReturn(GridCellEditor obj, IntPtr evt);
        public /+virtual+/ void HandleReturn(KeyEvent evt);
	    static extern(C) private void staticDestroy(GridCellEditor obj);
        public /+virtual+/ void Destroy();
        static extern(C) private IntPtr staticDoClone(GridCellEditor obj);
        public abstract GridCellEditor Clone();
        static extern(C) private string staticGetValue(GridCellEditor obj);
        public abstract string GetValue();
    }
    
    //-----------------------------------------------------------------------------
    
		//! \cond EXTERN
        static extern (C) IntPtr wxGridCellTextEditor_ctor();
	static extern (C) void wxGridCellTextEditor_dtor(IntPtr self);
        static extern (C) void wxGridCellTextEditor_Create(IntPtr self, IntPtr parent, int id, IntPtr evtHandler);
        static extern (C) void wxGridCellTextEditor_SetSize(IntPtr self, inout Rectangle rect);
        static extern (C) void wxGridCellTextEditor_PaintBackground(IntPtr self, inout Rectangle rectCell, IntPtr attr);
        static extern (C) bool wxGridCellTextEditor_IsAcceptedKey(IntPtr self, IntPtr evt);
        static extern (C) void wxGridCellTextEditor_BeginEdit(IntPtr self, int row, int col, IntPtr grid);
        static extern (C) bool wxGridCellTextEditor_EndEdit(IntPtr self, int row, int col, IntPtr grid);
        static extern (C) void wxGridCellTextEditor_Reset(IntPtr self);
        static extern (C) void wxGridCellTextEditor_StartingKey(IntPtr self, IntPtr evt);
        static extern (C) void wxGridCellTextEditor_SetParameters(IntPtr self, string parameter);
        static extern (C) IntPtr wxGridCellTextEditor_Clone(IntPtr self);
        static extern (C) IntPtr wxGridCellTextEditor_GetValue(IntPtr self);
		//! \endcond
	
    alias GridCellTextEditor wxGridCellTextEditor;
    public class GridCellTextEditor : GridCellEditor
    {
        public this();
        public this(IntPtr wxobj);
	    private this(IntPtr wxobj, bool memOwn);
	    override protected void dtor();
        public override void Create(Window parent, int id, EvtHandler evtHandler);
        public override void SetSize(Rectangle rect);
        public override void PaintBackground(Rectangle rectCell, GridCellAttr attr);
        public override bool IsAcceptedKey(KeyEvent evt);
        public override void BeginEdit(int row, int col, Grid grid);
        public override bool EndEdit(int row, int col, Grid grid);
        public override void Reset();
        public override void StartingKey(KeyEvent evt);
        public override void SetParameters(string parameter);
        public override GridCellEditor Clone();
        public override string GetValue();
    }

    //-----------------------------------------------------------------------------

		//! \cond EXTERN
        static extern (C) IntPtr wxGridCellNumberEditor_ctor(int min, int max);
	static extern (C) void wxGridCellNumberEditor_dtor(IntPtr self);
	static extern (C) void wxGridCellNumberEditor_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
        static extern (C) void wxGridCellNumberEditor_Create(IntPtr self, IntPtr parent, int id, IntPtr evtHandler);
        static extern (C) bool wxGridCellNumberEditor_IsAcceptedKey(IntPtr self, IntPtr evt);
        static extern (C) void wxGridCellNumberEditor_BeginEdit(IntPtr self, int row, int col, IntPtr grid);
        static extern (C) bool wxGridCellNumberEditor_EndEdit(IntPtr self, int row, int col, IntPtr grid);
        static extern (C) void wxGridCellNumberEditor_Reset(IntPtr self);
        static extern (C) void wxGridCellNumberEditor_StartingKey(IntPtr self, IntPtr evt);
        static extern (C) void wxGridCellNumberEditor_SetParameters(IntPtr self, string parameter);
        static extern (C) IntPtr wxGridCellNumberEditor_Clone(IntPtr self);
        static extern (C) IntPtr wxGridCellNumberEditor_GetValue(IntPtr self);
		//! \endcond
	
    alias GridCellNumberEditor wxGridCellNumberEditor;
    public class GridCellNumberEditor : GridCellTextEditor
    {
        public this();
        public this(int min);
        public this(int min, int max);
        public this(IntPtr wxobj);
    	private this(IntPtr wxobj, bool memOwn);
	    override protected void dtor();
        public override void Create(Window parent, int id, EvtHandler evtHandler);
        public override bool IsAcceptedKey(KeyEvent evt);
        public override void BeginEdit(int row, int col, Grid grid);
        public override bool EndEdit(int row, int col, Grid grid);
        public override void Reset();
        public override void StartingKey(KeyEvent evt);
        public override void SetParameters(string parameter);
        public override GridCellEditor Clone();
        public override string GetValue();
    }

    //-----------------------------------------------------------------------------

		//! \cond EXTERN
        static extern (C) IntPtr wxGridCellFloatEditor_ctor(int width, int precision);
	static extern (C) void wxGridCellFloatEditor_dtor(IntPtr self);
        static extern (C) void wxGridCellFloatEditor_Create(IntPtr self, IntPtr parent, int id, IntPtr evtHandler);
        static extern (C) bool wxGridCellFloatEditor_IsAcceptedKey(IntPtr self, IntPtr evt);
        static extern (C) void wxGridCellFloatEditor_BeginEdit(IntPtr self, int row, int col, IntPtr grid);
        static extern (C) bool wxGridCellFloatEditor_EndEdit(IntPtr self, int row, int col, IntPtr grid);
        static extern (C) void wxGridCellFloatEditor_Reset(IntPtr self);
        static extern (C) void wxGridCellFloatEditor_StartingKey(IntPtr self, IntPtr evt);
        static extern (C) void wxGridCellFloatEditor_SetParameters(IntPtr self, string parameter);
        static extern (C) IntPtr wxGridCellFloatEditor_Clone(IntPtr self);
        static extern (C) IntPtr wxGridCellFloatEditor_GetValue(IntPtr self);
		//! \endcond
	
    alias GridCellFloatEditor wxGridCellFloatEditor;
    public class GridCellFloatEditor : GridCellTextEditor
    {
        public this();
        public this(int width);
        public this(int width, int precision);
        public this(IntPtr wxobj);
	    private this(IntPtr wxobj, bool memOwn);
	    override protected void dtor() ;
        public override void Create(Window parent, int id, EvtHandler evtHandler);
        public override bool IsAcceptedKey(KeyEvent evt);
        public override void BeginEdit(int row, int col, Grid grid);
        public override bool EndEdit(int row, int col, Grid grid);
        public override void Reset();
        public override void StartingKey(KeyEvent evt);
        public override void SetParameters(string parameter);
        public override GridCellEditor Clone();
        public override string GetValue();
    }

    //-----------------------------------------------------------------------------
    
		//! \cond EXTERN
        static extern (C) IntPtr wxGridCellBoolEditor_ctor();
	static extern (C) void wxGridCellBoolEditor_dtor(IntPtr self);
	static extern (C) void wxGridCellBoolEditor_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
        static extern (C) void wxGridCellBoolEditor_Create(IntPtr self, IntPtr parent, int id, IntPtr evtHandler);
        static extern (C) void wxGridCellBoolEditor_SetSize(IntPtr self, inout Rectangle rect);
        static extern (C) bool wxGridCellBoolEditor_IsAcceptedKey(IntPtr self, IntPtr evt);
        static extern (C) void wxGridCellBoolEditor_BeginEdit(IntPtr self, int row, int col, IntPtr grid);
        static extern (C) bool wxGridCellBoolEditor_EndEdit(IntPtr self, int row, int col, IntPtr grid);
        static extern (C) void wxGridCellBoolEditor_Reset(IntPtr self);
        static extern (C) void wxGridCellBoolEditor_StartingClick(IntPtr self);
        static extern (C) IntPtr wxGridCellBoolEditor_Clone(IntPtr self);
        static extern (C) IntPtr wxGridCellBoolEditor_GetValue(IntPtr self);
		//! \endcond
	
    alias GridCellBoolEditor wxGridCellBoolEditor;
    public class GridCellBoolEditor : GridCellEditor
    {
        public this();
        public this(IntPtr wxobj);
	    private this(IntPtr wxobj, bool memOwn);
	    override protected void dtor();
        public override void Create(Window parent, int id, EvtHandler evtHandler);
        public override void SetSize(Rectangle rect);
        public override bool IsAcceptedKey(KeyEvent evt);
        public override void BeginEdit(int row, int col, Grid grid);
        public override bool EndEdit(int row, int col, Grid grid);
        public override void Reset();
        public override void StartingClick();
        public override GridCellEditor Clone();
        public override string GetValue();
    }
    
    //-----------------------------------------------------------------------------
    
		//! \cond EXTERN
        static extern (C) IntPtr wxGridCellChoiceEditor_ctor(int n, string* choices, bool allowOthers);
	static extern (C) void wxGridCellChoiceEditor_dtor(IntPtr self);
	static extern (C) void wxGridCellChoiceEditor_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
        static extern (C) void wxGridCellChoiceEditor_Create(IntPtr self, IntPtr parent, int id, IntPtr evtHandler);
        static extern (C) void wxGridCellChoiceEditor_PaintBackground(IntPtr self, inout Rectangle rectCell, IntPtr attr);
        static extern (C) void wxGridCellChoiceEditor_BeginEdit(IntPtr self, int row, int col, IntPtr grid);
        static extern (C) bool wxGridCellChoiceEditor_EndEdit(IntPtr self, int row, int col, IntPtr grid);
        static extern (C) void wxGridCellChoiceEditor_Reset(IntPtr self);
        static extern (C) void wxGridCellChoiceEditor_SetParameters(IntPtr self, string parameter);
        static extern (C) IntPtr wxGridCellChoiceEditor_Clone(IntPtr self);
        static extern (C) IntPtr wxGridCellChoiceEditor_GetValue(IntPtr self);
		//! \endcond
	
    alias GridCellChoiceEditor wxGridCellChoiceEditor;
    public class GridCellChoiceEditor : GridCellEditor
    {
        public this();
        public this(string[] choices);
        public this(string[] choices, bool allowOthers);
        public this(IntPtr wxobj);
	private this(IntPtr wxobj, bool memOwn);
	override protected void dtor() ;
        public override void Create(Window parent, int id, EvtHandler evtHandler);
        public override void PaintBackground(Rectangle rectCell, GridCellAttr attr);
        public override void BeginEdit(int row, int col, Grid grid);
        public override bool EndEdit(int row, int col, Grid grid);
        public override void Reset();
        public override void SetParameters(string parameter);
        public override GridCellEditor Clone();
        public override string GetValue();
    }
    
    //-----------------------------------------------------------------------------

		//! \cond EXTERN
        static extern (C) IntPtr wxGridRangeSelectEvent_ctor(int id, int type, IntPtr obj, IntPtr topLeft, IntPtr bottomRight, bool sel, bool control, bool shift, bool alt, bool meta);
        static extern (C) IntPtr wxGridRangeSelectEvent_GetTopLeftCoords(IntPtr self);
        static extern (C) IntPtr wxGridRangeSelectEvent_GetBottomRightCoords(IntPtr self);
        static extern (C) int wxGridRangeSelectEvent_GetTopRow(IntPtr self);
        static extern (C) int wxGridRangeSelectEvent_GetBottomRow(IntPtr self);
        static extern (C) int wxGridRangeSelectEvent_GetLeftCol(IntPtr self);
        static extern (C) int wxGridRangeSelectEvent_GetRightCol(IntPtr self);
        static extern (C) bool wxGridRangeSelectEvent_Selecting(IntPtr self);
        static extern (C) bool wxGridRangeSelectEvent_ControlDown(IntPtr self);
        static extern (C) bool wxGridRangeSelectEvent_MetaDown(IntPtr self);
        static extern (C) bool wxGridRangeSelectEvent_ShiftDown(IntPtr self);
        static extern (C) bool wxGridRangeSelectEvent_AltDown(IntPtr self);
        static extern (C) void wxGridRangeSelectEvent_Veto(IntPtr self);
        static extern (C) void wxGridRangeSelectEvent_Allow(IntPtr self);
        static extern (C) bool wxGridRangeSelectEvent_IsAllowed(IntPtr self);       
		//! \endcond
    
        //-----------------------------------------------------------------------------
    
    alias GridRangeSelectEvent wxGridRangeSelectEvent;
    public class GridRangeSelectEvent : Event
    {
        public this(IntPtr wxobj);
        public this(int id, int type, wxObject obj, GridCellCoords topLeft, GridCellCoords bottomRight, bool sel, bool control, bool shift, bool alt, bool meta);
        public GridCellCoords TopLeftCoords() ;    
        public GridCellCoords BottomRightCoords();
        public int TopRow();
        public int BottomRow() ;
        public int LeftCol();
        public int RightCol() ;
        public bool Selecting();
        public bool ControlDown() ;
        public bool MetaDown();
        public bool ShiftDown() ;
        public bool AltDown() ;
        public void Veto();
        public void Allow();
        public bool Allowed() ;
	    private static Event New(IntPtr obj) ;
	    static this();
    }

		//! \cond EXTERN
	extern (C) {
        alias void function(GridCellWorker obj, string param) Virtual_SetParameters;
	}

        static extern (C) IntPtr wxGridCellWorker_ctor();
        static extern (C) void wxGridCellWorker_RegisterVirtual(IntPtr self, GridCellWorker obj, Virtual_SetParameters setParameters);
        static extern (C) void wxGridCellWorker_IncRef(IntPtr self);
        static extern (C) void wxGridCellWorker_DecRef(IntPtr self);
        static extern (C) void wxGridCellWorker_SetParameters(IntPtr self, string parms);
		//! \endcond
	
        //-----------------------------------------------------------------------------
        
    alias GridCellWorker wxGridCellWorker;
    public class GridCellWorker : wxObject //ClientData
    {
        public this(IntPtr wxobj) ;
    	private this(IntPtr wxobj, bool memOwn);
        public this();
	    override protected void dtor();
        public void IncRef();
        public void DecRef();
        static extern (C) private void staticDoSetParameters(GridCellWorker obj, string param);
        public /+virtual+/ void SetParameters(string param);
    }
    
    //-----------------------------------------------------------------------------

            //! \cond EXTERN
            static extern (C) IntPtr wxGridEditorCreatedEvent_ctor(int id, int type, IntPtr obj, int row, int col, IntPtr ctrl);
            static extern (C) int    wxGridEditorCreatedEvent_GetRow(IntPtr self);
            static extern (C) int    wxGridEditorCreatedEvent_GetCol(IntPtr self);
            static extern (C) IntPtr wxGridEditorCreatedEvent_GetControl(IntPtr self);
            static extern (C) void   wxGridEditorCreatedEvent_SetRow(IntPtr self, int row);
            static extern (C) void   wxGridEditorCreatedEvent_SetCol(IntPtr self, int col);
            static extern (C) void   wxGridEditorCreatedEvent_SetControl(IntPtr self, IntPtr ctrl);
            //! \endcond

            //-----------------------------------------------------------------------------
    
    alias GridEditorCreatedEvent wxGridEditorCreatedEvent;
    public class GridEditorCreatedEvent : CommandEvent 
    {
            public this(IntPtr wxobj);
            public this(int id, int type, wxObject obj, int row, int col, Control ctrl);
            public int Row() ;
            public void Row(int value);
            public int Col();
            public void Col(int value);
            public Control control();
            public void control(Control value) ;
		private static Event New(IntPtr obj) ;
		static this()
		{
			AddEventType(wxEVT_GRID_EDITOR_CREATED,             &GridEditorCreatedEvent.New);        
		}
    }
    
    //-----------------------------------------------------------------------------

            //! \cond EXTERN
            static extern (C) IntPtr wxGrid_ctor();
            static extern (C) IntPtr wxGrid_ctorFull(IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
            static extern (C) bool   wxGrid_CreateGrid(IntPtr self, int numRows, int numCols,  int selmode);
            static extern (C) void   wxGrid_SetSelectionMode(IntPtr self, int selmode);
            static extern (C) int    wxGrid_GetNumberRows(IntPtr self);
            static extern (C) int    wxGrid_GetNumberCols(IntPtr self);
            static extern (C) IntPtr wxGrid_GetTable(IntPtr self);
            static extern (C) bool   wxGrid_SetTable(IntPtr self, IntPtr table, bool takeOwnership, int select);
            static extern (C) void   wxGrid_ClearGrid(IntPtr self);
            static extern (C) bool   wxGrid_InsertRows(IntPtr self, int pos, int numRows, bool updateLabels);
            static extern (C) bool   wxGrid_AppendRows(IntPtr self, int numRows, bool updateLabels);
            static extern (C) bool   wxGrid_DeleteRows(IntPtr self, int pos, int numRows, bool updateLabels);
            static extern (C) bool   wxGrid_InsertCols(IntPtr self, int pos, int numCols, bool updateLabels);
            static extern (C) bool   wxGrid_AppendCols(IntPtr self, int numCols, bool updateLabels);
            static extern (C) bool   wxGrid_DeleteCols(IntPtr self, int pos, int numCols, bool updateLabels);
            static extern (C) void   wxGrid_BeginBatch(IntPtr self);
            static extern (C) void   wxGrid_EndBatch(IntPtr self);
            static extern (C) int    wxGrid_GetBatchCount(IntPtr self);
            static extern (C) void   wxGrid_ForceRefresh(IntPtr self);
            static extern (C) bool   wxGrid_IsEditable(IntPtr self);
            static extern (C) void   wxGrid_EnableEditing(IntPtr self, bool edit);
            static extern (C) void   wxGrid_EnableCellEditControl(IntPtr self, bool enable);
            static extern (C) void   wxGrid_DisableCellEditControl(IntPtr self);
            static extern (C) bool   wxGrid_CanEnableCellControl(IntPtr self);
            static extern (C) bool   wxGrid_IsCellEditControlEnabled(IntPtr self);
            static extern (C) bool   wxGrid_IsCellEditControlShown(IntPtr self);
            static extern (C) bool   wxGrid_IsCurrentCellReadOnly(IntPtr self);
            static extern (C) void   wxGrid_ShowCellEditControl(IntPtr self);
            static extern (C) void   wxGrid_HideCellEditControl(IntPtr self);
            static extern (C) void   wxGrid_SaveEditControlValue(IntPtr self);
            static extern (C) int    wxGrid_YToRow(IntPtr self, int y);
            static extern (C) int    wxGrid_XToCol(IntPtr self, int x);
            static extern (C) int    wxGrid_YToEdgeOfRow(IntPtr self, int y);
            static extern (C) int    wxGrid_XToEdgeOfCol(IntPtr self, int x);
            static extern (C) void   wxGrid_CellToRect(IntPtr self, int row, int col, inout Rectangle rect);
            static extern (C) int    wxGrid_GetGridCursorRow(IntPtr self);
            static extern (C) int    wxGrid_GetGridCursorCol(IntPtr self);
            static extern (C) bool   wxGrid_IsVisible(IntPtr self, int row, int col, bool wholeCellVisible);
            static extern (C) void   wxGrid_MakeCellVisible(IntPtr self, int row, int col);
            static extern (C) void   wxGrid_SetGridCursor(IntPtr self, int row, int col);
            static extern (C) bool   wxGrid_MoveCursorUp(IntPtr self, bool expandSelection);
            static extern (C) bool   wxGrid_MoveCursorDown(IntPtr self, bool expandSelection);
            static extern (C) bool   wxGrid_MoveCursorLeft(IntPtr self, bool expandSelection);
            static extern (C) bool   wxGrid_MoveCursorRight(IntPtr self, bool expandSelection);
            static extern (C) bool   wxGrid_MovePageDown(IntPtr self);
            static extern (C) bool   wxGrid_MovePageUp(IntPtr self);
            static extern (C) bool   wxGrid_MoveCursorUpBlock(IntPtr self, bool expandSelection);
            static extern (C) bool   wxGrid_MoveCursorDownBlock(IntPtr self, bool expandSelection);
            static extern (C) bool   wxGrid_MoveCursorLeftBlock(IntPtr self, bool expandSelection);
            static extern (C) bool   wxGrid_MoveCursorRightBlock(IntPtr self, bool expandSelection);
            static extern (C) int    wxGrid_GetDefaultRowLabelSize(IntPtr self);
            static extern (C) int    wxGrid_GetRowLabelSize(IntPtr self);
            static extern (C) int    wxGrid_GetDefaultColLabelSize(IntPtr self);
            static extern (C) int    wxGrid_GetColLabelSize(IntPtr self);
            static extern (C) IntPtr wxGrid_GetLabelBackgroundColour(IntPtr self);
            static extern (C) IntPtr wxGrid_GetLabelTextColour(IntPtr self);
            static extern (C) IntPtr wxGrid_GetLabelFont(IntPtr self);
            static extern (C) void   wxGrid_GetRowLabelAlignment(IntPtr self, out int horiz, out int vert);
            static extern (C) void   wxGrid_GetColLabelAlignment(IntPtr self, out int horiz, out int vert);
            static extern (C) IntPtr wxGrid_GetRowLabelValue(IntPtr self, int row);
            static extern (C) IntPtr wxGrid_GetColLabelValue(IntPtr self, int col);
            static extern (C) IntPtr wxGrid_GetGridLineColour(IntPtr self);
            static extern (C) IntPtr wxGrid_GetCellHighlightColour(IntPtr self);
            static extern (C) int    wxGrid_GetCellHighlightPenWidth(IntPtr self);
            static extern (C) int    wxGrid_GetCellHighlightROPenWidth(IntPtr self);
            static extern (C) void   wxGrid_SetRowLabelSize(IntPtr self, int width);
            static extern (C) void   wxGrid_SetColLabelSize(IntPtr self, int height);
            static extern (C) void   wxGrid_SetLabelBackgroundColour(IntPtr self, IntPtr col);
            static extern (C) void   wxGrid_SetLabelTextColour(IntPtr self, IntPtr col);
            static extern (C) void   wxGrid_SetLabelFont(IntPtr self, IntPtr fnt);
            static extern (C) void   wxGrid_SetRowLabelAlignment(IntPtr self, int horiz, int vert);
            static extern (C) void   wxGrid_SetColLabelAlignment(IntPtr self, int horiz, int vert);
            static extern (C) void   wxGrid_SetRowLabelValue(IntPtr self, int row, string val);
            static extern (C) void   wxGrid_SetColLabelValue(IntPtr self, int col, string val);
            static extern (C) void   wxGrid_SetGridLineColour(IntPtr self, IntPtr col);
            static extern (C) void   wxGrid_SetCellHighlightColour(IntPtr self, IntPtr col);
            static extern (C) void   wxGrid_SetCellHighlightPenWidth(IntPtr self, int width);
            static extern (C) void   wxGrid_SetCellHighlightROPenWidth(IntPtr self, int width);
            static extern (C) void   wxGrid_EnableDragRowSize(IntPtr self, bool enable);
            static extern (C) void   wxGrid_DisableDragRowSize(IntPtr self);
            static extern (C) bool   wxGrid_CanDragRowSize(IntPtr self);
            static extern (C) void   wxGrid_EnableDragColSize(IntPtr self, bool enable);
            static extern (C) void   wxGrid_DisableDragColSize(IntPtr self);
            static extern (C) bool   wxGrid_CanDragColSize(IntPtr self);
            static extern (C) void   wxGrid_EnableDragGridSize(IntPtr self, bool enable);
            static extern (C) void   wxGrid_DisableDragGridSize(IntPtr self);
            static extern (C) bool   wxGrid_CanDragGridSize(IntPtr self);
            static extern (C) void   wxGrid_SetAttr(IntPtr self, int row, int col, IntPtr attr);
            static extern (C) void   wxGrid_SetRowAttr(IntPtr self, int row, IntPtr attr);
            static extern (C) void   wxGrid_SetColAttr(IntPtr self, int col, IntPtr attr);
            static extern (C) void   wxGrid_SetColFormatBool(IntPtr self, int col);
            static extern (C) void   wxGrid_SetColFormatNumber(IntPtr self, int col);
            static extern (C) void   wxGrid_SetColFormatFloat(IntPtr self, int col, int width, int precision);
            static extern (C) void   wxGrid_SetColFormatCustom(IntPtr self, int col, string typeName);
            static extern (C) void   wxGrid_EnableGridLines(IntPtr self, bool enable);
            static extern (C) bool   wxGrid_GridLinesEnabled(IntPtr self);
            static extern (C) int    wxGrid_GetDefaultRowSize(IntPtr self);
            static extern (C) int    wxGrid_GetRowSize(IntPtr self, int row);
            static extern (C) int    wxGrid_GetDefaultColSize(IntPtr self);
            static extern (C) int    wxGrid_GetColSize(IntPtr self, int col);
            static extern (C) IntPtr wxGrid_GetDefaultCellBackgroundColour(IntPtr self);
            static extern (C) IntPtr wxGrid_GetCellBackgroundColour(IntPtr self, int row, int col);
            static extern (C) IntPtr wxGrid_GetDefaultCellTextColour(IntPtr self);
            static extern (C) IntPtr wxGrid_GetCellTextColour(IntPtr self, int row, int col);
            static extern (C) IntPtr wxGrid_GetDefaultCellFont(IntPtr self);
            static extern (C) IntPtr wxGrid_GetCellFont(IntPtr self, int row, int col);
            static extern (C) void   wxGrid_GetDefaultCellAlignment(IntPtr self, inout int horiz, inout int vert);
            static extern (C) void   wxGrid_GetCellAlignment(IntPtr self, int row, int col, inout int horiz, inout int vert);
            static extern (C) bool   wxGrid_GetDefaultCellOverflow(IntPtr self);
            static extern (C) bool   wxGrid_GetCellOverflow(IntPtr self, int row, int col);
            static extern (C) void   wxGrid_GetCellSize(IntPtr self, int row, int col, inout int num_rows, inout int num_cols);
            static extern (C) void   wxGrid_SetDefaultRowSize(IntPtr self, int height, bool resizeExistingRows);
            static extern (C) void   wxGrid_SetRowSize(IntPtr self, int row, int height);
            static extern (C) void   wxGrid_SetDefaultColSize(IntPtr self, int width, bool resizeExistingCols);
            static extern (C) void   wxGrid_SetColSize(IntPtr self, int col, int width);
            static extern (C) void   wxGrid_AutoSizeColumn(IntPtr self, int col, bool setAsMin);
            static extern (C) void   wxGrid_AutoSizeRow(IntPtr self, int row, bool setAsMin);
            static extern (C) void   wxGrid_AutoSizeColumns(IntPtr self, bool setAsMin);
            static extern (C) void   wxGrid_AutoSizeRows(IntPtr self, bool setAsMin);
            static extern (C) void   wxGrid_AutoSize(IntPtr self);
            static extern (C) void   wxGrid_SetColMinimalWidth(IntPtr self, int col, int width);
            static extern (C) void   wxGrid_SetRowMinimalHeight(IntPtr self, int row, int width);
            static extern (C) void   wxGrid_SetColMinimalAcceptableWidth(IntPtr self, int width);
            static extern (C) void   wxGrid_SetRowMinimalAcceptableHeight(IntPtr self, int width);
            static extern (C) int    wxGrid_GetColMinimalAcceptableWidth(IntPtr self);
            static extern (C) int    wxGrid_GetRowMinimalAcceptableHeight(IntPtr self);
            static extern (C) void   wxGrid_SetDefaultCellBackgroundColour(IntPtr self, IntPtr wxColour);
            static extern (C) void   wxGrid_SetDefaultCellTextColour(IntPtr self, IntPtr wxColour);
            static extern (C) void   wxGrid_SetDefaultCellFont(IntPtr self, IntPtr wxFont);
            static extern (C) void   wxGrid_SetCellFont(IntPtr self, int row, int col, IntPtr wxFont );
            static extern (C) void   wxGrid_SetDefaultCellAlignment(IntPtr self, int horiz, int vert);
            static extern (C) void   wxGrid_SetCellAlignmentHV(IntPtr self, int row, int col, int horiz, int vert);
            static extern (C) void   wxGrid_SetDefaultCellOverflow(IntPtr self, bool allow);
            static extern (C) void   wxGrid_SetCellOverflow(IntPtr self, int row, int col, bool allow);
            static extern (C) void   wxGrid_SetCellSize(IntPtr self, int row, int col, int num_rows, int num_cols);
            static extern (C) void   wxGrid_SetDefaultRenderer(IntPtr self, IntPtr renderer);
            static extern (C) void   wxGrid_SetCellRenderer(IntPtr self, int row, int col, IntPtr renderer);
            static extern (C) IntPtr wxGrid_GetDefaultRenderer(IntPtr self);
            static extern (C) IntPtr wxGrid_GetCellRenderer(IntPtr self, int row, int col);
            static extern (C) void   wxGrid_SetDefaultEditor(IntPtr self, IntPtr editor);
            static extern (C) void   wxGrid_SetCellEditor(IntPtr self, int row, int col, IntPtr editor);
            static extern (C) IntPtr wxGrid_GetDefaultEditor(IntPtr self);
            static extern (C) IntPtr wxGrid_GetCellEditor(IntPtr self, int row, int col);
            static extern (C) IntPtr wxGrid_GetCellValue(IntPtr self, int row, int col);
            static extern (C) void   wxGrid_SetCellValue(IntPtr self, int row, int col, string s);
            static extern (C) bool   wxGrid_IsReadOnly(IntPtr self, int row, int col);
            static extern (C) void   wxGrid_SetReadOnly(IntPtr self, int row, int col, bool isReadOnly);
            static extern (C) void   wxGrid_SelectRow(IntPtr self, int row, bool addToSelected);
            static extern (C) void   wxGrid_SelectCol(IntPtr self, int col, bool addToSelected);
            static extern (C) void   wxGrid_SelectBlock(IntPtr self, int topRow, int leftCol, int bottomRow, int rightCol, bool addToSelected);
            static extern (C) void   wxGrid_SelectAll(IntPtr self);
            static extern (C) bool   wxGrid_IsSelection(IntPtr self);
            static extern (C) void   wxGrid_DeselectRow(IntPtr self, int row);
            static extern (C) void   wxGrid_DeselectCol(IntPtr self, int col);
            static extern (C) void   wxGrid_DeselectCell(IntPtr self, int row, int col);
            static extern (C) void   wxGrid_ClearSelection(IntPtr self);
            static extern (C) bool   wxGrid_IsInSelection(IntPtr self, int row, int col);
            //static extern (C) IntPtr wxGrid_GetSelectedCells(IntPtr self);
            //static extern (C) IntPtr wxGrid_GetSelectionBlockTopLeft(IntPtr self);
            //static extern (C) IntPtr wxGrid_GetSelectionBlockBottomRight(IntPtr self);
            //static extern (C) IntPtr wxGrid_GetSelectedRows(IntPtr self);
            //static extern (C) IntPtr wxGrid_GetSelectedCols(IntPtr self);
            static extern (C) void   wxGrid_BlockToDeviceRect(IntPtr self, IntPtr topLeft, IntPtr bottomRight, inout Rectangle rect);
            static extern (C) IntPtr wxGrid_GetSelectionBackground(IntPtr self);
            static extern (C) IntPtr wxGrid_GetSelectionForeground(IntPtr self);
            static extern (C) void   wxGrid_SetSelectionBackground(IntPtr self, IntPtr c);
            static extern (C) void   wxGrid_SetSelectionForeground(IntPtr self, IntPtr c);
            static extern (C) void   wxGrid_RegisterDataType(IntPtr self, string typeName, IntPtr renderer, IntPtr editor);
            static extern (C) IntPtr wxGrid_GetDefaultEditorForCell(IntPtr self, int row, int col);
            static extern (C) IntPtr wxGrid_GetDefaultRendererForCell(IntPtr self, int row, int col);
            static extern (C) IntPtr wxGrid_GetDefaultEditorForType(IntPtr self, string typeName);
            static extern (C) IntPtr wxGrid_GetDefaultRendererForType(IntPtr self, string typeName);
            static extern (C) void   wxGrid_SetMargins(IntPtr self, int extraWidth, int extraHeight);
            static extern (C) IntPtr wxGrid_GetGridWindow(IntPtr self);
            static extern (C) IntPtr wxGrid_GetGridRowLabelWindow(IntPtr self);
            static extern (C) IntPtr wxGrid_GetGridColLabelWindow(IntPtr self);
            static extern (C) IntPtr wxGrid_GetGridCornerLabelWindow(IntPtr self);
            static extern (C) void   wxGrid_UpdateDimensions(IntPtr self);
            static extern (C) int    wxGrid_GetRows(IntPtr self);
            static extern (C) int    wxGrid_GetCols(IntPtr self);
            static extern (C) int    wxGrid_GetCursorRow(IntPtr self);
            static extern (C) int    wxGrid_GetCursorColumn(IntPtr self);
            static extern (C) int    wxGrid_GetScrollPosX(IntPtr self);
            static extern (C) int    wxGrid_GetScrollPosY(IntPtr self);
            static extern (C) void   wxGrid_SetScrollX(IntPtr self, int x);
            static extern (C) void   wxGrid_SetScrollY(IntPtr self, int y);
            static extern (C) void   wxGrid_SetColumnWidth(IntPtr self, int col, int width);
            static extern (C) int    wxGrid_GetColumnWidth(IntPtr self, int col);
            static extern (C) void   wxGrid_SetRowHeight(IntPtr self, int row, int height);
            static extern (C) int    wxGrid_GetViewHeight(IntPtr self);
            static extern (C) int    wxGrid_GetViewWidth(IntPtr self);
            static extern (C) void   wxGrid_SetLabelSize(IntPtr self, int orientation, int sz);
            static extern (C) int    wxGrid_GetLabelSize(IntPtr self, int orientation);
            static extern (C) void   wxGrid_SetLabelAlignment(IntPtr self, int orientation, int alignment);
            static extern (C) int    wxGrid_GetLabelAlignment(IntPtr self, int orientation, int alignment);
            static extern (C) void   wxGrid_SetLabelValue(IntPtr self, int orientation, string val, int pos);
            static extern (C) IntPtr wxGrid_GetLabelValue(IntPtr self, int orientation, int pos);
            static extern (C) IntPtr wxGrid_GetCellTextFontGrid(IntPtr self);
            static extern (C) IntPtr wxGrid_GetCellTextFont(IntPtr self, int row, int col);
            static extern (C) void   wxGrid_SetCellTextFontGrid(IntPtr self, IntPtr fnt);
            static extern (C) void   wxGrid_SetCellTextFont(IntPtr self, IntPtr fnt, int row, int col);
            static extern (C) void   wxGrid_SetCellTextColour(IntPtr self, int row, int col, IntPtr val);
            static extern (C) void   wxGrid_SetCellTextColourGrid(IntPtr self, IntPtr col);
            static extern (C) void   wxGrid_SetCellBackgroundColourGrid(IntPtr self, IntPtr col);
            static extern (C) void   wxGrid_SetCellBackgroundColour(IntPtr self, int row, int col, IntPtr colour);
            static extern (C) bool   wxGrid_GetEditable(IntPtr self);
            static extern (C) void   wxGrid_SetEditable(IntPtr self, bool edit);
            static extern (C) bool   wxGrid_GetEditInPlace(IntPtr self);
            static extern (C) void   wxGrid_SetCellAlignment(IntPtr self, int alignment, int row, int col);
            static extern (C) void   wxGrid_SetCellAlignmentGrid(IntPtr self, int alignment);
            static extern (C) void   wxGrid_SetCellBitmap(IntPtr self, IntPtr bitmap, int row, int col);
            static extern (C) void   wxGrid_SetDividerPen(IntPtr self, IntPtr pen);
            static extern (C) IntPtr wxGrid_GetDividerPen(IntPtr self);
            static extern (C) int    wxGrid_GetRowHeight(IntPtr self, int row);
            //! \endcond

        //-----------------------------------------------------------------------------

    alias Grid wxGrid;
    public class Grid : ScrolledWindow
    {
        public this(IntPtr wxobj);
        public this();
        public this(Window parent, int id);
        public this(Window parent, int id, Point pos);
        public this(Window parent, int id, Point pos, Size size);
        public this(Window parent, int id, Point pos, Size size, int style);
        public this(Window parent, int id, Point pos, Size size, int style, string name);
	public this(Window parent);
        public this(Window parent, Point pos);
        public this(Window parent, Point pos, Size size);
        public this(Window parent, Point pos, Size size, int style);
        public this(Window parent, Point pos, Size size, int style, string name);
        public bool CreateGrid(int numRows, int numCols);
            public bool CreateGrid(int numRows, int numCols, GridSelectionMode selmode);
            public void SelectionMode(GridSelectionMode value) ;
            public int NumberRows();
            public int NumberCols() ;
       //     public GridTableBase Table() ;
        public bool SetTable(GridTableBase table);
        public bool SetTable(GridTableBase table, bool takeOwnerShip);
            public bool SetTable(GridTableBase table, bool takeOwnership, GridSelectionMode select);
            public void ClearGrid();
        public bool InsertRows();
        public bool InsertRows(int pos);
        public bool InsertRows(int pos, int numRows);
            public bool InsertRows(int pos, int numRows, bool updateLabels);
        public bool AppendRows();        
        public bool AppendRows(int numRows);    
            public bool AppendRows(int numRows, bool updateLabels);
        public bool DeleteRows();
        public bool DeleteRows(int pos);
        public bool DeleteRows(int pos, int numRows);
            public bool DeleteRows(int pos, int numRows, bool updateLabels);
        public bool InsertCols();
        public bool InsertCols(int pos);
        public bool InsertCols(int pos, int numRows);
            public bool InsertCols(int pos, int numCols, bool updateLabels);
        public bool AppendCols();
        public bool AppendCols(int numCols);
            public bool AppendCols(int numCols, bool updateLabels);
        public bool DeleteCols();
        public bool DeleteCols(int pos);
        public bool DeleteCols(int pos, int numRows);
            public bool DeleteCols(int pos, int numCols, bool updateLabels);
            public void BeginBatch();
            public void EndBatch();
            public int BatchCount();
            public void ForceRefresh();
            public bool IsEditable() ;
            public void IsEditable(bool value) ;
            public void CellEditControlEnabled(bool value) ;
            public bool CellEditControlEnabled() ;
            public void DisableCellEditControl();
            public bool CanEnableCellControl() ;
            public bool IsCellEditControlShown() ;
            public bool IsCurrentCellReadOnly() ;
            public void ShowCellEditControl();
            public void HideCellEditControl();
            public void SaveEditControlValue();
            //public void XYToCell(int x, int y,  GridCellCoords );
            public int YToRow(int y);
            public int XToCol(int x);    
            public int YToEdgeOfRow(int y);    
            public int XToEdgeOfCol(int x);
            public Rectangle CellToRect(int row, int col);
            public int GridCursorRow() ;
            public int GridCursorCol();
            public bool IsVisible(int row, int col, bool wholeCellVisible);
            public void MakeCellVisible(int row, int col);
            public void SetGridCursor(int row, int col);
            public bool MoveCursorUp(bool expandSelection);
            public bool MoveCursorDown(bool expandSelection);
            public bool MoveCursorLeft(bool expandSelection);
            public bool MoveCursorRight(bool expandSelection);
            public bool MovePageDown();
            public bool MovePageUp();
            public bool MoveCursorUpBlock(bool expandSelection);
            public bool MoveCursorDownBlock(bool expandSelection);
            public bool MoveCursorLeftBlock(bool expandSelection);
            public bool MoveCursorRightBlock(bool expandSelection);
            public int DefaultRowLabelSize();
            public int RowLabelSize();
            public void RowLabelSize(int value);
            public int DefaultColLabelSize() ;
            public int ColLabelSize();
            public void ColLabelSize(int value);
            public Colour LabelBackgroundColour() ;
            public void LabelBackgroundColour(Colour value) ;
            public Colour LabelTextColour() ;
            public void LabelTextColour(Colour value) ;
            public Font LabelFont();
            public void LabelFont(Font value);
            public void GetRowLabelAlignment(out int horiz, out int vert);
            public void GetColLabelAlignment(out int horiz, out int vert);
            public string GetRowLabelValue(int row);
            public string GetColLabelValue(int col);
            public Colour GridLineColour() ;
            public void GridLineColour(Colour value) ;
            public Colour CellHighlightColour() ;
            public void CellHighlightColour(Colour value) ;
            public int CellHighlightPenWidth();
            public void CellHighlightPenWidth(int value) ;
            public int CellHighlightROPenWidth() ;
            public void CellHighlightROPenWidth(int value) ;
            public void SetRowLabelAlignment(int horiz, int vert);
            public void SetColLabelAlignment(int horiz, int vert);
            public void SetRowLabelValue(int row, string str);
            public void SetColLabelValue(int col, string str);
            public void DragRowSizeEnabled(bool value) ;
            public bool DragRowSizeEnabled() ;
            public void DisableDragRowSize();
            public void DragColSizeEnabled(bool value);
            public bool DragColSizeEnabled() ;
            public void DisableDragColSize();
            public void DragGridSizeEnabled(bool value) ;
            public bool DragGridSizeEnabled() ;
            public void DisableDragGridSize();
            public void SetAttr(int row, int col, GridCellAttr attr);
            public void SetRowAttr(int row, GridCellAttr attr);
            public void SetColAttr(int col, GridCellAttr attr);
            public void ColFormatBool(int value) ;
            public void ColFormatNumber(int value) ;
            public void SetColFormatFloat(int col);
            public void SetColFormatFloat(int col, int width);
            public void SetColFormatFloat(int col, int width, int precision);
            public void SetColFormatCustom(int col, string typeName);
            public void GridLinesEnabled(bool value) ;
            public bool GridLinesEnabled() ;
            public int DefaultRowSize();
            public int GetRowSize(int row);
            public int DefaultColSize() ;
            public int GetColSize(int col);
            public Colour DefaultCellBackgroundColour();
            public void DefaultCellBackgroundColour(Colour value) ;
            public Colour DefaultCellTextColour() ;
            public void DefaultCellTextColour(Colour value);
            public Font DefaultCellFont();
            public void DefaultCellFont(Font value) ;
            public Font GetCellFont(int row, int col);
            public void GetDefaultCellAlignment(inout int horiz, inout int vert);
            public void GetCellAlignment(int row, int col, inout int horiz, inout int vert);
            public bool DefaultCellOverflow();
            public void DefaultCellOverflow(bool value) ;
            public bool GetCellOverflow(int row, int col);
            public void GetCellSize(int row, int col, inout int num_rows, inout int num_cols);
            public void SetDefaultRowSize(int height, bool resizeExistingRows);
            public void SetRowSize(int row, int height);
            public void SetDefaultColSize(int width, bool resizeExistingCols);
            public void SetColSize(int col, int width);
            public void AutoSizeColumn(int col, bool setAsMin);
            public void AutoSizeRow(int row, bool setAsMin);
            public void AutoSizeColumns();
            public void AutoSizeColumns(bool setAsMin);
            public void AutoSizeRows();
            public void AutoSizeRows(bool setAsMin);
            public void AutoSize();
            public void SetColMinimalWidth(int col, int width);
            public void SetRowMinimalHeight(int row, int width);
            public void ColMinimalAcceptableWidth(int value);
            public int ColMinimalAcceptableWidth() ;
            public void RowMinimalAcceptableHeight(int value);
            public int RowMinimalAcceptableHeight();
            public void SetCellFont(int row, int col, Font fnt);
            public void SetDefaultCellAlignment(int horiz, int vert);
            public void SetCellAlignment(int row, int col, int horiz, int vert);
            public void SetCellOverflow(int row, int col, bool allow);
            public void SetCellSize(int row, int col, int num_rows, int num_cols);
            public void DefaultRenderer(GridCellRenderer value) ;
            public void SetCellRenderer(int row, int col, GridCellRenderer renderer);
           // public GridCellRenderer GetCellRenderer(int row, int col);
            public void DefaultEditor(GridCellEditor value) ;
           // public GridCellEditor DefaultEditor() ;
            public void SetCellEditor(int row, int col, GridCellEditor editor);
           // public GridCellEditor GetCellEditor(int row, int col);
            public string GetCellValue(int row, int col);
            public void SetCellValue(int row, int col, string s);
            public bool IsReadOnly(int row, int col);
            public void SetReadOnly(int row, int col);
            public void SetReadOnly(int row, int col, bool isReadOnly);
            public void SelectRow(int row, bool addToSelected);
            public void SelectCol(int col, bool addToSelected);
            public void SelectBlock(int topRow, int leftCol, int bottomRow, int rightCol, bool addToSelected);
            public void SelectAll();
            public bool IsSelection() ;
            public void DeselectRow(int row);
            public void DeselectCol(int col);
            public void DeselectCell(int row, int col);
            public void ClearSelection();
            public bool IsInSelection(int row, int col);
    
            //-----------------------------------------------------------------------------

//! \cond VERSION
version(NOT_IMPLEMENTED){
            public GridCellCoordsArray GetSelectedCells();
            public GridCellCoordsArray GetSelectionBlockTopLeft();
            public GridCellCoordsArray GetSelectionBlockBottomRight();
            public ArrayInt GetSelectedRows();
            public ArrayInt GetSelectedCols();
} // version(NOT_IMPLEMENTED)
//! \endcond
            //-----------------------------------------------------------------------------
    
            public Rectangle BlockToDeviceRect(GridCellCoords topLeft, GridCellCoords bottomRight);
            public Colour SelectionBackground();
            public void SelectionBackground(Colour value) ;
            public Colour SelectionForeground();
            public void SelectionForeground(Colour value);
            public void RegisterDataType(string typeName, GridCellRenderer renderer, GridCellEditor editor);
           // public GridCellEditor GetDefaultEditorForCell(int row, int col);
           // public GridCellRenderer GetDefaultRendererForCell(int row, int col);
          //  public GridCellEditor GetDefaultEditorForType(string typeName);
          //  public GridCellRenderer GetDefaultRendererForType(string typeName);
            public void SetMargins(int extraWidth, int extraHeight);
            public Window GridWindow();
            public Window GridRowLabelWindow() ;
            public Window GridColLabelWindow();
            public Window GridCornerLabelWindow() ;
            public void UpdateDimensions();
            public int Rows() ;
            public int Cols();
            public int CursorRow() ;
            public int CursorColumn() ;
            public int ScrollPosX();
            public void ScrollPosX(int value);
            public int ScrollPosY() ;
            public void ScrollPosY(int value) ;
            public void SetColumnWidth(int col, int width);
            public int GetColumnWidth(int col);
            public void SetRowHeight(int row, int height);
            public int ViewHeight();
            public int ViewWidth() ;
            public void SetLabelSize(int orientation, int sz);
            public int GetLabelSize(int orientation);
            public void SetLabelAlignment(int orientation, int alignment);
            public int GetLabelAlignment(int orientation, int alignment);
            public void SetLabelValue(int orientation, string val, int pos);
            public string GetLabelValue(int orientation, int pos);
            public Font CellTextFont() ;
            public void CellTextFont(Font value);
            public Font GetCellTextFont(int row, int col);
            public void SetCellTextFont(Font fnt, int row, int col);
            public void SetCellTextColour(int row, int col, Colour val);
            public void CellTextColour(Colour value) ;
            public Colour GetCellTextColour(int row, int col);
            public void CellBackgroundColour(Colour value);
            public void SetCellBackgroundColour(int row, int col, Colour colour);
            public Colour GetCellBackgroundColour(int row, int col);
            public bool Editable() { return wxGrid_GetEditable(wxobj); }
            public void Editable(bool value);
            public bool EditInPlace() ;
            public void SetCellAlignment(int alignment, int row, int col);
            public void CellAlignment(int value);
            public void SetCellBitmap(Bitmap bitmap, int row, int col);
            public void DividerPen(Pen value) ;
            public Pen DividerPen() ;
            public int GetRowHeight(int row);
		public void CellLeftClick_Add(EventListener value);
		public void CellLeftClick_Remove(EventListener value) ;
		public void CellRightClick_Add(EventListener value) ;
		public void CellRightClick_Remove(EventListener value);
		public void CellLeftDoubleClick_Add(EventListener value) ;
		public void CellLeftDoubleClick_Remove(EventListener value);
		public void CellRightDoubleClick_Add(EventListener value);
		public void CellRightDoubleClick_Remove(EventListener value);
		public void LabelLeftClick_Add(EventListener value) ;
		public void LabelLeftClick_Remove(EventListener value) ;
		public void LabelRightClick_Add(EventListener value) ;
		public void LabelRightClick_Remove(EventListener value) ;
		public void LabelLeftDoubleClick_Add(EventListener value) ;
		public void LabelLeftDoubleClick_Remove(EventListener value) ;
		public void LabelRightDoubleClick_Add(EventListener value);
		public void LabelRightDoubleClick_Remove(EventListener value) ;
		public void RowSize_Add(EventListener value);
		public void RowSize_Remove(EventListener value);
		public void ColumnSize_Add(EventListener value) ;
		public void ColumnSize_Remove(EventListener value) ;
		public void RangeSelect_Add(EventListener value) ;
		public void RangeSelect_Remove(EventListener value);
		public void CellChange_Add(EventListener value);
		public void CellChange_Remove(EventListener value);
		public void SelectCell_Add(EventListener value) ;
		public void SelectCell_Remove(EventListener value) ;
		public void EditorShown_Add(EventListener value) ;
		public void EditorShown_Remove(EventListener value) ;
		public void EditorHidden_Add(EventListener value) ;
		public void EditorHidden_Remove(EventListener value) ;
		public void EditorCreate_Add(EventListener value);
		public void EditorCreate_Remove(EventListener value);

    }

        //! \cond EXTERN
        static extern (C) IntPtr wxGridCellCoords_ctor();
	static extern (C) void   wxGridCellCoords_dtor(IntPtr self);
        static extern (C) int    wxGridCellCoords_GetRow(IntPtr self);
        static extern (C) void   wxGridCellCoords_SetRow(IntPtr self, int n);
        static extern (C) int    wxGridCellCoords_GetCol(IntPtr self);
        static extern (C) void   wxGridCellCoords_SetCol(IntPtr self, int n);
        static extern (C) void   wxGridCellCoords_Set(IntPtr self, int row, int col);
        //! \endcond
	
        //-----------------------------------------------------------------------------
    
    alias GridCellCoords wxGridCellCoords;
    public class GridCellCoords : wxObject
    {
        public this(IntPtr wxobj);
	    private this(IntPtr wxobj, bool memOwn);
        public this();
        public this(int r, int c);
	    override protected void dtor() ;
        public void Row(int value);
        public int Row();
        public void Col(int value) ;
        public int Col() ;
        public void Set(int row, int col);
    }

        //! \cond EXTERN
        static extern (C) IntPtr wxGridCellAttr_ctor(IntPtr colText, IntPtr colBack, IntPtr font, int hAlign, int vAlign);
        static extern (C) IntPtr wxGridCellAttr_ctor2();
        static extern (C) IntPtr wxGridCellAttr_ctor3(IntPtr attrDefault);
        static extern (C) IntPtr wxGridCellAttr_Clone(IntPtr self);
        static extern (C) void   wxGridCellAttr_MergeWith(IntPtr self, IntPtr mergefrom);
        static extern (C) void   wxGridCellAttr_IncRef(IntPtr self);
        static extern (C) void   wxGridCellAttr_DecRef(IntPtr self);
        static extern (C) void   wxGridCellAttr_SetTextColour(IntPtr self, IntPtr colText);
        static extern (C) void   wxGridCellAttr_SetBackgroundColour(IntPtr self, IntPtr colBack);
        static extern (C) void   wxGridCellAttr_SetFont(IntPtr self, IntPtr font);
        static extern (C) void   wxGridCellAttr_SetAlignment(IntPtr self, int hAlign, int vAlign);
        static extern (C) void   wxGridCellAttr_SetSize(IntPtr self, int num_rows, int num_cols);
        static extern (C) void   wxGridCellAttr_SetOverflow(IntPtr self, bool allow);
        static extern (C) void   wxGridCellAttr_SetReadOnly(IntPtr self, bool isReadOnly);
        static extern (C) void   wxGridCellAttr_SetRenderer(IntPtr self, IntPtr renderer);
        static extern (C) void   wxGridCellAttr_SetEditor(IntPtr self, IntPtr editor);
        static extern (C) bool   wxGridCellAttr_HasTextColour(IntPtr self);
        static extern (C) bool   wxGridCellAttr_HasBackgroundColour(IntPtr self);
        static extern (C) bool   wxGridCellAttr_HasFont(IntPtr self);
        static extern (C) bool   wxGridCellAttr_HasAlignment(IntPtr self);
        static extern (C) bool   wxGridCellAttr_HasRenderer(IntPtr self);
        static extern (C) bool   wxGridCellAttr_HasEditor(IntPtr self);
        static extern (C) bool   wxGridCellAttr_HasReadWriteMode(IntPtr self);
        static extern (C) IntPtr wxGridCellAttr_GetTextColour(IntPtr self);
        static extern (C) IntPtr wxGridCellAttr_GetBackgroundColour(IntPtr self);
        static extern (C) IntPtr wxGridCellAttr_GetFont(IntPtr self);
        static extern (C) void   wxGridCellAttr_GetAlignment(IntPtr self, inout int hAlign, inout int vAlign);
        static extern (C) void   wxGridCellAttr_GetSize(IntPtr self, inout int num_rows, inout int num_cols);
        static extern (C) bool   wxGridCellAttr_GetOverflow(IntPtr self);
        static extern (C) IntPtr wxGridCellAttr_GetRenderer(IntPtr self, IntPtr grid, int row, int col);
        static extern (C) IntPtr wxGridCellAttr_GetEditor(IntPtr self, IntPtr grid, int row, int col);
        static extern (C) bool   wxGridCellAttr_IsReadOnly(IntPtr self);
        static extern (C) void   wxGridCellAttr_SetDefAttr(IntPtr self, IntPtr defAttr);
        //! \endcond
	
        //-----------------------------------------------------------------------------
    
    alias GridCellAttr wxGridCellAttr;
    public class GridCellAttr : wxObject
    {
        public enum AttrKind
        {
            Any, Default, Cell, Row, Col, Merged
        }
    
        //-----------------------------------------------------------------------------
    
        public this(IntPtr wxobj);
	    private this(IntPtr wxobj, bool memOwn);
        public this();
        public this(GridCellAttr attrDefault);
        public this(Colour colText, Colour colBack, Font font, int hAlign, int vAlign);
	    public static wxObject New(IntPtr ptr);
    	override protected void dtor() ;
        public GridCellAttr Clone();
        public void MergeWith(GridCellAttr mergefrom);
        public void IncRef();
        public void DecRef();
        public void TextColour(Colour value) ;
        public Colour TextColour() ;  
        public void BackgroundColour(Colour value);
        public Colour BackgroundColour();
        public void font(Font value) ;
        public Font font();
        public void SetAlignment(int hAlign, int vAlign);
        public void GetAlignment(inout int hAlign, inout int vAlign);
        public void SetSize(int num_rows, int num_cols);
        public void GetSize(inout int num_rows, inout int num_cols);
        public void Overflow(bool value) ;
        public bool Overflow();
        public void ReadOnly(bool value) ;
        public bool ReadOnly();
        public void SetRenderer(GridCellRenderer renderer);
        public void Editor(GridCellEditor value) ;       
        //public GridCellEditor GetEditor(Grid grid, int row, int col);
        public bool HasTextColour() ;        
        public bool HasBackgroundColour() ;
        public bool HasFont() ;
        public bool HasAlignment() ;
        public bool HasRenderer() ;
        public bool HasEditor() ;
        public bool HasReadWriteMode();
       // public GridCellRenderer GetRenderer(Grid grid, int row, int col);
        public void DefAttr(GridCellAttr value) ;
    }

        //! \cond EXTERN
        static extern (C) IntPtr wxGridSizeEvent_ctor();
        static extern (C) IntPtr wxGridSizeEvent_ctorParam(int id, int type, IntPtr obj, int rowOrCol, int x, int y, bool control, bool shift, bool alt, bool meta);
        static extern (C) int    wxGridSizeEvent_GetRowOrCol(IntPtr self);
        static extern (C) void   wxGridSizeEvent_GetPosition(IntPtr self, inout Point pt);
        static extern (C) bool   wxGridSizeEvent_ControlDown(IntPtr self);
        static extern (C) bool   wxGridSizeEvent_MetaDown(IntPtr self);
        static extern (C) bool   wxGridSizeEvent_ShiftDown(IntPtr self);
        static extern (C) bool   wxGridSizeEvent_AltDown(IntPtr self);
        static extern (C) void wxGridSizeEvent_Veto(IntPtr self);
        static extern (C) void wxGridSizeEvent_Allow(IntPtr self);
        static extern (C) bool wxGridSizeEvent_IsAllowed(IntPtr self);          
        //! \endcond
    
        //-----------------------------------------------------------------------------
        
    alias GridSizeEvent wxGridSizeEvent;
    public class GridSizeEvent : Event 
    {
        public this(IntPtr wxobj) ;
        public this();
        public this(int id, int type, wxObject obj, int rowOrCol, int x, int y, bool control, bool shift, bool alt, bool meta);
        public int RowOrCol();
        public Point Position();
        public bool ControlDown() ;
        public bool MetaDown();
        public bool ShiftDown();
        public bool AltDown();
        public void Veto();
        public void Allow();
        public bool Allowed();
	    private static Event New(IntPtr obj);
	   static this()
    	{
			wxEVT_GRID_ROW_SIZE = wxEvent_EVT_GRID_ROW_SIZE();
			wxEVT_GRID_COL_SIZE = wxEvent_EVT_GRID_COL_SIZE();

			AddEventType(wxEVT_GRID_ROW_SIZE,                   &GridSizeEvent.New);
			AddEventType(wxEVT_GRID_COL_SIZE,                   &GridSizeEvent.New);
	   }
    }
    
    //-----------------------------------------------------------------------------

	extern (C) {
        alias void function(GridCellRenderer obj, IntPtr grid, IntPtr attr, IntPtr dc, Rectangle rect, int row, int col, bool isSelected) Virtual_Draw;
        alias Size function(GridCellRenderer obj, IntPtr grid, IntPtr attr, IntPtr dc, int row, int col) Virtual_GetBestSize;
        alias IntPtr function(GridCellRenderer obj) Virtual_RendererClone;
	}

        //-----------------------------------------------------------------------------
        
        //! \cond EXTERN
        static extern (C) IntPtr wxGridCellRenderer_ctor();
	    static extern (C) void wxGridCellRenderer_dtor(IntPtr self);
        static extern (C) void wxGridCellRenderer_RegisterVirtual(IntPtr self, GridCellRenderer obj, Virtual_Draw draw, Virtual_GetBestSize getBestSize, Virtual_RendererClone clone);
        //! \endcond
	
	//-----------------------------------------------------------------------------
	
    public abstract class GridCellRenderer : GridCellWorker
    {
        public this();        
        public this(IntPtr wxobj);
	    private this(IntPtr wxobj, bool memOwn);	
	    //public static wxObject New(IntPtr ptr) ;
    	override protected void dtor() ;
        static extern (C) private void staticDoDraw(GridCellRenderer obj, IntPtr grid, IntPtr attr, IntPtr dc, Rectangle rect, int row, int col, bool isSelected);
        public abstract void Draw(Grid grid, GridCellAttr attr, DC dc, Rectangle rect, int row, int col, bool isSelected);
        static extern (C) private Size staticDoGetBestSize(GridCellRenderer obj, IntPtr grid, IntPtr attr, IntPtr dc,  int row, int col);
        public abstract Size GetBestSize(Grid grid, GridCellAttr attr, DC dc, int row, int col);
        static extern (C) private IntPtr staticDoClone(GridCellRenderer obj);
        public abstract GridCellRenderer Clone();
    }
    
    //-----------------------------------------------------------------------------
    
        //! \cond EXTERN
        static extern (C) IntPtr wxGridCellStringRenderer_ctor();
	    static extern (C) void wxGridCellStringRenderer_dtor(IntPtr self);
	    static extern (C) void wxGridCellStringRenderer_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
        static extern (C) void wxGridCellStringRenderer_Draw(IntPtr self, IntPtr grid, IntPtr attr, IntPtr dc, inout Rectangle rect, int row, int col, bool isSelected);
        static extern (C) void wxGridCellStringRenderer_GetBestSize(IntPtr self, IntPtr grid, IntPtr attr, IntPtr dc, int row, int col, out Size size);
        static extern (C) IntPtr wxGridCellStringRenderer_Clone(IntPtr self);
        //! \endcond
	
    alias GridCellStringRenderer wxGridCellStringRenderer;
    public class GridCellStringRenderer : GridCellRenderer
    {
        public this();            
        public this(IntPtr wxobj);
	private this(IntPtr wxobj, bool memOwn);
	override protected void dtor() ;
        public override void Draw(Grid grid, GridCellAttr attr, DC dc, Rectangle rect, int row, int col, bool isSelected);
        public override Size GetBestSize(Grid grid, GridCellAttr attr, DC dc, int row, int col);
        public override GridCellRenderer Clone();
    }
    
    //-----------------------------------------------------------------------------
    
        static extern (C) IntPtr wxGridCellNumberRenderer_ctor();
	    static extern (C) void wxGridCellNumberRenderer_dtor(IntPtr self);
        static extern (C) void wxGridCellNumberRenderer_Draw(IntPtr self, IntPtr grid, IntPtr attr, IntPtr dc, inout Rectangle rect, int row, int col, bool isSelected);
        static extern (C) void wxGridCellNumberRenderer_GetBestSize(IntPtr self, IntPtr grid, IntPtr attr, IntPtr dc, int row, int col, out Size size);
        static extern (C) IntPtr wxGridCellNumberRenderer_Clone(IntPtr self);
	
    alias GridCellNumberRenderer wxGridCellNumberRenderer;
    public class GridCellNumberRenderer : GridCellStringRenderer
    {
        public this();
        public this(IntPtr wxobj);
	    private this(IntPtr wxobj, bool memOwn);
	    override protected void dtor();
        public override void Draw(Grid grid, GridCellAttr attr, DC dc, Rectangle rect, int row, int col, bool isSelected);
        public override Size GetBestSize(Grid grid, GridCellAttr attr, DC dc, int row, int col);
        public override GridCellRenderer Clone();
    }
    
    //-----------------------------------------------------------------------------
    
        //! \cond EXTERN
        static extern (C) IntPtr wxGridCellFloatRenderer_ctor(int width, int precision);
	static extern (C) void wxGridCellFloatRenderer_dtor(IntPtr self);
        static extern (C) void wxGridCellFloatRenderer_Draw(IntPtr self, IntPtr grid, IntPtr attr, IntPtr dc, inout Rectangle rect, int row, int col, bool isSelected);
        static extern (C) void wxGridCellFloatRenderer_GetBestSize(IntPtr self, IntPtr grid, IntPtr attr, IntPtr dc, int row, int col, out Size size);
        static extern (C) IntPtr wxGridCellFloatRenderer_Clone(IntPtr self);
        static extern (C) int wxGridCellFloatRenderer_GetWidth(IntPtr self);
        static extern (C) void wxGridCellFloatRenderer_SetWidth(IntPtr self, int width);
        static extern (C) int wxGridCellFloatRenderer_GetPrecision(IntPtr self);
        static extern (C) void wxGridCellFloatRenderer_SetPrecision(IntPtr self, int precision);
        static extern (C) void wxGridCellFloatRenderer_SetParameters(IntPtr self, string parameter);
        //! \endcond
	
    alias GridCellFloatRenderer wxGridCellFloatRenderer;
    public class GridCellFloatRenderer : GridCellStringRenderer
    {
        public this();
        public this(int width);
        public this(int width, int precision);
        public this(IntPtr wxobj);
	    private this(IntPtr wxobj, bool memOwn);
	    override protected void dtor();
        public override void SetParameters(string parameter);
        public int Width();
        public void Width(int value) ;
        public int Precision() ;
        public void Precision(int value) ;
        public override void Draw(Grid grid, GridCellAttr attr, DC dc, Rectangle rect, int row, int col, bool isSelected);
        public override Size GetBestSize(Grid grid, GridCellAttr attr, DC dc, int row, int col);
        public override GridCellRenderer Clone();
    }
    
    //-----------------------------------------------------------------------------
    
        //! \cond EXTERN
        static extern (C) IntPtr wxGridCellBoolRenderer_ctor();
	    static extern (C) void wxGridCellBoolRenderer_dtor(IntPtr self);
	    static extern (C) void wxGridCellBoolRenderer_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
        static extern (C) void wxGridCellBoolRenderer_Draw(IntPtr self, IntPtr grid, IntPtr attr, IntPtr dc, inout Rectangle rect, int row, int col, bool isSelected);
        static extern (C) void wxGridCellBoolRenderer_GetBestSize(IntPtr self, IntPtr grid, IntPtr attr, IntPtr dc, int row, int col, out Size size);
        static extern (C) IntPtr wxGridCellBoolRenderer_Clone(IntPtr self);
        //! \endcond
	
    alias GridCellBoolRenderer wxGridCellBoolRenderer;
    public class GridCellBoolRenderer : GridCellRenderer
    {
        public this();
        public this(IntPtr wxobj);
	    private this(IntPtr wxobj, bool memOwn);
	    override protected void dtor() ;
        public override void Draw(Grid grid, GridCellAttr attr, DC dc, Rectangle rect, int row, int col, bool isSelected);
        public override Size GetBestSize(Grid grid, GridCellAttr attr, DC dc, int row, int col);
        public override GridCellRenderer Clone();
    }
    
    //-----------------------------------------------------------------------------
    
        extern (C) {
        alias int  function(GridTableBase obj) Virtual_GetNumberRows;
        alias int  function(GridTableBase obj) Virtual_GetNumberCols;
        alias bool function(GridTableBase obj, int row, int col) Virtual_IsEmptyCell;
        alias string function(GridTableBase obj, int row, int col) Virtual_GetValue_gt;
        alias void function(GridTableBase obj, int row, int col, IntPtr val) Virtual_SetValue;
        alias bool function(GridTableBase obj, int row, int col, IntPtr typeName) Virtual_CanGetValueAs;
        alias int  function(GridTableBase obj, int row, int col) Virtual_GetValueAsLong;
        alias double function(GridTableBase obj, int row, int col) Virtual_GetValueAsDouble;
        alias void function(GridTableBase obj, int row, int col, int value) Virtual_SetValueAsLong;
        alias void function(GridTableBase obj, int row, int col, double value) Virtual_SetValueAsDouble;
        alias void function(GridTableBase obj, int row, int col, bool value) Virtual_SetValueAsBool;
        alias IntPtr function(GridTableBase obj, int row, int col, IntPtr typeName) Virtual_GetValueAsCustom;
        alias void function(GridTableBase obj, int row, int col, IntPtr typeName, IntPtr value) Virtual_SetValueAsCustom;
        alias string function(GridTableBase obj, int col) Virtual_GetColLabelValue;
        alias void function(GridTableBase obj, IntPtr grid) Virtual_SetView;
        alias IntPtr function(GridTableBase obj) Virtual_GetView;
        alias void function(GridTableBase obj) Virtual_Clear;
        alias bool function(GridTableBase obj, int pos, int numRows) Virtual_InsertRows;
        alias bool function(GridTableBase obj, int numRows) Virtual_AppendRows;
        alias void function(GridTableBase obj, int row, IntPtr val) Virtual_SetRowLabelValue;
        alias void function(GridTableBase obj, IntPtr attrProvider) Virtual_SetAttrProvider;
        alias IntPtr function(GridTableBase obj) Virtual_GetAttrProvider;
        alias bool function(GridTableBase obj) Virtual_CanHaveAttributes;
        alias IntPtr function(GridTableBase obj, int row, int col, int kind) Virtual_GetAttr_gt;
        alias void function(GridTableBase obj, IntPtr attr, int row, int col) Virtual_SetAttr_gt;
        alias void function(GridTableBase obj, IntPtr attr, int row) Virtual_SetRowAttr_gt;
        }

        //! \cond EXTERN
        static extern (C) IntPtr wxGridTableBase_ctor();
        static extern (C) void wxGridTableBase_RegisterVirtual(IntPtr self, GridTableBase obj, 
            Virtual_GetNumberRows getNumberRows, 
            Virtual_GetNumberCols getNumberCols, 
            Virtual_IsEmptyCell isEmptyCell, 
            Virtual_GetValue_gt getValue, 
            Virtual_SetValue setValue, 
            Virtual_GetValue_gt getTypeName, 
            Virtual_CanGetValueAs canGetValueAs, 
            Virtual_CanGetValueAs canSetValueAs, 
            Virtual_GetValueAsLong getValueAsLong,
            Virtual_GetValueAsDouble getValueAsDouble, 
            Virtual_IsEmptyCell getValueAsBool,
            Virtual_SetValueAsLong setValueAsLong,
            Virtual_SetValueAsDouble setValueAsDouble,
            Virtual_SetValueAsBool setValueAsBool,
            Virtual_GetValueAsCustom getValueAsCustom,
            Virtual_SetValueAsCustom setValueAsCustom,
            Virtual_SetView setView,
            Virtual_GetView getView,
            Virtual_Clear clear,
            Virtual_InsertRows insertRows,
            Virtual_AppendRows appendRows,
            Virtual_InsertRows deleteRows,
            Virtual_InsertRows insertCols,
            Virtual_AppendRows appendCols,
            Virtual_InsertRows deleteCols,
            Virtual_GetColLabelValue getRowLabelValue,
            Virtual_GetColLabelValue getColLabelValue,
            Virtual_SetRowLabelValue setRowLabelValue,
            Virtual_SetRowLabelValue setColLabelValue,
            Virtual_SetAttrProvider setAttrProvider,
            Virtual_GetAttrProvider getAttrProvider,
            Virtual_CanHaveAttributes canHaveAttributes,
            Virtual_GetAttr_gt getAttr,
            Virtual_SetAttr_gt setAttr,
            Virtual_SetRowAttr_gt setRowAttr,
            Virtual_SetRowAttr_gt setColAttr);

        static extern (C) int    wxGridTableBase_GetNumberRows(IntPtr self);
        static extern (C) int    wxGridTableBase_GetNumberCols(IntPtr self);
        static extern (C) bool   wxGridTableBase_IsEmptyCell(IntPtr self, int row, int col);
        static extern (C) IntPtr wxGridTableBase_GetValue(IntPtr self, int row, int col);
        static extern (C) void   wxGridTableBase_SetValue(IntPtr self, int row, int col, IntPtr val);
        static extern (C) IntPtr wxGridTableBase_GetTypeName(IntPtr self, int row, int col);
        static extern (C) bool   wxGridTableBase_CanGetValueAs(IntPtr self, int row, int col, string typeName);
        static extern (C) bool   wxGridTableBase_CanSetValueAs(IntPtr self, int row, int col, string typeName);
        static extern (C) int   wxGridTableBase_GetValueAsLong(IntPtr self, int row, int col);
        static extern (C) double wxGridTableBase_GetValueAsDouble(IntPtr self, int row, int col);
        static extern (C) bool   wxGridTableBase_GetValueAsBool(IntPtr self, int row, int col);
        static extern (C) void   wxGridTableBase_SetValueAsLong(IntPtr self, int row, int col, int val);
        static extern (C) void   wxGridTableBase_SetValueAsDouble(IntPtr self, int row, int col, double val);
        static extern (C) void   wxGridTableBase_SetValueAsBool(IntPtr self, int row, int col, bool val);
        static extern (C) IntPtr wxGridTableBase_GetValueAsCustom(IntPtr self, int row, int col, string typeName);
        static extern (C) void   wxGridTableBase_SetValueAsCustom(IntPtr self, int row, int col, string typeName, IntPtr val);
        static extern (C) void   wxGridTableBase_SetView(IntPtr self, IntPtr grid);
        static extern (C) IntPtr wxGridTableBase_GetView(IntPtr self);
        static extern (C) void   wxGridTableBase_Clear(IntPtr self);
        static extern (C) bool   wxGridTableBase_InsertRows(IntPtr self, int pos, int numRows);
        static extern (C) bool   wxGridTableBase_AppendRows(IntPtr self, int numRows);
        static extern (C) bool   wxGridTableBase_DeleteRows(IntPtr self, int pos, int numRows);
        static extern (C) bool   wxGridTableBase_InsertCols(IntPtr self, int pos, int numCols);
        static extern (C) bool   wxGridTableBase_AppendCols(IntPtr self, int numCols);
        static extern (C) bool   wxGridTableBase_DeleteCols(IntPtr self, int pos, int numCols);
        static extern (C) IntPtr wxGridTableBase_GetRowLabelValue(IntPtr self, int row);
        static extern (C) IntPtr wxGridTableBase_GetColLabelValue(IntPtr self, int col);
        static extern (C) void   wxGridTableBase_SetRowLabelValue(IntPtr self, int row, string val);
        static extern (C) void   wxGridTableBase_SetColLabelValue(IntPtr self, int col, string val);
        static extern (C) void   wxGridTableBase_SetAttrProvider(IntPtr self, IntPtr attrProvider);
        static extern (C) IntPtr wxGridTableBase_GetAttrProvider(IntPtr self);
        static extern (C) bool   wxGridTableBase_CanHaveAttributes(IntPtr self);
        static extern (C) IntPtr wxGridTableBase_GetAttr(IntPtr self, int row, int col, int kind);
        static extern (C) void   wxGridTableBase_SetAttr(IntPtr self, IntPtr attr, int row, int col);
        static extern (C) void   wxGridTableBase_SetRowAttr(IntPtr self, IntPtr attr, int row);
        static extern (C) void   wxGridTableBase_SetColAttr(IntPtr self, IntPtr attr, int col);
        //! \endcond
        
        //-----------------------------------------------------------------------------
    
    public abstract class GridTableBase : wxObject//ClientData 
    {
        public this();        
        public this(IntPtr wxobj);
        //public static wxObject New(IntPtr ptr) ;
        static extern (C) private int staticGetNumberRows(GridTableBase obj);
        public abstract int GetNumberRows();
        static extern (C) private int staticGetNumberCols(GridTableBase obj);
        public abstract int GetNumberCols();
        static extern (C) private bool staticIsEmptyCell(GridTableBase obj, int row, int col);
        public abstract bool IsEmptyCell(int row, int col);
        static extern (C) private string staticGetValue(GridTableBase obj, int row, int col);
        public abstract string GetValue(int row, int col);
        static extern (C) private void staticDoSetValue(GridTableBase obj, int row, int col, IntPtr val);
        public abstract void SetValue(int row, int col, string val);
        static extern (C) private string staticGetTypeName(GridTableBase obj, int row, int col);
        public /+virtual+/ string GetTypeName(int row, int col);
        static extern (C) private bool staticDoCanGetValueAs(GridTableBase obj, int row, int col, IntPtr typeName);
        public /+virtual+/ bool CanGetValueAs(int row, int col, string typeName);
        static extern (C) private bool staticDoCanSetValueAs(GridTableBase obj, int row, int col, IntPtr typeName);
        public /+virtual+/ bool CanSetValueAs(int row, int col, string typeName);
        static extern (C) private int staticGetValueAsLong(GridTableBase obj, int row, int col);
        public /+virtual+/ int GetValueAsLong(int row, int col);
        static extern (C) private double staticGetValueAsDouble(GridTableBase obj, int row, int col);
        public /+virtual+/ double GetValueAsDouble(int row, int col);
        static extern (C) private bool staticGetValueAsBool(GridTableBase obj, int row, int col);
        public /+virtual+/ bool GetValueAsBool(int row, int col);
        static extern (C) private void staticSetValueAsLong(GridTableBase obj, int row, int col, int val);
        public /+virtual+/ void SetValueAsLong(int row, int col, int val);
        static extern (C) private void staticSetValueAsDouble(GridTableBase obj, int row, int col, double val);
        public /+virtual+/ void SetValueAsDouble(int row, int col, double val);
        static extern (C) private void staticSetValueAsBool(GridTableBase obj, int row, int col, bool val);
        public /+virtual+/ void SetValueAsBool(int row, int col, bool val);
        static extern (C) private IntPtr staticDoGetValueAsCustom(GridTableBase obj, int row, int col, IntPtr typeName);
        public /+virtual+/ wxObject GetValueAsCustom(int row, int col, string typeName);
        static extern (C) private void staticDoSetValueAsCustom(GridTableBase obj, int row, int col, IntPtr typeName, IntPtr val);
        public /+virtual+/ void SetValueAsCustom(int row, int col, string typeName, wxObject val);
        static extern (C) private void staticDoSetView(GridTableBase obj, IntPtr grid);
        public /+virtual+/ void SetView(Grid grid);
        static extern (C) private IntPtr staticDoGetView(GridTableBase obj);
        public /+virtual+/ Grid GetView();
        static extern (C) private void staticClear(GridTableBase obj);
        public /+virtual+/ void Clear();
        static extern (C) private bool staticInsertRows(GridTableBase obj, int pos, int numRows);
        public /+virtual+/ bool InsertRows(int pos, int numRows);
        static extern (C) private bool staticAppendRows(GridTableBase obj, int numRows);
        public /+virtual+/ bool AppendRows(int numRows);
        static extern (C) private bool staticDeleteRows(GridTableBase obj, int pos, int numRows);
        public /+virtual+/ bool DeleteRows(int pos, int numRows);
        static extern (C) private bool staticInsertCols(GridTableBase obj, int pos, int numCols);
        public /+virtual+/ bool InsertCols(int pos, int numCols);
        static extern (C) private bool staticAppendCols(GridTableBase obj, int numCols);
        public /+virtual+/ bool AppendCols(int numCols);
        static extern (C) private bool staticDeleteCols(GridTableBase obj, int pos, int numCols);
        public /+virtual+/ bool DeleteCols(int pos, int numCols);
        static extern (C) private string staticGetRowLabelValue(GridTableBase obj, int row);
        public /+virtual+/ string GetRowLabelValue(int row);
        static extern (C) private string staticGetColLabelValue(GridTableBase obj, int col);
        public /+virtual+/ string GetColLabelValue(int col);
        static extern (C) private void staticDoSetRowLabelValue(GridTableBase obj, int row, IntPtr val);
        public /+virtual+/ void SetRowLabelValue(int row, string val);
        static extern (C) private void staticDoSetColLabelValue(GridTableBase obj, int col, IntPtr val);
        public /+virtual+/ void SetColLabelValue(int col, string val);
        static extern (C) private void staticDoSetAttrProvider(GridTableBase obj, IntPtr attrProvider);
        public void SetAttrProvider(GridCellAttrProvider attrProvider);
        static extern (C) private IntPtr staticDoGetAttrProvider(GridTableBase obj);
        public GridCellAttrProvider GetAttrProvider();
        static extern (C) private bool staticCanHaveAttributes(GridTableBase obj);
        public /+virtual+/ bool CanHaveAttributes();
        static extern (C) private IntPtr staticDoGetAttr(GridTableBase obj, int row, int col, int kind);
        public /+virtual+/ GridCellAttr GetAttr(int row, int col, GridCellAttr.AttrKind kind);
        static extern (C) private void staticDoSetAttr(GridTableBase obj, IntPtr attr, int row, int col);
        public /+virtual+/ void SetAttr(GridCellAttr attr, int row, int col);
        static extern (C) private void staticDoSetRowAttr(GridTableBase obj, IntPtr attr, int row);
        public /+virtual+/ void SetRowAttr(GridCellAttr attr, int row);
        static extern (C) private void staticDoSetColAttr(GridTableBase obj, IntPtr attr, int col);
        public /+virtual+/ void SetColAttr(GridCellAttr attr, int col);
    }
    
	extern (C) {
        alias IntPtr function(GridCellAttrProvider obj, int row, int col, int kind) Virtual_GetAttr;
        alias void function(GridCellAttrProvider obj, IntPtr attr, int row, int col) Virtual_SetAttr;
        alias void function(GridCellAttrProvider obj, IntPtr attr, int row) Virtual_SetRowAttr;
	}

        //! \cond EXTERN
        static extern (C) IntPtr wxGridCellAttrProvider_ctor();
	static extern (C) void wxGridCellAttrProvider_dtor(IntPtr self);
        static extern (C) void wxGridCellAttrProvider_RegisterVirtual(IntPtr self,GridCellAttrProvider obj, 
            Virtual_GetAttr getAttr,
            Virtual_SetAttr setAttr,
            Virtual_SetRowAttr setRowAttr,
            Virtual_SetRowAttr setColAttr);
	static extern (C) void wxGridCellAttrProvider_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
        static extern (C) IntPtr wxGridCellAttrProvider_GetAttr(IntPtr self, int row, int col, int kind);
        static extern (C) void wxGridCellAttrProvider_SetAttr(IntPtr self, IntPtr attr, int row, int col); 
        static extern (C) void wxGridCellAttrProvider_SetRowAttr(IntPtr self, IntPtr attr, int row); 
        static extern (C) void wxGridCellAttrProvider_SetColAttr(IntPtr self, IntPtr attr, int col); 
        static extern (C) void wxGridCellAttrProvider_UpdateAttrRows(IntPtr self, int pos, int numRows);
        static extern (C) void wxGridCellAttrProvider_UpdateAttrCols(IntPtr self, int pos, int numCols);
        //! \endcond
	
        //-----------------------------------------------------------------------------
        
    alias GridCellAttrProvider wxGridCellAttrProvider;
    public class GridCellAttrProvider : wxObject  // ClientData
    {
        public this(IntPtr wxobj);	
	    private this(IntPtr wxobj, bool memOwn);        
        public this();
	    public static wxObject New(IntPtr ptr);
	    override protected void dtor();
        static extern (C) private IntPtr staticDoGetAttr(GridCellAttrProvider obj, int row, int col, int kind);
        public /+virtual+/ GridCellAttr GetAttr(int row, int col, GridCellAttr.AttrKind kind);
        static extern (C) private void staticDoSetAttr(GridCellAttrProvider obj, IntPtr attr, int row, int col);
        public /+virtual+/ void SetAttr(GridCellAttr attr, int row, int col);
        static extern (C) private void staticDoSetRowAttr(GridCellAttrProvider obj, IntPtr attr, int row);
        public /+virtual+/ void SetRowAttr(GridCellAttr attr, int row);
        static extern (C) private void staticDoSetColAttr(GridCellAttrProvider obj, IntPtr attr, int col);
        public /+virtual+/ void SetColAttr(GridCellAttr attr, int col);
        public void UpdateAttrRows(int pos, int numRows);
        public void UpdateAttrCols(int pos, int numCols);
    }
