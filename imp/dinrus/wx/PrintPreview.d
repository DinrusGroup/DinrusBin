module wx.PrintPreview;
public import wx.common;
public import wx.Panel;
public import wx.Frame;
public import wx.ScrolledWindow;
public import wx.PrintData;
public import wx.Printer;

		//! \cond EXTERN
        static extern (C) IntPtr wxPrintPreview_ctor(IntPtr printout, IntPtr printoutForPrinting, IntPtr data);
        static extern (C) IntPtr wxPrintPreview_ctorPrintData(IntPtr printout, IntPtr printoutForPrinting, IntPtr data);
        static extern (C) bool   wxPrintPreview_SetCurrentPage(IntPtr self, int pageNum);
        static extern (C) int    wxPrintPreview_GetCurrentPage(IntPtr self);
        static extern (C) void   wxPrintPreview_SetPrintout(IntPtr self, IntPtr printout);
        static extern (C) IntPtr wxPrintPreview_GetPrintout(IntPtr self);
        static extern (C) IntPtr wxPrintPreview_GetPrintoutForPrinting(IntPtr self);
        static extern (C) void   wxPrintPreview_SetFrame(IntPtr self, IntPtr frame);
        static extern (C) void   wxPrintPreview_SetCanvas(IntPtr self, IntPtr canvas);
        static extern (C) IntPtr wxPrintPreview_GetFrame(IntPtr self);
        static extern (C) IntPtr wxPrintPreview_GetCanvas(IntPtr self);
        static extern (C) bool   wxPrintPreview_PaintPage(IntPtr self, IntPtr canvas, IntPtr dc);
        static extern (C) bool   wxPrintPreview_DrawBlankPage(IntPtr self, IntPtr canvas, IntPtr dc);
        static extern (C) bool   wxPrintPreview_RenderPage(IntPtr self, int pageNum);
        static extern (C) IntPtr wxPrintPreview_GetPrintDialogData(IntPtr self);
        static extern (C) void   wxPrintPreview_SetZoom(IntPtr self, int percent);
        static extern (C) int    wxPrintPreview_GetZoom(IntPtr self);
        static extern (C) int    wxPrintPreview_GetMaxPage(IntPtr self);
        static extern (C) int    wxPrintPreview_GetMinPage(IntPtr self);
        static extern (C) bool   wxPrintPreview_Ok(IntPtr self);
        static extern (C) void   wxPrintPreview_SetOk(IntPtr self, bool ok);
        static extern (C) bool   wxPrintPreview_Print(IntPtr self, bool interactive);
        static extern (C) void   wxPrintPreview_DetermineScaling(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias PrintPreview wxPrintPreview;
    public class PrintPreview : wxObject
    {
        private this(IntPtr wxobj);
        public this(Printout printout, Printout printoutForPrinting, PrintDialogData data);
        public this(Printout printout, Printout printoutForPrinting);
        public this(Printout printout, Printout printoutForPrinting, PrintData data);
	public static wxObject New(IntPtr ptr) ;
        public bool SetCurrentPage(int pageNum);
        public int CurrentPage() ;
        public void CurrentPage(int value) ;
        public void printout(Printout value) ;
        public Printout printout() ;
        public Printout PrintoutForPrinting();
        public void frame(Frame value);
        public Frame frame() ;
        public Window Canvas() ;
        public void Canvas(Window value) ;
        public bool PaintPage(Window canvas, inout DC dc);
        public bool DrawBlankPage(Window canvas, inout DC dc);
        public bool RenderPage(int pageNum);
        public PrintDialogData printDialogData() ;
        public void Zoom(int value) ;
        public int Zoom() ;
        public int MaxPage() ;
        public int MinPage();
        public bool Ok() ;
        public void Ok(bool value) ;
        public bool Print(bool interactive);
        public void DetermineScaling();
    }

		//! \cond EXTERN
        static extern (C) IntPtr wxPreviewFrame_ctor(IntPtr preview, IntPtr parent, string title, inout Point pos, inout Size size, uint style, string name);
        static extern (C) void   wxPreviewFrame_Initialize(IntPtr self);
        static extern (C) void   wxPreviewFrame_CreateCanvas(IntPtr self);
        static extern (C) void   wxPreviewFrame_CreateControlBar(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias PreviewFrame wxPreviewFrame;
    public class PreviewFrame : Frame
    {
        private this(IntPtr wxobj);
        public this(PrintPreview preview, Window parent, string title = "Print Preview", Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = wxDEFAULT_FRAME_STYLE, string name = "frame");
        public void Initialize();
        public void CreateCanvas();
        public void CreateControlBar();
    }

		//! \cond EXTERN
        static extern (C) IntPtr wxPreviewControlBar_ctor(IntPtr preview, int buttons, IntPtr parent, inout Point pos, inout Size size, uint style, string name);
        static extern (C) void   wxPreviewControlBar_CreateButtons(IntPtr self);
        static extern (C) void   wxPreviewControlBar_SetZoomControl(IntPtr self, int zoom);
        static extern (C) int    wxPreviewControlBar_GetZoomControl(IntPtr self);
        static extern (C) IntPtr wxPreviewControlBar_GetPrintPreview(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias PreviewControlBar wxPreviewControlBar;
    public class PreviewControlBar : Panel
    {
        const int wxPREVIEW_PRINT       =  1;
        const int wxPREVIEW_PREVIOUS    =  2;
        const int wxPREVIEW_NEXT        =  4;
        const int wxPREVIEW_ZOOM        =  8;
        const int wxPREVIEW_FIRST       = 16;
        const int wxPREVIEW_LAST        = 32;
        const int wxPREVIEW_GOTO        = 64;

        const int wxPREVIEW_DEFAULT     = wxPREVIEW_PREVIOUS|wxPREVIEW_NEXT|wxPREVIEW_ZOOM
                          |wxPREVIEW_FIRST|wxPREVIEW_GOTO|wxPREVIEW_LAST;

        // Ids for controls
        const int wxID_PREVIEW_CLOSE      = 1;
        const int wxID_PREVIEW_NEXT       = 2;
        const int wxID_PREVIEW_PREVIOUS   = 3;
        const int wxID_PREVIEW_PRINT      = 4;
        const int wxID_PREVIEW_ZOOM       = 5;
        const int wxID_PREVIEW_FIRST      = 6;
        const int wxID_PREVIEW_LAST       = 7;
        const int wxID_PREVIEW_GOTO       = 8;
    
        private this(IntPtr wxobj);
        public this(PrintPreview preview, int buttons, Window parent, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=wxTAB_TRAVERSAL, string name="panel");
        public void CreateButtons();
        public int ZoomControl() ;
        public void ZoomControl(int value);
        public PrintPreview printPreview();
    }

		//! \cond EXTERN
        static extern (C) IntPtr wxPreviewCanvas_ctor(IntPtr preview, IntPtr parent, inout Point pos, inout Size size, uint style, string name);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias PreviewCanvas wxPreviewCanvas;
    public class PreviewCanvas : ScrolledWindow
    {
        private this(IntPtr wxobj);
        public this(PrintPreview preview, Window parent, Point pos = wxDefaultPosition, Size size = wxDefaultSize, int style = 0, string name = "canvas");
    }
