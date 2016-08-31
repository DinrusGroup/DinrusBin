/*
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

    Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.

    Redistributions in binary form must reproduce the above
    copyright notice, this list of conditions and the following
    disclaimer in the documentation and/or other materials provided
    with the distribution.

    Neither name of Victor Nakoryakov nor the names of
    its contributors may be used to endorse or promote products
    derived from this software without specific prior written
    permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2006. Victor Nakoryakov.
*/
/**
Module provides _basic numeric routines that are oftenly used in other
modules or helpful in projects that use auxd.helix.

Authors:
    Victor Nakoryakov, nail-mail[at]mail.ru
*/
module auxd.helix.basic;

import std.math;
import auxd.helix.config;

/**
Approximate equality function. In fact it's just a copy of phobos'es feqrel function,
but with modifcation that make it suitable for comparison of almost zero numbers.
However the cost of such possibility is little calculation overhead.

Params:
    x, y        = Numbers to compare.
    relprec     = Minimal number of mantissa bits that have to be _equal in x and y
                  to suppose their's equality. Makes sense in comparisons of values
                  enough far from zero.
    absprec     = If absolute difference between x and y is less than 2^(-absprec)
                  they supposed to be _equal. Makes sense in comparisons of values
                  enough near to zero.
                
Возвращает:
    true if x and y are supposed to be _equal, false otherwise.
*/
bool equal(real x, real y, int relprec = defrelprec, int absprec = defabsprec)
{
    /* Author: Don Clugston, 18 Aug 2005.
     */

    if (x == y)
        return true; // ensure diff!=0, cope with INF.

    real diff = fabs(x - y);
    
    ushort *pa = cast(ushort*)(&x);
    ushort *pb = cast(ushort*)(&y);
    ushort *pd = cast(ushort*)(&diff);

    // This check is added by me. If absolute difference between
    // x and y is less than 2^(-absprec) then count them equal.
    if (pd[4] < 0x3FFF - absprec)
        return true;

    // The difference in abs(exponent) between x or y and abs(x-y)
    // is equal to the number of mantissa bits of x which are
    // equal to y. If negative, x and y have different exponents.
    // If positive, x and y are equal to 'bitsdiff' bits.
    // AND with 0x7FFF to form the absolute value.
    // To avoid out-by-1 errors, we subtract 1 so it rounds down
    // if the exponents were different. This means 'bitsdiff' is
    // always 1 lower than we want, except that if bitsdiff==0,
    // they could have 0 or 1 bits in common.
    int bitsdiff = ( ((pa[4]&0x7FFF) + (pb[4]&0x7FFF)-1)>>1) - pd[4];

    if (pd[4] == 0)
    {   // Difference is denormal
        // For denormals, we need to add the number of zeros that
        // lie at the start of diff's mantissa.
        // We do this by multiplying by 2^real.mant_dig
        diff *= 0x1p+63;
        return bitsdiff + real.mant_dig - pd[4] >= relprec;
    }

    if (bitsdiff > 0)
        return bitsdiff + 1 >= relprec; // add the 1 we subtracted before

    // Avoid out-by-1 errors when factor is almost 2.
    return (bitsdiff == 0) ? (relprec <= 1) : false;
}


template EqualityByNorm(T)
{
    bool equal(T a, T b, int relprec = defrelprec, int absprec = defabsprec)
    {
        return .equal((b - a).normSquare, 0.L, relprec, absprec);
    }
}


bool less(real a, real b, int relprec = defrelprec, int absprec = defabsprec)
{
    return a < b && !equal(a, b, relprec, absprec);
}


bool greater(real a, real b, int relprec = defrelprec, int absprec = defabsprec)
{
    return a > b && !equal(a, b, relprec, absprec);
}

/**
Linear interpolation function.
Возвращает:
    Value interpolated from a to b by value of t. If t is not within range [0; 1]
    linear extrapolation is applied.
*/
real lerp(real a, real b, real t)
{
    return a * (1 - t) + b * t;
}


template Lerp(T)
{
    T lerp(T a, T b, real t)
    {
        return a * (1 - t) + b * t;
    }
}

/**
Contains min and max functions for generic types that provide
opCmp.
*/
template MinMax(T)
{
    /**
    Возвращает:
        Maximal of a and b.
    */
    T max(T a, T b)
    {
        return (a > b) ? a : b;
    }

    /**
    Возвращает:
        Minimal of a and b.
    */
    T min(T a, T b)
    {
        return (a < b) ? a : b;
    }
}

/// Introduce min and max functions for basic numeric types.
alias MinMax!(bool).min     min;
alias MinMax!(bool).max     max; /// ditto
alias MinMax!(byte).min     min; /// ditto
alias MinMax!(byte).max     max; /// ditto
alias MinMax!(ubyte).min    min; /// ditto
alias MinMax!(ubyte).max    max; /// ditto
alias MinMax!(short).min    min; /// ditto
alias MinMax!(short).max    max; /// ditto
alias MinMax!(ushort).min   min; /// ditto
alias MinMax!(ushort).max   max; /// ditto
alias MinMax!(int).min      min; /// ditto
alias MinMax!(int).max      max; /// ditto
alias MinMax!(uint).min     min; /// ditto
alias MinMax!(uint).max     max; /// ditto
alias MinMax!(long).min     min; /// ditto
alias MinMax!(long).max     max; /// ditto
alias MinMax!(ulong).min    min; /// ditto
alias MinMax!(ulong).max    max; /// ditto
alias MinMax!(float).min    min; /// ditto
alias MinMax!(float).max    max; /// ditto
alias MinMax!(double).min   min; /// ditto
alias MinMax!(double).max   max; /// ditto
alias MinMax!(real).min     min; /// ditto
alias MinMax!(real).max     max; /// ditto


/**
Contains clamping functions for generic types to which min and max
functions can be applied.
*/
template Clamp(T)
{
    /**
    Makes value of x to be not less than inf. Method can change value of x.
    Возвращает:
        Copy of x after clamping is applied.
    */
    T clampBelow(inout T x, T inf)
    {
        return x = max(x, inf);
    }

    /**
    Makes value of x to be not greater than sup. Method can change value of x.
    Возвращает:
        Copy of x after clamping is applied.
    */
    T clampAbove(inout T x, T sup)
    {
        return x = min(x, sup);
    }

    /**
    Makes value of x to be nor less than inf nor greater than sup.
    Method can change value of x.
    Возвращает:
        Copy of x after clamping is applied.
    */
    T clamp(inout T x, T inf, T sup)
    {
        clampBelow(x, inf);
        return clampAbove(x, sup);
    }
}

/// Introduce clamping functions for basic numeric types.
alias Clamp!(bool).clampBelow   clampBelow;
alias Clamp!(bool).clampAbove   clampAbove; /// ditto
alias Clamp!(bool).clamp        clamp;      /// ditto
alias Clamp!(byte).clampBelow   clampBelow; /// ditto
alias Clamp!(byte).clampAbove   clampAbove; /// ditto
alias Clamp!(byte).clamp        clamp;      /// ditto
alias Clamp!(ubyte).clampBelow  clampBelow; /// ditto
alias Clamp!(ubyte).clampAbove  clampAbove; /// ditto
alias Clamp!(ubyte).clamp       clamp;      /// ditto
alias Clamp!(short).clampBelow  clampBelow; /// ditto
alias Clamp!(short).clampAbove  clampAbove; /// ditto
alias Clamp!(short).clamp       clamp;      /// ditto
alias Clamp!(ushort).clampBelow clampBelow; /// ditto
alias Clamp!(ushort).clampAbove clampAbove; /// ditto
alias Clamp!(ushort).clamp      clamp;      /// ditto
alias Clamp!(int).clampBelow    clampBelow; /// ditto
alias Clamp!(int).clampAbove    clampAbove; /// ditto
alias Clamp!(int).clamp         clamp;      /// ditto
alias Clamp!(uint).clampBelow   clampBelow; /// ditto
alias Clamp!(uint).clampAbove   clampAbove; /// ditto
alias Clamp!(uint).clamp        clamp;      /// ditto
alias Clamp!(long).clampBelow   clampBelow; /// ditto
alias Clamp!(long).clampAbove   clampAbove; /// ditto
alias Clamp!(long).clamp        clamp;      /// ditto
alias Clamp!(ulong).clampBelow  clampBelow; /// ditto
alias Clamp!(ulong).clampAbove  clampAbove; /// ditto
alias Clamp!(ulong).clamp       clamp;      /// ditto
alias Clamp!(float).clampBelow  clampBelow; /// ditto
alias Clamp!(float).clampAbove  clampAbove; /// ditto
alias Clamp!(float).clamp       clamp;      /// ditto
alias Clamp!(double).clampBelow clampBelow; /// ditto
alias Clamp!(double).clampAbove clampAbove; /// ditto
alias Clamp!(double).clamp      clamp;      /// ditto
alias Clamp!(real).clampBelow   clampBelow; /// ditto
alias Clamp!(real).clampAbove   clampAbove; /// ditto
alias Clamp!(real).clamp        clamp;      /// ditto

/** Contains swap function for generic types. */
template SimpleSwap(T)
{
    /** Swaps values of a and b. */
    void swap(inout T a, inout T b)
    {
        T temp = a;
        a = b;
        b = temp;
    }
}

/// Introduces swap function for basic numeric types.
alias SimpleSwap!(bool).swap   swap;
alias SimpleSwap!(byte).swap   swap; /// ditto
alias SimpleSwap!(ubyte).swap  swap; /// ditto
alias SimpleSwap!(short).swap  swap; /// ditto
alias SimpleSwap!(ushort).swap swap; /// ditto
alias SimpleSwap!(int).swap    swap; /// ditto
alias SimpleSwap!(uint).swap   swap; /// ditto
alias SimpleSwap!(long).swap   swap; /// ditto
alias SimpleSwap!(ulong).swap  swap; /// ditto
alias SimpleSwap!(float).swap  swap; /// ditto
alias SimpleSwap!(double).swap swap; /// ditto
alias SimpleSwap!(real).swap   swap; /// ditto
