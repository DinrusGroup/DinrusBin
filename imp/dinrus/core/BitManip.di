/**
 * This module содержит a collection of bit-уровень operations.
 *
 * Copyright: Public Domain
 * License:   Public Domain
 * Authors:   Sean Kelly
 */
module core.BitManip;


version( TangoDoc )
{
    /**
     * Scans the биты in v starting with bit 0, looking
     * for the first установи bit.
     * Возвращает:
     *	The bit число of the first bit установи.
     *	The return значение is undefined if v is zero.
     */
    цел bsf( бцел v );


    /**
     * Scans the биты in v из_ the most significant bit
     * в_ the least significant bit, looking
     * for the first установи bit.
     * Возвращает:
     *	The bit число of the first bit установи.
     *	The return значение is undefined if v is zero.
     * Example:
     * ---
     * import core.BitManip;
     *
     * цел main()
     * {
     *     бцел v;
     *     цел x;
     *
     *     v = 0x21;
     *     x = bsf(v);
     *     printf("bsf(x%x) = %d\n", v, x);
     *     x = bsr(v);
     *     printf("bsr(x%x) = %d\n", v, x);
     *     return 0;
     * }
     * ---
     * Вывод:
     *  bsf(x21) = 0<br>
     *  bsr(x21) = 5
     */
    цел bsr( бцел v );


    /**
     * Tests the bit.
     */
    цел bt( бцел* p, бцел bitnum );


    /**
     * Tests and complements the bit.
     */
    цел btc( бцел* p, бцел bitnum );


    /**
     * Tests and resets (sets в_ 0) the bit.
     */
    цел btr( бцел* p, бцел bitnum );


    /**
     * Tests and sets the bit.
     * Параметры:
     * p = a non-NULL pointer в_ an Массив of бцелs.
     * индекс = a bit число, starting with bit 0 of p[0],
     * and progressing. It адресes биты like the expression:
    ---
    p[индекс / (бцел.sizeof*8)] & (1 << (индекс & ((бцел.sizeof*8) - 1)))
    ---
     * Возвращает:
     * 	A non-zero значение if the bit was установи, and a zero
     *	if it was сотри.
     *
     * Example:
     * ---
    import core.BitManip;

    цел main()
    {
        бцел Массив[2];

        Массив[0] = 2;
        Массив[1] = 0x100;

        printf("btc(Массив, 35) = %d\n", btc(Массив, 35));
        printf("Массив = [0]:x%x, [1]:x%x\n", Массив[0], Массив[1]);

        printf("btc(Массив, 35) = %d\n", btc(Массив, 35));
        printf("Массив = [0]:x%x, [1]:x%x\n", Массив[0], Массив[1]);

        printf("bts(Массив, 35) = %d\n", bts(Массив, 35));
        printf("Массив = [0]:x%x, [1]:x%x\n", Массив[0], Массив[1]);

        printf("btr(Массив, 35) = %d\n", btr(Массив, 35));
        printf("Массив = [0]:x%x, [1]:x%x\n", Массив[0], Массив[1]);

        printf("bt(Массив, 1) = %d\n", bt(Массив, 1));
        printf("Массив = [0]:x%x, [1]:x%x\n", Массив[0], Массив[1]);

        return 0;
    }
     * ---
     * Вывод:
    <pre>
    btc(Массив, 35) = 0
    Массив = [0]:x2, [1]:x108
    btc(Массив, 35) = -1
    Массив = [0]:x2, [1]:x100
    bts(Массив, 35) = 0
    Массив = [0]:x2, [1]:x108
    btr(Массив, 35) = -1
    Массив = [0]:x2, [1]:x100
    bt(Массив, 1) = -1
    Массив = [0]:x2, [1]:x100
    </pre>
     */
    цел bts( бцел* p, бцел bitnum );


    /**
     * Swaps байты in a 4 байт бцел конец-в_-конец, i.e. байт 0 becomes
     * байт 3, байт 1 becomes байт 2, байт 2 becomes байт 1, байт 3
     * becomes байт 0.
     */
    бцел bswap( бцел v );


    /**
     * Reads I/O порт at port_адрес.
     */
    ббайт inp( бцел port_адрес );


    /**
     * ditto
     */
    бкрат inpw( бцел port_адрес );


    /**
     * ditto
     */
    бцел inpl( бцел port_адрес );


    /**
     * Writes and returns значение в_ I/O порт at port_адрес.
     */
    ббайт outp( бцел port_адрес, ббайт значение );


    /**
     * ditto
     */
    бкрат outpw( бцел port_адрес, бкрат значение );


    /**
     * ditto
     */
    бцел outpl( бцел port_адрес, бцел значение );
}
else version( LDC )
{
    public import ldc.bitmanip;
}
else
{
    public import std.intrinsic;
}


/**
 *  Calculates the число of установи биты in a 32-bit целое.
 */
цел popcnt( бцел x )
{
    // Avoопр branches, and the potential for cache misses which
    // could be incurred with a table отыщи.

    // We need в_ маска alternate биты в_ prevent the
    // sum из_ overflowing.
    // добавь neighbouring биты. Each bit is 0 or 1.
    x = x - ((x>>1) & 0x5555_5555);
    // сейчас each two биты of x is a число 00,01 or 10.
    // сейчас добавь neighbouring pairs
    x = ((x&0xCCCC_CCCC)>>2) + (x&0x3333_3333);
    // сейчас each nibble holds 0000-0100. добавим them won't
    // перебор any ещё, so we don't need в_ маска any ещё

    // Сейчас добавь the nibbles, then the байты, then the words
    // We still need в_ маска в_ prevent дво-counting.
    // Note that if we used a rotate instead of a shift, we
    // wouldn't need the маски, and could just divопрe the sum
    // by 8 в_ account for the дво-counting.
    // On some CPUs, it may be faster в_ perform a multИПly.

    x += (x>>4);
    x &= 0x0F0F_0F0F;
    x += (x>>8);
    x &= 0x00FF_00FF;
    x += (x>>16);
    x &= 0xFFFF;
    return x;
}


debug( UnitTest )
{
    unittest
    {
      assert( popcnt( 0 ) == 0 );
      assert( popcnt( 7 ) == 3 );
      assert( popcnt( 0xAA )== 4 );
      assert( popcnt( 0x8421_1248 ) == 8 );
      assert( popcnt( 0xFFFF_FFFF ) == 32 );
      assert( popcnt( 0xCCCC_CCCC ) == 16 );
      assert( popcnt( 0x7777_7777 ) == 24 );
    }
}


/**
 * Reverses the order of биты in a 32-bit целое.
 */
бцел битсвоп( бцел x )
{

    version( D_InlineAsm_X86 )
    {
        asm
        {
            // Author: Tiago Gasiba.
            mov EDX, EAX;
            shr EAX, 1;
            and EDX, 0x5555_5555;
            and EAX, 0x5555_5555;
            shl EDX, 1;
            or  EAX, EDX;
            mov EDX, EAX;
            shr EAX, 2;
            and EDX, 0x3333_3333;
            and EAX, 0x3333_3333;
            shl EDX, 2;
            or  EAX, EDX;
            mov EDX, EAX;
            shr EAX, 4;
            and EDX, 0x0f0f_0f0f;
            and EAX, 0x0f0f_0f0f;
            shl EDX, 4;
            or  EAX, EDX;
            bswap EAX;
        }
    }
    else
    {
        // своп odd and even биты
        x = ((x >> 1) & 0x5555_5555) | ((x & 0x5555_5555) << 1);
        // своп consecutive pairs
        x = ((x >> 2) & 0x3333_3333) | ((x & 0x3333_3333) << 2);
        // своп nibbles
        x = ((x >> 4) & 0x0F0F_0F0F) | ((x & 0x0F0F_0F0F) << 4);
        // своп байты
        x = ((x >> 8) & 0x00FF_00FF) | ((x & 0x00FF_00FF) << 8);
        // своп 2-байт дол pairs
        x = ( x >> 16              ) | ( x               << 16);
        return x;

    }
}


debug( UnitTest )
{
    unittest
    {
        assert( битсвоп( 0x8000_0100 ) == 0x0080_0001 );
    }
}
