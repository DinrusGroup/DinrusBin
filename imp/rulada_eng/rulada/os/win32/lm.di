/***********************************************************************\
*                                  lm.d                                 *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module os.win32.lm;

version (WindowsVista) {
	version = WIN32_WINNT_ONLY;
} else version (Windows2003) {
	version = WIN32_WINNT_ONLY;
} else version (WindowsXP) {
	version = WIN32_WINNT_ONLY;
} else version (WindowsNTonly) {
	version = WIN32_WINNT_ONLY;
}

public import os.win32.lmcons;
public import os.win32.lmaccess;
public import os.win32.lmalert;
public import os.win32.lmat;
public import os.win32.lmerr;
public import os.win32.lmshare;
public import os.win32.lmapibuf;
public import os.win32.lmremutl;
public import os.win32.lmrepl;
public import os.win32.lmuse;
public import os.win32.lmstats;

version (WIN32_WINNT_ONLY) {
	public import os.win32.lmwksta;
	public import os.win32.lmserver;
}
version (WindowsVista) {
	public import os.win32.lmmsg;
} else version (Windows2003) {
	public import os.win32.lmmsg;
} else version (WindowsXP) {
	public import os.win32.lmmsg;
}

// FIXME: Everything in these next files seems to be deprecated!
import os.win32.lmaudit;
import os.win32.lmchdev; // can't find many docs for functions from this file.
import os.win32.lmconfig;
import os.win32.lmerrlog;
import os.win32.lmsvc;
import os.win32.lmsname; // in MinGW, this was publicly included by lm.lmsvc

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
