module tango.stdc.string;
pragma(lib, "rulada.lib");
public import rt.core.stdc.string;
public import rt.core.stdc.wchar_;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
