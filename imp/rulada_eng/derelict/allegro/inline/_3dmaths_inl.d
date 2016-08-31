/***************************************************************
                          inline/3dmaths.inl
 ***************************************************************/

module derelict.allegro.inline._3dmaths_inl;

import derelict.allegro._3dmaths;
import derelict.allegro.fixed : fixed;
import derelict.allegro.fmaths : fixmul, fixdiv;


fixed dot_product(fixed x1, fixed y_1, fixed z1, fixed x2, fixed y2, fixed z2)
{
   return fixmul(x1, x2) + fixmul(y_1, y2) + fixmul(z1, z2);
}


float dot_product_f(float x1, float y_1, float z1, float x2, float y2, float z2)
{
   return (x1 * x2) + (y_1 * y2) + (z1 * z2);
}


void persp_project(fixed x, fixed y, fixed z, fixed *xout, fixed *yout)
{
   *xout = fixmul(fixdiv(x, z), _persp_xscale) + _persp_xoffset;
   *yout = fixmul(fixdiv(y, z), _persp_yscale) + _persp_yoffset;
}


void persp_project_f(float x, float y, float z, float *xout, float *yout)
{
   float z1 = 1.0f / z;
   *xout = ((x * z1) * _persp_xscale_f) + _persp_xoffset_f;
   *yout = ((y * z1) * _persp_yscale_f) + _persp_yoffset_f;
}
