module os.win.tlb.ocxcamiseta;

private import os.win.com.core;

interface _Camiseta : IDispatch {
  mixin(uuid("36c6fd10-ed6a-4117-b1a5-e50bde0893d6"));
  int BuscaCercano(ref int color, ref int r, ref int g, ref int b);
  int get_IMAGENFONDO(out wchar* value);
  int put_IMAGENFONDO(wchar* value);
  int get_Imagen(out wchar* value);
  int put_Imagen(wchar* value);
  int get_ColorA(out OLE_COLOR value);
  int put_ColorA(OLE_COLOR value);
  int get_ColorB(out OLE_COLOR value);
  int put_ColorB(OLE_COLOR value);
  int get_ColorC(out OLE_COLOR value);
  int put_ColorC(OLE_COLOR value);
  int get_ColorD(out OLE_COLOR value);
  int put_ColorD(OLE_COLOR value);
  int get_VerImagenGrande(out short value);
  int put_VerImagenGrande(short value);
}

interface __Camiseta : IDispatch {
  mixin(uuid("105d8958-f7f6-439b-9591-164c3f24db32"));
  /+void Click();+/
  /+void MouseMove();+/
  /+void Change();+/
}
