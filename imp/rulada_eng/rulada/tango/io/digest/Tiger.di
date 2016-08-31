module tango.io.digest.Tiger;

public import tango.util.digest.Tiger;

version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
