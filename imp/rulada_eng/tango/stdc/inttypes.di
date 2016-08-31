module tango.stdc.inttypes;
pragma(lib, "rulada.lib");
public import rt.core.stdc.inttypes;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
