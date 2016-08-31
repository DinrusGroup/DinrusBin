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
 * inFile  = gio-Extension-Points.html
 * outPack = gio
 * outFile = IOExtension
 * strct   = GIOExtension
 * realStrct=
 * ctorStrct=
 * clss    = IOExtension
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_io_extension_
 * omit structs:
 * omit prefixes:
 * 	- g_io_extension_point_
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * structWrap:
 * 	- GIOExtension* -> IOExtension
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.IOExtension;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * GIOExtensionPoint provides a mechanism for modules to extend the
 * functionality of the library or application that loaded it in an
 * organized fashion.
 * An extension point is identified by a name, and it may optionally
 * require that any implementation must by of a certain type (or derived
 * thereof). Use g_io_extension_point_register() to register an
 * extension point, and g_io_extension_point_set_required_type() to
 * set a required type.
 * A module can implement an extension point by specifying the GType
 * that implements the functionality. Additionally, each implementation
 * of an extension point has a name, and a priority. Use
 * g_io_extension_point_implement() to implement an extension point.
 *  GIOExtensionPoint *ep;
 *  /+* Register an extension point +/
 *  ep = g_io_extension_point_register ("my-extension-point");
 *  g_io_extension_point_set_required_type (ep, MY_TYPE_EXAMPLE);
 *  /+* Implement an extension point +/
 *  G_DEFINE_TYPE (MyExampleImpl, my_example_impl, MY_TYPE_EXAMPLE);
 *  g_io_extension_point_implement ("my-extension-point",
 *  my_example_impl_get_type (),
 *  "my-example",
 *  10);
 *  It is up to the code that registered the extension point how
 *  it uses the implementations that have been associated with it.
 *  Depending on the use case, it may use all implementations, or
 *  only the one with the highest priority, or pick a specific
 *  one by name.
 */
public class IOExtension
{
	
	/** the main Gtk struct */
	protected GIOExtension* gIOExtension;
	
	
	public GIOExtension* getIOExtensionStruct()
	{
		return gIOExtension;
	}
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct()
	{
		return cast(void*)gIOExtension;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GIOExtension* gIOExtension)
	{
		if(gIOExtension is null)
		{
			this = null;
			return;
		}
		this.gIOExtension = gIOExtension;
	}
	
	/**
	 */
	
	/**
	 * Gets the name under which extension was registered.
	 * Note that the same type may be registered as extension
	 * for multiple extension points, under different names.
	 * Returns: the name of extension.
	 */
	public string getName()
	{
		// const char * g_io_extension_get_name (GIOExtension *extension);
		return Str.toString(g_io_extension_get_name(gIOExtension));
	}
	
	/**
	 * Gets the priority with which extension was registered.
	 * Returns: the priority of extension
	 */
	public int getPriority()
	{
		// gint g_io_extension_get_priority (GIOExtension *extension);
		return g_io_extension_get_priority(gIOExtension);
	}
	
	/**
	 * Gets the type associated with extension.
	 * Returns: the type of extension
	 */
	public GType getType()
	{
		// GType g_io_extension_get_type (GIOExtension *extension);
		return g_io_extension_get_type(gIOExtension);
	}
	
	/**
	 * Gets a reference to the class for the type that is
	 * associated with extension.
	 * Returns: the GTypeClass for the type of extension
	 */
	public GTypeClass* refClass()
	{
		// GTypeClass* g_io_extension_ref_class (GIOExtension *extension);
		return g_io_extension_ref_class(gIOExtension);
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gio");
        } else version (DigitalMars) {
            pragma(link, "DD-gio");
        } else {
            pragma(link, "DO-gio");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gio");
        } else version (DigitalMars) {
            pragma(link, "DD-gio");
        } else {
            pragma(link, "DO-gio");
        }
    }
}
