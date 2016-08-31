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
 * inFile  = gtk-Selections.html
 * outPack = gtk
 * outFile = TargetList
 * strct   = GtkTargetList
 * realStrct=
 * ctorStrct=
 * clss    = TargetList
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_target_list_
 * omit structs:
 * omit prefixes:
 * 	- gtk_selection_
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.gtk.TextBuffer
 * structWrap:
 * 	- GtkTargetList* -> TargetList
 * 	- GtkTextBuffer* -> TextBuffer
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.TargetList;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.TextBuffer;




/**
 * Description
 * The selection mechanism provides the basis for different types
 * of communication between processes. In particular, drag and drop and
 * GtkClipboard work via selections. You will very seldom or
 * never need to use most of the functions in this section directly;
 * GtkClipboard provides a nicer interface to the same functionality.
 * Some of the datatypes defined this section are used in
 * the GtkClipboard and drag-and-drop API's as well. The
 * GtkTargetEntry structure and GtkTargetList objects represent
 * lists of data types that are supported when sending or
 * receiving data. The GtkSelectionData object is used to
 * store a chunk of data along with the data type and other
 * associated information.
 */
public class TargetList
{
	
	/** the main Gtk struct */
	protected GtkTargetList* gtkTargetList;
	
	
	public GtkTargetList* getTargetListStruct()
	{
		return gtkTargetList;
	}
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct()
	{
		return cast(void*)gtkTargetList;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTargetList* gtkTargetList)
	{
		if(gtkTargetList is null)
		{
			this = null;
			return;
		}
		this.gtkTargetList = gtkTargetList;
	}
	
	/**
	 */
	
	/**
	 * Creates a new GtkTargetList from an array of GtkTargetEntry.
	 * Params:
	 * targets =  Pointer to an array of GtkTargetEntry
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GtkTargetEntry[] targets)
	{
		// GtkTargetList * gtk_target_list_new (const GtkTargetEntry *targets,  guint ntargets);
		auto p = gtk_target_list_new(targets.ptr, targets.length);
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_target_list_new(targets.ptr, targets.length)");
		}
		this(cast(GtkTargetList*) p);
	}
	
	/**
	 * Increases the reference count of a GtkTargetList by one.
	 * Returns: the passed in GtkTargetList.
	 */
	public TargetList doref()
	{
		// GtkTargetList * gtk_target_list_ref (GtkTargetList *list);
		auto p = gtk_target_list_ref(gtkTargetList);
		if(p is null)
		{
			return null;
		}
		return new TargetList(cast(GtkTargetList*) p);
	}
	
	/**
	 * Decreases the reference count of a GtkTargetList by one.
	 * If the resulting reference count is zero, frees the list.
	 */
	public void unref()
	{
		// void gtk_target_list_unref (GtkTargetList *list);
		gtk_target_list_unref(gtkTargetList);
	}
	
	/**
	 * Appends another target to a GtkTargetList.
	 * Params:
	 * target =  the interned atom representing the target
	 * flags =  the flags for this target
	 * info =  an ID that will be passed back to the application
	 */
	public void add(GdkAtom target, uint flags, uint info)
	{
		// void gtk_target_list_add (GtkTargetList *list,  GdkAtom target,  guint flags,  guint info);
		gtk_target_list_add(gtkTargetList, target, flags, info);
	}
	
	/**
	 * Prepends a table of GtkTargetEntry to a target list.
	 * Params:
	 * targets =  the table of GtkTargetEntry
	 */
	public void addTable(GtkTargetEntry[] targets)
	{
		// void gtk_target_list_add_table (GtkTargetList *list,  const GtkTargetEntry *targets,  guint ntargets);
		gtk_target_list_add_table(gtkTargetList, targets.ptr, targets.length);
	}
	
	/**
	 * Appends the text targets supported by GtkSelection to
	 * the target list. All targets are added with the same info.
	 * Since 2.6
	 * Params:
	 * info =  an ID that will be passed back to the application
	 */
	public void addTextTargets(uint info)
	{
		// void gtk_target_list_add_text_targets (GtkTargetList *list,  guint info);
		gtk_target_list_add_text_targets(gtkTargetList, info);
	}
	
	/**
	 * Appends the image targets supported by GtkSelection to
	 * the target list. All targets are added with the same info.
	 * Since 2.6
	 * Params:
	 * info =  an ID that will be passed back to the application
	 * writable =  whether to add only targets for which GTK+ knows
	 *  how to convert a pixbuf into the format
	 */
	public void addImageTargets(uint info, int writable)
	{
		// void gtk_target_list_add_image_targets (GtkTargetList *list,  guint info,  gboolean writable);
		gtk_target_list_add_image_targets(gtkTargetList, info, writable);
	}
	
	/**
	 * Appends the URI targets supported by GtkSelection to
	 * the target list. All targets are added with the same info.
	 * Since 2.6
	 * Params:
	 * info =  an ID that will be passed back to the application
	 */
	public void addUriTargets(uint info)
	{
		// void gtk_target_list_add_uri_targets (GtkTargetList *list,  guint info);
		gtk_target_list_add_uri_targets(gtkTargetList, info);
	}
	
	/**
	 * Appends the rich text targets registered with
	 * gtk_text_buffer_register_serialize_format() or
	 * gtk_text_buffer_register_deserialize_format() to the target list. All
	 * targets are added with the same info.
	 * Since 2.10
	 * Params:
	 * info =  an ID that will be passed back to the application
	 * deserializable =  if TRUE, then deserializable rich text formats
	 *  will be added, serializable formats otherwise.
	 * buffer =  a GtkTextBuffer.
	 */
	public void addRichTextTargets(uint info, int deserializable, TextBuffer buffer)
	{
		// void gtk_target_list_add_rich_text_targets  (GtkTargetList *list,  guint info,  gboolean deserializable,  GtkTextBuffer *buffer);
		gtk_target_list_add_rich_text_targets(gtkTargetList, info, deserializable, (buffer is null) ? null : buffer.getTextBufferStruct());
	}
	
	/**
	 * Removes a target from a target list.
	 * Params:
	 * target =  the interned atom representing the target
	 */
	public void remove(GdkAtom target)
	{
		// void gtk_target_list_remove (GtkTargetList *list,  GdkAtom target);
		gtk_target_list_remove(gtkTargetList, target);
	}
	
	/**
	 * Looks up a given target in a GtkTargetList.
	 * Params:
	 * target =  an interned atom representing the target to search for
	 * info =  a pointer to the location to store application info for target,
	 *  or NULL
	 * Returns: TRUE if the target was found, otherwise FALSE
	 */
	public int find(GdkAtom target, out uint info)
	{
		// gboolean gtk_target_list_find (GtkTargetList *list,  GdkAtom target,  guint *info);
		return gtk_target_list_find(gtkTargetList, target, &info);
	}
	
	/**
	 * This function frees a target table as returned by
	 * gtk_target_table_new_from_list()
	 * Since 2.10
	 * Params:
	 * targets =  a GtkTargetEntry array
	 * nTargets =  the number of entries in the array
	 */
	public static void gtkTargetTableFree(GtkTargetEntry[] targets, int nTargets)
	{
		// void gtk_target_table_free (GtkTargetEntry *targets,  gint n_targets);
		gtk_target_table_free(targets.ptr, nTargets);
	}
	
	/**
	 * This function creates an GtkTargetEntry array that contains the
	 * same targets as the passed list. The returned table is newly
	 * allocated and should be freed using gtk_target_table_free() when no
	 * longer needed.
	 * Since 2.10
	 * Returns: the new table.
	 */
	public GtkTargetEntry[] gtkTargetTableNewFromList()
	{
		// GtkTargetEntry * gtk_target_table_new_from_list (GtkTargetList *list,  gint *n_targets);
		int nTargets;
		auto p = gtk_target_table_new_from_list(gtkTargetList, &nTargets);
		return p[0 .. nTargets];
	}
	
	/**
	 * Determines if any of the targets in targets can be used to
	 * provide a GdkPixbuf.
	 * Since 2.10
	 * Params:
	 * targets =  an array of GdkAtoms
	 * writable =  whether to accept only targets for which GTK+ knows
	 *  how to convert a pixbuf into the format
	 * Returns: TRUE if targets include a suitable target for images, otherwise FALSE.
	 */
	public static int gtkTargetsIncludeImage(GdkAtom[] targets, int writable)
	{
		// gboolean gtk_targets_include_image (GdkAtom *targets,  gint n_targets,  gboolean writable);
		return gtk_targets_include_image(targets.ptr, targets.length, writable);
	}
	
	/**
	 * Determines if any of the targets in targets can be used to
	 * provide text.
	 * Since 2.10
	 * Params:
	 * targets =  an array of GdkAtoms
	 * Returns: TRUE if targets include a suitable target for text, otherwise FALSE.
	 */
	public static int gtkTargetsIncludeText(GdkAtom[] targets)
	{
		// gboolean gtk_targets_include_text (GdkAtom *targets,  gint n_targets);
		return gtk_targets_include_text(targets.ptr, targets.length);
	}
	
	/**
	 * Determines if any of the targets in targets can be used to
	 * provide an uri list.
	 * Since 2.10
	 * Params:
	 * targets =  an array of GdkAtoms
	 * Returns: TRUE if targets include a suitable target for uri lists, otherwise FALSE.
	 */
	public static int gtkTargetsIncludeUri(GdkAtom[] targets)
	{
		// gboolean gtk_targets_include_uri (GdkAtom *targets,  gint n_targets);
		return gtk_targets_include_uri(targets.ptr, targets.length);
	}
	
	/**
	 * Determines if any of the targets in targets can be used to
	 * provide rich text.
	 * Since 2.10
	 * Params:
	 * targets =  an array of GdkAtoms
	 * buffer =  a GtkTextBuffer
	 * Returns: TRUE if targets include a suitable target for rich text, otherwise FALSE.
	 */
	public static int gtkTargetsIncludeRichText(GdkAtom[] targets, TextBuffer buffer)
	{
		// gboolean gtk_targets_include_rich_text (GdkAtom *targets,  gint n_targets,  GtkTextBuffer *buffer);
		return gtk_targets_include_rich_text(targets.ptr, targets.length, (buffer is null) ? null : buffer.getTextBufferStruct());
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gtk");
        } else version (DigitalMars) {
            pragma(link, "DD-gtk");
        } else {
            pragma(link, "DO-gtk");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gtk");
        } else version (DigitalMars) {
            pragma(link, "DD-gtk");
        } else {
            pragma(link, "DO-gtk");
        }
    }
}
