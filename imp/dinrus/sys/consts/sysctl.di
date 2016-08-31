module sys.consts.sysctl;

version (Windows)
         public import sys.win32.consts.sysctl;
else
version (linux)
         public import sys.linux.consts.sysctl;
else
version (freebsd)
         public import sys.freebsd.consts.sysctl;
else
version (darwin)
         public import sys.darwin.consts.sysctl;
else
version (solaris)
         public import sys.solaris.consts.sysctl;

