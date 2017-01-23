/**
* Универсальный рантаймный модуль языка программирования Динрус,
* поддерживающий совместимость с английской версией.
* Разработчик Виталий Кулич
*/
module base;

version = Dinrus;
version = Unicode;
version = ЛитлЭндиан;

int useWfuncs = 1;
alias useWfuncs __ЮНИКОД__;

//Константы
const бул нет = false;
const бул да = true;
const пусто = null;
alias пусто NULL;
//const неук = проц; //получить тип от инициализатора не удаётся...

/* ************* Константы *************** */
    /** Cтрока, используемая для разделения в пути названий папок.
	* для  Windows это обратный слэш, для Linux - прямой. */
    const сим[1] РАЗДПАП = '\\';
    /** Альтернативная версия разделителя, используемая на Windows (слэш).
     *  Для Linux - пустая константа. */
    const сим[1] АЛЬТРАЗДПАП = '/';
    /** Строка разделитель пути. На Windows точка с запятой, на
     *  Linux - двоеточие. */
    const сим[1] РАЗДПСТР = ';';
    /** Строка, используемая для разделения строк, \r\n на Windows и \n
     * на Linux. */
    const сим[2] РАЗДСТР = "\r\n"; /// Строка-разделитель строк.
    const сим[1] ТЕКПАП = '.';	 /// Строка, представляющая текущую папку.
    const сим[2] РОДПАП = ".."; /// Строка, представляющая родительскую папку (папку на уровень выше).

const сим[16] ЦИФРЫ16 = "0123456789ABCDEF";			/// 0..9A..F
const сим[10] ЦИФРЫ    = "0123456789";			/// 0..9
const сим[8]  ЦИФРЫ8 = "01234567";				/// 0..7
const сим[92] ПРОПИСНЫЕ = "abcdefghijklmnopqrstuvwxyzабвгдеёжзийклмнопрстуфхцчшщъыьэюя";	/// а..z а..я
const сим[92] СТРОЧНЫЕ = "ABCDEFGHIJKLMNOPQRSTUVWXYZАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ";	/// A..Z А..Я
const сим[184] БУКВЫ   = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" "abcdefghijklmnopqrstuvwxyz" "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ" "абвгдеёжзийклмнопрстуфхцчшщъыьэюя";	/// A..Za..zА..Яа..я

const сим[6] ПРОБЕЛЫ = " \t\v\r\n\f";			/// пробелы в ASCII

const сим[3] РС = \u2028; /// Разделитель строк Unicode.
const дим РСд = 0x2028;  /// определено
const сим[3] РА = \u2029; /// Разделитель абзацев Unicode.
const дим РАд = 0x2029;  /// определено
static assert(РС[0] == РА[0] && РС[1] == РА[1]);

/// Метка перехода на новую строку для данной системы
version (Windows)
    const сим[2] НОВСТР = РАЗДСТР;
else version (Posix)
    const сим[1] НОВСТР = '\n';
	

/// Перечень меток порядка байтов UTF (BOM) 
enum МПБ {
	
	Ю8,		/// UTF-8
	Ю16ЛЕ,	/// UTF-16 Little Эндиан
	Ю16БЕ,	/// UTF-16 Big Эндиан
	Ю32ЛЕ,	/// UTF-32 Little Эндиан
	Ю32БЕ,	/// UTF-32 Big Эндиан
	Нет
}

private const цел ЧМПБ = 5;

Эндиан[ЧМПБ] МПБЭндиан = 
[ _эндиан, 
  Эндиан.Литл, Эндиан.Биг,
  Эндиан.Литл, Эндиан.Биг
  ];

ббайт[][ЧМПБ] МеткиПорядкаБайтов = 
[ [0xEF, 0xBB, 0xBF],
  [0xFF, 0xFE],
  [0xFE, 0xFF],
  [0xFF, 0xFE, 0x00, 0x00],
  [0x00, 0x00, 0xFE, 0xFF]
  ];
  


const{

version(ЛитлЭндиан)
{
    private const цел Эндиан_Амбьент =   1;
}

version(БигЭндиан)
{
    private const цел Эндиан_Амбьент =   2;
}

enum Эндиан
{
    Неизвестно =   0,                   //!< Неизвестно эндиан-ness. Indicates an ошиб
    Литл  =   1,                   //!< Литтл эндиан architecture
    Биг     =   2 ,                  //!< Биг эндиан architecture
    Мидл  =   3   ,                //!< Миддл эндиан architecture
    БайтСекс =   4,
    Амбьент =   Эндиан_Амбьент 
}

/*
	enum Эндиан
	 {
		БигЭндиан,	/// порядок байта, когда его завершает наибольший - старший - бит
		ЛитлЭндиан	/// порядок байта, когда в конце него находится младший бит
	 }

	*/
	version(ЛитлЭндиан)
	{
		/// Исконная "эндианность" системы
			Эндиан _эндиан = Эндиан.Литл;
	}
	else
	{
			Эндиан _эндиан = Эндиан.Биг;
	}
  
}	
	
typedef дол т_время;
typedef бцел ФВремяДос;
const т_время т_время_нч = cast(т_время) дол.min;
alias сим рсим;
alias ткст рткст;
/+
alias typeof(delegate) делегат;
alias typeof(function) функция;
alias typeof(struct)    структ;
alias typeof(union)       союз;
+/

version(ЛитлЭндиан) {
    static assert(реал.mant_dig == 53 || реал.mant_dig==64
               || реал.mant_dig == 113,
      "Только 64-битные, 80-битные и 128-битные реалы"
      " поддерживаются для процессоров ЛитлЭндиан");
} else {
    static assert(реал.mant_dig == 53 || реал.mant_dig==106
               || реал.mant_dig == 113,
    "Только 64-битные и 128-битные реалы поддерживаются для процессоров БигЭндиан."
    " дво-дво реалы имеют частичную поддержку.");
}

// Константы, используемые для извлечения компонентов из их представлений.
// Они обслуживают встроеннные свойства плавающей точки.
template плавТрэтс(T) {
 // МАСКАВЫР - это бкрат маска для выделения экспонентной части (без знака)
 // СТП2ЧИСМАНТ = pow(2, реал.mant_dig): ЭТО ЗНАЧЕНИЕis the value such that
 //  (smallest_denormal)*СТП2ЧИСМАНТ == реал.min
 // ПОЗВЫР_КРАТ is the index of the exponent when represented as а ushort array.
 // ПОЗЗНАКА_БАЙТ is the index of the sign when represented as а ббайт array.
 static if (T.mant_dig == 24) { // float
    const бкрат МАСКАВЫР = 0x7F80;
    const бкрат БИАСВЫР = 0x3F00;
    const uint МАСКАВЫР_ЦЕЛ = 0x7F80_0000;
    const uint МАСКАМАНТИССЫ_ЦЕЛ = 0x007F_FFFF;
    const реал СТП2ЧИСМАНТ = 0x1p+24;
    version(ЛитлЭндиан) {
      const ПОЗВЫР_КРАТ = 1;
    } else {
      const ПОЗВЫР_КРАТ = 0;
    }
 } else static if (T.mant_dig == 53) { // double, or реал==double
    const бкрат МАСКАВЫР = 0x7FF0;
    const бкрат БИАСВЫР = 0x3FE0;
    const uint МАСКАВЫР_ЦЕЛ = 0x7FF0_0000;
    const uint МАСКАМАНТИССЫ_ЦЕЛ = 0x000F_FFFF; // for the MSB only
    const реал СТП2ЧИСМАНТ = 0x1p+53;
    version(ЛитлЭндиан) {
      const ПОЗВЫР_КРАТ = 3;
      const ПОЗЗНАКА_БАЙТ = 7;
    } else {
      const ПОЗВЫР_КРАТ = 0;
      const ПОЗЗНАКА_БАЙТ = 0;
    }
 } else static if (T.mant_dig == 64) { // real80
    const бкрат МАСКАВЫР = 0x7FFF;
    const бкрат БИАСВЫР = 0x3FFE;
    const реал СТП2ЧИСМАНТ = 0x1p+63;
    version(ЛитлЭндиан) {
      const ПОЗВЫР_КРАТ = 4;
      const ПОЗЗНАКА_БАЙТ = 9;
    } else {
      const ПОЗВЫР_КРАТ = 0;
      const ПОЗЗНАКА_БАЙТ = 0;
    }
 } else static if (реал.mant_dig == 113){ // quadruple
    const бкрат МАСКАВЫР = 0x7FFF;
    const реал СТП2ЧИСМАНТ = 0x1p+113;
    version(ЛитлЭндиан) {
      const ПОЗВЫР_КРАТ = 7;
      const ПОЗЗНАКА_БАЙТ = 15;
    } else {
      const ПОЗВЫР_КРАТ = 0;
      const ПОЗЗНАКА_БАЙТ = 0;
    }
 } else static if (реал.mant_dig == 106) { // doubledouble
    const бкрат МАСКАВЫР = 0x7FF0;
    const реал СТП2ЧИСМАНТ = 0x1p+53;  // doubledouble denormals are strange
    // and the exponent byte is not unique
    version(ЛитлЭндиан) {
      const ПОЗВЫР_КРАТ = 7; // [3] is also an exp short
      const ПОЗЗНАКА_БАЙТ = 15;
    } else {
      const ПОЗВЫР_КРАТ = 0; // [4] is also an exp short
      const ПОЗЗНАКА_БАЙТ = 0;
    }
 }
}

// These apply to all floating-point types
version(ЛитлЭндиан) {
    const МАНТИССА_МЗЧ = 0; //LSB
    const МАНТИССА_БЗЧ = 1; //MSB
} else {
    const МАНТИССА_МЗЧ = 1;
    const МАНТИССА_БЗЧ = 0;
}

/**
*Константы математического характера
*/

const реал ЛОГ2Т =      0x1.a934f0979a3715fcp+1;
const реал ЛОГ2Е =      0x1.71547652b82fe178p+0;
const реал ЛОГ2 =       0x1.34413509f79fef32p-2;
const реал ЛОГ10Е =     0.43429448190325182765;
const реал ЛН2 =        0x1.62e42fefa39ef358p-1;
const реал ЛН10 =       2.30258509299404568402;
const реал ПИ =         0x1.921fb54442d1846ap+1;
const реал ПИ_2 =       1.57079632679489661923;
const реал ПИ_4 =       0.78539816339744830962;
const реал М_1_ПИ =     0.31830988618379067154;
const реал М_2_ПИ =     0.63661977236758134308;
const реал М_2_КВКОРПИ = 1.12837916709551257390;
const реал КВКОР2 =      1.41421356237309504880;
const реал КВКОР1_2 =    0.70710678118654752440;

const реал E =          2.7182818284590452354L;

const реал МАКСЛОГ = 0x1.62e42fefa39ef358p+13L;  /** лог(реал.max) */
const реал МИНЛОГ = -0x1.6436716d5406e6d8p+13L; /** лог(реал.min*реал.epsilon) */
const реал ОЙЛЕРГАММА = 0.57721_56649_01532_86060_65120_90082_40243_10421_59335_93992L; /** Euler-Mascheroni constant 0.57721566.. */

const ткст ИМЕЙЛ =
r"[а-zA-Z]([.]?([[а-zA-Z0-9_]-]+)*)?@([[а-zA-Z0-9_]\-_]+\.)+[а-zA-Z]{2,6}";
	
const ткст УРЛ =  r"(([h|H][t|T]|[f|F])[t|T][p|P]([s|S]?)\:\/\/|~/|/)?([\w]+:\w+@)?(([а-zA-Z]{1}([\w\-]+\.)+([\w]{2,5}))(:[\d]{1,5})?)?((/?\w+/)+|/?)(\w+\.[\w]{3,4})?([,]\w+)*((\?\w+=\w+)?(&\w+=\w+)*([,]\w*)*)?";

enum
{
	ЧасовВДне    = 24,
	МинутВЧасе = 60,
	МсекВМинуте    = 60 * 1000,
	МсекВЧасе      = 60 * МсекВМинуте,
	МсекВДень       = 86400000,
	ТиковВМсек     = 1,
	ТиковВСекунду = 1000,			
	ТиковВМинуту = ТиковВСекунду * 60,
	ТиковВЧас   = ТиковВМинуту * 60,
	ТиковВДень    = ТиковВЧас  * 24,
}

enum ПМангл : сим
{
    Тпроц     = 'v',
    Тбул     = 'g',
    Тбайт     = 'b',
    Тббайт    = 'h',
    Ткрат    = 's',
    Тбкрат   = 't',
    Тцел      = 'i',
    Тбцел     = 'k',
    Тдол     = 'l',
    Тбдол    = 'm',
    Тплав    = 'f',
    Тдво   = 'd',
    Треал     = 'e',

    Твплав   = 'o',
    Твдво  = 'p',
    Твреал    = 'j',
    Ткплав   = 'q',
    Ткдво  = 'r',
    Ткреал    = 'c',

    Тсим     = 'a',
    Тшим    = 'u',
    Тдим    = 'w',

    Тмассив    = 'A',
    Тсмассив   = 'G',
    Тамассив   = 'H',
    Туказатель  = 'P',
    Тфункция = 'F',
    Тидент    = 'I',
    Ткласс    = 'C',
    Тструкт   = 'S',
    Тперечень     = 'E',
    Ттипдеф  = 'T',
    Тделегат = 'D',

    Тконст    = 'x',
    Тинвариант = 'y',
}

enum
    {
        СБОЙ_ОП = ~cast(т_мера)0
    }

enum
{   РАЗМЕР_СТРАНИЦЫ =    4096,
    РАЗМЕР_ПОДАЧИ = (4096*16),
    РАЗМЕР_ПУЛА =   (4096*256),
}
const т_мера МАСКА_СТРАНИЦЫ = РАЗМЕР_СТРАНИЦЫ - 1;

	/**
     * Элементы бит-поля, представляющего атрибуты блока памяти. Ими
     * можно манипулировать функциями СМ дайАтр, устАтр, удалиАтр.
     */
    enum ПАтрБлока : бцел
    {
        Финализовать = 0b0000_0001, /// Финализовать данные этого блока при сборке.
        НеСканировать  = 0b0000_0010, /// Не сканировать при сборке данный блок.
        НеПеремещать  = 0b0000_0100,  /// Не перемещать данный блок при сборке.
		МожноДобавить  = 0b0000_1000,
        БезНутра = 0b0001_0000,
		ВсеБиты = 0b1111_1111
    }
	
	
interface ИнфоОтслежИскл
{
    цел opApply( цел delegate( inout ткст ) );
}

version( Windows )
{
    alias wchar wint_t, wchar_t, wctype_t, wctrans_t;

    const wchar WEOF = 0xFFFF;
	alias WEOF ШКФ;
}
else
{
    alias dchar wint_t, wchar_t,  wctype_t, wctrans_t;

    const dchar WEOF = 0xFFFF;
	alias WEOF ШКФ;
}

extern(Windows)
{

alias UINT SOCKET;
alias int socklen_t;

}

	alias DWORD ACCESS_MASK;
    alias ACCESS_MASK *PACCESS_MASK;
    alias ACCESS_MASK REGSAM;
	
    alias extern (Windows) int function() FARPROC, NEARPROC, PROC, ПРОЦУК;
extern (Windows) 
{	
version (0)
{   // Properly prototyped versions
    alias BOOL function(HWND, UINT, WPARAM, LPARAM) DLGPROC;
    alias VOID function(HWND, UINT, UINT, DWORD) TIMERPROC;
    alias BOOL function(HDC, LPARAM, int) GRAYSTRINGPROC;
    alias BOOL function(HWND, LPARAM) WNDENUMPROC;
    alias LRESULT function(int code, WPARAM wParam, LPARAM lParam) HOOKPROC;
    alias VOID function(HWND, UINT, DWORD, LRESULT) SENDASYNCPROC;
    alias BOOL function(HWND, LPCSTR, HANDLE) PROPENUMPROCA;
    alias BOOL function(HWND, LPCWSTR, HANDLE) PROPENUMPROCW;
    alias BOOL function(HWND, LPSTR, HANDLE, DWORD) PROPENUMPROCEXA;
    alias BOOL function(HWND, LPWSTR, HANDLE, DWORD) PROPENUMPROCEXW;
    alias int function(LPSTR lpch, int ichCurrent, int cch, int code)
       EDITWORDBREAKPROCA;
    alias int function(LPWSTR lpch, int ichCurrent, int cch, int code)
       EDITWORDBREAKPROCW;
    alias BOOL function(HDC hdc, LPARAM lData, WPARAM wData, int cx, int cy)
       DRAWSTATEPROC;
}
else
{
    alias FARPROC DLGPROC;
    alias FARPROC TIMERPROC;
    alias FARPROC GRAYSTRINGPROC;
    alias FARPROC WNDENUMPROC;
    alias FARPROC HOOKPROC;
    alias FARPROC SENDASYNCPROC;
    alias FARPROC EDITWORDBREAKPROCA;
    alias FARPROC EDITWORDBREAKPROCW;
    alias FARPROC PROPENUMPROCA;
    alias FARPROC PROPENUMPROCW;
    alias FARPROC PROPENUMPROCEXA;
    alias FARPROC PROPENUMPROCEXW;
    alias FARPROC DRAWSTATEPROC;
}
}
//Базовые типы языка Динрус
version( X86_64 )
{
    alias ulong т_мера, size_t;
    alias long  т_дельтаук, ptrdiff_t;
}
else
{
    alias uint  т_мера, size_t;
    alias int  т_дельтаук, ptrdiff_t;
}

alias т_мера т_хэш, hash_t;

alias char[] ткст, симма, string;
alias char[] *уткст, усимма;

alias wchar[] шткст, шимма, wstring;
alias wchar[] *ушткст, ушимма;

alias dchar[] юткст, димма, dstring;
alias dchar[] *уюткст, удимма;

alias bool бул, бит, bit, BOOLEAN;
alias bool *убул, PBOOLEAN;

extern  (C){

	version( Windows )
	{
		alias int   c_long;
		alias uint  c_ulong;
	}
	else
	{
	  static if( (ук).sizeof > int.sizeof )
	  {
		alias long  c_long;
		alias ulong c_ulong;
	  }
	  else
	  {
		alias int   c_long;
		alias uint  c_ulong;
	  }
	}

    alias int sig_atomic_t;
	
	alias byte      int8_t;
	alias short     int16_t;
	alias int       int32_t;
	alias long      int64_t;
	//alias cent      int128_t;

	alias ubyte     uint8_t;
	alias ushort    uint16_t;
	alias uint      uint32_t;
	alias ulong     uint64_t;
	//alias ucent     uint128_t;

	alias byte      int_least8_t;
	alias short     int_least16_t;
	alias int       int_least32_t;
	alias long      int_least64_t;

	alias ubyte     uint_least8_t;
	alias ushort    uint_least16_t;
	alias uint      uint_least32_t;
	alias ulong     uint_least64_t;

	alias byte      int_fast8_t;
	alias int       int_fast16_t;
	alias int       int_fast32_t;
	alias long      int_fast64_t;

	alias ubyte     uint_fast8_t;
	alias uint      uint_fast16_t;
	alias uint      uint_fast32_t;
	alias ulong     uint_fast64_t;

	version( X86_64 )
	{
		alias long  intptr_t;
		alias ulong uintptr_t;
	}
	else
	{
		alias int   intptr_t;
		alias uint  uintptr_t;
	}

	alias long      intmax_t, т_максцел;
	alias ulong     uintmax_t, т_максбцел;
}

////////////////////////////

alias int цел, т_рав, т_фпоз, equals_t, fexcept_t, fpos_t,LONG, BOOL,WINBOOL, HFILE, INT, LONG32, INT32;
alias int *уцел, PINT, LPINT, LPLONG, PWINBOOL, LPWINBOOL, PBOOL, LPBOOL, PLONG, PLONG32, PINT32;
alias LONG HRESULT, SCODE, LPARAM, LRESULT;
	
alias uint бцел, ЛКИД, DWORD, UINT, ULONG, FLONG, LCID,ULONG32, DWORD32, UINT32;
alias uint *убцел, PULONG, PUINT, PLCID, LPUINT, PULONG32, PDWORD32, PUINT32;
alias UINT WPARAM;
alias DWORD   COLORREF;
alias DWORD *PDWORD, LPDWORD, LPCOLORREF;

alias long дол, LONGLONG, USN, LONG64, INT64;
alias long *удол, PLONGLONG,PLONG64, PINT64;

alias ulong бдол, ULONG64, DWORD64, UINT64, DWORDLONG, ULONGLONG;
alias ulong *убдол, PULONG64, PDWORD64, PUINT64, PDWORDLONG, PULONGLONG;

alias real реал;
alias real *уреал;

alias double дво, double_t;
alias double *удво;

alias char сим, CHAR, CCHAR;
alias char *усим, ткст0, PSZ, PCHAR;
alias CHAR *LPSTR, PSTR, LPCSTR, PCSTR;
//alias LPSTR LPTCH, PTCH, PTSTR, LPTSTR, LPCTSTR;

alias wchar шим, WCHAR, OLECHAR;
alias wchar *ушим, шткст0, PWCHAR, LPWCH, PWCH, LPWSTR, PWSTR, LPCWSTR, PCWSTR, LPOLESTR, LPCOLESTR;
////////////////////////////////////////////////

enum : BOOL
{
    FALSE = 0,
    TRUE = 1,
}

version(Unicode) {
    alias WCHAR TCHAR, _TCHAR;
} else {
    alias CHAR TCHAR, _TCHAR;
}

alias TCHAR* PTCH, PTBYTE, LPTCH, PTSTR, LPTSTR, LP, PTCHAR, LPCTSTR;
alias TCHAR        TBYTE;

alias dchar дим;
alias dchar *удим;

alias byte байт, FCHAR, INT8;
alias byte *убайт, PINT8;

alias ubyte ббайт, BYTE, UCHAR,UINT8;
alias ubyte *уббайт, PUINT8;
alias UCHAR *PUCHAR;
alias BYTE *PBYTE, LPBYTE;

alias short крат, SHORT,INT16;
alias short *украт, PSHORT, PINT16;

alias ushort бкрат, ИДЯз, WORD, USHORT, LANGID, FSHORT,UINT16;
alias ushort *убкрат,PUINT16;
alias USHORT *PUSHORT;
alias WORD    ATOM, АТОМ;
alias WORD *PWORD, LPWORD;

alias float плав, float_t, FLOAT;
alias float *уплав, PFLOAT;

alias void проц, VOID;
alias void *ук, спис_ва, va_list, HANDLE, PVOID, LPVOID, LPCVOID, PVOID64, PCVOID;
alias HANDLE HINST, HGLOBAL, HLOCAL, HWND, HINSTANCE, HGDIOBJ, HACCEL, HBITMA, HBRUSH, HCOLORSPACE, HDC, HGLRC, HDESK, HENHMETAFILE, HFONT, HICON, HMENU, HMETAFILE, HPALETTE, HPEN, HRGN, HRSRC, HMONITOR, HSTR, HTASK, HWINSTA, HKEY, HKL, HBITMAP;

alias HANDLE* PHANDLE, LPHANDLE;


 version (Windows) 
                 alias ук Дескр;     
             else
                typedef цел Дескр = -1; 
			
alias ук  ДЕСКР;
alias ДЕСКР гук, лук, экз;

alias HINSTANCE HMODULE;
alias HICON HCURSOR;
alias HKEY *PHKEY;

alias COLORREF ЦВПредст;
alias HBRUSH УКисть;
alias HCURSOR УКурсор;
alias HPEN УПеро;
alias HICON УПиктограмма, УИконка;
alias HFONT УШрифт;
alias HWND УОК;

alias ireal вреал;
alias ireal *увреал;

alias idouble вдво;
alias idouble *увдво;

alias ifloat вплав;
alias ifloat *увплав;

alias creal креал;
alias creal *укреал;

alias cdouble кдво;
alias cdouble *укдво;

alias cfloat кплав;
alias cfloat *укплав;

// ULONG_PTR должен способствовать сохранению указателя в виде целочисленного типа
version (Win64)
{
	alias long __int3264;
	const ulong ADDRESS_TAG_BIT = 0x40000000000;

	alias long INT_PTR, LONG_PTR;
	alias long* PINT_PTR, PLONG_PTR;
	alias ulong UINT_PTR, ULONG_PTR, HANDLE_PTR;
	alias ulong* PUINT_PTR, PULONG_PTR;
	alias int HALF_PTR;
	alias int* PHALF_PTR;
	alias uint UHALF_PTR;
	alias uint* PUHALF_PTR;
}
else // Win32
{
	alias int __int3264;
	const uint ADDRESS_TAG_BIT = 0x80000000;

	alias int INT_PTR, LONG_PTR;
	alias int* PINT_PTR, PLONG_PTR;
	alias uint UINT_PTR, ULONG_PTR, HANDLE_PTR;
	alias uint* PUINT_PTR, PULONG_PTR;
	alias short HALF_PTR;
	alias short* PHALF_PTR;
	alias ushort UHALF_PTR;
	alias ushort* PUHALF_PTR;
}


alias ULONG_PTR SIZE_T, DWORD_PTR;
alias ULONG_PTR* PSIZE_T, PDWORD_PTR;
alias LONG_PTR SSIZE_T;
alias LONG_PTR* PSSIZE_T;



//ип = импортируемая переменная
extern(C)
{
alias  extern int ипЦ; 
alias extern uint ипбЦ; 
alias extern double ипД2; 
alias extern float ипП; 
alias extern void ип; 
alias extern void *ипУ; 
alias extern byte ипБ; 
alias extern ubyte ипбБ; 
alias extern char ипС; 
alias extern char *ипуС;
alias extern wchar ипШ;
alias extern wchar *ипуШ;
alias extern long ипД;
alias extern ulong ипбД;
}

alias extern(D) int function() функЦ; 
alias extern(D) uint  function() функбЦ; 
alias extern(D) double  function() функД2; 
alias extern(D) float  function() функП; 
alias extern(D) void  function() функ; 
alias extern(D) void *function() функУ; 
alias extern(D) byte  function() функБ; 
alias extern(D) ubyte  function() функбБ; 
alias extern(D) char  function() функС; 
alias extern(D) char *function() функуС;
alias extern(D) wchar  function() функШ;
alias extern(D)  wchar *function() функуШ;
alias extern(D)  Object  function() функО;
alias extern(D)  long  function() функД;
alias extern(D)  ulong  function() функбД;

alias extern (Windows) проц function(цел) винфунк_Ц;
alias extern (Windows) проц function(цел, цел) винфунк_ЦЦ;
alias extern (Windows) проц function(цел, цел, цел) винфунк_ЦЦЦ;
alias extern (Windows) проц function(цел, цел, цел, цел) винфунк_ЦЦЦЦ;
alias extern (Windows) проц function(цел, цел, цел, цел, цел) винфунк_ЦЦЦЦЦ;
alias extern (Windows) проц function(сим, цел, цел) винфунк_СЦЦ;
alias extern (Windows) проц function(ббайт, цел, цел) винфунк_бБЦЦ;


alias extern (Windows) проц function(бцел, цел, цел, цел) винфунк_бЦЦЦЦ; 

alias extern(Windows) цел  function() винфункЦ; 
alias extern (Windows) цел function(сим, цел, цел) винфункЦ_СЦЦ;
alias extern (Windows) цел function(ббайт, цел, цел) винфункЦ_бБЦЦ;
alias extern (Windows) цел function(цел) винфункЦ_Ц;
alias extern (Windows) цел function(цел, цел) винфункЦ_ЦЦ;
alias extern (Windows) цел function(цел, цел, цел) винфункЦ_ЦЦЦ;
alias extern (Windows) цел function(цел, цел, цел, цел) винфункЦ_ЦЦЦЦ;
alias extern (Windows) цел function (ук, бцел, бцел, цел) винфункЦ_УбЦбЦЦ;

alias extern(Windows) бцел  function() винфункбЦ; 
alias extern(Windows) бцел function (ук, бцел, бцел, цел) винфункбЦ_УбЦбЦЦ;
alias  extern (Windows) бцел function(ук) винфункбЦ_У;

alias extern(Windows) дво  function() винфункД2; 
alias extern(Windows) плав  function() винфункП; 
alias extern(Windows) проц  function() винфунк;
alias extern(Windows) ук   function() винфункУ; 
alias extern(Windows) байт  function() винфункБ; 
alias extern(Windows) ббайт  function() винфункбБ; 
alias extern(Windows) сим  function() винфункС; 
alias extern(Windows) усим function() винфункуС;
alias extern(Windows) шим  function() винфункШ;
alias extern(Windows) ушим function() винфункуШ;
alias extern(Windows) дол  function() винфункД;
alias extern(Windows) бдол  function() винфункбД;

alias extern(Windows) бул  function() винфункБ2;
alias extern(Windows) бул function(бцел) винфункБ2_бЦ;

//alias extern (Windows) struct винструкт;
//alias extern (Windows) class винкласс;

alias винфункЦ_УбЦбЦЦ ОКОНПРОЦ;
alias винфункбЦ_УбЦбЦЦ ОТКРФЛХУКПРОЦ;
alias винфункБ2_бЦ ОБРАБПРОЦ;
alias винфункЦ УДПРОЦ;
 alias УДПРОЦ ДЛГПРОЦ;
 alias УДПРОЦ ТАЙМЕРПРОЦ;
 alias УДПРОЦ СЕРСТРПРОЦ;
 alias УДПРОЦ РИССТПРОЦ; 
alias бцел СОКЕТ;
typedef СОКЕТ т_сокет = cast(СОКЕТ)~0;	
alias цел т_длинсок;
alias бцел ЦВЕТ; 
alias шим ОЛЕСИМ;
alias ОЛЕСИМ олес;
alias цел Бул;
alias бцел МАСКА_ДОСТУПА;
alias ук УкТОКЕН_ДОСТУПА;
alias ук УкБИД;
alias бул РЕЖИМ_ОТСЛЕЖИВАНИЯ_КОНТЕКСТА_БЕЗОПАСНОСТИ;
alias бкрат УПР_ДЕСКРИПТОРА_БЕЗОПАСНОСТИ;

alias проц  function( ткст файл, т_мера строка, ткст сооб = пусто ) типПроверОбр;
alias ИнфоОтслежИскл function( ук укз = пусто ) типСледОбр;	
alias проц delegate( ук, ук ) сканФн;
alias бул function() ТестерМодулей;
alias бул function(Объект) ОбработчикСборки;
alias проц delegate( Исключение ) ОбработчикИсключения;
alias extern(D) проц delegate() ddel;
alias extern(D) проц delegate(цел, цел) dint;
alias проц delegate() ПередВходом;
alias проц delegate() ПередВыходом;
alias проц delegate(Объект) ДСобыт, DEvent;

extern (D) typedef цел delegate(ук) т_дг, dg_t;
extern (D) typedef цел delegate(ук, ук) т_дг2, dg2_t;

alias проц delegate( ук, ук ) фнСканВсеНити;

/* Тип для возвратного значения динамических массивов.
 */
alias long т_дмВозврат;

struct СМСтат
	{
		т_мера размерПула;        // общий размер пула
		т_мера испРазмер;        // выделено байтов
		т_мера свобБлоки;      // число блоков, помеченных FREE
		т_мера размСпискаСвобБлоков;    // всего памяти в списках освобождения
		т_мера блокиСтр; 
	}
	alias СМСтат GCStats;	
	/**
     * Содержит инфоагрегат о блоке управляемой памяти. Назначение этой
     * структуры заключается в поддержке более эффективного стиля опроса
     * в тех экземплярах, где требуется более подробная информация.
     *
     * основа = Указатель на основание опрашиваемого блока.
     * размер = Размер блока, вычисляемый от основания.
     * атр = Биты установленных на блоке памяти атрибутов.
     */
	 
	struct ИнфОБл
	{
		ук  основа;
		т_мера размер;
		бцел   атр;
	}
	alias ИнфОБл BlkInfo;
	/**
     * Элементы бит-поля, представляющего атрибуты блока памяти. Ими
     * можно манипулировать функциями дайАтр, устАтр, удалиАтр.
     */

	struct Пространство
	{
		ук Низ;
		ук Верх;
	};

	struct Array
	{
		size_t length;
		byte *data;
		ук ptr;
		
		alias length длина;
		alias data данные;
		alias ptr укз;
	}


struct Complex
{
    реал re;
    реал im;
}

	struct aaA
	{
		//aaA *left;
		//aaA *right;
		//hash_t hash;
	aaA *next;
    hash_t hash;
		/* key   */
		/* value */
	}

	struct BB
	{
		aaA*[] b;
		size_t nodes;       // общее число узлов aaA
		TypeInfo keyti;     // TODO: заменить на TypeInfo_AssociativeArray, если  доступно через _aaGet()
		aaA*[4] binit;      // начальное значение с[]
	}

	/* Это тип Ассоциативный Массив, который действительно виден программисту,
	 * хотя он и правда, уплотнён.
	 */

	struct AA
	{
		BB* a;
	}
	
	/+class Амас
	{
	private AA амас;
	
	
	}+/

struct D_CRITICAL_SECTION
{
    D_CRITICAL_SECTION *next;
    //CRITICAL_SECTION cs;
}

alias проц (*ФИНАЛИЗАТОР_СМ)(ук p, бул dummy);


//Функции, экспортируемые рантаймом
extern(C)
{  

    цел printf(усим, ...);
	alias printf эхо; 
	
	проц _d_monitor_create(Object);
	проц _d_monitor_destroy(Object);
	проц _d_monitor_lock(Object);
	int  _d_monitor_unlock(Object);
	//asm
	проц _minit();

//exception
	проц onAssertError( ткст file, т_мера line );
	проц onAssertErrorMsg( ткст file, т_мера line, ткст msg );
	проц onArrayBoundsError( ткст file, т_мера line );
	проц onFinalizeError( ClassInfo info, Исключение ex );
	проц onOutOfMemoryError();
	проц onSwitchError( ткст file, т_мера line );
	проц onUnicodeError( ткст msg, т_мера idx );
	проц onRangeError( string file, т_мера line );
	проц onHiddenFuncError( Object o );
	проц _d_assert( ткст file, uint line );
	static проц _d_assert_msg( ткст msg, ткст file, uint line );
	проц _d_array_bounds( ткст file, uint line );
	проц _d_switch_error( ткст file, uint line );
	проц _d_OutOfMemory();
	
	//ИнфоОтслежИскл контекстТрассировки( ук ptr = null );
	//бул устСледОбр( типСледОбр h );
	бул устПроверОбр( типПроверОбр h );
	
}
	
extern (C)
{
	
//complex.c
	Complex _complex_div(Complex x, Complex y);
	Complex _complex_mul(Complex x, Complex y);
	// long double _complex_abs(Complex z);
	Complex _complex_sqrt(Complex z);

//critical.c
	проц _d_criticalenter(D_CRITICAL_SECTION *dcs);
	проц _d_criticalexit(D_CRITICAL_SECTION *dcs);
	проц _STI_critical_init();
	проц _STD_critical_term();
	
//rt.adi
	char[] _adReverseChar(char[] а);
	шткст _adReverseWchar(шткст а);
	проц[] _adReverse(Array а, size_t szelem);
	char[] _adSortChar(char[] а);
	шткст _adSortWchar(шткст а);
	int _adEq(Array a1, Array a2, TypeInfo ti);
	int _adEq2(Array a1, Array a2, TypeInfo ti);
	int _adCmp(Array a1, Array a2, TypeInfo ti);
	int _adCmp2(Array a1, Array a2, TypeInfo ti);
	int _adCmpChar(Array a1, Array a2);
	
//rt.aaA
	size_t _aaLen(AA aa);
	ук _aaGet(AA* aa, TypeInfo keyti, size_t valuesize, ...);
	ук _aaGetRvalue(AA aa, TypeInfo keyti, size_t valuesize, ...);
	ук _aaIn(AA aa, TypeInfo keyti, ...);
	проц _aaDel(AA aa, TypeInfo keyti, ...);
	т_дмВозврат _aaValues(AA aa, size_t keysize, size_t valuesize);
	ук _aaRehash(AA* paa, TypeInfo keyti);
	проц _aaBalance(AA* paa);
	т_дмВозврат _aaKeys(AA aa, size_t keysize);
	int _aaApply(AA aa, size_t keysize, т_дг дг);
	int _aaApply2(AA aa, size_t keysize, т_дг2 дг);
	BB* _d_assocarrayliteralT(TypeInfo_AssociativeArray ti, size_t length, ...);
	int _aaEqual(TypeInfo_AssociativeArray ti, AA e1, AA e2);
	
//rt.aApply
	int _aApplycd1(char[] aa, т_дг дг);
	int _aApplywd1(шткст aa, т_дг дг);
	int _aApplycw1(char[] aa, т_дг дг);
	int _aApplywc1(шткст aa, т_дг дг);
	int _aApplydc1(юткст aa, т_дг дг);
	int _aApplydw1(юткст aa, т_дг дг);
	int _aApplycd2(char[] aa, т_дг2 дг);
	int _aApplywd2(шткст aa, т_дг2 дг);
	int _aApplycw2(char[] aa, т_дг2 дг);
	int _aApplywc2(шткст aa, т_дг2 дг);
	int _aApplydc2(юткст aa, т_дг2 дг);
	int _aApplydw2(юткст aa, т_дг2 дг);
	
//rt.aApplyR
	int _aApplyRcd1(in char[] aa, т_дг дг);
	int _aApplyRwd1(in шткст aa, т_дг дг);
	int _aApplyRcw1(in char[] aa, т_дг дг);
	int _aApplyRwc1(in шткст aa, т_дг дг);
	int _aApplyRdc1(in юткст aa, т_дг дг);
	int _aApplyRdw1(in юткст aa, т_дг дг);
	int _aApplyRcd2(in char[] aa, т_дг2 дг);
	int _aApplyRwd2(in шткст aa, т_дг2 дг);
	int _aApplyRcw2(in char[] aa, т_дг2 дг);
	int _aApplyRwc2(in шткст aa, т_дг2 дг);
	int _aApplyRdc2(in юткст aa, т_дг2 дг);
	int _aApplyRdw2(in юткст aa, т_дг2 дг);
	
//rt.alloca
	ук __alloca(int nbytes);
	
//rt.arraycast
	проц[] _d_arraycast(size_t tsize, size_t fsize, проц[] а);
	проц[] _d_arraycast_frombit(uint tsize, проц[] а);

//rt.arraycat
	byte[] _d_arraycopy(size_t size, byte[] from, byte[] to);
	
//rt.cast
	Object _d_toObject(ук p);
	Object _d_interface_cast(ук p, ClassInfo c);
	Object _d_dynamic_cast(Object o, ClassInfo c);
	int _d_isbaseof2(ClassInfo oc, ClassInfo c, ref  size_t offset);
	int _d_isbaseof(ClassInfo oc, ClassInfo c);
	ук _d_interface_vtbl(ClassInfo ic, Object o);
	
//rt.lifetime
	Object _d_newclass(ClassInfo ci);
	проц _d_delinterface(ук p);
	проц _d_delclass(Object *p);
	ulong _d_newarrayT(TypeInfo ti, size_t length);
	ulong _d_newarrayiT(TypeInfo ti, size_t length);
	ulong _d_newarraymT(TypeInfo ti, int ndims, ...);
	ulong _d_newarraymiT(TypeInfo ti, int ndims, ...);
	ук  _d_allocmemory(size_t nbytes);
	проц _d_delarray(Array *p);
	проц _d_delmemory(проц  *p);
	проц _d_callfinalizer(ук p);	
	проц ртФинализуй(ук  p, бул det = да);
	extern (C) проц rt_finalize_gc(ук p);
	
	byte[] _d_arraysetlengthT(TypeInfo ti, size_t newlength, Array *p);
	byte[] _d_arraysetlengthiT(TypeInfo ti, size_t newlength, Array *p);
	long _d_arrayappendT(TypeInfo ti, Array *px, byte[] y);
	byte[] _d_arrayappendcT(TypeInfo ti, inout byte[] x, ...);
	byte[] _d_arraycatT(TypeInfo ti, byte[] x, byte[] y);	
	byte[] _d_arraycatnT(TypeInfo ti, uint n, ...);
	ук  _d_arrayliteralT(TypeInfo ti, size_t length, ...);
	long _adDupT(TypeInfo ti, Array а);
		
//rt.hash
	hash_t rt_hash_str(ук bStart,size_t длина, hash_t seed=cast(hash_t)0);
	hash_t rt_hash_block(size_t *bStart,size_t длина, hash_t seed=cast(hash_t)0);
	uint rt_hash_utf8(char[] str, uint seed=0);
	uint rt_hash_utf16(шткст str, uint seed=0);
	uint rt_hash_utf32(юткст str, uint seed=0);
	hash_t rt_hash_combine( hash_t val1, hash_t val2 );
	uint rt_hash_str_neutral32(ук bStart,uint длина, uint seed=0);
	ulong rt_hash_str_neutral64(ук bStart,ulong длина, ulong seed=0);
	uint rt_hash_combine32( uint знач, uint seed );
	ulong rt_hash_combine64( ulong value, ulong level);
	
//rt.qsort
	long _adSort(Array а, TypeInfo ti);
	
//rt.memset
	short *_memset16(short *p, short value, size_t count);
	int *_memset32(int *p, int value, size_t count);
	long *_memset64(long *p, long value, size_t count);
	cdouble *_memset128(cdouble *p, cdouble value, size_t count);
	реал *_memset80(реал *p, реал value, size_t count);
	creal *_memset160(creal *p, creal value, size_t count);
	ук _memsetn(ук p, ук value, int count, size_t sizelem);

//rt.switch
	int _d_switch_string(char[][] table, char[] ca);
	int _d_switch_ustring(шим[][] table, шткст ca);
	int _d_switch_dstring(дим[][] table, юткст ca);
	


//object	
	проц _d_monitorrelease(Object h);
	
	
	проц _d_notify_release(Object o);
	проц _moduleCtor();
	проц _moduleCtor2(ModuleInfo[] mi, int skip);
	проц _moduleDtor();
	проц _moduleUnitTests();
	проц _moduleIndependentCtors();

	
	проц создайМонитор(Объект о);
	проц разрушьМонитор(Объект о) ;
	проц блокируйМонитор(Объект о) ;
	цел разблокируйМонитор(Объект о) ;
	
	проц _d_monitordelete(Object h, бул det);
	проц удалиМонитор(Объект о, бул уд);	
	
	проц _d_monitorenter(Object h);
	проц войдиВМонитор(Объект о);		
	
    проц _d_monitorexit(Object h);
	проц выйдиИзМонитора(Объект о);
	проц _d_monitor_devt(Monitor* m, Object h);
	проц событиеМонитора(Монитор* м, Объект о);	
	проц rt_attachDisposeEvent(Object h, ДСобыт e);
	проц rt_detachDisposeEvent(Object h, ДСобыт e);
	int _fatexit(ук);
	
//runtime
	сим[][] ртПолучиАрги(цел аргчло, сим **аргткст);
	бул рт_вЗадержке();
	бул ртПущен();
	бул ртОстановлен();
	бул ртСтарт(ПередВходом передвхо = пусто, ОбработчикИсключения дг = пусто);
	проц ртСтоп();	
	проц  ртСоздайОбработчикСледа( Следопыт h );
	Исключение.ИнфОСледе ртСоздайКонтекстСледа( ук  ptr );
	проц  ртУстановиОбработчикСборки(ОбработчикСборки h);
	ук ртНизСтэка();
	ук ртВерхСтэка();
	проц ртСканируйСтатДан( сканФн scan );	
	проц _d_callinterfacefinalizer(ук p);
	size_t gc_newCapacity(size_t newlength, size_t size);
	ткст _d_arrayappendcd(inout ткст x, дим c);
	шткст _d_arrayappendwd(inout шткст x, дим c);
	//проц устСовместнПам( убайт буф); 	 
	//убайт получиСовместнПам();
	
	
//thread

	проц thread_init();
	проц thread_attachThis();
	проц thread_detachThis();
	проц thread_joinAll();

	бул thread_needLock();
	проц thread_suspendAll();
	проц thread_resumeAll();
	проц thread_scanAll( фнСканВсеНити scan, ук текВерхСтека = null );
	проц thread_yield();   
	проц thread_sleep(double период);
	проц fiber_entryPoint();
	проц fiber_switchContext( ук* oldp, ук newp );
	
//gc
	
бул смПроверь(ук p);	
бул смУменьши();
бул смДобавьКорень( ук p );
бул смДобавьПространство( ук p, т_мера разм );
бул смДобавьПространство2( ук p, ук разм );
бул смУдалиКорень( ук p );
бул смУдалиПространство( ук p );
т_мера смЁмкость(ук p);
бул смМонитор(ddel начало, dint конец );
бул смСтат();		
СМСтат смДайСтат();		
проц[] смПразместиМас(т_мера члобайт);
проц[] смПереместиМас(ук  p, т_мера члобайт);
бул устИнфОТипе(ИнфОТипе иот, ук  p);
ук  дайУкНаСМ();
бул укНаСМ(ук  p);
бул сбросьУкНаСМ();
бцел смДайАтр( ук  p );
бцел смУстАтр( ук  p, ПАтрБлока а );
бцел смУдалиАтр( ук  p, ПАтрБлока а );
ук  смПразмести( т_мера разм, бцел ba = 0 );
ук  смКразмести( т_мера разм, бцел ba = 0 );
ук  смПеремести( ук  p, т_мера разм, бцел ba = 0 );
т_мера смРасширь( ук p, т_мера mx, т_мера разм );
т_мера смРезервируй( т_мера разм );
бул смОсвободи( ук  p );
ук  смАдрес( ук  p );
т_мера смРазмер( ук  p );
ук  смСоздайСлабУк( Объект к );
бул смУдалиСлабУк( ук  wp );
Объект смДайСлабУк( ук  wp );
ИнфОБл смОпроси( ук  p );
бул смВключи();
бул смОтключи();
бул смСобери();


проц setTypeInfo(TypeInfo ti, ук p);
ук getGCHandle();
проц setGCHandle(ук p);
проц endGCHandle();

проц gc_init();
проц gc_term();
size_t gc_capacity(ук p);
проц gc_minimize();
проц gc_addRoot( ук p );
проц gc_addRange( ук p, size_t разм );
проц gc_removeRoot( ук p );
проц gc_removeRange( ук p );
проц gc_monitor(ddel begin, dint end );
GCStats gc_stats();
проц _d_gc_addrange(проц *pbot, проц *ptop);
проц _d_gc_removerange(проц *pbot);
uint gc_getAttr( ук p );
uint gc_setAttr( ук p, uint а );
uint gc_clrAttr( ук p, uint а );
ук gc_malloc( size_t разм, uint ba = 0 );
ук gc_calloc( size_t разм, uint ba = 0 );
ук gc_realloc( ук p, size_t разм, uint ba = 0 );
size_t gc_extend( ук p, size_t mx, size_t разм );
size_t gc_reserve( size_t разм );
проц gc_free( ук p );
ук gc_addrOf( ук p );
size_t gc_sizeOf( ук p );
ук gc_weakpointerCreate( Object к );
проц gc_weakpointerDestroy( ук wp );
Object gc_weakpointerGet( ук wp );
BlkInfo gc_query( ук p );
проц gc_enable();
проц gc_disable();
проц gc_collect();
проц gc_check(проц *p);
проц gc_addRangeOld( ук  p, ук разм );
	

 ткст[] дайАргиКС();
 }

extern (Windows) ук ДайДескрТекущейНити();
//extern (Windows) проц d_throw(Object *o);

extern (C) //Возвращает массив определённого типа с заданным количеством элементов
{
 ткст симмас(цел к);
 байт[] байтмас(цел к);
 ббайт[] ббайтмас(цел к);
 плав[] плавмас(цел к);
 дво[] двомас(цел к);
 ткст[] ткстмас(цел к);//выдаёт ошибку; причина неясна
 бдол[] бдолмас(цел к);
 дол[] долмас(цел к);
 цел[] целмас(цел к);
 бцел[] бцелмас(цел к);
 крат[] кратмас(цел к);
 бкрат[] бкратмас(цел к);
 
	проц ошибка(ткст сооб, ткст файл = пусто , т_мера строка = 0 );
		
	проц ошибкаПодтверждения(ткст файл, т_мера строка);
	проц ошибкаГраницМассива(ткст файл, т_мера строка);
	проц ошибкаФинализации(ИнфОКлассе инфо, Исключение ис);
	проц ошибкаНехваткиПамяти();
	проц ошибкаПереключателя(ткст файл, т_мера строка);
	проц ошибкаЮникод(ткст сооб, т_мера индкс);
	проц ошибкаДиапазона(ткст файл, т_мера строка);
	проц ошибкаСкрытойФункции(Объект о);
	
	
}

