module tango.io.digest.Sha512;

public import tango.util.digest.Sha512;

version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
