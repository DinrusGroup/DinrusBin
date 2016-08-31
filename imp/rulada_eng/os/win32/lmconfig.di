/***********************************************************************\
*                              lmconfig.d                               *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module os.win32.lmconfig;

// All functions in this file are deprecated!

private import os.win32.lmcons, os.win32.windef;

deprecated {
	struct CONFIG_INFO_0 {
		LPWSTR cfgi0_key;
		LPWSTR cfgi0_data;
	}

	alias CONFIG_INFO_0* PCONFIG_INFO_0, LPCONFIG_INFO_0;

	extern (Windows) {
		NET_API_STATUS NetConfigGet(LPCWSTR, LPCWSTR, LPCWSTR, PBYTE*);
		NET_API_STATUS NetConfigGetAll(LPCWSTR, LPCWSTR, PBYTE*);
		NET_API_STATUS NetConfigSet(LPCWSTR, LPCWSTR, LPCWSTR, DWORD, DWORD,
		  PBYTE, DWORD);
	}
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
