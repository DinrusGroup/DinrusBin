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
 * inFile  = GInitable.html
 * outPack = gio
 * outFile = InitableT
 * strct   = GInitable
 * realStrct=
 * ctorStrct=
 * clss    = InitableT
 * interf  = InitableIF
 * class Code: No
 * interface Code: No
 * template for:
 * 	- TStruct
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_initable_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ErrorG
 * 	- gtkD.glib.GException
 * 	- gtkD.gobject.ObjectG
 * 	- gtkD.gio.Cancellable
 * structWrap:
 * 	- GCancellable* -> Cancellable
 * 	- GObject* -> ObjectG
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.InitableT;

public  import gtkD.gtkc.giotypes;

public import gtkD.gtkc.gio;
public import gtkD.glib.ConstructionException;


public import gtkD.glib.Str;
public import gtkD.glib.ErrorG;
public import gtkD.glib.GException;
public import gtkD.gobject.ObjectG;
public import gtkD.gio.Cancellable;




/**
 * Description
 * GInitable is implemented by objects that can fail during
 * initialization. If an object implements this interface the
 * g_initable_init() function must be called as the first thing
 * after construction. If g_initable_init() is not called, or if
 * it returns an error, all further operations on the object
 * should fail, generally with a G_IO_ERROR_NOT_INITIALIZED error.
 * Users of objects implementing this are not intended to use
 * the interface method directly, instead it will be used automatically
 * in various ways. For C applications you generally just call
 * g_initable_new() directly, or indirectly via a foo_thing_new() wrapper.
 * This will call g_initable_init() under the cover, returning NULL and
 * setting a GError on failure.
 * For bindings in languages where the native constructor supports
 * exceptions the binding could check for objects implemention GInitable
 * during normal construction and automatically initialize them, throwing
 * an exception on failure.
 */
public template InitableT(TStruct)
{
	
	/** the main Gtk struct */
	protected GInitable* gInitable;
	
	
	public GInitable* getInitableTStruct()
	{
		return cast(GInitable*)getStruct();
	}
	
	
	/**
	 */
	
	/**
	 * Initializes the object implementing the interface. This must be
	 * done before any real use of the object after initial construction.
	 * Implementations may also support cancellation. If cancellable is not NULL,
	 * then initialization can be cancelled by triggering the cancellable object
	 * from another thread. If the operation was cancelled, the error
	 * G_IO_ERROR_CANCELLED will be returned. If cancellable is not NULL and
	 * the object doesn't support cancellable initialization the error
	 * G_IO_ERROR_NOT_SUPPORTED will be returned.
	 * If this function is not called, or returns with an error then all
	 * operations on the object should fail, generally returning the
	 * error G_IO_ERROR_NOT_INITIALIZED.
	 * Implementations of this method must be idempotent, i.e. multiple calls
	 * to this function with the same argument should return the same results.
	 * Only the first call initializes the object, further calls return the result
	 * of the first call. This is so that its safe to implement the singleton
	 * pattern in the GObject constructor function.
	 * Since 2.22
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if successful. If an error has occurred, this function will return FALSE and set error appropriately if present.
	 * Throws: GException on failure.
	 */
	public int init(Cancellable cancellable)
	{
		// gboolean g_initable_init (GInitable *initable,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_initable_init(getInitableTStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Helper function for constructing GInitiable object. This is
	 * similar to g_object_new_valist() but also initializes the object
	 * and returns NULL, setting an error on failure.
	 * Since 2.22
	 * Params:
	 * objectType =  a GType supporting GInitable.
	 * firstPropertyName =  the name of the first property, followed by
	 * the value, and other property value pairs, and ended by NULL.
	 * varArgs =  The var args list generated from first_property_name.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a newly allocated GObject, or NULL on error
	 * Throws: GException on failure.
	 */
	public static ObjectG newValist(GType objectType, string firstPropertyName, void* varArgs, Cancellable cancellable)
	{
		// GObject* g_initable_new_valist (GType object_type,  const gchar *first_property_name,  va_list var_args,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_initable_new_valist(objectType, Str.toStringz(firstPropertyName), varArgs, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			return null;
		}
		return new ObjectG(cast(GObject*) p);
	}
	
	/**
	 * Helper function for constructing GInitiable object. This is
	 * similar to g_object_newv() but also initializes the object
	 * and returns NULL, setting an error on failure.
	 * Since 2.22
	 * Params:
	 * objectType =  a GType supporting GInitable.
	 * parameters =  the parameters to use to construct the object
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a newly allocated GObject, or NULL on error
	 * Throws: GException on failure.
	 */
	public static void* newv(GType objectType, GParameter[] parameters, Cancellable cancellable)
	{
		// gpointer g_initable_newv (GType object_type,  guint n_parameters,  GParameter *parameters,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_initable_newv(objectType, parameters.length, parameters.ptr, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
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
