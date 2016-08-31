module std2.typetuple;
public import std.typetuple;

version (build) {
    debug {
        pragma(link, "auxd");
    } else {
        pragma(link, "auxd");
    }
}
