module tango.io.digest.Crc32;

public import tango.util.digest.Crc32;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
