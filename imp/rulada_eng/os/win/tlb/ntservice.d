module os.win.tlb.ntservice;

private import os.win.com.core;

enum SvcStartMode {
  svcStartAutomatic = 0x00000002,
  svcStartManual = 0x00000003,
  svcStartDisabled = 0x00000004,
}

enum SvcState {
  svcStopped = 0x00000001,
  svcStartPending = 0x00000002,
  svcStopPending = 0x00000003,
  svcRunning = 0x00000004,
  svcContinuePending = 0x00000005,
  svcPausePending = 0x00000006,
  svcPaused = 0x00000007,
}

enum SvcControls {
  svcCtrlStartStop = 0x00000001,
  svcCtrlStop = 0x00000001,
  svcCtrlPauseContinue = 0x00000002,
  svcCtrlShutdown = 0x00000004,
}

enum SvcEventType {
  svcEventSuccess = 0x00000000,
  svcEventError = 0x00000001,
  svcEventWarning = 0x00000002,
  svcEventInformation = 0x00000004,
  svcEventAuditSuccess = 0x00000008,
  svcEventAuditFailure = 0x00000010,
}

enum SvcEventId {
  svcMessageDebug = 0x0000006C,
  svcMessageError = 0x0000006D,
  svcMessageInfo = 0x0000006E,
}

interface _DNtSvc : IDispatch {
  mixin(uuid("e7bc34a1-ba86-11cf-84b1-cbc2da68bf6c"));
  /+void DeleteSetting(wchar* section, VARIANT key);+/
  /+VARIANT GetAllSettings(wchar* section);+/
  /+wchar* GetSetting(wchar* section, wchar* key, VARIANT defaultSetting);+/
  /+short Install();+/
  /+short LogEvent(short EventType, int ID, wchar* Message);+/
  /+short Running();+/
  /+void SaveSetting(wchar* section, wchar* key, wchar* setting);+/
  /+short StartService();+/
  /+void StopService();+/
  /+short Uninstall();+/
  /+void AboutBox();+/
  /+const wchar* Account;+/
  /+const int ControlsAccepted;+/
  /+const short Debug;+/
  /+const wchar* LoadOrderGroup;+/
  /+const wchar* Dependencies;+/
  /+const wchar* DisplayName;+/
  /+const short Interactive;+/
  /+const wchar* Password;+/
  /+const wchar* ServiceName;+/
  /+const SvcStartMode StartMode;+/
  /+const wchar* _DisplayName;+/
}

interface _DNtSvcEvents : IDispatch {
  mixin(uuid("e7bc34a2-ba86-11cf-84b1-cbc2da68bf6c"));
  /+void Continue(short* Success);+/
  /+void Control(int Event);+/
  /+void Pause(short* Success);+/
  /+void Start(short* Success);+/
  /+void Stop();+/
}

abstract final class NTService {
  mixin(uuid("e7bc34a3-ba86-11cf-84b1-cbc2da68bf6c"));
  mixin Interfaces!(_DNtSvc);
}
