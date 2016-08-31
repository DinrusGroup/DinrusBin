/***********************************************************************\
*                               shldisp.d                               *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module os.win32.shldisp;

private import os.win32.unknwn, os.win32.windef, os.win32.wtypes;

// options for IAutoComplete2
const DWORD ACO_AUTOSUGGEST = 0x01;

interface IAutoComplete : public IUnknown {
	HRESULT Init(HWND, IUnknown*, LPCOLESTR, LPCOLESTR);
	HRESULT Enable(BOOL);
}
alias IAutoComplete* LPAUTOCOMPLETE;

interface IAutoComplete2 : public IAutoComplete {
	HRESULT SetOptions(DWORD);
	HRESULT GetOptions(DWORD*);
}
alias IAutoComplete2* LPAUTOCOMPLETE2;

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
