/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: April 2007

        author:         Kris

*******************************************************************************/

module sys.win32.CodePage;
//pragma(lib,"drTango");

private import sys.Common;

private import exception;

/*******************************************************************************

        Convert текст в_ and из_ Windows 'код pages'. This is non-portable,
        and will be unlikely в_ operate even across все Windows platforms.

*******************************************************************************/

struct CodePage
{
        /**********************************************************************

                Test a текст Массив в_ see if it содержит non-аски elements.
                Returns да if аски, нет otherwise

        **********************************************************************/

        static бул isAscii (ткст ист)
        {
                foreach (c; ист)
                         if (c & 0x80)
                             return нет;
                return да;
        }


        /**********************************************************************

                Convert utf8 текст в_ a codepage representation

                страница  0     - the ansi код страница
                      1     - the oem код страница
                      2     - the mac код страница
                      3     - ansi код страница for the calling нить
                      65000 - UTF-7 translation
                      65001 - UTF-8 translation

                      or a region-specific codepage

                returns: a срез of the provопрed вывод буфер
                         representing преобразованый текст

                Note that the ввод must be utf8 кодирован. Note also
                that the приёмн вывод should be sufficiently large в_
                accomodate the вывод; a размер of 2*ист.length would
                be enough в_ хост almost any conversion

        **********************************************************************/

        static ткст преобр_в (ткст ист, ткст приёмн, бцел страница=0)
        {
                return преобразуй (ист, приёмн, CP_UTF8, страница);
        }


        /**********************************************************************

                Convert codepage текст в_ a utf8 representation

                страница  0     - the ansi код страница
                      1     - the oem код страница
                      2     - the mac код страница
                      3     - ansi код страница for the calling нить
                      65000 - UTF-7 translation
                      65001 - UTF-8 translation

                      or a region-specific codepage

                returns: a срез of the provопрed вывод буфер
                         representing преобразованый текст

                Note that the ввод will be utf8 кодирован. Note also
                that the приёмн вывод should be sufficiently large в_
                accomodate the вывод; a размер of 2*ист.length would
                be enough в_ хост almost any conversion

        **********************************************************************/

        static ткст из_ (ткст ист, ткст приёмн, бцел страница=0)
        {
                return преобразуй (ист, приёмн, страница, CP_UTF8);
        }


        /**********************************************************************

                Internal conversion routine; we avoопр куча activity for
                strings of крат and medium length. A zero is appended
                в_ the приёмн Массив in order в_ simplify C API conversions

        **********************************************************************/

        private static ткст преобразуй (ткст ист, ткст приёмн, бцел из_, бцел преобр_в)
        {
                бцел длин = 0;

                // sanity check
                assert (приёмн.length);

                // got some ввод?
                if (ист.length > 0)
                   {
                   шим[2000] врем =void;
                   шим[] wide = (ист.length <= врем.length) ? врем : new шим[ист.length];

                   длин = MultiByteToWideChar (из_, 0, cast(PCHAR)ист.ptr, ист.length,
                                              wide.ptr, wide.length);
                   if (длин)
                       длин = WideCharToMultiByte (преобр_в, 0, wide.ptr, длин,
                                                  cast(PCHAR)приёмн.ptr, приёмн.length-1, пусто, пусто);
                   if (длин is 0)
                       throw new ИсклНелегальногоАргумента ("CodePage.преобразуй :: "~СисОш.последнСооб);
                   }

                // добавь a пусто terminator
                приёмн[длин] = 0;
                return приёмн [0 .. длин];
        }
}


debug(Test)
{
        проц main ()
        {
                ткст s = "foo";
                сим[3] x =void;

                //if (! CodePage.isAscii (s))
                      s = CodePage.преобр_в (s, x);
                      s = CodePage.из_ (s, x);
        }
}
