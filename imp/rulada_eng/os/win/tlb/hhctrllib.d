module os.win.tlb.hhctrllib;

private import os.win.com.core;

alias uint UINT_PTR;

alias int LONG_PTR;

interface _HHCtrlEvents : IDispatch {
  mixin(uuid("adb880a3-d8ff-11cf-9377-00aa003b7a11"));
  /+void Click(wchar* ParamString);+/
}

interface IHHCtrl : IDispatch {
  mixin(uuid("adb880a1-d8ff-11cf-9377-00aa003b7a11"));
  int put_Image(wchar* path);
  int get_Image(out wchar* path);
  int Click();
  int HHClick();
  int Print();
  int syncURL(wchar* pszUrl);
  int TCard(UINT_PTR wParam, LONG_PTR lParam);
  int TextPopup(wchar* pszText, wchar* pszFont, int horzMargins, int vertMargins, uint clrForeground, uint clrBackground);
}

abstract final class HHCtrl {
  mixin(uuid("52a2aaae-085d-4187-97ea-8c30db990436"));
  mixin Interfaces!(IHHCtrl);
}

abstract final class OldHHCtrl2 {
  mixin(uuid("41b23c28-488e-4e5c-ace2-bb0bbabe99e8"));
  mixin Interfaces!(IHHCtrl);
}

abstract final class OldHHCtrl1 {
  mixin(uuid("adb880a6-d8ff-11cf-9377-00aa003b7a11"));
  mixin Interfaces!(IHHCtrl);
}
