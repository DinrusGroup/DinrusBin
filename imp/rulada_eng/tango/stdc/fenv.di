module tango.stdc.fenv;
pragma(lib, "rulada.lib");
public import rt.core.stdc.fenv;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
