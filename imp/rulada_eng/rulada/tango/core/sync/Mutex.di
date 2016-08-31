module tango.core.sync.Mutex;
pragma(lib, "rulada.lib");
public import rt.core.sync.mutex;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
