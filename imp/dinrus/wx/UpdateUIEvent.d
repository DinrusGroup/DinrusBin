module wx.UpdateUIEvent;
public import wx.common;
public import wx.CommandEvent;
public import wx.Window;

		//! \cond EXTERN
		static extern (C) IntPtr wxUpdateUIEvent_ctor(int commandId);
		static extern (C) void   wxUpdUIEvt_Enable(IntPtr self, bool enable);
		static extern (C) void   wxUpdUIEvt_Check(IntPtr self, bool check);
		static extern (C) bool   wxUpdateUIEvent_CanUpdate(IntPtr window);
		static extern (C) bool   wxUpdateUIEvent_GetChecked(IntPtr self);
		static extern (C) bool   wxUpdateUIEvent_GetEnabled(IntPtr self);
		static extern (C) bool   wxUpdateUIEvent_GetSetChecked(IntPtr self);
		static extern (C) bool   wxUpdateUIEvent_GetSetEnabled(IntPtr self);
		static extern (C) bool   wxUpdateUIEvent_GetSetText(IntPtr self);
		static extern (C) IntPtr wxUpdateUIEvent_GetText(IntPtr self);
		static extern (C) int    wxUpdateUIEvent_GetMode();
		static extern (C) uint   wxUpdateUIEvent_GetUpdateInterval();
		static extern (C) void   wxUpdateUIEvent_ResetUpdateTime();
		static extern (C) void   wxUpdateUIEvent_SetMode(int mode);
		static extern (C) void   wxUpdateUIEvent_SetText(IntPtr self, string text);
		static extern (C) void   wxUpdateUIEvent_SetUpdateInterval(uint updateInterval);
		//! \endcond

		//-----------------------------------------------------------------------------

	alias UpdateUIEvent wxUpdateUIEvent;
	public class UpdateUIEvent : CommandEvent
	{
		public this(IntPtr wxobj);
		public this(int commandId = 0) ;
		public void Enabled(bool value);
		public void Check(bool value);
		public static bool CanUpdate(Window window);
		public bool Checked() ;
		public bool GetEnabled();
		public bool SetChecked() ;
		public bool SetEnabled();
		public bool SetText() ;
		public string Text();
		public void Text(string value) ;
		static UpdateUIMode Mode() ;
		static void Mode(UpdateUIMode value);
		static int UpdateInterval() ;
		static void UpdateInterval(int value) ;
		public static void ResetUpdateTime();
		private static Event New(IntPtr obj) ;
		static this();
	}
