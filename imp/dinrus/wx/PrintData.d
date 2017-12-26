module wx.PrintData;
public import wx.common;

    public enum PrintMode
    {
        wxPRINT_MODE_NONE =    0,
        wxPRINT_MODE_PREVIEW = 1,   // Preview in external application
        wxPRINT_MODE_FILE =    2,   // Print to file
        wxPRINT_MODE_PRINTER = 3    // Send to printer
    }

    public enum PrintQuality
    {
        wxPRINT_QUALITY_HIGH    = -1,
        wxPRINT_QUALITY_MEDIUM  = -2,
        wxPRINT_QUALITY_LOW     = -3,
        wxPRINT_QUALITY_DRAFT   = -4
    }

    public enum DuplexMode
    {
        wxDUPLEX_SIMPLEX, 
        wxDUPLEX_HORIZONTAL,
        wxDUPLEX_VERTICAL
    }

    public enum PaperSize 
    {
        wxPAPER_NONE,               // Use specific dimensions
        wxPAPER_LETTER,             // Letter, 8 1/2 by 11 inches
        wxPAPER_LEGAL,              // Legal, 8 1/2 by 14 inches
        wxPAPER_A4,                 // A4 Sheet, 210 by 297 millimeters
        wxPAPER_CSHEET,             // C Sheet, 17 by 22 inches
        wxPAPER_DSHEET,             // D Sheet, 22 by 34 inches
        wxPAPER_ESHEET,             // E Sheet, 34 by 44 inches
        wxPAPER_LETTERSMALL,        // Letter Small, 8 1/2 by 11 inches
        wxPAPER_TABLOID,            // Tabloid, 11 by 17 inches
        wxPAPER_LEDGER,             // Ledger, 17 by 11 inches
        wxPAPER_STATEMENT,          // Statement, 5 1/2 by 8 1/2 inches
        wxPAPER_EXECUTIVE,          // Executive, 7 1/4 by 10 1/2 inches
        wxPAPER_A3,                 // A3 sheet, 297 by 420 millimeters
        wxPAPER_A4SMALL,            // A4 small sheet, 210 by 297 millimeters
        wxPAPER_A5,                 // A5 sheet, 148 by 210 millimeters
        wxPAPER_B4,                 // B4 sheet, 250 by 354 millimeters
        wxPAPER_B5,                 // B5 sheet, 182-by-257-millimeter paper
        wxPAPER_FOLIO,              // Folio, 8-1/2-by-13-inch paper
        wxPAPER_QUARTO,             // Quarto, 215-by-275-millimeter paper
        wxPAPER_10X14,              // 10-by-14-inch sheet
        wxPAPER_11X17,              // 11-by-17-inch sheet
        wxPAPER_NOTE,               // Note, 8 1/2 by 11 inches
        wxPAPER_ENV_9,              // #9 Envelope, 3 7/8 by 8 7/8 inches
        wxPAPER_ENV_10,             // #10 Envelope, 4 1/8 by 9 1/2 inches
        wxPAPER_ENV_11,             // #11 Envelope, 4 1/2 by 10 3/8 inches
        wxPAPER_ENV_12,             // #12 Envelope, 4 3/4 by 11 inches
        wxPAPER_ENV_14,             // #14 Envelope, 5 by 11 1/2 inches
        wxPAPER_ENV_DL,             // DL Envelope, 110 by 220 millimeters
        wxPAPER_ENV_C5,             // C5 Envelope, 162 by 229 millimeters
        wxPAPER_ENV_C3,             // C3 Envelope, 324 by 458 millimeters
        wxPAPER_ENV_C4,             // C4 Envelope, 229 by 324 millimeters
        wxPAPER_ENV_C6,             // C6 Envelope, 114 by 162 millimeters
        wxPAPER_ENV_C65,            // C65 Envelope, 114 by 229 millimeters
        wxPAPER_ENV_B4,             // B4 Envelope, 250 by 353 millimeters
        wxPAPER_ENV_B5,             // B5 Envelope, 176 by 250 millimeters
        wxPAPER_ENV_B6,             // B6 Envelope, 176 by 125 millimeters
        wxPAPER_ENV_ITALY,          // Italy Envelope, 110 by 230 millimeters
        wxPAPER_ENV_MONARCH,        // Monarch Envelope, 3 7/8 by 7 1/2 inches
        wxPAPER_ENV_PERSONAL,       // 6 3/4 Envelope, 3 5/8 by 6 1/2 inches
        wxPAPER_FANFOLD_US,         // US Std Fanfold, 14 7/8 by 11 inches
        wxPAPER_FANFOLD_STD_GERMAN, // German Std Fanfold, 8 1/2 by 12 inches
        wxPAPER_FANFOLD_LGL_GERMAN, // German Legal Fanfold, 8 1/2 by 13 inches

        wxPAPER_ISO_B4,             // B4 (ISO) 250 x 353 mm
        wxPAPER_JAPANESE_POSTCARD,  // Japanese Postcard 100 x 148 mm
        wxPAPER_9X11,               // 9 x 11 in
        wxPAPER_10X11,              // 10 x 11 in
        wxPAPER_15X11,              // 15 x 11 in
        wxPAPER_ENV_INVITE,         // Envelope Invite 220 x 220 mm
        wxPAPER_LETTER_EXTRA,       // Letter Extra 9 \275 x 12 in
        wxPAPER_LEGAL_EXTRA,        // Legal Extra 9 \275 x 15 in
        wxPAPER_TABLOID_EXTRA,      // Tabloid Extra 11.69 x 18 in
        wxPAPER_A4_EXTRA,           // A4 Extra 9.27 x 12.69 in
        wxPAPER_LETTER_TRANSVERSE,  // Letter Transverse 8 \275 x 11 in
        wxPAPER_A4_TRANSVERSE,      // A4 Transverse 210 x 297 mm
        wxPAPER_LETTER_EXTRA_TRANSVERSE, // Letter Extra Transverse 9\275 x 12 in
        wxPAPER_A_PLUS,             // SuperA/SuperA/A4 227 x 356 mm
        wxPAPER_B_PLUS,             // SuperB/SuperB/A3 305 x 487 mm
        wxPAPER_LETTER_PLUS,        // Letter Plus 8.5 x 12.69 in
        wxPAPER_A4_PLUS,            // A4 Plus 210 x 330 mm
        wxPAPER_A5_TRANSVERSE,      // A5 Transverse 148 x 210 mm
        wxPAPER_B5_TRANSVERSE,      // B5 (JIS) Transverse 182 x 257 mm
        wxPAPER_A3_EXTRA,           // A3 Extra 322 x 445 mm
        wxPAPER_A5_EXTRA,           // A5 Extra 174 x 235 mm
        wxPAPER_B5_EXTRA,           // B5 (ISO) Extra 201 x 276 mm
        wxPAPER_A2,                 // A2 420 x 594 mm
        wxPAPER_A3_TRANSVERSE,      // A3 Transverse 297 x 420 mm
        wxPAPER_A3_EXTRA_TRANSVERSE // A3 Extra Transverse 322 x 445 mm
    }

		//! \cond EXTERN
        static extern (C) IntPtr wxPageSetupDialogData_ctor();
        static extern (C) IntPtr wxPageSetupDialogData_ctorPrintSetup(IntPtr dialogData);
        static extern (C) IntPtr wxPageSetupDialogData_ctorPrintData(IntPtr printData);
        static extern (C) void wxPageSetupDialogData_GetPaperSize(IntPtr self, inout Size size);
        static extern (C) int wxPageSetupDialogData_GetPaperId(IntPtr self);
        static extern (C) void wxPageSetupDialogData_GetMinMarginTopLeft(IntPtr self, inout Point pt);
        static extern (C) void wxPageSetupDialogData_GetMinMarginBottomRight(IntPtr self, inout Point pt);
        static extern (C) void wxPageSetupDialogData_GetMarginTopLeft(IntPtr self, inout Point pt);
        static extern (C) void wxPageSetupDialogData_GetMarginBottomRight(IntPtr self, inout Point pt);
        static extern (C) bool wxPageSetupDialogData_GetDefaultMinMargins(IntPtr self);
        static extern (C) bool wxPageSetupDialogData_GetEnableMargins(IntPtr self);
        static extern (C) bool wxPageSetupDialogData_GetEnableOrientation(IntPtr self);
        static extern (C) bool wxPageSetupDialogData_GetEnablePaper(IntPtr self);
        static extern (C) bool wxPageSetupDialogData_GetEnablePrinter(IntPtr self);
        static extern (C) bool wxPageSetupDialogData_GetDefaultInfo(IntPtr self);
        static extern (C) bool wxPageSetupDialogData_GetEnableHelp(IntPtr self);
        static extern (C) bool wxPageSetupDialogData_Ok(IntPtr self);
        static extern (C) void wxPageSetupDialogData_SetPaperSize(IntPtr self, inout Size sz);
        static extern (C) void wxPageSetupDialogData_SetPaperId(IntPtr self, int id);
        static extern (C) void wxPageSetupDialogData_SetPaperSize(IntPtr self, int id);
        static extern (C) void wxPageSetupDialogData_SetMinMarginTopLeft(IntPtr self, inout Point pt);
        static extern (C) void wxPageSetupDialogData_SetMinMarginBottomRight(IntPtr self, inout Point pt);
        static extern (C) void wxPageSetupDialogData_SetMarginTopLeft(IntPtr self, inout Point pt);
        static extern (C) void wxPageSetupDialogData_SetMarginBottomRight(IntPtr self, inout Point pt);
        static extern (C) void wxPageSetupDialogData_SetDefaultMinMargins(IntPtr self, bool flag);
        static extern (C) void wxPageSetupDialogData_SetDefaultInfo(IntPtr self, bool flag);
        static extern (C) void wxPageSetupDialogData_EnableMargins(IntPtr self, bool flag);
        static extern (C) void wxPageSetupDialogData_EnableOrientation(IntPtr self, bool flag);
        static extern (C) void wxPageSetupDialogData_EnablePaper(IntPtr self, bool flag);
        static extern (C) void wxPageSetupDialogData_EnablePrinter(IntPtr self, bool flag);
        static extern (C) void wxPageSetupDialogData_EnableHelp(IntPtr self, bool flag);
        static extern (C) void wxPageSetupDialogData_CalculateIdFromPaperSize(IntPtr self);
        static extern (C) void wxPageSetupDialogData_CalculatePaperSizeFromId(IntPtr self);
        static extern (C) IntPtr wxPageSetupDialogData_GetPrintData(IntPtr self);
        static extern (C) void wxPageSetupDialogData_SetPrintData(IntPtr self, IntPtr printData);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias PageSetupDialogData wxPageSetupDialogData;
    public class PageSetupDialogData : wxObject
    {
        public this(IntPtr wxobj);
        public this();
        public  this(PageSetupDialogData dialogData);
        public  this(PrintData printData);
	public static wxObject New(IntPtr ptr) ;
        public Size paperSize();
        public void paperSize(Size value);
        public PaperSize PaperId();
        public void PaperId(PaperSize value);
        public Point MinMarginTopLeft();
        public void MinMarginTopLeft(Point value) ;
        public Point MinMarginBottomRight() ;
        public void MinMarginBottomRight(Point value);
        public Point MarginTopLeft();
        public void MarginTopLeft(Point value);
        public Point MarginBottomRight();
        public void MarginBottomRight(Point value) ;
        public bool DefaultMinMargins();
        public void DefaultMinMargins(bool value);
        public bool EnableOrientation();
        public void EnableOrientation(bool value);
        public bool EnablePaper();
        public void EnablePaper(bool value) ;
        public bool EnablePrinter();
        public void EnablePrinter(bool value) ;
        public bool DefaultInfo() ;
        public void DefaultInfo(bool value);
        public bool EnableHelp() ;
        public void EnableHelp(bool value) ;
        public bool Ok();
        public bool EnableMargins() ;
        public void EnableMargins(bool value) ;
        public void CalculateIdFromPaperSize();
        public void CalculatePaperSizeFromId();
        public PrintData printData() ;
        public void printData(PrintData value);
        //public static implicit operator PageSetupDialogData (PrintData data);
    }

		//! \cond EXTERN
        static extern (C) IntPtr wxPrintDialogData_ctor();
        static extern (C) IntPtr wxPrintDialogData_ctorDialogData(IntPtr dialogData);
        static extern (C) IntPtr wxPrintDialogData_ctorPrintData(IntPtr printData);
        static extern (C) int wxPrintDialogData_GetFromPage(IntPtr self);
        static extern (C) int wxPrintDialogData_GetToPage(IntPtr self);
        static extern (C) int wxPrintDialogData_GetMinPage(IntPtr self);
        static extern (C) int wxPrintDialogData_GetMaxPage(IntPtr self);
        static extern (C) int wxPrintDialogData_GetNoCopies(IntPtr self);
        static extern (C) bool wxPrintDialogData_GetAllPages(IntPtr self);
        static extern (C) bool wxPrintDialogData_GetSelection(IntPtr self);
        static extern (C) bool wxPrintDialogData_GetCollate(IntPtr self);
        static extern (C) bool wxPrintDialogData_GetPrintToFile(IntPtr self);
        static extern (C) bool wxPrintDialogData_GetSetupDialog(IntPtr self);
        static extern (C) void wxPrintDialogData_SetFromPage(IntPtr self, int v);
        static extern (C) void wxPrintDialogData_SetToPage(IntPtr self, int v);
        static extern (C) void wxPrintDialogData_SetMinPage(IntPtr self, int v);
        static extern (C) void wxPrintDialogData_SetMaxPage(IntPtr self, int v);
        static extern (C) void wxPrintDialogData_SetNoCopies(IntPtr self, int v);
        static extern (C) void wxPrintDialogData_SetAllPages(IntPtr self, bool flag);
        static extern (C) void wxPrintDialogData_SetSelection(IntPtr self, bool flag);
        static extern (C) void wxPrintDialogData_SetCollate(IntPtr self, bool flag);
        static extern (C) void wxPrintDialogData_SetPrintToFile(IntPtr self, bool flag);
        static extern (C) void wxPrintDialogData_SetSetupDialog(IntPtr self, bool flag);
        static extern (C) void wxPrintDialogData_EnablePrintToFile(IntPtr self, bool flag);
        static extern (C) void wxPrintDialogData_EnableSelection(IntPtr self, bool flag);
        static extern (C) void wxPrintDialogData_EnablePageNumbers(IntPtr self, bool flag);
        static extern (C) void wxPrintDialogData_EnableHelp(IntPtr self, bool flag);
        static extern (C) bool wxPrintDialogData_GetEnablePrintToFile(IntPtr self);
        static extern (C) bool wxPrintDialogData_GetEnableSelection(IntPtr self);
        static extern (C) bool wxPrintDialogData_GetEnablePageNumbers(IntPtr self);
        static extern (C) bool wxPrintDialogData_GetEnableHelp(IntPtr self);
        static extern (C) bool wxPrintDialogData_Ok(IntPtr self);
        static extern (C) IntPtr wxPrintDialogData_GetPrintData(IntPtr self);
        static extern (C) void wxPrintDialogData_SetPrintData(IntPtr self, IntPtr printData);
		//! \endcond

    alias PrintDialogData wxPrintDialogData;
    public class PrintDialogData : wxObject
    {
        //-----------------------------------------------------------------------------

        public this(IntPtr wxobj);
        public this();
        public this(PrintDialogData dialogData);
        public this(PrintData printData);
	public static wxObject New(IntPtr ptr) ;
        public int FromPage();
        public void FromPage(int value);
        public int ToPage() ;
        public void ToPage(int value) ;
        public int MinPage() ;
        public void MinPage(int value) ;
        public int MaxPage() ;
        public void MaxPage(int value);
        public int NoCopies() ;
        public void NoCopies(int value) ;
        public bool AllPages() ;
        public void AllPages(bool value) ;
        public bool Selection() ;
        public void Selection(bool value) ;
        public bool Collate() ;
        public void Collate(bool value) ;
        public bool PrintToFile() ;
        public void PrintToFile(bool value) ;
        public bool SetupDialog();
        public void SetupDialog(bool value) ;
        public void EnablePrintToFile(bool value) ;
        public bool EnablePrintToFile() ;
        public void EnableSelection(bool value);
        public bool EnableSelection() ;
        public void EnablePageNumbers(bool value);
        public bool EnablePageNumbers() ;
        public void EnableHelp(bool value) ;
        public bool EnableHelp();
        public bool Ok();
        public PrintData printData() ;
        public void printData(PrintData value) ;
    }

		//! \cond EXTERN
        static extern (C) IntPtr wxPrintData_ctor();
        static extern (C) IntPtr wxPrintData_ctorPrintData(IntPtr printData);
        static extern (C) int wxPrintData_GetNoCopies(IntPtr self);
        static extern (C) bool wxPrintData_GetCollate(IntPtr self);
        static extern (C) int wxPrintData_GetOrientation(IntPtr self);
        static extern (C) bool wxPrintData_Ok(IntPtr self);
        static extern (C) IntPtr wxPrintData_GetPrinterName(IntPtr self);
        static extern (C) bool wxPrintData_GetColour(IntPtr self);
        static extern (C) int wxPrintData_GetDuplex(IntPtr self);
        static extern (C) int wxPrintData_GetPaperId(IntPtr self);
        static extern (C) void wxPrintData_GetPaperSize(IntPtr self, inout Size sz);
        static extern (C) int wxPrintData_GetQuality(IntPtr self);
        static extern (C) void wxPrintData_SetNoCopies(IntPtr self, int v);
        static extern (C) void wxPrintData_SetCollate(IntPtr self, bool flag);
        static extern (C) void wxPrintData_SetOrientation(IntPtr self, int orient);
        static extern (C) void wxPrintData_SetPrinterName(IntPtr self, string name);
        static extern (C) void wxPrintData_SetColour(IntPtr self, bool colour);
        static extern (C) void wxPrintData_SetDuplex(IntPtr self, int duplex);
        static extern (C) void wxPrintData_SetPaperId(IntPtr self, int sizeId);
        static extern (C) void wxPrintData_SetPaperSize(IntPtr self, inout Size sz);
        static extern (C) void wxPrintData_SetQuality(IntPtr self, int quality);
        static extern (C) IntPtr wxPrintData_GetPrinterCommand(IntPtr self);
        static extern (C) IntPtr wxPrintData_GetPrinterOptions(IntPtr self);
        static extern (C) IntPtr wxPrintData_GetPreviewCommand(IntPtr self);
        static extern (C) IntPtr wxPrintData_GetFilename(IntPtr self);
        static extern (C) IntPtr wxPrintData_GetFontMetricPath(IntPtr self);
        static extern (C) double wxPrintData_GetPrinterScaleX(IntPtr self);
        static extern (C) double wxPrintData_GetPrinterScaleY(IntPtr self);
        static extern (C) int wxPrintData_GetPrinterTranslateX(IntPtr self);
        static extern (C) int wxPrintData_GetPrinterTranslateY(IntPtr self);
        static extern (C) int wxPrintData_GetPrintMode(IntPtr self);
        static extern (C) void wxPrintData_SetPrinterCommand(IntPtr self, string command);
        static extern (C) void wxPrintData_SetPrinterOptions(IntPtr self, string options);
        static extern (C) void wxPrintData_SetPreviewCommand(IntPtr self, string command);
        static extern (C) void wxPrintData_SetFilename(IntPtr self, string filename);
        static extern (C) void wxPrintData_SetFontMetricPath(IntPtr self, string path);
        static extern (C) void wxPrintData_SetPrinterScaleX(IntPtr self, double x);
        static extern (C) void wxPrintData_SetPrinterScaleY(IntPtr self, double y);
        static extern (C) void wxPrintData_SetPrinterScaling(IntPtr self, double x, double y);
        static extern (C) void wxPrintData_SetPrinterTranslateX(IntPtr self, int x);
        static extern (C) void wxPrintData_SetPrinterTranslateY(IntPtr self, int y);
        static extern (C) void wxPrintData_SetPrinterTranslation(IntPtr self, int x, int y);
        static extern (C) void wxPrintData_SetPrintMode(IntPtr self, int printMode);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias PrintData wxPrintData;
    public class PrintData : wxObject
    {
        public this(IntPtr wxobj);
        public this();
        public this(PrintData printData);
        public static wxObject New(IntPtr ptr);
        public int NoCopies();
        public void NoCopies(int value) ;
        public bool Collate();
        public void Collate(bool value) ;
        public int Orientation();
        public void Orientation(int value) ;
        public bool Ok();
        public string PrinterName() ;
        public void PrinterName(string value) ;
        public bool Colour() ;
        public void Colour(bool value) ;
        public DuplexMode Duplex() ;
        public void Duplex(DuplexMode value) ;
        public PaperSize PaperId() ;
        public void PaperId(PaperSize value);
        public Size paperSize() ;
        public void paperSize(Size value) ;
        public PrintQuality Quality();
        public void Quality(PrintQuality value) ;
        public string PrinterCommand() ;
        public void PrinterCommand(string value);
        public string PrinterOptions();
        public void PrinterOptions(string value) ;
        public string PreviewCommand() ;
        public void PreviewCommand(string value) ;
        public string Filename();
        public void Filename(string value) ;
        public string FontMetricPath() ;
        public void FontMetricPath(string value) ;
        public double PrinterScaleX();
        public void PrinterScaleX(double value) ;
        public double PrinterScaleY();
        public void PrinterScaleY(double value) ;
        public int PrinterTranslateX();
        public void PrinterTranslateX(int value);
        public int PrinterTranslateY();
        public void PrinterTranslateY(int value);
        public PrintMode printMode() ;
        public void printMode(PrintMode value) ;
        public void SetPrinterScaling(double x, double y);
        public void SetPrinterTranslation(int x, int y);
    }

