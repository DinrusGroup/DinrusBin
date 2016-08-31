/***************************************************************
                          inline/gfx.inl
 ***************************************************************/

module derelict.allegro.inline.gfx_inl;

version (Tango)
   import tango.stdc.stdint : uintptr_t;
else
   import std.c : uintptr_t;

//import derelict.allegro.base;
// FIXME: For some reason, getting ALLEGRO_NO_ASM through derelict.allegro.base doesn't
// work here.
import derelict.allegro.platform.dcommon : ALLEGRO_NO_ASM;
import derelict.allegro.gfx;


static if (ALLEGRO_NO_ASM) {
   /* use generic D versions */

   //FIXME: This being used?
   int _default_ds ()
   {
      return 0;
   }

   extern (C) alias uintptr_t function(BITMAP* bmp, int lyne) _BMP_BANK_SWITCHER;
   extern (C) alias void function(BITMAP* bmp) _BMP_UNBANK_SWITCHER;

   uintptr_t bmp_write_line (BITMAP *bmp, int lyne)
   {
      _BMP_BANK_SWITCHER switcher = cast(_BMP_BANK_SWITCHER)bmp.write_bank;
      return switcher(bmp, lyne);
   }

   uintptr_t bmp_read_line (BITMAP *bmp, int lyne)
   {
      _BMP_BANK_SWITCHER switcher = cast(_BMP_BANK_SWITCHER)bmp.read_bank;
      return switcher(bmp, lyne);
   }

   void bmp_unwrite_line (BITMAP *bmp)
   {
      _BMP_UNBANK_SWITCHER switcher = cast(_BMP_UNBANK_SWITCHER)bmp.vtable.unwrite_bank;
      switcher(bmp);
   }

}
else  extern (C) {
   /* DMD doesn't inline assembly so we can just as well use the assembly
    * functions in the allegro lib.  Which means one extra level of
    * indirection.  FIXME: benchmark this to see if it's a problem.
    */
   int _default_ds();
   uintptr_t bmp_write_line(BITMAP *bmp, int lyne);
   uintptr_t bmp_read_line(BITMAP *bmp, int lyne);
   void bmp_unwrite_line(BITMAP *bmp);
}


int is_windowed_mode ()
{
   assert (gfx_driver);
   return gfx_driver.windowed;
}

void clear_to_color (BITMAP *bitmap, int color)
{
   assert(bitmap);
   bitmap.vtable.clear_to_color(bitmap, color);
}

int bitmap_color_depth (BITMAP *bmp)
{
   assert(bmp);
   return bmp.vtable.color_depth;
}

int bitmap_mask_color (BITMAP *bmp)
{
   assert(bmp);
   return bmp.vtable.mask_color;
}

int is_same_bitmap (BITMAP *bmp1, BITMAP *bmp2)
{
   uint m1;
   uint m2;
   if ((!bmp1) || (!bmp2)) return false;
   if (bmp1 == bmp2) return true;
   m1 = bmp1.id & BMP_ID_MASK;
   m2 = bmp2.id & BMP_ID_MASK;
   return ((m1) && (m1 == m2));
}

int is_linear_bitmap (BITMAP *bmp)
{
   assert(bmp);
   return (bmp.id & BMP_ID_PLANAR) == 0;
}

int is_planar_bitmap (BITMAP *bmp)
{
   assert(bmp);
   return (bmp.id & BMP_ID_PLANAR) != 0;
}

int is_memory_bitmap (BITMAP *bmp)
{
   assert(bmp);
   return (bmp.id & (BMP_ID_VIDEO | BMP_ID_SYSTEM)) == 0;
}

int is_screen_bitmap (BITMAP *bmp)
{
   assert(bmp);
   return is_same_bitmap(bmp, screen);
}

int is_video_bitmap (BITMAP *bmp)
{
   assert(bmp);
   return (bmp.id & BMP_ID_VIDEO) != 0;
}

int is_system_bitmap (BITMAP *bmp)
{
   assert(bmp);
   return (bmp.id & BMP_ID_SYSTEM) != 0;
}

int is_sub_bitmap (BITMAP *bmp)
{
   assert(bmp);
   return (bmp.id & BMP_ID_SUB) != 0;
}

void acquire_bitmap (BITMAP *bmp)
{
   assert(bmp);
   if (bmp.vtable.acquire) bmp.vtable.acquire(bmp);
}

void release_bitmap (BITMAP *bmp)
{
   assert(bmp);
   if (bmp.vtable.release) bmp.vtable.release(bmp);
}

void acquire_screen ()
{
   acquire_bitmap(screen);
}

void release_screen ()
{
   release_bitmap(screen);
}


int is_inside_bitmap(BITMAP *bmp, int x, int y, int clip)
{
   assert(bmp);

   if (clip) {
      if (bmp.clip)
         /* internal clipping is inclusive-exclusive */
         return (x >= bmp.cl) && (y >= bmp.ct) && (x < bmp.cr) && (y < bmp.cb);
      else
         return true;
   }
   else
      /* bitmap dimensions are always non-negative */
      return cast(uint)x < cast(uint)bmp.w && cast(uint)y < cast(uint)bmp.h;
}


void get_clip_rect(BITMAP *bitmap, int *x1, int *y_1, int *x2, int *y2)
{
   assert(bitmap);

   /* internal clipping is inclusive-exclusive */
   *x1 = bitmap.cl;
   *y_1 = bitmap.ct;
   *x2 = bitmap.cr-1;
   *y2 = bitmap.cb-1;
}

void set_clip_state (BITMAP *bitmap, int state)
{
   assert(bitmap);

   bitmap.clip = state;
}

int get_clip_state(BITMAP *bitmap)
{
   assert(bitmap);

   return bitmap.clip;
}
