/***************************************************************
                          text.h
 ***************************************************************/
module derelict.allegro.text;

import derelict.allegro.gfx : BITMAP;
import derelict.allegro.font : FONT;
import derelict.allegro.internal._export;


mixin(_export!(
   "extern extern (C) {"
      "FONT *font;"
      "int allegro_404_char;"
   "}"
));

extern (C) {

alias textout_ex текствыв_доп;
alias textout_centre_ex текствыв_вцентр_доп;
alias textout_right_ex  текствыв_вправо_доп;
alias text_length длина_текста;
alias text_height высота_текста;
alias destroy_font удалить_шрифт;
alias textprintf_justify_ex текствыводф_растяни_доп;
alias textprintf_right_ex текствыводф_справа_доп;
alias textprintf_centre_ex текствыводф_вцентр_доп;
alias textprintf_ex текствыводф_доп;
alias textout_justify_ex текствыв_растяни_доп;

void textout_ex (BITMAP *bmp, in FONT *f, in char *str, int x, int y, int color, int bg);
void textout_centre_ex (BITMAP *bmp, in FONT *f, in char *str, int x, int y, int color, int bg);
void textout_right_ex (BITMAP *bmp, in FONT *f, in char *str, int x, int y, int color, int bg);
void textout_justify_ex (BITMAP *bmp, in FONT *f, in char *str, int x1, int x2, int y, int diff, int color, int bg);
void textprintf_ex (BITMAP *bmp, in FONT *f, int x, int y, int color, int bg, in char *format, ...);
void textprintf_centre_ex (BITMAP *bmp, in FONT *f, int x, int y, int color, int bg, in char *format, ...);
void textprintf_right_ex (BITMAP *bmp, in FONT *f, int x, int y, int color, int bg, in char *format, ...);
void textprintf_justify_ex (BITMAP *bmp, in FONT *f, int x1, int x2, int y, int diff, int color, int bg, in char *format, ...);
int text_length (in FONT *f, in char *str);
int text_height (in FONT *f);
void destroy_font (FONT *f);

} // extern (C)
