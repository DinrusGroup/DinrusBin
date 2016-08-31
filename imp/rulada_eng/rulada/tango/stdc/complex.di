module tango.stdc.complex;
pragma(lib, "rulada.lib");
public import rt.core.stdc.complex_;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
