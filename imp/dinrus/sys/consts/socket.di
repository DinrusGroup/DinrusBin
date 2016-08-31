module sys.consts.socket;

version (Windows)
         public import sys.win32.consts.socket;
else
version (linux)
         public import sys.linux.consts.socket;
else
version (freebsd)
         public import sys.freebsd.consts.socket;
else
version (darwin)
         public import sys.darwin.consts.socket;
else
version (solaris)
         public import sys.solaris.consts.socket;
