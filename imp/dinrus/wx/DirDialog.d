module wx.DirDialog;
public import wx.common;
public import wx.Dialog;

		//! \cond EXTERN
        static extern (C) IntPtr wxDirDialog_ctor(IntPtr parent, string message, string defaultPath, uint style, inout Point pos, inout Size size, string name);

        static extern (C) void   wxDirDialog_SetPath(IntPtr self, string path);
        static extern (C) IntPtr wxDirDialog_GetPath(IntPtr self);

        static extern (C) int    wxDirDialog_GetStyle(IntPtr self);
        static extern (C) void   wxDirDialog_SetStyle(IntPtr self, int style);

        static extern (C) void   wxDirDialog_SetMessage(IntPtr self, string message);
        static extern (C) IntPtr wxDirDialog_GetMessage(IntPtr self);

        static extern (C) int    wxDirDialog_ShowModal(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias DirDialog wxDirDialog;
    public class DirDialog : Dialog
    {
	enum {  wxDD_NEW_DIR_BUTTON  = 0x0080 }
	enum {  wxDD_DEFAULT_STYLE = (wxDEFAULT_DIALOG_STYLE | wxRESIZE_BORDER | wxDD_NEW_DIR_BUTTON) }

	public const string wxDirSelectorPromptStr = "Выберите папку";
	public const string wxDirDialogNameStr = "DirDialog";
	
        public this(IntPtr wxobj) ;
        public this(Window parent, string title = wxDirSelectorPromptStr, string defaultPath = "", int style = wxDD_DEFAULT_STYLE, Point pos = wxDefaultPosition, Size size = wxDefaultSize, string name = wxDirDialogNameStr);
        public void Path(string value);
        public string Path() ;
        public void Message(string value);
        public string Message() ;
        public override int ShowModal();
        public void Style(int value);
        public int Style() ;
    }

	//! \cond EXTERN
	extern (C) string wxDirSelector_func(string message,
              string defaultPath,
              int style,
              inout Point pos,
              IntPtr parent);
	//! \endcond

	string DirSelector(string message = null,
              string defaultPath = null,
              int style = DirDialog.wxDD_DEFAULT_STYLE ,
              Point pos = Dialog.wxDefaultPosition,
              Window parent = null);
