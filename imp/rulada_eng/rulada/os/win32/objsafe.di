/***********************************************************************\
*                               objsafe.d                               *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                           by Stewart Gordon                           *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module os.win32.objsafe;

private import os.win32.basetyps, os.win32.unknwn, os.win32.windef;

enum {
	INTERFACESAFE_FOR_UNTRUSTED_CALLER = 1,
	INTERFACESAFE_FOR_UNTRUSTED_DATA
}

interface IObjectSafety : IUnknown {
	HRESULT GetInterfaceSafetyOptions(REFIID, DWORD*, DWORD*);
	HRESULT SetInterfaceSafetyOptions(REFIID, DWORD, DWORD);
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
