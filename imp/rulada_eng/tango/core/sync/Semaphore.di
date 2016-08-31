module tango.core.sync.Semaphore;
pragma(lib, "rulada.lib");
public import rt.core.sync.semaphore;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
