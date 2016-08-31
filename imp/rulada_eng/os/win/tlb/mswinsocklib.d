module os.win.tlb.mswinsocklib;

private import os.win.com.core;

enum ProtocolConstants {
  sckTCPProtocol = 0x00000000,
  sckUDPProtocol = 0x00000001,
}

enum StateConstants {
  sckClosed = 0x00000000,
  sckOpen = 0x00000001,
  sckListening = 0x00000002,
  sckConnectionPending = 0x00000003,
  sckResolvingHost = 0x00000004,
  sckHostResolved = 0x00000005,
  sckConnecting = 0x00000006,
  sckConnected = 0x00000007,
  sckClosing = 0x00000008,
  sckError = 0x00000009,
}

enum ErrorConstants {
  sckInvalidPropertyValue = 0x0000017C,
  sckGetNotSupported = 0x0000018A,
  sckSetNotSupported = 0x0000017F,
  sckOutOfMemory = 0x00000007,
  sckBadState = 0x00009C46,
  sckInvalidArg = 0x00009C4E,
  sckSuccess = 0x00009C51,
  sckUnsupported = 0x00009C52,
  sckInvalidOp = 0x00009C54,
  sckOutOfRange = 0x00009C55,
  sckWrongProtocol = 0x00009C5A,
  sckOpCanceled = 0x00002714,
  sckInvalidArgument = 0x0000271E,
  sckWouldBlock = 0x00002733,
  sckInProgress = 0x00002734,
  sckAlreadyComplete = 0x00002735,
  sckNotSocket = 0x00002736,
  sckMsgTooBig = 0x00002738,
  sckPortNotSupported = 0x0000273B,
  sckAddressInUse = 0x00002740,
  sckAddressNotAvailable = 0x00002741,
  sckNetworkSubsystemFailed = 0x00002742,
  sckNetworkUnreachable = 0x00002743,
  sckNetReset = 0x00002744,
  sckConnectAborted = 0x00002745,
  sckConnectionReset = 0x00002746,
  sckNoBufferSpace = 0x00002747,
  sckAlreadyConnected = 0x00002748,
  sckNotConnected = 0x00002749,
  sckSocketShutdown = 0x0000274A,
  sckTimedout = 0x0000274C,
  sckConnectionRefused = 0x0000274D,
  sckNotInitialized = 0x0000276D,
  sckHostNotFound = 0x00002AF9,
  sckHostNotFoundTryAgain = 0x00002AFA,
  sckNonRecoverableError = 0x00002AFB,
  sckNoData = 0x00002AFC,
}

interface IMSWinsockControl : IDispatch {
  mixin(uuid("248dd892-bb45-11cf-9abc-0080c7e7b78d"));
  int AboutBox();
  int get_Protocol(out ProtocolConstants Protocol);
  int put_Protocol(ProtocolConstants Protocol);
  int get_RemoteHostIP(out wchar* RemoteHostIP);
  int get_LocalHostName(out wchar* LocalHostName);
  int get_LocalIP(out wchar* LocalIP);
  int get_SocketHandle(out int SocketHandle);
  int get__RemoteHost(out wchar* RemoteHost);
  int put__RemoteHost(wchar* RemoteHost);
  int get_RemotePort(out int RemotePort);
  int put_RemotePort(int RemotePort);
  int get_LocalPort(out int LocalPort);
  int put_LocalPort(int LocalPort);
  int get_State(out short State);
  int get_BytesReceived(out int BytesReceived);
  int Connect(VARIANT RemoteHost, VARIANT RemotePort);
  int Listen();
  int Accept(int requestID);
  int SendData(VARIANT data);
  int GetData(ref VARIANT data, VARIANT type, VARIANT maxLen);
  int PeekData(ref VARIANT data, VARIANT type, VARIANT maxLen);
  int Close();
  int Bind(VARIANT LocalPort, VARIANT LocalIP);
  int get_RemoteHost(out wchar* RemoteHost);
  int put_RemoteHost(wchar* RemoteHost);
}

interface DMSWinsockControlEvents : IDispatch {
  mixin(uuid("248dd893-bb45-11cf-9abc-0080c7e7b78d"));
  /+void Error(short Number, wchar** Description, int Scode, wchar* Source, wchar* HelpFile, int HelpContext, short* CancelDisplay);+/
  /+void DataArrival(int bytesTotal);+/
  /+void Connect();+/
  /+void ConnectionRequest(int requestID);+/
  /+void Close();+/
  /+void SendProgress(int bytesSent, int bytesRemaining);+/
  /+void SendComplete();+/
}

abstract final class Winsock {
  mixin(uuid("248dd896-bb45-11cf-9abc-0080c7e7b78d"));
  mixin Interfaces!(IMSWinsockControl);
}
