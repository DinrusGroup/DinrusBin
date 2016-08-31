   /***************************************************************
                           quat.h
 ***************************************************************/

module derelict.allegro.quat;

import derelict.allegro.internal._export;



struct QUAT
{
     float w, x, y, z;
}

mixin(_export!("extern (C) extern QUAT identity_quat;"));

extern (C) {

void quat_mul (in QUAT *p, in QUAT *q, QUAT *_out);
void get_x_rotate_quat (QUAT *q, float r);
void get_y_rotate_quat (QUAT *q, float r);
void get_z_rotate_quat (QUAT *q, float r);
void get_rotation_quat (QUAT *q, float x, float y, float z);
void get_vector_rotation_quat (QUAT *q, float x, float y, float z, float a);

void apply_quat (in QUAT *q, float x, float y, float z, float *xout, float *yout, float *zout);
void quat_slerp (in QUAT *from, in QUAT *to, float t, QUAT *_out, int how);

}  // extern (C)

enum {
   QUAT_SHORT = 0,
   QUAT_LONG  = 1,
   QUAT_CW    = 2,
   QUAT_CCW   = 3,
   QUAT_USER  = 4,
}

void quat_interpolate(in QUAT* from, in QUAT* to, float t, QUAT* _out)
{
   quat_slerp(from, to, t, _out, QUAT_SHORT);
}
