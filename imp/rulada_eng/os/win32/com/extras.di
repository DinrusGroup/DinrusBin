module os.win32.com.extras;

//
// extra bits form here and there to bring the com alias inline with MS
// to ease the porting.
//

public import os.windows;

alias IUnknown LPUNKNOWN;
alias IClassFactory LPCLASSFACTORY;

alias LPRECT LPCRECT; /* D has no consts */
struct COAUTHINFO{}
alias DWORD LCID;
alias PDWORD PLCID;
//typedef GUID CLSID;
typedef CLSID * LPCLSID;
typedef GUID *REFGUID;

typedef IID *REFIID;

typedef CLSID *REFCLSID;

//typedef FMTID  *REFFMTID;
union __MIDL_IWinTypes_0001
{
DWORD dwValue;
wchar *pwszName;
}
struct  userCLIPFORMAT
{
    long fContext;
	__MIDL_IWinTypes_0001 u;
}

alias userCLIPFORMAT *wireCLIPFORMAT;

alias WORD CLIPFORMAT;

alias void * HMETAFILEPICT;
// typeless hack
alias void * wireHGLOBAL;
alias void * wireHBITMAP;
alias void * wireHPALETTE;
alias void * wireHENHMETAFILE;
alias void * wireHMETAFILE;
alias void * wireHMETAFILEPICT;

struct BYTE_BLOB {
   ULONG clSize;
	byte[1] abData;
}

alias BYTE_BLOB *UP_BYTE_BLOB;

struct  WORD_BLOB
{
	ULONG clSize;
	ushort[1] asData;
}

alias WORD_BLOB *UP_WORD_BLOB;

struct  DWORD_BLOB
{
    ULONG clSize;
	ULONG[1] alData;
}
alias DWORD_BLOB *UP_DWORD_BLOB;
typedef ushort VARTYPE;
alias short VARIANT_BOOL;

// all the st
enum READYSTATE
    {	READYSTATE_UNINITIALIZED	= 0,
	READYSTATE_LOADING	= 1,
	READYSTATE_LOADED	= 2,
	READYSTATE_INTERACTIVE	= 3,
	READYSTATE_COMPLETE	= 4
}



version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-win32");
        } else version (DigitalMars) {
            pragma(link, "DD-win32");
        } else {
            pragma(link, "DO-win32");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-win32");
        } else version (DigitalMars) {
            pragma(link, "DD-win32");
        } else {
            pragma(link, "DO-win32");
        }
    }
}
