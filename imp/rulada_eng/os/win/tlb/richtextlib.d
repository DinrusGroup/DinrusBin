module os.win.tlb.richtextlib;

private import os.win.com.core;

enum OLEDragConstants {
  rtfOLEDragManual = 0x00000000,
  rtfOLEDragAutomatic = 0x00000001,
}

enum OLEDropConstants {
  rtfOLEDropNone = 0x00000000,
  rtfOLEDropManual = 0x00000001,
  rtfOLEDropAutomatic = 0x00000002,
}

enum DragOverConstants {
  rtfEnter = 0x00000000,
  rtfLeave = 0x00000001,
  rtfOver = 0x00000002,
}

enum ClipBoardConstants {
  rtfCFText = 0x00000001,
  rtfCFBitmap = 0x00000002,
  rtfCFMetafile = 0x00000003,
  rtfCFDIB = 0x00000008,
  rtfCFPalette = 0x00000009,
  rtfCFEMetafile = 0x0000000E,
  rtfCFFiles = 0x0000000F,
  rtfCFRTF = 0xFFFFBF01,
}

enum OLEDropEffectConstants {
  rtfOLEDropEffectNone = 0x00000000,
  rtfOLEDropEffectCopy = 0x00000001,
  rtfOLEDropEffectMove = 0x00000002,
  rtfOLEDropEffectScroll = 0x80000000,
}

enum AppearanceConstants {
  rtfFlat = 0x00000000,
  rtfThreeD = 0x00000001,
}

enum BorderStyleConstants {
  rtfNoBorder = 0x00000000,
  rtfFixedSingle = 0x00000001,
}

enum FindConstants {
  rtfWholeWord = 0x00000002,
  rtfMatchCase = 0x00000004,
  rtfNoHighlight = 0x00000008,
}

enum LoadSaveConstants {
  rtfRTF = 0x00000000,
  rtfText = 0x00000001,
}

enum MousePointerConstants {
  rtfDefault = 0x00000000,
  rtfArrow = 0x00000001,
  rtfCross = 0x00000002,
  rtfIBeam = 0x00000003,
  rtfIcon = 0x00000004,
  rtfSize = 0x00000005,
  rtfSizeNESW = 0x00000006,
  rtfSizeNS = 0x00000007,
  rtfSizeNWSE = 0x00000008,
  rtfSizeEW = 0x00000009,
  rtfUpArrow = 0x0000000A,
  rtfHourglass = 0x0000000B,
  rtfNoDrop = 0x0000000C,
  rtfArrowHourglass = 0x0000000D,
  rtfArrowQuestion = 0x0000000E,
  rtfSizeAll = 0x0000000F,
  rtfCustom = 0x00000063,
}

enum ScrollBarsConstants {
  rtfNone = 0x00000000,
  rtfHorizontal = 0x00000001,
  rtfVertical = 0x00000002,
  rtfBoth = 0x00000003,
}

enum SelAlignmentConstants {
  rtfLeft = 0x00000000,
  rtfRight = 0x00000001,
  rtfCenter = 0x00000002,
}

enum DisplayTypeConstants {
  rtfDisplayContent = 0x00000000,
  rtfDisplayIcon = 0x00000001,
}

enum ErrorConstants {
  rtfOutOfMemory = 0x00000007,
  rtfInvalidPropertyValue = 0x0000017C,
  rtfInvalidPropertyArrayIndex = 0x0000017D,
  rtfSetNotSupported = 0x0000017F,
  rtfSetNotPermitted = 0x00000183,
  rtfGetNotSupported = 0x0000018A,
  rtfInvalidProcedureCall = 0x00000005,
  rtfInvalidObjectUse = 0x000001A9,
  rtfWrongClipboardFormat = 0x000001CD,
  rtfDataObjectLocked = 0x000002A0,
  rtfExpectedAnArgument = 0x000002A1,
  rtfRecursiveOleDrag = 0x000002A2,
  rtfFormatNotByteArray = 0x000002A3,
  rtfDataNotSetInFormat = 0x000002A4,
  rtfPathFileAccessError = 0x0000004B,
  rtfInvalidFileFormat = 0x00000141,
  rtfInvalidCharPosition = 0x00007D00,
  rtfInvalidHdc = 0x00007D01,
  rtfCannotLoadFile = 0x00007D02,
  rtfProtected = 0x00007D0B,
  rtfInvalidKeyName = 0x00007D05,
  rtfInvalidClassName = 0x00007D06,
  rtfKeyNotFound = 0x00007D07,
  rtfOLESourceRequired = 0x00007D08,
  rtfNonUniqueKey = 0x00007D09,
  rtfInvalidObject = 0x00007D0A,
  rtfOleCreate = 0x00007D0C,
  rtfOleServer = 0x00007D0D,
}

alias IRichText IRichText10;

alias IRichText IRichText11;

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

interface IOLEObject : IDispatch {
  mixin(uuid("ed117630-4090-11cf-8981-00aa00688b10"));
  int get_Index(out int piIndex);
  int get_Key(out wchar* pbstrKey);
  int put_Key(wchar* pbstrKey);
  int get_Class(out wchar* pbstrClass);
  int get_DisplayType(out DisplayTypeConstants pnType);
  int put_DisplayType(DisplayTypeConstants pnType);
  int get_ObjectVerbs(out VARIANT pvArray);
  int get_ObjectVerbFlags(out VARIANT pvArray);
  int get_ObjectVerbsCount(out int pnCount);
  int DoVerb(VARIANT verb);
  int FetchVerbs(out int pnCount);
}

interface IOLEObjects : IDispatch {
  mixin(uuid("859321d0-3fd1-11cf-8981-00aa00688b10"));
  int get_Item(VARIANT Item, out IOLEObject ppOLEObject);
  int get_Count(out int plCount);
  int Clear();
  int Add(VARIANT Index, VARIANT Key, VARIANT source, VARIANT objclass, out IOLEObject ppOLEObject);
  int Remove(VARIANT Item);
  int _NewEnum(out IUnknown ppNewEnum);
}

interface IRichText : IDispatch {
  mixin(uuid("e9a5593c-cab0-11d1-8c0b-0000f8754da1"));
  int get_defTextRTF(out wchar* pbstrTextRTF);
  int put_defTextRTF(wchar* pbstrTextRTF);
  int get_Appearance(out AppearanceConstants pAppearance);
  int put_Appearance(AppearanceConstants pAppearance);
  int get_BackColor(out OLE_COLOR pocBackColor);
  int put_BackColor(OLE_COLOR pocBackColor);
  int get_BorderStyle(out BorderStyleConstants pBorderStyle);
  int put_BorderStyle(BorderStyleConstants pBorderStyle);
  int get_BulletIndent(out float pflBulletIndent);
  int put_BulletIndent(float pflBulletIndent);
  int get_DisableNoScroll(out short pfDisableNoScroll);
  int put_DisableNoScroll(short pfDisableNoScroll);
  int get_Enabled(out short pfEnabled);
  int put_Enabled(short pfEnabled);
  int get_FileName(out wchar* pbstrFileName);
  int put_FileName(wchar* pbstrFileName);
  int get_Font(out IFontDisp ppFont);
  int putref_Font(IFontDisp* ppFont);
  int get_HideSelection(out short pfHideSelection);
  int put_HideSelection(short pfHideSelection);
  int get_Hwnd(out OLE_HANDLE pohHwnd);
  int put_Hwnd(OLE_HANDLE pohHwnd);
  int get_Locked(out short pfLocked);
  int put_Locked(short pfLocked);
  int get_MaxLength(out int plMaxLength);
  int put_MaxLength(int plMaxLength);
  int get_MouseIcon(out IPictureDisp ppMouseIcon);
  int put_MouseIcon(IPictureDisp* ppMouseIcon);
  int putref_MouseIcon(IPictureDisp* ppMouseIcon);
  int get_MousePointer(out MousePointerConstants pMousePointer);
  int put_MousePointer(MousePointerConstants pMousePointer);
  int get_MultiLine(out short pfMultiLine);
  int put_MultiLine(short pfMultiLine);
  int get_RightMargin(out float pflRightMargin);
  int put_RightMargin(float pflRightMargin);
  int get_ScrollBars(out ScrollBarsConstants psbcScrollBars);
  int put_ScrollBars(ScrollBarsConstants psbcScrollBars);
  int get_SelAlignment(out VARIANT pvarSelAlignment);
  int put_SelAlignment(VARIANT pvarSelAlignment);
  int get_SelBold(out VARIANT pvarSelBold);
  int put_SelBold(VARIANT pvarSelBold);
  int get_SelBullet(out VARIANT pvarSelBullet);
  int put_SelBullet(VARIANT pvarSelBullet);
  int get_SelCharOffset(out VARIANT pvarSelCharOffset);
  int put_SelCharOffset(VARIANT pvarSelCharOffset);
  int get_SelColor(out VARIANT pvarSelColor);
  int put_SelColor(VARIANT pvarSelColor);
  int get_SelFontName(out VARIANT pvarSelFontName);
  int put_SelFontName(VARIANT pvarSelFontName);
  int get_SelFontSize(out VARIANT pvarSelFontSize);
  int put_SelFontSize(VARIANT pvarSelFontSize);
  int get_SelHangingIndent(out VARIANT pvarSelHangingIndent);
  int put_SelHangingIndent(VARIANT pvarSelHangingIndent);
  int get_SelIndent(out VARIANT pvarSelIndent);
  int put_SelIndent(VARIANT pvarSelIndent);
  int get_SelItalic(out VARIANT pvarSelItalic);
  int put_SelItalic(VARIANT pvarSelItalic);
  int get_SelLength(out int plSelLength);
  int put_SelLength(int plSelLength);
  int get_SelProtected(out VARIANT pvarSelProtected);
  int put_SelProtected(VARIANT pvarSelProtected);
  int get_SelRightIndent(out VARIANT pvarSelRightIndent);
  int put_SelRightIndent(VARIANT pvarSelRightIndent);
  int get_SelRTF(out wchar* pbstrSelRTF);
  int put_SelRTF(wchar* pbstrSelRTF);
  int get_SelStart(out int plSelStart);
  int put_SelStart(int plSelStart);
  int get_SelStrikeThru(out VARIANT pvarSelStrikeThru);
  int put_SelStrikeThru(VARIANT pvarSelStrikeThru);
  int get_SelTabCount(out VARIANT pvarSelTabCount);
  int put_SelTabCount(VARIANT pvarSelTabCount);
  int get_SelText(out wchar* pbstrSelText);
  int put_SelText(wchar* pbstrSelText);
  int get_SelUnderline(out VARIANT pvarSelUnderline);
  int put_SelUnderline(VARIANT pvarSelUnderline);
  int get_Text(out wchar* pbstrText);
  int put_Text(wchar* pbstrText);
  int get_TextRTF(out wchar* pbstrTextRTF);
  int put_TextRTF(wchar* pbstrTextRTF);
  int get_OLEObjects(out IOLEObjects ppOLEObjects);
  int get_AutoVerbMenu(out short pfOn);
  int put_AutoVerbMenu(short pfOn);
  int get_OLEDragMode(out OLEDragConstants psOLEDragMode);
  int put_OLEDragMode(OLEDragConstants psOLEDragMode);
  int get_OLEDropMode(out OLEDropConstants psOLEDropMode);
  int put_OLEDropMode(OLEDropConstants psOLEDropMode);
  void AboutBox();
  int Find(wchar* bstrString, VARIANT vStart, VARIANT vEnd, VARIANT vOptions, out int plFind);
  int GetLineFromChar(int lChar, out int plLine);
  int LoadFile(wchar* bstrFilename, VARIANT vFileType);
  void Refresh();
  int SaveFile(wchar* bstrFilename, VARIANT vFlags);
  int UnusedSelPrint(int lHDC);
  int get_SelTabs(short sElement, out VARIANT pvarSelTab);
  int put_SelTabs(short sElement, VARIANT pvarSelTab);
  int Span(wchar* bstrCharacterSet, VARIANT vForward, VARIANT vNegate);
  int UpTo(wchar* bstrCharacterSet, VARIANT vForward, VARIANT vNegate);
  int OLEDrag();
  int SelPrint(int lHDC, VARIANT vStartDoc);
}

interface DRichTextEvents : IDispatch {
  mixin(uuid("3b7c8862-d78f-101b-b9b5-04021c009402"));
  /+void Change();+/
  /+void Click();+/
  /+void DblClick();+/
  /+void KeyDown(short* KeyCode, short Shift);+/
  /+void KeyUp(short* KeyCode, short Shift);+/
  /+void KeyPress(short* KeyAscii);+/
  /+void MouseDown(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+void MouseMove(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+void MouseUp(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+void SelChange();+/
  /+void OLEStartDrag(ref DataObject Data, ref int AllowedEffects);+/
  /+void OLEGiveFeedback(ref int Effect, ref short DefaultCursors);+/
  /+void OLESetData(ref DataObject Data, ref short DataFormat);+/
  /+void OLECompleteDrag(ref int Effect);+/
  /+void OLEDragOver(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float x, ref float y, ref short State);+/
  /+void OLEDragDrop(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float x, ref float y);+/
}

abstract final class RichTextBox {
  mixin(uuid("3b7c8860-d78f-101b-b9b5-04021c009402"));
  mixin Interfaces!(IRichText);
}

abstract final class OLEObjects {
  mixin(uuid("4a8f35a0-d900-11cf-89b4-00aa00688b10"));
  mixin Interfaces!(IOLEObjects);
}

abstract final class OLEObject {
  mixin(uuid("4a8f35a1-d900-11cf-89b4-00aa00688b10"));
  mixin Interfaces!(IOLEObject);
}
