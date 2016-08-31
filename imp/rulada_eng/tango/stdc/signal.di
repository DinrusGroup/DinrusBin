module tango.stdc.signal;
pragma(lib, "rulada.lib");
public import rt.core.stdc.signal;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
