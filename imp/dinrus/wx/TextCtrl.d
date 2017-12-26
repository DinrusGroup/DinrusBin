module wx.TextCtrl;
public import wx.common;
public import wx.Control;
public import wx.CommandEvent;
public import wx.KeyEvent;

	public enum TextAttrAlignment
	{
		wxTEXT_ALIGNMENT_DEFAULT,
		wxTEXT_ALIGNMENT_LEFT,
		wxTEXT_ALIGNMENT_CENTRE,
		wxTEXT_ALIGNMENT_CENTER = wxTEXT_ALIGNMENT_CENTRE,
		wxTEXT_ALIGNMENT_RIGHT,
		wxTEXT_ALIGNMENT_JUSTIFIED
	}
	
	//---------------------------------------------------------------------
	
	public enum TextCtrlHitTestResult
	{
		wxTE_HT_UNKNOWN = -2,
		wxTE_HT_BEFORE,      
		wxTE_HT_ON_TEXT,     
		wxTE_HT_BELOW,       
		wxTE_HT_BEYOND       
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxTextAttr_ctor(IntPtr colText, IntPtr colBack, IntPtr font, int alignment);
		static extern (C) IntPtr wxTextAttr_ctor2();
		static extern (C) void   wxTextAttr_dtor(IntPtr self);
		static extern (C) void   wxTextAttr_Init(IntPtr self);
		static extern (C) void   wxTextAttr_SetTextColour(IntPtr self, IntPtr colText);
		static extern (C) IntPtr wxTextAttr_GetTextColour(IntPtr self);
		static extern (C) void   wxTextAttr_SetBackgroundColour(IntPtr self, IntPtr colBack);
		static extern (C) IntPtr wxTextAttr_GetBackgroundColour(IntPtr self);
		static extern (C) void   wxTextAttr_SetFont(IntPtr self, IntPtr font);
		static extern (C) IntPtr wxTextAttr_GetFont(IntPtr self);
		static extern (C) bool   wxTextAttr_HasTextColour(IntPtr self);
		static extern (C) bool   wxTextAttr_HasBackgroundColour(IntPtr self);
		static extern (C) bool   wxTextAttr_HasFont(IntPtr self);
		static extern (C) bool   wxTextAttr_IsDefault(IntPtr self);
		
		static extern (C) void   wxTextAttr_SetAlignment(IntPtr self, int alignment);
		static extern (C) int    wxTextAttr_GetAlignment(IntPtr self);
		static extern (C) void   wxTextAttr_SetTabs(IntPtr self, IntPtr tabs);
		static extern (C) IntPtr wxTextAttr_GetTabs(IntPtr self);
		static extern (C) void   wxTextAttr_SetLeftIndent(IntPtr self, int indent, int subIndent);
		static extern (C) int    wxTextAttr_GetLeftIndent(IntPtr self);
		static extern (C) int    wxTextAttr_GetLeftSubIndent(IntPtr self);
		static extern (C) void   wxTextAttr_SetRightIndent(IntPtr self, int indent);
		static extern (C) int    wxTextAttr_GetRightIndent(IntPtr self);
		static extern (C) void   wxTextAttr_SetFlags(IntPtr self, uint flags);
		static extern (C) uint   wxTextAttr_GetFlags(IntPtr self);
		static extern (C) bool   wxTextAttr_HasAlignment(IntPtr self);
		static extern (C) bool   wxTextAttr_HasTabs(IntPtr self);
		static extern (C) bool   wxTextAttr_HasLeftIndent(IntPtr self);
		static extern (C) bool   wxTextAttr_HasRightIndent(IntPtr self);
		static extern (C) bool   wxTextAttr_HasFlag(IntPtr self, uint flag);
		//! \endcond
		
		//---------------------------------------------------------------------
		
	alias TextAttr wxTextAttr;
	public class TextAttr : wxObject
	{
		public const int wxTEXT_ATTR_TEXT_COLOUR =		0x0001;
		public const int wxTEXT_ATTR_BACKGROUND_COLOUR =	0x0002;
		public const int wxTEXT_ATTR_FONT_FACE =		0x0004;
		public const int wxTEXT_ATTR_FONT_SIZE = 		0x0008;
		public const int wxTEXT_ATTR_FONT_WEIGHT =		0x0010;
		public const int wxTEXT_ATTR_FONT_ITALIC =		0x0020;
		public const int wxTEXT_ATTR_FONT_UNDERLINE =		0x0040;
		public const int wxTEXT_ATTR_FONT = wxTEXT_ATTR_FONT_FACE | wxTEXT_ATTR_FONT_SIZE | 
							wxTEXT_ATTR_FONT_WEIGHT | wxTEXT_ATTR_FONT_ITALIC | 
							wxTEXT_ATTR_FONT_UNDERLINE;
		public const int wxTEXT_ATTR_ALIGNMENT =		0x0080;
		public const int wxTEXT_ATTR_LEFT_INDENT =		0x0100;
		public const int wxTEXT_ATTR_RIGHT_INDENT =		0x0200;
		public const int wxTEXT_ATTR_TABS =			0x0400;

		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
	        public this(Colour colText, Colour colBack=null, Font font=null, TextAttrAlignment alignment = TextAttrAlignment.wxTEXT_ALIGNMENT_DEFAULT);
		override protected void dtor();
		public void TextColour(Colour value) ;
		public Colour TextColour() ;
		public void BackgroundColour(Colour value) ;
		public Colour BackgroundColour() ;
		public void font(Font value);
		public Font font();
		public void Alignment(TextAttrAlignment value);
		public TextAttrAlignment Alignment();
		public void Tabs(int[] value);
		public int[] Tabs();
		public void SetLeftIndent(int indent);
		public void SetLeftIndent(int indent, int subIndent);
		public int LeftIndent();
		public int LeftSubIndent() ;
		public void RightIndent(int value);
		public int RightIndent() ;
		public void Flags(int value);
		public int Flags();
		public bool HasTextColour() ;
		public bool HasBackgroundColour() ;
		public bool HasFont() ;
		public bool HasAlignment() ;
		public bool HasTabs();
		public bool HasLeftIndent();
		public bool HasRightIndent() ;
		public bool HasFlag(int flag);
		public bool IsDefault();
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxTextCtrl_GetValue(IntPtr self);
		static extern (C) void   wxTextCtrl_SetValue(IntPtr self, string value);
		static extern (C) IntPtr wxTextCtrl_GetRange(IntPtr self, uint from, uint to);
		static extern (C) int    wxTextCtrl_GetLineLength(IntPtr self, uint lineNo);
		static extern (C) IntPtr wxTextCtrl_GetLineText(IntPtr self, uint lineNo);
		static extern (C) int    wxTextCtrl_GetNumberOfLines(IntPtr self);
		static extern (C) bool   wxTextCtrl_IsModified(IntPtr self);
		static extern (C) bool   wxTextCtrl_IsEditable(IntPtr self);
		static extern (C) bool   wxTextCtrl_IsSingleLine(IntPtr self);
		static extern (C) bool   wxTextCtrl_IsMultiLine(IntPtr self);
		static extern (C) void   wxTextCtrl_GetSelection(IntPtr self, out int from, out int to);
		static extern (C) IntPtr wxTextCtrl_GetStringSelection(IntPtr self);
		static extern (C) void   wxTextCtrl_Clear(IntPtr self);
		static extern (C) void   wxTextCtrl_Replace(IntPtr self, uint from, uint to, string value);
		static extern (C) void   wxTextCtrl_Remove(IntPtr self, uint from, uint to);
		static extern (C) bool   wxTextCtrl_LoadFile(IntPtr self, string file);
		static extern (C) bool   wxTextCtrl_SaveFile(IntPtr self, string file);
		static extern (C) void   wxTextCtrl_MarkDirty(IntPtr self);
		static extern (C) void   wxTextCtrl_DiscardEdits(IntPtr self);
		static extern (C) void   wxTextCtrl_SetMaxLength(IntPtr self, uint len);
		static extern (C) void   wxTextCtrl_WriteText(IntPtr self, string text);
		static extern (C) void   wxTextCtrl_AppendText(IntPtr self, string text);
		static extern (C) bool   wxTextCtrl_EmulateKeyPress(IntPtr self, IntPtr evt);
		static extern (C) bool   wxTextCtrl_SetStyle(IntPtr self, uint start, uint end, IntPtr style);
		static extern (C) bool   wxTextCtrl_GetStyle(IntPtr self, uint position, inout IntPtr style);
		static extern (C) bool   wxTextCtrl_SetDefaultStyle(IntPtr self, IntPtr style);
		static extern (C) IntPtr wxTextCtrl_GetDefaultStyle(IntPtr self);
		static extern (C) uint   wxTextCtrl_XYToPosition(IntPtr self, uint x, uint y);
		static extern (C) bool   wxTextCtrl_PositionToXY(IntPtr self, uint pos, out int x, out int y);
		static extern (C) void   wxTextCtrl_ShowPosition(IntPtr self, uint pos);
		static extern (C) int    wxTextCtrl_HitTest(IntPtr self, inout Point pt, out int pos);
		static extern (C) int    wxTextCtrl_HitTest2(IntPtr self, inout Point pt, out int col, out int row);
		static extern (C) void   wxTextCtrl_Copy(IntPtr self);
		static extern (C) void   wxTextCtrl_Cut(IntPtr self);
		static extern (C) void   wxTextCtrl_Paste(IntPtr self);
		static extern (C) bool   wxTextCtrl_CanCopy(IntPtr self);
		static extern (C) bool   wxTextCtrl_CanCut(IntPtr self);
		static extern (C) bool   wxTextCtrl_CanPaste(IntPtr self);
		static extern (C) void   wxTextCtrl_Undo(IntPtr self);
		static extern (C) void   wxTextCtrl_Redo(IntPtr self);
		static extern (C) bool   wxTextCtrl_CanUndo(IntPtr self);
		static extern (C) bool   wxTextCtrl_CanRedo(IntPtr self);
		static extern (C) void   wxTextCtrl_SetInsertionPoint(IntPtr self, uint pos);
		static extern (C) void   wxTextCtrl_SetInsertionPointEnd(IntPtr self);
		static extern (C) uint   wxTextCtrl_GetInsertionPoint(IntPtr self);
		static extern (C) uint   wxTextCtrl_GetLastPosition(IntPtr self);
		static extern (C) void   wxTextCtrl_SetSelection(IntPtr self, uint from, uint to);
		static extern (C) void   wxTextCtrl_SelectAll(IntPtr self);
		static extern (C) void   wxTextCtrl_SetEditable(IntPtr self, bool editable);
		static extern (C)        IntPtr wxTextCtrl_ctor();
		static extern (C) bool   wxTextCtrl_Create(IntPtr self, IntPtr parent, int id, string value, inout Point pos, inout Size size, uint style, IntPtr validator, string name);
		static extern (C) bool   wxTextCtrl_Enable(IntPtr self, bool enable);
		static extern (C) void   wxTextCtrl_OnDropFiles(IntPtr self, IntPtr evt);
		static extern (C) bool   wxTextCtrl_SetFont(IntPtr self, IntPtr font);
		static extern (C) bool   wxTextCtrl_SetForegroundColour(IntPtr self, IntPtr colour);
		static extern (C) bool   wxTextCtrl_SetBackgroundColour(IntPtr self, IntPtr colour);
		static extern (C) void   wxTextCtrl_Freeze(IntPtr self);
		static extern (C) void   wxTextCtrl_Thaw(IntPtr self);
		static extern (C) bool   wxTextCtrl_ScrollLines(IntPtr self, int lines);
		static extern (C) bool   wxTextCtrl_ScrollPages(IntPtr self, int pages);
		//! \endcond

		//---------------------------------------------------------------------
        
	alias TextCtrl wxTextCtrl;
	public class TextCtrl : Control
	{
		public const int wxTE_NO_VSCROLL       = 0x0002;
		public const int wxTE_AUTO_SCROLL      = 0x0008;
	
		public const int wxTE_READONLY         = 0x0010;
		public const int wxTE_MULTILINE        = 0x0020;
		public const int wxTE_PROCESS_TAB      = 0x0040;
	
		public const int wxTE_LEFT             = 0x0000;
		public const int wxTE_CENTER           = Alignment.wxALIGN_CENTER;
		public const int wxTE_RIGHT            = Alignment.wxALIGN_RIGHT;
	
		public const int wxTE_RICH             = 0x0080;
		public const int wxTE_PROCESS_ENTER    = 0x0400;
		public const int wxTE_PASSWORD         = 0x0800;
	
		public const int wxTE_AUTO_URL         = 0x1000;
		public const int wxTE_NOHIDESEL        = 0x2000;
		public const int wxTE_DONTWRAP         = Window.wxHSCROLL;
		public const int wxTE_LINEWRAP         = 0x4000;
		public const int wxTE_WORDWRAP         = 0x0000;
		public const int wxTE_RICH2            = 0x8000;


		public const string wxTextCtrlNameStr = "text";
		//---------------------------------------------------------------------

		public this(IntPtr wxobj);
		public this(Window parent, int id, string value="", Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, Validator validator = null, string name = wxTextCtrlNameStr);
		public static wxObject New(IntPtr wxobj);
		public this(Window parent, string value="", Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, Validator validator = null, string name = wxTextCtrlNameStr);
		public void Clear();
		public override void BackgroundColour(Colour value);
		public override void ForegroundColour(Colour value);
		public string Value() ;
		public void Value(string value) ;
		public string GetRange(int from, int to);
		public int LineLength(int lineNo);
		public string GetLineText(int lineNo);
		public int GetNumberOfLines();
		public bool IsModified() ;
		public bool IsEditable();
		public bool IsSingleLine() ;
		public bool IsMultiLine() ;
		public void GetSelection(out int from, out int to);
		public void Replace(int from, int to, string value);
		public void Remove(int from, int to);
		public bool LoadFile(string file);
		public bool SaveFile(string file);
		public void DiscardEdits();
		public void MarkDirty();
		public void MaxLength(int value) ;
		public void WriteText(string text);
		public void AppendText(string text);
		public bool EmulateKeyPress(KeyEvent evt);
		public bool SetStyle(int start, int end, TextAttr style);
		public bool GetStyle(int position, inout TextAttr style);
		public bool SetDefaultStyle(TextAttr style);
		public TextAttr GetDefaultStyle();
		public int XYToPosition(int x, int y);
		public bool PositionToXY(int pos, out int x, out int y);
		public void ShowPosition(int pos);
		public TextCtrlHitTestResult HitTest(Point pt, out int pos);
		public TextCtrlHitTestResult HitTest(Point pt, out int col, out int row);
		public void Copy();
		public void Cut();
		public void Paste();
		public bool CanCopy();
		public bool CanCut();
		public bool CanPaste();
		public void Undo();
		public void Redo();
		public bool CanUndo();
		public bool CanRedo();
		public void InsertionPoint(int value) ;
		public int InsertionPoint() ;
		public void SetInsertionPointEnd();
		public int GetLastPosition();
		public void SetSelection(int from, int to);
		public void SelectAll();
		public void SetEditable(bool editable);
		public bool Enable(bool enable);
		public /+virtual+/ void OnDropFiles(Event evt);
		public override void Freeze();
		public override void Thaw();
		public override bool ScrollLines(int lines);
		public override bool ScrollPages(int pages);
		public override void UpdateUI_Add(EventListener value);
		public override void UpdateUI_Remove(EventListener value)	;
		public void Enter_Add(EventListener value) ;
		public void Enter_Remove(EventListener value) ;
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxTextUrlEvent_ctor(int id, IntPtr evtMouse, uint start, uint end);
		static extern (C) uint   wxTextUrlEvent_GetURLStart(IntPtr self);
		static extern (C) uint   wxTextUrlEvent_GetURLEnd(IntPtr self);
		//! \endcond
	
	alias TextUrlEvent wxTextUrlEvent;
	public class TextUrlEvent : CommandEvent
    	{
		// TODO: Replace Event with EventMouse
		public this(int id, Event evtMouse, int start, int end);
	}
