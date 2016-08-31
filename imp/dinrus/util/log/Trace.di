/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Oct 2007: Initial release

        author:         Kris

        Synchronized, formatted console вывод. This can be использован in lieu
        of да logging where appropriate.

        След exposes this стиль of usage:
        ---
        След.форматируй ("abc {}", 1);             => abc 1
        След.форматируй ("abc {}:{}", 1, 2);       => abc 1:2
        След.форматируй ("abc {1}:{0}", 1, 2);     => abc 2:1
        ---

        Special character sequences, such as "\n", are записано directly в_
        the вывод without any translation (though an вывод-фильтр could
        be inserted в_ perform translation as требуется). Platform-specific
        newlines are generated instead via the форматнс() метод, which also
        flushes the вывод when configured в_ do so:
        ---
        След.форматнс ("hello {}", "world");
        ---

        Explicitly flushing the вывод is achieved via a слей() метод
        ---
        След.форматируй ("hello {}", "world").слей;
        ---

*******************************************************************************/

module util.log.Trace;

private import io.Console;

private import io.model;

private import text.convert.Layout;

/*******************************************************************************

        Construct След when this module is загружен

*******************************************************************************/

/// global след экземпляр
public static СинхПринт След;

static this();

/*******************************************************************************

        Intended for internal use only

*******************************************************************************/

private class СинхПринт
{
        private Объект          стопор;
        private ИПотокВывода    вывод;
        private Выкладка!(сим)   преобразуй;
        private бул            слитьСтроки;

        version (Win32)
                 private const ткст Кс = "\r\n";
             else
                private const ткст Кс = "\n";

        /**********************************************************************

                Construct a Print экземпляр, tying the provопрed поток
                в_ a выкладка форматёр

        **********************************************************************/

        this (ИПотокВывода вывод, бул слей=нет);

        /**********************************************************************

                Выкладка using the provопрed formatting specification

        **********************************************************************/

        final СинхПринт форматируй (ткст фмт, ...);

        /**********************************************************************

                Выкладка using the provопрed formatting specification

        **********************************************************************/

        final СинхПринт форматнс (ткст фмт, ...);

        /**********************************************************************

               Flush the вывод поток

        **********************************************************************/

        final проц слей ();
		
        /**********************************************************************

                Сток for passing в_ the форматёр

        **********************************************************************/

        private final бцел сток (ткст s);

        /**********************************************************************

                Print a range of необр память as a hex dump.
                Characters in range 0x20..0x7E are printed, все другие are
                shown as dots.

                ----
000000:  47 49 46 38  39 61 10 00  10 00 80 00  00 48 5D 8C  GIF89a.......H].
000010:  FF FF FF 21  F9 04 01 00  00 01 00 2C  00 00 00 00  ...!.......,....
000020:  10 00 10 00  00 02 11 8C  8F A9 CB ED  0F A3 84 C0  ................
000030:  D4 70 A7 DE  BC FB 8F 14  00 3B                     .p.......;
                ----

        **********************************************************************/

        final СинхПринт память (проц[] mem);
}
