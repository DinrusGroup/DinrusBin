/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: November 2005

        author:         Kris

*******************************************************************************/

module sys.Common;

version (Win32)
        {
        public import sys.win32.UserGdi;
		public import exception;
		//pragma(lib,"DinrusTango.lib");
        }

version (linux)
        {
        public import sys.linux.linux;
        alias sys.linux.linux posix;
        }

version (darwin)
        {
        public import sys.darwin.darwin;
        alias sys.darwin.darwin posix;
        }
version (freebsd)
        {
        public import sys.freebsd.freebsd;
        alias sys.freebsd.freebsd posix;
        }
version (solaris)
        {
        public import sys.solaris.solaris;
        alias sys.solaris.solaris posix;
        }

/*******************************************************************************

        Stuff for sysErrorMsg(), kindly provопрed by Regan Heath.

*******************************************************************************/

version (Win32)
        {

        }
else
version (Posix)
        {
        private import cidrus;
        private import cidrus;
        }
else
   {
   pragma (msg, "Unsupported environment; neither Win32 or Posix is declared");
   static assert(0);
   }

   
