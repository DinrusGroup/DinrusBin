module sys.consts.errno;

version (Windows)
         public import sys.win32.consts.errno;
else
version (linux)
         public import sys.linux.consts.errno;
else
version (freebsd)
         public import sys.freebsd.consts.errno;
else
version (darwin)
         public import sys.darwin.consts.errno;
else
version (solaris)
         public import sys.solaris.consts.errno;
