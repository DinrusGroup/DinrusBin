module tango.core.sync.Barrier;
pragma(lib, "rulada.lib");
public import rt.core.sync.barrier;

version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
