/**
 * Элементарные Математические Функции
 */
module math.Math;

public import stdrus: абс, конъюнк, кос, син, тан, акос, асин, атан, атан2, гкос, гсин, гтан, гакос, гасин, гатан, округливдол, округливближдол, квкор, эксп, экспм1, эксп2, прэксп, лдэксп, лог, лог10, лог1п, лог2,модф, кубкор, гипот, фцош, лгамма, тгамма, потолок, пол, ближцел, окрвцел, окрвдол, округли, докругли, упрости, остаток, конечен_ли, нч, следщБольш, следщМеньш,пдельта, пбольш_из, пменьш_из, степень, правны, квадрат, дво, знак, цикл8градус, цикл8радиан, цикл8градиент, градус8цикл, градус8радиан, градус8градиент, радиан8градус, радиан8цикл, радиан8градиент, градиент8градус, градиент8цикл, градиент8радиан, сариф, сумма, меньш_из, больш_из, акот, асек, акосек, кот, сек, косек, гкот, гсек, гкосек, гакот, гасек, гакосек, ткст8реал;

private import math.IEEE;

private {
template минмакстип(T...){
    static if(T.length == 1) alias T[0] минмакстип;
    else static if(T.length > 2)
        alias минмакстип!(минмакстип!(T[0..2]), T[2..$]) минмакстип;
    else alias typeof (T[1] > T[0] ? T[1] : T[0]) минмакстип;
}
}

/** Возвращает минимальный из предложенных аргументов.
 *
 * Note: If the аргументы are floating-точка numbers, и at least one is a НЧ,
 * the результат is undefined.
 */
минмакстип!(T) мин(T...)(T арг){
    static if(арг.length == 1) return арг[0];
    else static if(арг.length == 2) return арг[1] < арг[0] ? арг[1] : арг[0];
    static if(арг.length > 2) return мин(арг[1] < арг[0] ? арг[1] : арг[0], арг[2..$]);
}

/** Return the maximum of the supplied аргументы.
 *
 * Note: If the аргументы are floating-точка numbers, и at least one is a НЧ,
 * the результат is undefined.
 */
минмакстип!(T) макс(T...)(T арг){
    static if(арг.length == 1) return арг[0];
    else static if(арг.length == 2) return арг[1] > арг[0] ? арг[1] : арг[0];
    static if(арг.length > 2) return макс(арг[1] > арг[0] ? арг[1] : арг[0], арг[2..$]);
}

/** Returns the minimum число of x и y, favouring numbers over NaNs.
 *
 * If Всё x и y are numbers, the minimum is returned.
 * If Всё параметры are НЧ, either will be returned.
 * If one parameter is a НЧ и the другой is a число, the число is
 * returned (this behaviour is mandated by IEEE 754R, и is useful
 * for determining the range of a function).
 */
реал минЧло(реал x, реал y) ;

/** Returns the maximum число of x и y, favouring numbers over NaNs.
 *
 * If Всё x и y are numbers, the maximum is returned.
 * If Всё параметры are НЧ, either will be returned.
 * If one parameter is a НЧ и the другой is a число, the число is
 * returned (this behaviour is mandated by IEEE 754-2008, и is useful
 * for determining the range of a function).
 */
реал максЧло(реал x, реал y);

/** Returns the minimum of x и y, favouring NaNs over numbers
 *
 * If Всё x и y are numbers, the minimum is returned.
 * If Всё параметры are НЧ, either will be returned.
 * If one parameter is a НЧ и the другой is a число, the НЧ is returned.
 */
реал минНч(реал x, реал y);

/** Returns the maximum of x и y, favouring NaNs over numbers
 *
 * If Всё x и y are numbers, the maximum is returned.
 * If Всё параметры are НЧ, either will be returned.
 * If one parameter is a НЧ и the другой is a число, the НЧ is returned.
 */
реал максНч(реал x, реал y);

/*****************************************
 * Sine, cosine, и arctangent of multИПle of &pi;
 *
 * Accuracy is preserved for large values of x.
 */
реал косПи(реал x);

/** ditto */
реал синПи(реал x);

/** ditto */
реал атанПи(реал x);

/***********************************
 * Коммплексный инверсный синус
 *
 * асин(z) = -i лог( квкор(1-$(POWER z, 2)) + iz)
 * где и лог, и квкор комплексные.
 */
креал асин(креал z);


/***********************************
 * Комплексный инверсный косинус
 *
 * акос(z) = $(ПИ)/2 - асин(z)
 */
креал акос(креал z);

/***********************************
 *  Гиперболический синус, комплексное и мнимое
 *
 *  гсин(z) = кос(z.im)*гсин(z.re) + син(z.im)*гкос(z.re)i
 */
креал гсин(креал z);

/** ditto */
вреал гсин(вреал y);

/***********************************
 *  hyperbolic cosine, комплексное и мнимое
 *
 *  гкос(z) = кос(z.im)*гкос(z.re) + син(z.im)*гсин(z.re)i
 */
креал гкос(креал z);

/** ditto */
реал гкос(вреал y);

/** ditto */
креал гатан(вреал y);

/** ditto */
креал гатан(креал z);

/+
креал квкор(креал z);
+/

/***********************************
 * Exponential, комплексное и мнимое
 *
 * For комплексное numbers, the exponential function is defined as
 *
 *  эксп(z) = эксп(z.re)кос(z.im) + эксп(z.re)син(z.im)i.
 *
 *  For a pure мнимое аргумент,
 *  эксп(&тэта;i)  = кос(&тэта;) + син(&тэта;)i.
 *
 */
креал эксп(вреал y);

/** ditto */
креал эксп(креал z);

/***********************************
 *  Natural logarithm, комплексное
 *
 * Returns комплексное logarithm в_ the основа e (2.718...) of
 * the комплексное аргумент x.
 *
 * If z = x + iy, then
 *       лог(z) = лог(абс(z)) + i arctan(y/x).
 *
 * The arctangent ranges из_ -ПИ в_ +ПИ.
 * There are branch cuts along Всё the негатив реал и негатив
 * мнимое axes. For pure мнимое аргументы, use one of the
 * following forms, depending on which branch is required.
 * ------------
 *    лог( 0.0 + yi) = лог(-y) + PI_2i  // y<=-0.0
 *    лог(-0.0 + yi) = лог(-y) - PI_2i  // y<=-0.0
 * ------------
 */
креал лог(креал z);


/***********************************
 * Evaluate polynomial A(x) = $(SUB a, 0) + $(SUB a, 1)x + $(SUB a, 2)$(POWER x,2)
 *                          + $(SUB a,3)$(POWER x,3); ...
 *
 * Uses Horner's правило A(x) = $(SUB a, 0) + x($(SUB a, 1) + x($(SUB a, 2) 
 *                         + x($(SUB a, 3) + ...)))
 * Параметры:
 *      A =     Массив of coefficients $(SUB a, 0), $(SUB a, 1), etc.
 */
T поли(T)(T x, T[] A)
in
{
    assert(A.length > 0);
}
body
{
  version (Naked_D_InlineAsm_X86) {
      const бул Use_D_InlineAsm_X86 = да;
  } else const бул Use_D_InlineAsm_X86 = нет;
  
  // BUG (Inherited из_ Phobos): This код assumes a frame pointer in EBP.
  // This is not in the spec.
  static if (Use_D_InlineAsm_X86 && is(T==реал) && T.sizeof == 10) {
    asm // assembler by W. Bright
    {
        // EDX = (A.length - 1) * реал.sizeof
        mov     ECX,A[EBP]          ; // ECX = A.length
        dec     ECX                 ;
        lea     EDX,[ECX][ECX*8]    ;
        add     EDX,ECX             ;
        add     EDX,A+4[EBP]        ;
        fld     real ptr [EDX]      ; // ST0 = coeff[ECX]
        jecxz   return_ST           ;
        fld     x[EBP]              ; // ST0 = x
        fxch    ST(1)               ; // ST1 = x, ST0 = r
        align   4                   ;
    L2:  fmul    ST,ST(1)           ; // r *= x
        fld     real ptr -10[EDX]   ;
        sub     EDX,10              ; // deg--
        faddp   ST(1),ST            ;
        dec     ECX                 ;
        jne     L2                  ;
        fxch    ST(1)               ; // ST1 = r, ST0 = x
        fstp    ST(0)               ; // dump x
        align   4                   ;
    return_ST:                      ;
        ;
    }
  } else static if ( Use_D_InlineAsm_X86 && is(T==реал) && T.sizeof==12){
    asm // assembler by W. Bright
    {
        // EDX = (A.length - 1) * реал.sizeof
        mov     ECX,A[EBP]          ; // ECX = A.length
        dec     ECX                 ;
        lea     EDX,[ECX*8]         ;
        lea     EDX,[EDX][ECX*4]    ;
        add     EDX,A+4[EBP]        ;
        fld     real ptr [EDX]      ; // ST0 = coeff[ECX]
        jecxz   return_ST           ;
        fld     x                   ; // ST0 = x
        fxch    ST(1)               ; // ST1 = x, ST0 = r
        align   4                   ;
    L2: fmul    ST,ST(1)            ; // r *= x
        fld     real ptr -12[EDX]   ;
        sub     EDX,12              ; // deg--
        faddp   ST(1),ST            ;
        dec     ECX                 ;
        jne     L2                  ;
        fxch    ST(1)               ; // ST1 = r, ST0 = x
        fstp    ST(0)               ; // dump x
        align   4                   ;
    return_ST:                      ;
        ;
        }
  } else {
        т_дельтаук i = A.length - 1;
        реал r = A[i];
        while (--i >= 0)
        {
            r *= x;
            r += A[i];
        }
        return r;
  }
}

package {
T рационалПоли(T)(T x, T [] numerator, T [] denominator)
{
    return поли(x, numerator)/поли(x, denominator);
}
}
