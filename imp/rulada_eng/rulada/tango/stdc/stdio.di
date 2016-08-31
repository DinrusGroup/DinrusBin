module tango.stdc.stdio;
pragma(lib, "rulada.lib");
public import rt.core.stdc.stdio;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
