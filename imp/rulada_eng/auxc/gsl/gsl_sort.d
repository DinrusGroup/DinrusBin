/* Converted to D from gsl_sort.h by htod
 * and edited by daniel truemper <truemped.dsource <with> hence22.org>
 */
module auxc.gsl.gsl_sort;

public import auxc.gsl.gsl_sort_long_double;

public import auxc.gsl.gsl_sort_double;

public import auxc.gsl.gsl_sort_float;

public import auxc.gsl.gsl_sort_ulong;

public import auxc.gsl.gsl_sort_long;

public import auxc.gsl.gsl_sort_uint;

public import auxc.gsl.gsl_sort_int;

public import auxc.gsl.gsl_sort_ushort;

public import auxc.gsl.gsl_sort_short;

public import auxc.gsl.gsl_sort_uchar;

public import auxc.gsl.gsl_sort_char;


version (build) {
    debug {
        pragma(link, "auxc");
    } else {
        pragma(link, "auxc");
    }
}
