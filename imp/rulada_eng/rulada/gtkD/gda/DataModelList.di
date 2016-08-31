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
 * inFile  = libgda-GdaDataModelList.html
 * outPack = gda
 * outFile = DataModelList
 * strct   = GdaDataModelList
 * realStrct=
 * ctorStrct=GdaDataModel
 * clss    = DataModelList
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = GdaDataModel
 * implements:
 * prefixes:
 * 	- gda_data_model_list_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.ListG
 * 	- gtkD.gda.Value
 * 	- gtkD.gda.Row
 * structWrap:
 * 	- GList* -> ListG
 * 	- GdaRow* -> Row
 * 	- GdaValue* -> Value
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gda.DataModelList;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ListG;
private import gtkD.gda.Value;
private import gtkD.gda.Row;



private import gtkD.gda.DataModel;

/**
 * Description
 */
public class DataModelList : DataModel
{
	
	/** the main Gtk struct */
	protected GdaDataModelList* gdaDataModelList;
	
	
	public GdaDataModelList* getDataModelListStruct()
	{
		return gdaDataModelList;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gdaDataModelList;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaDataModelList* gdaDataModelList)
	{
		if(gdaDataModelList is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gdaDataModelList);
		if( ptr !is null )
		{
			this = cast(DataModelList)ptr;
			return;
		}
		super(cast(GdaDataModel*)gdaDataModelList);
		this.gdaDataModelList = gdaDataModelList;
	}
	
	/**
	 */
	
	/**
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GdaDataModel* gda_data_model_list_new (void);
		auto p = gda_data_model_list_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by gda_data_model_list_new()");
		}
		this(cast(GdaDataModelList*) p);
	}
	
	/**
	 * Params:
	 * list =  a list of strings.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ListG list)
	{
		// GdaDataModel* gda_data_model_list_new_from_string_list  (const GList *list);
		auto p = gda_data_model_list_new_from_string_list((list is null) ? null : list.getListGStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by gda_data_model_list_new_from_string_list((list is null) ? null : list.getListGStruct())");
		}
		this(cast(GdaDataModelList*) p);
	}
	
	/**
	 * Inserts a row in the model, using value.
	 * Params:
	 * value =  a GdaValue which will be used to fill the row.
	 * Returns: the GdaRow which has been inserted, or NULL on failure.
	 */
	public Row appendValue(Value value)
	{
		// const GdaRow* gda_data_model_list_append_value (GdaDataModelList *model,  const GdaValue *value);
		auto p = gda_data_model_list_append_value(gdaDataModelList, (value is null) ? null : value.getValueStruct());
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
