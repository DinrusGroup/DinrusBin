/***********************************************************************\
*                                secext.d                               *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
// Don't include this file directly, use os.win32.security instead.
module os.win32.secext;
pragma(lib, "secur32.lib");

private import os.win32.w32api, os.win32.windef;

/*static assert (_WIN32_WINNT >= 0x0501,
  "SecExt is only available on WindowsXP and later");*/

enum EXTENDED_NAME_FORMAT {
	NameUnknown,
	NameFullyQualifiedDN,
	NameSamCompatible,
	NameDisplay,          // =  3
	NameUniqueId             =  6,
	NameCanonical,
	NameUserPrincipal,
	NameCanonicalEx,
	NameServicePrincipal, // = 10
	NameDnsDomain            = 12
}
alias EXTENDED_NAME_FORMAT* PEXTENDED_NAME_FORMAT;

extern (Windows) {
	BOOLEAN GetComputerObjectNameA(EXTENDED_NAME_FORMAT, LPSTR, PULONG);
	BOOLEAN GetComputerObjectNameW(EXTENDED_NAME_FORMAT, LPWSTR, PULONG);
	BOOLEAN GetUserNameExA(EXTENDED_NAME_FORMAT, LPSTR, PULONG);
	BOOLEAN GetUserNameExW(EXTENDED_NAME_FORMAT, LPWSTR, PULONG);
	BOOLEAN TranslateNameA(LPCSTR, EXTENDED_NAME_FORMAT,
	  EXTENDED_NAME_FORMAT, LPSTR, PULONG);
	BOOLEAN TranslateNameW(LPCWSTR, EXTENDED_NAME_FORMAT,
	  EXTENDED_NAME_FORMAT, LPWSTR, PULONG);
}

version (Unicode) {
	alias GetComputerObjectNameW GetComputerObjectName;
	alias GetUserNameExW GetUserNameEx;
	alias TranslateNameW TranslateName;
} else {
	alias GetComputerObjectNameA GetComputerObjectName;
	alias GetUserNameExA GetUserNameEx;
	alias TranslateNameA TranslateName;
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
