/***************************************************************
                          inline/fmaths.inl
 ***************************************************************/

module derelict.allegro.inline.fmaths_inl;

version (Tango) {
   import tango.stdc.errno;
}
else {
   import std.c;
   // Phobos doesn't define EDOM
   import derelict.allegro.platform.dcommon : EDOM;
}

import derelict.allegro.base;
import derelict.allegro.fixed : fixed;
import derelict.allegro.fmaths;


/* ftofix and fixtof are used in generic C versions of fixmul and fixdiv */
fixed ftofix(double x)
{
   if (x > 32767.0) {
      *allegro_errno = ERANGE;
      return 0x7FFFFFFF;
   }

   if (x < -32767.0) {
      *allegro_errno = ERANGE;
      return -0x7FFFFFFF;
   }

   return cast(fixed)(x * 65536.0 + (x < 0 ? -0.5 : 0.5));
}


double fixtof(fixed x)
{
   return cast(double)x / 65536.0;
}


fixed _fixmul_A(fixed x, fixed y)
{
   return ftofix(fixtof(x) * fixtof(y));
}


fixed _fixmul_B(fixed x, fixed y)
{
   long lx = x;
   long ly = y;
   long lres = (lx*ly);

   if (lres > 0x7FFFFFFF0000L) {
      *allegro_errno = ERANGE;
      return 0x7FFFFFFF;
   }
   else if (lres < -0x7FFFFFFF0000L) {
      *allegro_errno = ERANGE;
      return 0x80000000;
   }
   else {
      int res = cast(int)(lres >> 16);
      return res;
   }
}


static if (!ALLEGRO_NO_ASM) {
   /* Use Allegro's functions, implemented in asm on common platforms */
   extern (C) {
      fixed fixadd(fixed x, fixed y);
      fixed fixsub(fixed x, fixed y);
      // The D version of fixmul runs faster on my Athlon 1.4, I guess because
      // it's actually inlined.
      //fixed fixmul(fixed x, fixed y);
      alias _fixmul_B fixmul;
      fixed fixdiv(fixed x, fixed y);
      int fixfloor(fixed x);
      int fixceil(fixed x);
   }
}
else {

/* use generic D versions */

fixed fixadd(fixed x, fixed y)
{
   fixed result = x + y;

   if (result >= 0) {
      if ((x < 0) && (y < 0)) {
         *allegro_errno = ERANGE;
         return -0x7FFFFFFF;
      }
      else
         return result;
   }
   else {
      if ((x > 0) && (y > 0)) {
         *allegro_errno = ERANGE;
         return 0x7FFFFFFF;
      }
      else
         return result;
   }
}


fixed fixsub(fixed x, fixed y)
{
   fixed result = x - y;

   if (result >= 0) {
      if ((x < 0) && (y > 0)) {
         *allegro_errno = ERANGE;
         return -0x7FFFFFFF;
      }
      else
         return result;
   }
   else {
      if ((x > 0) && (y < 0)) {
         *allegro_errno = ERANGE;
         return 0x7FFFFFFF;
      }
      else
         return result;
   }
}


/* In benchmarks conducted circa May 2005 we found that, in the main:
 * - IA32 machines performed faster with one implementation;
 * - AMD64 and G4 machines performed faster with another implementation.
 *
 * Benchmarks were mainly done with differing versions of gcc.
 * Results varied with other compilers, optimisation levels, etc.
 * so this is not optimal, though a tenable compromise.
 *
 * Note that the following implementation are NOT what were benchmarked.
 * We had forgotten to put in overflow detection in those versions.
 * If you don't need overflow detection then previous versions in the
 * CVS tree might be worth looking at.
 *
 * PS. Don't move the #ifs inside the AL_INLINE; BCC doesn't like it.
 */
version (X86) {
   alias _fixmul_A fixmul;
}
else {
   alias _fixmul_B fixmul;
}


fixed fixdiv(fixed x, fixed y)
{
   if (y == 0) {
      *allegro_errno = ERANGE;
      return (x < 0) ? -0x7FFFFFFF : 0x7FFFFFFF;
   }
   else
      return ftofix(fixtof(x) / fixtof(y));
}


int fixfloor(fixed x)
{
   /* (x >> 16) is not portable */
   if (x >= 0)
      return (x >> 16);
   else
      return ~((~x) >> 16);
}


int fixceil(fixed x)
{
   if (x > 0x7FFF0000) {
      *allegro_errno = ERANGE;
      return 0x7FFF;
   }

   return fixfloor(x + 0xFFFF);
}

}  // C vs. D


fixed itofix(int x)
{
   return x << 16;
}


int fixtoi(fixed x)
{
   return fixfloor(x) + ((x & 0x8000) >> 15);
}


fixed fixcos(fixed x)
{
   return _cos_tbl[((x + 0x4000) >> 15) & 0x1FF];
}


fixed fixsin(fixed x)
{
   return _cos_tbl[((x - 0x400000 + 0x4000) >> 15) & 0x1FF];
}


fixed fixtan(fixed x)
{
   return _tan_tbl[((x + 0x4000) >> 15) & 0xFF];
}


fixed fixacos(fixed x)
{
   if ((x < -65536) || (x > 65536)) {
      *allegro_errno = EDOM;
      return 0;
   }

   return _acos_tbl[(x+65536+127)>>8];
}


fixed fixasin(fixed x)
{
   if ((x < -65536) || (x > 65536)) {
      *allegro_errno = EDOM;
      return 0;
   }

   return 0x00400000 - _acos_tbl[(x+65536+127)>>8];
}
