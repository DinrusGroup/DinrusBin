/***********************************************************************\
*                                core.d                                 *
*                                                                       *
*                    Helper module for the Windows API                  *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module os.win32.core;

/**
 The core Windows API functions.

 Importing this file is equivalent to the C code:
 ---
 #define WIN32_LEAN_AND_MEAN
 #include "windows.h"
 ---

*/

public import os.win32.windef;
public import os.win32.winnt;
public import os.win32.wincon;
public import os.win32.winbase;
public import os.win32.wingdi;
public import os.win32.winuser;
public import os.win32.winnls;
public import os.win32.winver;
public import os.win32.winnetwk;

// We can't use static if for imports, build gets confused.
// static if (_WIN32_WINNT_ONLY) import os.win32.winsvc;
version (WindowsVista) {
	version = WIN32_WINNT_ONLY;
} else version (Windows2003) {
	version = WIN32_WINNT_ONLY;
} else version (WindowsXP) {
	version = WIN32_WINNT_ONLY;
} else version (WindowsNTonly) {
	version = WIN32_WINNT_ONLY;
}

version (WIN32_WINNT_ONLY) {
	public import os.win32.winsvc;
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
