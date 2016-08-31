/***************************************************************
                           fli.h
 ***************************************************************/

module derelict.allegro.fli;

import derelict.allegro.palette : PALETTE;
import derelict.allegro.gfx : BITMAP;
import derelict.allegro.internal.dintern;
import derelict.allegro.internal._export;


enum {
    FLI_OK        = 0,              /* FLI player return values */
    FLI_EOF       = -1,
    FLI_ERROR     = -2,
    FLI_NOT_OPEN  = -3,
}

extern (C) {
int play_fli (in char *filename, BITMAP *bmp, int loop, int (*callback) ());
int play_memory_fli (void *fli_data, BITMAP *bmp, int loop, int (*callback) ());

int open_fli (in char *filename);
int open_memory_fli (void *fli_data);
void close_fli ();
int next_fli_frame (int loop);
void reset_fli_variables ();
}  // extern (C)

mixin(_export!(
"extern extern (C){"
   "BITMAP* fli_bitmap;"           /* current frame of the FLI */
   "PALETTE fli_palette;"          /* current FLI palette */

   "int fli_bmp_dirty_from;"       /* what part of fli_bitmap is dirty */
   "int fli_bmp_dirty_to;"
   "int fli_pal_dirty_from;"       /* what part of fli_palette is dirty */
   "int fli_pal_dirty_to;"

   "int fli_frame;"                /* current frame number */
"}"
));

int fli_timer()                  /* for timing FLI playback */
{
   volatile return derelict.allegro.internal.dintern.fli_timer;
}
