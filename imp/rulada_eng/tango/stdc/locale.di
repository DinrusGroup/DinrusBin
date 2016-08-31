module tango.stdc.locale;
pragma(lib, "rulada.lib");
public import rt.core.stdc.locale;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
