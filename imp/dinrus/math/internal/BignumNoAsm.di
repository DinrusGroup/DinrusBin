/** Arbitrary точность arithmetic ('bignum') for processors with no asm support
 *
 * All functions operate on массивы of uints, stored LSB first.
 * If there is a destination array, it will be the first parameter.
 * Currently, all of these functions are субъект to change, and are
 * intended for internal use only.
 * This module is intended only to assist development of high-скорость routines
 * on currently unsupported processors.
 * The X86 asm version is about 30 times faster than the D version(DMD).
 *
 * Copyright: Copyright (C) 2008 Don Clugston.  All rights reserved.
 * License:   BSD style: $(LICENSE)
 * Authors:   Don Clugston
 */

module math.internal.BignumNoAsm;

public:
alias бцел БольшЦифра; // A Bignum is an array of BigDigits. 
    
    // Limits for when to switch between multИПlication algorithms.
enum : цел { KARATSUBALIMIT = 10 }; // Minimum value for which Karatsuba is worthwhile.
enum : цел { KARATSUBASQUARELIMIT=12 }; // Minimum value for which square Karatsuba is worthwhile


/** Multi-byte addition or subtraction
 *    приёмник[] = src1[] + src2[] + carry (0 or 1).
 * or приёмник[] = src1[] - src2[] - carry (0 or 1).
 * Returns carry or borrow (0 or 1).
 * Набор op == '+' for addition, '-' for subtraction.
 */
бцел многобайтПрибавОтним(сим op)(бцел[] приёмник, бцел [] src1, бцел [] src2, бцел carry);
/** приёмник[] += carry, or приёмник[] -= carry.
 *  op must be '+' or '-'
 *  Returns final carry or borrow (0 or 1)
 */
бцел многобайтИнкрПрисвой(сим op)(бцел[] приёмник, бцел carry);

/** приёмник[] = src[] << numbits
 *  numbits must be in the range 1..31
 */
бцел многобайтСдвигЛ(бцел [] приёмник, бцел [] src, бцел numbits);

/** приёмник[] = src[] >> numbits
 *  numbits must be in the range 1..31
 */
проц многобайтСдвигП(бцел [] приёмник, бцел [] src, бцел numbits);

/** приёмник[] = src[] * множитель + carry.
 * Returns carry.
 */
бцел многобайтУмнож(бцел[] приёмник, бцел[] src, бцел множитель, бцел carry);

/**
 * приёмник[] += src[] * множитель + carry(0..FFFF_FFFF).
 * Returns carry out of MSB (0..FFFF_FFFF).
 */
бцел многобайтУмножПрибавь(сим op)(бцел [] приёмник, бцел[] src, бцел множитель, бцел carry);

/** 
   Sets result = result[0..left.length] + left * right
   
   It is defined in this way to allow cache-efficient multИПlication.
   This function is equivalent to:
    ----
    for (цел i = 0; i< right.length; ++i) {
        приёмник[left.length + i] = многобайтУмножПрибавь(приёмник[i..left.length+i],
                left, right[i], 0);
    }
    ----
 */
проц многобайтУмножАккум(бцел [] приёмник, бцел[] left, бцел [] right);

/**  приёмник[] /= divisor.
 * overflow is the начальное remainder, and must be in the range 0..divisor-1.
 */
бцел многобайтПрисвойДеление(бцел [] приёмник, бцел divisor, бцел overflow);

// Набор приёмник[2*i..2*i+1]+=src[i]*src[i]
проц многобайтПрибавьДиагПлощ(бцел[] приёмник, бцел[] src);

// Does half a square multИПly. (square = diagonal + 2*triangle)
проц многобайтПрямоугАккум(бцел[] приёмник, бцел[] x);

проц многобайтПлощадь(БольшЦифра[] result, БольшЦифра [] x);