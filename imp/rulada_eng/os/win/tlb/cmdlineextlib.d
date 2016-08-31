// CmdLineExt 1.0 Type Library
// Version 1.0

/*[uuid("6810dce2-bd7a-4e4b-b62d-c5d709858610")]*/
module cmdlineextlib;

/*[importlib("stdole2.tlb")]*/
private import os.win.com.core;

// CoClasses

// CmdLineContextMenu Class
abstract final class CmdLineContextMenu {
  mixin(uuid("f0407c3d-349c-42b9-b83e-821e31623df9"));
  mixin Interfaces!(IUnknown);
}
