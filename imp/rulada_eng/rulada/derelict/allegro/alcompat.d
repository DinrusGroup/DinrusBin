/***************************************************************
                           alcompat.h
 ***************************************************************/

module derelict.allegro.alcompat;

import derelict.allegro.base : al_long;
import derelict.allegro.fmaths;
import derelict.allegro.joystick;
import derelict.allegro.gui : object_message, file_select_ex, gui_textout_ex;
import derelict.allegro.system;
import derelict.allegro.color;
import derelict.allegro.fli : fli_palette;
import derelict.allegro.datafile : DAT_PALETTE;
import derelict.allegro.file : canonicalize_filename;
import derelict.allegro.font : FONT;
import derelict.allegro.text;
import derelict.allegro.draw : draw_character_ex;
import derelict.allegro.internal._export;

version (ALLEGRO_NO_CLEAR_BITMAP_ALIAS) {
}
else {
   import derelict.allegro.gfx : clear_bitmap, BITMAP;
   alias derelict.allegro.gfx.clear_bitmap clear;
}

version (ALLEGRO_NO_FIX_ALIASES) {
}
else {
   alias fixadd fadd;
   alias fixsub fsub;
   alias fixmul fmul;
   alias fixdiv fdiv;
   alias fixceil fceil;
   alias fixfloor ffloor;
   alias fixcos fcos;
   alias fixsin fsin;
   alias fixtan ftan;
   alias fixacos facos;
   alias fixasin fasin;
   alias fixatan fatan;
   alias fixatan2 fatan2;
   alias fixsqrt fsqrt;
   alias fixhypot fhypot;
}


enum {
   KB_NORMAL     = 1,
   KB_EXTENDED   = 2
}

alias object_message    SEND_MESSAGE;

int cpu_fpu() { return (cpu_capabilities & CPU_FPU); }
int cpu_mmx() { return (cpu_capabilities & CPU_MMX); }
int cpu_3dnow() { return (cpu_capabilities & CPU_3DNOW); }
int cpu_cpuid() { return (cpu_capabilities & CPU_ID); }

int joy_x() { return joy[0].stick[0].axis[0].pos; }
int joy_y() { return joy[0].stick[0].axis[1].pos; }
int joy_left() { return joy[0].stick[0].axis[0].d1; }
int joy_right() { return joy[0].stick[0].axis[0].d2; }
int joy_up() { return joy[0].stick[0].axis[1].d1; }
int joy_down() { return joy[0].stick[0].axis[1].d2; }
int joy_b1() { return joy[0].button[0].b; }
int joy_b2() { return joy[0].button[1].b; }
int joy_b3() { return joy[0].button[2].b; }
int joy_b4() { return joy[0].button[3].b; }
int joy_b5() { return joy[0].button[4].b; }
int joy_b6() { return joy[0].button[5].b; }
int joy_b7() { return joy[0].button[6].b; }
int joy_b8() { return joy[0].button[7].b; }

int joy2_x() { return joy[1].stick[0].axis[0].pos; }
int joy2_y() { return joy[1].stick[0].axis[1].pos; }
int joy2_left() { return joy[1].stick[0].axis[0].d1; }
int joy2_right() { return joy[1].stick[0].axis[0].d2; }
int joy2_up() { return joy[1].stick[0].axis[1].d1; }
int joy2_down() { return joy[1].stick[0].axis[1].d2; }
int joy2_b1() { return joy[1].button[0].b; }
int joy2_b2() { return joy[1].button[1].b; }

int joy_throttle() { return joy[0].stick[2].axis[0].pos; }

int joy_hat()
{
   return (joy[0].stick[1].axis[0].d1) ? 1 :
             ((joy[0].stick[1].axis[0].d2) ? 3 :
                ((joy[0].stick[1].axis[1].d1) ? 4 :
                   ((joy[0].stick[1].axis[1].d2) ? 2 :
                      0)));
}

enum {
   JOY_HAT_CENTRE      = 0,
   JOY_HAT_CENTER      = 0,
   JOY_HAT_LEFT        = 1,
   JOY_HAT_DOWN        = 2,
   JOY_HAT_RIGHT       = 3,
   JOY_HAT_UP          = 4
}

extern (C)
deprecated int initialise_joystick();


/* in case you want to spell 'palette' as 'pallete' */
alias PALETTE                        PALLETE;
alias black_palette                  black_pallete;
alias desktop_palette                desktop_pallete;
alias set_palette                    set_pallete;
alias get_palette                    get_pallete;
alias set_palette_range              set_pallete_range;
alias get_palette_range              get_pallete_range;
alias fli_palette                    fli_pallete;
alias palette_color                  pallete_color;
alias DAT_PALETTE                    DAT_PALLETE;
alias select_palette                 select_pallete;
alias unselect_palette               unselect_pallete;
alias generate_332_palette           generate_332_pallete;
alias generate_optimized_palette     generate_optimized_pallete;


/* a pretty vague name */
alias canonicalize_filename              fix_filename_path;


/* the good old file selector */
enum {
   OLD_FILESEL_WIDTH   = -1,
   OLD_FILESEL_HEIGHT  = -1
}

deprecated int file_select(in char *message, char *path, in char *ext)
{
   return file_select_ex(message, path, ext, 1024, OLD_FILESEL_WIDTH, OLD_FILESEL_HEIGHT);
}


/* the old (and broken!) file enumeration function */
deprecated int for_each_file(in char *name, int attrib, void (*callback) (in char *filename, int attrib, int param), int param);
/* long is 32-bit only on some systems, and we want to list DVDs! */
deprecated al_long file_size(in char *filename);


/* the old state-based textout functions */

mixin(_export!("extern extern (C) int _textmode;"));

deprecated extern (C) int text_mode(int mode);

deprecated void textout(BITMAP *bmp, in FONT *f, in char *str, int x, int y, int color)
{
   textout_ex(bmp, f, str, x, y, color, _textmode);
}

deprecated void textout_centre(BITMAP *bmp, in FONT *f, in char *str, int x, int y, int color)
{
   textout_centre_ex(bmp, f, str, x, y, color, _textmode);
}

deprecated void textout_right(BITMAP *bmp, in FONT *f, in char *str, int x, int y, int color)
{
   textout_right_ex(bmp, f, str, x, y, color, _textmode);
}

deprecated void textout_justify(BITMAP *bmp, in FONT *f, in char *str, int x1, int x2, int y, int diff, int color)
{
   textout_justify_ex(bmp, f, str, x1, x2, y, diff, color, _textmode);
}

extern (C) {
deprecated void textprintf(BITMAP *bmp, in FONT *f, int x, int y, int color, in char *format, ...);
deprecated void textprintf_centre(BITMAP *bmp, in FONT *f, int x, int y, int color, in char *format, ...);
deprecated void textprintf_right(BITMAP *bmp, in FONT *f, int x, int y, int color, in char *format, ...);
deprecated void textprintf_justify(BITMAP *bmp, in FONT *f, int x1, int x2, int y, int diff, int color, in char *format, ...);
}

deprecated void draw_character(BITMAP *bmp, BITMAP *sprite, int x, int y, int color)
{
   draw_character_ex(bmp, sprite, x, y, color, _textmode);
}

deprecated int gui_textout(BITMAP *bmp, in char *s, int x, int y, int color, int centre)
{
   return gui_textout_ex(bmp, s, x, y, color, _textmode, centre);
}


/* the old close button functions */
deprecated int set_window_close_button(int enable)
{
   return 0;
}

private extern (C) alias void function() void_c_func_no_args;

deprecated void set_window_close_hook (void_c_func_no_args proc)
{
   set_close_button_callback(proc);
}


/* the weird old clipping API */
extern (C) deprecated void set_clip(BITMAP *bitmap, int x1, int y_1, int x2, int y2);


/* unnecessary, can use rest(0)
 *
 * D-Allegro FIXME:
 * If this function is removed these symbols are not needed anymore:
 *   - derelict.allegro.base._DRIVER_INFO
 */
deprecated void yield_timeslice()
{
   assert(system_driver);

   if (system_driver.yield_timeslice)
      system_driver.yield_timeslice();
}


/* DOS-ish monitor retrace ideas that don't work elsewhere */
extern (C) {
   mixin(_export!("extern void (*retrace_proc)();"));

   deprecated int timer_can_simulate_retrace();
   deprecated void timer_simulate_retrace(int enable);

   deprecated int timer_is_using_retrace();
}
