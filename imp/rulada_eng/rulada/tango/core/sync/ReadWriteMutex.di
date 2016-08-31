module tango.core.sync.ReadWriteMutex;
pragma(lib, "rulada.lib");
public import rt.core.sync.rwmutex;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
