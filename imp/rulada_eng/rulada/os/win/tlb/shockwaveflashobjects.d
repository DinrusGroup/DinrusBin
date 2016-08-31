module os.win.tlb.shockwaveflashobjects;

private import os.win.com.core;

interface IShockwaveFlash : IDispatch {
  mixin(uuid("d27cdb6c-ae6d-11cf-96b8-444553540000"));
  int get_ReadyState(out int pVal);
  int get_TotalFrames(out int pVal);
  int get_Playing(out short pVal);
  int put_Playing(short pVal);
  int get_Quality(out int pVal);
  int put_Quality(int pVal);
  int get_ScaleMode(out int pVal);
  int put_ScaleMode(int pVal);
  int get_AlignMode(out int pVal);
  int put_AlignMode(int pVal);
  int get_BackgroundColor(out int pVal);
  int put_BackgroundColor(int pVal);
  int get_Loop(out short pVal);
  int put_Loop(short pVal);
  int get_Movie(out wchar* pVal);
  int put_Movie(wchar* pVal);
  int get_FrameNum(out int pVal);
  int put_FrameNum(int pVal);
  int SetZoomRect(int left, int top, int right, int bottom);
  int Zoom(int factor);
  int Pan(int x, int y, int mode);
  int Play();
  int Stop();
  int Back();
  int Forward();
  int Rewind();
  int StopPlay();
  int GotoFrame(int FrameNum);
  int CurrentFrame(out int FrameNum);
  int IsPlaying(out short Playing);
  int PercentLoaded(out int percent);
  int FrameLoaded(int FrameNum, out short loaded);
  int FlashVersion(out int versionParam);
  int get_WMode(out wchar* pVal);
  int put_WMode(wchar* pVal);
  int get_SAlign(out wchar* pVal);
  int put_SAlign(wchar* pVal);
  int get_Menu(out short pVal);
  int put_Menu(short pVal);
  int get_Base(out wchar* pVal);
  int put_Base(wchar* pVal);
  int get_Scale(out wchar* pVal);
  int put_Scale(wchar* pVal);
  int get_DeviceFont(out short pVal);
  int put_DeviceFont(short pVal);
  int get_EmbedMovie(out short pVal);
  int put_EmbedMovie(short pVal);
  int get_BGColor(out wchar* pVal);
  int put_BGColor(wchar* pVal);
  int get_Quality2(out wchar* pVal);
  int put_Quality2(wchar* pVal);
  int LoadMovie(int layer, wchar* url);
  int TGotoFrame(wchar* target, int FrameNum);
  int TGotoLabel(wchar* target, wchar* label);
  int TCurrentFrame(wchar* target, out int FrameNum);
  int TCurrentLabel(wchar* target, out wchar* pVal);
  int TPlay(wchar* target);
  int TStopPlay(wchar* target);
  int SetVariable(wchar* name, wchar* value);
  int GetVariable(wchar* name, out wchar* pVal);
  int TSetProperty(wchar* target, int property, wchar* value);
  int TGetProperty(wchar* target, int property, out wchar* pVal);
  int TCallFrame(wchar* target, int FrameNum);
  int TCallLabel(wchar* target, wchar* label);
  int TSetPropertyNum(wchar* target, int property, double value);
  int TGetPropertyNum(wchar* target, int property, out double pVal);
  int TGetPropertyAsNumber(wchar* target, int property, out double pVal);
  int get_SWRemote(out wchar* pVal);
  int put_SWRemote(wchar* pVal);
  int get_FlashVars(out wchar* pVal);
  int put_FlashVars(wchar* pVal);
  int get_AllowScriptAccess(out wchar* pVal);
  int put_AllowScriptAccess(wchar* pVal);
  int get_MovieData(out wchar* pVal);
  int put_MovieData(wchar* pVal);
  int get_InlineData(out IUnknown ppIUnknown);
  int put_InlineData(IUnknown ppIUnknown);
  int get_SeamlessTabbing(out short pVal);
  int put_SeamlessTabbing(short pVal);
}

interface _IShockwaveFlashEvents : IDispatch {
  mixin(uuid("d27cdb6d-ae6d-11cf-96b8-444553540000"));
  /+void OnReadyStateChange(int newState);+/
  /+void OnProgress(int percentDone);+/
  /+void FSCommand(wchar* command, wchar* args);+/
}

interface IFlashFactory : IUnknown {
  mixin(uuid("d27cdb70-ae6d-11cf-96b8-444553540000"));
}

interface IFlashObjectInterface : IDispatchEx {
  mixin(uuid("d27cdb72-ae6d-11cf-96b8-444553540000"));
}

interface IDispatchEx : IDispatch {
  mixin(uuid("a6ef9860-c720-11d0-9337-00a0c90dcaa9"));
  int GetDispID(wchar* bstrName, uint grfdex, out int pid);
  int RemoteInvokeEx(int id, uint lcid, uint dwFlags, DISPPARAMS* pdp, out VARIANT pvarRes, out EXCEPINFO pei, IServiceProvider pspCaller, uint cvarRefArg, uint* rgiRefArg, ref VARIANT rgvarRefArg);
  int DeleteMemberByName(wchar* bstrName, uint grfdex);
  int DeleteMemberByDispID(int id);
  int GetMemberProperties(int id, uint grfdexFetch, out uint pgrfdex);
  int GetMemberName(int id, out wchar* pbstrName);
  int GetNextDispID(uint grfdex, int id, out int pid);
  int GetNameSpaceParent(out IUnknown ppunk);
}

interface IServiceProvider : IUnknown {
  mixin(uuid("6d5140c1-7436-11ce-8034-00aa006009fa"));
  int RemoteQueryService(ref GUID guidService, ref GUID riid, out IUnknown ppvObject);
}

abstract final class ShockwaveFlash {
  mixin(uuid("d27cdb6e-ae6d-11cf-96b8-444553540000"));
  mixin Interfaces!(IShockwaveFlash);
}

abstract final class FlashProp {
  mixin(uuid("1171a62f-05d2-11d1-83fc-00a0c9089c5a"));
  mixin Interfaces!(IUnknown);
}

abstract final class FlashObjectInterface {
  mixin(uuid("d27cdb71-ae6d-11cf-96b8-444553540000"));
  mixin Interfaces!(IFlashObjectInterface);
}
