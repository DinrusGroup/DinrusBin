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
 * inFile  = gtk-Signals.html
 * outPack = gtk
 * outFile = Signals
 * strct   = 
 * realStrct=
 * ctorStrct=
 * clss    = Signals
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_signal_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gtk.ObjectGtk
 * structWrap:
 * 	- GtkObject* -> ObjectGtk
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.Signals;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.ObjectGtk;




/**
 * Description
 * The GTK+ signal system merely proxies the GLib signal system now. For future
 * usage, direct use of the GSignal API is recommended, this avoids significant
 * performance hits where GtkArg structures have to be converted into GValues.
 * What are signals?
 * Signals are a way to get notification when something happens
 * and to customize object behavior according to the
 * user's needs.
 * Every signal is uniquely identified by a name,
 * "class_name::signal_name", where signal_name might be something like
 * "clicked" and class_name might be "GtkButton". Note that some other class
 * may also define a "clicked" callback, so long as it doesn't derive from
 * GtkButton.
 * When they are created, they are also assigned a unique positive integer,
 * the signal id (1 is the first signal id- 0 is used to flag an error).
 * Each is also tied to an array of types that describes
 * the prototype of the function pointer(s) (handlers) you may
 * connect to the signal. Finally, every signal has
 * a default handler that is given by a function pointer
 * in its class structure: it is run by default whenever the
 * signal is emitted. (It is possible that a signal will
 * be emitted and a user-defined handler will prevent the default handler
 * from being run.)
 * Signals are used by everyone, but they are only
 * created on a per class basis -- so you should not call
 * call gtk_signal_new() unless you are writing
 * a new GtkObject type. However, if you want to make a new signal
 * for an existing type, you may use gtk_object_class_user_signal_new()
 * to create a signal that doesn't correspond to a class's builtin
 * methods.
 * <hr>
 * How are signals used?
 * There are two basic actions in the signal handling game.
 * If you want notification of an event, you must connect
 * a function pointer and a data pointer to that signal; the data pointer
 * will be passed as the last argument to the function (so long as you
 * are using the default marshalling functions).
 * You will receive a connection id, a unique positive integer
 * corresponding to that attachment.
 * Functions that want to notify the user of certain actions,
 * emit signals.
 * <hr>
 * Basic Terminology
 * signal
 * A class method, e.g. GtkButton::clicked.
 * More precisely it is a unique class-branch/signal-name pair.
 * This means you may not define a signal handler for a class which
 * derives from GtkButton that is called clicked,
 * but it is okay to share signals names if they are separate in
 * the class tree.
 * default handler
 * The object's internal method which is invoked
 * when the signal is emitted.
 * user-defined handler
 * A function pointer and data connected
 * to a signal (for a particular object).
 * There are really two types: those which are connected
 * normally, and those which are connected by one
 * of the connect_after functions. The connect_after handlers
 * are always run after the default handler.
 * Many toolkits refer to these as callbacks.
 * emission
 * the whole process of emitting a signal,
 * including the invocation of all
 * the different handler types mentioned above.
 * signal id
 * The unique positive (nonzero) integer
 * used to identify a signal. It can be used instead of
 * a name to many functions for a slight performance
 * improvement.
 * connection id
 * The unique positive (nonzero) integer
 * used to identify the connection of a user-defined handler
 * to a signal. Notice that it is allowed to connect the
 * same function-pointer/user-data pair twice, so
 * there is no guarantee that a function-pointer/user-data
 * maps to a unique connection id.
 * <hr>
 * A brief note on how they work.
 * The functions responsible for translating an array of GtkArgs
 * to your C compiler's normal semantics are called Marshallers.
 * They are identified by
 * gtk_marshal_return_value__parameter_list()
 * for example a C function returning a gboolean and taking a gint
 * can be invoked by using gtk_marshal_BOOL__INT().
 * Not all possibly combinations of return/params are available,
 * of course, so if you are writing a GtkObject with parameters
 * you might have to write a marshaller.
 */
public class Signals
{
	
	/**
	 */
	
	/**
	 * Warning
	 * gtk_signal_newv is deprecated and should not be used in newly-written code. Use g_signal_newv() instead.
	 * Creates a new signal type. (This is usually done in a
	 * class initializer.)
	 * This function take the types as an array, instead of a list
	 * following the arguments. Otherwise the same as gtk_signal_new().
	 * Params:
	 * name = the name of the signal to create.
	 * signalFlags = see gtk_signal_new().
	 * objectType = the type of GtkObject to associate the signal with.
	 * functionOffset = how many bytes the function pointer is in
	 * the class structure for this type.
	 * returnVal = the type of the return value, or GTK_TYPE_NONE if
	 * you don't want a return value.
	 * args = an array of GtkTypes, describing the prototype to
	 * the callbacks.
	 * Returns:the signal id.
	 */
	public static uint newv(string name, GtkSignalRunType signalFlags, GType objectType, uint functionOffset, GSignalCMarshaller marshaller, GType returnVal, GType[] args)
	{
		// guint gtk_signal_newv (const gchar *name,  GtkSignalRunType signal_flags,  GType object_type,  guint function_offset,  GSignalCMarshaller marshaller,  GType return_val,  guint n_args,  GType *args);
		return gtk_signal_newv(Str.toStringz(name), signalFlags, objectType, functionOffset, marshaller, returnVal, args.length, args.ptr);
	}
	
	/**
	 * Warning
	 * gtk_signal_emitv is deprecated and should not be used in newly-written code. Use g_signal_emitv() instead.
	 * Emits a signal. This causes the default handler and user-connected
	 * handlers to be run. This differs from gtk_signal_emit() by taking
	 * an array of GtkArgs instead of using C's varargs mechanism.
	 * Params:
	 * object = the object to emit the signal to.
	 * signalId = the signal identifier.
	 * args = an array of GtkArgs, one for each parameter,
	 * followed by one which is a pointer to the return type.
	 */
	public static void emitv(ObjectGtk object, uint signalId, GtkArg[] args)
	{
		// void gtk_signal_emitv (GtkObject *object,  guint signal_id,  GtkArg *args);
		gtk_signal_emitv((object is null) ? null : object.getObjectGtkStruct(), signalId, args.ptr);
	}
	
	/**
	 * Warning
	 * gtk_signal_emitv_by_name is deprecated and should not be used in newly-written code. Use g_signal_emitv() and g_signal_lookup() instead.
	 * Emits a signal by name. This causes the default handler and user-connected
	 * handlers to be run. This differs from gtk_signal_emit() by taking
	 * an array of GtkArgs instead of using C's varargs mechanism.
	 * Params:
	 * object = the object to emit the signal to.
	 * name = the name of the signal.
	 * args = an array of GtkArgs, one for each parameter,
	 * followed by one which is a pointer to the return type.
	 */
	public static void emitvByName(ObjectGtk object, string name, GtkArg[] args)
	{
		// void gtk_signal_emitv_by_name (GtkObject *object,  const gchar *name,  GtkArg *args);
		gtk_signal_emitv_by_name((object is null) ? null : object.getObjectGtkStruct(), Str.toStringz(name), args.ptr);
	}
	
	/**
	 * Warning
	 * gtk_signal_emit_stop_by_name is deprecated and should not be used in newly-written code. Use g_signal_stop_emission_by_name() instead.
	 * This function aborts a signal's current emission.
	 * It is just like gtk_signal_emit_stop()
	 * except it will lookup the signal id for you.
	 * Params:
	 * object = the object whose signal handlers you wish to stop.
	 * name = the name of the signal you wish to stop.
	 */
	public static void emitStopByName(ObjectGtk object, string name)
	{
		// void gtk_signal_emit_stop_by_name (GtkObject *object,  const gchar *name);
		gtk_signal_emit_stop_by_name((object is null) ? null : object.getObjectGtkStruct(), Str.toStringz(name));
	}
	
	/**
	 * Warning
	 * gtk_signal_connect_full is deprecated and should not be used in newly-written code. Use g_signal_connect_data() instead.
	 * Attaches a function pointer and user data to a signal with
	 * more control.
	 * Params:
	 * object = the object which emits the signal. For example, a button
	 * in the button press signal.
	 * name = the name of the signal.
	 * func = function pointer to attach to the signal.
	 * data = the user data associated with the function.
	 * destroyFunc = function to call when this particular hook is
	 * disconnected.
	 * objectSignal = whether this is an object signal-- basically an "object
	 * signal" is one that wants its user_data and object fields switched,
	 * which is useful for calling functions which operate on another
	 * object primarily.
	 * after = whether to invoke the user-defined handler after the signal, or to let
	 * the signal's default behavior preside (i.e. depending on GTK_RUN_FIRST
	 * and GTK_RUN_LAST).
	 * Returns:the connection id.
	 */
	public static uint connectFull(ObjectGtk object, string name, GCallback func, GtkCallbackMarshal unsupported, void* data, GDestroyNotify destroyFunc, int objectSignal, int after)
	{
		// gulong gtk_signal_connect_full (GtkObject *object,  const gchar *name,  GCallback func,  GtkCallbackMarshal unsupported,  gpointer data,  GDestroyNotify destroy_func,  gint object_signal,  gint after);
		return gtk_signal_connect_full((object is null) ? null : object.getObjectGtkStruct(), Str.toStringz(name), func, unsupported, data, destroyFunc, objectSignal, after);
	}
	
	/**
	 * Warning
	 * gtk_signal_connect_while_alive is deprecated and should not be used in newly-written code. Use g_signal_connect_object() instead.
	 * Attaches a function pointer and another GtkObject to a signal.
	 * This function takes an object whose "destroy" signal
	 * should be trapped.
	 * That way, you don't have to clean up the
	 * signal handler when you destroy the object.
	 * It is a little less efficient though.
	 * (Instead you may call gtk_signal_disconnect_by_data(), if you want
	 * to explicitly delete all attachments to this object. This
	 * is perhaps not recommended since it could be confused
	 * with an integer masquerading as a pointer (through GINT_TO_POINTER()).)
	 * Params:
	 * object = the object that emits the signal.
	 * name = name of the signal.
	 * func = function pointer to attach to the signal.
	 * funcData = pointer to pass to func.
	 * aliveObject = object whose death should cause the handler connection
	 * to be destroyed.
	 */
	public static void connectWhileAlive(ObjectGtk object, string name, GCallback func, void* funcData, ObjectGtk aliveObject)
	{
		// void gtk_signal_connect_while_alive (GtkObject *object,  const gchar *name,  GCallback func,  gpointer func_data,  GtkObject *alive_object);
		gtk_signal_connect_while_alive((object is null) ? null : object.getObjectGtkStruct(), Str.toStringz(name), func, funcData, (aliveObject is null) ? null : aliveObject.getObjectGtkStruct());
	}
	
	/**
	 * Warning
	 * gtk_signal_connect_object_while_alive is deprecated and should not be used in newly-written code. Use g_signal_connect_object() instead, passing
	 * G_CONNECT_SWAPPED as connect_flags.
	 * These signal connectors are for signals which refer to objects,
	 * so they must not be called after the object is deleted.
	 * Unlike gtk_signal_connect_while_alive(),
	 * this swaps the object and user data, making it suitable for
	 * use with functions which primarily operate on the user data.
	 * This function acts just like gtk_signal_connect_object() except
	 * it traps the "destroy" signal to prevent you from having to
	 * clean up the handler.
	 * Params:
	 * object = the object associated with the signal.
	 * name = name of the signal.
	 * func = function pointer to attach to the signal.
	 * aliveObject = the user data, which must be an object, whose destruction
	 * should signal the removal of this signal.
	 */
	public static void connectObjectWhileAlive(ObjectGtk object, string name, GCallback func, ObjectGtk aliveObject)
	{
		// void gtk_signal_connect_object_while_alive  (GtkObject *object,  const gchar *name,  GCallback func,  GtkObject *alive_object);
		gtk_signal_connect_object_while_alive((object is null) ? null : object.getObjectGtkStruct(), Str.toStringz(name), func, (aliveObject is null) ? null : aliveObject.getObjectGtkStruct());
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
