module wx.Dialog;
public import wx.common;
public import wx.Window;

		//! \cond EXTERN
		static extern (C) IntPtr wxDialog_ctor();
		static extern (C) void   wxDialog_dtor(IntPtr self);

		static extern (C) void   wxDialog_SetReturnCode(IntPtr self, int returnCode);
		static extern (C) int    wxDialog_GetReturnCode(IntPtr self);

		static extern (C) IntPtr wxDialog_GetTitle(IntPtr self);
		static extern (C) void   wxDialog_SetTitle(IntPtr self, string title);

		static extern (C) bool   wxDialog_Create(IntPtr self, IntPtr parent, int id, string title, inout Point pos, inout Size size, uint style, string name);

		static extern (C) void   wxDialog_EndModal(IntPtr self, int retCode);

		static extern (C) bool   wxDialog_IsModal(IntPtr self);
		//static extern (C) void   wxDialog_SetModal(IntPtr self, bool modal);

		static extern (C) void   wxDialog_SetIcon(IntPtr self, IntPtr icon);
		static extern (C) void   wxDialog_SetIcons(IntPtr self, IntPtr icons);

		static extern (C) int    wxDialog_ShowModal(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------

	alias Dialog wxDialog;
	/// A dialog box is a window with a title bar and sometimes a
	/// system menu, which can be moved around the screen. It can contain
	/// controls and other windows and is usually used to allow the user
	/// to make some choice or to answer a question.
	public class Dialog : Window
	{
		enum {
		wxCENTER		= 0x00000001,
		wxCENTRE		= 0x00000001,
		wxYES			= 0x00000002,
		wxOK			= 0x00000004,
		wxNO			= 0x00000008,
		wxCANCEL		= 0x00000010,
		wxYES_NO		= (wxYES | wxNO),

		wxYES_DEFAULT		= 0x00000000,
		wxNO_DEFAULT		= 0x00000080,

		wxICON_EXCLAMATION 	= 0x00000100,
		wxICON_HAND		= 0x00000200,
		wxICON_WARNING	= wxICON_EXCLAMATION,
		wxICON_ERROR		= wxICON_HAND,
		wxICON_QUESTION	= 0x00000400,
		wxICON_INFORMATION	= 0x00000800,
		wxICON_STOP		= wxICON_HAND,
		wxICON_ASTERISK	= wxICON_INFORMATION,
		wxICON_MASK		= (0x00000100|0x00000200|0x00000400|0x00000800),

		wxFORWARD		= 0x00001000,
		wxBACKWARD		= 0x00002000,
		wxRESET		= 0x00004000,
		wxHELP		= 0x00008000,
		wxMORE 		= 0x00010000,
		wxSETUP		= 0x00020000,
		}

		//---------------------------------------------------------------------
		const string wxDialogNameStr="dialog";

		public this(IntPtr wxobj);
		public this();
		public this(Window parent, int id, string title, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=wxDEFAULT_DIALOG_STYLE, string name=wxDialogNameStr);
		public this(Window parent, string title, Point pos=wxDefaultPosition, Size size=wxDefaultSize, int style=wxDEFAULT_DIALOG_STYLE, string name=wxDialogNameStr);
		public bool Create(Window window, int id, string title, inout Point pos,
						   inout Size size, int style, string name);
		public int ReturnCode() ;
		public void ReturnCode(int value);
		public override string Title() ;
		public override void Title(string value) ;
		public void EndModal(int retCode);
		public void SetIcon(Icon icon);
		//public void SetIcons(IconBundle icons);
		public /+virtual+/ int ShowModal();
		//deprecated public void Modal(bool value) ;
		public bool Modal() ;
	}
