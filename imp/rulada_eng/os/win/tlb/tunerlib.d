// Microsoft Tuner 1.0 Type Library
// Version 1.0

/*[uuid("9b085638-018e-11d3-9d8e-00c04f72d980")]*/
module os.win.tlb.tunerlib;

/*[importlib("STDOLE2.TLB")]*/
private import os.win.com.core;

// Enums

enum ComponentCategory {
  CategoryNotSet = 0xFFFFFFFF,
  CategoryOther = 0x00000000,
  CategoryVideo = 0x00000001,
  CategoryAudio = 0x00000002,
  CategoryText = 0x00000003,
  CategoryData = 0x00000004,
}

enum ComponentStatus {
  StatusActive = 0x00000000,
  StatusInactive = 0x00000001,
  StatusUnavailable = 0x00000002,
}

enum FECMethod {
  BDA_FEC_METHOD_NOT_SET = 0xFFFFFFFF,
  BDA_FEC_METHOD_NOT_DEFINED = 0x00000000,
  BDA_FEC_VITERBI = 0x00000001,
  BDA_FEC_RS_204_188 = 0x00000002,
  BDA_FEC_MAX = 0x00000003,
}

enum BinaryConvolutionCodeRate {
  BDA_BCC_RATE_NOT_SET = 0xFFFFFFFF,
  BDA_BCC_RATE_NOT_DEFINED = 0x00000000,
  BDA_BCC_RATE_1_2 = 0x00000001,
  BDA_BCC_RATE_2_3 = 0x00000002,
  BDA_BCC_RATE_3_4 = 0x00000003,
  BDA_BCC_RATE_3_5 = 0x00000004,
  BDA_BCC_RATE_4_5 = 0x00000005,
  BDA_BCC_RATE_5_6 = 0x00000006,
  BDA_BCC_RATE_5_11 = 0x00000007,
  BDA_BCC_RATE_7_8 = 0x00000008,
  BDA_BCC_RATE_MAX = 0x00000009,
}

enum ModulationType {
  BDA_MOD_NOT_SET = 0xFFFFFFFF,
  BDA_MOD_NOT_DEFINED = 0x00000000,
  BDA_MOD_16QAM = 0x00000001,
  BDA_MOD_32QAM = 0x00000002,
  BDA_MOD_64QAM = 0x00000003,
  BDA_MOD_80QAM = 0x00000004,
  BDA_MOD_96QAM = 0x00000005,
  BDA_MOD_112QAM = 0x00000006,
  BDA_MOD_128QAM = 0x00000007,
  BDA_MOD_160QAM = 0x00000008,
  BDA_MOD_192QAM = 0x00000009,
  BDA_MOD_224QAM = 0x0000000A,
  BDA_MOD_256QAM = 0x0000000B,
  BDA_MOD_320QAM = 0x0000000C,
  BDA_MOD_384QAM = 0x0000000D,
  BDA_MOD_448QAM = 0x0000000E,
  BDA_MOD_512QAM = 0x0000000F,
  BDA_MOD_640QAM = 0x00000010,
  BDA_MOD_768QAM = 0x00000011,
  BDA_MOD_896QAM = 0x00000012,
  BDA_MOD_1024QAM = 0x00000013,
  BDA_MOD_QPSK = 0x00000014,
  BDA_MOD_BPSK = 0x00000015,
  BDA_MOD_OQPSK = 0x00000016,
  BDA_MOD_8VSB = 0x00000017,
  BDA_MOD_16VSB = 0x00000018,
  BDA_MOD_ANALOG_AMPLITUDE = 0x00000019,
  BDA_MOD_ANALOG_FREQUENCY = 0x0000001A,
  BDA_MOD_MAX = 0x0000001B,
}

enum tagTunerInputType {
  TunerInputCable = 0x00000000,
  TunerInputAntenna = 0x00000001,
}

enum DVBSystemType {
  DVB_Cable = 0x00000000,
  DVB_Terrestrial = 0x00000001,
  DVB_Satellite = 0x00000002,
}

enum SpectralInversion {
  BDA_SPECTRAL_INVERSION_NOT_SET = 0xFFFFFFFF,
  BDA_SPECTRAL_INVERSION_NOT_DEFINED = 0x00000000,
  BDA_SPECTRAL_INVERSION_AUTOMATIC = 0x00000001,
  BDA_SPECTRAL_INVERSION_NORMAL = 0x00000002,
  BDA_SPECTRAL_INVERSION_INVERTED = 0x00000003,
  BDA_SPECTRAL_INVERSION_MAX = 0x00000004,
}

enum MPEG2StreamType {
  BDA_UNITIALIZED_MPEG2STREAMTYPE = 0xFFFFFFFF,
  Reserved1 = 0x00000000,
  ISO_IEC_11172_2_VIDEO = 0x00000001,
  ISO_IEC_13818_2_VIDEO = 0x00000002,
  ISO_IEC_11172_3_AUDIO = 0x00000003,
  ISO_IEC_13818_3_AUDIO = 0x00000004,
  ISO_IEC_13818_1_PRIVATE_SECTION = 0x00000005,
  ISO_IEC_13818_1_PES = 0x00000006,
  ISO_IEC_13522_MHEG = 0x00000007,
  ANNEX_A_DSM_CC = 0x00000008,
  ITU_T_REC_H_222_1 = 0x00000009,
  ISO_IEC_13818_6_TYPE_A = 0x0000000A,
  ISO_IEC_13818_6_TYPE_B = 0x0000000B,
  ISO_IEC_13818_6_TYPE_C = 0x0000000C,
  ISO_IEC_13818_6_TYPE_D = 0x0000000D,
  ISO_IEC_13818_1_AUXILIARY = 0x0000000E,
  ISO_IEC_13818_1_RESERVED = 0x0000000F,
  USER_PRIVATE = 0x00000010,
}

enum HierarchyAlpha {
  BDA_HALPHA_NOT_SET = 0xFFFFFFFF,
  BDA_HALPHA_NOT_DEFINED = 0x00000000,
  BDA_HALPHA_1 = 0x00000001,
  BDA_HALPHA_2 = 0x00000002,
  BDA_HALPHA_4 = 0x00000003,
  BDA_HALPHA_MAX = 0x00000004,
}

enum GuardInterval {
  BDA_GUARD_NOT_SET = 0xFFFFFFFF,
  BDA_GUARD_NOT_DEFINED = 0x00000000,
  BDA_GUARD_1_32 = 0x00000001,
  BDA_GUARD_1_16 = 0x00000002,
  BDA_GUARD_1_8 = 0x00000003,
  BDA_GUARD_1_4 = 0x00000004,
  BDA_GUARD_MAX = 0x00000005,
}

enum TransmissionMode {
  BDA_XMIT_MODE_NOT_SET = 0xFFFFFFFF,
  BDA_XMIT_MODE_NOT_DEFINED = 0x00000000,
  BDA_XMIT_MODE_2K = 0x00000001,
  BDA_XMIT_MODE_8K = 0x00000002,
  BDA_XMIT_MODE_MAX = 0x00000003,
}

enum Polarisation {
  BDA_POLARISATION_NOT_SET = 0xFFFFFFFF,
  BDA_POLARISATION_NOT_DEFINED = 0x00000000,
  BDA_POLARISATION_LINEAR_H = 0x00000001,
  BDA_POLARISATION_LINEAR_V = 0x00000002,
  BDA_POLARISATION_CIRCULAR_L = 0x00000003,
  BDA_POLARISATION_CIRCULAR_R = 0x00000004,
  BDA_POLARISATION_MAX = 0x00000005,
}

enum _FilterState {
  State_Stopped = 0x00000000,
  State_Paused = 0x00000001,
  State_Running = 0x00000002,
}

enum _PinDirection {
  PINDIR_INPUT = 0x00000000,
  PINDIR_OUTPUT = 0x00000001,
}

// Structs

struct _AMMediaType {
  GUID majortype;
  GUID subtype;
  int bFixedSizeSamples;
  int bTemporalCompression;
  uint lSampleSize;
  GUID formattype;
  IUnknown pUnk;
  uint cbFormat;
  ubyte* pbFormat;
}

struct _LARGE_INTEGER {
  long QuadPart;
}

struct _ULARGE_INTEGER {
  ulong QuadPart;
}

struct tagSTATSTG {
  wchar* pwcsName;
  uint Type;
  _ULARGE_INTEGER cbSize;
  _FILETIME mtime;
  _FILETIME ctime;
  _FILETIME atime;
  uint grfMode;
  uint grfLocksSupported;
  GUID CLSID;
  uint grfStateBits;
  uint reserved;
}

struct _FILETIME {
  uint dwLowDateTime;
  uint dwHighDateTime;
}

struct tagBIND_OPTS2 {
  uint cbStruct;
  uint grfFlags;
  uint grfMode;
  uint dwTickCountDeadline;
  uint dwTrackFlags;
  uint dwClassContext;
  uint locale;
  _COSERVERINFO* pServerInfo;
}

struct _COSERVERINFO {
  uint dwReserved1;
  wchar* pwszName;
  _COAUTHINFO* pAuthInfo;
  uint dwReserved2;
}

struct _COAUTHINFO {
  uint dwAuthnSvc;
  uint dwAuthzSvc;
  wchar* pwszServerPrincName;
  uint dwAuthnLevel;
  uint dwImpersonationLevel;
  _COAUTHIDENTITY* pAuthIdentityData;
  uint dwCapabilities;
}

struct _COAUTHIDENTITY {
  ushort* User;
  uint UserLength;
  ushort* Domain;
  uint DomainLength;
  ushort* Password;
  uint PasswordLength;
  uint Flags;
}

struct _PinInfo {
  IBaseFilter pFilter;
  _PinDirection dir;
  ushort[128] achName;
}

struct _FilterInfo {
  ushort[128] achName;
  IFilterGraph pGraph;
}

// Aliases

alias uint ULONG_PTR;

// Interfaces

// Tuning Space Container Interface
interface ITuningSpaceContainer : IDispatch {
  mixin(uuid("5b692e84-e2f1-11d2-9493-00c04f72d980"));
  // Number of items in the collection
  /*[id(0x60020000)]*/ int get_Count(out int Count);
  /*[id(0xFFFFFFFC)]*/ int get__NewEnum(out IEnumVARIANT NewEnum);
  // Find the Tuning Space with the specified Index
  /*[id(0x00000000)]*/ int get_Item(VARIANT varIndex, out ITuningSpace TuningSpace);
  // Find the Tuning Space with the specified Index
  /*[id(0x00000000)]*/ int put_Item(VARIANT varIndex, ITuningSpace TuningSpace);
  // Returns the collection of Tuning Spaces with the same implementation
  /*[id(0x60020004)]*/ int TuningSpacesForCLSID(wchar* SpaceCLSID, out ITuningSpaces NewColl);
  // Convenience Function for enumerating from C
  /*[id(0x60020005)]*/ int _TuningSpacesForCLSID(ref GUID SpaceCLSID, out ITuningSpaces NewColl);
  // Returns the collection of Tuning Spaces matching the name
  /*[id(0x60020006)]*/ int TuningSpacesForName(wchar* Name, out ITuningSpaces NewColl);
  // Find Local ID Number of the specified Tuning Space
  /*[id(0x60020007)]*/ int FindID(ITuningSpace TuningSpace, out int ID);
  // Add a new Tuning Space to the collection.  This tuning space will be persisted unless removed
  /*[id(0xFFFFFDD7)]*/ int Add(ITuningSpace TuningSpace, out VARIANT NewIndex);
  // Convenience Function for enumerating collection from C
  /*[id(0x60020009)]*/ int get_EnumTuningSpaces(out IEnumTuningSpaces ppEnum);
  // Remove a Tuning Space from the collection.  this tuning space will be deleted from the registry
  /*[id(0xFFFFFDD5)]*/ int Remove(VARIANT Index);
  // Maximum number of items allowed in the collection
  /*[id(0x6002000B)]*/ int get_MaxCount(out int MaxCount);
  // Maximum number of items allowed in the collection
  /*[id(0x6002000B)]*/ int put_MaxCount(int MaxCount);
}

// Tuning Space Interface
interface ITuningSpace : IDispatch {
  mixin(uuid("061c6e30-e622-11d2-9493-00c04f72d980"));
  // Unique name of the Tuning Space
  /*[id(0x00000001)]*/ int get_UniqueName(out wchar* Name);
  // Unique name of the Tuning Space
  /*[id(0x00000001)]*/ int put_UniqueName(wchar* Name);
  // User-friendly name of the Tuning Space
  /*[id(0x00000002)]*/ int get_FriendlyName(out wchar* Name);
  // User-friendly name of the Tuning Space
  /*[id(0x00000002)]*/ int put_FriendlyName(wchar* Name);
  // Returns the clsid of the tuning space implementation.  provides script access to IPersist:GetClassID
  /*[id(0x00000003)]*/ int get_CLSID(out wchar* SpaceCLSID);
  // Network Type (Network Proivder CLSID)
  /*[id(0x00000004)]*/ int get_NetworkType(out wchar* NetworkTypeGuid);
  // Network Type (Network Proivder CLSID)
  /*[id(0x00000004)]*/ int put_NetworkType(wchar* NetworkTypeGuid);
  // Network Type (Network Proivder CLSID)
  /*[id(0x00000005)]*/ int get__NetworkType(out GUID NetworkTypeGuid);
  // Network Type (Network Proivder CLSID)
  /*[id(0x00000005)]*/ int put__NetworkType(ref GUID NetworkTypeGuid);
  // Create a Tune Request object
  /*[id(0x00000006)]*/ int CreateTuneRequest(out ITuneRequest TuneRequest);
  /*[id(0x00000007)]*/ int EnumCategoryGUIDs(out IEnumGUID ppEnum);
  /*[id(0x00000008)]*/ int EnumDeviceMonikers(out IEnumMoniker ppEnum);
  /*[id(0x00000009)]*/ int get_DefaultPreferredComponentTypes(out IComponentTypes ComponentTypes);
  /*[id(0x00000009)]*/ int put_DefaultPreferredComponentTypes(IComponentTypes ComponentTypes);
  /*[id(0x0000000A)]*/ int get_FrequencyMapping(out wchar* pMapping);
  /*[id(0x0000000A)]*/ int put_FrequencyMapping(wchar* pMapping);
  /*[id(0x0000000B)]*/ int get_DefaultLocator(out ILocator LocatorVal);
  /*[id(0x0000000B)]*/ int put_DefaultLocator(ILocator LocatorVal);
  /*[id(0x60020012)]*/ int Clone(out ITuningSpace NewTS);
}

// Tune Request Interface
interface ITuneRequest : IDispatch {
  mixin(uuid("07ddc146-fc3d-11d2-9d8c-00c04f72d980"));
  // Tuning Space object
  /*[id(0x00000001)]*/ int get_TuningSpace(out ITuningSpace TuningSpace);
  // Components collection
  /*[id(0x00000002)]*/ int get_Components(out IComponents Components);
  // Create a new copy of this tune request
  /*[id(0x00000003)]*/ int Clone(out ITuneRequest NewTuneRequest);
  // Locator Object
  /*[id(0x00000004)]*/ int get_Locator(out ILocator Locator);
  // Locator Object
  /*[id(0x00000004)]*/ int put_Locator(ILocator Locator);
}

// Component Collection Interface
interface IComponents : IDispatch {
  mixin(uuid("fcd01846-0e19-11d3-9d8e-00c04f72d980"));
  // Number of items in the collection
  /*[id(0x60020000)]*/ int get_Count(out int Count);
  /*[id(0xFFFFFFFC)]*/ int get__NewEnum(out IEnumVARIANT ppNewEnum);
  // Convenience Function for Use with C
  /*[id(0x60020002)]*/ int EnumComponents(out IEnumComponents ppNewEnum);
  // Get the Component at the specified index
  /*[id(0x00000000)]*/ int get_Item(VARIANT Index, out IComponent ppComponent);
  // Add the Component to the collection
  /*[id(0xFFFFFDD7)]*/ int Add(IComponent Component, out VARIANT NewIndex);
  // Remove the Component at the specified index
  /*[id(0xFFFFFDD5)]*/ int Remove(VARIANT Index);
  // Copy the collection
  /*[id(0x60020006)]*/ int Clone(out IComponents NewList);
}

interface IEnumComponents : IUnknown {
  mixin(uuid("2a6e2939-2595-11d3-b64c-00c04f79498e"));
  /*[id(0x60010000)]*/ int Next(uint celt, out IComponent rgelt, out uint pceltFetched);
  /*[id(0x60010001)]*/ int Skip(uint celt);
  /*[id(0x60010002)]*/ int Reset();
  /*[id(0x60010003)]*/ int Clone(out IEnumComponents ppEnum);
}

// Component Interface
interface IComponent : IDispatch {
  mixin(uuid("1a5576fc-0e19-11d3-9d8e-00c04f72d980"));
  // Component Type
  /*[id(0x00000001)]*/ int get_Type(out IComponentType CT);
  // Component Type
  /*[id(0x00000001)]*/ int put_Type(IComponentType CT);
  // Language Identifier for Description Language
  /*[id(0x00000003)]*/ int get_DescLangID(out int LangID);
  // Language Identifier for Description Language
  /*[id(0x00000003)]*/ int put_DescLangID(int LangID);
  // Component Status
  /*[id(0x00000002)]*/ int get_Status(out ComponentStatus Status);
  // Component Status
  /*[id(0x00000002)]*/ int put_Status(ComponentStatus Status);
  // Component Description
  /*[id(0x00000004)]*/ int get_Description(out wchar* Description);
  // Component Description
  /*[id(0x00000004)]*/ int put_Description(wchar* Description);
  // Copy Component
  /*[id(0x00000005)]*/ int Clone(out IComponent NewComponent);
}

// Component Type Interface
interface IComponentType : IDispatch {
  mixin(uuid("6a340dc0-0311-11d3-9d8e-00c04f72d980"));
  // General category of component
  /*[id(0x00000001)]*/ int get_Category(out ComponentCategory Category);
  // General category of component
  /*[id(0x00000001)]*/ int put_Category(ComponentCategory Category);
  // DirectShow MediaType Major Type Guid
  /*[id(0x00000002)]*/ int get_MediaMajorType(out wchar* MediaMajorType);
  // DirectShow MediaType Major Type Guid
  /*[id(0x00000002)]*/ int put_MediaMajorType(wchar* MediaMajorType);
  // DirectShow MediaType Major Type Guid
  /*[id(0x00000003)]*/ int get__MediaMajorType(out GUID MediaMajorTypeGuid);
  // DirectShow MediaType Major Type Guid
  /*[id(0x00000003)]*/ int put__MediaMajorType(ref GUID MediaMajorTypeGuid);
  // DirectShow MediaType Sub Type Guid
  /*[id(0x00000004)]*/ int get_MediaSubType(out wchar* MediaSubType);
  // DirectShow MediaType Sub Type Guid
  /*[id(0x00000004)]*/ int put_MediaSubType(wchar* MediaSubType);
  // DirectShow MediaType Sub Type Guid
  /*[id(0x00000005)]*/ int get__MediaSubType(out GUID MediaSubTypeGuid);
  // DirectShow MediaType Sub Type Guid
  /*[id(0x00000005)]*/ int put__MediaSubType(ref GUID MediaSubTypeGuid);
  // DirectShow MediaType Format Guid
  /*[id(0x00000006)]*/ int get_MediaFormatType(out wchar* MediaFormatType);
  // DirectShow MediaType Format Guid
  /*[id(0x00000006)]*/ int put_MediaFormatType(wchar* MediaFormatType);
  // DirectShow MediaType Format Guid
  /*[id(0x00000007)]*/ int get__MediaFormatType(out GUID MediaFormatTypeGuid);
  // DirectShow MediaType Format Guid
  /*[id(0x00000007)]*/ int put__MediaFormatType(ref GUID MediaFormatTypeGuid);
  // DirectShow MediaType Guid, this only retrieves major, sub, format guids not the entire struct
  /*[id(0x00000008)]*/ int get_MediaType(out _AMMediaType MediaType);
  // DirectShow MediaType Guid, this only retrieves major, sub, format guids not the entire struct
  /*[id(0x00000008)]*/ int put_MediaType(_AMMediaType* MediaType);
  // Create a copy of this component type
  /*[id(0x00000009)]*/ int Clone(out IComponentType NewCT);
}

// Generic Locator Information
interface ILocator : IDispatch {
  mixin(uuid("286d7f89-760c-4f89-80c4-66841d2507aa"));
  // Carrier Frequency(KHz)
  /*[id(0x00000001)]*/ int get_CarrierFrequency(out int Frequency);
  // Carrier Frequency(KHz)
  /*[id(0x00000001)]*/ int put_CarrierFrequency(int Frequency);
  // Inner Fec Type
  /*[id(0x00000002)]*/ int get_InnerFEC(out FECMethod FEC);
  // Inner Fec Type
  /*[id(0x00000002)]*/ int put_InnerFEC(FECMethod FEC);
  // Inner Fec Rate
  /*[id(0x00000003)]*/ int get_InnerFECRate(out BinaryConvolutionCodeRate FEC);
  // Inner Fec Rate
  /*[id(0x00000003)]*/ int put_InnerFECRate(BinaryConvolutionCodeRate FEC);
  // Outer Fec Type
  /*[id(0x00000004)]*/ int get_OuterFEC(out FECMethod FEC);
  // Outer Fec Type
  /*[id(0x00000004)]*/ int put_OuterFEC(FECMethod FEC);
  // Outer Fec Rate
  /*[id(0x00000005)]*/ int get_OuterFECRate(out BinaryConvolutionCodeRate FEC);
  // Outer Fec Rate
  /*[id(0x00000005)]*/ int put_OuterFECRate(BinaryConvolutionCodeRate FEC);
  // Modulation Type
  /*[id(0x00000006)]*/ int get_Modulation(out ModulationType Modulation);
  // Modulation Type
  /*[id(0x00000006)]*/ int put_Modulation(ModulationType Modulation);
  // Modulation Symbol Rate
  /*[id(0x00000007)]*/ int get_SymbolRate(out int Rate);
  // Modulation Symbol Rate
  /*[id(0x00000007)]*/ int put_SymbolRate(int Rate);
  // Copy the Locator
  /*[id(0x00000008)]*/ int Clone(out ILocator NewLocator);
}

interface IEnumGUID : IUnknown {
  mixin(uuid("0002e000-0000-0000-c000-000000000046"));
  /*[id(0x60010000)]*/ int Next(uint celt, out GUID rgelt, out uint pceltFetched);
  /*[id(0x60010001)]*/ int Skip(uint celt);
  /*[id(0x60010002)]*/ int Reset();
  /*[id(0x60010003)]*/ int Clone(out IEnumGUID ppEnum);
}

interface IEnumMoniker : IUnknown {
  mixin(uuid("00000102-0000-0000-c000-000000000046"));
  /*[id(0x60010000)]*/ int RemoteNext(uint celt, out IMoniker rgelt, out uint pceltFetched);
  /*[id(0x60010001)]*/ int Skip(uint celt);
  /*[id(0x60010002)]*/ int Reset();
  /*[id(0x60010003)]*/ int Clone(out IEnumMoniker ppEnum);
}

interface IMoniker : IPersistStream {
  mixin(uuid("0000000f-0000-0000-c000-000000000046"));
  /*[id(0x60030000)]*/ int RemoteBindToObject(IBindCtx pbc, IMoniker pmkToLeft, ref GUID riidResult, out IUnknown ppvResult);
  /*[id(0x60030001)]*/ int RemoteBindToStorage(IBindCtx pbc, IMoniker pmkToLeft, ref GUID riid, out IUnknown ppvObj);
  /*[id(0x60030002)]*/ int Reduce(IBindCtx pbc, uint dwReduceHowFar, ref IMoniker ppmkToLeft, out IMoniker ppmkReduced);
  /*[id(0x60030003)]*/ int ComposeWith(IMoniker pmkRight, int fOnlyIfNotGeneric, out IMoniker ppmkComposite);
  /*[id(0x60030004)]*/ int Enum(int fForward, out IEnumMoniker ppenumMoniker);
  /*[id(0x60030005)]*/ int IsEqual(IMoniker pmkOtherMoniker);
  /*[id(0x60030006)]*/ int Hash(out uint pdwHash);
  /*[id(0x60030007)]*/ int IsRunning(IBindCtx pbc, IMoniker pmkToLeft, IMoniker pmkNewlyRunning);
  /*[id(0x60030008)]*/ int GetTimeOfLastChange(IBindCtx pbc, IMoniker pmkToLeft, out _FILETIME pfiletime);
  /*[id(0x60030009)]*/ int Inverse(out IMoniker ppmk);
  /*[id(0x6003000A)]*/ int CommonPrefixWith(IMoniker pmkOther, out IMoniker ppmkPrefix);
  /*[id(0x6003000B)]*/ int RelativePathTo(IMoniker pmkOther, out IMoniker ppmkRelPath);
  /*[id(0x6003000C)]*/ int GetDisplayName(IBindCtx pbc, IMoniker pmkToLeft, out wchar* ppszDisplayName);
  /*[id(0x6003000D)]*/ int ParseDisplayName(IBindCtx pbc, IMoniker pmkToLeft, wchar* pszDisplayName, out uint pchEaten, out IMoniker ppmkOut);
  /*[id(0x6003000E)]*/ int IsSystemMoniker(out uint pdwMksys);
}

interface IPersistStream : IPersist {
  mixin(uuid("00000109-0000-0000-c000-000000000046"));
  /*[id(0x60020000)]*/ int IsDirty();
  /*[id(0x60020001)]*/ int Load(IStream pstm);
  /*[id(0x60020002)]*/ int Save(IStream pstm, int fClearDirty);
  /*[id(0x60020003)]*/ int GetSizeMax(out _ULARGE_INTEGER pcbSize);
}

interface IPersist : IUnknown {
  mixin(uuid("0000010c-0000-0000-c000-000000000046"));
  /*[id(0x60010000)]*/ int GetClassID(out GUID pClassID);
}

interface IStream : ISequentialStream {
  mixin(uuid("0000000c-0000-0000-c000-000000000046"));
  /*[id(0x60020000)]*/ int RemoteSeek(_LARGE_INTEGER dlibMove, uint dwOrigin, out _ULARGE_INTEGER plibNewPosition);
  /*[id(0x60020001)]*/ int SetSize(_ULARGE_INTEGER libNewSize);
  /*[id(0x60020002)]*/ int RemoteCopyTo(IStream pstm, _ULARGE_INTEGER cb, out _ULARGE_INTEGER pcbRead, out _ULARGE_INTEGER pcbWritten);
  /*[id(0x60020003)]*/ int Commit(uint grfCommitFlags);
  /*[id(0x60020004)]*/ int Revert();
  /*[id(0x60020005)]*/ int LockRegion(_ULARGE_INTEGER libOffset, _ULARGE_INTEGER cb, uint dwLockType);
  /*[id(0x60020006)]*/ int UnlockRegion(_ULARGE_INTEGER libOffset, _ULARGE_INTEGER cb, uint dwLockType);
  /*[id(0x60020007)]*/ int Stat(out tagSTATSTG pstatstg, uint grfStatFlag);
  /*[id(0x60020008)]*/ int Clone(out IStream ppstm);
}

interface ISequentialStream : IUnknown {
  mixin(uuid("0c733a30-2a1c-11ce-ade5-00aa0044773d"));
  /*[id(0x60010000)]*/ int RemoteRead(out ubyte pv, uint cb, out uint pcbRead);
  /*[id(0x60010001)]*/ int RemoteWrite(ubyte* pv, uint cb, out uint pcbWritten);
}

interface IBindCtx : IUnknown {
  mixin(uuid("0000000e-0000-0000-c000-000000000046"));
  /*[id(0x60010000)]*/ int RegisterObjectBound(IUnknown pUnk);
  /*[id(0x60010001)]*/ int RevokeObjectBound(IUnknown pUnk);
  /*[id(0x60010002)]*/ int ReleaseBoundObjects();
  /*[id(0x60010003)]*/ int RemoteSetBindOptions(tagBIND_OPTS2* pbindopts);
  /*[id(0x60010004)]*/ int RemoteGetBindOptions(ref tagBIND_OPTS2 pbindopts);
  /*[id(0x60010005)]*/ int GetRunningObjectTable(out IRunningObjectTable pprot);
  /*[id(0x60010006)]*/ int RegisterObjectParam(wchar* pszKey, IUnknown pUnk);
  /*[id(0x60010007)]*/ int GetObjectParam(wchar* pszKey, out IUnknown ppunk);
  /*[id(0x60010008)]*/ int EnumObjectParam(out IEnumString ppEnum);
  /*[id(0x60010009)]*/ int RevokeObjectParam(wchar* pszKey);
}

interface IRunningObjectTable : IUnknown {
  mixin(uuid("00000010-0000-0000-c000-000000000046"));
  /*[id(0x60010000)]*/ int Register(uint grfFlags, IUnknown punkObject, IMoniker pmkObjectName, out uint pdwRegister);
  /*[id(0x60010001)]*/ int Revoke(uint dwRegister);
  /*[id(0x60010002)]*/ int IsRunning(IMoniker pmkObjectName);
  /*[id(0x60010003)]*/ int GetObject(IMoniker pmkObjectName, out IUnknown ppunkObject);
  /*[id(0x60010004)]*/ int NoteChangeTime(uint dwRegister, _FILETIME* pfiletime);
  /*[id(0x60010005)]*/ int GetTimeOfLastChange(IMoniker pmkObjectName, out _FILETIME pfiletime);
  /*[id(0x60010006)]*/ int EnumRunning(out IEnumMoniker ppenumMoniker);
}

interface IEnumString : IUnknown {
  mixin(uuid("00000101-0000-0000-c000-000000000046"));
  /*[id(0x60010000)]*/ int RemoteNext(uint celt, out wchar* rgelt, out uint pceltFetched);
  /*[id(0x60010001)]*/ int Skip(uint celt);
  /*[id(0x60010002)]*/ int Reset();
  /*[id(0x60010003)]*/ int Clone(out IEnumString ppEnum);
}

// ComponentType Collection Interface
interface IComponentTypes : IDispatch {
  mixin(uuid("0dc13d4a-0313-11d3-9d8e-00c04f72d980"));
  // Number of items in the collection
  /*[id(0x60020000)]*/ int get_Count(out int Count);
  /*[id(0xFFFFFFFC)]*/ int get__NewEnum(out IEnumVARIANT ppNewEnum);
  // Convenience Function for Use with C
  /*[id(0x60020002)]*/ int EnumComponentTypes(out IEnumComponentTypes ppNewEnum);
  // Get the ComponentType at the specified index
  /*[id(0x00000000)]*/ int get_Item(VARIANT Index, out IComponentType ComponentType);
  // Get the ComponentType at the specified index
  /*[id(0x00000000)]*/ int put_Item(VARIANT Index, IComponentType ComponentType);
  // Append the ComponentType to the collection
  /*[id(0xFFFFFDD7)]*/ int Add(IComponentType ComponentType, out VARIANT NewIndex);
  // Clear the collection
  /*[id(0xFFFFFDD5)]*/ int Remove(VARIANT Index);
  // Copy the collection
  /*[id(0x60020007)]*/ int Clone(out IComponentTypes NewList);
}

interface IEnumComponentTypes : IUnknown {
  mixin(uuid("8a674b4a-1f63-11d3-b64c-00c04f79498e"));
  /*[id(0x60010000)]*/ int Next(uint celt, out IComponentType rgelt, out uint pceltFetched);
  /*[id(0x60010001)]*/ int Skip(uint celt);
  /*[id(0x60010002)]*/ int Reset();
  /*[id(0x60010003)]*/ int Clone(out IEnumComponentTypes ppEnum);
}

// Tuning Space Collection Interface
interface ITuningSpaces : IDispatch {
  mixin(uuid("901284e4-33fe-4b69-8d63-634a596f3756"));
  // Number of items in the collection
  /*[id(0x60020000)]*/ int get_Count(out int Count);
  /*[id(0xFFFFFFFC)]*/ int get__NewEnum(out IEnumVARIANT NewEnum);
  // Find the Tuning Space with the specified Index
  /*[id(0x00000000)]*/ int get_Item(VARIANT varIndex, out ITuningSpace TuningSpace);
  // convenience function so C++ apps don't have to unpack VARIANT
  /*[id(0x60020003)]*/ int get_EnumTuningSpaces(out IEnumTuningSpaces NewEnum);
}

interface IEnumTuningSpaces : IUnknown {
  mixin(uuid("8b8eb248-fc2b-11d2-9d8c-00c04f72d980"));
  /*[id(0x60010000)]*/ int Next(uint celt, out ITuningSpace rgelt, out uint pceltFetched);
  /*[id(0x60010001)]*/ int Skip(uint celt);
  /*[id(0x60010002)]*/ int Reset();
  /*[id(0x60010003)]*/ int Clone(out IEnumTuningSpaces ppEnum);
}

interface IATSCTuningSpace : IAnalogTVTuningSpace {
  mixin(uuid("0369b4e2-45b6-11d3-b650-00c04f79498e"));
  // Smallest minor channel number ever provided by this tuning space
  /*[id(0x000000C9)]*/ int get_MinMinorChannel(out int MinMinorChannelVal);
  // Smallest minor channel number ever provided by this tuning space
  /*[id(0x000000C9)]*/ int put_MinMinorChannel(int MinMinorChannelVal);
  // Largest minor channel number ever provided by this tuning space
  /*[id(0x000000CA)]*/ int get_MaxMinorChannel(out int MaxMinorChannelVal);
  // Largest minor channel number ever provided by this tuning space
  /*[id(0x000000CA)]*/ int put_MaxMinorChannel(int MaxMinorChannelVal);
  // Smallest physical channel number ever provided by this tuning space
  /*[id(0x000000CB)]*/ int get_MinPhysicalChannel(out int MinPhysicalChannelVal);
  // Smallest physical channel number ever provided by this tuning space
  /*[id(0x000000CB)]*/ int put_MinPhysicalChannel(int MinPhysicalChannelVal);
  // Largest physical channel number ever provided by this tuning space
  /*[id(0x000000CC)]*/ int get_MaxPhysicalChannel(out int MaxPhysicalChannelVal);
  // Largest physical channel number ever provided by this tuning space
  /*[id(0x000000CC)]*/ int put_MaxPhysicalChannel(int MaxPhysicalChannelVal);
}

interface IAnalogTVTuningSpace : ITuningSpace {
  mixin(uuid("2a6e293c-2595-11d3-b64c-00c04f79498e"));
  // Smallest channel number ever provided by this tuning space
  /*[id(0x00000065)]*/ int get_MinChannel(out int MinChannelVal);
  // Smallest channel number ever provided by this tuning space
  /*[id(0x00000065)]*/ int put_MinChannel(int MinChannelVal);
  // Largest channel number ever provided by this tuning space
  /*[id(0x00000066)]*/ int get_MaxChannel(out int MaxChannelVal);
  // Largest channel number ever provided by this tuning space
  /*[id(0x00000066)]*/ int put_MaxChannel(int MaxChannelVal);
  // Input type for this tuning space
  /*[id(0x00000067)]*/ int get_InputType(out tagTunerInputType InputTypeVal);
  // Input type for this tuning space
  /*[id(0x00000067)]*/ int put_InputType(tagTunerInputType InputTypeVal);
  // International dialing prefix for country of physical broadcast source
  /*[id(0x00000068)]*/ int get_CountryCode(out int CountryCodeVal);
  // International dialing prefix for country of physical broadcast source
  /*[id(0x00000068)]*/ int put_CountryCode(int CountryCodeVal);
}

interface IAnalogRadioTuningSpace2 : IAnalogRadioTuningSpace {
  mixin(uuid("39dd45da-2da8-46ba-8a8a-87e2b73d983a"));
  // International dialing prefix for country of physical broadcast source
  /*[id(0x00000068)]*/ int get_CountryCode(out int CountryCodeVal);
  // International dialing prefix for country of physical broadcast source
  /*[id(0x00000068)]*/ int put_CountryCode(int CountryCodeVal);
}

interface IAnalogRadioTuningSpace : ITuningSpace {
  mixin(uuid("2a6e293b-2595-11d3-b64c-00c04f79498e"));
  // Smallest frequency(KHz) ever used by this tuning space
  /*[id(0x00000065)]*/ int get_MinFrequency(out int MinFrequencyVal);
  // Smallest frequency(KHz) ever used by this tuning space
  /*[id(0x00000065)]*/ int put_MinFrequency(int MinFrequencyVal);
  // Largest frequency(KHz) ever used by this tuning space
  /*[id(0x00000066)]*/ int get_MaxFrequency(out int MaxFrequencyVal);
  // Largest frequency(KHz) ever used by this tuning space
  /*[id(0x00000066)]*/ int put_MaxFrequency(int MaxFrequencyVal);
  // Default step value(KHz) to next frequency for this tuning space
  /*[id(0x00000067)]*/ int get_Step(out int StepVal);
  // Default step value(KHz) to next frequency for this tuning space
  /*[id(0x00000067)]*/ int put_Step(int StepVal);
}

interface IAuxInTuningSpace : ITuningSpace {
  mixin(uuid("e48244b8-7e17-4f76-a763-5090ff1e2f30"));
}

interface IAuxInTuningSpace2 : IAuxInTuningSpace {
  mixin(uuid("b10931ed-8bfe-4ab0-9dce-e469c29a9729"));
  // International dialing prefix for country of physical broadcast source
  /*[id(0x00000065)]*/ int get_CountryCode(out int CountryCodeVal);
  // International dialing prefix for country of physical broadcast source
  /*[id(0x00000065)]*/ int put_CountryCode(int CountryCodeVal);
}

interface IDVBTuningSpace2 : IDVBTuningSpace {
  mixin(uuid("843188b4-ce62-43db-966b-8145a094e040"));
  // Network ID of DVB System
  /*[id(0x00000066)]*/ int get_NetworkID(out int NetworkID);
  // Network ID of DVB System
  /*[id(0x00000066)]*/ int put_NetworkID(int NetworkID);
}

interface IDVBTuningSpace : ITuningSpace {
  mixin(uuid("ada0b268-3b19-4e5b-acc4-49f852be13ba"));
  // Type of DVB System
  /*[id(0x00000065)]*/ int get_SystemType(out DVBSystemType SysType);
  // Type of DVB System
  /*[id(0x00000065)]*/ int put_SystemType(DVBSystemType SysType);
}

interface IDVBSTuningSpace : IDVBTuningSpace2 {
  mixin(uuid("cdf7be60-d954-42fd-a972-78971958e470"));
  // Low Oscillator Frequency of DVB System in KHZ units
  /*[id(0x000003E9)]*/ int get_LowOscillator(out int LowOscillator);
  // Low Oscillator Frequency of DVB System in KHZ units
  /*[id(0x000003E9)]*/ int put_LowOscillator(int LowOscillator);
  // High Oscillator Frequency of DVB System in KHZ units
  /*[id(0x000003EA)]*/ int get_HighOscillator(out int HighOscillator);
  // High Oscillator Frequency of DVB System in KHZ units
  /*[id(0x000003EA)]*/ int put_HighOscillator(int HighOscillator);
  // LNB Switch Frequency of DVB System in KHZ units
  /*[id(0x000003EB)]*/ int get_LNBSwitch(out int LNBSwitch);
  // LNB Switch Frequency of DVB System in KHZ units
  /*[id(0x000003EB)]*/ int put_LNBSwitch(int LNBSwitch);
  // Which Option/Switch contains the requested signal source
  /*[id(0x000003EC)]*/ int get_InputRange(out wchar* InputRange);
  // Which Option/Switch contains the requested signal source
  /*[id(0x000003EC)]*/ int put_InputRange(wchar* InputRange);
  // Which Option/Switch contains the requested signal source
  /*[id(0x000003ED)]*/ int get_SpectralInversion(out SpectralInversion SpectralInversionVal);
  // Which Option/Switch contains the requested signal source
  /*[id(0x000003ED)]*/ int put_SpectralInversion(SpectralInversion SpectralInversionVal);
}

// Language Component Type Interface
interface ILanguageComponentType : IComponentType {
  mixin(uuid("b874c8ba-0fa2-11d3-9d8e-00c04f72d980"));
  // Language Identifier for Substream Content Language
  /*[id(0x00000064)]*/ int get_LangID(out int LangID);
  // Language Identifier for Substream Content Language
  /*[id(0x00000064)]*/ int put_LangID(int LangID);
}

// MPEG2 Component Type Interface
interface IMPEG2ComponentType : ILanguageComponentType {
  mixin(uuid("2c073d84-b51c-48c9-aa9f-68971e1f6e38"));
  // MPEG2 Stream Type
  /*[id(0x000000C8)]*/ int get_StreamType(out MPEG2StreamType MP2StreamType);
  // MPEG2 Stream Type
  /*[id(0x000000C8)]*/ int put_StreamType(MPEG2StreamType MP2StreamType);
}

// ATSC Component Type Interface
interface IATSCComponentType : IMPEG2ComponentType {
  mixin(uuid("fc189e4d-7bd4-4125-b3b3-3a76a332cc96"));
  // ATSC Component Type Flags
  /*[id(0x0000012C)]*/ int get_Flags(out int Flags);
  // ATSC Component Type Flags
  /*[id(0x0000012C)]*/ int put_Flags(int Flags);
}

// MPEG2 Component Interface
interface IMPEG2Component : IComponent {
  mixin(uuid("1493e353-1eb6-473c-802d-8e6b8ec9d2a9"));
  // MPEG2 Packet ID for this Substream
  /*[id(0x00000065)]*/ int get_PID(out int PID);
  // MPEG2 Packet ID for this Substream
  /*[id(0x00000065)]*/ int put_PID(int PID);
  // MPEG2 Packet ID for this Substream's Timestamps
  /*[id(0x00000066)]*/ int get_PCRPID(out int PCRPID);
  // MPEG2 Packet ID for this Substream's Timestamps
  /*[id(0x00000066)]*/ int put_PCRPID(int PCRPID);
  // MPEG2 Program Number
  /*[id(0x00000067)]*/ int get_ProgramNumber(out int ProgramNumber);
  // MPEG2 Program Number
  /*[id(0x00000067)]*/ int put_ProgramNumber(int ProgramNumber);
}

// Channel Tune Request Interface
interface IChannelTuneRequest : ITuneRequest {
  mixin(uuid("0369b4e0-45b6-11d3-b650-00c04f79498e"));
  // Channel
  /*[id(0x00000065)]*/ int get_Channel(out int Channel);
  // Channel
  /*[id(0x00000065)]*/ int put_Channel(int Channel);
}

// ATSC Channel Tune Request Interface
interface IATSCChannelTuneRequest : IChannelTuneRequest {
  mixin(uuid("0369b4e1-45b6-11d3-b650-00c04f79498e"));
  // Minor Channel
  /*[id(0x000000C9)]*/ int get_MinorChannel(out int MinorChannel);
  // Minor Channel
  /*[id(0x000000C9)]*/ int put_MinorChannel(int MinorChannel);
}

// MPEG2 Tune Request Interface
interface IMPEG2TuneRequest : ITuneRequest {
  mixin(uuid("eb7d987f-8a01-42ad-b8ae-574deee44d1a"));
  // Transport Stream ID
  /*[id(0x00000065)]*/ int get_TSID(out int TSID);
  // Transport Stream ID
  /*[id(0x00000065)]*/ int put_TSID(int TSID);
  // Program Number ID
  /*[id(0x00000066)]*/ int get_ProgNo(out int ProgNo);
  // Program Number ID
  /*[id(0x00000066)]*/ int put_ProgNo(int ProgNo);
}

// MPEG2 Tune Request Factory Interface
interface IMPEG2TuneRequestFactory : IDispatch {
  mixin(uuid("14e11abd-ee37-4893-9ea1-6964de933e39"));
  // Create MPEG2 Tune Request for specified tuning space(if possible)
  /*[id(0x00000001)]*/ int CreateTuneRequest(ITuningSpace TuningSpace, out IMPEG2TuneRequest TuneRequest);
}

// ATSC Locator Information
interface IATSCLocator : ILocator {
  mixin(uuid("bf8d986f-8c2b-4131-94d7-4d3d9fcc21ef"));
  // Physical Channel
  /*[id(0x000000C9)]*/ int get_PhysicalChannel(out int PhysicalChannel);
  // Physical Channel
  /*[id(0x000000C9)]*/ int put_PhysicalChannel(int PhysicalChannel);
  // Transport Stream ID
  /*[id(0x000000CA)]*/ int get_TSID(out int TSID);
  // Transport Stream ID
  /*[id(0x000000CA)]*/ int put_TSID(int TSID);
}

// DVB Terrestrial Locator Information
interface IDVBTLocator : ILocator {
  mixin(uuid("8664da16-dda2-42ac-926a-c18f9127c302"));
  // Bandwidth
  /*[id(0x0000012D)]*/ int get_Bandwidth(out int BandWidthVal);
  // Bandwidth
  /*[id(0x0000012D)]*/ int put_Bandwidth(int BandWidthVal);
  // Inner Fec Type for Low Priority Stream
  /*[id(0x0000012E)]*/ int get_LPInnerFEC(out FECMethod FEC);
  // Inner Fec Type for Low Priority Stream
  /*[id(0x0000012E)]*/ int put_LPInnerFEC(FECMethod FEC);
  // Inner Fec Rate for Low Priority Stream
  /*[id(0x0000012F)]*/ int get_LPInnerFECRate(out BinaryConvolutionCodeRate FEC);
  // Inner Fec Rate for Low Priority Stream
  /*[id(0x0000012F)]*/ int put_LPInnerFECRate(BinaryConvolutionCodeRate FEC);
  // Hierarchical Alpha
  /*[id(0x00000131)]*/ int get_HAlpha(out HierarchyAlpha Alpha);
  // Hierarchical Alpha
  /*[id(0x00000131)]*/ int put_HAlpha(HierarchyAlpha Alpha);
  // Guard Interval
  /*[id(0x00000130)]*/ int get_Guard(out GuardInterval GI);
  // Guard Interval
  /*[id(0x00000130)]*/ int put_Guard(GuardInterval GI);
  // Transmission Mode
  /*[id(0x00000132)]*/ int get_Mode(out TransmissionMode Mode);
  // Transmission Mode
  /*[id(0x00000132)]*/ int put_Mode(TransmissionMode Mode);
  // Hierarchical Alpha
  /*[id(0x00000133)]*/ int get_OtherFrequencyInUse(out short OtherFrequencyInUseVal);
  // Hierarchical Alpha
  /*[id(0x00000133)]*/ int put_OtherFrequencyInUse(short OtherFrequencyInUseVal);
}

// DVB Satellite Locator Information
interface IDVBSLocator : ILocator {
  mixin(uuid("3d7c353c-0d04-45f1-a742-f97cc1188dc8"));
  // Signal Polarisation Type
  /*[id(0x00000191)]*/ int get_SignalPolarisation(out Polarisation PolarisationVal);
  // Signal Polarisation Type
  /*[id(0x00000191)]*/ int put_SignalPolarisation(Polarisation PolarisationVal);
  // VARIANT_TRUE means orbital position specifies west longitude
  /*[id(0x00000192)]*/ int get_WestPosition(out short WestLongitude);
  // VARIANT_TRUE means orbital position specifies west longitude
  /*[id(0x00000192)]*/ int put_WestPosition(short WestLongitude);
  // Longitude in tenths of a degree
  /*[id(0x00000193)]*/ int get_OrbitalPosition(out int longitude);
  // Longitude in tenths of a degree
  /*[id(0x00000193)]*/ int put_OrbitalPosition(int longitude);
  // Azimuth in tenths of a degree
  /*[id(0x00000194)]*/ int get_Azimuth(out int Azimuth);
  // Azimuth in tenths of a degree
  /*[id(0x00000194)]*/ int put_Azimuth(int Azimuth);
  // Elevation in tenths of a degree
  /*[id(0x00000195)]*/ int get_Elevation(out int Elevation);
  // Elevation in tenths of a degree
  /*[id(0x00000195)]*/ int put_Elevation(int Elevation);
}

// DVB Cable Locator Information
interface IDVBCLocator : ILocator {
  mixin(uuid("6e42f36e-1dd2-43c4-9f78-69d25ae39034"));
}

// DVB Tune Request Interface
interface IDVBTuneRequest : ITuneRequest {
  mixin(uuid("0d6f567e-a636-42bb-83ba-ce4c1704afa2"));
  // Original Network ID
  /*[id(0x00000065)]*/ int get_ONID(out int ONID);
  // Original Network ID
  /*[id(0x00000065)]*/ int put_ONID(int ONID);
  // Transport Stream ID
  /*[id(0x00000066)]*/ int get_TSID(out int TSID);
  // Transport Stream ID
  /*[id(0x00000066)]*/ int put_TSID(int TSID);
  // Service ID
  /*[id(0x00000067)]*/ int get_SID(out int SID);
  // Service ID
  /*[id(0x00000067)]*/ int put_SID(int SID);
}

// Create property bag backed by registry
interface ICreatePropBagOnRegKey : IUnknown {
  mixin(uuid("8a674b48-1f63-11d3-b64c-00c04f79498e"));
  /*[id(0x60010000)]*/ int Create(void* hkey, wchar* subkey, uint ulOptions, uint samDesired, ref GUID iid, void* ppBag);
}

// Broadcast Event Service Firing/Reflecting Interface
interface IBroadcastEvent : IUnknown {
  mixin(uuid("3b21263f-26e8-489d-aac4-924f7efd9511"));
  /*[id(0x60010000)]*/ int Fire(GUID EventID);
}

// BDA ITuner Marshaler helper
interface IRegisterTuner : IUnknown {
  mixin(uuid("359b3901-572c-4854-bb49-cdef66606a25"));
  /*[id(0x60010000)]*/ int Register(ITuner pTuner, IGraphBuilder pGraph);
  /*[id(0x60010001)]*/ int Unregister();
}

// Tuner Interface
interface ITuner : IUnknown {
  mixin(uuid("28c52640-018a-11d3-9d8e-00c04f72d980"));
  // Tuning Space object
  /*[id(0x60010000)]*/ int get_TuningSpace(out ITuningSpace TuningSpace);
  // Tuning Space object
  /*[id(0x60010000)]*/ int put_TuningSpace(ITuningSpace TuningSpace);
  // Returns an enumerator for Tuning Spaces accepted by this tuner
  /*[id(0x60010002)]*/ int EnumTuningSpaces(out IEnumTuningSpaces ppEnum);
  // Tune Request object
  /*[id(0x60010003)]*/ int get_TuneRequest(out ITuneRequest TuneRequest);
  // Tune Request object
  /*[id(0x60010003)]*/ int put_TuneRequest(ITuneRequest TuneRequest);
  // Validate the tuning request without tuning
  /*[id(0x60010005)]*/ int Validate(ITuneRequest TuneRequest);
  // Preferred Component Types collection
  /*[id(0x60010006)]*/ int get_PreferredComponentTypes(out IComponentTypes ComponentTypes);
  // Preferred Component Types collection
  /*[id(0x60010006)]*/ int put_PreferredComponentTypes(IComponentTypes ComponentTypes);
  // Signal Strength
  /*[id(0x60010008)]*/ int get_SignalStrength(out int Strength);
  // Trigger Signal events (interval in milliseconds; 0 turns off trigger)
  /*[id(0x60010009)]*/ int TriggerSignalEvents(int Interval);
}

interface IGraphBuilder : IFilterGraph {
  mixin(uuid("56a868a9-0ad4-11ce-b03a-0020af0ba770"));
  /*[id(0x60020000)]*/ int Connect(IPin ppinOut, IPin ppinIn);
  /*[id(0x60020001)]*/ int Render(IPin ppinOut);
  /*[id(0x60020002)]*/ int RenderFile(wchar* lpcwstrFile, wchar* lpcwstrPlayList);
  /*[id(0x60020003)]*/ int AddSourceFilter(wchar* lpcwstrFileName, wchar* lpcwstrFilterName, out IBaseFilter ppFilter);
  /*[id(0x60020004)]*/ int SetLogFile(ULONG_PTR hFile);
  /*[id(0x60020005)]*/ int Abort();
  /*[id(0x60020006)]*/ int ShouldOperationContinue();
}

interface IFilterGraph : IUnknown {
  mixin(uuid("56a8689f-0ad4-11ce-b03a-0020af0ba770"));
  /*[id(0x60010000)]*/ int AddFilter(IBaseFilter pFilter, wchar* pName);
  /*[id(0x60010001)]*/ int RemoveFilter(IBaseFilter pFilter);
  /*[id(0x60010002)]*/ int EnumFilters(out IEnumFilters ppEnum);
  /*[id(0x60010003)]*/ int FindFilterByName(wchar* pName, out IBaseFilter ppFilter);
  /*[id(0x60010004)]*/ int ConnectDirect(IPin ppinOut, IPin ppinIn, _AMMediaType* pmt);
  /*[id(0x60010005)]*/ int Reconnect(IPin pPin);
  /*[id(0x60010006)]*/ int Disconnect(IPin pPin);
  /*[id(0x60010007)]*/ int SetDefaultSyncSource();
}

interface IBaseFilter : IMediaFilter {
  mixin(uuid("56a86895-0ad4-11ce-b03a-0020af0ba770"));
  /*[id(0x60030000)]*/ int EnumPins(out IEnumPins ppEnum);
  /*[id(0x60030001)]*/ int FindPin(wchar* ID, out IPin ppPin);
  /*[id(0x60030002)]*/ int QueryFilterInfo(out _FilterInfo pInfo);
  /*[id(0x60030003)]*/ int JoinFilterGraph(IFilterGraph pGraph, wchar* pName);
  /*[id(0x60030004)]*/ int QueryVendorInfo(out wchar* pVendorInfo);
}

interface IMediaFilter : IPersist {
  mixin(uuid("56a86899-0ad4-11ce-b03a-0020af0ba770"));
  /*[id(0x60020000)]*/ int Stop();
  /*[id(0x60020001)]*/ int Pause();
  /*[id(0x60020002)]*/ int Run(long tStart);
  /*[id(0x60020003)]*/ int GetState(uint dwMilliSecsTimeout, out _FilterState State);
  /*[id(0x60020004)]*/ int SetSyncSource(IReferenceClock pClock);
  /*[id(0x60020005)]*/ int GetSyncSource(out IReferenceClock pClock);
}

interface IReferenceClock : IUnknown {
  mixin(uuid("56a86897-0ad4-11ce-b03a-0020af0ba770"));
  /*[id(0x60010000)]*/ int GetTime(out long pTime);
  /*[id(0x60010001)]*/ int AdviseTime(long baseTime, long streamTime, ULONG_PTR hEvent, out ULONG_PTR pdwAdviseCookie);
  /*[id(0x60010002)]*/ int AdvisePeriodic(long startTime, long periodTime, ULONG_PTR hSemaphore, out ULONG_PTR pdwAdviseCookie);
  /*[id(0x60010003)]*/ int Unadvise(ULONG_PTR dwAdviseCookie);
}

interface IEnumPins : IUnknown {
  mixin(uuid("56a86892-0ad4-11ce-b03a-0020af0ba770"));
  /*[id(0x60010000)]*/ int Next(uint cPins, out IPin ppPins, out uint pcFetched);
  /*[id(0x60010001)]*/ int Skip(uint cPins);
  /*[id(0x60010002)]*/ int Reset();
  /*[id(0x60010003)]*/ int Clone(out IEnumPins ppEnum);
}

interface IPin : IUnknown {
  mixin(uuid("56a86891-0ad4-11ce-b03a-0020af0ba770"));
  /*[id(0x60010000)]*/ int Connect(IPin pReceivePin, _AMMediaType* pmt);
  /*[id(0x60010001)]*/ int ReceiveConnection(IPin pConnector, _AMMediaType* pmt);
  /*[id(0x60010002)]*/ int Disconnect();
  /*[id(0x60010003)]*/ int ConnectedTo(out IPin pPin);
  /*[id(0x60010004)]*/ int ConnectionMediaType(out _AMMediaType pmt);
  /*[id(0x60010005)]*/ int QueryPinInfo(out _PinInfo pInfo);
  /*[id(0x60010006)]*/ int QueryDirection(out _PinDirection pPinDir);
  /*[id(0x60010007)]*/ int QueryId(out wchar* ID);
  /*[id(0x60010008)]*/ int QueryAccept(_AMMediaType* pmt);
  /*[id(0x60010009)]*/ int EnumMediaTypes(out IEnumMediaTypes ppEnum);
  /*[id(0x6001000A)]*/ int QueryInternalConnections(out IPin apPin, ref uint nPin);
  /*[id(0x6001000B)]*/ int EndOfStream();
  /*[id(0x6001000C)]*/ int BeginFlush();
  /*[id(0x6001000D)]*/ int EndFlush();
  /*[id(0x6001000E)]*/ int NewSegment(long tStart, long tStop, double dRate);
}

interface IEnumMediaTypes : IUnknown {
  mixin(uuid("89c31040-846b-11ce-97d3-00aa0055595a"));
  /*[id(0x60010000)]*/ int Next(uint cMediaTypes, out _AMMediaType ppMediaTypes, out uint pcFetched);
  /*[id(0x60010001)]*/ int Skip(uint cMediaTypes);
  /*[id(0x60010002)]*/ int Reset();
  /*[id(0x60010003)]*/ int Clone(out IEnumMediaTypes ppEnum);
}

interface IEnumFilters : IUnknown {
  mixin(uuid("56a86893-0ad4-11ce-b03a-0020af0ba770"));
  /*[id(0x60010000)]*/ int Next(uint cFilters, out IBaseFilter ppFilter, out uint pcFetched);
  /*[id(0x60010001)]*/ int Skip(uint cFilters);
  /*[id(0x60010002)]*/ int Reset();
  /*[id(0x60010003)]*/ int Clone(out IEnumFilters ppEnum);
}

// CoClasses

// SystemTuningSpace Class
abstract final class SystemTuningSpaces {
  mixin(uuid("d02aac50-027e-11d3-9d8e-00c04f72d980"));
  mixin Interfaces!(ITuningSpaceContainer);
}

// dummy class to expose base tuning space i/f to VB
abstract final class TuningSpace {
  mixin(uuid("5ffdc5e6-b83a-4b55-b6e8-c69e765fe9db"));
  mixin Interfaces!(ITuningSpace);
}

// ATSC Digital Broadcast Tuning Space Class
abstract final class ATSCTuningSpace {
  mixin(uuid("a2e30750-6c3d-11d3-b653-00c04f79498e"));
  mixin Interfaces!(IATSCTuningSpace);
}

// Analog Radio Tuning Space Class
abstract final class AnalogRadioTuningSpace {
  mixin(uuid("8a674b4c-1f63-11d3-b64c-00c04f79498e"));
  mixin Interfaces!(IAnalogRadioTuningSpace2, IAnalogRadioTuningSpace);
}

// Auxiliary Inputs Tuning Space Class
abstract final class AuxInTuningSpace {
  mixin(uuid("f9769a06-7aca-4e39-9cfb-97bb35f0e77e"));
  mixin Interfaces!(IAuxInTuningSpace, IAuxInTuningSpace2);
}

// Analog TV Tuning Space Class
abstract final class AnalogTVTuningSpace {
  mixin(uuid("8a674b4d-1f63-11d3-b64c-00c04f79498e"));
  mixin Interfaces!(IAnalogTVTuningSpace);
}

// DVB Tuning Space Class
abstract final class DVBTuningSpace {
  mixin(uuid("c6b14b32-76aa-4a86-a7ac-5c79aaf58da7"));
  mixin Interfaces!(IDVBTuningSpace2, IDVBTuningSpace);
}

// DVB Satellite Tuning Space Class
abstract final class DVBSTuningSpace {
  mixin(uuid("b64016f3-c9a2-4066-96f0-bd9563314726"));
  mixin Interfaces!(IDVBSTuningSpace);
}

// Component Types Collection Class
abstract final class ComponentTypes {
  mixin(uuid("a1a2b1c4-0e3a-11d3-9d8e-00c04f72d980"));
  mixin Interfaces!(IComponentTypes);
}

// ComponentType Class
abstract final class ComponentType {
  mixin(uuid("823535a0-0318-11d3-9d8e-00c04f72d980"));
  mixin Interfaces!(IComponentType);
}

// LanguageComponentType Class
abstract final class LanguageComponentType {
  mixin(uuid("1be49f30-0e1b-11d3-9d8e-00c04f72d980"));
  mixin Interfaces!(ILanguageComponentType);
}

// MPEG2ComponentType Class
abstract final class MPEG2ComponentType {
  mixin(uuid("418008f3-cf67-4668-9628-10dc52be1d08"));
  mixin Interfaces!(IMPEG2ComponentType);
}

// ATSCComponentType Class
abstract final class ATSCComponentType {
  mixin(uuid("a8dcf3d5-0780-4ef4-8a83-2cffaacb8ace"));
  mixin Interfaces!(IATSCComponentType);
}

// Components Collection Class
abstract final class Components {
  mixin(uuid("809b6661-94c4-49e6-b6ec-3f0f862215aa"));
  mixin Interfaces!(IComponents);
}

// Component Class
abstract final class Component {
  mixin(uuid("59dc47a8-116c-11d3-9d8e-00c04f72d980"));
  mixin Interfaces!(IComponent);
}

// MPEG2 Component Class
abstract final class MPEG2Component {
  mixin(uuid("055cb2d7-2969-45cd-914b-76890722f112"));
  mixin Interfaces!(IMPEG2Component);
}

// dummy class to expose base tune request i/f to VB
abstract final class TuneRequest {
  mixin(uuid("b46e0d38-ab35-4a06-a137-70576b01b39f"));
  mixin Interfaces!(ITuneRequest);
}

// Channel Tune Request
abstract final class ChannelTuneRequest {
  mixin(uuid("0369b4e5-45b6-11d3-b650-00c04f79498e"));
  mixin Interfaces!(IChannelTuneRequest);
}

// ATSC Channel Tune Request
abstract final class ATSCChannelTuneRequest {
  mixin(uuid("0369b4e6-45b6-11d3-b650-00c04f79498e"));
  mixin Interfaces!(IATSCChannelTuneRequest);
}

// dummy class to expose mpeg2 request i/f to VB
abstract final class MPEG2TuneRequest {
  mixin(uuid("0955ac62-bf2e-4cba-a2b9-a63f772d46cf"));
  mixin Interfaces!(IMPEG2TuneRequest);
}

// Factory for creating IMPEG2TuneRequest
abstract final class MPEG2TuneRequestFactory {
  mixin(uuid("2c63e4eb-4cea-41b8-919c-e947ea19a77c"));
  mixin Interfaces!(IMPEG2TuneRequestFactory);
}

// dummy class to expose base locator i/f to VB
abstract final class Locator {
  mixin(uuid("0888c883-ac4f-4943-b516-2c38d9b34562"));
  mixin Interfaces!(ILocator);
}

// ATSC Locator
abstract final class ATSCLocator {
  mixin(uuid("8872ff1b-98fa-4d7a-8d93-c9f1055f85bb"));
  mixin Interfaces!(IATSCLocator);
}

// DVB-Terrestrial Locator
abstract final class DVBTLocator {
  mixin(uuid("9cd64701-bdf3-4d14-8e03-f12983d86664"));
  mixin Interfaces!(IDVBTLocator);
}

// DVB-Satellite Locator
abstract final class DVBSLocator {
  mixin(uuid("1df7d126-4050-47f0-a7cf-4c4ca9241333"));
  mixin Interfaces!(IDVBSLocator);
}

// DVB-Cable Locator
abstract final class DVBCLocator {
  mixin(uuid("c531d9fd-9685-4028-8b68-6e1232079f1e"));
  mixin Interfaces!(IDVBCLocator);
}

// DVB Tune Request
abstract final class DVBTuneRequest {
  mixin(uuid("15d6504a-5494-499c-886c-973c9e53b9f1"));
  mixin Interfaces!(IDVBTuneRequest);
}

// Create property bag backed by registry
abstract final class CreatePropBagOnRegKey {
  mixin(uuid("8a674b49-1f63-11d3-b64c-00c04f79498e"));
  mixin Interfaces!(ICreatePropBagOnRegKey);
}

// DShow Broadcast Event Service Object
abstract final class BroadcastEventService {
  mixin(uuid("0b3ffb92-0919-4934-9d5b-619c719d0202"));
  mixin Interfaces!(IBroadcastEvent);
}

// BDA ITuner Marshaling utility object
abstract final class TunerMarshaler {
  mixin(uuid("6438570b-0c08-4a25-9504-8012bb4d50cf"));
  mixin Interfaces!(IRegisterTuner, ITuner);
}
