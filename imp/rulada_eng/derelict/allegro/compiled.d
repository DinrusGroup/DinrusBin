/***************************************************************
                           compiled.h
 ***************************************************************/

module derelict.allegro.compiled;

import derelict.allegro.base;
public import derelict.allegro.system : BITMAP;
import derelict.allegro.rle;


// FIXME
version (X86)
   private const ALLEGRO_I386 = 1;
else
   private const ALLEGRO_I386 = 0;

static if (ALLEGRO_I386 && !ALLEGRO_NO_ASM) {
   /* compiled sprite structure */
   struct COMPILED_SPRITE
   {
      short planar;                  /* set if it's a planar (mode-X) sprite */
      short color_depth;             /* color depth of the image */
      short w, h;                    /* size of the sprite */
      struct P {
         void *draw;                 /* routines to draw the image */
         int len;                    /* length of the drawing functions */
      }
      P proc[4];
   }
}
else {
   /* emulate compiled sprites using RLE on other platforms */
   alias derelict.allegro.rle.RLE_SPRITE COMPILED_SPRITE;
}

extern (C) {
COMPILED_SPRITE* get_compiled_sprite(BITMAP *bitmap, int planar);
void destroy_compiled_sprite(COMPILED_SPRITE *sprite);
void draw_compiled_sprite(BITMAP *bmp, in COMPILED_SPRITE *sprite, int x, int y);
}
