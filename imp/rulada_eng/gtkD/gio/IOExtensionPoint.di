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
 * inFile  = 
 * outPack = gio
 * outFile = IOExtensionPoint
 * strct   = GIOExtensionPoint
 * realStrct=
 * ctorStrct=
 * clss    = IOExtensionPoint
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_io_extension_point_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ListG
 * 	- gtkD.gio.IOExtension
 * structWrap:
 * 	- GIOExtension* -> IOExtension
 * 	- GIOExtensionPoint* -> IOExtensionPoint
 * 	- GList* -> ListG
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.IOExtensionPoint;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.gio.IOExtension;




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
public class IOExtensionPoint
{
	
	/** the main Gtk struct */
	protected GIOExtensionPoint* gIOExtensionPoint;
	
	
	public GIOExtensionPoint* getIOExtensionPointStruct()
	{
		return gIOExtensionPoint;
	}
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct()
	{
		return cast(void*)gIOExtensionPoint;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GIOExtensionPoint* gIOExtensionPoint)
	{
		if(gIOExtensionPoint is null)
		{
			this = null;
			return;
		}
		this.gIOExtensionPoint = gIOExtensionPoint;
	}
	
	/**
	 */
	
	/**
	 * Finds a GIOExtension for an extension point by name.
	 * Params:
	 * name =  the name of the extension to get
	 * Returns: the GIOExtension for extension_point that has the given name, or NULL if there is no extension with that name
	 */
	public IOExtension getExtensionByName(string name)
	{
		// GIOExtension * g_io_extension_point_get_extension_by_name  (GIOExtensionPoint *extension_point,  const char *name);
		auto p = g_io_extension_point_get_extension_by_name(gIOExtensionPoint, Str.toStringz(name));
		if(p is null)
		{
			return null;
		}
		return new IOExtension(cast(GIOExtension*) p);
	}
	
	/**
	 * Gets a list of all extensions that implement this extension point.
	 * The list is sorted by priority, beginning with the highest priority.
	 * Returns: a GList of GIOExtensions. The list is owned by GIO and should not be modified
	 */
	public ListG getExtensions()
	{
		// GList * g_io_extension_point_get_extensions (GIOExtensionPoint *extension_point);
		auto p = g_io_extension_point_get_extensions(gIOExtensionPoint);
		if(p is null)
		{
			return null;
		}
		return new ListG(cast(GList*) p);
	}
	
	/**
	 * Gets the required type for extension_point.
	 * Returns: the GType that all implementations must have,  or G_TYPE_INVALID if the extension point has no required type
	 */
	public GType getRequiredType()
	{
		// GType g_io_extension_point_get_required_type  (GIOExtensionPoint *extension_point);
		return g_io_extension_point_get_required_type(gIOExtensionPoint);
	}
	
	/**
	 * Registers type as extension for the extension point with name
	 * extension_point_name.
	 * If type has already been registered as an extension for this
	 * extension point, the existing GIOExtension object is returned.
	 * Params:
	 * extensionPointName =  the name of the extension point
	 * type =  the GType to register as extension
	 * extensionName =  the name for the extension
	 * priority =  the priority for the extension
	 * Returns: a GIOExtension object for GType
	 */
	public static IOExtension implement(string extensionPointName, GType type, string extensionName, int priority)
	{
		// GIOExtension * g_io_extension_point_implement (const char *extension_point_name,  GType type,  const char *extension_name,  gint priority);
		auto p = g_io_extension_point_implement(Str.toStringz(extensionPointName), type, Str.toStringz(extensionName), priority);
		if(p is null)
		{
			return null;
		}
		return new IOExtension(cast(GIOExtension*) p);
	}
	
	/**
	 * Looks up an existing extension point.
	 * Params:
	 * name =  the name of the extension point
	 * Returns: the GIOExtensionPoint, or NULL if there is no registered extension point with the given name
	 */
	public static IOExtensionPoint lookup(string name)
	{
		// GIOExtensionPoint * g_io_extension_point_lookup (const char *name);
		auto p = g_io_extension_point_lookup(Str.toStringz(name));
		if(p is null)
		{
			return null;
		}
		return new IOExtensionPoint(cast(GIOExtensionPoint*) p);
	}
	
	/**
	 * Registers an extension point.
	 * Params:
	 * name =  The name of the extension point
	 * Returns: the new GIOExtensionPoint. This object is owned by GIO and should not be freed
	 */
	public static IOExtensionPoint register(string name)
	{
		// GIOExtensionPoint * g_io_extension_point_register (const char *name);
		auto p = g_io_extension_point_register(Str.toStringz(name));
		if(p is null)
		{
			return null;
		}
		return new IOExtensionPoint(cast(GIOExtensionPoint*) p);
	}
	
	/**
	 * Sets the required type for extension_point to type.
	 * All implementations must henceforth have this type.
	 * Params:
	 * type =  the GType to require
	 */
	public void setRequiredType(GType type)
	{
		// void g_io_extension_point_set_required_type  (GIOExtensionPoint *extension_point,  GType type);
		g_io_extension_point_set_required_type(gIOExtensionPoint, type);
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
