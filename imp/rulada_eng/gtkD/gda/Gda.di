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
 * inFile  = libgda-libgtkD.gda.html
 * outPack = gda
 * outFile = Gda
 * strct   = 
 * realStrct=
 * ctorStrct=
 * clss    = Gda
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gda_
 * omit structs:
 * omit prefixes:
 * omit code:
 * 	- gda_init
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.HashTable
 * 	- gtkD.glib.ListG
 * 	- gtkD.gda.ParameterList
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gda.Gda;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.HashTable;
private import gtkD.glib.ListG;
private import gtkD.gda.ParameterList;




/**
 * Description
 */
public class Gda
{
	
	/**
	 * Initializes the GDA library.
	 * Params:
	 *  appId = name of the program.
	 *  version = revision number of the program.
	 *  args = args from main().
	 */
	public static void init(string appId, string versio, string[] args)
	{
		// void gda_init (const gchar *app_id,  const gchar *version,  gint nargs,  gchar *args[]);
		gchar*[] argv = (new char*[args.length]);
		int argc = 0;
		foreach (string p; args)
		{
			argv[argc++] = cast(gchar*)p;
		}
		
		gda_init(Str.toStringz(appId), Str.toStringz(versio), argc, argv);
	}
	
	/**
	 * Description
	 */
	
	/**
	 * Runs the GDA main loop, which is nothing more than the Bonobo main
	 * loop, but with internally added stuff specific for applications using
	 * libgtkD.gda.
	 * You can specify a function to be called after everything has been correctly
	 * initialized (that is, for initializing your own stuff).
	 * Params:
	 * initFunc =  function to be called when everything has been initialized.
	 * userData =  data to be passed to the init function.
	 */
	public static void mainRun(GdaInitFunc initFunc, void* userData)
	{
		// void gda_main_run (GdaInitFunc init_func,  gpointer user_data);
		gda_main_run(initFunc, userData);
	}
	
	/**
	 * Exits the main loop.
	 */
	public static void mainQuit()
	{
		// void gda_main_quit (void);
		gda_main_quit();
	}
	
	/**
	 * Params:
	 * type =  Type to convert from.
	 * Returns: the string representing the given GdaValueType.This is not necessarily the same string used to describe the column type in a SQL statement.Use gda_connection_get_schema() with GDA_CONNECTION_SCHEMA_TYPES to get the actual types supported by the provider.
	 */
	public static string typeToString(GdaValueType type)
	{
		// const gchar* gda_type_to_string (GdaValueType type);
		return Str.toString(gda_type_to_string(type));
	}
	
	/**
	 * Params:
	 * str =  the name of a GdaValueType, as returned by gda_type_to_string().
	 * Returns: the GdaValueType represented by the given str.
	 */
	public static GdaValueType typeFromString(string str)
	{
		// GdaValueType gda_type_from_string (const gchar *str);
		return gda_type_from_string(Str.toStringz(str));
	}
	
	/**
	 * Creates a new list of strings, which contains all keys of a given hash
	 * table. After using it, you should free this list by calling g_list_free.
	 * Params:
	 * hashTable =  a hash table.
	 * Returns: a new GList.
	 */
	public static ListG stringHashToList(HashTable hashTable)
	{
		// GList* gda_string_hash_to_list (GHashTable *hash_table);
		auto p = gda_string_hash_to_list((hashTable is null) ? null : hashTable.getHashTableStruct());
		if(p is null)
		{
			return null;
		}
		return new ListG(cast(GList*) p);
	}
	
	/**
	 * Replaces the placeholders (:name) in the given SQL command with
	 * the values from the GdaParameterList specified as the params
	 * argument.
	 * Params:
	 * sql =  a SQL command containing placeholders for values.
	 * params =  a list of values for the placeholders.
	 * Returns: the SQL string with all placeholders replaced, or NULLon error. On success, the returned string must be freed by the callerwhen no longer needed.
	 */
	public static string sqlReplacePlaceholders(string sql, ParameterList params)
	{
		// gchar* gda_sql_replace_placeholders (const gchar *sql,  GdaParameterList *params);
		return Str.toString(gda_sql_replace_placeholders(Str.toStringz(sql), (params is null) ? null : params.getParameterListStruct()));
	}
	
	/**
	 * Loads a file, specified by the given uri, and returns the file
	 * contents as a string.
	 * It is the caller's responsibility to free the returned value.
	 * Params:
	 * filename =  path for the file to be loaded.
	 * Returns: the file contents as a newly-allocated string, or NULLif there is an error.
	 */
	public static string fileLoad(string filename)
	{
		// gchar* gda_file_load (const gchar *filename);
		return Str.toString(gda_file_load(Str.toStringz(filename)));
	}
	
	/**
	 * Saves a chunk of data into a file.
	 * Params:
	 * filename =  path for the file to be saved.
	 * buffer =  contents of the file.
	 * len =  size of buffer.
	 * Returns: TRUE if successful, FALSE on error.
	 */
	public static int fileSave(string filename, string buffer, int len)
	{
		// gboolean gda_file_save (const gchar *filename,  const gchar *buffer,  gint len);
		return gda_file_save(Str.toStringz(filename), Str.toStringz(buffer), len);
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gda");
        } else version (DigitalMars) {
            pragma(link, "DD-gda");
        } else {
            pragma(link, "DO-gda");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gda");
        } else version (DigitalMars) {
            pragma(link, "DD-gda");
        } else {
            pragma(link, "DO-gda");
        }
    }
}
