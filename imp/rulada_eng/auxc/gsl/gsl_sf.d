/* Converted to D from gsl_sf.h by htod
 * and edited by daniel truemper <truemped.dsource <with> hence22.org>
 */
module auxc.gsl.gsl_sf;
/* Author:  G. Jungman */

public import auxc.gsl.gsl_sf_result;

public import auxc.gsl.gsl_sf_airy;

public import auxc.gsl.gsl_sf_bessel;

public import auxc.gsl.gsl_sf_clausen;

public import auxc.gsl.gsl_sf_coupling;

public import auxc.gsl.gsl_sf_coulomb;

public import auxc.gsl.gsl_sf_dawson;

public import auxc.gsl.gsl_sf_debye;

public import auxc.gsl.gsl_sf_dilog;

public import auxc.gsl.gsl_sf_elementary;

public import auxc.gsl.gsl_sf_ellint;

public import auxc.gsl.gsl_sf_elljac;

public import auxc.gsl.gsl_sf_erf;

public import auxc.gsl.gsl_sf_exp;

public import auxc.gsl.gsl_sf_expint;

public import auxc.gsl.gsl_sf_fermi_dirac;

public import auxc.gsl.gsl_sf_gamma;

public import auxc.gsl.gsl_sf_gegenbauer;

public import auxc.gsl.gsl_sf_hyperg;

public import auxc.gsl.gsl_sf_laguerre;

public import auxc.gsl.gsl_sf_lambert;

public import auxc.gsl.gsl_sf_legendre;

public import auxc.gsl.gsl_sf_log;

public import auxc.gsl.gsl_sf_pow_int;

public import auxc.gsl.gsl_sf_psi;

public import auxc.gsl.gsl_sf_synchrotron;

public import auxc.gsl.gsl_sf_transport;

public import auxc.gsl.gsl_sf_trig;

public import auxc.gsl.gsl_sf_zeta;


version (build) {
    debug {
        pragma(link, "auxc");
    } else {
        pragma(link, "auxc");
    }
}
