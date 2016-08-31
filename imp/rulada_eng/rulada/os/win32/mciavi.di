/***********************************************************************\
*                                mciavi.d                               *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                           by Stewart Gordon                           *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module os.win32.mciavi;

private import os.win32.mmsystem;

// FIXME: check types and grouping of constants

const MCI_MCIAVI_PLAY_WINDOW     = 0x01000000;
const MCI_MCIAVI_PLAY_FULLSCREEN = 0x02000000;
const MCI_MCIAVI_PLAY_FULLBY2    = 0x04000000;

enum {
	MCI_AVI_STATUS_FRAMES_SKIPPED     = 0x00008001,
	MCI_AVI_STATUS_LAST_PLAY_SPEED    = 0x00008002,
	MCI_AVI_STATUS_AUDIO_BREAKS       = 0x00008003,
	MCI_AVI_SETVIDEO_DRAW_PROCEDURE   = 0x00008000,
	MCI_AVI_SETVIDEO_PALETTE_COLOR    = 0x00008100,
	MCI_AVI_SETVIDEO_PALETTE_HALFTONE = 0x0000FFFF
}

enum {
	MCIERR_AVI_OLDAVIFORMAT  = MCIERR_CUSTOM_DRIVER_BASE + 100,
	MCIERR_AVI_NOTINTERLEAVED,
	MCIERR_AVI_NODISPDIB,
	MCIERR_AVI_CANTPLAYFULLSCREEN,
	MCIERR_AVI_TOOBIGFORVGA,
	MCIERR_AVI_NOCOMPRESSOR,
	MCIERR_AVI_DISPLAYERROR,
	MCIERR_AVI_AUDIOERROR,
	MCIERR_AVI_BADPALETTE // = MCIERR_CUSTOM_DRIVER_BASE + 108
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
