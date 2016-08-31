module os.win.tlb.anigifctrl;

private import os.win.com.core;

interface IAniGIF : IDispatch {
  mixin(uuid("82351440-9094-11d1-a24b-00a0c932c7df"));
  int get_Frame(out short pVal);
  int put_Frame(short pVal);
  int get_Frames(out short pVal);
  int put_Frames(short pVal);
  int get_Playing(out short pVal);
  int put_Playing(short pVal);
  int get_Transparent(out short pVal);
  int put_Transparent(short pVal);
  int get_BackColor(out OLE_COLOR pVal);
  int put_BackColor(OLE_COLOR pVal);
  int get_GIF(out wchar* pVal);
  int put_GIF(wchar* pVal);
  int get_GIFWidth(out short pVal);
  int get_GIFHeight(out short pVal);
  int get_Speed(out short pVal);
  int put_Speed(short pVal);
  int Play();
  int Stop();
  int ReadGIF(wchar* FileName, out short pRet);
  int GetFrame(short Frame, out IPictureDisp pRet);
  int get_Stretch(out short pVal);
  int put_Stretch(short pVal);
  int get_FrameWidth(short Frame, out short pVal);
  int get_FrameHeight(short Frame, out short pVal);
  int get_FrameLeft(short Frame, out short pVal);
  int get_FrameTop(short Frame, out short pVal);
  int get_AutoSize(out short pVal);
  int put_AutoSize(short pVal);
  int get_SequenceString(out wchar* pVal);
  int put_SequenceString(wchar* pVal);
  int get_Sequence(out short pVal);
  int put_Sequence(short pVal);
  int get_HTTPProxy(out wchar* pVal);
  int put_HTTPProxy(wchar* pVal);
  int get_HTTPUserName(out wchar* pVal);
  int put_HTTPUserName(wchar* pVal);
  int get_HTTPPassword(out wchar* pVal);
  int put_HTTPPassword(wchar* pVal);
  int get_MouseIcon(out IPictureDisp pVal);
  int put_MouseIcon(IPictureDisp* pVal);
  int putref_MouseIcon(IPictureDisp* pVal);
  int get_MousePointer(out int pVal);
  int put_MousePointer(int pVal);
  int ReadGIF2(wchar* FileName);
  int get_Loop(out short pVal);
  int put_Loop(short pVal);
  int get_AutoRewind(out short pVal);
  int put_AutoRewind(short pVal);
  int get_Synchronized(out short pVal);
  int put_Synchronized(short pVal);
  int get_BackgroundPicture(out IPictureDisp pVal);
  int put_BackgroundPicture(IPictureDisp* pVal);
  int putref_BackgroundPicture(IPictureDisp* pVal);
  int StopReadGIF();
  int Refresh();
  int get_OriginalLoop(out short pVal);
  int _PutGIF(int GIF);
  int _GetGIF(out int GIF);
  int get_hWnd(out int pVal);
  int AboutBox();
}

interface IAniGIFEvents : IDispatch {
  mixin(uuid("5252ac41-94bb-11d1-b2e7-444553540000"));
  /+void Step();+/
  /+void ReadFinished();+/
  /+void PlayFinished();+/
  /+void Click();+/
  /+void KeyDown(short keycode, short shift);+/
  /+void KeyUp(short keycode, short shift);+/
  /+void KeyPress(short keyascii);+/
  /+void DblClick();+/
  /+void MouseDown(short Button, short shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+void MouseMove(short Button, short shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
  /+void MouseUp(short Button, short shift, OLE_XPOS_PIXELS x, OLE_YPOS_PIXELS y);+/
}

abstract final class AniGIF {
  mixin(uuid("82351441-9094-11d1-a24b-00a0c932c7df"));
  mixin Interfaces!(IAniGIF);
}

abstract final class AniGIFPpg {
  mixin(uuid("6dc82d15-92f2-11d1-a255-00a0c932c7df"));
  mixin Interfaces!(IUnknown);
}

abstract final class AniGIFPpg2 {
  mixin(uuid("61ab12e1-a5ff-11d1-b2e9-444553540000"));
  mixin Interfaces!(IUnknown);
}
