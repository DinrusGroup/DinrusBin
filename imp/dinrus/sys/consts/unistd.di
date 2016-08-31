module sys.consts.unistd;

version (Windows)
         public import sys.win32.consts.unistd;
else
version (linux)
         public import sys.linux.consts.unistd;
else
version (freebsd)
         public import sys.freebsd.consts.unistd;
else
version (darwin)
         public import sys.darwin.consts.unistd;
else
version (solaris)
         public import sys.solaris.consts.unistd;

