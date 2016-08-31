module cidrus;
//сиэф = экспортируемая си-функция

alias проц function(ук) _У;

extern(C)
{
alias  проц function() сифунк;
alias проц function(цел) сифунк_Ц;
alias проц function(цел, цел) сифунк_ЦЦ;
alias проц function(цел, цел, цел) сифунк_ЦЦЦ;
alias проц function(цел, цел, цел, цел) сифунк_ЦЦЦЦ;
alias проц function(цел, цел, цел, цел, цел) сифунк_ЦЦЦЦЦ;
alias проц function(сим, цел, цел) сифунк_СЦЦ;
alias проц function(ббайт, цел, цел) сифунк_бБЦЦ;
alias  проц function(ук) сифунк_У;
alias проц function(бцел, цел, цел, цел) сифунк_бЦЦЦЦ; 

alias цел function() сифункЦ; 
alias цел function(сим, цел, цел) сифункЦ_СЦЦ;
alias цел function(ббайт, цел, цел) сифункЦ_бБЦЦ;
alias цел function(цел) сифункЦ_Ц;
alias цел function(цел, цел) сифункЦ_ЦЦ;
alias цел function(цел, цел, цел) сифункЦ_ЦЦЦ;
alias цел function(цел, цел, цел, цел) сифункЦ_ЦЦЦЦ;
alias цел function (ук, бцел, бцел, цел) сифункЦ_УбЦбЦЦ;

alias бцел function() сифункбЦ; 
alias бцел function (ук, бцел, бцел, цел) сифункбЦ_УбЦбЦЦ;
alias  бцел function(ук) сифункбЦ_У;

alias дво  function() сифункД2; 
alias плав  function() сифункП; 
alias ук   function() сифункУ; 
alias байт  function() сифункБ; 
alias ббайт  function() сифункбБ; 
alias сим  function() сифункС; 
alias усим function() сифункуС;
alias шим  function() сифункШ;
alias ушим function() сифункуШ;
alias дол  function() сифункД;
alias бдол  function() сифункбД;

alias бул  function() сифункБ2;
alias бул function(бцел) сифункБ2_бЦ;
//alias extern (C) struct систрукт;
//alias extern (C) class сикласс;
}

const int     _ЧЛОФ     = 60;
extern (C) struct _iobuf
{
align (1):
        char* _ptr;
        int   _cnt;
        char* _base;
        int   _flag;
        int   _file;
        int   _charbuf;
        int   _bufsiz;
        int   __tmpnum;
   
        alias _ptr Ук ;
        alias   _cnt Конт;
        alias _base Ова ;
        alias   _flag Флаг ;
        alias   _file Файл ;
        alias   _charbuf Симбуф;
        alias  _bufsiz  Буфразм ;
        alias  __tmpnum  Времчло ;
	
}
alias _iobuf ФАЙЛ, FILE;
alias ФАЙЛ *фук;
 extern (C) extern ФАЙЛ[_ЧЛОФ] _iob;
 
extern (C) фук дайСтдвхо();
extern (C) фук дайСтдвых();
extern (C) фук дайСтдош();
extern (C) фук дайСтддоп();
extern (C) фук дайСтдпрн();

const фук стдвхо = &_iob[0];
const фук стдвых = &_iob[1];
const фук стдош = &_iob[2];
const фук стддоп = &_iob[3];
const фук стдпрн = &_iob[4];

	alias стдвхо stdin;
	alias стдвых stdout;
	alias стдош stderr;
	alias стддоп stdaux;
	alias стдпрн stdprn;


    const string  _P_tmpdir  = "\\"; // non-standard
    const wstring _wP_tmpdir = "\\"; // non-standard
    const int     L_tmpnam   = _P_tmpdir.length + 12;
	
  extern (C) extern ubyte __fhnd_info[_ЧЛОФ];

	
//Режимы открытия файла функцией откройфл:
const 
{
ткст Ч = "r";
ткст З = "w";
ткст Д = "a";
ткст ЧП = "r+";
ткст ЗП = "w+";
ткст ДП = "a+";

}

extern (C)
{

struct лпреобр
{

    ткст десятичная_точка;
    ткст делит_тысяч;
    ткст группировка;
    ткст цел_валютн_символ;
    ткст символ_валюты;
    ткст мон_десятичная_точка;
    ткст мон_делит_тыс;
    ткст мон_группировка;
    ткст положит_знак;
    ткст отрицат_знак;
    байт  цел_дробн_цифры;
    байт  дробн_цифры;
    байт  p_cs_precedes;
    байт  p_sep_by_space;
    байт  n_cs_precedes;
    байт  n_sep_by_space;
    байт  p_sign_posn;
    байт  n_sign_posn;
    байт  int_p_cs_precedes;
    байт  int_p_sep_by_space;
    байт  int_n_cs_precedes;
    байт  int_n_sep_by_space;
    байт  int_p_sign_posn;
    байт  int_n_sign_posn;
}

struct т_цмаксдел
	{
	
		дол    квот,
					остат;
	}

struct т_фсред
    {
	
        бкрат    статус;
        бкрат    контроль;
        бкрат    округл;
        бкрат[2] резерв;
    }
	
struct т_дели
	{
	
		цел квот,
			остат;
	}


struct т_делиц
	{
	
		цел квот,
			остат;
	}

struct т_делид
	{
	
		дол квот,
			 остат;
	}
	
	
}

    enum
    {
	ФУК_ДОБАВКА	= 0x04,
	ФУК_УСТРВО	= 0x08,
	ФУК_ТЕКСТ	= 0x10,
	ФУК_БАЙТ	= 0x20,
	ФУК_ШИМ	= 0x40,
   
    ВВФБФ   = 0,
    ВВЛБФ   = 0x40,
	ВВНБФ   = 4,
    ВВЧИТ  = 1,	  // non-standard
    ВВЗАП   = 2,	  // non-standard
    ВВМОЙБУФ = 8,	  // non-standard	
    ВВКФ   = 0x10,  // non-standard
    ВВОШ   = 0x20,  // non-standard
    ВВСТРЖ  = 0x40,  // non-standard
    ВВЧЗ    = 0x80,  // non-standard
    ВВТРАН  = 0x100, // non-standard
    ВВПРИЛ   = 0x200, // non-standard
    }

 enum
    {
        РАЗМБУФ       = 0x4000,
        КФ          = -1,//конец файла
        МАКС_ОТКРФ    = 20,
        МАКС_ИМЯФ = 256, // 255 plus NULL
        МАКС_ВРЕМ      = 32767,
        СИС_ОТКР     = 20,	// non-standard
    }

const шим ШКФ = 0xFFFF;

const дво ДВОБЕСК      = дво.infinity;
const дво ПЛАВБЕСК     = плав.infinity;
const дво РЕАЛБЕСК    = реал.infinity;

const СИМБИТ       = 8;
const БАЙТМИН      = байт.min;
const БАЙТМАКС      = байт.max;
const ББАЙТМИН      = ббайт.min;
const СИММИН       = сим.max;
const СИММАКС       = сим.max;
const МБДЛИНМАКС     = 2;
const КРАТМИН       = крат.min;
const КРАТМАКС       = крат.max;
const БКРАТМАКС      = бкрат.max;
const ЦЕЛМИН        = цел.min;
const ЦЕЛМАКС        = цел.max;
const БЦЕЛМАКС       = бцел.max;
const ДОЛМИН      = дол.min;
const ДОЛМАКС      = дол.max;
const БДОЛМАКС     = бдол.max;

const ПЛАВОКРУГЛ			= 1;
const ПЛАВМЕТОДОЦЕНКИ	= 2;
const ПЛАВКОРЕНЬ			= 2;

const ПЛАВЦИФР			= плав.dig;
const ДВОЦИФР			= дво.dig;
const РЕАЛЦИФР			= реал.dig;

const ПЛАВМАНТЦИФР		= плав.mant_dig;
const ДВОМАНТЦИФР		= дво.mant_dig;
const РЕАЛМАНТЦИФР		= реал.mant_dig;

const ПЛАВМИН			= плав.min;
const ДВОМИН			= дво.min;
const РЕАЛМИН			= реал.min;

const ПЛАВМАКС			= плав.max;
const ДВОМАКС			= дво.max;
const РЕАЛМАКС			= реал.max;

const ПЛАВЭПС		= плав.epsilon;
const ДВОЭПС		= дво.epsilon;
const РЕАЛЭПС		= реал.epsilon;

const ПЛАВМИНЭКСП		= плав.min_exp;
const ДВОМИНЭКСП		= дво.min_exp;
const РЕАЛМИНЭКСП		= реал.min_exp;

const ПЛАВМАКСЭКСП		= плав.max_exp;
const ДВОМАКСЭКСП		= дво.max_exp;
const РЕАЛМАКСЭКСП		= реал.max_exp;

const ПЛАВМИН10ЭКСП		= плав.min_10_exp;
const ДВОМИН10ЭКСП		= дво.min_10_exp;
const РЕАЛМИН10ЭКСП	= реал.min_10_exp;

const ПЛАВМАКС10ЭКСП		= плав.max_10_exp;
const ДВОМАКС10ЭКСП		= дво.max_10_exp;
const РЕАЛМАКС10ЭКСП	= реал.max_10_exp;

const плав БЕСКОНЕЧНОСТЬ       = плав.infinity;
const плав Н_Ч            = плав.nan;

const цел ПЗ_ИЛОГБ0        = цел.min;
const цел ПЗ_ИЛОГБНЧ      = цел.min;

const цел МАТОШ       = 1;//математическая ошибка
const цел МАТОШИСКЛ   = 2;
const цел матошобработка = МАТОШ | МАТОШИСКЛ;

const ЛП_СИТИП          = 0;
const ЛП_ЧИСЛО        = 1;
const ЛП_ВРЕМЯ           = 2;
const ЛП_КОЛЛЕЙТ        = 3;
const ЛП_МОНЕТА       = 4;
const ЛП_ВСЕ            = 6;
const ЛП_БУМАГА          = 7;  // non-standard
const ЛП_ИМЯ           = 8;  // non-standard
const ЛП_АДРЕС        = 9;  // non-standard
const ЛП_ТЕЛЕФОН      = 10; // non-standard
const ЛП_МЕРА    = 11; // non-standard
const ЛП_ИДЕНТИФИКАЦИЯ = 12; // non-standard

enum ППозКурсора {
  Уст,
  Тек,
  Кон,   
}

enum ФИскл
{
    Повреждён      = 1,
    Ненорм     = 2, // non-standard
    ДелениеНаНоль    = 4,
    Переполнение     = 8,
    Недополнение    = 0x10,
    Неточность      = 0x20,
    ВсеИскл   = 0x3F,
    КБлиж    = 0,
    Выше       = 0x800,
    Ниже     = 0x400,
    КНулю   = 0xC00,
}

version( Windows )
{
    extern т_фсред _FE_DFL_ENV;   
}



version( Windows )//errno
{
    const ОШНЕДОП              = 1;        // Недопустимая операция
    const ОШНЕСУЩ             = 2;        // Файл или каталог не найден
    const ОШПОИСК              = 3;        // Процес не найден
    const ОШПРЕРВ              = 4;        // Прерванный системный вызов
    const ОШВВ                = 5;        // Ошибка ввода-вывода
    const ОШНЕТУСТРВА              = 6;        //Устройство или адрес не найдены
    const ОШАРГСЛИШБ              = 7;        // Слишком много аргументов
    const ОШНЕИСП            = 8;        // Exec format error
    const ОШНЕВФАЙЛ              = 9;        // Неправильный номер файла
    const ОШНЕТОТПРЫСК             = 10;       // Отсутствуют дочерние процессы
    const ОШПОВТОР             = 11;       // Попробовать снова
    const ОШНЕТПАМ             = 12;       // Вне памяти
    const ОШДОСТУП             = 13;       // Доступ запрещён
    const ОШНЕТОТАДР             = 14;       // Неправильный адрес
    const ОШЗАНЯТ              = 16;       // Устройство или ресурс заняты
    const ОШФЕСТЬ             = 17;       // Файл уже есть
    const ОШКРОССУСТРССЫЛ              = 18;       // Ссылка на другое устройство
    const ОШНЕТУСТР             = 19;       // Устройство не обнаружено
    const ОШНЕПАП            = 20;       // Это не папка
    const ОШПАП             = 21;       // Это папка
    const ОШИНВАЛАРГ             = 22;       // Неверный аргумент
    const ОШПЕРЕПФТ             = 23;       // Переполнение файловой таблицы
    const ОШМНОГОТКРФ             = 24;       // Слишком много открытых файлов
    const ОШНЕТП             = 25;       // Not a typewriter
    const ОШФСЛИШБ              = 27;       // Файл слишком громоздкий
    const ОШНЕТМЕСТ             = 28;       // На устойстве закончилось свободное пространство
    const ОШПЕРЕМЕСТ             = 29;       // Недопустимое перемещение
    const ОШФСТЧ              = 30;       // Файловая система только для чтения
    const ОШСЛИШМССЫЛ             = 31;       // Слишком много ссылок
    const ОШПАЙП              = 32;       // Broken pipe
    const ОШДОМ               = 33;       // Математический аргумент вне домена или функции
    const ОШДИАП             = 34;       // Математический результат невозможно представить
    const ОШДЕДЛОК            = 36;       // Resource deadlock would occur
    const ОШСЛИШБФИМЯ       = 38;       // Слишком длинное название файла
    const ОШНЕТЗАМЗАП             = 39;       // No record locks available
    const ОШФУНКНЕРЕАЛИЗ             = 40;       // Функция не реализована
    const ОШПАПНЕПУСТ          = 41;       // Папка не пуста
    const ОШБАЙТПОСЛ             = 42;       // Недопустимая байтовая 
	
	
	const EPERM             = 1;        // Operation not permitted
    const ENOENT            = 2;        // No such файл or directory
    const ESRCH             = 3;        // No such process
    const EINTR             = 4;        // Interrupted system вызов
    const EIO               = 5;        // I/O ошибка
    const ENXIO             = 6;        // No such устройство or адрес
    const E2BIG             = 7;        // Аргумент список too дол
    const ENOEXEC           = 8;        // Exec форматируй ошибка
    const EBADF             = 9;        // Bad файл number
    const ECHILD            = 10;       // No ветвь processes
    const EAGAIN            = 11;       // Try again
    const ENOMEM            = 12;       // Out of память
    const EACCES            = 13;       // Permission denied
    const EFAULT            = 14;       // Bad адрес
    const EBUSY             = 16;       // Устройство or resource busy
    const EEXIST            = 17;       // Файл есть_ли
    const EXDEV             = 18;       // Cross-устройство link
    const ENODEV            = 19;       // No such устройство
    const ENOTDIR           = 20;       // Not a directory
    const EISDIR            = 21;       // Is a directory
    const EINVAL            = 22;       // Invalопр аргумент
    const ENFILE            = 23;       // Файл table перебор
    const EMFILE            = 24;       // Too many открой файлы
    const ENOTTY            = 25;       // Not a typewriter
    const EFBIG             = 27;       // Файл too large
    const ENOSPC            = 28;       // No пространство left on устройство
    const ESPIPE            = 29;       // Illegal сместись
    const EROFS             = 30;       // Чтен-only файл system
    const EMLINK            = 31;       // Too many линки
    const EPIPE             = 32;       // Broken pipe
    const EDOM              = 33;       // Math аргумент out of domain of func
    const ERANGE            = 34;       // Math результат not representable
    const EDEADLK           = 36;       // Resource deadlock would occur
    const ENAMETOOLONG      = 38;       // Файл имя too дол
    const ENOLCK            = 39;       // No record locks available
    const ENOSYS            = 40;       // Function not implemented
    const ENOTEMPTY         = 41;       // Directory not пустой
    const EILSEQ            = 42;       // Illegal байт sequence
    const EDEADLOCK         = EDEADLK;

    
}

private alias проц function(цел) т_сигфн, sigfn_t;

const СИГОШ    = cast(т_сигфн) -1;
const СИГДФЛ    = cast(т_сигфн) 0;
const СИГИГН    = cast(т_сигфн) 1;

    // стандартные сигналы Си
    const СИГАБОРТ    = 22; // Ненормальное закрытие программы
    const СИГОПЗ     = 8;  // Ошибка с плавающей запятой
    const СИГИЛЛ     = 4;  // Недопустимая инструкция оборудования/-ю
    const СИГПРЕРВ     = 2;  // Terminal interrupt character
    const СИГСЕГВ    = 11; // Invalid memory reference
    const СИГТЕРМ    = 15; // Termination


const УДАЧНЫЙ_ВЫХОД = 0;
const НЕУДАЧНЫЙ_ВЫХОД = 1;
const СЛУЧ_МАКС     = 32767;
const МБ_ТЕК_МАКС   = 1;

private
{
    template типируй(T)
    {
        T типируй( T val ) { return val; }
    }
}

const int8_t   ЦЕЛ8_МИН  = int8_t.min;
const int8_t   ЦЕЛ8_МАКС  = int8_t.max;
const int16_t  ЦЕЛ16_МИН = int16_t.min;
const int16_t  ЦЕЛ16_МАКС = int16_t.max;
const int32_t  ЦЕЛ32_МИН = int32_t.min;
const int32_t  ЦЕЛ32_МАКС = int32_t.max;
const int64_t  ЦЕЛ64_МИН = int64_t.min;
const int64_t  ЦЕЛ64_МАКС = int64_t.max;

const uint8_t  БЦЕЛ8_МАКС  = uint8_t.max;
const uint16_t БЦЕЛ16_МАКС = uint16_t.max;
const uint32_t БЦЕЛ32_МАКС = uint32_t.max;
const uint64_t БЦЕЛ64_МАКС = uint64_t.max;

const int_least8_t    ЦЕЛ_МЕН8_МИН   = int_least8_t.min;
const int_least8_t    ЦЕЛ_МЕН8_МАКС   = int_least8_t.max;
const int_least16_t   ЦЕЛ_МЕН16_МИН  = int_least16_t.min;
const int_least16_t   ЦЕЛ_МЕН16_МАКС  = int_least16_t.max;
const int_least32_t   ЦЕЛ_МЕН32_МИН  = int_least32_t.min;
const int_least32_t   ЦЕЛ_МЕН32_МАКС  = int_least32_t.max;
const int_least64_t   ЦЕЛ_МЕН64_МИН  = int_least64_t.min;
const int_least64_t   ЦЕЛ_МЕН64_МАКС  = int_least64_t.max;

const uint_least8_t   БЦЕЛ_МЕН8_МАКС  = uint_least8_t.max;
const uint_least16_t  БЦЕЛ_МЕН16_МАКС = uint_least16_t.max;
const uint_least32_t  БЦЕЛ_МЕН32_МАКС = uint_least32_t.max;
const uint_least64_t  БЦЕЛ_МЕН64_МАКС = uint_least64_t.max;

const int_fast8_t   ЦЕЛ_БЫСТР8_МИН   = int_fast8_t.min;
const int_fast8_t   ЦЕЛ_БЫСТР8_МАКС   = int_fast8_t.max;
const int_fast16_t  ЦЕЛ_БЫСТР16_МИН  = int_fast16_t.min;
const int_fast16_t  ЦЕЛ_БЫСТР16_МАКС  = int_fast16_t.max;
const int_fast32_t  ЦЕЛ_БЫСТР32_МИН  = int_fast32_t.min;
const int_fast32_t  ЦЕЛ_БЫСТР32_МАКС  = int_fast32_t.max;
const int_fast64_t  ЦЕЛ_БЫСТР64_МИН  = int_fast64_t.min;
const int_fast64_t  ЦЕЛ_БЫСТР64_МАКС  = int_fast64_t.max;

const uint_fast8_t  БЦЕЛ_БЫСТР8_МАКС  = uint_fast8_t.max;
const uint_fast16_t БЦЕЛ_БЫСТР16_МАКС = uint_fast16_t.max;
const uint_fast32_t БЦЕЛ_БЫСТР32_МАКС = uint_fast32_t.max;
const uint_fast64_t БЦЕЛ_БЫСТР64_МАКС = uint_fast64_t.max;

const intptr_t  ЦЕЛУК_МИН  = intptr_t.min;
const intptr_t  ЦЕЛУК_МАКС  = intptr_t.max;

const uintptr_t БЦЕЛУК_МИН = uintptr_t.min;
const uintptr_t БЦЕЛУК_МАКС = uintptr_t.max;

const intmax_t  ЦЕЛМАКС_МИН  = intmax_t.min;
const intmax_t  ЦЕЛМАКС_МАКС  = intmax_t.max;

const uintmax_t БЦЕЛМАКС_МАКС = uintmax_t.max;

const ptrdiff_t ДЕЛЬТАУК_МИН = ptrdiff_t.min;
const ptrdiff_t ДЕЛЬТАУК_МАКС = ptrdiff_t.max;

const sig_atomic_t СИГАТОМ_МИН = sig_atomic_t.min;
const sig_atomic_t СИГАТОМ_МАКС = sig_atomic_t.max;

const size_t  МЕРА_МАКС  = size_t.max;

const wchar_t ШИМ_МИН = wchar_t.min;
const wchar_t ШИМ_МАКС = wchar_t.max;

const wint_t  ВИНТ_МИН  = wint_t.min;
const wint_t  ВИНТ_МАКС  = wint_t.max;

alias типируй!(int8_t)  ЦЕЛ8_С;
alias типируй!(int16_t) ЦЕЛ16_С;
alias типируй!(int32_t) ЦЕЛ32_С;
alias типируй!(int64_t) ЦЕЛ64_С;

alias типируй!(uint8_t)  БЦЕЛ8_С;
alias типируй!(uint16_t) БЦЕЛ16_С;
alias типируй!(uint32_t) БЦЕЛ32_С;
alias типируй!(uint64_t) БЦЕЛ64_С;

alias типируй!(intmax_t)  ЦЕЛМАКС_С;
alias типируй!(uintmax_t) БЦЕЛМАКС_С;

extern(D)
{
    //цел fpclassify(реал-floating x);
    цел птклассифицируй(плав x)     ;
    цел птклассифицируй(дво x)    ;
    цел птклассифицируй(реал x);

    //цел isfinite(реал-floating x);
    цел конечен_ли(плав x)       ;
    цел конечен_ли(дво x)      ;
    цел конечен_ли(реал x)        ;

    //цел isinf(реал-floating x);
    цел беск_ли(плав x)          ;
    цел беск_ли(дво x)         ;
    цел беск_ли(реал x)           ;

    //цел isnan(реал-floating x);
    цел нечисло_ли(плав x)          ;
    цел нечисло_ли(дво x)         ;
    цел нечисло_ли(реал x)           ;

    //цел isnormal(реал-floating x);
    цел нормаль_ли(плав x)       ;
    цел нормаль_ли(дво x)      ;
    цел нормаль_ли(реал x)        ;

    //цел signbit(реал-floating x);
    цел знакбит(плав x)     ;
    цел знакбит(дво x)    ;
    цел знакбит(реал x);
	
	    //цел isgreater(реал-floating x, реал-floating y);
    цел больше_ли(плав x, плав y)        ;
    цел больше_ли(дво x, дво y)      ;
    цел больше_ли(реал x, реал y)          ;

    //цел большеравны_ли(реал-floating x, реал-floating y);
    цел большеравен_ли(плав x, плав y)   ;
    цел большеравен_ли(дво x, дво y) ;
    цел большеравен_ли(реал x, реал y)     ;

    //цел isless(реал-floating x, реал-floating y);
    цел меньше_ли(плав x, плав y)           ;
    цел меньше_ли(дво x, дво y)         ;
    цел меньше_ли(реал x, реал y)             ;

    //цел меньше_лиequal(реал-floating x, реал-floating y);
    цел меньшеравен_ли(плав x, плав y)      ;
    цел меньшеравен_ли(дво x, дво y)    ;
    цел меньшеравен_ли(реал x, реал y)        ;

    //цел меньше_лиgreater(реал-floating x, реал-floating y);
    цел меньшебольше_ли(плав x, плав y)    ;
    цел меньшебольше_ли(дво x, дво y)  ;
    цел меньшебольше_ли(реал x, реал y)      ;

    //цел isunordered(реал-floating x, реал-floating y);
    цел беспорядочны_ли(плав x, плав y)      ;
    цел беспорядочны_ли(дво x, дво y)    ;
    цел беспорядочны_ли(реал x, реал y)        ;


    дво  акос(дво x);
    плав   акосп(плав x);
    реал    акосд(реал x);

    дво  асин(дво x);
    плав   асинп(плав x);
    реал    асинд(реал x);

    дво  атан(дво x);
    плав   атанп(плав x);
    реал    атанд(реал x);

    дво  атан2(дво y, дво x);
    плав   атан2п(плав y, плав x);
    реал    атан2д(реал y, реал x);

    дво  кос(дво x);
    плав   косп(плав x);
    реал    косд(реал x);

    дво  син(дво x);
    плав   синп(плав x);
    реал    синд(реал x);

    дво  тан(дво x);
    плав   танп(плав x);
    реал    танд(реал x);

    дво  акосг(дво x);
    плав   акосгп(плав x);
    реал    акосгд(реал x);

    дво  асинг(дво x);
    плав   асингп(плав x);
    реал    асингд(реал x);

    дво  атанг(дво x);
    плав   атангп(плав x);
    реал    атангд(реал x);

    дво  косг(дво x);
    плав   косгп(плав x);
    реал    косгд(реал x);

    дво  синг(дво x);
    плав   сингп(плав x);
    реал    сингд(реал x);

    дво  танг(дво x);
    плав   тангп(плав x);
    реал    тангд(реал x);

    дво  эксп(дво x);
    плав   экспп(плав x);
    реал    экспд(реал x);

    дво  эксп2(дво x);
    плав   эксп2п(плав x);
    реал    эксп2д(реал x);

    дво  экспм1(дво x);
    плав   экспм1п(плав x);
    реал   экспм1д(реал x);

    дво  фрэксп(дво value, цел* exp);
    плав   фрэкспп(плав value, цел* exp);
    реал    фрэкспд(реал value, цел* exp);

    цел     илогб(дво x);
    цел     илогбп(плав x);
    цел     илогбд(реал x);
/*
    дво  ldexp(дво x, цел exp);
    плав   ldexpf(плав x, цел exp);
    реал    ldexpl(реал x, цел exp);
*/
    дво  лог(дво x);
    плав   логп(плав x);
    реал    логд(реал x);

    дво  лог10(дво x);
    плав   лог10п(плав x);
    реал    лог10д(реал x);

    дво  лог1п(дво x);
    плав   лог1пп(плав x);
    реал    лог1пд(реал x);

    дво  лог2(дво x);
    плав   лог2п(плав x);
    реал    лог2д(реал x);

    дво  логб(дво x);
    плав   логбп(плав x);
    реал    логбд(реал x);

    дво  модф(дво значение, дво* цук);
    плав   модфп(плав значение, плав* цук);
    реал    модфд(реал значение, реал *цук);
/*
    дво  scalbn(дво x, цел n);
    плав   scalbnf(плав x, цел n);
    реал    scalbnl(реал x, цел n);

    дво  scalbln(дво x, цел n);
    плав   scalblnf(плав x, цел n);
    реал    scalblnl(реал x, цел n);
*/
    дво  кубкор(дво x);
    плав   кубкорп(плав x);
    реал    кубкорд(реал x);

    дво  фабс(дво x);
    плав   фабсп(плав x);
    реал    фабсд(реал x);

    дво  гипот(дво x, дво y);
    плав   гипотп(плав x, плав y);
    реал    гипотд(реал x, реал y);

    дво  степ(дво x, дво y);
    плав   степп(плав x, плав y);
    реал    степд(реал x, реал y);

    дво  квкор(дво x);
    плав   квкорп(плав x);
    реал    квкорд(реал x);

    дво  фцош(дво x);
    плав   фцошп(плав x);
    реал    фцошд(реал x);

    дво  фцошк(дво x);
    плав   фцошкп(плав x);
    реал    фцошкд(реал x);

    дво  лгамма(дво x);
    плав   лгаммап(плав x);
    реал    лгаммад(реал x);

    дво  тгамма(дво x);
    плав   тгаммап(плав x);
    реал   тгаммад(реал x);

    дво  вокругли(дво x);
    плав   вокруглип(плав x);
    реал    вокруглид(реал x);

    дво  нокругли(дво x);
    плав   нокруглип(плав x);
    реал    нокруглид(реал x);

    дво  ближцел(дво x);
    плав   ближцелп(плав x);
    реал    ближцелд(реал x);

    дво  ринт(дво x);
    плав   ринтп(плав x);
    реал    ринтд(реал x);
/*
    цел  lrint(дво x);
    цел  lrintf(плав x);
    цел  lrintl(реал x);

    дол    llrint(дво x);
    дол    llrintf(плав x);
    дол    llrintl(реал x);
*/
    дво  округли(дво x);
    плав   округлип(плав x);
    реал    округлид(реал x);
/*
    цел  lround(дво x);
    цел  lroundf(плав x);
    цел  lroundl(реал x);

    дол    llround(дво x);
    дол    llroundf(плав x);
    дол    llroundl(реал x);

    дво  trunc(дво x);
    плав   truncf(плав x);
    реал    truncl(реал x);

    дво  fmod(дво x, дво y);
    плав   fmodf(плав x, плав y);
    реал    fmodl(реал x, реал y);
*/
    дво  остаток(дво x, дво y);
    плав   остатокп(плав x, плав y);
    реал    остатокд(реал x, реал y);
/*
    дво  remquo(дво x, дво y, цел* quo);
    плав   remquof(плав x, плав y, цел* quo);
    реал    remquol(реал x, реал y, цел* quo);
*/
    дво  копируйзнак(дво x, дво y);
    плав   копируйзнакп(плав x, плав y);
    реал    копируйзнакд(реал x, реал y);

    дво  нечисло(ткст tangp);
    плав   нечислоп(ткст tangp);
    реал    нечислод(ткст tangp);

    дво  следза(дво x, дво y);
    плав   следзап(плав x, плав y);
    //реал    следзад(реал x, реал y);

    //дво  следк(дво x, реал y);
    //плав   следкп(плав x, реал y);
    //реал    следкд(реал x, реал y);
/*
    дво  fdim(дво x, дво y);
    плав   fdimf(плав x, плав y);
    реал    fdiml(реал x, реал y);

    дво  fmax(дво x, дво y);
    плав   fmaxf(плав x, плав y);
    реал    fmaxl(реал x, реал y);

    дво  fmin(дво x, дво y);
    плав   fminf(плав x, плав y);
    реал    fminl(реал x, реал y);

    дво  fma(дво x, дво y, дво z);
    плав   fmaf(плав x, плав y, плав z);
    реал    fmal(реал x, реал y, реал z);*/

}

extern (D)
  {
    проц перемотай(фук поток);
    проц сбросьош(фук поток);
    цел  конфл(фук поток);
    цел  ошфл(фук поток);
  }
  
extern (C):

/*проц перемотай(фук поток);
проц удалиош(фук  поток);
цел кфф(фук поток);
цел ошибф(фук поток);*/

цел удали(in ткст фимя);
//alias удали remove;

цел переименуй(in ткст из, in ткст в);
//alias переименуй rename;

фук времфл();
//alias времфл tmpfile;

ткст времим(ткст s);
//alias времим tmpnam;

цел   закройфл(фук поток);
//alias закройфл fclose;

цел   слейфл(фук поток);
//alias слейфл fflush;

фук откройфл(in ткст фимя, in ткст режим);
//alias откройфл fopen;

фук переоткройфл(in ткст фимя, in ткст режим, фук поток);
//alias переоткройфл freopen;

проц устбуффл(фук поток, ткст буф);
//alias устбуф setbuf;

цел  уствбуф(фук поток, ткст буф, цел режим, т_мера размер);
//alias уствбуф setvbuf;

цел вфвыводф(фук поток, in ткст формат, спис_ва арг);
//alias вфвыводф vfprintf;

цел вфсканф(фук поток, in ткст формат, спис_ва арг);
//alias вфсканф vfscanf;

цел всвыводф(ткст s, in ткст формат, спис_ва арг);
//alias всвыводф vsprintf;

цел вссканф(in ткст s, in ткст формат, спис_ва арг);
//alias вссканф vsscanf;

цел ввыводф(in ткст формат, спис_ва арг);
//alias ввыводф vprinf;

цел всканф(in ткст формат, спис_ва арг);
//alias всканф vscanf;

цел берисфл(фук поток);
//alias берисфл fgetc;

цел вставьсфл(цел c, фук поток);
//alias вставьсфл fputc;

ткст дайтфл(ткст s, цел n, фук поток);
//alias дайтфл  fgets;

цел   вставьтфл(in ткст s, фук поток);
//alias вставьтфл fputs;

ткст дайт(ткст s);
//alias дайт gets;

цел   вставьт(in ткст s);
//alias вставьт puts;

цел отдайс(цел c, фук поток);
//alias отдайс ungetc;

т_мера читайфл(ук указат, т_мера размер, т_мера nmemb, фук поток);
//alias читайфл fread;

т_мера пишифл(in ук указат, т_мера размер, т_мера nmemb, фук поток);
//alias пишифл fwrite;

цел дайпозфл(фук поток, цел * поз);
//alias дайпозфл fgetpos;

цел устпозфл(фук поток, in цел* поз);
//alias устпозфл fsetpos;

цел    сместисьфл(фук поток, цел смещение, цел куда);
//alias сместисьфл fseek;

цел скажифл(фук поток);
//alias скажифл ftell;

цел   вснвыводф(ткст s, т_мера n, in ткст формат, спис_ва арг);
//alias вснвыводф _vsprintf;

проц укошиб(in ткст s);
//alias укошиб perror;

//////////////////////////////////////////

т_сигфн сигнал(цел сиг, т_сигфн функ);
//alias сигнал signal;

цел     влеки(цел сиг);
//alias влеки raise;

кдво какос(кдво z);
кплав  какосп(кплав z);
креал   какосд(креал z);

кдво касин(кдво z);
кплав  касинп(кплав z);
креал   касинд(креал z);

кдво катан(кдво z);
кплав  катанп(кплав z);
креал   катанд(креал z);

кдво ккос(кдво z);
кплав  ккосп(кплав z);
креал   ккосд(креал z);

кдво ксин(кдво z);
кплав  ксинп(кплав z);
креал   ксинд(креал z);

кдво ктан(кдво z);
кплав  ктанп(кплав z);
креал   ктанд(креал z);

кдво какосг(кдво z);
кплав  какосгп(кплав z);
креал   какосгд(креал z);

кдво касинг(кдво z);
кплав  касингп(кплав z);
креал   касингд(креал z);

кдво катанг(кдво z);
кплав  катангп(кплав z);
креал   катангд(креал z);

кдво ккосг(кдво z);
кплав  ккосгп(кплав z);
креал   ккосгд(креал z);

кдво ксинг(кдво z);
кплав  ксингп(кплав z);
креал   ксингд(креал z);

кдво ктанг(кдво z);
кплав  ктангп(кплав z);
креал   ктангд(креал z);

кдво кэксп(кдво z);
кплав  кэкспп(кплав z);
креал   кэкспд(креал z);

кдво клог(кдво z);
кплав  клогп(кплав z);
креал   клогд(креал z);

дво кабс(кдво z);
плав  кабсп(кплав z);
реал  кабсд(креал z);

кдво кстеп(кдво x, кдво y);
кплав  кстепп(кплав x, кплав y);
креал   кстепд(креал x, креал y);

кдво кквкор(кдво z);
кплав  кквкорп(кплав z);
креал   кквкорд(креал z);

 дво карг(кдво z);
 плав  каргп(кплав z);
 реал  каргд(креал z);

// дво квообр(кдво z);
 //плав  квообрп(кплав z);
 //реал  квообрд(креал z);

//кдво конъюнк(кдво z);
//кплав  конъюнкп(кплав z);
//креал   конъюнкд(креал z);

кдво кпроекц(кдво z);
кплав  кпроекцп(кплав z);
креал   кпроекцд(креал z);

 //дво креал(кдво z);
 //плав  креалп(кплав z);
 //реал  креалд(креал z);
 
 
цел числобукв_ли(цел c);
//alias числобукв_ли isalnum;

цел буква_ли(цел c);
//alias буква_ли isalpha;

цел пробел_ли(цел c);
//alias пробел_ли isblank;

цел управ_ли(цел c);
//alias управ_ли iscntrl;

цел цифра_ли(цел c);
//alias цифра_ли isdigit;

цел граф_ли(цел c);
//alias граф_ли isgraph;

цел проп_ли(цел c);
//alias проп_ли islower;

цел печат_ли(цел c);
//alias печат_ли isprint;

цел пункт_ли(цел c);
//alias пункт_ли ispunct;

цел межбукв_ли(цел c);
//alias межбукв_ли isspace;

цел заг_ли(цел c);
//alias заг_ли isupper;

цел цифраикс_ли(цел c);
//alias цифраикс_ли isxdigit;

цел впроп(цел c);
//alias впроп tolower;

цел взаг(цел c);
//alias взаг toupper;


цел числобуквш_ли(шим c);
//alias числобуквш_ли iswalnum;

цел букваш_ли(шим c);
//alias букваш_ли iswalpha;

//цел пробелш_ли(шим c);
////alias пробелш_ли iswblank;

цел управш_ли(шим c);
//alias управш_ли iswcntrl;

цел цифраш_ли(шим c);
//alias цифраш_ли iswdigit;

цел графш_ли(шим c);
//alias графш_ли iswgraph;

цел пропш_ли(шим c);
//alias пропш_ли iswlower;

цел печатш_ли(шим c);
//alias печатш_ли iswprint;

цел пунктш_ли(шим c);
//alias пунктш_ли iswpunct;

цел межбуквш_ли(шим c);
//alias межбуквш_ли iswspace;

цел загш_ли(шим c);
//alias загш_ли iswupper;

цел цифраиксш_ли(шим c);
//alias цифраиксш_ли iswxdigit;

цел впропш(шим c);
//alias впропш towlower;

цел взагш(шим c);
//alias взагш towupper;

//шим    втрансш(шим ш, шим опис);
//alias втрансш towctrans;

//шим трансш( in ткст0 свойство);
//alias трансш wctrans;

цел дайНомош();
//alias дайНомош getErrno;

цел устНомош(цел n);
//alias устНомош setErrno;

проц влекиисклфе(цел исклы);
//alias влекиисклфе feraiseexcept;

проц сотриисклфе(цел исклы);
//alias сотриисклфе feclearexcept;

цел тестисклфе(цел исклы);
//alias тестисклфе fetestexcept;

цел задержиисклфе(т_фсред* средп);
//alias задержиисклфе feholdexcept;

проц дайфлагисклфе(цел* флагп, цел исклы);
//alias дайфлагисклфе fegetexceptflag;

проц устфлагисклфе(in цел* флагп, цел исклы);
//alias устфлагисклфе fesetexceptglag;

цел дайкругфе();
//alias дайкругфе fegetround;

цел усткругфе(цел круг);
//alias усткругфе fesetround;

проц дайсредфе(т_фсред* средп);
//alias дайсредфе fegetenv;

проц устсредфе(in т_фсред* средп);
//alias устсредфе fesetenv;

проц обновисредфе(in т_фсред* средп);
//alias обновисредфе feupdateenv;

дол  цмаксабс(дол j);
//alias цмаксабс imaxabs;

т_цмаксдел цмаксдел(дол число, дол делитель);
//alias цмаксдел imaxdiv;

дол  ткствмаксц(in ткст чук, ткст* конук, цел основа);
//alias ткствмаксц strtoimax;

бдол ткствбмакс(in ткст чук, ткст* конук, цел основа);
//alias ткствбмакс strtoumax;

дол  шимвцмакс(in шткст чук, шткст* конук, цел основа);
//alias шимвцмакс wcstoimax;

бдол шимвбмакс(in шткст чук, шткст* конук, цел основа);
//alias шимвбмакс wcstoumax;

ткст  устлокаль(цел категория, in ткст локаль);
//alias устлокаль setlocale;

лпреобр* преобрлокаль();
//alias преобрлокаль localeconv;

    бцел __птклассифицируй_п(плав x);
    бцел __птклассифицируй_д(дво x);
    бцел __птклассифицируй_дд(реал x);

проц _си_выход();
//alias _си_выход _c_exit;

проц _сивыход();
//alias _сивыход _cexit;

проц _выход(цел x);
//alias _выход _exit;

проц _аборт();
//alias _аборт _abort;

проц _деструкт();
//alias _деструкт _dodtors;

цел дайпид();
//alias дайпид getpid;

проц    аборт();
//alias аборт abort;

проц    выход(цел статус);
//alias выход exit;

цел     навыходе(проц function() функц);
//alias навыходе atexit;

проц    _Выход(цел статус);
//alias _Выход _Exit;

дво  алфнапз(in ткст укнач);
//alias алфнапз atof;
 
цел     алфнац(in ткст укнач);
//alias алфнац atoi;

цел алфнадл(in ткст укнач);
//alias алфнадл atol;

дол    алфнадлдл(in ткст укнач);
//alias алфнадлдл atoll;

дво  стрнад(in ткст укнач, ткст* укнакон);
//alias стрнад strtod;

плав   стрнапз(in ткст укнач, ткст* укнакон);
//alias стрнапз strtof;

реал    стрнадлд(in ткст укнач, ткст* укнакон);
//alias стрнадлд strtold;

цел  стрнадл(in ткст укнач, ткст* укнакон, цел ова);
//alias стрнадл strtol;

дол    стрнадлдл(in ткст укнач, ткст* укнакон, цел ова);
//alias стрнадлдл strtoll;

бцел стрнабдл(in ткст укнач, ткст* укнакон, цел ова);
//alias стрнабдл strtoul;

бдол   стрнабдлдл(in ткст укнач, ткст* укнакон, цел ова);
//alias стрнабдлдл strtoull;

цел     случ();
//alias случ rand;

проц    сслуч(бцел семя);
//alias сслуч srand;

ук   празмести(т_мера разм);
//alias празмести malloc;

ук   кразмести(т_мера члочленов, т_мера разм);
//alias кразмести calloc;

ук   перемести(ук указ, т_мера разм);
//alias перемести realloc;

проц    освободи(ук указ);
//alias освободи free;

ткст   дайсреду(in ткст имя);
//alias дайсреду getenv;

цел     система(in ткст текст);
//alias система system;

ук   бпоиск(in ук key, in ук ова, т_мера члочленов, т_мера разм, цел function(in ук, in ук) compar);
//alias бпоиск bsearch;

проц    бсорт(ук ова, т_мера члочленов, т_мера разм, цел function(in ук, in ук) compar);
//alias бсорт qsort;

цел     абс(цел j);
//alias абс abs;

цел  абсц(цел j);
//alias абсц labs;

дол    абсд(дол j);
//alias абсд llabs;

т_дели   дели(цел число, цел делитель);
//alias дели div;

т_делиц  делиц(цел число, цел делитель);
//alias делиц ldiv;

т_делид делид(дол число, дол делитель);
//alias делид lldiv;


цел     мбдлин(in ткст s, т_мера n);
//alias мбдлин mblen;

цел     мбнашк(шткст pwc, in ткст s, т_мера n);
//alias мбнашк mbtowc;

цел     шкнамб(ткст s, шим wc);
//alias шкнамб wctomb;

т_мера  мбтнашкт(шткст pwcs, in ткст s, т_мера n);
//alias мбтнашкт mbstowcs;

т_мера  шктнамбт(ткст s, in шткст pwcs, т_мера n);
//alias шктнамбт wcstombs;

цел поместсфл(цел ц, фук  ф);
цел поместшфл(цел ц, фук  ф);
цел извлсфл(фук  ф);
цел извлшфл(фук  ф);
цел блокфл(фук ф);
проц разблокфл(фук  ф);

цел ширфл(фук  поток, цел реж);
//alias ширфл fwide;

ук разместа(т_мера разм);
//alias разместа alloca;
    
цел сравбуфлюб(ткст0 буф1, ткст0 буф2, т_мера члоб);
alias  сравбуфлюб сравни_буферы_люб;//, memicmp;

ук ищисим(in ук строка, цел сим, т_мера члобайт);
alias  ищисим ищи_символ;//, memchr;

цел сравбуф(in ук буф1, in ук буф2, т_мера члобайт);
alias сравбуф сравни_буферы ;//, memcmp;

ук копирбуф(ук приёмник, in ук исток, т_мера члобайт);
alias копирбуф копируй_буфер;//, memcpy;

ук перембуф(ук куда, in ук откуда, т_мера сколько);
alias  перембуф перемести_буфер;//, memmove;

ук устбуф(ук где, цел сим, т_мера члосим);
alias устбуф установи_буфер;//, memset;

ткст0 копиртекс(ткст0 куда, in ткст0 откуда);
alias копиртекс копируй_символы;//, strcpy;

ткст0 копирчтекс(ткст0 куда, in ткст0 откуда, т_мера члосим);
alias копирчтекс копируй_чло_сим ;//, strncpy;

ткст0 сотекс(ткст0 текст1, in ткст0 текст_плюс);
alias сотекс соедини_тексты ;//, strcat;

ткст0 сочтекс(ткст0 ткст1, in ткст0 ткст2, т_мера члосим);
alias сочтекс соедини_чло_сим ;//, strncat;

цел сравтекс(in ткст0 текст1, in ткст0 текст2);
alias сравтекс сравни_тексты;//, strcmp;

цел кодстрсравнитекс( in ткст0 текст1, in ткст0 текст2);
alias кодстрсравнитекс кссравтекс;//, strcoll;

цел сравчтекс(in ткст0 текст1, in ткст0 текст2, т_мера члосим);
alias  сравчтекс сравни_чло_сим ;//, strncmp;

т_мера форматчтекс(ткст0 в, in ткст0 из, т_мера чло);
alias форматчтекс преобразуй_чло_сим_лок;//, strxfrm;

ткст0  найдипер(in ткст0 т, цел с);
alias найдипер найди_перв_сим ;//, strchr;

т_мера персинд(in ткст0 где, in ткст0 что);
alias персинд дай_индекс_перв_сим;//, strcspn;

ткст0  найдитексвнаб(in ткст0 вчём, in ткст0 изчего);	
alias найдитексвнаб найди_сим_из_набора ;//, strpbrk;

ткст0  найдипос(in  ткст0 ткс, цел сим);	
alias найдипос найди_посл_сим;//, strrchr;

т_мера найдитекснеизнаб(in ткст0 вчём, in ткст0 изчего);	
alias найдитекснеизнаб найди_сим_не_из_набора ;//, strspn;

ткст0 найдиподтекс (in ткст0 стр, in ткст0 иском);	
alias найдиподтекс найди_подтекст ;//, strstr;

ткст0  стрзнак(ткст стрзнак0, in ткст строгран);
//alias стрзнак strtok;

ткст  строшиб(цел номош);
//alias строшиб strerror;

т_мера длинтекс(in ткст0 текст);
//alias длинтекс strlen;


т_мера длинашкс (in шим* с);
//alias длинашкс wcslen;

ук начнить(_У адр, бцел размстэка, ук аргспис);
//alias начнить _beginthread;

проц стопнить();
//alias стопнить _endthread;

ук начнитьдоп(ук безоп, бцел рамзстэка, винфункбЦ_У адр, ук аргспис, бцел иницфлаг, бцел* адрнити);
//alias начнитьдоп _beginthreadex;

проц стопнитьдоп(бцел кодвых);
//alias стопнитьдоп _endthreadex;

///////////////////////////////////////

const CHAR_BIT       = 8;
const SCHAR_MIN      = byte.min;
const SCHAR_MAX      = byte.max;
const UCHAR_MAX      = ubyte.min;
const CHAR_MIN       = сим.max;
const CHAR_MAX       = сим.max;
const MB_LEN_MAX     = 2;
const SHRT_MIN       = short.min;
const SHRT_MAX       = short.max;
const USHRT_MAX      = ushort.max;
const INT_MIN        = int.min;
const INT_MAX        = int.max;
const UINT_MAX       = uint.max;
const LONG_MIN       = c_long.min;
const LONG_MAX       = c_long.max;
const ULONG_MAX      = c_ulong.max;
const LLONG_MIN      = long.min;
const LLONG_MAX      = long.max;
const ULLONG_MAX     = ulong.max;

const int FP_ILOGB0        = int.min;
const int FP_ILOGBNAN      = int.min;
 
 
     enum
    {
        FP_NANS        = 0,
        FP_NANQ        = 1,
        FP_INFINITE    = 2,
        FP_NORMAL      = 3,
        FP_SUBNORMAL   = 4,
        FP_ZERO        = 5,
        FP_NAN         = FP_NANQ,
        FP_EMPTY       = 6,
        FP_UNSUPPORTED = 7,
    }
	
enum
{
    SEEK_SET,
    SEEK_CUR,
    SEEK_END
}
	
	struct div_t
	{
		int quot,
			rem;
	}


struct ldiv_t
	{
		int quot,
			rem;
	}
struct lldiv_t
	{
		long quot,
			 rem;
	}
	
struct imaxdiv_t
{
    intmax_t    quot,
                rem;
}


intmax_t  imaxabs(intmax_t j);
imaxdiv_t imaxdiv(intmax_t numer, intmax_t denom);
intmax_t  strtoimax(in char* nptr, char** endptr, int base);
uintmax_t strtoumax(in char* nptr, char** endptr, int base);
intmax_t  wcstoimax(in wchar_t* nptr, wchar_t** endptr, int base);
uintmax_t wcstoumax(in wchar_t* nptr, wchar_t** endptr, int base);



void _c_exit();
void _cexit();
void _exit(int);
void abort();
void _dodtors();
int getpid();
void    exit(int status);
int     atexit(void function() func);
void    _Exit(int status);



enum { _P_WAIT, _P_NOWAIT, _P_OVERLAY };

int execl(char *, char *,...);
int execle(char *, char *,...);
int execlp(char *, char *,...);
int execlpe(char *, char *,...);
int execv(char *, char **);
int execve(char *, char **, char **);
int execvp(char *, char **);
int execvpe(char *, char **, char **);


enum { WAIT_CHILD, WAIT_GRANDCHILD }

int cwait(int *,int,int);
int wait(int *);

version (Windows)
{

    uint _beginthread( _У ,uint, void *);

    extern  (Windows) alias uint (*stdfp)(void *);

    uint _beginthreadex(void* security, uint stack_size,
	    stdfp start_addr, void* arglist, uint initflag,
	    uint* thrdaddr);

    void _endthread();
    void _endthreadex(uint);

    int spawnl(int, char *, char *,...);
    int spawnle(int, char *, char *,...);
    int spawnlp(int, char *, char *,...);
    int spawnlpe(int, char *, char *,...);
    int spawnv(int, char *, char **);
    int spawnve(int, char *, char **, char **);
    int spawnvp(int, char *, char **);
    int spawnvpe(int, char *, char **, char **);


    int _wsystem(wchar_t *);
    int _wspawnl(int, wchar_t *, wchar_t *, ...);
    int _wspawnle(int, wchar_t *, wchar_t *, ...);
    int _wspawnlp(int, wchar_t *, wchar_t *, ...);
    int _wspawnlpe(int, wchar_t *, wchar_t *, ...);
    int _wspawnv(int, wchar_t *, wchar_t **);
    int _wspawnve(int, wchar_t *, wchar_t **, wchar_t **);
    int _wspawnvp(int, wchar_t *, wchar_t **);
    int _wspawnvpe(int, wchar_t *, wchar_t **, wchar_t **);

    int _wexecl(wchar_t *, wchar_t *, ...);
    int _wexecle(wchar_t *, wchar_t *, ...);
    int _wexeclp(wchar_t *, wchar_t *, ...);
    int _wexeclpe(wchar_t *, wchar_t *, ...);
    int _wexecv(wchar_t *, wchar_t **);
    int _wexecve(wchar_t *, wchar_t **, wchar_t **);
    int _wexecvp(wchar_t *, wchar_t **);
    int _wexecvpe(wchar_t *, wchar_t **, wchar_t **);
}


int iswalnum(wint_t wc);
int iswalpha(wint_t wc);
int iswblank(wint_t wc);
int iswcntrl(wint_t wc);
int iswdigit(wint_t wc);
int iswgraph(wint_t wc);
int iswlower(wint_t wc);
int iswprint(wint_t wc);
int iswpunct(wint_t wc);
int iswspace(wint_t wc);
int iswupper(wint_t wc);
int iswxdigit(wint_t wc);

int       iswctype(wint_t wc, wctype_t desc);
wctype_t  wctype(in char* property);
wint_t    towlower(wint_t wc);
wint_t    towupper(wint_t wc);
wint_t    towctrans(wint_t wc, wctrans_t desc);
wctrans_t wctrans(in char* property);
	
void* memchr(in void* s, int c, size_t n);
int   memcmp(in void* s1, in void* s2, size_t n);
void* memcpy(void* s1, in void* s2, size_t n);
void* memmove(void* s1, in void* s2, size_t n);
void* memset(void* s, int c, size_t n);

char*  strcpy(char* s1, in char* s2);
char*  strncpy(char* s1, in char* s2, size_t n);
char*  strcat(char* s1, in char* s2);
char*  strncat(char* s1, in char* s2, size_t n);
int    strcmp(in char* s1, in char* s2);
int    strcoll(in char* s1, in char* s2);
int    strncmp(in char* s1, in char* s2, size_t n);
size_t strxfrm(char* s1, in char* s2, size_t n);
char*  strchr(in char* s, int c);
size_t strcspn(in char* s1, in char* s2);
char*  strpbrk(in char* s1, in char* s2);
char*  strrchr(in char* s, int c);
size_t strspn(in char* s1, in char* s2);
char*  strstr(in char* s1, in char* s2);
char*  strtok(char* s1, in char* s2);
char*  strerror(int errnum);
size_t strlen(in char* s);

int memicmp(char* s1, char* s2, size_t n);
		
	int _fputc_nlock(int, FILE*);
	int _fputwc_nlock(int, FILE*);
	int _fgetc_nlock(FILE*);
	int _fgetwc_nlock(FILE*);
	int __fp_lock(FILE*);
	проц __fp_unlock(FILE*);
	
	int getErrno();      // for internal use
	int setErrno(int);   // for internal use
	
	    struct fenv_t
    {
        ushort    status;
        ushort    control;
        ushort    round;
        ushort[2] reserved;
    }
	
	void feraiseexcept(int excepts);
	void feclearexcept(int excepts);

	int fetestexcept(int excepts);
	int feholdexcept(fenv_t* envp);

	void fegetexceptflag(fexcept_t* flagp, int excepts);
	void fesetexceptflag(in fexcept_t* flagp, int excepts);

	int fegetround();
	int fesetround(int round);

	void fegetenv(fenv_t* envp);
	void fesetenv(in fenv_t* envp);
	void feupdateenv(in fenv_t* envp);
	
alias creal complex;
alias ireal imaginary;

cdouble cacos(cdouble z);
cfloat  cacosf(cfloat z);
creal   cacosl(creal z);

cdouble casin(cdouble z);
cfloat  casinf(cfloat z);
creal   casinl(creal z);

cdouble catan(cdouble z);
cfloat  catanf(cfloat z);
creal   catanl(creal z);

cdouble ccos(cdouble z);
cfloat  ccosf(cfloat z);
creal   ccosl(creal z);

cdouble csin(cdouble z);
cfloat  csinf(cfloat z);
creal   csinl(creal z);

cdouble ctan(cdouble z);
cfloat  ctanf(cfloat z);
creal   ctanl(creal z);

cdouble cacosh(cdouble z);
cfloat  cacoshf(cfloat z);
creal   cacoshl(creal z);

cdouble casinh(cdouble z);
cfloat  casinhf(cfloat z);
creal   casinhl(creal z);

cdouble catanh(cdouble z);
cfloat  catanhf(cfloat z);
creal   catanhl(creal z);

cdouble ccosh(cdouble z);
cfloat  ccoshf(cfloat z);
creal   ccoshl(creal z);

cdouble csinh(cdouble z);
cfloat  csinhf(cfloat z);
creal   csinhl(creal z);

cdouble ctanh(cdouble z);
cfloat  ctanhf(cfloat z);
creal   ctanhl(creal z);

cdouble cexp(cdouble z);
cfloat  cexpf(cfloat z);
creal   cexpl(creal z);

cdouble clog(cdouble z);
cfloat  clogf(cfloat z);
creal   clogl(creal z);

 double cabs(cdouble z);
 float  cabsf(cfloat z);
 real   cabsl(creal z);

cdouble cpow(cdouble x, cdouble y);
cfloat  cpowf(cfloat x, cfloat y);
creal   cpowl(creal x, creal y);

cdouble csqrt(cdouble z);
cfloat  csqrtf(cfloat z);
creal   csqrtl(creal z);

 double carg(cdouble z);
 float  cargf(cfloat z);
 real   cargl(creal z);

 double cimag(cdouble z);
 float  cimagf(cfloat z);
 real   cimagl(creal z);

cdouble conj(cdouble z);
cfloat  conjf(cfloat z);
creal   conjl(creal z);

cdouble cproj(cdouble z);
cfloat  cprojf(cfloat z);
creal   cprojl(creal z);

// double creal(cdouble z);
 float  crealf(cfloat z);
 real   creall(creal z);
 
int isalnum(int c);
int isalpha(int c);
int isblank(int c);
int iscntrl(int c);
int isdigit(int c);
int isgraph(int c);
int islower(int c);
int isprint(int c);
int ispunct(int c);
int isspace(int c);
int isupper(int c);
int isxdigit(int c);
int tolower(int c);
int toupper(int c);

struct lconv
{
    char* decimal_point;
    char* thousands_sep;
    char* grouping;
    char* int_curr_symbol;
    char* currency_symbol;
    char* mon_decimal_point;
    char* mon_thousands_sep;
    char* mon_grouping;
    char* positive_sign;
    char* negative_sign;
    byte  int_frac_digits;
    byte  frac_digits;
    byte  p_cs_precedes;
    byte  p_sep_by_space;
    byte  n_cs_precedes;
    byte  n_sep_by_space;
    byte  p_sign_posn;
    byte  n_sign_posn;
    byte  int_p_cs_precedes;
    byte  int_p_sep_by_space;
    byte  int_n_cs_precedes;
    byte  int_n_sep_by_space;
    byte  int_p_sign_posn;
    byte  int_n_sign_posn;
}

char*  setlocale(int category, in char* locale);
lconv* localeconv();
	
    uint __fpclassify_f(float x);
    uint __fpclassify_d(double x);
    uint __fpclassify_ld(real x);
	
	 double  acos(double x);
    float   acosf(float x);
    real    acosl(real x);

    double  asin(double x);
    float   asinf(float x);
    real    asinl(real x);

    double  atan(double x);
    float   atanf(float x);
    real    atanl(real x);

    double  atan2(double y, double x);
    float   atan2f(float y, float x);
    real    atan2l(real y, real x);

    double  cos(double x);
    float   cosf(float x);
    real    cosl(real x);

    double  sin(double x);
    float   sinf(float x);
    real    sinl(real x);

    double  tan(double x);
    float   tanf(float x);
    real    tanl(real x);

    double  acosh(double x);
    float   acoshf(float x);
    real    acoshl(real x);

    double  asinh(double x);
    float   asinhf(float x);
    real    asinhl(real x);

    double  atanh(double x);
    float   atanhf(float x);
    real    atanhl(real x);

    double  cosh(double x);
    float   coshf(float x);
    real    coshl(real x);

    double  sinh(double x);
    float   sinhf(float x);
    real    sinhl(real x);

    double  tanh(double x);
    float   tanhf(float x);
    real    tanhl(real x);

    double  exp(double x);
    float   expf(float x);
    real    expl(real x);

    double  exp2(double x);
    float   exp2f(float x);
    real    exp2l(real x);

    double  expm1(double x);
    float   expm1f(float x);
    real    expm1l(real x);

    double  frexp(double value, int* exp);
    float   frexpf(float value, int* exp);
    real    frexpl(real value, int* exp);

    int     ilogb(double x);
    int     ilogbf(float x);
    int     ilogbl(real x);

    double  ldexp(double x, int exp);
    float   ldexpf(float x, int exp);
    real    ldexpl(real x, int exp);

    double  log(double x);
    float   logf(float x);
    real    logl(real x);

    double  log10(double x);
    float   log10f(float x);
    real    log10l(real x);

    double  log1p(double x);
    float   log1pf(float x);
    real    log1pl(real x);

    double  log2(double x);
    float   log2f(float x);
    real    log2l(real x);

    double  logb(double x);
    float   logbf(float x);
    real    logbl(real x);

    double  modf(double value, double* iptr);
    float   modff(float value, float* iptr);
    real    modfl(real value, real *iptr);

    double  scalbn(double x, int n);
    float   scalbnf(float x, int n);
    real    scalbnl(real x, int n);

    double  scalbln(double x, c_long n);
    float   scalblnf(float x, c_long n);
    real    scalblnl(real x, c_long n);

    double  cbrt(double x);
    float   cbrtf(float x);
    real    cbrtl(real x);

    double  fabs(double x);
    float   fabsf(float x);
    real    fabsl(real x);

    double  hypot(double x, double y);
    float   hypotf(float x, float y);
    real    hypotl(real x, real y);

    double  pow(double x, double y);
    float   powf(float x, float y);
    real    powl(real x, real y);

    double  sqrt(double x);
    float   sqrtf(float x);
    real    sqrtl(real x);

    double  erf(double x);
    float   erff(float x);
    real    erfl(real x);

    double  erfc(double x);
    float   erfcf(float x);
    real    erfcl(real x);

    double  lgamma(double x);
    float   lgammaf(float x);
    real    lgammal(real x);

    double  tgamma(double x);
    float   tgammaf(float x);
    real    tgammal(real x);

    double  ceil(double x);
    float   ceilf(float x);
    real    ceill(real x);

    double  floor(double x);
    float   floorf(float x);
    real    floorl(real x);

    double  nearbyint(double x);
    float   nearbyintf(float x);
    real    nearbyintl(real x);

    double  rint(double x);
    float   rintf(float x);
    real    rintl(real x);

    c_long  lrint(double x);
    c_long  lrintf(float x);
    c_long  lrintl(real x);

    long    llrint(double x);
    long    llrintf(float x);
    long    llrintl(real x);

    double  round(double x);
    float   roundf(float x);
    real    roundl(real x);

    c_long  lround(double x);
    c_long  lroundf(float x);
    c_long  lroundl(real x);

    long    llround(double x);
    long    llroundf(float x);
    long    llroundl(real x);

    double  trunc(double x);
    float   truncf(float x);
    real    truncl(real x);

    double  fmod(double x, double y);
    float   fmodf(float x, float y);
    real    fmodl(real x, real y);

    double  remainder(double x, double y);
    float   remainderf(float x, float y);
    real    remainderl(real x, real y);

    double  remquo(double x, double y, int* quo);
    float   remquof(float x, float y, int* quo);
    real    remquol(real x, real y, int* quo);

    double  copysign(double x, double y);
    float   copysignf(float x, float y);
    real    copysignl(real x, real y);

    double  nan(char* tagp);
    float   nanf(char* tagp);
    real    nanl(char* tagp);

    double  nextafter(double x, double y);
    float   nextafterf(float x, float y);
    real    nextafterl(real x, real y);

    double  nexttoward(double x, real y);
    float   nexttowardf(float x, real y);
    real    nexttowardl(real x, real y);

    double  fdim(double x, double y);
    float   fdimf(float x, float y);
    real    fdiml(real x, real y);

    double  fmax(double x, double y);
    float   fmaxf(float x, float y);
    real    fmaxl(real x, real y);

    double  fmin(double x, double y);
    float   fminf(float x, float y);
    real    fminl(real x, real y);

    double  fma(double x, double y, double z);
    float   fmaf(float x, float y, float z);
    real    fmal(real x, real y, real z);
	
	int remove(in char* filename);
int rename(in char* from, in char* to);

FILE* tmpfile();
char* tmpnam(char* s);

int   fclose(FILE* stream);
int   fflush(FILE* stream);
FILE* fopen(in char* filename, in char* mode);
FILE* freopen(in char* filename, in char* mode, FILE* stream);

void setbuf(FILE* stream, char* buf);
int  setvbuf(FILE* stream, char* buf, int mode, size_t size);

int fprintf(FILE* stream, in char* format, ...);
int fscanf(FILE* stream, in char* format, ...);
int sprintf(char* s, in char* format, ...);
int sscanf(in char* s, in char* format, ...);
int vfprintf(FILE* stream, in char* format, va_list арг);
int vfscanf(FILE* stream, in char* format, va_list арг);
int vsprintf(char* s, in char* format, va_list арг);
int vsscanf(in char* s, in char* format, va_list арг);
int vprintf(in char* format, va_list арг);
int vscanf(in char* format, va_list арг);
//int эхо(in char* format, ...);
int scanf(in char* format, ...);

int fgetc(FILE* stream);
int fputc(int c, FILE* stream);

char* fgets(char* s, int n, FILE* stream);
int   fputs(in char* s, FILE* stream);
char* gets(char* s);
int   puts(in char* s);

int ungetc(int c, FILE* stream);

size_t fread(void* ptr, size_t size, size_t nmemb, FILE* stream);
size_t fwrite(in void* ptr, size_t size, size_t nmemb, FILE* stream);

int fgetpos(FILE* stream, fpos_t * pos);
int fsetpos(FILE* stream, in fpos_t* pos);

int    fseek(FILE* stream, c_long offset, int whence);
c_long ftell(FILE* stream);

int   _snprintf(char* s, size_t n, in char* fmt, ...);
alias _snprintf snprintf;

int   _vsnprintf(char* s, size_t n, in char* format, va_list арг);
alias _vsnprintf vsnprintf;

void perror(in char* s);

double  atof(in char* nptr);
int     atoi(in char* nptr);
c_long  atol(in char* nptr);
long    atoll(in char* nptr);

double  strtod(in char* nptr, char** endptr);
float   strtof(in char* nptr, char** endptr);
real    strtold(in char* nptr, char** endptr);
c_long  strtol(in char* nptr, char** endptr, int base);
long    strtoll(in char* nptr, char** endptr, int base);
c_ulong strtoul(in char* nptr, char** endptr, int base);
ulong   strtoull(in char* nptr, char** endptr, int base);

int     rand();
void    srand(uint seed);

void*   malloc(size_t size);
void*   calloc(size_t nmemb, size_t size);
void*   realloc(void* ptr, size_t size);
void    free(void* ptr);

char*   getenv(in char* name);
int     system(in char* string);

void*   bsearch(in void* key, in void* base, size_t nmemb, size_t size, int function(in void*, in void*) compar);
void    qsort(void* base, size_t nmemb, size_t size, int function(in void*, in void*) compar);

int     abs(int j);
c_long  labs(c_long j);
long    llabs(long j);

div_t   div(int numer, int denom);
ldiv_t  ldiv(c_long numer, c_long denom);
lldiv_t lldiv(long numer, long denom);

int     mblen(in char* s, size_t n);
int     mbtowc(wchar_t* pwc, in char* s, size_t n);
int     wctomb(char*s, wchar_t wc);
size_t  mbstowcs(wchar_t* pwcs, in char* s, size_t n);
size_t  wcstombs(char* s, in wchar_t* pwcs, size_t n);

version( DigitalMars )
	{
		void* alloca(size_t size); // non-standard
		
	}
	
version( Windows )
{
    struct tm
    {
        int     tm_sec;     // seconds after the minute - [0, 60]
        int     tm_min;     // minutes after the hour - [0, 59]
        int     tm_hour;    // hours since midnight - [0, 23]
        int     tm_mday;    // day of the month - [1, 31]
        int     tm_mon;     // months since January - [0, 11]
        int     tm_year;    // years since 1900
        int     tm_wday;    // days since Sunday - [0, 6]
        int     tm_yday;    // days since January 1 - [0, 365]
        int     tm_isdst;   // Daylight Saving Time flag
    }
}
else
{
    struct tm
    {
        int     tm_sec;     // seconds after the minute [0-60]
        int     tm_min;     // minutes after the hour [0-59]
        int     tm_hour;    // hours since midnight [0-23]
        int     tm_mday;    // day of the month [1-31]
        int     tm_mon;     // months since January [0-11]
        int     tm_year;    // years since 1900
        int     tm_wday;    // days since Sunday [0-6]
        int     tm_yday;    // days since January 1 [0-365]
        int     tm_isdst;   // Daylight Savings Time flag
        c_long  tm_gmtoff;  // offset from CUT in seconds
        char*   tm_zone;    // timezone abbreviation
    }
}

alias c_long time_t;
alias c_long clock_t;


 clock_t CLOCKS_PER_SEC = 1000;


clock_t clock();
double  difftime(time_t time1, time_t time0);
time_t  mktime(tm* timeptr);
time_t  time(time_t* timer);
char*   asctime(in tm* timeptr);
char*   ctime(in time_t* timer);
tm*     gmtime(in time_t* timer);
tm*     localtime(in time_t* timer);
size_t  strftime(char* s, size_t maxsize, in char* format, in tm* timeptr);

    void  tzset();  		 // non-standard
    void  _tzset(); 		 // non-standard
    char* _strdate(char* s); // non-standard
    char* _strtime(char* s); // non-standard
	
alias int     mbstate_t;
//alias wchar_t wint_t;

//const wchar_t WEOF = 0xFFFF;

int fwprintf(FILE* stream, in wchar_t* format, ...);
int fwscanf(FILE* stream, in wchar_t* format, ...);
int swprintf(wchar_t* s, size_t n, in wchar_t* format, ...);
int swscanf(in wchar_t* s, in wchar_t* format, ...);
int vfwprintf(FILE* stream, in wchar_t* format, va_list арг);
int vfwscanf(FILE* stream, in wchar_t* format, va_list арг);
int vswprintf(wchar_t* s, size_t n, in wchar_t* format, va_list арг);
int vswscanf(in wchar_t* s, in wchar_t* format, va_list арг);
int vwprintf(in wchar_t* format, va_list арг);
int vwscanf(in wchar_t* format, va_list арг);
int wprintf(in wchar_t* format, ...);
int wscanf(in wchar_t* format, ...);

wint_t fgetwc(FILE* stream);
wint_t fputwc(wchar_t c, FILE* stream);

wchar_t* fgetws(wchar_t* s, int n, FILE* stream);
int      fputws(in wchar_t* s, FILE* stream);

wint_t ungetwc(wint_t c, FILE* stream);
int    fwide(FILE* stream, int mode);

double  wcstod(in wchar_t* nptr, wchar_t** endptr);
float   wcstof(in wchar_t* nptr, wchar_t** endptr);
real    wcstold(in wchar_t* nptr, wchar_t** endptr);
c_long  wcstol(in wchar_t* nptr, wchar_t** endptr, int base);
long    wcstoll(in wchar_t* nptr, wchar_t** endptr, int base);
c_ulong wcstoul(in wchar_t* nptr, wchar_t** endptr, int base);
ulong   wcstoull(in wchar_t* nptr, wchar_t** endptr, int base);

wchar_t* wcscpy(wchar_t* s1, in wchar_t* s2);
wchar_t* wcsncpy(wchar_t* s1, in wchar_t* s2, size_t n);
wchar_t* wcscat(wchar_t* s1, in wchar_t* s2);
wchar_t* wcsncat(wchar_t* s1, in wchar_t* s2, size_t n);
int      wcscmp(in wchar_t* s1, in wchar_t* s2);
int      wcscoll(in wchar_t* s1, in wchar_t* s2);
int      wcsncmp(in wchar_t* s1, in wchar_t* s2, size_t n);
size_t   wcsxfrm(wchar_t* s1, in wchar_t* s2, size_t n);
wchar_t* wcschr(in wchar_t* s, wchar_t c);
size_t   wcscspn(in wchar_t* s1, in wchar_t* s2);
wchar_t* wcspbrk(in wchar_t* s1, in wchar_t* s2);
wchar_t* wcsrchr(in wchar_t* s, wchar_t c);
size_t   wcsspn(in wchar_t* s1, in wchar_t* s2);
wchar_t* wcsstr(in wchar_t* s1, in wchar_t* s2);
wchar_t* wcstok(wchar_t* s1, in wchar_t* s2, wchar_t** ptr);
size_t   wcslen(in wchar_t* s);

wchar_t* wmemchr(in wchar_t* s, wchar_t c, size_t n);
int      wmemcmp(in wchar_t* s1, in wchar_t* s2, size_t n);
wchar_t* wmemcpy(wchar_t* s1, in wchar_t* s2, size_t n);
wchar_t* wmemmove(wchar_t*s1, in wchar_t* s2, size_t n);
wchar_t* wmemset(wchar_t* s, wchar_t c, size_t n);

size_t wcsftime(wchar_t* s, size_t maxsize, in wchar_t* format, in tm* timeptr);

version( Windows )
{
    wchar_t* _wasctime(tm*);      // non-standard
    wchar_t* _wctime(time_t*);	  // non-standard
    wchar_t* _wstrdate(wchar_t*); // non-standard
    wchar_t* _wstrtime(wchar_t*); // non-standard
}

wint_t btowc(int c);
int    wctob(wint_t c);
int    mbsinit(in mbstate_t* ps);
size_t mbrlen(in char* s, size_t n, mbstate_t* ps);
size_t mbrtowc(wchar_t* pwc, in char* s, size_t n, mbstate_t* ps);
size_t wcrtomb(char* s, wchar_t wc, mbstate_t* ps);
size_t mbsrtowcs(wchar_t* dst, in char** src, size_t len, mbstate_t* ps);
size_t wcsrtombs(char* dst, in wchar_t** src, size_t len, mbstate_t* ps);

sigfn_t signal(int sig, sigfn_t func);
int     raise(int sig);



