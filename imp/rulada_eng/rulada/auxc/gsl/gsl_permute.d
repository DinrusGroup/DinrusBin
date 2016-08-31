/* Converted to D from gsl_permute.h by htod
 * and edited by daniel truemper <truemped.dsource <with> hence22.org>
 */
module auxc.gsl.gsl_permute;

public import auxc.gsl.gsl_permute_complex_long_double;

public import auxc.gsl.gsl_permute_complex_double;

public import auxc.gsl.gsl_permute_complex_float;

public import auxc.gsl.gsl_permute_long_double;

public import auxc.gsl.gsl_permute_double;

public import auxc.gsl.gsl_permute_float;

public import auxc.gsl.gsl_permute_ulong;

public import auxc.gsl.gsl_permute_long;

public import auxc.gsl.gsl_permute_uint;

public import auxc.gsl.gsl_permute_int;

public import auxc.gsl.gsl_permute_ushort;

public import auxc.gsl.gsl_permute_short;

public import auxc.gsl.gsl_permute_uchar;

public import auxc.gsl.gsl_permute_char;


version (build) {
    debug {
        pragma(link, "auxc");
    } else {
        pragma(link, "auxc");
    }
}
