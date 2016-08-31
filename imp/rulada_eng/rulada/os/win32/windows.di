/***********************************************************************\
*                               windows.d                               *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*             Translated from MinGW API for MS-Windows 3.10             *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module os.win32.windows;

/*
	windows.h - main header file for the Win32 API

	Written by Anders Norlander <anorland@hem2.passagen.se>

	This file is part of a free library for the Win32 API.

	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

*/

public import os.win32.w32api;
public import os.win32.core;

// We can't use static if for imports, build gets confused.
version (WindowsVista) {
	public import os.win32.winsvc;
} else version (Windows2003) {
	public import os.win32.winsvc;
} else version (WindowsXP) {
	public import os.win32.winsvc;
} else version (WindowsNTonly) {
	public import os.win32.winsvc;
}

public import os.win32.cderr;
public import os.win32.dde;
public import os.win32.ddeml;
public import os.win32.dlgs;
public import os.win32.imm;
public import os.win32.lzexpand;
public import os.win32.mmsystem;
public import os.win32.nb30;



public import os.win32.rpc;
public import os.win32.shellapi;
public import os.win32.winperf;
public import os.win32.commdlg;
public import os.win32.winspool;
public import os.win32.ole2;

// Select correct version of winsock.  Importing the incorrect
// module will cause a static assert to prevent problems later on.
version (Win32_Winsock1) {
	public import os.win32.winsock;
} else {
	public import os.win32.winsock2;
	public import os.win32.ws2tcpip;
}

/+
#if (_WIN32_WINNT >= 0x0400)
#include <winsock2.h>
/*
 * MS likes to include mswsock.h here as well,
 * but that can cause undefined symbols if
 * winsock2.h is included before windows.h
 */
#else
#include <winsock.h>
#endif /*  (_WIN32_WINNT >= 0x0400) */
+/

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
