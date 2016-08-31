/***************************************************************
                           base.h
 ***************************************************************/
module derelict.allegro.base;

public import derelict.allegro.internal.alconfig;

version (Tango) {
   import tango.math.Math;
}
else {
   import std.math;
}

import derelict.allegro.internal._export;


const int ALLEGRO_VERSION       = 4;
const int ALLEGRO_SUB_VERSION   = 2;
const int ALLEGRO_WIP_VERSION   = 2;
const char* ALLEGRO_VERSION_STR = "4.2.2";
const char* ALLEGRO_DATE_STR    = "2007";
const int ALLEGRO_DATE          =  20070722;   /* yyyymmdd */

enum { TRUE = -1, FALSE = 0, ТАК = -1, НЕТАК = 0 }


/* These are not documented, they are just included because some of the
 * examples use them.
 *
 * Be aware that MID() does not do what its name suggests. It does not
 * return the 'middle' value.  It clamps val between min and max.
 */
typeof(T + U) MAX(T, U)(T x, U y) { return x > y ? x : y; }

typeof(T + U) MIN(T, U)(T x, U y) { return x < y ? x : y; }

typeof(T + U + V) MID(T, U, V)(T min, U val, V max)
{
   return MAX(min, MIN(val, max));
}

version (Tango) {
   alias tango.math.Math.abs ABS;
}
else {
   alias std.math.abs ABS;
}


int AL_ID(char a, char b, char c, char d)
{
   return (a << 24) | (b << 16) | (c << 8) | d;
}

/* Alternative AL_ID.  The problem is that as of dmd 1.0, it has to be used
 * like this: AL_ID!(1, 2, 3, 4);
 *
 * If later compiler versions allows you to leave out the '!', the template
 * is probably the best solution.  The function can't be used in static 
 * initialization.  But the the error messages if you leave out the '!' are
 * more cryptic, so I'm assuming that the template version would cause more
 * user confusion.  But it's still nice to keep for internal use.
 */ 
template _AL_ID(char a, char b, char c, char d)
{
   const int _AL_ID = (a << 24) | (b << 16) | (c << 8) | d;
}

mixin(_export!("extern extern (C) int* allegro_errno;"));


package struct _DRIVER_INFO         /* info about a hardware driver */
{
alias id ид;
alias driver драйвер;
alias autodetect автоопред;

   int id;                          /* integer ID */
   void *driver;                    /* the driver structure */
   int autodetect;                  /* set to allow autodetection */
}
alias _DRIVER_INFO _ИНФО_ДРАЙВЕРЕ;