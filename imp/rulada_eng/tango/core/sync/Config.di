module tango.core.sync.Config;
pragma(lib, "rulada.lib");
public import rt.core.sync.config;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
