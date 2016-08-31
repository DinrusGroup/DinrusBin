/***************************************************************
                           mouse.h
 ***************************************************************/

module derelict.allegro.mouse;

import derelict.allegro.gfx : BITMAP;
import derelict.allegro.internal.dintern;
import derelict.allegro.internal._export;


enum {
   MOUSEDRV_AUTODETECT  = -1,
   MOUSEDRV_NONE        =  0,
   ДРВМЫШИ_АВТООПРЕД  = MOUSEDRV_AUTODETECT,
   ДРВМЫШИ_ОТС        =  MOUSEDRV_NONE,
}

alias MOUSE_DRIVER ДРАЙВЕР_МЫШИ;
extern (C) struct MOUSE_DRIVER
{
alias id ид;
alias name имя;
alias desc опис;
alias ascii_name аски_имя;
alias init иниц;
alias exit выход;
alias poll опроси;
alias timer_poll опроси_таймер;
alias position позиция;
alias set_range уст_охват;
alias set_speed уст_скорость;
alias get_mickeys дай_мики;
alias analyse_data анализирируй_дан;
alias enable_hardware_cursor вкл_аппаратн_курсор;
alias select_system_cursor выбери_сис_курсор;

   int  id;
   const char *name;   
   const char *desc;
   const char *ascii_name;   
   int (*init) ();      
   void (*exit) ();   
   void (*poll) ();   
   void (*timer_poll) ();
   void (*position) (int x, int y);   
   void (*set_range) (int x1, int y_1, int x2, int y2);   
   void (*set_speed) (int xspeed, int yspeed);   
   void (*get_mickeys) (int *mickeyx, int *mickeyy);   
   int (*analyse_data) (in char *buffer, int size);   
   void (*enable_hardware_cursor) (int mode);
   int (*select_system_cursor) (int cursor);   
}

// FIXME: remove?
//extern MOUSE_DRIVER mousedrv_none;
mixin(_export!("extern extern (C) MOUSE_DRIVER * mouse_driver;"));
//extern _DRIVER_INFO _mouse_driver_list[];

extern (C) {

int install_mouse ();
alias install_mouse уст_мышь;

void remove_mouse ();
alias remove_mouse удали_мышь;

int poll_mouse ();
alias poll_mouse опроси_мышь;

int mouse_needs_poll ();
alias mouse_needs_poll требуется_опрос_мыши;

void enable_hardware_cursor ();
alias enable_hardware_cursor вкл_аппаратн_курсор;

void disable_hardware_cursor ();
alias disable_hardware_cursor откл_аппаратн_курсор;

} // extern (C)

/* Mouse cursors */
enum {
   MOUSE_CURSOR_NONE       = 0,
   MOUSE_CURSOR_ALLEGRO    = 1,
   MOUSE_CURSOR_ARROW      = 2,
   MOUSE_CURSOR_BUSY       = 3,
   MOUSE_CURSOR_QUESTION   = 4,
   MOUSE_CURSOR_EDIT       = 5,
   AL_NUM_MOUSE_CURSORS    = 6,
   КУРСОР_МЫШИ_ОТС       = MOUSE_CURSOR_NONE,
   КУРСОР_МЫШИ_АЛЛЕГРО    = MOUSE_CURSOR_ALLEGRO,
   КУРСОР_МЫШИ_СТРЕЛКА     = MOUSE_CURSOR_ARROW ,
   КУРСОР_МЫШИ_ЗАНЯТ      = MOUSE_CURSOR_BUSY,
   КУРСОР_МЫШИ_ВОПРОС   = MOUSE_CURSOR_QUESTION,
   КУРСОР_МЫШИ_РЕДАКТ       = MOUSE_CURSOR_EDIT,
   ЧЛО_КУРСОРОВ_МЫШИ    = AL_NUM_MOUSE_CURSORS,
}

mixin(_export!(
   "extern (C) {"
      "extern BITMAP * mouse_sprite;"
      "extern int mouse_x_focus;"
      "extern int mouse_y_focus;"
   "}"
));

/* These volatile variables have been made properties, since 'volatile' in D is
 * a statement, not a storage class.
 */
int mouse_x() { volatile return derelict.allegro.internal.dintern.mouse_x; }
alias mouse_x мышь_x;

int mouse_y() { volatile return derelict.allegro.internal.dintern.mouse_y; }
alias mouse_y мышь_y;

int mouse_z() { volatile return derelict.allegro.internal.dintern.mouse_z; }
alias mouse_z мышь_z;

int mouse_w() { volatile return derelict.allegro.internal.dintern.mouse_w; }
alias mouse_w мышь_w;

int mouse_b() { volatile return derelict.allegro.internal.dintern.mouse_b; }
alias mouse_b мышь_b;

int mouse_pos() { volatile return derelict.allegro.internal.dintern.mouse_pos; }
alias mouse_pos поз_мыши;

int freeze_mouse_flag() { volatile return derelict.allegro.internal.dintern.freeze_mouse_flag; }
alias freeze_mouse_flag заморозь_флаг_мыши;

void freeze_mouse_flag(int v) { volatile derelict.allegro.internal.dintern.freeze_mouse_flag = v; }

enum {
   MOUSE_FLAG_MOVE            = 1,
   MOUSE_FLAG_LEFT_DOWN       = 2,
   MOUSE_FLAG_LEFT_UP         = 4,
   MOUSE_FLAG_RIGHT_DOWN      = 8,
   MOUSE_FLAG_RIGHT_UP        = 16,
   MOUSE_FLAG_MIDDLE_DOWN     = 32,
   MOUSE_FLAG_MIDDLE_UP       = 64,
   MOUSE_FLAG_MOVE_Z          = 128,
   MOUSE_FLAG_MOVE_W          = 256,
   ФЛАГ_МЫШИ_ДВИГАТЬ            = MOUSE_FLAG_MOVE,
   ФЛАГ_МЫШИ_ВЛЕВО_ВНИЗ       = MOUSE_FLAG_LEFT_DOWN ,
   ФЛАГ_МЫШИ_ВЛЕВО_ВВЕРХ         = MOUSE_FLAG_LEFT_UP,
   ФЛАГ_МЫШИ_ВПРАВО_ВНИЗ      = MOUSE_FLAG_RIGHT_DOWN ,
   ФЛАГ_МЫШИ_ВПРАВО_ВВЕРХ        = MOUSE_FLAG_RIGHT_UP,
   ФЛАГ_МЫШИ_СЕРЕДИНА_ВНИЗ     = MOUSE_FLAG_MIDDLE_DOWN,
   ФЛАГ_МЫШИ_СЕРЕДИНА_ВВЕРХ       = MOUSE_FLAG_MIDDLE_UP,
   ФЛАГ_МЫШИ_ДВИГАТЬ_П          = MOUSE_FLAG_MOVE_Z,
   ФЛАГ_МЫШИ_ДВИГАТЬ_Ш          = MOUSE_FLAG_MOVE_W
}

mixin(_export!("extern extern (C) void (*mouse_callback) (int flags);"));

extern (C) {

void show_mouse (BITMAP *bmp);
alias show_mouse покажи_мышь;

void scare_mouse ();
alias scare_mouse спрячь_мышь;

void scare_mouse_area (int x, int y, int w, int h);
alias scare_mouse_area спрячь_зону_мыши;

void unscare_mouse ();
alias unscare_mouse открой_мышь;

void position_mouse (int x, int y);
alias position_mouse помести_мышь;

void position_mouse_z (int z);
alias position_mouse_z помести_мышь_п;

void position_mouse_w (int w);
alias position_mouse_w помести_мышь_ш;

void set_mouse_range (int x1, int y_1, int x2, int y2);
alias set_mouse_range уст_охват_мыши;

void set_mouse_speed (int xspeed, int yspeed);
alias set_mouse_speed уст_скорость_мыши;

void select_mouse_cursor (int cursor);
alias select_mouse_cursor выбери_курсор_мыши;

void set_mouse_cursor_bitmap (int cursor, BITMAP *bmp);
alias set_mouse_cursor_bitmap  уст_битмап_курсора_мыши;

void set_mouse_sprite_focus (int x, int y);
alias set_mouse_sprite_focus уст_фокус_спрайта_мыши;

void get_mouse_mickeys (int *mickeyx, int *mickeyy);
alias get_mouse_mickeys дай_мики_мыши;

void set_mouse_sprite (BITMAP *sprite);
alias set_mouse_sprite уст_спрайт_мыши;

int show_os_cursor (int cursor);
alias show_os_cursor покажи_курсор_ос;

}  // extern (C)
