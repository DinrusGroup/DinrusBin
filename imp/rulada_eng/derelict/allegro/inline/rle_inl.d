/***************************************************************
                          inline/rle.inl
 ***************************************************************/

module derelict.allegro.inline.rle_inl;

import derelict.allegro.rle : RLE_SPRITE;
import derelict.allegro.gfx : BITMAP;


void draw_rle_sprite(BITMAP *bmp, in RLE_SPRITE *sprite, int x, int y)
{
   assert(bmp);
   assert(sprite);
   assert(bmp.vtable.color_depth == sprite.color_depth);

   bmp.vtable.draw_rle_sprite(bmp, sprite, x, y);
}


void draw_trans_rle_sprite(BITMAP *bmp, in RLE_SPRITE *sprite, int x, int y)
{
   assert(bmp);
   assert(sprite);

   if (sprite.color_depth == 32) {
      assert(bmp.vtable.draw_trans_rgba_rle_sprite);
      bmp.vtable.draw_trans_rgba_rle_sprite(bmp, sprite, x, y);
   }
   else {
      assert(bmp.vtable.color_depth == sprite.color_depth);
      bmp.vtable.draw_trans_rle_sprite(bmp, sprite, x, y);
   }
}


void draw_lit_rle_sprite(BITMAP *bmp, in RLE_SPRITE *sprite, int x, int y, int color)
{
   assert(bmp);
   assert(sprite);
   assert(bmp.vtable.color_depth == sprite.color_depth);

   bmp.vtable.draw_lit_rle_sprite(bmp, sprite, x, y, color);
}
