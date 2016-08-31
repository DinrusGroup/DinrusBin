/***************************************************************
                           font.h
 ***************************************************************/

module derelict.allegro.font;

import derelict.allegro.palette : RGB;
import derelict.allegro.gfx : BITMAP;


struct FONT_GLYPH;
struct FONT_VTABLE;
alias FONT_GLYPH ГЛИФ_ШРИФТА;
alias FONT_VTABLE ВТАБЛ_ШРИФТА;

alias FONT ШРИФТ;
struct FONT
{
alias data данные;
alias height высота;
alias vtable втабл;

   void *data;
   int height;
   FONT_VTABLE *vtable;
}

extern (C) {

int font_has_alpha(FONT *f);
void make_trans_font (FONT *f);

int is_trans_font(FONT *f);
int is_color_font (FONT *f);
int is_mono_font (FONT *f);
int is_compatible_font (FONT *f1, FONT *f2);

void register_font_file_type (in char *ext, FONT *(*load)(in char *filename, RGB *pal, void *param));
FONT * load_font (in char *filename, RGB *pal, void *param);

FONT * load_dat_font (in char *filename, RGB *pal, void *param);
FONT * load_bios_font (in char *filename, RGB *pal, void *param);
FONT * load_grx_font (in char *filename, RGB *pal, void *param);
FONT * load_grx_or_bios_font (in char *filename, RGB *pal, void *param);
FONT * load_bitmap_font (in char *fname, RGB *pal, void *param);
FONT * load_txt_font (in char *fname, RGB *pal, void *param);

FONT * grab_font_from_bitmap (BITMAP *bmp);

int get_font_ranges (FONT *f);
int get_font_range_begin (FONT *f, int range);
int get_font_range_end (FONT *f, int range);
FONT * extract_font_range (FONT *f, int begin, int end);
FONT * merge_fonts (FONT *f1, FONT *f2);
int transpose_font (FONT *f, int drange);

} // extern (C)
