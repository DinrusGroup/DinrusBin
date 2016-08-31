module tango.io.digest.Sha256;

public import tango.util.digest.Sha256;

version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
