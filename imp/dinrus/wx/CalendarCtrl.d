module wx.CalendarCtrl;
public import wx.common;
public import wx.wxDateTime;
public import wx.Colour;
public import wx.Font;
public import wx.Control;
public import wx.CommandEvent;

    public enum CalendarHitTestResult
    {
        wxCAL_HITTEST_NOWHERE,
        wxCAL_HITTEST_HEADER,
        wxCAL_HITTEST_DAY,
        wxCAL_HITTEST_INCMONTH,
        wxCAL_HITTEST_DECMONTH,
        wxCAL_HITTEST_SURROUNDING_WEEK
    }

    public enum CalendarDateBorder
    {
        wxCAL_BORDER_NONE,
        wxCAL_BORDER_SQUARE,
        wxCAL_BORDER_ROUND
    }

		//! \cond EXTERN
        static extern (C) IntPtr wxCalendarCtrl_ctor();
        static extern (C) bool   wxCalendarCtrl_Create(IntPtr self, IntPtr parent, int id, IntPtr date, inout Point pos, inout Size size, uint style, string name);
        static extern (C) bool   wxCalendarCtrl_SetDate(IntPtr self, IntPtr date);
        static extern (C) IntPtr wxCalendarCtrl_GetDate(IntPtr self);
        static extern (C) bool   wxCalendarCtrl_SetLowerDateLimit(IntPtr self, IntPtr date);
        static extern (C) IntPtr wxCalendarCtrl_GetLowerDateLimit(IntPtr self);
        static extern (C) bool   wxCalendarCtrl_SetUpperDateLimit(IntPtr self, IntPtr date);
        static extern (C) IntPtr wxCalendarCtrl_GetUpperDateLimit(IntPtr self);
        static extern (C) bool   wxCalendarCtrl_SetDateRange(IntPtr self, IntPtr lowerdate, IntPtr upperdate);
        static extern (C) void   wxCalendarCtrl_EnableYearChange(IntPtr self, bool enable);
        static extern (C) void   wxCalendarCtrl_EnableMonthChange(IntPtr self, bool enable);
        static extern (C) void   wxCalendarCtrl_EnableHolidayDisplay(IntPtr self, bool display);
        static extern (C) void   wxCalendarCtrl_SetHeaderColours(IntPtr self, IntPtr colFg, IntPtr colBg);
        static extern (C) IntPtr wxCalendarCtrl_GetHeaderColourFg(IntPtr self);
        static extern (C) IntPtr wxCalendarCtrl_GetHeaderColourBg(IntPtr self);
        static extern (C) void   wxCalendarCtrl_SetHighlightColours(IntPtr self, IntPtr colFg, IntPtr colBg);
        static extern (C) IntPtr wxCalendarCtrl_GetHighlightColourFg(IntPtr self);
        static extern (C) IntPtr wxCalendarCtrl_GetHighlightColourBg(IntPtr self);
        static extern (C) void   wxCalendarCtrl_SetHolidayColours(IntPtr self, IntPtr colFg, IntPtr colBg);
        static extern (C) IntPtr wxCalendarCtrl_GetHolidayColourFg(IntPtr self);
        static extern (C) IntPtr wxCalendarCtrl_GetHolidayColourBg(IntPtr self);
        static extern (C) IntPtr wxCalendarCtrl_GetAttr(IntPtr self, int day);
        static extern (C) void   wxCalendarCtrl_SetAttr(IntPtr self, int day, IntPtr attr);
        static extern (C) void   wxCalendarCtrl_SetHoliday(IntPtr self, int day);
        static extern (C) void   wxCalendarCtrl_ResetAttr(IntPtr self, int day);
        static extern (C) int    wxCalendarCtrl_HitTest(IntPtr self, inout Point pos, IntPtr date, inout DayOfWeek wd);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias CalendarCtrl wxCalendarCtrl;
    public class CalendarCtrl : Control
    {
        enum
        {
            // show Sunday as the first day of the week (default)
            wxCAL_SUNDAY_FIRST               = 0x0000,

            // show Monday as the first day of the week
            wxCAL_MONDAY_FIRST               = 0x0001,

            // highlight holidays
            wxCAL_SHOW_HOLIDAYS              = 0x0002,

            // disable the year change control, show only the month change one
            wxCAL_NO_YEAR_CHANGE             = 0x0004,

            // don't allow changing neither month nor year (implies
            // wxCAL_NO_YEAR_CHANGE)
            wxCAL_NO_MONTH_CHANGE            = 0x000c,

            // use MS-style month-selection instead of combo-spin combination
            wxCAL_SEQUENTIAL_MONTH_SELECTION = 0x0010,

            // show the neighbouring weeks in the previous and next month
            wxCAL_SHOW_SURROUNDING_WEEKS     = 0x0020
        }

	public const string wxCalendarNameStr  = "CalendarCtrl";
        //-----------------------------------------------------------------------------

        public this(IntPtr wxobj);
        public this();
        public this(Window parent, int id, wxDateTime date = null /*wxDefaultDateTime*/, Point pos = wxDefaultPosition, Size size =wxDefaultSize , int style = wxCAL_SHOW_HOLIDAYS | wxWANTS_CHARS, string name = wxCalendarNameStr);
	//-----------------------------------------------------------------------------
	// ctors with self created id

        public this(Window parent, DateTime date = null, Point pos = wxDefaultPosition, Size size =wxDefaultSize , int style = wxCAL_SHOW_HOLIDAYS | wxWANTS_CHARS, string name = wxCalendarNameStr);
	//-----------------------------------------------------------------------------

        public bool Create(Window parent, int id, wxDateTime date, inout Point pos, inout Size size, int style, string name);
        //-----------------------------------------------------------------------------

        public void Date(DateTime value);
        public DateTime Date() ;
        public void LowerDateLimit(DateTime value) ;
        public DateTime LowerDateLimit();

        public void UpperDateLimit(DateTime value);
        public DateTime UpperDateLimit() ;
        public bool SetDateRange(DateTime lowerdate, DateTime upperdate);
        public void EnableYearChange(bool value);
        public void EnableMonthChange(bool value);
        public void EnableHolidayDisplay(bool value);
        public void SetHeaderColours(Colour colFg, Colour colBg);
        public Colour HeaderColourFg() ;
        public Colour HeaderColourBg() ;
        public void SetHighlightColours(Colour colFg, Colour colBg);
        public Colour HighlightColourFg();
        public Colour HighlightColourBg() ;
        public void SetHolidayColours(Colour colFg, Colour colBg);
        public Colour HolidayColourFg();
        public Colour HolidayColourBg();
        public CalendarDateAttr GetAttr(int day);
        public void SetAttr(int day, CalendarDateAttr attr);
        public void SetHoliday(int day);
        public void ResetAttr(int day);
        public CalendarHitTestResult HitTest(Point pos, inout DateTime date, inout DayOfWeek wd);
		public void SelectionChange_Add(EventListener value) ;
		public void SelectionChange_Remove(EventListener value);
		public void DayChange_Add(EventListener value) ;
		public void DayChange_Remove(EventListener value) ;
		public void MonthChange_Add(EventListener value) ;
		public void MonthChange_Remove(EventListener value) ;
		public void YearChange_Add(EventListener value) ;
		public void YearChange_Remove(EventListener value);
		public void DoubleClick_Add(EventListener value) ;
		public void DoubleClick_Remove(EventListener value);
		public void WeekdayClick_Add(EventListener value);
		public void WeekdayClick_Remove(EventListener value) ;
    }

		//! \cond EXTERN
        static extern (C) IntPtr wxCalendarDateAttr_ctor();
        static extern (C) IntPtr wxCalendarDateAttr_ctor2(IntPtr colText, IntPtr colBack, IntPtr colBorder, IntPtr font, CalendarDateBorder border);
        static extern (C) IntPtr wxCalendarDateAttr_ctor3(CalendarDateBorder border, IntPtr colBorder);
	static extern (C) void   wxCalendarDateAttr_dtor(IntPtr self);
	static extern (C) void   wxCalendarDateAttr_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
        static extern (C) void   wxCalendarDateAttr_SetTextColour(IntPtr self, IntPtr colText);
        static extern (C) void   wxCalendarDateAttr_SetBackgroundColour(IntPtr self, IntPtr colBack);
        static extern (C) void   wxCalendarDateAttr_SetBorderColour(IntPtr self, IntPtr col);
        static extern (C) void   wxCalendarDateAttr_SetFont(IntPtr self, IntPtr font);
        static extern (C) void   wxCalendarDateAttr_SetBorder(IntPtr self, int border);
        static extern (C) void   wxCalendarDateAttr_SetHoliday(IntPtr self, bool holiday);
        static extern (C) bool   wxCalendarDateAttr_HasTextColour(IntPtr self);
        static extern (C) bool   wxCalendarDateAttr_HasBackgroundColour(IntPtr self);
        static extern (C) bool   wxCalendarDateAttr_HasBorderColour(IntPtr self);
        static extern (C) bool   wxCalendarDateAttr_HasFont(IntPtr self);
        static extern (C) bool   wxCalendarDateAttr_HasBorder(IntPtr self);
        static extern (C) bool   wxCalendarDateAttr_IsHoliday(IntPtr self);
        static extern (C) IntPtr wxCalendarDateAttr_GetTextColour(IntPtr self);
        static extern (C) IntPtr wxCalendarDateAttr_GetBackgroundColour(IntPtr self);
        static extern (C) IntPtr wxCalendarDateAttr_GetBorderColour(IntPtr self);
        static extern (C) IntPtr wxCalendarDateAttr_GetFont(IntPtr self);
        static extern (C) int    wxCalendarDateAttr_GetBorder(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias CalendarDateAttr wxCalendarDateAttr;
    public class CalendarDateAttr : wxObject
    {
        public this(IntPtr wxobj);
    	private this(IntPtr wxobj, bool memOwn);
        public this();
        public this(Colour colText, Colour colBack = Colour.wxNullColour, Colour colBorder = Colour.wxNullColour, Font font = Font.wxNullFont, CalendarDateBorder border = CalendarDateBorder.wxCAL_BORDER_NONE);
        public  this(CalendarDateBorder border, Colour colBorder);
    	override protected void dtor() ;
        public void TextColour(Colour value);
        public Colour TextColour() ;
        public void BackgroundColour(Colour value) { wxCalendarDateAttr_SetBackgroundColour(wxobj, wxObject.SafePtr(value)); }
        public Colour BackgroundColour();
        public void BorderColour(Colour value);
        public Colour BorderColour() ;
        public void font(Font value) ;
        public Font font();
        public void Border(CalendarDateBorder value) ;
        public CalendarDateBorder Border() ;
        public void IsHoliday(bool value) ;
        public bool IsHoliday() ;
        public bool HasTextColour();
        public bool HasBackgroundColour();
        public bool HasBorderColour() ;
        public bool HasFont();
        public bool HasBorder() ;
	public static wxObject New(IntPtr ptr);
    }

		//! \cond EXTERN
        static extern (C) IntPtr wxCalendarEvent_ctor();
        static extern (C) IntPtr wxCalendarEvent_ctor2(IntPtr cal, int type);
        static extern (C) IntPtr wxCalendarEvent_GetDate(IntPtr self);
        static extern (C) int    wxCalendarEvent_GetWeekDay(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias CalendarEvent wxCalendarEvent;
    public class CalendarEvent : CommandEvent
    {
	public this(IntPtr wxobj);
        public this();
        public this(CalendarCtrl cal, EventType type);
        public DateTime Date() ;
        public DayOfWeek WeekDay() ;
		private static Event New(IntPtr obj) ;
		    static this()
    {
        wxEVT_CALENDAR_SEL_CHANGED = wxEvent_EVT_CALENDAR_SEL_CHANGED();
        wxEVT_CALENDAR_DAY_CHANGED = wxEvent_EVT_CALENDAR_DAY_CHANGED();
        wxEVT_CALENDAR_MONTH_CHANGED = wxEvent_EVT_CALENDAR_MONTH_CHANGED();
        wxEVT_CALENDAR_YEAR_CHANGED = wxEvent_EVT_CALENDAR_YEAR_CHANGED();
        wxEVT_CALENDAR_DOUBLECLICKED = wxEvent_EVT_CALENDAR_DOUBLECLICKED();
        wxEVT_CALENDAR_WEEKDAY_CLICKED = wxEvent_EVT_CALENDAR_WEEKDAY_CLICKED();

        AddEventType(wxEVT_CALENDAR_SEL_CHANGED,            &CalendarEvent.New);
        AddEventType(wxEVT_CALENDAR_DAY_CHANGED,            &CalendarEvent.New);
        AddEventType(wxEVT_CALENDAR_MONTH_CHANGED,          &CalendarEvent.New);
        AddEventType(wxEVT_CALENDAR_YEAR_CHANGED,           &CalendarEvent.New);
        AddEventType(wxEVT_CALENDAR_DOUBLECLICKED,          &CalendarEvent.New);
        AddEventType(wxEVT_CALENDAR_WEEKDAY_CLICKED,        &CalendarEvent.New);
    }
    }

