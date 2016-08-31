/*         ______   ___    ___
 *        /\  _  \ /\_ \  /\_ \
 *        \ \ \L\ \\//\ \ \//\ \      __     __   _ __   ___
 *         \ \  __ \ \ \ \  \ \ \   /'__`\ /'_ `\/\`'__\/ __`\
 *          \ \ \/\ \ \_\ \_ \_\ \_/\  __//\ \L\ \ \ \//\ \L\ \
 *           \ \_\ \_\/\____\/\____\ \____\ \____ \ \_\\ \____/
 *            \/_/\/_/\/____/\/____/\/____/\/___L\ \/_/ \/___/
 *                                           /\____/
 *                                           \_/__/
 *
 *      Windows header file for the Allegro library.
 *
 *      It must be included by Allegro programs that need to use
 *      direct Win32 API calls and by Win32 programs that need to
 *      interface with Allegro.
 *
 *      By Shawn Hargreaves.
 *
 *      See readme.txt for copyright information.
 */

module derelict.allegro.winalleg;

version (Tango) {
   import tango.sys.win32.Types;
}
else {
   import os.win32.winuser;
   import os.win32.windef;
}

import derelict.allegro.palette : PALETTE;
import derelict.allegro.gfx : BITMAP;


extern (C):

//#define WINDOWS_RGB(r,g,b)  ((COLORREF)(((BYTE)(r)|((WORD)((BYTE)(g))<<8))|(((DWORD)(BYTE)(b))<<16)))


/* Allegro's Win32 specific interface */


/* external graphics driver support */
/*struct WIN_GFX_DRIVER {
   int has_backing_store;
   void (*switch_in)();
   void (*switch_out)();
   void (*enter_sysmode)();
   void (*exit_sysmode)();
   void (*move)(int x, int y, int w, int h);
   void (*iconify)();
   void (*paint)(RECT* rect);
}*/

//mixin(_export!("extern WIN_GFX_DRIVER* win_gfx_driver;"));

//void win_grab_input();


/* external window support */
HWND win_get_window();
void win_set_window(HWND wnd);
void win_set_wnd_create_proc(HWND (*proc)(WNDPROC));


/* GDI to DirectDraw routines */
HDC win_get_dc(BITMAP* bmp);
void win_release_dc (BITMAP* bmp, HDC dc);


/* GDI routines */
void set_gdi_color_format();
void set_palette_to_hdc(HDC dc, PALETTE pal);
HPALETTE convert_palette_to_hpalette(PALETTE pal);
void convert_hpalette_to_palette(HPALETTE hpal, PALETTE pal);
HBITMAP convert_bitmap_to_hbitmap(BITMAP* bitmap);
BITMAP*  convert_hbitmap_to_bitmap(HBITMAP bitmap);
void draw_to_hdc(HDC dc, BITMAP* bitmap, int x, int y);
void blit_to_hdc(BITMAP* bitmap, HDC dc, int src_x, int src_y, int dest_x, int dest_y, int w, int h);
void stretch_blit_to_hdc (BITMAP* bitmap, HDC dc, int src_x, int src_y, int src_w, int src_h, int dest_x, int dest_y, int dest_w, int dest_h);
void blit_from_hdc (HDC dc, BITMAP* bitmap, int src_x, int src_y, int dest_x, int dest_y, int w, int h);
void stretch_blit_from_hdc (HDC hdc, BITMAP* bitmap, int src_x, int src_y, int src_w, int src_h, int dest_x, int dest_y, int dest_w, int dest_h);
