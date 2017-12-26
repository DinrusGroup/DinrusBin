module wx.PrintDialog;
public import wx.common;
public import wx.Dialog;
public import wx.PrintData;

		//! \cond EXTERN
        static extern (C) IntPtr wxPageSetupDialog_ctor(IntPtr parent, IntPtr data);
        static extern (C) IntPtr wxPageSetupDialog_GetPageSetupData(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias PageSetupDialog wxPageSetupDialog;
    public class PageSetupDialog : Dialog
    {
        private this(IntPtr wxobj);
        public this(Window parent);
        public this(Window parent, PageSetupDialogData data);
        public PageSetupDialogData PageSetupData() ;
    }

		//! \cond EXTERN
        static extern (C) IntPtr wxPrintDialog_ctor(IntPtr parent, IntPtr data);
        static extern (C) IntPtr wxPrintDialog_ctorPrintData(IntPtr parent, IntPtr data);
        static extern (C) IntPtr wxPrintDialog_GetPrintData(IntPtr self);
        static extern (C) IntPtr wxPrintDialog_GetPrintDialogData(IntPtr self);
        static extern (C) IntPtr wxPrintDialog_GetPrintDC(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias PrintDialog wxPrintDialog;
    public class PrintDialog : Dialog
    {
        private this(IntPtr wxobj);
        public this(Window parent);
        public this(Window parent, PrintDialogData data);
        public this(Window parent, PrintData data);
        public PrintData printData() ;
        public PrintDialogData printDialogData();
        public DC PrintDC() ;
    }

//! \cond VERSION
version(none) /*(__WXGTK__)*/{
    
		//! \cond EXTERN
        static extern (C) IntPtr wxPrintSetupDialog_ctor(IntPtr parent, IntPtr data);
        static extern (C) IntPtr wxPrintSetupDialog_ctorPrintData(IntPtr parent, IntPtr data);
        static extern (C) void wxPrintSetupDialog_Init(IntPtr self, IntPtr data);
        static extern (C) IntPtr wxPrintSetupDialog_GetPrintData(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias PrintSetupDialog wxPrintSetupDialog;
    public class PrintSetupDialog : Dialog
    {
        private this(IntPtr wxobj);
        public this(Window parent);
        public this(Window parent, PrintDialogData data);
        public this(Window parent, PrintData data);
        public void Init(PrintData data);
        public PrintData printData() ;
    }

} // __WXGTK__
//! \endcond
