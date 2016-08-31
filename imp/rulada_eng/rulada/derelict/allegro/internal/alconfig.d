/***************************************************************
                        internal/alconfig.h
 ***************************************************************/

module derelict.allegro.internal.alconfig;

version (darwin) version = MacOSX;

public import derelict.allegro.platform.dcommon;

version (Tango) {
   import tango.io.FileConduit;
   import tango.io.model.IFile;
   import tango.stdc.stdint;
   import tango.stdc.stdlib;
}
else {
   import std.path;
   import std.c;
   //import std.c;
}

import derelict.allegro.gfx : BITMAP;


version (Tango)
   alias tango.io.model.IFile.FileConst.PathSeparatorChar OTHER_PATH_SEPARATOR;
else
   alias std.path.sep OTHER_PATH_SEPARATOR;


/* emulate the FA_* flags for platforms that don't already have them */
enum {
   FA_RDONLY    =  1,
   FA_HIDDEN    =  2,
   FA_SYSTEM    =  4,
   FA_LABEL     =  8,
   FA_DIREC     =  16,
   FA_ARCH      =  32,

   FA_NONE      =  0,
   FA_ALL       =  (~FA_NONE)
}

/* endian-independent 3-byte accessor macros */
version (LittleEndian) {

   int READ3BYTES(ubyte* p)
   {
      return (*cast(ubyte *)(p))
              | (*(cast(ubyte *)(p) + 1) << 8)
              | (*(cast(ubyte *)(p) + 2) << 16);
   }


   void WRITE3BYTES(ubyte* p, int c)
   {
      *cast(ubyte *)p = cast(ubyte)c;
      *(cast(ubyte *)p + 1) = cast(ubyte)(c >> 8);
      *(cast(ubyte *)p + 2) = cast(ubyte)(c >> 16);
   }

}
version (BigEndian) {

   int READ3BYTES(ubyte* p)
   {
      return (*cast(ubyte *)p << 16)
              | (*(cast(ubyte *)p + 1) << 8)
              | (*(cast(ubyte *)p + 2));
   }

   void WRITE3BYTES(ubyte* p, int c)
   {
      *cast(ubyte *)p = c >> 16;
      *(cast(ubyte *)p + 1) = c >> 8;
      *(cast(ubyte *)p + 2) = c;
   }
}


void bmp_select(BITMAP* bmp) { /* nothing, only DOS uses this for anything */ }

void bmp_write8(uintptr_t addr, int c) { *(cast(uint8_t  *)addr) = cast(ubyte)c; }
void bmp_write15(uintptr_t addr, int c) { *(cast(uint16_t *)addr) = cast(ubyte)c; }
void bmp_write16(uintptr_t addr, int c) { *(cast(uint16_t *)addr) = cast(ubyte)c; }
void bmp_write32(uintptr_t addr, int c) { *(cast(uint32_t *)addr) = c; }

uint8_t bmp_read8(uintptr_t addr) { return *(cast(uint8_t  *)addr); }
uint16_t bmp_read15(uintptr_t addr) { return *(cast(uint16_t *)addr); }
uint16_t bmp_read16(uintptr_t addr) { return *(cast(uint16_t *)addr); }
uint32_t bmp_read32(uintptr_t addr) { return *(cast(uint32_t *)addr); }

int bmp_read24(uintptr_t addr)
{
   ubyte* p = cast(ubyte*)addr;
   int c;

   c = READ3BYTES(p);

   return c;
}

void bmp_write24 (uintptr_t addr, int c)
{
   ubyte* p = cast(ubyte*)addr;

   WRITE3BYTES(p, c);
}

/* This is mainly to make it faster to translate the Allegro examples.
 * I tried using D's std.random.rand(), but it gives results in a different
 * range than the C version.
 */
version (MacOSX)
   int AL_RAND() { return (rand() >> 16) & 0x7fff; }
else
   alias rand AL_RAND;
