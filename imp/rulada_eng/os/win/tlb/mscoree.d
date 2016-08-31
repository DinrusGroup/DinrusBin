// Common Language Runtime Execution Engine 2.4 Library
// Version 2.4

/*[uuid("5477469e-83b1-11d2-8b49-00a0c9b7c9c4")]*/
module os.win.tlb.mscoree;

/*[importlib("stdole2.tlb")]*/
private import os.win.com.core;

// Enums

enum __MIDL___MIDL_itf_mscoree_tlb_0001_0009_0001 {
  ScenarioDefault = 0x00000000,
  ScenarioAll = 0x00000001,
  ScenarioDebug = 0x00000002,
  ScenarioProfile = 0x00000008,
  ScenarioTuningDataCollection = 0x00000010,
  ScenarioLegacy = 0x00000020,
  ScenarioNgenLastRetry = 0x00010000,
}

enum __MIDL___MIDL_itf_mscoree_tlb_0001_0009_0002 {
  ScenarioEmitFixups = 0x00010000,
  ScenarioProfileInfo = 0x00020000,
}

enum __MIDL___MIDL_itf_mscoree_tlb_0001_0011_0001 {
  DbgTypePdb = 0x00000001,
}

enum __MIDL___MIDL_itf_mscoree_tlb_0001_0012_0001 {
  RepositoryDefault = 0x00000000,
  MoveFromRepository = 0x00000001,
  CopyToRepository = 0x00000002,
}

enum CorSvcLogLevel {
  LogLevel_Error = 0x00000000,
  LogLevel_Warning = 0x00000001,
  LogLevel_Success = 0x00000002,
  LogLevel_Info = 0x00000003,
}

// Structs

struct _SvcWorkerPriority {
  uint dwPriorityClass;
}

struct _NGenPrivateAttributes {
  uint Flags;
  uint ZapStats;
  wchar* DbgDir;
}

struct _LARGE_INTEGER {
  long QuadPart;
}

struct _ULARGE_INTEGER {
  ulong QuadPart;
}

struct tagSTATSTG {
  wchar* pwcsName;
  uint type;
  _ULARGE_INTEGER cbSize;
  _FILETIME mtime;
  _FILETIME ctime;
  _FILETIME atime;
  uint grfMode;
  uint grfLocksSupported;
  GUID clsid;
  uint grfStateBits;
  uint reserved;
}

struct _FILETIME {
  uint dwLowDateTime;
  uint dwHighDateTime;
}

struct _COR_GC_STATS {
  uint Flags;
  ULONG_PTR ExplicitGCCount;
  ULONG_PTR[3] GenCollectionsTaken;
  ULONG_PTR CommittedKBytes;
  ULONG_PTR ReservedKBytes;
  ULONG_PTR Gen0HeapSizeKBytes;
  ULONG_PTR Gen1HeapSizeKBytes;
  ULONG_PTR Gen2HeapSizeKBytes;
  ULONG_PTR LargeObjectHeapSizeKBytes;
  ULONG_PTR KBytesPromotedFromGen0;
  ULONG_PTR KBytesPromotedFromGen1;
}

struct _COR_GC_THREAD_STATS {
  ulong PerThreadAllocation;
  uint Flags;
}

struct tag_VerError {
  uint Flags;
  uint opcode;
  uint uOffset;
  uint Token;
  uint item1_flags;
  int* item1_data;
  uint item2_flags;
  int* item2_data;
}

// Aliases

alias __MIDL___MIDL_itf_mscoree_tlb_0001_0009_0001 OptimizationScenario;

alias __MIDL___MIDL_itf_mscoree_tlb_0001_0009_0002 PrivateOptimizationScenario;

alias __MIDL___MIDL_itf_mscoree_tlb_0001_0011_0001 NGenPrivateAttributesFlags;

alias __MIDL___MIDL_itf_mscoree_tlb_0001_0012_0001 RepositoryFlags;

alias uint ULONG_PTR;

// Interfaces

interface ICorSvcDependencies : IUnknown {
  mixin(uuid("ddb34005-9ba3-4025-9554-f00a2df5dbf5"));
  /*[id(0x60010000)]*/ int GetAssemblyDependencies(wchar* pAssemblyName, out  pDependencies, out uint assemblyNGenSetting, out wchar* pNativeImageIdentity, out wchar* pAssemblyDisplayName, out  pDependencyLoadSetting, out  pDependencyNGenSetting);
}

interface ICorSvcWorker : IUnknown {
  mixin(uuid("d1047bc2-67c0-400c-a94c-e64446a67fbe"));
  /*[id(0x60010000)]*/ int SetPriority(_SvcWorkerPriority priority);
  /*[id(0x60010001)]*/ int OptimizeAssembly(wchar* pAssemblyName, wchar* pApplicationName, OptimizationScenario scenario,  loadAlwaysList,  loadSometimesList,  loadNeverList, out wchar* pNativeImageIdentity);
  /*[id(0x60010002)]*/ int DeleteNativeImage(wchar* pAssemblyName, wchar* pNativeImage);
  /*[id(0x60010003)]*/ int DisplayNativeImages(wchar* pAssemblyName);
  /*[id(0x60010004)]*/ int GetCorSvcDependencies(wchar* pApplicationName, OptimizationScenario scenario, out ICorSvcDependencies pCorSvcDependencies);
  /*[id(0x60010005)]*/ int Stop();
}

interface ICorSvcWorker2 : ICorSvcWorker {
  mixin(uuid("f3358a7d-0061-4776-880e-a2f21b9ef93e"));
  /*[id(0x60020000)]*/ int CreatePdb(wchar* pAssemblyName, wchar* pAppBaseOrConfig, OptimizationScenario scenario, wchar* pNativeImagePath, wchar* pPdbPath);
}

interface ICorSvcSetPrivateAttributes : IUnknown {
  mixin(uuid("b18e0b40-c089-4350-8328-066c668bccc2"));
  /*[id(0x60010000)]*/ int SetNGenPrivateAttributes(_NGenPrivateAttributes ngenPrivateAttributes);
}

interface ICorSvcRepository : IUnknown {
  mixin(uuid("d5346658-b5fd-4353-9647-07ad4783d5a0"));
  /*[id(0x60010000)]*/ int SetRepository(wchar* pRepositoryDir, RepositoryFlags RepositoryFlags);
}

interface ICorSvcLogger : IUnknown {
  mixin(uuid("d189ff1a-e266-4f13-9637-4b9522279ffc"));
  /*[id(0x60010000)]*/ int Log(CorSvcLogLevel logLevel, wchar* message);
}

interface ICorSvcPooledWorker : IUnknown {
  mixin(uuid("0631e7e2-6046-4fde-8b6d-a09b64fda6f3"));
  /*[id(0x60010000)]*/ int CanReuseProcess(OptimizationScenario scenario, ICorSvcLogger pCorSvcLogger, out int pCanContinue);
}

interface ICorSvcBindToWorker : IUnknown {
  mixin(uuid("5c6fb596-4828-4ed5-b9dd-293dad736fb5"));
  /*[id(0x60010000)]*/ int BindToRuntimeWorker(wchar* pRuntimeVersion, uint ParentProcessID, wchar* pInterruptEventName, ICorSvcLogger pCorSvcLogger, out ICorSvcWorker pCorSvcWorker);
}

// Type name parser
interface ITypeName : IUnknown {
  mixin(uuid("b81ff171-20f3-11d2-8dcc-00a0c9b00522"));
  /*[id(0x60010000)]*/ int GetNameCount(out uint pCount);
  /*[id(0x60010001)]*/ int GetNames(uint count, out wchar* rgbszNames, out uint pCount);
  /*[id(0x60010002)]*/ int GetTypeArgumentCount(out uint pCount);
  /*[id(0x60010003)]*/ int GetTypeArguments(uint count, out ITypeName rgpArguments, out uint pCount);
  /*[id(0x60010004)]*/ int GetModifierLength(out uint pCount);
  /*[id(0x60010005)]*/ int GetModifiers(uint count, out uint rgModifiers, out uint pCount);
  /*[id(0x60010006)]*/ int GetAssemblyName(out wchar* rgbszAssemblyNames);
}

// Type name builder
interface ITypeNameBuilder : IUnknown {
  mixin(uuid("b81ff171-20f3-11d2-8dcc-00a0c9b00523"));
  /*[id(0x60010000)]*/ int OpenGenericArguments();
  /*[id(0x60010001)]*/ int CloseGenericArguments();
  /*[id(0x60010002)]*/ int OpenGenericArgument();
  /*[id(0x60010003)]*/ int CloseGenericArgument();
  /*[id(0x60010004)]*/ int AddName(wchar* szName);
  /*[id(0x60010005)]*/ int AddPointer();
  /*[id(0x60010006)]*/ int AddByRef();
  /*[id(0x60010007)]*/ int AddSzArray();
  /*[id(0x60010008)]*/ int AddArray(uint rank);
  /*[id(0x60010009)]*/ int AddAssemblySpec(wchar* szAssemblySpec);
  /*[id(0x6001000A)]*/ int ToString(out wchar* pszStringRepresentation);
  /*[id(0x6001000B)]*/ int Clear();
}

// Type name builder and parser factory
interface ITypeNameFactory : IUnknown {
  mixin(uuid("b81ff171-20f3-11d2-8dcc-00a0c9b00521"));
  /*[id(0x60010000)]*/ int ParseTypeName(wchar* szName, out uint pError, out ITypeName ppTypeName);
  /*[id(0x60010001)]*/ int GetTypeNameBuilder(out ITypeNameBuilder ppTypeBuilder);
}

// Apartment callback interface
interface IApartmentCallback : IUnknown {
  mixin(uuid("178e5337-1528-4591-b1c9-1c6e484686d8"));
  /*[id(0x60010000)]*/ int DoCallback(ULONG_PTR pFunc, ULONG_PTR pData);
}

// Managed Object Interface
interface IManagedObject : IUnknown {
  mixin(uuid("c3fcc19e-a970-11d2-8b5a-00a0c9b7c9c4"));
  /*[id(0x60010000)]*/ int GetSerializedBuffer(out wchar* pBSTR);
  /*[id(0x60010001)]*/ int GetObjectIdentity(out wchar* pBSTRGUID, out int AppDomainID, out int pCCW);
}

// ICatalogServices Interface
interface ICatalogServices : IUnknown {
  mixin(uuid("04c6be1e-1db1-4058-ab7a-700cccfbf254"));
  /*[id(0x60010000)]*/ int Autodone();
  /*[id(0x60010001)]*/ int NotAutodone();
}

interface IMarshal : IUnknown {
  mixin(uuid("00000003-0000-0000-c000-000000000046"));
  /*[id(0x60010000)]*/ int GetUnmarshalClass(ref GUID riid, void* pv, uint dwDestContext, void* pvDestContext, uint mshlflags, out GUID pCid);
  /*[id(0x60010001)]*/ int GetMarshalSizeMax(ref GUID riid, void* pv, uint dwDestContext, void* pvDestContext, uint mshlflags, out uint pSize);
  /*[id(0x60010002)]*/ int MarshalInterface(IStream* pstm, ref GUID riid, void* pv, uint dwDestContext, void* pvDestContext, uint mshlflags);
  /*[id(0x60010003)]*/ int UnmarshalInterface(IStream pstm, ref GUID riid, void* ppv);
  /*[id(0x60010004)]*/ int ReleaseMarshalData(IStream pstm);
  /*[id(0x60010005)]*/ int DisconnectObject(uint dwReserved);
}

interface IStream : ISequentialStream {
  mixin(uuid("0000000c-0000-0000-c000-000000000046"));
  /*[id(0x60020000)]*/ int Seek(_LARGE_INTEGER dlibMove, uint dwOrigin, _ULARGE_INTEGER* plibNewPosition);
  /*[id(0x60020001)]*/ int RemoteSeek(_LARGE_INTEGER dlibMove, uint dwOrigin, out _ULARGE_INTEGER plibNewPosition);
  /*[id(0x60020002)]*/ int SetSize(_ULARGE_INTEGER libNewSize);
  /*[id(0x60020003)]*/ int CopyTo(IStream pstm, _ULARGE_INTEGER cb, _ULARGE_INTEGER* pcbRead, _ULARGE_INTEGER* pcbWritten);
  /*[id(0x60020004)]*/ int RemoteCopyTo(IStream pstm, _ULARGE_INTEGER cb, out _ULARGE_INTEGER pcbRead, out _ULARGE_INTEGER pcbWritten);
  /*[id(0x60020005)]*/ int Commit(uint grfCommitFlags);
  /*[id(0x60020006)]*/ int Revert();
  /*[id(0x60020007)]*/ int LockRegion(_ULARGE_INTEGER libOffset, _ULARGE_INTEGER cb, uint dwLockType);
  /*[id(0x60020008)]*/ int UnlockRegion(_ULARGE_INTEGER libOffset, _ULARGE_INTEGER cb, uint dwLockType);
  /*[id(0x60020009)]*/ int Stat(out tagSTATSTG pstatstg, uint grfStatFlag);
  /*[id(0x6002000A)]*/ int Clone(out IStream ppstm);
}

interface ISequentialStream : IUnknown {
  mixin(uuid("0c733a30-2a1c-11ce-ade5-00aa0044773d"));
  /*[id(0x60010000)]*/ int Read(void* pv, uint cb, uint* pcbRead);
  /*[id(0x60010001)]*/ int RemoteRead(out ubyte pv, uint cb, out uint pcbRead);
  /*[id(0x60010002)]*/ int Write(void* pv, uint cb, uint* pcbWritten);
  /*[id(0x60010003)]*/ int RemoteWrite(ubyte* pv, uint cb, out uint pcbWritten);
}

// Common Language Runtime Hosting Interface
interface ICorRuntimeHost : IUnknown {
  mixin(uuid("cb2f6722-ab3a-11d2-9c40-00c04fa30a3e"));
  /*[id(0x60010000)]*/ int CreateLogicalThreadState();
  /*[id(0x60010001)]*/ int DeleteLogicalThreadState();
  /*[id(0x60010002)]*/ int SwitchInLogicalThreadState(uint* pFiberCookie);
  /*[id(0x60010003)]*/ int SwitchOutLogicalThreadState(out uint pFiberCookie);
  /*[id(0x60010004)]*/ int LocksHeldByLogicalThread(out uint pCount);
  /*[id(0x60010005)]*/ int MapFile(void* hFile, void* hMapAddress);
  /*[id(0x60010006)]*/ int GetConfiguration(out ICorConfiguration pConfiguration);
  /*[id(0x60010007)]*/ int Start();
  /*[id(0x60010008)]*/ int Stop();
  /*[id(0x60010009)]*/ int CreateDomain(wchar* pwzFriendlyName, IUnknown pIdentityArray, out IUnknown pAppDomain);
  /*[id(0x6001000A)]*/ int GetDefaultDomain(out IUnknown pAppDomain);
  /*[id(0x6001000B)]*/ int EnumDomains(void* hEnum);
  /*[id(0x6001000C)]*/ int NextDomain(void* hEnum, out IUnknown pAppDomain);
  /*[id(0x6001000D)]*/ int CloseEnum(void* hEnum);
  /*[id(0x6001000E)]*/ int CreateDomainEx(wchar* pwzFriendlyName, IUnknown pSetup, IUnknown pEvidence, out IUnknown pAppDomain);
  /*[id(0x6001000F)]*/ int CreateDomainSetup(out IUnknown pAppDomainSetup);
  /*[id(0x60010010)]*/ int CreateEvidence(out IUnknown pEvidence);
  /*[id(0x60010011)]*/ int UnloadDomain(IUnknown pAppDomain);
  /*[id(0x60010012)]*/ int CurrentDomain(out IUnknown pAppDomain);
}

// Common Language Runtime Configuration Interface
interface ICorConfiguration : IUnknown {
  mixin(uuid("5c2b07a5-1e98-11d3-872f-00c04f79ed0d"));
  /*[id(0x60010000)]*/ int SetGCThreadControl(IGCThreadControl pGCThreadControl);
  /*[id(0x60010001)]*/ int SetGCHostControl(IGCHostControl pGCHostControl);
  /*[id(0x60010002)]*/ int SetDebuggerThreadControl(IDebuggerThreadControl pDebuggerThreadControl);
  /*[id(0x60010003)]*/ int AddDebuggerSpecialThread(uint dwSpecialThreadId);
}

// Control over threads blocked in GC
interface IGCThreadControl : IUnknown {
  mixin(uuid("f31d1788-c397-4725-87a5-6af3472c2791"));
  /*[id(0x60010000)]*/ int ThreadIsBlockingForSuspension();
  /*[id(0x60010001)]*/ int SuspensionStarting();
  /*[id(0x60010002)]*/ int SuspensionEnding(uint Generation);
}

// Request change in virtual memory for GC
interface IGCHostControl : IUnknown {
  mixin(uuid("5513d564-8374-4cb9-aed9-0083f4160a1d"));
  /*[id(0x60010000)]*/ int RequestVirtualMemLimit(ULONG_PTR sztMaxVirtualMemMB, ref ULONG_PTR psztNewMaxVirtualMemMB);
}

// Control over threads blocked in debugging services
interface IDebuggerThreadControl : IUnknown {
  mixin(uuid("23d86786-0bb5-4774-8fb5-e3522add6246"));
  /*[id(0x60010000)]*/ int ThreadIsBlockingForDebugger();
  /*[id(0x60010001)]*/ int ReleaseAllRuntimeThreads();
  /*[id(0x60010002)]*/ int StartBlockingForDebugger(uint dwUnused);
}

interface IGCHost : IUnknown {
  mixin(uuid("fac34f6e-0dcd-47b5-8021-531bc5ecca63"));
  /*[id(0x60010000)]*/ int SetGCStartupLimits(uint SegmentSize, uint MaxGen0Size);
  /*[id(0x60010001)]*/ int Collect(int Generation);
  /*[id(0x60010002)]*/ int GetStats(ref _COR_GC_STATS pStats);
  /*[id(0x60010003)]*/ int GetThreadStats(uint* pFiberCookie, ref _COR_GC_THREAD_STATS pStats);
  /*[id(0x60010004)]*/ int SetVirtualMemLimit(ULONG_PTR sztMaxVirtualMemMB);
}

interface IValidator : IUnknown {
  mixin(uuid("63df8730-dc81-4062-84a2-1ff943f59fac"));
  /*[id(0x60010000)]*/ int Validate(IVEHandler veh, IUnknown pAppDomain, uint ulFlags, uint ulMaxError, uint Token, wchar* fileName, ubyte* pe, uint ulSize);
  /*[id(0x60010001)]*/ int FormatEventInfo(int hVECode, tag_VerError Context, ref wchar* msg, uint ulMaxLength,  psa);
}

interface IVEHandler : IUnknown {
  mixin(uuid("856ca1b2-7dab-11d3-acec-00c04f86c309"));
  /*[id(0x60010000)]*/ int VEHandler(int VECode, tag_VerError Context,  psa);
  /*[id(0x60010001)]*/ int SetReporterFtn(long lFnPtr);
}

// Information on the state of the debugging services
interface IDebuggerInfo : IUnknown {
  mixin(uuid("bf24142d-a47d-4d24-a66d-8c2141944e44"));
  /*[id(0x60010000)]*/ int IsDebuggerAttached(out int pbAttached);
}

// Common Language Runtime Hosting Interface
interface ICLRRuntimeHost : IUnknown {
  mixin(uuid("90f1a06c-7712-4762-86b5-7a5eba6bdb02"));
  /*[id(0x60010000)]*/ int Start();
  /*[id(0x60010001)]*/ int Stop();
  /*[id(0x60010002)]*/ int SetHostControl(IHostControl pHostControl);
  /*[id(0x60010003)]*/ int GetCLRControl(out ICLRControl pCLRControl);
  /*[id(0x60010004)]*/ int UnloadAppDomain(uint dwAppDomainID, int fWaitUntilDone);
  /*[id(0x60010005)]*/ int __MIDL____MIDL_itf_mscoree_tlb_0000_00000000(void* cookie);
  /*[id(0x60010006)]*/ int ExecuteInAppDomain(uint dwAppDomainID, ICLRRuntimeHost pCallback, void* cookie);
  /*[id(0x60010007)]*/ int GetCurrentAppDomainId(out uint pdwAppDomainId);
  /*[id(0x60010008)]*/ int ExecuteApplication(wchar* pwzAppFullName, uint dwManifestPaths, wchar** ppwzManifestPaths, uint dwActivationData, wchar** ppwzActivationData, out int pReturnValue);
  /*[id(0x60010009)]*/ int ExecuteInDefaultAppDomain(wchar* pwzAssemblyPath, wchar* pwzTypeName, wchar* pwzMethodName, wchar* pwzArgument, out uint pReturnValue);
}

// Common Language Runtime Host Control Interface
interface IHostControl : IUnknown {
  mixin(uuid("02ca073c-7079-4860-880a-c2f7a449c991"));
  /*[id(0x60010000)]*/ int GetHostManager(ref GUID riid, void* ppObject);
  /*[id(0x60010001)]*/ int SetAppDomainManager(uint dwAppDomainID, IUnknown pUnkAppDomainManager);
}

// Common Language Runtime Control Interface
interface ICLRControl : IUnknown {
  mixin(uuid("9065597e-d1a1-4fb2-b6ba-7e1fce230f61"));
  /*[id(0x60010000)]*/ int GetCLRManager(ref GUID riid, void* ppObject);
  /*[id(0x60010001)]*/ int SetAppDomainManagerType(wchar* pwzAppDomainManagerAssembly, wchar* pwzAppDomainManagerType);
}

interface ICLRValidator : IUnknown {
  mixin(uuid("63df8730-dc81-4062-84a2-1ff943f59fdd"));
  /*[id(0x60010000)]*/ int Validate(IVEHandler veh, uint ulAppDomainId, uint ulFlags, uint ulMaxError, uint Token, wchar* fileName, ubyte* pe, uint ulSize);
  /*[id(0x60010001)]*/ int FormatEventInfo(int hVECode, tag_VerError Context, ref wchar* msg, uint ulMaxLength,  psa);
}

// CoClasses

// Com Call Wrapper Unmarshalling Class
abstract final class ComCallUnmarshal {
  mixin(uuid("3f281000-e95a-11d2-886b-00c04f869f04"));
  mixin Interfaces!(IMarshal);
}

// Com Call Wrapper Unmarshalling Class 4.0
abstract final class ComCallUnmarshalV4 {
  mixin(uuid("45fb4600-e6e8-4928-b25e-50476ff79425"));
  mixin Interfaces!(IMarshal);
}

// Cor Runtime Hosting Class
abstract final class CorRuntimeHost {
  mixin(uuid("cb2f6723-ab3a-11d2-9c40-00c04fa30a3e"));
  mixin Interfaces!(ICorRuntimeHost, IGCHost, ICorConfiguration, IValidator, IDebuggerInfo);
}

// CLR Runtime Hosting Class V2
abstract final class CLRRuntimeHost {
  mixin(uuid("90f1a06e-7712-4762-86b5-7a5eba6bdb02"));
  mixin Interfaces!(ICLRRuntimeHost, ICLRValidator);
}

// TypeName parser and builder
abstract final class TypeNameFactory {
  mixin(uuid("b81ff171-20f3-11d2-8dcc-00a0c9b00525"));
  mixin Interfaces!(ITypeNameFactory);
}
