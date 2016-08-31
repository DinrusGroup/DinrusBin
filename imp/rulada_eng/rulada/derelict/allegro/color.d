/***************************************************************
                          color.h
 ***************************************************************/
module derelict.allegro.color;

import derelict.allegro.palette : PALETTE, PAL_SIZE, RGB;
import derelict.allegro.gfx : BITMAP;
import derelict.allegro.internal._export;

public import derelict.allegro.inline.color_inl;


mixin(_export!(
   "extern extern (C) {"
      "PALETTE black_palette;"
      "PALETTE desktop_palette;"
      "PALETTE default_palette;"
   "}"
));

struct RGB_MAP {
   ubyte data[32][32][32];
}
alias RGB_MAP КАРТА_КЗС;

struct COLOR_MAP {
   ubyte data[PAL_SIZE][PAL_SIZE];
}
alias COLOR_MAP ЦВЕТОКАРТА;

mixin(_export!(
   "extern extern (C) {"
      "RGB_MAP* rgb_map;"
      "COLOR_MAP* color_map;"
      "PALETTE _current_palette;"
   
      "int _rgb_r_shift_15;"
      "int _rgb_g_shift_15;"
      "int _rgb_b_shift_15;"
      "int _rgb_r_shift_16;"
      "int _rgb_g_shift_16;"
      "int _rgb_b_shift_16;"
      "int _rgb_r_shift_24;"
      "int _rgb_g_shift_24;"
      "int _rgb_b_shift_24;"
      "int _rgb_r_shift_32;"
      "int _rgb_g_shift_32;"
      "int _rgb_b_shift_32;"
      "int _rgb_a_shift_32;"
   
      "int _rgb_scale_5[32];"
      "int _rgb_scale_6[64];"
   "}"
));

enum {
    MASK_COLOR_8     = 0,
    MASK_COLOR_15    = 0x7C1F,
    MASK_COLOR_16    = 0xF81F,
    MASK_COLOR_24    = 0xFF00FF,
    MASK_COLOR_32    = 0xFF00FF,
	
	ЦВЕТ_МАСКИ_8     = MASK_COLOR_8,
	ЦВЕТ_МАСКИ_15    = MASK_COLOR_15,
	ЦВЕТ_МАСКИ_16    = MASK_COLOR_16,
	ЦВЕТ_МАСКИ_24    = MASK_COLOR_24,
    ЦВЕТ_МАСКИ_32    = MASK_COLOR_32,
}

mixin(_export!("extern extern (C) int* palette_color;"));


extern (C) {

alias set_color уст_цвет;
alias set_palette уст_палитру;
alias set_palette_range уст_охват_палитры;
alias get_color дай_цвет;
alias get_palette дай_палитру;
alias get_palette_range дай_охват_палитры;
alias fade_interpolate пересечь_тени;
alias fade_from_range затени_из_охвата;
alias fade_in_range затени_охват;
alias fade_out_range оттени_охват;
alias fade_from затени_из; 
alias fade_in затени;
alias fade_out оттени;
alias select_palette выбрать_палитру;
alias unselect_palette отменить_палитру;
alias generate_332_palette ген_332_палитру;
alias generate_optimized_palette ген_оптим_палитру;
alias create_rgb_table созд_табл_кзc;
alias create_light_table созд_табл_света;
alias create_trans_table созд_табл_прозр;
alias create_color_table созд_табл_цвета;
alias create_blender_table созд_табл_смесителя;
alias BLENDER_FUNC ФУНКЦ_СМЕСИТЕЛЯ;
alias set_blender_mode уст_режим_смесителя;
alias set_blender_mode_ex уст_режим_смесителя_доп;
alias set_alpha_blender уст_альфа_смеситель;
alias set_write_alpha_blender уст_зап_альфа_смеситель;
alias set_trans_blender уст_смеситель_прозрачности;
alias set_add_blender уст_доб_смеcитель;


void set_color (int idx, in RGB *p);

void set_palette(in RGB* p);
void set_palette_range (in PALETTE p, int from, int to, int retracesync);

void get_color (int idx, RGB *p);
void get_palette (PALETTE p);
void get_palette_range (PALETTE p, int from, int to);

void fade_interpolate (in PALETTE source, in PALETTE dest, PALETTE output, int pos, int from, int to);
void fade_from_range (in PALETTE source, in PALETTE dest, int speed, int from, int to);
void fade_in_range (in PALETTE p, int speed, int from, int to);
void fade_out_range (int speed, int from, int to);
void fade_from (in PALETTE source, in PALETTE dest, int speed);
void fade_in (in PALETTE p, int speed);
void fade_out (int speed);

void select_palette (in PALETTE p);
void unselect_palette ();

void generate_332_palette (PALETTE pal);
int generate_optimized_palette (BITMAP *image, PALETTE pal, in byte rsvdcols[256]);

void create_rgb_table (RGB_MAP *table, in PALETTE pal, void (*callback) (int pos));
void create_light_table (COLOR_MAP *table, in PALETTE pal, int r, int g, int b, void (*callback) (int pos));
void create_trans_table (COLOR_MAP *table, in PALETTE pal, int r, int g, int b, void (*callback) (int pos));
void create_color_table (COLOR_MAP *table, in PALETTE pal, void (*blend) (in PALETTE pal, int x, int y, RGB *rgb), void (*callback) (int pos));
void create_blender_table (COLOR_MAP *table, in PALETTE pal, void (*callback) (int pos));

alias uint function(uint x, uint y, uint n) BLENDER_FUNC;

void set_blender_mode (BLENDER_FUNC b15, BLENDER_FUNC b16, BLENDER_FUNC b24, int r, int g, int b, int a);
void set_blender_mode_ex (BLENDER_FUNC b15, BLENDER_FUNC b16, BLENDER_FUNC b24, BLENDER_FUNC b32, BLENDER_FUNC b15x, BLENDER_FUNC b16x, BLENDER_FUNC b24x, int r, int g, int b, int a);

void set_alpha_blender ();
void set_write_alpha_blender ();
void set_trans_blender (int r, int g, int b, int a);
void set_add_blender (int r, int g, int b, int a);
void set_burn_blender (int r, int g, int b, int a);
void set_color_blender (int r, int g, int b, int a);
void set_difference_blender (int r, int g, int b, int a);
void set_dissolve_blender (int r, int g, int b, int a);
void set_dodge_blender (int r, int g, int b, int a);
void set_hue_blender (int r, int g, int b, int a);
void set_invert_blender (int r, int g, int b, int a);
void set_luminance_blender (int r, int g, int b, int a);
void set_multiply_blender (int r, int g, int b, int a);
void set_saturation_blender (int r, int g, int b, int a);
void set_screen_blender (int r, int g, int b, int a);

void hsv_to_rgb (float h, float s, float v, int *r, int *g, int *b);
void rgb_to_hsv (int r, int g, int b, float *h, float *s, float *v);

int bestfit_color (in PALETTE pal, int r, int g, int b);

int makecol (int r, int g, int b);
int makecol8 (int r, int g, int b);
int makecol_depth (int color_depth, int r, int g, int b);

int makeacol (int r, int g, int b, int a);
int makeacol_depth (int color_depth, int r, int g, int b, int a);

int makecol15_dither (int r, int g, int b, int x, int y);
int makecol16_dither (int r, int g, int b, int x, int y);

int getr (int c);
int getg (int c);
int getb (int c);
int geta (int c);

int getr_depth (int color_depth, int c);
int getg_depth (int color_depth, int c);
int getb_depth (int color_depth, int c);
int geta_depth (int color_depth, int c);

}  // extern (C)


/* This overload allows the C version to take an RGB* as the argument, which is
 * handy when loading a palette from a data file.
 *
 * NB: Putting set_palette(PALETTE) before the extern (C) block that contains
 * the set_palette(RGB*) overload's prototype triggers a GDC bug on OS X.
 */
void set_palette(PALETTE p) { set_palette(p.ptr); }
