/*******************************************************************************

        Copyright:      Copyright (c) 2007-2008 Matti Niemenmaa.
                        все rights reserved
        License:        BSD стиль: $(LICENSE)
        Версия:        Aug 2007: Initial release
                        Feb 2008: Retooled
        Author:         Matti Niemenmaa

        Модуль основан на стандарте ISO 8601:2004 и располагает функциями для
        парсинга (практически) любого формата дата/время, указанного в нём.
		(Единственно не поддерживаются интервалы, продолжительности и рекуррирующие интервалы.)

        Смотрите этот стандарт, где полностью описываются поддерживаемые форматы.

        Функции (разборВремени, разборДаты и разборДатыИВремени) перегружены, 
		каждая имеет по две версии: одна обновляет указанное Время, а другая -
		указанную структуру РасширеннаяДата. Эта структура предназначена для
		поддержки более детальной информации, которую не поддерживает тип данных Время.

        Если указан часовой пояс, то время просто преобразуется в UTC: из_ может
		вызывать изменение даты, если парсировано одно лишь время, например, "01:00+03"
        то же самое что и "22:00", но когда парсируется последнее, от дня отнимается единица.

*******************************************************************************/

module time.ISO8601;

public import time.Time;
public import time.chrono.Gregorian;

import exception : ИсклНелегальногоАргумента;
import math.Math : min;

private alias Время ДВ;
private alias ДатаДоп ПолнаяДата;

/** Расширенный тип даты, к-й инкапсулирует Время вместе с какой-л. доп.
 * информацией. */
public struct ДатаДоп {
   /** The Время значение, containing the information it can. */
   ДВ знач;

   private цел year_;

   /** Returns the год часть of the дата: a значение in the range
    * [-1_000_000_000,-1] ∪ [1,999_999_999], where -1 is the год 1 BCE.
    *
    * Do not use знач.год directly unless you are absolutely sure that it is in
    * the range a Время can hold (-10000 в_ 9999).
    */
   цел год();

   // y may be zero: if so, it refers в_ the год 1 BCE
   private проц год(цел y);

   private байт маска; // leap сукунда and endofday

   /** Returns the сек часть of the дата: may be 60 if a leap сукунда
    * occurred. In such a case, знач's сек часть is 59.
    */
   бцел сек();
   alias сек секунды, сукунда, sec;

   /** Whether the ISO 8601 representation of this час is 24 or 00: whether
    * this instant of mопрnight is в_ be consопрered the конец of the previous день
    * or the старт of the следщ.
    *
    * If the время of знач is not exactly 00:00:00.000, this значение is undefined.
    */
   бул конецДня();

   private проц установиВисокосным    () ;
   private проц установиКонецДня() ;

   debug (Tango_ISO8601) private ткст toStr();
}

/** Parses a дата in a форматируй specified in ISO 8601:2004.
 *
 * Returns the число of characters used в_ compose a valid дата: 0 if no дата
 * can be composed.
 *
 * Fields in dt will either be correct (e.g. месяцы will be >= 1 and <= 12) or
 * the default, which is 1 for год, месяц, and день, and 0 for все другой
 * fields. Unless one is absolutely sure that 0001-01-01 can never be
 * encountered, one should check the return значение в_ be sure that the parsing
 * succeeded as ожидалось.
 *
 * A third parameter is available for the ДатаДоп version: this allows for
 * parsing expanded год representations. The parameter is the число of extra
 * год digits beyond four, and defaults в_ zero. It must be within the range
 * [0,5]: this allows for a maximum год of 999 999 999, which should be enough
 * for сейчас.
 *
 * When using expanded год representations, be careful в_ use
 * ДатаДоп.год instead of the Время's год значение.
 *
 * Examples:
 * ---
 * Время t;
 * ДатаДоп ed;
 *
 * парсируйДату("19",             t);    // January 1st, 1900
 * парсируйДату("1970",           t);    // January 1st, 1970
 * парсируйДату("1970-02",        t);    // February 1st, 1970
 * парсируйДату("19700203",       t);    // February 3rd, 1970
 * парсируйДату("+19700203",     ed, 2); // March 1st, 197002
 * парсируйДату("-197002-04-01", ed, 2); // April 1st, -197003 (197003 BCE)
 * парсируйДату("00000101",       t);    // January 1st, -1 (1 BCE)
 * парсируйДату("1700-W14-2",     t);    // April 6th, 1700
 * парсируйДату("2008W01",        t);    // December 31st, 2007
 * парсируйДату("1987-221",       t);    // August 9th, 1987
 * парсируйДату("1234abcd",       t);    // January 1st, 1234; return значение is 4
 * парсируйДату("12abcdef",       t);    // January 1st, 1200; return значение is 2
 * парсируйДату("abcdefgh",       t);    // January 1st, 0001; return значение is 0
 * ---
 */
public т_мера парсируйДату(T)(T[] ист, ref ДВ dt) {
   auto fd = ПолнаяДата(dt);

   auto возвр = парсируйДату(ист, fd);
   dt = fd.знач;
   return возвр;
}
/** ditto */
public т_мера парсируйДату(T)(T[] ист, ref ПолнаяДата fd, ббайт expanded = 0) {
   ббайт dummy =void;
   T* p = ист.ptr;
   return doIso8601Date(p, ист, fd, expanded, dummy);
}

private т_мера doIso8601Date(T)(

   ref T* p, T[] ист,
   ref ПолнаяДата fd,
   ббайт expanded,
   out ббайт разделители

) {
   if (expanded > 5)
      throw new ИсклНелегальногоАргумента(
         "ISO8601 :: год expanded by ещё than 5 digits does not fit in цел");

   т_мера eaten() { return p - ист.ptr; }
   т_мера remaining() { return ист.length - eaten(); }
   бул готово(T[] s) { return .готово(eaten(), ист.length, p, s); }

   if (!парсируйГод(p, ист.length, expanded, fd))
      return 0;

   auto onlyYear = eaten();

   // /([+-]Y{expanded})?(YYYY|YY)/
   if (готово("-0123W"))
      return onlyYear;

   if (прими(p, '-')) {
      разделители = YES;

      if (remaining() == 0)
         return eaten() - 1;
   }

   if (прими(p, 'W')) {
      T* p2 = p;

      цел i = парсируйЦел(p, min(cast(т_мера)3, remaining()));

      if (i) if (p - p2 == 2) {

         // (год)-Www
         if (готово("-")) {
            if (дайМесяцИДеньИзНедели(fd, i))
               return eaten();

         // (год)-Www-D
         } else if (demand(p, '-')) {
            if (remaining() == 0)
               return eaten() - 1;

            if (разделители == NO) {
               // (год)Www after все
               if (дайМесяцИДеньИзНедели(fd, i))
                  return eaten() - 1;

            } else if (дайМесяцИДеньИзНедели(fd, i, *p++ - '0'))
               return eaten();
         }

      } else if (p - p2 == 3) {
         // (год)WwwD, i == wwD

         if (разделители == YES) {
            // (год)-Www after все
            if (дайМесяцИДеньИзНедели(fd, i / 10))
               return eaten() - 1;

         } else if (дайМесяцИДеньИзНедели(fd, i / 10, i % 10))
            return eaten();
      }
      return onlyYear;
   }

   // следщ up, MM or MM[-]DD or DDD

   T* p2 = p;

   цел i = парсируйЦел(p, remaining());
   if (!i)
      return onlyYear;

   switch (p - p2) {
      case 2:
         // MM or MM-DD

         if (i >= 1 && i <= 12)
            добавьМесяцы(fd, i);
         else
            return onlyYear;

         auto onlyMonth = eaten();

         // (год)-MM
         if (готово("-") || !demand(p, '-') || разделители == NO)
            return onlyMonth;

         цел день = парсируйЦел(p, min(cast(т_мера)2, remaining()));

         // (год)-MM-DD
         if (день && день <= днейВМесяце(месяцы(fd), fd.год))
            добавьДни(fd, день);
         else
            return onlyMonth;

         break;

      case 4:
         // e.g. 20010203, i = 203 сейчас

         цел месяц = i / 100;
         цел день   = i % 100;

         if (разделители == YES) {
            // Don't прими the день: behave as though we only got the месяц
            p -= 2;
            i = месяц;
            goto case 2;
         }

         // (год)MMDD
         if (
            месяц >= 1 && месяц <= 12 &&
            день   >= 1 && день   <= днейВМесяце(месяц, fd.год)
         ) {
            добавьМесяцы(fd, месяц);
            добавьДни  (fd, день);
         } else
            return onlyYear;

         break;

      case 3:
         // (год)-DDD
         // i is the порядковый of the день within the год

         if (i > 365 + високосен_ли(fd.год))
            return onlyYear;

         добавьДни(fd, i);

      default: break;
   }
   return eaten();
}

/** Parses a время of день in a форматируй specified in ISO 8601:2004.
 *
 * Returns the число of characters used в_ compose a valid время: 0 if no время
 * can be composed.
 *
 * Fields in dt will either be correct or the default, which is 0 for все
 * время-related fields. fields. Unless one is absolutely sure that mопрnight
 * can never be encountered, one should check the return значение в_ be sure that
 * the parsing succeeded as ожидалось.
 *
 * Экстра fields in ДатаДоп:
 *
 * Seconds may be 60 if the часы and минуты are 23 and 59, as leap сек
 * are occasionally добавьed в_ UTC время. A Время's сек will be 59 in this
 * case.
 *
 * Hours may be 0 or 24: the latter marks the конец of a день and the former the
 * beginning, although they Всё refer в_ the same instant in время. A Время
 * will be precisely 00:00 in either case.
 *
 * Examples:
 * ---
 * Время t;
 * ДатаДоп ed;
 *
 * // ",000" omitted for clarity
 * парсируйВремя("20",             t); // 20:00:00
 * парсируйВремя("2004",           t); // 20:04:00
 * парсируйВремя("20:04:06",       t); // 20:04:06
 * парсируйВремя("16:49:30,001",   t); // 16:49:30,001
 * парсируйВремя("16:49:30,1",     t); // 16:49:30,100
 * парсируйВремя("16:49,4",        t); // 16:49:24
 * парсируйВремя("23:59:60",      ed); // 23:59:60
 * парсируйВремя("24:00:01",       t); // 00:00:00; return значение is 5
 * парсируйВремя("24:00:01",      ed); // 00:00:00; return значение is 5; конецДня
 * парсируйВремя("30",             t); // 00:00:00; return значение is 0
 * парсируйВремя("21:32:43-12:34", t); // 10:06:43; день increased by one
 * ---
 */
public т_мера парсируйВремя(T)(T[] ист, ref ДВ dt) {
   auto fd = ПолнаяДата(dt);

   auto возвр = парсируйВремя(ист, fd);
   dt = fd.знач;
   return возвр;
}
/** ditto */
public т_мера парсируйВремя(T)(T[] ист, ref ПолнаяДата fd) {
   бул dummy =void;
   T* p = ист.ptr;
   return doIso8601Time(p, ист, fd, WHATEVER, dummy);
}

// разделители
private enum : ббайт { NO = 0, YES = 1, WHATEVER }

// ВсёValопр is used only в_ получи парсируйДатуИВремя() в_ catch ошибки correctly
private т_мера doIso8601Time(T)(

   ref T* p, T[] ист,
   ref ПолнаяДата fd,
   ббайт разделители,
   out бул ВсёValопр

) {
   т_мера eaten() { return p - ист.ptr; }
   т_мера remaining() { return ист.length - eaten(); }
   бул готово(T[] s) { return .готово(eaten(), ист.length, p, s); }
   бул проверьДвоеточие() { return .проверьДвоеточие(p, разделители); }

   байт дайВременнуюЗону() { return .дайВременнуюЗону(p, remaining(), fd, разделители, &готово); }

   if (разделители == WHATEVER)
      прими(p, 'T');

   цел час =void;
   if (парсируйЦел(p, min(cast(т_мера)2, remaining()), час) != 2 || час > 24)
      return 0;

   if (час == 24)
      fd.установиКонецДня();

   // Добавь the часы even if конецДня: the день should be the следщ день, not the
   // previous
   добавьЧасы(fd, час);

   auto onlyHour = eaten();

   // hh
   if (готово("+,-.012345:"))
      return onlyHour;

   switch (getDecimal(p, remaining(), fd, час)) {
      case NOTFOUND: break;
      case    FOUND:
         auto onlyDecimal = eaten();
         if (дайВременнуюЗону() == BAD)
            return onlyDecimal;

         // /hh,h+/
         return eaten();

      case BAD: return onlyHour;
      default: assert (нет);
   }

   switch (дайВременнуюЗону()) {
      case NOTFOUND: break;
      case    FOUND: return eaten();
      case BAD:      return onlyHour;
      default: assert (нет);
   }

   if (!проверьДвоеточие())
      return onlyHour;

   цел минуты =void;
   if (
      парсируйЦел(p, min(cast(т_мера)2, remaining()), минуты) != 2 ||
      минуты > 59 ||
      // конец of день is only for 24:00:00
      (fd.конецДня && минуты != 0)
   )
      return onlyHour;

   добавьМинуты(fd, минуты);

   auto onlyMinute = eaten();

   // hh:mm
   if (готово("+,-.0123456:")) {
      ВсёValопр = да;
      return onlyMinute;
   }

   switch (getDecimal(p, remaining(), fd, минута)) {
      case NOTFOUND: break;
      case    FOUND:
         auto onlyDecimal = eaten();
         if (дайВременнуюЗону() == BAD)
            return onlyDecimal;

         // /hh:mm,m+/
         ВсёValопр = да;
         return eaten();

      case BAD: return onlyMinute;
      default: assert (нет);
   }

   switch (дайВременнуюЗону()) {
      case NOTFOUND: break;
      case    FOUND: ВсёValопр = да; return eaten();
      case BAD:      return onlyMinute;
      default: assert (нет);
   }

   if (!проверьДвоеточие())
      return onlyMinute;

   цел sec =void;
   if (
      парсируйЦел(p, min(cast(т_мера)2, remaining()), sec) != 2 ||
      sec > 60 ||
      (fd.конецДня && sec != 0)
   )
      return onlyMinute;

   if (sec == 60) {
      if (часы(fd) != 23 && .минуты(fd) != 59)
         return onlyMinute;

      fd.установиВисокосным();
      --sec;
   }
   добавьСекунды(fd, sec);

   auto onlySecond = eaten();

   // hh:mm:ss
   if (готово("+,-.Z")) {
      ВсёValопр = да;
      return onlySecond;
   }

   switch (getDecimal(p, remaining(), fd, сукунда)) {
      case NOTFOUND: break;
      case    FOUND:
         auto onlyDecimal = eaten();
         if (дайВременнуюЗону() == BAD)
            return onlyDecimal;

         // /hh:mm:ss,s+/
         ВсёValопр = да;
         return eaten();

      case BAD: return onlySecond;
      default: assert (нет);
   }

   if (дайВременнуюЗону() == BAD)
      return onlySecond;
   else {
      ВсёValопр = да;
      return eaten(); // hh:mm:ss with timezone
   }
}

/** Parses a combined дата and время in a форматируй specified in ISO 8601:2004.
 *
 * Returns the число of characters used в_ compose a valid дата and время.
 * Zero is returned if a complete дата and время cannot be extracted. In that
 * case, the значение of the resulting Время or ДатаДоп is undefined.
 *
 * This function is stricter than just calling парсируйДату followed by
 * парсируйВремя: there are no allowances for expanded годы or reduced dates
 * (two-цифра годы), and разделитель usage must be consistent.
 *
 * Although the стандарт allows for omitting the T between the дата and the
 * время, this function requires it.
 *
 * Examples:
 * ---
 * Время t;
 *
 * // January 1st, 2008 00:01:00
 * парсируйДатуИВремя("2007-12-31T23:01-01", t);
 *
 * // April 12th, 1985 23:50:30,042
 * парсируйДатуИВремя("1985W155T235030,042", t);
 *
 * // Неверный время: returns zero
 * парсируйДатуИВремя("1902-03-04T10:1a", t);
 *
 * // Separating T omitted: returns zero
 * парсируйДатуИВремя("1985-04-1210:15:30+04:00", t);
 *
 * // Inconsistent разделители: все return zero
 * парсируйДатуИВремя("200512-01T10:02",          t);
 * парсируйДатуИВремя("1985-04-12T10:15:30+0400", t);
 * парсируйДатуИВремя("1902-03-04T050607",        t);
 * ---
 */
public т_мера парсируйДатуИВремя(T)(T[] ист, ref ДВ dt) {
   ПолнаяДата fd;
   auto возвр = парсируйДатуИВремя(ист, fd);
   dt = fd.знач;
   return возвр;
}
/** ditto */
public т_мера парсируйДатуИВремя(T)(T[] ист, ref ПолнаяДата fd) {
   T* p = ист.ptr;
   ббайт sep;
   бул ВсёValопр = нет;

   if (
      doIso8601Date(p, ист, fd, cast(ббайт)0, sep) &&

      // by mutual agreement this T may be omitted
      // but this is just a convenience метод for дата+время anyway
      ист.length - (p - ист.ptr) >= 1 &&
      demand(p, 'T') &&

      doIso8601Time(p, ист, fd, sep, ВсёValопр) &&
      ВсёValопр
   )
      return p - ист.ptr;
   else
      return 0;
}

/+ +++++++++++++++++++++++++++++++++++++++ +\

   Privates used by дата

\+ +++++++++++++++++++++++++++++++++++++++ +/

private:

// /([+-]Y{expanded})?(YYYY|YY)/
бул парсируйГод(T)(ref T* p, т_мера длин, ббайт expanded, ref ПолнаяДата fd) {

   цел год =void;

   бул doParse() {
      T* p2 = p;

      if (!парсируйЦел(p, min(cast(т_мера)(expanded + 4), длин), год))
         return нет;

      // it's Y{expanded}YY, Y{expanded}YYYY, or unacceptable

      if (p - p2 - expanded == 2)
         год *= 100;
      else if (p - p2 - expanded != 4)
         return нет;

      return да;
   }

   if (прими(p, '-')) {
      if (!doParse() || год < 0)
         return нет;
      год = -год;
   } else {
      прими(p, '+');
      if (!doParse() || год < 0)
         return нет;
   }

   fd.год = год;

   return да;
}

// найди the месяц and день given a calendar week and the день of the week
// uses fd.год for leap год calculations
// returns нет if week and fd.год are incompatible
бул дайМесяцИДеньИзНедели(ref ПолнаяДата fd, цел week, цел день = 1) {
   if (week < 1 || week > 53 || день < 1 || день > 7)
      return нет;

   цел год = fd.год;

   // only годы starting with Четверг and leap годы starting with Среда
   // have 53 weeks
   if (week == 53) {
      цел startingDay = деньНедели(год, 1, 1);

      if (!(startingDay == 4 || (високосен_ли(год) && startingDay == 3)))
         return нет;
   }

   // XXX
   // дни since год-01-04, plus 4 (?)...
   /* This is a bit scary, actually: I have ***no опрea why this works***. I
    * came up with this completely by accопрent. It seems в_ work though -
    * unless it fails in some (very) obscure case which isn't represented in
    * the unit tests.
   */
   добавьДни(fd, 7*(week - 1) + день - деньНедели(год, 1, 4) + 4);

   return да;
}

бул високосен_ли(цел год) {
   return год % 4 == 0 && (год % 100 != 0 || год % 400 == 0);
}

цел деньНедели(цел год, цел месяц, цел день)
in {
   assert (месяц  >= 1 && месяц  <= 12);
   assert (день    >= 1 && день    <= 31);
} out(результат) {
   assert (результат >= 1 && результат <= 7);
} body {
   бцел эра = erafy(год);

   цел результат =
      Грегориан.генерный.дайДеньНедели(
         Грегориан.генерный.воВремя(год, месяц, день, 0, 0, 0, 0, эра));

   if (результат == Грегориан.ДеньНедели.Воскресенье)
      return 7;
   else
      return результат;
}

/+ +++++++++++++++++++++++++++++++++++++++ +\

   Privates used by время

\+ +++++++++++++++++++++++++++++++++++++++ +/

enum : ббайт { час, минута, сукунда }
enum :  байт { BAD, FOUND, NOTFOUND }

бул проверьДвоеточие(T)(ref T* p, ref ббайт разделители) {
   ббайт foundSep = прими(p, ':') ? YES : NO;
   if (foundSep != разделители) {
      if (разделители == WHATEVER)
         разделители = foundSep;
      else
         return нет;
   }
   return да;
}

байт getDecimal(T)(ref T* p, т_мера длин, ref ПолнаяДата fd, ббайт which) {
   if (!(прими(p, ',') || прими(p, '.')))
      return NOTFOUND;

   T* p2 = p;

   цел i =void;
   auto iLen = парсируйЦел(p, длин-1, i);

   if (
      iLen == 0 ||

      // if i is 0, must have at least 3 digits
      // ... or at least that's what I think the стандарт means
      // when it says "[i]f the magnitude of the число is less
      // than unity, the decimal sign shall be preceded by two
      // zeros"...
      // surely that should читай "followed" and not "preceded"

      (i == 0 && iLen < 3)
   )
      return BAD;

   // 10 в_ the power of (iLen - 1)
   цел степ = 1;
   while (--iLen)
      степ *= 10;

   switch (which) {
      case час:
         добавьМинуты(fd, 6 * i / степ);
         добавьСекунды(fd, 6 * i % степ);
         break;
      case минута:
         добавьСекунды(fd, 6    * i / степ);
         добавьМс  (fd, 6000 * i / степ % 1000);
         break;
      case сукунда:
         добавьМс(fd, 100 * i / степ);
         break;

      default: assert (нет);
   }

   return FOUND;
}

// the ДВ is always UTC, so this just добавьs the смещение в_ the дата fields
// другой опция would be в_ добавь время зона fields в_ ДВ and have this заполни them

байт дайВременнуюЗону(T)(ref T* p, т_мера длин, ref ПолнаяДата fd, ббайт разделители, бул delegate(T[]) готово) {
   бул проверьДвоеточие() { return .проверьДвоеточие(p, разделители); }

   if (длин == 0)
      return NOTFOUND;

   auto p0 = p;

   if (прими(p, 'Z'))
      return FOUND;

   цел factor = -1;

   if (прими(p, '-'))
      factor = 1;
   else if (!прими(p, '+'))
      return NOTFOUND;

   цел час =void;
   if (парсируйЦел(p, min(cast(т_мера)2, длин-1), час) != 2 || час > 12 || (час == 0 && factor == 1))
      return BAD;

   добавьЧасы(fd, factor * час);

   // if we go forward in время в_ mопрnight, it's 24:00
   if (
      factor > 0 &&
      часы(fd) == 0 && минуты(fd) == 0 && секунды(fd) == 0 && ms(fd) == 0
   )
      fd.установиКонецДня();

   if (готово("012345:"))
      return FOUND;

   auto afterHours = p;

   if (!проверьДвоеточие())
      return BAD;

   цел минута =void;
   if (парсируйЦел(p, min(cast(т_мера)2, длин - (p-p0)), минута) != 2) {
      // The часы were valid even if the минуты weren't
      p = afterHours;
      return FOUND;
   }

   добавьМинуты(fd, factor * минута);

   // as above
   if (
      factor > 0 &&
      часы(fd) == 0 && минуты(fd) == 0 && секунды(fd) == 0 && ms(fd) == 0
   )
      fd.установиКонецДня();

   return FOUND;
}

/+ +++++++++++++++++++++++++++++++++++++++ +\

   Privates used by Всё дата and время

\+ +++++++++++++++++++++++++++++++++++++++ +/

бул прими(T)(ref T* p, сим c) {
   if (*p == c) {
      ++p;
      return да;
   }
   return нет;
}

бул demand(T)(ref T* p, сим c) {
   return (*p++ == c);
}

бул готово(T)(т_мера eaten, т_мера srcLen, T* p, T[] s) {
   if (eaten == srcLen)
      return да;

   // s is the Массив of characters which may come следщ
   // (i.e. which *p may be)
   // sorted in ascending order
   T t = *p;
   foreach (c; s) {
      if (t < c)
         return да;
      else if (t == c)
         break;
   }
   return нет;
}

цел днейВМесяце(цел месяц, цел год) {
   бцел эра = erafy(год);
   return Грегориан.генерный.дайДниМесяца(год, месяц, эра);
}

бцел erafy(ref цел год) {
   if (год < 0) {
      год *= -1;
      return Грегориан.BC_ERA;
   } else
      return Грегориан.AD_ERA;
}

/+ +++++++++++++++++++++++++++++++++++++++ +\

   Extract an целое из_ the ввод, прими no ещё than max digits

\+ +++++++++++++++++++++++++++++++++++++++ +/

// note: код relies on these always being positive, failing if *p == '-'

цел парсируйЦел(T)(ref T* p, т_мера max) {
   т_мера i = 0;
   цел значение = 0;
   while (i < max && p[i] >= '0' && p[i] <= '9')
      значение = значение * 10 + p[i++] - '0';
   p += i;
   return значение;
}

// ... and return the amount of digits processed

т_мера парсируйЦел(T)(ref T* p, т_мера max, out цел i) {
   T* p2 = p;
   i = парсируйЦел(p, max);
   return p - p2;
}


/+ +++++++++++++++++++++++++++++++++++++++ +\

   Helpers for ДВ/ПолнаяДата manИПulation

\+ +++++++++++++++++++++++++++++++++++++++ +/

// as documented in time.Time
бул DTyear(цел год) { return год >= -10000 && год <= 9999; }

проц добавьМесяцы(ref ПолнаяДата d, цел n) { d.знач = Грегориан.генерный.добавьМесяцы(d.знач, n-1); } // -1 due в_ начальное being 1
проц добавьДни  (ref ПолнаяДата d, цел n) { d.знач += ИнтервалВремени.изДней   (n-1); } // ditto
проц добавьЧасы (ref ПолнаяДата d, цел n) { d.знач += ИнтервалВремени.изЧасов  (n); }
проц добавьМинуты  (ref ПолнаяДата d, цел n) { d.знач += ИнтервалВремени.изМин(n); }
проц добавьСекунды  (ref ПолнаяДата d, цел n) { d.знач += ИнтервалВремени.изСек(n); }
проц добавьМс    (ref ПолнаяДата d, цел n) { d.знач += ИнтервалВремени.изМиллисек (n); }

// годы and секунды always just получи the ДВ значение
цел годы (ПолнаяДата d) { return Грегориан.генерный.дайГод      (d.знач); }
цел месяцы(ПолнаяДата d) { return Грегориан.генерный.дайМесяц     (d.знач); }
цел дни  (ПолнаяДата d) { return Грегориан.генерный.дайДеньМесяца(d.знач); }
цел часы (ПолнаяДата d) { return d.знач.время.часы;   }
цел минуты  (ПолнаяДата d) { return d.знач.время.минуты; }
цел секунды  (ПолнаяДата d) { return d.знач.время.сек; }
цел ms    (ПолнаяДата d) { return d.знач.время.миллисек;  }

////////////////////

// Unit tests

debug (UnitTest) {
   // проц main() {}

   debug (Tango_ISO8601_Valgrind) import rt.core.stdc.stdlib : malloc, free;

   unittest {
      ПолнаяДата fd;

      // дата

      т_мера d(ткст s, ббайт e = 0) {
         fd = fd.init;
         return парсируйДату(s, fd, e);
      }

      auto
         INIT_YEAR  = годы (ПолнаяДата.init),
         INIT_MONTH = месяцы(ПолнаяДата.init),
         INIT_DAY   = дни  (ПолнаяДата.init);

      assert (d("20abc") == 2);
      assert (годы(fd) == 2000);

      assert (d("2004") == 4);
      assert (годы(fd) == 2004);

      assert (d("+0019", 2) == 5);
      assert (годы(fd) == 1900);

      assert (d("+111985", 2) == 7);
      assert (годы(fd) == INIT_YEAR);
      assert (fd.год   == 111985);

      assert (d("+111985", 1) == 6);
      assert (годы(fd) == INIT_YEAR);
      assert (fd.год   == 11198);

      assert (d("+111985", 3) == 0);
      assert (годы(fd) == INIT_YEAR);
      assert (fd.год   == INIT_YEAR);

      assert (d("+111985", 4) == 7);
      assert (годы(fd) == INIT_YEAR);
      assert (fd.год   == 11198500);

      assert (d("-111985", 5) == 0);
      assert (годы(fd) == INIT_YEAR);
      assert (fd.год   == INIT_YEAR);

      assert (d("+999999999", 5) == 10);
      assert (годы(fd) == INIT_YEAR);
      assert (fd.год == 999_999_999);

      try {
         d("+10000000000", 6);
         assert (нет);
      } catch (ИсклНелегальногоАргумента) {
         assert (годы(fd) == INIT_YEAR);
         assert (fd.год   == INIT_YEAR);
      }

      assert (d("-999999999", 5) == 10);
      assert (годы(fd) == INIT_YEAR);
      assert (fd.год == -1_000_000_000);

      assert (d("0001") == 4);
      assert (годы(fd) == 1);
      assert (fd.год   == 1);

      assert (d("0000") == 4);
      assert (fd.год   == -1);

      assert (d("-0001") == 5);
      assert (fd.год   == -2);

      assert (d("abc") == 0);
      assert (годы(fd) == INIT_YEAR);
      assert (fd.год   == INIT_YEAR);

      assert (d("abc123") == 0);
      assert (годы(fd) == INIT_YEAR);
      assert (fd.год   == INIT_YEAR);

      assert (d("2007-08") == 7);
      assert (годы(fd)  == 2007);
      assert (месяцы(fd) ==    8);

      assert (d("+001985-04", 2) == 10);
      assert (годы(fd)  == 1985);
      assert (месяцы(fd) ==    4);

      assert (d("2007-08-07") == 10);
      assert (годы(fd)  == 2007);
      assert (месяцы(fd) ==    8);
      assert (дни(fd)   ==    7);

      assert (d("2008-20-30") == 4);
      assert (годы(fd)  == 2008);
      assert (месяцы(fd) == INIT_MONTH);

      assert (d("2007-02-30") == 7);
      assert (годы(fd)  == 2007);
      assert (месяцы(fd) ==    2);

      assert (d("20060708") == 8);
      assert (годы(fd)  == 2006);
      assert (месяцы(fd) ==    7);
      assert (дни(fd)   ==    8);

      assert (d("19953080") == 4);
      assert (годы(fd)  == 1995);
      assert (месяцы(fd) == INIT_MONTH);

      assert (d("2007-0201") == 7);
      assert (годы(fd)  == 2007);
      assert (месяцы(fd) ==    2);

      assert (d("200702-01") == 6);
      assert (годы(fd)  == 2007);
      assert (месяцы(fd) ==    2);

      assert (d("+001985-04-12", 2) == 13);
      assert (годы(fd)  == 1985);
      assert (fd.год    == 1985);
      assert (месяцы(fd) ==    4);
      assert (дни(fd)   ==   12);

      assert (d("-0123450607", 2) == 11);
      assert (годы(fd)  == INIT_YEAR);
      assert (fd.год    == -12346);
      assert (месяцы(fd) ==      6);
      assert (дни(fd)   ==      7);

      assert (d("1985W15") == 7);
      assert (годы(fd)  == 1985);
      assert (месяцы(fd) ==    4);
      assert (дни(fd)   ==    8);

      assert (d("2008-W01") == 8);
      assert (годы(fd)  == 2007);
      assert (месяцы(fd) ==   12);
      assert (дни(fd)   ==   31);

      assert (d("2008-W012") == 8);
      assert (годы(fd)  == 2007);
      assert (месяцы(fd) ==   12);
      assert (дни(fd)   ==   31);

      assert (d("2008W01-2") == 7);
      assert (годы(fd)  == 2007);
      assert (месяцы(fd) ==   12);
      assert (дни(fd)   ==   31);

      assert (d("2008-W01-2") == 10);
      assert (годы(fd)  == 2008);
      assert (месяцы(fd) ==    1);
      assert (дни(fd)   ==    1);

      assert (d("2009-W53-4") == 10);
      assert (годы(fd)  == 2009);
      assert (месяцы(fd) ==   12);
      assert (дни(fd)   ==   31);

      assert (d("2009-W01-1") == 10);
      assert (годы(fd)  == 2008);
      assert (месяцы(fd) ==   12);
      assert (дни(fd)   ==   29);

      assert (d("2009W537") == 8);
      assert (годы(fd)  == 2010);
      assert (месяцы(fd) ==    1);
      assert (дни(fd)   ==    3);

      assert (d("2010W537") == 4);
      assert (годы(fd)  == 2010);
      assert (месяцы(fd) == INIT_MONTH);

      assert (d("2009-W01-3") == 10);
      assert (годы(fd)  == 2008);
      assert (месяцы(fd) ==   12);
      assert (дни(fd)   ==   31);

      assert (d("2009-W01-4") == 10);
      assert (годы(fd)  == 2009);
      assert (месяцы(fd) ==    1);
      assert (дни(fd)   ==    1);

      assert (d("2004-W53-6") == 10);
      assert (годы(fd)  == 2005);
      assert (месяцы(fd) ==    1);
      assert (дни(fd)   ==    1);

      assert (d("2004-W53-7") == 10);
      assert (годы(fd)  == 2005);
      assert (месяцы(fd) ==    1);
      assert (дни(fd)   ==    2);

      assert (d("2005-W52-6") == 10);
      assert (годы(fd)  == 2005);
      assert (месяцы(fd) ==   12);
      assert (дни(fd)   ==   31);

      assert (d("2007-W01-1") == 10);
      assert (годы(fd)  == 2007);
      assert (месяцы(fd) ==    1);
      assert (дни(fd)   ==    1);

      assert (d("1000-W07-7") == 10);
      assert (годы(fd)  == 1000);
      assert (месяцы(fd) ==    2);
      assert (дни(fd)   ==   16);

      assert (d("1500-W11-1") == 10);
      assert (годы(fd)  == 1500);
      assert (месяцы(fd) ==    3);
      assert (дни(fd)   ==   12);

      assert (d("1700-W14-2") == 10);
      assert (годы(fd)  == 1700);
      assert (месяцы(fd) ==    4);
      assert (дни(fd)   ==    6);

      assert (d("1800-W19-3") == 10);
      assert (годы(fd)  == 1800);
      assert (месяцы(fd) ==    5);
      assert (дни(fd)   ==    7);

      assert (d("1900-W25-4") == 10);
      assert (годы(fd)  == 1900);
      assert (месяцы(fd) ==    6);
      assert (дни(fd)   ==   21);

      assert (d("0900-W27-5") == 10);
      assert (годы(fd)  ==  900);
      assert (месяцы(fd) ==    7);
      assert (дни(fd)   ==    9);

      assert (d("0800-W33-6") == 10);
      assert (годы(fd)  ==  800);
      assert (месяцы(fd) ==    8);
      assert (дни(fd)   ==   19);

      assert (d("0700-W37-7") == 10);
      assert (годы(fd)  ==  700);
      assert (месяцы(fd) ==    9);
      assert (дни(fd)   ==   16);

      assert (d("0600-W41-4") == 10);
      assert (годы(fd)  ==  600);
      assert (месяцы(fd) ==   10);
      assert (дни(fd)   ==    9);

      assert (d("0500-W45-7") == 10);
      assert (годы(fd)  ==  500);
      assert (месяцы(fd) ==   11);
      assert (дни(fd)   ==   14);

      assert (d("2000-W55") == 4);
      assert (годы(fd) == 2000);

      assert (d("1980-002") == 8);
      assert (годы(fd)  == 1980);
      assert (месяцы(fd) ==    1);
      assert (дни(fd)   ==    2);

      assert (d("1981-034") == 8);
      assert (годы(fd)  == 1981);
      assert (месяцы(fd) ==    2);
      assert (дни(fd)   ==    3);

      assert (d("1982-063") == 8);
      assert (годы(fd)  == 1982);
      assert (месяцы(fd) ==    3);
      assert (дни(fd)   ==    4);

      assert (d("1983-095") == 8);
      assert (годы(fd)  == 1983);
      assert (месяцы(fd) ==    4);
      assert (дни(fd)   ==    5);

      assert (d("1984-127") == 8);
      assert (годы(fd)  == 1984);
      assert (месяцы(fd) ==    5);
      assert (дни(fd)   ==    6);

      assert (d("1985-158") == 8);
      assert (годы(fd)  == 1985);
      assert (месяцы(fd) ==    6);
      assert (дни(fd)   ==    7);

      assert (d("1986-189") == 8);
      assert (годы(fd)  == 1986);
      assert (месяцы(fd) ==    7);
      assert (дни(fd)   ==    8);

      assert (d("1987-221") == 8);
      assert (годы(fd)  == 1987);
      assert (месяцы(fd) ==    8);
      assert (дни(fd)   ==    9);

      assert (d("1988-254") == 8);
      assert (годы(fd)  == 1988);
      assert (месяцы(fd) ==    9);
      assert (дни(fd)   ==   10);

      assert (d("1989-284") == 8);
      assert (годы(fd)  == 1989);
      assert (месяцы(fd) ==   10);
      assert (дни(fd)   ==   11);

      assert (d("1990316") == 7);
      assert (годы(fd)  == 1990);
      assert (месяцы(fd) ==   11);
      assert (дни(fd)   ==   12);

      assert (d("1991-347") == 8);
      assert (годы(fd)  == 1991);
      assert (месяцы(fd) ==   12);
      assert (дни(fd)   ==   13);

      assert (d("1992-000") == 4);
      assert (годы(fd) == 1992);

      assert (d("1993-370") == 4);
      assert (годы(fd) == 1993);

      // время

      т_мера t(ткст s) {
         fd = fd.init;
         return парсируйВремя(s, fd);
      }

      assert (t("20") == 2);
      assert (часы(fd) == 20);
      assert (минуты(fd)  ==  0);
      assert (секунды(fd)  ==  0);

      assert (t("30") == 0);

      assert (t("T15") == 3);
      assert (часы(fd) == 15);
      assert (минуты(fd)  ==  0);
      assert (секунды(fd)  ==  0);

      assert (t("T1") == 0);
      assert (t("T") == 0);

      assert (t("2004") == 4);
      assert (часы(fd) == 20);
      assert (минуты(fd)  ==  4);
      assert (секунды(fd)  ==  0);

      assert (t("200406") == 6);
      assert (часы(fd) == 20);
      assert (минуты(fd)  ==  4);
      assert (секунды(fd)  ==  6);

      assert (t("24:00") == 5);
      assert (fd.конецДня);
      assert (дни(fd)  == INIT_DAY + 1);
      assert (часы(fd) == 0);
      assert (минуты(fd)  == 0);
      assert (секунды(fd)  == 0);

      assert (t("00:00") == 5);
      assert (часы(fd) == 0);
      assert (минуты(fd)  == 0);
      assert (секунды(fd)  == 0);

      assert (t("23:59:60") == 8);
      assert (часы(fd)  == 23);
      assert (минуты(fd)   == 59);
      assert (секунды(fd)   == 59);
      assert (fd.сек == 60);

      assert (t("12:3456") == 5);
      assert (часы(fd) == 12);
      assert (минуты(fd)  == 34);

      assert (t("1234:56") == 4);
      assert (часы(fd) == 12);
      assert (минуты(fd)  == 34);

      assert (t("16:49:30,001") == 12);
      assert (часы(fd) == 16);
      assert (минуты(fd)  == 49);
      assert (секунды(fd)  == 30);
      assert (ms(fd)    ==  1);

      assert (t("15:48:29,1") == 10);
      assert (часы(fd) ==  15);
      assert (минуты(fd)  ==  48);
      assert (секунды(fd)  ==  29);
      assert (ms(fd)    == 100);

      assert (t("02:10:34,a") ==  8);
      assert (часы(fd) ==  2);
      assert (минуты(fd)  == 10);
      assert (секунды(fd)  == 34);

      assert (t("14:50,5") == 7);
      assert (часы(fd) == 14);
      assert (минуты(fd)  == 50);
      assert (секунды(fd)  == 30);

      assert (t("1540,4") == 6);
      assert (часы(fd) == 15);
      assert (минуты(fd)  == 40);
      assert (секунды(fd)  == 24);

      assert (t("1250,") == 4);
      assert (часы(fd) == 12);
      assert (минуты(fd)  == 50);

      assert (t("14,5") == 4);
      assert (часы(fd) == 14);
      assert (минуты(fd)  == 30);

      assert (t("12,") == 2);
      assert (часы(fd) == 12);
      assert (минуты(fd)  ==  0);

      assert (t("24:00:01") == 5);
      assert (fd.конецДня);
      assert (часы(fd) == 0);
      assert (минуты(fd)  == 0);
      assert (секунды(fd)  == 0);

      assert (t("12:34+:56") == 5);
      assert (часы(fd) == 12);
      assert (минуты(fd)  == 34);
      assert (секунды(fd)  ==  0);

      // время zones

      assert (t("14:45:15Z") == 9);
      assert (часы(fd) == 14);
      assert (минуты(fd)  == 45);
      assert (секунды(fd)  == 15);

      assert (t("23Z") == 3);
      assert (часы(fd) == 23);
      assert (минуты(fd)  ==  0);
      assert (секунды(fd)  ==  0);

      assert (t("21:32:43-12:34") == 14);
      assert (дни(fd)  == INIT_DAY + 1);
      assert (часы(fd) == 10);
      assert (минуты(fd)  ==  6);
      assert (секунды(fd)  == 43);

      assert (t("12:34,5+00:00") == 13);
      assert (часы(fd) == 12);
      assert (минуты(fd)  == 34);
      assert (секунды(fd)  == 30);

      assert (t("03:04+07") == 8);
      assert (часы(fd) == 20);
      assert (минуты(fd)  ==  4);
      assert (секунды(fd)  ==  0);

      assert (t("11,5+") == 4);
      assert (часы(fd) == 11);
      assert (минуты(fd)  == 30);

      assert (t("07-") == 2);
      assert (часы(fd) == 7);

      assert (t("06:12,7-") == 7);
      assert (часы(fd) ==  6);
      assert (минуты(fd)  == 12);
      assert (секунды(fd)  == 42);

      assert (t("050403,2+") == 8);
      assert (часы(fd) ==   5);
      assert (минуты(fd)  ==   4);
      assert (секунды(fd)  ==   3);
      assert (ms(fd)    == 200);

      assert (t("061656-") == 6);
      assert (часы(fd) ==  6);
      assert (минуты(fd)  == 16);
      assert (секунды(fd)  == 56);

      // дата and время together

      т_мера b(ткст s) {
         fd = fd.init;
         return парсируйДатуИВремя(s, fd);
      }

      assert (b("2007-08-09T12:34:56") == 19);
      assert (годы(fd)  == 2007);
      assert (месяцы(fd) ==    8);
      assert (дни(fd)   ==    9);
      assert (часы(fd)  ==   12);
      assert (минуты(fd)   ==   34);
      assert (секунды(fd)   ==   56);

      assert (b("1985W155T235030,768") == 19);
      assert (годы(fd)  == 1985);
      assert (месяцы(fd) ==    4);
      assert (дни(fd)   ==   12);
      assert (часы(fd)  ==   23);
      assert (минуты(fd)   ==   50);
      assert (секунды(fd)   ==   30);
      assert (ms(fd)     ==  768);

      // время zones

      assert (b("2009-08-07T01:02:03Z") == 20);
      assert (годы(fd)  == 2009);
      assert (месяцы(fd) ==    8);
      assert (дни(fd)   ==    7);
      assert (часы(fd)  ==    1);
      assert (минуты(fd)   ==    2);
      assert (секунды(fd)   ==    3);

      assert (b("2007-08-09T03:02,5+04:56") == 24);
      assert (годы(fd)  == 2007);
      assert (месяцы(fd) ==    8);
      assert (дни(fd)   ==    8);
      assert (часы(fd)  ==   22);
      assert (минуты(fd)   ==    6);
      assert (секунды(fd)   ==   30);

      assert (b("20000228T2330-01") == 16);
      assert (годы(fd)  == 2000);
      assert (месяцы(fd) ==    2);
      assert (дни(fd)   ==   29);
      assert (часы(fd)  ==    0);
      assert (минуты(fd)   ==   30);
      assert (секунды(fd)   ==    0);

      assert (b("2007-01-01T00:00+01") == 19);
      assert (годы(fd)  == 2006);
      assert (месяцы(fd) ==   12);
      assert (дни(fd)   ==   31);
      assert (часы(fd)  ==   23);
      assert (минуты(fd)   ==    0);
      assert (секунды(fd)   ==    0);

      assert (b("2007-12-31T23:00-01") == 19);
      assert (fd.конецДня);
      assert (годы(fd)  == 2008);
      assert (месяцы(fd) ==    1);
      assert (дни(fd)   ==    1);
      assert (часы(fd)  ==    0);
      assert (минуты(fd)   ==    0);
      assert (секунды(fd)   ==    0);

      assert (b("2007-12-31T23:01-01") == 19);
      assert (!fd.конецДня);
      assert (годы(fd)  == 2008);
      assert (месяцы(fd) ==    1);
      assert (дни(fd)   ==    1);
      assert (часы(fd)  ==    0);
      assert (минуты(fd)   ==    1);
      assert (секунды(fd)   ==    0);

      assert (b("1902-03-04T1a") == 0);
      assert (b("1902-03-04T10:aa") == 0);
      assert (b("1902-03-04T10:1aa") == 0);
      assert (b("200512-01T10:02") == 0);
      assert (b("1985-04-1210:15:30+04:00") == 0);
      assert (b("1985-04-12T10:15:30+0400") == 0);
      assert (b("19020304T05:06:07") == 0);
      assert (b("1902-03-04T050607") == 0);
      assert (b("19020304T05:06:07abcd") == 0);
      assert (b("1902-03-04T050607abcd") == 0);

      assert (b("1985-04-12T10:15:30-05:4") == 22);
      assert (годы(fd)  == 1985);
      assert (месяцы(fd) ==    4);
      assert (дни(fd)   ==   12);
      assert (часы(fd)  ==   15);
      assert (минуты(fd)   ==   15);
      assert (секунды(fd)   ==   30);
      assert (b("2009-04-13T23:00-01") == 19);
      assert (fd.конецДня);
      assert (годы(fd)  == 2009);
      assert (месяцы(fd) ==    4);
      assert (дни(fd)   ==   14);
      assert (часы(fd)  ==    0);
      assert (минуты(fd)   ==    0);
      assert (секунды(fd)   ==    0);
      assert (b("2009-04-13T24:00Z") == 17);
      assert (fd.конецДня);
      assert (годы(fd)  == 2009);
      assert (месяцы(fd) ==    4);
      assert (дни(fd)   ==   14);
      assert (часы(fd)  ==    0);
      assert (минуты(fd)   ==    0);
      assert (секунды(fd)   ==    0);

      // unimplemented: intervals, durations, recurring intervals

      debug (Tango_ISO8601_Valgrind) {
         т_мера valgrind(т_мера delegate(ткст) f, ткст s) {
            auto p = cast(сим*)malloc(s.length);
            auto ps = p[0..s.length];
            ps[] = s[];
            auto результат = f(ps);
            free(p);
            return результат;
         }
         т_мера vd(ткст s) {
            т_мера дата(ткст ss) { return d(ss); }
            return valgrind(&дата, s);
         }
         т_мера vt(ткст s) { return valgrind(&t, s); }
         т_мера vb(ткст s) { return valgrind(&b, s); }

         assert (vd("1") == 0);
         assert (vd("19") == 2);
         assert (vd("199") == 0);
         assert (vd("1999") == 4);
         assert (vd("1999-") == 4);
         assert (vd("1999-W") == 4);
         assert (vd("1999-W0") == 4);
         assert (vd("1999-W01") == 8);
         assert (vd("1999-W01-") == 8);
         assert (vd("1999-W01-3") == 10);
         assert (vd("1999W") == 4);
         assert (vd("1999W0") == 4);
         assert (vd("1999W01") == 7);
         assert (vd("1999W01-") == 7);
         assert (vd("1999W01-3") == 7);
         assert (vd("1999W013") == 8);
         assert (vd("1999-0") == 4);
         assert (vd("1999-01") == 7);
         assert (vd("1999-01-") == 7);
         assert (vd("1999-01-0") == 7);
         assert (vd("1999-01-01") == 10);
         assert (vd("1999-0101") == 7);
         assert (vd("1999-365") == 8);
         assert (vd("1999365") == 7);

         assert (vt("1") == 0);
         assert (vt("15") == 2);
         assert (vt("15:") == 2);
         assert (vt("15:3") == 2);
         assert (vt("15:30") == 5);
         assert (vt("153") == 2);
         assert (vt("1530") == 4);
         assert (vt("1530:") == 4);
         assert (vt("15304") == 4);
         assert (vt("153045") == 6);
         assert (vt("15:30:") == 5);
         assert (vt("15:30:4") == 5);
         assert (vt("15:30:45") == 8);
         assert (vt("T15") == 3);
         assert (vt("T1") == 0);
         assert (vt("T") == 0);
         assert (vt("15,") == 2);
         assert (vt("15,2") == 4);
         assert (vt("1530,") == 4);
         assert (vt("1530,2") == 6);
         assert (vt("15:30:45,") == 8);
         assert (vt("15:30:45,2") == 10);
         assert (vt("153045,") == 6);
         assert (vt("153045,2") == 8);
         assert (vt("153045,22") == 9);
         assert (vt("153045,222") == 10);
         assert (vt("15Z") == 3);
         assert (vt("15+") == 2);
         assert (vt("15-") == 2);
         assert (vt("15+0") == 2);
         assert (vt("15+00") == 5);
         assert (vt("15+00:") == 5);
         assert (vt("15+00:0") == 5);
         assert (vt("15+00:00") == 8);
         assert (vb("1999-01-01") == 0);
         assert (vb("1999-01-01T") == 0);
         assert (vb("1999-01-01T15:30:45") == 19);
      }
   }
}
