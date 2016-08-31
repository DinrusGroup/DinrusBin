/***************************************************************
                           gfx.h
 ***************************************************************/

module derelict.allegro.gfx;

public import derelict.allegro.inline.gfx_inl;

import derelict.allegro.base : _AL_ID;
import derelict.allegro.rle : RLE_SPRITE;
import derelict.allegro.palette: RGB;
import derelict.allegro.font : FONT_GLYPH;
import derelict.allegro.fixed : fixed;
import derelict.allegro._3d : V3D, V3D_f;
import derelict.allegro.internal._export;


const int GFX_TEXT                     = -1;
const int GFX_AUTODETECT               =  0;
const int GFX_AUTODETECT_FULLSCREEN    =  1;
const int GFX_AUTODETECT_WINDOWED      =  2;
const int GFX_SAFE                     = _AL_ID!('S','A','F','E');

const цел ГФКС_ТЕКСТ 				= GFX_TEXT;
const цел ГФКС_АВТООПРЕД 			= GFX_AUTODETECT;
const цел ГФКС_АВТООПРЕД_ПОЛНОЭКРАН = GFX_AUTODETECT_FULLSCREEN;
const цел ГФКС_АВТООПРЕД_ОКНОМ 		= GFX_AUTODETECT_WINDOWED;
const цел ГФКС_БЕЗОПАСНЫЙ			 = GFX_SAFE;

/* Blender mode defines, for the gfx_driver->set_blender_mode() function */
enum {
    blender_mode_none         =  0,
    blender_mode_trans        =  1,
    blender_mode_add          =  2,
    blender_mode_burn         =  3,
    blender_mode_color        =  4,
    blender_mode_difference   =  5,
    blender_mode_dissolve     =  6,
    blender_mode_dodge        =  7,
    blender_mode_hue          =  8,
    blender_mode_invert       =  9,
    blender_mode_luminance    = 10,
    blender_mode_multiply     = 11,
    blender_mode_saturation   = 12,
    blender_mode_screen       = 13,
    blender_mode_alpha        = 14,
	режим_смесителя_отс         =  blender_mode_none,
    режим_смесителя_транс        =  blender_mode_trans,
    режим_смесителя_доб         =  blender_mode_add,
    режим_смесителя_прож         =  blender_mode_burn,
    режим_смесителя_цвет        =  blender_mode_color ,
    режим_смесителя_дельта  	 =  blender_mode_difference,
    режим_смесителя_раствор     =  blender_mode_dissolve,
    режим_смесителя_уверт        =  blender_mode_dodge,
    режим_смесителя_хью          =  blender_mode_hue,
    режим_смесителя_инверт       =  blender_mode_invert,
    режим_смесителя_свечение    = blender_mode_luminance,
    режим_смесителя_умнож     = blender_mode_multiply,
    режим_смесителя_насыщение   = blender_mode_saturation,
    режим_смесителя_экран       = blender_mode_screen,
    режим_смесителя_альфа        = blender_mode_alpha ,
}
alias GFX_MODE РЕЖИМ_ГФКС;
struct GFX_MODE
{
alias width ширина;
alias height высота;
alias bpp бнп;

   int width, height, bpp;
}

alias GFX_MODE_LIST СПИСОК_РЕЖИМОВ_ГФКС;
struct GFX_MODE_LIST
{
alias num_modes чло_режимов;
alias mode режим;

   int num_modes;                /* число режимов gfx */
   GFX_MODE *mode;       /* указатель на действительный массив списка режимов*/
}

alias GFX_DRIVER ДРАЙВЕР_ГФКС;
extern (C) struct GFX_DRIVER     /* создает и управляет экранным битмапом */
{
alias id ид;
alias name имя;
alias desc опис;
alias ascii_name аски_имя;
alias init иниц;
alias exit выход;
alias scroll прокрут;
alias vsync всинх;
alias set_palette уст_палитру;
alias request_scroll запроси_прокрут;
alias poll_scroll опроси_прокрут;
alias enable_triple_buffer вкл_тройн_буфер;
alias create_video_bitmap создай_видео_битмап;
alias destroy_video_bitmap разрушь_видео_битмап;
alias show_video_bitmap покажи_видео_битмап;
alias request_video_bitmap запроси_видео_битмап;
alias create_system_bitmap создай_сис_битмап;
alias destroy_system_bitmap разрушь_сис_битмап;
alias set_mouse_sprite уст_спрайт_мыши;
alias show_mouse покажи_мышь;
alias hide_mouse спрячь_мышь;
alias move_mouse двигай_мышь;
alias drawing_mode режим_рис;
alias save_video_state сохрани_видео_сост;
alias restore_video_state восстанови_видео_сост;
alias set_blender_mode уст_реж_смесителя;
alias fetch_mode_list выбери_список_реж;
alias w ш;
alias h в;
alias linear линейный;
alias bank_size размер_банка;
alias bank_gran гран_банка;
alias vid_mem вид_пам;
alias vid_phys_base физ_вид_база;
alias windowed оконный;

   int id;
   const char *name;
   const char *desc;
   const char *ascii_name;
   BITMAP * (*init) (int w, int h, int v_w, int v_h, int color_depth);
   void (*exit) (BITMAP *b);
   int (*scroll) (int x, int y);
   void (*vsync) ();
   void (*set_palette) (in RGB *p, int from, int to, int retracesync);
   int (*request_scroll) (int x, int y);
   int (*poll_scroll) ();
   void (*enable_triple_buffer) ();
    BITMAP * (*create_video_bitmap) (int width, int height);
   void (*destroy_video_bitmap) (BITMAP *bitmap);
   int (*show_video_bitmap) (BITMAP *bitmap);
   int (*request_video_bitmap) (BITMAP *bitmap);
    BITMAP * (*create_system_bitmap) (int width, int height);
   void (*destroy_system_bitmap) (BITMAP *bitmap);
   int (*set_mouse_sprite) (BITMAP *sprite, int xfocus, int yfocus);
   int (*show_mouse) (BITMAP *bmp, int x, int y);
   void (*hide_mouse) ();
   void (*move_mouse) (int x, int y);
   void (*drawing_mode) ();
   void (*save_video_state) ();
   void (*restore_video_state) ();
   void (*set_blender_mode) (int mode, int r, int g, int b, int a);
   GFX_MODE_LIST * (*fetch_mode_list) ();
   int w, h;                     /* физический (не виртуальный!) размер экрана */
   int linear;                   /* true, если видеопамять линейна */
   int bank_size;                /* размер банка, в байтах */
   int bank_gran;                /* гранулярность банка, в байтах */
   int vid_mem;                  /* размер видеопамяти, в байтах */
   int vid_phys_base;            /* физический адрес видеопамяти */
   int windowed;                 /* true, если драйвер запущен в оконном режиме */
}

mixin(_export!("extern extern (C) GFX_DRIVER * gfx_driver;"));
//_DRIVER_INFO _gfx_driver_list[];


/* macros for constructing the driver list */
/*#define BEGIN_GFX_DRIVER_LIST                      \
   _DRIVER_INFO _gfx_driver_list[] =               \
   {

#define END_GFX_DRIVER_LIST                        \
      {  0,          NULL,       0     }           \
   };
*/

enum {
    GFX_CAN_SCROLL                    = 0x00000001,
    GFX_CAN_TRIPLE_BUFFER             = 0x00000002,
    GFX_HW_CURSOR                     = 0x00000004,
    GFX_HW_HLINE                      = 0x00000008,
    GFX_HW_HLINE_XOR                  = 0x00000010,
    GFX_HW_HLINE_SOLID_PATTERN        = 0x00000020,
    GFX_HW_HLINE_COPY_PATTERN         = 0x00000040,
    GFX_HW_FILL                       = 0x00000080,
    GFX_HW_FILL_XOR                   = 0x00000100,
    GFX_HW_FILL_SOLID_PATTERN         = 0x00000200,
    GFX_HW_FILL_COPY_PATTERN          = 0x00000400,
    GFX_HW_LINE                       = 0x00000800,
    GFX_HW_LINE_XOR                   = 0x00001000,
    GFX_HW_TRIANGLE                   = 0x00002000,
    GFX_HW_TRIANGLE_XOR               = 0x00004000,
    GFX_HW_GLYPH                      = 0x00008000,
    GFX_HW_VRAM_BLIT                  = 0x00010000,
    GFX_HW_VRAM_BLIT_MASKED           = 0x00020000,
    GFX_HW_MEM_BLIT                   = 0x00040000,
    GFX_HW_MEM_BLIT_MASKED            = 0x00080000,
    GFX_HW_SYS_TO_VRAM_BLIT           = 0x00100000,
    GFX_HW_SYS_TO_VRAM_BLIT_MASKED    = 0x00200000,
    GFX_SYSTEM_CURSOR                 = 0x00400000,
    GFX_HW_VRAM_STRETCH_BLIT          = 0x00800000,
    GFX_HW_VRAM_STRETCH_BLIT_MASKED   = 0x01000000,
    GFX_HW_SYS_STRETCH_BLIT           = 0x02000000,
    GFX_HW_SYS_STRETCH_BLIT_MASKED    = 0x04000000,
	ГФКС_ПРОКРУТ_ВКЛ                    = 0x00000001,
    ГФКС_ТРОЙН_БУФЕР_ВКЛ             = 0x00000002,
    ГФКС_ВШ_КУРСОР                     = 0x00000004,
    ГФКС_ВШ_ГЛИНИЯ                      = 0x00000008,
    ГФКС_ВШ_ГЛИНИЯ_ИИЛИ                  = 0x00000010,
    ГФКС_ВШ_ГЛИНИЯ_ПЛОТНЫЙ_ОБРАЗЕЦ        = 0x00000020,
    ГФКС_ВШ_ГЛИНИЯ_КОПИРОВАТЬ_ОБРАЗЕЦ         = 0x00000040,
    ГФКС_ВШ_ЗАПОЛНИТЬ                       = 0x00000080,
    ГФКС_ВШ_ЗАПОЛНИТЬ_ИИЛИ                   = 0x00000100,
    ГФКС_ВШ_ЗАПОЛНИТЬ_ПЛОТНЫЙ_ОБРАЗЕЦ         = 0x00000200,
    ГФКС_ВШ_ЗАПОЛНИТЬ_КОПИРОВАТЬ_ОБРАЗЕЦ          = 0x00000400,
    ГФКС_ВШ_ЛИНИЯ                       = 0x00000800,
    ГФКС_ВШ_ЛИНИЯ_ИИЛИ                   = 0x00001000,
    ГФКС_ВШ_ТРЕУГ                   = 0x00002000,
    ГФКС_ВШ_ТРЕУГ_ИИЛИ               = 0x00004000,
    ГФКС_ВШ_ГЛИФ                      = 0x00008000,
    ГФКС_ВШ_ВРАМ_КОПИРМАС                  = 0x00010000,
    ГФКС_ВШ_ВРАМ_КОПИРМАС_ПО_МАСКЕ           = 0x00020000,
    ГФКС_ВШ_ПАМ_КОПИРМАС                   = 0x00040000,
    ГФКС_ВШ_ПАМ_КОПИРМАС_ПО_МАСКЕ            = 0x00080000,
    ГФКС_ВШ_КОПИРМАС_СИС_В_ВРАМ           = 0x00100000,
    ГФКС_ВШ_КОПИРМАС_СИС_В_ВРАМ_ПО_МАСКЕ    = 0x00200000,
    ГФКС_СИСТЕМА_КУРСОР                 = 0x00400000,
    ГФКС_ВШ_ВРАМ_РАСТЯНУТЬ_КОПИРМАС          = 0x00800000,
    ГФКС_ВШ_ВРАМ_РАСТЯНУТЬ_КОПИРМАС_ПО_МАСКЕ   = 0x01000000,
    ГФКС_ВШ_СИС_РАСТЯНУТЬ_КОПИРМАС           = 0x02000000,
    ГФКС_ВШ_СИС_РАСТЯНУТЬ_КОПИРМАС_ПО_МАСКЕ    = 0x04000000,
}


/* current driver capabilities */
mixin(_export!("extern extern (C) int gfx_capabilities;"));

alias GFX_VTABLE ВТАБЛ_ГФКС;
extern (C)
struct GFX_VTABLE
{
alias color_depth глубина_цвета;
alias mask_color цвет_маски;
alias unwrite_bank отпиши_банк;
alias set_clip установи_обрезку;
alias acquire получи;
alias release освободи;
alias create_sub_bitmap создай_подбитмап;
alias created_sub_bitmap созданый_подбитмап;
alias getpixel дайпиксель;
alias putpixel вставьпиксель;
alias vline влиния;
alias hline глиния;
alias hfill гзаполни;
alias line линия;
alias fastline быстрлиния;
alias rectfill заполнипрям;
alias triangle треуг;
alias draw_sprite рисуй_спрайт;
alias draw_256_sprite рисуй_256_спрайт;
alias draw_sprite_v_flip рисуй_спрайт_в_переброс;
alias draw_sprite_h_flip рисуй_спрайт_г_переброс;
alias draw_sprite_vh_flip рисуй_спрайт_вг_переброс;
alias draw_trans_sprite рисуй_транс_спрайт;
alias draw_trans_rgba_sprite рисуй_транс_кзcа_спрайт;
alias draw_lit_sprite рисуй_освети_спрайт;
alias draw_rle_sprite рисуй_рле_спрайт;
alias draw_trans_rle_sprite рисуй_транс_рле_спрайт;
alias draw_trans_rgba_rle_sprite рисуй_транс_кгса_рле_спрайт;
alias draw_lit_rle_sprite рисуй_освети_рле_спрайт;
alias draw_character рисуй_символ;
alias draw_glyph рисуй_глиф;
alias blit_from_memory копирмас_из_памяти;
alias blit_to_memory копирмас_в_память;
alias blit_from_system копирмас_из_системы;
alias blit_to_system копирмас_в_систему;
alias blit_to_self копирмас_в_себя;
alias blit_to_self_forward копирмас_в_себя_вперёд;
alias blit_to_self_backward копирмас_в_себя_назад;
alias blit_between_formats копирмас_между_форматами;
alias masked_blit копирмас_по_маске;
alias clear_to_color очисть_в_цвет;
//alias pivot_scaled_sprite_flip
alias do_stretch_blit растяни_копирмас;
alias draw_gouraud_sprite рисуй_спрайт_гуро;
alias draw_sprite_end рисуй_спрайт_конец;
alias blit_end копирмас_конец;
alias polygon многоуг;
alias rect прямоуг;
alias circle круг;
alias circlefill кругзап;
alias ellipse элипс;
alias ellipsefill элипсзап;
alias arc дуга;
//alias spline 
//alias floodfill
alias polygon3d многоуг3м;
alias polygon3d_f многоуг3м_п;
alias triangle3d треуг3м;
alias triangle3d_f треуг3м_п;
alias quad3d квад3м;
alias quad3d_f квад3м_п;


   int color_depth;
   int mask_color;
   void *unwrite_bank;
   void (*set_clip) (BITMAP *bmp);
   void (*acquire) (BITMAP *bmp);
   void (*release) (BITMAP *bmp);
   BITMAP * (*create_sub_bitmap) (BITMAP *parent, int x, int y, int width, int height);
   void (*created_sub_bitmap) (BITMAP *bmp,  BITMAP *parent);
   int (*getpixel) (BITMAP *bmp, int x, int y);
   void (*putpixel) (BITMAP *bmp, int x, int y, int color);
   void (*vline) (BITMAP *bmp, int x, int y_1, int y2, int color);
   void (*hline) (BITMAP *bmp, int x1, int y, int x2, int color);
   void (*hfill) (BITMAP *bmp, int x1, int y, int x2, int color);
   void (*line) (BITMAP *bmp, int x1, int y_1, int x2, int y2, int color);
   void (*fastline) (BITMAP *bmp, int x1, int y_1, int x2, int y2, int color);
   void (*rectfill) (BITMAP *bmp, int x1, int y_1, int x2, int y2, int color);
   void (*triangle) (BITMAP *bmp, int x1, int y_1, int x2, int y2, int x3, int y3, int color);
   void (*draw_sprite) (BITMAP *bmp,  BITMAP *sprite, int x, int y);
   void (*draw_256_sprite) (BITMAP *bmp,  BITMAP *sprite, int x, int y);
   void (*draw_sprite_v_flip) (BITMAP *bmp,  BITMAP *sprite, int x, int y);
   void (*draw_sprite_h_flip) (BITMAP *bmp,  BITMAP *sprite, int x, int y);
   void (*draw_sprite_vh_flip) (BITMAP *bmp,  BITMAP *sprite, int x, int y);
   void (*draw_trans_sprite) (BITMAP *bmp,  BITMAP *sprite, int x, int y);
   void (*draw_trans_rgba_sprite) (BITMAP *bmp,  BITMAP *sprite, int x, int y);
   void (*draw_lit_sprite) (BITMAP *bmp,  BITMAP *sprite, int x, int y, int color);
   void (*draw_rle_sprite) (BITMAP *bmp,   in RLE_SPRITE *sprite, int x, int y);
   void (*draw_trans_rle_sprite) (BITMAP *bmp, in RLE_SPRITE *sprite, int x, int y);
   void (*draw_trans_rgba_rle_sprite) (BITMAP *bmp, in RLE_SPRITE *sprite, int x, int y);
   void (*draw_lit_rle_sprite) (BITMAP *bmp, in RLE_SPRITE *sprite, int x, int y, int color);
   void (*draw_character) (BITMAP *bmp, BITMAP *sprite, int x, int y, int color, int bg);
   void (*draw_glyph) (BITMAP *bmp, in FONT_GLYPH *glyph, int x, int y, int color, int bg);
   void (*blit_from_memory) (BITMAP *source,  BITMAP *dest, int source_x, int source_y, int dest_x, int dest_y, int width, int height);
   void (*blit_to_memory) (BITMAP *source,  BITMAP *dest, int source_x, int source_y, int dest_x, int dest_y, int width, int height);
   void (*blit_from_system) (BITMAP *source,  BITMAP *dest, int source_x, int source_y, int dest_x, int dest_y, int width, int height);
   void (*blit_to_system) (BITMAP *source,  BITMAP *dest, int source_x, int source_y, int dest_x, int dest_y, int width, int height);
   void (*blit_to_self) (BITMAP *source,  BITMAP *dest, int source_x, int source_y, int dest_x, int dest_y, int width, int height);
   void (*blit_to_self_forward) (BITMAP *source,  BITMAP *dest, int source_x, int source_y, int dest_x, int dest_y, int width, int height);
   void (*blit_to_self_backward) (BITMAP *source,  BITMAP *dest, int source_x, int source_y, int dest_x, int dest_y, int width, int height);
   void (*blit_between_formats) (BITMAP *source,  BITMAP *dest, int source_x, int source_y, int dest_x, int dest_y, int width, int height);
   void (*masked_blit) (BITMAP *source,  BITMAP *dest, int source_x, int source_y, int dest_x, int dest_y, int width, int height);
   void (*clear_to_color) (BITMAP *bitmap, int color);
   void (*pivot_scaled_sprite_flip) (BITMAP *bmp,  BITMAP *sprite, fixed x, fixed y, fixed cx, fixed cy, fixed angle, fixed scale, int v_flip);
   void (*do_stretch_blit) (BITMAP *source,  BITMAP *dest, int source_x, int source_y, int source_width, int source_height, int dest_x, int dest_y, int dest_width, int dest_height, int masked);
   void (*draw_gouraud_sprite) (BITMAP *bmp,  BITMAP *sprite, int x, int y, int c1, int c2, int c3, int c4);
   void (*draw_sprite_end) ();
   void (*blit_end) ();
   void (*polygon) (BITMAP *bmp, int vertices,  in int *points, int color);
   void (*rect) (BITMAP *bmp, int x1, int y_1, int x2, int y2, int color);
   void (*circle) (BITMAP *bmp, int x, int y, int radius, int color);
   void (*circlefill) (BITMAP *bmp, int x, int y, int radius, int color);
   void (*ellipse) (BITMAP *bmp, int x, int y, int rx, int ry, int color);
   void (*ellipsefill) (BITMAP *bmp, int x, int y, int rx, int ry, int color);
   void (*arc) (BITMAP *bmp, int x, int y, fixed ang1, fixed ang2, int r, int color);
   void (*spline) (BITMAP *bmp, in int points[8], int color);
   void (*floodfill) (BITMAP *bmp, int x, int y, int color);
   void (*polygon3d) (BITMAP *bmp, int type,  BITMAP *texture, int vc, V3D **vtx);
   void (*polygon3d_f) (BITMAP *bmp, int type,  BITMAP *texture, int vc, V3D_f **vtx);
   void (*triangle3d) (BITMAP *bmp, int type,  BITMAP *texture, V3D *v1, V3D *v2, V3D *v3);
   void (*triangle3d_f) (BITMAP *bmp, int type,  BITMAP *texture, V3D_f *v1, V3D_f *v2, V3D_f *v3);
   void (*quad3d) (BITMAP *bmp, int type,  BITMAP *texture, V3D *v1, V3D *v2, V3D *v3, V3D *v4);
   void (*quad3d_f) (BITMAP *bmp, int type,  BITMAP *texture, V3D_f *v1, V3D_f *v2, V3D_f *v3, V3D_f *v4);
}

mixin(_export!(
   "extern extern (C) {"
      "GFX_VTABLE __linear_vtable8;"
      "GFX_VTABLE __linear_vtable15;"
      "GFX_VTABLE __linear_vtable16;"
      "GFX_VTABLE __linear_vtable24;"
      "GFX_VTABLE __linear_vtable32;"
   "}"
));

/*typedef struct _VTABLE_INFO
{
   int color_depth;
   GFX_VTABLE *vtable;
}*/

//_VTABLE_INFO _vtable_list[];


/* macros for constructing the vtable list */
/*#define BEGIN_COLOR_DEPTH_LIST               \
   _VTABLE_INFO _vtable_list[] =             \
   {

#define END_COLOR_DEPTH_LIST                 \
      {  0,    NULL  }                       \
   };

#define COLOR_DEPTH_8                        \
   {  8,    &__linear_vtable8    },

#define COLOR_DEPTH_15                       \
   {  15,   &__linear_vtable15   },

#define COLOR_DEPTH_16                       \
   {  16,   &__linear_vtable16   },

#define COLOR_DEPTH_24                       \
   {  24,   &__linear_vtable24   },

#define COLOR_DEPTH_32                       \
   {  32,   &__linear_vtable32   },
*/
alias BITMAP БИТМАП;

struct BITMAP                    /* a bitmap structure */
{
alias w ш;
alias h в;
alias clip обрез;
alias cl ол;
alias cr оп;
alias ct ов;
alias cb он;
alias vtable втабл;
alias write_bank пиши_банк;
alias read_bank читай_банк;
alias dat дан;
alias id ид;
alias extra экстра;
alias x_ofs г_смещ;
alias y_ofs в_смещ;
alias seg сег;
alias line линия;

   int w, h;                     /* width and height in pixels */
   int clip;                     /* flag if clipping is turned on */
   int cl, cr, ct, cb;           /* clip left, right, top and bottom values */
   GFX_VTABLE *vtable;           /* drawing functions */
   void *write_bank;             /* C func on some machines, asm on i386 */
   void *read_bank;              /* C func on some machines, asm on i386 */
   void *dat;                    /* the memory we allocated for the bitmap */
   uint id;                     /* for identifying sub-bitmaps */
   void *extra;                  /* points to a structure with more info */
   int x_ofs;                    /* horizontal offset (for sub-bitmaps) */
   int y_ofs;                    /* vertical offset (for sub-bitmaps) */
   int seg;                      /* bitmap segment */
   //ZERO_SIZE_ARRAY(unsigned char *, line);f
   ubyte *line[1000000];  // FIXME: zero size was supposed to work here
}


enum {
    BMP_ID_VIDEO       = 0x80000000,
    BMP_ID_SYSTEM      = 0x40000000,
    BMP_ID_SUB         = 0x20000000,
    BMP_ID_PLANAR      = 0x10000000,
    BMP_ID_NOBLIT      = 0x08000000,
    BMP_ID_LOCKED      = 0x04000000,
    BMP_ID_AUTOLOCK    = 0x02000000,
    BMP_ID_MASK        = 0x01FFFFFF,
	БМП_ИД_ВИДЕО       = 0x80000000,
    БМП_ИД_СИСТЕМА      = 0x40000000,
    БМП_ИД_ПОД         = 0x20000000,
    БМП_ИД_ПЛАНАР      = 0x10000000,
    БМП_ИД_БЕЗКОПИРМАС      = 0x08000000,
    БМП_ИД_БЛОКИР      = 0x04000000,
    БМП_ИД_АВТОБЛОК    = 0x02000000,
    БМП_ИД_МАСКА        = 0x01FFFFFF,
}


mixin(_export!("extern extern (C) BITMAP* screen;"));

int SCREEN_W() { return gfx_driver ? gfx_driver.w : 0; }
int SCREEN_H() { return gfx_driver ? gfx_driver.h : 0; }

int VIRTUAL_W() { return screen ? screen.w : 0; }
int VIRTUAL_H() { return screen ? screen.h : 0; }

alias SCREEN_W Ш_ЭКРАНА;
alias SCREEN_H В_ЭКРАНА;
alias VIRTUAL_W ВИРТ_Ш;
alias VIRTUAL_H ВИРТ_В;

enum {
   COLORCONV_NONE            = 0,

   COLORCONV_8_TO_15         = 1,
   COLORCONV_8_TO_16         = 2,
   COLORCONV_8_TO_24         = 4,
   COLORCONV_8_TO_32         = 8,

   COLORCONV_15_TO_8         = 0x10,
   COLORCONV_15_TO_16        = 0x20,
   COLORCONV_15_TO_24        = 0x40,
   COLORCONV_15_TO_32        = 0x80,

   COLORCONV_16_TO_8         = 0x100,
   COLORCONV_16_TO_15        = 0x200,
   COLORCONV_16_TO_24        = 0x400,
   COLORCONV_16_TO_32        = 0x800,

   COLORCONV_24_TO_8         = 0x1000,
   COLORCONV_24_TO_15        = 0x2000,
   COLORCONV_24_TO_32        = 0x8000,
   COLORCONV_24_TO_16        = 0x4000,

   COLORCONV_32_TO_8         = 0x10000,
   COLORCONV_32_TO_15        = 0x20000,
   COLORCONV_32_TO_16        = 0x40000,
   COLORCONV_32_TO_24        = 0x80000,

   COLORCONV_32A_TO_8        = 0x100000,
   COLORCONV_32A_TO_15       = 0x200000,
   COLORCONV_32A_TO_16       = 0x400000,
   COLORCONV_32A_TO_24       = 0x800000,

   COLORCONV_DITHER_PAL      = 0x1000000,
   COLORCONV_DITHER_HI       = 0x2000000,
   COLORCONV_KEEP_TRANS      = 0x4000000,

   COLORCONV_DITHER            = COLORCONV_DITHER_PAL |
                                 COLORCONV_DITHER_HI,

   COLORCONV_EXPAND_256        = COLORCONV_8_TO_15 |
                                 COLORCONV_8_TO_16 |
                                 COLORCONV_8_TO_24 |
                                 COLORCONV_8_TO_32,

   COLORCONV_REDUCE_TO_256     = COLORCONV_15_TO_8 |
                                 COLORCONV_16_TO_8 |
                                 COLORCONV_24_TO_8 |
                                 COLORCONV_32_TO_8 |
                                 COLORCONV_32A_TO_8,

   COLORCONV_EXPAND_15_TO_16   = COLORCONV_15_TO_16,

   COLORCONV_REDUCE_16_TO_15   = COLORCONV_16_TO_15,

   COLORCONV_EXPAND_HI_TO_TRUE = COLORCONV_15_TO_24 |
                                 COLORCONV_15_TO_32 |
                                 COLORCONV_16_TO_24 |
                                 COLORCONV_16_TO_32,

   COLORCONV_REDUCE_TRUE_TO_HI = COLORCONV_24_TO_15 |
                                 COLORCONV_24_TO_16 |
                                 COLORCONV_32_TO_15 |
                                 COLORCONV_32_TO_16,

   COLORCONV_24_EQUALS_32      = COLORCONV_24_TO_32 |
                                 COLORCONV_32_TO_24,

   COLORCONV_TOTAL             = COLORCONV_EXPAND_256 |
                                 COLORCONV_REDUCE_TO_256 |
                                 COLORCONV_EXPAND_15_TO_16 |
                                 COLORCONV_REDUCE_16_TO_15 |
                                 COLORCONV_EXPAND_HI_TO_TRUE |
                                 COLORCONV_REDUCE_TRUE_TO_HI |
                                 COLORCONV_24_EQUALS_32 |
                                 COLORCONV_32A_TO_15 |
                                 COLORCONV_32A_TO_16 |
                                 COLORCONV_32A_TO_24,

   COLORCONV_PARTIAL           = COLORCONV_EXPAND_15_TO_16 |
                                 COLORCONV_REDUCE_16_TO_15 |
                                 COLORCONV_24_EQUALS_32,

   COLORCONV_MOST              = COLORCONV_EXPAND_15_TO_16 |
                                 COLORCONV_REDUCE_16_TO_15 |
                                 COLORCONV_EXPAND_HI_TO_TRUE |
                                 COLORCONV_REDUCE_TRUE_TO_HI |
                                 COLORCONV_24_EQUALS_32,

   COLORCONV_KEEP_ALPHA        = COLORCONV_TOTAL
                                 & ~(COLORCONV_32A_TO_8 |
                                 COLORCONV_32A_TO_15 |
                                 COLORCONV_32A_TO_16 |
                                 COLORCONV_32A_TO_24),
}


extern (C) {

GFX_MODE_LIST * get_gfx_mode_list (int card);
void destroy_gfx_mode_list (GFX_MODE_LIST *gfx_mode_list);
void set_color_depth (int depth);
int get_color_depth ();
void set_color_conversion (int mode);
int get_color_conversion ();
void request_refresh_rate (int rate);
int get_refresh_rate ();
int set_gfx_mode (int card, int w, int h, int v_w, int v_h);
int scroll_screen (int x, int y);
int request_scroll (int x, int y);
int poll_scroll ();
int show_video_bitmap (BITMAP *bitmap);
int request_video_bitmap (BITMAP *bitmap);
int enable_triple_buffer ();
BITMAP * create_bitmap (int width, int height);
BITMAP * create_bitmap_ex (int color_depth, int width, int height);
BITMAP * create_sub_bitmap (BITMAP *parent, int x, int y, int width, int height);
BITMAP * create_video_bitmap (int width, int height);
BITMAP * create_system_bitmap (int width, int height);
void destroy_bitmap (BITMAP *bitmap);
void set_clip_rect (BITMAP *bitmap, int x1, int y_1, int x2, int y2);
void add_clip_rect (BITMAP *bitmap, int x1, int y_1, int x2, int y2);
void clear_bitmap (BITMAP *bitmap);
void vsync ();

} // extern (C)

enum {
    SWITCH_NONE           = 0,
    SWITCH_PAUSE          = 1,
    SWITCH_AMNESIA        = 2,
    SWITCH_BACKGROUND     = 3,
    SWITCH_BACKAMNESIA    = 4,

    SWITCH_IN             = 0,
    SWITCH_OUT            = 1,
}


extern (C) {

int set_display_switch_mode (int mode);
int get_display_switch_mode ();
int set_display_switch_callback (int dir, void (*cb) ());
void remove_display_switch_callback (void (*cb) ());

void lock_bitmap (BITMAP *bmp);

} // extern (C)

СПИСОК_РЕЖИМОВ_ГФКС * дай_список_режимов_гфкс(цел карта)
	{
	return get_gfx_mode_list (cast(int) карта);
	}
	
проц  разрушь_список_режимов_гфкс(СПИСОК_РЕЖИМОВ_ГФКС *список_режимов_гфкс)
	{
	destroy_gfx_mode_list (cast(GFX_MODE_LIST *) список_режимов_гфкс);
	}
	
проц уст_глубину_цвета(цел глубина)
	{
	 set_color_depth (cast(int) глубина);
	}
	
цел дай_глубину_цвета()
	{
	return cast(цел) get_color_depth ();
	}

проц уст_преобразование_цвета(цел режим)
	{
	 set_color_conversion (cast(int) режим);
	}

цел дай_преобразование_цвета()
	{
	return cast(цел) get_color_conversion ();
	}

проц запроси_частоту_обновления(цел частота)
	{
	 request_refresh_rate (cast(int) частота);
	}
	
цел дай_частоту_обновления()
	{
	return cast(цел) get_refresh_rate ();
	}
	
цел уст_режим_гфкс(цел карта, цел ш, цел в, цел в_ш, цел в_в)
{
return set_gfx_mode (cast(int) карта, cast(int) ш, cast(int) в, cast(int) в_ш, cast(int) в_в);
}

цел прокрути_экран(цел г, цел в)
	{
	return cast(цел) scroll_screen (cast(int) г, cast(int) в);
	}

цел запроси_прокрут(цел г, цел в)
	{
	return cast(цел)  request_scroll (cast(int) г, cast(int) в);
	}

цел опроси_прокрут()
	{
	return cast(цел) poll_scroll ();
	}

цел покажи_видео_битмап(БИТМАП *битмап)
	{
	 return cast(цел) show_video_bitmap (cast(BITMAP *) битмап);
	}
 
цел запроси_видео_битмап(БИТМАП *битмап)
	{
	return cast(цел) request_video_bitmap (cast(BITMAP *) битмап);
	}

цел вкл_тройн_буфер()
	{
	return cast(цел) enable_triple_buffer ();
	}
	
БИТМАП * создай_битмап(цел ширина, цел высота)
	{
	return cast(БИТМАП *) create_bitmap (cast(int) ширина, cast(int) высота);
	}

БИТМАП * создай_битмап_доп(цел глубина_цвета, цел ширина, цел высота)
	{
	return cast(БИТМАП *) create_bitmap_ex (cast(int) глубина_цвета, cast(int) ширина, cast(int) высота);
	}

БИТМАП * создай_подбитмап(БИТМАП *предок, цел г, цел в, цел ширина, цел высота)
	{
	return cast(БИТМАП *) create_sub_bitmap (cast(BITMAP *) предок, cast(int) г, cast(int) в, cast(int) ширина, cast(int) высота);
	}

БИТМАП * создай_видео_битмап(цел ширина, цел высота)
	{
	return create_video_bitmap (cast(int) ширина, cast(int) высота);
	}

БИТМАП * создай_сис_битмап(цел ширина, цел высота)
	{
	return create_system_bitmap (cast(int) ширина, cast(int) высота);
	}

проц разрушь_битмап(БИТМАП *битмап)
	{
	destroy_bitmap (битмап);
	}
	
проц уст_прямоуг_обезки(БИТМАП *битмап, цел г1, цел в_1, цел г2, цел в2)
	{
	 set_clip_rect (cast(BITMAP *) битмап, cast(int) г1, cast(int) в_1, cast(int) г2, cast(int) в2);
	}

проц доб_прямоуг_обрезки(БИТМАП *битмап, цел г1, цел в_1, цел г2, цел в2)
	{
	add_clip_rect (cast(BITMAP *) битмап, cast(int) г1, cast(int) в_1, cast(int) г2, cast(int) в2);
	}

проц сотри_битмап(БИТМАП *битмап)
	{
	clear_bitmap (cast(BITMAP *) битмап);
	}

проц всинх()
	{
	vsync ();
	}

цел уст_режим_переключ_дисплея(цел режим)
{
return cast(цел) set_display_switch_mode (cast(int) режим);
}

цел дай_режим_переключ_дисплея()
{
return cast(цел) get_display_switch_mode ();
}
/*
цел уст_обрвызов_переключ_дисплея(цел пап, проц (*cb) ())
{
return cast(цел) set_display_switch_callback (cast(int) пап, cast(void) (*cb)());
}
*/
alias set_display_switch_callback уст_обрвызов_переключ_дисплея;

/*
проц удали_обрвызов_переключ_дисплея(проц (*cb) ())
{
remove_display_switch_callback (cast(void)(*cb)());
}
*/
alias remove_display_switch_callback удали_обрвызов_переключ_дисплея;

проц блокируй_битмап(БИТМАП *бмп)
{
lock_bitmap (cast(BITMAP *) бмп);
}

static this() {
   // FIXME: need this?
   //_vtable_list = derelict.allegro.misc._vtable_list.ptr;
}
