/**
 * The Массив module provопрes Массив manИПulation routines in a manner that
 * balances performance and flexibility.  Operations are provопрed for sorting,
 * and for processing Всё sorted and unsorted массивы.
 *
 * Copyright: Copyright (C) 2005-2006 Sean Kelly.  все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Sean Kelly
 */
module core.Array;

private import core.Traits;
private import cidrus : alloca, случ;

version( TangoDoc )
{
    typedef цел Чис;
    typedef цел Элем;

    typedef бул function( Элем )       Pred1E;
    typedef бул function( Элем, Элем ) Pred2E;
    typedef т_мера function( т_мера )   Oper1A;
}


private
{
    struct Равно_ли( T )
    {
        static бул opCall( T p1, T p2 )
        {
            // TODO: Fix this if/when opEquals is изменён в_ return a бул.
            static if( is( T == class ) || is( T == struct ) )
                return (p1 == p2) != 0;
            else
                return p1 == p2;
        }
    }


    struct Меньше_ли( T )
    {
        static бул opCall( T p1, T p2 )
        {
            return p1 < p2;
        }
    }


    struct RandOper()
    {
        static т_мера opCall( т_мера lim )
        {
            // NOTE: The use of 'max' here is intended в_ eliminate modulo bias
            //       in this routine.
            т_мера макс = т_мера.max - (т_мера.max % lim);
            т_мера знач;

            do
            {
                static if( т_мера.sizeof == 4 )
                {
                    знач = (((cast(т_мера)случ()) << 16) & 0xffff0000u) |
                          (((cast(т_мера)случ()))       & 0x0000ffffu);
                }
                else // assume т_мера.sizeof == 8
                {
                    знач = (((cast(т_мера)случ()) << 48) & 0xffff000000000000uL) |
                          (((cast(т_мера)случ()) << 32) & 0x0000ffff00000000uL) |
                          (((cast(т_мера)случ()) << 16) & 0x00000000ffff0000uL) |
                          (((cast(т_мера)случ()))       & 0x000000000000ffffuL);
                }
            } while( знач > макс );
            return знач % lim;
        }
    }


    template ЭлемТипа( T )
    {
        alias typeof(T[0]) ЭлемТипа;
    }
}


////////////////////////////////////////////////////////////////////////////////
// Find
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a linear скан of буф из_ $(LB)0 .. буф.length$(RP), returning
     * the индекс of the first element matching pat, or буф.length if no match
     * was найдено.  Comparisons will be performed using the supplied predicate
     * or '==' if Неук is supplied.
     *
     * Параметры:
     *  буф  = The Массив в_ search.
     *  pat  = The образец в_ search for.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         equal в_ e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  The индекс of the first match or буф.length if no match was найдено.
     */
    т_мера найди( Элем[] буф, Элем pat, Pred2E пред = Pred2E.init );


    /**
     * Performs a linear скан of буф из_ $(LB)0 .. буф.length$(RP), returning
     * the индекс of the first element matching pat, or буф.length if no match
     * was найдено.  Comparisons will be performed using the supplied predicate
     * or '==' if Неук is supplied.
     *
     * Параметры:
     *  буф  = The Массив в_ search.
     *  pat  = The образец в_ search for.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         equal в_ e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  The индекс of the first match or буф.length if no match was найдено.
     */
    т_мера найди( Элем[] буф, Элем[] pat, Pred2E пред = Pred2E.init );

}
else
{
    template найди_( Элем, Пред = Равно_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        т_мера фн( Элем[] буф, Элем pat, Пред пред = Пред.init )
        {
            foreach( т_мера поз, Элем тек; буф )
            {
                if( пред( тек, pat ) )
                    return поз;
            }
            return буф.length;
        }


        т_мера фн( Элем[] буф, Элем[] pat, Пред пред = Пред.init )
        {
            if( буф.length == 0 ||
                pat.length == 0 ||
                буф.length < pat.length )
            {
                return буф.length;
            }

            т_мера конец = буф.length - pat.length + 1;

            for( т_мера поз = 0; поз < конец; ++поз )
            {
                if( пред( буф[поз], pat[0] ) )
                {
                    т_мера mat = 0;

                    do
                    {
                        if( ++mat >= pat.length )
                            return поз - pat.length + 1;
                        if( ++поз >= буф.length )
                            return буф.length;
                    } while( пред( буф[поз], pat[mat] ) );
                    поз -= mat;
                }
            }
            return буф.length;
        }
    }


    template найди( Буф, Pat )
    {
        т_мера найди( Буф буф, Pat pat )
        {
            return найди_!(ЭлемТипа!(Буф)).фн( буф, pat );
        }
    }


    template найди( Буф, Pat, Пред )
    {
        т_мера найди( Буф буф, Pat pat, Пред пред )
        {
            return найди_!(ЭлемТипа!(Буф), Пред).фн( буф, pat, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        // найди element
        assert( найди( "", 'a' ) == 0 );
        assert( найди( "abc", 'a' ) == 0 );
        assert( найди( "abc", 'b' ) == 1 );
        assert( найди( "abc", 'c' ) == 2 );
        assert( найди( "abc", 'd' ) == 3 );

        // пусто параметры
        assert( найди( "", "" ) == 0 );
        assert( найди( "a", "" ) == 1 );
        assert( найди( "", "a" ) == 0 );

        // exact match
        assert( найди( "abc", "abc" ) == 0 );

        // simple substring match
        assert( найди( "abc", "a" ) == 0 );
        assert( найди( "abca", "a" ) == 0 );
        assert( найди( "abc", "b" ) == 1 );
        assert( найди( "abc", "c" ) == 2 );
        assert( найди( "abc", "d" ) == 3 );

        // multi-сим substring match
        assert( найди( "abc", "ab" ) == 0 );
        assert( найди( "abcab", "ab" ) == 0 );
        assert( найди( "abc", "bc" ) == 1 );
        assert( найди( "abc", "ac" ) == 3 );
        assert( найди( "abrabracadabra", "abracadabra" ) == 3 );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Реверсни Find
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a linear скан of буф из_ $(LP)буф.length .. 0$(RB), returning
     * the индекс of the first element matching pat, or буф.length if no match
     * was найдено.  Comparisons will be performed using the supplied predicate
     * or '==' if Неук is supplied.
     *
     * Параметры:
     *  буф  = The Массив в_ search.
     *  pat  = The образец в_ search for.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         equal в_ e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  The индекс of the first match or буф.length if no match was найдено.
     */
    т_мера найдрек( Элем[] буф, Элем pat, Pred2E пред = Pred2E.init );


    /**
     * Performs a linear скан of буф из_ $(LP)буф.length .. 0$(RB), returning
     * the индекс of the first element matching pat, or буф.length if no match
     * was найдено.  Comparisons will be performed using the supplied predicate
     * or '==' if Неук is supplied.
     *
     * Параметры:
     *  буф  = The Массив в_ search.
     *  pat  = The образец в_ search for.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         equal в_ e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  The индекс of the first match or буф.length if no match was найдено.
     */
    т_мера найдрек( Элем[] буф, Элем[] pat, Pred2E пред = Pred2E.init );
}
else
{
    template найдрек_( Элем, Пред = Равно_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        т_мера фн( Элем[] буф, Элем pat, Пред пред = Пред.init )
        {
            if( буф.length == 0 )
                return буф.length;

            т_мера поз = буф.length;

            do
            {
                if( пред( буф[--поз], pat ) )
                    return поз;
            } while( поз > 0 );
            return буф.length;
        }


        т_мера фн( Элем[] буф, Элем[] pat, Пред пред = Пред.init )
        {
            if( буф.length == 0 ||
                pat.length == 0 ||
                буф.length < pat.length )
            {
                return буф.length;
            }

            т_мера поз = буф.length - pat.length + 1;

            do
            {
                if( пред( буф[--поз], pat[0] ) )
                {
                    т_мера mat = 0;

                    do
                    {
                        if( ++mat >= pat.length )
                            return поз - pat.length + 1;
                        if( ++поз >= буф.length )
                            return буф.length;
                    } while( пред( буф[поз], pat[mat] ) );
                    поз -= mat;
                }
            } while( поз > 0 );
            return буф.length;
        }
    }


    template найдрек( Буф, Pat )
    {
        т_мера найдрек( Буф буф, Pat pat )
        {
            return найдрек_!(ЭлемТипа!(Буф)).фн( буф, pat );
        }
    }


    template найдрек( Буф, Pat, Пред )
    {
        т_мера найдрек( Буф буф, Pat pat, Пред пред )
        {
            return найдрек_!(ЭлемТипа!(Буф), Пред).фн( буф, pat, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        // найдрек element
        assert( найдрек( "", 'a' ) == 0 );
        assert( найдрек( "abc", 'a' ) == 0 );
        assert( найдрек( "abc", 'b' ) == 1 );
        assert( найдрек( "abc", 'c' ) == 2 );
        assert( найдрек( "abc", 'd' ) == 3 );

        // пусто параметры
        assert( найдрек( "", "" ) == 0 );
        assert( найдрек( "a", "" ) == 1 );
        assert( найдрек( "", "a" ) == 0 );

        // exact match
        assert( найдрек( "abc", "abc" ) == 0 );

        // simple substring match
        assert( найдрек( "abc", "a" ) == 0 );
        assert( найдрек( "abca", "a" ) == 3 );
        assert( найдрек( "abc", "b" ) == 1 );
        assert( найдрек( "abc", "c" ) == 2 );
        assert( найдрек( "abc", "d" ) == 3 );

        // multi-сим substring match
        assert( найдрек( "abc", "ab" ) == 0 );
        assert( найдрек( "abcab", "ab" ) == 3 );
        assert( найдрек( "abc", "bc" ) == 1 );
        assert( найдрек( "abc", "ac" ) == 3 );
        assert( найдрек( "abracadabrabra", "abracadabra" ) == 0 );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// KMP Find
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a linear скан of буф из_ $(LB)0 .. буф.length$(RP), returning
     * the индекс of the first element matching pat, or буф.length if no match
     * was найдено.  Comparisons will be performed using the supplied predicate
     * or '==' if Неук is supplied.
     *
     * This function uses the KMP algorithm and offers O(M+N) performance but
     * must размести a temporary буфер of размер pat.sizeof в_ do so.  If it is
     * available on the мишень system, alloca will be used for the allocation,
     * otherwise a стандарт dynamic память allocation will occur.
     *
     * Параметры:
     *  буф  = The Массив в_ search.
     *  pat  = The образец в_ search for.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         equal в_ e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  The индекс of the first match or буф.length if no match was найдено.
     */
    т_мера кнайди( Элем[] буф, Элем pat, Pred2E пред = Pred2E.init );


    /**
     * Performs a linear скан of буф из_ $(LB)0 .. буф.length$(RP), returning
     * the индекс of the first element matching pat, or буф.length if no match
     * was найдено.  Comparisons will be performed using the supplied predicate
     * or '==' if Неук is supplied.
     *
     * This function uses the KMP algorithm and offers O(M+N) performance but
     * must размести a temporary буфер of размер pat.sizeof в_ do so.  If it is
     * available on the мишень system, alloca will be used for the allocation,
     * otherwise a стандарт dynamic память allocation will occur.
     *
     * Параметры:
     *  буф  = The Массив в_ search.
     *  pat  = The образец в_ search for.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         equal в_ e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  The индекс of the first match or буф.length if no match was найдено.
     */
    т_мера кнайди( Элем[] буф, Элем[] pat, Pred2E пред = Pred2E.init );
}
else
{
    template кнайди_( Элем, Пред = Равно_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        т_мера фн( Элем[] буф, Элем pat, Пред пред = Пред.init )
        {
            foreach( т_мера поз, Элем тек; буф )
            {
                if( пред( тек, pat ) )
                    return поз;
            }
            return буф.length;
        }


        т_мера фн( Элем[] буф, Элем[] pat, Пред пред = Пред.init )
        {
            if( буф.length == 0 ||
                pat.length == 0 ||
                буф.length < pat.length )
            {
                return буф.length;
            }

            static if( is( alloca ) ) // always нет, alloca usage should be rethought
            {
                т_мера[] func = (cast(т_мера*) alloca( (pat.length + 1) * т_мера.sizeof ))[0 .. pat.length + 1];
            }
            else
            {
                т_мера[] func = new т_мера[pat.length + 1];
                scope( exit ) delete func; // force cleanup
            }

            func[0] = 0;

            //
            // building префикс-function
            //
            for( т_мера m = 0, i = 1 ; i < pat.length ; ++i )
            {
                while( ( m > 0 ) && !пред( pat[m], pat[i] ) )
                    m = func[m - 1];
                if( пред( pat[m], pat[i] ) )
                    ++m;
                func[i] = m;
            }

            //
            // searching
            //
            for( т_мера m = 0, i = 0; i < буф.length; ++i )
            {
                while( ( m > 0 ) && !пред( pat[m], буф[i] ) )
                    m = func[m - 1];
                if( пред( pat[m], буф[i] ) )
                {
                    ++m;
                    if( m == pat.length )
                    {
                        return i - pat.length + 1;
                    }
                }
            }

            return буф.length;
        }
    }


    template кнайди( Буф, Pat )
    {
        т_мера кнайди( Буф буф, Pat pat )
        {
            return кнайди_!(ЭлемТипа!(Буф)).фн( буф, pat );
        }
    }


    template кнайди( Буф, Pat, Пред )
    {
        т_мера кнайди( Буф буф, Pat pat, Пред пред )
        {
            return кнайди_!(ЭлемТипа!(Буф), Пред).фн( буф, pat, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        // найди element
        assert( кнайди( "", 'a' ) == 0 );
        assert( кнайди( "abc", 'a' ) == 0 );
        assert( кнайди( "abc", 'b' ) == 1 );
        assert( кнайди( "abc", 'c' ) == 2 );
        assert( кнайди( "abc", 'd' ) == 3 );

        // пусто параметры
        assert( кнайди( "", "" ) == 0 );
        assert( кнайди( "a", "" ) == 1 );
        assert( кнайди( "", "a" ) == 0 );

        // exact match
        assert( кнайди( "abc", "abc" ) == 0 );

        // simple substring match
        assert( кнайди( "abc", "a" ) == 0 );
        assert( кнайди( "abca", "a" ) == 0 );
        assert( кнайди( "abc", "b" ) == 1 );
        assert( кнайди( "abc", "c" ) == 2 );
        assert( кнайди( "abc", "d" ) == 3 );

        // multi-сим substring match
        assert( кнайди( "abc", "ab" ) == 0 );
        assert( кнайди( "abcab", "ab" ) == 0 );
        assert( кнайди( "abc", "bc" ) == 1 );
        assert( кнайди( "abc", "ac" ) == 3 );
        assert( кнайди( "abrabracadabra", "abracadabra" ) == 3 );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// KMP Реверсни Find
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a linear скан of буф из_ $(LP)буф.length .. 0$(RB), returning
     * the индекс of the first element matching pat, or буф.length if no match
     * was найдено.  Comparisons will be performed using the supplied predicate
     * or '==' if Неук is supplied.
     *
     * This function uses the KMP algorithm and offers O(M+N) performance but
     * must размести a temporary буфер of размер pat.sizeof в_ do so.  If it is
     * available on the мишень system, alloca will be used for the allocation,
     * otherwise a стандарт dynamic память allocation will occur.
     *
     * Параметры:
     *  буф  = The Массив в_ search.
     *  pat  = The образец в_ search for.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         equal в_ e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  The индекс of the first match or буф.length if no match was найдено.
     */
    т_мера кнайдрек( Элем[] буф, Элем pat, Pred2E пред = Pred2E.init );


    /**
     * Performs a linear скан of буф из_ $(LP)буф.length .. 0$(RB), returning
     * the индекс of the first element matching pat, or буф.length if no match
     * was найдено.  Comparisons will be performed using the supplied predicate
     * or '==' if Неук is supplied.
     *
     * This function uses the KMP algorithm and offers O(M+N) performance but
     * must размести a temporary буфер of размер pat.sizeof в_ do so.  If it is
     * available on the мишень system, alloca will be used for the allocation,
     * otherwise a стандарт dynamic память allocation will occur.
     *
     * Параметры:
     *  буф  = The Массив в_ search.
     *  pat  = The образец в_ search for.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         equal в_ e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  The индекс of the first match or буф.length if no match was найдено.
     */
    т_мера кнайдрек( Элем[] буф, Элем[] pat, Pred2E пред = Pred2E.init );
}
else
{
    template кнайдрек_( Элем, Пред = Равно_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        т_мера фн( Элем[] буф, Элем pat, Пред пред = Пред.init )
        {
            if( буф.length == 0 )
                return буф.length;

            т_мера поз = буф.length;

            do
            {
                if( пред( буф[--поз], pat ) )
                    return поз;
            } while( поз > 0 );
            return буф.length;
        }


        т_мера фн( Элем[] буф, Элем[] pat, Пред пред = Пред.init )
        {
            if( буф.length == 0 ||
                pat.length == 0 ||
                буф.length < pat.length )
            {
                return буф.length;
            }

            static if( is( alloca ) ) // always нет, alloca usage should be rethought
            {
                т_мера[] func = (cast(т_мера*) alloca( (pat.length + 1) * т_мера.sizeof ))[0 .. pat.length + 1];
            }
            else
            {
                т_мера[] func = new т_мера[pat.length + 1];
                scope( exit ) delete func; // force cleanup
            }

            func[$ - 1] = 0;

            //
            // building префикс-function
            //
            for( т_мера m = 0, i = pat.length - 1; i > 0; --i )
            {
                while( ( m > 0 ) && !пред( pat[length - m - 1], pat[i - 1] ) )
                    m = func[length - m];
                if( пред( pat[length - m - 1], pat[i - 1] ) )
                    ++m;
                func[i - 1] = m;
            }

            //
            // searching
            //
            т_мера  m = 0;
            т_мера  i = буф.length;
            do
            {
                --i;
                while( ( m > 0 ) && !пред( pat[length - m - 1], буф[i] ) )
                    m = func[length - m - 1];
                if( пред( pat[length - m - 1], буф[i] ) )
                {
                    ++m;
                    if ( m == pat.length )
                    {
                        return i;
                    }
                }
            } while( i > 0 );

            return буф.length;
        }
    }


    template кнайдрек( Буф, Pat )
    {
        т_мера кнайдрек( Буф буф, Pat pat )
        {
            return кнайдрек_!(ЭлемТипа!(Буф)).фн( буф, pat );
        }
    }


    template кнайдрек( Буф, Pat, Пред )
    {
        т_мера кнайдрек( Буф буф, Pat pat, Пред пред )
        {
            return кнайдрек_!(ЭлемТипа!(Буф), Пред).фн( буф, pat, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        // найдрек element
        assert( кнайдрек( "", 'a' ) == 0 );
        assert( кнайдрек( "abc", 'a' ) == 0 );
        assert( кнайдрек( "abc", 'b' ) == 1 );
        assert( кнайдрек( "abc", 'c' ) == 2 );
        assert( кнайдрек( "abc", 'd' ) == 3 );

        // пусто параметры
        assert( кнайдрек( "", "" ) == 0 );
        assert( кнайдрек( "a", "" ) == 1 );
        assert( кнайдрек( "", "a" ) == 0 );

        // exact match
        assert( кнайдрек( "abc", "abc" ) == 0 );

        // simple substring match
        assert( кнайдрек( "abc", "a" ) == 0 );
        assert( кнайдрек( "abca", "a" ) == 3 );
        assert( кнайдрек( "abc", "b" ) == 1 );
        assert( кнайдрек( "abc", "c" ) == 2 );
        assert( кнайдрек( "abc", "d" ) == 3 );

        // multi-сим substring match
        assert( кнайдрек( "abc", "ab" ) == 0 );
        assert( кнайдрек( "abcab", "ab" ) == 3 );
        assert( кнайдрек( "abc", "bc" ) == 1 );
        assert( кнайдрек( "abc", "ac" ) == 3 );
        assert( кнайдрек( "abracadabrabra", "abracadabra" ) == 0 );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Find-If
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a linear скан of буф из_ $(LB)0 .. буф.length$(RP), returning
     * the индекс of the first element where пред returns да.
     *
     * Параметры:
     *  буф  = The Массив в_ search.
     *  пред = The evaluation predicate, which should return да if the
     *         element is a valid match and нет if not.  This predicate
     *         may be any callable тип.
     *
     * Возвращает:
     *  The индекс of the first match or буф.length if no match was найдено.
     */
    т_мера найдиЕсли( Элем[] буф, Pred1E пред );
}
else
{
    template найдиЕсли_( Элем, Пред )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        т_мера фн( Элем[] буф, Пред пред )
        {
            foreach( т_мера поз, Элем тек; буф )
            {
                if( пред( тек ) )
                    return поз;
            }
            return буф.length;
        }
    }


    template найдиЕсли( Буф, Пред )
    {
        т_мера найдиЕсли( Буф буф, Пред пред )
        {
            return найдиЕсли_!(ЭлемТипа!(Буф), Пред).фн( буф, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        assert( найдиЕсли( "bcecg", ( сим c ) { return c == 'a'; } ) == 5 );
        assert( найдиЕсли( "bcecg", ( сим c ) { return c == 'b'; } ) == 0 );
        assert( найдиЕсли( "bcecg", ( сим c ) { return c == 'c'; } ) == 1 );
        assert( найдиЕсли( "bcecg", ( сим c ) { return c == 'd'; } ) == 5 );
        assert( найдиЕсли( "bcecg", ( сим c ) { return c == 'g'; } ) == 4 );
        assert( найдиЕсли( "bcecg", ( сим c ) { return c == 'h'; } ) == 5 );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Реверсни Find-If
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a linear скан of буф из_ $(LP)буф.length .. 0$(RB), returning
     * the индекс of the first element where пред returns да.
     *
     * Параметры:
     *  буф  = The Массив в_ search.
     *  пред = The evaluation predicate, which should return да if the
     *         element is a valid match and нет if not.  This predicate
     *         may be any callable тип.
     *
     * Возвращает:
     *  The индекс of the first match or буф.length if no match was найдено.
     */
    т_мера найдрекЕсли( Элем[] буф, Pred1E пред );
}
else
{
    template найдрекЕсли_( Элем, Пред )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        т_мера фн( Элем[] буф, Пред пред )
        {
            if( буф.length == 0 )
                return буф.length;

            т_мера поз = буф.length;

            do
            {
                if( пред( буф[--поз] ) )
                    return поз;
            } while( поз > 0 );
            return буф.length;
        }
    }


    template найдрекЕсли( Буф, Пред )
    {
        т_мера найдрекЕсли( Буф буф, Пред пред )
        {
            return найдрекЕсли_!(ЭлемТипа!(Буф), Пред).фн( буф, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        assert( найдрекЕсли( "bcecg", ( сим c ) { return c == 'a'; } ) == 5 );
        assert( найдрекЕсли( "bcecg", ( сим c ) { return c == 'b'; } ) == 0 );
        assert( найдрекЕсли( "bcecg", ( сим c ) { return c == 'c'; } ) == 3 );
        assert( найдрекЕсли( "bcecg", ( сим c ) { return c == 'd'; } ) == 5 );
        assert( найдрекЕсли( "bcecg", ( сим c ) { return c == 'g'; } ) == 4 );
        assert( найдрекЕсли( "bcecg", ( сим c ) { return c == 'h'; } ) == 5 );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Find Adjacent
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a linear скан of буф из_ $(LB)0 .. буф.length$(RP), returning
     * the индекс of the first element that compares equal в_ the следщ element
     * in the sequence.  Comparisons will be performed using the supplied
     * predicate or '==' if Неук is supplied.
     *
     * Параметры:
     *  буф  = The Массив в_ скан.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         equal в_ e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  The индекс of the first match or буф.length if no match was найдено.
     */
    т_мера findAdj( Элем[] буф, Элем pat, Pred2E пред = Pred2E.init );

}
else
{
    template findAdj_( Элем, Пред = Равно_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        т_мера фн( Элем[] буф, Пред пред = Пред.init )
        {
            if( буф.length < 2 )
                return буф.length;

            Элем sav = буф[0];

            foreach( т_мера поз, Элем тек; буф[1 .. $] )
            {
                if( пред( тек, sav ) )
                    return поз;
                sav = тек;
            }
            return буф.length;
        }
    }


    template findAdj( Буф )
    {
        т_мера findAdj( Буф буф )
        {
            return findAdj_!(ЭлемТипа!(Буф)).фн( буф );
        }
    }


    template findAdj( Буф, Пред )
    {
        т_мера findAdj( Буф буф, Пред пред )
        {
            return findAdj_!(ЭлемТипа!(Буф), Пред).фн( буф, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        assert( findAdj( "aabcdef" ) == 0 );
        assert( findAdj( "abcddef" ) == 3 );
        assert( findAdj( "abcdeff" ) == 5 );
        assert( findAdj( "abcdefg" ) == 7 );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Contains
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a linear скан of буф из_ $(LB)0 .. буф.length$(RP), returning
     * да if an element matching pat is найдено.  Comparisons will be performed
     * using the supplied predicate or '<' if Неук is supplied.
     *
     * Параметры:
     *  буф  = The Массив в_ search.
     *  pat  = The образец в_ search for.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         equal в_ e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  Да if an element equivalent в_ pat is найдено, нет if not.
     */
    т_равно содержит( Элем[] буф, Элем pat, Pred2E пред = Pred2E.init );


    /**
     * Performs a linear скан of буф из_ $(LB)0 .. буф.length$(RP), returning
     * да if a sequence matching pat is найдено.  Comparisons will be performed
     * using the supplied predicate or '<' if Неук is supplied.
     *
     * Параметры:
     *  буф  = The Массив в_ search.
     *  pat  = The образец в_ search for.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         equal в_ e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  Да if an element equivalent в_ pat is найдено, нет if not.
     */
    т_равно содержит( Элем[] буф, Элем[] pat, Pred2E пред = Pred2E.init );
}
else
{
    template содержит( Буф, Pat )
    {
        т_равно содержит( Буф буф, Pat pat )
        {
            return cast(т_равно)(найди( буф, pat ) != буф.length);
        }
    }


    template содержит( Буф, Pat, Пред )
    {
        т_равно содержит( Буф буф, Pat pat, Пред пред )
        {
            return cast(т_равно)(найди( буф, pat, пред ) != буф.length);
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        // найди element
        assert( !содержит( "", 'a' ) );
        assert(  содержит( "abc", 'a' ) );
        assert(  содержит( "abc", 'b' ) );
        assert(  содержит( "abc", 'c' ) );
        assert( !содержит( "abc", 'd' ) );

        // пусто параметры
        assert( !содержит( "", "" ) );
        assert( !содержит( "a", "" ) );
        assert( !содержит( "", "a" ) );

        // exact match
        assert(  содержит( "abc", "abc" ) );

        // simple substring match
        assert(  содержит( "abc", "a" ) );
        assert(  содержит( "abca", "a" ) );
        assert(  содержит( "abc", "b" ) );
        assert(  содержит( "abc", "c" ) );
        assert( !содержит( "abc", "d" ) );

        // multi-сим substring match
        assert(  содержит( "abc", "ab" ) );
        assert(  содержит( "abcab", "ab" ) );
        assert(  содержит( "abc", "bc" ) );
        assert( !содержит( "abc", "ac" ) );
        assert(  содержит( "abrabracadabra", "abracadabra" ) );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Mismatch
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a parallel linear скан of bufA and bufB из_ $(LB)0 .. N$(RP)
     * where N = min$(LP)bufA.length, bufB.length$(RP), returning the индекс of
     * the first element in bufA which does not match the corresponding element
     * in bufB or N if no не_совпадают occurs.  Comparisons will be performed using
     * the supplied predicate or '==' if Неук is supplied.
     *
     * Параметры:
     *  bufA = The Массив в_ evaluate.
     *  bufB = The Массив в_ match against.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         equal в_ e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  The индекс of the first не_совпадают or N if the first N elements of bufA
     * and bufB match, where N = min$(LP)bufA.length, bufB.length$(RP).
     */
    т_мера не_совпадают( Элем[] bufA, Элем[] bufB, Pred2E пред = Pred2E.init );

}
else
{
    template не_совпадают_( Элем, Пред = Равно_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        т_мера фн( Элем[] bufA, Элем[] bufB, Пред пред = Пред.init )
        {
            т_мера  posA = 0,
                    posB = 0;

            while( posA < bufA.length && posB < bufB.length )
            {
                if( !пред( bufB[posB], bufA[posA] ) )
                    break;
                ++posA, ++posB;
            }
            return posA;
        }
    }


    template не_совпадают( BufA, BufB )
    {
        т_мера не_совпадают( BufA bufA, BufB bufB )
        {
            return не_совпадают_!(ЭлемТипа!(BufA)).фн( bufA, bufB );
        }
    }


    template не_совпадают( BufA, BufB, Пред )
    {
        т_мера не_совпадают( BufA bufA, BufB bufB, Пред пред )
        {
            return не_совпадают_!(ЭлемТипа!(BufA), Пред).фн( bufA, bufB, пред );
        }
    }

    debug( UnitTest )
    {
      unittest
      {
        assert( не_совпадают( "a", "abcdefg" ) == 1 );
        assert( не_совпадают( "abcdefg", "a" ) == 1 );

        assert( не_совпадают( "x", "abcdefg" ) == 0 );
        assert( не_совпадают( "abcdefg", "x" ) == 0 );

        assert( не_совпадают( "xbcdefg", "abcdefg" ) == 0 );
        assert( не_совпадают( "abcdefg", "xbcdefg" ) == 0 );

        assert( не_совпадают( "abcxefg", "abcdefg" ) == 3 );
        assert( не_совпадают( "abcdefg", "abcxefg" ) == 3 );

        assert( не_совпадают( "abcdefx", "abcdefg" ) == 6 );
        assert( не_совпадают( "abcdefg", "abcdefx" ) == 6 );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Count
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a linear скан of буф из_ $(LB)0 .. буф.length$(RP), returning
     * a счёт of the число of elements matching pat.  Comparisons will be
     * performed using the supplied predicate or '==' if Неук is supplied.
     *
     * Параметры:
     *  буф  = The Массив в_ скан.
     *  pat  = The образец в_ match.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         equal в_ e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  The число of elements matching pat.
     */
    т_мера счёт( Элем[] буф, Элем pat, Pred2E пред = Pred2E.init );

}
else
{
    template count_( Элем, Пред = Равно_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        т_мера фн( Элем[] буф, Элем pat, Пред пред = Пред.init )
        {
            т_мера cnt = 0;

            foreach( т_мера поз, Элем тек; буф )
            {
                if( пред( тек, pat ) )
                    ++cnt;
            }
            return cnt;
        }
    }


    template счёт( Буф, Pat )
    {
        т_мера счёт( Буф буф, Pat pat )
        {
            return count_!(ЭлемТипа!(Буф)).фн( буф, pat );
        }
    }


    template счёт( Буф, Pat, Пред )
    {
        т_мера счёт( Буф буф, Pat pat, Пред пред )
        {
            return count_!(ЭлемТипа!(Буф), Пред).фн( буф, pat, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        assert( счёт( "gbbbi", 'a' ) == 0 );
        assert( счёт( "gbbbi", 'g' ) == 1 );
        assert( счёт( "gbbbi", 'b' ) == 3 );
        assert( счёт( "gbbbi", 'i' ) == 1 );
        assert( счёт( "gbbbi", 'd' ) == 0 );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Count-If
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a linear скан of буф из_ $(LB)0 .. буф.length$(RP), returning
     * a счёт of the число of elements where пред returns да.
     *
     * Параметры:
     *  буф  = The Массив в_ скан.
     *  пред = The evaluation predicate, which should return да if the
     *         element is a valid match and нет if not.  This predicate
     *         may be any callable тип.
     *
     * Возвращает:
     *  The число of elements where пред returns да.
     */
    т_мера countIf( Элем[] буф, Pred1E пред = Pred1E.init );

}
else
{
    template countIf_( Элем, Пред )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        т_мера фн( Элем[] буф, Пред пред )
        {
            т_мера cnt = 0;

            foreach( т_мера поз, Элем тек; буф )
            {
                if( пред( тек ) )
                    ++cnt;
            }
            return cnt;
        }
    }


    template countIf( Буф, Пред )
    {
        т_мера countIf( Буф буф, Пред пред )
        {
            return countIf_!(ЭлемТипа!(Буф), Пред).фн( буф, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        assert( countIf( "gbbbi", ( сим c ) { return c == 'a'; } ) == 0 );
        assert( countIf( "gbbbi", ( сим c ) { return c == 'g'; } ) == 1 );
        assert( countIf( "gbbbi", ( сим c ) { return c == 'b'; } ) == 3 );
        assert( countIf( "gbbbi", ( сим c ) { return c == 'i'; } ) == 1 );
        assert( countIf( "gbbbi", ( сим c ) { return c == 'd'; } ) == 0 );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Замени
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a linear скан of буф из_ $(LB)0 .. буф.length$(RP), replacing
     * occurrences of pat with знач.  Comparisons will be performed using the
     * supplied predicate or '==' if Неук is supplied.
     *
     * Параметры:
     *  буф  = The Массив в_ скан.
     *  pat  = The образец в_ match.
     *  знач  = The значение в_ подставь.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         equal в_ e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  The число of elements replaced.
     */
    т_мера замени( Элем[] буф, Элем pat, Элем знач, Pred2E пред = Pred2E.init );

}
else
{
    template замени_( Элем, Пред = Равно_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        т_мера фн( Элем[] буф, Элем pat, Элем знач, Пред пред = Пред.init )
        {
            т_мера cnt = 0;

            foreach( т_мера поз, ref Элем тек; буф )
            {
                if( пред( тек, pat ) )
                {
                    тек = знач;
                    ++cnt;
                }
            }
            return cnt;
        }
    }


    template замени( Буф, Элем )
    {
        т_мера замени( Буф буф, Элем pat, Элем знач )
        {
            return замени_!(ЭлемТипа!(Буф)).фн( буф, pat, знач );
        }
    }


    template замени( Буф, Элем, Пред )
    {
        т_мера замени( Буф буф, Элем pat, Элем знач, Пред пред )
        {
            return замени_!(ЭлемТипа!(Буф), Пред).фн( буф, pat, знач, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        assert( замени( "gbbbi".dup, 'a', 'b' ) == 0 );
        assert( замени( "gbbbi".dup, 'g', 'h' ) == 1 );
        assert( замени( "gbbbi".dup, 'b', 'c' ) == 3 );
        assert( замени( "gbbbi".dup, 'i', 'j' ) == 1 );
        assert( замени( "gbbbi".dup, 'd', 'e' ) == 0 );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Замени-If
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a linear скан of буф из_ $(LB)0 .. буф.length$(RP), replacing
     * elements where пред returns да with знач.
     *
     * Параметры:
     *  буф  = The Массив в_ скан.
     *  знач  = The значение в_ подставь.
     *  пред = The evaluation predicate, which should return да if the
     *         element is a valid match and нет if not.  This predicate
     *         may be any callable тип.
     *
     * Возвращает:
     *  The число of elements replaced.
     */
    т_мера замениЕсли( Элем[] буф, Элем знач, Pred2E пред = Pred2E.init );

}
else
{
    template замениЕсли_( Элем, Пред )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        т_мера фн( Элем[] буф, Элем знач, Пред пред )
        {
            т_мера cnt = 0;

            foreach( т_мера поз, ref Элем тек; буф )
            {
                if( пред( тек ) )
                {
                    тек = знач;
                    ++cnt;
                }
            }
            return cnt;
        }
    }


    template замениЕсли( Буф, Элем, Пред )
    {
        т_мера замениЕсли( Буф буф, Элем знач, Пред пред )
        {
            return замениЕсли_!(ЭлемТипа!(Буф), Пред).фн( буф, знач, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        assert( замениЕсли( "gbbbi".dup, 'b', ( сим c ) { return c == 'a'; } ) == 0 );
        assert( замениЕсли( "gbbbi".dup, 'h', ( сим c ) { return c == 'g'; } ) == 1 );
        assert( замениЕсли( "gbbbi".dup, 'c', ( сим c ) { return c == 'b'; } ) == 3 );
        assert( замениЕсли( "gbbbi".dup, 'j', ( сим c ) { return c == 'i'; } ) == 1 );
        assert( замениЕсли( "gbbbi".dup, 'e', ( сим c ) { return c == 'd'; } ) == 0 );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Удали
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a linear скан of буф из_ $(LB)0 .. буф.length$(RP), moving все
     * elements matching pat в_ the конец of the sequence.  The relative order of
     * elements not matching pat will be preserved.  Comparisons will be
     * performed using the supplied predicate or '==' if Неук is supplied.
     *
     * Параметры:
     *  буф  = The Массив в_ скан.  This parameter is not marked 'ref'
     *         в_ allow temporary slices в_ be изменён.  As буф is not resized
     *         in any way, omitting the 'ref' qualifier есть no effect on the
     *         результат of this operation, even though it may be viewed as a
     *         sопрe-effect.
     *  pat  = The образец в_ match against.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         equal в_ e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  The число of elements that do not match pat.
     */
    т_мера удали( Элем[] буф, Элем pat, Pred2E пред = Pred2E.init );

    /**
     * Performs a linear скан of буф из_ $(LB)0 .. буф.length$(RP), moving все
     * elements matching pat в_ the конец of the sequence.  The relative order of
     * elements not matching pat will be preserved.  Comparisons will be
     * performed '=='.
     *
     * Параметры:
     *  буф  = The Массив в_ скан.  This parameter is not marked 'ref'
     *         в_ allow temporary slices в_ be изменён.  As буф is not resized
     *         in any way, omitting the 'ref' qualifier есть no effect on the
     *         результат of this operation, even though it may be viewed as a
     *         sопрe-effect.
     *  pat  = The образец в_ match against.
     *
     * Возвращает:
     *  The число of elements that do not match pat.
     */
    т_мера удали( Элем[] буф, Элем pat );
}
else
{
    template удали_( Элем, Пред = Равно_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        т_мера фн( Элем[] буф, Элем pat, Пред пред = Пред.init )
        {
            // NOTE: Indexes are passed instead of references because DMD does
            //       not inline the reference-based version.
            проц exch( т_мера p1, т_мера p2 )
            {
                Элем t  = буф[p1];
                буф[p1] = буф[p2];
                буф[p2] = t;
            }

            т_мера cnt = 0;

            for( т_мера поз = 0, длин = буф.length; поз < длин; ++поз )
            {
                if( пред( буф[поз], pat ) )
                    ++cnt;
                else
                    exch( поз, поз - cnt );
            }
            return буф.length - cnt;
        }
    }


    template удали( Буф, Pat )
    {
        т_мера удали( Буф буф, Pat pat )
        {
            return удали_!(ЭлемТипа!(Буф)).фн( буф, pat );
        }
    }


    template удали( Буф, Pat, Пред )
    {
        т_мера удали( Буф буф, Pat pat, Пред пред )
        {
            return удали_!(ЭлемТипа!(Буф), Пред).фн( буф, pat, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        проц тест( ткст буф, сим pat, т_мера num )
        {
            assert( удали( буф, pat ) == num );
            foreach( поз, тек; буф )
            {
                assert( поз < num ? тек != pat : тек == pat );
            }
        }

        тест( "abcdefghij".dup, 'x', 10 );
        тест( "xabcdefghi".dup, 'x',  9 );
        тест( "abcdefghix".dup, 'x',  9 );
        тест( "abxxcdefgh".dup, 'x',  8 );
        тест( "xaxbcdxxex".dup, 'x',  5 );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Удали-If
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a linear скан of буф из_ $(LB)0 .. буф.length$(RP), moving все
     * elements that satisfy пред в_ the конец of the sequence.  The relative
     * order of elements that do not satisfy пред will be preserved.
     *
     * Параметры:
     *  буф  = The Массив в_ скан.  This parameter is not marked 'ref'
     *         в_ allow temporary slices в_ be изменён.  As буф is not resized
     *         in any way, omitting the 'ref' qualifier есть no effect on the
     *         результат of this operation, even though it may be viewed as a
     *         sопрe-effect.
     *  пред = The evaluation predicate, which should return да if the
     *         element satisfies the condition and нет if not.  This
     *         predicate may be any callable тип.
     *
     * Возвращает:
     *  The число of elements that do not satisfy пред.
     */
    т_мера удалиЕсли( Элем[] буф, Pred1E пред );
}
else
{
    template удалиЕсли_( Элем, Пред )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        т_мера фн( Элем[] буф, Пред пред )
        {
            // NOTE: Indexes are passed instead of references because DMD does
            //       not inline the reference-based version.
            проц exch( т_мера p1, т_мера p2 )
            {
                Элем t  = буф[p1];
                буф[p1] = буф[p2];
                буф[p2] = t;
            }

            т_мера cnt = 0;

            for( т_мера поз = 0, длин = буф.length; поз < длин; ++поз )
            {
                if( пред( буф[поз] ) )
                    ++cnt;
                else
                    exch( поз, поз - cnt );
            }
            return буф.length - cnt;
        }
    }


    template удалиЕсли( Буф, Пред )
    {
        т_мера удалиЕсли( Буф буф, Пред пред )
        {
            return удалиЕсли_!(ЭлемТипа!(Буф), Пред).фн( буф, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        проц тест( ткст буф, бул delegate( сим ) дг, т_мера num )
        {
            assert( удалиЕсли( буф, дг ) == num );
            foreach( поз, тек; буф )
            {
                assert( поз < num ? !дг( тек ) : дг( тек ) );
            }
        }

        тест( "abcdefghij".dup, ( сим c ) { return c == 'x'; }, 10 );
        тест( "xabcdefghi".dup, ( сим c ) { return c == 'x'; },  9 );
        тест( "abcdefghix".dup, ( сим c ) { return c == 'x'; },  9 );
        тест( "abxxcdefgh".dup, ( сим c ) { return c == 'x'; },  8 );
        тест( "xaxbcdxxex".dup, ( сим c ) { return c == 'x'; },  5 );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Уникум
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a linear скан of буф из_ $(LB)0 .. буф.length$(RP), moving все
     * but the first element of each consecutive группа of duplicate elements в_
     * the конец of the sequence.  The relative order of все remaining elements
     * will be preserved.  Comparisons will be performed using the supplied
     * predicate or '==' if Неук is supplied.
     *
     * Параметры:
     *  буф  = The Массив в_ скан.  This parameter is not marked 'ref'
     *         в_ allow temporary slices в_ be изменён.  As буф is not resized
     *         in any way, omitting the 'ref' qualifier есть no effect on the
     *         результат of this operation, even though it may be viewed as a
     *         sопрe-effect.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         equal в_ e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  The число of distinct sub-sequences in буф.
     */
    т_мера distinct( Элем[] буф, Pred2E пред = Pred2E.init );
}
else
{
    template distinct_( Элем, Пред = Равно_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        т_мера фн( Элем[] буф, Пред пред = Пред.init )
        {
            // NOTE: Indexes are passed instead of references because DMD does
            //       not inline the reference-based version.
            проц exch( т_мера p1, т_мера p2 )
            {
                Элем t  = буф[p1];
                буф[p1] = буф[p2];
                буф[p2] = t;
            }

            if( буф.length < 2 )
                return буф.length;

            т_мера cnt = 0;
            Элем   pat = буф[0];

            for( т_мера поз = 1, длин = буф.length; поз < длин; ++поз )
            {
                if( пред( буф[поз], pat ) )
                    ++cnt;
                else
                {
                    pat = буф[поз];
                    exch( поз, поз - cnt );
                }
            }
            return буф.length - cnt;
        }
    }


    template distinct( Буф )
    {
        т_мера distinct( Буф буф )
        {
            return distinct_!(ЭлемТипа!(Буф)).фн( буф );
        }
    }


    template distinct( Буф, Пред )
    {
        т_мера distinct( Буф буф, Пред пред )
        {
            return distinct_!(ЭлемТипа!(Буф), Пред).фн( буф, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        проц тест( ткст буф, ткст pat )
        {
            assert( distinct( буф ) == pat.length );
            foreach( поз, тек; pat )
            {
                assert( буф[поз] == тек );
            }
        }

        тест( "abcdefghij".dup, "abcdefghij" );
        тест( "aabcdefghi".dup, "abcdefghi" );
        тест( "bcdefghijj".dup, "bcdefghij" );
        тест( "abccdefghi".dup, "abcdefghi" );
        тест( "abccdddefg".dup, "abcdefg" );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Shuffle
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a linear скан of буф из_ $(LB)2 .. буф.length$(RP), exchanging
     * each element with an element in the range $(LB)0 .. поз$(RP), where поз
     * represents the current Массив позиция.
     *
     * Параметры:
     *  буф  = The Массив в_ shuffle.
     *  oper = The рандомируй operation, which should return a число in the
     *         range $(LB)0 .. N$(RP) for any supplied значение N.  This routine
     *         may be any callable тип.
     */
    проц shuffle( Элем[] буф, Oper1A oper = Oper1A.init );

}
else
{
    template shuffle_( Элем, Oper )
    {
        static assert( ВызываемыйТип_ли!(Oper) );


        проц фн( Элем[] буф, Oper oper )
        {
            // NOTE: Indexes are passed instead of references because DMD does
            //       not inline the reference-based version.
            проц exch( т_мера p1, т_мера p2 )
            {
                Элем t  = буф[p1];
                буф[p1] = буф[p2];
                буф[p2] = t;
            }

            for( т_мера поз = буф.length - 1; поз > 0; --поз )
            {
                exch( поз, oper( поз + 1 ) );
            }
        }
    }


    template shuffle( Буф, Oper = RandOper!() )
    {
        проц shuffle( Буф буф, Oper oper = Oper.init )
        {
            return shuffle_!(ЭлемТипа!(Буф), Oper).фн( буф, oper );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        ткст буф = "abcdefghijklmnopqrstuvwxyz";
        ткст врем = буф.dup;

        assert( врем == буф );
        shuffle( врем );
        assert( врем != буф );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Partition
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Partitions буф such that все elements that satisfy пред will be placed
     * before the elements that do not satisfy пред.  The algorithm is not
     * required в_ be stable.
     *
     * Параметры:
     *  буф  = The Массив в_ partition.  This parameter is not marked 'ref'
     *         в_ allow temporary slices в_ be sorted.  As буф is not resized
     *         in any way, omitting the 'ref' qualifier есть no effect on
     *         the результат of this operation, even though it may be viewed
     *         as a sопрe-effect.
     *  пред = The evaluation predicate, which should return да if the
     *         element satisfies the condition and нет if not.  This
     *         predicate may be any callable тип.
     *
     * Возвращает:
     *  The число of elements that satisfy пред.
     */
    т_мера partition( Элем[] буф, Pred1E пред );
}
else
{
    template partition_( Элем, Пред = Меньше_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред ) );


        т_мера фн( Элем[] буф, Пред пред )
        {
            // NOTE: Indexes are passed instead of references because DMD does
            //       not inline the reference-based version.
            проц exch( т_мера p1, т_мера p2 )
            {
                Элем t  = буф[p1];
                буф[p1] = буф[p2];
                буф[p2] = t;
            }

            if( буф.length < 2 )
                return 0;

            т_мера  l = 0,
                    r = буф.length,
                    i = l,
                    j = r - 1;

            while( да )
            {
                while( i < r && пред( буф[i] ) )
                    ++i;
                while( j > l && !пред( буф[j] ) )
                    --j;
                if( i >= j )
                    break;
                exch( i++, j-- );
            }
            return i;
        }
    }


    template partition( Буф, Пред )
    {
        т_мера partition( Буф буф, Пред пред )
        {
            return partition_!(ЭлемТипа!(Буф), Пред).фн( буф, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        проц тест( ткст буф, бул delegate( сим ) дг, т_мера num )
        {
            assert( partition( буф, дг ) == num );
            for( т_мера поз = 0; поз < буф.length; ++поз )
            {
                assert( поз < num ? дг( буф[поз] ) : !дг( буф[поз] ) );
            }
        }

        тест( "abcdefg".dup, ( сим c ) { return c < 'a'; }, 0 );
        тест( "gfedcba".dup, ( сим c ) { return c < 'a'; }, 0 );
        тест( "abcdefg".dup, ( сим c ) { return c < 'h'; }, 7 );
        тест( "gfedcba".dup, ( сим c ) { return c < 'h'; }, 7 );
        тест( "abcdefg".dup, ( сим c ) { return c < 'd'; }, 3 );
        тест( "gfedcba".dup, ( сим c ) { return c < 'd'; }, 3 );
        тест( "bbdaabc".dup, ( сим c ) { return c < 'c'; }, 5 );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Select
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Partitions буф with num - 1 as a pivot such that the first num elements
     * will be less than or equal в_ the remaining elements in the Массив.
     * Comparisons will be performed using the supplied predicate or '<' if
     * Неук is supplied.  The algorithm is not required в_ be stable.
     *
     * Параметры:
     *  буф  = The Массив в_ partition.  This parameter is not marked 'ref'
     *         в_ allow temporary slices в_ be sorted.  As буф is not resized
     *         in any way, omitting the 'ref' qualifier есть no effect on
     *         the результат of this operation, even though it may be viewed
     *         as a sопрe-effect.
     *  num  = The число of elements which are consопрered significant in
     *         this Массив, where num - 1 is the pivot around which partial
     *         sorting will occur.  For example, if num is буф.length / 2
     *         then выбери will effectively partition the Массив around its
     *         median значение, with the elements in the first half of the Массив
     *         evaluating as less than or equal в_ the elements in the сукунда
     *         half.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         less than e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  The индекс of the pivot point, which will be the lesser of num - 1 and
     *  буф.length.
     */
    т_мера выбери( Элем[] буф, Чис num, Pred2E пред = Pred2E.init );
}
else
{
    template выбери_( Элем, Пред = Меньше_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред ) );


        т_мера фн( Элем[] буф, т_мера num, Пред пред = Пред.init )
        {
            // NOTE: Indexes are passed instead of references because DMD does
            //       not inline the reference-based version.
            проц exch( т_мера p1, т_мера p2 )
            {
                Элем t  = буф[p1];
                буф[p1] = буф[p2];
                буф[p2] = t;
            }

            if( буф.length < 2 )
                return буф.length;

            т_мера  l = 0,
                    r = буф.length - 1,
                    k = num;

            while( r > l )
            {
                т_мера  i = l,
                        j = r - 1;
                Элем    v = буф[r];

                while( да )
                {
                    while( i < r && пред( буф[i], v ) )
                        ++i;
                    while( j > l && пред( v, буф[j] ) )
                        --j;
                    if( i >= j )
                        break;
                    exch( i++, j-- );
                }
                exch( i, r );
                if( i >= k )
                    r = i - 1;
                if( i <= k )
                    l = i + 1;
            }
            return num - 1;
        }
    }


    template выбери( Буф, Чис )
    {
        т_мера выбери( Буф буф, Чис num )
        {
            return выбери_!(ЭлемТипа!(Буф)).фн( буф, num );
        }
    }


    template выбери( Буф, Чис, Пред )
    {
        т_мера выбери( Буф буф, Чис num, Пред пред )
        {
            return выбери_!(ЭлемТипа!(Буф), Пред).фн( буф, num, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        ткст буф = "efedcaabca".dup;
        т_мера num = буф.length / 2;
        т_мера поз = выбери( буф, num );

        assert( поз == num - 1 );
        foreach( тек; буф[0 .. поз] )
            assert( тек <= буф[поз] );
        foreach( тек; буф[поз .. $] )
            assert( тек >= буф[поз] );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Sort
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Sorts буф using the supplied predicate or '<' if Неук is supplied.  The
     * algorithm is not required в_ be stable.  The current implementation is
     * based on быстросорт, but uses a three-way partitioning scheme в_ improve
     * performance for ranges containing duplicate values (Bentley and McIlroy,
     * 1993).
     *
     * Параметры:
     *  буф  = The Массив в_ сортируй.  This parameter is not marked 'ref' в_
     *         allow temporary slices в_ be sorted.  As буф is not resized
     *         in any way, omitting the 'ref' qualifier есть no effect on
     *         the результат of this operation, even though it may be viewed
     *         as a sопрe-effect.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         less than e2 and нет if not.  This predicate may be any
     *         callable тип.
     */
    проц сортируй( Элем, Pred2E = Меньше_ли!(Элем) )( Элем[] буф, Pred2E пред = Pred2E.init );
}
else
{
    template сортируй_( Элем, Пред = Меньше_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред ) );


        проц фн( Элем[] буф, Пред пред = Пред.init )
        {
            бул equiv( Элем p1, Элем p2 )
            {
                return !пред( p1, p2 ) && !пред( p2, p1 );
            }

            // NOTE: Indexes are passed instead of references because DMD does
            //       not inline the reference-based version.
            проц exch( т_мера p1, т_мера p2 )
            {
                Элем t  = буф[p1];
                буф[p1] = буф[p2];
                буф[p2] = t;
            }

            // NOTE: This algorithm operates on the включительно range [l .. r].
            проц insertionSort( т_мера l, т_мера r )
            {
                for( т_мера i = r; i > l; --i )
                {
                    // своп the min element в_ буф[0] в_ act as a sentinel
                    if( пред( буф[i], буф[i - 1] ) )
                        exch( i, i - 1 );
                }
                for( т_мера i = l + 2; i <= r; ++i )
                {
                    т_мера  j = i;
                    Элем    v = буф[i];

                    // don't need в_ тест (j != l) because of the sentinel
                    while( пред( v, буф[j - 1] ) )
                    {
                        буф[j] = буф[j - 1];
                        j--;
                    }
                    буф[j] = v;
                }
            }

            т_мера medianOf( т_мера l, т_мера m, т_мера r )
            {
                if( пред( буф[m], буф[l] ) )
                {
                    if( пред( буф[r], буф[m] ) )
                        return m;
                    else
                    {
                        if( пред( буф[r], буф[l] ) )
                            return r;
                        else
                            return l;
                    }
                }
                else
                {
                    if( пред( буф[r], буф[m] ) )
                    {
                        if( пред( буф[r], буф[l] ) )
                            return l;
                        else
                            return r;
                    }
                    else
                        return m;
                }
            }

            // NOTE: This algorithm operates on the включительно range [l .. r].
            проц быстросорт( т_мера l, т_мера r, т_мера d )
            {
                if( r <= l )
                    return;

                // HEURISTIC: Use insertion сортируй for sufficiently small массивы.
                enum { MIN_LENGTH = 80 }
                if( r - l < MIN_LENGTH )
                    return insertionSort( l, r );

                // HEURISTIC: If the recursion depth is too great, assume this
                //            is a worst-case Массив and краш в_ куча сортируй.
                if( d-- == 0 )
                {
                    сделайКучу( буф[l .. r+1], пред );
                    сортируйКучу( буф[l .. r+1], пред );
                    return;
                }

                // HEURISTIC: Use the median-of-3 значение as a pivot.  Swap this
                //            преобр_в r so быстросорт remains untouched.
                exch( r, medianOf( l, l + (r - l) / 2, r ) );

                // This implementation of быстросорт improves upon the classic
                // algorithm by partitioning the Массив преобр_в three части, one
                // each for ключи smaller than, equal в_, and larger than the
                // partitioning element, v:
                //
                // |--less than v--|--equal в_ v--|--greater than v--[v]
                // l               j              i                   r
                //
                // This approach sorts ranges containing duplicate elements
                // ещё quickly.  During processing, the following situation
                // is maintained:
                //
                // |--equal--|--less--|--[###]--|--greater--|--equal--[v]
                // l         p        i         j           q          r
                //
                // Please note that this implementation varies из_ the typical
                // algorithm by replacing the use of signed индекс values with
                // unsigned values.

                Элем    v = буф[r];
                т_мера  i = l,
                        j = r,
                        p = l,
                        q = r;

                while( да )
                {
                    while( пред( буф[i], v ) )
                        ++i;
                    while( пред( v, буф[--j] ) )
                        if( j == l ) break;
                    if( i >= j )
                        break;
                    exch( i, j );
                    if( equiv( буф[i], v ) )
                        exch( p++, i );
                    if( equiv( v, буф[j] ) )
                        exch( --q, j );
                    ++i;
                }
                exch( i, r );
                if( p < i )
                {
                    j = i - 1;
                    for( т_мера k = l; k < p; k++, j-- )
                        exch( k, j );
                    быстросорт( l, j, d );
                }
                if( ++i < q )
                {
                    for( т_мера k = r - 1; k >= q; k--, i++ )
                        exch( k, i );
                    быстросорт( i, r, d );
                }
            }

            т_мера maxDepth( т_мера x )
            {
                т_мера d = 0;

                do
                {
                    ++d;
                    x /= 2;
                } while( x > 1 );
                return d * 2; // same as "пол( лог( x ) / лог( 2 ) ) * 2"
            }

            if( буф.length > 1 )
            {
                быстросорт( 0, буф.length - 1, maxDepth( буф.length ) );
            }
        }
    }


    template сортируй( Буф )
    {
        проц сортируй( Буф буф )
        {
            return сортируй_!(ЭлемТипа!(Буф)).фн( буф );
        }
    }


    template сортируй( Буф, Пред )
    {
        проц сортируй( Буф буф, Пред пред )
        {
            return сортируй_!(ЭлемТипа!(Буф), Пред).фн( буф, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        проц тест( ткст буф )
        {
            сортируй( буф );
            сим sav = буф[0];
            foreach( тек; буф )
            {
                assert( тек >= sav );
                sav = тек;
            }
        }

        тест( "mkcvalsопрivjoaisjdvmzlksvdjioawmdsvmsdfefewv".dup );
        тест( "asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf".dup );
        тест( "the быстро brown fox jumped over the lazy dog".dup );
        тест( "abcdefghijklmnopqrstuvwxyz".dup );
        тест( "zyxwvutsrqponmlkjihgfedcba".dup );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Lower Bound
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a binary search of буф, returning the индекс of the first
     * location where pat may be inserted without disrupting сортируй order.  If
     * the сортируй order of pat precedes все elements in буф then 0 will be
     * returned.  If the сортируй order of pat succeeds the largest element in буф
     * then буф.length will be returned.  Comparisons will be performed using
     * the supplied predicate or '<' if Неук is supplied.
     *
     * Параметры:
     *  буф = The sorted Массив в_ search.
     *  pat = The образец в_ search for.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         less than e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  The индекс of the first match or буф.length if no match was найдено.
     */
    т_мера lbound( Элем[] буф, Элем pat, Pred2E пред = Pred2E.init );
}
else
{
    template lbound_( Элем, Пред = Меньше_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        т_мера фн( Элем[] буф, Элем pat, Пред пред = Пред.init )
        {
            т_мера  beg   = 0,
                    конец   = буф.length,
                    mопр   = конец / 2;

            while( beg < конец )
            {
                if( пред( буф[mопр], pat ) )
                    beg = mопр + 1;
                else
                    конец = mопр;
                mопр = beg + ( конец - beg ) / 2;
            }
            return mопр;
        }
    }


    template lbound( Буф, Pat )
    {
        т_мера lbound( Буф буф, Pat pat )
        {
            return lbound_!(ЭлемТипа!(Буф)).фн( буф, pat );
        }
    }


    template lbound( Буф, Pat, Пред )
    {
        т_мера lbound( Буф буф, Pat pat, Пред пред )
        {
            return lbound_!(ЭлемТипа!(Буф), Пред).фн( буф, pat, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        assert( lbound( "bcefg", 'a' ) == 0 );
        assert( lbound( "bcefg", 'h' ) == 5 );
        assert( lbound( "bcefg", 'd' ) == 2 );
        assert( lbound( "bcefg", 'e' ) == 2 );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Upper Bound
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a binary search of буф, returning the индекс of the first
     * location beyond where pat may be inserted without disrupting сортируй order.
     * If the сортируй order of pat precedes все elements in буф then 0 will be
     * returned.  If the сортируй order of pat succeeds the largest element in буф
     * then буф.length will be returned.  Comparisons will be performed using
     * the supplied predicate or '<' if Неук is supplied.
     *
     * Параметры:
     *  буф = The sorted Массив в_ search.
     *  pat = The образец в_ search for.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         less than e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  The индекс of the first match or буф.length if no match was найдено.
     */
    т_мера ubound( Элем[] буф, Элем pat, Pred2E пред = Pred2E.init );
}
else
{
    template ubound_( Элем, Пред = Меньше_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        т_мера фн( Элем[] буф, Элем pat, Пред пред = Пред.init )
        {
            т_мера  beg   = 0,
                    конец   = буф.length,
                    mопр   = конец / 2;

            while( beg < конец )
            {
                if( !пред( pat, буф[mопр] ) )
                    beg = mопр + 1;
                else
                    конец = mопр;
                mопр = beg + ( конец - beg ) / 2;
            }
            return mопр;
        }
    }


    template ubound( Буф, Pat )
    {
        т_мера ubound( Буф буф, Pat pat )
        {
            return ubound_!(ЭлемТипа!(Буф)).фн( буф, pat );
        }
    }


    template ubound( Буф, Pat, Пред )
    {
        т_мера ubound( Буф буф, Pat pat, Пред пред )
        {
            return ubound_!(ЭлемТипа!(Буф), Пред).фн( буф, pat, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        assert( ubound( "bcefg", 'a' ) == 0 );
        assert( ubound( "bcefg", 'h' ) == 5 );
        assert( ubound( "bcefg", 'd' ) == 2 );
        assert( ubound( "bcefg", 'e' ) == 3 );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Binary Search
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a binary search of буф, returning да if an element equivalent
     * в_ pat is найдено.  Comparisons will be performed using the supplied
     * predicate or '<' if Неук is supplied.
     *
     * Параметры:
     *  буф = The sorted Массив в_ search.
     *  pat = The образец в_ search for.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         less than e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  Да if an element equivalent в_ pat is найдено, нет if not.
     */
    бул бпоиск( Элем[] буф, Элем pat, Pred2E пред = Pred2E.init );
}
else
{
    template bsearch_( Элем, Пред = Меньше_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред) );


        бул фн( Элем[] буф, Элем pat, Пред пред = Пред.init )
        {
            т_мера поз = lbound( буф, pat, пред );
            return поз < буф.length && !( pat < буф[поз] );
        }
    }


    template бпоиск( Буф, Pat )
    {
        бул бпоиск( Буф буф, Pat pat )
        {
            return bsearch_!(ЭлемТипа!(Буф)).фн( буф, pat );
        }
    }


    template бпоиск( Буф, Pat, Пред )
    {
        бул бпоиск( Буф буф, Pat pat, Пред пред )
        {
            return bsearch_!(ЭлемТипа!(Буф), Пред).фн( буф, pat, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        assert( !бпоиск( "bcefg", 'a' ) );
        assert(  бпоиск( "bcefg", 'b' ) );
        assert(  бпоиск( "bcefg", 'c' ) );
        assert( !бпоиск( "bcefg", 'd' ) );
        assert(  бпоиск( "bcefg", 'e' ) );
        assert(  бпоиск( "bcefg", 'f' ) );
        assert(  бпоиск( "bcefg", 'g' ) );
        assert( !бпоиск( "bcefg", 'h' ) );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Includes
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Performs a parallel linear скан of setA and setB из_ $(LB)0 .. N$(RP)
     * where N = min$(LP)setA.length, setB.length$(RP), returning да if setA
     * включает все elements in setB and нет if not.  Всё setA and setB are
     * required в_ be sorted, and duplicates in setB require an equal число of
     * duplicates in setA.  Comparisons will be performed using the supplied
     * predicate or '<' if Неук is supplied.
     *
     * Параметры:
     *  setA = The sorted Массив в_ evaluate.
     *  setB = The sorted Массив в_ match against.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         less than e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  да if setA включает все elements in setB, нет if not.
     */
    бул включает( Элем[] setA, Элем[] setB, Pred2E пред = Pred2E.init );
}
else
{
    template включает_( Элем, Пред = Меньше_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред ) );


        бул фн( Элем[] setA, Элем[] setB, Пред пред = Пред.init )
        {
            т_мера  posA = 0,
                    posB = 0;

            while( posA < setA.length && posB < setB.length )
            {
                if( пред( setB[posB], setA[posA] ) )
                    return нет;
                else if( пред( setA[posA], setB[posB] ) )
                    ++posA;
                else
                    ++posA, ++posB;
            }
            return posB == setB.length;
        }
    }


    template включает( BufA, BufB )
    {
        бул включает( BufA setA, BufB setB )
        {
            return включает_!(ЭлемТипа!(BufA)).фн( setA, setB );
        }
    }


    template включает( BufA, BufB, Пред )
    {
        бул включает( BufA setA, BufB setB, Пред пред )
        {
            return включает_!(ЭлемТипа!(BufA), Пред).фн( setA, setB, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        assert( включает( "abcdefg", "a" ) );
        assert( включает( "abcdefg", "g" ) );
        assert( включает( "abcdefg", "d" ) );
        assert( включает( "abcdefg", "abcdefg" ) );
        assert( включает( "aaaabbbcdddefgg", "abbbcdefg" ) );

        assert( !включает( "abcdefg", "aaabcdefg" ) );
        assert( !включает( "abcdefg", "abcdefggg" ) );
        assert( !включает( "abbbcdefg", "abbbbcdefg" ) );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Union Of
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Computes the union of setA and setB as a установи operation and returns the
     * retult in a new sorted Массив.  Всё setA and setB are required в_ be
     * sorted.  If either setA or setB contain duplicates, the результат will
     * contain the larger число of duplicates из_ setA and setB.  When an
     * overlap occurs, записи will be copied из_ setA.  Comparisons will be
     * performed using the supplied predicate or '<' if Неук is supplied.
     *
     * Параметры:
     *  setA = The first sorted Массив в_ evaluate.
     *  setB = The сукунда sorted Массив в_ evaluate.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         less than e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  A new Массив containing the union of setA and setB.
     */
    Элем[] союзИз( Элем[] setA, Элем[] setB, Pred2E пред = Pred2E.init );
}
else
{
    template союзИз_( Элем, Пред = Меньше_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред ) );


        Элем[] фн( Элем[] setA, Элем[] setB, Пред пред = Пред.init )
        {
            т_мера  posA = 0,
                    posB = 0;
            Элем[]  setU;

            while( posA < setA.length && posB < setB.length )
            {
                if( пред( setA[posA], setB[posB] ) )
                    setU ~= setA[posA++];
                else if( пред( setB[posB], setA[posA] ) )
                    setU ~= setB[posB++];
                else
                    setU ~= setA[posA++], posB++;
            }
            setU ~= setA[posA .. $];
            setU ~= setB[posB .. $];
            return setU;
        }
    }


    template союзИз( BufA, BufB )
    {
        ЭлемТипа!(BufA)[] союзИз( BufA setA, BufB setB )
        {
            return союзИз_!(ЭлемТипа!(BufA)).фн( setA, setB );
        }
    }


    template союзИз( BufA, BufB, Пред )
    {
        ЭлемТипа!(BufA)[] союзИз( BufA setA, BufB setB, Пред пред )
        {
            return союзИз_!(ЭлемТипа!(BufA), Пред).фн( setA, setB, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        assert( союзИз( "", "" ) == "" );
        assert( союзИз( "abc", "def" ) == "abcdef" );
        assert( союзИз( "abbbcd", "aadeefg" ) == "aabbbcdeefg" );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Intersection Of
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Computes the intersection of setA and setB as a установи operation and
     * returns the retult in a new sorted Массив.  Всё setA and setB are
     * required в_ be sorted.  If either setA or setB contain duplicates, the
     * результат will contain the smaller число of duplicates из_ setA and setB.
     * все записи will be copied из_ setA.  Comparisons will be performed
     * using the supplied predicate or '<' if Неук is supplied.
     *
     * Параметры:
     *  setA = The first sorted Массив в_ evaluate.
     *  setB = The сукунда sorted Массив в_ evaluate.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         less than e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  A new Массив containing the intersection of setA and setB.
     */
    Элем[] пересечениеИз( Элем[] setA, Элем[] setB, Pred2E пред = Pred2E.init );
}
else
{
    template пересечениеИз_( Элем, Пред = Меньше_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред ) );


        Элем[] фн( Элем[] setA, Элем[] setB, Пред пред = Пред.init )
        {
            т_мера  posA = 0,
                    posB = 0;
            Элем[]  setI;

            while( posA < setA.length && posB < setB.length )
            {
                if( пред( setA[posA], setB[posB] ) )
                    ++posA;
                else if( пред( setB[posB], setA[posA] ) )
                    ++posB;
                else
                    setI ~= setA[posA++], posB++;
            }
            return setI;
        }
    }


    template пересечениеИз( BufA, BufB )
    {
        ЭлемТипа!(BufA)[] пересечениеИз( BufA setA, BufB setB )
        {
            return пересечениеИз_!(ЭлемТипа!(BufA)).фн( setA, setB );
        }
    }


    template пересечениеИз( BufA, BufB, Пред )
    {
        ЭлемТипа!(BufA)[] пересечениеИз( BufA setA, BufB setB, Пред пред )
        {
            return пересечениеИз_!(ЭлемТипа!(BufA), Пред).фн( setA, setB, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        assert( пересечениеИз( "", "" ) == "" );
        assert( пересечениеИз( "abc", "def" ) == "" );
        assert( пересечениеИз( "abbbcd", "aabdddeefg" ) == "abd" );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Missing ОтКого
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Returns a new Массив containing все elements in setA which are not
     * present in setB.  Всё setA and setB are required в_ be sorted.
     * Comparisons will be performed using the supplied predicate or '<'
     * if Неук is supplied.
     *
     * Параметры:
     *  setA = The first sorted Массив в_ evaluate.
     *  setB = The сукунда sorted Массив в_ evaluate.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         less than e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  A new Массив containing the elements in setA that are not in setB.
     */
    Элем[] отсутствуютВ2( Элем[] setA, Элем[] setB, Pred2E пред = Pred2E.init );
}
else
{
    template отсутствуютВ2_( Элем, Пред = Меньше_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред ) );


        Элем[] фн( Элем[] setA, Элем[] setB, Пред пред = Пред.init )
        {
            т_мера  posA = 0,
                    posB = 0;
            Элем[]  setM;

            while( posA < setA.length && posB < setB.length )
            {
                if( пред( setA[posA], setB[posB] ) )
                    setM ~= setA[posA++];
                else if( пред( setB[posB], setA[posA] ) )
                    ++posB;
                else
                    ++posA, ++posB;
            }
            setM ~= setA[posA .. $];
            return setM;
        }
    }


    template отсутствуютВ2( BufA, BufB )
    {
        ЭлемТипа!(BufA)[] отсутствуютВ2( BufA setA, BufB setB )
        {
            return отсутствуютВ2_!(ЭлемТипа!(BufA)).фн( setA, setB );
        }
    }


    template отсутствуютВ2( BufA, BufB, Пред )
    {
        ЭлемТипа!(BufA)[] отсутствуютВ2( BufA setA, BufB setB, Пред пред )
        {
            return отсутствуютВ2_!(ЭлемТипа!(BufA), Пред).фн( setA, setB, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        assert( отсутствуютВ2( "", "" ) == "" );
        assert( отсутствуютВ2( "", "abc" ) == "" );
        assert( отсутствуютВ2( "abc", "" ) == "abc" );
        assert( отсутствуютВ2( "abc", "abc" ) == "" );
        assert( отсутствуютВ2( "abc", "def" ) == "abc" );
        assert( отсутствуютВ2( "abbbcd", "abd" ) == "bbc" );
        assert( отсутствуютВ2( "abcdef", "bc" ) == "adef" );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Difference Of
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
   /**
     * Returns a new Массив containing все elements in setA which are not
     * present in setB and the elements in setB which are not present in
     * setA.  Всё setA and setB are required в_ be sorted.  Comparisons
     * will be performed using the supplied predicate or '<' if Неук is
     * supplied.
     *
     * Параметры:
     *  setA = The first sorted Массив в_ evaluate.
     *  setB = The сукунда sorted Массив в_ evaluate.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         less than e2 and нет if not.  This predicate may be any
     *         callable тип.
     *
     * Возвращает:
     *  A new Массив containing the elements in setA that are not in setB
     *  and the elements in setB that are not in setA.
     */
    Элем[] разницаИз( Элем[] setA, Элем[] setB, Pred2E пред = Pred2E.init );
}
else
{
    template разницаИз_( Элем, Пред = Меньше_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред ) );


        Элем[] фн( Элем[] setA, Элем[] setB, Пред пред = Пред.init )
        {
            т_мера  posA = 0,
                    posB = 0;
            Элем[]  setD;

            while( posA < setA.length && posB < setB.length )
            {
                if( пред( setA[posA], setB[posB] ) )
                    setD ~= setA[posA++];
                else if( пред( setB[posB], setA[posA] ) )
                    setD ~= setB[posB++];
                else
                    ++posA, ++posB;
            }
            setD ~= setA[posA .. $];
            setD ~= setB[posB .. $];
            return setD;
        }
    }


    template разницаИз( BufA, BufB )
    {
        ЭлемТипа!(BufA)[] разницаИз( BufA setA, BufB setB )
        {
            return разницаИз_!(ЭлемТипа!(BufA)).фн( setA, setB );
        }
    }


    template разницаИз( BufA, BufB, Пред )
    {
        ЭлемТипа!(BufA)[] разницаИз( BufA setA, BufB setB, Пред пред )
        {
            return разницаИз_!(ЭлемТипа!(BufA), Пред).фн( setA, setB, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        assert( разницаИз( "", "" ) == "" );
        assert( разницаИз( "", "abc" ) == "abc" );
        assert( разницаИз( "abc", "" ) == "abc" );
        assert( разницаИз( "abc", "abc" ) == "" );
        assert( разницаИз( "abc", "def" ) == "abcdef" );
        assert( разницаИз( "abbbcd", "abd" ) == "bbc" );
        assert( разницаИз( "abd", "abbbcd" ) == "bbc" );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Make куча
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Converts буф в_ a куча using the supplied predicate or '<' if Неук is
     * supplied.
     *
     * Параметры:
     *  буф  = The Массив в_ преобразуй.  This parameter is not marked 'ref' в_
     *         allow temporary slices в_ be sorted.  As буф is not resized in
     *         any way, omitting the 'ref' qualifier есть no effect on the
     *         результат of this operation, even though it may be viewed as a
     *         sопрe-effect.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         less than e2 and нет if not.  This predicate may be any
     *         callable тип.
     */
    проц сделайКучу( Элем[] буф, Pred2E пред = Pred2E.init );
}
else
{
    template сделайКучу_( Элем, Пред = Меньше_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред ) );


        проц фн( Элем[] буф, Пред пред = Пред.init )
        {
            // NOTE: Indexes are passed instead of references because DMD does
            //       not inline the reference-based version.
            проц exch( т_мера p1, т_мера p2 )
            {
                Элем t  = буф[p1];
                буф[p1] = буф[p2];
                буф[p2] = t;
            }

            проц fixDown( т_мера поз, т_мера конец )
            {
                if( конец <= поз )
                    return;
                while( поз <= ( конец - 1 ) / 2 )
                {
                    т_мера nxt = 2 * поз + 1;

                    if( nxt < конец && пред( буф[nxt], буф[nxt + 1] ) )
                        ++nxt;
                    if( !пред( буф[поз], буф[nxt] ) )
                        break;
                    exch( поз, nxt );
                    поз = nxt;
                }
            }

            if( буф.length < 2 )
                return;

            т_мера  конец = буф.length - 1,
                    поз = конец / 2 + 2;

            do
            {
                fixDown( --поз, конец );
            } while( поз > 0 );
        }
    }


    template сделайКучу( Буф )
    {
        проц сделайКучу( Буф буф )
        {
            return сделайКучу_!(ЭлемТипа!(Буф)).фн( буф );
        }
    }


    template сделайКучу( Буф, Пред )
    {
        проц сделайКучу( Буф буф, Пред пред )
        {
            return сделайКучу_!(ЭлемТипа!(Буф), Пред).фн( буф, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        проц basic( ткст буф )
        {
            if( буф.length < 2 )
                return;

            т_мера  поз = 0,
                    конец = буф.length - 1;

            while( поз <= ( конец - 1 ) / 2 )
            {
                assert( буф[поз] >= буф[2 * поз + 1] );
                if( 2 * поз + 1 < конец )
                {
                    assert( буф[поз] >= буф[2 * поз + 2] );
                }
                ++поз;
            }
        }

        проц тест( ткст буф )
        {
            сделайКучу( буф );
            basic( буф );
        }

        тест( "mkcvalsопрivjoaisjdvmzlksvdjioawmdsvmsdfefewv".dup );
        тест( "asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf".dup );
        тест( "the быстро brown fox jumped over the lazy dog".dup );
        тест( "abcdefghijklmnopqrstuvwxyz".dup );
        тест( "zyxwvutsrqponmlkjihgfedcba".dup );
        тест( "ba".dup );
        тест( "a".dup );
        тест( "".dup );
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Push куча
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * добавьs знач в_ буф by appending it and adjusting it up the куча.
     *
     * Параметры:
     *  буф  = The куча в_ modify.  This parameter is marked 'ref' because
     *         буф.length will be altered.
     *  знач  = The element в_ push onto буф.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         less than e2 and нет if not.  This predicate may be any
     *         callable тип.
     */
    проц суньВКучу( ref Элем[] буф, Элем знач, Pred2E пред = Pred2E.init );
}
else
{
    template pushHeap_( Элем, Пред = Меньше_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред ) );


        проц фн( ref Элем[] буф, Элем знач, Пред пред = Пред.init )
        {
            // NOTE: Indexes are passed instead of references because DMD does
            //       not inline the reference-based version.
            проц exch( т_мера p1, т_мера p2 )
            {
                Элем t  = буф[p1];
                буф[p1] = буф[p2];
                буф[p2] = t;
            }

            проц fixUp( т_мера поз )
            {
                if( поз < 1 )
                    return;
                т_мера par = ( поз - 1 ) / 2;
                while( поз > 0 && пред( буф[par], буф[поз] ) )
                {
                    exch( par, поз );
                    поз = par;
                    par = ( поз - 1 ) / 2;
                }
            }

            буф ~= знач;
            if( буф.length > 1 )
            {
                fixUp( буф.length - 1 );
            }
        }
    }


    template суньВКучу( Буф, Val )
    {
        проц суньВКучу( ref Буф буф, Val знач )
        {
            return pushHeap_!(ЭлемТипа!(Буф)).фн( буф, знач );
        }
    }


    template суньВКучу( Буф, Val, Пред )
    {
        проц суньВКучу( ref Буф буф, Val знач, Пред пред )
        {
            return pushHeap_!(ЭлемТипа!(Буф), Пред).фн( буф, знач, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        проц basic( ткст буф )
        {
            if( буф.length < 2 )
                return;

            т_мера  поз = 0,
                    конец = буф.length - 1;

            while( поз <= ( конец - 1 ) / 2 )
            {
                assert( буф[поз] >= буф[2 * поз + 1] );
                if( 2 * поз + 1 < конец )
                {
                    assert( буф[поз] >= буф[2 * поз + 2] );
                }
                ++поз;
            }
        }

        ткст буф;

        foreach( тек; "abcdefghijklmnopqrstuvwxyz" )
        {
            суньВКучу( буф, тек );
            basic( буф );
        }

        буф.length = 0;

        foreach( тек; "zyxwvutsrqponmlkjihgfedcba" )
        {
            суньВКучу( буф, тек );
            basic( буф );
        }
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Pop куча
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Removes the top element из_ буф by свопping it with the bottom element,
     * adjusting it down the куча, and reducing the length of буф by one.
     *
     * Параметры:
     *  буф  = The куча в_ modify.  This parameter is marked 'ref' because
     *         буф.length will be altered.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         less than e2 and нет if not.  This predicate may be any
     *         callable тип.
     */
    проц выньИзКучи( ref Элем[] буф, Pred2E пред = Pred2E.init );
}
else
{
    template popHeap_( Элем, Пред = Меньше_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред ) );


        проц фн( ref Элем[] буф, Пред пред = Пред.init )
        {
            // NOTE: Indexes are passed instead of references because DMD does
            //       not inline the reference-based version.
            проц exch( т_мера p1, т_мера p2 )
            {
                Элем t  = буф[p1];
                буф[p1] = буф[p2];
                буф[p2] = t;
            }

            проц fixDown( т_мера поз, т_мера конец )
            {
                if( конец <= поз )
                    return;
                while( поз <= ( конец - 1 ) / 2 )
                {
                    т_мера nxt = 2 * поз + 1;

                    if( nxt < конец && пред( буф[nxt], буф[nxt + 1] ) )
                        ++nxt;
                    if( !пред( буф[поз], буф[nxt] ) )
                        break;
                    exch( поз, nxt );
                    поз = nxt;
                }
            }

            if( буф.length > 1 )
            {
                exch( 0, буф.length - 1 );
                fixDown( 0, буф.length - 2 );
            }
            if( буф.length > 0 )
            {
                буф.length = буф.length - 1;
            }
        }
    }


    template выньИзКучи( Буф )
    {
        проц выньИзКучи( ref Буф буф )
        {
            return popHeap_!(ЭлемТипа!(Буф)).фн( буф );
        }
    }


    template выньИзКучи( Буф, Пред )
    {
        проц выньИзКучи( ref Буф буф, Пред пред )
        {
            return popHeap_!(ЭлемТипа!(Буф), Пред).фн( буф, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        проц тест( ткст буф )
        {
            if( буф.length < 2 )
                return;

            т_мера  поз = 0,
                    конец = буф.length - 1;

            while( поз <= ( конец - 1 ) / 2 )
            {
                assert( буф[поз] >= буф[2 * поз + 1] );
                if( 2 * поз + 1 < конец )
                {
                    assert( буф[поз] >= буф[2 * поз + 2] );
                }
                ++поз;
            }
        }

        ткст буф = "zyxwvutsrqponmlkjihgfedcba".dup;

        while( буф.length > 0 )
        {
            выньИзКучи( буф );
            тест( буф );
        }
      }
    }
}


////////////////////////////////////////////////////////////////////////////////
// Sort куча
////////////////////////////////////////////////////////////////////////////////


version( TangoDoc )
{
    /**
     * Sorts буф as a куча using the supplied predicate or '<' if Неук is
     * supplied.  Calling сделайКучу and сортируйКучу on an Массив in succession
     * есть the effect of sorting the Массив using the heapsort algorithm.
     *
     * Параметры:
     *  буф  = The куча в_ сортируй.  This parameter is not marked 'ref' в_
     *         allow temporary slices в_ be sorted.  As буф is not resized
     *         in any way, omitting the 'ref' qualifier есть no effect on
     *         the результат of this operation, even though it may be viewed
     *         as a sопрe-effect.
     *  пред = The evaluation predicate, which should return да if e1 is
     *         less than e2 and нет if not.  This predicate may be any
     *         callable тип.
     */
    проц сортируйКучу( Элем[] буф, Pred2E пред = Pred2E.init );
}
else
{
    template сортируйКучу_( Элем, Пред = Меньше_ли!(Элем) )
    {
        static assert( ВызываемыйТип_ли!(Пред ) );


        проц фн( Элем[] буф, Пред пред = Пред.init )
        {
            // NOTE: Indexes are passed instead of references because DMD does
            //       not inline the reference-based version.
            проц exch( т_мера p1, т_мера p2 )
            {
                Элем t  = буф[p1];
                буф[p1] = буф[p2];
                буф[p2] = t;
            }

            проц fixDown( т_мера поз, т_мера конец )
            {
                if( конец <= поз )
                    return;
                while( поз <= ( конец - 1 ) / 2 )
                {
                    т_мера nxt = 2 * поз + 1;

                    if( nxt < конец && пред( буф[nxt], буф[nxt + 1] ) )
                        ++nxt;
                    if( !пред( буф[поз], буф[nxt] ) )
                        break;
                    exch( поз, nxt );
                    поз = nxt;
                }
            }

            if( буф.length < 2 )
                return;

            т_мера  поз = буф.length - 1;

            while( поз > 0 )
            {
                exch( 0, поз );
                fixDown( 0, --поз );
            }
        }
    }


    template сортируйКучу( Буф )
    {
        проц сортируйКучу( Буф буф )
        {
            return сортируйКучу_!(ЭлемТипа!(Буф)).фн( буф );
        }
    }


    template сортируйКучу( Буф, Пред )
    {
        проц сортируйКучу( Буф буф, Пред пред )
        {
            return сортируйКучу_!(ЭлемТипа!(Буф), Пред).фн( буф, пред );
        }
    }


    debug( UnitTest )
    {
      unittest
      {
        ткст буф = "zyxwvutsrqponmlkjihgfedcba".dup;

        сортируйКучу( буф );
        сим sav = буф[0];
        foreach( тек; буф )
        {
            assert( тек >= sav );
            sav = тек;
        }
      }
    }
}
