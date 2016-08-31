module tango.io.digest.Digest;

public import tango.util.digest.Digest;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
