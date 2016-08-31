module os.win.tlb.sliderexctrl;

private import os.win.com.core;

enum TxActiveFormBorderStyle {
  afbNone = 0x00000000,
  afbSingle = 0x00000001,
  afbSunken = 0x00000002,
  afbRaised = 0x00000003,
}

enum TxPrintScale {
  poNone = 0x00000000,
  poProportional = 0x00000001,
  poPrintToFit = 0x00000002,
}

enum TxMouseButton {
  mbLeft = 0x00000000,
  mbRight = 0x00000001,
  mbMiddle = 0x00000002,
}

interface ISliderEx : IDispatch {
  mixin(uuid("20ad086b-ba65-4fe0-8782-e0d270601c0e"));
  int get_Visible(out short Value);
  int put_Visible(short Value);
  int get_AutoScroll(out short Value);
  int put_AutoScroll(short Value);
  int get_AutoSize(out short Value);
  int put_AutoSize(short Value);
  int get_AxBorderStyle(out TxActiveFormBorderStyle Value);
  int put_AxBorderStyle(TxActiveFormBorderStyle Value);
  int get_Caption(out wchar* Value);
  int put_Caption(wchar* Value);
  int get_Color(out OLE_COLOR Value);
  int put_Color(OLE_COLOR Value);
  int get_Font(out IFontDisp Value);
  int put_Font(IFontDisp* Value);
  int putref_Font(IFontDisp** Value);
  int get_KeyPreview(out short Value);
  int put_KeyPreview(short Value);
  int get_PixelsPerInch(out int Value);
  int put_PixelsPerInch(int Value);
  int get_PrintScale(out TxPrintScale Value);
  int put_PrintScale(TxPrintScale Value);
  int get_Scaled(out short Value);
  int put_Scaled(short Value);
  int get_Active(out short Value);
  int get_DropTarget(out short Value);
  int put_DropTarget(short Value);
  int get_HelpFile(out wchar* Value);
  int put_HelpFile(wchar* Value);
  int get_DoubleBuffered(out short Value);
  int put_DoubleBuffered(short Value);
  int get_VisibleDockClientCount(out int Value);
  int get_Enabled(out short Value);
  int put_Enabled(short Value);
  int get_Cursor(out short Value);
  int put_Cursor(short Value);
  int get_Min(out int Value);
  int put_Min(int Value);
  int get_Max(out int Value);
  int put_Max(int Value);
  int get_Position(out int Value);
  int put_Position(int Value);
  int get_BKColor(out int Value);
  int put_BKColor(int Value);
  int get_Orientation(out short Value);
  int put_Orientation(short Value);
  int SetRange(int nMin, int nMax, int nPosition);
  int get_ParentHandle(out int Value);
  int put_ParentHandle(int Value);
  int get_DisplayTick(out int Value);
  int put_DisplayTick(int Value);
  int get_RGBType(int nKind, out int Value);
  int put_RGBType(int nKind, int Value);
  int get_SliderEnabled(out short Value);
  int put_SliderEnabled(short Value);
}

interface ISliderExEvents : IDispatch {
  mixin(uuid("82c77645-c02a-497f-9d78-0f481bfdf5fa"));
  /+void OnActivate();+/
  /+void OnClick();+/
  /+void OnCreate();+/
  /+void OnDblClick();+/
  /+void OnDestroy();+/
  /+void OnDeactivate();+/
  /+void OnKeyPress(ref short Key);+/
  /+void OnPaint();+/
  /+int OnSliderChange();+/
}

abstract final class SliderEx {
  mixin(uuid("244c02af-0694-498a-9e7e-51526da0014e"));
  mixin Interfaces!(ISliderEx);
}
