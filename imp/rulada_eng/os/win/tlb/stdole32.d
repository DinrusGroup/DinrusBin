// OLE Automation
// Version 1.0

/*[uuid("00020430-0000-0000-c000-000000000046")]*/
module stdole;

private import os.win.com.core;

// Structs

struct GUID {
  uint Data1;
  ushort Data2;
  ushort Data3;
  ubyte[8] Data4;
}

struct DISPPARAMS {
  VARIANT* rgvarg;
  int* rgdispidNamedArgs;
  uint cArgs;
  uint cNamedArgs;
}

struct EXCEPINFO {
  ushort wCode;
  ushort wReserved;
  wchar* bstrSource;
  wchar* bstrDescription;
  wchar* bstrHelpFile;
  uint dwHelpContext;
  void* pvReserved;
  void* pfnDeferredFillIn;
  int scode;
}

// Interfaces

interface IUnknown {
  mixin(uuid("00000000-0000-0000-c000-000000000046"));
  /*[id(0x60000000)]*/ int QueryInterface(ref GUID riid, void* ppvObj);
  /*[id(0x60000001)]*/ uint AddRef();
  /*[id(0x60000002)]*/ uint Release();
}

interface IDispatch : IUnknown {
  mixin(uuid("00020400-0000-0000-c000-000000000046"));
  /*[id(0x60010000)]*/ int GetTypeInfoCount(out uint pctinfo);
  /*[id(0x60010001)]*/ int GetTypeInfo(uint itinfo, uint lcid, void* pptinfo);
  /*[id(0x60010002)]*/ int GetIDsOfNames(ref GUID riid, byte** rgszNames, uint cNames, uint lcid, out int rgdispid);
  /*[id(0x60010003)]*/ int Invoke(int dispidMember, ref GUID riid, uint lcid, ushort wFlags, DISPPARAMS* pdispparams, out VARIANT pvarResult, out EXCEPINFO pexcepinfo, out uint puArgErr);
}

interface IEnumVARIANT : IUnknown {
  mixin(uuid("00020404-0000-0000-c000-000000000046"));
  /*[id(0x60010000)]*/ int Next(uint celt, VARIANT* rgvar, out uint pceltFetched);
  /*[id(0x60010001)]*/ int Skip(uint celt);
  /*[id(0x60010002)]*/ int Reset();
  /*[id(0x60010003)]*/ int Clone(out IEnumVARIANT ppenum);
}
