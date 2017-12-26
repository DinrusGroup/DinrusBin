module wx.CommandEvent;
public import wx.common;
public import wx.Event;

public import wx.ClientData;

		//! \cond EXTERN
		static extern (C) IntPtr wxCommandEvent_ctor(int type,int winid);
		static extern (C) int    wxCommandEvent_GetSelection(IntPtr self);
		static extern (C) IntPtr wxCommandEvent_GetString(IntPtr self);
		static extern (C) void wxCommandEvent_SetString(IntPtr self, string s);
		static extern (C) bool   wxCommandEvent_IsChecked(IntPtr self);
		static extern (C) bool   wxCommandEvent_IsSelection(IntPtr self);
		static extern (C) int    wxCommandEvent_GetInt(IntPtr self);
		static extern (C) void wxCommandEvent_SetInt(IntPtr self, int i);

		static extern (C) IntPtr wxCommandEvent_GetClientObject(IntPtr self);
		static extern (C) void   wxCommandEvent_SetClientObject(IntPtr self, IntPtr data);

		static extern (C) void wxCommandEvent_SetExtraLong(IntPtr self, uint extralong);
		static extern (C) uint wxCommandEvent_GetExtraLong(IntPtr self);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias CommandEvent wxCommandEvent;
	public class CommandEvent : Event
	{

		public this(IntPtr wxobj);
		public this(EventType commandType = wxEVT_NULL, int winid = 0);
		public int Selection();
		public string String();
		public void String(string value) ;
		public bool IsChecked();
		public bool IsSelection() ;
		public int Int() ;
		public void Int(int value) ;
		public ClientData ClientObject();
		public void ClientObject(ClientData value) ;
		public int ExtraLong();
		public void ExtraLong(int value) ;
		private static Event New(IntPtr obj);
		    static this()
    {
        AddEventType(wxEVT_COMMAND_BUTTON_CLICKED,          &CommandEvent.New);
        AddEventType(wxEVT_COMMAND_MENU_SELECTED,           &CommandEvent.New);

        AddEventType(wxEVT_COMMAND_CHECKBOX_CLICKED,        &CommandEvent.New);

        AddEventType(wxEVT_COMMAND_LISTBOX_SELECTED,        &CommandEvent.New);
        AddEventType(wxEVT_COMMAND_LISTBOX_DOUBLECLICKED,   &CommandEvent.New);
        AddEventType(wxEVT_COMMAND_CHOICE_SELECTED,         &CommandEvent.New);
        AddEventType(wxEVT_COMMAND_COMBOBOX_SELECTED,       &CommandEvent.New);
        AddEventType(wxEVT_COMMAND_TEXT_UPDATED,            &CommandEvent.New);
        AddEventType(wxEVT_COMMAND_TEXT_ENTER,              &CommandEvent.New);
        AddEventType(wxEVT_COMMAND_RADIOBOX_SELECTED,       &CommandEvent.New);
        AddEventType(wxEVT_COMMAND_RADIOBUTTON_SELECTED,    &CommandEvent.New);
        AddEventType(wxEVT_COMMAND_SLIDER_UPDATED,          &CommandEvent.New);
        AddEventType(wxEVT_COMMAND_SPINCTRL_UPDATED,        &CommandEvent.New);

        AddEventType(wxEVT_COMMAND_TOGGLEBUTTON_CLICKED,    &CommandEvent.New);

        AddEventType(wxEVT_COMMAND_CHECKLISTBOX_TOGGLED,    &CommandEvent.New);
    }
	}
