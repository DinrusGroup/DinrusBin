/*******************************************************************************

        @file Double.d
        
        Copyright (c) 2004 Kris Bell
        
        This software is provided 'as-is', without any express or implied
        warranty. In no event will the authors be held liable for damages
        of any kind arising from the use of this software.
        
        Permission is hereby granted to anyone to use this software for any 
        purpose, including commercial applications, and to alter it and/or 
        redistribute it freely, subject to the following restrictions:
        
        1. The origin of this software must not be misrepresented; you must 
           not claim that you wrote the original software. If you use this 
           software in a product, an acknowledgment within documentation of 
           said product would be appreciated but is not required.

        2. Altered source versions must be plainly marked as such, and must 
           not be misrepresented as being the original software.

        3. This notice may not be removed or altered from any distribution
           of the source.

        4. Derivative works are permitted, but they must carry this notice
           in full and credit the original source.


                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        
        @version        Initial version, Nov 2005

        @author         Kris


*******************************************************************************/

module mango.convert.Double;

private import mango.convert.Atoi;

/******************************************************************************

        A set of functions for converting between string and floating-
        point values. 

******************************************************************************/

struct DoubleT(T)
{
        static if (!is (T == char) && !is (T == wchar) && !is (T == dchar)) 
                    pragma (msg, "Template type must be char, wchar, or dchar");


        private alias AtoiT!(T) Atoi;

        /**********************************************************************

                Convert a float to a string. This produces pretty
                good results for the most part, though one should
                use David Gay's dtoa package for best accuracy.

                Note that the approach first normalizes a base10
                mantissa, then pulls digits from the left side
                whilst emitting them (rightward) to the output.

        **********************************************************************/

        static final T[] format (T[] dst, double x, uint decimals = 6, bool scientific = false)
        in {
           assert (dst.length >= 32);
           }
        body
        {
                // function to strip digits from the
                // left of a normalized base-10 number
                static int toDigit (inout double v, inout int count)
                {
                        int digit;

                        // double can reliably hold 17 digits only
                        if (++count > 17)
                            digit = 0;
                        else
                           {
                           // remove leading digit, and bump
                           digit = cast(int) v;
                           v = (v - digit) * 10.0;
                           }
                        return digit + '0';
                }

                // test for nan/infinity
                if (((cast(ushort*) &x)[3] & 0x7ff0) == 0x7ff0)
                      if (*(cast(ulong*) &x) & 0x000f_ffff_ffff_ffff)
                            return "nan";
                      else
                         return "inf";

                int exp;
                bool sign;
        
                // extract the sign
                if (x < 0.0)
                   {
                   x = -x;
                   sign = true;
                   }

                // don't scale if zero
                if (x > 0.0)
                   {
                   // round up a bit (should do even/odd test?)
                   x += 0.5 / pow10 (decimals);

                   // extract exponent; convert to base10
                   frexp (x, &exp);
                   exp = cast(int) (0.301029995664 * exp);

                   // normalize base10 mantissa (0 < m < 10)
                   int len = exp;
                   if (exp < 0)
                      {
                      --exp;
                      x *= pow10 (len = -exp);
                      }
                   else
                      x /= pow10 (exp);

                   // switch to short display if not enough space
                   if (len + 32 > dst.length)
                       scientific = true;
                   }

                T* p = cast(T*) dst;
                int count = 0;

                // emit sign
                if (sign)
                    *p++ = '-';

                // are we doing +/-exp format?
                if (scientific)
                   {
                   // emit first digit, and decimal point
                   *p++ = toDigit (x, count);
                   *p++ = '.';

                   // emit rest of mantissa
                   while (decimals-- > 0)
                          *p++ = toDigit (x, count);

                   // emit exponent, if non zero
                   if (exp)
                      {
                      *p++ = 'e';
                      *p++ = (exp < 0) ? '-' : '+';
                      if (exp < 0)
                          exp = -exp;

                      if (exp >= 100)
                         {
                         *p++ = (exp/100) + '0';
                         exp %= 100;
                         }

                      *p++ = (exp/10) + '0';
                      *p++ = (exp%10) + '0';
                      }
                   }
                else
                   {
                   // if fraction only, emit a leading zero
                   if (exp < 0)
                       *p++ = '0';
                   else
                      // emit all digits to the left of point
                      for (; exp >= 0; --exp)
                             *p++ = toDigit (x, count);

                   // emit point
                   *p++ = '.';

                   // emit leading fractional zeros?
                   for (++exp; exp < 0 && decimals > 0; --decimals, ++exp)
                        *p++ = '0';

                   // output remaining digits, if any. Trailing
                   // zeros are also returned from toDigit()
                   while (decimals-- > 0)
                          *p++ = toDigit (x, count);
                   }

                return dst [0..(p - dst.ptr)];
        }


        /**********************************************************************

                Convert a formatted string of digits to a floating-
                point number. Good for general use, but use David
                Gay's dtoa package if serious rounding adjustments
                should be applied.

        **********************************************************************/

        final static double parse (T[] src, uint* ate=null)
        {
                T               c;
                T*              p;
                int             exp;
                bool            sign;
                uint            radix;
                double          value = 0.0;

                // remove leading space, and sign
                c = *(p = src.ptr + Atoi.trim (src, sign, radix));

                // handle non-decimal representations
                if (radix != 10)
                   {
                   long v = Atoi.parse (src, radix, ate); 
                   return *cast(double*) &v;
                   }

                // read leading digits; note that leading
                // zeros are simply multiplied away.
                while (c >= '0' && c <= '9')
                      {
                      value = value * 10 + (c - '0');
                      c = *++p;
                      }

                // gobble up the point
                if (c == '.')
                    c = *++p;

                // read fractional digits; note that we accumulate
                // all digits ... very long numbers impact accuracy
                // to a degree, but perhaps not as much as one might
                // expect. A prior version limited the digit count,
                // but did not show marked improvement. For maximum
                // accuracy when reading and writing, use David Gay's
                // dtoa package instead.
                while (c >= '0' && c <= '9')
                      {
                      value = value * 10 + (c - '0');
                      c = *++p;
                      --exp;
                      } 

                // did we get something?
                if (value)
                   {
                   // parse base10 exponent?
                   if (c == 'e' || c == 'E')
                      {
                      uint eaten;
                      exp += Atoi.parse (src[(p-src.ptr)+1..length], 0, &eaten);
                      p += eaten;
                      }

                   // adjust mantissa; note that the exponent has
                   // already been adjusted for fractional digits
                   if (exp < 0)
                       value /= pow10 (-exp);
                   else
                      value *= pow10 (exp);
                   }
                else
                   // was it was nan instead?
                   if (p == src.ptr)
                       if (p[0..3] == "inf")
                           p += 3, value = double.infinity;
                       else
                          if (p[0..3] == "nan")
                              p += 3, value = double.nan;

                // set parse length, and return value
                if (ate)
                    *ate = p - src.ptr;
                return sign ? -value : value; 
        }


        /**********************************************************************

                Internal function to convert an exponent specifier to 
                a floating point value.
                 
        **********************************************************************/

        private static final double pow10 (uint exp)
        in {
           assert (exp < 512);
           }    
        body
        {
                static  double[] Powers = 
                        [
                        1.0e1,
                        1.0e2,
                        1.0e4,
                        1.0e8,
                        1.0e16,
                        1.0e32,
                        1.0e64,
                        1.0e128,
                        1.0e256,
                        ];

                double mult = 1.0;
                foreach (double power; Powers)
                        {
                        if (exp & 1)
                            mult *= power;
                        if ((exp >>= 1) == 0)
                             break;
                        }
                return mult;
        }
}


/******************************************************************************

******************************************************************************/

alias DoubleT!(char) Double;


/******************************************************************************

        Temporary patch to avoid huge bloat from snn.lib

******************************************************************************/

/*version (X86)
{
        private static double frexp (double v, int* n)
        {
                asm {
                    fld     v;                      
                    mov     EDI, n;                 
                    ftst;                           
                    fstsw   AX;                     
                    sahf;                           
                    jnz     nonZero;                 
                    fld     st(0);                  
                    jmp     done;                

        nonZero:    fxtract;                       
                    fld1;                          
                    fld1;                          
                    fadd;                          
                    fdiv;                          
                    fxch;                          
                    fld1;                          
                    fadd;                          
                    fistp   [EDI];       
        done:;
                    }
        }
}
else*/
   extern (C) double frexp (double, int*);



version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
