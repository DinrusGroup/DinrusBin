module os.win.tlb.mscommlib;

private import os.win.com.core;

enum HandshakingConstants {
  NoHandshaking = 0x00000000,
  XonXoff = 0x00000001,
  RtsCts = 0x00000002,
  XonXoffAndRtsCts = 0x00000003,
}

enum HandshakeConstants {
  comNone = 0x00000000,
  comXOnXoff = 0x00000001,
  comRTS = 0x00000002,
  comRTSXOnXOff = 0x00000003,
}

enum ErrorConstants {
  comInvalidPropertyValue = 0x0000017C,
  comGetNotSupported = 0x0000018A,
  comSetNotSupported = 0x0000017F,
  comPortInvalid = 0x00001F42,
  comPortAlreadyOpen = 0x00001F45,
  comPortOpen = 0x00001F40,
  comNoOpen = 0x00001F4C,
  comSetCommStateFailed = 0x00001F4F,
  comPortNotOpen = 0x00001F52,
  comReadError = 0x00001F54,
  comDCBError = 0x00001F55,
  comBreak = 0x000003E9,
  comCTSTO = 0x000003EA,
  comDSRTO = 0x000003EB,
  comFrame = 0x000003EC,
  comOverrun = 0x000003EE,
  comCDTO = 0x000003EF,
  comRxOver = 0x000003F0,
  comRxParity = 0x000003F1,
  comTxFull = 0x000003F2,
  comDCB = 0x000003F3,
}

enum CommEventConstants {
  comEventBreak = 0x000003E9,
  comEventCTSTO = 0x000003EA,
  comEventDSRTO = 0x000003EB,
  comEventFrame = 0x000003EC,
  comEventOverrun = 0x000003EE,
  comEventCDTO = 0x000003EF,
  comEventRxOver = 0x000003F0,
  comEventRxParity = 0x000003F1,
  comEventTxFull = 0x000003F2,
  comEventDCB = 0x000003F3,
}

enum OnCommConstants {
  comEvSend = 0x00000001,
  comEvReceive = 0x00000002,
  comEvCTS = 0x00000003,
  comEvDSR = 0x00000004,
  comEvCD = 0x00000005,
  comEvRing = 0x00000006,
  comEvEOF = 0x00000007,
}

enum InputModeConstants {
  comInputModeText = 0x00000000,
  comInputModeBinary = 0x00000001,
}

interface IMSComm : IDispatch {
  mixin(uuid("e6e17e90-df38-11cf-8e74-00a0c90f26f8"));
  int put_CDHolding(short pfCDHolding);
  int get_CDHolding(out short pfCDHolding);
  int put_CDTimeout(int plCDTimeout);
  int get_CDTimeout(out int plCDTimeout);
  int put_CommID(int plCommID);
  int get_CommID(out int plCommID);
  int put_CommPort(short psCommPort);
  int get_CommPort(out short psCommPort);
  int put__CommPort(short psCommPort);
  int get__CommPort(out short psCommPort);
  int put_CTSHolding(short pfCTSHolding);
  int get_CTSHolding(out short pfCTSHolding);
  int put_CTSTimeout(int plCTSTimeout);
  int get_CTSTimeout(out int plCTSTimeout);
  int put_DSRHolding(short pfDSRHolding);
  int get_DSRHolding(out short pfDSRHolding);
  int put_DSRTimeout(int plDSRTimeout);
  int get_DSRTimeout(out int plDSRTimeout);
  int put_DTREnable(short pfDTREnable);
  int get_DTREnable(out short pfDTREnable);
  int put_Handshaking(HandshakeConstants phandshake);
  int get_Handshaking(out HandshakeConstants phandshake);
  int put_InBufferSize(short psInBufferSize);
  int get_InBufferSize(out short psInBufferSize);
  int put_InBufferCount(short psInBufferCount);
  int get_InBufferCount(out short psInBufferCount);
  int put_Break(short pfBreak);
  int get_Break(out short pfBreak);
  int put_InputLen(short psInputLen);
  int get_InputLen(out short psInputLen);
  int put_Interval(int plInterval);
  int get_Interval(out int plInterval);
  int put_NullDiscard(short pfNullDiscard);
  int get_NullDiscard(out short pfNullDiscard);
  int put_OutBufferSize(short psOutBufferSize);
  int get_OutBufferSize(out short psOutBufferSize);
  int put_OutBufferCount(short psOutBufferCount);
  int get_OutBufferCount(out short psOutBufferCount);
  int put_ParityReplace(wchar* pbstrParityReplace);
  int get_ParityReplace(out wchar* pbstrParityReplace);
  int put_PortOpen(short pfPortOpen);
  int get_PortOpen(out short pfPortOpen);
  int put_RThreshold(short psRThreshold);
  int get_RThreshold(out short psRThreshold);
  int put_RTSEnable(short pfRTSEnable);
  int get_RTSEnable(out short pfRTSEnable);
  int put_Settings(wchar* pbstrSettings);
  int get_Settings(out wchar* pbstrSettings);
  int put_SThreshold(short psSThreshold);
  int get_SThreshold(out short psSThreshold);
  int put_Output(VARIANT pvarOutput);
  int get_Output(out VARIANT pvarOutput);
  int put_Input(VARIANT pvarInput);
  int get_Input(out VARIANT pvarInput);
  int put_CommEvent(short psCommEvent);
  int get_CommEvent(out short psCommEvent);
  int put_EOFEnable(short pfEOFEnable);
  int get_EOFEnable(out short pfEOFEnable);
  int put_InputMode(InputModeConstants InputMode);
  int get_InputMode(out InputModeConstants InputMode);
  void AboutBox();
}

interface DMSCommEvents : IDispatch {
  mixin(uuid("648a5602-2c6e-101b-82b6-000000000014"));
  /+void OnComm();+/
}

abstract final class MSComm {
  mixin(uuid("648a5600-2c6e-101b-82b6-000000000014"));
  mixin Interfaces!(IMSComm);
}
