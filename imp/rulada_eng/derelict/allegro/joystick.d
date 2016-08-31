/***************************************************************
                           joystick.h
 ***************************************************************/

module derelict.allegro.joystick;

import derelict.allegro.internal._export;
import derelict.allegro.internal.dversion;


enum {
   JOY_TYPE_AUTODETECT	 = -1,
   JOY_TYPE_NONE         = 0,       
   ТИП_ДЖОЙСТ_АВТООПРЕД  = JOY_TYPE_AUTODETECT,
   ТИП_ДЖОЙСТ_ОТС		 = JOY_TYPE_NONE,
}

enum {
   MAX_JOYSTICKS          = 8,
   MAX_JOYSTICK_AXIS      = 3,
   MAX_JOYSTICK_STICKS    = 5,
   MAX_JOYSTICK_BUTTONS   = 32,
   МАКСЧЛО_ДЖОЙСТ		  = MAX_JOYSTICKS,
   МАКСЧЛО_ОСЕЙ_ДЖОЙСТ	  = MAX_JOYSTICK_AXIS,
   МАКСЧЛО_РУКУПР_ДЖОЙСТ  = MAX_JOYSTICK_STICKS,
   МАКСЧЛО_КНОПОК_ДЖОЙСТ  = MAX_JOYSTICK_BUTTONS,
}

/* информация об единичной оси джойстика */
alias JOYSTICK_AXIS_INFO ИНФОБ_ОСЯХ_ДЖ;
struct JOYSTICK_AXIS_INFO
{
alias pos поз;
alias name имя;
alias d1 д1;
alias d2 д2;

   int pos;      
   int d1, d2;   
   const char *name;
 }


/* информация об одной и более осях (слайдер или упр. элемент направления) */
alias JOYSTICK_STICK_INFO ИНФО_РУКУПР_ДЖ;
struct JOYSTICK_STICK_INFO
{
alias flags флаги;
alias num_axis чло_осей;
alias axis оси;
alias name имя;

   int flags;
   int num_axis;      
   JOYSTICK_AXIS_INFO axis[MAX_JOYSTICK_AXIS];   
   const char *name;   
}

/* информация о кнопке джойстика */
alias JOYSTICK_BUTTON_INFO ИНФО_КНОПКАХ_ДЖ;
struct JOYSTICK_BUTTON_INFO
{
alias name имя;
alias b к;

   int b;
   const char *name;   
}

/* информация обо всём джойстике */
alias JOYSTICK_INFO ИНФО_ДЖОЙСТЕ;
struct JOYSTICK_INFO
{
alias flags флаги;
alias num_sticks чло_рукупр;
alias num_buttons  чло_кнопок;
alias stick рукупр;
alias button кнопка;

   int flags;
   int num_sticks;      
   int num_buttons;   
   JOYSTICK_STICK_INFO stick[MAX_JOYSTICK_STICKS];   
   JOYSTICK_BUTTON_INFO button[MAX_JOYSTICK_BUTTONS];
}

/* флаги состояния джойстика */
enum {
   JOYFLAG_DIGITAL           = 1,
   JOYFLAG_ANALOGUE          = 2,
   JOYFLAG_CALIB_DIGITAL     = 4,
   JOYFLAG_CALIB_ANALOGUE    = 8,
   JOYFLAG_CALIBRATE         = 16,
   JOYFLAG_SIGNED            = 32,
   JOYFLAG_UNSIGNED          = 64,
   ДЖОЙФЛАГ_ЦИФРА = JOYFLAG_DIGITAL, 
   ДЖОЙФЛАГ_АНАЛОГ = JOYFLAG_ANALOGUE,
   ДЖОЙФЛАГ_КАЛИБ_ЦИФРА = JOYFLAG_CALIB_DIGITAL,
   ДЖОЙФЛАГ_КАЛИБ_АНАЛОГ = JOYFLAG_CALIB_ANALOGUE,
   ДЖОЙФЛАГ_КАЛИБРОВКА = JOYFLAG_CALIBRATE,
  ДЖОЙФЛАГ_СОЗНАКОМ = JOYFLAG_SIGNED,
   ДЖОЙФЛАГ_БЕЗЗНАКА = JOYFLAG_UNSIGNED
}


/* альтернативное произношение */
alias JOYFLAG_ANALOGUE        JOYFLAG_ANALOG;
alias JOYFLAG_CALIB_ANALOGUE  JOYFLAG_CALIB_ANALOG;


/* глобальная информация о джойстике */
mixin(_export!(
   "extern extern (C) {"
      "JOYSTICK_INFO joy[MAX_JOYSTICKS];"
      "int num_joysticks;"
   "}"
));

alias JOYSTICK_DRIVER  ДРАЙВЕР_ДЖОЙСТА;
extern (C) struct JOYSTICK_DRIVER         /* driver for reading joystick input */
{
alias id ид;
alias name имя;
alias desc опис;
alias ascii_name аски_имя;
alias init иниц;
alias exit выход;
alias poll опроси;
alias save_data сохрани_дан;
alias load_data загрузи_дан;
alias calibrate_name калибруй_имя;
alias calibrate калибруй;

   int  id;   
   const char *name;   
   const char *desc;	
   const char *ascii_name;   
   int init();   
   void exit();   
   int poll();   
   int save_data();   
   int load_data();   
   stringz calibrate_name(int n);   
   int calibrate(int n);
}


mixin(_export!(
   "extern extern (C) {"
      //JOYSTICK_DRIVER joystick_none;
      "JOYSTICK_DRIVER* joystick_driver;"
      //_DRIVER_INFO _joystick_driver_list[];
   "}"
));


extern (C) {

int install_joystick (int type);
alias install_joystick установи_джойст;

void remove_joystick ();
alias remove_joystick  удали_джойст;

int poll_joystick ();
alias poll_joystick опроси_джойст;

int save_joystick_data (in char *filename);
alias save_joystick_data сохрани_дан_о_джойсте;

int load_joystick_data (in char *filename);
alias load_joystick_data загрузи_дан_о_джойсте;

stringz calibrate_joystick_name (int n);
alias calibrate_joystick_name  калибруй_имя_джойста;

int calibrate_joystick (int n);
alias calibrate_joystick калибруй_джойст;

}  // extern (C)
