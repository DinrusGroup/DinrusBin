/**
 * D header file for C99.
 *
 * Copyright: Public Domain
 * License:   Public Domain
 * Authors:   Sean Kelly, Walter Bright
 * Standards: ISO/IEC 9899:1999 (E)
 */
module rt.core.stdc.tgmath;

private import rt.core.stdc.config;
private static import rt.core.stdc.math;
private static import rt.core.stdc.complex_;

extern  (C):

version( freebsd )
{
    alias rt.core.stdc.math.acos          acos;
    alias rt.core.stdc.math.acosf         acos;
    alias rt.core.stdc.math.acosl         acos;

    alias rt.core.stdc.complex_.cacos      acos;
    alias rt.core.stdc.complex_.cacosf     acos;
    alias rt.core.stdc.complex_.cacosl     acos;

    alias rt.core.stdc.math.asin          asin;
    alias rt.core.stdc.math.asinf         asin;
    alias rt.core.stdc.math.asinl         asin;

    alias rt.core.stdc.complex_.casin      asin;
    alias rt.core.stdc.complex_.casinf     asin;
    alias rt.core.stdc.complex_.casinl     asin;

    alias rt.core.stdc.math.atan          atan;
    alias rt.core.stdc.math.atanf         atan;
    alias rt.core.stdc.math.atanl         atan;

    alias rt.core.stdc.complex_.catan      atan;
    alias rt.core.stdc.complex_.catanf     atan;
    alias rt.core.stdc.complex_.catanl     atan;

    alias rt.core.stdc.math.atan2         atan2;
    alias rt.core.stdc.math.atan2f        atan2;
    alias rt.core.stdc.math.atan2l        atan2;

    alias rt.core.stdc.math.cos           cos;
    alias rt.core.stdc.math.cosf          cos;
    alias rt.core.stdc.math.cosl          cos;

    alias rt.core.stdc.complex_.ccos       cos;
    alias rt.core.stdc.complex_.ccosf      cos;
    alias rt.core.stdc.complex_.ccosl      cos;

    alias rt.core.stdc.math.sin           sin;
    alias rt.core.stdc.math.sinf          sin;
    alias rt.core.stdc.math.sinl          sin;

    alias rt.core.stdc.complex_.csin       csin;
    alias rt.core.stdc.complex_.csinf      csin;
    alias rt.core.stdc.complex_.csinl      csin;

    alias rt.core.stdc.math.tan           tan;
    alias rt.core.stdc.math.tanf          tan;
    alias rt.core.stdc.math.tanl          tan;

    alias rt.core.stdc.complex_.ctan       tan;
    alias rt.core.stdc.complex_.ctanf      tan;
    alias rt.core.stdc.complex_.ctanl      tan;

    alias rt.core.stdc.math.acosh         acosh;
    alias rt.core.stdc.math.acoshf        acosh;
    alias rt.core.stdc.math.acoshl        acosh;

    alias rt.core.stdc.complex_.cacosh     acosh;
    alias rt.core.stdc.complex_.cacoshf    acosh;
    alias rt.core.stdc.complex_.cacoshl    acosh;

    alias rt.core.stdc.math.asinh         asinh;
    alias rt.core.stdc.math.asinhf        asinh;
    alias rt.core.stdc.math.asinhl        asinh;

    alias rt.core.stdc.complex_.casinh     asinh;
    alias rt.core.stdc.complex_.casinhf    asinh;
    alias rt.core.stdc.complex_.casinhl    asinh;

    alias rt.core.stdc.math.atanh         atanh;
    alias rt.core.stdc.math.atanhf        atanh;
    alias rt.core.stdc.math.atanhl        atanh;

    alias rt.core.stdc.complex_.catanh     atanh;
    alias rt.core.stdc.complex_.catanhf    atanh;
    alias rt.core.stdc.complex_.catanhl    atanh;

    alias rt.core.stdc.math.cosh          cosh;
    alias rt.core.stdc.math.coshf         cosh;
    alias rt.core.stdc.math.coshl         cosh;

    alias rt.core.stdc.complex_.ccosh      cosh;
    alias rt.core.stdc.complex_.ccoshf     cosh;
    alias rt.core.stdc.complex_.ccoshl     cosh;

    alias rt.core.stdc.math.sinh          sinh;
    alias rt.core.stdc.math.sinhf         sinh;
    alias rt.core.stdc.math.sinhl         sinh;

    alias rt.core.stdc.complex_.csinh      sinh;
    alias rt.core.stdc.complex_.csinhf     sinh;
    alias rt.core.stdc.complex_.csinhl     sinh;

    alias rt.core.stdc.math.tanh          tanh;
    alias rt.core.stdc.math.tanhf         tanh;
    alias rt.core.stdc.math.tanhl         tanh;

    alias rt.core.stdc.complex_.ctanh      tanh;
    alias rt.core.stdc.complex_.ctanhf     tanh;
    alias rt.core.stdc.complex_.ctanhl     tanh;

    alias rt.core.stdc.math.exp           exp;
    alias rt.core.stdc.math.expf          exp;
    alias rt.core.stdc.math.expl          exp;

    alias rt.core.stdc.complex_.cexp       exp;
    alias rt.core.stdc.complex_.cexpf      exp;
    alias rt.core.stdc.complex_.cexpl      exp;

    alias rt.core.stdc.math.exp2          exp2;
    alias rt.core.stdc.math.exp2f         exp2;
    alias rt.core.stdc.math.exp2l         exp2;

    alias rt.core.stdc.math.expm1         expm1;
    alias rt.core.stdc.math.expm1f        expm1;
    alias rt.core.stdc.math.expm1l        expm1;

    alias rt.core.stdc.math.frexp         frexp;
    alias rt.core.stdc.math.frexpf        frexp;
    alias rt.core.stdc.math.frexpl        frexp;

    alias rt.core.stdc.math.ilogb         ilogb;
    alias rt.core.stdc.math.ilogbf        ilogb;
    alias rt.core.stdc.math.ilogbl        ilogb;

    alias rt.core.stdc.math.ldexp         ldexp;
    alias rt.core.stdc.math.ldexpf        ldexp;
    alias rt.core.stdc.math.ldexpl        ldexp;

    alias rt.core.stdc.math.log           log;
    alias rt.core.stdc.math.logf          log;
    alias rt.core.stdc.math.logl          log;

    alias rt.core.stdc.complex_.clog       log;
    alias rt.core.stdc.complex_.clogf      log;
    alias rt.core.stdc.complex_.clogl      log;

    alias rt.core.stdc.math.log10         log10;
    alias rt.core.stdc.math.log10f        log10;
    alias rt.core.stdc.math.log10l        log10;

    alias rt.core.stdc.math.log1p         log1p;
    alias rt.core.stdc.math.log1pf        log1p;
    alias rt.core.stdc.math.log1pl        log1p;

    alias rt.core.stdc.math.log2          log1p;
    alias rt.core.stdc.math.log2f         log1p;
    alias rt.core.stdc.math.log2l         log1p;

    alias rt.core.stdc.math.logb          log1p;
    alias rt.core.stdc.math.logbf         log1p;
    alias rt.core.stdc.math.logbl         log1p;

    alias rt.core.stdc.math.modf          modf;
    alias rt.core.stdc.math.modff         modf;
//  alias rt.core.stdc.math.modfl         modf;

    alias rt.core.stdc.math.scalbn        scalbn;
    alias rt.core.stdc.math.scalbnf       scalbn;
    alias rt.core.stdc.math.scalbnl       scalbn;

    alias rt.core.stdc.math.scalbln       scalbln;
    alias rt.core.stdc.math.scalblnf      scalbln;
    alias rt.core.stdc.math.scalblnl      scalbln;

    alias rt.core.stdc.math.cbrt          cbrt;
    alias rt.core.stdc.math.cbrtf         cbrt;
    alias rt.core.stdc.math.cbrtl         cbrt;

    alias rt.core.stdc.math.fabs          fabs;
    alias rt.core.stdc.math.fabsf         fabs;
    alias rt.core.stdc.math.fabsl         fabs;

    alias rt.core.stdc.complex_.cabs       fabs;
    alias rt.core.stdc.complex_.cabsf      fabs;
    alias rt.core.stdc.complex_.cabsl      fabs;

    alias rt.core.stdc.math.hypot         hypot;
    alias rt.core.stdc.math.hypotf        hypot;
    alias rt.core.stdc.math.hypotl        hypot;

    alias rt.core.stdc.math.pow           pow;
    alias rt.core.stdc.math.powf          pow;
    alias rt.core.stdc.math.powl          pow;

    alias rt.core.stdc.complex_.cpow       pow;
    alias rt.core.stdc.complex_.cpowf      pow;
    alias rt.core.stdc.complex_.cpowl      pow;

    alias rt.core.stdc.math.sqrt          sqrt;
    alias rt.core.stdc.math.sqrtf         sqrt;
    alias rt.core.stdc.math.sqrtl         sqrt;

    alias rt.core.stdc.complex_.csqrt      sqrt;
    alias rt.core.stdc.complex_.csqrtf     sqrt;
    alias rt.core.stdc.complex_.csqrtl     sqrt;

    alias rt.core.stdc.math.erf           erf;
    alias rt.core.stdc.math.erff          erf;
    alias rt.core.stdc.math.erfl          erf;

    alias rt.core.stdc.math.erfc          erfc;
    alias rt.core.stdc.math.erfcf         erfc;
    alias rt.core.stdc.math.erfcl         erfc;

    alias rt.core.stdc.math.lgamma        lgamma;
    alias rt.core.stdc.math.lgammaf       lgamma;
    alias rt.core.stdc.math.lgammal       lgamma;

    alias rt.core.stdc.math.tgamma        tgamma;
    alias rt.core.stdc.math.tgammaf       tgamma;
    alias rt.core.stdc.math.tgammal       tgamma;

    alias rt.core.stdc.math.ceil          ceil;
    alias rt.core.stdc.math.ceilf         ceil;
    alias rt.core.stdc.math.ceill         ceil;

    alias rt.core.stdc.math.floor         floor;
    alias rt.core.stdc.math.floorf        floor;
    alias rt.core.stdc.math.floorl        floor;

    alias rt.core.stdc.math.nearbyint     nearbyint;
    alias rt.core.stdc.math.nearbyintf    nearbyint;
    alias rt.core.stdc.math.nearbyintl    nearbyint;

    alias rt.core.stdc.math.rint          rint;
    alias rt.core.stdc.math.rintf         rint;
    alias rt.core.stdc.math.rintl         rint;

    alias rt.core.stdc.math.lrint         lrint;
    alias rt.core.stdc.math.lrintf        lrint;
    alias rt.core.stdc.math.lrintl        lrint;

    alias rt.core.stdc.math.llrint        llrint;
    alias rt.core.stdc.math.llrintf       llrint;
    alias rt.core.stdc.math.llrintl       llrint;

    alias rt.core.stdc.math.round         round;
    alias rt.core.stdc.math.roundf        round;
    alias rt.core.stdc.math.roundl        round;

    alias rt.core.stdc.math.lround        lround;
    alias rt.core.stdc.math.lroundf       lround;
    alias rt.core.stdc.math.lroundl       lround;

    alias rt.core.stdc.math.llround       llround;
    alias rt.core.stdc.math.llroundf      llround;
    alias rt.core.stdc.math.llroundl      llround;

    alias rt.core.stdc.math.trunc         trunc;
    alias rt.core.stdc.math.truncf        trunc;
    alias rt.core.stdc.math.truncl        trunc;

    alias rt.core.stdc.math.fmod          fmod;
    alias rt.core.stdc.math.fmodf         fmod;
    alias rt.core.stdc.math.fmodl         fmod;

    alias rt.core.stdc.math.remainder     remainder;
    alias rt.core.stdc.math.remainderf    remainder;
    alias rt.core.stdc.math.remainderl    remainder;

    alias rt.core.stdc.math.remquo        remquo;
    alias rt.core.stdc.math.remquof       remquo;
    alias rt.core.stdc.math.remquol       remquo;

    alias rt.core.stdc.math.copysign      copysign;
    alias rt.core.stdc.math.copysignf     copysign;
    alias rt.core.stdc.math.copysignl     copysign;

//  alias rt.core.stdc.math.nan           nan;
//  alias rt.core.stdc.math.nanf          nan;
//  alias rt.core.stdc.math.nanl          nan;

    alias rt.core.stdc.math.nextafter     nextafter;
    alias rt.core.stdc.math.nextafterf    nextafter;
    alias rt.core.stdc.math.nextafterl    nextafter;

    alias rt.core.stdc.math.nexttoward    nexttoward;
    alias rt.core.stdc.math.nexttowardf   nexttoward;
    alias rt.core.stdc.math.nexttowardl   nexttoward;

    alias rt.core.stdc.math.fdim          fdim;
    alias rt.core.stdc.math.fdimf         fdim;
    alias rt.core.stdc.math.fdiml         fdim;

    alias rt.core.stdc.math.fmax          fmax;
    alias rt.core.stdc.math.fmaxf         fmax;
    alias rt.core.stdc.math.fmaxl         fmax;

    alias rt.core.stdc.math.fmin          fmin;
    alias rt.core.stdc.math.fmin          fmin;
    alias rt.core.stdc.math.fminl         fmin;

    alias rt.core.stdc.math.fma           fma;
    alias rt.core.stdc.math.fmaf          fma;
    alias rt.core.stdc.math.fmal          fma;

    alias rt.core.stdc.complex_.carg       carg;
    alias rt.core.stdc.complex_.cargf      carg;
    alias rt.core.stdc.complex_.cargl      carg;

    alias rt.core.stdc.complex_.cimag      cimag;
    alias rt.core.stdc.complex_.cimagf     cimag;
    alias rt.core.stdc.complex_.cimagl     cimag;

    alias rt.core.stdc.complex_.conj       conj;
    alias rt.core.stdc.complex_.conjf      conj;
    alias rt.core.stdc.complex_.conjl      conj;

    alias rt.core.stdc.complex_.cproj      cproj;
    alias rt.core.stdc.complex_.cprojf     cproj;
    alias rt.core.stdc.complex_.cprojl     cproj;

//  alias rt.core.stdc.complex_.creal      creal;
//  alias rt.core.stdc.complex_.crealf     creal;
//  alias rt.core.stdc.complex_.creall     creal;
}
else
{
    alias rt.core.stdc.math.acos          acos;
    alias rt.core.stdc.math.acosf         acos;
    alias rt.core.stdc.math.acosl         acos;

    alias rt.core.stdc.complex_.cacos      acos;
    alias rt.core.stdc.complex_.cacosf     acos;
    alias rt.core.stdc.complex_.cacosl     acos;

    alias rt.core.stdc.math.asin          asin;
    alias rt.core.stdc.math.asinf         asin;
    alias rt.core.stdc.math.asinl         asin;

    alias rt.core.stdc.complex_.casin      asin;
    alias rt.core.stdc.complex_.casinf     asin;
    alias rt.core.stdc.complex_.casinl     asin;

    alias rt.core.stdc.math.atan          atan;
    alias rt.core.stdc.math.atanf         atan;
    alias rt.core.stdc.math.atanl         atan;

    alias rt.core.stdc.complex_.catan      atan;
    alias rt.core.stdc.complex_.catanf     atan;
    alias rt.core.stdc.complex_.catanl     atan;

    alias rt.core.stdc.math.atan2         atan2;
    alias rt.core.stdc.math.atan2f        atan2;
    alias rt.core.stdc.math.atan2l        atan2;

    alias rt.core.stdc.math.cos           cos;
    alias rt.core.stdc.math.cosf          cos;
    alias rt.core.stdc.math.cosl          cos;

    alias rt.core.stdc.complex_.ccos       cos;
    alias rt.core.stdc.complex_.ccosf      cos;
    alias rt.core.stdc.complex_.ccosl      cos;

    alias rt.core.stdc.math.sin           sin;
    alias rt.core.stdc.math.sinf          sin;
    alias rt.core.stdc.math.sinl          sin;

    alias rt.core.stdc.complex_.csin       csin;
    alias rt.core.stdc.complex_.csinf      csin;
    alias rt.core.stdc.complex_.csinl      csin;

    alias rt.core.stdc.math.tan           tan;
    alias rt.core.stdc.math.tanf          tan;
    alias rt.core.stdc.math.tanl          tan;

    alias rt.core.stdc.complex_.ctan       tan;
    alias rt.core.stdc.complex_.ctanf      tan;
    alias rt.core.stdc.complex_.ctanl      tan;

    alias rt.core.stdc.math.acosh         acosh;
    alias rt.core.stdc.math.acoshf        acosh;
    alias rt.core.stdc.math.acoshl        acosh;

    alias rt.core.stdc.complex_.cacosh     acosh;
    alias rt.core.stdc.complex_.cacoshf    acosh;
    alias rt.core.stdc.complex_.cacoshl    acosh;

    alias rt.core.stdc.math.asinh         asinh;
    alias rt.core.stdc.math.asinhf        asinh;
    alias rt.core.stdc.math.asinhl        asinh;

    alias rt.core.stdc.complex_.casinh     asinh;
    alias rt.core.stdc.complex_.casinhf    asinh;
    alias rt.core.stdc.complex_.casinhl    asinh;

    alias rt.core.stdc.math.atanh         atanh;
    alias rt.core.stdc.math.atanhf        atanh;
    alias rt.core.stdc.math.atanhl        atanh;

    alias rt.core.stdc.complex_.catanh     atanh;
    alias rt.core.stdc.complex_.catanhf    atanh;
    alias rt.core.stdc.complex_.catanhl    atanh;

    alias rt.core.stdc.math.cosh          cosh;
    alias rt.core.stdc.math.coshf         cosh;
    alias rt.core.stdc.math.coshl         cosh;

    alias rt.core.stdc.complex_.ccosh      cosh;
    alias rt.core.stdc.complex_.ccoshf     cosh;
    alias rt.core.stdc.complex_.ccoshl     cosh;

    alias rt.core.stdc.math.sinh          sinh;
    alias rt.core.stdc.math.sinhf         sinh;
    alias rt.core.stdc.math.sinhl         sinh;

    alias rt.core.stdc.complex_.csinh      sinh;
    alias rt.core.stdc.complex_.csinhf     sinh;
    alias rt.core.stdc.complex_.csinhl     sinh;

    alias rt.core.stdc.math.tanh          tanh;
    alias rt.core.stdc.math.tanhf         tanh;
    alias rt.core.stdc.math.tanhl         tanh;

    alias rt.core.stdc.complex_.ctanh      tanh;
    alias rt.core.stdc.complex_.ctanhf     tanh;
    alias rt.core.stdc.complex_.ctanhl     tanh;

    alias rt.core.stdc.math.exp           exp;
    alias rt.core.stdc.math.expf          exp;
    alias rt.core.stdc.math.expl          exp;

    alias rt.core.stdc.complex_.cexp       exp;
    alias rt.core.stdc.complex_.cexpf      exp;
    alias rt.core.stdc.complex_.cexpl      exp;

    alias rt.core.stdc.math.exp2          exp2;
    alias rt.core.stdc.math.exp2f         exp2;
    alias rt.core.stdc.math.exp2l         exp2;

    alias rt.core.stdc.math.expm1         expm1;
    alias rt.core.stdc.math.expm1f        expm1;
    alias rt.core.stdc.math.expm1l        expm1;

    alias rt.core.stdc.math.frexp         frexp;
    alias rt.core.stdc.math.frexpf        frexp;
    alias rt.core.stdc.math.frexpl        frexp;

    alias rt.core.stdc.math.ilogb         ilogb;
    alias rt.core.stdc.math.ilogbf        ilogb;
    alias rt.core.stdc.math.ilogbl        ilogb;

    alias rt.core.stdc.math.ldexp         ldexp;
    alias rt.core.stdc.math.ldexpf        ldexp;
    alias rt.core.stdc.math.ldexpl        ldexp;

    alias rt.core.stdc.math.log           log;
    alias rt.core.stdc.math.logf          log;
    alias rt.core.stdc.math.logl          log;

    alias rt.core.stdc.complex_.clog       log;
    alias rt.core.stdc.complex_.clogf      log;
    alias rt.core.stdc.complex_.clogl      log;

    alias rt.core.stdc.math.log10         log10;
    alias rt.core.stdc.math.log10f        log10;
    alias rt.core.stdc.math.log10l        log10;

    alias rt.core.stdc.math.log1p         log1p;
    alias rt.core.stdc.math.log1pf        log1p;
    alias rt.core.stdc.math.log1pl        log1p;

    alias rt.core.stdc.math.log2          log1p;
    alias rt.core.stdc.math.log2f         log1p;
    alias rt.core.stdc.math.log2l         log1p;

    alias rt.core.stdc.math.logb          log1p;
    alias rt.core.stdc.math.logbf         log1p;
    alias rt.core.stdc.math.logbl         log1p;

    alias rt.core.stdc.math.modf          modf;
    alias rt.core.stdc.math.modff         modf;
    alias rt.core.stdc.math.modfl         modf;

    alias rt.core.stdc.math.scalbn        scalbn;
    alias rt.core.stdc.math.scalbnf       scalbn;
    alias rt.core.stdc.math.scalbnl       scalbn;

    alias rt.core.stdc.math.scalbln       scalbln;
    alias rt.core.stdc.math.scalblnf      scalbln;
    alias rt.core.stdc.math.scalblnl      scalbln;

    alias rt.core.stdc.math.cbrt          cbrt;
    alias rt.core.stdc.math.cbrtf         cbrt;
    alias rt.core.stdc.math.cbrtl         cbrt;

    alias rt.core.stdc.math.fabs          fabs;
    alias rt.core.stdc.math.fabsf         fabs;
    alias rt.core.stdc.math.fabsl         fabs;

    alias rt.core.stdc.complex_.cabs       fabs;
    alias rt.core.stdc.complex_.cabsf      fabs;
    alias rt.core.stdc.complex_.cabsl      fabs;

    alias rt.core.stdc.math.hypot         hypot;
    alias rt.core.stdc.math.hypotf        hypot;
    alias rt.core.stdc.math.hypotl        hypot;

    alias rt.core.stdc.math.pow           pow;
    alias rt.core.stdc.math.powf          pow;
    alias rt.core.stdc.math.powl          pow;

    alias rt.core.stdc.complex_.cpow       pow;
    alias rt.core.stdc.complex_.cpowf      pow;
    alias rt.core.stdc.complex_.cpowl      pow;

    alias rt.core.stdc.math.sqrt          sqrt;
    alias rt.core.stdc.math.sqrtf         sqrt;
    alias rt.core.stdc.math.sqrtl         sqrt;

    alias rt.core.stdc.complex_.csqrt      sqrt;
    alias rt.core.stdc.complex_.csqrtf     sqrt;
    alias rt.core.stdc.complex_.csqrtl     sqrt;

    alias rt.core.stdc.math.erf           erf;
    alias rt.core.stdc.math.erff          erf;
    alias rt.core.stdc.math.erfl          erf;

    alias rt.core.stdc.math.erfc          erfc;
    alias rt.core.stdc.math.erfcf         erfc;
    alias rt.core.stdc.math.erfcl         erfc;

    alias rt.core.stdc.math.lgamma        lgamma;
    alias rt.core.stdc.math.lgammaf       lgamma;
    alias rt.core.stdc.math.lgammal       lgamma;

    alias rt.core.stdc.math.tgamma        tgamma;
    alias rt.core.stdc.math.tgammaf       tgamma;
    alias rt.core.stdc.math.tgammal       tgamma;

    alias rt.core.stdc.math.ceil          ceil;
    alias rt.core.stdc.math.ceilf         ceil;
    alias rt.core.stdc.math.ceill         ceil;

    alias rt.core.stdc.math.floor         floor;
    alias rt.core.stdc.math.floorf        floor;
    alias rt.core.stdc.math.floorl        floor;

    alias rt.core.stdc.math.nearbyint     nearbyint;
    alias rt.core.stdc.math.nearbyintf    nearbyint;
    alias rt.core.stdc.math.nearbyintl    nearbyint;

    alias rt.core.stdc.math.rint          rint;
    alias rt.core.stdc.math.rintf         rint;
    alias rt.core.stdc.math.rintl         rint;

    alias rt.core.stdc.math.lrint         lrint;
    alias rt.core.stdc.math.lrintf        lrint;
    alias rt.core.stdc.math.lrintl        lrint;

    alias rt.core.stdc.math.llrint        llrint;
    alias rt.core.stdc.math.llrintf       llrint;
    alias rt.core.stdc.math.llrintl       llrint;

    alias rt.core.stdc.math.round         round;
    alias rt.core.stdc.math.roundf        round;
    alias rt.core.stdc.math.roundl        round;

    alias rt.core.stdc.math.lround        lround;
    alias rt.core.stdc.math.lroundf       lround;
    alias rt.core.stdc.math.lroundl       lround;

    alias rt.core.stdc.math.llround       llround;
    alias rt.core.stdc.math.llroundf      llround;
    alias rt.core.stdc.math.llroundl      llround;

    alias rt.core.stdc.math.trunc         trunc;
    alias rt.core.stdc.math.truncf        trunc;
    alias rt.core.stdc.math.truncl        trunc;

    alias rt.core.stdc.math.fmod          fmod;
    alias rt.core.stdc.math.fmodf         fmod;
    alias rt.core.stdc.math.fmodl         fmod;

    alias rt.core.stdc.math.remainder     remainder;
    alias rt.core.stdc.math.remainderf    remainder;
    alias rt.core.stdc.math.remainderl    remainder;

    alias rt.core.stdc.math.remquo        remquo;
    alias rt.core.stdc.math.remquof       remquo;
    alias rt.core.stdc.math.remquol       remquo;

    alias rt.core.stdc.math.copysign      copysign;
    alias rt.core.stdc.math.copysignf     copysign;
    alias rt.core.stdc.math.copysignl     copysign;

    alias rt.core.stdc.math.nan           nan;
    alias rt.core.stdc.math.nanf          nan;
    alias rt.core.stdc.math.nanl          nan;

    alias rt.core.stdc.math.nextafter     nextafter;
    alias rt.core.stdc.math.nextafterf    nextafter;
    alias rt.core.stdc.math.nextafterl    nextafter;

    alias rt.core.stdc.math.nexttoward    nexttoward;
    alias rt.core.stdc.math.nexttowardf   nexttoward;
    alias rt.core.stdc.math.nexttowardl   nexttoward;

    alias rt.core.stdc.math.fdim          fdim;
    alias rt.core.stdc.math.fdimf         fdim;
    alias rt.core.stdc.math.fdiml         fdim;

    alias rt.core.stdc.math.fmax          fmax;
    alias rt.core.stdc.math.fmaxf         fmax;
    alias rt.core.stdc.math.fmaxl         fmax;

    alias rt.core.stdc.math.fmin          fmin;
    alias rt.core.stdc.math.fmin          fmin;
    alias rt.core.stdc.math.fminl         fmin;

    alias rt.core.stdc.math.fma           fma;
    alias rt.core.stdc.math.fmaf          fma;
    alias rt.core.stdc.math.fmal          fma;

    alias rt.core.stdc.complex_.carg       carg;
    alias rt.core.stdc.complex_.cargf      carg;
    alias rt.core.stdc.complex_.cargl      carg;

    alias rt.core.stdc.complex_.cimag      cimag;
    alias rt.core.stdc.complex_.cimagf     cimag;
    alias rt.core.stdc.complex_.cimagl     cimag;

    alias rt.core.stdc.complex_.conj       conj;
    alias rt.core.stdc.complex_.conjf      conj;
    alias rt.core.stdc.complex_.conjl      conj;

    alias rt.core.stdc.complex_.cproj      cproj;
    alias rt.core.stdc.complex_.cprojf     cproj;
    alias rt.core.stdc.complex_.cprojl     cproj;

//  alias rt.core.stdc.complex_.creal      creal;
//  alias rt.core.stdc.complex_.crealf     creal;
//  alias rt.core.stdc.complex_.creall     creal;
}
