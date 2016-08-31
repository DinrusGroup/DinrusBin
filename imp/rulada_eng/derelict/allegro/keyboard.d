/***************************************************************
                           keyboard.h
 ***************************************************************/

module derelict.allegro.keyboard;

import derelict.allegro.internal._export;
import derelict.allegro.internal.dversion;

alias stringz ткст0;

alias KEYBOARD_DRIVER ДРАЙВЕР_КЛАВИАТУРЫ;
extern (C) struct KEYBOARD_DRIVER
{
alias id ид;
alias name имя;
alias desc опис;
alias ascii_name аски_имя;
alias autorepeat автоповтор;
alias init иниц;
alias exit выход;
alias poll опроси;
alias set_leds уст_вводы;
alias set_rate уст_частоту;
alias wait_for_input жди_ввода;
alias stop_waiting_for_input стоп_ждать_ввод;
alias scancode_to_ascii сканкод_в_аски;
alias scancode_to_name сканкод_в_имя;

   int id;
   const char *name;
   const char *desc;
   const char *ascii_name;
   int autorepeat;
   int (*init) ();
   void (*exit) ();
   void (*poll) ();
   void (*set_leds) (int leds);
   void (*set_rate) (int delay, int rate);
   void (*wait_for_input) ();
   void (*stop_waiting_for_input) ();
   int (*scancode_to_ascii) (int scancode);
   stringz (*scancode_to_name) (int scancode);
}

enum {
   KB_SHIFT_FLAG    = 0x0001,
   KB_CTRL_FLAG     = 0x0002,
   KB_ALT_FLAG      = 0x0004,
   KB_LWIN_FLAG     = 0x0008,
   KB_RWIN_FLAG     = 0x0010,
   KB_MENU_FLAG     = 0x0020,
   KB_COMMAND_FLAG  = 0x0040,
   KB_SCROLOCK_FLAG = 0x0100,
   KB_NUMLOCK_FLAG  = 0x0200,
   KB_CAPSLOCK_FLAG = 0x0400,
   KB_INALTSEQ_FLAG = 0x0800,
   KB_ACCENT1_FLAG  = 0x1000,
   KB_ACCENT2_FLAG  = 0x2000,
   KB_ACCENT3_FLAG  = 0x4000,
   KB_ACCENT4_FLAG  = 0x8000,
   
   ФЛАГ_КВ_ШИФТ				= KB_SHIFT_FLAG ,
   ФЛАГ_КВ_КТРЛ				= KB_CTRL_FLAG ,
   ФЛАГ_КВ_АЛЬТ				= KB_ALT_FLAG ,
   ФЛАГ_КВ_ЛУИН				= KB_LWIN_FLAG  ,
   ФЛАГ_КВ_ПУИН				= KB_RWIN_FLAG  ,
   ФЛАГ_КВ_МЕНЮ				= KB_MENU_FLAG ,
   ФЛАГ_КВ_КОМАНДА			=  KB_COMMAND_FLAG  ,
   ФЛАГ_КВ_СКРОЛЛОК			= KB_SCROLOCK_FLAG,
   ФЛАГ_КВ_НУМЛОК			= KB_NUMLOCK_FLAG  ,
   ФЛАГ_КВ_КАПСЛОК			= KB_CAPSLOCK_FLAG,
   ФЛАГ_КВ_ИНАЛЬТСЕКВ		= KB_INALTSEQ_FLAG ,
   ФЛАГ_КВ_АКЦЕНТ1			= KB_ACCENT1_FLAG ,
   ФЛАГ_КВ_АКЦЕНТ2			= KB_ACCENT2_FLAG  ,
   ФЛАГ_КВ_АКЦЕНТ3			= KB_ACCENT3_FLAG ,
   ФЛВГ_КВ_АКЦЕНТ4			= KB_ACCENT4_FLAG

}

enum {
   KEY_A            = 1,
   KEY_B            = 2,
   KEY_C            = 3,
   KEY_D            = 4,
   KEY_E            = 5,
   KEY_F            = 6,
   KEY_G            = 7,
   KEY_H            = 8,
   KEY_I            = 9,
   KEY_J            = 10,
   KEY_K            = 11,
   KEY_L            = 12,
   KEY_M            = 13,
   KEY_N            = 14,
   KEY_O            = 15,
   KEY_P            = 16,
   KEY_Q            = 17,
   KEY_R            = 18,
   KEY_S            = 19,
   KEY_T            = 20,
   KEY_U            = 21,
   KEY_V            = 22,
   KEY_W            = 23,
   KEY_X            = 24,
   KEY_Y            = 25,
   KEY_Z            = 26,
   KEY_0            = 27,
   KEY_1            = 28,
   KEY_2            = 29,
   KEY_3            = 30,
   KEY_4            = 31,
   KEY_5            = 32,
   KEY_6            = 33,
   KEY_7            = 34,
   KEY_8            = 35,
   KEY_9            = 36,
   KEY_0_PAD        = 37,
   KEY_1_PAD        = 38,
   KEY_2_PAD        = 39,
   KEY_3_PAD        = 40,
   KEY_4_PAD        = 41,
   KEY_5_PAD        = 42,
   KEY_6_PAD        = 43,
   KEY_7_PAD        = 44,
   KEY_8_PAD        = 45,
   KEY_9_PAD        = 46,
   KEY_F1           = 47,
   KEY_F2           = 48,
   KEY_F3           = 49,
   KEY_F4           = 50,
   KEY_F5           = 51,
   KEY_F6           = 52,
   KEY_F7           = 53,
   KEY_F8           = 54,
   KEY_F9           = 55,
   KEY_F10          = 56,
   KEY_F11          = 57,
   KEY_F12          = 58,
   KEY_ESC          = 59,
   KEY_TILDE        = 60,
   KEY_MINUS        = 61,
   KEY_EQUALS       = 62,
   KEY_BACKSPACE    = 63,
   KEY_TAB          = 64,
   KEY_OPENBRACE    = 65,
   KEY_CLOSEBRACE   = 66,
   KEY_ENTER        = 67,
   KEY_COLON        = 68,
   KEY_QUOTE        = 69,
   KEY_BACKSLASH    = 70,
   KEY_BACKSLASH2   = 71,
   KEY_COMMA        = 72,
   KEY_STOP         = 73,
   KEY_SLASH        = 74,
   KEY_SPACE        = 75,
   KEY_INSERT       = 76,
   KEY_DEL          = 77,
   KEY_HOME         = 78,
   KEY_END          = 79,
   KEY_PGUP         = 80,
   KEY_PGDN         = 81,
   KEY_LEFT         = 82,
   KEY_RIGHT        = 83,
   KEY_UP           = 84,
   KEY_DOWN         = 85,
   KEY_SLASH_PAD    = 86,
   KEY_ASTERISK     = 87,
   KEY_MINUS_PAD    = 88,
   KEY_PLUS_PAD     = 89,
   KEY_DEL_PAD      = 90,
   KEY_ENTER_PAD    = 91,
   KEY_PRTSCR       = 92,
   KEY_PAUSE        = 93,
   KEY_ABNT_C1      = 94,
   KEY_YEN          = 95,
   KEY_KANA         = 96,
   KEY_CONVERT      = 97,
   KEY_NOCONVERT    = 98,
   KEY_AT           = 99,
   KEY_CIRCUMFLEX   = 100,
   KEY_COLON2       = 101,
   KEY_KANJI        = 102,
   KEY_EQUALS_PAD   = 103,  /* MacOS X */
   KEY_BACKQUOTE    = 104,  /* MacOS X */
   KEY_SEMICOLON    = 105,  /* MacOS X */
   KEY_COMMAND      = 106,  /* MacOS X */
   KEY_UNKNOWN1     = 107,
   KEY_UNKNOWN2     = 108,
   KEY_UNKNOWN3     = 109,
   KEY_UNKNOWN4     = 110,
   KEY_UNKNOWN5     = 111,
   KEY_UNKNOWN6     = 112,
   KEY_UNKNOWN7     = 113,
   KEY_UNKNOWN8     = 114,

   KEY_MODIFIERS    = 115,

   KEY_LSHIFT       = 115,
   KEY_RSHIFT       = 116,
   KEY_LCONTROL     = 117,
   KEY_RCONTROL     = 118,
   KEY_ALT          = 119,
   KEY_ALTGR        = 120,
   KEY_LWIN         = 121,
   KEY_RWIN         = 122,
   KEY_MENU         = 123,
   KEY_SCRLOCK      = 124,
   KEY_NUMLOCK      = 125,
   KEY_CAPSLOCK     = 126,

   KEY_MAX          = 127
}

// FIXME: only for building allegro?
mixin(_export!("extern extern (C) KEYBOARD_DRIVER * keyboard_driver;"));
//_DRIVER_INFO _keyboard_driver_list[];
//_DRIVER_INFO* _keyboard_driver_list;


extern (C) {

int install_keyboard ();
void remove_keyboard ();

int poll_keyboard ();
int keyboard_needs_poll ();

mixin(_export!(
   "extern  {"
      "int (*keyboard_callback) (int key);"
      "int (*keyboard_ucallback) (int key, int *scancode);"
      "void (*keyboard_lowlevel_callback) (int scancode);"
   "}"
));

void install_keyboard_hooks (int (*keypressed) (), int (*readkey) ());

}  // extern (C)

import derelict.allegro.internal.dintern;

char[] key() { volatile return derelict.allegro.internal.dintern.key; }

сим[] клавиша()
{
return cast(сим[]) key();
}

int key_shifts() { volatile return derelict.allegro.internal.dintern.key_shifts; }

цел сдвиги_клавиш()
{
return cast(цел) key_shifts();
}

extern (C) {

mixin(_export!("extern int three_finger_flag;"));
mixin(_export!("extern int key_led_flag;"));

int keypressed ();
int readkey ();
int ureadkey (int *scancode);
void simulate_keypress (int keycode);
void simulate_ukeypress (int keycode, int scancode);
void clear_keybuf ();
void set_leds (int leds);
void set_keyboard_rate (int delay, int repeat);
int scancode_to_ascii (int scancode);
stringz scancode_to_name (int scancode);

} // extern (C)

цел установи_клавиатуру()
	{
	return cast(цел) install_keyboard ();
	}

проц удали_клавиатуру()
	{
	remove_keyboard ();
	}

цел опроси_клавиатуру()
	{
	return cast(цел) poll_keyboard ();
	}

цел требуется_опрос_клавиатуры()
	{
	return cast(цел) keyboard_needs_poll ();
	}
/*
проц установи_хуки_клавиатуры(цел (*нажата_клавища) (), цел (*читайклавишу) ())
{
install_keyboard_hooks (нажата_клавиша (), читайклавишу ());
}*/
alias install_keyboard_hooks установи_хуки_клавиатуры;

цел нажата_клавиша()
	{
	return cast(цел) keypressed ();
	}

цел читайклав()
	{
	return cast(цел) readkey ();
	}

цел учитайклав(цел *сканкод)
	{
	return cast(цел) ureadkey (сканкод);
	}

проц симулируй_нажим_клавиши(цел код_клавиши)
	{
	 simulate_keypress (код_клавиши);
	}

проц симулируй_унажим_клавиши(цел код_клавиши, цел сканкод)
	{
	 simulate_ukeypress (код_клавиши, сканкод);
	}

проц очисть_буфклав()
	{
	 clear_keybuf ();
	}

проц уст_светодиоды(цел свдиоды)
	{
	 set_leds (свдиоды);
	}

проц уст_частоту_клавиатуры(цел задержка, цел повтор)
{
 set_keyboard_rate (задержка, повтор);
 }

цел сканкод_в_аски(цел сканкод)
	{
	return cast(цел) scancode_to_ascii (сканкод);
	}

ткст0 сканкод_в_имя(цел сканкод)
	{
	return cast(ткст0) scancode_to_name (сканкод);
	}
