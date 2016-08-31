module tango.io.digest.Md5;

public  import tango.util.digest.Md5;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
