/* Allegro 4.2.1 headers, in the same order they are listed in derelict.allegro.h */

module derelict.allegro.all;
pragma(lib, "alleg.lib");

version (linux) version = Unix;
version (darwin) version = MacOSX;

public {
   import derelict.allegro.base;

   import derelict.allegro.system;
   import derelict.allegro._debug;

   import derelict.allegro.unicode;

   import derelict.allegro.mouse;
   import derelict.allegro.timer;
   import derelict.allegro.keyboard;
   import derelict.allegro.joystick;

   import derelict.allegro.palette;
   import derelict.allegro.gfx;
   import derelict.allegro.color;
   import derelict.allegro.draw;
   import derelict.allegro.rle;
   import derelict.allegro.compiled;
   import derelict.allegro.text;
   import derelict.allegro.font;

   import derelict.allegro.fli;
   import derelict.allegro.config;
   import derelict.allegro.gui;

   import derelict.allegro.sound;

   import derelict.allegro.file;
   import derelict.allegro.lzss;
   import derelict.allegro.datafile;

   import derelict.allegro.fixed;
   import derelict.allegro.fmaths;
   import derelict.allegro.matrix;
   import derelict.allegro.quat;

   import derelict.allegro._3d;
   import derelict.allegro._3dmaths;

   version (ALLEGRO_NO_COMPATIBILITY) {
   }
   else {
      import derelict.allegro.alcompat;
   }

   // Corresponds to ALLEGRO_EXTRA_HEADER in C-Allegro
   version (Windows) {
      import derelict.allegro.platform.alwin;
   }
   else version (MacOSX) {
      import derelict.allegro.platform.alosx;
   }   
   else version (Unix) {
      import derelict.allegro.platform.alunix;
   }

/*
   #ifndef ALLEGRO_NO_FIX_CLASS
      #ifdef __cplusplus
        #include "allegro/fix.h"
      #endif
*/
}
