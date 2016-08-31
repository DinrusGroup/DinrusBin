// Used only for testing -- imports all windows headers.
module os.win32.testall;

import os.win32.core;
import os.win32.windows;
import os.win32.commctrl;
import os.win32.setupapi;

import os.win32.directx.d3d9;
import os.win32.directx.dxerr8;
import os.win32.directx.dxerr9;
import os.win32.oleacc;
import os.win32.comcat;
import os.win32.cpl;
import os.win32.cplext;
import os.win32.custcntl;
import os.win32.oleacc;
import os.win32.ocidl;
import os.win32.olectl;
import os.win32.oledlg;
import os.win32.objsafe;
import os.win32.ole;

import os.win32.shldisp;
import os.win32.shlobj;
import os.win32.shlwapi;
import os.win32.regstr;
import os.win32.richole;
import os.win32.tmschema;
import os.win32.servprov;
import os.win32.exdisp;
import os.win32.exdispid;
import os.win32.idispids;
import os.win32.mshtml;

import os.win32.lm;
import os.win32.lmbrowsr;

import os.win32.sql;
import os.win32.sqlext;
import os.win32.sqlucode;
import os.win32.odbcinst;

import os.win32.imagehlp;
import os.win32.intshcut;
import os.win32.iphlpapi;
import os.win32.isguids;

import os.win32.subauth;
import os.win32.rasdlg;
import os.win32.rassapi;

import os.win32.mapi;
import os.win32.mciavi;
import os.win32.mcx;
import os.win32.mgmtapi;

import os.win32.nddeapi;
import os.win32.msacm;
import os.win32.nspapi;

import os.win32.ntdef;
import os.win32.ntldap;
import os.win32.ntsecapi;

import os.win32.pbt;
import os.win32.powrprof;
import os.win32.rapi;

import os.win32.wininet;
import os.win32.winioctl;
import os.win32.winldap;

import os.win32.dbt;

import os.win32.rpcdce2;

import os.win32.tlhelp32;


version (WindowsVista) {
	version = WINDOWS_XP_UP;
} else version (Windows2003) {
	version = WINDOWS_XP_UP;
} else version (WindowsXP) {
	version = WINDOWS_XP_UP;
}

version (WINDOWS_XP_UP) {
	import os.win32.dhcpcsdk;
	import os.win32.errorrep;
	import os.win32.reason;
	import os.win32.secext;
	import os.win32.ntdll;
} else version (WindowsNTonly) {
	version (Windows2000) {
		import os.win32.dhcpcsdk;
		import os.win32.aclui;
	}
	import os.win32.ntdll;
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
