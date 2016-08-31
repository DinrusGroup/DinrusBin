
// Written in the D programming language.

/*
 * Placed into the Public Domain.
 * Digital Mars, www.digitalmars.com
 * Written by Walter Bright
 */

/**
 * Simple Unicode character classification functions.
 * For ASCII classification, see $(LINK2 std_ctype.html, std.ctype).
 * Macros:
 *	WIKI=Phobos/StdUni
 * References:
 *	$(LINK2 http://www.digitalmars.com/d/ascii-table.html, ASCII Table),
 *	$(LINK2 http://en.wikipedia.org/wiki/Unicode, Wikipedia),
 *	$(LINK2 http://www.unicode.org, The Unicode Consortium)
 * Trademarks:
 *	Unicode(tm) is a trademark of Unicode, Inc.
 */

module std.uni;
/**
 * Возвращает !=0, если c является символом Unicode нижнего регистра.
 */
int isUniLower(dchar c);
alias isUniLower пропУни_ли;
/**
 * Возвращает !=0, если c является символом Unicode верхнего регистра.
 */
int isUniUpper(dchar c);
alias isUniUpper загУни_ли;
/**
 * Если c есть символ Unicode верхнего регистра, то возвратит его эквивалент
 * нижнего регистра, иначе вернет c.
 */
dchar toUniLower(dchar c);
alias toUniLower вУнипроп;

/**
 * Если c есть символ Unicode нижнего регистра, то вернет его эквивалент
 * верхнего регистра, в противном случае вернет c.
 */
dchar toUniUpper(dchar c);
alias toUniUpper вУнизаг;

/*******************************
 * Return !=0 if u is a Unicode alpha character.
 * (general Unicode category: Lu, Ll, Lt, Lm and Lo)
 *
 * Standards: Unicode 5.0.0
 */

int isUniAlpha(dchar u);
alias isUniAlpha цифрабуквУни_ли;