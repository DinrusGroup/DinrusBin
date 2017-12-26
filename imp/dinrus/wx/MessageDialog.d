
module wx.MessageDialog;
public import wx.common;
public import wx.Dialog;

	// The MessageDialog class implements the interface for wxWidgets' 
	// wxMessageDialog class and wxMessageBox.

		//! \cond EXTERN

		// MessageBox function
		static extern (C) int    wxMsgBox(IntPtr parent, string msg, string cap, uint style, inout Point pos);

		// Message dialog methods
		static extern (C) IntPtr wxMessageDialog_ctor(IntPtr parent, string message, string caption, uint style, inout Point pos);
		static extern (C) int    wxMessageDialog_ShowModal(IntPtr self);

		//! \endcond

	alias MessageDialog wxMessageDialog;
	public class MessageDialog : Dialog
	{
		public const string wxMessageBoxCaptionStr = "Message";
		//---------------------------------------------------------------------
	
		private this(IntPtr wxobj) ;
		public this(Window parent, string msg, string caption=wxMessageBoxCaptionStr, int style=wxOK | wxCENTRE, Point pos = wxDefaultPosition);
		public override int ShowModal();

	}

		static extern(C) int wxMessageBox_func(string msg, string cap, int style, IntPtr parent,int x, int y);

		static int MessageBox(string msg,string caption=MessageDialog.wxMessageBoxCaptionStr,int style=Dialog.wxOK | Dialog.wxCENTRE , Window parent=null, int x=-1, int y=-1);		
		static int MessageBox(Window parent,string msg,string caption=MessageDialog.wxMessageBoxCaptionStr,int style=Dialog.wxOK | Dialog.wxCENTRE , Point pos=Dialog.wxDefaultPosition);