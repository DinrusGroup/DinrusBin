/** Fundamental operations for arbitrary-точность arithmetic
 *
 * These functions are for internal use only.
 *
 * Copyright: Copyright (C) 2008 Don Clugston.  все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Don Clugston
 */
/* References:
  - R.P. Brent и P. Zimmermann, "Modern Computer Arithmetic", 
    Версия 0.2, p. 26, (June 2009).
  - C. Burkinel и J. Ziegler, "Быстрый Recursive Division", MPI-I-98-1-022, 
    Max-Planck Institute fuer Informatik, (Oct 1998).
  - G. Hanrot, M. Quercia, и P. Zimmermann, "The Mопрdle Product Algorithm, I.",
    INRIA 4664, (Dec 2002).
  - M. Bodrato и A. Zanoni, "What about Toom-Cook Matrices Optimality?",
    http://bodrato.it/papers (2006).
  - A. Fog, "Optimizing subroutines in assembly language", 
    www.agner.org/оптимизируй (2008).
  - A. Fog, "The microarchitecture of Intel и AMD CPU's",
    www.agner.org/оптимизируй (2008).
  - A. Fog, "Instruction tables: Lists of instruction latencies, throughputs
    и micro-operation breakdowns for Intel и AMD CPU's.", www.agner.org/оптимизируй (2008).
*/ 
module math.internal.BiguintCore;

//version=TangoBignumNoAsm;       /// temporal: see ticket #1878

version(GNU){
    // GDC is a filthy liar. It can't actually do inline asm.
} else version(D_InlineAsm_X86) {
    version = Naked_D_InlineAsm_X86;
} else version(LLVM_InlineAsm_X86) { 
    version = Naked_D_InlineAsm_X86; 
}

version(Naked_D_InlineAsm_X86) { 
private import math.internal.BignumX86;
} else {
private import math.internal.BignumNoAsm;
}
version(build){// bud/build won't link properly without this.
    static import math.internal.BignumX86;
}

alias многобайтПрибавОтним!('+') multibyteAdd;
alias многобайтПрибавОтним!('-') multibyteSub;

// private import core.Cpuid;
static this()
{
    CACHELIMIT = 8000; // core.Cpuid.кэш_данных[0].размер/2;
    FASTDIVLIMIT = 100;
}

private:
// Limits for when в_ switch between algorithms.
const цел CACHELIMIT;   // Half the размер of the данные кэш.
const цел FASTDIVLIMIT; // crossover в_ recursive division


// These constants are использован by shift operations
static if (БольшЦифра.sizeof == цел.sizeof) {
    enum { LG2BIGDIGITBITS = 5, BIGDIGITSHIFTMASK = 31 };
    alias бкрат BIGHALFDIGIT;
} else static if (БольшЦифра.sizeof == дол.sizeof) {
    alias бцел BIGHALFDIGIT;
    enum { LG2BIGDIGITBITS = 6, BIGDIGITSHIFTMASK = 63 };
} else static assert(0, "Unsupported БольшЦифра size");

const БольшЦифра [] ZERO = [0];
const БольшЦифра [] ONE = [1];
const БольшЦифра [] TWO = [2];
const БольшЦифра [] TEN = [10];

public:       

/// БольшБцел performs память management и wraps the low-уровень calls.
struct БольшБцел {
private:
    invariant() {
        assert( данные.length == 1 || данные[$-1] != 0 );
    }
    БольшЦифра [] данные = ZERO; 
    static БольшБцел opCall(БольшЦифра [] x) {
       БольшБцел a;
       a.данные = x;
       return a;
    }
public: // for development only, will be removed eventually
    // Equivalent в_ БольшБцел[члобайтов-$..$]
    БольшБцел срежьВерхниеБайты(бцел члобайтов) ;
    // Length in бцелs
    цел бцелДлина() ;
    цел бдолДлина();
	
    // The значение at (cast(бдол[])данные)[n]
    бдол возьмиБдол(цел n) ;
    бцел возьмиБцел(цел n) ;
public:
    ///
    проц opAssign(бдол u) ;
///
цел opCmp(БольшБцел y);

///
цел opCmp(бдол y);

цел opEquals(БольшБцел y) ;

цел opEquals(бдол y);


бул ноль_ли() ;

цел члоБайтов() ;


сим [] вДесятичнТкст(цел frontExtraBytes);

/** Convert в_ a hex ткст, printing a minimum число of цифры 'minPдобавим',
 *  allocating an добавьitional 'frontExtraBytes' at the старт of the ткст.
 *  Pдобавим is готово with padChar, which may be '0' or ' '.
 *  'разделитель' is a цифра separation character. If non-zero, it is inserted
 *  between every 8 цифры.
 *  Separator characters do not contribute в_ the minPдобавим.
 */
сим [] вГексТкст(цел frontExtraBytes, сим разделитель = 0, цел minPдобавим=0, сим padChar = '0');

// return нет if не_годится character найдено
бул изГексТкст(сим [] s);

// return да if ОК; нет if erroneous characters найдено
бул изДесятичнТкст(сим [] s);
////////////////////////
//
// все of these member functions создай a new БольшБцел.

// return x >> y
БольшБцел opShr(бдол y);

// return x << y
БольшБцел opShl(бдол y);

// If wantSub is нет, return x+y, leaving знак unchanged
// If wantSub is да, return абс(x-y), negating знак if x<y
static БольшБцел addOrSubInt(БольшБцел x, бдол y, бул wantSub, бул *знак) ;

// If wantSub is нет, return x + y, leaving знак unchanged.
// If wantSub is да, return абс(x - y), negating знак if x<y
static БольшБцел addOrSub(БольшБцел x, БольшБцел y, бул wantSub, бул *знак);

//  return x*y.
//  y must not be zero.
static БольшБцел mulInt(БольшБцел x, бдол y);

/*  return x*y.
 */
static БольшБцел mul(БольшБцел x, БольшБцел y);

// return x/y
static БольшБцел divInt(БольшБцел x, бцел y) ;

// return x%y
static бцел modInt(БольшБцел x, бцел y);

// return x/y
static БольшБцел div(БольшБцел x, БольшБцел y);

// return x%y
static БольшБцел mod(БольшБцел x, БольшБцел y);

/**
 * Return a БольшБцел which is x raised в_ the power of y.
 * Метод: Powers of 2 are removed из_ x, then left-в_-right binary
 * exponentiation is использован.
 * Memory allocation is minimized: at most one temporary БольшБцел is использован.
 */
static БольшБцел степень(БольшБцел x, бдол y);
} // конец БольшБцел


// Удали leading zeros из_ x, в_ restore the БольшБцел invariant
БольшЦифра[] removeLeadingZeros(БольшЦифра [] x);