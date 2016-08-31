/***********************************************************************\
*                                cplext.d                               *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*             Translated from MinGW API for MS-Windows 3.10             *
*                           by Stewart Gordon                           *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module os.win32.cplext;

enum : uint {
	CPLPAGE_MOUSE_BUTTONS      = 1,
	CPLPAGE_MOUSE_PTRMOTION    = 2,
	CPLPAGE_MOUSE_WHEEL        = 3,
	CPLPAGE_KEYBOARD_SPEED     = 1,
	CPLPAGE_DISPLAY_BACKGROUND = 1
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-win32");
        } else version (DigitalMars) {
            pragma(link, "auxC");
        } else {
            pragma(link, "DO-win32");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-win32");
        } else version (DigitalMars) {
            pragma(link, "auxC");
        } else {
            pragma(link, "DO-win32");
        }
    }
}
