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
 * inFile  = 
 * outPack = glib
 * outFile = Tuples
 * strct   = GTuples
 * realStrct=
 * ctorStrct=
 * clss    = Tuples
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_tuples_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.glib.Tuples;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * A GRelation is a table of data which can be indexed on any number of fields,
 * rather like simple database tables. A GRelation contains a number of
 * records, called tuples. Each record contains a number of fields.
 * Records are not ordered, so it is not possible to find the record at a
 * particular index.
 * Note that GRelation tables are currently limited to 2 fields.
 * To create a GRelation, use g_relation_new().
 * To specify which fields should be indexed, use g_relation_index().
 * Note that this must be called before any tuples are added to the GRelation.
 * To add records to a GRelation use g_relation_insert().
 * To determine if a given record appears in a GRelation, use
 * g_relation_exists(). Note that fields are compared directly, so pointers
 * must point to the exact same position (i.e. different copies of the same
 * string will not match.)
 * To count the number of records which have a particular value in a given
 * field, use g_relation_count().
 * To get all the records which have a particular value in a given field,
 * use g_relation_select(). To access fields of the resulting records,
 * use g_tuples_index(). To free the resulting records use g_tuples_destroy().
 * To delete all records which have a particular value in a given field,
 * use g_relation_delete().
 * To destroy the GRelation, use g_relation_destroy().
 * To help debug GRelation objects, use g_relation_print().
 */
public class Tuples
{
	
	/** the main Gtk struct */
	protected GTuples* gTuples;
	
	
	public GTuples* getTuplesStruct()
	{
		return gTuples;
	}
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct()
	{
		return cast(void*)gTuples;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GTuples* gTuples)
	{
		if(gTuples is null)
		{
			this = null;
			return;
		}
		this.gTuples = gTuples;
	}
	
	/**
	 */
	
	/**
	 * Frees the records which were returned by g_relation_select().
	 * This should always be called after g_relation_select() when you are
	 * finished with the records.
	 * The records are not removed from the GRelation.
	 */
	public void destroy()
	{
		// void g_tuples_destroy (GTuples *tuples);
		g_tuples_destroy(gTuples);
	}
	
	/**
	 * Gets a field from the records returned by g_relation_select().
	 * It returns the given field of the record at the given index.
	 * The returned value should not be changed.
	 * Params:
	 * index = the index of the record.
	 * field = the field to return.
	 * Returns:the field of the record.
	 */
	public void* index(int index, int field)
	{
		// gpointer g_tuples_index (GTuples *tuples,  gint index_,  gint field);
		return g_tuples_index(gTuples, index, field);
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
