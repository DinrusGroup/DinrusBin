module os.win.tlb.dmview2lib;

private import os.win.com.core;

interface _DDMView2 : IDispatch {
  mixin(uuid("aeb84c81-95dc-11d0-b7fc-b61140119c4a"));
  /+void LoadData(int ConnectionStatus);+/
  /+void Init(int pDMSnapin, int pTaskData, int pSnapin);+/
  /+void AddRow(int lCookie);+/
  /+void ChangeRow(int lCookie);+/
  /+void DeleteRow(int lCookie);+/
  /+void SetViewType(short nViewNum);+/
  /+void RefreshDiskView();+/
  /+void GetListViewsWidths();+/
  /+void UIStateChange(int dwState);+/
  /+void ResetLoadState(int LoadDataState);+/
  /+void SysColorChange();+/
  /+void ReloadData();+/
  /+const int CWndPtr;+/
}

interface _DDMView2Events : IDispatch {
  mixin(uuid("aeb84c82-95dc-11d0-b7fc-b61140119c4a"));
}

abstract final class DMView2 {
  mixin(uuid("aeb84c83-95dc-11d0-b7fc-b61140119c4a"));
  mixin Interfaces!(_DDMView2);
}
