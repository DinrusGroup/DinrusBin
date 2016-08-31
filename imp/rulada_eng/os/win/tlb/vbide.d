// Microsoft Visual Basic for Applications Extensibility 5.3
// Version 5.3

/*[uuid("0002e157-0000-0000-c000-000000000046")]*/
module os.win.tlb.vbide;

/*[importlib("STDOLE2.TLB")]*/
/*[importlib("MSO.DLL")]*/
private import os.win.com.core;

// Enums

enum vbextFileTypes {
  vbextFileTypeForm = 0x00000000,
  vbextFileTypeModule = 0x00000001,
  vbextFileTypeClass = 0x00000002,
  vbextFileTypeProject = 0x00000003,
  vbextFileTypeExe = 0x00000004,
  vbextFileTypeFrx = 0x00000005,
  vbextFileTypeRes = 0x00000006,
  vbextFileTypeUserControl = 0x00000007,
  vbextFileTypePropertyPage = 0x00000008,
  vbextFileTypeDocObject = 0x00000009,
  vbextFileTypeBinary = 0x0000000A,
  vbextFileTypeGroupProject = 0x0000000B,
  vbextFileTypeDesigners = 0x0000000C,
}

enum vbext_WindowType {
  vbext_wt_CodeWindow = 0x00000000,
  vbext_wt_Designer = 0x00000001,
  vbext_wt_Browser = 0x00000002,
  vbext_wt_Watch = 0x00000003,
  vbext_wt_Locals = 0x00000004,
  vbext_wt_Immediate = 0x00000005,
  vbext_wt_ProjectWindow = 0x00000006,
  vbext_wt_PropertyWindow = 0x00000007,
  vbext_wt_Find = 0x00000008,
  vbext_wt_FindReplace = 0x00000009,
  vbext_wt_Toolbox = 0x0000000A,
  vbext_wt_LinkedWindowFrame = 0x0000000B,
  vbext_wt_MainWindow = 0x0000000C,
  vbext_wt_ToolWindow = 0x0000000F,
}

enum vbext_WindowState {
  vbext_ws_Normal = 0x00000000,
  vbext_ws_Minimize = 0x00000001,
  vbext_ws_Maximize = 0x00000002,
}

enum vbext_ProjectType {
  vbext_pt_HostProject = 0x00000064,
  vbext_pt_StandAlone = 0x00000065,
}

enum vbext_ProjectProtection {
  vbext_pp_none = 0x00000000,
  vbext_pp_locked = 0x00000001,
}

enum vbext_VBAMode {
  vbext_vm_Run = 0x00000000,
  vbext_vm_Break = 0x00000001,
  vbext_vm_Design = 0x00000002,
}

enum vbext_ComponentType {
  vbext_ct_StdModule = 0x00000001,
  vbext_ct_ClassModule = 0x00000002,
  vbext_ct_MSForm = 0x00000003,
  vbext_ct_ActiveXDesigner = 0x0000000B,
  vbext_ct_Document = 0x00000064,
}

enum vbext_ProcKind {
  vbext_pk_Proc = 0x00000000,
  vbext_pk_Let = 0x00000001,
  vbext_pk_Set = 0x00000002,
  vbext_pk_Get = 0x00000003,
}

enum vbext_CodePaneview {
  vbext_cv_ProcedureView = 0x00000000,
  vbext_cv_FullModuleView = 0x00000001,
}

enum vbext_RefKind {
  vbext_rk_TypeLib = 0x00000000,
  vbext_rk_Project = 0x00000001,
}

// Interfaces

interface Application : IDispatch {
  mixin(uuid("0002e158-0000-0000-c000-000000000046"));
  /*[id(0x00000064)]*/ int get_Version(out wchar* lpbstrReturn);
}

interface VBE : Application {
  mixin(uuid("0002e166-0000-0000-c000-000000000046"));
  /*[id(0x0000006B)]*/ int get_VBProjects(out VBProjects lppptReturn);
  /*[id(0x0000006C)]*/ int get_CommandBars(out CommandBars ppcbs);
  /*[id(0x0000006D)]*/ int get_CodePanes(out CodePanes ppCodePanes);
  /*[id(0x0000006E)]*/ int get_Windows(out Windows ppwnsVBWindows);
  /*[id(0x0000006F)]*/ int get_Events(out Events ppevtEvents);
  /*[id(0x000000C9)]*/ int get_ActiveVBProject(out VBProject lppptReturn);
  /*[id(0x000000C9)]*/ int putref_ActiveVBProject(VBProject* lppptReturn);
  /*[id(0x000000CA)]*/ int get_SelectedVBComponent(out VBComponent lppscReturn);
  /*[id(0x000000CC)]*/ int get_MainWindow(out Window ppwin);
  /*[id(0x000000CD)]*/ int get_ActiveWindow(out Window ppwinActive);
  /*[id(0x000000CE)]*/ int get_ActiveCodePane(out CodePane ppCodePane);
  /*[id(0x000000CE)]*/ int putref_ActiveCodePane(CodePane* ppCodePane);
  /*[id(0x000000D1)]*/ int get_Addins(out Addins lpppAddIns);
}

interface Window : IDispatch {
  mixin(uuid("0002e16b-0000-0000-c000-000000000046"));
  /*[id(0x00000001)]*/ int get_VBE(out VBE lppaReturn);
  /*[id(0x00000002)]*/ int get_Collection(out Windows lppaReturn);
  /*[id(0x00000063)]*/ int Close();
  /*[id(0x00000064)]*/ int get_Caption(out wchar* pbstrTitle);
  /*[id(0x0000006A)]*/ int get_Visible(out short pfVisible);
  /*[id(0x0000006A)]*/ int put_Visible(short pfVisible);
  /*[id(0x00000065)]*/ int get_Left(out int plLeft);
  /*[id(0x00000065)]*/ int put_Left(int plLeft);
  /*[id(0x00000067)]*/ int get_Top(out int plTop);
  /*[id(0x00000067)]*/ int put_Top(int plTop);
  /*[id(0x00000069)]*/ int get_Width(out int plWidth);
  /*[id(0x00000069)]*/ int put_Width(int plWidth);
  /*[id(0x0000006B)]*/ int get_Height(out int plHeight);
  /*[id(0x0000006B)]*/ int put_Height(int plHeight);
  /*[id(0x0000006D)]*/ int get_WindowState(out vbext_WindowState plWindowState);
  /*[id(0x0000006D)]*/ int put_WindowState(vbext_WindowState plWindowState);
  /*[id(0x0000006F)]*/ int SetFocus();
  /*[id(0x00000070)]*/ int get_Type(out vbext_WindowType pKind);
  /*[id(0x00000071)]*/ int SetKind(vbext_WindowType eKind);
  /*[id(0x00000074)]*/ int get_LinkedWindows(out LinkedWindows ppwnsCollection);
  /*[id(0x00000075)]*/ int get_LinkedWindowFrame(out Window ppwinFrame);
  /*[id(0x00000076)]*/ int Detach();
  /*[id(0x00000077)]*/ int Attach(int lWindowHandle);
  /*[id(0x00000078)]*/ int get_HWnd(out int plWindowHandle);
}

interface _Windows_old : IDispatch {
  mixin(uuid("0002e16a-0000-0000-c000-000000000046"));
  /*[id(0x00000001)]*/ int get_VBE(out VBE lppaReturn);
  /*[id(0x00000002)]*/ int get_Parent(out Application lppptReturn);
  /*[id(0x00000000)]*/ int Item(VARIANT index, out Window lppcReturn);
  /*[id(0x000000C9)]*/ int get_Count(out int lplReturn);
  /*[id(0xFFFFFFFC)]*/ int _NewEnum(out IUnknown lppiuReturn);
}

interface _Windows : _Windows_old {
  mixin(uuid("f57b7ed0-d8ab-11d1-85df-00c04f98f42c"));
  /*[id(0x0000012C)]*/ int CreateToolWindow(AddIn AddInInst, wchar* ProgId, wchar* Caption, wchar* GuidPosition, ref IDispatch DocObj, out Window lppcReturn);
}

interface _LinkedWindows : IDispatch {
  mixin(uuid("0002e16c-0000-0000-c000-000000000046"));
  /*[id(0x00000001)]*/ int get_VBE(out VBE lppaReturn);
  /*[id(0x00000002)]*/ int get_Parent(out Window ppptReturn);
  /*[id(0x00000000)]*/ int Item(VARIANT index, out Window lppcReturn);
  /*[id(0x000000C9)]*/ int get_Count(out int lplReturn);
  /*[id(0xFFFFFFFC)]*/ int _NewEnum(out IUnknown lppiuReturn);
  /*[id(0x000000CA)]*/ int Remove(Window Window);
  /*[id(0x000000CB)]*/ int Add(Window Window);
}

interface Events : IDispatch {
  mixin(uuid("0002e167-0000-0000-c000-000000000046"));
  /*[id(0x000000CA)]*/ int get_ReferencesEvents(VBProject* VBProject, out ReferencesEvents prceNew);
  /*[id(0x000000CD)]*/ int get_CommandBarEvents(IDispatch CommandBarControl, out CommandBarEvents prceNew);
}

interface _VBProjectsEvents : IUnknown {
  mixin(uuid("0002e113-0000-0000-c000-000000000046"));
}

interface _dispVBProjectsEvents : IDispatch {
  mixin(uuid("0002e103-0000-0000-c000-000000000046"));
  /+/*[id(0x00000001)]*/ void ItemAdded(VBProject* VBProject);+/
  /+/*[id(0x00000002)]*/ void ItemRemoved(VBProject* VBProject);+/
  /+/*[id(0x00000003)]*/ void ItemRenamed(VBProject* VBProject, wchar* OldName);+/
  /+/*[id(0x00000004)]*/ void ItemActivated(VBProject* VBProject);+/
}

interface _VBComponentsEvents : IUnknown {
  mixin(uuid("0002e115-0000-0000-c000-000000000046"));
}

interface _dispVBComponentsEvents : IDispatch {
  mixin(uuid("0002e116-0000-0000-c000-000000000046"));
  /+/*[id(0x00000001)]*/ void ItemAdded(VBComponent* VBComponent);+/
  /+/*[id(0x00000002)]*/ void ItemRemoved(VBComponent* VBComponent);+/
  /+/*[id(0x00000003)]*/ void ItemRenamed(VBComponent* VBComponent, wchar* OldName);+/
  /+/*[id(0x00000004)]*/ void ItemSelected(VBComponent* VBComponent);+/
  /+/*[id(0x00000005)]*/ void ItemActivated(VBComponent* VBComponent);+/
  /+/*[id(0x00000006)]*/ void ItemReloaded(VBComponent* VBComponent);+/
}

interface _ReferencesEvents : IUnknown {
  mixin(uuid("0002e11a-0000-0000-c000-000000000046"));
}

interface _dispReferencesEvents : IDispatch {
  mixin(uuid("0002e118-0000-0000-c000-000000000046"));
  /+/*[id(0x00000001)]*/ void ItemAdded(Reference Reference);+/
  /+/*[id(0x00000002)]*/ void ItemRemoved(Reference Reference);+/
}

interface _CommandBarControlEvents : IUnknown {
  mixin(uuid("0002e130-0000-0000-c000-000000000046"));
}

interface _dispCommandBarControlEvents : IDispatch {
  mixin(uuid("0002e131-0000-0000-c000-000000000046"));
  /+/*[id(0x00000001)]*/ void Click(IDispatch CommandBarControl, short* handled, short* CancelDefault);+/
}

interface _ProjectTemplate : IDispatch {
  mixin(uuid("0002e159-0000-0000-c000-000000000046"));
  /*[id(0x00000001)]*/ int get_Application(out Application lppaReturn);
  /*[id(0x00000002)]*/ int get_Parent(out Application lppaReturn);
}

interface _VBProject_Old : _ProjectTemplate {
  mixin(uuid("0002e160-0000-0000-c000-000000000046"));
  /*[id(0x00000074)]*/ int get_HelpFile(out wchar* lpbstrHelpFile);
  /*[id(0x00000074)]*/ int put_HelpFile(wchar* lpbstrHelpFile);
  /*[id(0x00000075)]*/ int get_HelpContextID(out int lpdwContextID);
  /*[id(0x00000075)]*/ int put_HelpContextID(int lpdwContextID);
  /*[id(0x00000076)]*/ int get_Description(out wchar* lpbstrDescription);
  /*[id(0x00000076)]*/ int put_Description(wchar* lpbstrDescription);
  /*[id(0x00000077)]*/ int get_Mode(out vbext_VBAMode lpVbaMode);
  /*[id(0x00000078)]*/ int get_References(out References lppReferences);
  /*[id(0x00000079)]*/ int get_Name(out wchar* lpbstrName);
  /*[id(0x00000079)]*/ int put_Name(wchar* lpbstrName);
  /*[id(0x0000007A)]*/ int get_VBE(out VBE lppaReturn);
  /*[id(0x0000007B)]*/ int get_Collection(out VBProjects lppaReturn);
  /*[id(0x00000083)]*/ int get_Protection(out vbext_ProjectProtection lpProtection);
  /*[id(0x00000085)]*/ int get_Saved(out short lpfReturn);
  /*[id(0x00000087)]*/ int get_VBComponents(out VBComponents lppcReturn);
}

interface _VBProject : _VBProject_Old {
  mixin(uuid("eee00915-e393-11d1-bb03-00c04fb6c4a6"));
  /*[id(0x0000008A)]*/ int SaveAs(wchar* FileName);
  /*[id(0x0000008B)]*/ int MakeCompiledFile();
  /*[id(0x0000008C)]*/ int get_Type(out vbext_ProjectType lpkind);
  /*[id(0x0000008D)]*/ int get_FileName(out wchar* lpbstrReturn);
  /*[id(0x0000008E)]*/ int get_BuildFileName(out wchar* lpbstrBldFName);
  /*[id(0x0000008E)]*/ int put_BuildFileName(wchar* lpbstrBldFName);
}

interface _VBProjects_Old : IDispatch {
  mixin(uuid("0002e165-0000-0000-c000-000000000046"));
  /*[id(0x00000000)]*/ int Item(VARIANT index, out VBProject lppcReturn);
  /*[id(0x00000014)]*/ int get_VBE(out VBE lppaReturn);
  /*[id(0x00000002)]*/ int get_Parent(out VBE lppaReturn);
  /*[id(0x0000000A)]*/ int get_Count(out int lplReturn);
  /*[id(0xFFFFFFFC)]*/ int _NewEnum(out IUnknown lppiuReturn);
}

interface _VBProjects : _VBProjects_Old {
  mixin(uuid("eee00919-e393-11d1-bb03-00c04fb6c4a6"));
  /*[id(0x00000089)]*/ int Add(vbext_ProjectType Type, out VBProject lppcReturn);
  /*[id(0x0000008A)]*/ int Remove(VBProject* lpc);
  /*[id(0x0000008B)]*/ int Open(wchar* bstrPath, out VBProject lpc);
}

interface SelectedComponents : IDispatch {
  mixin(uuid("be39f3d4-1b13-11d0-887f-00a0c90f2744"));
  /*[id(0x00000000)]*/ int Item(int index, out Component lppcReturn);
  /*[id(0x00000001)]*/ int get_Application(out Application lppaReturn);
  /*[id(0x00000002)]*/ int get_Parent(out VBProject lppptReturn);
  /*[id(0x0000000A)]*/ int get_Count(out int lplReturn);
  /*[id(0xFFFFFFFC)]*/ int _NewEnum(out IUnknown lppiuReturn);
}

interface _Components : IDispatch {
  mixin(uuid("0002e161-0000-0000-c000-000000000046"));
  /*[id(0x00000000)]*/ int Item(VARIANT index, out Component lppcReturn);
  /*[id(0x00000001)]*/ int get_Application(out Application lppaReturn);
  /*[id(0x00000002)]*/ int get_Parent(out VBProject lppptReturn);
  /*[id(0x0000000A)]*/ int get_Count(out int lplReturn);
  /*[id(0xFFFFFFFC)]*/ int _NewEnum(out IUnknown lppiuReturn);
  /*[id(0x0000000B)]*/ int Remove(Component* Component);
  /*[id(0x0000000C)]*/ int Add(vbext_ComponentType ComponentType, out Component lppComponent);
  /*[id(0x0000000D)]*/ int Import(wchar* FileName, out Component lppComponent);
  /*[id(0x00000014)]*/ int get_VBE(out VBE lppaReturn);
}

interface _VBComponents_Old : IDispatch {
  mixin(uuid("0002e162-0000-0000-c000-000000000046"));
  /*[id(0x00000000)]*/ int Item(VARIANT index, out VBComponent lppcReturn);
  /*[id(0x00000002)]*/ int get_Parent(out VBProject lppptReturn);
  /*[id(0x0000000A)]*/ int get_Count(out int lplReturn);
  /*[id(0xFFFFFFFC)]*/ int _NewEnum(out IUnknown lppiuReturn);
  /*[id(0x0000000B)]*/ int Remove(VBComponent* VBComponent);
  /*[id(0x0000000C)]*/ int Add(vbext_ComponentType ComponentType, out VBComponent lppComponent);
  /*[id(0x0000000D)]*/ int Import(wchar* FileName, out VBComponent lppComponent);
  /*[id(0x00000014)]*/ int get_VBE(out VBE lppaReturn);
}

interface _VBComponents : _VBComponents_Old {
  mixin(uuid("eee0091c-e393-11d1-bb03-00c04fb6c4a6"));
  /*[id(0x00000019)]*/ int AddCustom(wchar* ProgId, out VBComponent lppComponent);
  /*[id(0x0000001A)]*/ int AddMTDesigner(int index, out VBComponent lppComponent);
}

interface _Component : IDispatch {
  mixin(uuid("0002e163-0000-0000-c000-000000000046"));
  /*[id(0x00000001)]*/ int get_Application(out Application lppaReturn);
  /*[id(0x00000002)]*/ int get_Parent(out Components lppcReturn);
  /*[id(0x0000000A)]*/ int get_IsDirty(out short lpfReturn);
  /*[id(0x0000000A)]*/ int put_IsDirty(short lpfReturn);
  /*[id(0x00000030)]*/ int get_Name(out wchar* pbstrReturn);
  /*[id(0x00000030)]*/ int put_Name(wchar* pbstrReturn);
}

interface _VBComponent_Old : IDispatch {
  mixin(uuid("0002e164-0000-0000-c000-000000000046"));
  /*[id(0x0000000A)]*/ int get_Saved(out short lpfReturn);
  /*[id(0x00000030)]*/ int get_Name(out wchar* pbstrReturn);
  /*[id(0x00000030)]*/ int put_Name(wchar* pbstrReturn);
  /*[id(0x00000031)]*/ int get_Designer(out IDispatch ppDispatch);
  /*[id(0x00000032)]*/ int get_CodeModule(out CodeModule ppVbaModule);
  /*[id(0x00000033)]*/ int get_Type(out vbext_ComponentType pKind);
  /*[id(0x00000034)]*/ int Export(wchar* FileName);
  /*[id(0x00000035)]*/ int get_VBE(out VBE lppaReturn);
  /*[id(0x00000036)]*/ int get_Collection(out VBComponents lppcReturn);
  /*[id(0x00000037)]*/ int get_HasOpenDesigner(out short lpfReturn);
  /*[id(0x00000038)]*/ int get_Properties(out Properties lpppReturn);
  /*[id(0x00000039)]*/ int DesignerWindow(out Window lppcReturn);
  /*[id(0x0000003C)]*/ int Activate();
}

interface _VBComponent : _VBComponent_Old {
  mixin(uuid("eee00921-e393-11d1-bb03-00c04fb6c4a6"));
  /*[id(0x00000040)]*/ int get_DesignerID(out wchar* pbstrReturn);
}

interface Property : IDispatch {
  mixin(uuid("0002e18c-0000-0000-c000-000000000046"));
  /*[id(0x00000000)]*/ int get_Value(out VARIANT lppvReturn);
  /*[id(0x00000000)]*/ int put_Value(VARIANT lppvReturn);
  /*[id(0x00000003)]*/ int get_IndexedValue(VARIANT Index1, VARIANT Index2, VARIANT Index3, VARIANT Index4, out VARIANT lppvReturn);
  /*[id(0x00000003)]*/ int put_IndexedValue(VARIANT Index1, VARIANT Index2, VARIANT Index3, VARIANT Index4, VARIANT lppvReturn);
  /*[id(0x00000004)]*/ int get_NumIndices(out short lpiRetVal);
  /*[id(0x00000001)]*/ int get_Application(out Application lpaReturn);
  /*[id(0x00000002)]*/ int get_Parent(out Properties lpppReturn);
  /*[id(0x00000028)]*/ int get_Name(out wchar* lpbstrReturn);
  /*[id(0x00000029)]*/ int get_VBE(out VBE lpaReturn);
  /*[id(0x0000002A)]*/ int get_Collection(out Properties lpppReturn);
  /*[id(0x0000002D)]*/ int get_Object(out IUnknown lppunk);
  /*[id(0x0000002D)]*/ int putref_Object(IUnknown lppunk);
}

interface _Properties : IDispatch {
  mixin(uuid("0002e188-0000-0000-c000-000000000046"));
  /*[id(0x00000000)]*/ int Item(VARIANT index, out Property lplppReturn);
  /*[id(0x00000001)]*/ int get_Application(out Application lppaReturn);
  /*[id(0x00000002)]*/ int get_Parent(out IDispatch lppidReturn);
  /*[id(0x00000028)]*/ int get_Count(out int lplReturn);
  /*[id(0xFFFFFFFC)]*/ int _NewEnum(out IUnknown lppiuReturn);
  /*[id(0x0000000A)]*/ int get_VBE(out VBE lppaReturn);
}

interface _AddIns : IDispatch {
  mixin(uuid("da936b62-ac8b-11d1-b6e5-00a0c90f2744"));
  /*[id(0x00000000)]*/ int Item(VARIANT index, out AddIn lppaddin);
  /*[id(0x00000001)]*/ int get_VBE(out VBE lppVBA);
  /*[id(0x00000002)]*/ int get_Parent(out IDispatch lppVBA);
  /*[id(0x00000028)]*/ int get_Count(out int lplReturn);
  /*[id(0xFFFFFFFC)]*/ int _NewEnum(out IUnknown lppiuReturn);
  /*[id(0x00000029)]*/ int Update();
}

interface AddIn : IDispatch {
  mixin(uuid("da936b64-ac8b-11d1-b6e5-00a0c90f2744"));
  /*[id(0x00000000)]*/ int get_Description(out wchar* lpbstr);
  /*[id(0x00000000)]*/ int put_Description(wchar* lpbstr);
  /*[id(0x00000001)]*/ int get_VBE(out VBE lppVBE);
  /*[id(0x00000002)]*/ int get_Collection(out Addins lppaddins);
  /*[id(0x00000003)]*/ int get_ProgId(out wchar* lpbstr);
  /*[id(0x00000004)]*/ int get_Guid(out wchar* lpbstr);
  /*[id(0x00000006)]*/ int get_Connect(out short lpfConnect);
  /*[id(0x00000006)]*/ int put_Connect(short lpfConnect);
  /*[id(0x00000007)]*/ int get_Object(out IDispatch lppdisp);
  /*[id(0x00000007)]*/ int put_Object(IDispatch lppdisp);
}

interface _CodeModule : IDispatch {
  mixin(uuid("0002e16e-0000-0000-c000-000000000046"));
  /*[id(0x60020000)]*/ int get_Parent(out VBComponent retval);
  /*[id(0x60020001)]*/ int get_VBE(out VBE retval);
  /*[id(0x00000000)]*/ int get_Name(out wchar* pbstrName);
  /*[id(0x00000000)]*/ int put_Name(wchar* pbstrName);
  /*[id(0x60020004)]*/ int AddFromString(wchar* String);
  /*[id(0x60020005)]*/ int AddFromFile(wchar* FileName);
  /*[id(0x60020006)]*/ int get_Lines(int StartLine, int Count, out wchar* String);
  /*[id(0x60020007)]*/ int get_CountOfLines(out int CountOfLines);
  /*[id(0x60020008)]*/ int InsertLines(int Line, wchar* String);
  /*[id(0x60020009)]*/ int DeleteLines(int StartLine, int Count);
  /*[id(0x6002000A)]*/ int ReplaceLine(int Line, wchar* String);
  /*[id(0x6002000B)]*/ int get_ProcStartLine(wchar* ProcName, vbext_ProcKind ProcKind, out int ProcStartLine);
  /*[id(0x6002000C)]*/ int get_ProcCountLines(wchar* ProcName, vbext_ProcKind ProcKind, out int ProcCountLines);
  /*[id(0x6002000D)]*/ int get_ProcBodyLine(wchar* ProcName, vbext_ProcKind ProcKind, out int ProcBodyLine);
  /*[id(0x6002000E)]*/ int get_ProcOfLine(int Line, out vbext_ProcKind ProcKind, out wchar* pbstrName);
  /*[id(0x6002000F)]*/ int get_CountOfDeclarationLines(out int pDeclCountOfLines);
  /*[id(0x60020010)]*/ int CreateEventProc(wchar* EventName, wchar* ObjectName, out int Line);
  /*[id(0x60020011)]*/ int Find(wchar* Target, ref int StartLine, ref int StartColumn, ref int EndLine, ref int EndColumn, short WholeWord, short MatchCase, short PatternSearch, out short pfFound);
  /*[id(0x60020012)]*/ int get_CodePane(out CodePane CodePane);
}

interface _CodePanes : IDispatch {
  mixin(uuid("0002e172-0000-0000-c000-000000000046"));
  /*[id(0x60020000)]*/ int get_Parent(out VBE retval);
  /*[id(0x60020001)]*/ int get_VBE(out VBE retval);
  /*[id(0x00000000)]*/ int Item(VARIANT index, out CodePane CodePane);
  /*[id(0x60020003)]*/ int get_Count(out int Count);
  /*[id(0xFFFFFFFC)]*/ int _NewEnum(out IUnknown ppenum);
  /*[id(0x60020005)]*/ int get_Current(out CodePane CodePane);
  /*[id(0x60020005)]*/ int put_Current(CodePane* CodePane);
}

interface _CodePane : IDispatch {
  mixin(uuid("0002e176-0000-0000-c000-000000000046"));
  /*[id(0x60020000)]*/ int get_Collection(out CodePanes retval);
  /*[id(0x60020001)]*/ int get_VBE(out VBE retval);
  /*[id(0x60020002)]*/ int get_Window(out Window retval);
  /*[id(0x60020003)]*/ int GetSelection(out int StartLine, out int StartColumn, out int EndLine, out int EndColumn);
  /*[id(0x60020004)]*/ int SetSelection(int StartLine, int StartColumn, int EndLine, int EndColumn);
  /*[id(0x60020005)]*/ int get_TopLine(out int TopLine);
  /*[id(0x60020005)]*/ int put_TopLine(int TopLine);
  /*[id(0x60020007)]*/ int get_CountOfVisibleLines(out int CountOfVisibleLines);
  /*[id(0x60020008)]*/ int get_CodeModule(out CodeModule CodeModule);
  /*[id(0x60020009)]*/ int Show();
  /*[id(0x6002000A)]*/ int get_CodePaneView(out vbext_CodePaneview pCodePaneview);
}

interface _References : IDispatch {
  mixin(uuid("0002e17a-0000-0000-c000-000000000046"));
  /*[id(0x60020000)]*/ int get_Parent(out VBProject retval);
  /*[id(0x60020001)]*/ int get_VBE(out VBE retval);
  /*[id(0x00000000)]*/ int Item(VARIANT index, out Reference Reference);
  /*[id(0x60020003)]*/ int get_Count(out int Count);
  /*[id(0xFFFFFFFC)]*/ int _NewEnum(out IUnknown ppenum);
  /*[id(0x60020005)]*/ int AddFromGuid(wchar* Guid, int Major, int Minor, out Reference Reference);
  /*[id(0x60020006)]*/ int AddFromFile(wchar* FileName, out Reference Reference);
  /*[id(0x60020007)]*/ int Remove(Reference Reference);
}

interface Reference : IDispatch {
  mixin(uuid("0002e17e-0000-0000-c000-000000000046"));
  /*[id(0x60020000)]*/ int get_Collection(out References retval);
  /*[id(0x60020001)]*/ int get_VBE(out VBE lppaReturn);
  /*[id(0x60020002)]*/ int get_Name(out wchar* pbstrName);
  /*[id(0x60020003)]*/ int get_Guid(out wchar* pbstrGuid);
  /*[id(0x60020004)]*/ int get_Major(out int pMajor);
  /*[id(0x60020005)]*/ int get_Minor(out int pMinor);
  /*[id(0x60020006)]*/ int get_FullPath(out wchar* pbstrLocation);
  /*[id(0x60020007)]*/ int get_BuiltIn(out short pfIsDefault);
  /*[id(0x60020008)]*/ int get_IsBroken(out short pfIsBroken);
  /*[id(0x60020009)]*/ int get_Type(out vbext_RefKind pKind);
  /*[id(0x6002000A)]*/ int get_Description(out wchar* pbstrName);
}

interface _dispReferences_Events : IDispatch {
  mixin(uuid("cdde3804-2064-11cf-867f-00aa005ff34a"));
  /+/*[id(0x00000000)]*/ void ItemAdded(Reference Reference);+/
  /+/*[id(0x00000001)]*/ void ItemRemoved(Reference Reference);+/
}

// CoClasses

abstract final class Windows {
  mixin(uuid("0002e185-0000-0000-c000-000000000046"));
  mixin Interfaces!(_Windows);
}

abstract final class LinkedWindows {
  mixin(uuid("0002e187-0000-0000-c000-000000000046"));
  mixin Interfaces!(_LinkedWindows);
}

abstract final class ReferencesEvents {
  mixin(uuid("0002e119-0000-0000-c000-000000000046"));
  mixin Interfaces!(_ReferencesEvents);
}

abstract final class CommandBarEvents {
  mixin(uuid("0002e132-0000-0000-c000-000000000046"));
  mixin Interfaces!(_CommandBarControlEvents);
}

abstract final class ProjectTemplate {
  mixin(uuid("32cdf9e0-1602-11ce-bfdc-08002b2b8cda"));
  mixin Interfaces!(_ProjectTemplate);
}

abstract final class VBProject {
  mixin(uuid("0002e169-0000-0000-c000-000000000046"));
  mixin Interfaces!(_VBProject);
}

abstract final class VBProjects {
  mixin(uuid("0002e101-0000-0000-c000-000000000046"));
  mixin Interfaces!(_VBProjects);
}

abstract final class Components {
  mixin(uuid("be39f3d6-1b13-11d0-887f-00a0c90f2744"));
  mixin Interfaces!(_Components);
}

abstract final class VBComponents {
  mixin(uuid("be39f3d7-1b13-11d0-887f-00a0c90f2744"));
  mixin Interfaces!(_VBComponents);
}

abstract final class Component {
  mixin(uuid("be39f3d8-1b13-11d0-887f-00a0c90f2744"));
  mixin Interfaces!(_Component);
}

abstract final class VBComponent {
  mixin(uuid("be39f3da-1b13-11d0-887f-00a0c90f2744"));
  mixin Interfaces!(_VBComponent);
}

abstract final class Properties {
  mixin(uuid("0002e18b-0000-0000-c000-000000000046"));
  mixin Interfaces!(_Properties);
}

abstract final class Addins {
  mixin(uuid("da936b63-ac8b-11d1-b6e5-00a0c90f2744"));
  mixin Interfaces!(_AddIns);
}

abstract final class CodeModule {
  mixin(uuid("0002e170-0000-0000-c000-000000000046"));
  mixin Interfaces!(_CodeModule);
}

abstract final class CodePanes {
  mixin(uuid("0002e174-0000-0000-c000-000000000046"));
  mixin Interfaces!(_CodePanes);
}

abstract final class CodePane {
  mixin(uuid("0002e178-0000-0000-c000-000000000046"));
  mixin Interfaces!(_CodePane);
}

abstract final class References {
  mixin(uuid("0002e17c-0000-0000-c000-000000000046"));
  mixin Interfaces!(_References);
}
