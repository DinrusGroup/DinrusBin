/***************************************************************
                           fmaths.h
 ***************************************************************/

module derelict.allegro.fmaths;

public import derelict.allegro.inline.fmaths_inl;

import derelict.allegro.fixed : fixed;
import derelict.allegro.base : allegro_errno;
import derelict.allegro.internal._export;


extern (C) {
   fixed fixsqrt (fixed x);
   fixed fixhypot (fixed x, fixed y);
   fixed fixatan (fixed x);
   fixed fixatan2 (fixed y, fixed x);
}

mixin(_export!(
   "extern extern (C) {"
      // sizes taken from math.c
      "fixed _cos_tbl[512];"
      "fixed _tan_tbl[256];"
      "fixed _acos_tbl[513];"
   "}"
));
