/*  Stuff that can't be in the other modules for various reasons. */

module derelict.allegro.internal.dintern;

import derelict.allegro.base : al_long;
import derelict.allegro.keyboard;
import derelict.allegro.system;
import derelict.allegro.internal._export;


// To declare a static array in D, you need to specify a size.
// When the size is not known, we just need to put any size.  But making an
// array declared with the wrong size available to users is a bad idea.
//
// To avoid that, we assign the array's address to a pointer instead.  This
// pointer is public, the static array is not.
//
// Variables that are volatile in C-Allegro are declared here, to keep them
// from conflicting with their property wrappers.

private const UNKNOWN_SIZE = 1000;

mixin(_export!(
   "extern extern (C) {"
      // fli.d
      /*volatile*/ "int fli_timer;"

      // gfx.d
      //"_VTABLE_INFO _vtable_list[UNKNOWN_SIZE];"

      // keyboard.d
      /*volatile*/ "char key[KEY_MAX];"
      /*volatile*/ "int key_shifts;"
      //"_DRIVER_INFO _keyboard_driver_list[UNKNOWN_SIZE];"

      // midi.d
      /*volatile*/ "al_long midi_pos;"
      /*volatile*/ "al_long midi_time;"

      // mouse.d
      /*volatile*/ "int mouse_x;"
      /*volatile*/ "int mouse_y;"
      /*volatile*/ "int mouse_z;"
      /*volatile*/ "int mouse_w;"
      /*volatile*/ "int mouse_b;"
      /*volatile*/ "int mouse_pos;"
      /*volatile*/ "int freeze_mouse_flag;"

      // system.d
      "char[UNKNOWN_SIZE] allegro_id;"
      "char[ALLEGRO_ERROR_SIZE] allegro_error;"
      "char[UNKNOWN_SIZE] cpu_vendor;"
      //"_DRIVER_INFO[UNKNOWN_SIZE] _system_driver_list;"

      // timer.d
      /* volatile*/ "int retrace_count;"

      // unicode.d
      "char[UNKNOWN_SIZE] empty_string;"
   "}"
));
