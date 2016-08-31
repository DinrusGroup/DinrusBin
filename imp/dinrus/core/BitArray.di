/**
 * Данный модуль содержит реализацию упакованного массива бит в стиле
 * встроенных динамических массивов Ди.
 *
 * Copyright: Copyright (C) 2005-2006 Digital Mars, www.digitalmars.com.
 *            
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Walter Bright, Sean Kelly
 */
module core.BitArray;


private import core.BitManip;


/**
 * Эта структура представляет собой Массив из булевых значений, каждое из которых
 * занимает бит памяти для своего хранения. Таким образом Массив из 32 бит
 * займёт то же пространство, что и целое значение. Типичные операции с массивами -
 * индексирование и сортировка - поддерживаются, так же как и побитные операции,
 * такие как and, or, xor и complement.
 */
struct МассивБит
{
    т_мера  длин;
    бцел*   ptr;


    /**
     * Инициализация МассиваБит из биты.длина бит, где значение
	 * каждого бита соответствует булеву значению данного бита.
     *
     * Параметры:
     *  биты = инициализационное значение.
     *
     * Возвращает:
     *  МассивБит с тем же числом и последовательностью элементов как и у битов.
     */
    static МассивБит opCall( бул[] биты );

    /**
     * Выводит число бит, содержащихся в этом Массиве.
     *
     * Возвращает:
     *  Число бит в этом Массиве.
     */
    т_мера длина();


    /**
     * Меняет длину Массива на длину новдлин. Если новдлин больше текущей
	 * длины,новые биты будут инициализованы в ноль.
     *
     * Параметры:
     *  новдлин = Число бит, которое должен содержать данный Массив.
     */
    проц длина( т_мера новдлин );


    /**
     * Получает длину массива типа бцел, способного вместить все сохраняемые биты.
     *
     * Возвращает:
     *  Размер бцел Массива, способного сохранить данный Массив.
     */
    т_мера цразм();


    /**
     * Дублирует данный Массив, как и свойство dup у встроенных массивов.
     *
     * Возвращает:
     *  Дубликат данного Массива.
     */
    МассивБит dup();


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a;
        МассивБит b;

        a.длина = 3;
        a[0] = 1; a[1] = 0; a[2] = 1;
        b = a.dup;
        assert( b.длина == 3 );
        for( цел i = 0; i < 3; ++i )
        {
            assert( b[i] == (((i ^ 1) & 1) ? да : нет) );
        }
      }
    }


    /**
     * Resets the длина of this Массив в_ биты.длина and then initializes this
     *
     * Resizes this Массив в_ hold биты.длина биты and initializes each bit
     * значение в_ match the corresponding булево значение in биты.
     *
     * Параметры:
     *  биты = The initialization значение.
     */
    проц opAssign( бул[] биты );

    /**
     * Copy the биты из_ one Массив преобр_в this Массив.  This is not a shallow
     * копируй.
     *
     * Параметры:
     *  rhs = A МассивБит with at least the same число of биты as this bit
     *  Массив.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     *
     *  --------------------
     *  МассивБит ba = [0,1,0,1,0];
     *  МассивБит ba2;
     *  ba2.длина = ba.длина;
     *  ba2[] = ba; // perform the копируй
     *  ba[0] = да;
     *  assert(ba2[0] == нет);
     */
     МассивБит opSliceAssign(МассивБит rhs);


    /**
     * Map МассивБит onto мишень, with numbits being the число of биты in the
     * Массив. Does not копируй the данные.  This is the inverse of opCast.
     *
     * Параметры:
     *  мишень  = The Массив в_ карта.
     *  numbits = The число of биты в_ карта in мишень.
     */
    проц иниц( проц[] мишень, т_мера numbits );


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b;
        проц[] буф;

        буф = cast(проц[])a;
        b.иниц( буф, a.длина );

        assert( b[0] == 1 );
        assert( b[1] == 0 );
        assert( b[2] == 1 );
        assert( b[3] == 0 );
        assert( b[4] == 1 );

        a[0] = 0;
        assert( b[0] == 0 );

        assert( a == b );

        // тест opSliceAssign
        МассивБит c;
        c.длина = a.длина;
        c[] = a;
        assert( c == a );
        a[0] = 1;
        assert( c != a );
      }
    }


    /**
     * Reverses the contents of this Массив in place, much like the реверс
     * property for built-in массивы.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит реверс();


    debug( UnitTest )
    {
      unittest
      {
        static бул[5] данные = [1,0,1,1,0];
        МассивБит b = данные;
        b.реверс;

        for( т_мера i = 0; i < данные.длина; ++i )
        {
            assert( b[i] == данные[4 - i] );
        }
      }
    }


    /**
     * Sorts this Массив in place, with zero записи sorting before one.  This
     * is equivalent в_ the сортируй property for built-in массивы.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит сортируй();


    debug( UnitTest )
    {
      unittest
      {
        static бцел x = 0b1100011000;
        static МассивБит ba = { 10, &x };

        ba.сортируй;
        for( т_мера i = 0; i < 6; ++i )
            assert( ba[i] == нет );
        for( т_мера i = 6; i < 10; ++i )
            assert( ba[i] == да );
      }
    }


    /**
     * Operates on все биты in this Массив.
     *
     * Параметры:
     *  дг = The supplied код as a delegate.
     */
    цел opApply( цел delegate(ref бул) дг );


    /** ditto */
    цел opApply( цел delegate(ref т_мера, ref бул) дг );


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1];

        цел i;
        foreach( b; a )
        {
            switch( i )
            {
            case 0: assert( b == да );  break;
            case 1: assert( b == нет ); break;
            case 2: assert( b == да );  break;
            default: assert( нет );
            }
            i++;
        }

        foreach( j, b; a )
        {
            switch( j )
            {
            case 0: assert( b == да );  break;
            case 1: assert( b == нет ); break;
            case 2: assert( b == да );  break;
            default: assert( нет );
            }
        }
      }
    }


    /**
     * Compares this Массив в_ другой for equality.  Two bit массивы are equal
     * if they are the same размер and contain the same series of биты.
     *
     * Параметры:
     *  rhs = The Массив в_ compare against.
     *
     * Возвращает:
     *  zero if not equal and non-zero otherwise.
     */
    цел opEquals( МассивБит rhs );

    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1];
        МассивБит c = [1,0,1,0,1,0,1];
        МассивБит d = [1,0,1,1,1];
        МассивБит e = [1,0,1,0,1];

        assert(a != b);
        assert(a != c);
        assert(a != d);
        assert(a == e);
      }
    }


    /**
     * Performs a lexicographical сравнение of this Массив в_ the supplied
     * Массив.
     *
     * Параметры:
     *  rhs = The Массив в_ compare against.
     *
     * Возвращает:
     *  A значение less than zero if this Массив sorts before the supplied Массив,
     *  zero if the массивы are equavalent, and a значение greater than zero if
     *  this Массив sorts after the supplied Массив.
     */
    цел opCmp( МассивБит rhs );

    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1];
        МассивБит c = [1,0,1,0,1,0,1];
        МассивБит d = [1,0,1,1,1];
        МассивБит e = [1,0,1,0,1];
        МассивБит f = [1,0,1,0];

        assert( a >  b );
        assert( a >= b );
        assert( a <  c );
        assert( a <= c );
        assert( a <  d );
        assert( a <= d );
        assert( a == e );
        assert( a <= e );
        assert( a >= e );
        assert( f >  b );
      }
    }


    /**
     * Convert this Массив в_ a проц Массив.
     *
     * Возвращает:
     *  This Массив represented as a проц Массив.
     */
    проц[] opCast();


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        проц[] v = cast(проц[])a;

        assert( v.длина == a.dim * бцел.sizeof );
      }
    }


    /**
     * Support for индекс operations, much like the behavior of built-in массивы.
     *
     * Параметры:
     *  поз = The desired индекс позиция.
     *
     * In:
     *  поз must be less than the длина of this Массив.
     *
     * Возвращает:
     *  The значение of the bit at поз.
     */
    бул opIndex( т_мера поз );


    /**
     * Generates a копируй of this Массив with the unary complement operation
     * applied.
     *
     * Возвращает:
     *  A new Массив which is the complement of this Массив.
     */
    МассивБит opCom();


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = ~a;

        assert(b[0] == 0);
        assert(b[1] == 1);
        assert(b[2] == 0);
        assert(b[3] == 1);
        assert(b[4] == 0);
      }
    }


    /**
     * Generates a new Массив which is the результат of a bitwise and operation
     * between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the bitwise and operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A new Массив which is the результат of a bitwise and with this Массив and
     *  the supplied Массив.
     */
    МассивБит opAnd( МассивБит rhs );


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1,1,0];

        МассивБит c = a & b;

        assert(c[0] == 1);
        assert(c[1] == 0);
        assert(c[2] == 1);
        assert(c[3] == 0);
        assert(c[4] == 0);
      }
    }


    /**
     * Generates a new Массив which is the результат of a bitwise or operation
     * between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the bitwise or operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A new Массив which is the результат of a bitwise or with this Массив and
     *  the supplied Массив.
     */
    МассивБит opOr( МассивБит rhs );


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1,1,0];

        МассивБит c = a | b;

        assert(c[0] == 1);
        assert(c[1] == 0);
        assert(c[2] == 1);
        assert(c[3] == 1);
        assert(c[4] == 1);
      }
    }


    /**
     * Generates a new Массив which is the результат of a bitwise xor operation
     * between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the bitwise xor operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A new Массив which is the результат of a bitwise xor with this Массив and
     *  the supplied Массив.
     */
    МассивБит opXor( МассивБит rhs );


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1,1,0];

        МассивБит c = a ^ b;

        assert(c[0] == 0);
        assert(c[1] == 0);
        assert(c[2] == 0);
        assert(c[3] == 1);
        assert(c[4] == 1);
      }
    }


    /**
     * Generates a new Массив which is the результат of this Массив minus the
     * supplied Массив.  $(I a - b) for BitArrays means the same thing as
     * $(I a &amp; ~b).
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the subtraction operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A new Массив which is the результат of this Массив minus the supplied Массив.
     */
    МассивБит opSub( МассивБит rhs );


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1,1,0];

        МассивБит c = a - b;

        assert( c[0] == 0 );
        assert( c[1] == 0 );
        assert( c[2] == 0 );
        assert( c[3] == 0 );
        assert( c[4] == 1 );
      }
    }


    /**
     * Generates a new Массив which is the результат of this Массив concatenated
     * with the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the concatenation operation.
     *
     * Возвращает:
     *  A new Массив which is the результат of this Массив concatenated with the
     *  supplied Массив.
     */
    МассивБит opCat( бул rhs );

    /** ditto */
    МассивБит opCat_r( бул lhs );


    /** ditto */
    МассивБит opCat( МассивБит rhs );


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0];
        МассивБит b = [0,1,0];
        МассивБит c;

        c = (a ~ b);
        assert( c.длина == 5 );
        assert( c[0] == 1 );
        assert( c[1] == 0 );
        assert( c[2] == 0 );
        assert( c[3] == 1 );
        assert( c[4] == 0 );

        c = (a ~ да);
        assert( c.длина == 3 );
        assert( c[0] == 1 );
        assert( c[1] == 0 );
        assert( c[2] == 1 );

        c = (нет ~ a);
        assert( c.длина == 3 );
        assert( c[0] == 0 );
        assert( c[1] == 1 );
        assert( c[2] == 0 );
      }
    }


    /**
     * Support for индекс operations, much like the behavior of built-in массивы.
     *
     * Параметры:
     *  b   = The new bit значение в_ установи.
     *  поз = The desired индекс позиция.
     *
     * In:
     *  поз must be less than the длина of this Массив.
     *
     * Возвращает:
     *  The new значение of the bit at поз.
     */
    бул opIndexAssign( бул b, т_мера поз );


    /**
     * Updates the contents of this Массив with the результат of a bitwise and
     * operation between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the bitwise and operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит opAndAssign( МассивБит rhs );


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1,1,0];

        a &= b;
        assert( a[0] == 1 );
        assert( a[1] == 0 );
        assert( a[2] == 1 );
        assert( a[3] == 0 );
        assert( a[4] == 0 );
      }
    }


    /**
     * Updates the contents of this Массив with the результат of a bitwise or
     * operation between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the bitwise or operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит opOrAssign( МассивБит rhs );


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1,1,0];

        a |= b;
        assert( a[0] == 1 );
        assert( a[1] == 0 );
        assert( a[2] == 1 );
        assert( a[3] == 1 );
        assert( a[4] == 1 );
      }
    }


    /**
     * Updates the contents of this Массив with the результат of a bitwise xor
     * operation between this Массив and the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the bitwise xor operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит opXorAssign( МассивБит rhs );


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1,1,0];

        a ^= b;
        assert( a[0] == 0 );
        assert( a[1] == 0 );
        assert( a[2] == 0 );
        assert( a[3] == 1 );
        assert( a[4] == 1 );
      }
    }


    /**
     * Updates the contents of this Массив with the результат of this Массив minus
     * the supplied Массив.  $(I a - b) for BitArrays means the same thing as
     * $(I a &amp; ~b).
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the subtraction operation.
     *
     * In:
     *  rhs.длина must equal the длина of this Массив.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит opSubAssign( МассивБит rhs );


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b = [1,0,1,1,0];

        a -= b;
        assert( a[0] == 0 );
        assert( a[1] == 0 );
        assert( a[2] == 0 );
        assert( a[3] == 0 );
        assert( a[4] == 1 );
      }
    }


    /**
     * Updates the contents of this Массив with the результат of this Массив
     * concatenated with the supplied Массив.
     *
     * Параметры:
     *  rhs = The Массив with which в_ perform the concatenation operation.
     *
     * Возвращает:
     *  A shallow копируй of this Массив.
     */
    МассивБит opCatAssign( бул b );


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0,1,0,1];
        МассивБит b;

        b = (a ~= да);
        assert( a[0] == 1 );
        assert( a[1] == 0 );
        assert( a[2] == 1 );
        assert( a[3] == 0 );
        assert( a[4] == 1 );
        assert( a[5] == 1 );

        assert( b == a );
      }
    }


    /** ditto */
    МассивБит opCatAssign( МассивБит rhs );


    debug( UnitTest )
    {
      unittest
      {
        МассивБит a = [1,0];
        МассивБит b = [0,1,0];
        МассивБит c;

        c = (a ~= b);
        assert( a.длина == 5 );
        assert( a[0] == 1 );
        assert( a[1] == 0 );
        assert( a[2] == 0 );
        assert( a[3] == 1 );
        assert( a[4] == 0 );

        assert( c == a );
      }
    }
}
