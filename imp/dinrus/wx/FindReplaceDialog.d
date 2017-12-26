
module wx.FindReplaceDialog;
public import wx.common;
public import wx.Dialog;
public import wx.CommandEvent;

		//! \cond EXTERN
        static extern (C) IntPtr wxFindReplaceDialog_ctor();
        static extern (C) bool   wxFindReplaceDialog_Create(IntPtr self, IntPtr parent, IntPtr data, string title, uint style);

        static extern (C) IntPtr wxFindReplaceDialog_GetData(IntPtr self);
        static extern (C) void   wxFindReplaceDialog_SetData(IntPtr self, IntPtr data);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias FindReplaceDialog wxFindReplaceDialog;
    public class FindReplaceDialog : Dialog
    {
        public const int wxFR_DOWN       = 1;
        public const int wxFR_WHOLEWORD  = 2;
        public const int wxFR_MATCHCASE  = 4;

        public const int wxFR_REPLACEDIALOG = 1;
        public const int wxFR_NOUPDOWN      = 2;
        public const int wxFR_NOMATCHCASE   = 4;
        public const int wxFR_NOWHOLEWORD   = 8;

        //-----------------------------------------------------------------------------

        public this(IntPtr wxobj) ;
        public this();
        public this(Window parent, FindReplaceData data, string title, int style = 0);
        public bool Create(Window parent, FindReplaceData data, string title, int style = 0);
        public FindReplaceData Data() ;
        public void Data(FindReplaceData value);
		public void Find_Add(EventListener value) ;
		public void Find_Remove(EventListener value) ;
		public void FindNext_Add(EventListener value) ;
		public void FindNext_Remove(EventListener value) ;
		public void FindReplace_Add(EventListener value) ;
		public void FindReplace_Remove(EventListener value) ;
		public void FindReplaceAll_Add(EventListener value) ;
		public void FindReplaceAll_Remove(EventListener value) ;
		public void FindClose_Add(EventListener value) ;
		public void FindClose_Remove(EventListener value);
    }

	//-----------------------------------------------------------------------------

		//! \cond EXTERN
        static extern (C) IntPtr wxFindDialogEvent_ctor(int commandType, int id);

        static extern (C) int    wxFindDialogEvent_GetFlags(IntPtr self);
        static extern (C) void   wxFindDialogEvent_SetFlags(IntPtr self, int flags);

        static extern (C) IntPtr wxFindDialogEvent_GetFindString(IntPtr self);
        static extern (C) void   wxFindDialogEvent_SetFindString(IntPtr self, string str);

        static extern (C) IntPtr wxFindDialogEvent_GetReplaceString(IntPtr self);
        static extern (C) void   wxFindDialogEvent_SetReplaceString(IntPtr self, string str);

        static extern (C) IntPtr wxFindDialogEvent_GetDialog(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias FindDialogEvent wxFindDialogEvent;
    public class FindDialogEvent : CommandEvent
    {
	static this()
	{
			wxEVT_COMMAND_FIND = wxEvent_EVT_COMMAND_FIND();
			wxEVT_COMMAND_FIND_NEXT = wxEvent_EVT_COMMAND_FIND_NEXT();
			wxEVT_COMMAND_FIND_REPLACE = wxEvent_EVT_COMMAND_FIND_REPLACE();
			wxEVT_COMMAND_FIND_REPLACE_ALL = wxEvent_EVT_COMMAND_FIND_REPLACE_ALL();
			wxEVT_COMMAND_FIND_CLOSE = wxEvent_EVT_COMMAND_FIND_CLOSE();

			AddEventType(wxEVT_COMMAND_FIND,	&FindDialogEvent.New);
			AddEventType(wxEVT_COMMAND_FIND_NEXT,	&FindDialogEvent.New);
			AddEventType(wxEVT_COMMAND_FIND_REPLACE,	&FindDialogEvent.New);
			AddEventType(wxEVT_COMMAND_FIND_REPLACE_ALL,	&FindDialogEvent.New);
			AddEventType(wxEVT_COMMAND_FIND_CLOSE,	&FindDialogEvent.New);
	
	}

        public this(IntPtr wxobj);
        public this(int commandType, int id);
    	public static Event New(IntPtr ptr) ;
        public int Flags();
        public void Flags(int value);
        public string FindString();
        public void FindString(string value) ;
        public string ReplaceString();
        public void ReplaceString(string value);
        public FindReplaceDialog Dialog() ;
    }

	//-----------------------------------------------------------------------------

		//! \cond EXTERN
        static extern (C) IntPtr wxFindReplaceData_ctor(uint flags);

        static extern (C) IntPtr wxFindReplaceData_GetFindString(IntPtr self);
        static extern (C) void   wxFindReplaceData_SetFindString(IntPtr self, string str);

        static extern (C) int    wxFindReplaceData_GetFlags(IntPtr self);
        static extern (C) void   wxFindReplaceData_SetFlags(IntPtr self, int flags);

        static extern (C) void   wxFindReplaceData_SetReplaceString(IntPtr self, string str);
        static extern (C) IntPtr wxFindReplaceData_GetReplaceString(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias FindReplaceData wxFindReplaceData;
    public class FindReplaceData : wxObject
    {
        public this(IntPtr wxobj);
        public this();
        public this(int flags);
        public string FindString();
        public void FindString(string value) ;
        public string ReplaceString();
        public void ReplaceString(string value) ;
        public int Flags() ;
        public void Flags(int value);
        public static wxObject New(IntPtr ptr) ;
    }

