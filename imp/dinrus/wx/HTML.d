
module wx.HTML;
public import wx.common;
public import wx.ScrolledWindow;
public import wx.Frame;
public import wx.Config;
public import wx.PrintData;
public import wx.MouseEvent;

//version(LDC) { pragma(ldc, "verbose") }

//class HtmlContainerCell;
//class HtmlFilter;
//class HtmlTag;

	public enum HtmlURLType
	{
		wxHTML_URL_PAGE,
		wxHTML_URL_IMAGE,
		wxHTML_URL_OTHER
	}

	//-----------------------------------------------------------------------------

	public enum HtmlOpeningStatus
	{
		wxHTML_OPEN,
		wxHTML_BLOCK,
		wxHTML_REDIRECT
	}

	//-----------------------------------------------------------------------------

		//! \cond EXTERN
        static extern (C) IntPtr wxHtmlTag_GetParent(IntPtr self);
        static extern (C) IntPtr wxHtmlTag_GetFirstSibling(IntPtr self);
        static extern (C) IntPtr wxHtmlTag_GetLastSibling(IntPtr self);
        static extern (C) IntPtr wxHtmlTag_GetChildren(IntPtr self);
        static extern (C) IntPtr wxHtmlTag_GetPreviousSibling(IntPtr self);
        static extern (C) IntPtr wxHtmlTag_GetNextSibling(IntPtr self);
        static extern (C) IntPtr wxHtmlTag_GetNextTag(IntPtr self);
        static extern (C) IntPtr wxHtmlTag_GetName(IntPtr self);
        static extern (C) bool   wxHtmlTag_HasParam(IntPtr self, string par);
        static extern (C) IntPtr wxHtmlTag_GetParam(IntPtr self, string par, bool with_commas);
        static extern (C) bool   wxHtmlTag_GetParamAsColour(IntPtr self, string par, IntPtr clr);
        static extern (C) bool   wxHtmlTag_GetParamAsInt(IntPtr self, string par, inout int clr);
        static extern (C) int    wxHtmlTag_ScanParam(IntPtr self, string par, string format, IntPtr param);
        static extern (C) IntPtr wxHtmlTag_GetAllParams(IntPtr self);
        static extern (C) bool   wxHtmlTag_IsEnding(IntPtr self);
        static extern (C) bool   wxHtmlTag_HasEnding(IntPtr self);
        static extern (C) int    wxHtmlTag_GetBeginPos(IntPtr self);
        static extern (C) int    wxHtmlTag_GetEndPos1(IntPtr self);
        static extern (C) int    wxHtmlTag_GetEndPos2(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias HtmlTag wxHtmlTag;
    public class HtmlTag : wxObject
    {
        public this(IntPtr wxobj) ;
	public static wxObject New(IntPtr ptr) ;
	private static HtmlTag FindObj(IntPtr ptr);
        public HtmlTag Parent() ;
        public HtmlTag FirstSibling() ;
        public HtmlTag LastSibling();
        public HtmlTag Children() ;
        public HtmlTag PreviousSibling() ;
        public HtmlTag NextSibling() ;
        public HtmlTag NextTag() ;
        public string Name() ;
        public bool HasParam(string par);
        public string GetParam(string par, bool with_commas);
        public bool GetParamAsColour(string par, Colour clr);
        public bool GetParamAsInt(string par, out int clr);
        public int ScanParam(string par, string format, wxObject param);
        public string AllParams() ;
        // public bool IsEnding() ;
        public bool HasEnding() ;
        public int BeginPos();
        public int EndPos1();
        public int EndPos2();
       // public static implicit operator HtmlTag (IntPtr obj);
   }

    public abstract class HtmlFilter : wxObject
    {
        // TODO

        public this(IntPtr wxobj);
        /*public abstract bool CanRead(FSFile file);
        public abstract string ReadFile(FSFile file);*/
    }

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
        static extern (C) IntPtr wxHtmlCell_ctor();
        static extern (C) void   wxHtmlCell_SetParent(IntPtr self, IntPtr p);
        static extern (C) IntPtr wxHtmlCell_GetParent(IntPtr self);
        static extern (C) int    wxHtmlCell_GetPosX(IntPtr self);
        static extern (C) int    wxHtmlCell_GetPosY(IntPtr self);
        static extern (C) int    wxHtmlCell_GetWidth(IntPtr self);
        static extern (C) int    wxHtmlCell_GetHeight(IntPtr self);
        static extern (C) int    wxHtmlCell_GetDescent(IntPtr self);
        static extern (C) IntPtr wxHtmlCell_GetId(IntPtr self);
        static extern (C) void   wxHtmlCell_SetId(IntPtr self, string id);
        static extern (C) IntPtr wxHtmlCell_GetNext(IntPtr self);
        static extern (C) void   wxHtmlCell_SetPos(IntPtr self, int x, int y);
        static extern (C) void   wxHtmlCell_SetLink(IntPtr self, IntPtr link);
        static extern (C) void   wxHtmlCell_SetNext(IntPtr self, IntPtr cell);
        static extern (C) void   wxHtmlCell_Layout(IntPtr self, int w);
        static extern (C) void   wxHtmlCell_Draw(IntPtr self, IntPtr dc, int x, int y, int view_y1, int view_y2, IntPtr info);
        static extern (C) void   wxHtmlCell_DrawInvisible(IntPtr self, IntPtr dc, int x, int y, IntPtr info);
        static extern (C) IntPtr wxHtmlCell_Find(IntPtr self, int condition, IntPtr param);
        static extern (C) void   wxHtmlCell_OnMouseClick(IntPtr self, IntPtr parent, int x, int y, IntPtr evt);
        static extern (C) bool   wxHtmlCell_AdjustPagebreak(IntPtr self, inout int pagebreak);
        static extern (C) void   wxHtmlCell_SetCanLiveOnPagebreak(IntPtr self, bool can);
        static extern (C) void   wxHtmlCell_GetHorizontalConstraints(IntPtr self, inout int left, inout int right);
        static extern (C) bool   wxHtmlCell_IsTerminalCell(IntPtr self);
        static extern (C) IntPtr wxHtmlCell_FindCellByPos(IntPtr self, int x, int y);
        //! \endcond

    alias HtmlCell wxHtmlCell;
    public class HtmlCell : wxObject
    {
        //-----------------------------------------------------------------------------

        public this(IntPtr wxobj) ;
        public this();
	    public static wxObject New(IntPtr ptr) ;
	    public static HtmlCell FindObj(IntPtr ptr) ;
        public void Parent(HtmlContainerCell value) ;
        public HtmlContainerCell Parent();
        public int X() ;
        public int Y() ;
        public int Width();
        public int Height();
	    public int PosX();
	    public int PosY() ;
	    public Point Position() ;
	    public void  Position(Point pt) ;
	    public Size size() ;
	    public Rectangle rect();
        public int Descent();
        public /+virtual+/ string Id() ;
        public /+virtual+/ void Id(string value) ;
        public HtmlCell Next() ;
        public void Next(HtmlCell value);
        public void SetPos(int x, int y);
        public void Link(HtmlLinkInfo value) ;
        public /+virtual+/ void Layout(int w);
        public /+virtual+/ void Draw(DC dc, int x, int y, int view_y1, int view_y2, HtmlRenderingInfo info);
        public /+virtual+/ void DrawInvisible(DC dc, int x, int y, HtmlRenderingInfo info);
        public /+virtual+/ HtmlCell Find(int condition, wxObject param);
        public /+virtual+/ void OnMouseClick(Window parent, int x, int y, MouseEvent evt);
        public /+virtual+/ bool AdjustPagebreak(inout int pagebreak);
        public void CanLiveOnPagebreak(bool value) ;
        //public void GetHorizontalConstraints(out int left, out int right);
        public /+virtual+/ bool IsTerminalCell();
        public HtmlCell FindCellByPos(int x, int y);
       // public static implicit operator HtmlCell (IntPtr obj) ;
    }

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
		static extern (C) IntPtr wxHtmlFontCell_ctor(IntPtr font);
		static extern (C) void   wxHtmlFontCell_Draw(IntPtr self, IntPtr dc, int x, int y, int view_y1, int view_y2, IntPtr info);
		static extern (C) void   wxHtmlFontCell_DrawInvisible(IntPtr self, IntPtr dc, int x, int y, IntPtr info);
        //! \endcond

	alias HtmlFontCell wxHtmlFontCell;
	public class HtmlFontCell : HtmlCell
	{
		//-----------------------------------------------------------------------------

		public this(IntPtr wxobj);
		public this(Font font);
		public override void Draw(DC dc, int x, int y, int view_y1, int view_y2, HtmlRenderingInfo info);
		public override void DrawInvisible(DC dc, int x, int y, HtmlRenderingInfo info);
	}

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
        static extern (C) IntPtr wxHtmlContainerCell_ctor(IntPtr parent);
        static extern (C) void   wxHtmlContainerCell_Layout(IntPtr self, int w);
        static extern (C) void   wxHtmlContainerCell_Draw(IntPtr self, IntPtr dc, int x, int y, int view_y1, int view_y2, IntPtr info);
        static extern (C) void   wxHtmlContainerCell_DrawInvisible(IntPtr self, IntPtr dc, int x, int y, IntPtr info);
        static extern (C) bool   wxHtmlContainerCell_AdjustPagebreak(IntPtr self, inout int pagebreak);
        static extern (C) void   wxHtmlContainerCell_InsertCell(IntPtr self, IntPtr cell);
        static extern (C) void   wxHtmlContainerCell_SetAlignHor(IntPtr self, int al);
        static extern (C) int    wxHtmlContainerCell_GetAlignHor(IntPtr self);
        static extern (C) void   wxHtmlContainerCell_SetAlignVer(IntPtr self, int al);
        static extern (C) int    wxHtmlContainerCell_GetAlignVer(IntPtr self);
        static extern (C) void   wxHtmlContainerCell_SetIndent(IntPtr self, int i, int what, int units);
        static extern (C) int    wxHtmlContainerCell_GetIndent(IntPtr self, int ind);
        static extern (C) int    wxHtmlContainerCell_GetIndentUnits(IntPtr self, int ind);
        static extern (C) void   wxHtmlContainerCell_SetAlign(IntPtr self, IntPtr tag);
        static extern (C) void   wxHtmlContainerCell_SetWidthFloat(IntPtr self, int w, int units);
        static extern (C) void   wxHtmlContainerCell_SetWidthFloatTag(IntPtr self, IntPtr tag, double pixel_scale);
        static extern (C) void   wxHtmlContainerCell_SetMinHeight(IntPtr self, int h, int alignment);
        static extern (C) void   wxHtmlContainerCell_SetBackgroundColour(IntPtr self, IntPtr clr);
        static extern (C) IntPtr wxHtmlContainerCell_GetBackgroundColour(IntPtr self);
        static extern (C) void   wxHtmlContainerCell_SetBorder(IntPtr self, IntPtr clr1, IntPtr clr2);
        static extern (C) IntPtr wxHtmlContainerCell_GetLink(IntPtr self, int x, int y);
        static extern (C) IntPtr wxHtmlContainerCell_Find(IntPtr self, int condition, IntPtr param);
        static extern (C) void   wxHtmlContainerCell_OnMouseClick(IntPtr self, IntPtr parent, int x, int y, IntPtr evt);
        static extern (C) void   wxHtmlContainerCell_GetHorizontalConstraints(IntPtr self, inout int left, inout int right);
        static extern (C) IntPtr wxHtmlContainerCell_GetFirstCell(IntPtr self);
        static extern (C) bool   wxHtmlContainerCell_IsTerminalCell(IntPtr self);
        static extern (C) IntPtr wxHtmlContainerCell_FindCellByPos(IntPtr self, int x, int y);
        //! \endcond

    alias HtmlContainerCell wxHtmlContainerCell;
    public class HtmlContainerCell : HtmlCell
    {
        //-----------------------------------------------------------------------------

        public this(IntPtr wxobj);
        public this(HtmlContainerCell parent);
	public static wxObject New(IntPtr ptr);
        public override void Layout(int w);
        public override void Draw(DC dc, int x, int y, int view_y1, int view_y2, HtmlRenderingInfo info);
        public override void DrawInvisible(DC dc, int x, int y, HtmlRenderingInfo info);
        public override bool AdjustPagebreak(inout int pagebreak);
        public void InsertCell(HtmlCell cell);
        public void AlignHor(int value) ;
        public int AlignHor() ;
        public void AlignVer(int value) ;
        public int AlignVer() ;
        public void SetIndent(int i, int what, int units);
        public int GetIndent(int ind);
        public int GetIndentUnits(int ind);
        public void Align(HtmlTag value);
        public void SetWidthFloat(int w, int units);
        public void SetWidthFloat(HtmlTag tag, double pixel_scale);
        public void SetMinHeight(int h, int alignment);
        public void BackgroundColour(Colour value) ;
        public Colour BackgroundColour() ;
        public void SetBorder(Colour clr1, Colour clr2);
        public /+virtual+/ HtmlLinkInfo GetLink(int x, int y);
        public override HtmlCell Find(int condition, wxObject param);
        public override void OnMouseClick(Window parent, int x, int y, MouseEvent evt);
       // public void GetHorizontalConstraints(out int left, out int right);
        //public HtmlCell FirstCell() ;
        public override bool IsTerminalCell();
        public override HtmlCell FindCellByPos(int x, int y);
    }

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
		static extern (C) IntPtr wxHtmlColourCell_ctor(IntPtr clr, int flags);
		static extern (C) void   wxHtmlColourCell_Draw(IntPtr self, IntPtr dc, int x, int y, int view_y1, int view_y2, IntPtr info);
		static extern (C) void   wxHtmlColourCell_DrawInvisible(IntPtr self, IntPtr dc, int x, int y, IntPtr info);
        //! \endcond

	alias HtmlColourCell wxHtmlColourCell;
	public class HtmlColourCell : HtmlCell
	{
		//-----------------------------------------------------------------------------

		public this(IntPtr wxobj);
		public  this(Colour clr, int flags);
		public override void Draw(DC dc, int x, int y, int view_y1, int view_y2, HtmlRenderingInfo info);
		public override void DrawInvisible(DC dc, int x, int y, HtmlRenderingInfo info);
	}

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
		static extern (C) IntPtr wxHtmlLinkInfo_ctor();
		/*static extern (C) IntPtr wxHtmlLinkInfo_ctor(string href, string target);*/
		/*static extern (C) IntPtr wxHtmlLinkInfo_ctor(IntPtr l);*/
		static extern (C) void   wxHtmlLinkInfo_SetEvent(IntPtr self, IntPtr e);
		static extern (C) void   wxHtmlLinkInfo_SetHtmlCell(IntPtr self, IntPtr e);
		static extern (C) IntPtr wxHtmlLinkInfo_GetHref(IntPtr self);
		static extern (C) IntPtr wxHtmlLinkInfo_GetTarget(IntPtr self);
		static extern (C) IntPtr wxHtmlLinkInfo_GetEvent(IntPtr self);
		static extern (C) IntPtr wxHtmlLinkInfo_GetHtmlCell(IntPtr self);
        //! \endcond

		//-----------------------------------------------------------------------------

	alias HtmlLinkInfo wxHtmlLinkInfo;
	public class HtmlLinkInfo : wxObject
	{
		public this(IntPtr wxobj);
		public  this();
		//public  this(string href, string target);
		public static wxObject New(IntPtr ptr);
		//public  this(HtmlLinkInfo l);
		public void event(MouseEvent value) ;
		public MouseEvent event() ;
		public string Href();
		public string Target() ;
		public HtmlCell htmlCell();
		public void htmlCell(HtmlCell value) ;
	}

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
        static extern (C) IntPtr wxHtmlWidgetCell_ctor(IntPtr wnd, int w);
        static extern (C) void   wxHtmlWidgetCell_Draw(IntPtr self, IntPtr dc, int x, int y, int view_y1, int view_y2, IntPtr info);
        static extern (C) void   wxHtmlWidgetCell_DrawInvisible(IntPtr self, IntPtr dc, int x, int y, IntPtr info);
        static extern (C) void   wxHtmlWidgetCell_Layout(IntPtr self, int w);
        //! \endcond

        //-----------------------------------------------------------------------------

    alias HtmlWidgetCell wxHtmlWidgetCell;
    public class HtmlWidgetCell : HtmlCell
    {
		public this(IntPtr wxobj);
        public this(Window wnd, int w);
        public override void Draw(DC dc, int x, int y, int view_y1, int view_y2, HtmlRenderingInfo info);
        public override void DrawInvisible(DC dc, int x, int y, HtmlRenderingInfo info);
        public override void Layout(int w);
    }

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
        static extern (C) IntPtr wxHtmlWordCell_ctor(string word, IntPtr dc);
        static extern (C) void   wxHtmlWordCell_Draw(IntPtr self, IntPtr dc, int x, int y, int view_y1, int view_y2, IntPtr info);
        //! \endcond

        //-----------------------------------------------------------------------------

    alias HtmlWordCell wxHtmlWordCell;
    public class HtmlWordCell : HtmlCell
    {
		public this(IntPtr wxobj);
        public  this(string word, DC dc);
        public override void Draw(DC dc, int x, int y, int view_y1, int view_y2, HtmlRenderingInfo info);
    }

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
        static extern (C) bool   wxHtmlFilterPlainText_CanRead(IntPtr self, IntPtr file);
        static extern (C) IntPtr wxHtmlFilterPlainText_ReadFile(IntPtr self, IntPtr file);
        //! \endcond

        //-----------------------------------------------------------------------------

    alias HtmlFilterPlainText wxHtmlFilterPlainText;
    public class HtmlFilterPlainText : HtmlFilter
    {
        public this(IntPtr wxobj) ;

        //-----------------------------------------------------------------------------

        /*public override bool CanRead(FSFile file)
        {
            return wxHtmlFilterPlainText_CanRead(wxobj, wxObject.SafePtr(file));
        }

        //-----------------------------------------------------------------------------

        public override string ReadFile(FSFile file)
        {
            return cast(string) new wxString(wxHtmlFilterPlainText_ReadFile(wxobj, wxObject.SafePtr(file)));
        }
    }

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
        static extern (C) bool   wxHtmlFilterHTML_CanRead(IntPtr self, IntPtr file);
        static extern (C) IntPtr wxHtmlFilterHTML_ReadFile(IntPtr self, IntPtr file);
        //! \endcond

        //-----------------------------------------------------------------------------

    alias HtmlFilterHTML wxHtmlFilterHTML;
    public class HtmlFilterHTML : HtmlFilter
    {
        public this(IntPtr wxobj)
            { super(wxobj); }

        //-----------------------------------------------------------------------------

        /*public override bool CanRead(FSFile file)
        {
            return wxHtmlFilterHTML_CanRead(wxobj, wxObject.SafePtr(file));
        }

        //-----------------------------------------------------------------------------

        public override string ReadFile(FSFile file)
        {
            return cast(string) new wxString(wxHtmlFilterHTML_ReadFile(wxobj, wxObject.SafePtr(file)));
        }*/
    }

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
        static extern (C) IntPtr wxHtmlTagsModule_ctor();
        static extern (C) bool   wxHtmlTagsModule_OnInit(IntPtr self);
        static extern (C) void   wxHtmlTagsModule_OnExit(IntPtr self);
        static extern (C) void   wxHtmlTagsModule_FillHandlersTable(IntPtr self, IntPtr parser);
        //! \endcond

        //-----------------------------------------------------------------------------

    alias HtmlTagsModule wxHtmlTagsModule;
    public class HtmlTagsModule : wxObject // TODO: Module
    {
		public this(IntPtr wxobj);
        public this();
        public bool OnInit();
        public void OnExit();
        public void FillHandlersTable(HtmlWinParser  parser);
    }

	//-----------------------------------------------------------------------------

    public abstract class HtmlWinTagHandler : HtmlTagHandler
    {
        public this(IntPtr wxobj);
    }

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
        static extern (C) IntPtr wxHtmlWinParser_ctor(IntPtr wnd);
        static extern (C) void   wxHtmlWinParser_InitParser(IntPtr self, string source);
        static extern (C) void   wxHtmlWinParser_DoneParser(IntPtr self);
        static extern (C) IntPtr wxHtmlWinParser_GetProduct(IntPtr self);
        static extern (C) IntPtr wxHtmlWinParser_OpenURL(IntPtr self, int type, string url);
        static extern (C) void   wxHtmlWinParser_SetDC(IntPtr self, IntPtr dc, double pixel_scale);
        static extern (C) IntPtr wxHtmlWinParser_GetDC(IntPtr self);
        static extern (C) double wxHtmlWinParser_GetPixelScale(IntPtr self);
        static extern (C) int    wxHtmlWinParser_GetCharHeight(IntPtr self);
        static extern (C) int    wxHtmlWinParser_GetCharWidth(IntPtr self);
        static extern (C) IntPtr wxHtmlWinParser_GetWindow(IntPtr self);
        static extern (C) void   wxHtmlWinParser_SetFonts(IntPtr self, string normal_face, string fixed_face, int* sizes);
        static extern (C) void   wxHtmlWinParser_AddModule(IntPtr self, IntPtr mod);
        static extern (C) void   wxHtmlWinParser_RemoveModule(IntPtr self, IntPtr mod);
        static extern (C) IntPtr wxHtmlWinParser_GetContainer(IntPtr self);
        static extern (C) IntPtr wxHtmlWinParser_OpenContainer(IntPtr self);
        static extern (C) IntPtr wxHtmlWinParser_SetContainer(IntPtr self, IntPtr c);
        static extern (C) IntPtr wxHtmlWinParser_CloseContainer(IntPtr self);
        static extern (C) int    wxHtmlWinParser_GetFontSize(IntPtr self);
        static extern (C) void   wxHtmlWinParser_SetFontSize(IntPtr self, int s);
        static extern (C) int    wxHtmlWinParser_GetFontBold(IntPtr self);
        static extern (C) void   wxHtmlWinParser_SetFontBold(IntPtr self, int x);
        static extern (C) int    wxHtmlWinParser_GetFontItalic(IntPtr self);
        static extern (C) void   wxHtmlWinParser_SetFontItalic(IntPtr self, int x);
        static extern (C) int    wxHtmlWinParser_GetFontUnderlined(IntPtr self);
        static extern (C) void   wxHtmlWinParser_SetFontUnderlined(IntPtr self, int x);
        static extern (C) int    wxHtmlWinParser_GetFontFixed(IntPtr self);
        static extern (C) void   wxHtmlWinParser_SetFontFixed(IntPtr self, int x);
        static extern (C) IntPtr wxHtmlWinParser_GetFontFace(IntPtr self);
        static extern (C) void   wxHtmlWinParser_SetFontFace(IntPtr self, string face);
        static extern (C) int    wxHtmlWinParser_GetAlign(IntPtr self);
        static extern (C) void   wxHtmlWinParser_SetAlign(IntPtr self, int a);
        static extern (C) IntPtr wxHtmlWinParser_GetLinkColor(IntPtr self);
        static extern (C) void   wxHtmlWinParser_SetLinkColor(IntPtr self, IntPtr clr);
        static extern (C) IntPtr wxHtmlWinParser_GetActualColor(IntPtr self);
        static extern (C) void   wxHtmlWinParser_SetActualColor(IntPtr self, IntPtr clr);
        static extern (C) IntPtr wxHtmlWinParser_GetLink(IntPtr self);
        static extern (C) void   wxHtmlWinParser_SetLink(IntPtr self, IntPtr link);
        static extern (C) IntPtr wxHtmlWinParser_CreateCurrentFont(IntPtr self);
        //! \endcond

        //-----------------------------------------------------------------------------

    alias HtmlWinParser wxHtmlWinParser;
    public class HtmlWinParser : HtmlParser
    {
		public this(IntPtr wxobj);
        public this(HtmlWindow wnd);
	    public static wxObject New(IntPtr ptr) ;
        public override void InitParser(string source);
        public override void DoneParser();
        public override wxObject Product();
        //public FSFile OpenURL(HtmlURLType type, string url);
        public void SetDC(DC dc, double pixel_scale);
        public DC GetDC();
        public double PixelScale();
        public int CharHeight();
        public int CharWidth() ;
        public HtmlWindow window();
        public void SetFonts(string normal_face, string fixed_face, int[] sizes);
        public void AddModule(HtmlTagsModule mod);
        public void RemoveModule(HtmlTagsModule mod);
        public HtmlContainerCell Container() ;
        public HtmlContainerCell SetContainter(HtmlContainerCell cont);
        public HtmlContainerCell OpenContainer();
        public HtmlContainerCell CloseContainer();
        public int FontSize() ;
        public void FontSize(int value) ;
        public int FontBold() ;
        public void FontBold(int value) ;
        public int FontItalic() ;
        public void FontItalic(int value) ;
        public int FontUnderlined();
        public void FontUnderlined(int value) ;
        public int FontFixed() ;
        public void FontFixed(int value);
        public string FontFace() ;
        public void FontFace(string value) ;
        public int Align();
        public void Align(int value) ;
        public Colour LinkColor() ;
        public void LinkColor(Colour value) ;
        public Colour ActualColor() ;
        public void ActualColor(Colour value);
        public HtmlLinkInfo Link() ;
        public void Link(HtmlLinkInfo value) ;
        public Font CreateCurrentFont();
    }

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
        static extern (C) void   wxHtmlTagHandler_SetParser(IntPtr self, IntPtr parser);
        //! \endcond

        //-----------------------------------------------------------------------------

    public abstract class HtmlTagHandler : wxObject
    {
        public this(IntPtr wxobj) ;
        public void Parser(HtmlParser value);
        public abstract string GetSupportedTags();
        public abstract bool HandleTag(HtmlTag tag);
    }

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
        static extern (C) IntPtr wxHtmlEntitiesParser_ctor();
        static extern (C) void   wxHtmlEntitiesParser_SetEncoding(IntPtr self, int encoding);
        static extern (C) IntPtr wxHtmlEntitiesParser_Parse(IntPtr self, string input);
        static extern (C) char   wxHtmlEntitiesParser_GetEntityChar(IntPtr self, string entity);
        static extern (C) char   wxHtmlEntitiesParser_GetCharForCode(IntPtr self, uint code);
        //! \endcond

        //-----------------------------------------------------------------------------

    alias HtmlEntitiesParser wxHtmlEntitiesParser;
    public class HtmlEntitiesParser : wxObject
    {
		public this(IntPtr wxobj);
        public  this();
        public void Encoding(FontEncoding value) ;
        public string Parse(string input);
        public char GetEntityChar(string entity);
        public char GetCharForCode(int code);
    }

	//-----------------------------------------------------------------------------

         //! \cond EXTERN
        static extern (C) void   wxHtmlParser_SetFS(IntPtr self, IntPtr fs);
        static extern (C) IntPtr wxHtmlParser_GetFS(IntPtr self);
        static extern (C) IntPtr wxHtmlParser_OpenURL(IntPtr self, int type, string url);
        static extern (C) IntPtr wxHtmlParser_Parse(IntPtr self, string source);
        static extern (C) void   wxHtmlParser_InitParser(IntPtr self, string source);
        static extern (C) void   wxHtmlParser_DoneParser(IntPtr self);
        static extern (C) void   wxHtmlParser_StopParsing(IntPtr self);
        static extern (C) void   wxHtmlParser_DoParsing(IntPtr self, int begin_pos, int end_pos);
        static extern (C) void   wxHtmlParser_DoParsingAll(IntPtr self);
        static extern (C) IntPtr wxHtmlParser_GetCurrentTag(IntPtr self);
        static extern (C) void   wxHtmlParser_AddTagHandler(IntPtr self, IntPtr handler);
        static extern (C) void   wxHtmlParser_PushTagHandler(IntPtr self, IntPtr handler, string tags);
        static extern (C) void   wxHtmlParser_PopTagHandler(IntPtr self);
        static extern (C) IntPtr wxHtmlParser_GetSource(IntPtr self);
        static extern (C) void   wxHtmlParser_SetSource(IntPtr self, string src);
        static extern (C) void   wxHtmlParser_SetSourceAndSaveState(IntPtr self, string src);
        static extern (C) bool   wxHtmlParser_RestoreState(IntPtr self);
        static extern (C) IntPtr wxHtmlParser_ExtractCharsetInformation(IntPtr self, string markup);
        //! \endcond

        //-----------------------------------------------------------------------------

    public abstract class HtmlParser : wxObject
    {
        public this(IntPtr wxobj) ;
        //-----------------------------------------------------------------------------

        /*public void SetFS(FileSystem fs)
        {
            wxHtmlParser_SetFS(wxobj, wxObject.SafePtr(fs));
        }

        //-----------------------------------------------------------------------------

        public FileSystem GetFS()
        {
            return wxHtmlParser_GetFS(wxobj);
        }

        //-----------------------------------------------------------------------------

        public FSFile OpenURL(HtmlURLType type, string url)
        {
            return wxHtmlParser_OpenURL(wxobj, wxObject.SafePtr(type), url);
        }*/

        //-----------------------------------------------------------------------------

        public wxObject Parse(string source);
        public /+virtual+/ void InitParser(string source);
        public /+virtual+/ void DoneParser();
        public void StopParsing();
        public void DoParsing(int begin_pos, int end_pos);
        public void DoParsing();
        public HtmlTag GetCurrentTag();
        public abstract wxObject Product();
        public void AddTagHandler(HtmlTagHandler handler);
        public void PushTagHandler(HtmlTagHandler handler, string tags);
        public void PopTagHandler();
        public string Source();
        public void Source(string value) ;
        public void SourceAndSaveState(string value);
        public bool RestoreState();
        public string ExtractCharsetInformation(string markup);
    }

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
        static extern (C) int    wxHtmlProcessor_GetPriority(IntPtr self);
        static extern (C) void   wxHtmlProcessor_Enable(IntPtr self, bool enable);
        static extern (C) bool   wxHtmlProcessor_IsEnabled(IntPtr self);
        //! \endcond

        //-----------------------------------------------------------------------------

    public abstract class HtmlProcessor : wxObject
    {
        public this(IntPtr wxobj) ;
        public abstract string Process(string text);
        public int Priority() ;
        public void Enabled(bool value);
        public bool Enabled();
    }

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
		static extern (C) IntPtr wxHtmlRenderingInfo_ctor();
		static extern (C) void wxHtmlRenderingInfo_dtor(IntPtr self);
		static extern (C) void wxHtmlRenderingInfo_SetSelection(IntPtr self, IntPtr s);
		static extern (C) IntPtr wxHtmlRenderingInfo_GetSelection(IntPtr self);
        //! \endcond

		//-----------------------------------------------------------------------------

	alias HtmlRenderingInfo wxHtmlRenderingInfo;
	public class HtmlRenderingInfo : wxObject
	{
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this();
		override protected void dtor();
		public HtmlSelection Selection() ;
		public void Selection(HtmlSelection value) ;
	}

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
		static extern (C) IntPtr wxHtmlSelection_ctor();
		static extern (C) void wxHtmlSelection_dtor(IntPtr self);
		static extern (C) void wxHtmlSelection_Set(IntPtr self, inout Point fromPos, IntPtr fromCell, inout Point toPos, IntPtr toCell);
		static extern (C) void wxHtmlSelection_Set2(IntPtr self, IntPtr fromCell, IntPtr toCell);
		static extern (C) IntPtr wxHtmlSelection_GetFromCell(IntPtr self);
		static extern (C) IntPtr wxHtmlSelection_GetToCell(IntPtr self);
		static extern (C) void wxHtmlSelection_GetFromPos(IntPtr self, out Point fromPos);
		static extern (C) void wxHtmlSelection_GetToPos(IntPtr self, out Point toPos);
		static extern (C) void wxHtmlSelection_GetFromPrivPos(IntPtr self, out Point fromPrivPos);
		static extern (C) void wxHtmlSelection_GetToPrivPos(IntPtr self, out Point toPrivPos);
		static extern (C) void wxHtmlSelection_SetFromPrivPos(IntPtr self, inout Point pos);
		static extern (C) void wxHtmlSelection_SetToPrivPos(IntPtr self, inout Point pos);
		static extern (C) void wxHtmlSelection_ClearPrivPos(IntPtr self);
		static extern (C) bool wxHtmlSelection_IsEmpty(IntPtr self);
        //! \endcond

		//-----------------------------------------------------------------------------

	alias HtmlSelection wxHtmlSelection;
	public class HtmlSelection : wxObject
	{
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this();
		public static wxObject New(IntPtr ptr) ;
		override protected void dtor();
		public void Set(Point fromPos, HtmlCell fromCell, Point toPos, HtmlCell toCell);
		public void Set(HtmlCell fromCell, HtmlCell toCell);
		public HtmlCell FromCell();
		public HtmlCell ToCell() ;
		public Point FromPos();
		public Point ToPos() ;
		public Point FromPrivPos() ;
		public void FromPrivPos(Point value) ;
		public Point ToPrivPos() ;
		public void ToPrivPos(Point value) ;
		public void ClearPrivPos();
		public bool Empty() ;
	}

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
		static extern (C) IntPtr wxHtmlEasyPrinting_ctor(string name, IntPtr parent);
		static extern (C) bool   wxHtmlEasyPrinting_PreviewFile(IntPtr self, string htmlfile);
		static extern (C) bool   wxHtmlEasyPrinting_PreviewText(IntPtr self, string htmltext, string basepath);
		static extern (C) bool   wxHtmlEasyPrinting_PrintFile(IntPtr self, string htmlfile);
		static extern (C) bool   wxHtmlEasyPrinting_PrintText(IntPtr self, string htmltext, string basepath);
		//static extern (C) void   wxHtmlEasyPrinting_PrinterSetup(IntPtr self);
		static extern (C) void   wxHtmlEasyPrinting_PageSetup(IntPtr self);
		static extern (C) void   wxHtmlEasyPrinting_SetHeader(IntPtr self, string header, int pg);
		static extern (C) void   wxHtmlEasyPrinting_SetFooter(IntPtr self, string footer, int pg);
		static extern (C) void   wxHtmlEasyPrinting_SetFonts(IntPtr self, string normal_face, string fixed_face, int* sizes);
		static extern (C) void   wxHtmlEasyPrinting_SetStandardFonts(IntPtr self, int size, string normal_face, string fixed_face);
		static extern (C) IntPtr wxHtmlEasyPrinting_GetPrintData(IntPtr self);
		static extern (C) IntPtr wxHtmlEasyPrinting_GetPageSetupData(IntPtr self);
        //! \endcond

		//-----------------------------------------------------------------------------

	alias HtmlEasyPrinting wxHtmlEasyPrinting;
	public class HtmlEasyPrinting : wxObject
	{
		public const int wxPAGE_ODD	= 0;
		public const int wxPAGE_EVEN	= 1;
		public const int wxPAGE_ALL	= 2;

		//-----------------------------------------------------------------------------

		public this(IntPtr wxobj);
		public this();
		public this(string name);
		public this(string name, Window parentWindow);
		public bool PreviewFile(string htmlfile);
		public bool PreviewText(string htmltext);
		public bool PreviewText(string htmltext, string basepath);
		public bool PrintFile(string htmlfile);
		public bool PrintText(string htmltext);
		public bool PrintText(string htmltext, string basepath);
		//public void PrinterSetup();
		public void PageSetup();
		public void SetHeader(string header);
		public void SetHeader(string header, int pg);
		public void SetFooter(string footer);
		public void SetFooter(string footer, int pg);
		public void SetFonts(string normal_face, string fixed_face);
		public void SetFonts(string normal_face, string fixed_face, int[] sizes);
		public void SetStandardFonts();
		public void SetStandardFonts(int size);
		public void SetStandardFonts(int size, string normal_face);
		public void SetStandardFonts(int size, string normal_face, string fixed_face);
		public PrintData printData();
		public PageSetupDialogData PageSetupData();
	}

	//-----------------------------------------------------------------------------

        //! \cond EXTERN
		extern (C) {
		alias void function(HtmlWindow obj, IntPtr link) Virtual_OnLinkClicked;
		alias void function(HtmlWindow obj, IntPtr title) Virtual_OnSetTitle;
		alias void function(HtmlWindow obj, IntPtr cell, int x, int y) Virtual_OnCellMouseHover;
		alias void function(HtmlWindow obj, IntPtr cell, int x, int y, IntPtr mouseevent) Virtual_OnCellClicked;
		alias int function(HtmlWindow obj, int type, IntPtr url, IntPtr redirect) Virtual_OnOpeningURL;
		}

		static extern (C) IntPtr wxHtmlWindow_ctor();
		static extern (C) void   wxHtmlWindow_RegisterVirtual(IntPtr self, HtmlWindow obj,
			Virtual_OnLinkClicked onLinkClicked,
			Virtual_OnSetTitle onSetTitle,
			Virtual_OnCellMouseHover onCellMouseHover,
			Virtual_OnCellClicked onCellClicked,
			Virtual_OnOpeningURL onOpeningURL);
		static extern (C) bool   wxHtmlWindow_Create(IntPtr self, IntPtr parent, int id, inout Point pos, inout Size size, uint style, string name);
		static extern (C) bool   wxHtmlWindow_SetPage(IntPtr self, string source);
		static extern (C) bool   wxHtmlWindow_AppendToPage(IntPtr self, string source);
		static extern (C) bool   wxHtmlWindow_LoadPage(IntPtr self, string location);
		static extern (C) bool   wxHtmlWindow_LoadFile(IntPtr self, string filename);
		static extern (C) IntPtr wxHtmlWindow_GetOpenedPage(IntPtr self);
		static extern (C) IntPtr wxHtmlWindow_GetOpenedAnchor(IntPtr self);
		static extern (C) IntPtr wxHtmlWindow_GetOpenedPageTitle(IntPtr self);
		static extern (C) void   wxHtmlWindow_SetRelatedFrame(IntPtr self, IntPtr frame, string format);
		static extern (C) IntPtr wxHtmlWindow_GetRelatedFrame(IntPtr self);
		static extern (C) void   wxHtmlWindow_SetRelatedStatusBar(IntPtr self, int bar);
		static extern (C) void   wxHtmlWindow_SetFonts(IntPtr self, string normal_face, string fixed_face, int* sizes);
		static extern (C) void   wxHtmlWindow_SetBorders(IntPtr self, int b);
		static extern (C) void   wxHtmlWindow_ReadCustomization(IntPtr self, IntPtr cfg, string path);
		static extern (C) void   wxHtmlWindow_WriteCustomization(IntPtr self, IntPtr cfg, string path);
		static extern (C) bool   wxHtmlWindow_HistoryBack(IntPtr self);
		static extern (C) bool   wxHtmlWindow_HistoryForward(IntPtr self);
		static extern (C) bool   wxHtmlWindow_HistoryCanBack(IntPtr self);
		static extern (C) bool   wxHtmlWindow_HistoryCanForward(IntPtr self);
		static extern (C) void   wxHtmlWindow_HistoryClear(IntPtr self);
		static extern (C) IntPtr wxHtmlWindow_GetInternalRepresentation(IntPtr self);
		static extern (C) void   wxHtmlWindow_AddFilter(IntPtr filter);
		static extern (C) IntPtr wxHtmlWindow_GetParser(IntPtr self);
		static extern (C) void   wxHtmlWindow_AddProcessor(IntPtr self, IntPtr processor);
		static extern (C) void   wxHtmlWindow_AddGlobalProcessor(IntPtr processor);
		static extern (C) bool   wxHtmlWindow_AcceptsFocusFromKeyboard(IntPtr self);
		static extern (C) void   wxHtmlWindow_OnSetTitle(IntPtr self, string title);
		static extern (C) void   wxHtmlWindow_OnCellClicked(IntPtr self, IntPtr cell, int x, int y, IntPtr evt);
		static extern (C) void   wxHtmlWindow_OnLinkClicked(IntPtr self, IntPtr link);
		static extern (C) int    wxHtmlWindow_OnOpeningURL(IntPtr self, int type, string url, string redirect);

		static extern (C) void   wxHtmlWindow_SelectAll(IntPtr self);
		static extern (C) void   wxHtmlWindow_SelectWord(IntPtr self, inout Point pos);
		static extern (C) void   wxHtmlWindow_SelectLine(IntPtr self, inout Point pos);

		static extern (C) IntPtr wxHtmlWindow_ToText(IntPtr self);

		static extern (C) IntPtr wxHtmlWindow_SelectionToText(IntPtr self);
        //! \endcond

		//-----------------------------------------------------------------------------

	alias HtmlWindow wxHtmlWindow;
	public class HtmlWindow : ScrolledWindow
	{
		public const int wxHW_SCROLLBAR_NEVER   = 0x0002;
		public const int wxHW_SCROLLBAR_AUTO    = 0x0004;
		public const int wxHW_NO_SELECTION      = 0x0008;

		//-----------------------------------------------------------------------------

		public this(IntPtr  wxobj);
		public this();
		public this(Window parent, int id /*= wxID_ANY*/, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxHW_SCROLLBAR_AUTO, string name = "htmlWindow");
		public this(Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxHW_SCROLLBAR_AUTO, string name = "htmlWindow");
		public override bool Create(Window parent, int id, inout Point pos, inout Size size, int style, string name);
		public bool SetPage(string source);
		public bool AppendToPage(string source);
		public /+virtual+/ bool LoadPage(string location);
		public bool LoadFile(string filename);
		public string OpenedPage();
		public string OpenedAnchor() ;
		public string OpenedPageTitle() ;
		public void SetRelatedFrame(Frame frame, string format);
		public Frame RelatedFrame() ;
		public void RelatedStatusBar(int value);
		public void SetFonts(string normal_face, string fixed_face, int[] sizes);
		public void Borders(int value);
		public /+virtual+/ void ReadCustomization(Config cfg, string path);
		public /+virtual+/ void WriteCustomization(Config cfg, string path);
		public bool HistoryBack();
		public bool HistoryForward();
		public bool HistoryCanBack();
		public bool HistoryCanForward();
		public void HistoryClear();
		public HtmlContainerCell InternalRepresentation() ;
		public static void AddFilter(HtmlFilter filter);
		public HtmlWinParser Parser();
		public void AddProcessor(HtmlProcessor processor);
		public static void AddGlobalProcessor(HtmlProcessor processor);
		public override bool AcceptsFocusFromKeyboard();
		static extern(C) private void staticDoOnSetTitle(HtmlWindow obj, IntPtr title);
		public /+virtual+/ void OnSetTitle(string title);
		static extern(C) private void staticDoOnCellMouseHover(HtmlWindow obj, IntPtr cell, int x, int y);
		public /+virtual+/ void OnCellMouseHover(HtmlCell cell, int x, int y);
		static extern(C) private void staticDoOnCellClicked(HtmlWindow obj, IntPtr cell, int x, int y, IntPtr mouseevent);
		public /+virtual+/ void OnCellClicked(HtmlCell cell, int x, int y, MouseEvent evt);
		static extern(C) private void staticDoOnLinkClicked(HtmlWindow obj, IntPtr link);
		public /+virtual+/ void OnLinkClicked(HtmlLinkInfo link);
		static extern(C) private int staticDoOnOpeningURL(HtmlWindow obj, int type, IntPtr url, IntPtr redirect);
		public HtmlOpeningStatus OnOpeningURL(HtmlURLType type, string url, string redirect);
		public void SelectAll();
		public void SelectLine(Point pos);
		public void SelectWord(Point pos);
		public string Text() ;
		public string SelectionText() ;
	}

