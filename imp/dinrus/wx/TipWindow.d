module wx.TipWindow;
public import wx.common;
public import wx.Window;

		//! \cond EXTERN
        static extern (C) IntPtr wxTipWindow_ctor(IntPtr parent, string text, int maxLength, Rectangle* rectBound);
        //static extern (C) IntPtr wxTipWindow_ctorNoRect(IntPtr parent, string text, int maxLength);
        //static extern (C) void   wxTipWindow_SetTipWindowPtr(IntPtr self, IntPtr wxTipWindow* windowPtr);
        static extern (C) void   wxTipWindow_SetBoundingRect(IntPtr self, inout Rectangle rectBound);
        static extern (C) void   wxTipWindow_Close(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias TipWindow wxTipWindow;
    public class TipWindow : Window
    {
        public this(IntPtr wxobj);
        public this(Window parent, string text, int maxLength = 100);
        public this(Window parent, string text, int maxLength, Rectangle rectBound);
        public void BoundingRect(Rectangle value) ;
    }
