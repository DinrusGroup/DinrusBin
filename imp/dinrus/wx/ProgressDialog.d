module wx.ProgressDialog;
public import wx.common;
public import wx.Dialog;

		//! \cond EXTERN
        static extern (C) IntPtr wxProgressDialog_ctor(string title, string message, int maximum, IntPtr parent, uint style);
	static extern (C) void wxProgressDialog_dtor(IntPtr self);
        static extern (C) bool wxProgressDialog_Update(IntPtr self, int value, string newmsg);
        static extern (C) void wxProgressDialog_Resume(IntPtr self);
        static extern (C) bool wxProgressDialog_Show(IntPtr self, bool show);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias ProgressDialog wxProgressDialog;
    public class ProgressDialog : Dialog
    {
        public const int wxPD_CAN_ABORT      = 0x0001;
        public const int wxPD_APP_MODAL      = 0x0002;
        public const int wxPD_AUTO_HIDE      = 0x0004;
        public const int wxPD_ELAPSED_TIME   = 0x0008;
        public const int wxPD_ESTIMATED_TIME = 0x0010;
        public const int wxPD_REMAINING_TIME = 0x0040;

        public this(IntPtr wxobj);
        public this(string title, string message, int maximum = 100, Window parent = null, int style = wxPD_APP_MODAL | wxPD_AUTO_HIDE);
        public bool Update(int value);
        public bool Update(int value, string newmsg);
        public void Resume();
        public override bool Show(bool show=true);
	override protected void dtor() ;
    }

