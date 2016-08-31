module os.win.tlb.msscriptcontrol;

private import os.win.com.core;

enum ScriptControlStates {
  Initialized = 0x00000000,
  Connected = 0x00000001,
}

interface IScriptProcedure : IDispatch {
  mixin(uuid("70841c73-067d-11d0-95d8-00a02463ab28"));
  int get_Name(out wchar* pbstrName);
  int get_NumArgs(out int pcArgs);
  int get_HasReturnValue(out short pfHasReturnValue);
}

interface IScriptProcedureCollection : IDispatch {
  mixin(uuid("70841c71-067d-11d0-95d8-00a02463ab28"));
  int get__NewEnum(out IUnknown ppenumProcedures);
  int get_Item(VARIANT Index, out IScriptProcedure ppdispProcedure);
  int get_Count(out int plCount);
}

interface IScriptModule : IDispatch {
  mixin(uuid("70841c70-067d-11d0-95d8-00a02463ab28"));
  int get_Name(out wchar* pbstrName);
  int get_CodeObject(out IDispatch ppdispObject);
  int get_Procedures(out IScriptProcedureCollection ppdispProcedures);
  int AddCode(wchar* Code);
  int Eval(wchar* Expression, out VARIANT pvarResult);
  int ExecuteStatement(wchar* Statement);
  int Run(wchar* ProcedureName, * Parameters, out VARIANT pvarResult);
}

interface IScriptModuleCollection : IDispatch {
  mixin(uuid("70841c6f-067d-11d0-95d8-00a02463ab28"));
  int get__NewEnum(out IUnknown ppenumContexts);
  int get_Item(VARIANT Index, out IScriptModule ppmod);
  int get_Count(out int plCount);
  int Add(wchar* Name, VARIANT* ObjectParam, out IScriptModule ppmod);
}

interface IScriptError : IDispatch {
  mixin(uuid("70841c78-067d-11d0-95d8-00a02463ab28"));
  int get_Number(out int plNumber);
  int get_Source(out wchar* pbstrSource);
  int get_Description(out wchar* pbstrDescription);
  int get_HelpFile(out wchar* pbstrHelpFile);
  int get_HelpContext(out int plHelpContext);
  int get_Text(out wchar* pbstrText);
  int get_Line(out int plLine);
  int get_Column(out int plColumn);
  int Clear();
}

interface IScriptControl : IDispatch {
  mixin(uuid("0e59f1d3-1fbe-11d0-8ff2-00a0d10038bc"));
  int get_Language(out wchar* pbstrLanguage);
  int put_Language(wchar* pbstrLanguage);
  int get_State(out ScriptControlStates pssState);
  int put_State(ScriptControlStates pssState);
  int put_SitehWnd(int phwnd);
  int get_SitehWnd(out int phwnd);
  int get_Timeout(out int plMilleseconds);
  int put_Timeout(int plMilleseconds);
  int get_AllowUI(out short pfAllowUI);
  int put_AllowUI(short pfAllowUI);
  int get_UseSafeSubset(out short pfUseSafeSubset);
  int put_UseSafeSubset(short pfUseSafeSubset);
  int get_Modules(out IScriptModuleCollection ppmods);
  int get_Error(out IScriptError ppse);
  int get_CodeObject(out IDispatch ppdispObject);
  int get_Procedures(out IScriptProcedureCollection ppdispProcedures);
  int _AboutBox();
  int AddObject(wchar* Name, IDispatch ObjectParam, short AddMembers);
  int Reset();
  int AddCode(wchar* Code);
  int Eval(wchar* Expression, out VARIANT pvarResult);
  int ExecuteStatement(wchar* Statement);
  int Run(wchar* ProcedureName, * Parameters, out VARIANT pvarResult);
}

interface DScriptControlSource : IDispatch {
  mixin(uuid("8b167d60-8605-11d0-abcb-00a0c90fffc0"));
  /+void Error();+/
  /+void Timeout();+/
}

abstract final class ScriptControl {
  mixin(uuid("0e59f1d5-1fbe-11d0-8ff2-00a0d10038bc"));
  mixin Interfaces!(IScriptControl);
}
const wchar* GlobalModule = "Global";
const int NoTimeout = 0xFFFFFFFF;
