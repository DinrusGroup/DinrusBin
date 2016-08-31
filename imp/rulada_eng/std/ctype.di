/*
 * Placed into the Public Domain.
 * Digital Mars, www.digitalmars.com
 * Written by Walter Bright
 */

/**
 * Простые функции для классификации символов ASCII.
 * Для классификации символов Unicode используйте $(LINK2 std_uni.html, std.uni).
 * References:
 *	$(LINK2 http://www.digitalmars.com/d/ascii-table.html, ASCII Table),
 *	$(LINK2 http://en.wikipedia.org/wiki/Ascii, Wikipedia)
 * Macros:
 *	WIKI=Phobos/StdCtype
 */

module std.ctype;

/**
 * Returns !=0 if c is a letter in the range (0..9, a..z, A..Z).
 */
int isalnum(dchar c);
alias isalnum числобукв_ли;
/**
 * Returns !=0 if c is an ascii upper or lower case letter.
 */
int isalpha(dchar c);
alias isalpha буква_ли;
/**
 * Returns !=0 if c is a control character.
 */
int iscntrl(dchar c);
alias iscntrl управ_ли;
/**
 * Returns !=0 if c is a digit.
 */
int isdigit(dchar c);
alias isdigit цифра_ли;
/**
 * Returns !=0 if c is lower case ascii letter.
 */
int islower(dchar c);
alias islower пропись_ли;
/**
 * Returns !=0 if c is a punctuation character.
 */
int ispunct(dchar c);
alias ispunct пунктзнак_ли;
/**
 * Returns !=0 if c is a space, tab, vertical tab, form feed,
 * carriage return, or linefeed.
 */
int isspace(dchar c);
alias isspace межбукв_ли;
/**
 * Returns !=0 if c is an upper case ascii character.
 */
int isupper(dchar c);
alias isupper заглавн_ли;
/**
 * Returns !=0 if c is a hex digit (0..9, a..f, A..F).
 */
int isxdigit(dchar c);
alias isxdigit цифраикс_ли;
/**
 * Returns !=0 if c is a printing character except for the space character.
 */
int isgraph(dchar c);
alias isgraph граф_ли;
/**
 * Returns !=0 if c is a printing character including the space character.
 */
int isprint(dchar c);
alias isprint печат_ли;
/**
 * Returns !=0 if c is in the ascii character set, i.e. in the range 0..0x7F.
 */
int isascii(dchar c);
alias isascii аски_ли;

/**
 * If c is an upper case ascii character,
 * return the lower case equivalent, otherwise return c.
 */
dchar tolower(dchar c);
alias tolower впроп;
/**
 * If c is a lower case ascii character,
 * return the upper case equivalent, otherwise return c.
 */
dchar toupper(dchar c);
alias toupper взаг;

int isruslower(dchar c);
цел руспроп_ли(дим c);

int isrusupper(dchar c);
цел русзаг_ли(дим c);
private:

enum
{
    _SPC =	8,
    _CTL =	0x20,
    _BLK =	0x40,
    _HEX =	0x80,
    _UC  =	1,
    _LC  =	2,
    _PNC =	0x10,
    _DIG =	4,
    _ALP =	_UC|_LC,
}

ubyte _ctype[128] =
[
	_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,
	_CTL,_CTL|_SPC,_CTL|_SPC,_CTL|_SPC,_CTL|_SPC,_CTL|_SPC,_CTL,_CTL,
	_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,
	_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,_CTL,
	_SPC|_BLK,_PNC,_PNC,_PNC,_PNC,_PNC,_PNC,_PNC,
	_PNC,_PNC,_PNC,_PNC,_PNC,_PNC,_PNC,_PNC,
	_DIG|_HEX,_DIG|_HEX,_DIG|_HEX,_DIG|_HEX,_DIG|_HEX,
	_DIG|_HEX,_DIG|_HEX,_DIG|_HEX,_DIG|_HEX,_DIG|_HEX,
	_PNC,_PNC,_PNC,_PNC,_PNC,_PNC,
	_PNC,_UC|_HEX,_UC|_HEX,_UC|_HEX,_UC|_HEX,_UC|_HEX,_UC|_HEX,_UC,
	_UC,_UC,_UC,_UC,_UC,_UC,_UC,_UC,
	_UC,_UC,_UC,_UC,_UC,_UC,_UC,_UC,
	_UC,_UC,_UC,_PNC,_PNC,_PNC,_PNC,_PNC,
	_PNC,_LC|_HEX,_LC|_HEX,_LC|_HEX,_LC|_HEX,_LC|_HEX,_LC|_HEX,_LC,
	_LC,_LC,_LC,_LC,_LC,_LC,_LC,_LC,
	_LC,_LC,_LC,_LC,_LC,_LC,_LC,_LC,
	_LC,_LC,_LC,_PNC,_PNC,_PNC,_PNC,_CTL
];


unittest
{
    assert(isspace(' '));
    assert(!isspace('z'));
    assert(toupper('a') == 'A');
    assert(tolower('Q') == 'q');
    assert(!isxdigit('G'));
}
