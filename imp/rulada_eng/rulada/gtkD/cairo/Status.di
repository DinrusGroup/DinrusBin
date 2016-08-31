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
 * inFile  = cairo-error-status.html
 * outPack = cairo
 * outFile = Status
 * strct   = 
 * realStrct=
 * ctorStrct=
 * clss    = Status
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- cairo_status_t
 * 	- cairo_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.cairo.Status;

public  import gtkD.gtkc.cairotypes;

private import gtkD.gtkc.cairo;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * Cairo uses a single status type to represent all kinds of errors. A status
 * value of CAIRO_STATUS_SUCCESS represents no error and has an integer value
 * of zero. All other status values represent an error.
 * Cairo's error handling is designed to be easy to use and safe. All major
 * cairo objects retain an error status internally which
 * can be queried anytime by the users using cairo*_status() calls. In
 * the mean time, it is safe to call all cairo functions normally even if the
 * underlying object is in an error status. This means that no error handling
 * code is required before or after each individual cairo function call.
 */
public class Status
{
	
	/**
	 */
	
	/**
	 * Provides a human-readable description of a cairo_status_t.
	 * Params:
	 * status =  a cairo status
	 * Returns: a string representation of the status
	 */
	public static string oString(cairo_status_t status)
	{
		// const char* cairo_status_to_string (cairo_status_t status);
		return Str.toString(cairo_status_to_string(status));
	}
	
	/**
	 * Resets all static data within cairo to its original state,
	 * (ie. identical to the state at the time of program invocation). For
	 * example, all caches within cairo will be flushed empty.
	 * This function is intended to be useful when using memory-checking
	 * tools such as valgrind. When valgrind's memcheck analyzes a
	 * cairo-using program without a call to cairo_debug_reset_static_data(),
	 * it will report all data reachable via cairo's static objects as
	 * "still reachable". Calling cairo_debug_reset_static_data() just prior
	 * to program termination will make it easier to get squeaky clean
	 * reports from valgrind.
	 * WARNING: It is only safe to call this function when there are no
	 * active cairo objects remaining, (ie. the appropriate destroy
	 * functions have been called as necessary). If there are active cairo
	 * objects, this call is likely to cause a crash, (eg. an assertion
	 * failure due to a hash table being destroyed when non-empty).
	 */
	public static void debugResetStaticData()
	{
		// void cairo_debug_reset_static_data (void);
		cairo_debug_reset_static_data();
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-cairo");
        } else version (DigitalMars) {
            pragma(link, "DD-cairo");
        } else {
            pragma(link, "DO-cairo");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-cairo");
        } else version (DigitalMars) {
            pragma(link, "DD-cairo");
        } else {
            pragma(link, "DO-cairo");
        }
    }
}
