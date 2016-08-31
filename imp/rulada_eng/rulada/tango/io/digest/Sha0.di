module tango.io.digest.Sha0;

public import tango.util.digest.Sha0;

version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
