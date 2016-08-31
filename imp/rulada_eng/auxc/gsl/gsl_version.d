/* Converted to D from gsl_version.h by htod
 * and edited by daniel truemper <truemped.dsource <with> hence22.org>
 */
module auxc.gsl.gsl_version;

public import auxc.gsl.gsl_types;

extern (C):
extern char *gsl_version;


version (build) {
    debug {
        pragma(link, "auxc");
    } else {
        pragma(link, "auxc");
    }
}
