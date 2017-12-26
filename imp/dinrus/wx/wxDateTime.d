module wx.wxDateTime;
public import wx.common;
//private import std.date;

    alias wxDateTime DateTime;
    enum DayOfWeek
    {
        Sun, Mon, Tue, Wed, Thu, Fri, Sat, Inv_WeekDay
    };

/* wxDateTime imprementation is class { longlong } */

		//! \cond EXTERN
        static extern (C) IntPtr wxDefaultDateTime_Get();
        static extern (C) IntPtr wxDateTime_ctor();
        static extern (C) IntPtr wxDateTime_Now();
	static extern (C) void   wxDateTime_dtor(IntPtr self);
        static extern (C) void   wxDateTime_Set(IntPtr self, ushort day, int month, int year, ushort hour, ushort minute, ushort second, ushort millisec);
        static extern (C) ushort wxDateTime_GetYear(IntPtr self);
        static extern (C) int    wxDateTime_GetMonth(IntPtr self);
        static extern (C) ushort wxDateTime_GetDay(IntPtr self);
        static extern (C) ushort wxDateTime_GetHour(IntPtr self);
        static extern (C) ushort wxDateTime_GetMinute(IntPtr self);
        static extern (C) ushort wxDateTime_GetSecond(IntPtr self);
        static extern (C) ushort wxDateTime_GetMillisecond(IntPtr self);
		//! \endcond
	
        //-----------------------------------------------------------------------------

    /// wxDateTime class represents an absolute moment in time.
    public class wxDateTime : wxObject
    {
	static wxDateTime wxDefaultDateTime;
	static this();
        public this(IntPtr wxobj);
	private this(IntPtr wxobj, bool memOwn);
        public this();
	override protected void dtor();
        public void Set(ushort day, int month, int year, ushort hour, ushort minute, ushort second, ushort millisec);
        public ushort Year() ;
        public int Month();
        public ushort Day();
        public ushort Hour() ;
        public ushort Minute() ;        
        public ushort Second();
        public ushort Millisecond() ;
	static wxDateTime Now() ;
        //-----------------------------------------------------------------------------
/+
        public static implicit operator DateTime (wxDateTime wdt)
        {
            DateTime dt = new DateTime(wdt.Year, cast(int)wdt.Month+1, cast(int)wdt.Day, 
                                       cast(int)wdt.Hour, cast(int)wdt.Minute, 
                                       cast(int)wdt.Second, cast(int)wdt.Millisecond);
            return dt;
        }

        public static implicit operator wxDateTime (DateTime dt)
        {
            wxDateTime wdt = new wxDateTime();
            wdt.Set((ushort)dt.Day, dt.Month-1, dt.Year, (ushort)dt.Hour, 
                    (ushort)dt.Minute, (ushort)dt.Second, 
                    (ushort)dt.Millisecond);
            return wdt;
        }
+/
        //-----------------------------------------------------------------------------
    }
