/* Converted to D from gsl_sort_vector.h by htod
 * and edited by daniel truemper <truemped.dsource <with> hence22.org>
 */
module auxc.gsl.gsl_sort_vector;

public import auxc.gsl.gsl_sort_vector_long_double;

public import auxc.gsl.gsl_sort_vector_double;

public import auxc.gsl.gsl_sort_vector_float;

public import auxc.gsl.gsl_sort_vector_ulong;

public import auxc.gsl.gsl_sort_vector_long;

public import auxc.gsl.gsl_sort_vector_uint;

public import auxc.gsl.gsl_sort_vector_int;

public import auxc.gsl.gsl_sort_vector_ushort;

public import auxc.gsl.gsl_sort_vector_short;

public import auxc.gsl.gsl_sort_vector_uchar;

public import auxc.gsl.gsl_sort_vector_char;


version (build) {
    debug {
        pragma(link, "auxc");
    } else {
        pragma(link, "auxc");
    }
}
