module tango.io.digest.Sha1;

public import tango.util.digest.Sha1;

version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
