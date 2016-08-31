module tango.stdc.stddef;
pragma(lib, "rulada.lib");
public import rt.core.stdc.stddef;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
