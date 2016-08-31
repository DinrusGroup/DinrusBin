module tango.core.sync.Condition;
pragma(lib, "rulada.lib");
public import rt.core.sync.condition;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
