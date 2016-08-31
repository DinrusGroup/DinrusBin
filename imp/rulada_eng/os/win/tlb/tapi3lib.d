// Microsoft TAPI 3.0 Type Library
// Version 1.0

/*[uuid("21d6d480-a88b-11d0-83dd-00aa003ccabd")]*/
module os.win.tlb.tapi3lib;

/*[importlib("STDOLE2.TLB")]*/
private import os.win.com.core;

// Enums

enum ADDRESS_STATE {
  AS_INSERVICE = 0x00000000,
  AS_OUTOFSERVICE = 0x00000001,
}

enum CALLHUB_STATE {
  CHS_ACTIVE = 0x00000000,
  CHS_IDLE = 0x00000001,
}

enum DISCONNECT_CODE {
  DC_NORMAL = 0x00000000,
  DC_NOANSWER = 0x00000001,
  DC_REJECTED = 0x00000002,
}

enum QOS_SERVICE_LEVEL {
  QSL_NEEDED = 0x00000001,
  QSL_IF_AVAILABLE = 0x00000002,
  QSL_BEST_EFFORT = 0x00000003,
}

enum FINISH_MODE {
  FM_ASTRANSFER = 0x00000000,
  FM_ASCONFERENCE = 0x00000001,
}

enum CALL_STATE {
  CS_IDLE = 0x00000000,
  CS_INPROGRESS = 0x00000001,
  CS_CONNECTED = 0x00000002,
  CS_DISCONNECTED = 0x00000003,
  CS_OFFERING = 0x00000004,
  CS_HOLD = 0x00000005,
  CS_QUEUED = 0x00000006,
  CS_LASTITEM = 0x00000006,
}

enum CALL_PRIVILEGE {
  CP_OWNER = 0x00000000,
  CP_MONITOR = 0x00000001,
}

enum CALLINFO_LONG {
  CIL_MEDIATYPESAVAILABLE = 0x00000000,
  CIL_BEARERMODE = 0x00000001,
  CIL_CALLERIDADDRESSTYPE = 0x00000002,
  CIL_CALLEDIDADDRESSTYPE = 0x00000003,
  CIL_CONNECTEDIDADDRESSTYPE = 0x00000004,
  CIL_REDIRECTIONIDADDRESSTYPE = 0x00000005,
  CIL_REDIRECTINGIDADDRESSTYPE = 0x00000006,
  CIL_ORIGIN = 0x00000007,
  CIL_REASON = 0x00000008,
  CIL_APPSPECIFIC = 0x00000009,
  CIL_CALLPARAMSFLAGS = 0x0000000A,
  CIL_CALLTREATMENT = 0x0000000B,
  CIL_MINRATE = 0x0000000C,
  CIL_MAXRATE = 0x0000000D,
  CIL_COUNTRYCODE = 0x0000000E,
  CIL_CALLID = 0x0000000F,
  CIL_RELATEDCALLID = 0x00000010,
  CIL_COMPLETIONID = 0x00000011,
  CIL_NUMBEROFOWNERS = 0x00000012,
  CIL_NUMBEROFMONITORS = 0x00000013,
  CIL_TRUNK = 0x00000014,
  CIL_RATE = 0x00000015,
  CIL_GENERATEDIGITDURATION = 0x00000016,
  CIL_MONITORDIGITMODES = 0x00000017,
  CIL_MONITORMEDIAMODES = 0x00000018,
}

enum CALLINFO_STRING {
  CIS_CALLERIDNAME = 0x00000000,
  CIS_CALLERIDNUMBER = 0x00000001,
  CIS_CALLEDIDNAME = 0x00000002,
  CIS_CALLEDIDNUMBER = 0x00000003,
  CIS_CONNECTEDIDNAME = 0x00000004,
  CIS_CONNECTEDIDNUMBER = 0x00000005,
  CIS_REDIRECTIONIDNAME = 0x00000006,
  CIS_REDIRECTIONIDNUMBER = 0x00000007,
  CIS_REDIRECTINGIDNAME = 0x00000008,
  CIS_REDIRECTINGIDNUMBER = 0x00000009,
  CIS_CALLEDPARTYFRIENDLYNAME = 0x0000000A,
  CIS_COMMENT = 0x0000000B,
  CIS_DISPLAYABLEADDRESS = 0x0000000C,
  CIS_CALLINGPARTYID = 0x0000000D,
}

enum CALLINFO_BUFFER {
  CIB_USERUSERINFO = 0x00000000,
  CIB_DEVSPECIFICBUFFER = 0x00000001,
  CIB_CALLDATABUFFER = 0x00000002,
  CIB_CHARGINGINFOBUFFER = 0x00000003,
  CIB_HIGHLEVELCOMPATIBILITYBUFFER = 0x00000004,
  CIB_LOWLEVELCOMPATIBILITYBUFFER = 0x00000005,
}

enum CALL_STATE_EVENT_CAUSE {
  CEC_NONE = 0x00000000,
  CEC_DISCONNECT_NORMAL = 0x00000001,
  CEC_DISCONNECT_BUSY = 0x00000002,
  CEC_DISCONNECT_BADADDRESS = 0x00000003,
  CEC_DISCONNECT_NOANSWER = 0x00000004,
  CEC_DISCONNECT_CANCELLED = 0x00000005,
  CEC_DISCONNECT_REJECTED = 0x00000006,
  CEC_DISCONNECT_FAILED = 0x00000007,
  CEC_DISCONNECT_BLOCKED = 0x00000008,
}

enum CALL_NOTIFICATION_EVENT {
  CNE_OWNER = 0x00000000,
  CNE_MONITOR = 0x00000001,
  CNE_LASTITEM = 0x00000001,
}

enum TAPI_EVENT {
  TE_TAPIOBJECT = 0x00000001,
  TE_ADDRESS = 0x00000002,
  TE_CALLNOTIFICATION = 0x00000004,
  TE_CALLSTATE = 0x00000008,
  TE_CALLMEDIA = 0x00000010,
  TE_CALLHUB = 0x00000020,
  TE_CALLINFOCHANGE = 0x00000040,
  TE_PRIVATE = 0x00000080,
  TE_REQUEST = 0x00000100,
  TE_AGENT = 0x00000200,
  TE_AGENTSESSION = 0x00000400,
  TE_QOSEVENT = 0x00000800,
  TE_AGENTHANDLER = 0x00001000,
  TE_ACDGROUP = 0x00002000,
  TE_QUEUE = 0x00004000,
  TE_DIGITEVENT = 0x00008000,
  TE_GENERATEEVENT = 0x00010000,
  TE_ASRTERMINAL = 0x00020000,
  TE_TTSTERMINAL = 0x00040000,
  TE_FILETERMINAL = 0x00080000,
  TE_TONETERMINAL = 0x00100000,
  TE_PHONEEVENT = 0x00200000,
  TE_TONEEVENT = 0x00400000,
  TE_GATHERDIGITS = 0x00800000,
  TE_ADDRESSDEVSPECIFIC = 0x01000000,
  TE_PHONEDEVSPECIFIC = 0x02000000,
}

enum CALLHUB_EVENT {
  CHE_CALLJOIN = 0x00000000,
  CHE_CALLLEAVE = 0x00000001,
  CHE_CALLHUBNEW = 0x00000002,
  CHE_CALLHUBIDLE = 0x00000003,
  CHE_LASTITEM = 0x00000003,
}

enum ADDRESS_CAPABILITY {
  AC_ADDRESSTYPES = 0x00000000,
  AC_BEARERMODES = 0x00000001,
  AC_MAXACTIVECALLS = 0x00000002,
  AC_MAXONHOLDCALLS = 0x00000003,
  AC_MAXONHOLDPENDINGCALLS = 0x00000004,
  AC_MAXNUMCONFERENCE = 0x00000005,
  AC_MAXNUMTRANSCONF = 0x00000006,
  AC_MONITORDIGITSUPPORT = 0x00000007,
  AC_GENERATEDIGITSUPPORT = 0x00000008,
  AC_GENERATETONEMODES = 0x00000009,
  AC_GENERATETONEMAXNUMFREQ = 0x0000000A,
  AC_MONITORTONEMAXNUMFREQ = 0x0000000B,
  AC_MONITORTONEMAXNUMENTRIES = 0x0000000C,
  AC_DEVCAPFLAGS = 0x0000000D,
  AC_ANSWERMODES = 0x0000000E,
  AC_LINEFEATURES = 0x0000000F,
  AC_SETTABLEDEVSTATUS = 0x00000010,
  AC_PARKSUPPORT = 0x00000011,
  AC_CALLERIDSUPPORT = 0x00000012,
  AC_CALLEDIDSUPPORT = 0x00000013,
  AC_CONNECTEDIDSUPPORT = 0x00000014,
  AC_REDIRECTIONIDSUPPORT = 0x00000015,
  AC_REDIRECTINGIDSUPPORT = 0x00000016,
  AC_ADDRESSCAPFLAGS = 0x00000017,
  AC_CALLFEATURES1 = 0x00000018,
  AC_CALLFEATURES2 = 0x00000019,
  AC_REMOVEFROMCONFCAPS = 0x0000001A,
  AC_REMOVEFROMCONFSTATE = 0x0000001B,
  AC_TRANSFERMODES = 0x0000001C,
  AC_ADDRESSFEATURES = 0x0000001D,
  AC_PREDICTIVEAUTOTRANSFERSTATES = 0x0000001E,
  AC_MAXCALLDATASIZE = 0x0000001F,
  AC_LINEID = 0x00000020,
  AC_ADDRESSID = 0x00000021,
  AC_FORWARDMODES = 0x00000022,
  AC_MAXFORWARDENTRIES = 0x00000023,
  AC_MAXSPECIFICENTRIES = 0x00000024,
  AC_MINFWDNUMRINGS = 0x00000025,
  AC_MAXFWDNUMRINGS = 0x00000026,
  AC_MAXCALLCOMPLETIONS = 0x00000027,
  AC_CALLCOMPLETIONCONDITIONS = 0x00000028,
  AC_CALLCOMPLETIONMODES = 0x00000029,
  AC_PERMANENTDEVICEID = 0x0000002A,
  AC_GATHERDIGITSMINTIMEOUT = 0x0000002B,
  AC_GATHERDIGITSMAXTIMEOUT = 0x0000002C,
  AC_GENERATEDIGITMINDURATION = 0x0000002D,
  AC_GENERATEDIGITMAXDURATION = 0x0000002E,
  AC_GENERATEDIGITDEFAULTDURATION = 0x0000002F,
}

enum ADDRESS_CAPABILITY_STRING {
  ACS_PROTOCOL = 0x00000000,
  ACS_ADDRESSDEVICESPECIFIC = 0x00000001,
  ACS_LINEDEVICESPECIFIC = 0x00000002,
  ACS_PROVIDERSPECIFIC = 0x00000003,
  ACS_SWITCHSPECIFIC = 0x00000004,
  ACS_PERMANENTDEVICEGUID = 0x00000005,
}

enum QOS_EVENT {
  QE_NOQOS = 0x00000001,
  QE_ADMISSIONFAILURE = 0x00000002,
  QE_POLICYFAILURE = 0x00000003,
  QE_GENERICERROR = 0x00000004,
  QE_LASTITEM = 0x00000004,
}

enum ADDRESS_EVENT {
  AE_STATE = 0x00000000,
  AE_CAPSCHANGE = 0x00000001,
  AE_RINGING = 0x00000002,
  AE_CONFIGCHANGE = 0x00000003,
  AE_FORWARD = 0x00000004,
  AE_NEWTERMINAL = 0x00000005,
  AE_REMOVETERMINAL = 0x00000006,
  AE_MSGWAITON = 0x00000007,
  AE_MSGWAITOFF = 0x00000008,
  AE_LASTITEM = 0x00000008,
}

enum TERMINAL_STATE {
  TS_INUSE = 0x00000000,
  TS_NOTINUSE = 0x00000001,
}

enum TERMINAL_TYPE {
  TT_STATIC = 0x00000000,
  TT_DYNAMIC = 0x00000001,
}

enum TERMINAL_DIRECTION {
  TD_CAPTURE = 0x00000000,
  TD_RENDER = 0x00000001,
  TD_BIDIRECTIONAL = 0x00000002,
  TD_MULTITRACK_MIXED = 0x00000003,
  TD_NONE = 0x00000004,
}

enum CALL_MEDIA_EVENT {
  CME_NEW_STREAM = 0x00000000,
  CME_STREAM_FAIL = 0x00000001,
  CME_TERMINAL_FAIL = 0x00000002,
  CME_STREAM_NOT_USED = 0x00000003,
  CME_STREAM_ACTIVE = 0x00000004,
  CME_STREAM_INACTIVE = 0x00000005,
  CME_LASTITEM = 0x00000005,
}

enum CALL_MEDIA_EVENT_CAUSE {
  CMC_UNKNOWN = 0x00000000,
  CMC_BAD_DEVICE = 0x00000001,
  CMC_CONNECT_FAIL = 0x00000002,
  CMC_LOCAL_REQUEST = 0x00000003,
  CMC_REMOTE_REQUEST = 0x00000004,
  CMC_MEDIA_TIMEOUT = 0x00000005,
  CMC_MEDIA_RECOVERED = 0x00000006,
  CMC_QUALITY_OF_SERVICE = 0x00000007,
}

enum TAPIOBJECT_EVENT {
  TE_ADDRESSCREATE = 0x00000000,
  TE_ADDRESSREMOVE = 0x00000001,
  TE_REINIT = 0x00000002,
  TE_TRANSLATECHANGE = 0x00000003,
  TE_ADDRESSCLOSE = 0x00000004,
  TE_PHONECREATE = 0x00000005,
  TE_PHONEREMOVE = 0x00000006,
}

enum PHONE_PRIVILEGE {
  PP_OWNER = 0x00000000,
  PP_MONITOR = 0x00000001,
}

enum PHONECAPS_LONG {
  PCL_HOOKSWITCHES = 0x00000000,
  PCL_HANDSETHOOKSWITCHMODES = 0x00000001,
  PCL_HEADSETHOOKSWITCHMODES = 0x00000002,
  PCL_SPEAKERPHONEHOOKSWITCHMODES = 0x00000003,
  PCL_DISPLAYNUMROWS = 0x00000004,
  PCL_DISPLAYNUMCOLUMNS = 0x00000005,
  PCL_NUMRINGMODES = 0x00000006,
  PCL_NUMBUTTONLAMPS = 0x00000007,
  PCL_GENERICPHONE = 0x00000008,
}

enum PHONECAPS_STRING {
  PCS_PHONENAME = 0x00000000,
  PCS_PHONEINFO = 0x00000001,
  PCS_PROVIDERINFO = 0x00000002,
}

enum PHONE_BUTTON_MODE {
  PBM_DUMMY = 0x00000000,
  PBM_CALL = 0x00000001,
  PBM_FEATURE = 0x00000002,
  PBM_KEYPAD = 0x00000003,
  PBM_LOCAL = 0x00000004,
  PBM_DISPLAY = 0x00000005,
}

enum PHONE_BUTTON_FUNCTION {
  PBF_UNKNOWN = 0x00000000,
  PBF_CONFERENCE = 0x00000001,
  PBF_TRANSFER = 0x00000002,
  PBF_DROP = 0x00000003,
  PBF_HOLD = 0x00000004,
  PBF_RECALL = 0x00000005,
  PBF_DISCONNECT = 0x00000006,
  PBF_CONNECT = 0x00000007,
  PBF_MSGWAITON = 0x00000008,
  PBF_MSGWAITOFF = 0x00000009,
  PBF_SELECTRING = 0x0000000A,
  PBF_ABBREVDIAL = 0x0000000B,
  PBF_FORWARD = 0x0000000C,
  PBF_PICKUP = 0x0000000D,
  PBF_RINGAGAIN = 0x0000000E,
  PBF_PARK = 0x0000000F,
  PBF_REJECT = 0x00000010,
  PBF_REDIRECT = 0x00000011,
  PBF_MUTE = 0x00000012,
  PBF_VOLUMEUP = 0x00000013,
  PBF_VOLUMEDOWN = 0x00000014,
  PBF_SPEAKERON = 0x00000015,
  PBF_SPEAKEROFF = 0x00000016,
  PBF_FLASH = 0x00000017,
  PBF_DATAON = 0x00000018,
  PBF_DATAOFF = 0x00000019,
  PBF_DONOTDISTURB = 0x0000001A,
  PBF_INTERCOM = 0x0000001B,
  PBF_BRIDGEDAPP = 0x0000001C,
  PBF_BUSY = 0x0000001D,
  PBF_CALLAPP = 0x0000001E,
  PBF_DATETIME = 0x0000001F,
  PBF_DIRECTORY = 0x00000020,
  PBF_COVER = 0x00000021,
  PBF_CALLID = 0x00000022,
  PBF_LASTNUM = 0x00000023,
  PBF_NIGHTSRV = 0x00000024,
  PBF_SENDCALLS = 0x00000025,
  PBF_MSGINDICATOR = 0x00000026,
  PBF_REPDIAL = 0x00000027,
  PBF_SETREPDIAL = 0x00000028,
  PBF_SYSTEMSPEED = 0x00000029,
  PBF_STATIONSPEED = 0x0000002A,
  PBF_CAMPON = 0x0000002B,
  PBF_SAVEREPEAT = 0x0000002C,
  PBF_QUEUECALL = 0x0000002D,
  PBF_NONE = 0x0000002E,
  PBF_SEND = 0x0000002F,
}

enum PHONE_BUTTON_STATE {
  PBS_UP = 0x00000001,
  PBS_DOWN = 0x00000002,
  PBS_UNKNOWN = 0x00000004,
  PBS_UNAVAIL = 0x00000008,
}

enum PHONE_HOOK_SWITCH_DEVICE {
  PHSD_HANDSET = 0x00000001,
  PHSD_SPEAKERPHONE = 0x00000002,
  PHSD_HEADSET = 0x00000004,
}

enum PHONE_HOOK_SWITCH_STATE {
  PHSS_ONHOOK = 0x00000001,
  PHSS_OFFHOOK_MIC_ONLY = 0x00000002,
  PHSS_OFFHOOK_SPEAKER_ONLY = 0x00000004,
  PHSS_OFFHOOK = 0x00000008,
}

enum PHONECAPS_BUFFER {
  PCB_DEVSPECIFICBUFFER = 0x00000000,
}

enum PHONE_LAMP_MODE {
  LM_DUMMY = 0x00000001,
  LM_OFF = 0x00000002,
  LM_STEADY = 0x00000004,
  LM_WINK = 0x00000008,
  LM_FLASH = 0x00000010,
  LM_FLUTTER = 0x00000020,
  LM_BROKENFLUTTER = 0x00000040,
  LM_UNKNOWN = 0x00000080,
}

enum AGENT_SESSION_STATE {
  ASST_NOT_READY = 0x00000000,
  ASST_READY = 0x00000001,
  ASST_BUSY_ON_CALL = 0x00000002,
  ASST_BUSY_WRAPUP = 0x00000003,
  ASST_SESSION_ENDED = 0x00000004,
}

enum AGENT_STATE {
  AS_NOT_READY = 0x00000000,
  AS_READY = 0x00000001,
  AS_BUSY_ACD = 0x00000002,
  AS_BUSY_INCOMING = 0x00000003,
  AS_BUSY_OUTGOING = 0x00000004,
  AS_UNKNOWN = 0x00000005,
}

enum AGENT_EVENT {
  AE_NOT_READY = 0x00000000,
  AE_READY = 0x00000001,
  AE_BUSY_ACD = 0x00000002,
  AE_BUSY_INCOMING = 0x00000003,
  AE_BUSY_OUTGOING = 0x00000004,
  AE_UNKNOWN = 0x00000005,
}

enum AGENT_SESSION_EVENT {
  ASE_NEW_SESSION = 0x00000000,
  ASE_NOT_READY = 0x00000001,
  ASE_READY = 0x00000002,
  ASE_BUSY = 0x00000003,
  ASE_WRAPUP = 0x00000004,
  ASE_END = 0x00000005,
}

enum ACDGROUP_EVENT {
  ACDGE_NEW_GROUP = 0x00000000,
  ACDGE_GROUP_REMOVED = 0x00000001,
}

enum ACDQUEUE_EVENT {
  ACDQE_NEW_QUEUE = 0x00000000,
  ACDQE_QUEUE_REMOVED = 0x00000001,
}

enum AGENTHANDLER_EVENT {
  AHE_NEW_AGENTHANDLER = 0x00000000,
  AHE_AGENTHANDLER_REMOVED = 0x00000001,
}

enum CALLINFOCHANGE_CAUSE {
  CIC_OTHER = 0x00000000,
  CIC_DEVSPECIFIC = 0x00000001,
  CIC_BEARERMODE = 0x00000002,
  CIC_RATE = 0x00000003,
  CIC_APPSPECIFIC = 0x00000004,
  CIC_CALLID = 0x00000005,
  CIC_RELATEDCALLID = 0x00000006,
  CIC_ORIGIN = 0x00000007,
  CIC_REASON = 0x00000008,
  CIC_COMPLETIONID = 0x00000009,
  CIC_NUMOWNERINCR = 0x0000000A,
  CIC_NUMOWNERDECR = 0x0000000B,
  CIC_NUMMONITORS = 0x0000000C,
  CIC_TRUNK = 0x0000000D,
  CIC_CALLERID = 0x0000000E,
  CIC_CALLEDID = 0x0000000F,
  CIC_CONNECTEDID = 0x00000010,
  CIC_REDIRECTIONID = 0x00000011,
  CIC_REDIRECTINGID = 0x00000012,
  CIC_USERUSERINFO = 0x00000013,
  CIC_HIGHLEVELCOMP = 0x00000014,
  CIC_LOWLEVELCOMP = 0x00000015,
  CIC_CHARGINGINFO = 0x00000016,
  CIC_TREATMENT = 0x00000017,
  CIC_CALLDATA = 0x00000018,
  CIC_PRIVILEGE = 0x00000019,
  CIC_MEDIATYPE = 0x0000001A,
  CIC_LASTITEM = 0x0000001A,
}

enum TAPI_TONEMODE {
  TTM_RINGBACK = 0x00000002,
  TTM_BUSY = 0x00000004,
  TTM_BEEP = 0x00000008,
  TTM_BILLING = 0x00000010,
}

enum TAPI_GATHERTERM {
  TGT_BUFFERFULL = 0x00000001,
  TGT_TERMDIGIT = 0x00000002,
  TGT_FIRSTTIMEOUT = 0x00000004,
  TGT_INTERTIMEOUT = 0x00000008,
  TGT_CANCEL = 0x00000010,
}

enum PHONE_TONE {
  PT_KEYPADZERO = 0x00000000,
  PT_KEYPADONE = 0x00000001,
  PT_KEYPADTWO = 0x00000002,
  PT_KEYPADTHREE = 0x00000003,
  PT_KEYPADFOUR = 0x00000004,
  PT_KEYPADFIVE = 0x00000005,
  PT_KEYPADSIX = 0x00000006,
  PT_KEYPADSEVEN = 0x00000007,
  PT_KEYPADEIGHT = 0x00000008,
  PT_KEYPADNINE = 0x00000009,
  PT_KEYPADSTAR = 0x0000000A,
  PT_KEYPADPOUND = 0x0000000B,
  PT_KEYPADA = 0x0000000C,
  PT_KEYPADB = 0x0000000D,
  PT_KEYPADC = 0x0000000E,
  PT_KEYPADD = 0x0000000F,
  PT_NORMALDIALTONE = 0x00000010,
  PT_EXTERNALDIALTONE = 0x00000011,
  PT_BUSY = 0x00000012,
  PT_RINGBACK = 0x00000013,
  PT_ERRORTONE = 0x00000014,
  PT_SILENCE = 0x00000015,
}

enum TERMINAL_MEDIA_STATE {
  TMS_IDLE = 0x00000000,
  TMS_ACTIVE = 0x00000001,
  TMS_PAUSED = 0x00000002,
  TMS_LASTITEM = 0x00000002,
}

enum FT_STATE_EVENT_CAUSE {
  FTEC_NORMAL = 0x00000000,
  FTEC_END_OF_FILE = 0x00000001,
  FTEC_READ_ERROR = 0x00000002,
  FTEC_WRITE_ERROR = 0x00000003,
}

enum PHONE_EVENT {
  PE_DISPLAY = 0x00000000,
  PE_LAMPMODE = 0x00000001,
  PE_RINGMODE = 0x00000002,
  PE_RINGVOLUME = 0x00000003,
  PE_HOOKSWITCH = 0x00000004,
  PE_CAPSCHANGE = 0x00000005,
  PE_BUTTON = 0x00000006,
  PE_CLOSE = 0x00000007,
  PE_NUMBERGATHERED = 0x00000008,
  PE_DIALING = 0x00000009,
  PE_ANSWER = 0x0000000A,
  PE_DISCONNECT = 0x0000000B,
  PE_LASTITEM = 0x0000000B,
}

enum FULLDUPLEX_SUPPORT {
  FDS_SUPPORTED = 0x00000000,
  FDS_NOTSUPPORTED = 0x00000001,
  FDS_UNKNOWN = 0x00000002,
}

// Union

union__MIDL_IWinTypes_0009 {
  int hInproc;
  int hRemote;
}

// Structs

struct _RemotableHandle {
  int fContext;
  __MIDL_IWinTypes_0009 u;
}

struct TAPI_DETECTTONE {
  uint dwAppSpecific;
  uint dwDuration;
  uint dwFrequency1;
  uint dwFrequency2;
  uint dwFrequency3;
}

struct TAPI_CUSTOMTONE {
  uint dwFrequency;
  uint dwCadenceOn;
  uint dwCadenceOff;
  uint dwVolume;
}

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

// Aliases

alias _RemotableHandle* wireHWND;

// Interfaces

// TAPI 3.0 ITCollection interface
interface ITCollection : IDispatch {
  mixin(uuid("5ec5acf2-9c02-11d0-8362-00aa003ccabd"));
  // Returns number of items in collection.
  /*[id(0x60020000)]*/ int get_Count(out int lCount);
  // Given an index, returns an item in the collection.
  /*[id(0x00000000)]*/ int get_Item(int Index, out VARIANT pVariant);
  // returns an enumerator for the collection.
  /*[id(0xFFFFFFFC)]*/ int get__NewEnum(out IUnknown ppNewEnum);
}

// ITMediaPlayback Interface
interface ITMediaPlayback : IDispatch {
  mixin(uuid("627e8ae6-ae4c-4a69-bb63-2ad625404b77"));
  // property PlayList
  /*[id(0x00040001)]*/ int put_PlayList(VARIANT pPlayListVariant);
  // property PlayList
  /*[id(0x00040001)]*/ int get_PlayList(out VARIANT pPlayListVariant);
}

// ITMediaRecord Interface
interface ITMediaRecord : IDispatch {
  mixin(uuid("f5dd4592-5476-4cc1-9d4d-fad3eefe7db2"));
  // propery FileName
  /*[id(0x00030001)]*/ int put_FileName(wchar* pbstrFileName);
  // propery FileName
  /*[id(0x00030001)]*/ int get_FileName(out wchar* pbstrFileName);
}

// TAPI 3.1 ITCollection2 interface
interface ITCollection2 : ITCollection {
  mixin(uuid("e6dddda5-a6d3-48ff-8737-d32fc4d95477"));
  // Adds an item to the collection.
  /*[id(0x00000001)]*/ int Add(int Index, VARIANT* pVariant);
  // Removes an item from the collection.
  /*[id(0x00000002)]*/ int Remove(int Index);
}

// TAPI 3.0 ITCallStateEvent Interface
interface ITCallStateEvent : IDispatch {
  mixin(uuid("62f47097-95c9-11d0-835d-00aa003ccabd"));
  // property Call
  /*[id(0x00000001)]*/ int get_Call(out ITCallInfo ppCallInfo);
  // property State
  /*[id(0x00000002)]*/ int get_State(out CALL_STATE pCallState);
  // property Cause
  /*[id(0x00000003)]*/ int get_Cause(out CALL_STATE_EVENT_CAUSE pCEC);
  // property CallbackInstance
  /*[id(0x00000004)]*/ int get_CallbackInstance(out int plCallbackInstance);
}

// TAPI 3.0 ITCallInfo interface
interface ITCallInfo : IDispatch {
  mixin(uuid("350f85d1-1227-11d3-83d4-00c04fb6809f"));
  // property Address
  /*[id(0x00010001)]*/ int get_Address(out ITAddress ppAddress);
  // property CallState
  /*[id(0x00010002)]*/ int get_CallState(out CALL_STATE pCallState);
  // property Privilege
  /*[id(0x00010003)]*/ int get_Privilege(out CALL_PRIVILEGE pPrivilege);
  // property CallHub
  /*[id(0x00010004)]*/ int get_CallHub(out ITCallHub ppCallHub);
  // property CallInfoLong
  /*[id(0x00010005)]*/ int get_CallInfoLong(CALLINFO_LONG CallInfoLong, out int plCallInfoLongVal);
  // property CallInfoLong
  /*[id(0x00010005)]*/ int put_CallInfoLong(CALLINFO_LONG CallInfoLong, int plCallInfoLongVal);
  // property CallInfoString
  /*[id(0x00010006)]*/ int get_CallInfoString(CALLINFO_STRING CallInfoString, out wchar* ppCallInfoString);
  // property CallInfoString
  /*[id(0x00010006)]*/ int put_CallInfoString(CALLINFO_STRING CallInfoString, wchar* ppCallInfoString);
  // property CallInfoBuffer
  /*[id(0x00010007)]*/ int get_CallInfoBuffer(CALLINFO_BUFFER CallInfoBuffer, out VARIANT ppCallInfoBuffer);
  // property CallInfoBuffer
  /*[id(0x00010007)]*/ int put_CallInfoBuffer(CALLINFO_BUFFER CallInfoBuffer, VARIANT ppCallInfoBuffer);
  /*[id(0x00010008)]*/ int GetCallInfoBuffer(CALLINFO_BUFFER CallInfoBuffer, out uint pdwSize, out ubyte ppCallInfoBuffer);
  /*[id(0x00010009)]*/ int SetCallInfoBuffer(CALLINFO_BUFFER CallInfoBuffer, uint dwSize, ubyte* pCallInfoBuffer);
  // method ReleaseUserUserInfo
  /*[id(0x0001000A)]*/ int ReleaseUserUserInfo();
}

// TAPI 3.0 ITAddress interface
interface ITAddress : IDispatch {
  mixin(uuid("b1efc386-9355-11d0-835c-00aa003ccabd"));
  // property State
  /*[id(0x00010001)]*/ int get_State(out ADDRESS_STATE pAddressState);
  // property AddressName
  /*[id(0x00010002)]*/ int get_AddressName(out wchar* ppName);
  // property ServiceProviderName
  /*[id(0x00010003)]*/ int get_ServiceProviderName(out wchar* ppName);
  // property TAPIObject
  /*[id(0x00010004)]*/ int get_TAPIObject(out ITTAPI ppTapiObject);
  // method CreateCall
  /*[id(0x00010005)]*/ int CreateCall(wchar* pDestAddress, int lAddressType, int lMediaTypes, out ITBasicCallControl ppCall);
  // property Calls
  /*[id(0x00010006)]*/ int get_Calls(out VARIANT pVariant);
  // method EnumerateCalls
  /*[id(0x00010007)]*/ int EnumerateCalls(out IEnumCall ppCallEnum);
  // property DialableAddress
  /*[id(0x00010008)]*/ int get_DialableAddress(out wchar* pDialableAddress);
  // method CreateForwardInfoObject
  /*[id(0x0001000A)]*/ int CreateForwardInfoObject(out ITForwardInformation ppForwardInfo);
  // method Forward
  /*[id(0x0001000B)]*/ int Forward(ITForwardInformation pForwardInfo, ITBasicCallControl pCall);
  // method Forward
  /*[id(0x0001000C)]*/ int get_CurrentForwardInfo(out ITForwardInformation ppForwardInfo);
  // property MessageWaiting
  /*[id(0x0001000E)]*/ int put_MessageWaiting(short pfMessageWaiting);
  // property MessageWaiting
  /*[id(0x0001000E)]*/ int get_MessageWaiting(out short pfMessageWaiting);
  // property DoNotDisturb
  /*[id(0x0001000F)]*/ int put_DoNotDisturb(short pfDoNotDisturb);
  // property DoNotDisturb
  /*[id(0x0001000F)]*/ int get_DoNotDisturb(out short pfDoNotDisturb);
}

// TAPI 3.0 ITTAPI interface
interface ITTAPI : IDispatch {
  mixin(uuid("b1efc382-9355-11d0-835c-00aa003ccabd"));
  // Initialize
  /*[id(0x0001000D)]*/ int Initialize();
  // Shutdown
  /*[id(0x0001000E)]*/ int Shutdown();
  // property Addresses
  /*[id(0x00010001)]*/ int get_Addresses(out VARIANT pVariant);
  // method EnumerateAddresses
  /*[id(0x00010002)]*/ int EnumerateAddresses(out IEnumAddress ppEnumAddress);
  // method RegisterCallNotifications
  /*[id(0x00010003)]*/ int RegisterCallNotifications(ITAddress pAddress, short fMonitor, short fOwner, int lMediaTypes, int lCallbackInstance, out int plRegister);
  // method UnregisterNotifications
  /*[id(0x00010004)]*/ int UnregisterNotifications(int lRegister);
  // property CallHubs
  /*[id(0x00010005)]*/ int get_CallHubs(out VARIANT pVariant);
  // method EnumerateCallHubs
  /*[id(0x00010006)]*/ int EnumerateCallHubs(out IEnumCallHub ppEnumCallHub);
  // method SetCallHubTracking
  /*[id(0x00010007)]*/ int SetCallHubTracking(VARIANT pAddresses, short bTracking);
  /*[id(0x00010008)]*/ int EnumeratePrivateTAPIObjects(out IEnumUnknown ppEnumUnknown);
  // property PrivateTAPIObjects
  /*[id(0x00010009)]*/ int get_PrivateTAPIObjects(out VARIANT pVariant);
  // method RegisterRequestRecipient
  /*[id(0x0001000A)]*/ int RegisterRequestRecipient(int lRegistrationInstance, int lRequestMode, short fEnable);
  // method SetAssistedTelephonyPriority
  /*[id(0x0001000B)]*/ int SetAssistedTelephonyPriority(wchar* pAppFilename, short fPriority);
  // method SetApplicationPriority
  /*[id(0x0001000C)]*/ int SetApplicationPriority(wchar* pAppFilename, int lMediaType, short fPriority);
  // property EventFilter
  /*[id(0x0001000F)]*/ int put_EventFilter(int plFilterMask);
  // property EventFilter
  /*[id(0x0001000F)]*/ int get_EventFilter(out int plFilterMask);
}

// TAPI 3.0 IEnumAddress interface
interface IEnumAddress : IUnknown {
  mixin(uuid("1666fca1-9363-11d0-835c-00aa003ccabd"));
  /*[id(0x60010000)]*/ int Next(uint celt, out ITAddress ppElements, ref uint pceltFetched);
  /*[id(0x60010001)]*/ int Reset();
  /*[id(0x60010002)]*/ int Skip(uint celt);
  /*[id(0x60010003)]*/ int Clone(out IEnumAddress ppEnum);
}

// TAPI 3.0 IEnumCallHub interface
interface IEnumCallHub : IUnknown {
  mixin(uuid("a3c15450-5b92-11d1-8f4e-00c04fb6809f"));
  /*[id(0x60010000)]*/ int Next(uint celt, out ITCallHub ppElements, ref uint pceltFetched);
  /*[id(0x60010001)]*/ int Reset();
  /*[id(0x60010002)]*/ int Skip(uint celt);
  /*[id(0x60010003)]*/ int Clone(out IEnumCallHub ppEnum);
}

// TAPI 3.0 ITCallHub interface
interface ITCallHub : IDispatch {
  mixin(uuid("a3c1544e-5b92-11d1-8f4e-00c04fb6809f"));
  // method Clear
  /*[id(0x00000001)]*/ int Clear();
  // method EnumerateCalls
  /*[id(0x00000002)]*/ int EnumerateCalls(out IEnumCall ppEnumCall);
  // property Calls
  /*[id(0x00000003)]*/ int get_Calls(out VARIANT pCalls);
  // property NumCalls
  /*[id(0x00000004)]*/ int get_NumCalls(out int plCalls);
  // property State
  /*[id(0x00000005)]*/ int get_State(out CALLHUB_STATE pState);
}

// TAPI 3.0 IEnumCall interface
interface IEnumCall : IUnknown {
  mixin(uuid("ae269cf6-935e-11d0-835c-00aa003ccabd"));
  /*[id(0x60010000)]*/ int Next(uint celt, out ITCallInfo ppElements, ref uint pceltFetched);
  /*[id(0x60010001)]*/ int Reset();
  /*[id(0x60010002)]*/ int Skip(uint celt);
  /*[id(0x60010003)]*/ int Clone(out IEnumCall ppEnum);
}

interface IEnumUnknown : IUnknown {
  mixin(uuid("00000100-0000-0000-c000-000000000046"));
  /*[id(0x60010000)]*/ int RemoteNext(uint celt, out IUnknown rgelt, out uint pceltFetched);
  /*[id(0x60010001)]*/ int Skip(uint celt);
  /*[id(0x60010002)]*/ int Reset();
  /*[id(0x60010003)]*/ int Clone(out IEnumUnknown ppEnum);
}

// TAPI 3.0 ITBasicCallControl interface
interface ITBasicCallControl : IDispatch {
  mixin(uuid("b1efc389-9355-11d0-835c-00aa003ccabd"));
  // method Connect
  /*[id(0x00020003)]*/ int Connect(short fSync);
  // method Answer
  /*[id(0x00020004)]*/ int Answer();
  // method Disconnect
  /*[id(0x00020005)]*/ int Disconnect(DISCONNECT_CODE code);
  // method Hold
  /*[id(0x00020006)]*/ int Hold(short fHold);
  // method HandoffDirect
  /*[id(0x00020007)]*/ int HandoffDirect(wchar* pApplicationName);
  // method HandoffIndirect
  /*[id(0x00020008)]*/ int HandoffIndirect(int lMediaType);
  // method Conference
  /*[id(0x00020009)]*/ int Conference(ITBasicCallControl pCall, short fSync);
  // method Transfer
  /*[id(0x0002000A)]*/ int Transfer(ITBasicCallControl pCall, short fSync);
  // method BlindTransfer
  /*[id(0x0002000B)]*/ int BlindTransfer(wchar* pDestAddress);
  // method SwapHold
  /*[id(0x0002000C)]*/ int SwapHold(ITBasicCallControl pCall);
  // method ParkDirect
  /*[id(0x0002000D)]*/ int ParkDirect(wchar* pParkAddress);
  // method ParkIndirect
  /*[id(0x0002000E)]*/ int ParkIndirect(out wchar* ppNonDirAddress);
  // method Unpark
  /*[id(0x0002000F)]*/ int Unpark();
  // method SetQOS
  /*[id(0x00020010)]*/ int SetQOS(int lMediaType, QOS_SERVICE_LEVEL ServiceLevel);
  // method Pickup
  /*[id(0x00020013)]*/ int Pickup(wchar* pGroupID);
  // method Dial
  /*[id(0x00020014)]*/ int Dial(wchar* pDestAddress);
  // method Finish
  /*[id(0x00020015)]*/ int Finish(FINISH_MODE finishMode);
  // method RemoveFromConference
  /*[id(0x00020016)]*/ int RemoveFromConference();
}

// TAPI 3.0 ITForwardInformation Interface
interface ITForwardInformation : IDispatch {
  mixin(uuid("449f659e-88a3-11d1-bb5d-00c04fb6809f"));
  // property NumRingsNoAnswer
  /*[id(0x00000001)]*/ int put_NumRingsNoAnswer(int plNumRings);
  // property NumRingsNoAnswer
  /*[id(0x00000001)]*/ int get_NumRingsNoAnswer(out int plNumRings);
  // method SetForwardType
  /*[id(0x00000002)]*/ int SetForwardType(int ForwardType, wchar* pDestAddress, wchar* pCallerAddress);
  // property ForwardTypeDestination
  /*[id(0x00000003)]*/ int get_ForwardTypeDestination(int ForwardType, out wchar* ppDestAddress);
  // property ForwardTypeCaller
  /*[id(0x00000004)]*/ int get_ForwardTypeCaller(int ForwardType, out wchar* ppCallerAddress);
  /*[id(0x00000005)]*/ int GetForwardType(int ForwardType, out wchar* ppDestinationAddress, out wchar* ppCallerAddress);
  // method Clear
  /*[id(0x00000006)]*/ int Clear();
}

// TAPI 3.0 ITCallNotificationEvent interface
interface ITCallNotificationEvent : IDispatch {
  mixin(uuid("895801df-3dd6-11d1-8f30-00c04fb6809f"));
  // property Call
  /*[id(0x00000001)]*/ int get_Call(out ITCallInfo ppCall);
  // property Event
  /*[id(0x00000002)]*/ int get_Event(out CALL_NOTIFICATION_EVENT pCallNotificationEvent);
  // property CallbackInstance
  /*[id(0x00000003)]*/ int get_CallbackInstance(out int plCallbackInstance);
}

// TAPI 3.0 ITTAPIEventNotification Interface
interface ITTAPIEventNotification : IUnknown {
  mixin(uuid("eddb9426-3b91-11d1-8f30-00c04fb6809f"));
  // method Event
  /*[id(0x00000001)]*/ int Event(TAPI_EVENT TapiEvent, IDispatch pEvent);
}

// TAPI 3.0 ITBasicAudioTerminal interface
interface ITBasicAudioTerminal : IDispatch {
  mixin(uuid("b1efc38d-9355-11d0-835c-00aa003ccabd"));
  // property Volume
  /*[id(0x00000001)]*/ int put_Volume(int plVolume);
  // property Volume
  /*[id(0x00000001)]*/ int get_Volume(out int plVolume);
  // property Balance
  /*[id(0x00000002)]*/ int put_Balance(int plBalance);
  // property Balance
  /*[id(0x00000002)]*/ int get_Balance(out int plBalance);
}

// TAPI 3.0 ITCallHubEvent Interface
interface ITCallHubEvent : IDispatch {
  mixin(uuid("a3c15451-5b92-11d1-8f4e-00c04fb6809f"));
  // property Event
  /*[id(0x00000001)]*/ int get_Event(out CALLHUB_EVENT pEvent);
  // property CallHub
  /*[id(0x00000002)]*/ int get_CallHub(out ITCallHub ppCallHub);
  // property Call
  /*[id(0x00000003)]*/ int get_Call(out ITCallInfo ppCall);
}

// TAPI 3.1 ITForwardInformation2 Interface
interface ITForwardInformation2 : ITForwardInformation {
  mixin(uuid("5229b4ed-b260-4382-8e1a-5df3a8a4ccc0"));
  // method SetForwardType2
  /*[id(0x00000007)]*/ int SetForwardType2(int ForwardType, wchar* pDestAddress, int DestAddressType, wchar* pCallerAddress, int CallerAddressType);
  /*[id(0x00000008)]*/ int GetForwardType2(int ForwardType, out wchar* ppDestinationAddress, out int pDestAddressType, out wchar* ppCallerAddress, out int pCallerAddressType);
  // property ForwardTypeDestinationAddressType
  /*[id(0x00000009)]*/ int get_ForwardTypeDestinationAddressType(int ForwardType, out int pDestAddressType);
  // property ForwardTypeCallerAddressType
  /*[id(0x0000000A)]*/ int get_ForwardTypeCallerAddressType(int ForwardType, out int pCallerAddressType);
}

// TAPI 3.0 ITAddressCapabilities interface
interface ITAddressCapabilities : IDispatch {
  mixin(uuid("8df232f5-821b-11d1-bb5c-00c04fb6809f"));
  // property AddressCapability
  /*[id(0x00020001)]*/ int get_AddressCapability(ADDRESS_CAPABILITY AddressCap, out int plCapability);
  // property AddressCapabilityString
  /*[id(0x00020002)]*/ int get_AddressCapabilityString(ADDRESS_CAPABILITY_STRING AddressCapString, out wchar* ppCapabilityString);
  // property CallTreatments
  /*[id(0x00020003)]*/ int get_CallTreatments(out VARIANT pVariant);
  /*[id(0x00020004)]*/ int EnumerateCallTreatments(out IEnumBstr ppEnumCallTreatment);
  // property CompletionMessages
  /*[id(0x00020005)]*/ int get_CompletionMessages(out VARIANT pVariant);
  /*[id(0x00020006)]*/ int EnumerateCompletionMessages(out IEnumBstr ppEnumCompletionMessage);
  // property DeviceClasses
  /*[id(0x00020007)]*/ int get_DeviceClasses(out VARIANT pVariant);
  /*[id(0x00020008)]*/ int EnumerateDeviceClasses(out IEnumBstr ppEnumDeviceClass);
}

// TAPI 3.0 IEnumBstr interface
interface IEnumBstr : IUnknown {
  mixin(uuid("35372049-0bc6-11d2-a033-00c04fb6809f"));
  /*[id(0x60010000)]*/ int Next(uint celt, out wchar* ppStrings, ref uint pceltFetched);
  /*[id(0x60010001)]*/ int Reset();
  /*[id(0x60010002)]*/ int Skip(uint celt);
  /*[id(0x60010003)]*/ int Clone(out IEnumBstr ppEnum);
}

// TAPI 3.0 ITQOSEvent Interface
interface ITQOSEvent : IDispatch {
  mixin(uuid("cfa3357c-ad77-11d1-bb68-00c04fb6809f"));
  // property CallHub
  /*[id(0x00000001)]*/ int get_Call(out ITCallInfo ppCall);
  // property Event
  /*[id(0x00000003)]*/ int get_Event(out QOS_EVENT pQosEvent);
  // property MediaType
  /*[id(0x00000004)]*/ int get_MediaType(out int plMediaType);
}

// TAPI 3.0 ITAddressEvent interface
interface ITAddressEvent : IDispatch {
  mixin(uuid("831ce2d1-83b5-11d1-bb5c-00c04fb6809f"));
  // property Address
  /*[id(0x00000001)]*/ int get_Address(out ITAddress ppAddress);
  // property Event
  /*[id(0x00000002)]*/ int get_Event(out ADDRESS_EVENT pEvent);
  // property Terminal
  /*[id(0x00000003)]*/ int get_Terminal(out ITTerminal ppTerminal);
}

// TAPI 3.0 ITTerminal interface
interface ITTerminal : IDispatch {
  mixin(uuid("b1efc38a-9355-11d0-835c-00aa003ccabd"));
  // property Name
  /*[id(0x00000001)]*/ int get_Name(out wchar* ppName);
  // property State
  /*[id(0x00000002)]*/ int get_State(out TERMINAL_STATE pTerminalState);
  // property TerminalType
  /*[id(0x00000003)]*/ int get_TerminalType(out TERMINAL_TYPE pType);
  // property TerminalClass
  /*[id(0x00000004)]*/ int get_TerminalClass(out wchar* ppTerminalClass);
  // property MediaType
  /*[id(0x00000005)]*/ int get_MediaType(out int plMediaType);
  // property Direction
  /*[id(0x00000006)]*/ int get_Direction(out TERMINAL_DIRECTION pDirection);
}

// TAPI 3.1 ITAddressDeviceSpecificEvent interface
interface ITAddressDeviceSpecificEvent : IDispatch {
  mixin(uuid("3acb216b-40bd-487a-8672-5ce77bd7e3a3"));
  // property Address
  /*[id(0x00000001)]*/ int get_Address(out ITAddress ppAddress);
  // property Call
  /*[id(0x00000002)]*/ int get_Call(out ITCallInfo ppCall);
  // property lParam1
  /*[id(0x00000003)]*/ int get_lParam1(out int pParam1);
  // property lParam2
  /*[id(0x00000004)]*/ int get_lParam2(out int pParam2);
  // property lParam3
  /*[id(0x00000005)]*/ int get_lParam3(out int pParam3);
}

// TAPI 3.0 ITCallMediaEvent Interface
interface ITCallMediaEvent : IDispatch {
  mixin(uuid("ff36b87f-ec3a-11d0-8ee4-00c04fb6809f"));
  // property Call
  /*[id(0x00000001)]*/ int get_Call(out ITCallInfo ppCallInfo);
  // property Event
  /*[id(0x00000002)]*/ int get_Event(out CALL_MEDIA_EVENT pCallMediaEvent);
  // property Error
  /*[id(0x00000003)]*/ int get_Error(out int phrError);
  // property Terminal
  /*[id(0x00000004)]*/ int get_Terminal(out ITTerminal ppTerminal);
  // property Stream
  /*[id(0x00000005)]*/ int get_Stream(out ITStream ppStream);
  // property Cause
  /*[id(0x00000006)]*/ int get_Cause(out CALL_MEDIA_EVENT_CAUSE pCause);
}

// ITStream interface
interface ITStream : IDispatch {
  mixin(uuid("ee3bd605-3868-11d2-a045-00c04fb6809f"));
  // property MediaType
  /*[id(0x00000001)]*/ int get_MediaType(out int plMediaType);
  // property Direction
  /*[id(0x00000002)]*/ int get_Direction(out TERMINAL_DIRECTION pTD);
  // property Name
  /*[id(0x00000003)]*/ int get_Name(out wchar* ppName);
  // method StartStream
  /*[id(0x00000004)]*/ int StartStream();
  // method PauseStream
  /*[id(0x00000005)]*/ int PauseStream();
  // method StopStream
  /*[id(0x00000006)]*/ int StopStream();
  // method SelectTerminal
  /*[id(0x00000007)]*/ int SelectTerminal(ITTerminal pTerminal);
  // method UnselectTerminal
  /*[id(0x00000008)]*/ int UnselectTerminal(ITTerminal pTerminal);
  /*[id(0x00000009)]*/ int EnumerateTerminals(out IEnumTerminal ppEnumTerminal);
  // property Terminals
  /*[id(0x0000000A)]*/ int get_Terminals(out VARIANT pTerminals);
}

// TAPI 3.0 IEnumTerminal Interface
interface IEnumTerminal : IUnknown {
  mixin(uuid("ae269cf4-935e-11d0-835c-00aa003ccabd"));
  /*[id(0x60010000)]*/ int Next(uint celt, out ITTerminal ppElements, ref uint pceltFetched);
  /*[id(0x60010001)]*/ int Reset();
  /*[id(0x60010002)]*/ int Skip(uint celt);
  /*[id(0x60010003)]*/ int Clone(out IEnumTerminal ppEnum);
}

// TAPI 3.0 ITTAPIObjectEvent Interface
interface ITTAPIObjectEvent : IDispatch {
  mixin(uuid("f4854d48-937a-11d1-bb58-00c04fb6809f"));
  // property TAPIObject
  /*[id(0x00000001)]*/ int get_TAPIObject(out ITTAPI ppTapiObject);
  // property Event
  /*[id(0x00000002)]*/ int get_Event(out TAPIOBJECT_EVENT pEvent);
  // property Address
  /*[id(0x00000003)]*/ int get_Address(out ITAddress ppAddress);
  // property CallbackInstance
  /*[id(0x00000004)]*/ int get_CallbackInstance(out int plCallbackInstance);
}

// TAPI 3.1 ITTAPIObjectEvent2 interface
interface ITTAPIObjectEvent2 : ITTAPIObjectEvent {
  mixin(uuid("359dda6e-68ce-4383-bf0b-169133c41b46"));
  // property Phone
  /*[id(0x00000005)]*/ int get_Phone(out ITPhone ppPhone);
}

// TAPI 3.1 ITPhone interface
interface ITPhone : IDispatch {
  mixin(uuid("09d48db4-10cc-4388-9de7-a8465618975a"));
  // method Open
  /*[id(0x00010001)]*/ int Open(PHONE_PRIVILEGE Privilege);
  // method Close
  /*[id(0x00010002)]*/ int Close();
  // property Addresses
  /*[id(0x00010003)]*/ int get_Addresses(out VARIANT pAddresses);
  // method EnumerateAddresses
  /*[id(0x00010004)]*/ int EnumerateAddresses(out IEnumAddress ppEnumAddress);
  // property PhoneCapsLong
  /*[id(0x00010005)]*/ int get_PhoneCapsLong(PHONECAPS_LONG pclCap, out int plCapability);
  // property PhoneCapsString
  /*[id(0x00010006)]*/ int get_PhoneCapsString(PHONECAPS_STRING pcsCap, out wchar* ppCapability);
  // property Terminals
  /*[id(0x00010007)]*/ int get_Terminals(ITAddress pAddress, out VARIANT pTerminals);
  // method EnumerateTerminals
  /*[id(0x00010008)]*/ int EnumerateTerminals(ITAddress pAddress, out IEnumTerminal ppEnumTerminal);
  // property ButtonMode
  /*[id(0x00010009)]*/ int get_ButtonMode(int lButtonID, out PHONE_BUTTON_MODE pButtonMode);
  // property ButtonMode
  /*[id(0x00010009)]*/ int put_ButtonMode(int lButtonID, PHONE_BUTTON_MODE pButtonMode);
  // property ButtonFunction
  /*[id(0x0001000A)]*/ int get_ButtonFunction(int lButtonID, out PHONE_BUTTON_FUNCTION pButtonFunction);
  // property ButtonFunction
  /*[id(0x0001000A)]*/ int put_ButtonFunction(int lButtonID, PHONE_BUTTON_FUNCTION pButtonFunction);
  // property ButtonText
  /*[id(0x0001000B)]*/ int get_ButtonText(int lButtonID, out wchar* ppButtonText);
  // property ButtonText
  /*[id(0x0001000B)]*/ int put_ButtonText(int lButtonID, wchar* ppButtonText);
  // property ButtonState
  /*[id(0x0001000C)]*/ int get_ButtonState(int lButtonID, out PHONE_BUTTON_STATE pButtonState);
  // property HookSwitchState
  /*[id(0x0001000D)]*/ int get_HookSwitchState(PHONE_HOOK_SWITCH_DEVICE HookSwitchDevice, out PHONE_HOOK_SWITCH_STATE pHookSwitchState);
  // property HookSwitchState
  /*[id(0x0001000D)]*/ int put_HookSwitchState(PHONE_HOOK_SWITCH_DEVICE HookSwitchDevice, PHONE_HOOK_SWITCH_STATE pHookSwitchState);
  // property RingMode
  /*[id(0x0001000E)]*/ int put_RingMode(int plRingMode);
  // property RingMode
  /*[id(0x0001000E)]*/ int get_RingMode(out int plRingMode);
  // property RingVolume
  /*[id(0x0001000F)]*/ int put_RingVolume(int plRingVolume);
  // property RingVolume
  /*[id(0x0001000F)]*/ int get_RingVolume(out int plRingVolume);
  // property Privilege
  /*[id(0x00010010)]*/ int get_Privilege(out PHONE_PRIVILEGE pPrivilege);
  // method GetPhoneDevCapsBuffer
  /*[id(0x00010011)]*/ int GetPhoneCapsBuffer(PHONECAPS_BUFFER pcbCaps, out uint pdwSize, out ubyte ppPhoneCapsBuffer);
  // property PhoneCapsBuffer
  /*[id(0x00010012)]*/ int get_PhoneCapsBuffer(PHONECAPS_BUFFER pcbCaps, out VARIANT pVarBuffer);
  // property LampMode
  /*[id(0x00010013)]*/ int get_LampMode(int lLampID, out PHONE_LAMP_MODE pLampMode);
  // property LampMode
  /*[id(0x00010013)]*/ int put_LampMode(int lLampID, PHONE_LAMP_MODE pLampMode);
  // property Display
  /*[id(0x00010014)]*/ int get_Display(out wchar* pbstrDisplay);
  // method SetDisplay
  /*[id(0x00010015)]*/ int SetDisplay(int lRow, int lColumn, wchar* bstrDisplay);
  // property PreferredAddresses
  /*[id(0x00010016)]*/ int get_PreferredAddresses(out VARIANT pAddresses);
  // method EnumeratePreferredAddresses
  /*[id(0x00010017)]*/ int EnumeratePreferredAddresses(out IEnumAddress ppEnumAddress);
  // method DeviceSpecific
  /*[id(0x00010018)]*/ int DeviceSpecific(ubyte* pParams, uint dwSize);
  // method DeviceSpecificVariant
  /*[id(0x00010019)]*/ int DeviceSpecificVariant(VARIANT varDevSpecificByteArray);
  // method NegotiateExtVersion
  /*[id(0x0001001A)]*/ int NegotiateExtVersion(int lLowVersion, int lHighVersion, out int plExtVersion);
}

// TAPI 3.0 ITAddressTranslation Interface
interface ITAddressTranslation : IDispatch {
  mixin(uuid("0c4d8f03-8ddb-11d1-a09e-00805fc147d3"));
  // method TranslateAddress
  /*[id(0x00040001)]*/ int TranslateAddress(wchar* pAddressToTranslate, int lCard, int lTranslateOptions, out ITAddressTranslationInfo ppTranslated);
  // method TranslateDialog
  /*[id(0x00040002)]*/ int TranslateDialog(int hwndOwner, wchar* pAddressIn);
  // method EnumerateLocations
  /*[id(0x00040003)]*/ int EnumerateLocations(out IEnumLocation ppEnumLocation);
  // property Locations
  /*[id(0x00040004)]*/ int get_Locations(out VARIANT pVariant);
  // method EnumerateCallingCards
  /*[id(0x00040005)]*/ int EnumerateCallingCards(out IEnumCallingCard ppEnumCallingCard);
  // property CallingCards
  /*[id(0x00040006)]*/ int get_CallingCards(out VARIANT pVariant);
}

// TAPI 3.0 ITAddressTranslationInfo Interface
interface ITAddressTranslationInfo : IDispatch {
  mixin(uuid("afc15945-8d40-11d1-a09e-00805fc147d3"));
  // property Dialable String
  /*[id(0x00000001)]*/ int get_DialableString(out wchar* ppDialableString);
  // property Displayable String
  /*[id(0x00000002)]*/ int get_DisplayableString(out wchar* ppDisplayableString);
  // property Current Country Code
  /*[id(0x00000003)]*/ int get_CurrentCountryCode(out int CountryCode);
  // property Destination Country Code
  /*[id(0x00000004)]*/ int get_DestinationCountryCode(out int CountryCode);
  // property Translation Results
  /*[id(0x00000005)]*/ int get_TranslationResults(out int plResults);
}

// TAPI 3.0 IEnumLocation interface
interface IEnumLocation : IUnknown {
  mixin(uuid("0c4d8f01-8ddb-11d1-a09e-00805fc147d3"));
  /*[id(0x60010000)]*/ int Next(uint celt, out ITLocationInfo ppElements, ref uint pceltFetched);
  /*[id(0x60010001)]*/ int Reset();
  /*[id(0x60010002)]*/ int Skip(uint celt);
  /*[id(0x60010003)]*/ int Clone(out IEnumLocation ppEnum);
}

// TAPI 3.0 ITLocationInfo Interface
interface ITLocationInfo : IDispatch {
  mixin(uuid("0c4d8eff-8ddb-11d1-a09e-00805fc147d3"));
  // property Permanent Location ID
  /*[id(0x00000001)]*/ int get_PermanentLocationID(out int plLocationID);
  // property Country Code
  /*[id(0x00000002)]*/ int get_CountryCode(out int plCountryCode);
  // property Country ID
  /*[id(0x00000003)]*/ int get_CountryID(out int plCountryID);
  // property Options
  /*[id(0x00000004)]*/ int get_Options(out int plOptions);
  // property Preferred Credit Card ID
  /*[id(0x00000005)]*/ int get_PreferredCardID(out int plCardID);
  // property Location Name
  /*[id(0x00000006)]*/ int get_LocationName(out wchar* ppLocationName);
  // property City/Area Code
  /*[id(0x00000007)]*/ int get_CityCode(out wchar* ppCode);
  // property Local Access Code
  /*[id(0x00000008)]*/ int get_LocalAccessCode(out wchar* ppCode);
  // property Long Distance Access Code
  /*[id(0x00000009)]*/ int get_LongDistanceAccessCode(out wchar* ppCode);
  // property Toll Prefix List
  /*[id(0x0000000A)]*/ int get_TollPrefixList(out wchar* ppTollList);
  // property Cancel Call Waiting Code
  /*[id(0x0000000B)]*/ int get_CancelCallWaitingCode(out wchar* ppCode);
}

// TAPI 3.0 IEnumCallingCard interface
interface IEnumCallingCard : IUnknown {
  mixin(uuid("0c4d8f02-8ddb-11d1-a09e-00805fc147d3"));
  /*[id(0x60010000)]*/ int Next(uint celt, out ITCallingCard ppElements, ref uint pceltFetched);
  /*[id(0x60010001)]*/ int Reset();
  /*[id(0x60010002)]*/ int Skip(uint celt);
  /*[id(0x60010003)]*/ int Clone(out IEnumCallingCard ppEnum);
}

// TAPI 3.0 ITCallingCard Interface
interface ITCallingCard : IDispatch {
  mixin(uuid("0c4d8f00-8ddb-11d1-a09e-00805fc147d3"));
  // property Permanent Card ID
  /*[id(0x00000001)]*/ int get_PermanentCardID(out int plCardID);
  // property Number Of Digits
  /*[id(0x00000002)]*/ int get_NumberOfDigits(out int plDigits);
  // property Options
  /*[id(0x00000003)]*/ int get_Options(out int plOptions);
  // property Card Name
  /*[id(0x00000004)]*/ int get_CardName(out wchar* ppCardName);
  // property Same Area Dialing Rule
  /*[id(0x00000005)]*/ int get_SameAreaDialingRule(out wchar* ppRule);
  // property Long Distance Dialing Rule
  /*[id(0x00000006)]*/ int get_LongDistanceDialingRule(out wchar* ppRule);
  // property International Dialing Rule
  /*[id(0x00000007)]*/ int get_InternationalDialingRule(out wchar* ppRule);
}

// TAPI 3.0 ITAgent interface
interface ITAgent : IDispatch {
  mixin(uuid("5770ece5-4b27-11d1-bf80-00805fc147d3"));
  // method EnumerateAgentSessions
  /*[id(0x00000001)]*/ int EnumerateAgentSessions(out IEnumAgentSession ppEnumAgentSession);
  // method CreateSession
  /*[id(0x00000002)]*/ int CreateSession(ITACDGroup pACDGroup, ITAddress pAddress, out ITAgentSession ppAgentSession);
  // method CreateSessionWithPIN
  /*[id(0x00000003)]*/ int CreateSessionWithPIN(ITACDGroup pACDGroup, ITAddress pAddress, wchar* pPIN, out ITAgentSession ppAgentSession);
  // property ID
  /*[id(0x00000004)]*/ int get_ID(out wchar* ppID);
  // property User
  /*[id(0x00000005)]*/ int get_User(out wchar* ppUser);
  // property State
  /*[id(0x00000006)]*/ int put_State(AGENT_STATE pAgentState);
  // property State
  /*[id(0x00000006)]*/ int get_State(out AGENT_STATE pAgentState);
  // property MeasurementPeriod
  /*[id(0x00000007)]*/ int put_MeasurementPeriod(int plPeriod);
  // property MeasurementPeriod
  /*[id(0x00000007)]*/ int get_MeasurementPeriod(out int plPeriod);
  // property OverallCallRate
  /*[id(0x00000008)]*/ int get_OverallCallRate(out long pcyCallrate);
  // property NumberOfACDCalls
  /*[id(0x00000009)]*/ int get_NumberOfACDCalls(out int plCalls);
  // property NumberOfIncomingCalls
  /*[id(0x0000000A)]*/ int get_NumberOfIncomingCalls(out int plCalls);
  // property NumberOfOutgoingCalls
  /*[id(0x0000000B)]*/ int get_NumberOfOutgoingCalls(out int plCalls);
  // property TotalACDTalkTime
  /*[id(0x0000000C)]*/ int get_TotalACDTalkTime(out int plTalkTime);
  // property TotalACDCallTime
  /*[id(0x0000000D)]*/ int get_TotalACDCallTime(out int plCallTime);
  // property TotalWrapUpTime
  /*[id(0x0000000E)]*/ int get_TotalWrapUpTime(out int plWrapUpTime);
  // property AgentSessions
  /*[id(0x0000000F)]*/ int get_AgentSessions(out VARIANT pVariant);
}

// TAPI 3.0 IEnumAgentSession interface
interface IEnumAgentSession : IUnknown {
  mixin(uuid("5afc314e-4bcc-11d1-bf80-00805fc147d3"));
  /*[id(0x60010000)]*/ int Next(uint celt, out ITAgentSession ppElements, out uint pceltFetched);
  /*[id(0x60010001)]*/ int Reset();
  /*[id(0x60010002)]*/ int Skip(uint celt);
  /*[id(0x60010003)]*/ int Clone(out IEnumAgentSession ppEnum);
}

// TAPI 3.0 ITAgentSession interface
interface ITAgentSession : IDispatch {
  mixin(uuid("5afc3147-4bcc-11d1-bf80-00805fc147d3"));
  // property Agent
  /*[id(0x00000001)]*/ int get_Agent(out ITAgent ppAgent);
  // property Address
  /*[id(0x00000002)]*/ int get_Address(out ITAddress ppAddress);
  // property ACDGroup
  /*[id(0x00000003)]*/ int get_ACDGroup(out ITACDGroup ppACDGroup);
  // property State
  /*[id(0x00000004)]*/ int put_State(AGENT_SESSION_STATE pSessionState);
  // property State
  /*[id(0x00000004)]*/ int get_State(out AGENT_SESSION_STATE pSessionState);
  // property SessionStartTime
  /*[id(0x00000005)]*/ int get_SessionStartTime(out double pdateSessionStart);
  // property SessionDuration
  /*[id(0x00000006)]*/ int get_SessionDuration(out int plDuration);
  // property NumberOfCalls
  /*[id(0x00000007)]*/ int get_NumberOfCalls(out int plCalls);
  // property TotalTalkTime
  /*[id(0x00000008)]*/ int get_TotalTalkTime(out int plTalkTime);
  // property AverageTalkTime
  /*[id(0x00000009)]*/ int get_AverageTalkTime(out int plTalkTime);
  // property TotalCallTime
  /*[id(0x0000000A)]*/ int get_TotalCallTime(out int plCallTime);
  // property AverageCallTime
  /*[id(0x0000000B)]*/ int get_AverageCallTime(out int plCallTime);
  // property TotalWrapUpTime
  /*[id(0x0000000C)]*/ int get_TotalWrapUpTime(out int plWrapUpTime);
  // property AverageWrapUpTime
  /*[id(0x0000000D)]*/ int get_AverageWrapUpTime(out int plWrapUpTime);
  // property ACDCallRate
  /*[id(0x0000000E)]*/ int get_ACDCallRate(out long pcyCallrate);
  // property LongestTimeToAnswer
  /*[id(0x0000000F)]*/ int get_LongestTimeToAnswer(out int plAnswerTime);
  // property AverageTimeToAnswer
  /*[id(0x00000010)]*/ int get_AverageTimeToAnswer(out int plAnswerTime);
}

// TAPI 3.0 ITACDGroup interface
interface ITACDGroup : IDispatch {
  mixin(uuid("5afc3148-4bcc-11d1-bf80-00805fc147d3"));
  // property Name
  /*[id(0x00000001)]*/ int get_Name(out wchar* ppName);
  // method EnumerateQueues
  /*[id(0x00000002)]*/ int EnumerateQueues(out IEnumQueue ppEnumQueue);
  // property Queues
  /*[id(0x00000003)]*/ int get_Queues(out VARIANT pVariant);
}

// TAPI 3.0 IEnumQueue interface
interface IEnumQueue : IUnknown {
  mixin(uuid("5afc3158-4bcc-11d1-bf80-00805fc147d3"));
  /*[id(0x60010000)]*/ int Next(uint celt, out ITQueue ppElements, out uint pceltFetched);
  /*[id(0x60010001)]*/ int Reset();
  /*[id(0x60010002)]*/ int Skip(uint celt);
  /*[id(0x60010003)]*/ int Clone(out IEnumQueue ppEnum);
}

// TAPI 3.0 ITQueue interface
interface ITQueue : IDispatch {
  mixin(uuid("5afc3149-4bcc-11d1-bf80-00805fc147d3"));
  // property MeasurementPeriod
  /*[id(0x00000001)]*/ int put_MeasurementPeriod(int plPeriod);
  // property MeasurementPeriod
  /*[id(0x00000001)]*/ int get_MeasurementPeriod(out int plPeriod);
  // property TotalCallsQueued
  /*[id(0x00000002)]*/ int get_TotalCallsQueued(out int plCalls);
  // property CurrentCallsQueued
  /*[id(0x00000003)]*/ int get_CurrentCallsQueued(out int plCalls);
  // property TotalCallsAbandoned
  /*[id(0x00000004)]*/ int get_TotalCallsAbandoned(out int plCalls);
  // property TotalCallsFlowedIn
  /*[id(0x00000005)]*/ int get_TotalCallsFlowedIn(out int plCalls);
  // property TotalCallsFlowedOut
  /*[id(0x00000006)]*/ int get_TotalCallsFlowedOut(out int plCalls);
  // property LongestEverWaitTime
  /*[id(0x00000007)]*/ int get_LongestEverWaitTime(out int plWaitTime);
  // property CurrentLongestWaitTime
  /*[id(0x00000008)]*/ int get_CurrentLongestWaitTime(out int plWaitTime);
  // property AverageWaitTime
  /*[id(0x00000009)]*/ int get_AverageWaitTime(out int plWaitTime);
  // property FinalDisposition
  /*[id(0x0000000A)]*/ int get_FinalDisposition(out int plCalls);
  // property Name
  /*[id(0x0000000B)]*/ int get_Name(out wchar* ppName);
}

// TAPI 3.0 ITAgentEvent interface
interface ITAgentEvent : IDispatch {
  mixin(uuid("5afc314a-4bcc-11d1-bf80-00805fc147d3"));
  // property Agent
  /*[id(0x00000001)]*/ int get_Agent(out ITAgent ppAgent);
  // property Event
  /*[id(0x00000002)]*/ int get_Event(out AGENT_EVENT pEvent);
}

// TAPI 3.0 ITAgentSessionEvent interface
interface ITAgentSessionEvent : IDispatch {
  mixin(uuid("5afc314b-4bcc-11d1-bf80-00805fc147d3"));
  // property Session
  /*[id(0x00000001)]*/ int get_Session(out ITAgentSession ppSession);
  // property Event
  /*[id(0x00000002)]*/ int get_Event(out AGENT_SESSION_EVENT pEvent);
}

// TAPI 3.0 ITACDGroupEvent interface
interface ITACDGroupEvent : IDispatch {
  mixin(uuid("297f3032-bd11-11d1-a0a7-00805fc147d3"));
  // property Group
  /*[id(0x00000001)]*/ int get_Group(out ITACDGroup ppGroup);
  // property Event
  /*[id(0x00000002)]*/ int get_Event(out ACDGROUP_EVENT pEvent);
}

// TAPI 3.0 ITQueueEvent interface
interface ITQueueEvent : IDispatch {
  mixin(uuid("297f3033-bd11-11d1-a0a7-00805fc147d3"));
  // property Queue
  /*[id(0x00000001)]*/ int get_Queue(out ITQueue ppQueue);
  // property Event
  /*[id(0x00000002)]*/ int get_Event(out ACDQUEUE_EVENT pEvent);
}

// TAPI 3.0 ITTAPICallCenter interface
interface ITTAPICallCenter : IDispatch {
  mixin(uuid("5afc3154-4bcc-11d1-bf80-00805fc147d3"));
  // method EnumerateAgentHandlers
  /*[id(0x00020001)]*/ int EnumerateAgentHandlers(out IEnumAgentHandler ppEnumHandler);
  // property AgentHandlers
  /*[id(0x00020002)]*/ int get_AgentHandlers(out VARIANT pVariant);
}

// TAPI 3.0 IEnumAgentHandler interface
interface IEnumAgentHandler : IUnknown {
  mixin(uuid("587e8c28-9802-11d1-a0a4-00805fc147d3"));
  /*[id(0x60010000)]*/ int Next(uint celt, out ITAgentHandler ppElements, out uint pceltFetched);
  /*[id(0x60010001)]*/ int Reset();
  /*[id(0x60010002)]*/ int Skip(uint celt);
  /*[id(0x60010003)]*/ int Clone(out IEnumAgentHandler ppEnum);
}

// TAPI 3.0 ITAgentHandler interface
interface ITAgentHandler : IDispatch {
  mixin(uuid("587e8c22-9802-11d1-a0a4-00805fc147d3"));
  // property Name
  /*[id(0x00000001)]*/ int get_Name(out wchar* ppName);
  // property CreateAgent
  /*[id(0x00000002)]*/ int CreateAgent(out ITAgent ppAgent);
  // property CreateAgentWithID
  /*[id(0x00000003)]*/ int CreateAgentWithID(wchar* pID, wchar* pPIN, out ITAgent ppAgent);
  // method EnumerateACDGroups
  /*[id(0x00000004)]*/ int EnumerateACDGroups(out IEnumACDGroup ppEnumACDGroup);
  // method EnumerateUsableAddresses
  /*[id(0x00000005)]*/ int EnumerateUsableAddresses(out IEnumAddress ppEnumAddress);
  // property ACDGroups
  /*[id(0x00000006)]*/ int get_ACDGroups(out VARIANT pVariant);
  // property UsableAddresses
  /*[id(0x00000007)]*/ int get_UsableAddresses(out VARIANT pVariant);
}

// TAPI 3.0 IEnumACDGroup interface
interface IEnumACDGroup : IUnknown {
  mixin(uuid("5afc3157-4bcc-11d1-bf80-00805fc147d3"));
  /*[id(0x60010000)]*/ int Next(uint celt, out ITACDGroup ppElements, out uint pceltFetched);
  /*[id(0x60010001)]*/ int Reset();
  /*[id(0x60010002)]*/ int Skip(uint celt);
  /*[id(0x60010003)]*/ int Clone(out IEnumACDGroup ppEnum);
}

// TAPI 3.0 ITAgentHandlerEvent interface
interface ITAgentHandlerEvent : IDispatch {
  mixin(uuid("297f3034-bd11-11d1-a0a7-00805fc147d3"));
  // property AgentHandler
  /*[id(0x00000001)]*/ int get_AgentHandler(out ITAgentHandler ppAgentHandler);
  // property Event
  /*[id(0x00000002)]*/ int get_Event(out AGENTHANDLER_EVENT pEvent);
}

// TAPI 3.0 ITCallInfoChangeEvent Interface
interface ITCallInfoChangeEvent : IDispatch {
  mixin(uuid("5d4b65f9-e51c-11d1-a02f-00c04fb6809f"));
  // property Call
  /*[id(0x00000001)]*/ int get_Call(out ITCallInfo ppCall);
  // property Cause
  /*[id(0x00000002)]*/ int get_Cause(out CALLINFOCHANGE_CAUSE pCIC);
  // property Callback Instance
  /*[id(0x00000003)]*/ int get_CallbackInstance(out int plCallbackInstance);
}

// TAPI 3.0 ITRequestEvent Interface
interface ITRequestEvent : IDispatch {
  mixin(uuid("ac48ffde-f8c4-11d1-a030-00c04fb6809f"));
  // property RegistrationInstance
  /*[id(0x00000001)]*/ int get_RegistrationInstance(out int plRegistrationInstance);
  // property RequestMode
  /*[id(0x00000002)]*/ int get_RequestMode(out int plRequestMode);
  // property DestAddress
  /*[id(0x00000003)]*/ int get_DestAddress(out wchar* ppDestAddress);
  // property AppName
  /*[id(0x00000005)]*/ int get_AppName(out wchar* ppAppName);
  // property CalledParty
  /*[id(0x00000006)]*/ int get_CalledParty(out wchar* ppCalledParty);
  // property Comment
  /*[id(0x00000007)]*/ int get_Comment(out wchar* ppComment);
}

// TAPI 3.0 ITMediaSupport interface
interface ITMediaSupport : IDispatch {
  mixin(uuid("b1efc384-9355-11d0-835c-00aa003ccabd"));
  // property MediaTypes
  /*[id(0x00030001)]*/ int get_MediaTypes(out int plMediaTypes);
  // method QueryMediaType
  /*[id(0x00030002)]*/ int QueryMediaType(int lMediaType, out short pfSupport);
}

// TAPI 3.0 ITTerminalSupport interface
interface ITTerminalSupport : IDispatch {
  mixin(uuid("b1efc385-9355-11d0-835c-00aa003ccabd"));
  // property StaticTerminals
  /*[id(0x00060001)]*/ int get_StaticTerminals(out VARIANT pVariant);
  // method EnumerateStaticTerminals
  /*[id(0x00060002)]*/ int EnumerateStaticTerminals(out IEnumTerminal ppTerminalEnumerator);
  // property DynamicTerminalClasses
  /*[id(0x00060003)]*/ int get_DynamicTerminalClasses(out VARIANT pVariant);
  // method EnumerateDynamicTerminalClasses
  /*[id(0x00060004)]*/ int EnumerateDynamicTerminalClasses(out IEnumTerminalClass ppTerminalClassEnumerator);
  // method CreateTerminal
  /*[id(0x00060005)]*/ int CreateTerminal(wchar* pTerminalClass, int lMediaType, TERMINAL_DIRECTION Direction, out ITTerminal ppTerminal);
  // method GetDefaultStaticTerminal
  /*[id(0x00060006)]*/ int GetDefaultStaticTerminal(int lMediaType, TERMINAL_DIRECTION Direction, out ITTerminal ppTerminal);
}

// TAPI 3.0 IEnumTerminalClass interface
interface IEnumTerminalClass : IUnknown {
  mixin(uuid("ae269cf5-935e-11d0-835c-00aa003ccabd"));
  /*[id(0x60010000)]*/ int Next(uint celt, out GUID pElements, ref uint pceltFetched);
  /*[id(0x60010001)]*/ int Reset();
  /*[id(0x60010002)]*/ int Skip(uint celt);
  /*[id(0x60010003)]*/ int Clone(out IEnumTerminalClass ppEnum);
}

// TAPI 3.1 ITTerminalSupport2 interface
interface ITTerminalSupport2 : ITTerminalSupport {
  mixin(uuid("f3eb39bc-1b1f-4e99-a0c0-56305c4dd591"));
  // property PluggableSuperclasses
  /*[id(0x00060007)]*/ int get_PluggableSuperclasses(out VARIANT pVariant);
  // method EnumeratePluggableSuperclasses
  /*[id(0x00060008)]*/ int EnumeratePluggableSuperclasses(out IEnumPluggableSuperclassInfo ppSuperclassEnumerator);
  // property PluggableTerminalClasses
  /*[id(0x00060009)]*/ int get_PluggableTerminalClasses(wchar* bstrTerminalSuperclass, int lMediaType, out VARIANT pVariant);
  // method EnumeratePluggableTerminalClasses
  /*[id(0x0006000A)]*/ int EnumeratePluggableTerminalClasses(GUID iidTerminalSuperclass, int lMediaType, out IEnumPluggableTerminalClassInfo ppClassEnumerator);
}

// TAPI 3.1 IEnumPluggableSuperclassInfo interface
interface IEnumPluggableSuperclassInfo : IUnknown {
  mixin(uuid("e9586a80-89e6-4cff-931d-478d5751f4c0"));
  /*[id(0x60010000)]*/ int Next(uint celt, out ITPluggableTerminalSuperclassInfo ppElements, ref uint pceltFetched);
  /*[id(0x60010001)]*/ int Reset();
  /*[id(0x60010002)]*/ int Skip(uint celt);
  /*[id(0x60010003)]*/ int Clone(out IEnumPluggableSuperclassInfo ppEnum);
}

// TAPI 3.1 ITPluggableTerminalSuperclassInfo interface
interface ITPluggableTerminalSuperclassInfo : IDispatch {
  mixin(uuid("6d54e42c-4625-4359-a6f7-631999107e05"));
  // method get_Name
  /*[id(0x00000001)]*/ int get_Name(out wchar* pName);
  // method get_CLSID
  /*[id(0x00000002)]*/ int get_CLSID(out wchar* pCLSID);
}

// TAPI 3.1 IEnumPluggableTerminalClassInfo interface
interface IEnumPluggableTerminalClassInfo : IUnknown {
  mixin(uuid("4567450c-dbee-4e3f-aaf5-37bf9ebf5e29"));
  /*[id(0x60010000)]*/ int Next(uint celt, out ITPluggableTerminalClassInfo ppElements, ref uint pceltFetched);
  /*[id(0x60010001)]*/ int Reset();
  /*[id(0x60010002)]*/ int Skip(uint celt);
  /*[id(0x60010003)]*/ int Clone(out IEnumPluggableTerminalClassInfo ppEnum);
}

// TAPI 3.1 ITPluggableTerminalClassInfo interface
interface ITPluggableTerminalClassInfo : IDispatch {
  mixin(uuid("41757f4a-cf09-4b34-bc96-0a79d2390076"));
  // method get_Name
  /*[id(0x00000001)]*/ int get_Name(out wchar* pName);
  // method get_Company
  /*[id(0x00000002)]*/ int get_Company(out wchar* pCompany);
  // method get_Version
  /*[id(0x00000003)]*/ int get_Version(out wchar* pVersion);
  // method get_TerminalClass
  /*[id(0x00000004)]*/ int get_TerminalClass(out wchar* pTerminalClass);
  // method get_CLSID
  /*[id(0x00000005)]*/ int get_CLSID(out wchar* pCLSID);
  // method get_Direction
  /*[id(0x00000006)]*/ int get_Direction(out TERMINAL_DIRECTION pDirection);
  // method get_MediaTypes
  /*[id(0x00000007)]*/ int get_MediaTypes(out int pMediaTypes);
}

// ITStreamControl interface
interface ITStreamControl : IDispatch {
  mixin(uuid("ee3bd604-3868-11d2-a045-00c04fb6809f"));
  // method CreateStream
  /*[id(0x00040001)]*/ int CreateStream(int lMediaType, TERMINAL_DIRECTION td, out ITStream ppStream);
  // method RemoveStream
  /*[id(0x00040002)]*/ int RemoveStream(ITStream pStream);
  /*[id(0x00040003)]*/ int EnumerateStreams(out IEnumStream ppEnumStream);
  // property Streams
  /*[id(0x00040004)]*/ int get_Streams(out VARIANT pVariant);
}

// IEnumStream interface
interface IEnumStream : IUnknown {
  mixin(uuid("ee3bd606-3868-11d2-a045-00c04fb6809f"));
  /*[id(0x60010000)]*/ int Next(uint celt, out ITStream ppElements, ref uint pceltFetched);
  /*[id(0x60010001)]*/ int Reset();
  /*[id(0x60010002)]*/ int Skip(uint celt);
  /*[id(0x60010003)]*/ int Clone(out IEnumStream ppEnum);
}

// ITSubStreamControl interface
interface ITSubStreamControl : IDispatch {
  mixin(uuid("ee3bd607-3868-11d2-a045-00c04fb6809f"));
  // method CreateSubStream
  /*[id(0x00000001)]*/ int CreateSubStream(out ITSubStream ppSubStream);
  // method RemoveSubStream
  /*[id(0x00000002)]*/ int RemoveSubStream(ITSubStream pSubStream);
  /*[id(0x00000003)]*/ int EnumerateSubStreams(out IEnumSubStream ppEnumSubStream);
  // property SubStreams
  /*[id(0x00000004)]*/ int get_SubStreams(out VARIANT pVariant);
}

// ITSubStream interface
interface ITSubStream : IDispatch {
  mixin(uuid("ee3bd608-3868-11d2-a045-00c04fb6809f"));
  // method StartStream
  /*[id(0x00000001)]*/ int StartSubStream();
  // method PauseStream
  /*[id(0x00000002)]*/ int PauseSubStream();
  // method StopStream
  /*[id(0x00000003)]*/ int StopSubStream();
  // method SelectTerminal
  /*[id(0x00000004)]*/ int SelectTerminal(ITTerminal pTerminal);
  // method UnselectTerminal
  /*[id(0x00000005)]*/ int UnselectTerminal(ITTerminal pTerminal);
  /*[id(0x00000006)]*/ int EnumerateTerminals(out IEnumTerminal ppEnumTerminal);
  // property Terminals
  /*[id(0x00000007)]*/ int get_Terminals(out VARIANT pTerminals);
  // property Stream
  /*[id(0x00000008)]*/ int get_Stream(out ITStream ppITStream);
}

// IEnumSubStream interface
interface IEnumSubStream : IUnknown {
  mixin(uuid("ee3bd609-3868-11d2-a045-00c04fb6809f"));
  /*[id(0x60010000)]*/ int Next(uint celt, out ITSubStream ppElements, ref uint pceltFetched);
  /*[id(0x60010001)]*/ int Reset();
  /*[id(0x60010002)]*/ int Skip(uint celt);
  /*[id(0x60010003)]*/ int Clone(out IEnumSubStream ppEnum);
}

// TAPI 3.0 ITLegacyAddressMediaControl Interface
interface ITLegacyAddressMediaControl : IUnknown {
  mixin(uuid("ab493640-4c0b-11d2-a046-00c04fb6809f"));
  /*[id(0x00050001)]*/ int GetID(wchar* pDeviceClass, out uint pdwSize, out ubyte ppDeviceID);
  /*[id(0x00050002)]*/ int GetDevConfig(wchar* pDeviceClass, out uint pdwSize, out ubyte ppDeviceConfig);
  /*[id(0x00050003)]*/ int SetDevConfig(wchar* pDeviceClass, uint dwSize, ubyte* pDeviceConfig);
}

// TAPI 3.1 ITLegacyAddressMediaControl2 Interface
interface ITLegacyAddressMediaControl2 : ITLegacyAddressMediaControl {
  mixin(uuid("b0ee512b-a531-409e-9dd9-4099fe86c738"));
  /*[id(0x00050004)]*/ int ConfigDialog(wireHWND hwndOwner, wchar* pDeviceClass);
  /*[id(0x00050005)]*/ int ConfigDialogEdit(wireHWND hwndOwner, wchar* pDeviceClass, uint dwSizeIn, ubyte* pDeviceConfigIn, out uint pdwSizeOut, out ubyte ppDeviceConfigOut);
}

// TAPI 3.0 ITLegacyCallMediaControl Interface
interface ITLegacyCallMediaControl : IDispatch {
  mixin(uuid("d624582f-cc23-4436-b8a5-47c625c8045d"));
  // method DetectDigits
  /*[id(0x00030001)]*/ int DetectDigits(int DigitMode);
  // method GenerateDigits
  /*[id(0x00030002)]*/ int GenerateDigits(wchar* pDigits, int DigitMode);
  /*[id(0x00030003)]*/ int GetID(wchar* pDeviceClass, out uint pdwSize, out ubyte ppDeviceID);
  // method SetMediaType
  /*[id(0x00030004)]*/ int SetMediaType(int lMediaType);
  // method MonitorMedia
  /*[id(0x00030005)]*/ int MonitorMedia(int lMediaType);
}

// TAPI 3.1 ITLegacyCallMediaControl2 Interface
interface ITLegacyCallMediaControl2 : ITLegacyCallMediaControl {
  mixin(uuid("57ca332d-7bc2-44f1-a60c-936fe8d7ce73"));
  // method GenerateDigits2
  /*[id(0x00030006)]*/ int GenerateDigits2(wchar* pDigits, int DigitMode, int lDuration);
  // method GatherDigits
  /*[id(0x00030007)]*/ int GatherDigits(int DigitMode, int lNumDigits, wchar* pTerminationDigits, int lFirstDigitTimeout, int lInterDigitTimeout);
  // method DetectTones
  /*[id(0x00030008)]*/ int DetectTones(TAPI_DETECTTONE* pToneList, int lNumTones);
  // method DetectTonesByCollection
  /*[id(0x00030009)]*/ int DetectTonesByCollection(ITCollection2 pDetectToneCollection);
  // method GenerateTone
  /*[id(0x0003000A)]*/ int GenerateTone(TAPI_TONEMODE ToneMode, int lDuration);
  // method GenerateCustomTones
  /*[id(0x0003000B)]*/ int GenerateCustomTones(TAPI_CUSTOMTONE* pToneList, int lNumTones, int lDuration);
  // method GenerateCustomTonesByCollection
  /*[id(0x0003000C)]*/ int GenerateCustomTonesByCollection(ITCollection2 pCustomToneCollection, int lDuration);
  // method CreateDetectToneObject
  /*[id(0x0003000D)]*/ int CreateDetectToneObject(out ITDetectTone ppDetectTone);
  // method CreateCustomToneObject
  /*[id(0x0003000E)]*/ int CreateCustomToneObject(out ITCustomTone ppCustomTone);
  // method GetIDAsVariant
  /*[id(0x0003000F)]*/ int GetIDAsVariant(wchar* bstrDeviceClass, out VARIANT pVarDeviceID);
}

// TAPI 3.1 ITDetectTone Interface
interface ITDetectTone : IDispatch {
  mixin(uuid("961f79bd-3097-49df-a1d6-909b77e89ca0"));
  // property AppSpecific
  /*[id(0x00000001)]*/ int get_AppSpecific(out int plAppSpecific);
  // property AppSpecific
  /*[id(0x00000001)]*/ int put_AppSpecific(int plAppSpecific);
  // property Duration
  /*[id(0x00000002)]*/ int get_Duration(out int plDuration);
  // property Duration
  /*[id(0x00000002)]*/ int put_Duration(int plDuration);
  // property Frequency
  /*[id(0x00000003)]*/ int get_Frequency(int Index, out int plFrequency);
  // property Frequency
  /*[id(0x00000003)]*/ int put_Frequency(int Index, int plFrequency);
}

// TAPI 3.1 ITCustomTone Interface
interface ITCustomTone : IDispatch {
  mixin(uuid("357ad764-b3c6-4b2a-8fa5-0722827a9254"));
  // property Frequency
  /*[id(0x00000001)]*/ int get_Frequency(out int plFrequency);
  // property Frequency
  /*[id(0x00000001)]*/ int put_Frequency(int plFrequency);
  // property CadenceOn
  /*[id(0x00000002)]*/ int get_CadenceOn(out int plCadenceOn);
  // property CadenceOn
  /*[id(0x00000002)]*/ int put_CadenceOn(int plCadenceOn);
  // property CadenceOff
  /*[id(0x00000003)]*/ int get_CadenceOff(out int plCadenceOff);
  // property CadenceOff
  /*[id(0x00000003)]*/ int put_CadenceOff(int plCadenceOff);
  // property Volume
  /*[id(0x00000004)]*/ int get_Volume(out int plVolume);
  // property Volume
  /*[id(0x00000004)]*/ int put_Volume(int plVolume);
}

// TAPI 3.0 ITDigitDetectionEvent interface
interface ITDigitDetectionEvent : IDispatch {
  mixin(uuid("80d3bfac-57d9-11d2-a04a-00c04fb6809f"));
  // property Call
  /*[id(0x00000001)]*/ int get_Call(out ITCallInfo ppCallInfo);
  // property Digit
  /*[id(0x00000002)]*/ int get_Digit(out ubyte pucDigit);
  // property DigitMode
  /*[id(0x00000003)]*/ int get_DigitMode(out int pDigitMode);
  // property TickCount
  /*[id(0x00000004)]*/ int get_TickCount(out int plTickCount);
  // property CallbackInstance
  /*[id(0x00000005)]*/ int get_CallbackInstance(out int plCallbackInstance);
}

// TAPI 3.0 ITDigitGenerationEvent interface
interface ITDigitGenerationEvent : IDispatch {
  mixin(uuid("80d3bfad-57d9-11d2-a04a-00c04fb6809f"));
  // property Call
  /*[id(0x00000001)]*/ int get_Call(out ITCallInfo ppCallInfo);
  // property GenerationTermination
  /*[id(0x00000002)]*/ int get_GenerationTermination(out int plGenerationTermination);
  // property TickCount
  /*[id(0x00000003)]*/ int get_TickCount(out int plTickCount);
  // property CallbackInstance
  /*[id(0x00000004)]*/ int get_CallbackInstance(out int plCallbackInstance);
}

// TAPI 3.1 ITDigitsGatheredEvent Interface
interface ITDigitsGatheredEvent : IDispatch {
  mixin(uuid("e52ec4c1-cba3-441a-9e6a-93cb909e9724"));
  // property Call
  /*[id(0x00000001)]*/ int get_Call(out ITCallInfo ppCallInfo);
  // property Digits
  /*[id(0x00000002)]*/ int get_Digits(out wchar* ppDigits);
  // property GatherTermination
  /*[id(0x00000003)]*/ int get_GatherTermination(out TAPI_GATHERTERM pGatherTermination);
  // property TickCount
  /*[id(0x00000004)]*/ int get_TickCount(out int plTickCount);
  // property CallbackInstance
  /*[id(0x00000005)]*/ int get_CallbackInstance(out int plCallbackInstance);
}

// TAPI 3.1 ITToneDetectionEvent Interface
interface ITToneDetectionEvent : IDispatch {
  mixin(uuid("407e0faf-d047-4753-b0c6-8e060373fecd"));
  // property Call
  /*[id(0x00000001)]*/ int get_Call(out ITCallInfo ppCallInfo);
  // property AppSpecific
  /*[id(0x00000002)]*/ int get_AppSpecific(out int plAppSpecific);
  // property TickCount
  /*[id(0x00000003)]*/ int get_TickCount(out int plTickCount);
  // property CallbackInstance
  /*[id(0x00000004)]*/ int get_CallbackInstance(out int plCallbackInstance);
}

// TAPI 3.0 ITPrivateEvent Interface
interface ITPrivateEvent : IDispatch {
  mixin(uuid("0e269cd0-10d4-4121-9c22-9c85d625650d"));
  // property Address
  /*[id(0x00000001)]*/ int get_Address(out ITAddress ppAddress);
  // property Call
  /*[id(0x00000002)]*/ int get_Call(out ITCallInfo ppCallInfo);
  // property CallHub
  /*[id(0x00000003)]*/ int get_CallHub(out ITCallHub ppCallHub);
  // property EventCode
  /*[id(0x00000004)]*/ int get_EventCode(out int plEventCode);
  // property EventInterface
  /*[id(0x00000005)]*/ int get_EventInterface(out IDispatch pEventInterface);
}

// TAPI 3.1 ITAddress2 interface
interface ITAddress2 : ITAddress {
  mixin(uuid("b0ae5d9b-be51-46c9-b0f7-dfa8a22a8bc4"));
  // property Phones
  /*[id(0x00010010)]*/ int get_Phones(out VARIANT pPhones);
  // method EnumeratePhones
  /*[id(0x00010011)]*/ int EnumeratePhones(out IEnumPhone ppEnumPhone);
  // method GetPhoneFromTerminal
  /*[id(0x00010012)]*/ int GetPhoneFromTerminal(ITTerminal pTerminal, out ITPhone ppPhone);
  // property PreferredPhones
  /*[id(0x00010014)]*/ int get_PreferredPhones(out VARIANT pPhones);
  // method EnumeratePreferredPhones
  /*[id(0x00010015)]*/ int EnumeratePreferredPhones(out IEnumPhone ppEnumPhone);
  // method EventFilter
  /*[id(0x00010013)]*/ int get_EventFilter(TAPI_EVENT TapiEvent, int lSubEvent, out short pEnable);
  // method EventFilter
  /*[id(0x00010013)]*/ int put_EventFilter(TAPI_EVENT TapiEvent, int lSubEvent, short pEnable);
  // method DeviceSpecific
  /*[id(0x00010016)]*/ int DeviceSpecific(ITCallInfo pCall, ubyte* pParams, uint dwSize);
  // method DeviceSpecificVariant
  /*[id(0x00010017)]*/ int DeviceSpecificVariant(ITCallInfo pCall, VARIANT varDevSpecificByteArray);
  // method NegotiateExtVersion
  /*[id(0x00010018)]*/ int NegotiateExtVersion(int lLowVersion, int lHighVersion, out int plExtVersion);
}

// TAPI 3.1 IEnumPhone Interface
interface IEnumPhone : IUnknown {
  mixin(uuid("f15b7669-4780-4595-8c89-fb369c8cf7aa"));
  /*[id(0x60010000)]*/ int Next(uint celt, out ITPhone ppElements, ref uint pceltFetched);
  /*[id(0x60010001)]*/ int Reset();
  /*[id(0x60010002)]*/ int Skip(uint celt);
  /*[id(0x60010003)]*/ int Clone(out IEnumPhone ppEnum);
}

// TAPI 3.1 ITTAPI2 interface
interface ITTAPI2 : ITTAPI {
  mixin(uuid("54fbdc8c-d90f-4dad-9695-b373097f094b"));
  // property Phones
  /*[id(0x00010010)]*/ int get_Phones(out VARIANT pPhones);
  // method EnumeratePhones
  /*[id(0x00010011)]*/ int EnumeratePhones(out IEnumPhone ppEnumPhone);
  // method CreateEmptyCollectionObject
  /*[id(0x00010012)]*/ int CreateEmptyCollectionObject(out ITCollection2 ppCollection);
}

// ITMultiTrackTerminal Interface
interface ITMultiTrackTerminal : IDispatch {
  mixin(uuid("fe040091-ade8-4072-95c9-bf7de8c54b44"));
  // property TrackTerminals
  /*[id(0x00010001)]*/ int get_TrackTerminals(out VARIANT pVariant);
  // method EnumerateTrackTerminals
  /*[id(0x00010002)]*/ int EnumerateTrackTerminals(out IEnumTerminal ppEnumTerminal);
  // method CreateTrackTerminal
  /*[id(0x00010003)]*/ int CreateTrackTerminal(int MediaType, TERMINAL_DIRECTION TerminalDirection, out ITTerminal ppTerminal);
  // property MediaTypesInUse
  /*[id(0x00010004)]*/ int get_MediaTypesInUse(out int plMediaTypesInUse);
  // property DirectionsInUse
  /*[id(0x00010005)]*/ int get_DirectionsInUse(out TERMINAL_DIRECTION plDirectionsInUsed);
  // method RemoveTrackTerminal
  /*[id(0x00010006)]*/ int RemoveTrackTerminal(ITTerminal pTrackTerminalToRemove);
}

// TAPI 3.1 ITStaticAudioTerminal Interface
interface ITStaticAudioTerminal : IDispatch {
  mixin(uuid("a86b7871-d14c-48e6-922e-a8d15f984800"));
  // property WaveId
  /*[id(0x00000001)]*/ int get_WaveId(out int plWaveId);
}

// TAPI 3.0 ITBasicCallControl2 interface
interface ITBasicCallControl2 : ITBasicCallControl {
  mixin(uuid("161a4a56-1e99-4b3f-a46a-168f38a5ee4c"));
  // method RequestTerminal
  /*[id(0x00020017)]*/ int RequestTerminal(wchar* bstrTerminalClassGUID, int lMediaType, TERMINAL_DIRECTION Direction, out ITTerminal ppTerminal);
  // method SelectTerminalOnCall
  /*[id(0x00020018)]*/ int SelectTerminalOnCall(ITTerminal pTerminal);
  // method UnselectTerminalOnCall
  /*[id(0x00020019)]*/ int UnselectTerminalOnCall(ITTerminal pTerminal);
}

// TAPI 3.1 ITAutomatedPhoneControl interface
interface ITAutomatedPhoneControl : IDispatch {
  mixin(uuid("1ee1af0e-6159-4a61-b79b-6a4ba3fc9dfc"));
  // method StartTone
  /*[id(0x00020001)]*/ int StartTone(PHONE_TONE Tone, int lDuration);
  // method StopTone
  /*[id(0x00020002)]*/ int StopTone();
  // property Tone
  /*[id(0x00020003)]*/ int get_Tone(out PHONE_TONE pTone);
  // method StartRinger
  /*[id(0x00020004)]*/ int StartRinger(int lRingMode, int lDuration);
  // method StopRinger
  /*[id(0x00020005)]*/ int StopRinger();
  // property Ringer
  /*[id(0x00020006)]*/ int get_Ringer(out short pfRinging);
  // property PhoneHandlingEnabled
  /*[id(0x00020007)]*/ int put_PhoneHandlingEnabled(short pfEnabled);
  // property PhoneHandlingEnabled
  /*[id(0x00020007)]*/ int get_PhoneHandlingEnabled(out short pfEnabled);
  // property AutoEndOfNumberTimeout
  /*[id(0x00020008)]*/ int put_AutoEndOfNumberTimeout(int plTimeout);
  // property AutoEndOfNumberTimeout
  /*[id(0x00020008)]*/ int get_AutoEndOfNumberTimeout(out int plTimeout);
  // property AutoDialtone
  /*[id(0x00020009)]*/ int put_AutoDialtone(short pfEnabled);
  // property AutoDialtone
  /*[id(0x00020009)]*/ int get_AutoDialtone(out short pfEnabled);
  // property AutoStopTonesOnOnHook
  /*[id(0x0002000A)]*/ int put_AutoStopTonesOnOnHook(short pfEnabled);
  // property AutoStopTonesOnOnHook
  /*[id(0x0002000A)]*/ int get_AutoStopTonesOnOnHook(out short pfEnabled);
  // property AutoStopRingOnOffHook
  /*[id(0x0002000B)]*/ int put_AutoStopRingOnOffHook(short pfEnabled);
  // property AutoStopRingOnOffHook
  /*[id(0x0002000B)]*/ int get_AutoStopRingOnOffHook(out short pfEnabled);
  // property AutoKeypadTones
  /*[id(0x0002000C)]*/ int put_AutoKeypadTones(short pfEnabled);
  // property AutoKeypadTones
  /*[id(0x0002000C)]*/ int get_AutoKeypadTones(out short pfEnabled);
  // property AutoKeypadTonesMinimumDuration
  /*[id(0x0002000D)]*/ int put_AutoKeypadTonesMinimumDuration(int plDuration);
  // property AutoKeypadTonesMinimumDuration
  /*[id(0x0002000D)]*/ int get_AutoKeypadTonesMinimumDuration(out int plDuration);
  // property AutoVolumeControl
  /*[id(0x0002000E)]*/ int put_AutoVolumeControl(short fEnabled);
  // property AutoVolumeControl
  /*[id(0x0002000E)]*/ int get_AutoVolumeControl(out short fEnabled);
  // property AutoVolumeControlStep
  /*[id(0x0002000F)]*/ int put_AutoVolumeControlStep(int plStepSize);
  // property AutoVolumeControlStep
  /*[id(0x0002000F)]*/ int get_AutoVolumeControlStep(out int plStepSize);
  // property AutoVolumeControlRepeatDelay
  /*[id(0x00020010)]*/ int put_AutoVolumeControlRepeatDelay(int plDelay);
  // property AutoVolumeControlRepeatDelay
  /*[id(0x00020010)]*/ int get_AutoVolumeControlRepeatDelay(out int plDelay);
  // property AutoVolumeControlRepeatPeriod
  /*[id(0x00020011)]*/ int put_AutoVolumeControlRepeatPeriod(int plPeriod);
  // property AutoVolumeControlRepeatPeriod
  /*[id(0x00020011)]*/ int get_AutoVolumeControlRepeatPeriod(out int plPeriod);
  // method SelectCall
  /*[id(0x00020012)]*/ int SelectCall(ITCallInfo pCall, short fSelectDefaultTerminals);
  // method UnselectCall
  /*[id(0x00020013)]*/ int UnselectCall(ITCallInfo pCall);
  // method EnumerateSelectedCalls
  /*[id(0x00020014)]*/ int EnumerateSelectedCalls(out IEnumCall ppCallEnum);
  // property SelectedCalls
  /*[id(0x00020015)]*/ int get_SelectedCalls(out VARIANT pVariant);
}

// ITMediaControl Interface
interface ITMediaControl : IDispatch {
  mixin(uuid("c445dde8-5199-4bc7-9807-5ffb92e42e09"));
  // method Start
  /*[id(0x00020001)]*/ int Start();
  // method Stop
  /*[id(0x00020002)]*/ int Stop();
  // method Pause
  /*[id(0x00020003)]*/ int Pause();
  // property MediaState
  /*[id(0x00020004)]*/ int get_MediaState(out TERMINAL_MEDIA_STATE pTerminalMediaState);
}

// ITFileTrack Interface
interface ITFileTrack : IDispatch {
  mixin(uuid("31ca6ea9-c08a-4bea-8811-8e9c1ba3ea3a"));
  // property Format
  /*[id(0x00010001)]*/ int get_Format(out _AMMediaType ppmt);
  // property Format
  /*[id(0x00010001)]*/ int put_Format(_AMMediaType* ppmt);
  // property ControllingTerminal
  /*[id(0x00010002)]*/ int get_ControllingTerminal(out ITTerminal ppControllingTerminal);
  // property AudioFormatForScripting
  /*[id(0x00010003)]*/ int get_AudioFormatForScripting(out ITScriptableAudioFormat ppAudioFormat);
  // property AudioFormatForScripting
  /*[id(0x00010003)]*/ int put_AudioFormatForScripting(ITScriptableAudioFormat ppAudioFormat);
  // property EmptyAudioFormatForScripting
  /*[id(0x00010005)]*/ int get_EmptyAudioFormatForScripting(out ITScriptableAudioFormat ppAudioFormat);
}

// TAPI 3.0 ITScriptableAudioFormat Interface
interface ITScriptableAudioFormat : IDispatch {
  mixin(uuid("b87658bd-3c59-4f64-be74-aede3e86a81e"));
  // property Channels
  /*[id(0x00000001)]*/ int get_Channels(out int pVal);
  // property Channels
  /*[id(0x00000001)]*/ int put_Channels(int pVal);
  // property SamplesPerSec
  /*[id(0x00000002)]*/ int get_SamplesPerSec(out int pVal);
  // property SamplesPerSec
  /*[id(0x00000002)]*/ int put_SamplesPerSec(int pVal);
  // property AvgBytesPerSec
  /*[id(0x00000003)]*/ int get_AvgBytesPerSec(out int pVal);
  // property AvgBytesPerSec
  /*[id(0x00000003)]*/ int put_AvgBytesPerSec(int pVal);
  // property BlockAlign
  /*[id(0x00000004)]*/ int get_BlockAlign(out int pVal);
  // property BlockAlign
  /*[id(0x00000004)]*/ int put_BlockAlign(int pVal);
  // property BitsPerSample
  /*[id(0x00000005)]*/ int get_BitsPerSample(out int pVal);
  // property BitsPerSample
  /*[id(0x00000005)]*/ int put_BitsPerSample(int pVal);
  // property FormatTag
  /*[id(0x00000006)]*/ int get_FormatTag(out int pVal);
  // property FormatTag
  /*[id(0x00000006)]*/ int put_FormatTag(int pVal);
}

// TAPI 3.1 ITCallInfo2 interface
interface ITCallInfo2 : ITCallInfo {
  mixin(uuid("94d70ca6-7ab0-4daa-81ca-b8f8643faec1"));
  // method EventFilter
  /*[id(0x0001000B)]*/ int get_EventFilter(TAPI_EVENT TapiEvent, int lSubEvent, out short pEnable);
  // method EventFilter
  /*[id(0x0001000B)]*/ int put_EventFilter(TAPI_EVENT TapiEvent, int lSubEvent, short pEnable);
}

// TAPI 3.0 ITFileTerminalEvent interface
interface ITFileTerminalEvent : IDispatch {
  mixin(uuid("e4a7fbac-8c17-4427-9f55-9f589ac8af00"));
  // property Terminal
  /*[id(0x00000001)]*/ int get_Terminal(out ITTerminal ppTerminal);
  // property Track
  /*[id(0x00000002)]*/ int get_Track(out ITFileTrack ppTrackTerminal);
  // property Call
  /*[id(0x00000003)]*/ int get_Call(out ITCallInfo ppCall);
  // property State
  /*[id(0x00000004)]*/ int get_State(out TERMINAL_MEDIA_STATE pState);
  // property Cause
  /*[id(0x00000005)]*/ int get_Cause(out FT_STATE_EVENT_CAUSE pCause);
  // property Error
  /*[id(0x00000006)]*/ int get_Error(out int phrErrorCode);
}

// TAPI 3.0 ITToneTerminalEvent interface
interface ITToneTerminalEvent : IDispatch {
  mixin(uuid("e6f56009-611f-4945-bbd2-2d0ce5612056"));
  // property Terminal
  /*[id(0x00000001)]*/ int get_Terminal(out ITTerminal ppTerminal);
  // property Call
  /*[id(0x00000002)]*/ int get_Call(out ITCallInfo ppCall);
  // property Error
  /*[id(0x00000003)]*/ int get_Error(out int phrErrorCode);
}

// TAPI 3.0 ITASRTerminalEvent interface
interface ITASRTerminalEvent : IDispatch {
  mixin(uuid("ee016a02-4fa9-467c-933f-5a15b12377d7"));
  // property Terminal
  /*[id(0x00000001)]*/ int get_Terminal(out ITTerminal ppTerminal);
  // property Call
  /*[id(0x00000002)]*/ int get_Call(out ITCallInfo ppCall);
  // property Error
  /*[id(0x00000003)]*/ int get_Error(out int phrErrorCode);
}

// TAPI 3.0 ITTTSTerminalEvent interface
interface ITTTSTerminalEvent : IDispatch {
  mixin(uuid("d964788f-95a5-461d-ab0c-b9900a6c2713"));
  // property Terminal
  /*[id(0x00000001)]*/ int get_Terminal(out ITTerminal ppTerminal);
  // property Call
  /*[id(0x00000002)]*/ int get_Call(out ITCallInfo ppCall);
  // property Error
  /*[id(0x00000003)]*/ int get_Error(out int phrErrorCode);
}

// TAPI 3.1 ITPhoneEvent Interface
interface ITPhoneEvent : IDispatch {
  mixin(uuid("8f942dd8-64ed-4aaf-a77d-b23db0837ead"));
  // property Phone
  /*[id(0x00000001)]*/ int get_Phone(out ITPhone ppPhone);
  // property Event
  /*[id(0x00000002)]*/ int get_Event(out PHONE_EVENT pEvent);
  // property ButtonState
  /*[id(0x00000003)]*/ int get_ButtonState(out PHONE_BUTTON_STATE pState);
  // property HookSwitchState
  /*[id(0x00000004)]*/ int get_HookSwitchState(out PHONE_HOOK_SWITCH_STATE pState);
  // property HookSwitchDevice
  /*[id(0x00000005)]*/ int get_HookSwitchDevice(out PHONE_HOOK_SWITCH_DEVICE pDevice);
  // property RingMode
  /*[id(0x00000006)]*/ int get_RingMode(out int plRingMode);
  // property ButtonLampId
  /*[id(0x00000007)]*/ int get_ButtonLampId(out int plButtonLampId);
  // property NumberGathered
  /*[id(0x00000008)]*/ int get_NumberGathered(out wchar* ppNumber);
  // property Call
  /*[id(0x00000009)]*/ int get_Call(out ITCallInfo ppCallInfo);
}

// TAPI 3.1 ITPhoneDeviceSpecificEvent interface
interface ITPhoneDeviceSpecificEvent : IDispatch {
  mixin(uuid("63ffb2a6-872b-4cd3-a501-326e8fb40af7"));
  // property Phone
  /*[id(0x00000001)]*/ int get_Phone(out ITPhone ppPhone);
  // property lParam1
  /*[id(0x00000002)]*/ int get_lParam1(out int pParam1);
  // property lParam2
  /*[id(0x00000003)]*/ int get_lParam2(out int pParam2);
  // property lParam3
  /*[id(0x00000004)]*/ int get_lParam3(out int pParam3);
}

// ITLegacyWaveSupport
interface ITLegacyWaveSupport : IDispatch {
  mixin(uuid("207823ea-e252-11d2-b77e-0080c7135381"));
  /*[id(0x60020000)]*/ int IsFullDuplex(out FULLDUPLEX_SUPPORT pSupport);
}

// TAPI 3.0 ITTAPIDispatchEventNotification Interface
interface ITTAPIDispatchEventNotification : IDispatch {
  mixin(uuid("9f34325b-7e62-11d2-9457-00c04f8ec888"));
  /+// method Event
  /*[id(0x00000001)]*/ int Event(TAPI_EVENT TapiEvent, IDispatch pEvent);+/
}

// TAPI 3.0 ITDispatchMapper interface
interface ITDispatchMapper : IDispatch {
  mixin(uuid("e9225295-c759-11d1-a02b-00c04fb6809f"));
  // QueryDispatchInterface
  /*[id(0x00000001)]*/ int QueryDispatchInterface(wchar* pIID, IDispatch pInterfaceToMap, out IDispatch ppReturnedInterface);
}

// TAPI 3.0 ITRequest Interface
interface ITRequest : IDispatch {
  mixin(uuid("ac48ffdf-f8c4-11d1-a030-00c04fb6809f"));
  // method MakeCall
  /*[id(0x00000001)]*/ int MakeCall(wchar* pDestAddress, wchar* pAppName, wchar* pCalledParty, wchar* pComment);
}

// CoClasses

// TAPI 3.0 TAPI Object
abstract final class TAPI {
  mixin(uuid("21d6d48e-a88b-11d0-83dd-00aa003ccabd"));
  mixin Interfaces!(ITTAPI, ITTAPICallCenter);
}

// TAPI 3.0 DispatchMapper Object
abstract final class DispatchMapper {
  mixin(uuid("e9225296-c759-11d1-a02b-00c04fb6809f"));
  mixin Interfaces!(ITDispatchMapper);
}

// TAPI 3.0 RequestMakeCall Object
abstract final class RequestMakeCall {
  mixin(uuid("ac48ffe0-f8c4-11d1-a030-00c04fb6809f"));
  mixin Interfaces!(ITRequest);
}

// Global variables
const wchar* CLSID_String_VideoWindowTerm = "{F7438990-D6EB-11D0-82A6-00AA00B5CA1B}";
const wchar* CLSID_String_VideoInputTerminal = "{AAF578EC-DC70-11D0-8ED3-00C04FB6809F}";
const wchar* CLSID_String_HandsetTerminal = "{AAF578EB-DC70-11D0-8ED3-00C04FB6809F}";
const wchar* CLSID_String_HeadsetTerminal = "{AAF578ED-DC70-11D0-8ED3-00C04FB6809F}";
const wchar* CLSID_String_SpeakerphoneTerminal = "{AAF578EE-DC70-11D0-8ED3-00C04FB6809F}";
const wchar* CLSID_String_MicrophoneTerminal = "{AAF578EF-DC70-11D0-8ED3-00C04FB6809F}";
const wchar* CLSID_String_SpeakersTerminal = "{AAF578F0-DC70-11D0-8ED3-00C04FB6809F}";
const wchar* CLSID_String_MediaStreamTerminal = "{E2F7AEF7-4971-11D1-A671-006097C9A2E8}";
const wchar* CLSID_String_FileRecordingTerminal = "{521F3D06-C3D0-4511-8617-86B9A783DA77}";
const wchar* CLSID_String_FilePlaybackTerminal = "{0CB9914C-79CD-47DC-ADB0-327F47CEFB20}";
const wchar* TAPIPROTOCOL_String_PSTN = "{831CE2D6-83B5-11D1-BB5C-00C04FB6809F}";
const wchar* TAPIPROTOCOL_String_H323 = "{831CE2D7-83B5-11D1-BB5C-00C04FB6809F}";
const wchar* TAPIPROTOCOL_String_Multicast = "{831CE2D8-83B5-11D1-BB5C-00C04FB6809F}";
const int LINEADDRESSTYPE_PHONENUMBER = 0x00000001;
const int LINEADDRESSTYPE_SDP = 0x00000002;
const int LINEADDRESSTYPE_EMAILNAME = 0x00000004;
const int LINEADDRESSTYPE_DOMAINNAME = 0x00000008;
const int LINEADDRESSTYPE_IPADDRESS = 0x00000010;
const int LINEDIGITMODE_PULSE = 0x00000001;
const int LINEDIGITMODE_DTMF = 0x00000002;
const int LINEDIGITMODE_DTMFEND = 0x00000004;
const int TAPIMEDIATYPE_AUDIO = 0x00000008;
const int TAPIMEDIATYPE_VIDEO = 0x00008000;
const int TAPIMEDIATYPE_DATAMODEM = 0x00000010;
const int TAPIMEDIATYPE_G3FAX = 0x00000020;
const int TAPIMEDIATYPE_MULTITRACK = 0x00010000;
