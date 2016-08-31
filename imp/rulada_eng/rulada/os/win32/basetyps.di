/***********************************************************************\
*                               basetyps.d                              *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*             Translated from MinGW API for MS-Windows 3.10             *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module os.win32.basetyps;

private import os.win32.windef, os.win32.basetsd;

align(1) struct GUID {  // size is 16
	DWORD   Data1;
	WORD    Data2;
	WORD    Data3;
	BYTE[8] Data4;
}
alias GUID UUID, IID, CLSID, FMTID, uuid_t;
alias GUID* LPGUID, LPCLSID, LPIID;
alias CPtr!(GUID) REFGUID, REFIID, REFCLSID, REFFMTID;

alias uint error_status_t, PROPID;

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
