module mango.locale.parse;

private import mango.locale.core;

private struct DateTimeParseResult {

  int year = -1;
  int month = -1;
  int day = -1;
  int hour;
  int minute;
  int second;
  double fraction;
  int timeMark;
  Calendar calendar;
  TimeSpan timeZoneOffset;
  DateTime parsedDate;

}

package DateTime parseDateTime(char[] s, DateTimeFormat dtf) {
  DateTimeParseResult result;
  if (!tryParseExactMultiple(s, dtf.getAllDateTimePatterns(), dtf, result))
    throw new Exception("String was not a valid DateTime.");
  return result.parsedDate;
}

package DateTime parseDateTimeExact(char[] s, char[] format, DateTimeFormat dtf) {
  DateTimeParseResult result;
  if (!tryParseExact(s, format, dtf, result))
    throw new Exception("String was not a valid DateTime.");
  return result.parsedDate;
}

package bool tryParseDateTime(char[] s, DateTimeFormat dtf, out DateTime result) {
  result = DateTime.min;
  DateTimeParseResult resultRecord;
  if (!tryParseExactMultiple(s, dtf.getAllDateTimePatterns(), dtf, resultRecord))
    return false;
  result = resultRecord.parsedDate;
  return true;
}

package bool tryParseDateTimeExact(char[] s, char[] format, DateTimeFormat dtf, out DateTime result) {
  result = DateTime.min;
  DateTimeParseResult resultRecord;
  if (!tryParseExact(s, format, dtf, resultRecord))
    return false;
  result = resultRecord.parsedDate;
  return true;
}

private bool tryParseExactMultiple(char[] s, char[][] formats, DateTimeFormat dtf, inout DateTimeParseResult result) {
  foreach (char[] format; formats) {
    if (tryParseExact(s, format, dtf, result))
      return true;
  }
  return false;
}

private bool tryParseExact(char[] s, char[] pattern, DateTimeFormat dtf, inout DateTimeParseResult result) {

  bool doParse() {

    int parseDigits(char[] s, inout int pos, int max) {
      int result = s[pos++] - '0';
      while (max > 1 && pos < s.length && s[pos] >= '0' && s[pos] <= '9') {
        result = result * 10 + s[pos++] - '0';
        --max;
      }
      return result;
    }

    bool parseOne(char[] s, inout int pos, char[] value) {
      if (s[pos .. pos + value.length] != value)
        return false;
      pos += value.length;
      return true;
    }

    int parseMultiple(char[] s, inout int pos, char[][] values ...) {
      int result = -1, max;
      foreach (int i, char[] value; values) {
        if (value.length == 0 || s.length - pos < value.length)
          continue;

        if (s[pos .. pos + value.length] == value) {
          if (result == 0 || value.length > max) {
            result = i + 1;
            max = value.length;
          }
        }
      }
      pos += max;
      return result;
    }

    TimeSpan parseTimeZoneOffset(char[] s, inout int pos) {
      bool sign;
      if (pos < s.length) {
        if (s[pos] == '-') {
          sign = true;
          pos++;
        }
        else if (s[pos] == '+')
          pos++;
      }
      int hour = parseDigits(s, pos, 2);
      int minute;
      if (pos < s.length && s[pos] == ':') {
        pos++;
        minute = parseDigits(s, pos, 2);
      }
      TimeSpan result = TimeSpan(hour, minute, 0);
      if (sign)
        result = result.negate();
      return result;
    }
      
    char[] stringOf(char c, int count = 1) {
      char[] s = new char[count];
      s[0 .. count] = c;
      return s;
    }

    result.calendar = dtf.calendar;
    result.year = result.month = result.day = -1;
    result.hour = result.minute = result.second = 0;
    result.fraction = 0.0;

    int pos, i, count;
    char c;

    while (pos < pattern.length && i < s.length) {
      c = pattern[pos++];

      if (c == ' ') {
        i++;
        while (i < s.length && s[i] == ' ')
          i++;
        if (i >= s.length)
          break;
        continue;
      }

      count = 1;

      switch (c) {
        case 'd': case 'm': case 'M': case 'y':
        case 'h': case 'H': case 's':
        case 't': case 'z':
          while (pos < pattern.length && pattern[pos] == c) {
            pos++;
            count++;
          }
          break;
        case ':':
          if (!parseOne(s, i, dtf.timeSeparator))
            return false;
          continue;
        case '/':
          if (!parseOne(s, i, dtf.dateSeparator))
            return false;
          continue;
        case '\\':
          if (pos < pattern.length) {
            c = pattern[pos++];
            if (s[i++] != c)
              return false;
          }
          else
            return false;
          continue;
        case '\'':
          while (pos < pattern.length) {
            c = pattern[pos++];
            if (c == '\'')
              break;
            if (s[i++] != c)
              return false;
          }
          continue;
        default:
          if (s[i++] != c)
            return false;
          continue;
      }

      switch (c) {
        case 'd': // day
          if (count == 1 || count == 2)
            result.day = parseDigits(s, i, 2);
          else if (count == 3)
            result.day = parseMultiple(s, i, dtf.abbreviatedDayNames);
          else
            result.day = parseMultiple(s, i, dtf.dayNames);
          if (result.day == -1)
            return false;
          break;
        case 'M': // month
          if (count == 1 || count == 2)
            result.month = parseDigits(s, i, 2);
          else if (count == 3)
            result.month = parseMultiple(s, i, dtf.abbreviatedMonthNames);
          else
            result.month = parseMultiple(s, i, dtf.monthNames);
          if (result.month == -1)
            return false;
          break;
        case 'y': // year
          if (count == 1 || count == 2)
            result.year = parseDigits(s, i, 2);
          else
            result.year = parseDigits(s, i, 4);
          if (result.year == -1)
            return false;
          break;
        case 'h': // 12-hour clock
        case 'H': // 24-hour clock
          result.hour = parseDigits(s, i, 2);
          break;
        case 'm': // minute
          result.minute = parseDigits(s, i, 2);
          break;
        case 's': // second
          result.second = parseDigits(s, i, 2);
          break;
        case 't': // time mark
          if (count == 1)
            result.timeMark = parseMultiple(s, i, stringOf(dtf.amDesignator[0]), stringOf(dtf.pmDesignator[0]));
          else
            result.timeMark = parseMultiple(s, i, dtf.amDesignator, dtf.pmDesignator);
          break;
        case 'z':
          result.timeZoneOffset = parseTimeZoneOffset(s, i);
          break;
        default:
          break;
      }
    }

    if (pos < pattern.length || i < s.length)
      return false;

    if (result.timeMark == 1) { // am
      if (result.hour == 12)
        result.hour = 0;
    }
    else if (result.timeMark == 2) { // pm
      if (result.hour < 12)
        result.hour += 12;
    }

    // If the input string didn't specify a date part, try to return something meaningful.
    if (result.year == -1 || result.month == -1 || result.day == -1) {
      DateTime now = DateTime.now;
      if (result.month == -1 && result.day == -1) {
        if (result.year == -1) {
          result.year = result.calendar.getYear(now);
          result.month = result.calendar.getMonth(now);
          result.day = result.calendar.getDayOfMonth(now);
        }
        else
          result.month = result.day = 1;
      }
      else {
        if (result.year == -1)
          result.year = result.calendar.getYear(now);
        if (result.month == -1)
          result.month = 1;
        if (result.day == -1)
          result.day = 1;
      }
    }
    return true;
  }

  if (doParse()) {
    result.parsedDate = result.calendar.getDateTime(result.year, result.month, result.day, result.hour, result.minute, result.second, 0);
    return true;
  }
  return false;
}
version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
