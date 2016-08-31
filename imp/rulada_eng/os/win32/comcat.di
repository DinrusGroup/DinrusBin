/***********************************************************************\
*                                comcat.d                               *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                           by Stewart Gordon                           *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module os.win32.comcat;

import os.win32.windows, os.win32.ole2;
private import os.win32.basetyps, os.win32.cguid, os.win32.objbase, os.win32.unknwn,
  os.win32.windef, os.win32.wtypes;

alias IEnumGUID* LPENUMGUID;

interface IEnumGUID : IUnknown {
	HRESULT Next(ULONG, GUID*, ULONG*);
	HRESULT Skip(ULONG);
	HRESULT Reset();
	HRESULT Clone(LPENUMGUID*);
}

alias GUID CATID;
alias REFGUID REFCATID;
alias GUID_NULL CATID_NULL;
alias IsEqualGUID IsEqualCATID;

struct CATEGORYINFO {
	CATID        catid;
	LCID         lcid;
	OLECHAR[128] szDescription;
}
alias CATEGORYINFO* LPCATEGORYINFO;

alias IEnumGUID IEnumCATID;
alias LPENUMGUID LPENUMCATID;
alias IID_IEnumGUID IID_IEnumCATID;

alias IEnumGUID IEnumCLSID;
alias LPENUMGUID LPENUMCLSID;
alias IID_IEnumGUID IID_IEnumCLSID;

interface ICatInformation : IUnknown {
	HRESULT EnumCategories(LCID, LPENUMCATEGORYINFO*);
	HRESULT GetCategoryDesc(REFCATID, LCID, PWCHAR*);
	HRESULT EnumClassesOfCategories(ULONG, CATID*, ULONG, CATID*,
	  LPENUMCLSID*);
	HRESULT IsClassOfCategories(REFCLSID, ULONG, CATID*, ULONG, CATID*);
	HRESULT EnumImplCategoriesOfClass(REFCLSID, LPENUMCATID*);
	HRESULT EnumReqCategoriesOfClass(REFCLSID, LPENUMCATID*);
}
alias ICatInformation* LPCATINFORMATION;

interface ICatRegister : IUnknown {
	HRESULT RegisterCategories(ULONG, CATEGORYINFO*);
	HRESULT UnRegisterCategories(ULONG, CATID*);
	HRESULT RegisterClassImplCategories(REFCLSID, ULONG, CATID*);
	HRESULT UnRegisterClassImplCategories(REFCLSID, ULONG, CATID*);
	HRESULT RegisterClassReqCategories(REFCLSID, ULONG, CATID*);
	HRESULT UnRegisterClassReqCategories(REFCLSID, ULONG, CATID*);
}
alias ICatRegister* LPCATREGISTER;

interface IEnumCATEGORYINFO : IUnknown {
	HRESULT Next(ULONG, CATEGORYINFO*, ULONG*);
	HRESULT Skip(ULONG);
	HRESULT Reset();
	HRESULT Clone(LPENUMCATEGORYINFO*);
}
alias IEnumCATEGORYINFO* LPENUMCATEGORYINFO;

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
