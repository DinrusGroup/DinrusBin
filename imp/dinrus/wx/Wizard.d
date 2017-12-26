module wx.Wizard;
public import wx.common;
public import wx.Dialog;
public import wx.Panel;
//public import wx.NotifyEvent;
public import wx.WizardPage;

		//! \cond EXTERN
		static extern (C) IntPtr wxWizard_ctor(IntPtr parent, int id, string title, IntPtr bitmap, inout Point pos, int style);
		static extern (C) bool   wxWizard_RunWizard(IntPtr self, IntPtr firstPage);
		static extern (C) void   wxWizard_SetPageSize(IntPtr self, inout Size size);
		//! \endcond

		//---------------------------------------------------------------------
		
	alias Wizard wxWizard;
	public class Wizard : Dialog
	{
		public this(IntPtr wxobj) ;
		public this(Window parent, int id = wxID_ANY, string title = "", Bitmap bitmap = Bitmap.wxNullBitmap, Point pos = wxDefaultPosition, int style = wxDEFAULT_DIALOG_STYLE);
		public bool RunWizard(WizardPage firstPage);
		public void PageSize(Size value) ;
	}

		//! \cond EXTERN
		static extern (C) IntPtr wxWizardEvent_ctor(int type,int id, bool direction,IntPtr page);
		static extern (C) bool   wxWizardEvent_GetDirection(IntPtr self);
		static extern (C) IntPtr wxWizardEvent_GetPage(IntPtr self);

		static extern (C) EventType wxEvent_WIZARD_PAGE_CHANGED();
		static extern (C) EventType wxEvent_WIZARD_PAGE_CHANGING();
		static extern (C) EventType wxEvent_WIZARD_CANCEL();
		static extern (C) EventType wxEvent_WIZARD_HELP();
		static extern (C) EventType wxEvent_WIZARD_FINISHED();
		//! \endcond

/+
	alias WizardEvent wxWizardEvent;
	public class WizardEvent : NotifyEvent
	{
		static EventType wxEVT_WIZARD_PAGE_CHANGED;
		static EventType wxEVT_WIZARD_PAGE_CHANGING;
		static EventType wxEVT_WIZARD_CANCEL;
		static EventType wxEVT_WIZARD_HELP;
		static EventType wxEVT_WIZARD_FINISHED;
	
		static this()
		{
			wxEVT_WIZARD_PAGE_CHANGED  = wxEvent_WIZARD_PAGE_CHANGED();
			wxEVT_WIZARD_PAGE_CHANGING = wxEvent_WIZARD_PAGE_CHANGING();
			wxEVT_WIZARD_CANCEL   = wxEvent_WIZARD_CANCEL();
			wxEVT_WIZARD_HELP     = wxEvent_WIZARD_HELP();
			wxEVT_WIZARD_FINISHED = wxEvent_WIZARD_FINISHED();
			
			AddEventType(wxEVT_WIZARD_PAGE_CHANGED,  &WizardEvent.New);
			AddEventType(wxEVT_WIZARD_PAGE_CHANGING, &WizardEvent.New);
			AddEventType(wxEVT_WIZARD_CANCEL,   &WizardEvent.New);
			AddEventType(wxEVT_WIZARD_HELP,     &WizardEvent.New);
			AddEventType(wxEVT_WIZARD_FINISHED, &WizardEvent.New);
		}
	
		this(IntPtr ptr)
			{ super(ptr); }
	
		this(EventType type = wxEVT_NULL, int id = wxID_ANY, bool direction = true, WizardPage page = null)
		{
			this(wxWizardEvent_ctor(type,id,direction,wxObject.SafePtr(page)));
		}

		static Event New(IntPtr ptr) { return new WizardEvent(ptr); }

		bool Direction()
		{
			return wxWizardEvent_GetDirection(wxobj);
		}
		WizardPage Page()
		{
			return cast(WizardPage)FindObject(wxWizardEvent_GetPage(wxobj),&WizardPage.New);
		}
	}
+/
