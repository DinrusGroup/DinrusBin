module os.win.base.all;

public import os.win.base.core,
  os.win.base.string,
  os.win.base.collections,
  os.win.base.text,
  os.win.base.math,
  os.win.base.environment,
  os.win.base.threading,
  os.win.base.time,
  os.win.base.events;

public import os.win.loc.consts,
  os.win.loc.core,
  os.win.loc.time,
  os.win.loc.num,
  os.win.loc.conv;

public import os.win.io.core,
  os.win.io.path,
  os.win.io.fs,
  os.win.io.zip;
version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-win");
        } else version (DigitalMars) {
            pragma(link, "rulada");
        } else {
            pragma(link, "DO-win");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-win");
        } else version (DigitalMars) {
            pragma(link, "rulada");
        } else {
            pragma(link, "DO-win");
        }
    }
}
