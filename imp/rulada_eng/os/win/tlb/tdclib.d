module os.win.tlb.tdclib;

private import os.win.com.core;

interface OLEDBSimpleProviderX : IDispatch {
  mixin(uuid("e0e270c0-c0be-11d0-8fe4-00a0c90a6341"));
}

interface ITDCCtl : IDispatch {
  mixin(uuid("333c7bc5-460f-11d0-bc04-0080c7055a83"));
  int get_FieldDelim(out wchar* pbstrFieldDelim);
  int put_FieldDelim(wchar* pbstrFieldDelim);
  int get_RowDelim(out wchar* pbstrRowDelim);
  int put_RowDelim(wchar* pbstrRowDelim);
  int get_TextQualifier(out wchar* pbstrTextQualifier);
  int put_TextQualifier(wchar* pbstrTextQualifier);
  int get_EscapeChar(out wchar* pbstrEscapeChar);
  int put_EscapeChar(wchar* pbstrEscapeChar);
  int get_UseHeader(out short pfUseHeader);
  int put_UseHeader(short pfUseHeader);
  int get_SortColumn(out wchar* pbstrSortColumn);
  int put_SortColumn(wchar* pbstrSortColumn);
  int get_SortAscending(out short pfSortAscending);
  int put_SortAscending(short pfSortAscending);
  int get_FilterValue(out wchar* pbstrFilterValue);
  int put_FilterValue(wchar* pbstrFilterValue);
  int get_FilterCriterion(out wchar* pbstrFilterCriterion);
  int put_FilterCriterion(wchar* pbstrFilterCriterion);
  int get_FilterColumn(out wchar* pbstrFilterColumn);
  int put_FilterColumn(wchar* pbstrFilterColumn);
  int get_CharSet(out wchar* pbstrCharSet);
  int put_CharSet(wchar* pbstrCharSet);
  int get_Language(out wchar* pbstrLanguage);
  int put_Language(wchar* pbstrLanguage);
  int get_CaseSensitive(out short pfCaseSensitive);
  int put_CaseSensitive(short pfCaseSensitive);
  int get_DataURL(out wchar* pbstrDataURL);
  int put_DataURL(wchar* pbstrDataURL);
  int msDataSourceObject(wchar* qualifier, out IUnknown ppUnk);
  int addDataSourceListener(IUnknown pEvent);
  int Reset();
  int _OnTimer();
  int get_Filter(out wchar* pbstrFilterExpr);
  int put_Filter(wchar* pbstrFilterExpr);
  int get_Sort(out wchar* pbstrSortExpr);
  int put_Sort(wchar* pbstrSortExpr);
  int get_ReadyState(out int state);
  int put_ReadyState(int state);
  int get_AppendData(out short pfAppendData);
  int put_AppendData(short pfAppendData);
  int get_OSP(out OLEDBSimpleProviderX ppISTD);
}

interface ITDCCtlEvents : IDispatch {
  mixin(uuid("333c7bc6-460f-11d0-bc04-0080c7055a83"));
  void onreadystatechange();
}

interface IAmTheTDC : IUnknown {
  mixin(uuid("3050f6c2-98b5-11cf-bb82-00aa00bdce0b"));
}

abstract final class CTDCCtl {
  mixin(uuid("333c7bc4-460f-11d0-bc04-0080c7055a83"));
  mixin Interfaces!(ITDCCtl);
}
