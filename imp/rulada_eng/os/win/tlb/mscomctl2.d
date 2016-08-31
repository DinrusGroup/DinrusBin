module os.win.tlb.mscomctl2;

private import os.win.com.core;

enum OLEDropConstants {
  cc2OLEDropNone = 0x00000000,
  cc2OLEDropManual = 0x00000001,
}

enum DragOverConstants {
  cc2Enter = 0x00000000,
  cc2Leave = 0x00000001,
  cc2Over = 0x00000002,
}

enum ClipBoardConstants {
  cc2CFText = 0x00000001,
  cc2CFBitmap = 0x00000002,
  cc2CFMetafile = 0x00000003,
  cc2CFDIB = 0x00000008,
  cc2CFPalette = 0x00000009,
  cc2CFEMetafile = 0x0000000E,
  cc2CFFiles = 0x0000000F,
  cc2CFRTF = 0xFFFFBF01,
}

enum OLEDropEffectConstants {
  cc2OLEDropEffectNone = 0x00000000,
  cc2OLEDropEffectCopy = 0x00000001,
  cc2OLEDropEffectMove = 0x00000002,
  cc2OLEDropEffectScroll = 0x80000000,
}

enum ErrorConstants {
  cc2BadFileNameOrNumber = 0x00000034,
  cc2FileNotFound = 0x00000035,
  cc2InvalidPropertyValue = 0x0000017C,
  cc2SetNotSupportedAtRuntime = 0x0000017E,
  cc2SetNotSupported = 0x0000017F,
  cc2GetNotSupported = 0x0000018A,
  cc2DataObjectLocked = 0x000002A0,
  cc2ExpectedAnArgument = 0x000002A1,
  cc2InvalidProcedureCall = 0x00000005,
  cc2InvalidObjectUse = 0x000001A9,
  cc2WrongClipboardFormat = 0x000001CD,
  cc2RecursiveOleDrag = 0x000002A2,
  cc2FormatNotByteArray = 0x000002A3,
  cc2DataNotSetForFormat = 0x000002A4,
  cc2InconsistentObject = 0x00008BA6,
  cc2ErrorDuringSet = 0x00008BA7,
  cc2ErrorOpeningVideo = 0x00008BA8,
  cc2ErrorPlayingVideo = 0x00008BA9,
  cc2VideoNotOpen = 0x00008BAB,
  cc2ErrorStoppingVideo = 0x00008BAD,
  cc2ErrorClosingVideo = 0x00008BAE,
  cc2CantStopAutoPlay = 0x00008BAF,
  cc2NoValidBuddyCtl = 0x00008BAA,
  cc2AutoBuddyNotSet = 0x00008BAC,
  cc2BuddyNotASibling = 0x00008BB0,
  cc2NoUpDownAsBuddy = 0x00008BB1,
  cc2InvalidRange = 0x00008BBA,
  cc2InvalidMaxDate = 0x00008BBB,
  cc2InvalidMinDate = 0x00008BBC,
  cc2DateOutOfRange = 0x00008BBD,
  cc2InvalidMaxDateMin = 0x00008BBE,
  cc2InvalidMinDateMax = 0x00008BBF,
  cc2InvalidRowColValue = 0x00008BC0,
  cc2InvalidRowColTotal = 0x00008BC1,
  cc2MonthViewError = 0x00008BC2,
  cc2SetDayMultiSelectOn = 0x00008BC3,
  cc2SetDayOfWeekMultiSelectOn = 0x00008BC4,
  cc2SetMonthMultiSelectOn = 0x00008BC5,
  cc2SetWeekMultiSelectOn = 0x00008BC6,
  cc2SetYearMultiSelectOn = 0x00008BC7,
  cc2SetMaxSelCountMultiSelectOff = 0x00008BC8,
  cc2SetSelEndMultiSelectOff = 0x00008BC9,
  cc2SetSelStartMultiSelectOff = 0x00008BCA,
  cc2NullValueNotAllowed = 0x00008BCB,
  cc2DTPickerError = 0x00008BCC,
  cc2ScrollValueOutOfRange = 0x00008BCD,
}

enum AppearanceConstants {
  cc2Flat = 0x00000000,
  cc23D = 0x00000001,
}

enum BorderStyleConstants {
  cc2None = 0x00000000,
  cc2FixedSingle = 0x00000001,
}

enum MousePointerConstants {
  cc2Default = 0x00000000,
  cc2Arrow = 0x00000001,
  cc2Cross = 0x00000002,
  cc2IBeam = 0x00000003,
  cc2Icon = 0x00000004,
  cc2Size = 0x00000005,
  cc2SizeNESW = 0x00000006,
  cc2SizeNS = 0x00000007,
  cc2SizeNWSE = 0x00000008,
  cc2SizeEW = 0x00000009,
  cc2UpArrow = 0x0000000A,
  cc2Hourglass = 0x0000000B,
  cc2NoDrop = 0x0000000C,
  cc2ArrowHourglass = 0x0000000D,
  cc2ArrowQuestion = 0x0000000E,
  cc2SizeAll = 0x0000000F,
  cc2Custom = 0x00000063,
}

enum OrientationConstants {
  cc2OrientationVertical = 0x00000000,
  cc2OrientationHorizontal = 0x00000001,
}

enum BackStyleConstants {
  cc2BackstyleTransparent = 0x00000000,
  cc2BackstyleOpaque = 0x00000001,
}

enum AlignmentConstants {
  cc2AlignmentLeft = 0x00000000,
  cc2AlignmentRight = 0x00000001,
}

enum DayConstants {
  mvwSunday = 0x00000001,
  mvwMonday = 0x00000002,
  mvwTuesday = 0x00000003,
  mvwWednesday = 0x00000004,
  mvwThursday = 0x00000005,
  mvwFriday = 0x00000006,
  mvwSaturday = 0x00000007,
}

enum MonthConstants {
  mvwJanuary = 0x00000001,
  mvwFebruary = 0x00000002,
  mvwMarch = 0x00000003,
  mvwApril = 0x00000004,
  mvwMay = 0x00000005,
  mvwJune = 0x00000006,
  mvwJuly = 0x00000007,
  mvwAugust = 0x00000008,
  mvwSeptember = 0x00000009,
  mvwOctober = 0x0000000A,
  mvwNovember = 0x0000000B,
  mvwDecember = 0x0000000C,
}

enum MonthViewHitTestAreas {
  mvwCalendarBack = 0x00000000,
  mvwCalendarDate = 0x00000001,
  mvwCalendarDateNext = 0x00000002,
  mvwCalendarDatePrev = 0x00000003,
  mvwCalendarDay = 0x00000004,
  mvwCalendarWeekNum = 0x00000005,
  mvwNoWhere = 0x00000006,
  mvwTitleBack = 0x00000007,
  mvwTitleBtnNext = 0x00000008,
  mvwTitleBtnPrev = 0x00000009,
  mvwTitleMonth = 0x0000000A,
  mvwTitleYear = 0x0000000B,
  mvwTodayLink = 0x0000000C,
}

enum FormatConstants {
  dtpLongDate = 0x00000000,
  dtpShortDate = 0x00000001,
  dtpTime = 0x00000002,
  dtpCustom = 0x00000003,
}

enum FlatScrollBarAppearanceConstants {
  fsb3D = 0x00000000,
  fsbFlat = 0x00000001,
  fsbTrack3D = 0x00000002,
}

enum ArrowsConstants {
  cc2Both = 0x00000000,
  cc2LeftUp = 0x00000001,
  cc2RightDown = 0x00000002,
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

interface IAnimation : IDispatch {
  mixin(uuid("b09de713-87c1-11d1-8be3-0000f8754da1"));
  int put_AutoPlay(short pfAutoPlay);
  int get_AutoPlay(out short pfAutoPlay);
  int put_BackStyle(BackStyleConstants penumBackStyle);
  int get_BackStyle(out BackStyleConstants penumBackStyle);
  int put_Center(short pfCenter);
  int get_Center(out short pfCenter);
  int put_Enabled(short pfEnable);
  int get_Enabled(out short pfEnable);
  int get_hWnd(out OLE_HANDLE phWnd);
  int put_BackColor(OLE_COLOR pocBackColor);
  int get_BackColor(out OLE_COLOR pocBackColor);
  int get_OLEDropMode(out OLEDropConstants psOLEDropMode);
  int put_OLEDropMode(OLEDropConstants psOLEDropMode);
  int Close();
  int Open(wchar* bstrFilename);
  int Play(VARIANT varRepeatCount, VARIANT varStartFrame, VARIANT varEndFrame);
  int Stop();
  void AboutBox();
  int OLEDrag();
}

interface DAnimationEvents : IDispatch {
  mixin(uuid("b09de714-87c1-11d1-8be3-0000f8754da1"));
  /+void Click();+/
  /+void DblClick();+/
  /+void MouseDown(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+void MouseMove(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+void MouseUp(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+void OLEStartDrag(ref DataObject Data, ref int AllowedEffects);+/
  /+void OLEGiveFeedback(ref int Effect, ref short DefaultCursors);+/
  /+void OLESetData(ref DataObject Data, ref short DataFormat);+/
  /+void OLECompleteDrag(ref int Effect);+/
  /+void OLEDragOver(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float x, ref float y, ref short State);+/
  /+void OLEDragDrop(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float x, ref float y);+/
}

interface IUpDown : IDispatch {
  mixin(uuid("603c7e7e-87c2-11d1-8be3-0000f8754da1"));
  int put_Value(int plValue);
  int get_Value(out int plValue);
  int put_Acceleration(short psAcceleration);
  int get_Acceleration(out short psAcceleration);
  int put_Alignment(AlignmentConstants penumAlignment);
  int get_Alignment(out AlignmentConstants penumAlignment);
  int put_AutoBuddy(short pfAutoBuddy);
  int get_AutoBuddy(out short pfAutoBuddy);
  int put_BuddyControl(VARIANT pvarBuddyCtl);
  int putref_BuddyControl(VARIANT pvarBuddyCtl);
  int get_BuddyControl(out VARIANT pvarBuddyCtl);
  int put_Increment(int plIncrement);
  int get_Increment(out int plIncrement);
  int put_Max(int plMax);
  int get_Max(out int plMax);
  int put_Min(int plMin);
  int get_Min(out int plMin);
  int put_Orientation(OrientationConstants penumOrientation);
  int get_Orientation(out OrientationConstants penumOrientation);
  int put_SyncBuddy(short pfSyncBuddy);
  int get_SyncBuddy(out short pfSyncBuddy);
  int put_Wrap(short pfWrap);
  int get_Wrap(out short pfWrap);
  int put_BuddyProperty(VARIANT pvarDispidBuddyProperty);
  int get_BuddyProperty(out VARIANT pvarDispidBuddyProperty);
  int put_Enabled(short pfEnable);
  int get_Enabled(out short pfEnable);
  int get_hWnd(out OLE_HANDLE phWnd);
  int get_OLEDropMode(out OLEDropConstants psOLEDropMode);
  int put_OLEDropMode(OLEDropConstants psOLEDropMode);
  void AboutBox();
  int OLEDrag();
}

interface DUpDownEvents : IDispatch {
  mixin(uuid("603c7e7f-87c2-11d1-8be3-0000f8754da1"));
  /+void Change();+/
  /+void DownClick();+/
  /+void UpClick();+/
  /+void MouseDown(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+void MouseMove(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+void MouseUp(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+void OLEStartDrag(ref DataObject Data, ref int AllowedEffects);+/
  /+void OLEGiveFeedback(ref int Effect, ref short DefaultCursors);+/
  /+void OLESetData(ref DataObject Data, ref short DataFormat);+/
  /+void OLECompleteDrag(ref int Effect);+/
  /+void OLEDragOver(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float x, ref float y, ref short State);+/
  /+void OLEDragDrop(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float x, ref float y);+/
}

interface IMonthView : IDispatch {
  mixin(uuid("232e4565-87c3-11d1-8be3-0000f8754da1"));
  int get_Appearance(out AppearanceConstants penumAppearances);
  int put_Appearance(AppearanceConstants penumAppearances);
  int get_BackColor(out OLE_COLOR pclrBackColor);
  int put_BackColor(OLE_COLOR pclrBackColor);
  int get_BorderStyle(out BorderStyleConstants psBorderStyle);
  int put_BorderStyle(BorderStyleConstants psBorderStyle);
  int get_Day(out short psDay);
  int put_Day(short psDay);
  int get_DayBold(double dateIndex, out short pbDayBold);
  int put_DayBold(double dateIndex, short pbDayBold);
  int get_DayOfWeek(out DayConstants penumDayOfWeek);
  int put_DayOfWeek(DayConstants penumDayOfWeek);
  int get_Enabled(out short pbEnabled);
  int put_Enabled(short pbEnabled);
  int get_Font(out IFontDisp ppFont);
  int put_Font(IFontDisp* ppFont);
  int putref_Font(IFontDisp* ppFont);
  int get_ForeColor(out OLE_COLOR pclrForeColor);
  int put_ForeColor(OLE_COLOR pclrForeColor);
  int get_hWnd(out OLE_HANDLE phWnd);
  int put_hWnd(OLE_HANDLE phWnd);
  int get_MaxDate(out double pdateMaxDate);
  int put_MaxDate(double pdateMaxDate);
  int get_MaxSelCount(out short psMaxSelCount);
  int put_MaxSelCount(short psMaxSelCount);
  int get_MinDate(out double pdateMinDate);
  int put_MinDate(double pdateMinDate);
  int get_Month(out MonthConstants psMonth);
  int put_Month(MonthConstants psMonth);
  int get_MonthBackColor(out OLE_COLOR pclrMonthBackColor);
  int put_MonthBackColor(OLE_COLOR pclrMonthBackColor);
  int get_MonthColumns(out short psMonthColumns);
  int put_MonthColumns(short psMonthColumns);
  int get_MonthRows(out short psMonthRows);
  int put_MonthRows(short psMonthRows);
  int get_MouseIcon(out IPictureDisp ppMouseIcon);
  int put_MouseIcon(IPictureDisp* ppMouseIcon);
  int putref_MouseIcon(IPictureDisp* ppMouseIcon);
  int get_MousePointer(out MousePointerConstants psMousePointer);
  int put_MousePointer(MousePointerConstants psMousePointer);
  int get_MultiSelect(out short pbMultiSelect);
  int put_MultiSelect(short pbMultiSelect);
  int get_OLEDropMode(out OLEDropConstants psOLEDropMode);
  int put_OLEDropMode(OLEDropConstants psOLEDropMode);
  int get_ScrollRate(out short psScrollRate);
  int put_ScrollRate(short psScrollRate);
  int get_SelEnd(out double pdateSelEnd);
  int put_SelEnd(double pdateSelEnd);
  int get_SelStart(out double pdateSelStart);
  int put_SelStart(double pdateSelStart);
  int get_ShowToday(out short pbShowToday);
  int put_ShowToday(short pbShowToday);
  int get_ShowWeekNumbers(out short pbShowWeekNumbers);
  int put_ShowWeekNumbers(short pbShowWeekNumbers);
  int get_StartOfWeek(out DayConstants penumStartOfWeek);
  int put_StartOfWeek(DayConstants penumStartOfWeek);
  int get_TitleBackColor(out OLE_COLOR pclrTitleBackColor);
  int put_TitleBackColor(OLE_COLOR pclrTitleBackColor);
  int get_TitleForeColor(out OLE_COLOR pclrTitleForeColor);
  int put_TitleForeColor(OLE_COLOR pclrTitleForeColor);
  int get_TrailingForeColor(out OLE_COLOR pclrTrailingForeColor);
  int put_TrailingForeColor(OLE_COLOR pclrTrailingForeColor);
  int get_Value(out double pdateValue);
  int put_Value(double pdateValue);
  int get__Value(out double pdateValue);
  int put__Value(double pdateValue);
  int get_VisibleDays(short sIndex, out double pdateVisibleDays);
  int put_VisibleDays(short sIndex, double pdateVisibleDays);
  int get_Week(out short psWeek);
  int put_Week(short psWeek);
  int get_Year(out short psYear);
  int put_Year(short psYear);
  int AboutBox();
  int ComputeControlSize(short Rows, short Columns, out float Width, out float Height);
  int HitTest(int x, int y, out double Date, out MonthViewHitTestAreas enumHitTestArea);
  int OLEDrag();
  int Refresh();
}

interface DMonthViewEvents : IDispatch {
  mixin(uuid("232e4569-87c3-11d1-8be3-0000f8754da1"));
  /+void DateClick(double DateClicked);+/
  /+void DateDblClick(double DateDblClicked);+/
  /+void GetDayBold(double StartDate, short Count, ref  State);+/
  /+void SelChange(double StartDate, double EndDate, out short Cancel);+/
  /+void Click();+/
  /+void DblClick();+/
  /+void KeyDown(short* KeyCode, short Shift);+/
  /+void KeyUp(short* KeyCode, short Shift);+/
  /+void KeyPress(short* KeyAscii);+/
  /+void MouseDown(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+void MouseMove(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+void MouseUp(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+void OLEStartDrag(ref DataObject Data, ref int AllowedEffects);+/
  /+void OLEGiveFeedback(ref int Effect, ref short DefaultCursors);+/
  /+void OLESetData(ref DataObject Data, ref short DataFormat);+/
  /+void OLECompleteDrag(ref int Effect);+/
  /+void OLEDragOver(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float x, ref float y, ref short State);+/
  /+void OLEDragDrop(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float x, ref float y);+/
}

interface IDTPicker : IDispatch {
  mixin(uuid("20dd1b9b-87c4-11d1-8be3-0000f8754da1"));
  int get_Format(out FormatConstants penumFormat);
  int put_Format(FormatConstants penumFormat);
  int get_CalendarBackColor(out OLE_COLOR pclrCalendarBackColor);
  int put_CalendarBackColor(OLE_COLOR pclrCalendarBackColor);
  int get_CalendarForeColor(out OLE_COLOR pclrCalendarForeColor);
  int put_CalendarForeColor(OLE_COLOR pclrCalendarForeColor);
  int get_CalendarTitleBackColor(out OLE_COLOR pclrTitleBackColor);
  int put_CalendarTitleBackColor(OLE_COLOR pclrTitleBackColor);
  int get_CalendarTitleForeColor(out OLE_COLOR pclrTitleForeColor);
  int put_CalendarTitleForeColor(OLE_COLOR pclrTitleForeColor);
  int get_CalendarTrailingForeColor(out OLE_COLOR pclrTrailingForeColor);
  int put_CalendarTrailingForeColor(OLE_COLOR pclrTrailingForeColor);
  int get_CheckBox(out short pbEnabled);
  int put_CheckBox(short pbEnabled);
  int get_CustomFormat(out wchar* pbstrCustomFormat);
  int put_CustomFormat(wchar* pbstrCustomFormat);
  int get_Day(out VARIANT pvDay);
  int put_Day(VARIANT pvDay);
  int get_DayOfWeek(out VARIANT pvDayOfWeek);
  int put_DayOfWeek(VARIANT pvDayOfWeek);
  int get_Enabled(out short pbEnabled);
  int put_Enabled(short pbEnabled);
  int get_Font(out IFontDisp ppFont);
  int put_Font(IFontDisp* ppFont);
  int putref_Font(IFontDisp* ppFont);
  int get_Hour(out VARIANT pvHour);
  int put_Hour(VARIANT pvHour);
  int get_hWnd(out OLE_HANDLE phWnd);
  int put_hWnd(OLE_HANDLE phWnd);
  int get_MaxDate(out double pdateMaxDate);
  int put_MaxDate(double pdateMaxDate);
  int get_MinDate(out double pdateMinDate);
  int put_MinDate(double pdateMinDate);
  int get_Minute(out VARIANT pvMinute);
  int put_Minute(VARIANT pvMinute);
  int get_Month(out VARIANT pvMonth);
  int put_Month(VARIANT pvMonth);
  int get_MouseIcon(out IPictureDisp ppMouseIcon);
  int put_MouseIcon(IPictureDisp* ppMouseIcon);
  int putref_MouseIcon(IPictureDisp* ppMouseIcon);
  int get_MousePointer(out MousePointerConstants psMousePointer);
  int put_MousePointer(MousePointerConstants psMousePointer);
  int get_OLEDropMode(out OLEDropConstants psOLEDropMode);
  int put_OLEDropMode(OLEDropConstants psOLEDropMode);
  int get_Second(out VARIANT pvSecond);
  int put_Second(VARIANT pvSecond);
  int get_UpDown(out short pbUpDown);
  int put_UpDown(short pbUpDown);
  int get_Value(out VARIANT pvdateValue);
  int put_Value(VARIANT pvdateValue);
  int get__Value(out VARIANT pvdateValue);
  int put__Value(VARIANT pvdateValue);
  int get_Year(out VARIANT pvYear);
  int put_Year(VARIANT pvYear);
  int AboutBox();
  int OLEDrag();
  int Refresh();
}

interface DDTPickerEvents : IDispatch {
  mixin(uuid("20dd1b9d-87c4-11d1-8be3-0000f8754da1"));
  /+void CallbackKeyDown(short KeyCode, short Shift, wchar* CallbackField, ref double CallbackDate);+/
  /+void Change();+/
  /+void CloseUp();+/
  /+void DropDown();+/
  /+void Format(wchar* CallbackField, out wchar* FormattedString);+/
  /+void FormatSize(wchar* CallbackField, out short Size);+/
  /+void Click();+/
  /+void DblClick();+/
  /+void KeyDown(short* KeyCode, short Shift);+/
  /+void KeyUp(short* KeyCode, short Shift);+/
  /+void KeyPress(short* KeyAscii);+/
  /+void MouseDown(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+void MouseMove(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+void MouseUp(short Button, short Shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+void OLEStartDrag(ref DataObject Data, ref int AllowedEffects);+/
  /+void OLEGiveFeedback(ref int Effect, ref short DefaultCursors);+/
  /+void OLESetData(ref DataObject Data, ref short DataFormat);+/
  /+void OLECompleteDrag(ref int Effect);+/
  /+void OLEDragOver(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float x, ref float y, ref short State);+/
  /+void OLEDragDrop(ref DataObject Data, ref int Effect, ref short Button, ref short Shift, ref float x, ref float y);+/
}

interface IFlatSB : IDispatch {
  mixin(uuid("fe387538-44a3-11d1-b5b7-0000c09000c4"));
  int get_Appearance(out FlatScrollBarAppearanceConstants penumAppearance);
  int put_Appearance(FlatScrollBarAppearanceConstants penumAppearance);
  int get_Arrows(out ArrowsConstants penumArrows);
  int put_Arrows(ArrowsConstants penumArrows);
  int get_Enabled(out short pbEnabled);
  int put_Enabled(short pbEnabled);
  int get_hWnd(out OLE_HANDLE phWnd);
  int put_hWnd(OLE_HANDLE phWnd);
  int get_LargeChange(out short psLargeChange);
  int put_LargeChange(short psLargeChange);
  int get_Min(out short psMin);
  int put_Min(short psMin);
  int get_Max(out short psMax);
  int put_Max(short psMax);
  int get_MouseIcon(out IPictureDisp ppMouseIcon);
  int put_MouseIcon(IPictureDisp* ppMouseIcon);
  int putref_MouseIcon(IPictureDisp* ppMouseIcon);
  int get_MousePointer(out MousePointerConstants psMousePointer);
  int put_MousePointer(MousePointerConstants psMousePointer);
  int get_Orientation(out OrientationConstants penumOrientation);
  int put_Orientation(OrientationConstants penumOrientation);
  int get_SmallChange(out short psSmallChange);
  int put_SmallChange(short psSmallChange);
  int get_Value(out short psValue);
  int put_Value(short psValue);
  int get__Value(out short psValue);
  int put__Value(short psValue);
  int AboutBox();
  int Refresh();
}

interface DFlatSBEvents : IDispatch {
  mixin(uuid("fe387539-44a3-11d1-b5b7-0000c09000c4"));
  /+void Change();+/
  /+void Scroll();+/
}

abstract final class Animation {
  mixin(uuid("b09de715-87c1-11d1-8be3-0000f8754da1"));
  mixin Interfaces!(IAnimation);
}

abstract final class UpDown {
  mixin(uuid("603c7e80-87c2-11d1-8be3-0000f8754da1"));
  mixin Interfaces!(IUpDown);
}

abstract final class MonthView {
  mixin(uuid("232e456a-87c3-11d1-8be3-0000f8754da1"));
  mixin Interfaces!(IMonthView);
}

abstract final class DTPicker {
  mixin(uuid("20dd1b9e-87c4-11d1-8be3-0000f8754da1"));
  mixin Interfaces!(IDTPicker);
}

abstract final class FlatScrollBar {
  mixin(uuid("fe38753a-44a3-11d1-b5b7-0000c09000c4"));
  mixin Interfaces!(IFlatSB);
}
