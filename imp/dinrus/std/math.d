module std.math;

private import stdrus;

const real E =          2.7182818284590452354L;  /** e */ // 3.32193 fldl2t 0x1.5BF0A8B1_45769535_5FF5p+1L
const real LOG2T =      0x1.a934f0979a3715fcp+1; /** $(SUB log, 2)10 */ // 1.4427 fldl2e
const real LOG2E =      0x1.71547652b82fe178p+0; /** $(SUB log, 2)e */ // 0.30103 fldlg2
const real LOG2 =       0x1.34413509f79fef32p-2; /** $(SUB log, 10)2 */
const real LOG10E =     0.43429448190325182765;  /** $(SUB log, 10)e */
const real LN2 =        0x1.62e42fefa39ef358p-1; /** ln 2 */  // 0.693147 fldln2
const real LN10 =       2.30258509299404568402;  /** ln 10 */
const real PI =         0x1.921fb54442d1846ap+1; /** $(_PI) */ // 3.14159 fldpi
const real PI_2 =       1.57079632679489661923;  /** $(PI) / 2 */
const real PI_4 =       0.78539816339744830962;  /** $(PI) / 4 */
const real M_1_PI =     0.31830988618379067154;  /** 1 / $(PI) */
const real M_2_PI =     0.63661977236758134308;  /** 2 / $(PI) */
const real M_2_SQRTPI = 1.12837916709551257390;  /** 2 / $(SQRT)$(PI) */
const real SQRT2 =      1.41421356237309504880;  /** $(SQRT)2 */
const real SQRT1_2 =    0.70710678118654752440;  /** $(SQRT)$(HALF) */

/*
        Octal versions:
        PI/64800        0.00001 45530 36176 77347 02143 15351 61441 26767
        PI/180          0.01073 72152 11224 72344 25603 54276 63351 22056
        PI/8            0.31103 75524 21026 43021 51423 06305 05600 67016
        SQRT(1/PI)      0.44067 27240 41233 33210 65616 51051 77327 77303
        2/PI            0.50574 60333 44710 40522 47741 16537 21752 32335
        PI/4            0.62207 73250 42055 06043 23046 14612 13401 56034
        SQRT(2/PI)      0.63041 05147 52066 24106 41762 63612 00272 56161

        PI              3.11037 55242 10264 30215 14230 63050 56006 70163
        LOG2            0.23210 11520 47674 77674 61076 11263 26013 37111
 */

alias stdrus.син sin;
alias stdrus.абс abs;
alias stdrus.квкор sqrt;
alias stdrus.кос cos;
alias stdrus.конъюнк conj;
alias stdrus.степень pow;
alias stdrus.тан tan;
alias stdrus.акос acos;
alias stdrus.асин asin;
alias stdrus.атан atan;
alias stdrus.атан2 atan2;
alias stdrus.гкос cosh;
alias stdrus.гсин sinh;
alias stdrus.гтан tanh;
alias stdrus.гакос acosh;
alias stdrus.гасин asinh;
alias stdrus.гатан atanh;
alias stdrus.округливдол rndtol;
alias stdrus.округливближдол rndtonl;
alias stdrus.эксп exp;
alias stdrus.экспм1 expm1;
alias stdrus.эксп2 exp2;
alias stdrus.экспи expi;
alias stdrus.прэксп frexp;
alias stdrus.илогб ilogb;
alias stdrus.лдэксп ldexp;
alias stdrus.лог log;
alias stdrus.лог10 log10;
alias stdrus.лог1п log1p;
alias stdrus.лог2 log2;
alias stdrus.логб logb;
alias stdrus.модф modf;
alias stdrus.скалбн scalbn;
alias stdrus.кубкор cbrt;
alias stdrus.фабс fabs;
alias stdrus.гипот hypot;
alias stdrus.фцош erf;
alias stdrus.лгамма lgamma;
alias stdrus.тгамма tgamma;
alias stdrus.потолок ceil;
alias stdrus.пол floor;
alias stdrus.ближцел nearbyint;
alias stdrus.окрвреал rint;
alias stdrus.окрвдол lrint;
alias stdrus.округли round;
alias stdrus.докругли lround;
alias stdrus.упрости trunc;
alias stdrus.остаток remainder;
alias stdrus.нч_ли isnan;
alias stdrus.конечен_ли isfinite;
alias stdrus.субнорм_ли issubnormal;
alias stdrus.беск_ли isinf;
alias stdrus.идентичен_ли isIdentical;
alias stdrus.битзнака signbit;
alias stdrus.копируйзнак copysign;
alias stdrus.нч nan;
alias stdrus.следщБольш nextUp;
alias stdrus.следщМеньш nextUp;
alias stdrus.следщза nextafter;
alias stdrus.пдельта fdim;
alias stdrus.пбольш_из fmax;
alias stdrus.пменьш_из fmin;
alias stdrus.степень pow;
