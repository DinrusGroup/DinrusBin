// Version 1.1
//oleacc.dll

/*[uuid("1ea4dbf0-3c3b-11cf-810c-00aa00389b71")]*/
module os.win.tlb.accessibility;

/*[importlib("stdole2.tlb")]*/
private import os.win.com.core;

// Enums

enum AnnoScope {
  ANNO_THIS = 0x00000000,
  ANNO_CONTAINER = 0x00000001,
}

// Union

union __MIDL_IWinTypes_0009 {
  int hInproc;
  int hRemote;
}

// Structs

struct _RemotableHandle {
  int fContext;
  __MIDL_IWinTypes_0009 u;
}

// Aliases

alias _RemotableHandle* wireHWND;

alias _RemotableHandle* wireHMENU;

// Interfaces

interface IAccessible : IDispatch {
  mixin(uuid("618736e0-3c3d-11cf-810c-00aa00389b71"));
  /*[id(0xFFFFEC78)]*/ int get_accParent(out IDispatch ppdispParent);
  /*[id(0xFFFFEC77)]*/ int get_accChildCount(out int pcountChildren);
  /*[id(0xFFFFEC76)]*/ int get_accChild(VARIANT varChild, out IDispatch ppdispChild);
  /*[id(0xFFFFEC75)]*/ int get_accName(VARIANT varChild, out wchar* pszName);
  /*[id(0xFFFFEC74)]*/ int get_accValue(VARIANT varChild, out wchar* pszValue);
  /*[id(0xFFFFEC73)]*/ int get_accDescription(VARIANT varChild, out wchar* pszDescription);
  /*[id(0xFFFFEC72)]*/ int get_accRole(VARIANT varChild, out VARIANT pvarRole);
  /*[id(0xFFFFEC71)]*/ int get_accState(VARIANT varChild, out VARIANT pvarState);
  /*[id(0xFFFFEC70)]*/ int get_accHelp(VARIANT varChild, out wchar* pszHelp);
  /*[id(0xFFFFEC6F)]*/ int get_accHelpTopic(out wchar* pszHelpFile, VARIANT varChild, out int pidTopic);
  /*[id(0xFFFFEC6E)]*/ int get_accKeyboardShortcut(VARIANT varChild, out wchar* pszKeyboardShortcut);
  /*[id(0xFFFFEC6D)]*/ int get_accFocus(out VARIANT pvarChild);
  /*[id(0xFFFFEC6C)]*/ int get_accSelection(out VARIANT pvarChildren);
  /*[id(0xFFFFEC6B)]*/ int get_accDefaultAction(VARIANT varChild, out wchar* pszDefaultAction);
  /*[id(0xFFFFEC6A)]*/ int accSelect(int flagsSelect, VARIANT varChild);
  /*[id(0xFFFFEC69)]*/ int accLocation(out int pxLeft, out int pyTop, out int pcxWidth, out int pcyHeight, VARIANT varChild);
  /*[id(0xFFFFEC68)]*/ int accNavigate(int navDir, VARIANT varStart, out VARIANT pvarEndUpAt);
  /*[id(0xFFFFEC67)]*/ int accHitTest(int xLeft, int yTop, out VARIANT pvarChild);
  /*[id(0xFFFFEC66)]*/ int accDoDefaultAction(VARIANT varChild);
  /*[id(0xFFFFEC75)]*/ int put_accName(VARIANT varChild, wchar* pszName);
  /*[id(0xFFFFEC74)]*/ int put_accValue(VARIANT varChild, wchar* pszValue);
}

interface IAccessibleHandler : IUnknown {
  mixin(uuid("03022430-abc4-11d0-bde2-00aa001a1953"));
  /*[id(0x60010000)]*/ int AccessibleObjectFromID(int hwnd, int lObjectID, out IAccessible pIAccessible);
}

interface IAccIdentity : IUnknown {
  mixin(uuid("7852b78d-1cfd-41c1-a615-9c0c85960b5f"));
  /*[id(0x60010000)]*/ int GetIdentityString(uint dwIDChild, out ubyte ppIDString, out uint pdwIDStringLen);
}

interface IAccPropServer : IUnknown {
  mixin(uuid("76c0dbbb-15e0-4e7b-b61b-20eeea2001e0"));
  /*[id(0x60010000)]*/ int GetPropValue(ubyte* pIDString, uint dwIDStringLen, GUID idProp, out VARIANT pvarValue, out int pfHasProp);
}

interface IAccPropServices : IUnknown {
  mixin(uuid("6e26e776-04f0-495d-80e4-3330352e3169"));
  /*[id(0x60010000)]*/ int SetPropValue(ubyte* pIDString, uint dwIDStringLen, GUID idProp, VARIANT var);
  /*[id(0x60010001)]*/ int SetPropServer(ubyte* pIDString, uint dwIDStringLen, ref GUID paProps, int cProps, IAccPropServer pServer, AnnoScope AnnoScope);
  /*[id(0x60010002)]*/ int ClearProps(ubyte* pIDString, uint dwIDStringLen, ref GUID paProps, int cProps);
  /*[id(0x60010003)]*/ int SetHwndProp(wireHWND hwnd, uint idObject, uint idChild, GUID idProp, VARIANT var);
  /*[id(0x60010004)]*/ int SetHwndPropStr(wireHWND hwnd, uint idObject, uint idChild, GUID idProp, wchar* str);
  /*[id(0x60010005)]*/ int SetHwndPropServer(wireHWND hwnd, uint idObject, uint idChild, ref GUID paProps, int cProps, IAccPropServer pServer, AnnoScope AnnoScope);
  /*[id(0x60010006)]*/ int ClearHwndProps(wireHWND hwnd, uint idObject, uint idChild, ref GUID paProps, int cProps);
  /*[id(0x60010007)]*/ int ComposeHwndIdentityString(wireHWND hwnd, uint idObject, uint idChild, out ubyte ppIDString, out uint pdwIDStringLen);
  /*[id(0x60010008)]*/ int DecomposeHwndIdentityString(ubyte* pIDString, uint dwIDStringLen, out wireHWND phwnd, out uint pidObject, out uint pidChild);
  /*[id(0x60010009)]*/ int SetHmenuProp(wireHMENU hmenu, uint idChild, GUID idProp, VARIANT var);
  /*[id(0x6001000A)]*/ int SetHmenuPropStr(wireHMENU hmenu, uint idChild, GUID idProp, wchar* str);
  /*[id(0x6001000B)]*/ int SetHmenuPropServer(wireHMENU hmenu, uint idChild, ref GUID paProps, int cProps, IAccPropServer pServer, AnnoScope AnnoScope);
  /*[id(0x6001000C)]*/ int ClearHmenuProps(wireHMENU hmenu, uint idChild, ref GUID paProps, int cProps);
  /*[id(0x6001000D)]*/ int ComposeHmenuIdentityString(wireHMENU hmenu, uint idChild, out ubyte ppIDString, out uint pdwIDStringLen);
  /*[id(0x6001000E)]*/ int DecomposeHmenuIdentityString(ubyte* pIDString, uint dwIDStringLen, out wireHMENU phmenu, out uint pidChild);
}

// CoClasses

abstract final class CAccPropServices {
  mixin(uuid("b5f8350b-0548-48b1-a6ee-88bd00b4a5e7"));
  mixin Interfaces!(IAccPropServices);
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-win");
        } else version (DigitalMars) {
            pragma(link, "rulada");
        } else {
            pragma(link, "DO-win");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-win");
        } else version (DigitalMars) {
            pragma(link, "rulada");
        } else {
            pragma(link, "DO-win");
        }
    }
}
