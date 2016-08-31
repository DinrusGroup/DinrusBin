
// Written in the D programming language.

/**
 * String handling functions.
 *
 * To copy or not to copy?
 * When a function takes a string as a parameter, and returns a string,
 * is that string the same as the input string, modified in place, or
 * is it a modified copy of the input string? The D array convention is
 * "copy-on-write". This means that if no modifications are done, the
 * original string (or slices of it) can be returned. If any modifications
 * are done, the returned string is a copy.
 *
 * Macros:
 *	WIKI = Phobos/StdString
 * Copyright:
 *	Public Domain
 */

/* Author:
 *	Walter Bright, Digital Mars, www.digitalmars.com
 */

// The code is not optimized for speed, that will have to wait
// until the design is solidified.

module std.string;

//public import rt.core.string;

//debug=string;		// uncomment to turn on debugging printf's

private import std.io;
private import std.c: cstring, wcslen, strlen;
private import std.utf;
private import std.uni;
private import std.exception;
private import std.format;
private import std.ctype;
private import std.stdarg;

extern (C)
{

    size_t wcslen(wchar *);
    int wcscmp(wchar *, wchar *);
}

	/+alias iswhite пробел_ли;
	 alias atoi алфнац;
	 alias atof алфнапз;
	 alias cmp сравни;
	 alias icmp сравнлюб;
	 alias toCharz вСим0;
	 alias toStringz вТкст0;
	 alias find найди;
	 alias ifind найдлюб;
	 alias rfind найдрек;
	 alias irfind найдлюбрек;
	 alias toupper взаг;+/
	 alias capitalize озаг;
	 alias capwords озагслова;
	 alias repeat повтори;
	 alias join объедени;
	 alias split разбей;
	 alias splitlines разбейнастр;
	 alias stripl уберислев;
	 alias stripr уберисправ;
	 alias strip убери;
	 alias chomp убериразгр;
	 alias chop уберигран;
	 alias ljustify полев;
	 alias rjustify поправ;
	 alias center вцентр;
	 alias zfill занули;
	 alias replace замени;
	 alias replaceSlice заменисрез;
	 alias insert вставь;
	 alias count счесть;
	 alias expandtabs заменитабнапбел;
	 alias entab заменипбелнатаб;
	 alias maketrans постройтранстаб;
	 alias translate транслируй;
	 alias toString вТкст;
	 alias format форматируй;
	 alias форматируй фм;
	 alias sformat форматируйс;
	 alias inPattern вОбразце;
	 alias countchars посчитайсимв;
	 alias removechars удалисимв;
	 alias squeeze сквиз;
	 alias succ следщ;
	 alias isNumeric число_ли;
	 alias column колном;
	 alias wrap параграф;
	 alias isEmail эладр_ли;
	 alias isURL урл_ли;
	 alias intToUtf8 целВУтф8;
	 alias ulongToUtf8 бдолВУтф8;

	 
/* ************* Exceptions *************** */

/// Thrown on errors in string functions.
class StringException : Exception
{
    this(char[] msg)	/// Constructor
    {
	super(msg);
    }
}

/* ************* Constants *************** */

const char[16] hexdigits = "0123456789ABCDEF";			/// 0..9A..F
const char[10] digits    = "0123456789";			/// 0..9
const char[8]  octdigits = "01234567";				/// 0..7
const char[92] lowercase = "abcdefghijklmnopqrstuvwxyzабвгдеёжзийклмнопрстуфхцчшщъыьэюя";	/// a..z
const char[92] uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ";	/// A..Z
const char[184] letters   = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
			   "abcdefghijklmnopqrstuvwxyz" "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ" "абвгдеёжзийклмнопрстуфхцчшщъыьэюя";	/// A..Za..z
const char[6] whitespace = " \t\v\r\n\f";			/// ASCII whitespace

const dchar LS = '\u2028';	/// UTF line separator
const dchar PS = '\u2029';	/// UTF paragraph separator

/// Newline sequence for this system
version (Windows)
    const char[2] newline = "\r\n";
else version (Posix)
    const char[1] newline = "\n";

/**********************************
 * Returns true if c is whitespace
 */

bool iswhite(dchar c);
бул пробел_ли(дим с);
/*********************************
 * Convert string to integer.
 */

long atoi(char[] s);
дол алфнац(сим[] с);
/*************************************
 * Convert string to real.
 */

real atof(char[] s);
реал алфнапз(сим[] с);
/**********************************
 * Compare two strings. cmp is case sensitive, icmp is case insensitive.
 * Returns:
 *	<table border=1 cellpadding=4 cellspacing=0>
 *	$(TR $(TD &lt; 0)	$(TD s1 &lt; s2))
 *	$(TR $(TD = 0)	$(TD s1 == s2))
 *	$(TR $(TD &gt; 0)	$(TD s1 &gt; s2))
 *	</table>
 */

int cmp(char[] s1, char[] s2);
цел сравни(сим[] s1, сим[] s2);
/*********************************
 * ditto
 */

int icmp(char[] s1, char[] s2);
цел сравнлюб(сим[] s1, сим[] s2);

/* ********************************
 * Converts a D array of chars to a C-style 0 terminated string.
 * Deprecated: replaced with toStringz().
 */

deprecated char* toCharz(char[] s);

/*********************************
 * Convert array of chars s[] to a C-style 0 terminated string.
 * s[] must not contain embedded 0's.
 */

char* toStringz(char[] s);
сим* вТкст0(сим[] s);
/******************************************
 * find, ifind _find first occurrence of c in string s.
 * rfind, irfind _find last occurrence of c in string s.
 *
 * find, rfind are case sensitive; ifind, irfind are case insensitive.
 * Returns:
 *	Index in s where c is found, -1 if not found.
 */

int find(char[] s, dchar c);
цел найди(сим[] s, дим c);
/******************************************
 * ditto
 */

int ifind(char[] s, dchar c);
цел найдлюб(сим[] s, дим c);
/******************************************
 * ditto
 */

int rfind(char[] s, dchar c);
цел найдрек(сим[] s, дим c);
/******************************************
 * ditto
 */

int irfind(char[] s, dchar c);
цел найдлюбрек(сим[] s, дим c);
/******************************************
 * find, ifind _find first occurrence of sub[] in string s[].
 * rfind, irfind _find last occurrence of sub[] in string s[].
 *
 * find, rfind are case sensitive; ifind, irfind are case insensitive.
 * Returns:
 *	Index in s where c is found, -1 if not found.
 */

int find(char[] s, char[] sub);
цел найди(сим[] s, сим[] sub);
/******************************************
 * ditto
 */

int ifind(char[] s, char[] sub);
цел найдлюб(сим[] s, сим[] sub);
/******************************************
 * ditto
 */

int rfind(char[] s, char[] sub);
цел найдрек(сим[] s, сим[] sub);
/******************************************
 * ditto
 */

int irfind(char[] s, char[] sub);
цел найдлюбрек(сим[] s, сим[] sub);
/************************************
 * Convert string s[] to lower case.
 */

string tolower(string s);
ткст впроп(ткст s);
/************************************
 * Convert string s[] to upper case.
 */

string toupper(string s);
ткст взаг(ткст s);
/********************************************
 * Capitalize first character of string s[], convert rest of string s[]
 * to lower case.
 */

char[] capitalize(char[] s);


/********************************************
 * Capitalize all words in string s[].
 * Remove leading and trailing whitespace.
 * Replace all sequences of whitespace with a single space.
 */

char[] capwords(char[] s);
/********************************************
 * Return a string that consists of s[] repeated n times.
 */

char[] repeat(char[] s, size_t n);


/********************************************
 * Concatenate all the strings in words[] together into one
 * string; use sep[] as the separator.
 */

char[] join(char[][] words, char[] sep);

/**************************************
 * Split s[] into an array of words,
 * using whitespace as the delimiter.
 */

char[][] split(char[] s);

/**************************************
 * Split s[] into an array of words,
 * using delim[] as the delimiter.
 */

char[][] split(char[] s, char[] delim);


/**************************************
 * Split s[] into an array of lines,
 * using CR, LF, or CR-LF as the delimiter.
 * The delimiter is not included in the line.
 */

char[][] splitlines(char[] s);


/*****************************************
 * Strips leading or trailing whitespace, or both.
 */

char[] stripl(char[] s);
char[] stripr(char[] s);
char[] strip(char[] s);

/*******************************************
 * Returns s[] sans trailing delimiter[], if any.
 * If delimiter[] is null, removes trailing CR, LF, or CRLF, if any.
 */

char[] chomp(char[] s, char[] delimiter = null);

/***********************************************
 * Returns s[] sans trailing character, if there is one.
 * If last two characters are CR-LF, then both are removed.
 */

char[] chop(char[] s);

/*******************************************
 * Left justify, right justify, or center string s[]
 * in field width chars wide.
 */

char[] ljustify(char[] s, int width);

/// ditto
char[] rjustify(char[] s, int width);

/// ditto
char[] center(char[] s, int width);



/*****************************************
 * Same as rjustify(), but fill with '0's.
 */

char[] zfill(char[] s, int width);

/********************************************
 * Replace occurrences of from[] with to[] in s[].
 */

char[] replace(char[] s, char[] from, char[] to);

/*****************************
 * Return a _string that is string[] with slice[] replaced by replacement[].
 */

char[] replaceSlice(char[] string, char[] slice, char[] replacement);

/**********************************************
 * Insert sub[] into s[] at location index.
 */

char[] insert(char[] s, size_t index, char[] sub);
/***********************************************
 * Count up all instances of sub[] in s[].
 */

size_t count(char[] s, char[] sub);


/************************************************
 * Replace tabs with the appropriate number of spaces.
 * tabsize is the distance between tab stops.
 */

char[] expandtabs(char[] string, int tabsize = 8);


/*******************************************
 * Replace spaces in string with the optimal number of tabs.
 * Trailing spaces or tabs in a line are removed.
 * Params:
 *	string = String to convert.
 *	tabsize = Tab columns are tabsize spaces apart. tabsize defaults to 8.
 */

char[] entab(char[] string, int tabsize = 8);


/************************************
 * Construct translation table for translate().
 * BUG: only works with ASCII
 */

char[] maketrans(char[] from, char[] to);

/******************************************
 * Translate characters in s[] using table created by maketrans().
 * Delete chars in delchars[].
 * BUG: only works with ASCII
 */

char[] translate(char[] s, char[] transtab, char[] delchars);
/***********************************************
 * Convert to char[].
 */

char[] toString(bool b);
char[] toString(ubyte ub) ;
char[] toString(ushort us) ;
char[] toString(uint u);
char[] toString(ulong u);
char[] toString(byte b) ;
char[] toString(short s) ;
char[] toString(int i);
char[] toString(long i);
char[] toString(float f) ;
char[] toString(double d);
char[] toString(real r);
char[] toString(ifloat f) ;
char[] toString(idouble d);
char[] toString(ireal r);
char[] toString(cfloat f) ;
char[] toString(cdouble d);
char[] toString(creal r);


/******************************************
 * Convert value to string in _radix radix.
 *
 * radix must be a value from 2 to 36.
 * value is treated as a signed value only if radix is 10.
 * The characters A through Z are used to represent values 10 through 36.
 */
char[] toString(long value, uint radix);
char[] toString(ulong value, uint radix);

/*************************************************
 * Convert C-style 0 terminated string s to char[] string.
 */

char[] toString(char *s);

/*****************************************************
 * Format arguments into a string.
 */


char[] format(...);

/*****************************************************
 * Format arguments into string <i>s</i> which must be large
 * enough to hold the result. Throws ArrayBoundsError if it is not.
 * Returns: s
 */
char[] sformat(char[] s, ...);


/***********************************************
 * See if character c is in the pattern.
 * Patterns:
 *
 *	A <i>pattern</i> is an array of characters much like a <i>character
 *	class</i> in regular expressions. A sequence of characters
 *	can be given, such as "abcde". The '-' can represent a range
 *	of characters, as "a-e" represents the same pattern as "abcde".
 *	"a-fA-F0-9" represents all the hex characters.
 *	If the first character of a pattern is '^', then the pattern
 *	is negated, i.e. "^0-9" means any character except a digit.
 *	The functions inPattern, <b>countchars</b>, <b>removeschars</b>,
 *	and <b>squeeze</b>
 *	use patterns.
 *
 * Note: In the future, the pattern syntax may be improved
 *	to be more like regular expression character classes.
 */

bool inPattern(dchar c, char[] pattern);


/***********************************************
 * See if character c is in the intersection of the patterns.
 */

int inPattern(dchar c, char[][] patterns);

/********************************************
 * Count characters in s that match pattern.
 */

size_t countchars(char[] s, char[] pattern);

/********************************************
 * Return string that is s with all characters removed that match pattern.
 */

char[] removechars(char[] s, char[] pattern);

/***************************************************
 * Return string where sequences of a character in s[] from pattern[]
 * are replaced with a single instance of that character.
 * If pattern is null, it defaults to all characters.
 */

char[] squeeze(char[] s, char[] pattern = null);

/**********************************************
 * Return string that is the 'successor' to s[].
 * If the rightmost character is a-zA-Z0-9, it is incremented within
 * its case or digits. If it generates a carry, the process is
 * repeated with the one to its immediate left.
 */

char[] succ(char[] s);

/***********************************************
 * Replaces characters in str[] that are in from[]
 * with corresponding characters in to[] and returns the resulting
 * string.
 * Params:
 *	modifiers = a string of modifier characters
 * Modifiers:
		<table border=1 cellspacing=0 cellpadding=5>
		<tr> <th>Modifier <th>Description
		<tr> <td><b>c</b> <td>Complement the list of characters in from[]
		<tr> <td><b>d</b> <td>Removes matching characters with no corresponding replacement in to[]
		<tr> <td><b>s</b> <td>Removes adjacent duplicates in the replaced characters
		</table>

	If modifier <b>d</b> is present, then the number of characters
	in to[] may be only 0 or 1.

	If modifier <b>d</b> is not present and to[] is null,
	then to[] is taken _to be the same as from[].

	If modifier <b>d</b> is not present and to[] is shorter
	than from[], then to[] is extended by replicating the
	last character in to[].

	Both from[] and to[] may contain ranges using the <b>-</b>
	character, for example <b>a-d</b> is synonymous with <b>abcd</b>.
	Neither accept a leading <b>^</b> as meaning the complement of
	the string (use the <b>c</b> modifier for that).
 */

char[] tr(char[] str, char[] from, char[] to, char[] modifiers = null);

/* ************************************************
 * Version       : v0.3
 * Author        : David L. 'SpottedTiger' Davis
 * Date Created  : 31.May.05 Compiled and Tested with dmd v0.125
 * Date Modified : 01.Jun.05 Modified the function to handle the
 *               :           imaginary and complex float-point 
 *               :           datatypes.
 *               :
 * Licence       : Public Domain / Contributed to Digital Mars
 */

/**
 * [in] char[] s can be formatted in the following ways:
 *
 * Integer Whole Number:
 * (for byte, ubyte, short, ushort, int, uint, long, and ulong)
 * ['+'|'-']digit(s)[U|L|UL]
 *
 * examples: 123, 123UL, 123L, +123U, -123L
 *
 * Floating-Point Number:
 * (for float, double, real, ifloat, idouble, and ireal)
 * ['+'|'-']digit(s)[.][digit(s)][[e-|e+]digit(s)][i|f|L|Li|fi]]
 *      or [nan|nani|inf|-inf]
 *
 * examples: +123., -123.01, 123.3e-10f, 123.3e-10fi, 123.3e-10L
 * 
 * (for cfloat, cdouble, and creal)
 * ['+'|'-']digit(s)[.][digit(s)][[e-|e+]digit(s)][+]
 *         [digit(s)[.][digit(s)][[e-|e+]digit(s)][i|f|L|Li|fi]]
 *      or [nan|nani|nan+nani|inf|-inf]
 *
 * examples: nan, -123e-1+456.9e-10Li, +123e+10+456i, 123+456
 *
 * [in] bool bAllowSep 
 * False by default, but when set to true it will accept the 
 * separator characters "," and "_" within the string, but these  
 * characters should be stripped from the string before using any 
 * of the conversion functions like toInt(), toFloat(), and etc 
 * else an error will occur.
 *
 * Also please note, that no spaces are allowed within the string  
 * anywhere whether it's a leading, trailing, or embedded space(s), 
 * thus they too must be stripped from the string before using this
 * function, or any of the conversion functions.
 */

final bool isNumeric(in char[] s, in bool bAllowSep = false);

/// Allow any object as a parameter
bool isNumeric(...);

/// Check only the first parameter, all others will be ignored. 
bool isNumeric(TypeInfo[] _arguments, va_list _argptr);

/*****************************
 * Soundex algorithm.
 *
 * The Soundex algorithm converts a word into 4 characters
 * based on how the word sounds phonetically. The idea is that
 * two spellings that sound alike will have the same Soundex
 * value, which means that Soundex can be used for fuzzy matching
 * of names.
 *
 * Params:
 *	string = String to convert to Soundex representation.
 *	buffer = Optional 4 char array to put the resulting Soundex
 *		characters into. If null, the return value
 *		buffer will be allocated on the heap.
 * Returns:
 *	The four character array with the Soundex result in it.
 *	Returns null if there is no Soundex representation for the string.
 *
 * See_Also:
 *	$(LINK2 http://en.wikipedia.org/wiki/Soundex, Wikipedia),
 *	$(LINK2 http://www.archives.gov/publications/general-info-leaflets/55.html, The Soundex Indexing System)
 *
 * Bugs:
 *	Only works well with English names.
 *	There are other arguably better Soundex algorithms,
 *	but this one is the standard one.
 */

char[] soundex(char[] string, char[] buffer = null);


/***************************************************
 * Construct an associative array consisting of all
 * abbreviations that uniquely map to the strings in values.
 *
 * This is useful in cases where the user is expected to type
 * in one of a known set of strings, and the program will helpfully
 * autocomplete the string once sufficient characters have been
 * entered that uniquely identify it.
 * Example:
 * ---
 * import std.stdio;
 * import std.string;
 * 
 * void main()
 * {
 *    static char[][] list = [ "food", "foxy" ];
 * 
 *    auto abbrevs = std.string.abbrev(list);
 * 
 *    foreach (key, value; abbrevs)
 *    {
 *       writefln("%s => %s", key, value);
 *    }
 * }
 * ---
 * produces the output:
 * <pre>
 * fox =&gt; foxy
 * food =&gt; food
 * foxy =&gt; foxy
 * foo =&gt; food
 * </pre>
 */

char[][char[]] abbrev(char[][] values);

/******************************************
 * Compute column number after string if string starts in the
 * leftmost column, which is numbered starting from 0.
 */

size_t column(char[] string, int tabsize = 8);
/******************************************
 * Wrap text into a paragraph.
 *
 * The input text string s is formed into a paragraph
 * by breaking it up into a sequence of lines, delineated
 * by \n, such that the number of columns is not exceeded
 * on each line.
 * The last line is terminated with a \n.
 * Params:
 *	s = text string to be wrapped
 *	columns = maximum number of _columns in the paragraph
 *	firstindent = string used to _indent first line of the paragraph
 *	indent = string to use to _indent following lines of the paragraph
 *	tabsize = column spacing of tabs
 * Returns:
 *	The resulting paragraph.
 */

char[] wrap(char[] s, int columns = 80, char[] firstindent = null,
	char[] indent = null, int tabsize = 8);

/***************************
 * Does string s[] start with an email address?
 * Returns:
 *	null	it does not
 *	char[]	it does, and this is the slice of s[] that is that email address
 * References:
 *	RFC2822
 */
char[] isEmail(char[] s);

/***************************
 * Does string s[] start with a URL?
 * Returns:
 *	null	it does not
 *	char[]	it does, and this is the slice of s[] that is that URL
 */

char[] isURL(char[] s);

// convert uint to char[], within the given buffer
// Returns a valid slice of the populated buffer
char[] intToUtf8 (char[] tmp, uint val);
// convert uint to char[], within the given buffer
// Returns a valid slice of the populated buffer
char[] ulongToUtf8 (char[] tmp, ulong val);

// function to compare two strings
alias cmp stringCompare;

