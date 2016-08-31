module tango.core.sync.Atomic;
pragma(lib, "rulada.lib");
public import rt.core.sync.atomic;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
