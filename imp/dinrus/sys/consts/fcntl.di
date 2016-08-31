module sys.consts.fcntl;

version (Windows)
         public import sys.win32.consts.fcntl;
else
version (linux)
         public import sys.linux.consts.fcntl;
else
version (freebsd)
         public import sys.freebsd.consts.fcntl;
else
version (darwin)
         public import sys.darwin.consts.fcntl;
else
version (solaris)
         public import sys.solaris.consts.fcntl;
