// Written in the D programming language.

/**
 * Macros:
 *	WIKI = Phobos/StdFile
 */

module std.file;

public import std.console;

private import std.c;
private import std.path;
private import std.string;
private import std.regexp;
private import std.gc;

/* =========================== Win32 ======================= */

version (Win32)
{

private import os.windows;
private import std.utf;
private import os.win.syserror;
private import os.win.charset;
private import std.date;

int useWfuncs = 1;

static this()
{
    // Win 95, 98, ME do not implement the W functions
    useWfuncs = (GetVersion() < 0x80000000);
}

/***********************************
 * Исключение, выводимое для ошибок файлового I/O.
 */

class FileException : Exception
{
    uint errno;			// код ошибки операционной системы

    this(string name);

    this(string name, string message);

    this(string name, uint errno);
}
alias FileException ФайлИскл;
/* **********************************
 * Основные Файловые операции.
 */

/********************************************
 * Прочесть файл name[], вернуть массив считанных байтов.
 * Выводит:
 *	FileException при ошибке.
 */

void[] read(char[] name);
   alias read читай;

/*********************************************
 * Записать buffer[] в файл name[].
 * Выводит: FileException при ошибке.
 */

void write(char[] name, void[] buffer);
alias write пиши;
/*********************************************
 * Добавить buffer[] в файл name[].
 * Выводит: FileException при ошибке.
 */

void append(char[] name, void[] buffer);
    alias append допиши;

/***************************************************
 * Переименовать файл from[] в to[].
 * Выводит: FileException при ошибке.
 */

void rename(char[] from, char[] to);
 alias rename переименуй;
/***************************************************
 * Удалить файл name[].
 * Выводит: FileException при ошибке.
 */

void remove(char[] name);
 alias remove удали;
/***************************************************
 * Получить размер файла name[].
 * Выводит: FileException при ошибке.
 */

ulong getSize(char[] name);
alias getSize дайРазмер;

/*************************
 * Получить время создания/доступа/изменения файла name[].
 * Выводит: FileException при ошибке.
 */

void getTimes(char[] name, out d_time ftc, out d_time fta, out d_time ftm);
alias getTimes дайВремя;

/***************************************************
 * Существует ли файл (или папка) name[]?
 * вернет 1, если да, и 0, если нет.
 */

int exists(char[] name);
 alias exists есть_ли;
/***************************************************
 * Получить атрибуты файла name[].
 * Выводит: FileException при ошибке.
 */

uint getAttributes(string name);
alias getAttributes дайАтры;
/****************************************************
 * Является ли name[] файлом?
 * Выводит: FileException, если name[] не существует.
 */

int isfile(char[] name);
 alias isfile файл_ли;
/****************************************************
 * Является ли name[] папкой?
 * Выводит: FileException, если name[] не существует.
 */

int isdir(char[] name);
alias isdir папка_ли;

/****************************************************
 * Изменить папку на to pathname[].
 * Выводит: FileException при ошибке.
 */

void chdir(char[] pathname);
alias chdir сменипап;
/****************************************************
 * Создать папку pathname[].
 * Выводит: FileException при ошибке.
 */

void mkdir(char[] pathname);
alias mkdir сделпап;
/****************************************************
 * Удалить папку pathname[].
 * Выводит: FileException при ошибке.
 */

void rmdir(char[] pathname);
alias rmdir удалипап;
/****************************************************
 * Получить текущую папку.
 * Выводит: FileException при ошибке.
 */

char[] getcwd();
alias getcwd дайтекпап;
	
/***************************************************
 * Directory Entry
 */

struct DirEntry
{
    string name;			/// название файла или папки
	alias name имя;
	
    ulong size = ~0UL;			/// размер файла в байтах
	alias size размер;
	
    d_time creationTime = d_time_nan;	/// время создания файла
	alias creationTime датаСозд;
	
    d_time lastAccessTime = d_time_nan;	/// время последнего доступа к файлу
	alias lastAccessTime последВремяДост;
	
    d_time lastWriteTime = d_time_nan;	/// время последней записи в файлo
	alias lastWriteTime последнВремяЗап;
	
    uint attributes;		// Windows file attributes OR'd together
	alias attributes атрибуты;
	
    void init(string path, WIN32_FIND_DATA *fd);
    void init(string path, WIN32_FIND_DATAW *fd);
	alias init иниц;
    /****
     * Вернуть !=0, если DirEntry является папкой.
     */
    uint isdir();
	alias isdir папка_ли;
    /****
     * Вернуть !=0, если DirEntry является файлом.
     */
    uint isfile();
	alias isfile файл_ли;
}
alias DirEntry ПапЗапись;

/***************************************************
 * Возвращает содержимое папки pathname[].
 * В названия из содержимого не входит pathname.
 * Выводит: FileException при ошибке
 * Пример:
 *	Эта программа создает список всех файлов и подпапок в ее
 *	аргументе path.
 * ----
 * import std.io;
 * import std.file;
 *
 * void main(string[] args)
 * {
 *    auto dirs = std.file.listdir(args[1]);
 *
 *    foreach (d; dirs)
 *	writefln(d);
 * }
 * ----
 */

string[] listdir(string pathname);

/*****************************************************
 * Вернет все файлы в папке и ее подпапках,
 * соответствующие образцу или регулярному выражению r.
 * Параметры:
 *	pathname = Название папки
 *	pattern = Строка с wildcards, вроде этой: $(RED "*.d"). Поддерживаемые
 *		wildcard-строки описаны в fnmatch() из
 *		$(LINK2 std_path.html, std.path).
 *	r = Регулярное выражение, для более мощной сверки образцов(_pattern matching).
 * Пример:
 *	Эта программа создает список всех файлов с расширением "d" из
 *	path (пути), переданного в качестве первого аргумента.
 * ----
 * import std.io;
 * import std.file;
 *
 * void main(string[] args)
 * {
 *    auto d_source_files = std.file.listdir(args[1], "*.d");
 *
 *    foreach (d; d_source_files)
 *	writefln(d);
 * }
 * ----
 * Версия регулярного выражения, которая находит все файлы с расширениями "d" или
 * "obj":
 * ----
 * import std.io;
 * import std.file;
 * import std.regexp;
 *
 * void main(string[] args)
 * {
 *    auto d_source_files = std.file.listdir(args[1], RegExp(r"\.(d|obj)$"));
 *
 *    foreach (d; d_source_files)
 *	writefln(d);
 * }
 * ----
 */

string[] listdir(string pathname, string pattern);

/** Ditto */

string[] listdir(string pathname, RegExp r);

/******************************************************
 * Передать каждое название файла и папки из pathname[]
 * делегату обратного вызова.
 * Параметры:
 *	callback =	Делегат, обрабатывающий каждое
 *			filename по очереди. Возвращает true для
 *			продолжения, и false для остановки.
 * Пример:
 *	Эта программа создает список всех файлов из своего
 *	аргумента пути, включая и этот путь.
 * ----
 * import std.io;
 * import std.path;
 * import std.file;
 *
 * void main(string[] args)
 * {
 *    auto pathname = args[1];
 *    string[] result;
 *
 *    bool listing(string filename)
 *    {
 *      result ~= std.path.join(pathname, filename);
 *      return true; // продолжить
 *    }
 *
 *    listdir(pathname, &listing);
 *
 *    foreach (name; result)
 *      writefln("%s", name);
 * }
 * ----
 */

void listdir(string pathname, bool delegate(string filename) callback);

/******************************************************
 * Каждый файл и папку DirEntry по адресу pathname[]
 * передать делегату обратного вызова.
 * Параметры:
 *	callback =	Делегат, обрабатывающий каждое
 *			DirEntry поочередно. Возвращает true,  
 *			что означает "продолжить", и false, означающее остановку.
 * Пример:
 *	Эта программа перечисляет все файлы по своему аргументу
 *	path и все находящиеся по нему подпапки.
 * ----
 * import std.io;
 * import std.file;
 *
 * void main(string[] args)
 * {
 *    bool callback(DirEntry* de)
 *    {
 *      if (de.isdir)
 *        listdir(de.name, &callback);
 *      else
 *        writefln(de.name);
 *      return true;
 *    }
 *
 *    listdir(args[1], &callback);
 * }
 * ----
 */

void listdir(string pathname, bool delegate(DirEntry* de) callback);
		
alias listdir списпап;
/******************************************
 * Поскольку Win 9x не поддерживает "W" API'шки, сначала надо преобразовать в
 * wchar, затем в многобайтник, используя текущую кодовую страницу.
 * (Спасибо за это yaneurao)
 * Депрекировано: используйте вместо нее os.win.charset.toMBSz.
 */

char* toMBSz(string s);
alias toMBSz вМбс0;

/***************************************************
 * Скопировать файл из from[] в to[].
 */

void copy(string from, string to);
alias copy копируй;

}




