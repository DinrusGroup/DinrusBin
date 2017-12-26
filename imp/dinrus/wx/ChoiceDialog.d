module wx.ChoiceDialog;
public import wx.common;
public import wx.Dialog;
public import wx.ClientData;
public import wx.ArrayInt;

		//! \cond EXTERN
        static extern (C) IntPtr wxSingleChoiceDialog_ctor(IntPtr parent, string message, string caption, int n, string* choices, IntPtr clientData, uint style, inout Point pos);
        static extern (C) void wxSingleChoiceDialog_SetSelection(IntPtr self, int sel);
        static extern (C) int wxSingleChoiceDialog_GetSelection(IntPtr self);
        static extern (C) IntPtr wxSingleChoiceDialog_GetStringSelection(IntPtr self);
        static extern (C) IntPtr wxSingleChoiceDialog_GetSelectionClientData(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias SingleChoiceDialog wxSingleChoiceDialog;
    public class SingleChoiceDialog : Dialog
    {
        enum {
            wxCHOICEDLG_STYLE	= (wxDEFAULT_DIALOG_STYLE | wxRESIZE_BORDER | wxOK | wxCANCEL | wxCENTRE)
        }
	public const int wxCHOICE_HEIGHT = 150;
	public const int wxCHOICE_WIDTH  = 200;


        public this(IntPtr wxobj);
        public  this(Window parent, string message, string caption, string[] choices, ClientData clientData = null, int style =  wxCHOICEDLG_STYLE, Point pos = wxDefaultPosition);
        public void Selection(int sel);
        public int Selection();
        public string StringSelection();
        public ClientData SelectionClientData();
    }

	//-----------------------------------------------------------------------------

		//! \cond EXTERN
        static extern (C) IntPtr wxMultiChoiceDialog_ctor(IntPtr parent, string message, string caption, int n, string* choices, uint style, inout Point pos);
        static extern (C) void wxMultiChoiceDialog_SetSelections(IntPtr self, int* sel, int numsel);
        static extern (C) IntPtr wxMultiChoiceDialog_GetSelections(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias MultiChoiceDialog wxMultiChoiceDialog;
    public class MultiChoiceDialog : Dialog
    {
        public this(IntPtr wxobj);
        public  this(Window parent, string message, string caption, string[] choices, int style = SingleChoiceDialog.wxCHOICEDLG_STYLE, Point pos = wxDefaultPosition);
        public void SetSelections(int[] sel);
        public int[] GetSelections();
    }

	//-----------------------------------------------------------------------------

	//! \cond EXTERN
	static extern (C) IntPtr wxGetSingleChoice_func(string message, string caption, int n, string* choices, IntPtr parent, int x, int y, bool centre, int width, int height);
	static extern (C) int wxGetSingleChoiceIndex_func(string message, string caption, int n, string* choices, IntPtr parent, int x, int y, bool centre, int width, int height);
	static extern (C) void* wxGetSingleChoiceData_func(string message, string caption, int n, string* choices, void **client_data, IntPtr parent, int x, int y, bool centre, int width, int height);
	static extern (C) uint wxGetMultipleChoices_func(IntPtr selections,string message, string caption, int n, string* choices, IntPtr parent, int x, int y, bool centre, int width, int height);
	//! \endcond

	public string GetSingleChoice(string message, string caption, string[] choices, Window parent = null, int x = -1, int y= -1, bool centre = true, int width = SingleChoiceDialog.wxCHOICE_WIDTH, int height = SingleChoiceDialog.wxCHOICE_HEIGHT);
	public int GetSingleChoiceIndex(string message, string caption, string[] choices, Window parent = null, int x = -1, int y= -1, bool centre = true, int width = SingleChoiceDialog.wxCHOICE_WIDTH, int height = SingleChoiceDialog.wxCHOICE_HEIGHT);
	public void* GetSingleChoiceData(string message, string caption, string[] choices, void **client_data, Window parent = null, int x = -1, int y= -1, bool centre = true, int width = SingleChoiceDialog.wxCHOICE_WIDTH, int height = SingleChoiceDialog.wxCHOICE_HEIGHT);
	public int[] GetMultipleChoices(string message, string caption, string[] choices, Window parent = null, int x = -1, int y= -1, bool centre = true, int width = SingleChoiceDialog.wxCHOICE_WIDTH, int height = SingleChoiceDialog.wxCHOICE_HEIGHT);