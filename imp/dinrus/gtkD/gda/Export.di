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
 * inFile  = libgda-GdaExport.html
 * outPack = gda
 * outFile = Export
 * strct   = GdaExport
 * realStrct=
 * ctorStrct=
 * clss    = Export
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = GObject
 * implements:
 * prefixes:
 * 	- gda_export_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ListG
 * 	- gtkD.gda.Connection
 * structWrap:
 * 	- GList* -> ListG
 * 	- GdaConnection* -> Connection
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gda.Export;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.gda.Connection;



private import gtkD.gobject.ObjectG;

/**
 * Description
 */
public class Export : ObjectG
{
	
	/** the main Gtk struct */
	protected GdaExport* gdaExport;
	
	
	public GdaExport* getExportStruct()
	{
		return gdaExport;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gdaExport;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaExport* gdaExport)
	{
		if(gdaExport is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gdaExport);
		if( ptr !is null )
		{
			this = cast(Export)ptr;
			return;
		}
		super(cast(GObject*)gdaExport);
		this.gdaExport = gdaExport;
	}
	
	/**
	 */
	
	/**
	 * Creates a new GdaExport object, which allows you to easily add
	 * exporting functionality to your programs.
	 * It works by first having a GdaConnection object associated
	 * to it, and then allowing you to retrieve information about all
	 * the objects present in the database, and also to add/remove
	 * those objects from a list of selected objects.
	 * When you're done, you just run the export (gda_export_run), first
	 * connecting to the different signals that will let you be
	 * informed of the export process progress.
	 * Params:
	 * cnc =  a GdaConnection object.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Connection cnc)
	{
		// GdaExport* gda_export_new (GdaConnection *cnc);
		auto p = gda_export_new((cnc is null) ? null : cnc.getConnectionStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by gda_export_new((cnc is null) ? null : cnc.getConnectionStruct())");
		}
		this(cast(GdaExport*) p);
	}
	
	/**
	 * Returns a list of all tables that exist in the GdaConnection
	 * being used by the given GdaExport object. This function is
	 * useful when you're building, for example, a list for the user
	 * to select which tables he/she wants in the export process.
	 * You are responsible to free the returned value yourself.
	 * Returns: a GList containing the names of all the tables.
	 */
	public ListG getTables()
	{
		// GList* gda_export_get_tables (GdaExport *exp);
		auto p = gda_export_get_tables(gdaExport);
		if(p is null)
		{
			return null;
		}
		return new ListG(cast(GList*) p);
	}
	
	/**
	 * Returns a list with the names of all the currently selected objects
	 * in the given GdaExport object.
	 * You are responsible to free the returned value yourself.
	 * Returns: a GList containing the names of the selected tables.
	 */
	public ListG getSelectedTables()
	{
		// GList* gda_export_get_selected_tables (GdaExport *exp);
		auto p = gda_export_get_selected_tables(gdaExport);
		if(p is null)
		{
			return null;
		}
		return new ListG(cast(GList*) p);
	}
	
	/**
	 * Adds the given table to the list of selected tables.
	 * Params:
	 * table =  name of the table.
	 */
	public void selectTable(string table)
	{
		// void gda_export_select_table (GdaExport *exp,  const gchar *table);
		gda_export_select_table(gdaExport, Str.toStringz(table));
	}
	
	/**
	 * Adds all the tables contained in the given list to the list of
	 * selected tables.
	 * Params:
	 * list =  list of tables to be selected.
	 */
	public void selectTableList(ListG list)
	{
		// void gda_export_select_table_list (GdaExport *exp,  GList *list);
		gda_export_select_table_list(gdaExport, (list is null) ? null : list.getListGStruct());
	}
	
	/**
	 * Removes the given table name from the list of selected tables.
	 * Params:
	 * table =  name of the table.
	 */
	public void unselectTable(string table)
	{
		// void gda_export_unselect_table (GdaExport *exp,  const gchar *table);
		gda_export_unselect_table(gdaExport, Str.toStringz(table));
	}
	
	/**
	 * Starts the execution of the given export object. This means that, after
	 * calling this function, your application will lose control about the export
	 * process and will only receive notifications via the class signals.
	 * Params:
	 * flags =  execution flags.
	 */
	public void run(GdaExportFlags flags)
	{
		// void gda_export_run (GdaExport *exp,  GdaExportFlags flags);
		gda_export_run(gdaExport, flags);
	}
	
	/**
	 * Stops execution of the given export object.
	 */
	public void stop()
	{
		// void gda_export_stop (GdaExport *exp);
		gda_export_stop(gdaExport);
	}
	
	/**
	 * Returns: the GdaConnection object associated with the given GdaExport.
	 */
	public Connection getConnection()
	{
		// GdaConnection* gda_export_get_connection (GdaExport *exp);
		auto p = gda_export_get_connection(gdaExport);
		if(p is null)
		{
			return null;
		}
		return new Connection(cast(GdaConnection*) p);
	}
	
	/**
	 * Associates the given GdaConnection with the given GdaExport.
	 * Params:
	 * cnc =  a GdaConnection object.
	 */
	public void setConnection(Connection cnc)
	{
		// void gda_export_set_connection (GdaExport *exp,  GdaConnection *cnc);
		gda_export_set_connection(gdaExport, (cnc is null) ? null : cnc.getConnectionStruct());
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
