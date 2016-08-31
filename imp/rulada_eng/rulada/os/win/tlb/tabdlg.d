module os.win.tlb.tabdlg;

private import os.win.com.core;

enum OLEDropConstants {
  ssOLEDropNone = 0x00000000,
  ssOLEDropManual = 0x00000001,
}

enum DragOverConstants {
  ssEnter = 0x00000000,
  ssLeave = 0x00000001,
  ssOver = 0x00000002,
}

enum ClipBoardConstants {
  ssCFText = 0x00000001,
  ssCFBitmap = 0x00000002,
  ssCFMetafile = 0x00000003,
  ssCFDIB = 0x00000008,
  ssCFPalette = 0x00000009,
  ssCFEMetafile = 0x0000000E,
  ssCFFiles = 0x0000000F,
  ssCFRTF = 0xFFFFBF01,
}

enum OLEDropEffectConstants {
  ssOLEDropEffectNone = 0x00000000,
  ssOLEDropEffectCopy = 0x00000001,
  ssOLEDropEffectMove = 0x00000002,
  ssOLEDropEffectScroll = 0x80000000,
}

enum ErrorConstants {
  ssOutOfMemory = 0x00000007,
  ssInvalidPropertyValue = 0x0000017C,
  ssSetNotSupported = 0x0000017F,
  ssGetNotSupported = 0x0000018A,
  ssBadIndex = 0x0000017D,
  ssInvalidPicture = 0x000001E1,
  ssDataObjectLocked = 0x000002A0,
  ssExpectedAnArgument = 0x000002A1,
  ssInvalidProcedureCall = 0x00000005,
  ssInvalidObjectUse = 0x000001A9,
  ssWrongClipboardFormat = 0x000001CD,
  ssRecursiveOleDrag = 0x000002A2,
  ssFormatNotByteArray = 0x000002A3,
  ssDataNotSetForFormat = 0x000002A4,
}

enum MousePointerConstants {
  ssDefault = 0x00000000,
  ssArrow = 0x00000001,
  ssCross = 0x00000002,
  ssIBeam = 0x00000003,
  ssIcon = 0x00000004,
  ssSize = 0x00000005,
  ssSizeNESW = 0x00000006,
  ssSizeNS = 0x00000007,
  ssSizeNWSE = 0x00000008,
  ssSizeEW = 0x00000009,
  ssUpArrow = 0x0000000A,
  ssHourglass = 0x0000000B,
  ssNoDrop = 0x0000000C,
  ssArrowHourglass = 0x0000000D,
  ssArrowQuestion = 0x0000000E,
  ssSizeAll = 0x0000000F,
  ssCustom = 0x00000063,
}

enum TabOrientationConstants {
  ssTabOrientationTop = 0x00000000,
  ssTabOrientationBottom = 0x00000001,
  ssTabOrientationLeft = 0x00000002,
  ssTabOrientationRight = 0x00000003,
}

enum StyleConstants {
  ssStyleTabbedDialog = 0x00000000,
  ssStylePropertyPage = 0x00000001,
}

interface IVBDataObject : IDispatch {
  mixin(uuid("2334d2b1-713e-11cf-8ae5-00aa00c00905"));
  int Clear();
  int GetData(short sFormat, out VARIANT pvData);
  int GetFormat(short sFormat, out short pbFormatSupported);
  int SetData(VARIANT vValue, VARIANT vFormat);
  int get_Files(out IVBDataObjectFiles pFiles);
}

interface IVBDataObjectFiles : IDispatch {
  mixin(uuid("2334d2b3-713e-11cf-8ae5-00aa00c00905"));
  int get_Item(int lIndex, out wchar* bstrItem);
  int get_Count(out int plCount);
  int Add(wchar* bstrFilename, VARIANT vIndex);
  int Clear();
  int Remove(VARIANT vIndex);
  int _NewEnum(out IUnknown ppUnk);
}

interface ISSTabCtl : IDispatch {
  mixin(uuid("2a4fccb0-dff1-11cf-8e74-00a0c90f26f8"));
  int get_BackColor(out OLE_COLOR pocBackColor);
  int put_BackColor(OLE_COLOR pocBackColor);
  int get_Font(out IFontDisp ppFont);
  int putref_Font(IFontDisp* ppFont);
  int get_ForeColor(out OLE_COLOR pocForeColor);
  int put_ForeColor(OLE_COLOR pocForeColor);
  int get_Caption(out wchar* pbstrCaption);
  int put_Caption(wchar* pbstrCaption);
  int get_Enabled(out short pbEnabled);
  int put_Enabled(short pbEnabled);
  int get_hWnd(out OLE_HANDLE phWnd);
  int put_hWnd(OLE_HANDLE phWnd);
  int get__Tab(out short pTab);
  int put__Tab(short pTab);
  int get_TabsPerRow(out short psTabsPerRow);
  int put_TabsPerRow(short psTabsPerRow);
  int get_Tabs(out short psTabs);
  int put_Tabs(short psTabs);
  int get_Rows(out short psRows);
  int put_Rows(short psRows);
  int get_Tab(out short psTab);
  int put_Tab(short psTab);
  int get_TabOrientation(out TabOrientationConstants pTabOrientation);
  int put_TabOrientation(TabOrientationConstants pTabOrientation);
  int get_Picture(out IPictureDisp ppPicture);
  int put_Picture(IPictureDisp* ppPicture);
  int putref_Picture(IPictureDisp* ppPicture);
  int get_ShowFocusRect(out short pbShowFocusRect);
  int put_ShowFocusRect(short pbShowFocusRect);
  int get_WordWrap(out short pbWordWrap);
  int put_WordWrap(short pbWordWrap);
  int get_Style(out StyleConstants pStyle);
  int put_Style(StyleConstants pStyle);
  int get_TabHeight(out float pfTabHeight);
  int put_TabHeight(float pfTabHeight);
  int get_TabMaxWidth(out float pfTabMaxWidth);
  int put_TabMaxWidth(float pfTabMaxWidth);
  int get_MousePointer(out MousePointerConstants pMousePtr);
  int put_MousePointer(MousePointerConstants pMousePtr);
  int get_MouseIcon(out IPictureDisp ppMouseIcon);
  int put_MouseIcon(IPictureDisp* ppMouseIcon);
  int putref_MouseIcon(IPictureDisp* ppMouseIcon);
  int get_OLEDropMode(out OLEDropConstants psOLEDropMode);
  int put_OLEDropMode(OLEDropConstants psOLEDropMode);
  int OLEDrag();
  int get_TabPicture(short Index, out IPictureDisp ppTabPicture);
  int put_TabPicture(short Index, IPictureDisp* ppTabPicture);
  int putref_TabPicture(short Index, IPictureDisp* ppTabPicture);
  int get_TabVisible(short Index, out short pbTabVisible);
  int put_TabVisible(short Index, short pbTabVisible);
  int get_TabEnabled(short sIndex, out short pbTabEnabled);
  int put_TabEnabled(short sIndex, short pbTabEnabled);
  int get_TabCaption(short sIndex, out wchar* pbstrTabCaption);
  int put_TabCaption(short sIndex, wchar* pbstrTabCaption);
  void AboutBox();
}

interface DSSTabCtlEvents : IDispatch {
  mixin(uuid("bdc217c7-ed16-11cd-956c-0000c04e4c0a"));
  /+void DblClick();+/
  /+void KeyDown(short KeyCode, short Shift);+/
  /+void KeyPress(short* KeyAscii);+/
  /+void KeyUp(short KeyCode, short Shift);+/
  /+void MouseDown(short Button, short Shift, OLE_XPOS_PIXELS X, OLE_YPOS_PIXELS Y);+/
  /+void MouseMove(short Button, short Shift, OLE_XPOS_PIXELS X, OLE_YPOS_PIXELS Y);+/
  /+void MouseUp(short Button, short Shift, OLE_XPOS_PIXELS X, OLE_YPOS_PIXELS Y);+/
  /+void Click(short PreviousTab);+/
  /+void OLEStartDrag(ref DataObject Data, ref int AllowedEffects);+/
  /+void OLEGiveFeedback(ref int Effect, ref short DefaultCursors);+/
  /+void OLESetData(ref DataObject Data, ref short DataFormat);+/
  /+void OLECompleteDrag(ref int Effect);+/
  /+void OLEDragOver(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float X, ref float Y, ref short State);+/
  /+void OLEDragDrop(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float X, ref float Y);+/
}

abstract final class SSTab {
  mixin(uuid("bdc217c5-ed16-11cd-956c-0000c04e4c0a"));
  mixin Interfaces!(ISSTabCtl);
}
