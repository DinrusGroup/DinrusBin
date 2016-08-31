/* Converted to D from gsl_statistics.h by htod
 * and edited by daniel truemper <truemped.dsource <with> hence22.org>
 */
module auxc.gsl.gsl_statistics;

public import auxc.gsl.gsl_statistics_long_double;

public import auxc.gsl.gsl_statistics_double;

public import auxc.gsl.gsl_statistics_float;

public import auxc.gsl.gsl_statistics_ulong;

public import auxc.gsl.gsl_statistics_long;

public import auxc.gsl.gsl_statistics_uint;

public import auxc.gsl.gsl_statistics_int;

public import auxc.gsl.gsl_statistics_ushort;

public import auxc.gsl.gsl_statistics_short;

public import auxc.gsl.gsl_statistics_uchar;

public import auxc.gsl.gsl_statistics_char;


version (build) {
    debug {
        pragma(link, "auxc");
    } else {
        pragma(link, "auxc");
    }
}
