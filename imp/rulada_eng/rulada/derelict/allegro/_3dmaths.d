/***************************************************************
                           _3dmaths.h
 ***************************************************************/

module derelict.allegro._3dmaths;

public import derelict.allegro.inline._3dmaths_inl;

import derelict.allegro.fixed : fixed;
import derelict.allegro.matrix : MATRIX_f;
import derelict.allegro.quat : QUAT;
import derelict.allegro.internal._export;


extern (C) {
fixed vector_length (fixed x, fixed y, fixed z);
float vector_length_f (float x, float y, float z);

void normalize_vector (fixed *x, fixed *y, fixed *z);
void normalize_vector_f (float *x, float *y, float *z);

void cross_product (fixed x1, fixed y_1, fixed z1, fixed x2, fixed y2, fixed z2, fixed *xout, fixed *yout, fixed *zout);
void cross_product_f (float x1, float y_1, float z1, float x2, float y2, float z2, float *xout, float *yout, float *zout);
}  // extern (C)

mixin(_export!(
   "extern (C) {"
      "extern fixed _persp_xscale;"
      "extern fixed _persp_yscale;"
      "extern fixed _persp_xoffset;"
      "extern fixed _persp_yoffset;"
   
      "extern float _persp_xscale_f;"
      "extern float _persp_yscale_f;"
      "extern float _persp_xoffset_f;"
      "extern float _persp_yoffset_f;"
   "}"
));

extern (C) {
void set_projection_viewport (int x, int y, int w, int h);

void quat_to_matrix (in QUAT *q, MATRIX_f *m);
void matrix_to_quat (in MATRIX_f *m, QUAT *q);
}  // extern (C)

