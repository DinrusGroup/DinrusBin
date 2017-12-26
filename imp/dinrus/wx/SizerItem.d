module wx.SizerItem;
public import wx.common;
public import wx.Window;

		//! \cond EXTERN
        static extern (C) IntPtr wxSizerItem_ctorSpace(int width, int height, int proportion, int flag, int border, IntPtr userData);
        static extern (C) IntPtr wxSizerItem_ctorWindow(IntPtr window, int proportion, int flag, int border, IntPtr userData);
        static extern (C) IntPtr wxSizerItem_ctorSizer(IntPtr sizer, int proportion, int flag, int border, IntPtr userData);
        static extern (C) IntPtr wxSizerItem_ctor();
        static extern (C) void   wxSizerItem_DeleteWindows(IntPtr self);
        static extern (C) void   wxSizerItem_DetachSizer(IntPtr self);
        static extern (C) void   wxSizerItem_GetSize(IntPtr self, inout Size size);
        static extern (C) void   wxSizerItem_CalcMin(IntPtr self, inout Size min);
        static extern (C) void   wxSizerItem_SetDimension(IntPtr self, inout Point pos, inout Size size);
        static extern (C) void   wxSizerItem_GetMinSize(IntPtr self, inout Size size);
        static extern (C) void   wxSizerItem_SetInitSize(IntPtr self, int x, int y);
        static extern (C) void   wxSizerItem_SetRatio(IntPtr self, int width, int height);
        static extern (C) void   wxSizerItem_SetRatioFloat(IntPtr self, float ratio);
        static extern (C) float  wxSizerItem_GetRatioFloat(IntPtr self);
        static extern (C) bool   wxSizerItem_IsWindow(IntPtr self);
        static extern (C) bool   wxSizerItem_IsSizer(IntPtr self);
        static extern (C) bool   wxSizerItem_IsSpacer(IntPtr self);
        static extern (C) void   wxSizerItem_SetProportion(IntPtr self, int proportion);
        static extern (C) int    wxSizerItem_GetProportion(IntPtr self);
        static extern (C) void   wxSizerItem_SetFlag(IntPtr self, int flag);
        static extern (C) int    wxSizerItem_GetFlag(IntPtr self);
        static extern (C) void   wxSizerItem_SetBorder(IntPtr self, int border);
        static extern (C) int    wxSizerItem_GetBorder(IntPtr self);
        static extern (C) IntPtr wxSizerItem_GetWindow(IntPtr self);
        static extern (C) void   wxSizerItem_SetWindow(IntPtr self, IntPtr window);
        static extern (C) IntPtr wxSizerItem_GetSizer(IntPtr self);
        static extern (C) void   wxSizerItem_SetSizer(IntPtr self, IntPtr sizer);
        static extern (C) void   wxSizerItem_GetSpacer(IntPtr self, inout Size size);
        static extern (C) void   wxSizerItem_SetSpacer(IntPtr self, inout Size size);
        static extern (C) void   wxSizerItem_Show(IntPtr self, bool show);
        static extern (C) bool   wxSizerItem_IsShown(IntPtr self);
        static extern (C) IntPtr wxSizerItem_GetUserData(IntPtr self);
        static extern (C) void   wxSizerItem_GetPosition(IntPtr self, inout Point pos);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias SizerItem wxSizerItem;
    public class SizerItem : wxObject
    {
        public this(int width, int height, int proportion, int flag, int border, wxObject userData);
        public this(Window window, int proportion, int flag, int border, wxObject userData);
        public this(Sizer sizer, int proportion, int flag, int border, wxObject userData);
        public this();
        public this(IntPtr wxobj);
        public void DeleteWindows();
        public void DetachSizer();
        public Size size() ;
        public Size CalcMin();
        public void SetDimension(Point pos, Size size);
        public Size MinSize() ;
        public void SetInitSize(int x, int y);
        public void SetRatio(Size size);
        public void SetRatio(int width, int height);
        public void Ratio(float value);
        public float Ratio() ;
        public bool IsWindow() ;
        public bool IsSizer() ;
        public bool IsSpacer() ;
        public void Proportion(int value) ;
        public int Proportion() ;
        public void Flag(int value) ;
        public int Flag() ;
        public void Border(int value) ;
        public int Border();
        public Window window();
        public void window(Window value) ;
        public Sizer sizer();
        public void sizer(Sizer value) ;
        public Size Spacer();
        public void Spacer(Size value);
        public void Show(bool show);
        public bool IsShown() ;
        public wxObject UserData();
        public Point Position() ;
    }

