// CodeGear Common Tasks Assembly
// Version 12.0

/*[uuid("f0212da1-7b4f-41f6-8d61-903d91e3681a")]*/
module borland_build_tasks_common;

/*[importlib("stdole2.tlb")]*/
/*[importlib("mscorlib.tlb")]*/
private import os.win.com.core;

// Interfaces

interface ICallBackObject : IDispatch {
  mixin(uuid("029de800-75be-3628-8aa2-08dc78ee3bc5"));
  /*[id(0x60020000)]*/ int LogError(wchar* subcategory, wchar* errorCode, wchar* helpKeyword, wchar* file, int lineNumber, int columnNumber, wchar* message);
  /*[id(0x60020001)]*/ int LogWarning(wchar* subcategory, wchar* warningCode, wchar* helpKeyword, wchar* file, int lineNumber, int columnNumber, wchar* message);
  /*[id(0x60020002)]*/ int LogHint(wchar* subcategory, wchar* hintCode, wchar* helpKeyword, wchar* file, int lineNumber, int columnNumber, wchar* message);
  /*[id(0x60020003)]*/ int LogMessage(int importance, wchar* message);
}

interface IArgumentValueList : IDispatch {
  mixin(uuid("ba1187a5-2561-4ed7-96e6-aa674c752508"));
  /*[id(0x60020000)]*/ int Description(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int LongDescription(out wchar* pRetVal);
  /*[id(0x60020002)]*/ int EnabledText(out wchar* pRetVal);
  /*[id(0x00000000)]*/ int Value(out wchar* pRetVal);
}

interface IOptionArgument : IDispatch {
  mixin(uuid("731dc45c-08e7-41d2-a4ee-2c06f70b080c"));
  /*[id(0x60020000)]*/ int Description(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int ValueSeparator(out wchar* pRetVal);
  /*[id(0x60020002)]*/ int Separator(out wchar* pRetVal);
  /*[id(0x60020003)]*/ int AllowMerge(out short pRetVal);
  /*[id(0x60020004)]*/ int UpperLimit(out int pRetVal);
  /*[id(0x60020005)]*/ int LowerLimit(out int pRetVal);
  /*[id(0x60020006)]*/ int FileFilter(out wchar* pRetVal);
  /*[id(0x60020007)]*/ int ValueList(out  pRetVal);
  /*[id(0x60020008)]*/ int Type(out int pRetVal);
}

interface IToolParameter : IDispatch {
  mixin(uuid("2ac65acc-4a74-45ae-a01d-d4cb9ff0072f"));
  /*[id(0x60020000)]*/ int Name(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int Description(out wchar* pRetVal);
  /*[id(0x60020002)]*/ int Type(out int pRetVal);
}

interface IToolOption : IDispatch {
  mixin(uuid("a3446de3-5b98-46e5-88e8-fe5f3753d3e8"));
  /*[id(0x60020000)]*/ int Name(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int Description(out wchar* pRetVal);
  /*[id(0x60020002)]*/ int LongDescription(out wchar* pRetVal);
  /*[id(0x60020003)]*/ int EnabledText(out wchar* pRetVal);
  /*[id(0x60020004)]*/ int DisabledText(out wchar* pRetVal);
  /*[id(0x60020005)]*/ int ArgumentRequired(out short pRetVal);
  /*[id(0x60020006)]*/ int ExcludeFromDefaultSave(out short pRetVal);
  /*[id(0x60020007)]*/ int DefaultValue(out wchar* pRetVal);
  /*[id(0x60020008)]*/ int Argument(out IOptionArgument pRetVal);
  /*[id(0x60020009)]*/ int Parent(out IToolOption pRetVal);
  /*[id(0x6002000A)]*/ int ChildCount(out int pRetVal);
  /*[id(0x6002000B)]*/ int GetChild(int index, out IToolOption pRetVal);
  /*[id(0x6002000C)]*/ int GroupName(out wchar* pRetVal);
  /*[id(0x6002000D)]*/ int Hidden(out short pRetVal);
}

interface IOptionGroup : IDispatch {
  mixin(uuid("f14b1aed-061a-4b9b-a1fa-8ec1fa2ca6af"));
  /*[id(0x60020000)]*/ int Name(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int Description(out wchar* pRetVal);
  /*[id(0x60020002)]*/ int Hidden(out short pRetVal);
  /*[id(0x60020003)]*/ int helpKeyword(out wchar* pRetVal);
  /*[id(0x60020004)]*/ int Groups(out  pRetVal);
  /*[id(0x60020005)]*/ int Options(out  pRetVal);
}

interface IToolMetadata : IDispatch {
  mixin(uuid("bf38defe-8e74-47e2-ac15-0d0f128f71e3"));
  /*[id(0x60020000)]*/ int Name(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int GetOptions(out  pRetVal);
  /*[id(0x60020002)]*/ int GetOption(wchar* Name, out IToolOption pRetVal);
  /*[id(0x60020003)]*/ int GetGroups(out  pRetVal);
  /*[id(0x60020004)]*/ int Description(out wchar* pRetVal);
  /*[id(0x60020005)]*/ int PropertyPrefix(out wchar* pRetVal);
  /*[id(0x60020006)]*/ int FileExtensions(out  pRetVal);
  /*[id(0x60020007)]*/ int Inputs(out  pRetVal);
}

interface IToolInfoManager : IDispatch {
  mixin(uuid("a8afd5e4-d515-4a24-a924-bdbe73bd240c"));
  /*[id(0x60020000)]*/ int LoadFromResource(wchar* assemblyFilename, wchar* resourceName, out IToolMetadata pRetVal);
  /*[id(0x60020001)]*/ int LoadFromAssembly(wchar* assemblyFilename, wchar* taskClassname, out IToolMetadata pRetVal);
  /*[id(0x60020002)]*/ int GetMetadata(wchar* toolKey, out IToolMetadata pRetVal);
}

interface IBDSHostObject : IDispatch {
  mixin(uuid("af689fe0-6fa2-3e93-8eb6-d2a829c526f3"));
  /*[id(0x60020000)]*/ int GetProjectFullPath(out wchar* pRetVal);
  /*[id(0x60020001)]*/ int SetProjectFullPath(wchar* Value);
  /*[id(0x60020002)]*/ int SetMessageCallBack(ICallBackObject CallBackObject);
  /*[id(0x60020003)]*/ int GetFileTime(wchar* filename, out long pRetVal);
  /*[id(0x60020004)]*/ int ClearFileAgeCache();
  /*[id(0x60020005)]*/ int ShowCommandLine(wchar* toolDesc, wchar* commandLine, wchar* filename);
  /*[id(0x60020006)]*/ int KibitzResult(wchar* kibitzTarget, wchar* result);
  /*[id(0x60020007)]*/ int UpdateProgressDialog(int kind, wchar* filename, int lineCount, int totalLines, out short pRetVal);
  /*[id(0x60020008)]*/ int ClearErrorsAndWarnings();
  /*[id(0x60020009)]*/ int IncErrorCount(out short pRetVal);
  /*[id(0x6002000A)]*/ int IncWarningCount(out short pRetVal);
  /*[id(0x6002000B)]*/ int IncHintCount(out short pRetVal);
  /*[id(0x6002000C)]*/ int SetLogger(* logger);
  /*[id(0x6002000D)]*/ int GetLogger(out  pRetVal);
  /*[id(0x6002000E)]*/ int ShouldBuild(wchar* filename, wchar* outputFilename, ref short ShouldBuild);
  /*[id(0x6002000F)]*/ int PostCompile(wchar* inputFilenames, wchar* outputFilenames, short success);
  /*[id(0x60020010)]*/ int get_LastParentMessage(out int pRetVal);
  /*[id(0x60020010)]*/ int put_LastParentMessage(int pRetVal);
  /*[id(0x60020012)]*/ int get_LastMessage(out int pRetVal);
  /*[id(0x60020012)]*/ int put_LastMessage(int pRetVal);
  /*[id(0x60020014)]*/ int CreateTemporaryFile(wchar* filename, out wchar* tempFilename, out short pRetVal);
  /*[id(0x60020015)]*/ int DeleteTemporaryFile(wchar* tempFilename);
  /*[id(0x60020016)]*/ int ForceSaveFile(wchar* filename, out wchar* savedFilename, out short pRetVal);
}

interface ITaskErrorCounts : IDispatch {
  mixin(uuid("cd28592c-e687-4b17-9999-845e206b4d48"));
  /*[id(0x60020000)]*/ int IncErrorCount();
  /*[id(0x60020001)]*/ int IncWarningCount();
}

// CoClasses

abstract final class ToolInfoManager {
  mixin(uuid("4dad7710-05b1-40b4-8327-4dc02b42e023"));
  mixin Interfaces!(_Object, IToolInfoManager);
}
