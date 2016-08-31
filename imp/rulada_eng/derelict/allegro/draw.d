/***************************************************************
                           draw.h
 ***************************************************************/

module derelict.allegro.draw;

public import derelict.allegro.inline.draw_inl;

import derelict.allegro.fixed : fixed;
import derelict.allegro.gfx : BITMAP;


enum {
    DRAW_MODE_SOLID             = 0,     /* flags for drawing_mode() */
    DRAW_MODE_XOR               = 1,
    DRAW_MODE_COPY_PATTERN      = 2,
    DRAW_MODE_SOLID_PATTERN     = 3,
    DRAW_MODE_MASKED_PATTERN    = 4,
    DRAW_MODE_TRANS             = 5,
}

extern (C) {

void drawing_mode(int mode,  BITMAP *pattern, int x_anchor, int y_anchor);
void xor_mode(int on);
void solid_mode();
void do_line(BITMAP *bmp, int x1, int y_1, int x2, int y2, int d, void (*proc)(BITMAP *, int, int, int));
void _soft_triangle(BITMAP *bmp, int x1, int y_1, int x2, int y2, int x3, int y3, int color);
void _soft_polygon(BITMAP *bmp, int vertices,  in int *points, int color);
void _soft_rect(BITMAP *bmp, int x1, int y_1, int x2, int y2, int color);
void do_circle(BITMAP *bmp, int x, int y, int radius, int d, void (*proc)(BITMAP *, int, int, int));
void _soft_circle(BITMAP *bmp, int x, int y, int radius, int color);
void _soft_circlefill(BITMAP *bmp, int x, int y, int radius, int color);
void do_ellipse(BITMAP *bmp, int x, int y, int rx, int ry, int d, void (*proc)(BITMAP *, int, int, int));
void _soft_ellipse(BITMAP *bmp, int x, int y, int rx, int ry, int color);
void _soft_ellipsefill(BITMAP *bmp, int x, int y, int rx, int ry, int color);
void do_arc(BITMAP *bmp, int x, int y, fixed ang1, fixed ang2, int r, int d, void (*proc)(BITMAP *, int, int, int));
void _soft_arc(BITMAP *bmp, int x, int y, fixed ang1, fixed ang2, int r, int color);
void calc_spline(in int points[8], int npts, int *x, int *y);
void _soft_spline(BITMAP *bmp,  in int points[8], int color);
void _soft_floodfill(BITMAP *bmp, int x, int y, int color);
void blit(BITMAP *source,  BITMAP *dest, int source_x, int source_y, int dest_x, int dest_y, int width, int height);
void masked_blit(BITMAP *source,  BITMAP *dest, int source_x, int source_y, int dest_x, int dest_y, int width, int height);
void stretch_blit(BITMAP *s,  BITMAP *d, int s_x, int s_y, int s_w, int s_h, int d_x, int d_y, int d_w, int d_h);
void masked_stretch_blit(BITMAP *s,  BITMAP *d, int s_x, int s_y, int s_w, int s_h, int d_x, int d_y, int d_w, int d_h);
void stretch_sprite(BITMAP *bmp,  BITMAP *sprite, int x, int y, int w, int h);
void _soft_draw_gouraud_sprite(BITMAP *bmp,  BITMAP *sprite, int x, int y, int c1, int c2, int c3, int c4);

} // extern (C)
