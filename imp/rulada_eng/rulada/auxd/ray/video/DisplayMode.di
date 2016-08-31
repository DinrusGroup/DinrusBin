/**
	Copyright: Copyright (c) 2007, Artyom Shalkhakov. All rights reserved.
	License: BSD

	TODO: provide implementations for platforms other than Win32
	TODO: documentation
	TODO: log messages instead of sending them to Stdout?
	BUGS: multiple monitors, as well as virtual desktops, are not handled

	Version: Aug 2007: initial release
	Authors: Artyom Shalkhakov
*/
module auxd.ray.video.DisplayMode;

import tango.core.Array : sort, lbound;
import tango.io.Stdout;

version ( Windows ) {
	import auxd.ray.video.internal.DisplayModeWin;
}
else {
	static assert( false, "not implemented" );
}

/// display mode description
struct DisplayMode {
	int opCmp( DisplayMode m );

	int opEquals( DisplayMode m ) ;

	int		width, height;	/// width and height, in pixels
	int		bitdepth;		/// color bits
	int		frequency;		/// vertical refresh rate, Hz (cycles/second)
	uint	index;			/// for internal use only
}

static this() {
	DisplaySettings.imp.init( DisplaySettings.modes, DisplaySettings.defaultMode );
	DisplaySettings.currentMode = DisplaySettings.defaultMode;
	// sort ascending: width, height, bitdepth, frequency
	DisplaySettings.modes.sort;
}

static ~this() {
	DisplaySettings.restore;			// we might have to restore the video mode
	DisplaySettings.modes.length = 0;
	DisplaySettings.imp.term;			// terminate implementation
}

/**
	Exposes the OS display settings in a portable way.
*/
struct DisplaySettings {
	/**
		Change display mode to the desired resolution. Returns false on failure.
		If strict is true, then no matching will be performed, otherwise
		the closest match will be set.
		Omit parameters to set the default display mode.
	*/
	static bool change( bool strict, int width = 0, int height = 0, int bitdepth = 0, int frequency = 0 ) ;

	/// ditto
	static bool change( bool strict, ref DisplayMode mode );

	/**
		Has display mode changed?
		On Windows, default mode corresponds to desktop display mode.
	*/
 	static bool modified() ;

	/**
		Restore the display mode to the default. Returns false on failure.
	*/
	static bool restore() ;

	/**
		Enumerate all the supported display modes. Callback should return false to terminate the loop.
	*/
	static void enumerate( bool delegate( DisplayMode mode ) callback ) ;

	/// ditto
	static void enumerate( bool function( DisplayMode mode ) callback ) ;

	/// information on current display mode
	static DisplayMode modeInfo();

	/// information on default display mode
	static DisplayMode defaultModeInfo();

	static private {
		DisplayMode			defaultMode;
		DisplayMode 		currentMode;
		DisplayMode[]		modes;
		DisplaySettingsImp	imp;
	}
}

debug ( UNITTESTS ) {
	unittest {
		bool	r;

		assert( !DisplaySettings.modified );
		r = DisplaySettings.change( true );		// redundant change
		assert( r == true );

		static bool print( DisplayMode mode ) {
			with ( mode ) {
				Stdout.format( "mode: {0} by {1}, color depth: {2}, at {3} Hz", width, height, bitdepth, frequency ).newline;
			}
			return true;
		}

		Stdout( "printing all supported display modes:" ).newline;
		DisplaySettings.enumerate( &print );

		Stdout( "setting safe mode (strict):" ).newline;
		r = DisplaySettings.change( true, 640, 480, 16, 70 );
		if ( !r ) {
			Stdout( "setting safe mode (relaxed):" ).newline;
			r = DisplaySettings.change( false, 640, 480, 16, 0 );
		}
		else {
			r = DisplaySettings.change( true, 640, 480, 16, 0 );
		}
		if ( !r ) {
			Stdout( "failed" ).newline;
		}
		else {
			Stdout( "setting very high mode (strict):" ).newline;
			r = DisplaySettings.change( true, 2048, 1536, 32, 150 );
			if ( !r ) {
				Stdout( "setting very high mode (relaxed):" ).newline;
				r = DisplaySettings.change( false, 2048, 1536, 32, 150 );
			}
		}

		if ( DisplaySettings.modified ) {
			Stdout( "restoring display mode" ).newline;
			DisplaySettings.restore;
		}
	}}

version (build) {
    debug {
        pragma(link, "ray");
    } else {
        pragma(link, "ray");
    }
}
