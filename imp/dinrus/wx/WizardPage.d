module wx.WizardPage;
public import wx.Panel;

	alias WizardPage wxWizardPage;
	public class WizardPage : Panel
	{
		public this(IntPtr wxobj);
		static wxObject New(IntPtr ptr) ;
	}

