module wx.TipDialog;
public import wx.common;
public import wx.Dialog;

	//! \cond EXTERN
	static extern (C) IntPtr wxCreateFileTipProvider_func(string filename, int currentTip);
	static extern (C) bool wxShowTip_func(IntPtr parent, IntPtr tipProvider, bool showAtStartup);
	static extern (C) int wxTipProvider_GetCurrentTip();
	//! \endcond

    alias TipProvider wxTipProvider;
    public class TipProvider
    {
	public static IntPtr CreateFileTipProvider(string filename, int currentTip);
	public static bool ShowTip(Window parent, IntPtr tipProvider);
	public static bool ShowTip(Window parent, IntPtr tipProvider, bool showAtStartup);
	static int CurrentTip() ;
    }
