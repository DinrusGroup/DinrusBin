// Written in the D programming language

/***********************
 * Scheduled for deprecation. Use $(LINK2
 * std_bitmanip.html,std.bitmanip) instead.
 *
 * Macros:
 *	WIKI = StdBitarray
 */

module std2.bitarray;
//version(Tango) import std.compat;
public import std2.bitmanip;

pragma(msg, "You may want to import std.bitmanip instead of std.bitarray");

version (build) {
    debug {
        pragma(link, "auxd");
    } else {
        pragma(link, "auxd");
    }
}
