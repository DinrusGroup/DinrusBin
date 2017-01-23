/**
 * This module provопрes a templated function that performs значение-preserving
 * conversions between arbitrary типы.  This function's behaviour can be
 * extended for пользователь-defined типы as needed.
 *
 * Copyright:   Copyright &копируй; 2007 Daniel Keep.
 * License:     BSD стиль: $(LICENSE)
 * Authors:     Daniel Keep
 * Credits:     Inspired in часть by Andrei Alexandrescu's work on std.conv.
 */

module util.Convert;

private import exception;
private import core.Traits;
private import core.Tuple : Кортеж;

private import math.Math;
private import text.convert.Utf;
private import text.convert.Float;
private import text.convert.Integer;

private import Ascii = text.Ascii;

version( TangoDoc )
{
    /**
     * Attempts в_ perform a значение-preserving conversion of the given значение
     * из_ тип S в_ тип D.  If the conversion cannot be performed in any
     * контекст, a компилируй-время ошибка will be issued describing the типы
     * involved.  If the conversion fails at run-время because the destination
     * тип could not represent the значение being преобразованый, a
     * ИсклПреобразования will be thrown.
     *
     * For example, в_ преобразуй the ткст "123" преобр_в an equivalent целое
     * значение, you would use:
     *
     * -----
     * auto v = в_!(цел)("123");
     * -----
     *
     * You may also specify a default значение which should be returned in the
     * событие that the conversion cannot take place:
     *
     * -----
     * auto v = в_!(цел)("abc", 456);
     * -----
     *
     * The function will attempt в_ preserve the ввод значение as exactly as
     * possible, given the limitations of the destination форматируй.  For
     * экземпляр, converting a floating-точка значение в_ an целое will cause it
     * в_ округли the значение в_ the nearest целое значение.
     *
     * Below is a complete список of conversions between built-in типы and
     * strings.  Capitalised names indicate classes of типы.  Conversions
     * between типы in the same class are also possible.
     *
     * -----
     * бул         <-- Целое (0/!0), Char ('t'/'f'), Строка ("да"/"нет")
     * Целое      <-- бул, Real, Char ('0'-'9'), Строка
     * Real         <-- Целое, Строка
     * Imaginary    <-- Complex
     * Complex      <-- Целое, Real, Imaginary
     * Char         <-- бул, Целое (0-9)
     * Строка       <-- бул, Целое, Real, Char
     * -----
     *
     * Conversions between массивы and associative массивы are also supported,
     * and are готово element-by-element.
     *
     * You can добавь support for значение conversions в_ your типы by defining
     * appropriate static and экземпляр member functions.  Given a тип
     * the_type, any of the following члены of a тип T may be used:
     *
     * -----
     * the_type to_the_type();
     * static T from_the_type(the_type);
     * -----
     *
     * You may also use "camel case" names:
     *
     * -----
     * the_type toTheType();
     * static T fromTheType(the_type);
     * -----
     *
     * Arrays and associative массивы can also be explicitly supported:
     *
     * -----
     * the_type[] to_the_type_array();
     * the_type[] toTheTypeArray();
     *
     * static T from_the_type_array(the_type[]);
     * static T fromTheTypeArray(the_type[]);
     *
     * the_type[цел] to_int_to_the_type_map();
     * the_type[цел] toIntToTheTypeMap();
     *
     * static T from_int_to_the_type_map(the_type[цел]);
     * static T fromIntToTheTypeMap(the_type[цел]);
     * -----
     *
     * If you have ещё комплексное requirements, you can also use the generic в_
     * and из_ templated члены:
     *
     * -----
     * the_type в_(the_type)();
     * static T из_(the_type)(the_type);
     * -----
     *
     * These templates will have the_type explicitly passed в_ them in the
     * template instantiation.
     *
     * Finally, strings are given special support.  The following члены will
     * be checked for:
     *
     * -----
     * ткст  вТкст();
     * шим[] вТкст16();
     * дим[] toString32();
     * ткст  вТкст();
     * -----
     *
     * The "toString_" метод corresponding в_ the destination ткст тип will be
     * tried first.  If this метод does not exist, then the function will
     * look for другой "toString_" метод из_ which it will преобразуй the результат.
     * Failing this, it will try "вТкст" and преобразуй the результат в_ the
     * appropriate кодировка.
     *
     * The rules for converting в_ a пользовательский тип are much the same,
     * except it makes use of the "fromUtf8", "fromUtf16", "fromUtf32" and
     * "fromString" static methods.
     *
     * Note: This module содержит imports в_ другой Dinrus modules that needs
     * semantic analysis в_ be discovered. If your build tool doesn't do this
     * properly, causing компилируй or link время problems, import the relevant 
     * module explicitly.
     */
    D в_(D,S)(S значение);
    D в_(D,S)(S значение, D default_); /// ditto
}
else
{
    template в_(D)
    {
        D в_(S, Def=Missing)(S значение, Def def=Def.init)
        {
            static if( is( Def == Missing ) )
                return toImpl!(D,S)(значение);

            else
            {
                try
                {
                    return toImpl!(D,S)(значение);
                }
                catch( ИсклПреобразования e )
                    {}

                return def;
            }
        }
    }
}

/**
 * This исключение is thrown when the в_ template is unable в_ perform a
 * conversion at run-время.  This typically occurs when the источник значение cannot
 * be represented in the destination тип.  This исключение is also thrown when
 * the conversion would cause an over- or недобор.
 */
class ИсклПреобразования : Исключение
{
    this( ткст сооб )
    {
        super( сооб );
    }
}

private:

typedef цел Missing;

/*
 * So, как is this module structured?
 *
 * Firstly, we need a bunch of support код.  The first block of this содержит
 * some CTFE functions for ткст manИПulation (в_ cut down on the число of
 * template symbols we generate.)
 *
 * The следщ содержит a boat-загрузи of templates.  Most of these are trait
 * templates (things like isPOD, объект_ли, etc.)  There are also a число of
 * mixins, and some switching templates (like toString_(n).)
 *
 * другой thing в_ mention is intCmp, which performs a safe сравнение
 * between two целыйs of arbitrary размер and signage.
 *
 * Following все this are the templated в_* implementations.
 *
 * The actual toImpl template is the сукунда последний thing in the module, with the
 * module unit tests coming последний.
 */

сим ctfe_upper(сим c)
{
    if( 'a' <= c && c <= 'z' )
        return cast(сим)((c - 'a') + 'A');
    else
        return c;
}

ткст ctfe_camelCase(ткст s)
{
    ткст результат;

    бул nextIsCapital = да;

    foreach( c ; s )
    {
        if( nextIsCapital )
        {
            if( c == '_' )
                результат ~= c;
            else
            {
                результат ~= ctfe_upper(c);
                nextIsCapital = нет;
            }
        }
        else
        {
            if( c == '_' )
                nextIsCapital = да;
            else
                результат ~= c;
        }
    }

    return результат;
}

бул ctfe_isSpace(T)(T c)
{
    static if (T.sizeof is 1)
        return (c <= 32 && (c is ' ' | c is '\t' | c is '\r'
                    | c is '\n' | c is '\v' | c is '\f'));
    else
        return (c <= 32 && (c is ' ' | c is '\t' | c is '\r'
                    | c is '\n' | c is '\v' | c is '\f'))
            || (c is '\u2028' | c is '\u2029');
}

T[] ctfe_triml(T)(T[] источник)
{
    if( источник.length == 0 )
        return пусто;

    foreach( i,c ; источник )
        if( !ctfe_isSpace(c) )
            return источник[i..$];

    return пусто;
}

T[] ctfe_trimr(T)(T[] источник)
{
    if( источник.length == 0 )
        return пусто;

    foreach_reverse( i,c ; источник )
        if( !ctfe_isSpace(c) )
            return источник[0..i+1];

    return пусто;
}

T[] ctfe_trim(T)(T[] источник)
{
    return ctfe_trimr(ctfe_triml(источник));
}

template isPOD(T)
{
    static if( is( T == struct ) || is( T == union ) )
        const isPOD = да;
    else
        const isPOD = нет;
}

template объект_ли(T)
{
    static if( is( T == class ) || is( T == interface ) )
        const объект_ли = да;
    else
        const объект_ли = нет;
}

template isUDT(T)
{
    const isUDT = isPOD!(T) || объект_ли!(T);
}

template ткст_ли(T)
{
    static if( is( typeof(T[]) == ткст )
            || is( typeof(T[]) == шим[] )
            || is( typeof(T[]) == дим[] ) )
        const ткст_ли = да;
    else
        const ткст_ли = нет;
}

template типМассив_ли(T)
{
    const типМассив_ли = типДинМас_ли!(T) || типСтатМас_ли!(T);
}

/*
 * Determines which signed целое тип of T and U is larger.
 */
template sintSuperType(T,U)
{
    static if( is( T == дол ) || is( U == дол ) )
        alias дол sintSuperType;
    else static if( is( T == цел ) || is( U == цел ) )
        alias цел sintSuperType;
    else static if( is( T == крат ) || is( U == крат ) )
        alias крат sintSuperType;
    else static if( is( T == байт ) || is( U == байт ) )
        alias байт sintSuperType;
}

/*
 * Determines which unsigned целое тип of T and U is larger.
 */
template бцелSuperType(T,U)
{
    static if( is( T == бдол ) || is( U == бдол ) )
        alias бдол бцелSuperType;
    else static if( is( T == бцел ) || is( U == бцел ) )
        alias бцел бцелSuperType;
    else static if( is( T == бкрат ) || is( U == бкрат ) )
        alias бкрат бцелSuperType;
    else static if( is( T == ббайт ) || is( U == ббайт ) )
        alias ббайт бцелSuperType;
}

template бцелOfSize(бцел байты)
{
    static if( байты == 1 )
        alias ббайт бцелOfSize;
    else static if( байты == 2 )
        alias бкрат бцелOfSize;
    else static if( байты == 4 )
        alias бцел бцелOfSize;
}

/*
 * Safely performs a сравнение between two целое values, taking преобр_в
 * account different sizes and signages.
 */
цел intCmp(T,U)(T lhs, U rhs)
{
    static if( типЦел_ли!(T) && типЦел_ли!(U) )
    {
        alias sintSuperType!(T,U) S;
        auto l = cast(S) lhs;
        auto r = cast(S) rhs;
        if( l < r ) return -1;
        else if( l > r ) return 1;
        else return 0;
    }
    else static if( типБЦел_ли!(T) && типБЦел_ли!(U) )
    {
        alias бцелSuperType!(T,U) S;
        auto l = cast(S) lhs;
        auto r = cast(S) rhs;
        if( l < r ) return -1;
        else if( l > r ) return 1;
        else return 0;
    }
    else
    {
        static if( типЦел_ли!(T) )
        {
            if( lhs < 0 )
                return -1;
            else
            {
                static if( U.sizeof >= T.sizeof )
                {
                    auto l = cast(U) lhs;
                    if( l < rhs ) return -1;
                    else if( l > rhs ) return 1;
                    else return 0;
                }
                else
                {
                    auto l = cast(бдол) lhs;
                    auto r = cast(бдол) rhs;
                    if( l < r ) return -1;
                    else if( l > r ) return 1;
                    else return 0;
                }
            }
        }
        else static if( типЦел_ли!(U) )
        {
            if( rhs < 0 )
                return 1;
            else
            {
                static if( T.sizeof >= U.sizeof )
                {
                    auto r = cast(T) rhs;
                    if( lhs < r ) return -1;
                    else if( lhs > r ) return 1;
                    else return 0;
                }
                else
                {
                    auto l = cast(бдол) lhs;
                    auto r = cast(бдол) rhs;
                    if( l < r ) return -1;
                    else if( l > r ) return 1;
                    else return 0;
                }
            }
        }
    }
}

template unsupported(ткст desc="")
{
    static assert(нет, "Unsupported conversion: cannot преобразуй в_ "
            ~ctfe_trim(D.stringof)~" из_ "
            ~(desc!="" ? desc~" " : "")~ctfe_trim(S.stringof)~".");
}

template unsupported_backwards(ткст desc="")
{
    static assert(нет, "Unsupported conversion: cannot преобразуй в_ "
            ~(desc!="" ? desc~" " : "")~ctfe_trim(D.stringof)
            ~" из_ "~ctfe_trim(S.stringof)~".");
}

// TN works out the c_case имя of the given тип.
template TN(T:T[])
{
    static if( is( T == сим ) )
        const TN = "ткст";
    else static if( is( T == шим ) )
        const TN = "wstring";
    else static if( is( T == дим ) )
        const TN = "dstring";
    else
        const TN = TN!(T)~"_array";
}

// ditto
template TN(T:T*)
{
    const TN = TN!(T)~"_pointer";
}

// ditto
template TN(T)
{
    static if( типАссоцМассив_ли!(T) )
        const TN = TN!(typeof(T.ключи[0]))~"_to_"
            ~TN!(typeof(T.values[0]))~"_map";
    else
        const TN = ctfe_trim(T.stringof);
}

// Picks an appropriate вТкст* метод из_ t.текст.преобразуй.Utf.
template toString_(T)
{
    static if( is( T == ткст ) )
        alias text.convert.Utf.вТкст toString_;

    else static if( is( T == шим[] ) )
        alias text.convert.Utf.вТкст16 toString_;

    else
        alias text.convert.Utf.toString32 toString_;
}

template UtfNum(T)
{
    const UtfNum = is(typeof(T[0])==сим) ? "8" : (
            is(typeof(T[0])==шим) ? "16" : "32");
}

template StringNum(T)
{
    const StringNum = is(typeof(T[0])==сим) ? "" : (
            is(typeof(T[0])==шим) ? "16" : "32");
}

// Decodes a single дим character из_ a ткст.  Yes, I know they're
// actually код points, but I can't be Всёered в_ тип that much.  Although
// I suppose I just typed MORE than that by writing this коммент.  Meh.
дим firstCharOf(T)(T s, out т_мера used)
{
    static if( is( T : ткст ) || is( T : шим[] ) )
    {
        return text.convert.Utf.раскодируй(s, used);
    }
    else
    {
        used = 1;
        return s[0];
    }
}

// This mixin defines a general function for converting в_ a UDT.
template toUDT()
{
    D toDfromS()
    {
        static if( ткст_ли!(S) )
        {
            static if( is( typeof(mixin("D.fromUtf"
                                ~UtfNum!(S)~"(значение)")) : D ) )
                return mixin("D.fromUtf"~UtfNum!(S)~"(значение)");

            else static if( is( typeof(D.fromUtf8(""c)) : D ) )
                return D.fromUtf8(toString_!(ткст)(значение));

            else static if( is( typeof(D.fromUtf16(""w)) : D ) )
                return D.fromUtf16(toString_!(шим[])(значение));

            else static if( is( typeof(D.fromUtf32(""d)) : D ) )
                return D.fromUtf32(toString_!(дим[])(значение));

            else static if( is( typeof(D.fromString(""c)) : D ) )
            {
                static if( is( S == ткст ) )
                    return D.fromString(значение);

                else
                    return D.fromString(toString_!(ткст)(значение));
            }

            // Default fallbacks

            else static if( is( typeof(D.из_!(S)(значение)) : D ) )
                return D.из_!(S)(значение);

            else
                mixin unsupported!("пользовательский тип");
        }
        else
        {
            // TODO: Check for templates.  Dunno what в_ do about them.

            static if( is( typeof(mixin("D.from_"~TN!(S)~"()")) : D ) )
                return mixin("D.from_"~TN!(S)~"()");

            else static if( is( typeof(mixin("D.из_"
                                ~ctfe_camelCase(TN!(S))~"()")) : D ) )
                return mixin("D.из_"~ctfe_camelCase(TN!(S))~"()");

            else static if( is( typeof(D.из_!(S)(значение)) : D ) )
                return D.из_!(S)(значение);

            else
                mixin unsupported!("пользовательский тип");
        }
    }
}

// This mixin defines a general function for converting из_ a UDT.
template fromUDT(ткст fallthrough="")
{
    D toDfromS()
    {
        static if( ткст_ли!(D) )
        {
            static if( is( typeof(mixin("значение.вТкст"
                                ~StringNum!(D)~"()")) == D ) )
                return mixin("значение.вТкст"~StringNum!(D)~"()");

            else static if( is( typeof(значение.вТкст()) == ткст ) )
                return toString_!(D)(значение.вТкст);

            else static if( is( typeof(значение.вТкст16()) == шим[] ) )
                return toString_!(D)(значение.вТкст16);

            else static if( is( typeof(значение.toString32()) == дим[] ) )
                return toString_!(D)(значение.toString32);

            else static if( is( typeof(значение.вТкст()) == ткст ) )
            {
                static if( is( D == ткст ) )
                    return значение.вТкст;

                else
                {
                    return toString_!(D)(значение.вТкст);
                }
            }

            // Default fallbacks

            else static if( is( typeof(значение.в_!(D)()) : D ) )
                return значение.в_!(D)();

            else static if( fallthrough != "" )
                mixin(fallthrough);

            else
                mixin unsupported!("пользовательский тип");
        }
        else
        {
            // TODO: Check for templates.  Dunno what в_ do about them.

            static if( is( typeof(mixin("значение.to_"~TN!(D)~"()")) : D ) )
                return mixin("значение.to_"~TN!(D)~"()");

            else static if( is( typeof(mixin("значение.в_"
                                ~ctfe_camelCase(TN!(D))~"()")) : D ) )
                return mixin("значение.в_"~ctfe_camelCase(TN!(D))~"()");

            else static if( is( typeof(значение.в_!(D)()) : D ) )
                return значение.в_!(D)();

            else static if( fallthrough != "" )
                mixin(fallthrough);

            else
                mixin unsupported!("пользовательский тип");
        }
    }
}

template convError()
{
    проц throwConvError()
    {
        // Since we're going в_ use в_!(T) в_ преобразуй the значение в_ a ткст,
        // we need в_ сделай sure we don't конец up in a loop...
        static if( ткст_ли!(D) || !is( typeof(в_!(ткст)(значение)) == ткст ) )
        {
            throw new ИсклПреобразования("Could not преобразуй a значение of тип "
                    ~S.stringof~" в_ тип "~D.stringof~".");
        }
        else
        {
            throw new ИсклПреобразования("Could not преобразуй `"
                    ~в_!(ткст)(значение)~"` of тип "
                    ~S.stringof~" в_ тип "~D.stringof~".");
        }
    }
}

D вБул(D,S)(S значение)
{
    static assert(is(D==бул));

    static if( типЦелЧис_ли!(S) /+|| типРеал_ли!(S) || типМнимое_ли!(S)
                || типКомплекс_ли!(S)+/ )
        // The weird сравнение is в_ support НЧ as да
        return !(значение == 0);

    else static if( типСим_ли!(S) )
    {
        switch( значение )
        {
            case 'F': case 'f':
                return нет;

            case 'T': case 't':
                return да;

            default:
                mixin convError;
                throwConvError;
        }
    }

    else static if( ткст_ли!(S) )
    {
        switch( Ascii.toLower(значение) )
        {
            case "нет":
                return нет;

            case "да":
                return да;

            default:
                mixin convError;
                throwConvError;
        }
    }
    /+
    else static if( типДинМас_ли!(S) || типСтатМас_ли!(S) )
    {
        mixin unsupported!("Массив тип");
    }
    else static if( типАссоцМассив_ли!(S) )
    {
        mixin unsupported!("associative Массив тип");
    }
    else static if( типУк_ли!(S) )
    {
        mixin unsupported!("pointer тип");
    }
    else static if( is( S == typedef ) )
    {
        mixin unsupported!("typedef'ed тип");
    }
    // +/
    else static if( isPOD!(S) || объект_ли!(S) )
    {
        mixin fromUDT;
        return toDfromS;
    }
    else
    {
        mixin unsupported;
    }
}

D toIntegerFromInteger(D,S)(S значение)
{
    static if( (cast(бдол) D.max) < (cast(бдол) S.max)
            || (cast(дол) D.min) > (cast(дол) S.min) )
    {
        mixin convError; // TODO: Overflow ошибка

        if( intCmp(значение,D.min)<0 || intCmp(значение,D.max)>0 )
        {
            throwConvError;
        }
    }
    return cast(D) значение;
}

D toIntegerFromReal(D,S)(S значение)
{
    auto v = math.Math.округли(значение);
    if( (cast(реал) D.min) <= v && v <= (cast(реал) D.max) )
    {
        return cast(D) v;
    }
    else
    {
        mixin convError; // TODO: Overflow ошибка
        throwConvError;
    }
}

D toIntegerFromString(D,S)(S значение)
{
    static if( is( S charT : charT[] ) )
    {
        mixin convError;

        static if( is( D == бдол ) )
        {
            // Check for sign
            S s = значение;

            if( s.length == 0 )
                throwConvError;

            else if( s[0] == '-' )
                throwConvError;

            else if( s[0] == '+' )
                s = s[1..$];

            бцел длин;
            auto результат = text.convert.Integer.преобразуй(s, 10, &длин);

            if( длин < s.length || длин == 0 )
                throwConvError;

            return результат;
        }
        else
        {
            бцел длин;
            auto результат = text.convert.Integer.разбор(значение, 10, &длин);

            if( длин < значение.length || длин == 0 )
                throwConvError;

            return toIntegerFromInteger!(D,дол)(результат);
        }
    }
}

D toInteger(D,S)(S значение)
{
    static if( is( S == бул ) )
        return (значение ? 1 : 0);

    else static if( типЦелЧис_ли!(S) )
    {
        return toIntegerFromInteger!(D,S)(значение);
    }
    else static if( типСим_ли!(S) )
    {
        if( значение >= '0' && значение <= '9' )
        {
            return cast(D)(значение - '0');
        }
        else
        {
            mixin convError;
            throwConvError;
        }
    }
    else static if( типРеал_ли!(S) )
    {
        return toIntegerFromReal!(D,S)(значение);
    }
    else static if( ткст_ли!(S) )
    {
        return toIntegerFromString!(D,S)(значение);
    }
    else static if( isPOD!(S) || объект_ли!(S) )
    {
        mixin fromUDT;
        return toDfromS;
    }
    else
        mixin unsupported;
}

D вРеал(D,S)(S значение)
{
    /+static if( is( S == бул ) )
        return (значение ? 1.0 : 0.0);

    else+/ static if( типЦелЧис_ли!(S) || типРеал_ли!(S) )
        return cast(D) значение;

    /+else static if( типСим_ли!(S) )
        return cast(D) в_!(бцел)(значение);+/

    else static if( ткст_ли!(S) )
    {
        /+
        try
        {
            return text.convert.Float.toFloat(значение);
        }
        catch( ИсклНелегальногоАргумента e )
        {
            mixin convError;
            throwConvError;
        }
        +/

        mixin convError;

        бцел длин;
        auto r = text.convert.Float.разбор(значение, &длин);
        if( длин < значение.length || длин == 0 )
            throwConvError;

        return r;
    }

    else static if( isPOD!(S) || объект_ли!(S) )
    {
        mixin fromUDT;
        return toDfromS;
    }
    else
        mixin unsupported;
}

D toImaginary(D,S)(S значение)
{
    /+static if( is( S == бул ) )
        return (значение ? 1.0i : 0.0i);

    else+/ static if( типКомплекс_ли!(S) )
    {
        if( значение.re == 0.0 )
            return значение.im * cast(D)1.0i;

        else
        {
            mixin convError;
            throwConvError;
        }
    }
    else static if( isPOD!(S) || объект_ли!(S) )
    {
        mixin fromUDT;
        return toDfromS;
    }
    else
        mixin unsupported;
}

D toComplex(D,S)(S значение)
{
    static if( типЦелЧис_ли!(S) || типРеал_ли!(S) || типМнимое_ли!(S)
            || типКомплекс_ли!(S) )
        return cast(D) значение;

    /+else static if( типСим_ли!(S) )
        return cast(D) в_!(бцел)(значение);+/

    else static if( isPOD!(S) || объект_ли!(S) )
    {
        mixin fromUDT;
        return toDfromS;
    }
    else
        mixin unsupported;
}

D toChar(D,S)(S значение)
{
    static if( is( S == бул ) )
        return (значение ? 't' : 'f');

    else static if( типЦелЧис_ли!(S) )
    {
        if( значение >= 0 && значение <= 9 )
            return cast(D) значение+'0';

        else
        {
            mixin convError; // TODO: Overflow ошибка
            throwConvError;
        }
    }
    else static if( ткст_ли!(S) )
    {
        проц краш()
        {
            mixin convError;
            throwConvError;
        }

        if( значение.length == 0 )
            краш();

        else
        {
            т_мера used;
            дим c = firstCharOf(значение, used);

            if( used < значение.length )
            {
                краш(); // TODO: Overflow ошибка
            }

            if( (cast(т_мера) c) > (cast(т_мера) D.max) )
            {
                краш(); // TODO: Overflow ошибка
            }

            return cast(D) c;
        }
    }
    else static if( isPOD!(S) || объект_ли!(S) )
    {
        mixin fromUDT;
        return toDfromS;
    }
    else
        mixin unsupported;
}

D toStringFromString(D,S)(S значение)
{
    static if( is( typeof(D[0]) == сим ) )
        return text.convert.Utf.вТкст(значение);

    else static if( is( typeof(D[0]) == шим ) )
        return text.convert.Utf.вТкст16(значение);

    else
    {
        static assert( is( typeof(D[0]) == дим ) );
        return text.convert.Utf.toString32(значение);
    }
}

const ткст CHARS = 
"\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f"
"\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f"
"\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f"
"\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f"
"\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f"
"\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x7b\x7c\x7d\x7e";

D toStringFromChar(D,S)(S значение)
{
    static if( is( D == S[] ) )
    {
        static if( is( S == сим ) )
        {
            if( 0x20 <= значение && значение <= 0x7e )
                return (&CHARS[значение-0x20])[0..1];
        }
        auto r = new S[1];
        r[0] = значение;
        return r;
    }
    else
    {
        S[1] temp;
        temp[0] = значение;
        return toStringFromString!(D,S[])(temp);
    }
}

D вТкст(D,S)(S значение)
{
    static if( is( S == бул ) )
        return (значение ? "да" : "нет");

    else static if( типСим_ли!(S) )
        return toStringFromChar!(D,S)(значение);

    else static if( типЦелЧис_ли!(S) )
        // TODO: Make sure this works with ulongs.
        return mixin("text.convert.Integer.вТкст"~StringNum!(D)~"(значение)");

    else static if( типРеал_ли!(S) )
        return mixin("text.convert.Float.вТкст"~StringNum!(D)~"(значение)");

    else static if( типДинМас_ли!(S) || типСтатМас_ли!(S) )
        mixin unsupported!("Массив тип");

    else static if( типАссоцМассив_ли!(S) )
        mixin unsupported!("associative Массив тип");

    else static if( isPOD!(S) || объект_ли!(S) )
    {
        mixin fromUDT;
        return toDfromS;
    }
    else
        mixin unsupported;
}

D fromString(D,S)(D значение)
{
    static if( типДинМас_ли!(S) || типСтатМас_ли!(S) )
        mixin unsupported_backwards!("Массив тип");

    else static if( типАссоцМассив_ли!(S) )
        mixin unsupported_backwards!("associative Массив тип");

    else static if( isPOD!(S) || объект_ли!(S) )
    {
        mixin toUDT;
        return toDfromS;
    }
    else
        mixin unsupported_backwards;
}

D toArrayFromArray(D,S)(S значение)
{
    alias typeof(D[0]) De;

    D результат; результат.length = значение.length;
    scope(failure) delete результат;

    foreach( i,e ; значение )
        результат[i] = в_!(De)(e);

    return результат;
}

D toMapFromMap(D,S)(S значение)
{
    alias typeof(D.ключи[0])   Dk;
    alias typeof(D.values[0]) Dv;

    D результат;

    foreach( k,v ; значение )
        результат[ в_!(Dk)(k) ] = в_!(Dv)(v);

    return результат;
}

D toFromUDT(D,S)(S значение)
{
    // Try значение.в_* first
    static if( is( typeof(mixin("значение.to_"~TN!(D)~"()")) : D ) )
        return mixin("значение.to_"~TN!(D)~"()");

    else static if( is( typeof(mixin("значение.в_"
                        ~ctfe_camelCase(TN!(D))~"()")) : D ) )
        return mixin("значение.в_"~ctfe_camelCase(TN!(D))~"()");

    else static if( is( typeof(значение.в_!(D)()) : D ) )
        return значение.в_!(D)();

    // Ok, try D.из_* сейчас
    else static if( is( typeof(mixin("D.from_"~TN!(S)~"(значение)")) : D ) )
        return mixin("D.from_"~TN!(S)~"(значение)");

    else static if( is( typeof(mixin("D.из_"
                        ~ctfe_camelCase(TN!(S))~"(значение)")) : D ) )
        return mixin("D.из_"~ctfe_camelCase(TN!(S))~"(значение)");

    else static if( is( typeof(D.из_!(S)(значение)) : D ) )
        return D.из_!(S)(значение);

    // Give up
    else
        mixin unsupported;
}

D toImpl(D,S)(S значение)
{
    static if( is( D == S ) )
        return значение;

    else static if( is( S BaseType == typedef ) )
        return toImpl!(D,BaseType)(значение);

    else static if( is( S BaseType == enum ) )
        return toImpl!(D,BaseType)(значение);

    else static if( типМассив_ли!(D) && типМассив_ли!(S)
            && is( typeof(D[0]) == typeof(S[0]) ) )
        // Special-case which catches в_!(T[])!(T[n]).
        return значение;

    else static if( is( D == бул ) )
        return вБул!(D,S)(значение);

    else static if( типЦелЧис_ли!(D) )
        return toInteger!(D,S)(значение);

    else static if( типРеал_ли!(D) )
        return вРеал!(D,S)(значение);

    else static if( типМнимое_ли!(D) )
        return toImaginary!(D,S)(значение);

    else static if( типКомплекс_ли!(D) )
        return toComplex!(D,S)(значение);

    else static if( типСим_ли!(D) )
        return toChar!(D,S)(значение);

    else static if( ткст_ли!(D) && ткст_ли!(S) )
        return toStringFromString!(D,S)(значение);

    else static if( ткст_ли!(D) )
        return вТкст!(D,S)(значение);

    else static if( ткст_ли!(S) )
        return fromString!(D,S)(значение);

    else static if( типМассив_ли!(D) && типМассив_ли!(S) )
        return toArrayFromArray!(D,S)(значение);

    else static if( типАссоцМассив_ли!(D) && типАссоцМассив_ли!(S) )
        return toMapFromMap!(D,S)(значение);

    else static if( isUDT!(D) || isUDT!(S) )
        return toFromUDT!(D,S)(значение);

    else
        mixin unsupported;
}

debug ( ConvertTest ):
    проц main() {}

debug( UnitTest ):


бул ex(T)(lazy T v)
{
    бул результат = нет;
    try
    {
        v();
    }
    catch( ИсклПреобразования _ )
    {
        результат = да;
    }
    return результат;
}

бул nx(T)(lazy T v)
{
    бул результат = да;
    try
    {
        v();
    }
    catch( ИсклПреобразования _ )
    {
        результат = нет;
    }
    return результат;
}

struct Foo
{
    цел вЦел() { return 42; }

    ткст вТкст() { return "ткст foo"; }

    цел[] вЦелМас() { return [1,2,3]; }

    Bar toBar()
    {
        Bar результат; return результат;
    }

    T в_(T)()
    {
        static if( is( T == бул ) )
            return да;
        else
            static assert( нет );
    }
}

struct Bar
{
    реал вРеал()
    {
        return 3.14159;
    }

    вреал toIreal()
    {
        return 42.0i;
    }
}

struct Baz
{
    static Baz fromFoo(Foo foo)
    {
        Baz результат; return результат;
    }

    Bar toBar()
    {
        Bar результат; return результат;
    }
}

unittest
{
    /*
     * бул
     */
    static assert( !is( typeof(в_!(бул)(1.0)) ) );
    static assert( !is( typeof(в_!(бул)(1.0i)) ) );
    static assert( !is( typeof(в_!(бул)(1.0+1.0i)) ) );

    assert( в_!(бул)(0) == нет );
    assert( в_!(бул)(1) == да );
    assert( в_!(бул)(-1) == да );

    assert( в_!(бул)('t') == да );
    assert( в_!(бул)('T') == да );
    assert( в_!(бул)('f') == нет );
    assert( в_!(бул)('F') == нет );
    assert(ex( в_!(бул)('x') ));

    assert( в_!(бул)("да") == да );
    assert( в_!(бул)("нет") == нет );
    assert( в_!(бул)("TrUe") == да );
    assert( в_!(бул)("fAlSe") == нет );

    /*
     * Целое
     */
    assert( в_!(цел)(42L) == 42 );
    assert( в_!(байт)(42) == cast(байт)42 );
    assert( в_!(крат)(-1701) == cast(крат)-1701 );
    assert( в_!(дол)(cast(ббайт)72) == 72L );

    assert(nx( в_!(байт)(127) ));
    assert(ex( в_!(байт)(128) ));
    assert(nx( в_!(байт)(-128) ));
    assert(ex( в_!(байт)(-129) ));

    assert(nx( в_!(ббайт)(255) ));
    assert(ex( в_!(ббайт)(256) ));
    assert(nx( в_!(ббайт)(0) ));
    assert(ex( в_!(ббайт)(-1) ));

    assert(nx( в_!(дол)(9_223_372_036_854_775_807UL) ));
    assert(ex( в_!(дол)(9_223_372_036_854_775_808UL) ));
    assert(nx( в_!(бдол)(0L) ));
    assert(ex( в_!(бдол)(-1L) ));

    assert( в_!(цел)(3.14159) == 3 );
    assert( в_!(цел)(2.71828) == 3 );

    assert( в_!(цел)("1234") == 1234 );

    assert( в_!(цел)(да) == 1 );
    assert( в_!(цел)(нет) == 0 );

    assert( в_!(цел)('0') == 0 );
    assert( в_!(цел)('9') == 9 );

    /*
     * Real
     */
    assert( в_!(реал)(3) == 3.0 );
    assert( в_!(реал)("1.125") == 1.125 );

    /*
     * Imaginary
     */
    static assert( !is( typeof(в_!(вреал)(3.0)) ) );

    assert( в_!(вреал)(0.0+1.0i) == 1.0i );
    assert(nx( в_!(вреал)(0.0+1.0i) ));
    assert(ex( в_!(вреал)(1.0+0.0i) ));

    /*
     * Complex
     */
    assert( в_!(креал)(1) == (1.0+0.0i) );
    assert( в_!(креал)(2.0) == (2.0+0.0i) );
    assert( в_!(креал)(3.0i) == (0.0+3.0i) );

    /*
     * Char
     */
    assert( в_!(сим)(да) == 't' );
    assert( в_!(сим)(нет) == 'f' );

    assert( в_!(сим)(0) == '0' );
    assert( в_!(сим)(9) == '9' );

    assert(ex( в_!(сим)(-1) ));
    assert(ex( в_!(сим)(10) ));

    assert( в_!(сим)("a"d) == 'a' );
    assert( в_!(дим)("ε"c) == 'ε' );

    assert(ex( в_!(сим)("ε"d) ));

    /*
     * Строка-ткст
     */
    assert( в_!(ткст)("Í love в_ æt "w) == "Í love в_ æt "c );
    assert( в_!(ткст)("them smûrƒies™,"d) == "them smûrƒies™,"c );
    assert( в_!(шим[])("Smûrﬁes™ I love"c) == "Smûrﬁes™ I love"w );
    assert( в_!(шим[])("２ 食い散らす"d) == "２ 食い散らす"w );
    assert( в_!(дим[])("bite đey µgly"c) == "bite đey µgly"d );
    assert( в_!(дим[])("headž ㍳ff"w) == "headž ㍳ff"d );
    // ... nibble on they bluish feet.

    /*
     * Строка
     */
    assert( в_!(ткст)(да) == "да" );
    assert( в_!(ткст)(нет) == "нет" );

    assert( в_!(ткст)(12345678) == "12345678" );
    assert( в_!(ткст)(1234.567800) == "1234.57");

    assert( в_!( ткст)(cast(сим) 'a') == "a"c );
    assert( в_!(шим[])(cast(сим) 'b') == "b"w );
    assert( в_!(дим[])(cast(сим) 'c') == "c"d );
    assert( в_!( ткст)(cast(шим)'d') == "d"c );
    assert( в_!(шим[])(cast(шим)'e') == "e"w );
    assert( в_!(дим[])(cast(шим)'f') == "f"d );
    assert( в_!( ткст)(cast(дим)'g') == "g"c );
    assert( в_!(шим[])(cast(дим)'h') == "h"w );
    assert( в_!(дим[])(cast(дим)'i') == "i"d );

    /*
     * Массив-Массив
     */
    assert( в_!(ббайт[])([1,2,3]) == [cast(ббайт)1, 2, 3] );
    assert( в_!(бул[])(["да"[], "нет"]) == [да, нет] );

    /*
     * Map-карта
     */
    {
        ткст[цел] ист = [1:"да"[], 2:"нет"];
        бул[ббайт] приёмн = в_!(бул[ббайт])(ист);
        assert( приёмн.ключи.length == 2 );
        assert( приёмн[1] == да );
        assert( приёмн[2] == нет );
    }

    /*
     * UDT
     */
    {
        Foo foo;

        assert( в_!(бул)(foo) == да );
        assert( в_!(цел)(foo) == 42 );
        assert( в_!(ткст)(foo) == "ткст foo" );
        assert( в_!(шим[])(foo) == "ткст foo"w );
        assert( в_!(дим[])(foo) == "ткст foo"d );
        assert( в_!(цел[])(foo) == [1,2,3] );
        assert( в_!(вреал)(в_!(Bar)(foo)) == 42.0i );
        assert( в_!(реал)(в_!(Bar)(в_!(Baz)(foo))) == 3.14159 );
    }

    /*
     * Default values
     */
    {
        assert( в_!(цел)("123", 456) == 123,
                `в_!(цел)("123", 456) == "` ~ в_!(ткст)(
                    в_!(цел)("123", 456)) ~ `"` );
        assert( в_!(цел)("abc", 456) == 456,
                `в_!(цел)("abc", 456) == "` ~ в_!(ткст)(
                    в_!(цел)("abc", 456)) ~ `"` );
    }

    /*
     * Ticket #1486
     */
    {
        assert(ex( в_!(цел)("") ));

        assert(ex( в_!(реал)("Foo") ));
        assert(ex( в_!(реал)("") ));
        assert(ex( в_!(реал)("0x1.2cp+9") ));

        // ОтКого d0c's patch
        assert(ex( в_!(цел)("0x20") ));
        assert(ex( в_!(цел)("0x") ));
        assert(ex( в_!(цел)("-") ));
        assert(ex( в_!(цел)("-0x") ));

        assert( в_!(реал)("0x20") == cast(реал) 0x20 );
        assert(ex( в_!(реал)("0x") ));
        assert(ex( в_!(реал)("-") ));
    }
}

