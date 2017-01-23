/*******************************************************************************

        Copyright: Copyright (C) 2008 Kris Bell, все rights reserved

        License:   BSD стиль: $(LICENSE)

        version:   July 2008: Initial release

        Authors:   Kris

*******************************************************************************/

module text.json.JsonEscape;

private import text.json.JsonParser;

private import Util = text.Util;

private import Utf = text.convert.Utf;

/******************************************************************************

        Convert 'escaped' симвы в_ нормаль ones. For example: \\ => \

        The provопрed вывод буфер should be at least as дол as the 
        ввод ткст, or it will be allocated из_ the куча instead.

        Returns a срез of приёмн where the контент требуется conversion, 
        or the provопрed ист otherwise
        
******************************************************************************/

T[] убериИскейп(T) (T[] ист, T[] приёмн = пусто)
{
        т_мера контент;

        проц добавь (T[] s)
        {
                if (контент + s.length > приёмн.length)
                    приёмн.length = приёмн.length + s.length + 1024;
                приёмн[контент .. контент+s.length] = s;
                контент += s.length;
        }

        убериИскейп (ист, &добавь);
        return приёмн [0 .. контент];
}


/******************************************************************************

        Convert reserved симвы в_ escaped ones. For example: \ => \\ 

        Either a срез of the provопрed вывод буфер is returned, or the 
        original контент, depending on whether there were reserved симвы
        present or not. The вывод буфер will be expanded as necessary
        
******************************************************************************/

T[] escape(T) (T[] ист, T[] приёмн = пусто)
{
        т_мера контент;

        проц добавь (T[] s)
        {
                if (контент + s.length > приёмн.length)
                    приёмн.length = приёмн.length + s.length + 1024;
                приёмн[контент .. контент+s.length] = s;
                контент += s.length;
        }

        escape (ист, &добавь);
        return приёмн [0..контент];
}


/******************************************************************************

        Convert 'escaped' симвы в_ нормаль ones. For example: \\ => \

        This variant does not require an interim workspace, и instead
        излейs directly via the provопрed delegate
              
******************************************************************************/

проц убериИскейп(T) (T[] ист, проц delegate(T[]) излей)
{
        цел delta;
        auto s = ист.ptr;
        auto длин = ист.length;
        enum:T {slash = '\\'};

        // возьми a Просмотр первый в_ see if there's anything
        if ((delta = Util.индексУ (s, slash, длин)) < длин)
           {
           // копируй segments over, a чанк at a время
           do {
              излей (s[0 .. delta]);
              длин -= delta;
              s += delta;

              // bogus trailing '\'
              if (длин < 2)
                 {
                 излей ("\\");
                 длин = 0;
                 break;
                 }

              // translate \c
              switch (s[1])
                     {
                      case '\\':
                           излей ("\\");
                           break;

                      case '/':
                           излей ("/");
                           break;

                      case '"':
                           излей (`"`);
                           break;

                      case 'b':
                           излей ("\b");
                           break;

                      case 'f':
                           излей ("\f");
                           break;

                      case 'n':
                           излей ("\n");
                           break;

                      case 'r':
                           излей ("\r");
                           break;

                      case 't':
                           излей ("\t");
                           break;

                      case 'u':
                           if (длин < 6)
                               goto default;
                           else
                              {
                              дим v = 0;
                              T[6]  t =void;

                              for (auto i=2; i < 6; ++i)
                                  {
                                  auto c = s[i];
                                  if (c >= '0' && c <= '9')
                                     {}
                                  else
                                     if (c >= 'a' && c <= 'f')
                                         c -= 39;
                                     else
                                        if (c >= 'A' && c <= 'F')
                                            c -= 7;
                                        else
                                           goto default;
                                  v = (v << 4) + c - '0';
                                  }
                              
                              излей (Utf.изТкст32 ((&v)[0..1], t));
                              длин -= 4;
                              s += 4;
                              }
                           break;

                      default:
                           throw new Исключение ("не_годится escape");
                     }

              s += 2;
              длин -= 2;           
              } while ((delta = Util.индексУ (s, slash, длин)) < длин);

           // копируй хвост too
           излей (s [0 .. длин]);
           }
        else
           излей (ист);
}


/******************************************************************************

        Convert reserved симвы в_ escaped ones. For example: \ => \\ 

        This variant does not require an interim workspace, и instead
        излейs directly via the provопрed delegate
        
******************************************************************************/

проц escape(T) (T[] ист, проц delegate(T[]) излей)
{
        T[2] patch = '\\';
        auto s = ист.ptr;
        auto t = s;
        auto e = s + ист.length;

        while (s < e)
              {
              switch (*s)
                     {
                     case '"':
                     case '/':
                     case '\\':
                          patch[1] = *s;
                          break;
                     case '\r':
                          patch[1] = 'r';
                          break;
                     case '\n':
                          patch[1] = 'n';
                          break;
                     case '\t':
                          patch[1] = 't';
                          break;
                     case '\b':
                          patch[1] = 'b';
                          break;
                     case '\f':
                          patch[1] = 'f';
                          break;
                     default:
                          ++s;
                          continue;
                     }
              излей (t [0 .. s - t]);
              излей (patch);
              t = ++s;
              }

        // dопр we change anything? Copy хвост also
        if (t is ист.ptr)
            излей (ист);
        else
           излей (t [0 .. e - t]);
}


/******************************************************************************

******************************************************************************/

debug (JsonEscape)
{
        import io.Stdout;

        проц main()
        {
                escape ("abc");
                assert (escape ("abc") == "abc");
                assert (escape ("/abc") == `\/abc`, escape ("/abc"));
                assert (escape ("ab\\c") == `ab\\c`, escape ("ab\\c"));
                assert (escape ("abc\"") == `abc\"`);
                assert (escape ("abc/") == `abc\/`);
                assert (escape ("\n\t\r\b\f") == `\n\t\r\b\f`);

                убериИскейп ("abc");
                убериИскейп ("abc\\u0020x", (ткст p){Стдвыв(p);});
                assert (убериИскейп ("abc") == "abc");
                assert (убериИскейп ("abc\\") == "abc\\");
                assert (убериИскейп ("abc\\t") == "abc\t");
                assert (убериИскейп ("abc\\tc") == "abc\tc");
                assert (убериИскейп ("\\t") == "\t");
                assert (убериИскейп ("\\tx") == "\tx");
                assert (убериИскейп ("\\r\\rx") == "\r\rx");
                assert (убериИскейп ("abc\\t\\n\\bc") == "abc\t\n\bc");

                assert (убериИскейп ("abc\"\\n\\bc") == "abc\"\n\bc");
                assert (убериИскейп ("abc\\u002bx") == "abc+x");
        }

}

