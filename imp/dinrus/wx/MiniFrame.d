module wx.MiniFrame;
public import wx.common;
public import wx.Frame;

		//! \cond EXTERN
        static extern (C) IntPtr wxMiniFrame_ctor();
        static extern (C) bool   wxMiniFrame_Create(IntPtr self, IntPtr parent, int id, string title, inout Point pos, inout Size size, uint style, string name);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias MiniFrame wxMiniFrame;
    public class MiniFrame : Frame
    {
        enum { wxDEFAULT_MINIFRAME_STYLE = wxCAPTION | wxCLIP_CHILDREN | wxRESIZE_BORDER }
    
        public this(IntPtr wxobj) ;
        public this();
        public this(Window parent, int id, string title, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=wxDEFAULT_MINIFRAME_STYLE, string name=wxFrameNameStr);
        public this(Window parent, string title, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=wxDEFAULT_MINIFRAME_STYLE, string name=wxFrameNameStr);
        public override bool Create(Window parent, int id, string title, inout Point pos, inout Size size, int style, string name);
        public this(string title, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=wxDEFAULT_MINIFRAME_STYLE);
    }

