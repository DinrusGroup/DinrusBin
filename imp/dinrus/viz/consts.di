module viz.consts;
import winapi;

enum ИдПлатформы: DWORD
{
	WIN_CE = cast(DWORD)-1,
	WIN32s = 0,
	WIN32_WINDOWS = 1,
	WIN32_NT = 2,
}

enum: WPARAM
{
	WPARAM_VIZ_INVOKE = 78,
	WPARAM_VIZ_DELAY_INVOKE = 79,
	WPARAM_VIZ_DELAY_INVOKE_PARAMS = 80,
	WPARAM_VIZ_INVOKE_SIMPLE = 81,
}

// Flags.
enum СтильШрифта: ббайт
{
	ОБЫЧНЫЙ = 0,
 	ПОЛУЖИРНЫЙ = 1, 
	КУРСИВ = 2, 
	ПОДЧЁРКНУТЫЙ = 4, 
	ЗАЧЁРКНУТЫЙ = 8, 
}

enum СглаживаниеШрифта
{
	ПО_УМОЛЧАНИЮ = 0,
	ВКЛ = 4,
	ВЫКЛ = 3,
}

enum ЕдиницаГрафики: ббайт // docmain ?
{
	ПИКСЕЛЬ,	
	ДИСПЛЕЙ, // 1/75 inch.	
	ДОКУМЕНТ, // 1/300 inch.	
	ДЮЙМ, // 1 inch, der.	
	МИЛЛИМЕТР, // 25.4 millimeters in 1 inch.	
	ТОЧКА, // 1/72 inch.
	//WORLD, // ?
	TWIP, // Extra. 1/1440 inch.
}

enum ПКлавиши: бцел // docmain
{
	НЕУК =     0, /// No ПКлавиши задано.	
	ШИФТ =    0x10000, /// Modifier ПКлавиши.
	КОНТРОЛ =  0x20000, 
	АЛЬТ =      0x40000, 
	
	A = 'A', /// Letters.
	B = 'B', 
	C = 'C', 
	D = 'D', 
	E = 'E', 
	F = 'F', 
	G = 'G', 
	H = 'H', 
	I = 'I', 
	J = 'J', 
	K = 'K', 
	L = 'L', 
	M = 'M', 
	N = 'N', 
	O = 'O', 
	P = 'P', 
	Q = 'Q', 
	R = 'R', 
	S = 'S', 
	T = 'T', 
	U = 'U', 
	V = 'V', 
	W = 'W', 
	X = 'X', 
	Y = 'Y', 
	Z = 'Z', 
	
	D0 = '0', /// Digits.
	D1 = '1', 
	D2 = '2', 
	D3 = '3', 
	D4 = '4', 
	D5 = '5', 
	D6 = '6', 
	D7 = '7', 
	D8 = '8', 
	D9 = '9', 
	
	F1 = 112, /// F - function ПКлавиши.
	F2 = 113, 
	F3 = 114, 
	F4 = 115, 
	F5 = 116, 
	F6 = 117, 
	F7 = 118, 
	F8 = 119, 
	F9 = 120, 
	F10 = 121, 
	F11 = 122, 
	F12 = 123, 
	F13 = 124, 
	F14 = 125, 
	F15 = 126, 
	F16 = 127, 
	F17 = 128, 
	F18 = 129, 
	F19 = 130, 
	F20 = 131, 
	F21 = 132, 
	F22 = 133, 
	F23 = 134, 
	F24 = 135, 
	
	NUM_PAD0 = 96, /// Numbers on keypad.
	NUM_PAD1 = 97, 
	NUM_PAD2 = 98, 
	NUM_PAD3 = 99, 
	NUM_PAD4 = 100, 
	NUM_PAD5 = 101, 
	NUM_PAD6 = 102, 
	NUM_PAD7 = 103, 
	NUM_PAD8 = 104, 
	NUM_PAD9 = 105, 
	
	ADD = 107,
 	APPS = 93,
 /// Приложение.
	ATTN = 246,
 	BACK = 8,
 /// Backspace.
	ОТМЕНА = 3,
 	CAPITAL = 20,
 	CAPS_LOCK = 20,
 
	CLEAR = 12,
 	КЛАВИША_КОНТРОЛ = 17,
 	CRSEL = 247,
 	DECIMAL = 110,
 	DEL = 46,
 	DELETE = DEL,
 	PERIOD = 190,
 	Пунктир = PERIOD,
 
	DIVIDE = 111,
 	DOWN = 40,
 /// Down стрелка.
	END = 35,
 	ENTER = 13,
 	ERASE_EOF = 249,
 	ESCAPE = 27,
 	EXECUTE = 43,
 	EXSEL = 248,
 	FINAL_MODE = 4,
 /// IME final mode.
	HANGUL_MODE = 21,
 /// IME Hangul mode.
	HANGUEL_MODE = 21,
 
	HANJA_MODE = 25,
 /// IME Hanja mode.
	СПРАВКА = 47,
 	HOME = 36,
 	IME_ACCEPT = 30,
 	IME_CONVERT = 28,
 	IME_MODE_CHANGE = 31,
 	IME_NONCONVERT = 29,
 	INSERT = 45,
 	JUNJA_MODE = 23,
 	KANA_MODE = 21,
 	KANJI_MODE = 25,
 	LEFT_КОНТРОЛ = 162,
 /// Left Ctrl.
	ЛЕВ = 37,
 /// Left стрелка.
	LINE_FEED = 10,
 	LEFT_MENU = 164,
 /// Left Alt.
	LEFT_SHIFT = 160,
 	LEFT_WIN = 91,
 /// Left Windows logo.
	MENU = 18,
 /// Alt.
	MULTIPLY = 106,
 	NEXT = 34,
 /// Page down.
	NO_NAME = 252,
 // Reserved for future use.
	NUM_LOCK = 144,
 	OEM8 = 223,
 // OEM specific.
	OEM_CLEAR = 254,

	PA1 = 253,

	PAGE_DOWN = 34,
 	PAGE_UP = 33,
 	PAUSE = 19,
 	PLAY = 250,
 	PRINT = 42,
 	PRINT_SCREEN = 44,
 	PROCESS_KEY = 229,
 	RIGHT_КОНТРОЛ = 163,
 /// Right Ctrl.
	RETURN = 13,
 	ПРАВ = 39,
 /// Right стрелка.
	RIGHT_MENU = 165,
 /// Right Alt.
	RIGHT_SHIFT = 161,
 	RIGHT_WIN = 92,
 /// Right Windows logo.
	ПРОМОТКА = 145,
 /// Scroll lock.
	SELECT = 41,
 	SEPARATOR = 108,
 	SHIFT_KEY = 16,
 	SNAPSHOT = 44,
 /// Print screen.
	SPACE = 32,
 	SPACEBAR = SPACE,
 // Extra.
	SUBTRACT = 109,
 	TAB = 9,
 	UP = 38,
 /// Up стрелка.
	ZOOM = 251,
 	
	// Windows 2000+
	BROWSER_BACK = 166,
 	BROWSER_FAVORITES = 171, 
	BROWSER_FORWARD = 167, 
	BROWSER_HOME = 172, 
	BROWSER_REFRESH = 168, 
	BROWSER_SEARCH = 170, 
	BROWSER_STOP = 169,
 
	LAUNCH_APPLICATION1 = 182,
 	LAUNCH_APPLICATION2 = 183,
 
	LAUNCH_MAIL = 180,
 
	MEDIA_NEXT_TRACK = 176,
 	MEDIA_PLAY_PAUSE = 179,
 
	MEDIA_PREVIOUS_TRACK = 177,
 
	MEDIA_STOP = 178,
 
	OEM_BACKSLASH = 226,
 // OEM angle bracket or backslash.
	OEM_CLOSE_BRACKETS = 221,

	OEM_COMMA = 188,
	OEM_MINUS = 189,
	OEM_OPEN_BRACKETS = 219,
	OEM_PERIOD = 190,
	OEM_PIPE = 220,
	OEM_PLUS = 187,
	OEM_QUESTION = 191,
	OEM_QUOTES = 222,
	OEM_SEMICOLON = 186,
	OEM_TILDE = 192,
	SELECT_MEDIA = 181,
 	VOLUME_DOWN = 174,
 	VOLUME_MUTE = 173, 
	VOLUME_UP = 175, 
	
	/// Bit mask to extract key code from key значение.
	КОД_КЛАВИШИ = 0xFFFF,
	
	/// Bit mask to extract модификаторы from key значение.
	МОДИФИКАТОРЫ = 0xFFFF0000,
}
enum HatchStyle: цел
{
	ГОРИЗ = 0, 
	ВЕРТ = 1, 
	FORWARD_DIAGONAL = 2, 
	BACKWARD_DIAGONAL = 3, 
	CROSS = 4, 
	DIAGONAL_CROSS = 5, 
}

enum СокращениеТекста: UINT
{
	НЕУК = 0,
	ЭЛЛИПСИС = 0x00008000, 
	ЭЛЛИПСИС_ПУТЬ = 0x00004000, 
}


enum ФлагиФорматаТекста: UINT
{
	БЕЗ_ПРЕФИКСОВ = 0x00000800,
	СПРАВА_НАЛЕВО = 0x00020000, 
	ПРЕРВАТЬ_СЛОВО = 0x00000010, 
	ЕДИНАЯ_СТРОКА = 0x00000020, 
	БЕЗ_ОБРЕЗКИ = 0x00000100, 
	ЛИМИТ_СТРОКА = 0x00002000, 
}


enum РасположениеТекста: UINT
{
	ЛЕВ = 0x00000000,
 	ПРАВ = 0x00000002, 
	ЦЕНТР = 0x00000001, 
	
	ВЕРХ = 0x00000000,  /// Single line only расположение.
	НИЗ = 0x00000008, 
	СРЕДН = 0x00000004, 
}

enum ПРежимОтрисовки: ббайт
{
	НОРМА,
 	OWNER_DRAW_FIXED,
 	OWNER_DRAW_VARIABLE, 
}

enum ПСостОтрисовкиЭлемента: бцел
{
	НЕУК = 0,
 	ВЫДЕЛЕНО = 1, 
	ОТКЛЮЧЕНО = 2, 
	УСТАНОВЛЕНО = 8, 
	ФОКУС = 0x10, 
	ПО_УМОЛЧАНИЮ = 0x20, 
	HOT_LIGHT = 0x40, 
	NO_ACCELERATOR = 0x80, 
	НЕАКТИВНО = 0x100, 
	NO_FOCUS_RECT = 0x200, 
	COMBO_BOX_EDIT = 0x1000, 
}

enum ПСправаНалево: ббайт
{
	НАСЛЕДОВАТЬ = 2,
 	ДА = 1, 
	НЕТ = 0, 
}

enum ПГоризРасположение: ббайт
{
	ЛЕВ,
 	ПРАВ, 
	ЦЕНТР, 
}

enum ППолосыПрокрутки: ббайт
{
	НЕУК, 	
	ГОРИЗ,
 	ВЕРТ, 
	ОБА, 
}

enum ПРегистрСимволов: ббайт
{
	НОРМА,
 	ПРОПИСЬ,
 	ЗАГ,
 }

enum ПРасположение: ббайт
{
	ВЕРХ_ЛЕВ,
 	НИЗ_ЦЕНТР,
 	НИЗ_ЛЕВ,
 	НИЗ_ПРАВ,
 	ЦЕНТР,
 	ЦЕНТР_ЛЕВ,
 	ЦЕНТР_ПРАВ,
 	ВЕРХ_ЦЕНТР,
 	ВЕРХ_ПРАВ,
 }
 
enum ПНаружность: ббайт
{
	НОРМА,
 	КНОПКА,
 }
 
enum ПСтильКромки: ббайт
{
	НЕУК, 	
	ФИКС_3М,
 	ФИКС_ЕДИН,
 
}

enum ПАктивацияПункта: ббайт
{
	СТАНДАРТ,
 	ОДИН_КЛИК,
 	ДВА_КЛИКА,
 }
 
enum ПВид: ббайт
{
	БОЛЬШАЯ_ПИКТ,
 	МАЛЕНЬКАЯ_ПИКТ,
 	СПИСОК,
 	ДЕТАЛИ,
 }
 
enum ППорядокСортировки: ббайт
{
	НЕУК, 	
	ВОЗРАСТАНИЕ,
 	УМЕНЬШЕНИЕ, 
}

enum ПРезДиалога: ббайт // docmain
{
	НЕУК, 	
	АБОРТ = 3,
 	ОТМЕНА = 2,
 	ИГНОРИРОВАТЬ = 5,
 	НЕТ = 7,
 	ОК = 1,
 	ПОВТОРИТЬ = 4,
 	ДА = 6, 	
	ЗАКРЫТЬ = 8,
	СПРАВКА = 9,
}

enum ПСостУст: ббайт
{
	НЕУСТ = 0x0000,
 	УСТАНОВЛЕНО = 0x0001, 
	НЕОПРЕД = 0x0002, 
}


enum ПКнопкиМыши: бцел 
{
	НЕУК =      0,	
	ЛЕВ =      0x100000,
 	ПРАВ =     0x200000, 
	СРЕДН =    0x400000, 
}

enum ПСтилиЯкоря: ббайт
{
	НЕУК = 0, 
	ВЕРХ = 1, 
	НИЗ = 2, 
	ЛЕВ = 4, 
	ПРАВ = 8, 
	
	/+
	// Extras:
	ВЕРТ = ВЕРХ | НИЗ,
	ГОРИЗ = ЛЕВ | ПРАВ,
	ВСЕ = ВЕРХ | НИЗ | ЛЕВ | ПРАВ,
	ПО_УМОЛЧАНИЮ = ВЕРХ | ЛЕВ,
	ВЕРХ_ЛЕВ = ВЕРХ | ЛЕВ,
	ВЕРХ_ПРАВ = ВЕРХ | ПРАВ,
	НИЗ_ЛЕВ = НИЗ | ЛЕВ,
	НИЗ_ПРАВ = НИЗ | ПРАВ,
	+/
}

/// Флаги для установки границ управляющего элемента.
enum ПЗаданныеПределы: ббайт
{
	НЕУК = 0,
 	X = 1, 
	Y = 2, 
	ПОЛОЖЕНИЕ = 1 | 2, 
	ШИРИНА = 4, 
	ВЫСОТА = 8, 
	РАЗМЕР = 4 | 8, 
	ВСЕ = 1 | 2 | 4 | 8, 
}

/// Layout docking стиль.
enum ПДокСтиль: ббайт
{
	НЕУК,
 	НИЗ,
 	ЗАПОЛНИТЬ,
 	ЛЕВ,
 	ПРАВ,
 	ВЕРХ,
}

/// Effect флаги for drag/drop operations.
enum ПЭффектыДД: DWORD
{
	НЕУК = 0, 
	КОПИЯ = 1, 
	ПЕРЕМЕЩЕНИЕ = 2, 
	ЛИНК = 4, 
	ПРОМОТКА = 0x80000000, 
	ВСЕ = КОПИЯ | ПЕРЕМЕЩЕНИЕ | ЛИНК | ПРОМОТКА, 
}

/// Drag/drop действие.
enum ПДрэгДействие: HRESULT
{
	ПРОДОЛЖЕНИЕ = 0,
 	ОТМЕНА = 0x00040101, 
	БРОС = 0x00040100, 
}

// May be OR'ed together.
/// Style флаги of а упрэлт.
enum ПСтилиУпрЭлта: бцел
{
	НЕУК = 0, 	
	КОНТЕЙНЕР =                0x1, 
	
	// TODO: implement.
	USER_PAINT =                       0x2, 
	
	НЕПРОЗРАЧНЫЙ =                           0x4, 
	ПЕРЕРИС_ПЕРЕМЕР =                    0x10, 
	//FIXED_WIDTH =                      0x20, // TODO: implement.
	//FIXED_HEIGHT =                     0x40, // TODO: implement.
	СТАНДАРТНЫЙ_КЛИК =                   0x100, 
	ВЫДЕЛЕНИЕ =                       0x200, 
	
	// TODO: implement.
	ПОЛЬЗОВАТЕЛЬ_МЫШЬ =                       0x400, ///  ditto
	
	//SUPPORTS_TRANSPARENT_BACK_COLOR =  0x800, // Only if USER_PAINT and родитель is derived from УпрЭлт. TODO: implement.
	СТАНДАРТНЫЙ_ДВУКЛИК =            0x1000, 
	ALL_PAINTING_IN_WM_PAINT =         0x2000, 
	CACHE_TEXT =                       0x4000, 
	ENABLE_NOTIFY_MESSAGE =            0x8000, // deprecated. Calls onNotifyMessage() for every сообщение.
	//DOUBLE_BUFFER =                    0x10000, // TODO: implement.
	
	WANT_TAB_KEY = 0x01000000,
	WANT_ALL_KEYS = 0x02000000,
}

enum ПорцияГраницЭлемента: ббайт
{
	ENTIRE,
 	ПИКТОГРАММА,
 	ТОЛЬКО_ЭЛТ,
 /// Excludes other stuff like check boxes.
	ЯРЛЫК,
 /// Текст элемента.
}

enum СтильЗаголовкаСтолбца: ббайт
{
	КЛИКАЕМЫЙ,
 	НЕКЛИКАЕМЫЙ,
 	НЕУК,
 /// No столбец header.
}

enum ПлоскийСтиль: ббайт
{
	СТАНДАРТ,
 	ПЛОСКИЙ, 
	ВСПЛЫВАЮЩИЙ, 
	СИСТЕМНЫЙ, 
}

enum ГлубинаЦвета: ббайт
{
	БИТ4 = 0x04,
 	БИТ8 = 0x08, 
	БИТ16 = 0x10, 
	БИТ24 = 0x18, 
	БИТ32 = 0x20, 
}

enum ПШрифтУпрЭлта: ббайт
{
	СОВМЕСТИМЫЙ,
 	СТАРЫЙ, 
	ИСКОННЫЙ, 
}

enum ПСтильКромкиФормы: ббайт //: ПСтильКромки
{
	НЕУК = ПСтильКромки.НЕУК, 	
	ФИКС_3М = ПСтильКромки.ФИКС_3М, 
	ФИКС_ЕДИН = ПСтильКромки.ФИКС_ЕДИН, 
	ФИКС_ДИАЛОГ, 
	НЕФИКС, 
	ФИКС_ИНСТР, 
	НЕФИКС_ИНСТР, 
}

deprecated enum SizeGripStyle: ббайт
{
	АВТО,
 	СКРОЙ, 
	ПОКАЖИ, 
}


enum ПНачПоложениеФормы: ббайт
{
	ЦЕНТР_РОДИТЕЛЯ,
 	ЦЕНТР_ЭКРАНА, 
	РУЧНОЕ, 
	ДЕФГРАНИЦЫ, 
	ВИНДЕФГРАНИЦЫ = ДЕФГРАНИЦЫ, // deprecated
	ДЕФПОЛОЖЕНИЕ, 
	ВИНДЕФПОЛОЖЕНИЕ = ДЕФПОЛОЖЕНИЕ, // deprecated
}


enum ПСостОкнаФормы: ббайт
{
	РАЗВЁРНУТО,
 	СВЁРНУТО, 
	НОРМА, 
}

enum РаскладкаМди: ббайт
{
	ARRANGE_ICONS,
 	CASCADE, 
	TILE_HORIZONTAL, 
	TILE_VERTICAL, 
}