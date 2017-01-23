/**
 * The variant module содержит a variant, or polymorphic тип.
 *
 * Copyright: Copyright (C) 2005-2009 The Dinrus Team.  все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Daniel Keep, Sean Kelly
 */
module core.Variant;

private import core.Vararg : спис_ва;
private import core.Traits;
private import core.Tuple;

private extern(C) Объект _d_toObject(ук);

/*
 * This is в_ control when we компилируй in vararg support.  Vararg is a complete
 * pain in the arse.  I haven't been able в_ тест under GDC at все (and
 * support for it may disappear soon anyway) and LDC refuses в_ build for me.
 *
 * As другой compilers are tested and verified в_ work, they should be добавьed
 * below.  It would also probably be a good опрea в_ проверь the platforms for
 * which it works.
 */

version( DigitalMars )
{
    version( X86 )
    {
        version( Windows )
        {
            version=РазрешитьВарарг;
        }
        else version( Posix )
        {
            version=РазрешитьВарарг;
        }
    }
}
else version( LDC )
{
    version( X86 )
    {
        version( linux )
        {
            version=РазрешитьВарарг; // thanks Необрler
        }
    }
    else version( X86_64 )
    {
        version( linux )
        {
            version=РазрешитьВарарг; // thanks mwarning
        }
    }
}
else version( DDoc )
{
    // Let's hope DDoc is smart enough в_ catch this...
    version=РазрешитьВарарг;
}

version( РазрешитьВарарг ) {} else
{
    pragma(msg, "Note: Вариант vararg functionality not supported for this "
            "compiler/platform combination.");
    pragma(msg, "To override and enable vararg support anyway, компилируй with "
            "the РазрешитьВарарг version.");
}

private
{
    /*
     * This is used в_ сохрани the actual значение being kept in a Вариант.
     */
    struct ХранилищеВариантов
    {
        union
        {
            /*
             * Contains куча-allocated хранилище for values which are too large
             * в_ fit преобр_в the Вариант directly.
             */
            проц[] куча;

            /*
             * Used в_ сохрани массивы directly.  Note that this is NOT an actual
             * Массив; using a проц[] causes the length в_ change, which screws
             * up the ptr() property.
             *
             * WARNING: this structure MUST match the ABI for массивы for this
             * platform.  AFAIK, все compilers implement массивы this way.
             * There needs в_ be a case in the unit тест в_ ensure this.
             */
            struct Массив
            {
                т_мера length;
                ук  ptr;
            }
            Массив массив;

            // Used в_ simplify dealing with objects.
            Объект об;

            // Used в_ адрес хранилище as an Массив.
            ббайт[Массив.sizeof] данные;
        }

        /*
         * This is used в_ установи the Массив structure safely.  We're essentially
         * just ensuring that if a garbage collection happens mопр-присвой, we
         * don't accопрentally метка биты of память we shouldn't.
         *
         * Of course, the compiler could always re-order the length and ptr
         * assignment.  Oh well.
         */
        проц установиМассив(ук  ptr, т_мера length)
        {
            массив.length = 0;
            массив.ptr = ptr;
            массив.length = length;
        }
    }

    // Determines if the given тип is an Объект (class) тип.
    template объект_ли(T)
    {
        static if( is( T : Объект ) )
            const объект_ли = да;
        else
            const объект_ли = нет;
    }

    // Determines if the given тип is an interface
    template интерфейс_ли(T)
    {
        static if( is( T == interface ) )
            const интерфейс_ли = да;
        else
            const интерфейс_ли = нет;
    }

    // A список of все basic типы
    alias Кортеж!(бул, сим, шим, дим,
            байт, крат, цел, дол, //cent,
            ббайт, бкрат, бцел, бдол, //ucent,
            плав, дво, реал,
            вплав, вдво, вреал,
            кплав, кдво, креал) ОсновныеТипы;

    // see основнойТип_ли
    template isBasicTypeImpl(T, U)
    {
        const isBasicTypeImpl = is( T == U );
    }

    // see основнойТип_ли
    template isBasicTypeImpl(T, U, Us...)
    {
        static if( is( T == U ) )
            const isBasicTypeImpl = да;
        else
            const isBasicTypeImpl = isBasicTypeImpl!(T, Us);
    }

    // Determines if the given тип is one of the basic типы.
    template основнойТип_ли(T)
    {
        const основнойТип_ли = isBasicTypeImpl!(T, ОсновныеТипы);
    }

    /*
     * Used в_ determine if we can cast a значение of the given ИнфОТипе в_ the
     * specified тип implicitly.  This should be somewhat faster than the
     * version in RuntimeTraits since we can basically eliminate half of the
     * tests.
     */
    бул неявноВТипПривестиМожно_ли(dsttypeT)(ИнфОТипе типист)
    {
        /*
         * Before we do anything else, we need в_ "unwrap" typedefs в_
         * получи at the реал тип.  While we do that, сделай sure we don't
         * accопрentally jump over the destination тип.
         */
        while( cast(ИнфОТипе_Typedef) типист !is пусто )
        {
            if( типист is typeid(dsttypeT) )
                return да;
            типист = типист.следщ;
        }

        /*
         * First, we'll generate tests for the basic типы.  The список of
         * things which can be cast TO basic типы is finite and easily
         * computed.
         */
        foreach( T ; ОсновныеТипы )
        {
            // If the current тип is the мишень...
            static if( is( dsttypeT == T ) )
            {
                // ... then for все of the другой basic типы ...
                foreach( U ; ОсновныеТипы )
                {
                    static if
                    (
                        // ... if that тип is smaller than ...
                        U.sizeof < T.sizeof

                        // ... or the same размер and signed-ness ...
                        || ( U.sizeof == T.sizeof &&
                            ((типСим_ли!(T) || типБЦел_ли!(T))
                             ^ !(типСим_ли!(U) || типБЦел_ли!(U)))
                        )
                    )
                    {
                        // ... тест.
                        if( типист is typeid(U) )
                            return да;
                    }
                }
                // Nothing matched; no implicit casting.
                return нет;
            }
        }

        /*
         * Account for static массивы being implicitly convertible в_ dynamic
         * массивы.
         */
        static if( is( T[] : dsttypeT ) )
        {
            if( typeid(T[]) is типист )
                return да;

            if( auto ti_sa = cast(TypeInfo_StaticArray) типист )
                return ti_sa.следщ is typeid(T);

            return нет;
        }

        /*
         * Any pointer can be cast в_ проц*.
         */
        static if( is( dsttypeT == ук  ) )
            return (cast(TypeInfo_Pointer) типист) !is пусто;

        /*
         * Any Массив can be cast в_ проц[], however remember that it есть в_
         * be manually adjusted в_ preserve the correct length.
         */
        static if( is( dsttypeT == void[] ) )
            return ((cast(TypeInfo_Array) типист) !is пусто)
                || ((cast(TypeInfo_StaticArray) типист) !is пусто);

        return нет;
    }

    /*
     * Aliases itself в_ the тип used в_ return a значение of тип T out of a
     * function.  This is basically a work-around for not being able в_ return
     * static массивы.
     */
    template returnT(T)
    {
        static if( типСтатМас_ли!(T) )
            alias typeof(T.dup) returnT;
        else
            alias T returnT;
    }

    /*
     * Here are some tests that perform рантайм versions of the компилируй-время
     * traits functions.
     */

    бул иофБазовый_ли(ИнфОТипе ti)
    {
        foreach( T ; ОсновныеТипы )
            if( ti is typeid(T) )
                return да;
        return нет;
    }

    private import RuntimeTraits = core.RuntimeTraits;

    alias RuntimeTraits.статМасс_ли иофСтатМасс_ли;
    alias RuntimeTraits.класс_ли иофОбъект_ли;
    alias RuntimeTraits.интерфейс_ли иофИнтерфейс_ли;
}

/**
 * This исключение is thrown whenever you attempt в_ получи the значение of a Вариант
 * without using a compatible тип.
 */
class ИсклНесовпаденияВариантногоТипа : Исключение
{
    this(ИнфОТипе ожидалось, ИнфОТипе got)
    {
        super("не удаётся преобразовать "~ожидалось.вТкст
                    ~" значение в "~got.вТкст);
    }
}

/**
 * This исключение is thrown when you attempt в_ use an пустой Вариант with
 * varargs.
 */
class ИсклПустойВариантСВарАрг : Исключение
{
    this()
    {
        super("cannot use Вариантs containing a проц with varargs");
    }
}

/**
 * The Вариант тип is used в_ dynamically сохрани values of different типы at
 * рантайм.
 *
 * You can создай a Вариант using either the pseudo-constructor or direct
 * assignment.
 *
 * -----
 *  Вариант v = Вариант(42);
 *  v = "abc";
 * -----
 */
struct Вариант
{
    /**
     * This pseudo-constructor is used в_ place a значение преобр_в a new Вариант.
     *
     * Параметры:
     *  значение = The значение you wish в_ помести in the Вариант.
     *
     * Возвращает:
     *  The new Вариант.
     * 
     * Example:
     * -----
     *  auto v = Вариант(42);
     * -----
     */
    static Вариант opCall(T)(T значение)
    {
        Вариант _this;

        static if( типСтатМас_ли!(T) )
            _this = значение.dup;

        else
            _this = значение;

        return _this;
    }

    /**
     * This pseudo-constructor creates a new Вариант using a specified
     * ИнфОТипе and необр pointer в_ the значение.
     *
     * Параметры:
     *  тип = Тип of the значение.
     *  ptr  = Pointer в_ the значение.
     *
     * Возвращает:
     *  The new Вариант.
     * 
     * Example:
     * -----
     *  цел life = 42;
     *  auto v = Вариант(typeid(typeof(life)), &life);
     * -----
     */
    static Вариант opCall()(ИнфОТипе тип, ук  ptr)
    {
        Вариант _this;
        Вариант.изУк(тип, ptr, _this);
        return _this;
    }

    /**
     * This operator allows you в_ присвой arbitrary values directly преобр_в an
     * existing Вариант.
     *
     * Параметры:
     *  значение = The значение you wish в_ помести in the Вариант.
     *
     * Возвращает:
     *  The new значение of the assigned-в_ variant.
     * 
     * Example:
     * -----
     *  Вариант v;
     *  v = 42;
     * -----
     */
    Вариант opAssign(T)(T значение)
    {
        static if( типСтатМас_ли!(T) )
        {
            return (*this = значение.dup);
        }
        else
        {
            тип = typeid(T);

            static if( типДинМас_ли!(T) )
            {
                this.значение.установиМассив(значение.ptr, значение.length);
            }
            else static if( интерфейс_ли!(T) )
            {
                this.значение.об = cast(Объект) значение;
            }
            else
            {
                /*
                 * If the значение is small enough в_ fit in the хранилище
                 * available, do so.  If it isn't, then сделай a куча копируй.
                 *
                 * Obviously, this pretty clearly breaks значение semantics for
                 * large values, but without a postblit operator, there's not
                 * much we can do.  :(
                 */
                static if( T.sizeof <= this.значение.данные.length )
                {
                    this.значение.данные[0..T.sizeof] =
                        (cast(ббайт*)&значение)[0..T.sizeof];
                }
                else
                {
                    auto буфер = (cast(ббайт*)&значение)[0..T.sizeof].dup;
                    this.значение.куча = cast(проц[])буфер;
                }
            }
            return *this;
        }
    }

    /**
     * This member can be used в_ determine if the значение stored in the Вариант
     * is of the specified тип.  Note that this сравнение is exact: it does
     * not take implicit casting rules преобр_в account.
     *
     * Возвращает:
     *  да if the Вариант содержит a значение of тип T, нет otherwise.
     * 
     * Example:
     * -----
     *  auto v = Вариант(cast(цел) 42);
     *  assert(   v.isA!(цел) );
     *  assert( ! v.isA!(крат) ); // note no implicit conversion
     * -----
     */
    бул isA(T)()
    {
        return cast(бул)(typeid(T) is тип);
    }

    /**
     * This member can be used в_ determine if the значение stored in the Вариант
     * is of the specified тип.  This сравнение попытки в_ take implicit
     * conversion rules преобр_в account.
     *
     * Возвращает:
     *  да if the Вариант содержит a значение of тип T, or if the Вариант
     *  содержит a значение that can be implicitly cast в_ тип T; нет
     *  otherwise.
     * 
     * Example:
     * -----
     *  auto v = Вариант(cast(цел) 42);
     *  assert( v.isA!(цел) );
     *  assert( v.isA!(крат) ); // note implicit conversion
     * -----
     */
    бул isImplicitly(T)()
    {
        static if( is( T == class ) || is( T == interface ) )
        {
            // Check for classes and interfaces first.
            if( cast(ИнфОТипе_Класс) тип || cast(ТипИнтерфейс) тип )
                return (cast(T) значение.об) !is пусто;

            else
                // We're trying в_ cast TO an объект, but we don't have
                // an объект stored.
                return нет;
        }
        else
        {
            // Test for basic типы (oh, and dynamic->static массивы and
            // pointers.)
            return ( cast(бул)(typeid(T) is тип)
                    || неявноВТипПривестиМожно_ли!(T)(тип) );
        }
    }

    /**
     * This determines whether the Вариант есть an assigned значение or not.  It
     * is simply крат-hand for calling the isA member with a тип of проц.
     *
     * Возвращает:
     *  да if the Вариант does not contain a значение, нет otherwise.
     */
    бул пуст_ли()
    {
        return isA!(проц);
    }

    /**
     * This member will сотри the Вариант, returning it в_ an пустой состояние.
     */
    проц сотри()
    {
        _type = typeid(проц);
        значение = значение.init;
    }

    version( DDoc )
    {
        /**
         * This is the primary mechanism for extracting a значение это a Вариант.
         * Given a destination тип S, it will attempt в_ extract the значение of the
         * Вариант преобр_в that тип.  If the значение contained within the Вариант
         * cannot be implicitly cast в_ the given тип S, it will throw an
         * исключение.
         *
         * You can check в_ see if this operation will краш by calling the
         * isImplicitly member with the тип S.
         *
         * Note that attempting в_ получи a statically-sized Массив will результат in a
         * dynamic Массив being returned; this is a language limitation.
         *
         * Возвращает:
         *  The значение stored within the Вариант.
         */
        T получи(T)()
        {
            // For actual implementation, see below.
        }
    }
    else
    {
        returnT!(S) получи(S)()
        {
            alias returnT!(S) T;

            // If we're not dealing with the exact same тип as is being
            // stored, we краш NOW if the тип in question isn't an объект (we
            // can let the рантайм do the тест) and if it isn't something we
            // know we can implicitly cast в_.
            if( тип !is typeid(T)
                    // Let D do рантайм check itself
                    && !объект_ли!(T)
                    && !интерфейс_ли!(T)

                    // Разрешить implicit upcasts
                    && !неявноВТипПривестиМожно_ли!(T)(тип)
              )
                throw new ИсклНесовпаденияВариантногоТипа(тип,typeid(T));

            // Дескр basic типы, since they account for most of the implicit
            // casts.
            static if( основнойТип_ли!(T) )
            {
                if( тип is typeid(T) )
                {
                    // We got lucky; the типы match exactly.  If the тип is
                    // small, grab it out of хранилище; otherwise, копируй it это
                    // the куча.
                    static if( T.sizeof <= значение.sizeof )
                        return *cast(T*)(&значение);

                    else
                        return *cast(T*)(значение.куча.ptr);
                }
                else
                {
                    // This handles implicit coercion.  What it does is finds
                    // the basic тип U which is actually being stored.  It
                    // then unpacks the значение of тип U stored in the Вариант
                    // and casts it в_ тип T.
                    //
                    // It is assumed that this is valid в_ perform since we
                    // should have already eliminated не_годится coercions.
                    foreach( U ; ОсновныеТипы )
                    {
                        if( тип is typeid(U) )
                        {
                            static if( U.sizeof <= значение.sizeof )
                                return cast(T) *cast(U*)(&значение);

                            else
                                return cast(T) *cast(U*)(значение.куча.ptr);
                        }
                    }
                    throw new ИсклНесовпаденияВариантногоТипа(тип,typeid(T));
                }
            }
            else static if( типДинМас_ли!(T) )
            {
                return (cast(typeof(T.ptr)) значение.Массив.ptr)
                    [0..значение.Массив.length];
            }
            else static if( объект_ли!(T) || интерфейс_ли!(T) )
            {
                return cast(T)this.значение.об;
            }
            else
            {
                static if( T.sizeof <= this.значение.данные.length )
                {
                    T результат;
                    (cast(ббайт*)&результат)[0..T.sizeof] =
                        this.значение.данные[0..T.sizeof];
                    return результат;
                }
                else
                {
                    T результат;
                    (cast(ббайт*)&результат)[0..T.sizeof] =
                        (cast(ббайт[])this.значение.куча)[0..T.sizeof];
                    return результат;
                }
            }
        }
    }

    /**
     * The following operator overloads are defined for the sake of
     * convenience.  It is important в_ understand that they do not allow you
     * в_ use a Вариант as Всё the left-hand and right-hand sопрes of an
     * expression.  One sопрe of the operator must be a concrete тип in order
     * for the Вариант в_ know what код в_ generate.
     */
    typeof(T+T) opAdd(T)(T rhs)     { return получи!(T) + rhs; }
    typeof(T+T) opAdd_r(T)(T lhs)   { return lhs + получи!(T); } /// ditto
    typeof(T-T) opSub(T)(T rhs)     { return получи!(T) - rhs; } /// ditto
    typeof(T-T) opSub_r(T)(T lhs)   { return lhs - получи!(T); } /// ditto
    typeof(T*T) opMul(T)(T rhs)     { return получи!(T) * rhs; } /// ditto
    typeof(T*T) opMul_r(T)(T lhs)   { return lhs * получи!(T); } /// ditto
    typeof(T/T) opDiv(T)(T rhs)     { return получи!(T) / rhs; } /// ditto
    typeof(T/T) opDiv_r(T)(T lhs)   { return lhs / получи!(T); } /// ditto
    typeof(T%T) opMod(T)(T rhs)     { return получи!(T) % rhs; } /// ditto
    typeof(T%T) opMod_r(T)(T lhs)   { return lhs % получи!(T); } /// ditto
    typeof(T&T) opAnd(T)(T rhs)     { return получи!(T) & rhs; } /// ditto
    typeof(T&T) opAnd_r(T)(T lhs)   { return lhs & получи!(T); } /// ditto
    typeof(T|T) opOr(T)(T rhs)      { return получи!(T) | rhs; } /// ditto
    typeof(T|T) opOr_r(T)(T lhs)    { return lhs | получи!(T); } /// ditto
    typeof(T^T) opXor(T)(T rhs)     { return получи!(T) ^ rhs; } /// ditto
    typeof(T^T) opXor_r(T)(T lhs)   { return lhs ^ получи!(T); } /// ditto
    typeof(T<<T) opShl(T)(T rhs)    { return получи!(T) << rhs; } /// ditto
    typeof(T<<T) opShl_r(T)(T lhs)  { return lhs << получи!(T); } /// ditto
    typeof(T>>T) opShr(T)(T rhs)    { return получи!(T) >> rhs; } /// ditto
    typeof(T>>T) opShr_r(T)(T lhs)  { return lhs >> получи!(T); } /// ditto
    typeof(T>>>T) opUShr(T)(T rhs)  { return получи!(T) >>> rhs; } /// ditto
    typeof(T>>>T) opUShr_r(T)(T lhs){ return lhs >>> получи!(T); } /// ditto
    typeof(T~T) opCat(T)(T rhs)     { return получи!(T) ~ rhs; } /// ditto
    typeof(T~T) opCat_r(T)(T lhs)   { return lhs ~ получи!(T); } /// ditto

    Вариант opAddAssign(T)(T значение) { return (*this = получи!(T) + значение); } /// ditto
    Вариант opSubAssign(T)(T значение) { return (*this = получи!(T) - значение); } /// ditto
    Вариант opMulAssign(T)(T значение) { return (*this = получи!(T) * значение); } /// ditto
    Вариант opDivAssign(T)(T значение) { return (*this = получи!(T) / значение); } /// ditto
    Вариант opModAssign(T)(T значение) { return (*this = получи!(T) % значение); } /// ditto
    Вариант opAndAssign(T)(T значение) { return (*this = получи!(T) & значение); } /// ditto
    Вариант opOrAssign(T)(T значение)  { return (*this = получи!(T) | значение); } /// ditto
    Вариант opXorAssign(T)(T значение) { return (*this = получи!(T) ^ значение); } /// ditto
    Вариант opShlAssign(T)(T значение) { return (*this = получи!(T) << значение); } /// ditto
    Вариант opShrAssign(T)(T значение) { return (*this = получи!(T) >> значение); } /// ditto
    Вариант opUShrAssign(T)(T значение){ return (*this = получи!(T) >>> значение); } /// ditto
    Вариант opCatAssign(T)(T значение) { return (*this = получи!(T) ~ значение); } /// ditto

    /**
     * The following operators can be used with Вариантs on Всё sопрes.  Note
     * that these operators do not follow the стандарт rules of
     * implicit conversions.
     */
    цел opEquals(T)(T rhs)
    {
        static if( is( T == Вариант ) )
            return opEqualsВариант(rhs);

        else
            return получи!(T) == rhs;
    }

    /// ditto
    цел opCmp(T)(T rhs)
    {
        static if( is( T == Вариант ) )
            return opCmpВариант(rhs);
        else
        {
            auto lhs = получи!(T);
            return (lhs < rhs) ? -1 : (lhs == rhs) ? 0 : 1;
        }
    }

    /// ditto
    т_хэш toHash()
    {
        return тип.getHash(this.ptr);
    }

    /**
     * Returns a ткст representation of the тип being stored in this
     * Вариант.
     *
     * Возвращает:
     *  The ткст representation of the тип contained within the Вариант.
     */
    ткст вТкст()
    {
        return тип.вТкст;
    }

    /**
     * This can be used в_ retrieve the ИнфОТипе for the currently stored
     * значение.
     */
    ИнфОТипе тип()
    {
        return _type;
    }

    /**
     * This can be used в_ retrieve a pointer в_ the значение stored in the
     * variant.
     */
    ук  ptr()
    {
        if( тип.tsize <= значение.sizeof )
            return &значение;

        else
            return значение.куча.ptr;
    }
    
    version( РазрешитьВарарг )
    {
        /**
         * Converts a vararg function аргумент список преобр_в an Массив of Вариантs.
         */
        static Вариант[] изВарарг(ИнфОТипе[] типы, спис_ва арги)
        {
            auto vs = new Вариант[](типы.length);

            foreach( i, ref v ; vs )
                арги = Вариант.изУк(типы[i], арги, v);
            
            return vs;
        }
        
        /// ditto
        static Вариант[] изВарарг(...)
        {
            return Вариант.изВарарг(_arguments, _argptr);
        }
        
        /**
         * Converts an Массив of Вариантs преобр_в a vararg function аргумент список.
         *
         * This will размести память в_ сохрани the аргументы in; you may destroy
         * this память when you are готово with it if you feel so inclined.
         */
        static проц вВарарг(Вариант[] vars, out ИнфОТипе[] типы, out спис_ва арги)
        {
            // First up, compute the total amount of пространство we'll need.  While
            // we're at it, work out if any of the values we're storing have
            // pointers.  If they do, we'll need в_ tell the СМ.
            т_мера размер = 0;
            бул noptr = да;
            foreach( ref v ; vars )
            {
                auto ti = v.тип;
                размер += (ti.tsize + т_мера.sizeof-1) & ~(т_мера.sizeof-1);
                noptr = noptr && (ti.флаги & 2);
            }
            
            // Create the хранилище, and tell the СМ whether it needs в_ be scanned
            // or not.
            auto хранилище = new ббайт[размер];
            смУстАтр(cast(ук)хранилище.ptr, cast(ПАтрБлока)(
                (смДайАтр(хранилище.ptr) & ~ПАтрБлока.НеСканировать)
                | (noptr ? ПАтрБлока.НеСканировать : 0)));

            // Dump the variants преобр_в the хранилище.
            арги = хранилище.ptr;
            auto arg_temp = арги;

            типы = new ИнфОТипе[vars.length];

            foreach( i, ref v ; vars )
            {
                типы[i] = v.тип;
                arg_temp = v.вУк(arg_temp);
            }
        }
    } // version( РазрешитьВарарг )

private:
    ИнфОТипе _type = typeid(проц);
    ХранилищеВариантов значение;

    ИнфОТипе тип(ИнфОТипе v)
    {
        return (_type = v);
    }
    
    /*
     * Creates a Вариант using a given ИнфОТипе and a проц*.  Returns the
     * given pointer adjusted for the следщ vararg.
     */
    static ук  изУк(ИнфОТипе тип, ук  ptr, out Вариант r)
    {
        /*
         * This function basically duplicates the functionality of
         * opAssign, except that we can't generate код based on the
         * тип of the данные we're storing.
         */

        if( тип is typeid(проц) )
            throw new ИсклПустойВариантСВарАрг;

        r.тип = тип;

        if( иофСтатМасс_ли(тип) )
        {
            /*
             * Static массивы are passed by-значение; for example, if тип is
             * typeid(цел[4]), then ptr is a pointer в_ 16 байты of память
             * (four 32-bit целыйs).
             *
             * It's possible that the память being pointed в_ is on the
             * stack, so we need в_ копируй it before storing it.  тип.tsize
             * tells us exactly как many байты we need в_ копируй.
             *
             * Sadly, we can't directly construct the dynamic Массив version
             * of тип.  We'll сохрани the static Массив тип and cope with it
             * in isImplicitly(S) and получи(S).
             */
            r.значение.куча = ptr[0 .. тип.tsize].dup;
        }
        else
        {
            if( иофОбъект_ли(тип)
                || иофИнтерфейс_ли(тип) )
            {
                /*
                 * We have в_ вызов преобр_в the core рантайм в_ turn this pointer
                 * преобр_в an actual Объект reference.
                 */
                r.значение.об = _d_toObject(*cast(проц**)ptr);
            }
            else
            {
                if( тип.tsize <= this.значение.данные.length )
                {
                    // Copy преобр_в хранилище
                    r.значение.данные[0 .. тип.tsize] = 
                        (cast(ббайт*)ptr)[0 .. тип.tsize];
                }
                else
                {
                    // Store in куча
                    auto буфер = (cast(ббайт*)ptr)[0 .. тип.tsize].dup;
                    r.значение.куча = cast(проц[])буфер;
                }
            }
        }

        // Compute the "advanced" pointer.
        return ptr + ( (тип.tsize + т_мера.sizeof-1) & ~(т_мера.sizeof-1) );
    }

    version( РазрешитьВарарг )
    {
        /*
         * Takes the current Вариант, and dumps its contents преобр_в память pointed
         * at by a проц*, suitable for vararg calls.
         *
         * It also returns the supplied pointer adjusted by the размер of the данные
         * записано в_ память.
         */
        ук  вУк(ук  ptr)
        {
            version( GNU )
            {
                pragma(msg, "WARNING: core.Variant's vararg support есть "
                        "not been tested with this compiler." );
            }
            version( LDC )
            {
                pragma(msg, "WARNING: core.Variant's vararg support есть "
                        "not been tested with this compiler." );
            }

            if( тип is typeid(проц) )
                throw new ИсклПустойВариантСВарАрг;

            if( иофСтатМасс_ли(тип) )
            {
                // Just dump straight
                ptr[0 .. тип.tsize] = this.значение.куча[0 .. тип.tsize];
            }
            else
            {
                if( иофИнтерфейс_ли(тип) )
                {
                    /*
                     * This is tricky.  What we actually have stored in
                     * значение.об is an Объект, not an interface.  What we
                     * need в_ do is manually "cast" значение.об в_ the correct
                     * interface.
                     *
                     * We have the original interface's ИнфОТипе.  This gives us
                     * the interface's ИнфОКлассе.  We can also obtain the объект's
                     * ИнфОКлассе which содержит a список of Interfaces.
                     *
                     * So what we need в_ do is loop over the interfaces об
                     * реализует until we найди the one we're interested in.  Then
                     * we just читай out the interface's смещение and исправь об
                     * accordingly.
                     */
                    auto type_i = cast(ТипИнтерфейс) тип;
                    бул найдено = нет;
                    foreach( i ; this.значение.об.classinfo.interfaces )
                    {
                        if( i.classinfo is type_i.инфо )
                        {
                            // Найдено it
                            ук  i_ptr = (cast(проц*) this.значение.об) + i.смещение;
                            *cast(проц**)ptr = i_ptr;
                            найдено = да;
                            break;
                        }
                    }
                    assert(найдено,"Could not преобразуй Объект в_ interface; "
                            "bad things have happened.");
                }
                else
                {
                    if( тип.tsize <= this.значение.данные.length )
                    {
                        // Значение stored in хранилище
                        ptr[0 .. тип.tsize] = this.значение.данные[0 .. тип.tsize];
                    }
                    else
                    {
                        // Значение stored on куча
                        ptr[0 .. тип.tsize] = this.значение.куча[0 .. тип.tsize];
                    }
                }
            }

            // Compute the "advanced" pointer.
            return ptr + ( (тип.tsize + т_мера.sizeof-1) & ~(т_мера.sizeof-1) );
        }
    } // version( РазрешитьВарарг )

    /*
     * Performs a тип-dependant сравнение.  Note that this obviously doesn't
     * take преобр_в account things like implicit conversions.
     */
    цел opEqualsВариант(Вариант rhs)
    {
        if( тип != rhs.тип ) return нет;
        return cast(бул) тип.равны(this.ptr, rhs.ptr);
    }

    /*
     * Same as opEqualsВариант except it does opCmp.
     */
    цел opCmpВариант(Вариант rhs)
    {
        if( тип != rhs.тип )
            throw new ИсклНесовпаденияВариантногоТипа(тип, rhs.тип);
        return тип.compare(this.ptr, rhs.ptr);
    }
}

debug( UnitTest )
{
    /*
     * Language tests.
     */

    unittest
    {
        {
            цел[2] a;
            проц[] b = a;
            цел[]  c = cast(цел[]) b;
            assert( b.length == 2*цел.sizeof );
            assert( c.length == a.length );
        }

        {
            struct A { т_мера l; ук  p; }
            ткст b = "123";
            A a = *cast(A*)(&b);

            assert( a.l == b.length );
            assert( a.p == b.ptr );
        }
    }

    /*
     * Basic tests.
     */

    unittest
    {
        Вариант v;
        assert( v.isA!(проц), v.тип.вТкст );
        assert( v.пуст_ли, v.тип.вТкст );

        // Test basic целое хранилище and implicit casting support
        v = 42;
        assert( v.isA!(цел), v.тип.вТкст );
        assert( v.isImplicitly!(дол), v.тип.вТкст );
        assert( v.isImplicitly!(бдол), v.тип.вТкст );
        assert( !v.isImplicitly!(бцел), v.тип.вТкст );
        assert( v.получи!(цел) == 42 );
        assert( v.получи!(дол) == 42L );
        assert( v.получи!(бдол) == 42uL );

        // Test clearing
        v.сотри;
        assert( v.isA!(проц), v.тип.вТкст );
        assert( v.пуст_ли, v.тип.вТкст );

        // Test strings
        v = "Hello, World!"c;
        assert( v.isA!(ткст), v.тип.вТкст );
        assert( !v.isImplicitly!(шим[]), v.тип.вТкст );
        assert( v.получи!(ткст) == "Hello, World!" );

        // Test Массив хранилище
        v = [1,2,3,4,5];
        assert( v.isA!(цел[]), v.тип.вТкст );
        assert( v.получи!(цел[]) == [1,2,3,4,5] );

        // Make sure массивы are correctly stored so that .ptr works.
        {
            цел[] a = [1,2,3,4,5];
            v = a;
            auto b = *cast(цел[]*)(v.ptr);

            assert( a.ptr == b.ptr );
            assert( a.length == b.length );
        }

        // Test pointer хранилище
        v = &v;
        assert( v.isA!(Вариант*), v.тип.вТкст );
        assert( !v.isImplicitly!(цел*), v.тип.вТкст );
        assert( v.isImplicitly!(проц*), v.тип.вТкст );
        assert( v.получи!(Вариант*) == &v );

        // Test объект хранилище
        {
            scope o = new Объект;
            v = o;
            assert( v.isA!(Объект), v.тип.вТкст );
            assert( v.получи!(Объект) is o );
        }

        // Test interface support
        {
            interface A {}
            interface B : A {}
            class C : B {}
            class D : C {}

            A a = new D;
            Вариант v2 = a;
            B b = v2.получи!(B);
            C c = v2.получи!(C);
            D d = v2.получи!(D);
        }

        // Test class/interface implicit casting
        {
            class G {}
            interface H {}
            class I : G {}
            class J : H {}
            struct K {}

            scope a = new G;
            scope c = new I;
            scope d = new J;
            K e;

            Вариант v2 = a;
            assert( v2.isImplicitly!(Объект), v2.тип.вТкст );
            assert( v2.isImplicitly!(G), v2.тип.вТкст );
            assert(!v2.isImplicitly!(I), v2.тип.вТкст );

            v2 = c;
            assert( v2.isImplicitly!(Объект), v2.тип.вТкст );
            assert( v2.isImplicitly!(G), v2.тип.вТкст );
            assert( v2.isImplicitly!(I), v2.тип.вТкст );

            v2 = d;
            assert( v2.isImplicitly!(Объект), v2.тип.вТкст );
            assert(!v2.isImplicitly!(G), v2.тип.вТкст );
            assert( v2.isImplicitly!(H), v2.тип.вТкст );
            assert( v2.isImplicitly!(J), v2.тип.вТкст );

            v2 = e;
            assert(!v2.isImplicitly!(Объект), v2.тип.вТкст );
        }

        // Test doubles and implicit casting
        v = 3.1413;
        assert( v.isA!(дво), v.тип.вТкст );
        assert( v.isImplicitly!(реал), v.тип.вТкст );
        assert( !v.isImplicitly!(плав), v.тип.вТкст );
        assert( v.получи!(дво) == 3.1413 );

        // Test хранилище transitivity
        auto u = Вариант(v);
        assert( u.isA!(дво), u.тип.вТкст );
        assert( u.получи!(дво) == 3.1413 );

        // Test operators
        v = 38;
        assert( v + 4 == 42 );
        assert( 4 + v == 42 );
        assert( v - 4 == 34 );
        assert( 4 - v == -34 );
        assert( v * 2 == 76 );
        assert( 2 * v == 76 );
        assert( v / 2 == 19 );
        assert( 2 / v == 0 );
        assert( v % 2 == 0 );
        assert( 2 % v == 2 );
        assert( (v & 6) == 6 );
        assert( (6 & v) == 6 );
        assert( (v | 9) == 47 );
        assert( (9 | v) == 47 );
        assert( (v ^ 5) == 35 );
        assert( (5 ^ v) == 35 );
        assert( v << 1 == 76 );
        assert( 1 << Вариант(2) == 4 );
        assert( v >> 1 == 19 );
        assert( 4 >> Вариант(2) == 1 );

        assert( Вариант("abc") ~ "def" == "abcdef" );
        assert( "abc" ~ Вариант("def") == "abcdef" );

        // Test op= operators
        v = 38; v += 4; assert( v == 42 );
        v = 38; v -= 4; assert( v == 34 );
        v = 38; v *= 2; assert( v == 76 );
        v = 38; v /= 2; assert( v == 19 );
        v = 38; v %= 2; assert( v == 0 );
        v = 38; v &= 6; assert( v == 6 );
        v = 38; v |= 9; assert( v == 47 );
        v = 38; v ^= 5; assert( v == 35 );
        v = 38; v <<= 1; assert( v == 76 );
        v = 38; v >>= 1; assert( v == 19 );

        v = "abc"; v ~= "def"; assert( v == "abcdef" );

        // Test сравнение
        assert( Вариант(0) < Вариант(42) );
        assert( Вариант(42) > Вариант(0) );
        assert( Вариант(21) == Вариант(21) );
        assert( Вариант(0) != Вариант(42) );
        assert( Вариант("bar") == Вариант("bar") );
        assert( Вариант("foo") != Вариант("bar") );

        // Test variants as AA ключи
        {
            auto v1 = Вариант(42);
            auto v2 = Вариант("foo");
            auto v3 = Вариант(1+2.0i);

            цел[Вариант] hash;
            hash[v1] = 0;
            hash[v2] = 1;
            hash[v3] = 2;

            assert( hash[v1] == 0 );
            assert( hash[v2] == 1 );
            assert( hash[v3] == 2 );
        }

        // Test AA хранилище
        {
            цел[ткст] hash;
            hash["a"] = 1;
            hash["b"] = 2;
            hash["c"] = 3;
            Вариант vhash = hash;

            assert( vhash.получи!(цел[ткст])["a"] == 1 );
            assert( vhash.получи!(цел[ткст])["b"] == 2 );
            assert( vhash.получи!(цел[ткст])["c"] == 3 );
        }
    }

    /*
     * Vararg tests.
     */

    version( РазрешитьВарарг )
    {
        private import core.Vararg;

        unittest
        {
            class A
            {
                ткст сооб() { return "A"; }
            }
            class B : A
            {
                override ткст сооб() { return "B"; }
            }
            interface C
            {
                ткст имя();
            }
            class D : B, C
            {
                override ткст сооб() { return "D"; }
                override ткст имя() { return "phil"; }
            }

            struct S { цел a, b, c, d; }

            Вариант[] scoop(...)
            {
                return Вариант.изВарарг(_arguments, _argptr);
            }

            auto va_0 = cast(сим)  '?';
            auto va_1 = cast(крат) 42;
            auto va_2 = cast(цел)   1701;
            auto va_3 = cast(дол)  9001;
            auto va_4 = cast(плав) 3.14;
            auto va_5 = cast(дво)2.14;
            auto va_6 = cast(реал)  0.1;
            auto va_7 = "abcd"[];
            S    va_8 = { 1, 2, 3, 4 };
            A    va_9 = new A;
            B    va_a = new B;
            C    va_b = new D;
            D    va_c = new D;
            
            auto vs = scoop(va_0, va_1, va_2, va_3,
                            va_4, va_5, va_6, va_7,
                            va_8, va_9, va_a, va_b, va_c);

            assert( vs[0x0].получи!(typeof(va_0)) == va_0 );
            assert( vs[0x1].получи!(typeof(va_1)) == va_1 );
            assert( vs[0x2].получи!(typeof(va_2)) == va_2 );
            assert( vs[0x3].получи!(typeof(va_3)) == va_3 );
            assert( vs[0x4].получи!(typeof(va_4)) == va_4 );
            assert( vs[0x5].получи!(typeof(va_5)) == va_5 );
            assert( vs[0x6].получи!(typeof(va_6)) == va_6 );
            assert( vs[0x7].получи!(typeof(va_7)) == va_7 );
            assert( vs[0x8].получи!(typeof(va_8)) == va_8 );
            assert( vs[0x9].получи!(typeof(va_9)) is va_9 );
            assert( vs[0xa].получи!(typeof(va_a)) is va_a );
            assert( vs[0xb].получи!(typeof(va_b)) is va_b );
            assert( vs[0xc].получи!(typeof(va_c)) is va_c );

            assert( vs[0x9].получи!(typeof(va_9)).сооб == "A" );
            assert( vs[0xa].получи!(typeof(va_a)).сооб == "B" );
            assert( vs[0xc].получи!(typeof(va_c)).сооб == "D" );
            
            assert( vs[0xb].получи!(typeof(va_b)).имя == "phil" );
            assert( vs[0xc].получи!(typeof(va_c)).имя == "phil" );

            {
                ИнфОТипе[] типы;
                ук  арги;

                Вариант.вВарарг(vs, типы, арги);

                assert( типы[0x0] is typeid(typeof(va_0)) );
                assert( типы[0x1] is typeid(typeof(va_1)) );
                assert( типы[0x2] is typeid(typeof(va_2)) );
                assert( типы[0x3] is typeid(typeof(va_3)) );
                assert( типы[0x4] is typeid(typeof(va_4)) );
                assert( типы[0x5] is typeid(typeof(va_5)) );
                assert( типы[0x6] is typeid(typeof(va_6)) );
                assert( типы[0x7] is typeid(typeof(va_7)) );
                assert( типы[0x8] is typeid(typeof(va_8)) );
                assert( типы[0x9] is typeid(typeof(va_9)) );
                assert( типы[0xa] is typeid(typeof(va_a)) );
                assert( типы[0xb] is typeid(typeof(va_b)) );
                assert( типы[0xc] is typeid(typeof(va_c)) );

                auto ptr = арги;

                auto vb_0 = ва_арг!(typeof(va_0))(ptr);
                auto vb_1 = ва_арг!(typeof(va_1))(ptr);
                auto vb_2 = ва_арг!(typeof(va_2))(ptr);
                auto vb_3 = ва_арг!(typeof(va_3))(ptr);
                auto vb_4 = ва_арг!(typeof(va_4))(ptr);
                auto vb_5 = ва_арг!(typeof(va_5))(ptr);
                auto vb_6 = ва_арг!(typeof(va_6))(ptr);
                auto vb_7 = ва_арг!(typeof(va_7))(ptr);
                auto vb_8 = ва_арг!(typeof(va_8))(ptr);
                auto vb_9 = ва_арг!(typeof(va_9))(ptr);
                auto vb_a = ва_арг!(typeof(va_a))(ptr);
                auto vb_b = ва_арг!(typeof(va_b))(ptr);
                auto vb_c = ва_арг!(typeof(va_c))(ptr);

                assert( vb_0 == va_0 );
                assert( vb_1 == va_1 );
                assert( vb_2 == va_2 );
                assert( vb_3 == va_3 );
                assert( vb_4 == va_4 );
                assert( vb_5 == va_5 );
                assert( vb_6 == va_6 );
                assert( vb_7 == va_7 );
                assert( vb_8 == va_8 );
                assert( vb_9 is va_9 );
                assert( vb_a is va_a );
                assert( vb_b is va_b );
                assert( vb_c is va_c );

                assert( vb_9.сооб == "A" );
                assert( vb_a.сооб == "B" );
                assert( vb_c.сооб == "D" );

                assert( vb_b.имя == "phil" );
                assert( vb_c.имя == "phil" );
            }
        }
    }
}
