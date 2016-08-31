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
 * inFile  = glib-I18N.html
 * outPack = glib
 * outFile = Internationalization
 * strct   = 
 * realStrct=
 * ctorStrct=
 * clss    = Internationalization
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

module gtkD.glib.Internationalization;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * GLib doesn't force any particular localization method upon its users.
 * But since GLib itself is localized using the gettext() mechanism, it seems
 * natural to offer the de-facto standard gettext() support macros in an
 * easy-to-use form.
 * In order to use these macros in an application, you must include
 * glib/gi18n.h. For use in a library, must include
 * glib/gi18n-lib.h after defining
 * the GETTEXT_PACKAGE macro suitably for your library:
 * #define GETTEXT_PACKAGE "gtk20"
 * #include <glib/gi18n-lib.h>
 * The gettext manual covers details of how to set up message extraction
 * with xgettext.
 */
public class Internationalization
{
	
	/**
	 */
	
	/**
	 * This function is a wrapper of dgettext() which does not translate
	 * the message if the default domain as set with textdomain() has no
	 * translations for the current locale.
	 * The advantage of using this function over dgettext() proper is that
	 * libraries using this function (like GTK+) will not use translations
	 * if the application using the library does not have translations for
	 * the current locale. This results in a consistent English-only
	 * interface instead of one having partial translations. For this
	 * feature to work, the call to textdomain() and setlocale() should
	 * precede any g_dgettext() invocations. For GTK+, it means calling
	 * textdomain() before gtk_init or its variants.
	 * This function disables translations if and only if upon its first
	 * Since 2.18
	 * Params:
	 * domain =  the translation domain to use, or NULL to use
	 *  the domain set with textdomain()
	 * msgid =  message to translate
	 * Returns: The translated string
	 */
	public static string dgettext(string domain, string msgid)
	{
		// const gchar * g_dgettext (const gchar *domain,  const gchar *msgid);
		return Str.toString(g_dgettext(Str.toStringz(domain), Str.toStringz(msgid)));
	}
	
	/**
	 * This function is a wrapper of dngettext() which does not translate
	 * the message if the default domain as set with textdomain() has no
	 * translations for the current locale.
	 * See g_dgettext() for details of how this differs from dngettext()
	 * proper.
	 * Since 2.18
	 * Params:
	 * domain =  the translation domain to use, or NULL to use
	 *  the domain set with textdomain()
	 * msgid =  message to translate
	 * msgidPlural =  plural form of the message
	 * n =  the quantity for which translation is needed
	 * Returns: The translated string
	 */
	public static string dngettext(string domain, string msgid, string msgidPlural, uint n)
	{
		// const gchar * g_dngettext (const gchar *domain,  const gchar *msgid,  const gchar *msgid_plural,  gulong n);
		return Str.toString(g_dngettext(Str.toStringz(domain), Str.toStringz(msgid), Str.toStringz(msgidPlural), n));
	}
	
	/**
	 * This function is a variant of g_dgettext() which supports
	 * a disambiguating message context. GNU gettext uses the
	 * '\004' character to separate the message context and
	 * message id in msgctxtid.
	 * If 0 is passed as msgidoffset, this function will fall back to
	 * trying to use the deprecated convention of using "|" as a separation
	 * character.
	 * This uses g_dgettext() internally. See that functions for differences
	 * with dgettext() proper.
	 * Applications should normally not use this function directly,
	 * but use the C_() macro for translations with context.
	 * Since 2.16
	 * Params:
	 * domain =  the translation domain to use, or NULL to use
	 *  the domain set with textdomain()
	 * msgctxtid =  a combined message context and message id, separated
	 *  by a \004 character
	 * msgidoffset =  the offset of the message id in msgctxid
	 * Returns: The translated string
	 */
	public static string dpgettext(string domain, string msgctxtid, uint msgidoffset)
	{
		// const gchar * g_dpgettext (const gchar *domain,  const gchar *msgctxtid,  gsize msgidoffset);
		return Str.toString(g_dpgettext(Str.toStringz(domain), Str.toStringz(msgctxtid), msgidoffset));
	}
	
	/**
	 * This function is a variant of g_dgettext() which supports
	 * a disambiguating message context. GNU gettext uses the
	 * '\004' character to separate the message context and
	 * message id in msgctxtid.
	 * This uses g_dgettext() internally. See that functions for differences
	 * with dgettext() proper.
	 * This function differs from C_() in that it is not a macro and
	 * thus you may use non-string-literals as context and msgid arguments.
	 * Since 2.18
	 * Params:
	 * domain =  the translation domain to use, or NULL to use
	 *  the domain set with textdomain()
	 * context =  the message context
	 * msgid =  the message
	 * Returns: The translated string
	 */
	public static string dpgettext2(string domain, string context, string msgid)
	{
		// const gchar * g_dpgettext2 (const gchar *domain,  const gchar *context,  const gchar *msgid);
		return Str.toString(g_dpgettext2(Str.toStringz(domain), Str.toStringz(context), Str.toStringz(msgid)));
	}
	
	/**
	 * An auxiliary function for gettext() support (see Q_()).
	 * Since 2.4
	 * Params:
	 * msgid =  a string
	 * msgval =  another string
	 * Returns: msgval, unless msgval is identical to msgid and contains a '|' character, in which case a pointer to the substring of msgid after the first '|' character is returned.
	 */
	public static string stripContext(string msgid, string msgval)
	{
		// const gchar * g_strip_context (const gchar *msgid,  const gchar *msgval);
		return Str.toString(g_strip_context(Str.toStringz(msgid), Str.toStringz(msgval)));
	}
	
	/**
	 * Computes a list of applicable locale names, which can be used to
	 * e.g. construct locale-dependent filenames or search paths. The returned
	 * list is sorted from most desirable to least desirable and always contains
	 * the default locale "C".
	 * For example, if LANGUAGE=de:en_US, then the returned list is
	 * "de", "en_US", "en", "C".
	 * This function consults the environment variables LANGUAGE,
	 * LC_ALL, LC_MESSAGES and LANG
	 * to find the list of locales specified by the user.
	 * Since 2.6
	 * Returns: a NULL-terminated array of strings owned by GLib  that must not be modified or freed.
	 */
	public static string[] getLanguageNames()
	{
		// const gchar* const * g_get_language_names (void);
		return Str.toStringArray(g_get_language_names());
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
