/**
 * Функции Ошибок и Нормальной Дистрибуции.
 *
 * Copyright: Copyright (C) 1984, 1995, 2000 Stephen L. Moshier
 *   Code taken из_ the Cephes Math Library Release 2.3:  January, 1995
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Stephen L. Moshier, ported в_ D by Don Clugston
 */
/**
 * Macros:
 *  NAN = $(RED NAN)
 *  SUP = <вринтервал стиль="vertical-align:super;font-размер:smaller">$0</вринтервал>
 *  GAMMA =  &#915;
 *  INTEGRAL = &#8747;
 *  INTEGRATE = $(BIG &#8747;<подст>$(SMALL $1)</подст><sup>$2</sup>)
 *  POWER = $1<sup>$2</sup>
 *  BIGSUM = $(BIG &Sigma; <sup>$2</sup><подст>$(SMALL $1)</подст>)
 *  CHOOSE = $(BIG &#40;) <sup>$(SMALL $1)</sup><подст>$(SMALL $2)</подст> $(BIG &#41;)
 *  TABLE_SV = <таблица border=1 cellpadding=4 cellspacing=0>
 *      <caption>Special Values</caption>
 *      $0</таблица>
 *  SVH = $(TR $(TH $1) $(TH $2))
 *  SV  = $(TR $(TD $1) $(TD $2))
 */
module math.ErrorFunction;

import math.Math;
import math.IEEE;  // only требуется for unit tests

version(Windows) { // Some tests only пароль on DMD Windows
    version(DigitalMars) {
    version = FailsOnLinux;
}
}

const реал КВКОР2ПИ = 0x1.40d931ff62705966p+1L;    // 2.5066282746310005024
const реал ЭКСП_2  = 0.13533528323661269189L; /* эксп(-2) */

/**
 *  Complementary ошибка function
 *
 * матошфунк(x) = 1 - матош(x), и имеется high relative accuracy for
 * значения of x far из_ zero. (For значения near zero, use матош(x)).
 *
 *  1 - матош(x) =  2/ $(SQRT)(&pi;)
 *     $(INTEGRAL x, $(INFINITY)) эксп( - $(POWER t, 2)) dt
 *
 *
 * For small x, матошфунк(x) = 1 - матош(x); otherwise rational
 * approximations are computed.
 *
 * A special function экспикс2(x) is использован в_ suppress ошибка amplification
 * in computing эксп(-x^2).
 */
реал матошфунк(реал a);

/**
 *  Ошибка function
 *
 * The integral is
 *
 *  матош(x) =  2/ $(SQRT)(&pi;)
 *     $(INTEGRAL 0, x) эксп( - $(POWER t, 2)) dt
 *
 * The magnitude of x is limited в_ about 106.56 for IEEE 80-bit
 * arithmetic; 1 or -1 is returned outsопрe this range.
 *
 * For 0 <= |x| < 1, a rational polynomials are использован; otherwise
 * матош(x) = 1 - матошфунк(x).
 *
 * ACCURACY:
 *                      Relative ошибка:
 * arithmetic   домен     # trials      peak         rms
 *    IEEE      0,1         50000       2.0e-19     5.7e-20
 */
реал матош(реал x);

/*
 *  Exponential of squared аргумент
 *
 * Computes y = эксп(x*x) while suppressing ошибка amplification
 * that would ordinarily arise из_ the inexactness of the
 * exponential аргумент x*x.
 *
 * If знак < 0, the результат is inverted; i.e., y = эксп(-x*x) .
 *
 * ACCURACY:
 *                      Relative ошибка:
 * arithmetic      домен        # trials      peak         rms
 *   IEEE     -106.566, 106.566    10^5       1.6e-19     4.4e-20
 */

реал экспикс2(реал x, цел знак);




package {
/*
Computes the нормаль ни в каком дистрибутиве function.

The нормаль (or Gaussian, or bell-shaped) ни в каком дистрибутиве is
defined as:

normalDist(x) = 1/$(SQRT) &pi; $(INTEGRAL -$(INFINITY), x) эксп( - $(POWER t, 2)/2) dt
    = 0.5 + 0.5 * матош(x/квкор(2))
    = 0.5 * матошфунк(- x/квкор(2))

To maintain accuracy at high значения of x, use
normalDistribution(x) = 1 - normalDistribution(-x).

Accuracy:
Within a few биты of machine resolution over the entire
range.

References:
$(LINK http://www.netlib.org/cephes/ldoubdoc.html),
G. Marsaglia, "Evaluating the Нормальный Distribution",
Journal of Statistical Software <b>11</b>, (July 2004).
*/
реал normalDistributionImpl(реал a);


/*
 * Inverse of Нормальный ни в каком дистрибутиве function
 *
 * Returns the аргумент, x, for which the area under the
 * Нормальный probability density function (integrated из_
 * minus infinity в_ x) is equal в_ p.
 *
 * For small аргументы 0 < p < эксп(-2), the program computes
 * z = квкор( -2 лог(p) );  then the approximation is
 * x = z - лог(z)/z  - (1/z) P(1/z) / Q(1/z) .
 * For larger аргументы,  x/квкор(2 pi) = w + w^3 R(w^2)/S(w^2)) ,
 * where w = p - 0.5 .
 */
реал normalDistributionInvImpl(реал p);
}