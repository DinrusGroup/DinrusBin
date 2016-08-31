/**
 * D header file for C99.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License:   <a href="http://www.boost.org/LICENSE_1_0.txt>Boost License 1.0</a>.
 * Authors:   Sean Kelly
 * Standards: ISO/IEC 9899:1999 (E)
 *
 *          Copyright Sean Kelly 2005 - 2009.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module rt.core.stdc.float_;

extern  (C):

const FLT_ROUNDS			= 1;
const FLT_EVAL_METHOD	= 2;
const FLT_RADIX			= 2;

const DECIMAL_DIG		= real.dig;
const FLT_DIG			= float.dig;
const DBL_DIG			= double.dig;
const LDBL_DIG			= real.dig;

const FLT_MANT_DIG		= float.mant_dig;
const DBL_MANT_DIG		= double.mant_dig;
const LDBL_MANT_DIG		= real.mant_dig;

const FLT_MIN			= float.min;
const DBL_MIN			= double.min;
const LDBL_MIN			= real.min;

const FLT_MAX			= float.max;
const DBL_MAX			= double.max;
const LDBL_MAX			= real.max;

const FLT_EPSILON		= float.epsilon;
const DBL_EPSILON		= double.epsilon;
const LDBL_EPSILON		= real.epsilon;

const FLT_MIN_EXP		= float.min_exp;
const DBL_MIN_EXP		= double.min_exp;
const LDBL_MIN_EXP		= real.min_exp;

const FLT_MAX_EXP		= float.max_exp;
const DBL_MAX_EXP		= double.max_exp;
const LDBL_MAX_EXP		= real.max_exp;

const FLT_MIN_10_EXP		= float.min_10_exp;
const DBL_MIN_10_EXP		= double.min_10_exp;
const LDBL_MIN_10_EXP	= real.min_10_exp;

const FLT_MAX_10_EXP		= float.max_10_exp;
const DBL_MAX_10_EXP		= double.max_10_exp;
const LDBL_MAX_10_EXP	= real.max_10_exp;
