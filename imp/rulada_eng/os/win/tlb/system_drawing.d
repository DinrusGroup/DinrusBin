// System.Drawing.dll
// Version 2.0

/*[uuid("d37e2a3e-8545-3a39-9f4f-31827c9124ab")]*/
module os.win.tlb.system_drawing;

/*[importlib("STDOLE2.TLB")]*/
/*[importlib("mscorlib.tlb")]*/
private import os.win.com.core;

// Enums

enum CopyPixelOperation {
  CopyPixelOperation_Blackness = 0x00000042,
  CopyPixelOperation_CaptureBlt = 0x40000000,
  CopyPixelOperation_DestinationInvert = 0x00550009,
  CopyPixelOperation_MergeCopy = 0x00C000CA,
  CopyPixelOperation_MergePaint = 0x00BB0226,
  CopyPixelOperation_NoMirrorBitmap = 0x80000000,
  CopyPixelOperation_NotSourceCopy = 0x00330008,
  CopyPixelOperation_NotSourceErase = 0x001100A6,
  CopyPixelOperation_PatCopy = 0x00F00021,
  CopyPixelOperation_PatInvert = 0x005A0049,
  CopyPixelOperation_PatPaint = 0x00FB0A09,
  CopyPixelOperation_SourceAnd = 0x008800C6,
  CopyPixelOperation_SourceCopy = 0x00CC0020,
  CopyPixelOperation_SourceErase = 0x00440328,
  CopyPixelOperation_SourceInvert = 0x00660046,
  CopyPixelOperation_SourcePaint = 0x00EE0086,
  CopyPixelOperation_Whiteness = 0x00FF0062,
}

// Structs

struct Point {
  mixin(uuid("cd6cb0a8-d6ef-33e8-888e-fe8c78ca568f"));
  int x;
  int y;
}

struct Rectangle {
  mixin(uuid("548bbb02-5f3c-35fb-a75f-1fbd3d0d3584"));
  int x;
  int y;
  int width;
  int height;
}

struct Size {
  mixin(uuid("ecd5eb7f-1cd0-3f82-9997-5e4c9ab9f326"));
  int width;
  int height;
}

struct PointF {
  mixin(uuid("a521101d-a776-3125-b530-67030f2e0a21"));
  float x;
  float y;
}

struct SizeF {
  mixin(uuid("56abb41c-4516-30f6-882e-57f234ab5028"));
  float width;
  float height;
}

// Interfaces

interface _Image : IDispatch {
  mixin(uuid("2948ebcd-5e0a-3184-9a87-37d3258c0d98"));
}

interface _Bitmap : IDispatch {
  mixin(uuid("f86086e0-a89e-3ebe-b036-79bf72354656"));
}

interface _Font : IDispatch {
  mixin(uuid("bc28f4b1-b9ab-3dd8-a471-5b7ae757f8f9"));
}
