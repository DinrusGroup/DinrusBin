module tango.io.digest.MerkleDamgard;

public  import tango.util.digest.MerkleDamgard;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
