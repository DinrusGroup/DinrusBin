module tango.stdc.ctype;
pragma(lib, "rulada.lib");
public import rt.core.stdc.ctype;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
