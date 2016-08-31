/***************************************************************
                          inline/color.inl
 ***************************************************************/

module derelict.allegro.inline.color_inl;

import derelict.allegro.color;


int makecol15 (int r, int g, int b)
{
   return (((r >> 3) << _rgb_r_shift_15) | ((g >> 3) << _rgb_g_shift_15) |
                                           ((b >> 3) << _rgb_b_shift_15));
}

int makecol16 (int r, int g, int b)
{
   return (((r >> 3) << _rgb_r_shift_16) | ((g >> 2) << _rgb_g_shift_16) |
                                           ((b >> 3) << _rgb_b_shift_16));
}

int makecol24 (int r, int g, int b)
{
   return ((r << _rgb_r_shift_24) | (g << _rgb_g_shift_24) |
                                    (b << _rgb_b_shift_24));
}

int makecol32 (int r, int g, int b)
{
   return ((r << _rgb_r_shift_32) | (g << _rgb_g_shift_32) |
                                    (b << _rgb_b_shift_32));
}

int makeacol32 (int r, int g, int b, int a)
{
   return ((r << _rgb_r_shift_32) | (g << _rgb_g_shift_32) |
                              (b << _rgb_b_shift_32) | (a << _rgb_a_shift_32));
}

int getr8 (int c)
{
   return _rgb_scale_6[cast(int)_current_palette[c].r];
}

int getg8 (int c)
{
   return _rgb_scale_6[cast(int)_current_palette[c].g];
}

int getb8 (int c)
{
   return _rgb_scale_6[cast(int)_current_palette[c].b];
}

int getr15 (int c)
{
   return _rgb_scale_5[(c >> _rgb_r_shift_15) & 0x1F];
}

int getg15 (int c)
{
   return _rgb_scale_5[(c >> _rgb_g_shift_15) & 0x1F];
}

int getb15 (int c)
{
   return _rgb_scale_5[(c >> _rgb_b_shift_15) & 0x1F];
}

int getr16 (int c)
{
   return _rgb_scale_5[(c >> _rgb_r_shift_16) & 0x1F];
}

int getg16 (int c)
{
   return _rgb_scale_6[(c >> _rgb_g_shift_16) & 0x3F];
}

int getb16 (int c)
{
   return _rgb_scale_5[(c >> _rgb_b_shift_16) & 0x1F];
}

int getr24 (int c)
{
   return ((c >> _rgb_r_shift_24) & 0xFF);
}

int getg24 (int c)
{
   return ((c >> _rgb_g_shift_24) & 0xFF);
}

int getb24 (int c)
{
   return ((c >> _rgb_b_shift_24) & 0xFF);
}

int getr32 (int c)
{
   return ((c >> _rgb_r_shift_32) & 0xFF);
}

int getg32 (int c)
{
   return ((c >> _rgb_g_shift_32) & 0xFF);
}

int getb32 (int c)
{
   return ((c >> _rgb_b_shift_32) & 0xFF);
}

int geta32 (int c)
{
   return ((c >> _rgb_a_shift_32) & 0xFF);
}


//#ifndef ALLEGRO_DOS

void _set_color(int idx, in RGB *p)
{
   set_color(idx, p);
}

//#endif
