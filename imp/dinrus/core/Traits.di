/**
 * The traits module defines tools useful for obtaining detailed компилируй-время
 * information about a тип.  Please note that the mixed naming scheme used in
 * this module is intentional.  Templates which evaluate в_ a тип follow the
 * naming convention used for типы, and templates which evaluate в_ a значение
 * follow the naming convention used for functions.
 *
 * Copyright: Copyright (C) 2005-2006 Sean Kelly.  все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Sean Kelly, Fawzi Mohamed, Abscissa
 */
module core.Traits;


/**
 * Evaluates в_ да if T is ткст, шим[], or дим[].
 */
template типТкст_ли( T )
{
    const бул типТкст_ли = is( T : ткст )  ||
                              is( T : шим[] ) ||
                              is( T : дим[] );
}

/**
 * Evaluates в_ да if T is сим, шим, or дим.
 */
template типСим_ли( T )
{
    const бул типСим_ли = is( T == сим )  ||
                            is( T == шим ) ||
                            is( T == дим );
}


/**
 * Evaluates в_ да if T is a signed целое тип.
 */
template типЦел_ли( T )
{
    const бул типЦел_ли = is( T == байт )  ||
                                     is( T == крат ) ||
                                     is( T == цел )   ||
                                     is( T == дол )/+||
                                     is( T == cent  )+/;
}


/**
 * Evaluates в_ да if T is an unsigned целое тип.
 */
template типБЦел_ли( T )
{
    const бул типБЦел_ли = is( T == ббайт )  ||
                                       is( T == бкрат ) ||
                                       is( T == бцел )   ||
                                       is( T == бдол )/+||
                                       is( T == ucent  )+/;
}


/**
 * Evaluates в_ да if T is a signed or unsigned целое тип.
 */
template типЦелЧис_ли( T )
{
    const бул типЦелЧис_ли = типЦел_ли!(T) ||
                               типБЦел_ли!(T);
}


/**
 * Evaluates в_ да if T is a реал floating-point тип.
 */
template типРеал_ли( T )
{
    const бул типРеал_ли = is( T == плав )  ||
                            is( T == дво ) ||
                            is( T == реал );
}


/**
 * Evaluates в_ да if T is a комплексное floating-point тип.
 */
template типКомплекс_ли( T )
{
    const бул типКомплекс_ли = is( T == кплав )  ||
                               is( T == кдво ) ||
                               is( T == креал );
}


/**
 * Evaluates в_ да if T is an мнимое floating-point тип.
 */
template типМнимое_ли( T )
{
    const бул типМнимое_ли = is( T == вплав )  ||
                                 is( T == вдво ) ||
                                 is( T == вреал );
}


/**
 * Evaluates в_ да if T is any floating-point тип: реал, комплексное, or
 * мнимое.
 */
template isFloatingPointType( T )
{
    const бул isFloatingPointType = типРеал_ли!(T)    ||
                                     типКомплекс_ли!(T) ||
                                     типМнимое_ли!(T);
}

/// да if T is an atomic тип
template isAtomicType(T)
{
    static if( is( T == бул )
            || is( T == сим )
            || is( T == шим )
            || is( T == дим )
            || is( T == байт )
            || is( T == крат )
            || is( T == цел )
            || is( T == дол )
            || is( T == ббайт )
            || is( T == бкрат )
            || is( T == бцел )
            || is( T == бдол )
            || is( T == плав )
            || is( T == дво )
            || is( T == реал )
            || is( T == вплав )
            || is( T == вдво )
            || is( T == вреал ) )
        const isAtomicType = да;
    else
        const isAtomicType = нет;
}

/**
 * комплексное тип for the given тип
 */
template ComplexTypeOf(T){
    static if(is(T==плав)||is(T==вплав)||is(T==кплав)){
        alias кплав ComplexTypeOf;
    } else static if(is(T==дво)|| is(T==вдво)|| is(T==кдво)){
        alias кдво ComplexTypeOf;
    } else static if(is(T==реал)|| is(T==вреал)|| is(T==креал)){
        alias креал ComplexTypeOf;
    } else static assert(0,"unsupported тип in ComplexTypeOf "~T.stringof);
}

/**
 * реал тип for the given тип
 */
template RealTypeOf(T){
    static if(is(T==плав)|| is(T==вплав)|| is(T==кплав)){
        alias плав RealTypeOf;
    } else static if(is(T==дво)|| is(T==вдво)|| is(T==кдво)){
        alias дво RealTypeOf;
    } else static if(is(T==реал)|| is(T==вреал)|| is(T==креал)){
        alias реал RealTypeOf;
    } else static assert(0,"unsupported тип in RealTypeOf "~T.stringof);
}

/**
 * мнимое тип for the given тип
 */
template ImaginaryTypeOf(T){
    static if(is(T==плав)|| is(T==вплав)|| is(T==кплав)){
        alias вплав ImaginaryTypeOf;
    } else static if(is(T==дво)|| is(T==вдво)|| is(T==кдво)){
        alias вдво ImaginaryTypeOf;
    } else static if(is(T==реал)|| is(T==вреал)|| is(T==креал)){
        alias вреал ImaginaryTypeOf;
    } else static assert(0,"unsupported тип in ImaginaryTypeOf "~T.stringof);
}

/// тип with maximum точность
template MaxPrecTypeOf(T){
    static if (типКомплекс_ли!(T)){
        alias креал MaxPrecTypeOf;
    } else static if (типМнимое_ли!(T)){
        alias вреал MaxPrecTypeOf;
    } else {
        alias реал MaxPrecTypeOf;
    }
}


/**
 * Evaluates в_ да if T is a pointer тип.
 */
template типУк_ли(T)
{
        const типУк_ли = нет;
}

template типУк_ли(T : T*)
{
        const типУк_ли = да;
}

debug( UnitTest )
{
    unittest
    {
        static assert( типУк_ли!(проц*) );
        static assert( !типУк_ли!(ткст) );
        static assert( типУк_ли!(ткст*) );
        static assert( !типУк_ли!(сим*[]) );
        static assert( типУк_ли!(реал*) );
        static assert( !типУк_ли!(бцел) );
        static assert( is(MaxPrecTypeOf!(плав)==реал));
        static assert( is(MaxPrecTypeOf!(кплав)==креал));
        static assert( is(MaxPrecTypeOf!(вплав)==вреал));

        class Ham
        {
            ук  a;
        }

        static assert( !типУк_ли!(Ham) );

        union Eggs
        {
            ук  a;
            бцел  b;
        };

        static assert( !типУк_ли!(Eggs) );
        static assert( типУк_ли!(Eggs*) );

        struct Bacon {};

        static assert( !типУк_ли!(Bacon) );

    }
}

/**
 * Evaluates в_ да if T is a a pointer, class, interface, or delegate.
 */
template ссылТип_ли( T )
{

    const бул ссылТип_ли = типУк_ли!(T)  ||
                               is( T == class )     ||
                               is( T == interface ) ||
                               is( T == delegate );
}


/**
 * Evaulates в_ да if T is a dynamic Массив тип.
 */
template типДинМас_ли( T )
{
    const бул типДинМас_ли = is( typeof(T.init[0])[] == T );
}

/**
 * Evaluates в_ да if T is a static Массив тип.
 */
version( GNU )
{
    // GDC should also be able в_ use the другой version, but it probably
    // relies on a frontend fix in one of the latest DMD versions - will
    // удали this when GDC is ready. For сейчас, this код пароль the unittests.
    private template статМасс_лиTypeInst( T )
    {
        const T статМасс_лиTypeInst =void;
    }

    template типСтатМас_ли( T )
    {
        static if( is( typeof(T.length) ) && !is( typeof(T) == typeof(T.init) ) )
        {
            const бул типСтатМас_ли = is( T == typeof(T[0])[статМасс_лиTypeInst!(T).length] );
        }
        else
        {
            const бул типСтатМас_ли = нет;
        }
    }
}
else
{
    template типСтатМас_ли( T : T[U], т_мера U )
    {
        const бул типСтатМас_ли = да;
    }

    template типСтатМас_ли( T )
    {
        const бул типСтатМас_ли = нет;
    }
}

/// да for Массив типы
template типМассив_ли(T)
{
    static if (is( T U : U[] ))
        const бул типМассив_ли=да;
    else
        const бул типМассив_ли=нет;
}

debug( UnitTest )
{
    unittest
    {
        static assert( типСтатМас_ли!(сим[5][2]) );
        static assert( !типДинМас_ли!(сим[5][2]) );
        static assert( типМассив_ли!(сим[5][2]) );

        static assert( типСтатМас_ли!(сим[15]) );
        static assert( !типСтатМас_ли!(ткст) );

        static assert( типДинМас_ли!(ткст) );
        static assert( !типДинМас_ли!(сим[15]) );

        static assert( типМассив_ли!(сим[15]) );
        static assert( типМассив_ли!(ткст) );
        static assert( !типМассив_ли!(сим) );
    }
}

/**
 * Evaluates в_ да if T is an associative Массив тип.
 */
template isAssocArrayType( T )
{
    const бул isAssocArrayType = is( typeof(T.init.values[0])[typeof(T.init.ключи[0])] == T );
}


/**
 * Evaluates в_ да if T is a function, function pointer, delegate, or
 * callable объект.
 */
template ВызываемыйТип_ли( T )
{
    const бул ВызываемыйТип_ли = is( T == function )             ||
                                is( typeof(*T) == function )    ||
                                is( T == delegate )             ||
                                is( typeof(T.opCall) == function );
}


/**
 * Evaluates в_ the return тип of Fn.  Fn is required в_ be a callable тип.
 */
template ReturnTypeOf( Fn )
{
    static if( is( Fn Ret == return ) )
        alias Ret ReturnTypeOf;
    else
        static assert( нет, "Аргумент есть no return тип." );
}

/** 
 * Returns the тип that a T would evaluate в_ in an expression.
 * Expr is not required в_ be a callable тип
 */ 
template ExprTypeOf( Expr )
{
    static if(ВызываемыйТип_ли!( Expr ))
        alias ReturnTypeOf!( Expr ) ExprTypeOf;
    else
        alias Expr ExprTypeOf;
}


/**
 * Evaluates в_ the return тип of фн.  фн is required в_ be callable.
 */
template ReturnTypeOf( alias фн )
{
    static if( is( typeof(фн) Base == typedef ) )
        alias ReturnTypeOf!(Base) ReturnTypeOf;
    else
        alias ReturnTypeOf!(typeof(фн)) ReturnTypeOf;
}


/**
 * Evaluates в_ a tuple representing the параметры of Fn.  Fn is required в_
 * be a callable тип.
 */
template ParameterTupleOf( Fn )
{
    static if( is( Fn Params == function ) )
        alias Params ParameterTupleOf;
    else static if( is( Fn Params == delegate ) )
        alias ParameterTupleOf!(Params) ParameterTupleOf;
    else static if( is( Fn Params == Params* ) )
        alias ParameterTupleOf!(Params) ParameterTupleOf;
    else
        static assert( нет, "Аргумент есть no параметры." );
}


/**
 * Evaluates в_ a tuple representing the параметры of фн.  n is required в_
 * be callable.
 */
template ParameterTupleOf( alias фн )
{
    static if( is( typeof(фн) Base == typedef ) )
        alias ParameterTupleOf!(Base) ParameterTupleOf;
    else
        alias ParameterTupleOf!(typeof(фн)) ParameterTupleOf;
}


/**
 * Evaluates в_ a tuple representing the ancestors of T.  T is required в_ be
 * a class or interface тип.
 */
template BaseTypeTupleOf( T )
{
    static if( is( T Base == super ) )
        alias Base BaseTypeTupleOf;
    else
        static assert( нет, "Аргумент is not a class or interface." );
}

/**
 * strips the []'s off of a тип.
 */
template БазТипМассивов(T)
{
    static if( is( T S : S[]) ) {
        alias БазТипМассивов!(S)  БазТипМассивов;
    }
    else {
        alias T БазТипМассивов;
    }
}

/**
 * strips one [] off a тип
 */
template ElementTypeOfArray(T:T[])
{
    alias T ElementTypeOfArray;
}

/**
 * Count the []'s on an Массив тип
 */
template rankOfArray(T) {
    static if(is(T S : S[])) {
        const бцел rankOfArray = 1 + rankOfArray!(S);
    } else {
        const бцел rankOfArray = 0;
    }
}

/// тип of the ключи of an AA
template KeyTypeOfAA(T){
    alias typeof(T.init.ключи[0]) KeyTypeOfAA;
}

/// тип of the values of an AA
template ValTypeOfAA(T){
    alias typeof(T.init.values[0]) ValTypeOfAA;
}

/// returns the размер of a static Массив
template staticArraySize(T)
{
    static assert(типСтатМас_ли!(T),"staticArraySize needs a static Массив as тип");
    static assert(rankOfArray!(T)==1,"implemented only for 1d массивы...");
    const т_мера staticArraySize=(T).sizeof / typeof(T.init).sizeof;
}

/// is T is static Массив returns a dynamic Массив, otherwise returns T
template DynamicArrayType(T)
{
    static if( типСтатМас_ли!(T) )
        alias typeof(T.dup) DynamicArrayType;
    else
        alias T DynamicArrayType;
}

debug( UnitTest )
{
    static assert( is(БазТипМассивов!(реал[][])==реал) );
    static assert( is(БазТипМассивов!(реал[2][3])==реал) );
    static assert( is(ElementTypeOfArray!(реал[])==реал) );
    static assert( is(ElementTypeOfArray!(реал[][])==реал[]) );
    static assert( is(ElementTypeOfArray!(реал[2][])==реал[2]) );
    static assert( is(ElementTypeOfArray!(реал[2][2])==реал[2]) );
    static assert( rankOfArray!(реал[][])==2 );
    static assert( rankOfArray!(реал[2][])==2 );
    static assert( is(ValTypeOfAA!(сим[цел])==сим));
    static assert( !is(KeyTypeOfAA!(сим[цел])==цел));
    static assert( is(ValTypeOfAA!(ткст[цел])==ткст));
    static assert( is(KeyTypeOfAA!(ткст[цел[]])==цел[]));
    static assert( isAssocArrayType!(ткст[цел[]]));
    static assert( !isAssocArrayType!(ткст));
    static assert( is(DynamicArrayType!(сим[2])==DynamicArrayType!(ткст)));
    static assert( is(DynamicArrayType!(сим[2])==ткст));
    static assert( staticArraySize!(сим[2])==2);
}

// ------- CTFE -------

/// компилируй время целое в_ ткст
сим [] ctfe_i2a(цел i){
    ткст цифра="0123456789";
    ткст рез="";
    if (i==0){
        return "0";
    }
    бул neg=нет;
    if (i<0){
        neg=да;
        i=-i;
    }
    while (i>0) {
        рез=цифра[i%10]~рез;
        i/=10;
    }
    if (neg)
        return '-'~рез;
    else
        return рез;
}
/// ditto
сим [] ctfe_i2a(дол i){
    ткст цифра="0123456789";
    ткст рез="";
    if (i==0){
        return "0";
    }
    бул neg=нет;
    if (i<0){
        neg=да;
        i=-i;
    }
    while (i>0) {
        рез=цифра[cast(т_мера)(i%10)]~рез;
        i/=10;
    }
    if (neg)
        return '-'~рез;
    else
        return рез;
}
/// ditto
сим [] ctfe_i2a(бцел i){
    ткст цифра="0123456789";
    ткст рез="";
    if (i==0){
        return "0";
    }
    бул neg=нет;
    while (i>0) {
        рез=цифра[i%10]~рез;
        i/=10;
    }
    return рез;
}
/// ditto
сим [] ctfe_i2a(бдол i){
    ткст цифра="0123456789";
    ткст рез="";
    if (i==0){
        return "0";
    }
    бул neg=нет;
    while (i>0) {
        рез=цифра[cast(т_мера)(i%10)]~рез;
        i/=10;
    }
    return рез;
}

debug( UnitTest )
{
    unittest {
    static assert( ctfe_i2a(31)=="31" );
    static assert( ctfe_i2a(-31)=="-31" );
    static assert( ctfe_i2a(14u)=="14" );
    static assert( ctfe_i2a(14L)=="14" );
    static assert( ctfe_i2a(14UL)=="14" );
    }
}
