module wx.Utils;
public import wx.common;
public import wx.Window;

		//! \cond EXTERN
		static extern (C) IntPtr wxGlobal_GetHomeDir();
		static extern (C) IntPtr wxGlobal_GetCwd();
		static extern (C) void wxSleep_func(int num);
		static extern (C) void wxMilliSleep_func(uint num);
		static extern (C) void wxMicroSleep_func(uint num);
		static extern (C) void wxYield_func();
		static extern (C) void wxBeginBusyCursor_func();
		static extern (C) void wxEndBusyCursor_func();
		static extern (C) void wxMutexGuiEnter_func();
		static extern (C) void wxMutexGuiLeave_func();
		//! \endcond


		public static string GetHomeDir();
		public static string GetCwd();
		public static void wxSleep(int num);
		public static void wxMilliSleep(int num);
		public static void wxMicroSleep(int num);
		public static void wxYield();
		public static void BeginBusyCursor();
		public static void EndBusyCursor();
		public static void MutexGuiEnter();
		public static void MutexGuiLeave();

	alias BusyCursor wxBusyCursor;
	public class BusyCursor : IDisposable
	{
		private bool disposed = false;
		public this();
		~this();
		public void Dispose();
	}

	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxWindowDisabler_ctor(IntPtr winToSkip);
		static extern (C) void wxWindowDisabler_dtor(IntPtr self);
		//! \endcond

	alias WindowDisabler wxWindowDisabler;
	public scope class WindowDisabler : wxObject
	{
		//---------------------------------------------------------------------

		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this();
		public this(Window winToSkip);
		override protected void dtor();
	}

	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxBusyInfo_ctor(string message, IntPtr parent);
		static extern (C) void   wxBusyInfo_dtor(IntPtr self);
		//! \endcond

	alias BusyInfo wxBusyInfo;
	public scope class BusyInfo : wxObject
	{
		//---------------------------------------------------------------------

		public this(IntPtr wxobj);
		public this(string message);
		public this(string message, Window parent);
		private this(IntPtr wxobj, bool memOwn);
		override protected void dtor();
	}

	//---------------------------------------------------------------------
