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
 * inFile  = glib-Shell-related-Utilities.html
 * outPack = glib
 * outFile = ShellUtils
 * strct   = 
 * realStrct=
 * ctorStrct=
 * clss    = ShellUtils
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_shell_
 * omit structs:
 * omit prefixes:
 * omit code:
 * 	- g_shell_parse_argv
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ErrorG
 * 	- gtkD.glib.GException
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.glib.ShellUtils;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;




/**
 * Description
 */
public class ShellUtils
{
	
	/**
	 * Parses a command line into an argument vector, in much the same way
	 * the shell would, but without many of the expansions the shell would
	 * perform (variable expansion, globs, operators, filename expansion,
	 * etc. are not supported). The results are defined to be the same as
	 * those you would get from a UNIX98 /bin/sh, as long as the input
	 * contains none of the unsupported shell expansions. If the input
	 * does contain such expansions, they are passed through
	 * literally. Possible errors are those from the G_SHELL_ERROR
	 * domain. Free the returned vector with g_strfreev().
	 * Params:
	 * commandLine =  command line to parse
	 * argcp =  return location for number of args
	 * argvp =  return location for array of args
	 * Returns: TRUE on success, FALSE if error set
	 * Throws: GException on failure.
	 */
	public static int parseArgv(string commandLine, out int argcp, out string[] argvp)
	{
		// gboolean g_shell_parse_argv (const gchar *command_line,  gint *argcp,  gchar ***argvp,  GError **error);
		GError* err = null;
		char** arg = null;
		
		auto p = g_shell_parse_argv(Str.toStringz(commandLine), &argcp, &arg, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		argvp = Str.toStringArray(arg);
		return p;
	}
	
	/**
	 */
	
	/**
	 * Quotes a string so that the shell (/bin/sh) will interpret the
	 * quoted string to mean unquoted_string. If you pass a filename to
	 * the shell, for example, you should first quote it with this
	 * function. The return value must be freed with g_free(). The
	 * quoting style used is undefined (single or double quotes may be
	 * used).
	 * Params:
	 * unquotedString =  a literal string
	 * Returns: quoted string
	 */
	public static string quote(string unquotedString)
	{
		// gchar* g_shell_quote (const gchar *unquoted_string);
		return Str.toString(g_shell_quote(Str.toStringz(unquotedString)));
	}
	
	/**
	 * Unquotes a string as the shell (/bin/sh) would. Only handles
	 * quotes; if a string contains file globs, arithmetic operators,
	 * variables, backticks, redirections, or other special-to-the-shell
	 * features, the result will be different from the result a real shell
	 * would produce (the variables, backticks, etc. will be passed
	 * through literally instead of being expanded). This function is
	 * guaranteed to succeed if applied to the result of
	 * g_shell_quote(). If it fails, it returns NULL and sets the
	 * error. The quoted_string need not actually contain quoted or
	 * escaped text; g_shell_unquote() simply goes through the string and
	 * unquotes/unescapes anything that the shell would. Both single and
	 * double quotes are handled, as are escapes including escaped
	 * newlines. The return value must be freed with g_free(). Possible
	 * errors are in the G_SHELL_ERROR domain.
	 * Shell quoting rules are a bit strange. Single quotes preserve the
	 * literal string exactly. escape sequences are not allowed; not even
	 * \' - if you want a ' in the quoted text, you have to do something
	 * like 'foo'\''bar'. Double quotes allow $, `, ", \, and newline to
	 * be escaped with backslash. Otherwise double quotes preserve things
	 * literally.
	 * Params:
	 * quotedString =  shell-quoted string
	 * Returns: an unquoted string
	 * Throws: GException on failure.
	 */
	public static string unquote(string quotedString)
	{
		// gchar* g_shell_unquote (const gchar *quoted_string,  GError **error);
		GError* err = null;
		
		auto p = Str.toString(g_shell_unquote(Str.toStringz(quotedString), &err));
		
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
