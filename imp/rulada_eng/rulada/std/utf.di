// utf.d

/*
 *  Copyright (C) 2003-2004 by Digital Mars, www.digitalmars.com
 *  Written by Walter Bright
 *
 *  This software is provided 'as-is', without any express or implied
 *  warranty. In no event will the authors be held liable for any damages
 *  arising from the use of this software.
 *
 *  Permission is granted to anyone to use this software for any purpose,
 *  including commercial applications, and to alter it and redistribute it
 *  freely, subject to the following restrictions:
 *
 *  o  The origin of this software must not be misrepresented; you must not
 *     claim that you wrote the original software. If you use this software
 *     in a product, an acknowledgment in the product documentation would be
 *     appreciated but is not required.
 *  o  Altered source versions must be plainly marked as such, and must not
 *     be misrepresented as being the original software.
 *  o  This notice may not be removed or altered from any source
 *     distribution.
 */

/********************************************
 * Кодировать и декодировать строки UTF-8, UTF-16 и UTF-32.
 *
 * Для систем Win32 тип Си wchar_t является UTF-16 и соответствует типу Ди
 * wchar.
 * Для систем linux, тип Си wchar_t является UTF-32 и соответствует
 * типу Ди utf.dchar. 
 *
 * Поддержка символов UTF ограничена пределом (\u0000 &lt;= character &lt;= \U0010FFFF).
 *
 * See_Also:
 *	$(LINK2 http://en.wikipedia.org/wiki/Unicode, Wikipedia)<br>
 *	$(LINK http://www.cl.cam.art.core.stdc.uk/~mgk25/unicode.html#utf-8)<br>
 *	$(LINK http://anubis.dkuug.dk/JTC1/SC2/WG2/docs/n1335)
 * Macros:
 *	WIKI = Phobos/StdUtf
 */
 
module std.utf;

//private import rt.core.io;
import std.exception;
import std.c, os.windows;

alias wchar* wptr;

//debug=utf;		// uncomment to turn on debugging printf's

extern (C) void onUnicodeError( char[] msg, size_t idx );
alias onUnicodeError приОшУни;
deprecated class UtfError: Error
{
    size_t idx;	// index in string of where error occurred

    this(char[] s, size_t i)
    {
	idx = i;
	super(s);
    }
}

/**********************************
 * Класс исключения, выводимого при каких-либо ошибках.
 */

class UtfException : Exception
{
    size_t idx;	/// index in string of where error occurred

    this(char[] s, size_t i)
    {
	idx = i;
	super(s);
    }
}
alias UtfException ИсклУтш;

class ИсключениеУТФ:Исключение
{
т_мера индкс;
this(char[] s, size_t i){индкс = i; super("Conversion failed"~s);
wchar* soob =cast(wchar*)("Неудачная операция с кодировкой UTF\n"~toUTF16(s));
ОкноСооб(null, cast(wchar*) soob, "D рантайм:ИсключениеУТФ", СО_ОК|СО_ПИКТОШИБКА);}
}

/*******************************
 * Проверка на то, является ли c действительным символом UTF-32.
 *
 * \uFFFE и \uFFFF рассматриваются этой функцией соответствующими,
 * так как они допускаются для внутреннего использования в приложении,
 * но они не допустимы для взаимозамены по стандарту Unicode.
 *
 * Возвращает: true if it is, false if not.
 */

bool isValidDchar(dchar c);
alias isValidDchar реальноДсим_ли;

ubyte[256] UTF8stride =
[
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
    3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
    4,4,4,4,4,4,4,4,5,5,5,5,6,6,0xFF,0xFF,
];

/**
 * stride() возвращает длину последовательности UTF-8, начиная с индекса i
 * в строке s.
 * Возвращает:
 *	Число байтов в последовательности UTF-8 или
 *	0xFF, означающее, что s[i] не есть начало последовательности UTF-8.
 */

uint stride(char[] s, size_t i);

/**
 * stride() возвращает длину последовательности UTF-16, начиная с индекса i
 * в строке s.
 */

uint stride(wchar[] s, size_t i);

/**
 * stride() возвращает длину последовательности UTF-32, начиная с индекса i
 * в строке s.
 * Возвращает: возвращаемое значение всегда будет равно 1.
 */

uint stride(dchar[] s, size_t i);
alias stride пролёт;
/*******************************************
 * Given an index i into an array of characters s[],
 * and assuming that index i is at the start of a UTF character,
 * determine the number of UCS characters up to that index i.
 */

size_t toUCSindex(char[] s, size_t i);
/** ditto */

size_t toUCSindex(wchar[] s, size_t i);
/** ditto */

size_t toUCSindex(dchar[] s, size_t i);

alias toUCSindex вИндексУНC;//Универсальный Набор Символов
/******************************************
 * Given a UCS index n into an array of characters s[], return the UTF index.
 */

size_t toUTFindex(char[] s, size_t n);
/** ditto */

size_t toUTFindex(wchar[] s, size_t n);
/** ditto */

size_t toUTFindex(dchar[] s, size_t n);

alias toUTFindex вИндексУТШ;//Универсальный TrueType Шрифт
/* =================== Decode ======================= */

/***************
 * Decodes and returns character starting at s[idx]. idx is advanced past the
 * decoded character. If the character is not well formed, a UtfException is
 * thrown and idx remains unchanged.
 */

dchar decode(char[] s, inout size_t idx);

/** ditto */

dchar decode(in wchar[] s, inout size_t idx);

/** ditto */

dchar decode(in dchar[] s, inout size_t idx);
alias decode раскодируй;
/* =================== Encode ======================= */

/*******************************
 * Encodes character c and appends it to array s[].
 */

void encode(inout char[] s, dchar c);

/** ditto */

void encode(inout wchar[] s, dchar c);

/** ditto */
void encode(inout dchar[] s, dchar c);

alias encode кодируй;
/* =================== Validation ======================= */

/***********************************
 * Checks to see if string is well formed or not. Throws a UtfException if it is
 * not. Use to check all untrusted input for correctness.
 */

void validate(char[] s);
/** ditto */

void validate(wchar[] s);

/** ditto */

void validate(dchar[] s);

alias validate оцени;
/* =================== Conversion to UTF8 ======================= */

char[] toUTF8(char[4] buf, dchar c);

/*******************
 * Encodes string s into UTF-8 and returns the encoded string.
 */

char[] toUTF8(char[] s);

/** ditto */

char[] toUTF8(wchar[] s);

/** ditto */

char[] toUTF8(dchar[] s);
alias toUTF8 вУТШ8;
/* =================== Conversion to UTF16 ======================= */

wchar[] toUTF16(wchar[2] buf, dchar c);

/****************
 * Encodes string s into UTF-16 and returns the encoded string.
 * toUTF16z() is suitable for calling the 'W' functions in the Win32 API that take
 * an LPWSTR or LPCWSTR argument.
 */

wchar[] toUTF16(char[] s);
/** ditto */

wchar* toUTF16z(char[] s);
/** ditto */

wchar[] toUTF16(wchar[] s);
/** ditto */

wchar[] toUTF16(dchar[] s);
alias toUTF16 вУТШ16;
/* =================== Conversion to UTF32 ======================= */

/*****
 * Encodes string s into UTF-32 and returns the encoded string.
 */

dchar[] toUTF32(char[] s);

/** ditto */

dchar[] toUTF32(wchar[] s);
/** ditto */

dchar[] toUTF32(dchar[] s);
alias toUTF32 вУТШ32;
/* ================================ tests ================================== */


/**
 * Простые функции для классификации символов Unicode.
 * Для классификации ASCII смотрите $(LINK2 std_rt.coretype.html, ctype).
 * Macros:
 *	WIKI=Phobos/StdUni
 * Ссылки:
 *	$(LINK2 http://www.digitalmars.com/d/ascii-table.html, ASCII Table),
 *	$(LINK2 http://en.wikipedia.org/wiki/Unicode, Wikipedia),
 *	$(LINK2 http://www.unicode.org, The Unicode Consortium)
 * Trademarks:
 *	Unicode(tm) is a trademark of Unicode, Inc.
 */

