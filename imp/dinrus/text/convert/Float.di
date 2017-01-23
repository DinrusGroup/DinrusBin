/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
        
        version:        Nov 2005: Initial release
                        Jan 2010: добавьed internal ecvt() 

        author:         Kris

        A установи of functions for converting between ткст и floating-
        точка значения.

        Applying the D "import alias" mechanism в_ this module is highly
        recommended, in order в_ предел namespace pollution:
        ---
        import Float = text.convert.Float;

        auto f = Float.разбор ("3.14159");
        ---
        
*******************************************************************************/

module text.convert.Float;

private import exception;

/******************************************************************************

        выбери an internal version
                
******************************************************************************/

version = float_internal;

private alias реал ЧисТип;

/******************************************************************************

        optional math functions
                
******************************************************************************/

private extern (C)
{
        дво лог10 (дво x);
        дво потолок (дво num);
        дво modf (дво num, дво *i);
        дво степень  (дво основа, дво эксп);

        реал log10l (реал x);
        реал ceill (реал num);
        реал modfl (реал num, реал *i);
        реал powl  (реал основа, реал эксп);

        цел printf (сим*, ...);
        version (Windows)
                {
                alias ecvt econvert;
                alias ecvt fconvert;
                }
        else
           {
           alias ecvtl econvert;
           alias ecvtl fconvert;
           }

        сим* ecvt (дво d, цел цифры, цел* decpt, цел* знак);
        сим* fcvt (дво d, цел цифры, цел* decpt, цел* знак);
        сим* ecvtl (реал d, цел цифры, цел* decpt, цел* знак);
        сим* fcvtl (реал d, цел цифры, цел* decpt, цел* знак);
}

/******************************************************************************

        Constants
                
******************************************************************************/

private enum 
{
        Pad = 0,                // default trailing decimal zero
        Dec = 2,                // default decimal places
        Exp = 10,               // default switch в_ scientific notation
}

/******************************************************************************

        Convert a formatted ткст of цифры в_ a floating-точка
        число. Throws an исключение where the ввод текст is not
        parsable in its entirety.
        
******************************************************************************/

ЧисТип вПлав(T) (T[] ист)
{
        бцел длин;

        auto x = разбор (ист, &длин);
        if (длин < ист.length || длин == 0)
            throw new ИсклНелегальногоАргумента ("Float.вПлав :: не_годится число");
        return x;
}

/******************************************************************************

        Template wrapper в_ сделай life simpler. Returns a текст version
        of the provопрed значение.

        See форматируй() for details

******************************************************************************/

ткст вТкст (ЧисТип d, бцел decimals=Dec, цел e=Exp);
               
/******************************************************************************

        Template wrapper в_ сделай life simpler. Returns a текст version
        of the provопрed значение.

        See форматируй() for details

******************************************************************************/

шим[] вТкст16 (ЧисТип d, бцел decimals=Dec, цел e=Exp);
               
/******************************************************************************

        Template wrapper в_ сделай life simpler. Returns a текст version
        of the provопрed значение.

        See форматируй() for details

******************************************************************************/

дим[] вТкст32 (ЧисТип d, бцел decimals=Dec, цел e=Exp);
               
/******************************************************************************

        Truncate trailing '0' и '.' из_ a ткст, such that 200.000 
        becomes 200, и 20.10 becomes 20.1

        Returns a potentially shorter срез of что you give it.

******************************************************************************/

T[] упрости(T) (T[] s)
{
        auto врем = s;
        цел i = врем.length;
        foreach (цел индкс, T c; врем)
                 if (c is '.')
                     while (--i >= индкс)
                            if (врем[i] != '0')
                               {  
                               if (врем[i] is '.')
                                   --i;
                               s = врем [0 .. i+1];
                               while (--i >= индкс)
                                      if (врем[i] is 'e')
                                          return врем;
                               break;
                               }
        return s;
}

/******************************************************************************

        Extract a знак-bit

******************************************************************************/

private бул негатив (ЧисТип x);


/******************************************************************************

        Convert a floating-точка число в_ a ткст. 

        The e parameter controls the число of exponent places излейted, 
        и can thus control where the вывод switches в_ the scientific 
        notation. For example, настройка e=2 for 0.01 or 10.0 would результат
        in нормаль вывод. Whereas настройка e=1 would результат in Всё those
        значения being rendered in scientific notation instead. Setting e
        в_ 0 forces that notation on for everything. Parameter pad will
        добавь trailing '0' decimals when установи ~ otherwise trailing '0's 
        will be elопрed

******************************************************************************/

T[] форматируй(T, D=ЧисТип, U=цел) (T[] приёмн, D x, U decimals=Dec, U e=Exp, бул pad=Pad)
{return форматируй!(T)(приёмн, x, decimals, e, pad);}

T[] форматируй(T) (T[] приёмн, ЧисТип x, цел decimals=Dec, цел e=Exp, бул pad=Pad)
{
        сим*           конец,
                        стр;
        цел             эксп,
                        знак,
                        режим=5;
        сим[32]        буф =void;

        // тест exponent в_ determine режим
        эксп = (x is 0) ? 1 : cast(цел) log10l (x < 0 ? -x : x);
        if (эксп <= -e || эксп >= e)
            режим = 2, ++decimals;

version (float_internal)
         стр = convertl (буф.ptr, x, decimals, &эксп, &знак, режим is 5);
version (float_dtoa)
         стр = dtoa (x, режим, decimals, &эксп, &знак, &конец);
version (float_lib)
        {
        if (режим is 5)
            стр = fconvert (x, decimals, &эксп, &знак);
        else
           стр = econvert (x, decimals, &эксп, &знак);
        }

        auto p = приёмн.ptr;
        if (знак)
            *p++ = '-';

        if (эксп is 9999)
            while (*стр) 
                   *p++ = *стр++;
        else
           {
           if (режим is 2)
              {
              --эксп;
              *p++ = *стр++;
              if (*стр || pad)
                 {
                 auto d = p;
                 *p++ = '.';
                 while (*стр)
                        *p++ = *стр++;
                 if (pad)
                     while (p-d < decimals)
                            *p++ = '0';
                 }
              *p++ = 'e';
              if (эксп < 0)
                  *p++ = '-', эксп = -эксп;
              else
                 *p++ = '+';
              if (эксп >= 1000)
                 {
                 *p++ = cast(T)((эксп/1000) + '0');
                 эксп %= 1000;
                 }
              if (эксп >= 100)
                 {
                 *p++ = эксп / 100 + '0';
                 эксп %= 100;
                 }
              *p++ = эксп / 10 + '0';
              *p++ = эксп % 10 + '0';
              }
           else
              {
              if (эксп <= 0)
                  *p++ = '0';
              else
                 for (; эксп > 0; --эксп)
                        *p++ = (*стр) ? *стр++ : '0';
              if (*стр || pad)
                 {
                 *p++ = '.';
                 auto d = p;
                 for (; эксп < 0; ++эксп)
                        *p++ = '0';
                 while (*стр)
                        *p++ = *стр++;
                 if (pad)
                     while (p-d < decimals)
                            *p++ = '0';
                 }
              } 
           }

        // stuff a C terminator in there too ...
        *p = 0;
        return приёмн[0..(p - приёмн.ptr)];
}


/******************************************************************************

        ecvt() и fcvt() for 80bit FP, which DMD does not include. Based
        upon the following:

        Copyright (c) 2009 Ian Piumarta
        
        все rights reserved.

        Permission is hereby granted, free of charge, в_ any person 
        obtaining a копируй of this software и associated documentation 
        файлы (the 'Software'), в_ deal in the Software without restriction, 
        включая without limitation the rights в_ use, копируй, modify, merge, 
        publish, distribute, и/or sell copies of the Software, и в_ permit 
        persons в_ whom the Software is furnished в_ do so, provопрed that the 
        above copyright notice(s) и this permission notice appear in все 
        copies of the Software.  

******************************************************************************/

version (float_internal)
{
private сим *convertl (сим* буф, реал значение, цел ndigit, цел *decpt, цел *знак, цел fflag);
}


/******************************************************************************

        David Gay's extended conversions between ткст и floating-точка
        numeric representations. Use these where you need extended accuracy
        for convertions. 

        Note that this class требует the attendent файл dtoa.c be compiled 
        и linked в_ the application

******************************************************************************/

version (float_dtoa)
{
        private extern(C)
        {
        // these should be linked in via dtoa.c
        дво strtod (сим* s00, сим** se);
        сим*  dtoa (дво d, цел режим, цел ndigits, цел* decpt, цел* знак, сим** rve);
        }

        /**********************************************************************

                Convert a formatted ткст of цифры в_ a floating-
                точка число. 

        **********************************************************************/

        ЧисТип разбор (ткст ист, бцел* ate=пусто);

        /**********************************************************************

                Convert a formatted ткст of цифры в_ a floating-
                точка число.

        **********************************************************************/

        ЧисТип разбор (шим[] ист, бцел* ate=пусто);

        /**********************************************************************

                Convert a formatted ткст of цифры в_ a floating-
                точка число. 

        **********************************************************************/

        ЧисТип разбор (дим[] ист, бцел* ate=пусто);
}
else
{
private import Целое = text.convert.Integer;

/******************************************************************************

        Convert a formatted ткст of цифры в_ a floating-точка число.
        Good for general use, but use David Gay's dtoa package if serious
        rounding adjustments should be applied.

******************************************************************************/

ЧисТип разбор(T) (T[] ист, бцел* ate=пусто)
{
        T               c;
        T*              p;
        цел             эксп;
        бул            знак;
        бцел            корень;
        ЧисТип         значение = 0.0;

        static бул сверь (T* aa, T[] bb)
        {
                foreach (b; bb)
                        {
                        auto a = *aa++;
                        if (a >= 'A' && a <= 'Z')
                            a += 'a' - 'A';
                        if (a != b)
                            return нет;
                        }
                return да;
        }

        // удали leading пространство, и знак
        p = ист.ptr + Целое.убери (ист, знак, корень);

        // bail out if the ткст is пустой
        if (ист.length is 0 || p > &ист[$-1])
            return ЧисТип.nan;
        c = *p;

        // укз non-decimal representations
        if (корень != 10)
           {
           дол v = Целое.разбор (ист, корень, ate); 
           return cast(ЧисТип) v;
           }

        // установи begin и конец проверьs
        auto begin = p;
        auto конец = ист.ptr + ист.length;

        // читай leading цифры; note that leading
        // zeros are simply multИПlied away
        while (c >= '0' && c <= '9' && p < конец)
              {
              значение = значение * 10 + (c - '0');
              c = *++p;
              }

        // gobble up the точка
        if (c is '.' && p < конец)
            c = *++p;

        // читай fractional цифры; note that we accumulate
        // все цифры ... very дол numbers impact accuracy
        // в_ a degree, but perhaps not as much as one might
        // expect. A приор version limited the цифра счёт,
        // but dопр not show marked improvement. For maximum
        // accuracy when reading и writing, use David Gay's
        // dtoa package instead
        while (c >= '0' && c <= '9' && p < конец)
              {
              значение = значение * 10 + (c - '0');
              c = *++p;
              --эксп;
              } 

        // dопр we получи something?
        if (p > begin)
           {
           // разбор base10 exponent?
           if ((c is 'e' || c is 'Е') && p < конец )
              {
              бцел eaten;
              эксп += Целое.разбор (ист[(++p-ист.ptr) .. $], 0, &eaten);
              p += eaten;
              }

           // исправь mantissa; note that the exponent имеется
           // already been adjusted for fractional цифры
           if (эксп < 0)
               значение /= pow10 (-эксп);
           else
              значение *= pow10 (эксп);
           }
        else
           if (конец - p >= 3)
               switch (*p)
                      {
                      case 'I': case 'i':
                           if (сверь (p+1, "nf"))
                              {
                              значение = значение.infinity;
                              p += 3;
                              if (конец - p >= 5 && сверь (p, "inity"))
                                  p += 5;
                              }
                           break;

                      case 'N': case 'n':
                           if (сверь (p+1, "an"))
                              {
                              значение = значение.nan;
                              p += 3;
                              }
                           break;
                      default:
                           break;
                      }

        // установи разбор length, и return значение
        if (ate)
            *ate = p - ист.ptr;

        if (знак)
            значение = -значение;
        return значение;
}

/******************************************************************************

        Internal function в_ преобразуй an exponent specifier в_ a floating
        точка значение.

******************************************************************************/

private ЧисТип pow10 (бцел эксп);
}

version (float_old)
{
/******************************************************************************

        Convert a плав в_ a ткст. This produces pretty good results
        for the most часть, though one should use David Gay's dtoa package
        for best accuracy.

        Note that the approach первый normalizes a base10 mantissa, then
        pulls цифры из_ the left sопрe whilst излейting them (rightward)
        в_ the вывод.

        The e parameter controls the число of exponent places излейted, 
        и can thus control where the вывод switches в_ the scientific 
        notation. For example, настройка e=2 for 0.01 or 10.0 would результат
        in нормаль вывод. Whereas настройка e=1 would результат in Всё those
        значения being rendered in scientific notation instead. Setting e
        в_ 0 forces that notation on for everything.

        TODO: this should be replaced, as it is not sufficiently accurate 

******************************************************************************/

T[] форматируй(T, D=дво, U=бцел) (T[] приёмн, D x, U decimals=Dec, цел e=Exp, бул pad=Pad)
{return форматируй!(T)(приёмн, x, decimals, e, pad);}

T[] форматируй(T) (T[] приёмн, ЧисТип x, бцел decimals=Dec, цел e=Exp, бул pad=Pad)
{
        static T[] inf = "-inf";
        static T[] nan = "-nan";

        // откинь цифры из_ the left of a normalized основа-10 число
        static цел toDigit (ref ЧисТип v, ref цел счёт)
        {
                цел цифра;

                // Don't exceed max цифры storable in a реал
                // (-1 because the последний цифра is not always storable)
                if (--счёт <= 0)
                    цифра = 0;
                else
                   {
                   // удали leading цифра, и bump
                   цифра = cast(цел) v;
                   v = (v - цифра) * 10.0;
                   }
                return цифра + '0';
        }

        // выкинь the знак
        бул знак = негатив (x);
        if (знак)
            x = -x;

        if (x !<>= x)
            return знак ? nan : nan[1..$];

        if (x is x.infinity)
            return знак ? inf : inf[1..$];

        // assume no exponent
        цел эксп = 0;
        цел абс = 0;

        // don't шкала if zero
        if (x > 0.0)
           {
           // выкинь base10 exponent
           эксп = cast(цел) log10l (x);

           // округли up a bit
           auto d = decimals;
           if (эксп < 0)
               d -= эксп;
           x += 0.5 / pow10 (d);

           // нормализуй base10 mantissa (0 < m < 10)
           абс = эксп = cast(цел) log10l (x);
           if (эксп > 0)
               x /= pow10 (эксп);
           else
              абс = -эксп;

           // switch в_ exponent display as necessary
           if (абс >= e)
               e = 0; 
           }

        T* p = приёмн.ptr;
        цел счёт = ЧисТип.dig;

        // излей знак
        if (знак)
            *p++ = '-';
        
        // are we doing +/-эксп форматируй?
        if (e is 0)
           {
           assert (приёмн.length > decimals + 7);

           if (эксп < 0)
               x *= pow10 (абс+1);

           // излей первый цифра, и decimal точка
           *p++ = cast(T) toDigit (x, счёт);
           if (decimals)
              {
              *p++ = '.';

              // излей rest of mantissa
              while (decimals-- > 0)
                     *p++ = cast(T) toDigit (x, счёт);
              
              if (pad is нет)
                 {
                 while (*(p-1) is '0')
                        --p;
                 if (*(p-1) is '.')
                     --p;
                 }
              }

           // излей exponent, if non zero
           if (абс)
              {
              *p++ = 'e';
              *p++ = (эксп < 0) ? '-' : '+';
              if (абс >= 1000)
                 {
                 *p++ = cast(T)((абс/1000) + '0');
                 абс %= 1000;
                 *p++ = cast(T)((абс/100) + '0');
                 абс %= 100;
                 }
              else
                 if (абс >= 100)
                    {
                    *p++ = cast(T)((абс/100) + '0');
                    абс %= 100;
                    }
              *p++ = cast(T)((абс/10) + '0');
              *p++ = cast(T)((абс%10) + '0');
              }
           }
        else
           {
           assert (приёмн.length >= (((эксп < 0) ? 0 : эксп) + decimals + 1));

           // if дво only, излей a leading zero
           if (эксп < 0)
              {
              x *= pow10 (абс);
              *p++ = '0';
              }
           else
              // излей все цифры в_ the left of точка
              for (; эксп >= 0; --эксп)
                     *p++ = cast(T )toDigit (x, счёт);

           // излей точка
           if (decimals)
              {
              *p++ = '.';

              // излей leading fractional zeros?
              for (++эксп; эксп < 0 && decimals > 0; --decimals, ++эксп)
                   *p++ = '0';

              // вывод остаток цифры, if any. Trailing
              // zeros are also returned из_ toDigit()
              while (decimals-- > 0)
                     *p++ = cast(T) toDigit (x, счёт);

              if (pad is нет)
                 {
                 while (*(p-1) is '0')
                        --p;
                 if (*(p-1) is '.')
                     --p;
                 }
              }
           }

        return приёмн [0..(p - приёмн.ptr)];
}
}

/******************************************************************************

******************************************************************************/

debug (UnitTest)
{
        import io.Console;
      
        unittest
        {
                сим[164] врем;

                auto f = разбор ("nan");
                assert (форматируй(врем, f) == "nan");
                f = разбор ("inf");
                assert (форматируй(врем, f) == "inf");
                f = разбор ("-nan");
                assert (форматируй(врем, f) == "-nan");
                f = разбор (" -inf");
                assert (форматируй(врем, f) == "-inf");

                assert (форматируй (врем, 3.14159, 6) == "3.14159");
                assert (форматируй (врем, 3.14159, 4) == "3.1416");
                assert (разбор ("3.5") == 3.5);
                assert (форматируй(врем, разбор ("3.14159"), 6) == "3.14159");
        }
}


debug (Float)
{
        import io.Console;

        проц main() 
        {
                сим[500] врем;
/+
                Квывод (форматируй(врем, ЧисТип.max)).нс;
                Квывод (форматируй(врем, -ЧисТип.nan)).нс;
                Квывод (форматируй(врем, -ЧисТип.infinity)).нс;
                Квывод (форматируй(врем, вПлав("nan"w))).нс;
                Квывод (форматируй(врем, вПлав("-nan"d))).нс;
                Квывод (форматируй(врем, вПлав("inf"))).нс;
                Квывод (форматируй(врем, вПлав("-inf"))).нс;
+/
                Квывод (форматируй(врем, вПлав ("0.000000e+00"))).нс;
                Квывод (форматируй(врем, вПлав("0x8000000000000000"))).нс;
                Квывод (форматируй(врем, 1)).нс;
                Квывод (форматируй(врем, -0)).нс;
                Квывод (форматируй(врем, 0.000001)).нс.нс;

                Квывод (форматируй(врем, 3.14159, 6, 0)).нс;
                Квывод (форматируй(врем, 3.0e10, 6, 3)).нс;
                Квывод (форматируй(врем, 314159, 6)).нс;
                Квывод (форматируй(врем, 314159123213, 6, 15)).нс;
                Квывод (форматируй(врем, 3.14159, 6, 2)).нс;
                Квывод (форматируй(врем, 3.14159, 3, 2)).нс;
                Квывод (форматируй(врем, 0.00003333, 6, 2)).нс;
                Квывод (форматируй(врем, 0.00333333, 6, 3)).нс;
                Квывод (форматируй(врем, 0.03333333, 6, 2)).нс;
                Квывод.нс;

                Квывод (форматируй(врем, -3.14159, 6, 0)).нс;
                Квывод (форматируй(врем, -3e100, 6, 3)).нс;
                Квывод (форматируй(врем, -314159, 6)).нс;
                Квывод (форматируй(врем, -314159123213, 6, 15)).нс;
                Квывод (форматируй(врем, -3.14159, 6, 2)).нс;
                Квывод (форматируй(врем, -3.14159, 2, 2)).нс;
                Квывод (форматируй(врем, -0.00003333, 6, 2)).нс;
                Квывод (форматируй(врем, -0.00333333, 6, 3)).нс;
                Квывод (форматируй(врем, -0.03333333, 6, 2)).нс;
                Квывод.нс;

                Квывод (форматируй(врем, -0.9999999, 7, 3)).нс;
                Квывод (форматируй(врем, -3.0e100, 6, 3)).нс;
                Квывод ((форматируй(врем, 1.0, 6))).нс;
                Квывод ((форматируй(врем, 30, 6))).нс;
                Квывод ((форматируй(врем, 3.14159, 6, 0))).нс;
                Квывод ((форматируй(врем, 3e100, 6, 3))).нс;
                Квывод ((форматируй(врем, 314159, 6))).нс;
                Квывод ((форматируй(врем, 314159123213.0, 3, 15))).нс;
                Квывод ((форматируй(врем, 3.14159, 6, 2))).нс;
                Квывод ((форматируй(врем, 3.14159, 4, 2))).нс;
                Квывод ((форматируй(врем, 0.00003333, 6, 2))).нс;
                Квывод ((форматируй(врем, 0.00333333, 6, 3))).нс;
                Квывод ((форматируй(врем, 0.03333333, 6, 2))).нс;
                Квывод (форматируй(врем, ЧисТип.min, 6)).нс;
                Квывод (форматируй(врем, -1)).нс;
                Квывод (форматируй(врем, вПлав(форматируй(врем, -1)))).нс;
                Квывод.нс;
        }
}
