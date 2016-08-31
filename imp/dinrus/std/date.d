module std.date;

private import stdrus;

alias long d_time;
alias d_time д_время;
const d_time d_time_nan = long.min;
alias d_time_nan д_время_нч;
alias stdrus.Дата Date;

enum
{
	HoursPerDay    = 24,
	MinutesPerHour = 60,
	msPerMinute    = 60 * 1000,
	msPerHour      = 60 * msPerMinute,
	msPerDay       = 86400000,
	TicksPerMs     = 1,
	TicksPerSecond = 1000,			/// Will be at least 1000
	TicksPerMinute = TicksPerSecond * 60,
	TicksPerHour   = TicksPerMinute * 60,
	TicksPerDay    = TicksPerHour   * 24,
}

d_time LocalTZA = 0;


const char[] daystr = "SunMonTueWedThuFriSatВсПнВтСрЧтПтСб";
alias daystr стрдней;
const char[] monstr = "JanFebMarAprMayJunJulAugSepOctNovDec";

const int[12] mdays = [ 0,31,59,90,120,151,181,212,243,273,304,334 ];


alias  stdrus.вГодНедИСО8601 toISO8601YearWeek;	
alias  stdrus.високосныйГод LeapYear;
alias  stdrus.деньИзГода DayFromYear;
//alias  stdrus.времяИзГода ;
alias  stdrus.годИзВрем YearFromTime;		
//alias  stdrus.високосный_ли  ;
alias  stdrus.месяцИзВрем MonthFromTime;
alias  stdrus.датаИзВрем DateFromTime;
alias  stdrus.нокругли floor;
alias  stdrus.дмод dmod;
//alias  stdrus.часИзВрем ;
//alias  stdrus.минИзВрем ;	
//alias  stdrus.секИзВрем ;	
//alias  stdrus.мсекИзВрем ;
//alias  stdrus.времениВДне ;
alias  stdrus.ДеньНедели WeekDay;
alias  stdrus.МВ8Местное UTCtoLocalTime;
alias  stdrus.местное8МВ LocalTimetoUTC;
alias  stdrus.сделайВремя MakeTime;
alias  stdrus.сделайДень MakeDay;
alias  stdrus.сделайДату MakeDate;
//d_time TimeClip(d_time время)
alias  stdrus.датаОтДняНеделиМесяца DateFromNthWeekdayOfMonth;
alias  stdrus.днейВМесяце DaysInMonth;
//alias  stdrus.вТкст(т_время время){return std.date.toString(время);}
alias  stdrus.вТкстМВ toUTCString;
alias  stdrus.вТкстДаты toDateString;
alias  stdrus.вТкстВремени toTimeString;
alias  stdrus.разборВремени parse;
alias  stdrus.дайВремяМВ getUTCtime;
alias  stdrus.ФВРЕМЯ8т_время FILETIME2d_time;
alias  stdrus.СИСТВРЕМЯ8т_время SYSTEMTIME2d_time;
//alias  stdrus.дайМестнуюЗЧП дайЛокTZA;
alias  stdrus.дневноеСохранениеЧО DaylightSavingTA;
alias  stdrus.вДвремя toDtime;
alias  stdrus.вФВремяДос toDosFileTime;