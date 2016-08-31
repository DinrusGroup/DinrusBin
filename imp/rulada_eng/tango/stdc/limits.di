module tango.stdc.limits;
pragma(lib, "rulada.lib");
public import rt.core.stdc.limits;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
