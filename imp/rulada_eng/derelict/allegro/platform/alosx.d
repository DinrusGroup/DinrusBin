/*         ______   ___    ___
 *        /\  _  \ /\_ \  /\_ \
 *        \ \ \L\ \\//\ \ \//\ \      __     __   _ __   ___
 *         \ \  __ \ \ \ \  \ \ \   /'__`\ /'_ `\/\`'__\/ __`\
 *          \ \ \/\ \ \_\ \_ \_\ \_/\  __//\ \L\ \ \ \//\ \L\ \
 *           \ \_\ \_\/\____\/\____\ \____\ \____ \ \_\\ \____/
 *            \/_/\/_/\/____/\/____/\/____/\/___L\ \/_/ \/___/
 *                                           /\____/
 *                                           \_/__/
 *
 *      MacOS X specific header defines.
 *
 *      By Angelo Mottola.
 *
 *      D version by torhu.
 *
 *      See readme.txt for copyright information.
 */


module derelict.allegro.platform.alosx;

import derelict.allegro.base : _AL_ID;


private {
   /* Allegro's startup code on OS X uses a C main function to do some
    * necessary initialization.  But normally, the C main function in a D
    * program calls a function that runs some D startup code and then calls the
    * regular D main.  Since there can only be one C main, we'll make Allegro's
    * C main call the D startup function.
    *
    * DMD has this startup code inside the C main itself, so this trick would
    * not work.  But GDC also defines two other functions that can be used
    * instead, either of which can be called by user code.
    */

   // GDC initialization and cleanup function.  Also calls the D main function.
   extern (C) int _d_run_Dmain(int argc, char **argv);

   // Allegro's MacOS X C main calls the function through this pointer.
   extern (C) int function(int, char**) _mangled_main_address = &_d_run_Dmain;
}


/* Gfx drivers */
const int GFX_QUARTZ_WINDOW    = _AL_ID!('Q','Z','W','N');
const int GFX_QUARTZ_FULLSCREEN= _AL_ID!('Q','Z','F','L');

/* Digital sound drivers */
const int DIGI_CORE_AUDIO      = _AL_ID!('D','C','A',' ');
const int DIGI_SOUND_MANAGER   = _AL_ID!('S','N','D','M');

/* MIDI music drivers */
const int MIDI_CORE_AUDIO      = _AL_ID!('M','C','A',' ');
const int MIDI_QUICKTIME       = _AL_ID!('Q','T','M',' ');
