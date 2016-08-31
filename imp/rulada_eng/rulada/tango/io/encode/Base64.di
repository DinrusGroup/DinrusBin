module tango.io.encode.Base64;
public import tango.util.encode.Base64;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
