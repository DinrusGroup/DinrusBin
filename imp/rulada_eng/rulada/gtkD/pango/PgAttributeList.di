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
 * outPack = pango
 * outFile = PgAttributeList
 * strct   = PangoAttrList
 * realStrct=
 * ctorStrct=
 * clss    = PgAttributeList
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- pango_attr_list_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.pango.PgAttribute
 * 	- gtkD.pango.PgAttributeIterator
 * structWrap:
 * 	- PangoAttrIterator* -> PgAttributeIterator
 * 	- PangoAttrList* -> PgAttributeList
 * 	- PangoAttribute* -> PgAttribute
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.pango.PgAttributeList;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.pango.PgAttribute;
private import gtkD.pango.PgAttributeIterator;




/**
 * Description
 * Attributed text is used in a number of places in Pango. It
 * is used as the input to the itemization process and also when
 * creating a PangoLayout. The data types and functions in
 * this section are used to represent and manipulate sets
 * of attributes applied to a portion of text.
 */
public class PgAttributeList
{
	
	/** the main Gtk struct */
	protected PangoAttrList* pangoAttrList;
	
	
	public PangoAttrList* getPgAttributeListStruct()
	{
		return pangoAttrList;
	}
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct()
	{
		return cast(void*)pangoAttrList;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoAttrList* pangoAttrList)
	{
		if(pangoAttrList is null)
		{
			this = null;
			return;
		}
		this.pangoAttrList = pangoAttrList;
	}
	
	/**
	 */
	
	/**
	 * Create a new empty attribute list with a reference count of one.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// PangoAttrList * pango_attr_list_new (void);
		auto p = pango_attr_list_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by pango_attr_list_new()");
		}
		this(cast(PangoAttrList*) p);
	}
	
	/**
	 * Increase the reference count of the given attribute list by one.
	 * Since 1.10
	 * Returns: The attribute list passed in
	 */
	public PgAttributeList doref()
	{
		// PangoAttrList * pango_attr_list_ref (PangoAttrList *list);
		auto p = pango_attr_list_ref(pangoAttrList);
		if(p is null)
		{
			return null;
		}
		return new PgAttributeList(cast(PangoAttrList*) p);
	}
	
	/**
	 * Decrease the reference count of the given attribute list by one.
	 * If the result is zero, free the attribute list and the attributes
	 * it contains.
	 */
	public void unref()
	{
		// void pango_attr_list_unref (PangoAttrList *list);
		pango_attr_list_unref(pangoAttrList);
	}
	
	/**
	 * Copy list and return an identical new list.
	 * Returns: the newly allocated PangoAttrList, with a reference count of one, which should be freed with pango_attr_list_unref(). Returns NULL if list was NULL.
	 */
	public PgAttributeList copy()
	{
		// PangoAttrList * pango_attr_list_copy (PangoAttrList *list);
		auto p = pango_attr_list_copy(pangoAttrList);
		if(p is null)
		{
			return null;
		}
		return new PgAttributeList(cast(PangoAttrList*) p);
	}
	
	/**
	 * Insert the given attribute into the PangoAttrList. It will
	 * be inserted after all other attributes with a matching
	 * start_index.
	 * Params:
	 * attr =  the attribute to insert. Ownership of this value is
	 *  assumed by the list.
	 */
	public void insert(PgAttribute attr)
	{
		// void pango_attr_list_insert (PangoAttrList *list,  PangoAttribute *attr);
		pango_attr_list_insert(pangoAttrList, (attr is null) ? null : attr.getPgAttributeStruct());
	}
	
	/**
	 * Insert the given attribute into the PangoAttrList. It will
	 * be inserted before all other attributes with a matching
	 * start_index.
	 * Params:
	 * attr =  the attribute to insert. Ownership of this value is
	 *  assumed by the list.
	 */
	public void insertBefore(PgAttribute attr)
	{
		// void pango_attr_list_insert_before (PangoAttrList *list,  PangoAttribute *attr);
		pango_attr_list_insert_before(pangoAttrList, (attr is null) ? null : attr.getPgAttributeStruct());
	}
	
	/**
	 * Insert the given attribute into the PangoAttrList. It will
	 * replace any attributes of the same type on that segment
	 * and be merged with any adjoining attributes that are identical.
	 * This function is slower than pango_attr_list_insert() for
	 * creating a attribute list in order (potentially much slower
	 * for large lists). However, pango_attr_list_insert() is not
	 * suitable for continually changing a set of attributes
	 * since it never removes or combines existing attributes.
	 * Params:
	 * attr =  the attribute to insert. Ownership of this value is
	 *  assumed by the list.
	 */
	public void change(PgAttribute attr)
	{
		// void pango_attr_list_change (PangoAttrList *list,  PangoAttribute *attr);
		pango_attr_list_change(pangoAttrList, (attr is null) ? null : attr.getPgAttributeStruct());
	}
	
	/**
	 * This function opens up a hole in list, fills it in with attributes from
	 * the left, and then merges other on top of the hole.
	 * This operation is equivalent to stretching every attribute
	 * that applies at position pos in list by an amount len,
	 * and then calling pango_attr_list_change() with a copy
	 * of each attribute in other in sequence (offset in position by pos).
	 * This operation proves useful for, for instance, inserting
	 * a pre-edit string in the middle of an edit buffer.
	 * Params:
	 * other =  another PangoAttrList
	 * pos =  the position in list at which to insert other
	 * len =  the length of the spliced segment. (Note that this
	 *  must be specified since the attributes in other
	 *  may only be present at some subsection of this range)
	 */
	public void splice(PgAttributeList other, int pos, int len)
	{
		// void pango_attr_list_splice (PangoAttrList *list,  PangoAttrList *other,  gint pos,  gint len);
		pango_attr_list_splice(pangoAttrList, (other is null) ? null : other.getPgAttributeListStruct(), pos, len);
	}
	
	/**
	 * Given a PangoAttrList and callback function, removes any elements
	 * of list for which func returns TRUE and inserts them into
	 * a new list.
	 * Since 1.2
	 * Params:
	 * func =  callback function; returns TRUE if an attribute
	 *  should be filtered out.
	 * data =  Data to be passed to func
	 * Returns: the new PangoAttrList or NULL if no attributes of the given types were found.
	 */
	public PgAttributeList filter(PangoAttrFilterFunc func, void* data)
	{
		// PangoAttrList * pango_attr_list_filter (PangoAttrList *list,  PangoAttrFilterFunc func,  gpointer data);
		auto p = pango_attr_list_filter(pangoAttrList, func, data);
		if(p is null)
		{
			return null;
		}
		return new PgAttributeList(cast(PangoAttrList*) p);
	}
	
	/**
	 * Create a iterator initialized to the beginning of the list.
	 * list must not be modified until this iterator is freed.
	 * Returns: the newly allocated PangoAttrIterator, which should be freed with pango_attr_iterator_destroy().
	 */
	public PgAttributeIterator getIterator()
	{
		// PangoAttrIterator * pango_attr_list_get_iterator (PangoAttrList *list);
		auto p = pango_attr_list_get_iterator(pangoAttrList);
		if(p is null)
		{
			return null;
		}
		return new PgAttributeIterator(cast(PangoAttrIterator*) p);
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-pango");
        } else version (DigitalMars) {
            pragma(link, "DD-pango");
        } else {
            pragma(link, "DO-pango");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-pango");
        } else version (DigitalMars) {
            pragma(link, "DD-pango");
        } else {
            pragma(link, "DO-pango");
        }
    }
}
