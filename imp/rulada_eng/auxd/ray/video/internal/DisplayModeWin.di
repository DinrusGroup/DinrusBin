/**
	Copyright: Copyright (c) 2007, Artyom Shalkhakov. All rights reserved.
	License: BSD

	This module provides Win32 implementation for auxd.ray.video.DisplayMode.DisplaySettings,
	and is not meant to be used on its own.

	TODO: log messages?
	BUGS: tango version doesn't work: values returned by ChangeDisplaySettings/EnumDisplaySettings are always 0

	Version: Aug 2007: initial release
	Authors: Artyom Shalkhakov
*/
module auxd.ray.video.internal.DisplayModeWin;

import tango.io.Stdout;

import auxd.ray.video.DisplayMode;

version ( Windows ) {
	// FIXME: why doesn't it work using tango?
	version ( TANGO_IMP ) {
		import tango.sys.win32.UserGdi;
	
		// this is missing in UserGdi: why?
		enum : DWORD {
			ENUM_CURRENT_SETTINGS       = ( cast( DWORD )-1 ),
			CDS_FULLSCREEN				= 0x00000004,
			DISP_CHANGE_BADPARAM		= -5
		}
	}
	else {
		import tango.sys.win32.Types;

		enum : DWORD {
			/* Flags for ChangeDisplaySettings */
			CDS_UPDATEREGISTRY	= 0x00000001,
			CDS_TEST			= 0x00000002,
			CDS_FULLSCREEN		= 0x00000004,
			CDS_GLOBAL			= 0x00000008,
			CDS_SET_PRIMARY		= 0x00000010,
			CDS_RESET			= 0x40000000,
			CDS_SETRECT			= 0x20000000,
			CDS_NORESET			= 0x10000000,

			/* Return values for ChangeDisplaySettings */
			DISP_CHANGE_SUCCESSFUL		= 0,
			DISP_CHANGE_RESTART			= 1,
			DISP_CHANGE_FAILED			= -1,
			DISP_CHANGE_BADMODE			= -2,
			DISP_CHANGE_NOTUPDATED		= -3,
			DISP_CHANGE_BADFLAGS		= -4,
			DISP_CHANGE_BADPARAM		= -5,

			// special values for EnumDisplaySettings
			ENUM_CURRENT_SETTINGS		= ( cast( DWORD ) -1 ),

			/* size of a device name string */
			CCHDEVICENAME = 32,
			/* size of a form name string */
			CCHFORMNAME = 32
		}

		struct DEVMODEA {
			BYTE   dmDeviceName[CCHDEVICENAME];
			WORD dmSpecVersion;
			WORD dmDriverVersion;
			WORD dmSize;
			WORD dmDriverExtra;
			DWORD dmFields;
			short dmOrientation;
			short dmPaperSize;
			short dmPaperLength;
			short dmPaperWidth;
			short dmScale;
			short dmCopies;
			short dmDefaultSource;
			short dmPrintQuality;
			short dmColor;
			short dmDuplex;
			short dmYResolution;
			short dmTTOption;
			short dmCollate;
			BYTE   dmFormName[CCHFORMNAME];
			WORD   dmLogPixels;
			DWORD  dmBitsPerPel;
			DWORD  dmPelsWidth;
			DWORD  dmPelsHeight;
			DWORD  dmDisplayFlags;
			DWORD  dmDisplayFrequency;
			DWORD  dmICMMethod;
			DWORD  dmICMIntent;
			DWORD  dmMediaType;
			DWORD  dmDitherType;
			DWORD  dmICCManufacturer;
			DWORD  dmICCModel;
			DWORD  dmPanningWidth;
			DWORD  dmPanningHeight;
		}
		alias DEVMODEA * PDEVMODEA,NPDEVMODEA,LPDEVMODEA;
		alias DEVMODEA	DEVMODE;	// for compatibility with tango version, above

		extern ( Windows ) {
			LONG ChangeDisplaySettingsA( LPDEVMODEA lpDevMode, DWORD dwFlags );
			BOOL EnumDisplaySettingsA( LPCSTR lpszDeviceName, DWORD iModeNum, LPDEVMODEA lpDevMode );
		}
	}

	pragma( lib, "gdi32.lib" );
}
else {
	static assert( false, "this module should not be used on this platform" );
}

struct DisplaySettingsImp {
	void init( out DisplayMode[] list, ref DisplayMode desktopMode ) {
		DEVMODEA			dm;
		DisplayMode			mode;

		static void assign( ref DEVMODE devmode, ref DisplayMode mode )
		in {
			assert( devmode.dmFields & ( DM_PELSWIDTH | DM_PELSHEIGHT | DM_BITSPERPEL | DM_DISPLAYFREQUENCY ) );
		}
		body {
			mode.width = devmode.dmPelsWidth;
			mode.height = devmode.dmPelsHeight;
			mode.bitdepth = devmode.dmBitsPerPel;
			mode.frequency = devmode.dmDisplayFrequency;
		}

		dm.dmSize = DEVMODE.sizeof;

		// get desktop mode
		if ( !EnumDisplaySettingsA( null, ENUM_CURRENT_SETTINGS, &dm ) ) {
			throw new Exception( "EnumDisplaySettings() failed for ENUM_CURRENT_SETTINGS" );
		}
		assign( dm, desktopMode );

		// enumerate and cache available display modes
		list.length = 0;
		for ( DWORD i = 0; ; i++ ) {
			if ( !EnumDisplaySettingsA( null, i, &dm ) ) {
				break;
			}
			assign( dm, mode );
			mode.index = i;
			list ~= mode;
		}
	}

	void term() {
		// nothing to do here
	}

	private static void printCDS( int value ) {
		switch ( value ) {
		case DISP_CHANGE_RESTART:
			Stdout( "restart required" ).newline;
			break;
		case DISP_CHANGE_BADPARAM:
			Stdout( "bad param" ).newline;
			break;
		case DISP_CHANGE_BADFLAGS:
			Stdout( "bad flags" ).newline;
			break;
		case DISP_CHANGE_FAILED:
			Stdout( "DISP_CHANGE_FAILED" ).newline;
			break;
		case DISP_CHANGE_BADMODE:
			Stdout( "bad mode" ).newline;
			break;
		default:
			Stdout.format( "unknown error {}", value ).newline;
			break;
		}
	}

	// do a call to CDS
	bool change( int index ) {
		int		cds;
		DEVMODE	dm;

		dm.dmSize = DEVMODE.sizeof;
		EnumDisplaySettingsA( null, index, &dm );

		Stdout.format( "...trying to set the mode: {0}x{1}, color: {2} bits, frequency: {3} Hz", dm.dmPelsWidth, dm.dmPelsHeight, dm.dmBitsPerPel, dm.dmDisplayFrequency ).newline;
		Stdout( "...calling CDS: " );
		if ( ( cds = ChangeDisplaySettingsA( &dm, CDS_FULLSCREEN ) ) != DISP_CHANGE_SUCCESSFUL ) {
			printCDS( cds );
			return false;
		}
		Stdout( "succeeded" ).newline;
		return true;
	}

	// restore display settings to defaults
	bool restore() {
		int	cds;

		if ( ( cds = ChangeDisplaySettingsA( null, 0 ) ) != DISP_CHANGE_SUCCESSFUL ) {
			printCDS( cds );
			return false;
		}
		return true;
	}
}

version (build) {
    debug {
        pragma(link, "ray");
    } else {
        pragma(link, "ray");
    }
}
