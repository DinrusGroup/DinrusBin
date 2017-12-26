module wx.WizardPageSimple;
public import wx.WizardPage;
public import wx.Wizard;

		//! \cond EXTERN
		static extern (C) IntPtr wxWizardPageSimple_ctor(IntPtr parent, IntPtr prev, IntPtr next, IntPtr bitmap, string resource);
		static extern (C) void   wxWizardPageSimple_Chain(IntPtr first, IntPtr second);
		//! \endcond

		//---------------------------------------------------------------------

	alias WizardPageSimple wxWizardPageSimple;
	public class WizardPageSimple : WizardPage
	{
		public this(Wizard parent, WizardPage prev = null, WizardPage next = null, Bitmap bitmap = Bitmap.wxNullBitmap, string resource = null);
		public this(IntPtr wxobj) ;
		public static void Chain(WizardPageSimple first, WizardPageSimple second);
	}

