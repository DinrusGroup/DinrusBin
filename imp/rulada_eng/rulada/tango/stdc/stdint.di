module tango.stdc.stdint;
pragma(lib, "rulada.lib");
public import rt.core.stdc.stdint;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
