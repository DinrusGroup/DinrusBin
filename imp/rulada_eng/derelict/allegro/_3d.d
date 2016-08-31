/***************************************************************
                           3d.h
 ***************************************************************/

module derelict.allegro._3d;

import derelict.allegro.fixed : fixed;
import derelict.allegro.gfx : BITMAP;
import derelict.allegro.internal._export;


struct V3D                          /* a 3d point (fixed point version) */
{
   fixed x, y, z;                   /* position */
   fixed u, v;                      /* texture map coordinates */
   int c;                           /* color */
}


struct V3D_f                        /* a 3d point (floating point version) */
{
   float x, y, z;                   /* position */
   float u, v;                      /* texture map coordinates */
   int c;                           /* color */
}


enum {
   POLYTYPE_FLAT               = 0,
   POLYTYPE_GCOL               = 1,
   POLYTYPE_GRGB               = 2,
   POLYTYPE_ATEX               = 3,
   POLYTYPE_PTEX               = 4,
   POLYTYPE_ATEX_MASK          = 5,
   POLYTYPE_PTEX_MASK          = 6,
   POLYTYPE_ATEX_LIT           = 7,
   POLYTYPE_PTEX_LIT           = 8,
   POLYTYPE_ATEX_MASK_LIT      = 9,
   POLYTYPE_PTEX_MASK_LIT      = 10,
   POLYTYPE_ATEX_TRANS         = 11,
   POLYTYPE_PTEX_TRANS         = 12,
   POLYTYPE_ATEX_MASK_TRANS    = 13,
   POLYTYPE_PTEX_MASK_TRANS    = 14,
   POLYTYPE_MAX                = 15,
   POLYTYPE_ZBUF               = 16,
}

mixin(_export!("extern extern (C) float scene_gap;"));

extern (C) {

void _soft_polygon3d ( BITMAP *bmp, int type,  BITMAP *texture, int vc, V3D **vtx);
void _soft_polygon3d_f ( BITMAP *bmp, int type,  BITMAP *texture, int vc, V3D_f **vtx);
void _soft_triangle3d ( BITMAP *bmp, int type,  BITMAP *texture, V3D *v1, V3D *v2, V3D *v3);
void _soft_triangle3d_f ( BITMAP *bmp, int type,  BITMAP *texture, V3D_f *v1, V3D_f *v2, V3D_f *v3);
void _soft_quad3d ( BITMAP *bmp, int type,  BITMAP *texture, V3D *v1, V3D *v2, V3D *v3, V3D *v4);
void _soft_quad3d_f ( BITMAP *bmp, int type,  BITMAP *texture, V3D_f *v1, V3D_f *v2, V3D_f *v3, V3D_f *v4);
int clip3d (int type, fixed min_z, fixed max_z, int vc,  in V3D **vtx, V3D **vout, V3D **vtmp, int *_out);
int clip3d_f (int type, float min_z, float max_z, int vc,  in V3D_f **vtx, V3D_f **vout, V3D_f **vtmp, int *_out);

fixed polygon_z_normal ( in V3D *v1,  in V3D *v2,  in V3D *v3);
float polygon_z_normal_f ( in V3D_f *v1,  in V3D_f *v2,  in V3D_f *v3);

} // extern (C)

/* Note: You are not supposed to mix ZBUFFER with BITMAP even though it is
 * currently possible. This is just the internal representation, and it may
 * change in the future.
 */
alias BITMAP ZBUFFER;

extern (C) {

ZBUFFER * create_zbuffer (BITMAP *bmp);
ZBUFFER * create_sub_zbuffer (ZBUFFER *parent, int x, int y, int width, int height);
void set_zbuffer (ZBUFFER *zbuf);
void clear_zbuffer (ZBUFFER *zbuf, float z);
void destroy_zbuffer (ZBUFFER *zbuf);

int create_scene (int nedge, int npoly);
void clear_scene ( BITMAP* bmp);
void destroy_scene ();
int scene_polygon3d (int type,  BITMAP *texture, int vx, V3D **vtx);
int scene_polygon3d_f (int type,  BITMAP *texture, int vx, V3D_f **vtx);
void render_scene ();

}  // extern (C)
