module os.win.tlb.msmask;

private import os.win.com.core;

enum OLEDragConstants {
  mskOLEDragManual = 0x00000000,
  mskOLEDragAutomatic = 0x00000001,
}

enum OLEDropConstants {
  mskOLEDropNone = 0x00000000,
  mskOLEDropManual = 0x00000001,
  mskOLEDropAutomatic = 0x00000002,
}

enum DragOverConstants {
  mskEnter = 0x00000000,
  mskLeave = 0x00000001,
  mskOver = 0x00000002,
}

enum ClipBoardConstants {
  mskCFText = 0x00000001,
  mskCFBitmap = 0x00000002,
  mskCFMetafile = 0x00000003,
  mskCFDIB = 0x00000008,
  mskCFPalette = 0x00000009,
  mskCFEMetafile = 0x0000000E,
  mskCFFiles = 0x0000000F,
  mskCFRTF = 0xFFFFBF01,
}

enum OLEDropEffectConstants {
  mskOLEDropEffectNone = 0x00000000,
  mskOLEDropEffectCopy = 0x00000001,
  mskOLEDropEffectMove = 0x00000002,
  mskOLEDropEffectScroll = 0x80000000,
}

enum ErrorConstants {
  mskInvalidPropertyValue = 0x0000017C,
  mskGetNotSupported = 0x0000018A,
  mskSetNotSupported = 0x0000017F,
  mskInvalidProcedureCall = 0x00000005,
  mskInvalidObjectUse = 0x000001A9,
  mskWrongClipboardFormat = 0x000001CD,
  mskDataObjectLocked = 0x000002A0,
  mskExpectedAnArgument = 0x000002A1,
  mskRecursiveOleDrag = 0x000002A2,
  mskFormatNotByteArray = 0x000002A3,
  mskDataNotSetForFormat = 0x000002A4,
}

enum BorderStyleConstants {
  mskNone = 0x00000000,
  mskFixedSingle = 0x00000001,
}

enum AppearanceConstants {
  mskFlat = 0x00000000,
  mskThreeD = 0x00000001,
}

enum ClipModeConstants {
  mskIncludeLiterals = 0x00000000,
  mskExcludeLiterals = 0x00000001,
}

enum MousePointerConstants {
  mskDefault = 0x00000000,
  mskArrow = 0x00000001,
  mskCross = 0x00000002,
  mskIBeam = 0x00000003,
  mskIcon = 0x00000004,
  mskSize = 0x00000005,
  mskSizeNESW = 0x00000006,
  mskSizeNS = 0x00000007,
  mskSizeNWSE = 0x00000008,
  mskSizeEW = 0x00000009,
  mskUpArrow = 0x0000000A,
  mskHourglass = 0x0000000B,
  mskNoDrop = 0x0000000C,
  mskArrowHourglass = 0x0000000D,
  mskArrowQuestion = 0x0000000E,
  mskSizeAll = 0x0000000F,
  mskCustom = 0x00000063,
}

enum FormatConstants {
  mskDefaultFormat = 0x00000000,
  mskZero = 0x00000001,
  mskFloatInteger = 0x00000002,
  mskPercent = 0x00000003,
  mskExponential = 0x00000004,
  mskc = 0x00000005,
  mskdddddd = 0x00000006,
  mskddmmyy = 0x00000007,
  mskddddd = 0x00000008,
  mskttttt = 0x00000009,
  mskhhmmAMPM = 0x0000000A,
  mskhhmm = 0x0000000B,
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

interface IMSMask : IDispatch {
  mixin(uuid("4d6cc9a0-df77-11cf-8e74-00a0c90f26f8"));
  int get_ClipMode(out ClipModeConstants peClipMode);
  int put_ClipMode(ClipModeConstants peClipMode);
  int get_PromptInclude(out short pbInclude);
  int put_PromptInclude(short pbInclude);
  int get_AllowPrompt(out short pbAllow);
  int put_AllowPrompt(short pbAllow);
  int get_AutoTab(out short pbAuto);
  int put_AutoTab(short pbAuto);
  int get_MousePointer(out MousePointerConstants peMousePointer);
  int put_MousePointer(MousePointerConstants peMousePointer);
  int get_FontBold(out short pbBold);
  int put_FontBold(short pbBold);
  int get_FontItalic(out short pbItalic);
  int put_FontItalic(short pbItalic);
  int get_FontName(out wchar* pbstrName);
  int put_FontName(wchar* pbstrName);
  int get_FontSize(out float pfSize);
  int put_FontSize(float pfSize);
  int get_FontStrikethru(out short pbStrikethru);
  int put_FontStrikethru(short pbStrikethru);
  int get_FontUnderline(out short pbUnderline);
  int put_FontUnderline(short pbUnderline);
  int get_HideSelection(out short pbHide);
  int put_HideSelection(short pbHide);
  int get_MaxLength(out short psMaxLen);
  int put_MaxLength(short psMaxLen);
  int get_Format(out wchar* pbstrFormat);
  int put_Format(wchar* pbstrFormat);
  int get_Mask(out wchar* pbstrMask);
  int put_Mask(wchar* pbstrMask);
  int get_FormattedText(out wchar* pbstrFormat);
  int put_FormattedText(wchar* pbstrFormat);
  int get_SelLength(out int plSelLength);
  int put_SelLength(int plSelLength);
  int get_SelStart(out int plSelStart);
  int put_SelStart(int plSelStart);
  int get_SelText(out wchar* pbstrText);
  int put_SelText(wchar* pbstrText);
  int get_ClipText(out wchar* pbstrText);
  int put_ClipText(wchar* pbstrText);
  int get_PromptChar(out wchar* pbstrChar);
  int put_PromptChar(wchar* pbstrChar);
  int get_defaultText(out wchar* pbstrText);
  int put_defaultText(wchar* pbstrText);
  int get_Text(out wchar* pbstrText);
  int put_Text(wchar* pbstrText);
  int get_MouseIcon(out IPictureDisp ppMouseIcon);
  int put_MouseIcon(IPictureDisp* ppMouseIcon);
  int putref_MouseIcon(IPictureDisp* ppMouseIcon);
  int get_Appearance(out AppearanceConstants peAppearance);
  int put_Appearance(AppearanceConstants peAppearance);
  int get_BackColor(out OLE_COLOR pocBackColor);
  int put_BackColor(OLE_COLOR pocBackColor);
  int get_Font(out IFontDisp ppFont);
  int putref_Font(IFontDisp* ppFont);
  int get_ForeColor(out OLE_COLOR pocForeColor);
  int put_ForeColor(OLE_COLOR pocForeColor);
  int get_Enabled(out short pbEnabled);
  int put_Enabled(short pbEnabled);
  int get_hWnd(out OLE_HANDLE phWnd);
  int put_hWnd(OLE_HANDLE phWnd);
  int get_BorderStyle(out BorderStyleConstants peBorderStyle);
  int put_BorderStyle(BorderStyleConstants peBorderStyle);
  int get_OLEDragMode(out OLEDragConstants psOLEDragMode);
  int put_OLEDragMode(OLEDragConstants psOLEDragMode);
  int get_OLEDropMode(out OLEDropConstants psOLEDropMode);
  int put_OLEDropMode(OLEDropConstants psOLEDropMode);
  void AboutBox();
  void Refresh();
  int OLEDrag();
}

interface MaskEdBoxEvents : IDispatch {
  mixin(uuid("c932ba87-4374-101b-a56c-00aa003668dc"));
  /+void Change();+/
  /+void ValidationError(wchar** InvalidText, short* StartPosition);+/
  /+void KeyDown(short KeyCode, short Shift);+/
  /+void KeyPress(short* KeyAscii);+/
  /+void KeyUp(short KeyCode, short Shift);+/
  /+void OLEStartDrag(ref DataObject Data, ref int AllowedEffects);+/
  /+void OLEGiveFeedback(ref int Effect, ref short DefaultCursors);+/
  /+void OLESetData(ref DataObject Data, ref short DataFormat);+/
  /+void OLECompleteDrag(ref int Effect);+/
  /+void OLEDragOver(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float X, ref float Y, ref short State);+/
  /+void OLEDragDrop(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float X, ref float Y);+/
}

abstract final class MaskEdBox {
  mixin(uuid("c932ba85-4374-101b-a56c-00aa003668dc"));
  mixin Interfaces!(IMSMask);
}
