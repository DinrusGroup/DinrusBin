/***************************************************************
                            dcommon.d

                   Various platform configuration.
 ***************************************************************/

module derelict.allegro.platform.dcommon;

version(Phobos)
/*version (Tango) {
   import tango.stdc.stdint;
   public import tango.stdc.errno : EDOM;
}
else*/ {
   import std.c;
   }


/**********************************************************
 *                 Platform descriptions                  *
 *                                                        *
 *            These correspond to the 'Describe this      *
 *            platform' stuff in C-Allegro's              *
 *            allegro/platform/*.h.                       *
 **********************************************************/

version(linux) version = Unix;  // DMD doesn't define Unix
version (darwin) version = MacOSX;


version (Windows) {
   const char* ALLEGRO_PLATFORM_STR = "Windows";
   const bool ALLEGRO_VRAM_SINGLE_SURFACE = false;
   const bool ALLEGRO_CONSOLE_OK = false;
   const bool ALLEGRO_MULTITHREADED = true;
   const bool ALLEGRO_LFN = true;
   const char DEVICE_SEPARATOR = ':';
}
else version (MacOSX) {  // based on allegro/platform/alosxcfg.h
   const char* ALLEGRO_PLATFORM_STR = "MacOS X";
   const bool ALLEGRO_VRAM_SINGLE_SURFACE = false;
   const bool ALLEGRO_CONSOLE_OK = true;
   const bool ALLEGRO_MULTITHREADED = true;
   const bool ALLEGRO_LFN = true;
   const char DEVICE_SEPARATOR = '\0';
}
else version (Unix) {  // based on allegro/platform/alucfg.h
   const char* ALLEGRO_PLATFORM_STR = "Unix";
   const bool ALLEGRO_VRAM_SINGLE_SURFACE = true;
   const bool ALLEGRO_CONSOLE_OK = true;
   const bool ALLEGRO_MULTITHREADED = true;
   const bool ALLEGRO_LFN = true;
   const char DEVICE_SEPARATOR = '\0';
}
else {
   static assert(0, "No description for this platform, please supply one.");
}


// Not sure if it's necessary to support setting ALLEGRO_NO_ASM on the
// command line (-version=ALLEGRO_NO_ASM), but why not.
version (X86) {
   // We have assembly for this platform.
}
else {
   version = ALLEGRO_NO_ASM;
}

version (ALLEGRO_NO_ASM) {
   const bool ALLEGRO_NO_ASM = true;
}
else {
   const bool ALLEGRO_NO_ASM = false;
}


/********************************************************
 *                Other configuration.                  *
 ********************************************************/

// Phobos doesn't define EDOM, which is found in errno.h in C.
version (Tango) {
}
else {
   // This should be correct for Windows, linux, and OS X.
   enum { EDOM = 33 }
}


// al_long has to be set to a type that matches the C compiler's long size,
// in order to be binary compatible with the Allegro library itself.
version (Windows) {
   // Windows x64 keeps the size of long as 32 bits.
   alias int al_long;
   alias uint al_ulong;
}
else {
   // I hope this is a safe assumption.
   alias intptr_t al_long;
   alias uintptr_t al_ulong;
}
