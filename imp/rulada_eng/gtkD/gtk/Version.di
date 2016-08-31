/*
 * This file is part of gtkD.
 *
 * gtkD is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * gtkD is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with gtkD; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 
// generated automatically - do not change
// find conversion definition on APILookup.txt
// implement new conversion functionalities on the wrap.utils pakage

/*
 * Conversion parameters:
 * inFile  = gtk-Feature-Test-Macros.html
 * outPack = gtk
 * outFile = Version
 * strct   = 
 * realStrct=
 * ctorStrct=
 * clss    = Version
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gtkc.Loader
 * 	- gtkD.gtkc.paths
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.Version;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtkc.Loader;
private import gtkD.gtkc.paths;




/**
 * Description
 * GTK+ provides version information, primarily useful in configure checks
 * for builds that have a configure script. Applications will not
 * typically use the features described here.
 */
public class Version
{
	
	/*
	 * The major version number of the GTK+ library. (e.g. in GTK+ version 2.12.4 this is 2.)
	 * This variable is in the library, so represents the GTK+ library you have linked against.
	 */
	public static int major()
	{
		uint* vers;
		
		Linker.link(vers, "gtk_major_version", LIBRARY.GTK);
		
		if ( vers is null )
		{
			return -1;
		}
		else
		{
			return *vers;
		}
	}
	
	/*
	 * The minor version number of the GTK+ library. (e.g. in GTK+ version 2.12.4 this is 12.)
	 * This variable is in the library, so represents the GTK+ library you have linked against.
	 */
	public static int minor()
	{
		uint* vers;
		
		Linker.link(vers, "gtk_minor_version", LIBRARY.GTK);
		
		if ( vers is null )
		{
			return -1;
		}
		else
		{
			return *vers;
		}
	}
	
	/*
	 * The micro version number of the GTK+ library. (e.g. in GTK+ version 2.12.4 this is 4.)
	 * This variable is in the library, so represents the GTK+ library you have linked against.
	 */
	public static int micro()
	{
		uint* vers;
		
		Linker.link(vers, "gtk_micro_version", LIBRARY.GTK);
		
		if ( vers is null )
		{
			return -1;
		}
		else
		{
			return *vers;
		}
	}
	
	/**
	 */
	
	/**
	 * Checks that the GTK+ library in use is compatible with the
	 * given version. Generally you would pass in the constants
	 * GTK_MAJOR_VERSION, GTK_MINOR_VERSION, GTK_MICRO_VERSION
	 * as the three arguments to this function; that produces
	 * a check that the library in use is compatible with
	 * the version of GTK+ the application or module was compiled
	 * against.
	 * Compatibility is defined by two things: first the version
	 * of the running library is newer than the version
	 * required_major.required_minor.required_micro. Second
	 * the running library must be binary compatible with the
	 * version required_major.required_minor.required_micro
	 * (same major version.)
	 * This function is primarily for GTK+ modules; the module
	 * can call this function to check that it wasn't loaded
	 * into an incompatible version of GTK+. However, such a
	 * a check isn't completely reliable, since the module may be
	 * linked against an old version of GTK+ and calling the
	 * old version of gtk_check_version(), but still get loaded
	 * into an application using a newer version of GTK+.
	 * Params:
	 * requiredMajor =  the required major version.
	 * requiredMinor =  the required minor version.
	 * requiredMicro =  the required micro version.
	 * Returns: NULL if the GTK+ library is compatible with the given version, or a string describing the version mismatch. The returned string is owned by GTK+ and should not be modified or freed.
	 */
	public static string checkVersion(uint requiredMajor, uint requiredMinor, uint requiredMicro)
	{
		// const gchar* gtk_check_version (guint required_major,  guint required_minor,  guint required_micro);
		return Str.toString(gtk_check_version(requiredMajor, requiredMinor, requiredMicro));
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gtk");
        } else version (DigitalMars) {
            pragma(link, "DD-gtk");
        } else {
            pragma(link, "DO-gtk");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gtk");
        } else version (DigitalMars) {
            pragma(link, "DD-gtk");
        } else {
            pragma(link, "DO-gtk");
        }
    }
}
