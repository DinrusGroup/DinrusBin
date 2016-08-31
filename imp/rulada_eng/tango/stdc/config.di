module tango.stdc.config;
pragma(lib, "rulada.lib");
public import rt.core.stdc.config;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
