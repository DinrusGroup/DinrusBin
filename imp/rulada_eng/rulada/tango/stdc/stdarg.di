module tango.stdc.stdarg;
pragma(lib, "rulada.lib");
public import rt.core.stdc.stdarg;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
