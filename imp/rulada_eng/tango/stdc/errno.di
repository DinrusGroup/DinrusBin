module tango.stdc.errno;
pragma(lib, "rulada.lib");
public import rt.core.stdc.errno_;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
