module gtkD.gtkc.all;

public import gtkd = gtkD.gtk.Version;

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gtkc");
        } else version (DigitalMars) {
            pragma(link, "DD-gtkc");
        } else {
            pragma(link, "DO-gtkc");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gtkc");
        } else version (DigitalMars) {
            pragma(link, "DD-gtkc");
        } else {
            pragma(link, "DO-gtkc");
        }
    }
}
