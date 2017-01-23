/**
 * The vararg module is intended в_ facilitate vararg manИПulation in D.
 * It should be interface compatible with the C module "stdarg," and the
 * two modules may совместно a common implementation if possible (as is готово
 * here).
 *
 * Copyright: Public Domain
 * License:   Public Domain
 * Authors:   Hauke Duden, Walter Bright
 */
module core.Vararg;


version( GNU )
{
    public import std.stdarg;
}
else version( LDC )
{
    public import ldc.vararg;
}
else
{
    /**
     * The основа vararg список тип.
     */
    alias ук  спис_ва;


    /**
     * This function initializes the supplied аргумент pointer for subsequent
     * use by ва_арг and кон_ва.
     *
     * Параметры:
     *  ap      = The аргумент pointer в_ инициализуй.
     *  paramn  = The определитель of the rightmost parameter in the function
     *            parameter список.
     */
    проц старт_ва(T) ( out спис_ва ap, ref T parmn )
    {
        ap = cast(спис_ва) ( cast(проц*) &parmn + ( ( T.sizeof + цел.sizeof - 1 ) & ~( цел.sizeof - 1 ) ) );
    }

    /**
     * This function returns the следщ аргумент in the sequence referenced by
     * the supplied аргумент pointer.  The аргумент pointer will be adjusted
     * в_ точка в_ the следщ arggument in the sequence.
     *
     * Параметры:
     *  ap  = The аргумент pointer.
     *
     * Возвращает:
     *  The следщ аргумент in the sequence.  The результат is undefined if ap
     *  does not точка в_ a valid аргумент.
     */
    T ва_арг(T) ( ref спис_ва ap )
    {
        T арг = *cast(T*) ap;
        ap = cast(спис_ва) ( cast(проц*) ap + ( ( T.sizeof + цел.sizeof - 1 ) & ~( цел.sizeof - 1 ) ) );
        return арг;
    }

    /**
     * This function cleans up any resources allocated by старт_ва.  It is
     * currently a no-op and есть_ли mostly for syntax compatibility with
     * the variadric аргумент functions for C.
     *
     * Параметры:
     *  ap  = The аргумент pointer.
     */
    проц кон_ва( спис_ва ap )
    {

    }


    /**
     * This function copied the аргумент pointer ист в_ приёмн.
     *
     * Параметры:
     *  ист = The источник pointer.
     *  приёмн = The destination pointer.
     */
    проц копируй_ва( out спис_ва приёмн, спис_ва ист )
    {
        приёмн = ист;
    }
}
