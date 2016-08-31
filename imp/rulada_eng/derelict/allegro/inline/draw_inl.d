/***************************************************************
                          inline/draw.inl
 ***************************************************************/

module derelict.allegro.inline.draw_inl;


version (Tango)
	import tango.stdc.stdint;
else
	import std.c;

import derelict.allegro.internal.alconfig;
import derelict.allegro._3d : V3D, V3D_f;
import derelict.allegro.fixed : fixed;
import derelict.allegro.gfx : BITMAP;
import derelict.allegro.inline.gfx_inl : bmp_read_line, bmp_write_line,
                                bmp_unwrite_line;


int getpixel (BITMAP *bmp, int x, int y)
{
   assert(bmp);
   return bmp.vtable.getpixel(bmp, x, y);
}

void putpixel (BITMAP *bmp, int x, int y, int color)
{
   assert(bmp);
   bmp.vtable.putpixel(bmp, x, y, color);
}

void _allegro_vline (BITMAP *bmp, int x, int y_1, int y2, int color)
{
   assert(bmp);
   bmp.vtable.vline(bmp, x, y_1, y2, color);
}

void _allegro_hline (BITMAP *bmp, int x1, int y, int x2, int color)
{
   assert(bmp);
   bmp.vtable.hline(bmp, x1, y, x2, color);
}

/* The curses API also contains functions called vline and hline so we have
 * called our functions _allegro_vline and _allegro_hline.  User programs
 * should use the vline/hline aliases as they are the official names.
 */
version (ALLEGRO_NO_VHLINE_ALIAS) {
   // nothing here
}
else {
   void vline(BITMAP *bmp, int x, int y_1, int y2, int color)
   {
      _allegro_vline(bmp, x, y_1, y2, color);
   }

   void hline(BITMAP *bmp, int x1, int y, int x2, int color)
   {
      _allegro_hline(bmp, x1, y, x2, color);
   }
}


void line(BITMAP *bmp, int x1, int y_1, int x2, int y2, int color)
{
   assert(bmp);

   bmp.vtable.line(bmp, x1, y_1, x2, y2, color);
}


void fastline(BITMAP *bmp, int x1, int y_1, int x2, int y2, int color)
{
   assert(bmp);

   bmp.vtable.fastline(bmp, x1, y_1, x2, y2, color);
}


void rectfill(BITMAP *bmp, int x1, int y_1, int x2, int y2, int color)
{
   assert(bmp);

   bmp.vtable.rectfill(bmp, x1, y_1, x2, y2, color);
}


void triangle(BITMAP *bmp, int x1, int y_1, int x2, int y2, int x3, int y3, int color)
{
   assert(bmp);

   bmp.vtable.triangle(bmp, x1, y_1, x2, y2, x3, y3, color);
}


void polygon(BITMAP *bmp, int vertices, in int *points, int color)
{
   assert(bmp);

   bmp.vtable.polygon(bmp, vertices, points, color);
}


void rect(BITMAP *bmp, int x1, int y_1, int x2, int y2, int color)
{
   assert(bmp);

   bmp.vtable.rect(bmp, x1, y_1, x2, y2, color);
}


void circle(BITMAP *bmp, int x, int y, int radius, int color)
{
   assert(bmp);

   bmp.vtable.circle(bmp, x, y, radius, color);
}


void circlefill(BITMAP *bmp, int x, int y, int radius, int color)
{
   assert(bmp);

   bmp.vtable.circlefill(bmp, x, y, radius, color);
}


void ellipse(BITMAP *bmp, int x, int y, int rx, int ry, int color)
{
   assert(bmp);

   bmp.vtable.ellipse(bmp, x, y, rx, ry, color);
}


void ellipsefill(BITMAP *bmp, int x, int y, int rx, int ry, int color)
{
   assert(bmp);

   bmp.vtable.ellipsefill(bmp, x, y, rx, ry, color);
}


void arc(BITMAP *bmp, int x, int y, fixed ang1, fixed ang2, int r, int color)
{
   assert(bmp);

   bmp.vtable.arc(bmp, x, y, ang1, ang2, r, color);
}


void spline(BITMAP *bmp, in int points[8], int color)
{
   assert(bmp);

   bmp.vtable.spline(bmp, points, color);
}


void floodfill(BITMAP *bmp, int x, int y, int color)
{
   assert(bmp);

   bmp.vtable.floodfill(bmp, x, y, color);
}


void polygon3d(BITMAP *bmp, int type, BITMAP *texture, int vc, V3D **vtx)
{
   assert(bmp);

   bmp.vtable.polygon3d(bmp, type, texture, vc, vtx);
}


void polygon3d_f(BITMAP *bmp, int type, BITMAP *texture, int vc, V3D_f **vtx)
{
   assert(bmp);

   bmp.vtable.polygon3d_f(bmp, type, texture, vc, vtx);
}



void triangle3d(BITMAP *bmp, int type, BITMAP *texture, V3D *v1, V3D *v2, V3D *v3)
{
   assert(bmp);

   bmp.vtable.triangle3d(bmp, type, texture, v1, v2, v3);
}


void triangle3d_f(BITMAP *bmp, int type, BITMAP *texture, V3D_f *v1, V3D_f *v2, V3D_f *v3)
{
   assert(bmp);

   bmp.vtable.triangle3d_f(bmp, type, texture, v1, v2, v3);
}


void quad3d(BITMAP *bmp, int type, BITMAP *texture, V3D *v1, V3D *v2, V3D *v3, V3D *v4)
{
   assert(bmp);

   bmp.vtable.quad3d(bmp, type, texture, v1, v2, v3, v4);
}


void quad3d_f(BITMAP *bmp, int type, BITMAP *texture, V3D_f *v1, V3D_f *v2, V3D_f *v3, V3D_f *v4)
{
   assert(bmp);

   bmp.vtable.quad3d_f(bmp, type, texture, v1, v2, v3, v4);
}


void draw_sprite(BITMAP *bmp, BITMAP *sprite, int x, int y)
{
   assert(bmp);
   assert(sprite);

   if (sprite.vtable.color_depth == 8) {
      bmp.vtable.draw_256_sprite(bmp, sprite, x, y);
   }
   else {
      assert(bmp.vtable.color_depth == sprite.vtable.color_depth);
      bmp.vtable.draw_sprite(bmp, sprite, x, y);
   }
}


void draw_sprite_v_flip(BITMAP *bmp, BITMAP *sprite, int x, int y)
{
   assert(bmp);
   assert(sprite);
   assert(bmp.vtable.color_depth == sprite.vtable.color_depth);

   bmp.vtable.draw_sprite_v_flip(bmp, sprite, x, y);
}


void draw_sprite_h_flip(BITMAP *bmp, BITMAP *sprite, int x, int y)
{
   assert(bmp);
   assert(sprite);
   assert(bmp.vtable.color_depth == sprite.vtable.color_depth);

   bmp.vtable.draw_sprite_h_flip(bmp, sprite, x, y);
}


void draw_sprite_vh_flip(BITMAP *bmp, BITMAP *sprite, int x, int y)
{
   assert(bmp);
   assert(sprite);
   assert(bmp.vtable.color_depth == sprite.vtable.color_depth);

   bmp.vtable.draw_sprite_vh_flip(bmp, sprite, x, y);
}


void draw_trans_sprite(BITMAP *bmp, BITMAP *sprite, int x, int y)
{
   assert(bmp);
   assert(sprite);

   if (sprite.vtable.color_depth == 32) {
      assert(bmp.vtable.draw_trans_rgba_sprite);
      bmp.vtable.draw_trans_rgba_sprite(bmp, sprite, x, y);
   }
   else {
      assert((bmp.vtable.color_depth == sprite.vtable.color_depth) ||
             ((bmp.vtable.color_depth == 32) &&
              (sprite.vtable.color_depth == 8)));
      bmp.vtable.draw_trans_sprite(bmp, sprite, x, y);
   }
}


void draw_lit_sprite(BITMAP *bmp, BITMAP *sprite, int x, int y, int color)
{
   assert(bmp);
   assert(sprite);
   assert(bmp.vtable.color_depth == sprite.vtable.color_depth);

   bmp.vtable.draw_lit_sprite(bmp, sprite, x, y, color);
}


void draw_gouraud_sprite(BITMAP *bmp, BITMAP *sprite, int x, int y, int c1, int c2, int c3, int c4)
{
   assert(bmp);
   assert(sprite);
   assert(bmp.vtable.color_depth == sprite.vtable.color_depth);

   bmp.vtable.draw_gouraud_sprite(bmp, sprite, x, y, c1, c2, c3, c4);
}


void draw_character_ex(BITMAP *bmp, BITMAP *sprite, int x, int y, int color, int bg)
{
   assert(bmp);
   assert(sprite);
   assert(sprite.vtable.color_depth == 8);

   bmp.vtable.draw_character(bmp, sprite, x, y, color, bg);
}


void rotate_sprite(BITMAP *bmp, BITMAP *sprite, int x, int y, fixed angle)
{
   assert(bmp);
   assert(sprite);

   bmp.vtable.pivot_scaled_sprite_flip(bmp, sprite, (x<<16) + (sprite.w * 0x10000) / 2,
                                       (y<<16) + (sprite.h * 0x10000) / 2,
                                       sprite.w << 15, sprite.h << 15,
                                       angle, 0x10000, false);
}


void rotate_sprite_v_flip(BITMAP *bmp, BITMAP *sprite, int x, int y, fixed angle)
{
   assert(bmp);
   assert(sprite);

   bmp.vtable.pivot_scaled_sprite_flip(bmp, sprite, (x<<16) + (sprite.w * 0x10000) / 2,
                                       (y<<16) + (sprite.h * 0x10000) / 2,
                                       sprite.w << 15, sprite.h << 15,
                                       angle, 0x10000, true);
}


void rotate_scaled_sprite(BITMAP *bmp, BITMAP *sprite, int x, int y, fixed angle, fixed scale)
{
   assert(bmp);
   assert(sprite);

   bmp.vtable.pivot_scaled_sprite_flip(bmp, sprite, (x<<16) + (sprite.w * scale) / 2,
                                       (y<<16) + (sprite.h * scale) / 2,
                                       sprite.w << 15, sprite.h << 15,
                                       angle, scale, false);
}


void rotate_scaled_sprite_v_flip(BITMAP *bmp, BITMAP *sprite, int x, int y, fixed angle, fixed scale)
{
   assert(bmp);
   assert(sprite);

   bmp.vtable.pivot_scaled_sprite_flip(bmp, sprite, (x<<16) + (sprite.w * scale) / 2,
                                       (y<<16) + (sprite.h * scale) / 2,
                                       sprite.w << 15, sprite.h << 15,
                                       angle, scale, true);
}


void pivot_sprite(BITMAP *bmp, BITMAP *sprite, int x, int y, int cx, int cy, fixed angle)
{
   assert(bmp);
   assert(sprite);

   bmp.vtable.pivot_scaled_sprite_flip(bmp, sprite, x<<16, y<<16, cx<<16, cy<<16, angle, 0x10000, false);
}


void pivot_sprite_v_flip(BITMAP *bmp, BITMAP *sprite, int x, int y, int cx, int cy, fixed angle)
{
   assert(bmp);
   assert(sprite);

   bmp.vtable.pivot_scaled_sprite_flip(bmp, sprite, x<<16, y<<16, cx<<16, cy<<16, angle, 0x10000, true);
}


void pivot_scaled_sprite(BITMAP *bmp, BITMAP *sprite, int x, int y, int cx, int cy, fixed angle, fixed scale)
{
   assert(bmp);
   assert(sprite);

   bmp.vtable.pivot_scaled_sprite_flip(bmp, sprite, x<<16, y<<16, cx<<16, cy<<16, angle, scale, false);
}


void pivot_scaled_sprite_v_flip(BITMAP *bmp, BITMAP *sprite, int x, int y, int cx, int cy, fixed angle, fixed scale)
{
   assert(bmp);
   assert(sprite);

   bmp.vtable.pivot_scaled_sprite_flip(bmp, sprite, x<<16, y<<16, cx<<16, cy<<16, angle, scale, true);
}


void _putpixel(BITMAP *bmp, int x, int y, int color)
{
   uintptr_t addr;

   bmp_select(bmp);
   addr = bmp_write_line(bmp, y);
   bmp_write8(addr+x, color);
   bmp_unwrite_line(bmp);
}


int _getpixel(BITMAP *bmp, int x, int y)
{
   uintptr_t addr;
   int c;

   bmp_select(bmp);
   addr = bmp_read_line(bmp, y);
   c = bmp_read8(addr+x);
   bmp_unwrite_line(bmp);

   return c;
}


void _putpixel15(BITMAP *bmp, int x, int y, int color)
{
   uintptr_t addr;

   bmp_select(bmp);
   addr = bmp_write_line(bmp, y);
   bmp_write15(addr+x*short.sizeof, color);
   bmp_unwrite_line(bmp);
}


int _getpixel15(BITMAP *bmp, int x, int y)
{
   uintptr_t addr;
   int c;

   bmp_select(bmp);
   addr = bmp_read_line(bmp, y);
   c = bmp_read15(addr+x*short.sizeof);
   bmp_unwrite_line(bmp);

   return c;
}


void _putpixel16(BITMAP *bmp, int x, int y, int color)
{
   uintptr_t addr;

   bmp_select(bmp);
   addr = bmp_write_line(bmp, y);
   bmp_write16(addr+x*short.sizeof, color);
   bmp_unwrite_line(bmp);
}


int _getpixel16(BITMAP *bmp, int x, int y)
{
   uintptr_t addr;
   int c;

   bmp_select(bmp);
   addr = bmp_read_line(bmp, y);
   c = bmp_read16(addr+x*short.sizeof);
   bmp_unwrite_line(bmp);

   return c;
}


void _putpixel24(BITMAP *bmp, int x, int y, int color)
{
   uintptr_t addr;

   bmp_select(bmp);
   addr = bmp_write_line(bmp, y);
   bmp_write24(addr+x*3, color);
   bmp_unwrite_line(bmp);
}


int _getpixel24(BITMAP *bmp, int x, int y)
{
   uintptr_t addr;
   int c;

   bmp_select(bmp);
   addr = bmp_read_line(bmp, y);
   c = bmp_read24(addr+x*3);
   bmp_unwrite_line(bmp);

   return c;
}


void _putpixel32(BITMAP *bmp, int x, int y, int color)
{
   uintptr_t addr;

   bmp_select(bmp);
   addr = bmp_write_line(bmp, y);
   bmp_write32(addr+x*int32_t.sizeof, color);
   bmp_unwrite_line(bmp);
}


int _getpixel32(BITMAP *bmp, int x, int y)
{
   uintptr_t addr;
   int c;

   bmp_select(bmp);
   addr = bmp_read_line(bmp, y);
   c = bmp_read32(addr+x*int32_t.sizeof);
   bmp_unwrite_line(bmp);

   return c;
}
