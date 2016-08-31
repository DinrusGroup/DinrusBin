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
 * inFile  = libgda-GdaSelect.html
 * outPack = gda
 * outFile = Select
 * strct   = GdaSelect
 * realStrct=
 * ctorStrct=GdaDataModel
 * clss    = Select
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = GdaDataModelArray
 * implements:
 * prefixes:
 * 	- gda_select_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gda.DataModel
 * structWrap:
 * 	- GdaDataModel* -> DataModel
 * 	- GdaSelect* -> Select
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gda.Select;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gda.DataModel;



private import gtkD.gda.DataModelArray;

/**
 * Description
 */
public class Select : DataModelArray
{
	
	/** the main Gtk struct */
	protected GdaSelect* gdaSelect;
	
	
	public GdaSelect* getSelectStruct()
	{
		return gdaSelect;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gdaSelect;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaSelect* gdaSelect)
	{
		if(gdaSelect is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gdaSelect);
		if( ptr !is null )
		{
			this = cast(Select)ptr;
			return;
		}
		super(cast(GdaDataModelArray*)gdaSelect);
		this.gdaSelect = gdaSelect;
	}
	
	/**
	 */
	
	/**
	 * Creates a new GdaSelect object, which allows programs to filter
	 * GdaDataModel's based on a given SQL SELECT command.
	 * A GdaSelect is just another GdaDataModel-based class, so it
	 * can be used in the same way any other data model class is.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GdaDataModel* gda_select_new (void);
		auto p = gda_select_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by gda_select_new()");
		}
		this(cast(GdaSelect*) p);
	}
	
	/**
	 * Adds a data model as a source of data for the GdaSelect object. When
	 * the select object is run (via gda_select_run), it will parse the SQL
	 * and get the required data from the source data models.
	 * Params:
	 * name =  name to identify the data model (usually a table name).
	 * source =  a GdaDataModel from which to get data.
	 */
	public void addSource(string name, DataModel source)
	{
		// void gda_select_add_source (GdaSelect *sel,  const gchar *name,  GdaDataModel *source);
		gda_select_add_source(gdaSelect, Str.toStringz(name), (source is null) ? null : source.getDataModelStruct());
	}
	
	/**
	 * Sets the SQL command to be used on the given GdaSelect object
	 * for filtering rows from the source data model (which is
	 * set with gda_select_set_source).
	 * Params:
	 * sql =  the SQL command to be used for filtering rows.
	 */
	public void setSql(string sql)
	{
		// void gda_select_set_sql (GdaSelect *sel,  const gchar *sql);
		gda_select_set_sql(gdaSelect, Str.toStringz(sql));
	}
	
	/**
	 * Runs the query and fills in the GdaSelect object with the
	 * rows that matched the SQL command (which can be set with
	 * gda_select_set_sql) associated with this GdaSelect
	 * object.
	 * After calling this function, if everything is successful,
	 * the GdaSelect object will contain the matched rows, which
	 * can then be accessed like a normal GdaDataModel.
	 * Returns: TRUE if successful, FALSE if there was an error.
	 */
	public int run()
	{
		// gboolean gda_select_run (GdaSelect *sel);
		return gda_select_run(gdaSelect);
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
