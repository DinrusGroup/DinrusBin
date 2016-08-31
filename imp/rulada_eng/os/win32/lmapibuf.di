/***********************************************************************\
*                              lmapibuf.d                               *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module os.win32.lmapibuf;
pragma(lib, "netapi32.lib");

private import os.win32.lmcons, os.win32.windef;

extern (Windows) {
	NET_API_STATUS NetApiBufferAllocate(DWORD, PVOID*);
	NET_API_STATUS NetApiBufferFree(PVOID);
	NET_API_STATUS NetApiBufferReallocate(PVOID, DWORD, PVOID*);
	NET_API_STATUS NetApiBufferSize(PVOID, PDWORD);
	NET_API_STATUS NetapipBufferAllocate(DWORD, PVOID*);
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-win32");
        } else version (DigitalMars) {
            pragma(link, "auxC");
        } else {
            pragma(link, "DO-win32");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-win32");
        } else version (DigitalMars) {
            pragma(link, "auxC");
        } else {
            pragma(link, "DO-win32");
        }
    }
}
