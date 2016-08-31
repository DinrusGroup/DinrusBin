/**
 * Contains classes that define culture-related information.
 *
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module os.win.loc.core;

import os.win.base.core,
  os.win.base.native,
  os.win.loc.consts;
import os.win.loc.time : Calendar,
  CalendarData,
  GregorianCalendar, 
  JapaneseCalendar,
  TaiwanCalendar,
  KoreanCalendar,
  ThaiBuddhistCalendar;
import std.utf : toUTF8;
import std.string : icmp, tolower, toupper, wcslen;
import std.c : sprintf;
import std.c : memcmp, memicmp;
version(D_Version2) {
  import std.string : indexOf, lastIndexOf;
  alias indexOf find;
  alias lastIndexOf rfind;
}
else {
  import std.string : find, rfind;
}

debug import std.io : writefln;

extern(C) int swscanf(in wchar*, in wchar*, ...);

private uint[string] nameToLcidMap;
private string[uint] lcidToNameMap;
private uint[string] regionNameToLcidMap;

static ~this() {
  nameToLcidMap = null;
  lcidToNameMap = null;
  regionNameToLcidMap = null;
}

/*/*package*/ wchar* toUTF16zNls(string s, int offset, int length, out int translated);

/*package*/ string toUTF8Nls(in wchar* pChars, int cch, out int translated) ;

/*package*/ string getLocaleInfo(uint locale, uint field, bool userOverride = true) ;

/*package*/ int getLocaleInfoI(uint locale, uint field, bool userOverride = true);

/*package*/ string getCalendarInfo(uint locale, uint calendar, uint field, bool userOverride = true) ;

/*package*/ string getGeoInfo(uint geoId, uint geoType) ;
private void ensureNameMapping() ;

  bool enumSystemLocales(out uint[] locales) ;
  
  string getLocaleName(uint locale);

  bool enumSystemLocales(out uint[] locales);
  
/*package*/ bool findCultureByName(string cultureName, out string actualName, out uint culture) ;

/*package*/ bool findCultureById(uint culture, out string cultureName, out uint actualCulture);
  
/*package*/ bool findCultureFromRegionName(string regionName, out uint culture) ;
  private void ensureRegionMapping(); 

private bool isNeutralCulture(uint culture) ;
/**
 * Retrieves an object that controls formatting.
 */
interface IFormatProvider {

  /**
   * Gets an object that provides formatting services for the specified type.
   * Параметры: formatType = An object that identifies the type of format to get.
   * Возвращает: The current instance if formatType is the same type as the current instance; otherwise, null.
   */
  Object getFormat(TypeInfo formatType);

}

/**
 * Provides information about a specific culture (locale).
 */
class Culture : IFormatProvider {

  private static Culture[string] nameCultures_;
  private static Culture[uint] lcidCultures_;

  private static Culture userDefault_;
  private static Culture userDefaultUI_;
  private static Culture constant_;
  private static Culture current_;
  private static Culture currentUI_;

  private uint cultureId_;
  private string cultureName_;

  /*package*/ bool isReadOnly_;
  /*package*/ bool isInherited_;
  private string listSeparator_;

  private Culture parent_;

  private NumberFormat numberFormat_;
  private DateTimeFormat dateTimeFormat_;
  private Calendar calendar_;
  private CalendarData[] calendars_;
  private Collator collator_;

  static this() {
    constant_ = new Culture(LOCALE_INVARIANT);
    constant_.isReadOnly_ = true;

    userDefault_ = initUserDefault();
    userDefaultUI_ = initUserDefaultUI();
  }

  static ~this() {
    userDefault_ = null;
    userDefaultUI_ = null;
    constant_ = null;
    current_ = null;
    currentUI_ = null;
    nameCultures_ = null;
    lcidCultures_ = null;
  }

  /** 
   * Initializes a new instance based on the _culture specified by the _culture identifier.
   * Параметры: culture = A predefined Culture identifier.
   */
  this(uint culture);
  /**
   * Initializes a new instance based on the culture specified by name.
   * Параметры: name = A predefined culture _name.
   */
  this(string name);

  /**
   * Gets an object that defines how to format the specified type.
   * Параметры: formatType = The type to get a formatting object for. Supports NumberFormat and DateTimeFormat.
   * Возвращает: The value of the numberFormat property or the value of the dateTimeFormat property, depending on formatType.
   */
  Object getFormat(TypeInfo formatType);

  /**
   * Retrieves a cached, read-only instance of a _culture using the specified _culture identifier.
   * Параметры: culture = A _culture identifier.
   * Возвращает: A read-only Culture object.
   */
  static Culture get(uint culture) ;

  /**
   * Retrieves a cached, read-only instance of a culture using the specified culture _name.
   * Параметры: name = The _name of the culture.
   * Возвращает: A read-only Culture object.
   */
  static Culture get(string name) ;
  
  private static Culture getCultureWorker(uint lcid, string name);

  /**
   * Gets the list of supported cultures filtered by the specified CultureTypes parameter.
   * Параметры: types = A bitwise combination of CultureTypes values.
   * Возвращает: An array of type Culture.
   */
  static Culture[] getCultures(CultureTypes types) ;

  /**
   * Gets the Culture that is culture-independent.
   * Возвращает: The Culture that is culture-independent.
   */
  static Culture constant();
  /**
   * Gets or sets the Culture that represents the culture used by the _current thread.
   * Возвращает: The Culture that represents the culture used by the _current thread.
   */
  static void current(Culture value) ;
  /**
   * ditto
   */
  static Culture current() ;

  /**
   * Gets or sets the Culture that represents the current culture used to look up resources.
   * Возвращает: The Culture that represents the current culture used to look up resources.
   */
  static void currentUI(Culture value) ;
  /** 
   * ditto
   */
  static Culture currentUI() ;

  /**
   * Gets the Culture that represents the _parent culture of the current instance.
   * Возвращает: The Culture that represents the _parent culture.
   */
  Culture parent();

  /**
   * Gets the culture identifier of the current instance.
   * Возвращает: The culture identifier.
   */
  uint lcid() ;
  /**
   * Gets the culture _name in the format "&lt;language&gt;-&lt;region&gt;".
   * Возвращает: The culture _name.
   */
  string name() ;

  /**
   * Gets the culture name in the format "&lt;language&gt; (&lt;region&gt;)" in the language of the culture.
   * Возвращает: The culture name in the language of the culture.
   */
  string nativeName() ;

  /**
   * Gets the culture name in the format "&lt;language&gt; (&lt;region&gt;)" in English.
   * Возвращает: The culture name in English.
   */
  string englishName() ;

  /**
   * Gets the culture name in the format "&lt;language&gt; (&lt;region&gt;)" in the localised version of Windows.
   * Возвращает: The culture name in the localised version of Windows.
   */
  string displayName() ;

  /**
   * Gets or sets the string that separates items in a list.
   * Параметры: value = The string that separates items in a list.
   */
  void listSeparator(string value);
  /// ditto
  string listSeparator() ;

  /**
   * Gets a value indictating whether the current instance represents a neutral culture.
   * Возвращает: true if the current instance represents a neutral culture; otherwise, false.
   */
  bool isNeutral() ;

  /**
   * Gets a value indicating whether the current instance is read-only.
   * Возвращает: true if the current instance is read-only; otherwise, false.
   */
  final bool isReadOnly() ;

  /**
   * Gets the culture _types that pertain to the current instance.
   * Возвращает: A bitwise combination of CultureTypes values.
   */
  CultureTypes types() ;

  /**
   * $(I Property.) Gets or sets a NumberFormat that defines the culturally appropriate format of displaying numbers and currency.
   */
  void numberFormat(NumberFormat value);
  /// ditto
  NumberFormat numberFormat();

  /**
   *$(I Property.) Gets or sets a DateTimeFormat that defines the culturally appropriate format of displaying dates and times.
   */
  void dateTimeFormat(DateTimeFormat value) ;

  /**
   * Gets the default _calendar used by the culture.
   * Возвращает: A Calendar that represents the default _calendar used by a culture.
   */
  Calendar calendar() ;
  
  Calendar[] optionalCalendars();

  /**
   * Gets the Collator that defines how to compare strings for the culture.
   * Возвращает: The Collator that defines how to compare strings for the culture.
   */
  Collator collator() ;

  /**
   * Returns a string containing the name of the current instance.
   * Возвращает: A string containing the name of the current instance.
   */
  override string toString() ;

  private static void checkNeutral(Culture culture) ;
  
  private void checkReadOnly() ;

  private static Calendar getCalendar(int calendarId);
  
  private CalendarData calendarData(int calendarId);

  private static Culture initUserDefault() ;

  private static Culture initUserDefaultUI() ;

  private static Culture userDefault() ;
  
  private static Culture userDefaultUI() ;
}

/**
 * Defines how numeric values are formatted and displayed.
 */
class NumberFormat : IFormatProvider {

  private static NumberFormat constant_;
  private static NumberFormat current_;

  /*package*/ bool isReadOnly_;

  private int[] numberGroupSizes_;
  private int[] currencyGroupSizes_;
  private string positiveSign_;
  private string negativeSign_;
  private string numberDecimalSeparator_;
  private string currencyDecimalSeparator_;
  private string numberGroupSeparator_;
  private string currencyGroupSeparator_;
  private string currencySymbol_;
  private string nanSymbol_;
  private string positiveInfinitySymbol_;
  private string negativeInfinitySymbol_;
  private int numberDecimalDigits_;
  private int currencyDecimalDigits_;
  private int currencyPositivePattern_;
  private int numberNegativePattern_;
  private int currencyNegativePattern_;

  static ~this() {
    constant_ = null;
    current_ = null;
  }

  /**
   * Initializes a new instance.
   */
  this() ;

  /**
   */
  Object getFormat(TypeInfo formatType) ;

  /**
   */
  static NumberFormat get(IFormatProvider provider);

  /**
   */
  static NumberFormat constant() ;

  /**
   */
  static NumberFormat current() ;

  /**
   */
  void numberGroupSizes(int[] value) ;

  /**
   * ditto
   */
  int[] numberGroupSizes() ;

  /**
   */
  void currencyGroupSizes(int[] value) ;

  /**
   * ditto
   */
  int[] currencyGroupSizes() ;

  /**
   */
  void positiveSign(string value) ;

  /**
   * ditto
   */
  string positiveSign() ;

  /**
   */
  void negativeSign(string value) ;

  /**
   * ditto
   */
  string negativeSign() ;

  /**
   */
  void numberDecimalSeparator(string value) ;
  /**
   * ditto
   */
  string numberDecimalSeparator() ;

  /**
   */
  void currencyDecimalSeparator(string value) ;

  /**
   * ditto
   */
  string currencyDecimalSeparator() ;
  /**
   */
  void numberGroupSeparator(string value) ;
  /**
   * ditto
   */
  string numberGroupSeparator();

  /**
   */
  void currencyGroupSeparator(string value) ;

  /**
   * ditto
   */
  string currencyGroupSeparator();
  /**
   */
  void currencySymbol(string value);
  /**
   * ditto
   */
  string currencySymbol() ;
  /**
   */
  void nanSymbol(string value) ;

  /**
   * ditto
   */
  string nanSymbol() ;

  /**
   */
  void positiveInfinitySymbol(string value) ;
  /**
   * ditto
   */
  string positiveInfinitySymbol() ;

  /**
   */
  void negativeInfinitySymbol(string value);

  /**
   * ditto
   */
  string negativeInfinitySymbol() ;
  /**
   */
  void numberDecimalDigits(int value) ;
  /**
   * ditto
   */
  int numberDecimalDigits() ;
  /**
   */
  void currencyDecimalDigits(int value) ;
  /**
   * ditto
   */
  int currencyDecimalDigits() ;

  /**
   */
  void currencyPositivePattern(int value) ;

  /**
   * ditto
   */
  int currencyPositivePattern() ;

  /**
   */
  void currencyNegativePattern(int value) ;
  /**
   * ditto
   */
  int currencyNegativePattern() ;

  /**
   */
  void numberNegativePattern(int value) ;

  /**
   * ditto
   */
  int numberNegativePattern() ;
  
  /*package*/ this(uint culture) ;
  
  private void checkReadOnly();

}

/*package*/ const char[] allStandardFormats = [ 'd', 'D', 'f', 'F', 'g', 'G', 'r', 'R', 's', 't', 'T', 'u', 'U', 'y', 'Y' ];

/**
 * Defines how dates and times are formatted and displayed.
 */
class DateTimeFormat : IFormatProvider {

  private static const string RFC1123_PATTERN = "ddd, dd MMM yyyy HH':'mm':'ss 'GMT'";
  private static const string SORTABLE_DATETIME_PATTERN = "yyyy'-'MM'-'dd'T'HH':'mm':'ss";
  private static const string UNIVERSAL_SORTABLE_DATETIME_PATTERN = "yyyy'-'MM'-'dd HH':'mm':'ss'Z'";

  private static DateTimeFormat constant_;
  private static DateTimeFormat current_;

  private uint cultureId_;
  private Calendar calendar_;
  private bool isDefaultCalendar_;
  private int[] optionalCalendars_;
  private string amDesignator_;
  private string pmDesignator_;
  private string dateSeparator_;
  private string timeSeparator_;
  private int firstDayOfWeek_ = -1;
  private int calendarWeekRule_ = -1;
  private string[] dayNames_;
  private string[] abbrevDayNames_;
  private string[] monthNames_;
  private string[] abbrevMonthNames_;
  private string[] eraNames_;
  private string shortDatePattern_;
  private string longDatePattern_;
  private string shortTimePattern_;
  private string longTimePattern_;
  private string yearMonthPattern_;
  private string fullDateTimePattern_;
  private string[] allShortDatePatterns_;
  private string[] allShortTimePatterns_;
  private string[] allLongDatePatterns_;
  private string[] allLongTimePatterns_;
  private string[] allYearMonthPatterns_;
  private string generalShortTimePattern_;
  private string generalLongTimePattern_;

  /*package*/ bool isReadOnly_;

  static ~this() {
    constant_ = null;
    current_ = null;
  }

  /**
   * Initializes a new instance.
   */
  this();

  /**
   */
  Object getFormat(TypeInfo formatType);

  /**
   */
  static DateTimeFormat get(IFormatProvider provider);

  /**
   */
  final string getAbbreviatedDayName(DayOfWeek dayOfWeek) ;
  /**
   */
  final string getDayName(DayOfWeek dayOfWeek) ;

  /**
   */
  final string getMonthName(int month) ;

  /**
   */
  final string getAbbreviatedMonthName(int month) ;

  /**
   */
  final string getEraName(int era) ;
  /**
   */
  final string[] getAllDateTimePatterns() ;

  /**
   */
  final string[] getAllDateTimePatterns(char format);
  /**
   */
  static DateTimeFormat constant() ;

  /**
   */
  static DateTimeFormat current() ;

  /**
   */
  final void calendar(Calendar value) {
    if (value !is calendar_) {
      for (auto i = 0; i < optionalCalendars.length; i++) {
        if (optionalCalendars[i] == value.internalId) {
          isDefaultCalendar_ = (value.internalId == CAL_GREGORIAN);

          if (calendar_ !is null) {
            // Clear current values.
            eraNames_ = null;
            abbrevDayNames_ = null;
            dayNames_ = null;
            abbrevMonthNames_ = null;
            monthNames_ = null;
            shortDatePattern_ = null;
            longDatePattern_ = null;
            yearMonthPattern_ = null;
            fullDateTimePattern_ = null;
            allShortDatePatterns_ = null;
            allLongDatePatterns_ = null;
            allYearMonthPatterns_ = null;
            generalShortTimePattern_ = null;
            generalLongTimePattern_ = null;
            dateSeparator_ = null;
          }

          calendar_ = value;
          //initializeProperties();

          return;
        }
      }
      throw new ArgumentException("Not a valid calendar for the given culture.", "value");
    }
  }

  /**
   * ditto
   */
  final Calendar calendar() {
    return calendar_;
  }

  /**
   */
  final void amDesignator(string value) {
    checkReadOnly();
    amDesignator_ = value;
  }

  /**
   * ditto
   */
  final string amDesignator() {
    if (amDesignator_ == null)
      amDesignator_ = getLocaleInfo(cultureId_, LOCALE_S1159);
    return amDesignator_;
  }

  /**
   */
  final void pmDesignator(string value) {
    checkReadOnly();
    pmDesignator_ = value;
  }

  /**
   * ditto
   */
  final string pmDesignator() {
    if (pmDesignator_ == null)
      pmDesignator_ = getLocaleInfo(cultureId_, LOCALE_S2359);
    return pmDesignator_;
  }

  /**
   */
  final void dateSeparator(string value) {
    checkReadOnly();
    dateSeparator_ = value;
  }

  /**
   * ditto
   */
  final string dateSeparator() {
    if (dateSeparator_ == null)
      dateSeparator_ = getLocaleInfo(cultureId_, LOCALE_SDATE);
    return dateSeparator_;
  }

  /**
   */
  final void timeSeparator(string value) {
    checkReadOnly();
    timeSeparator_ = value;
  }

  /**
   * ditto
   */
  final string timeSeparator() {
    if (timeSeparator_ == null)
      timeSeparator_ = getLocaleInfo(cultureId_, LOCALE_STIME);
    return timeSeparator_;
  }

  /**
   */
  final void firstDayOfWeek(DayOfWeek value) {
    checkReadOnly();
    firstDayOfWeek_ = cast(int)value;
  }
  /**
   * ditto
   */
  final DayOfWeek firstDayOfWeek() {
    if (firstDayOfWeek_ == -1) {
      firstDayOfWeek_ = getLocaleInfoI(cultureId_, LOCALE_IFIRSTDAYOFWEEK);
      // 0 = Monday, 1 = Tuesday ... 6 = Sunday
      if (firstDayOfWeek_ < 6)
        firstDayOfWeek_++;
      else
        firstDayOfWeek_ = 0;
    }
    return cast(DayOfWeek)firstDayOfWeek_;
  }

  /**
   */
  final void calendarWeekRule(CalendarWeekRule value) {
    checkReadOnly();
    calendarWeekRule_ = cast(int)value;
  }
  /**
   * ditto
   */
  final CalendarWeekRule calendarWeekRule() {
    if (calendarWeekRule_ == -1)
      calendarWeekRule_ = getLocaleInfoI(cultureId_, LOCALE_IFIRSTWEEKOFYEAR);
    return cast(CalendarWeekRule)calendarWeekRule_;
  }

  /**
   */
  final string rfc1123Pattern() {
    return RFC1123_PATTERN;
  }

  /**
   */
  final string sortableDateTimePattern() {
    return SORTABLE_DATETIME_PATTERN;
  }

  /**
   */
  final string universalSortableDateTimePattern() {
    return UNIVERSAL_SORTABLE_DATETIME_PATTERN;
  }

  /**
   */
  final void shortDatePattern(string value) {
    checkReadOnly();
    shortDatePattern_ = value;
    generalShortTimePattern_ = null;
    generalLongTimePattern_ = null;
  }

  /**
   * ditto
   */
  final string shortDatePattern() {
    if (shortDatePattern_ == null)
      shortDatePattern_ = getShortDatePattern(calendar_.internalId);
    return shortDatePattern_;
  }

  /**
   */
  final void longDatePattern(string value) {
    checkReadOnly();
    longDatePattern_ = value;
    fullDateTimePattern_ = null;
  }

  /**
   * ditto
   */
  final string longDatePattern() {
    if (longDatePattern_ == null)
      longDatePattern_ = getLongDatePattern(calendar_.internalId);
    return longDatePattern_;
  }

  /**
   */
  final void shortTimePattern(string value) {
    checkReadOnly();
    shortTimePattern_ = value;
    generalShortTimePattern_ = null;
  }

  /**
   * ditto
   */
  final string shortTimePattern() {
    if (shortTimePattern_ == null)
      shortTimePattern_ = getShortTime(cultureId_);
    return shortTimePattern_;
  }

  /**
   */
  final void longTimePattern(string value) {
    checkReadOnly();
    longTimePattern_ = value;
    fullDateTimePattern_ = null;
    generalLongTimePattern_ = null;
  }

  /**
   * ditto
   */
  final string longTimePattern() {
    if (longTimePattern_ == null)
      longTimePattern_ = getLocaleInfo(cultureId_, LOCALE_STIMEFORMAT);
    return longTimePattern_;
  }

  /**
   */
  final void yearMonthPattern(string value) {
    checkReadOnly();
    yearMonthPattern_ = value;
  }

  /**
   * ditto
   */
  final string yearMonthPattern() {
    if (yearMonthPattern_ == null)
      yearMonthPattern_ = getLocaleInfo(cultureId_, LOCALE_SYEARMONTH);
    return yearMonthPattern_;
  }

  /**
   */
  final string fullDateTimePattern() {
    if (fullDateTimePattern_ == null)
      fullDateTimePattern_ = longDatePattern ~ " " ~ longTimePattern;
    return fullDateTimePattern_;
  }

  /*package*/ string generalShortTimePattern() {
    if (generalShortTimePattern_ == null)
      generalShortTimePattern_ = shortDatePattern ~ " " ~ shortTimePattern;
    return generalShortTimePattern_;
  }

  /*package*/ string generalLongTimePattern() {
    if (generalLongTimePattern_ == null)
      generalLongTimePattern_ = shortDatePattern ~ " " ~ longTimePattern;
    return generalLongTimePattern_;
  }

  /**
   */
  final void dayNames(string[] value) {
    checkReadOnly();
    dayNames_ = value;
  }

  /**
   * ditto
   */
  final string[] dayNames() {
    return getDayNames().dup;
  }

  /**
   */
  final void abbreviatedDayNames(string[] value) {
    checkReadOnly();
    abbrevDayNames_ = value;
  }

  /**
   * ditto
   */
  final string[] abbreviatedDayNames() {
    return getAbbreviatedDayNames().dup;
  }

  /**
   */
  final void monthNames(string[] value) {
    checkReadOnly();
    monthNames_ = value;
  }

  /**
   * ditto
   */
  final string[] monthNames() {
    return getMonthNames().dup;
  }

  /**
   */
  final void abbreviatedMonthNames(string[] value) {
    checkReadOnly();
    abbrevMonthNames_ = value;
  }

  final string[] abbreviatedMonthNames() {
    return getAbbreviatedMonthNames().dup;
  }

  /*package*/ this(uint culture, Calendar cal) {
    cultureId_ = culture;
    calendar = cal;
  }

  private void checkReadOnly() {
    if (isReadOnly_)
      throw new InvalidOperationException("The instance is read-only.");
  }

  /*private void initializeProperties() {
    amDesignator_ = getLocaleInfo(cultureId_, LOCALE_S1159);
    pmDesignator_ = getLocaleInfo(cultureId_, LOCALE_S2359);

    firstDayOfWeek_ = getLocaleInfoI(cultureId_, LOCALE_IFIRSTDAYOFWEEK);
    // 0 = Monday, 1 = Tuesday ... 6 = Sunday
    if (firstDayOfWeek_ < 6)
      firstDayOfWeek_++;
    else
      firstDayOfWeek_ = 0;

    calendarWeekRule_ = getLocaleInfoI(cultureId_, LOCALE_IFIRSTWEEKOFYEAR);

    shortDatePattern_ = getShortDatePattern(calendar_.internalId);
    longDatePattern_ = getLongDatePattern(calendar_.internalId);
    longTimePattern_ = getLocaleInfo(cultureId_, LOCALE_STIMEFORMAT);
    yearMonthPattern_ = getLocaleInfo(cultureId_, LOCALE_SYEARMONTH);
  }*/

  private string[] allShortDatePatterns() {
    if (allShortDatePatterns_ == null) {
      if (!isDefaultCalendar_)
        allShortDatePatterns_ = [ getShortDatePattern(calendar_.internalId) ];
      if (allShortDatePatterns_ == null)
        allShortDatePatterns_ = getShortDates(cultureId_, calendar_.internalId);
    }
    return allShortDatePatterns_.dup;
  }

  private string[] allLongDatePatterns() {
    if (allLongDatePatterns_ == null) {
      if (!isDefaultCalendar_)
        allLongDatePatterns_ = [ getLongDatePattern(calendar_.internalId) ];
      if (allLongDatePatterns_ == null)
        allLongDatePatterns_ = getLongDates(cultureId_, calendar_.internalId);
    }
    return allLongDatePatterns_.dup;
  }

  private string[] allShortTimePatterns() {
    if (allShortTimePatterns_ == null)
      allShortTimePatterns_ = getShortTimes(cultureId_);
    return allShortTimePatterns_.dup;
  }

  private string[] allLongTimePatterns() {
    if (allLongTimePatterns_ == null)
      allLongTimePatterns_ = getLongTimes(cultureId_);
    return allLongTimePatterns_.dup;
  }

  private string[] allYearMonthPatterns() {
    if (allYearMonthPatterns_ == null) {
      if (!isDefaultCalendar_)
        allYearMonthPatterns_ = [ getCalendarInfo(cultureId_, calendar_.internalId, CAL_SYEARMONTH) ];
      if (allYearMonthPatterns_ == null)
        allYearMonthPatterns_ = [ getLocaleInfo(cultureId_, LOCALE_SYEARMONTH) ];
    }
    return allYearMonthPatterns_.dup;
  }

  private static bool enumDateFormats(uint culture, uint calendar, uint flags, out string[] formats) {
    static string[] temp;
    static uint cal;

    extern(Windows)
    static int enumDateFormatsProc(wchar* lpDateFormatString, uint CalendarID) {
      if (cal == CalendarID)
        temp ~= toUTF8(lpDateFormatString[0 .. std.c.wcslen(lpDateFormatString)]);
      return true;
    }

    temp = null;
    cal = calendar;
    if (!EnumDateFormatsEx(&enumDateFormatsProc, culture, flags))
      return false;

    formats = temp.dup;
    return true;
  }

  private static string[] getShortDates(uint culture, uint calendar) {
    string[] formats;
    synchronized {
      if (!enumDateFormats(culture, calendar, DATE_SHORTDATE, formats))
        return null;
    }
    if (formats == null)
      formats = [ getCalendarInfo(culture, calendar, CAL_SSHORTDATE) ];
    return formats;
  }

  private string getShortDatePattern(uint cal) {
    if (!isDefaultCalendar_)
      return getShortDates(cultureId_, cal)[0];
    return getLocaleInfo(cultureId_, LOCALE_SSHORTDATE);
  }

  private static string getShortTime(uint culture) {
    // There is no LOCALE_SSHORTTIME, so we simulate one based on the long time pattern.
    string s = getLocaleInfo(culture, LOCALE_STIMEFORMAT);
    int i = s.rfind(getLocaleInfo(culture, LOCALE_STIME));
    if (i != -1)
      s.length = i;
    return s;
  }

  private static string[] getLongDates(uint culture, uint calendar) {
    string[] formats;
    synchronized {
      if (!enumDateFormats(culture, calendar, DATE_LONGDATE, formats))
        return null;
    }
    if (formats == null)
      formats = [ getCalendarInfo(culture, calendar, CAL_SLONGDATE) ];
    return formats;
  }

  private string getLongDatePattern(uint cal) {
    if (!isDefaultCalendar_)
      return getLongDates(cultureId_, cal)[0];
    return getLocaleInfo(cultureId_, LOCALE_SLONGDATE);
  }

  private static bool enumTimeFormats(uint culture, uint flags, out string[] formats) {
    static string[] temp;

    extern(Windows)
    static int enumTimeFormatsProc(wchar* lpTimeFormatString) {
      temp ~= toUTF8(lpTimeFormatString[0 .. std.c.wcslen(lpTimeFormatString)]);
      return true;
    }

    temp = null;
    if (!EnumTimeFormats(&enumTimeFormatsProc, culture, flags))
      return false;

    formats = temp.dup;
    return true;
  }

  private static string[] getShortTimes(uint culture) {
    string[] formats;

    synchronized {
      if (!enumTimeFormats(culture, 0, formats))
        return null;
    }

    foreach (ref s; formats) {
      int i = s.rfind(getLocaleInfo(culture, LOCALE_STIME));
      int j = -1;
      if (i != -1)
        j = s.rfind(' ');
      if (i != -1 && j != -1) {
        string temp = s[0 .. j];
        temp ~= s[j .. $];
        s = temp;
      }
      else if (i != -1)
        s.length = i;
    }

    return formats;
  }

  private static string[] getLongTimes(uint culture) {
    string[] formats;
    synchronized {
      if (!enumTimeFormats(culture, 0, formats))
        return null;
    }
    return formats;
  }

  private string[] getDayNames() {
    if (dayNames_ == null) {
      dayNames_.length = 7;
      for (uint i = LOCALE_SDAYNAME1; i <= LOCALE_SDAYNAME7; i++) {
        uint j = (i != LOCALE_SDAYNAME7) ? i - LOCALE_SDAYNAME1 + 1 : 0;
        dayNames_[j] = getLocaleInfo(cultureId_, i);
      }
    }
    return dayNames_;
  }

  private string[] getAbbreviatedDayNames() {
    if (abbrevDayNames_ == null) {
      abbrevDayNames_.length = 7;
      for (uint i = LOCALE_SABBREVDAYNAME1; i <= LOCALE_SABBREVDAYNAME7; i++) {
        uint j = (i != LOCALE_SABBREVDAYNAME7) ? i - LOCALE_SABBREVDAYNAME1 + 1 : 0;
        abbrevDayNames_[j] = getLocaleInfo(cultureId_, i);
      }
    }
    return abbrevDayNames_;
  }

  private string[] getMonthNames() {
    if (monthNames_ == null) {
      monthNames_.length = 13;
      for (uint i = LOCALE_SMONTHNAME1; i <= LOCALE_SMONTHNAME12; i++) {
        monthNames_[i - LOCALE_SMONTHNAME1] = getLocaleInfo(cultureId_, i);
      }
    }
    return monthNames_;
  }

  private string[] getAbbreviatedMonthNames() {
    if (abbrevMonthNames_ == null) {
      abbrevMonthNames_.length = 13;
      for (uint i = LOCALE_SABBREVMONTHNAME1; i <= LOCALE_SABBREVMONTHNAME12; i++) {
        abbrevMonthNames_[i - LOCALE_SABBREVMONTHNAME1] = getLocaleInfo(cultureId_, i);
      }
    }
    return abbrevMonthNames_;
  }

  /*private static bool enumCalendarInfo(uint culture, uint calendar, uint calType, out string[] result) {
    static string[] temp;

    extern(Windows)
    static int enumCalendarsProc(wchar* lpCalendarInfoString, uint Calendar) {
      temp ~= toUTF8(lpCalendarInfoString[0 .. wcslen(lpCalendarInfoString)]);
      return 1;
    }

    temp = null;
    if (!EnumCalendarInfoEx(&enumCalendarsProc, culture, calendar, calType))
      return false;
    result = temp.reverse;
    return true;
  }*/

  private string[] getEraNames() {
    if (eraNames_ == null) {
      eraNames_ = Culture.get(cultureId_).calendarData(calendar.internalId).eraNames;
      //enumCalendarInfo(cultureId_, calendar.internalId, CAL_SERASTRING, eraNames_);
    }
    return eraNames_;
  }

  private int[] optionalCalendars() {
    if (optionalCalendars_ == null)
      optionalCalendars_ = getOptionalCalendars(cultureId_);
    return optionalCalendars_;
  }

  private static bool enumCalendarInfo(uint culture, uint calendar, uint calType, out int[] result) {
    static int[] temp;

    extern(Windows)
    static int enumCalendarsProc(wchar* lpCalendarInfoString, uint Calendar) {
      temp ~= Calendar;
      return 1;
    }

    temp = null;
    if (!EnumCalendarInfoEx(&enumCalendarsProc, culture, calendar, calType))
      return false;
    result = temp.dup;
    return true;
  }

  private static int[] getOptionalCalendars(uint culture) {
    int[] cals;
    synchronized {
      if (!enumCalendarInfo(culture, ENUM_ALL_CALENDARS, CAL_ICALINTVALUE, cals))
        return null;
    }
    return cals;
  }

}

/**
 * Implements methods for culture-sensitive string comparisons.
 */
class Collator {

  private static Collator[uint] cache_;

  private uint cultureId_;
  private uint sortingId_;
  private string name_;

  static ~this() {
    cache_ = null;
  }

  private this(uint culture) {
    cultureId_ = culture;
    sortingId_ = getSortingId(culture);
  }

  private uint getSortingId(uint culture) {
    uint sortId = (culture >> 16) & 0xF;
    return (sortId == 0) ? culture : (culture | (sortId << 16));
  }

  /**
   */
  static Collator get(uint culture) {
    synchronized {
      if (auto value = culture in cache_)
        return *value;

      return cache_[culture] = new Collator(culture);
    }
  }

  /**
   */
  static Collator get(string name) {
    Culture culture = Culture.get(name);
    Collator collator = get(culture.lcid);
    collator.name_ = culture.name;
    return collator;
  }

  /**
   */
  int compare(string string1, int offset1, int length1, string string2, int offset2, int length2, CompareOptions options = CompareOptions.None) {
    if (string1 == null) {
      if (string2 == null)
        return 0;
      return -1;
    }
    if (string2 == null)
      return 1;

    //if ((options & CompareOptions.Ordinal) != 0 || (options & CompareOptions.OrdinalIgnoreCase) != 0)
    //  return compareStringOrdinal(string1, offset1, length1, string2, offset2, length2, (options & CompareOptions.OrdinalIgnoreCase) != 0);

    return compareString(sortingId_, string1, offset1, length1, string2, offset2, length2, getCompareFlags(options));
  }

  /// ditto
  int compare(string string1, int offset1, string string2, int offset2, CompareOptions options = CompareOptions.None) {
    return compare(string1, offset1, string1.length - offset1, string2, offset2, string2.length - offset2, options);
  }

  /// ditto
  int compare(string string1, string string2, CompareOptions options = CompareOptions.None) {
    if (string1 == null) {
      if (string2 == null)
        return 0;
      return -1;
    }
    if (string2 == null)
      return 1;

    //if ((options & CompareOptions.Ordinal) != 0 || (options & CompareOptions.OrdinalIgnoreCase) != 0)
    //  return compareStringOrdinal(string1, 0, string1.length, string2, 0, string2.length, (options & CompareOptions.OrdinalIgnoreCase) != 0);

    return compareString(sortingId_, string1, 0, string1.length, string2, 0, string2.length, getCompareFlags(options));
  }

  /**
   */
  int indexOf(string source, string value, int index, int count, CompareOptions options = CompareOptions.None) {
    uint flags = getCompareFlags(options);

    int n = findString(sortingId_, flags | FIND_FROMSTART, source, index, count, value, value.length);
    if (n > -1)
      return n + index;
    if (n == -1)
      return n;

    for (uint i = 0; i < count; i++) {
      if (isPrefix(source, index + i, count - i, value, flags))
        return index + i;
    }
    return -1;
  }

  /// ditto
  int indexOf(string source, string value, int index, CompareOptions options = CompareOptions.None) {
    return indexOf(source, value, index, source.length - index, options);
  }

  /// ditto
  int indexOf(string source, string value, CompareOptions options = CompareOptions.None) {
    return indexOf(source, value, 0, source.length, options);
  }

  /**
   */
  int lastIndexOf(string source, string value, int index, int count, CompareOptions options = CompareOptions.None) {
    if (source.length == 0 && (index == -1 || index == 0)) {
      if (value.length != 0)
        return -1;
      return 0;
    }

    if (index == source.length) {
      index++;
      if (count > 0)
        count--;
      if (value.length == 0 && count >= 0 && (index - count) + 1 >= 0)
        return index;
    }

    uint flags = getCompareFlags(options);

    int n = findString(sortingId_, flags | FIND_FROMEND, source, (index - count) + 1, count, value, value.length);
    if (n > -1)
      return n + (index - count) + 1;
    if (n == -1)
      return n;

    for (uint i = 0; i < count; i++) {
      if (isSuffix(source, index - i, count - i, value, flags))
        return i + (index - count) + 1;
    }
    return -1;
  }

  /// ditto
  int lastIndexOf(string source, string value, int index, CompareOptions options = CompareOptions.None) {
    return lastIndexOf(source, value, index, index + 1, options);
  }

  /// ditto
  int lastIndexOf(string source, string value, CompareOptions options = CompareOptions.None) {
    return lastIndexOf(source, value, source.length - 1, source.length, options);
  }

  /**
   */
  bool isPrefix(string source, string prefix, CompareOptions options = CompareOptions.None) {
    if (prefix.length == 0)
      return true;
    return isPrefix(source, 0, source.length, prefix, getCompareFlags(options));
  }

  /**
   */
  bool isSuffix(string source, string suffix, CompareOptions options = CompareOptions.None) {
    if (suffix.length == 0)
      return true;
    return isSuffix(source, source.length - 1, source.length, suffix, getCompareFlags(options));
  }

  /**
   */
  char toLower(char c) {
    return changeCaseChar(cultureId_, c, false);
  }

  /**
   */
  string toLower(string str) {
    return changeCaseString(cultureId_, str, false);
  }

  /**
   */
  char toUpper(char c) {
    return changeCaseChar(cultureId_, c, true);
  }

  /**
   */
  string toUpper(string str) {
    return changeCaseString(cultureId_, str, true);
  }

  /**
   */
  uint lcid() {
    return cultureId_;
  }

  /**
   */
  string name() {
    if (name_ == null)
      name_ = Culture.get(cultureId_).name;
    return name_;
  }

  private static uint getCompareFlags(CompareOptions options) {
    uint flags;
    if ((options & CompareOptions.IgnoreCase) != 0)
      flags |= NORM_IGNORECASE;
    if ((options & CompareOptions.IgnoreNonSpace) != 0)
      flags |= NORM_IGNORENONSPACE;
    if ((options & CompareOptions.IgnoreSymbols) != 0)
      flags |= NORM_IGNORESYMBOLS;
    if ((options & CompareOptions.IgnoreWidth) != 0)
      flags |= NORM_IGNOREWIDTH;
    return flags;
  }

  private static int compareString(uint lcid, string string1, int offset1, int length1, string string2, int offset2, int length2, uint flags) {
    int cch1, cch2;
    wchar* lpString1 = toUTF16zNls(string1, offset1, length1, cch1);
    wchar* lpString2 = toUTF16zNls(string2, offset2, length2, cch2);
    return CompareString(lcid, flags, lpString1, cch1, lpString2, cch2) - 2;
  }

  private static int compareStringOrdinal(string string1, int offset1, int length1, string string2, int offset2, int length2, bool ignoreCase) {
    int count = (length2 < length1) 
      ? length2 
      : length1;
    int ret = ignoreCase
      ? memicmp(string1.ptr + offset1, string2.ptr + offset2, count)
      : memcmp(string1.ptr + offset1, string2.ptr + offset2, count);
    if (ret == 0)
      ret = length1 - length2;
    return ret;
  }

  private bool isPrefix(string source, int start, int length, string prefix, uint flags) {
    // Call FindNLSString if the API is present on the system, otherwise call CompareString. 
    int i = findString(sortingId_, 0, source, start, length, prefix, prefix.length);
    if (i >= -1)
      return (i != -1);

    for (i = 1; i <= length; i++) {
      if (compareString(sortingId_, prefix, 0, prefix.length, source, start, i, flags) == 0)
        return true;
    }
    return false;
  }

  private bool isSuffix(string source, int end, int length, string suffix, uint flags) {
    // Call FindNLSString if the API is present on the system, otherwise call CompareString. 
    int i = findString(sortingId_, flags | FIND_ENDSWITH, source, 0, length, suffix, suffix.length);
    if (i >= -1)
      return (i != -1);

    for (i = 0; i < length; i++) {
      if (compareString(sortingId_, suffix, 0, suffix.length, source, end - i, i + 1, flags))
        return true;
    }
    return false;
  }

  private static char changeCaseChar(uint lcid, char ch, bool upperCase) {
    wchar wch;
    MultiByteToWideChar(CP_UTF8, 0, &ch, 1, &wch, 1);
    LCMapString(lcid, (upperCase ? LCMAP_UPPERCASE : LCMAP_LOWERCASE) | LCMAP_LINGUISTIC_CASING, &wch, 1, &wch, 1);
    WideCharToMultiByte(CP_UTF8, 0, &wch, 1, &ch, 1, null, null);
    return ch;
  }

  private static string changeCaseString(uint lcid, string string, bool upperCase) {
    int cch, cb;
    wchar* pChars = toUTF16zNls(string, 0, string.length, cch);
    LCMapString(lcid, (upperCase ? LCMAP_UPPERCASE : LCMAP_LOWERCASE) | LCMAP_LINGUISTIC_CASING, pChars, cch, pChars, cch);
    return toUTF8Nls(pChars, cch, cb);
  }

  private static int findString(uint lcid, uint flags, string source, int start, int sourceLen, string value, int valueLen) {
    // Return value:
    // -2 FindNLSString unavailable
    // -1 function failed
    //  0-based index if successful

    int result = -1;

    int cchSource, cchValue;
    wchar* lpSource = toUTF16zNls(source, 0, sourceLen, cchSource);
    wchar* lpValue = toUTF16zNls(value, 0, valueLen, cchValue);

    try {
      result = FindNLSString(lcid, flags, lpSource + start, cchSource, lpValue, cchValue, null);
    }
    catch (EntryPointNotFoundException) {
      result = -2;
    }
    return result;
  }

}

/**
 * Contains information about the country/region.
 */
class Region {

  private static Region current_;

  private uint cultureId_;
  private string name_;

  static ~this() {
    current_ = null;
  }

  /**
   */
  this(uint culture) {
    if (culture == LOCALE_INVARIANT)
      throw new ArgumentException("There is no region associated with the invariant culture (Culture ID: 0x7F).");

    if (SUBLANGID(cast(ushort)culture) == 0) {
      scope buffer = new char[100];
      int len = sprintf(buffer.ptr, "Culture ID %d (0x%04X) is a neutral culture; a region cannot be created from it.", culture, culture);
      throw new ArgumentException(cast(string)buffer[0 .. len], "culture");
    }

    cultureId_ = culture;
    name_ = getLocaleInfo(culture, LOCALE_SISO3166CTRYNAME);
  }

  /**
   */
  this(string name) {
    name_ = name.toupper();

    if (!findCultureFromRegionName(name, cultureId_))
      throw new ArgumentException("Region name '" ~ name ~ "' is not supported.", "name");

    if (isNeutralCulture(cultureId_))
      throw new ArgumentException("Region name '" ~ name ~ "' should not correspond to a neutral culture; a specific culture name is required.", "name");
  }

  override string toString() {
    return name;
  }

  /**
   */
  static Region current() {
    if (current_ is null)
      current_ = new Region(Culture.current.lcid);
    return current_;
  }

  /**
   */
  int geoId() {
    return getLocaleInfoI(cultureId_, LOCALE_IGEOID);
  }

  /**
   */
  string name() {
    if (name_ == null)
      name_ = getLocaleInfo(cultureId_, LOCALE_SISO3166CTRYNAME);
    return name_;
  }

  /**
   */
  string nativeName() {
    return getLocaleInfo(cultureId_, LOCALE_SNATIVECTRYNAME);
  }

  /**
   */
  string displayName() {
    return getLocaleInfo(cultureId_, LOCALE_SCOUNTRY);
  }

  /**
   */
  string englishName() {
    return getLocaleInfo(cultureId_, LOCALE_SENGCOUNTRY);
  }

  /**
   */
  string isoRegionName() {
    return getGeoInfo(geoId, GEO_ISO2);
  }

  /**
   */
  bool isMetric() {
    return getLocaleInfoI(cultureId_, LOCALE_IMEASURE) == 0;
  }

  /**
   */
  string currencySymbol() {
    return getLocaleInfo(cultureId_, LOCALE_SCURRENCY);
  }

  /**
   */
  string isoCurrencySymbol() {
    return getLocaleInfo(cultureId_, LOCALE_SINTLSYMBOL);
  }

  /**
   */
  string currencyNativeName() {
    return getLocaleInfo(cultureId_, LOCALE_SNATIVECURRNAME);
  }

  /**
   */
  string currencyEnglishName() {
    return getLocaleInfo(cultureId_, LOCALE_SENGCURRNAME);
  }

  /**
   */
  double latitude() {
    version(D_Version2) {
      return std.conv.to!(double)(getGeoInfo(geoId, GEO_LATITUDE));
    }
    else {
      return std.conv.toDouble(getGeoInfo(geoId, GEO_LATITUDE));
    }
  }

  /**
   */
  double longitude() {
    version(D_Version2) {
      return std.conv.to!(double)(getGeoInfo(geoId, GEO_LONGITUDE));
    }
    else {
      return std.conv.toDouble(getGeoInfo(geoId, GEO_LONGITUDE));
    }
  }

}