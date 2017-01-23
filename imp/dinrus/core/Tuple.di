/**
 * The tuple module defines a template struct used for arbitrary данные grouping.
 *
 * Copyright: Copyright (C) 2005-2006 Sean Kelly.  все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Walter Bright, Sean Kelly
 */
module core.Tuple;


/**
 * Кортеж -из_ набор типизированных значений.  Tuples are useful for returning
 * a установи of values из_ a function or for passing a установи of параметры в_ a
 * function.
 *
 * NOTE: Since the transition из_ пользователь-defined в_ built-in tuples, the ability
 *       в_ return tuples из_ a function есть been lost.  Until this issue is
 *       адресed within the language, tuples must be enclosed in a struct
 *       if they are в_ be returned из_ a function.
 *
 * Example:
 * ----------------------------------------------------------------------
 *
 * alias Кортеж!(цел, реал) T1;
 * alias Кортеж!(цел, дол) T2;
 * struct Wrap( Vals... )
 * {
 *     Vals знач;
 * }
 *
 * Wrap!(T2) func( T1 знач )
 * {
 *     Wrap!(T2) возвр;
 *     возвр.знач[0] = знач[0];
 *     возвр.знач[1] = знач[0] * cast(дол) знач[1];
 *     return возвр;
 * }
 *
 * ----------------------------------------------------------------------
 *
 * This is the original tuple example, and demonstates what should be possible
 * with tuples.  Hopefully, language support will be добавьed for this feature
 * soon.
 *
 * Example:
 * ----------------------------------------------------------------------
 *
 * alias Кортеж!(цел, реал) T1;
 * alias Кортеж!(цел, дол) T2;
 *
 * T2 func( T1 знач )
 * {
 *     T2 возвр;
 *     возвр[0] = знач[0];
 *     возвр[1] = знач[0] * cast(дол) знач[1];
 *     return возвр;
 * }
 *
 *
 * // tuples may be composed
 * alias Кортеж!(цел) IntTuple;
 * alias Кортеж!(IntTuple, дол) RetTuple;
 *
 * // tuples are equivalent в_ a установи of function параметры of the same тип
 * RetTuple t = func( 1, 2.3 );
 *
 * ----------------------------------------------------------------------
 */
template Кортеж( СписокТ... )
{
    alias СписокТ Кортеж;
}


/**
 * Returns the индекс of the first occurrence of T in СписокТ or Tlist.length if
 * не найден.
 */
template ИндексУ( T, СписокТ... )
{
    static if( СписокТ.length == 0 )
        const т_мера ИндексУ = 0;
    else static if( is( T == СписокТ[0] ) )
        const т_мера ИндексУ = 0;
    else
        const т_мера ИндексУ = 1 + ИндексУ!( T, СписокТ[1 .. $] );
}


/**
 * Returns a Кортеж with the first occurrence of T removed из_ СписокТ.
 */
template Удали( T, СписокТ... )
{
    static if( СписокТ.length == 0 )
        alias СписокТ Удали;
    else static if( is( T == СписокТ[0] ) )
        alias СписокТ[1 .. $] Удали;
    else
        alias Кортеж!( СписокТ[0], Удали!( T, СписокТ[1 .. $] ) ) Удали;
}


/**
 * Returns a Кортеж with все occurrences of T removed из_ СписокТ.
 */
template УдалиВсе( T, СписокТ... )
{
    static if( СписокТ.length == 0 )
        alias СписокТ УдалиВсе;
    else static if( is( T == СписокТ[0] ) )
        alias .УдалиВсе!( T, СписокТ[1 .. $] ) УдалиВсе;
    else
        alias Кортеж!( СписокТ[0], .УдалиВсе!( T, СписокТ[1 .. $] ) ) УдалиВсе;
}


/**
 * Returns a Кортеж with the first offuccrence of T replaced with U.
 */
template Замени( T, U, СписокТ... )
{
    static if( СписокТ.length == 0 )
        alias СписокТ Замени;
    else static if( is( T == СписокТ[0] ) )
        alias Кортеж!(U, СписокТ[1 .. $]) Замени;
    else
        alias Кортеж!( СписокТ[0], Замени!( T, U, СписокТ[1 .. $] ) ) Замени;
}


/**
 * Returns a Кортеж with все occurrences of T replaced with U.
 */
template ЗамениВсе( T, U, СписокТ... )
{
    static if( СписокТ.length == 0 )
        alias СписокТ ЗамениВсе;
    else static if( is( T == СписокТ[0] ) )
        alias Кортеж!( U, ЗамениВсе!( T, U, СписокТ[1 .. $] ) ) ЗамениВсе;
    else
        alias Кортеж!( СписокТ[0], ЗамениВсе!( T, U, СписокТ[1 .. $] ) ) ЗамениВсе;
}


/**
 * Returns a Кортеж with the типы из_ СписокТ declared in реверс order.
 */
template Реверсни( СписокТ... )
{
    static if( СписокТ.length == 0 )
        alias СписокТ Реверсни;
    else
        alias Кортеж!( Реверсни!( СписокТ[1 .. $]), СписокТ[0] ) Реверсни;
}


/**
 * Returns a Кортеж with все duplicate типы removed.
 */
template Уникум( СписокТ... )
{
    static if( СписокТ.length == 0 )
        alias СписокТ Уникум;
    else
        alias Кортеж!( СписокТ[0],
                      Уникум!( УдалиВсе!( СписокТ[0],
                                           СписокТ[1 .. $] ) ) ) Уникум;
}


/**
 * Returns the тип из_ СписокТ that is the most производный из_ T.  If no such
 * тип is найдено then T will be returned.
 */
template ФинПроизводный( T, СписокТ... )
{
    static if( СписокТ.length == 0 )
        alias T ФинПроизводный;
    else static if( is( СписокТ[0] : T ) )
        alias ФинПроизводный!( СписокТ[0], СписокТ[1 .. $] ) ФинПроизводный;
    else
        alias ФинПроизводный!( T, СписокТ[1 .. $] ) ФинПроизводный;
}


/**
 * Returns a Кортеж with the типы sorted so that the most производный типы are
 * ordered before the remaining типы.
 */
template ПроизводныеВперёд( СписокТ... )
{
    static if( СписокТ.length == 0 )
        alias СписокТ ПроизводныеВперёд;
    else
        alias Кортеж!( ФинПроизводный!( СписокТ[0], СписокТ[1 .. $] ),
                      ПроизводныеВперёд!( ЗамениВсе!( ФинПроизводный!( СписокТ[0], СписокТ[1 .. $] ),
                                                    СписокТ[0],
                                                    СписокТ[1 .. $] ) ) ) ПроизводныеВперёд;
}


/*
 * A brief тест of the above templates.
 */
static assert( 0 == ИндексУ!(цел, цел, плав, сим));
static assert( 1 == ИндексУ!(плав, цел, плав, сим));
static assert( 3 == ИндексУ!(дво, цел, плав, сим));

static assert( is( Удали!(цел, цел, плав, цел) == Удали!(проц, плав, цел) ) );
static assert( is( УдалиВсе!(цел, цел, плав, цел) == Удали!(проц, плав) ) );
static assert( is( Удали!(плав, цел, плав, цел) == Удали!(проц, цел, цел) ) );
static assert( is( Удали!(дво, цел, плав, цел) == Удали!(проц, цел, плав, цел) ) );

static assert( is( Замени!(цел, сим, цел, плав, цел) == Удали!(проц, сим, плав, цел) ) );
static assert( is( ЗамениВсе!(цел, сим, цел, плав, цел) == Удали!(проц, сим, плав, сим) ) );
static assert( is( Замени!(плав, сим, цел, плав, цел) == Удали!(проц, цел, сим, цел) ) );
static assert( is( Замени!(дво, сим, цел, плав, цел) == Удали!(проц, цел, плав, цел) ) );

static assert( is( Реверсни!(плав, плав[], дво, сим, цел) ==
                   Уникум!(цел, сим, дво, плав[], сим, цел, плав, дво) ) );

static assert( is( ФинПроизводный!(цел, дол, крат) == крат ) );
