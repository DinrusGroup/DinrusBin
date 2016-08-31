/***************************************************************
                           matrix.h
 ***************************************************************/

module derelict.allegro.matrix;

public import derelict.allegro.inline.matrix_inl;

import derelict.allegro.fixed : fixed;
import derelict.allegro.internal._export;


struct MATRIX                    /* transformation matrix (fixed point) */
{
   fixed v[3][3];                /* scaling and rotation */
   fixed t[3];                   /* translation */
}


struct MATRIX_f                  /* transformation matrix (floating point) */
{
   float v[3][3];                /* scaling and rotation */
   float t[3];                   /* translation */
}


mixin(_export!(
   "extern (C) {"
      "extern MATRIX identity_matrix;"
      "extern MATRIX_f identity_matrix_f;"
   "}"
));

extern (C) {

void get_translation_matrix (MATRIX *m, fixed x, fixed y, fixed z);
void get_translation_matrix_f (MATRIX_f *m, float x, float y, float z);

void get_scaling_matrix (MATRIX *m, fixed x, fixed y, fixed z);
void get_scaling_matrix_f (MATRIX_f *m, float x, float y, float z);

void get_x_rotate_matrix (MATRIX *m, fixed r);
void get_x_rotate_matrix_f (MATRIX_f *m, float r);

void get_y_rotate_matrix (MATRIX *m, fixed r);
void get_y_rotate_matrix_f (MATRIX_f *m, float r);

void get_z_rotate_matrix (MATRIX *m, fixed r);
void get_z_rotate_matrix_f (MATRIX_f *m, float r);

void get_rotation_matrix (MATRIX *m, fixed x, fixed y, fixed z);
void get_rotation_matrix_f (MATRIX_f *m, float x, float y, float z);

void get_align_matrix (MATRIX *m, fixed xfront, fixed yfront, fixed zfront, fixed xup, fixed yup, fixed zup);
void get_align_matrix_f (MATRIX_f *m, float xfront, float yfront, float zfront, float xup, float yup, float zup);

void get_vector_rotation_matrix (MATRIX *m, fixed x, fixed y, fixed z, fixed a);
void get_vector_rotation_matrix_f (MATRIX_f *m, float x, float y, float z, float a);

void get_transformation_matrix (MATRIX *m, fixed scale, fixed xrot, fixed yrot, fixed zrot, fixed x, fixed y, fixed z);
void get_transformation_matrix_f (MATRIX_f *m, float scale, float xrot, float yrot, float zrot, float x, float y, float z);

void get_camera_matrix (MATRIX *m, fixed x, fixed y, fixed z, fixed xfront, fixed yfront, fixed zfront, fixed xup, fixed yup, fixed zup, fixed fov, fixed aspect);
void get_camera_matrix_f (MATRIX_f *m, float x, float y, float z, float xfront, float yfront, float zfront, float xup, float yup, float zup, float fov, float aspect);

void qtranslate_matrix (MATRIX *m, fixed x, fixed y, fixed z);
void qtranslate_matrix_f (MATRIX_f *m, float x, float y, float z);

void qscale_matrix (MATRIX *m, fixed scale);
void qscale_matrix_f (MATRIX_f *m, float scale);

void matrix_mul (in MATRIX *m1, in MATRIX *m2, MATRIX *_out);
void matrix_mul_f (in MATRIX_f *m1, in MATRIX_f *m2, MATRIX_f *_out);

void apply_matrix_f (MATRIX_f *m, float x, float y, float z, float *xout, float *yout, float *zout);

}  // extern (C)
