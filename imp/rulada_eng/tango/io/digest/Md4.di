module tango.io.digest.Md4;

public  import tango.util.digest.Md4;

version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
