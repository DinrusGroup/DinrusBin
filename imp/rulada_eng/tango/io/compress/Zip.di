module tango.io.compress.Zip;

public import tango.util.compress.Zip;

version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
