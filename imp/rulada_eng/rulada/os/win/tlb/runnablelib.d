// Version 1.0

/*[uuid("383bb080-e35f-11d0-8648-00aa00bdd685")]*/
module os.win.tlb.runnablelib;

/*[importlib("STDOLE2.TLB")]*/
private import os.win.com.core;

// Interfaces

interface Runnable : IDispatch {
  mixin(uuid("383bb081-e35f-11d0-8648-00aa00bdd685"));
  /*[id(0x60030000)]*/ int Start();
}
