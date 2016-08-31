module tango.io.digest.Sha01;

public import tango.util.digest.Sha01;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
