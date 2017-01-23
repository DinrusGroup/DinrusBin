/** Optimised asm arbitrary точность arithmetic ('bignum') 
 * routines for X86 processors.
 *
 * All functions operate on массивы of uints, stored LSB first.
 * If there is a destination array, it will be the first parameter.
 * Currently, all of these functions are субъект to change, and are
 * intended for internal use only. 
 * The symbol [#] indicates an array of machine words which is to be
 * interpreted as a multi-byte число.
 *
 * Copyright: Copyright (C) 2008 Don Clugston.  All rights reserved.
 * License:   BSD style: $(LICENSE)
 * Authors:   Don Clugston
 */
/**
 * In simple terms, there are 3 modern x86 microarchitectures:
 * (a) the P6 семейство (Pentium Pro, PII, PIII, PM, Core), produced by Intel;
 * (b) the K6, Athlon, and AMD64 families, produced by AMD; and
 * (c) the Pentium 4, produced by Marketing.
 *
 * This код есть been optimised for the Intel P6 семейство.
 * Generally the код remains near-optimal for Intel Core2, after translating
 * EAX-> RAX, etc, since all these CPUs use essentially the same pИПeline, and
 * are typically limited by memory access.
 * The код uses techniques described in Agner Fog's superb Pentium manuals
 * available at www.agner.org.
 * Not optimised for AMD, which can do two memory loads per cycle (Intel
 * CPUs can only do one). Despite this, performance is superior on AMD.
 * Performance is dreadful on P4. 
 *
 *  Timing results (cycles per цел)
 *              --Intel Pentium--  --AMD--
 *              PM     P4   Core2   K7 
 *  +,-         2.25  15.6   2.25   1.5
 *  <<,>>       2.0    6.6   2.0    5.0
 *    (<< MMX)  1.7    5.3   1.5    1.2
 *  *           5.0   15.0   4.0    4.3
 *  mulAdd      5.7   19.0   4.9    4.0
 *  div        30.0   32.0  32.0   22.4
 *  mulAcc(32)  6.5   20.0   5.4    4.9
 *
 * mulAcc(32) is multИПlyAccumulate() for a 32*32 multИПly. Thus it includes
 * function call overhead.
 * The timing for Div is quite unpredictable, but it's probably too slow
 * to be useful. On 64-bit processors, these times should
 * halve if run in 64-bit режим, except for the MMX functions.
 */

module math.internal.BignumX86;

/*  
  Naked asm is used throughout, because:
  (a) it frees up the EBP register
  (b) compiler bugs prevent the use of .ptr when a frame pointer is used.
*/

version(GNU) {
    // GDC is a filthy liar. It can't actually do inline asm.
} else version(D_InlineAsm_X86) {
    version = Really_D_InlineAsm_X86;
} else version(LLVM_InlineAsm_X86) { 
        version = Really_D_InlineAsm_X86; 
}

version(Really_D_InlineAsm_X86) {

private:

/* Duplicate ткст s, with n times, substituting index for '@'.
 *
 * Each instance of '@' in s is replaced by 0,1,...n-1. This is a helper
 * function for some of the asm routines.
 */
сим [] откатиИндексированныйЦикл(цел n, сим [] s);

public:
    
alias бцел БольшЦифра; // A Bignum is an array of BigDigits. Usually the machine word size.
    
// Limits for when to switch between multИПlication algorithms.
enum : цел { KARATSUBALIMIT = 18 }; // Minimum value for which Karatsuba is worthwhile.
enum : цел { KARATSUBASQUARELIMIT=26 }; // Minimum value for which square Karatsuba is worthwhile
    
/** Multi-byte addition or subtraction
 *    приёмник[#] = src1[#] + src2[#] + carry (0 or 1).
 * or приёмник[#] = src1[#] - src2[#] - carry (0 or 1).
 * Returns carry or borrow (0 or 1).
 * Набор op == '+' for addition, '-' for subtraction.
 */
бцел многобайтПрибавОтним(сим op)(бцел[] приёмник, бцел [] src1, бцел [] src2, бцел carry);
/** приёмник[#] += carry, or приёмник[#] -= carry.
 *  op must be '+' or '-'
 *  Returns final carry or borrow (0 or 1)
 */
бцел многобайтИнкрПрисвой(сим op)(бцел[] приёмник, бцел carry);
 
/** приёмник[#] = src[#] << numbits
 *  numbits must be in the range 1..31
 *  Returns the overflow
 */
бцел многобайтСдвигЛБезММХ(бцел [] приёмник, бцел [] src, бцел numbits);

/** приёмник[#] = src[#] >> numbits
 *  numbits must be in the range 1..31
 * This version uses MMX.
 */
бцел многобайтСдвигЛ(бцел [] приёмник, бцел [] src, бцел numbits);

проц многобайтСдвигП(бцел [] приёмник, бцел [] src, бцел numbits);

/** приёмник[#] = src[#] >> numbits
 *  numbits must be in the range 1..31
 */
проц многобайтСдвигПБезММХ(бцел [] приёмник, бцел [] src, бцел numbits);

/** приёмник[#] = src[#] * множитель + carry.
 * Returns carry.
 */
бцел многобайтУмнож(бцел[] приёмник, бцел[] src, бцел множитель, бцел carry);

// The inner multИПly-and-add loop, together with the Even entry точка.
// MultИПles by M_ADDRESS which should be "ESP+LASTPARAM" or "ESP". OP must be "add" or "sub"
// This is the most time-critical код in the BigInt library.
// It is used by Всё MulAdd, multИПlyAccumulate, and triangleAccumulate
сим [] асмУмножьДоб_внутрцикл(сим [] OP, сим [] M_ADDRESS) ;
сим [] асмУмножьДоб_вх_одд(сим [] OP, сим [] M_ADDRESS);
		


/**
 * приёмник[#] += src[#] * множитель OP carry(0..FFFF_FFFF).
 * where op == '+' or '-'
 * Returns carry out of MSB (0..FFFF_FFFF).
 */
бцел многобайтУмножПрибавь(сим op)(бцел [] приёмник, бцел[] src, бцел множитель, бцел carry);

/** 
   Sets result[#] = result[0..left.length] + left[#] * right[#]
   
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

/**  приёмник[#] /= divisor.
 * overflow is the начальное remainder, and must be in the range 0..divisor-1.
 * divisor must not be a power of 2 (use right shift for that case;
 * A division by zero will occur if divisor is a power of 2).
 * Returns the final remainder
 *
 * Based on public домен код by Eric Bainville. 
 * (http://www.bealto.com/) Used with permission.
 */
бцел многобайтПрисвойДеление(бцел [] приёмник, бцел divisor, бцел overflow);

// Набор приёмник[2*i..2*i+1]+=src[i]*src[i]
проц многобайтПрибавьДиагПлощ(бцел [] приёмник, бцел [] src);
проц многобайтПрямоугАккумД(бцел[] приёмник, бцел[] x);

//приёмник += src[0]*src[1...$] + src[1]*src[2..$] + ... + src[$-3]*src[$-2..$]+ src[$-2]*src[$-1]
// assert(приёмник.length = src.length*2);
// assert(src.length >= 3);
проц многобайтПрямоугАккумАсм(бцел[] приёмник, бцел[] src);
проц многобайтПлощадь(БольшЦифра[] result, БольшЦифра [] x);
}