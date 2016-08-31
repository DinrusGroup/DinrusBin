module tango.stdc.stdlib;
pragma(lib, "rulada.lib");
public import rt.core.stdc.stdlib;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
