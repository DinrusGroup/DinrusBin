module os.freebsd;
version (FreeBSD) {
public import rt.core.os.freebsd; 
} else { static assert(0); }



