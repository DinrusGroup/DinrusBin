module wx.Printer;
public import wx.common;
public import wx.Window;
public import wx.PrintData;

    public enum PrinterError 
    {
        wxPRINTER_NO_ERROR = 0,
        wxPRINTER_CANCELLED,
        wxPRINTER_ERROR
    }

		//! \cond EXTERN
        static extern (C) IntPtr wxPrinter_ctor(IntPtr data);
        static extern (C) IntPtr wxPrinter_CreateAbortWindow(IntPtr self, IntPtr parent, IntPtr printout);
        static extern (C) void   wxPrinter_ReportError(IntPtr self, IntPtr parent, IntPtr printout, string message);
        static extern (C) IntPtr wxPrinter_GetPrintDialogData(IntPtr self);
        static extern (C) bool   wxPrinter_GetAbort(IntPtr self);
        static extern (C) int    wxPrinter_GetLastError(IntPtr self);
        static extern (C) bool   wxPrinter_Setup(IntPtr self, IntPtr parent);
        static extern (C) bool   wxPrinter_Print(IntPtr self, IntPtr parent, IntPtr printout, bool prompt);
        static extern (C) IntPtr wxPrinter_PrintDialog(IntPtr self, IntPtr parent);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias Printer wxPrinter;
    public class Printer : wxObject
    {
        private this(IntPtr wxobj) ;
        public this();
        public this(PrintDialogData data);
        public Window CreateAbortWindow(Window parent, Printout printout);
        public void ReportError(Window parent, Printout printout, string message);
        public PrintDialogData printDialogData() ;
        public bool Abort();
        public PrinterError LastError() ;
        public bool Setup(Window parent);
        public bool Print(Window parent, Printout printout, bool prompt);
        public DC PrintDialog(Window parent);
    }


        //-----------------------------------------------------------------------------

		//! \cond EXTERN
	extern (C) {
        alias void function(Printout obj) Virtual_NoParams;
        alias bool function(Printout obj, int i) Virtual_ParamsInt;
        alias bool function(Printout obj, int startPage, int endPage) Virtual_OnBeginDocument;
        alias void function(Printout obj, inout int minPage, inout int maxPage, inout int pageFrom, inout int pageTo) Virtual_GetPageInfo;
	}

        static extern (C) IntPtr wxPrintout_ctor(string title);
        static extern (C) bool   wxPrintout_OnBeginDocument(IntPtr self, int startPage, int endPage);
        static extern (C) void   wxPrintout_OnEndDocument(IntPtr self);
        static extern (C) void   wxPrintout_OnBeginPrinting(IntPtr self);
        static extern (C) void   wxPrintout_OnEndPrinting(IntPtr self);
        static extern (C) void   wxPrintout_OnPreparePrinting(IntPtr self);
        static extern (C) bool   wxPrintout_HasPage(IntPtr self, int page);
        static extern (C) void   wxPrintout_GetPageInfo(IntPtr self, inout int minPage, inout int maxPage, inout int pageFrom, inout int pageTo);
        static extern (C) IntPtr wxPrintout_GetTitle(IntPtr self);
        static extern (C) IntPtr wxPrintout_GetDC(IntPtr self);
        static extern (C) void   wxPrintout_SetDC(IntPtr self, IntPtr dc);
        static extern (C) void   wxPrintout_SetPageSizePixels(IntPtr self, int w, int h);
        static extern (C) void   wxPrintout_GetPageSizePixels(IntPtr self, inout int w, inout int h);
        static extern (C) void   wxPrintout_SetPageSizeMM(IntPtr self, int w, int h);
        static extern (C) void   wxPrintout_GetPageSizeMM(IntPtr self, inout int w, inout int h);
        static extern (C) void   wxPrintout_SetPPIScreen(IntPtr self, int x, int y);
        static extern (C) void   wxPrintout_GetPPIScreen(IntPtr self, inout int x, inout int y);
        static extern (C) void   wxPrintout_SetPPIPrinter(IntPtr self, int x, int y);
        static extern (C) void   wxPrintout_GetPPIPrinter(IntPtr self, inout int x, inout int y);
        static extern (C) bool   wxPrintout_IsPreview(IntPtr self);
        static extern (C) void   wxPrintout_SetIsPreview(IntPtr self, bool p);

        static extern (C) void   wxPrintout_RegisterVirtual(IntPtr self, Printout obj, Virtual_OnBeginDocument onBeginDocument, Virtual_NoParams onEndDocument, Virtual_NoParams onBeginPrinting, Virtual_NoParams onEndPrinting, Virtual_NoParams onPreparePrinting, Virtual_ParamsInt hasPage, Virtual_ParamsInt onPrintPage, Virtual_GetPageInfo getPageInfo);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias Printout wxPrintout;
    public abstract class Printout : wxObject
    {
        private this(IntPtr wxobj) ;
        public this(string title);
//	public static wxObject New(IntPtr ptr) ;
        static extern(C) private bool staticOnBeginDocument(Printout obj, int startPage, int endPage);
        public /+virtual+/ bool OnBeginDocument(int startPage, int endPage);
        static extern(C) private void staticOnEndDocument(Printout obj);
        public /+virtual+/ void OnEndDocument();
        static extern(C) private void staticOnBeginPrinting(Printout obj);
        public /+virtual+/ void OnBeginPrinting();
        static extern(C) private void staticOnEndPrinting(Printout obj);
        public /+virtual+/ void OnEndPrinting();
        static extern(C) private void staticOnPreparePrinting(Printout obj);
        public /+virtual+/ void OnPreparePrinting();
        static extern(C) private bool staticHasPage(Printout obj, int page);
        public /+virtual+/ bool HasPage(int page);
        static extern(C) private bool staticOnPrintPage(Printout obj,int page);
        public abstract bool OnPrintPage(int page);
        static extern(C) private void staticGetPageInfo(Printout obj, inout int minPage, inout int maxPage, inout int pageFrom, inout int pageTo);
        public /+virtual+/ void GetPageInfo(inout int minPage, inout int maxPage, inout int pageFrom, inout int pageTo);
        public string Title() ;
        public DC Dc();
        public void Dc(DC value);
        public void SetPageSizePixels(int w, int h);
        public void GetPageSizePixels(out int w, out int h);
        public void SetPageSizeMM(int w, int h);
        public void GetPageSizeMM(out int w, out int h);
        public void SetPPIScreen(int x, int y);
        public void GetPPIScreen(out int x, out int y);
        public void SetPPIPrinter(int x, int y);
        public void GetPPIPrinter(out int x, out int y);
        public bool IsPreview() ;
        public void IsPreview(bool value);
    }

