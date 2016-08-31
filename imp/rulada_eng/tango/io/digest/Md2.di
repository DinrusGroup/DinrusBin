module tango.io.digest.Md2;

public  import tango.util.digest.Md2;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
