// Acrobat Control for ActiveX
// Version 1.3

/*[uuid("ca8a9783-280d-11cf-a24d-444553540000")]*/
module os.win.tlb.pdflib;

/*[importlib("stdole2.tlb")]*/
private import os.win.com.core;

// Interfaces

// Dispatch interface for Acrobat Control
interface _DPdf : IDispatch {
  mixin(uuid("ca8a9781-280d-11cf-a24d-444553540000"));
  /+/*[id(0x00000002)]*/ short LoadFile(wchar* fileName);+/
  /+/*[id(0x00000003)]*/ void setShowToolbar(short On);+/
  /+/*[id(0x00000004)]*/ void gotoFirstPage();+/
  /+/*[id(0x00000005)]*/ void gotoLastPage();+/
  /+/*[id(0x00000006)]*/ void gotoNextPage();+/
  /+/*[id(0x00000007)]*/ void gotoPreviousPage();+/
  /+/*[id(0x00000008)]*/ void setCurrentPage(int n);+/
  /+/*[id(0x00000009)]*/ void goForwardStack();+/
  /+/*[id(0x0000000A)]*/ void goBackwardStack();+/
  /+/*[id(0x0000000B)]*/ void setPageMode(wchar* pageMode);+/
  /+/*[id(0x0000000C)]*/ void setLayoutMode(wchar* layoutMode);+/
  /+/*[id(0x0000000D)]*/ void setNamedDest(wchar* namedDest);+/
  /+/*[id(0x0000000E)]*/ void Print();+/
  /+/*[id(0x0000000F)]*/ void printWithDialog();+/
  /+/*[id(0x00000010)]*/ void setZoom(float percent);+/
  /+/*[id(0x00000011)]*/ void setZoomScroll(float percent, float left, float top);+/
  /+/*[id(0x00000012)]*/ void setView(wchar* viewMode);+/
  /+/*[id(0x00000013)]*/ void setViewScroll(wchar* viewMode, float offset);+/
  /+/*[id(0x00000014)]*/ void setViewRect(float left, float top, float width, float height);+/
  /+/*[id(0x00000015)]*/ void printPages(int from, int to);+/
  /+/*[id(0x00000016)]*/ void printPagesFit(int from, int to, short shrinkToFit);+/
  /+/*[id(0x00000017)]*/ void printAll();+/
  /+/*[id(0x00000018)]*/ void printAllFit(short shrinkToFit);+/
  /+/*[id(0x00000019)]*/ void setShowScrollbars(short On);+/
  /+/*[id(0xFFFFFDD8)]*/ void AboutBox();+/
  /+const wchar* src;+/
}

// Event interface for Acrobat Control
interface _DPdfEvents : IDispatch {
  mixin(uuid("ca8a9782-280d-11cf-a24d-444553540000"));
}

// CoClasses

// Acrobat Control for ActiveX
abstract final class Pdf {
  mixin(uuid("ca8a9780-280d-11cf-a24d-444553540000"));
  mixin Interfaces!(_DPdf);
}
