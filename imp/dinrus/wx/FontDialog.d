module wx.FontDialog;
public import wx.common;
public import wx.Dialog;
public import wx.Font;
public import wx.GdiCommon; //for nullobject

		//! \cond EXTERN
		static extern (C) IntPtr wxFontData_ctor();
		static extern (C) void   wxFontData_dtor(IntPtr self);

		static extern (C) void   wxFontData_SetAllowSymbols(IntPtr self, bool flag);
		static extern (C) bool   wxFontData_GetAllowSymbols(IntPtr self);

		static extern (C) void   wxFontData_SetColour(IntPtr self, IntPtr colour);
		static extern (C) IntPtr wxFontData_GetColour(IntPtr self);

		static extern (C) void   wxFontData_SetShowHelp(IntPtr self, bool flag);
		static extern (C) bool   wxFontData_GetShowHelp(IntPtr self);

		static extern (C) void   wxFontData_EnableEffects(IntPtr self, bool flag);
		static extern (C) bool   wxFontData_GetEnableEffects(IntPtr self);

		static extern (C) void   wxFontData_SetInitialFont(IntPtr self, IntPtr font);
		static extern (C) IntPtr wxFontData_GetInitialFont(IntPtr self);

		static extern (C) void   wxFontData_SetChosenFont(IntPtr self, IntPtr font);
		static extern (C) IntPtr wxFontData_GetChosenFont(IntPtr self);

		static extern (C) void   wxFontData_SetRange(IntPtr self, int minRange, int maxRange);
		//! \endcond

        //---------------------------------------------------------------------

    alias FontData wxFontData;
    public class FontData : wxObject
    {
        public this(IntPtr wxobj) ;
        public this();
        public bool AllowSymbols();
        public void AllowSymbols(bool value);
        public bool EffectsEnabled();
        public void EffectsEnabled(bool value) ;
        public bool ShowHelp();
        public void ShowHelp(bool value);
        public Colour colour() ;
        public void colour(Colour value) ;
        public Font InitialFont() ;
        public void InitialFont(Font value) ;
        public Font ChosenFont() ;
        public void ChosenFont(Font value) ;
        public void SetRange(int min, int max);
    	public static wxObject New(IntPtr ptr) ;
    }

		//! \cond EXTERN
		static extern (C) IntPtr wxFontDialog_ctor();
		static extern (C) bool   wxFontDialog_Create(IntPtr self, IntPtr parent, IntPtr data);
		static extern (C) void   wxFontDialog_dtor(IntPtr self);

		static extern (C) int    wxFontDialog_ShowModal(IntPtr self);
		static extern (C) IntPtr wxFontDialog_GetFontData(IntPtr self);
		//! \endcond

        //---------------------------------------------------------------------

	alias FontDialog wxFontDialog;
	public class FontDialog : Dialog
	{
        public this(IntPtr wxobj);
        public this();
        public this(Window parent);
        public this(Window parent, FontData data);
        public bool Create(Window parent, FontData data);
        public FontData fontData() ;
        public override int ShowModal();
	}

	//! \cond EXTERN
	extern (C) IntPtr wxGetFontFromUser_func(IntPtr parent, IntPtr fontInit);
	//! \endcond

	Font GetFontFromUser(Window parent,Font fontInit=null);
