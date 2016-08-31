/* Converted to D from gsl_matrix.h by htod
 * and edited by daniel truemper <truemped.dsource <with> hence22.org>
 */
module auxc.gsl.gsl_matrix;

public import auxc.gsl.gsl_matrix_complex_long_double;

public import auxc.gsl.gsl_matrix_complex_double;

public import auxc.gsl.gsl_matrix_complex_float;

public import auxc.gsl.gsl_matrix_long_double;

public import auxc.gsl.gsl_matrix_double;

public import auxc.gsl.gsl_matrix_float;

public import auxc.gsl.gsl_matrix_ulong;

public import auxc.gsl.gsl_matrix_long;

public import auxc.gsl.gsl_matrix_uint;

public import auxc.gsl.gsl_matrix_int;

public import auxc.gsl.gsl_matrix_ushort;

public import auxc.gsl.gsl_matrix_short;

public import auxc.gsl.gsl_matrix_uchar;

public import auxc.gsl.gsl_matrix_char;


version (build) {
    debug {
        pragma(link, "auxc");
    } else {
        pragma(link, "auxc");
    }
}
