module os.win.tlb.inetctlsobjects;

private import os.win.com.core;

enum StateConstants {
  icNone = 0x00000000,
  icResolvingHost = 0x00000001,
  icHostResolved = 0x00000002,
  icConnecting = 0x00000003,
  icConnected = 0x00000004,
  icRequesting = 0x00000005,
  icRequestSent = 0x00000006,
  icReceivingResponse = 0x00000007,
  icResponseReceived = 0x00000008,
  icDisconnecting = 0x00000009,
  icDisconnected = 0x0000000A,
  icError = 0x0000000B,
  icResponseCompleted = 0x0000000C,
}

enum AccessConstants {
  icUseDefault = 0x00000000,
  icDirect = 0x00000001,
  icNamedProxy = 0x00000002,
}

enum ProtocolConstants {
  icUnknown = 0x00000000,
  icDefault = 0x00000001,
  icFTP = 0x00000002,
  icGopher = 0x00000003,
  icHTTP = 0x00000004,
  icHTTPS = 0x00000005,
}

enum DataTypeConstants {
  icString = 0x00000000,
  icByteArray = 0x00000001,
}

enum ErrorConstants {
  icOutOfMemory = 0x00000007,
  icTypeMismatch = 0x0000000D,
  icInvalidPropertyValue = 0x0000017C,
  icInetOpenFailed = 0x00008BA6,
  icUrlOpenFailed = 0x00008BA7,
  icBadUrl = 0x00008BA8,
  icProtMismatch = 0x00008BA9,
  icConnectFailed = 0x00008BAA,
  icNoRemoteHost = 0x00008BAB,
  icRequestFailed = 0x00008BAC,
  icNoExecute = 0x00008BAD,
  icBlewChunk = 0x00008BAE,
  icFtpCommandFailed = 0x00008BAF,
  icUnsupportedType = 0x00008BB0,
  icTimeout = 0x00008BB1,
  icUnsupportedCommand = 0x00008BB2,
  icInvalidOperation = 0x00008BB3,
  icExecuting = 0x00008BB4,
  icInvalidForFtp = 0x00008BB5,
  icOutOfHandles = 0x00008BB7,
  icInetTimeout = 0x00008BB8,
  icExtendedError = 0x00008BB9,
  icIntervalError = 0x00008BBA,
  icInvalidURL = 0x00008BBB,
  icUnrecognizedScheme = 0x00008BBC,
  icNameNotResolved = 0x00008BBD,
  icProtocolNotFound = 0x00008BBE,
  icInvalidOption = 0x00008BBF,
  icBadOptionLength = 0x00008BC0,
  icOptionNotSettable = 0x00008BC1,
  icShutDown = 0x00008BC2,
  icIncorrectUserName = 0x00008BC3,
  icIncorrectPassword = 0x00008BC4,
  icLoginFailure = 0x00008BC5,
  icInetInvalidOperation = 0x00008BC6,
  icOperationCancelled = 0x00008BC7,
  icIncorrectHandleType = 0x00008BC8,
  icIncorrectHandleState = 0x00008BC9,
  icNotProxyRequest = 0x00008BCA,
  icRegistryValueNotFound = 0x00008BCB,
  icBadRegistryParameter = 0x00008BCC,
  icNoDirectAccess = 0x00008BCD,
  icNoContext = 0x00008BCE,
  icNoCallback = 0x00008BCF,
  icRequestPending = 0x00008BD0,
  icIncorrectFormat = 0x00008BD1,
  icItemNotFound = 0x00008BD2,
  icCannotConnect = 0x00008BD3,
  icConnectionAborted = 0x00008BD4,
  icConnectionReset = 0x00008BD5,
  icForceRetry = 0x00008BD6,
  icInvalidProxyRequest = 0x00008BD7,
  icWouldBlock = 0x00008BD8,
  icHandleExists = 0x00008BDA,
  icSecCertDateInvalid = 0x00008BDB,
  icSecCertCnInvalid = 0x00008BDC,
  icHttpToHttpsOnRedir = 0x00008BDD,
  icHttpsToHttpOnRedir = 0x00008BDE,
  icMixedSecurity = 0x00008BDF,
  icChgPostIsNonSecure = 0x00008BE0,
  icPostIsNonSecure = 0x00008BE1,
  icClientAuthCertNeeded = 0x00008BE2,
  icInvalidCa = 0x00008BE3,
  icClientAuthNotSetup = 0x00008BE4,
  icAsyncThreadFailed = 0x00008BE5,
  icRedirectSchemeChange = 0x00008BE6,
  icDialogPending = 0x00008BE7,
  icRetryDialog = 0x00008BE8,
  icHttpsHttpSubmitRedir = 0x00008BEA,
  icInsertCdrom = 0x00008BEB,
  icFtpTransferInProgress = 0x00008C24,
  icFtpDropped = 0x00008C25,
  icFtpNoPassiveMode = 0x00008C26,
  icGopherProtocolError = 0x00008C38,
  icGopherNotFile = 0x00008C39,
  icGopherDataError = 0x00008C3A,
  icGopherEndOfData = 0x00008C3B,
  icGopherInvalidLocator = 0x00008C3C,
  icGopherIncorrectLocatorType = 0x00008C3D,
  icGopherNotGopherPlus = 0x00008C3E,
  icGopherAttributeNotFound = 0x00008C3F,
  icGopherUnknownLocator = 0x00008C40,
  icHttpHeaderNotFound = 0x00008C4C,
  icHttpDownlevelServer = 0x00008C4D,
  icHttpInvalidServerResponse = 0x00008C4E,
  icHttpInvalidHeader = 0x00008C4F,
  icHttpInvalidQueryRequest = 0x00008C50,
  icHttpHeaderAlreadyExists = 0x00008C51,
  icHttpRedirectFailed = 0x00008C52,
  icHttpCookieNeedsConfirmation = 0x00008C57,
  icHttpCookieDeclined = 0x00008C58,
  icHttpRedirectNeedsConfirmation = 0x00008C5E,
  icSecurityChannelError = 0x00008C53,
  icUnableToCacheFile = 0x00008C54,
  icInternetDisconnected = 0x00008C59,
  icServerUnreachable = 0x00008C5A,
  icProxyServerUnreachable = 0x00008C5B,
  icBadAutoProxyScript = 0x00008C5C,
  icUnableToDownloadScript = 0x00008C5D,
  icSecInvalidCert = 0x00008C5F,
  icSecCertRevoked = 0x00008C60,
  icFailedDueToSecurityCheck = 0x00008C61,
}

interface IInet : IDispatch {
  mixin(uuid("48e59291-9880-11cf-9754-00aa00c00908"));
  int get_Protocol(out ProtocolConstants Protocol);
  int put_Protocol(ProtocolConstants Protocol);
  int get_RemoteHost(out wchar* RemoteHost);
  int put_RemoteHost(wchar* RemoteHost);
  int get_RemotePort(out short RemotePort);
  int put_RemotePort(short RemotePort);
  int get_ResponseInfo(out wchar* Response);
  int get_ResponseCode(out int Code);
  int get_hInternet(out int Handle);
  int get_StillExecuting(out short IsBusy);
  int get_URL(out wchar* URL);
  int put_URL(wchar* URL);
  int get_Proxy(out wchar* Name);
  int put_Proxy(wchar* Name);
  int get_Document(out wchar* Document);
  int put_Document(wchar* Document);
  int get_AccessType(out AccessConstants Type);
  int put_AccessType(AccessConstants Type);
  int get_UserName(out wchar* UserName);
  int put_UserName(wchar* UserName);
  int get_Password(out wchar* Password);
  int put_Password(wchar* Password);
  int get_RequestTimeout(out int Timeout);
  int put_RequestTimeout(int Timeout);
  int OpenURL(VARIANT URL, VARIANT DataType, out VARIANT pRetval);
  int Execute(VARIANT URL, VARIANT Operation, VARIANT InputData, VARIANT InputHdrs);
  int Cancel();
  int GetChunk(ref int Size, VARIANT DataType, out VARIANT pRetval);
  int GetHeader(VARIANT HdrName, out wchar* pRetval);
  void AboutBox();
  int get__URL(out wchar* URL);
  int put__URL(wchar* URL);
}

interface DInetEvents : IDispatch {
  mixin(uuid("48e59292-9880-11cf-9754-00aa00c00908"));
  /+void StateChanged(short State);+/
}

abstract final class Inet {
  mixin(uuid("48e59293-9880-11cf-9754-00aa00c00908"));
  mixin Interfaces!(IInet);
}
