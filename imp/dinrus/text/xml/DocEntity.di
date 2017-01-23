/*******************************************************************************

        Copyright: Copyright (C) 2008 Kris Bell.  все rights reserved.

        License:   BSD стиль: $(LICENSE)

        version:   Aug 2008: Initial release

        Authors:   Kris

*******************************************************************************/

module text.xml.DocEntity;

private import Util = text.Util;

/******************************************************************************

        Convert XML сущность образцы в_ нормаль characters
        
        <pre>
        &amp; => ;
        &quot; => "
        etc.
        </pre>
        
******************************************************************************/

T[] изСущности (T) (T[] ист, T[] приёмн = пусто)
{
        цел delta;
        auto s = ист.ptr;
        auto длин = ист.length;

        // возьми a Просмотр первый в_ see if there's anything
        if ((delta = Util.индексУ (s, '&', длин)) < длин)
           {
           // сделай some room if not enough provопрed
           if (приёмн.length < ист.length)
               приёмн.length = ист.length;
           auto d = приёмн.ptr;

           // копируй segments over, a чанк at a время
           do {
              d [0 .. delta] = s [0 .. delta];
              длин -= delta;
              s += delta;
              d += delta;

              // translate сущность
              auto токен = 0;

              switch (s[1])
                     {
                      case 'a':
                           if (длин > 4 && s[1..5] == "amp;")
                               *d++ = '&', токен = 5;
                           else
                           if (длин > 5 && s[1..6] == "apos;")
                               *d++ = '\'', токен = 6;
                           break;
                           
                      case 'g':
                           if (длин > 3 && s[1..4] == "gt;")
                               *d++ = '>', токен = 4;
                           break;
                           
                      case 'l':
                           if (длин > 3 && s[1..4] == "lt;")
                               *d++ = '<', токен = 4;
                           break;
                           
                      case 'q':
                           if (длин > 5 && s[1..6] == "quot;")
                               *d++ = '"', токен = 6;
                           break;

                      default:
                           break;
                     }

              if (токен is 0)
                  *d++ = '&', токен = 1;

              s += токен, длин -= токен;
              } while ((delta = Util.индексУ (s, '&', длин)) < длин);

           // копируй хвост too
           d [0 .. длин] = s [0 .. длин];
           return приёмн [0 .. (d + длин) - приёмн.ptr];
           }
        return ист;
}


/******************************************************************************

        Convert XML сущность образцы в_ нормаль characters
        ---
        &amp; => ;
        &quot => "
        etc
        ---
        
        This variant does not require an interim workspace, и instead
        излейs directly via the provопрed delegate
              
******************************************************************************/

проц изСущности (T) (T[] ист, проц delegate(T[]) излей)
{
        цел delta;
        auto s = ист.ptr;
        auto длин = ист.length;

        // возьми a Просмотр первый в_ see if there's anything
        if ((delta = Util.индексУ (s, '&', длин)) < длин)
           {
           // копируй segments over, a чанк at a время
           do {
              излей (s [0 .. delta]);
              длин -= delta;
              s += delta;

              // translate сущность
              auto токен = 0;

              switch (s[1])
                     {
                      case 'a':
                           if (длин > 4 && s[1..5] == "amp;")
                               излей("&"), токен = 5;
                           else
                           if (длин > 5 && s[1..6] == "apos;")
                               излей("'"), токен = 6;
                           break;
                           
                      case 'g':
                           if (длин > 3 && s[1..4] == "gt;")
                               излей(">"), токен = 4;
                           break;
                           
                      case 'l':
                           if (длин > 3 && s[1..4] == "lt;")
                               излей("<"), токен = 4;
                           break;
                           
                      case 'q':
                           if (длин > 5 && s[1..6] == "quot;")
                               излей("\""), токен = 6;
                           break;

                      default:
                           break;
                     }

              if (токен is 0)
                  излей ("&"), токен = 1;

              s += токен, длин -= токен;
              } while ((delta = Util.индексУ (s, '&', длин)) < длин);

           // копируй хвост too
           излей (s [0 .. длин]);
           }
        else
           излей (ист);
}


/******************************************************************************

        Convert reserved симвы в_ entities. For example: " => &quot; 

        Either a срез of the provопрed вывод буфер is returned, or the 
        original контент, depending on whether there were reserved симвы
        present or not. The вывод буфер should be sufficiently large в_  
        accomodate the преобразованый вывод, or it will be allocated из_ the 
        куча instead 
        
******************************************************************************/

T[] вСущность(T) (T[] ист, T[] приёмн = пусто)
{
        T[]  сущность;
        auto s = ист.ptr;
        auto t = s;
        auto e = s + ист.length;
        auto индекс = 0;

        while (s < e)
               switch (*s)
                      {
                      case '"':
                           сущность = "&quot;";
                           goto common;

                      case '>':
                           сущность = "&gt;";
                           goto common;

                      case '<':
                           сущность = "&lt;";
                           goto common;

                      case '&':
                           сущность = "&amp;";
                           goto common;

                      case '\'':
                           сущность = "&apos;";
                           goto common;

                      common:
                           auto длин = s - t;
                           if (приёмн.length <= индекс + длин + сущность.length)
                               приёмн.length = (приёмн.length + длин + сущность.length) + приёмн.length / 2;

                           приёмн [индекс .. индекс + длин] = t [0 .. длин];
                           индекс += длин;

                           приёмн [индекс .. индекс + сущность.length] = сущность;
                           индекс += сущность.length;
                           t = ++s;
                           break;

                      default:
                           ++s;
                           break;
                      }


        // dопр we change anything?
        if (индекс)
           {
           // копируй хвост too
           auto длин = e - t;
           if (приёмн.length <= индекс + длин)
               приёмн.length = индекс + длин;

           приёмн [индекс .. индекс + длин] = t [0 .. длин];
           return приёмн [0 .. индекс + длин];
           }

        return ист;
}


/******************************************************************************

        Convert reserved симвы в_ entities. For example: " => &quot; 

        This variant does not require an interim workspace, и instead
        излейs directly via the provопрed delegate
        
******************************************************************************/

проц вСущность(T) (T[] ист, проц delegate(T[]) излей)
{
        T[]  сущность;
        auto s = ист.ptr;
        auto t = s;
        auto e = s + ист.length;

        while (s < e)
               switch (*s)
                      {
                      case '"':
                           сущность = "&quot;";
                           goto common;

                      case '>':
                           сущность = "&gt;";
                           goto common;

                      case '<':
                           сущность = "&lt;";
                           goto common;

                      case '&':
                           сущность = "&amp;";
                           goto common;

                      case '\'':
                           сущность = "&apos;";
                           goto common;

                      common:
                           if (s - t > 0)
                               излей (t [0 .. s - t]);
                           излей (сущность);
                           t = ++s;
                           break;

                      default:
                           ++s;
                           break;
                      }

        // dопр we change anything? Copy хвост also
        if (сущность.length)
            излей (t [0 .. e - t]);
        else
           излей (ист);
}



/*******************************************************************************

*******************************************************************************/

debug (DocEntity)
{
        import io.Console;

        проц main()
        {
                auto s = изСущности ("&amp;");
                assert (s == "&");
                s = изСущности ("&quot;");
                assert (s == "\"");
                s = изСущности ("&apos;");
                assert (s == "'");
                s = изСущности ("&gt;");
                assert (s == ">");
                s = изСущности ("&lt;");
                assert (s == "<");
                s = изСущности ("&lt;&amp;&apos;");
                assert (s == "<&'");
                s = изСущности ("*&lt;&amp;&apos;*");
                assert (s == "*<&'*");

                assert (изСущности ("abc") == "abc");
                assert (изСущности ("abc&") == "abc&");
                assert (изСущности ("abc&lt;") == "abc<");
                assert (изСущности ("abc&gt;goo") == "abc>goo");
                assert (изСущности ("&amp;") == "&");
                assert (изСущности ("&quot;&apos;") == "\"'");
                assert (изСущности ("&q&s") == "&q&s");

                auto d = вСущность (">");
                assert (d == "&gt;");
                d = вСущность ("<");
                assert (d == "&lt;");
                d = вСущность ("&");
                assert (d == "&amp;");
                d = вСущность ("'");
                assert (d == "&apos;");
                d = вСущность ("\"");
                assert (d == "&quot;");
                d = вСущность ("^^>*>*");
                assert (d == "^^&gt;*&gt;*");
        }
}
