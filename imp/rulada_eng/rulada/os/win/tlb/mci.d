module os.win.tlb.mci;

private import os.win.com.core;

enum ErrorConstants {
  mciInvalidPropertyValue = 0x0000017C,
  mciGetNotSupported = 0x0000018A,
  mciSetNotSupported = 0x0000017F,
  mciInvalidProcedureCall = 0x00000005,
  mciInvalidObjectUse = 0x000001A9,
  mciWrongClipboardFormat = 0x000001CD,
  mciDataObjectLocked = 0x000002A0,
  mciExpectedAnArgument = 0x000002A1,
  mciRecursiveOleDrag = 0x000002A2,
  mciFormatNotByteArray = 0x000002A3,
  mciDataNotSetForFormat = 0x000002A4,
  mciCantCreateButton = 0x00007531,
  mciCantCreateTimer = 0x00007532,
  mciUnsupportedFunction = 0x00007534,
}

enum BorderStyleConstants {
  mciNone = 0x00000000,
  mciFixedSingle = 0x00000001,
}

enum RecordModeConstants {
  mciRecordInsert = 0x00000000,
  mciRecordOverwrite = 0x00000001,
}

enum MousePointerConstants {
  mciDefault = 0x00000000,
  mciArrow = 0x00000001,
  mciCross = 0x00000002,
  mciIBeam = 0x00000003,
  mciIcon = 0x00000004,
  mciSize = 0x00000005,
  mciSizeNESW = 0x00000006,
  mciSizeNS = 0x00000007,
  mciSizeNWSE = 0x00000008,
  mciSizeEW = 0x00000009,
  mciUpArrow = 0x0000000A,
  mciHourglass = 0x0000000B,
  mciNoDrop = 0x0000000C,
  mciArrowHourglass = 0x0000000D,
  mciArrowQuestion = 0x0000000E,
  mciSizeAll = 0x0000000F,
  mciCustom = 0x00000063,
}

enum ModeConstants {
  mciModeNotOpen = 0x0000020C,
  mciModeStop = 0x0000020D,
  mciModePlay = 0x0000020E,
  mciModeRecord = 0x0000020F,
  mciModeSeek = 0x00000210,
  mciModePause = 0x00000211,
  mciModeReady = 0x00000212,
}

enum NotifyConstants {
  mciNotifySuccessful = 0x00000001,
  mciNotifySuperseded = 0x00000002,
  mciAborted = 0x00000004,
  mciFailure = 0x00000008,
}

enum OrientationConstants {
  mciOrientHorz = 0x00000000,
  mciOrientVert = 0x00000001,
}

enum FormatConstants {
  mciFormatMilliseconds = 0x00000000,
  mciFormatHms = 0x00000001,
  mciFormatMsf = 0x00000002,
  mciFormatFrames = 0x00000003,
  mciFormatSmpte24 = 0x00000004,
  mciFormatSmpte25 = 0x00000005,
  mciFormatSmpte30 = 0x00000006,
  mciFormatSmpte30Drop = 0x00000007,
  mciFormatBytes = 0x00000008,
  mciFormatSamples = 0x00000009,
  mciFormatTmsf = 0x0000000A,
}

enum OLEDropConstants {
  mciOLEDropNone = 0x00000000,
  mciOLEDropManual = 0x00000001,
}

enum DragOverConstants {
  mciEnter = 0x00000000,
  mciLeave = 0x00000001,
  mciOver = 0x00000002,
}

enum ClipBoardConstants {
  mciCFText = 0x00000001,
  mciCFBitmap = 0x00000002,
  mciCFMetafile = 0x00000003,
  mciCFDIB = 0x00000008,
  mciCFPalette = 0x00000009,
  mciCFEMetafile = 0x0000000E,
  mciCFFiles = 0x0000000F,
  mciCFRTF = 0xFFFFBF01,
}

enum OLEDropEffectConstants {
  mciOLEDropEffectNone = 0x00000000,
  mciOLEDropEffectCopy = 0x00000001,
  mciOLEDropEffectMove = 0x00000002,
  mciOLEDropEffectScroll = 0x80000000,
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

interface Imci : IDispatch {
  mixin(uuid("b7abc220-df71-11cf-8e74-00a0c90f26f8"));
  int get_DeviceType(out wchar* pbstrType);
  int put_DeviceType(wchar* pbstrType);
  int get_AutoEnable(out short pfEnable);
  int put_AutoEnable(short pfEnable);
  int get_PrevVisible(out short pfVisible);
  int put_PrevVisible(short pfVisible);
  int get_NextVisible(out short pfVisible);
  int put_NextVisible(short pfVisible);
  int get_PlayVisible(out short pfVisible);
  int put_PlayVisible(short pfVisible);
  int get_PauseVisible(out short pfVisible);
  int put_PauseVisible(short pfVisible);
  int get_BackVisible(out short pfVisible);
  int put_BackVisible(short pfVisible);
  int get_StepVisible(out short pfVisible);
  int put_StepVisible(short pfVisible);
  int get_StopVisible(out short pfVisible);
  int put_StopVisible(short pfVisible);
  int get_RecordVisible(out short pfVisible);
  int put_RecordVisible(short pfVisible);
  int get_EjectVisible(out short pfVisible);
  int put_EjectVisible(short pfVisible);
  int get_PrevEnabled(out short pfEnabled);
  int put_PrevEnabled(short pfEnabled);
  int get_NextEnabled(out short pfEnabled);
  int put_NextEnabled(short pfEnabled);
  int get_PlayEnabled(out short pfEnabled);
  int put_PlayEnabled(short pfEnabled);
  int get_PauseEnabled(out short pfEnabled);
  int put_PauseEnabled(short pfEnabled);
  int get_BackEnabled(out short pfEnabled);
  int put_BackEnabled(short pfEnabled);
  int get_StepEnabled(out short pfEnabled);
  int put_StepEnabled(short pfEnabled);
  int get_StopEnabled(out short pfEnabled);
  int put_StopEnabled(short pfEnabled);
  int get_RecordEnabled(out short pfEnabled);
  int put_RecordEnabled(short pfEnabled);
  int get_EjectEnabled(out short pfEnabled);
  int put_EjectEnabled(short pfEnabled);
  int get_FileName(out wchar* pbstrName);
  int put_FileName(wchar* pbstrName);
  int get_Command(out wchar* pbstrCmd);
  int put_Command(wchar* pbstrCmd);
  int get_Notify(out short pfNotify);
  int put_Notify(short pfNotify);
  int get_Wait(out short pfWait);
  int put_Wait(short pfWait);
  int get_Shareable(out short pfShare);
  int put_Shareable(short pfShare);
  int get_Orientation(out OrientationConstants peOrientation);
  int put_Orientation(OrientationConstants peOrientation);
  int get_ErrorMessage(out wchar* pbstrMsg);
  int put_ErrorMessage(wchar* pbstrMsg);
  int get_From(out int plFrom);
  int put_From(int plFrom);
  int get_To(out int plTo);
  int put_To(int plTo);
  int get_CanEject(out short pfCanEject);
  int put_CanEject(short pfCanEject);
  int get_CanPlay(out short pfCanPlay);
  int put_CanPlay(short pfCanPlay);
  int get_CanRecord(out short pfCanRecord);
  int put_CanRecord(short pfCanRecord);
  int get_CanStep(out short pfCanStep);
  int put_CanStep(short pfCanStep);
  int get_Mode(out int plMode);
  int put_Mode(int plMode);
  int get_Length(out int plLength);
  int put_Length(int plLength);
  int get_Position(out int plPosition);
  int put_Position(int plPosition);
  int get_Start(out int plStart);
  int put_Start(int plStart);
  int get_TimeFormat(out int plTimeFormat);
  int put_TimeFormat(int plTimeFormat);
  int get_Silent(out short pfSilent);
  int put_Silent(short pfSilent);
  int get_Track(out int plTrack);
  int put_Track(int plTrack);
  int get_Tracks(out int plTracks);
  int put_Tracks(int plTracks);
  int get_TrackLength(out int plTrackLength);
  int put_TrackLength(int plTrackLength);
  int get_TrackPosition(out int plTrackPosition);
  int put_TrackPosition(int plTrackPosition);
  int get_UpdateInterval(out short psUpdateInterval);
  int put_UpdateInterval(short psUpdateInterval);
  int get_UsesWindows(out short pfUsesWindows);
  int put_UsesWindows(short pfUsesWindows);
  int get_Frames(out int plFrames);
  int put_Frames(int plFrames);
  int get_RecordMode(out RecordModeConstants peRecordMode);
  int put_RecordMode(RecordModeConstants peRecordMode);
  int get_hWndDisplay(out int plhWndDisplay);
  int put_hWndDisplay(int plhWndDisplay);
  int get_NotifyValue(out short psNotifyValue);
  int put_NotifyValue(short psNotifyValue);
  int get_NotifyMessage(out wchar* pbstrMsg);
  int put_NotifyMessage(wchar* pbstrMsg);
  int get_Enabled(out short pfEnabled);
  int put_Enabled(short pfEnabled);
  int get_BorderStyle(out BorderStyleConstants peBorderStyle);
  int put_BorderStyle(BorderStyleConstants peBorderStyle);
  int get_Error(out short psError);
  int put_Error(short psError);
  int get_DeviceID(out short psDeviceID);
  int put_DeviceID(short psDeviceID);
  int get_MousePointer(out MousePointerConstants peMousePointer);
  int put_MousePointer(MousePointerConstants peMousePointer);
  int get_MouseIcon(out IPictureDisp ppMouseIcon);
  int putref_MouseIcon(IPictureDisp* ppMouseIcon);
  int get_hWnd(out OLE_HANDLE phWnd);
  int put_hWnd(OLE_HANDLE phWnd);
  int get__Command(out wchar* pbstrCommand);
  int put__Command(wchar* pbstrCommand);
  int get_OLEDropMode(out OLEDropConstants psOLEDropMode);
  int put_OLEDropMode(OLEDropConstants psOLEDropMode);
  int AboutBox();
  int Refresh();
  int OLEDrag();
}

interface DmciEvents : IDispatch {
  mixin(uuid("c1a8af27-1257-101b-8fb0-0020af039ca3"));
  /+void Done(short* NotifyCode);+/
  /+void BackClick(short* Cancel);+/
  /+void PrevClick(short* Cancel);+/
  /+void NextClick(short* Cancel);+/
  /+void PlayClick(short* Cancel);+/
  /+void PauseClick(short* Cancel);+/
  /+void StepClick(short* Cancel);+/
  /+void StopClick(short* Cancel);+/
  /+void RecordClick(short* Cancel);+/
  /+void EjectClick(short* Cancel);+/
  /+void PrevGotFocus();+/
  /+void PrevLostFocus();+/
  /+void NextGotFocus();+/
  /+void NextLostFocus();+/
  /+void PlayGotFocus();+/
  /+void PlayLostFocus();+/
  /+void PauseGotFocus();+/
  /+void PauseLostFocus();+/
  /+void BackGotFocus();+/
  /+void BackLostFocus();+/
  /+void StepGotFocus();+/
  /+void StepLostFocus();+/
  /+void StopLostFocus();+/
  /+void StopGotFocus();+/
  /+void RecordGotFocus();+/
  /+void RecordLostFocus();+/
  /+void EjectGotFocus();+/
  /+void EjectLostFocus();+/
  /+void StatusUpdate();+/
  /+void NextCompleted(int* Errorcode);+/
  /+void PlayCompleted(int* Errorcode);+/
  /+void PauseCompleted(int* Errorcode);+/
  /+void BackCompleted(int* Errorcode);+/
  /+void StepCompleted(int* Errorcode);+/
  /+void StopCompleted(int* Errorcode);+/
  /+void RecordCompleted(int* Errorcode);+/
  /+void EjectCompleted(int* Errorcode);+/
  /+void PrevCompleted(int* Errorcode);+/
  /+void OLEStartDrag(ref DataObject Data, ref int AllowedEffects);+/
  /+void OLEGiveFeedback(ref int Effect, ref short DefaultCursors);+/
  /+void OLESetData(ref DataObject Data, ref short DataFormat);+/
  /+void OLECompleteDrag(ref int Effect);+/
  /+void OLEDragOver(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float X, ref float Y, ref short State);+/
  /+void OLEDragDrop(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float X, ref float Y);+/
}

abstract final class MMControl {
  mixin(uuid("c1a8af25-1257-101b-8fb0-0020af039ca3"));
  mixin Interfaces!(Imci);
}
