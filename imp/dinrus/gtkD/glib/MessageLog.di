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
 * inFile  = glib-Message-Logging.html
 * outPack = glib
 * outFile = MessageLog
 * strct   = 
 * realStrct=
 * ctorStrct=
 * clss    = MessageLog
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_
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

module gtkD.glib.MessageLog;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * These functions provide support for logging error messages or messages
 * used for debugging.
 * There are several built-in levels of messages, defined in GLogLevelFlags.
 * These can be extended with user-defined levels.
 */
public class MessageLog
{
	
	/**
	 */
	
	/**
	 * Logs an error or debugging message.
	 * If the log level has been set as fatal, the abort()
	 * function is called to terminate the program.
	 * Params:
	 * logDomain = the log domain.
	 * logLevel = the log level.
	 * format = the message format. See the printf()
	 * documentation.
	 * args = the parameters to insert into the format string.
	 */
	public static void logv(string logDomain, GLogLevelFlags logLevel, string format, void* args)
	{
		// void g_logv (const gchar *log_domain,  GLogLevelFlags log_level,  const gchar *format,  va_list args);
		g_logv(Str.toStringz(logDomain), logLevel, Str.toStringz(format), args);
	}
	
	/**
	 * Sets the log handler for a domain and a set of log levels.
	 * To handle fatal and recursive messages the log_levels parameter
	 * must be combined with the G_LOG_FLAG_FATAL and G_LOG_FLAG_RECURSION
	 * bit flags.
	 * Note that since the G_LOG_LEVEL_ERROR log level is always fatal, if
	 * you want to set a handler for this log level you must combine it with
	 * G_LOG_FLAG_FATAL.
	 * Example 12. Adding a log handler for all warning messages in the default
	 * (application) domain
	 *  g_log_set_handler (NULL, G_LOG_LEVEL_WARNING | G_LOG_FLAG_FATAL
	 *  | G_LOG_FLAG_RECURSION, my_log_handler, NULL);
	 * Example 13. Adding a log handler for all critical messages from GTK+
	 *  g_log_set_handler ("Gtk", G_LOG_LEVEL_CRITICAL | G_LOG_FLAG_FATAL
	 *  | G_LOG_FLAG_RECURSION, my_log_handler, NULL);
	 * Example 14. Adding a log handler for all messages from
	 * GLib
	 *  g_log_set_handler ("GLib", G_LOG_LEVEL_MASK | G_LOG_FLAG_FATAL
	 *  | G_LOG_FLAG_RECURSION, my_log_handler, NULL);
	 * Params:
	 * logDomain = the log domain, or NULL for the default "" application domain.
	 * logLevels = the log levels to apply the log handler for. To handle fatal
	 * and recursive messages as well, combine the log levels with the
	 * G_LOG_FLAG_FATAL and G_LOG_FLAG_RECURSION bit flags.
	 * logFunc = the log handler function.
	 * userData = data passed to the log handler.
	 * Returns:the id of the new handler.
	 */
	public static uint logSetHandler(string logDomain, GLogLevelFlags logLevels, GLogFunc logFunc, void* userData)
	{
		// guint g_log_set_handler (const gchar *log_domain,  GLogLevelFlags log_levels,  GLogFunc log_func,  gpointer user_data);
		return g_log_set_handler(Str.toStringz(logDomain), logLevels, logFunc, userData);
	}
	
	/**
	 * Removes the log handler.
	 * Params:
	 * logDomain = the log domain.
	 * handlerId = the id of the handler, which was returned in g_log_set_handler().
	 */
	public static void logRemoveHandler(string logDomain, uint handlerId)
	{
		// void g_log_remove_handler (const gchar *log_domain,  guint handler_id);
		g_log_remove_handler(Str.toStringz(logDomain), handlerId);
	}
	
	/**
	 * Sets the message levels which are always fatal, in any log domain.
	 * When a message with any of these levels is logged the program terminates.
	 * You can only set the levels defined by GLib to be fatal.
	 * G_LOG_LEVEL_ERROR is always fatal.
	 * You can also make some message levels
	 * fatal at runtime by setting the G_DEBUG environment variable (see
	 * Running GLib Applications).
	 * Params:
	 * fatalMask = the mask containing bits set for each level of error which is
	 * to be fatal.
	 * Returns:the old fatal mask.
	 */
	public static GLogLevelFlags logSetAlwaysFatal(GLogLevelFlags fatalMask)
	{
		// GLogLevelFlags g_log_set_always_fatal (GLogLevelFlags fatal_mask);
		return g_log_set_always_fatal(fatalMask);
	}
	
	/**
	 * Sets the log levels which are fatal in the given domain.
	 * G_LOG_LEVEL_ERROR is always fatal.
	 * Params:
	 * logDomain = the log domain.
	 * fatalMask = the new fatal mask.
	 * Returns:the old fatal mask for the log domain.
	 */
	public static GLogLevelFlags logSetFatalMask(string logDomain, GLogLevelFlags fatalMask)
	{
		// GLogLevelFlags g_log_set_fatal_mask (const gchar *log_domain,  GLogLevelFlags fatal_mask);
		return g_log_set_fatal_mask(Str.toStringz(logDomain), fatalMask);
	}
	
	/**
	 * The default log handler set up by GLib; g_log_set_default_handler()
	 * allows to install an alternate default log handler.
	 * This is used if no log handler has been set for the particular log domain
	 * and log level combination. It outputs the message to stderr or stdout
	 * and if the log level is fatal it calls abort().
	 * stderr is used for levels G_LOG_LEVEL_ERROR, G_LOG_LEVEL_CRITICAL,
	 * G_LOG_LEVEL_WARNING and G_LOG_LEVEL_MESSAGE. stdout is used for the rest.
	 * Params:
	 * logDomain = the log domain of the message.
	 * logLevel = the level of the message.
	 * message = the message.
	 * unusedData = data passed from g_log() which is unused.
	 */
	public static void logDefaultHandler(string logDomain, GLogLevelFlags logLevel, string message, void* unusedData)
	{
		// void g_log_default_handler (const gchar *log_domain,  GLogLevelFlags log_level,  const gchar *message,  gpointer unused_data);
		g_log_default_handler(Str.toStringz(logDomain), logLevel, Str.toStringz(message), unusedData);
	}
	
	/**
	 * Installs a default log handler which is used if no
	 * log handler has been set for the particular log domain
	 * and log level combination. By default, GLib uses
	 * g_log_default_handler() as default log handler.
	 * Since 2.6
	 * Params:
	 * logFunc = the log handler function.
	 * userData = data passed to the log handler.
	 * Returns:the previous default log handler
	 */
	public static GLogFunc logSetDefaultHandler(GLogFunc logFunc, void* userData)
	{
		// GLogFunc g_log_set_default_handler (GLogFunc log_func,  gpointer user_data);
		return g_log_set_default_handler(logFunc, userData);
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-glib");
        } else version (DigitalMars) {
            pragma(link, "DD-glib");
        } else {
            pragma(link, "DO-glib");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-glib");
        } else version (DigitalMars) {
            pragma(link, "DD-glib");
        } else {
            pragma(link, "DO-glib");
        }
    }
}
