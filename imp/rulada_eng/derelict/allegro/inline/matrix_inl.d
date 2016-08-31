/***************************************************************
                          inline/matrix.inl
 ***************************************************************/

module derelict.allegro.inline.matrix_inl;

import derelict.allegro.matrix : MATRIX;
import derelict.allegro.fixed : fixed;
import derelict.allegro.fmaths : fixmul;


void apply_matrix(MATRIX *m, fixed x, fixed y, fixed z, fixed *xout, fixed *yout, fixed *zout)
{
   fixed CALC_ROW(fixed n)
   {
      return fixmul(x, m.v[n][0]) + fixmul(y, m.v[n][1]) + fixmul(z, m.v[n][2]) +  m.t[n];
   }

   *xout = CALC_ROW(0);
   *yout = CALC_ROW(1);
   *zout = CALC_ROW(2);
}
