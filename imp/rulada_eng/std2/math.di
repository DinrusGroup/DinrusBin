// Written in the D programming language

/**
 * Macros:
 *	WIKI = Phobos/StdMath
 *
 *	TABLE_SV = <table border=1 cellpadding=4 cellspacing=0>
 *		<caption>Special Values</caption>
 *		$0</table>
 *	SVH = $(TR $(TH $1) $(TH $2))
 *	SV  = $(TR $(TD $1) $(TD $2))
 *
 *	NAN = $(RED NAN)
 *	SUP = <span style="vertical-align:super;font-size:smaller">$0</span>
 *	GAMMA =  &#915;
 *	INTEGRAL = &#8747;
 *	INTEGRATE = $(BIG &#8747;<sub>$(SMALL $1)</sub><sup>$2</sup>)
 *	POWER = $1<sup>$2</sup>
 *	BIGSUM = $(BIG &Sigma; <sup>$2</sup><sub>$(SMALL $1)</sub>)
 *	CHOOSE = $(BIG &#40;) <sup>$(SMALL $1)</sup><sub>$(SMALL $2)</sub> $(BIG &#41;)
 *	PLUSMN = &plusmn;
 *	INFIN = &infin;
 *	PI = &pi;
 *	LT = &lt;
 *	GT = &gt;
 */

/*
 * Author:
 *	Walter Bright
 * Copyright:
 *	Copyright (c) 2001-2005 by Digital Mars,
 *	All Rights Reserved,
 *	www.digitalmars.com
 * License:
 *  This software is provided 'as-is', without any express or implied
 *  warranty. In no event will the authors be held liable for any damages
 *  arising from the use of this software.
 *
 *  Permission is granted to anyone to use this software for any purpose,
 *  including commercial applications, and to alter it and redistribute it
 *  freely, subject to the following restrictions:
 *
 *  <ul>
 *  <li> The origin of this software must not be misrepresented; you must not
 *       claim that you wrote the original software. If you use this software
 *       in a product, an acknowledgment in the product documentation would be
 *       appreciated but is not required.
 *  </li>
 *  <li> Altered source versions must be plainly marked as such, and must not
 *       be misrepresented as being the original software.
 *  </li>
 *  <li> This notice may not be removed or altered from any source
 *       distribution.
 *  </li>
 *  </ul>
 */


module std2.math;

//version(Tango) import std.compat;
public import std.math;
static import std.c;

private import std2.traits;

/******************************************
 * Calculates the next representable value after x in the direction of y. 
 *
 * If y $(GT) x, the result will be the next largest floating-point value;
 * if y $(LT) x, the result will be the next smallest value.
 * If x == y, the result is y.
 * The FE_INEXACT and FE_OVERFLOW exceptions will be raised if x is finite and
 * the function result is infinite. The FE_INEXACT and FE_UNDERFLOW 
 * exceptions will be raised if the function value is subnormal, and x is 
 * not equal to y. 
 */
real nextafter(real x, real y)
{
    version(Windows) {
        return std.c.nextafter(x,y);
    }
    else {
        return std.c.nextafterl(x, y);
    }
}

/// ditto
float nextafter(float x, float y)
{
    return std.c.nextafterf(x, y);
}

/// ditto
double nextafter(double x, double y)
{
    return std.c.nextafter(x, y);
}

unittest
{
    float a = 1;
    double b = 2;
    real c = 3;
    assert(is(typeof(nextafter(a, a)) == float));
    assert(is(typeof(nextafter(b, b)) == double));
    assert(is(typeof(nextafter(c, c)) == real));
    assert(nextafter(a, a.infinity) > a);
    assert(nextafter(b, b.infinity) > b);
    assert(nextafter(c, c.infinity) > c);
}

//real nexttoward(real x, real y) { return std.c.nexttowardl(x, y); }

/**
   Computes whether $(D lhs) is approximately equal to $(D rhs)
   admitting a maximum relative difference $(D maxRelDiff) and a
   maximum absolute difference $(D maxAbsDiff).
 */
bool approxEqual(T, U, V)(T lhs, U rhs, V maxRelDiff, V maxAbsDiff = 0)
{
    static if (isArray!(T)) {
        final n = lhs.length;
        static if (isArray!(U)) {
            // Two arrays
            assert(n == rhs.length);
            for (uint i = 0; i != n; ++i) {
                if (!approxEqual(lhs[i], rhs[i], maxRelDiff, maxAbsDiff))
                    return false;
            }
        } else {
            // lhs is array, rhs is number
            for (uint i = 0; i != n; ++i) {
                if (!approxEqual(lhs[i], rhs, maxRelDiff, maxAbsDiff))
                    return false;
            }
        }
        return true;
    } else {
        static if (isArray!(U)) {
            // lhs is number, rhs is array
            return approxEqual(rhs, lhs, maxRelDiff);
        } else {
            // two numbers
            //static assert(is(T : real) && is(U : real));
            if (rhs == 0) {
                return (lhs == 0 ? 0 : 1) <= maxRelDiff;
            }
            return fabs((lhs - rhs) / rhs) <= maxRelDiff
                || maxAbsDiff != 0 && fabs(lhs - rhs) < maxAbsDiff;
        }
    }
}

/**
   Returns $(D approxEqual(lhs, rhs, 0.01)).
 */
bool approxEqual(T, U)(T lhs, U rhs) {
    return approxEqual(lhs, rhs, 0.01);
}

unittest
{
    assert(approxEqual(1.0, 1.0099));
    assert(!approxEqual(1.0, 1.011));
    float[] arr1 = [ 1.0, 2.0, 3.0 ];
    double[] arr2 = [ 1.001, 1.999, 3 ];
    assert(approxEqual(arr1, arr2));
}

version (build) {
    debug {
        pragma(link, "auxd");
    } else {
        pragma(link, "auxd");
    }
}
