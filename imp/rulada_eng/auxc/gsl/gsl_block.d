/* Converted to D from gsl_block.h by htod
 * and edited by daniel truemper <truemped.dsource <with> hence22.org>
 */
module auxc.gsl.gsl_block;

public import auxc.gsl.gsl_block_complex_long_double;

public import auxc.gsl.gsl_block_complex_double;

public import auxc.gsl.gsl_block_complex_float;

public import auxc.gsl.gsl_block_long_double;

public import auxc.gsl.gsl_block_double;

public import auxc.gsl.gsl_block_float;

public import auxc.gsl.gsl_block_ulong;

public import auxc.gsl.gsl_block_long;

public import auxc.gsl.gsl_block_uint;

public import auxc.gsl.gsl_block_int;

public import auxc.gsl.gsl_block_ushort;

public import auxc.gsl.gsl_block_short;

public import auxc.gsl.gsl_block_uchar;

public import auxc.gsl.gsl_block_char;


version (build) {
    debug {
        pragma(link, "auxc");
    } else {
        pragma(link, "auxc");
    }
}
