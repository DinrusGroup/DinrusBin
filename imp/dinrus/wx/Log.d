module wx.Log;
public import wx.common;
public import wx.TextCtrl;


		//! \cond EXTERN
		static extern (C) IntPtr wxLog_ctor();
		static extern (C) bool wxLog_IsEnabled();
		static extern (C) void wxLog_FlushActive();
		static extern (C) IntPtr wxLog_SetActiveTargetTextCtrl(IntPtr pLogger);
		static extern (C) void wxLog_Log_Function(int what, string szFormat);
		static extern (C) void wxLog_AddTraceMask(string tmask);
		//! \endcond
		
	alias Log wxLog;
	public class Log : wxObject
	{
		enum eLogLevel : int
		{
			xLOG,
			xFATALERROR,
			xERROR,
			xWARNING,
			xINFO,
			xVERBOSE,
			xSTATUS,
			xSYSERROR
		}
		
		public this(IntPtr wxobj);
		public this();
		static bool IsEnabled() ;
		public static void FlushActive();
		public static void SetActiveTarget(TextCtrl pLogger);
		public static void AddTraceMask(string tmask);
		public static void LogMessage(...);
		public static void LogFatalError(...);
		public static void LogError(...);
		public static void LogWarning(...);
		public static void LogInfo(...);
		public static void LogVerbose(...);
		public static void LogStatus(...);
		public static void LogSysError(...);
		private static string stringFormat(TypeInfo[] arguments, va_list argptr);

//! \cond VERSION
version (none) {
/* C# compatible */
private static string stringFormat(char[] str,va_list argptr,TypeInfo[] arguments);

}
//! \endcond
	}

