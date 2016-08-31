/***************************************************************
                           gui.h
 ***************************************************************/

module derelict.allegro.gui;

import derelict.allegro.gfx : BITMAP;
import derelict.allegro.internal._export;


alias extern (C) int (*DIALOG_PROC)(int msg, DIALOG *d, int c);
alias DIALOG_PROC ПРОЦ_ДИАЛОГА;
alias BITMAP БИТМАП;

alias DIALOG ДИАЛОГ;
struct DIALOG
{
alias proc проц;
alias x гор;
alias y вер;
alias w шир;
alias h выс;
alias fg пфон;
alias bg зфон;
alias key клавиша;
alias flags флаги;
alias d1 д1;
alias d2 д2;
alias dp уд;
alias dp2 уд2;
alias dp3 уд3;

   //DIALOG_PROC proc;  // FIXME: extern (C)?
   extern (C) int (*proc)(int msg, DIALOG *d, int c);
   int x, y, w, h;               /* положение и размер объекта */
   int fg, bg;                   /* цвета перезнего и заднего фона */
   int key;                      /* клавиатурное сокращение (код ASCII) */
   int flags;                    /* флаги состояния объекта */
   int d1, d2;                   /* любые данные, к-е м. б. необходимы этому объекту */
   void* dp, dp2, dp3;           /* указатели на другие данные объекта */
}


/* всплывающее меню */
alias MENU МЕНЮ;
struct MENU
{
alias text текст;
alias proc проц;
alias child отпрыск;
alias flags флаги;
alias dp уд;

   char *text;                   /* текст элемента меню */
   extern (C) int (*proc)();     /* функция обратного вызова */
   MENU *child;                  /* разрешить внедренные меню */
   int flags;                    /* флаги состояния меню */
   void *dp;                     /* любые данные, к-е м. б. необходимы этому меню */
}


/* сохраненная информация о состоянии активного диалога GUI */
alias DIALOG_PLAYER ПЛЕЙЕР_ДИАЛОГА;
struct DIALOG_PLAYER
{
alias obj объ;
alias res рес;
alias mouse_obj объ_мышь;
alias focus_obj объ_фокус;
alias joy_on джой_вкл;
alias click_wait жать_жду;
alias dialog диалог;

   int obj;
   int res;
   int mouse_obj;
   int focus_obj;
   int joy_on;
   int click_wait;
   int mouse_ox, mouse_oy;
   int mouse_oz;
   int mouse_b;
   DIALOG *dialog;
}


/* сохраненная информация о состоянии активного меню GUI */
alias MENU_PLAYER ПЛЕЙЕР_МЕНЮ;
struct MENU_PLAYER
{
alias menu меню;
alias bar брус;
alias size размер;
alias sel выбран;
alias proc проц;
alias saved сохран;
alias mouse_button_was_pressed нажата_кнопка_мыши;
alias back_from_child обрат_от_отпрыска;          
alias timestamp штамп_времени;         
alias mouse_sel выбран_мышью;  
alias redraw перерис;  
alias auto_open авто_откр; 
alias ret возвр;
alias dialog диалог;
alias parent предок;
alias child отпрыск;
alias x гор;
alias y вер;
alias w шир;
alias h выс;

   MENU *menu;                      /* само меню */
   int bar;                         /* установить, если это высокоуровневая строка меню */
   int size;                        /* число элементов в меню */
   int sel;                         /* выделенный элемент */
   int x, y, w, h;                  /* положение меню на экране */
   extern (C) int (*proc)();        /* функция обратного вызова */
   BITMAP *saved;                   /* saved what was underneath it */
   
   int mouse_button_was_pressed;    /* установлен, если кнопка мыши нажата при последней итерации */
   int back_from_child;             /* Установлен, если отпрыск активирован при последней итерации */    
   int timestamp;                   /* штамп времени для событий gui_таймера */
   int mouse_sel;                   /* элемент, над которым находится сейчас мышь */
   int redraw;                      /* установить, если требуется перерисовка */
   int auto_open;                   /* Установить, если активировано авто-открытие меню */
   int ret;                         /* значение возврата */
   
   DIALOG *dialog;                  /* d_menu_proc() parent dialog (if any) */
   
   MENU_PLAYER *parent;             /* the parent menu, or NULL for root */
   MENU_PLAYER *child;              /* the child menu, or NULL for none */
}


/* биты для поля флагов */
enum {
   D_EXIT        = 1,        /* object makes the dialog exit */
   D_SELECTED    = 2,        /* object is selected */
   D_GOTFOCUS    = 4,        /* object has the input focus */
   D_GOTMOUSE    = 8,        /* mouse is on top of object */
   D_HIDDEN      = 16,       /* object is not visible */
   D_DISABLED    = 32,       /* object is visible but inactive */
   D_DIRTY       = 64,       /* object needs to be redrawn */
   D_INTERNAL    = 128,      /* reserved for internal use */
   D_USER        = 256,      /* from here on is free for your own use */
   Д_ВЫХОД       = D_EXIT, 
   Д_ВЫДЕЛЕН   	 = D_SELECTED, 
   Д_ВФОКУСЕ     = D_GOTFOCUS,
   Д_ПОДМЫШЬЮ    = D_GOTMOUSE, 
   Д_СКРЫТ       = D_HIDDEN, 
   Д_ОТКЛЮЧЕН    = D_DISABLED,
   Д_ЧЕРНОВОЙ    = D_DIRTY,
   Д_ВНУТРЕН     = D_INTERNAL, 
   Д_ЮЗЕР        = D_USER,
}

/* значения возврата для диалоговых процедур */
enum {
   D_O_K           = 0,      /* normal exit status */
   D_CLOSE         = 1,      /* request to close the dialog */
   D_REDRAW        = 2,      /* request to redraw the dialog */
   D_REDRAWME      = 4,      /* request to redraw this object */
   D_WANTFOCUS     = 8,      /* this object wants the input focus */
   D_USED_CHAR     = 16,     /* object has used the keypress */
   D_REDRAW_ALL    = 32,     /* request to redraw all active dialogs */
   D_DONTWANTMOUSE = 64,     /* this object does not want mouse focus */
   Д_ОК 		  	 = D_O_K,
   Д_ЗАКР 		  	 = D_CLOSE,
   Д_ПЕРЕРИС  	  	 = D_REDRAW,
   Д_ПЕРЕРИСМЯ	   	 = D_REDRAWME,
   Д_ДАЙФОК 		 = D_WANTFOCUS,
   Д_ИСПОЛЬЗОВАН_СИМ = D_USED_CHAR,
   Д_ПЕРЕРИС_ВСЕ	 = D_REDRAW_ALL,
   Д_НЕТРЕБМЫШ		 = D_DONTWANTMOUSE,
   
}

/* messages for the dialog procedures */
enum {
   MSG_START     = 1,        /* start the dialog, initialise */
   MSG_END       = 2,        /* dialog is finished - cleanup */
   MSG_DRAW      = 3,        /* draw the object */
   MSG_CLICK     = 4,        /* mouse click on the object */
   MSG_DCLICK    = 5,        /* double click on the object */
   MSG_KEY       = 6,        /* keyboard shortcut */
   MSG_CHAR      = 7,        /* other keyboard input */
   MSG_UCHAR     = 8,        /* unicode keyboard input */
   MSG_XCHAR     = 9,        /* broadcast character to all objects */
   MSG_WANTFOCUS = 10,       /* does object want the input focus? */
   MSG_GOTFOCUS  = 11,       /* got the input focus */
   MSG_LOSTFOCUS = 12,       /* lost the input focus */
   MSG_GOTMOUSE  = 13,       /* mouse on top of object */
   MSG_LOSTMOUSE = 14,       /* mouse moved away from object */
   MSG_IDLE      = 15,       /* update any background stuff */
   MSG_RADIO     = 16,       /* clear radio buttons */
   MSG_WHEEL     = 17,       /* mouse wheel moved */
   MSG_LPRESS    = 18,       /* mouse left button pressed */
   MSG_LRELEASE  = 19,       /* mouse left button released */
   MSG_MPRESS    = 20,       /* mouse middle button pressed */
   MSG_MRELEASE  = 21,       /* mouse middle button released */
   MSG_RPRESS    = 22,       /* mouse right button pressed */
   MSG_RRELEASE  = 23,       /* mouse right button released */
   MSG_WANTMOUSE = 24,       /* does object want the mouse? */
   MSG_USER      = 25,       /* from here on are free... */
   СООБ_СТАРТ		= MSG_START ,
   СООБ_КОН			= MSG_END ,
   СООБ_РИС			= MSG_DRAW  ,
   СООБ_КЛИК			= MSG_CLICK  ,
   СООБ_ДКЛИК		= MSG_DCLICK ,
   СООБ_КЛАВИША		= MSG_KEY    ,
   СООБ_СИМ			= MSG_CHAR  ,
   СООБ_БСИМ		= MSG_UCHAR,
   СООБ_ИКССИМ		= MSG_XCHAR,
   СООБ_ДАЙФОК		= MSG_WANTFOCUS ,
   СООБ_ВФОКУСЕ		= MSG_GOTFOCUS ,
   СООБ_ФОКПОТЕРЯ	= MSG_LOSTFOCUS,
   СООБ_ПОДМЫШЬЮ	= MSG_GOTMOUSE ,
   СООБ_МЫШПОТЕРЯ	= MSG_LOSTMOUSE ,
   СООБ_ВПРОСТОЕ	= MSG_IDLE ,
   СООБ_РАДИО		= MSG_RADIO,
   СООБ_КОЛЕСО		= MSG_WHEEL,
   СООБ_ЛЖИМ		= MSG_LPRESS,
   СООБ_ЛОТЖИМ		=  MSG_LRELEASE ,
   СООБ_СРЖИМ		= MSG_MPRESS ,
   СООБ_СРОТЖИМ		= MSG_MRELEASE  ,
   СООБ_ПЖИМ		= MSG_RPRESS  ,
   СООБ_ПОТЖИМ		= MSG_RRELEASE,
   СООБ_ТРЕБМЫШ 	= MSG_WANTMOUSE ,
   СООБ_ЮЗЕР		= MSG_USER ,
}


/* some dialog procedures */
extern (C) {

int d_yield_proc (int msg, DIALOG *d, int c);
int d_clear_proc (int msg, DIALOG *d, int c);
int d_box_proc (int msg, DIALOG *d, int c);
int d_shadow_box_proc (int msg, DIALOG *d, int c);
int d_bitmap_proc (int msg, DIALOG *d, int c);
int d_text_proc (int msg, DIALOG *d, int c);
int d_ctext_proc (int msg, DIALOG *d, int c);
int d_rtext_proc (int msg, DIALOG *d, int c);
int d_button_proc (int msg, DIALOG *d, int c);
int d_check_proc (int msg, DIALOG *d, int c);
int d_radio_proc (int msg, DIALOG *d, int c);
int d_icon_proc (int msg, DIALOG *d, int c);
int d_keyboard_proc (int msg, DIALOG *d, int c);
int d_edit_proc (int msg, DIALOG *d, int c);
int d_list_proc (int msg, DIALOG *d, int c);
int d_text_list_proc (int msg, DIALOG *d, int c);
int d_textbox_proc (int msg, DIALOG *d, int c);
int d_slider_proc (int msg, DIALOG *d, int c);
int d_menu_proc (int msg, DIALOG *d, int c);

} // extern (C)

цел д_проц_жни(цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_yield_proc (сооб, д, ц);
	}

цел д_проц_сотри(цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_clear_proc (сооб, д, ц);
	}

цел д_проц_бокс(цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_box_proc ( сооб, д, ц);
	}

цел д_проц_затени_бокс (цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_shadow_box_proc( сооб, д, ц);
	}

цел д_проц_битмап (цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_bitmap_proc( сооб, д, ц);
	}

цел д_проц_текст (цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_text_proc( сооб, д, ц);
	}

цел д_проц_цтекст (цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_ctext_proc( сооб, д, ц);
	}

цел д_проц_птекст (цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_rtext_proc( сооб, д, ц);
	}

цел д_проц_кнопка (цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_button_proc( сооб, д, ц);
	}

цел д_проц_чек (цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_check_proc( сооб, д, ц);
	}

цел д_проц_радио (цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_radio_proc( сооб, д, ц);
	}

цел д_проц_иконка (цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_icon_proc( сооб, д, ц);
	}

цел д_проц_клавиатура (цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_keyboard_proc( сооб, д, ц);
	}

цел д_проц_редактир (цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_edit_proc( сооб, д, ц);
	}

цел д_проц_список (цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_list_proc( сооб, д, ц);
	}

цел д_проц_текст_список (цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_text_list_proc( сооб, д, ц);
	}

цел д_проц_текстбокс (цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_textbox_proc( сооб, д, ц);
	}

цел д_проц_слайдер (цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_slider_proc( сооб, д, ц);
	}

цел д_проц_меню (цел сооб, ДИАЛОГ *д, цел ц)
	{
	return cast(цел) d_menu_proc( сооб, д, ц);
	}

mixin(_export!(
   "extern (C) {"
      "extern DIALOG_PROC gui_shadow_box_proc;"
      "extern DIALOG_PROC gui_ctext_proc;"
      "extern DIALOG_PROC gui_button_proc;"
      "extern DIALOG_PROC gui_edit_proc;"
      "extern DIALOG_PROC gui_list_proc;"
      "extern DIALOG_PROC gui_text_list_proc;"
   "}"
));

mixin(_export!(
"extern (C) {"

   "extern void (*gui_menu_draw_menu) (int x, int y, int w, int h);"
   "extern void (*gui_menu_draw_menu_item) (MENU *m, int x, int y, int w, int h, int bar, int sel);"

   "extern DIALOG * active_dialog;"
   "extern MENU * active_menu;"

   "extern int gui_mouse_focus;"

   "extern int gui_fg_color;"
   "extern int gui_mg_color;"
   "extern int gui_bg_color;"

   "extern int gui_font_baseline;"

   "extern int (*gui_mouse_x) ();"
   "extern int (*gui_mouse_y) ();"
   "extern int (*gui_mouse_z) ();"
   "extern int (*gui_mouse_b) ();"

"}" // extern (C)
));


extern (C) {

void gui_set_screen (BITMAP *bmp);
BITMAP * gui_get_screen ();
int gui_textout_ex (BITMAP *bmp, in char *s, int x, int y, int color, int bg, int centre);
int gui_strlen (in char *s);
void position_dialog (DIALOG *dialog, int x, int y);
void centre_dialog (DIALOG *dialog);
void set_dialog_color (DIALOG *dialog, int fg, int bg);
int find_dialog_focus (DIALOG *dialog);
int offer_focus (DIALOG *dialog, int obj, int *focus_obj, int force);
int object_message (DIALOG *dialog, int msg, int c);
int dialog_message (DIALOG *dialog, int msg, int c, int *obj);
int broadcast_dialog_message (int msg, int c);
int do_dialog (DIALOG *dialog, int focus_obj);
int popup_dialog (DIALOG *dialog, int focus_obj);
DIALOG_PLAYER * init_dialog (DIALOG *dialog, int focus_obj);
int update_dialog (DIALOG_PLAYER *player);
int shutdown_dialog (DIALOG_PLAYER *player);
int do_menu (MENU *menu, int x, int y);
MENU_PLAYER * init_menu (MENU *menu, int x, int y);
int update_menu (MENU_PLAYER *player);
int shutdown_menu (MENU_PLAYER *player);
int alert (in char *s1, in char *s2, in char *s3, in char *b1, in char *b2, int c1, int c2);
int alert3 (in char *s1, in char *s2, in char *s3, in char *b1, in char *b2, in char *b3, int c1, int c2, int c3);
int file_select_ex (in char *message, char *path, in char *ext, int size, int w, int h);

int gfx_mode_select (int *card, int *w, int *h);
int gfx_mode_select_ex (int *card, int *w, int *h, int *color_depth);
int gfx_mode_select_filter (int *card, int *w, int *h, int *color_depth, int (*filter)(int, int, int, int));

}  // extern (C)


проц гип_уст_экран(БИТМАП *бмп)
	{
	gui_set_screen (бмп);
	}

БИТМАП * гип_дай_экран()
	{
	return gui_get_screen ();
	}

цел гип_текствыв_доп(БИТМАП *бмп, in сим *с, цел гор, цел вер, цел цвет, цел зфон, цел центр)
	{
	return cast(цел) gui_textout_ex (бмп, с, гор, вер, цвет, зфон, центр);
	}

цел гип_ткстдлин(in сим *с)
	{
	return cast(цел) gui_strlen (с);
	}

проц размести_диалог(ДИАЛОГ *диалог, цел гор, цел вер)
	{
	 position_dialog (диалог, гор, вер);
	}

проц центрируй_диалог(ДИАЛОГ *диалог)
	{
	centre_dialog (диалог);
	}

проц уст_цвет_диалога(ДИАЛОГ *диалог, цел пфон, цел зфон)
	{
	set_dialog_color (диалог, пфон, зфон);
	}

цел найди_фокус_диалога(ДИАЛОГ *диалог)
	{
	return cast(цел) find_dialog_focus (диалог);
	}

цел предложи_фокус(ДИАЛОГ *диалог, цел объ, цел *объ_фокуса, цел сила)
	{
	return cast(цел) offer_focus (диалог, объ, объ_фокуса, сила);
	}

цел сооб_объекта(ДИАЛОГ *диалог, цел сооб, цел ц)
	{
	return cast(цел) object_message (диалог, сооб, ц);
	}

цел сооб_диалога(ДИАЛОГ *диалог, цел сооб, цел ц, цел *объ)
	{
	return cast(цел) dialog_message (диалог, сооб, ц, объ);
	}

цел передай_сооб_диалога(цел сооб, цел ц)
	{
	return cast(цел) broadcast_dialog_message (сооб, ц);
	}

цел делай_диалог(ДИАЛОГ *диалог, цел объ_фокуса)
	{
	return cast(цел) do_dialog (диалог, объ_фокуса);
	}

цел выведи_диалог(ДИАЛОГ *диалог, цел объ_фокуса)
	{
	return cast(цел) popup_dialog (диалог, объ_фокуса);
	}

ПЛЕЙЕР_ДИАЛОГА * иниц_диалог(ДИАЛОГ *диалог, цел объ_фокуса)
	{
	return cast(ПЛЕЙЕР_ДИАЛОГА *) init_dialog (диалог, объ_фокуса);
	}

цел обнови_диалог(ПЛЕЙЕР_ДИАЛОГА *плейер)
	{
	return cast(цел) update_dialog (плейер);
	}

цел закрой_диалог(ПЛЕЙЕР_ДИАЛОГА *плейер)
	{
	return cast(цел) shutdown_dialog (плейер);
	}

цел делай_меню(МЕНЮ *меню, цел гор, цел вер)
	{
	return cast(цел) do_menu (меню, гор, вер);
	}

ПЛЕЙЕР_МЕНЮ * иниц_меню(МЕНЮ *меню, цел гор, цел вер)
	{
	return cast(ПЛЕЙЕР_МЕНЮ *) init_menu (меню, гор, вер);
	}

цел обнови_меню(ПЛЕЙЕР_МЕНЮ *плейер)
	{
	return cast(цел) update_menu (плейер);
	}

цел закрой_меню(ПЛЕЙЕР_МЕНЮ *плейер)
	{
	return cast(цел) shutdown_menu (плейер);
	}

цел тревога(in сим *с1, in сим *с2, in сим *с3, in сим *б1, in сим *б2, цел ц1, цел ц2)
	{
	return cast(цел) alert (с1, с2, с3, б1, б2, ц1, ц2);
	}

цел тревога3(in сим *с1, in сим *с2, in сим *с3, in сим *б1, in сим *б2, in сим *б3, цел ц1, цел ц2, цел ц3)
	{
	return cast(цел) alert3 (с1, с2, с3, б1, б2, б3, ц1, ц2, ц3);
	}

цел выбери_файл_доп(in сим *сообщение, сим *путь, in сим *расш, цел размер, цел шир, цел выс)
	{
	return cast(цел) file_select_ex (сообщение, путь, расш, размер, шир, выс);
	}

цел выбери_режим_гфкс(цел *карта, цел *шир, цел *выс)
	{
	return cast(цел) gfx_mode_select (карта, шир, выс);
	}

цел выбери_режим_гфкс_доп(цел *карта, цел *шир, цел *выс, цел *глубина_цвета)
	{
	return cast(цел) gfx_mode_select_ex (карта, шир, выс, глубина_цвета);
	}
/*
цел выбери_фильтр_режима_гфкс(цел *карта, цел *шир, цел *выс, цел *глубина_цвета, цел (*фильтруй)(цел, цел, цел, цел))
	{
	return cast(цел) gfx_mode_select_ex (карта, шир, выс, глубина_цвета, фильтруй);
	}
*/
alias gfx_mode_select_ex выбери_фильтр_режима_гфкс;
