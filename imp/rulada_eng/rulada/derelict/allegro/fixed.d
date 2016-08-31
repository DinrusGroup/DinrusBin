/***************************************************************
                           fixed.h
 ***************************************************************/

module derelict.allegro.fixed;

import derelict.allegro.internal._export;

alias int fixed;
alias fixed фикс;

mixin(_export!(
   "extern extern (C) {"
      "const fixed fixtorad_r;"
      "const fixed radtofix_r;"
   "}"
));
