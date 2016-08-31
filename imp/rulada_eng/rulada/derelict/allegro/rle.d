/***************************************************************
                           rle.h
 ***************************************************************/

module derelict.allegro.rle;

public import derelict.allegro.inline.rle_inl;

import derelict.allegro.gfx : BITMAP;


struct RLE_SPRITE                   /* a RLE compressed sprite */
{
   int w, h;                        /* width and height in pixels */
   int color_depth;                 /* color depth of the image */
   int size;                        /* size of sprite data in bytes */
   byte[0] dat;  // FIXME: does [0] work?
}

extern (C) {
   RLE_SPRITE *get_rle_sprite(BITMAP *bitmap);
   void destroy_rle_sprite(RLE_SPRITE *sprite);
}
