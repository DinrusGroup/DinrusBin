module tango.stdc.math;
pragma(lib, "rulada.lib");
public import rt.core.stdc.math;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
