module os.solaris;
version (Solaris) { public import rt.core.os.solaris;}
 else { static assert(0); }
