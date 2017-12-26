module wx.TextDialog;
public import wx.common;
public import wx.Dialog;

		//! \cond EXTERN
        static extern (C) IntPtr wxTextEntryDialog_ctor(IntPtr parent, string message, string caption, string value, uint style, inout Point pos);
        static extern (C) void wxTextEntryDialog_dtor(IntPtr self);
        static extern (C) void wxTextEntryDialog_SetValue(IntPtr self, string val);
        static extern (C) IntPtr wxTextEntryDialog_GetValue(IntPtr self);
        static extern (C) int wxTextEntryDialog_ShowModal(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias TextEntryDialog wxTextEntryDialog;
    public class TextEntryDialog : Dialog
    {
    	enum {
        wxTextEntryDialogStyle = (wxOK | wxCANCEL | wxCENTRE),
	}
	public const string wxGetTextFromUserPromptStr = "Input Text";

        public this(IntPtr wxobj);
        public  this(Window parent, string message=wxGetTextFromUserPromptStr, string caption="", string value="", int style=wxTextEntryDialogStyle, Point pos=wxDefaultPosition);
        public string Value() ;
        public void Value(string value);
        public override int ShowModal();
    }

    //-----------------------------------------------------------------------------

		//! \cond EXTERN
        static extern (C) IntPtr wxGetPasswordFromUser_func(string message, string caption, string defaultValue, IntPtr parent);
        static extern (C) IntPtr wxGetTextFromUser_func(string message, string caption, string defaultValue, IntPtr parent, int x, int y, bool centre);
		//! \endcond

        //-----------------------------------------------------------------------------

        public string GetPasswordFromUser(string message, string caption=TextEntryDialog.wxGetTextFromUserPromptStr, string defaultValue="", Window parent=null);
        public string GetTextFromUser(string message, string caption=TextEntryDialog.wxGetTextFromUserPromptStr, string defaultValue="", Window parent=null, int x=-1, int y=-1, bool centre=true);