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
 * inFile  = libgda-GdaDataModelHash.html
 * outPack = gda
 * outFile = DataModelHash
 * strct   = GdaDataModelHash
 * realStrct=
 * ctorStrct=GdaDataModel
 * clss    = DataModelHash
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = GdaDataModel
 * implements:
 * prefixes:
 * 	- gda_data_model_hash_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.gda.DataModel
 * 	- gtkD.gda.Value
 * 	- gtkD.gda.Row
 * structWrap:
 * 	- GdaDataModel* -> DataModel
 * 	- GdaRow* -> Row
 * 	- GdaValue* -> Value
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gda.DataModelHash;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.gda.DataModel;
private import gtkD.gda.Value;
private import gtkD.gda.Row;



private import gtkD.gda.DataModel;

/**
 * Description
 * Unlike GdaDataModelArray, this data model implementation stores the GdaRow in
 * a hash table. So it only retrieves from the database backend exactly the
 * requested rows (while in GdaDataModelArray you have to retrieve all the rows
 * until the one requested).
 */
public class DataModelHash : DataModel
{
	
	/** the main Gtk struct */
	protected GdaDataModelHash* gdaDataModelHash;
	
	
	public GdaDataModelHash* getDataModelHashStruct()
	{
		return gdaDataModelHash;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gdaDataModelHash;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaDataModelHash* gdaDataModelHash)
	{
		if(gdaDataModelHash is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gdaDataModelHash);
		if( ptr !is null )
		{
			this = cast(DataModelHash)ptr;
			return;
		}
		super(cast(GdaDataModel*)gdaDataModelHash);
		this.gdaDataModelHash = gdaDataModelHash;
	}
	
	/**
	 */
	
	/**
	 * Params:
	 * cols =  number of columns for rows in this data model.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (int cols)
	{
		// GdaDataModel* gda_data_model_hash_new (gint cols);
		auto p = gda_data_model_hash_new(cols);
		if(p is null)
		{
			throw new ConstructionException("null returned by gda_data_model_hash_new(cols)");
		}
		this(cast(GdaDataModelHash*) p);
	}
	
	/**
	 * Retrieves the value at a specified column and row.
	 * Params:
	 * model =  the GdaDataModelHash to retrieve the value from.
	 * col =  column number (starting from 0).
	 * row =  row number (starting from 0).
	 * Returns: a pointer to a GdaValue.
	 */
	public static Value getValueAt(DataModel model, int col, int row)
	{
		// const GdaValue* gda_data_model_hash_get_value_at (GdaDataModel *model,  gint col,  gint row);
		auto p = gda_data_model_hash_get_value_at((model is null) ? null : model.getDataModelStruct(), col, row);
		if(p is null)
		{
			return null;
		}
		return new Value(cast(GdaValue*) p);
	}
	
	/**
	 * Frees all the rows inserted in model.
	 */
	public void clear()
	{
		// void gda_data_model_hash_clear (GdaDataModelHash *model);
		gda_data_model_hash_clear(gdaDataModelHash);
	}
	
	/**
	 * Sets the number of columns for rows inserted in this model.
	 * cols must be greater than or equal to 0.
	 * This function calls gda_data_model_hash_clear to free the
	 * existing rows if any.
	 * Params:
	 * cols =  the number of columns for rows inserted in model.
	 */
	public void setNColumns(int cols)
	{
		// void gda_data_model_hash_set_n_columns (GdaDataModelHash *model,  gint cols);
		gda_data_model_hash_set_n_columns(gdaDataModelHash, cols);
	}
	
	/**
	 * Inserts a row in the model.
	 * Params:
	 * rownum =  the number of the row.
	 * row =  the row to insert. The model is responsible of freeing it!
	 */
	public void insertRow(int rownum, Row row)
	{
		// void gda_data_model_hash_insert_row (GdaDataModelHash *model,  gint rownum,  GdaRow *row);
		gda_data_model_hash_insert_row(gdaDataModelHash, rownum, (row is null) ? null : row.getRowStruct());
	}
	
	/**
	 * Retrieves a row from the underlying hash table.
	 * Params:
	 * model =  the GdaDataModelHash
	 * row =  row number
	 * Returns: a GdaRow or NULL if the requested row is not in the hash table.
	 */
	public static Row getRow(DataModel model, int row)
	{
		// const GdaRow* gda_data_model_hash_get_row (GdaDataModel *model,  gint row);
		auto p = gda_data_model_hash_get_row((model is null) ? null : model.getDataModelStruct(), row);
		if(p is null)
		{
			return null;
		}
		return new Row(cast(GdaRow*) p);
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
