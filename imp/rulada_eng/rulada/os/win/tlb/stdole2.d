// OLE Automation
// Version 2.0

/*[uuid("00020430-0000-0000-c000-000000000046")]*/
module stdole;

private import os.win.com.core;

// Enums

enum OLE_TRISTATE {
  Unchecked = 0x00000000,
  Checked = 0x00000001,
  Gray = 0x00000002,
}

enum LoadPictureConstants {
  Default = 0x00000000,
  Monochrome = 0x00000001,
  VgaColor = 0x00000002,
  Color = 0x00000004,
}

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

// Aliases

alias uint OLE_COLOR;

alias int OLE_XPOS_PIXELS;

alias int OLE_YPOS_PIXELS;

alias int OLE_XSIZE_PIXELS;

alias int OLE_YSIZE_PIXELS;

alias int OLE_XPOS_HIMETRIC;

alias int OLE_YPOS_HIMETRIC;

alias int OLE_XSIZE_HIMETRIC;

alias int OLE_YSIZE_HIMETRIC;

alias float OLE_XPOS_CONTAINER;

alias float OLE_YPOS_CONTAINER;

alias float OLE_XSIZE_CONTAINER;

alias float OLE_YSIZE_CONTAINER;

alias int OLE_HANDLE;

alias short OLE_OPTEXCLUSIVE;

alias short OLE_CANCELBOOL;

alias short OLE_ENABLEDEFAULTBOOL;

alias wchar* FONTNAME;

alias long FONTSIZE;

alias short FONTBOLD;

alias short FONTITALIC;

alias short FONTUNDERSCORE;

alias short FONTSTRIKETHROUGH;

alias Font IFontDisp;

alias Picture IPictureDisp;

alias FontEvents IFontEventsDisp;

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

// Font Object
interface IFont : IUnknown {
  mixin(uuid("bef6e002-a874-101a-8bba-00aa00300cab"));
  /*[id(0x60010000)]*/ int get_Name(out wchar* pname);
  /*[id(0x60010000)]*/ int put_Name(wchar* pname);
  /*[id(0x60010002)]*/ int get_Size(out long psize);
  /*[id(0x60010002)]*/ int put_Size(long psize);
  /*[id(0x60010004)]*/ int get_Bold(out short pbold);
  /*[id(0x60010004)]*/ int put_Bold(short pbold);
  /*[id(0x60010006)]*/ int get_Italic(out short pitalic);
  /*[id(0x60010006)]*/ int put_Italic(short pitalic);
  /*[id(0x60010008)]*/ int get_Underline(out short punderline);
  /*[id(0x60010008)]*/ int put_Underline(short punderline);
  /*[id(0x6001000A)]*/ int get_Strikethrough(out short pstrikethrough);
  /*[id(0x6001000A)]*/ int put_Strikethrough(short pstrikethrough);
  /*[id(0x6001000C)]*/ int get_Weight(out short pweight);
  /*[id(0x6001000C)]*/ int put_Weight(short pweight);
  /*[id(0x6001000E)]*/ int get_Charset(out short pcharset);
  /*[id(0x6001000E)]*/ int put_Charset(short pcharset);
  /*[id(0x60010010)]*/ int get_hFont(out OLE_HANDLE phfont);
  /*[id(0x60010011)]*/ int Clone(out IFont ppfont);
  /*[id(0x60010012)]*/ int IsEqual(IFont pfontOther);
  /*[id(0x60010013)]*/ int SetRatio(int cyLogical, int cyHimetric);
  /*[id(0x60010014)]*/ int AddRefHfont(OLE_HANDLE hFont);
  /*[id(0x60010015)]*/ int ReleaseHfont(OLE_HANDLE hFont);
}

interface Font : IDispatch {
  mixin(uuid("bef6e003-a874-101a-8bba-00aa00300cab"));
  /+const wchar* Name;+/
  /+const long Size;+/
  /+const short Bold;+/
  /+const short Italic;+/
  /+const short Underline;+/
  /+const short Strikethrough;+/
  /+const short Weight;+/
  /+const short Charset;+/
}

// Picture Object
interface IPicture : IUnknown {
  mixin(uuid("7bf80980-bf32-101a-8bbb-00aa00300cab"));
  /*[id(0x60010000)]*/ int get_Handle(out OLE_HANDLE phandle);
  /*[id(0x60010001)]*/ int get_hPal(out OLE_HANDLE phpal);
  /*[id(0x60010002)]*/ int get_Type(out short ptype);
  /*[id(0x60010003)]*/ int get_Width(out OLE_XSIZE_HIMETRIC pwidth);
  /*[id(0x60010004)]*/ int get_Height(out OLE_YSIZE_HIMETRIC pheight);
  /*[id(0x60010005)]*/ int Render(int hdc, int x, int y, int cx, int cy, OLE_XPOS_HIMETRIC xSrc, OLE_YPOS_HIMETRIC ySrc, OLE_XSIZE_HIMETRIC cxSrc, OLE_YSIZE_HIMETRIC cySrc, void* prcWBounds);
  /*[id(0x60010001)]*/ int put_hPal(OLE_HANDLE phpal);
  /*[id(0x60010007)]*/ int get_CurDC(out int phdcOut);
  /*[id(0x60010008)]*/ int SelectPicture(int hdcIn, out int phdcOut, out OLE_HANDLE phbmpOut);
  /*[id(0x60010009)]*/ int get_KeepOriginalFormat(out short pfkeep);
  /*[id(0x60010009)]*/ int put_KeepOriginalFormat(short pfkeep);
  /*[id(0x6001000B)]*/ int PictureChanged();
  /*[id(0x6001000C)]*/ int SaveAsFile(void* pstm, short fSaveMemCopy, out int pcbSize);
  /*[id(0x6001000D)]*/ int get_Attributes(out int pdwAttr);
  /*[id(0x6001000E)]*/ int SetHdc(OLE_HANDLE hdc);
}

interface Picture : IDispatch {
  mixin(uuid("7bf80981-bf32-101a-8bbb-00aa00300cab"));
  /+/*[id(0x00000006)]*/ void Render(int hdc, int x, int y, int cx, int cy, OLE_XPOS_HIMETRIC xSrc, OLE_YPOS_HIMETRIC ySrc, OLE_XSIZE_HIMETRIC cxSrc, OLE_YSIZE_HIMETRIC cySrc, void* prcWBounds);+/
  /+const OLE_HANDLE Handle;+/
  /+const OLE_HANDLE hPal;+/
  /+const short Type;+/
  /+const OLE_XSIZE_HIMETRIC Width;+/
  /+const OLE_YSIZE_HIMETRIC Height;+/
}

// Event interface for the Font object
interface FontEvents : IDispatch {
  mixin(uuid("4ef6100a-af88-11d0-9846-00c04fc29993"));
  /+/*[id(0x00000009)]*/ void FontChanged(wchar* PropertyName);+/
}

// CoClasses

abstract final class StdFont {
  mixin(uuid("0be35203-8f91-11ce-9de3-00aa004bb851"));
  mixin Interfaces!(Font, IFont);
}

abstract final class StdPicture {
  mixin(uuid("0be35204-8f91-11ce-9de3-00aa004bb851"));
  mixin Interfaces!(Picture, IPicture);
}

// Global functions

extern(Windows):

// Loads a picture from a file
/*[id(0x60000000)]*/ int LoadPicture(VARIANT filename, int widthDesired, int heightDesired, LoadPictureConstants flags, out IPictureDisp retval);
// Saves a picture to a file
/*[id(0x60000001)]*/ int SavePicture(IPictureDisp* Picture, wchar* filename);
