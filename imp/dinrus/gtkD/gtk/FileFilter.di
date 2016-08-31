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
 * inFile  = gtk-gtkfilefilter.html
 * outPack = gtk
 * outFile = FileFilter
 * strct   = GtkFileFilter
 * realStrct=
 * ctorStrct=
 * clss    = FileFilter
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_file_filter_
 * 	- gtk_
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

module gtkD.gtk.FileFilter;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;



private import gtkD.gtk.ObjectGtk;

/**
 * Description
 * A GtkFileFilter can be used to restrict the files being shown
 * in a GtkFileChooser. Files can be filtered based on their name
 * (with gtk_file_filter_add_pattern()), on their mime type (with
 * gtk_file_filter_add_mime_type()), or by a custom filter function
 * (with gtk_file_filter_add_custom()).
 * Filtering by mime types handles aliasing and subclassing of mime
 * types; e.g. a filter for text/plain also matches a file with mime
 * type application/rtf, since application/rtf is a subclass of
 * text/plain. Note that GtkFileFilter allows wildcards for the
 * subtype of a mime type, so you can e.g. filter for image/+*.
 * Normally, filters are used by adding them to a GtkFileChooser,
 * see gtk_file_chooser_add_filter(), but it is also possible
 * to manually use a filter on a file with gtk_file_filter_filter().
 */
public class FileFilter : ObjectGtk
{
	
	/** the main Gtk struct */
	protected GtkFileFilter* gtkFileFilter;
	
	
	public GtkFileFilter* getFileFilterStruct()
	{
		return gtkFileFilter;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkFileFilter;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkFileFilter* gtkFileFilter)
	{
		if(gtkFileFilter is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkFileFilter);
		if( ptr !is null )
		{
			this = cast(FileFilter)ptr;
			return;
		}
		super(cast(GtkObject*)gtkFileFilter);
		this.gtkFileFilter = gtkFileFilter;
	}
	
	/**
	 */
	
	/**
	 * Creates a new GtkFileFilter with no rules added to it.
	 * Such a filter doesn't accept any files, so is not
	 * particularly useful until you add rules with
	 * gtk_file_filter_add_mime_type(), gtk_file_filter_add_pattern(),
	 * or gtk_file_filter_add_custom(). To create a filter
	 * Since 2.4
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GtkFileFilter * gtk_file_filter_new (void);
		auto p = gtk_file_filter_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_file_filter_new()");
		}
		this(cast(GtkFileFilter*) p);
	}
	
	/**
	 * Sets the human-readable name of the filter; this is the string
	 * that will be displayed in the file selector user interface if
	 * there is a selectable list of filters.
	 * Since 2.4
	 * Params:
	 * name =  the human-readable-name for the filter, or NULL
	 *  to remove any existing name.
	 */
	public void setName(string name)
	{
		// void gtk_file_filter_set_name (GtkFileFilter *filter,  const gchar *name);
		gtk_file_filter_set_name(gtkFileFilter, Str.toStringz(name));
	}
	
	/**
	 * Gets the human-readable name for the filter. See gtk_file_filter_set_name().
	 * Since 2.4
	 * Returns: The human-readable name of the filter, or NULL. This value is owned by GTK+ and must not be modified or freed.
	 */
	public string getName()
	{
		// const gchar * gtk_file_filter_get_name (GtkFileFilter *filter);
		return Str.toString(gtk_file_filter_get_name(gtkFileFilter));
	}
	
	/**
	 * Adds a rule allowing a given mime type to filter.
	 * Since 2.4
	 * Params:
	 * mimeType =  name of a MIME type
	 */
	public void addMimeType(string mimeType)
	{
		// void gtk_file_filter_add_mime_type (GtkFileFilter *filter,  const gchar *mime_type);
		gtk_file_filter_add_mime_type(gtkFileFilter, Str.toStringz(mimeType));
	}
	
	/**
	 * Adds a rule allowing a shell style glob to a filter.
	 * Since 2.4
	 * Params:
	 * pattern =  a shell style glob
	 */
	public void addPattern(string pattern)
	{
		// void gtk_file_filter_add_pattern (GtkFileFilter *filter,  const gchar *pattern);
		gtk_file_filter_add_pattern(gtkFileFilter, Str.toStringz(pattern));
	}
	
	/**
	 * Adds a rule allowing image files in the formats supported
	 * by GdkPixbuf.
	 * Since 2.6
	 */
	public void addPixbufFormats()
	{
		// void gtk_file_filter_add_pixbuf_formats (GtkFileFilter *filter);
		gtk_file_filter_add_pixbuf_formats(gtkFileFilter);
	}
	
	/**
	 * Adds rule to a filter that allows files based on a custom callback
	 * function. The bitfield needed which is passed in provides information
	 * about what sorts of information that the filter function needs;
	 * this allows GTK+ to avoid retrieving expensive information when
	 * it isn't needed by the filter.
	 * Since 2.4
	 * Params:
	 * needed =  bitfield of flags indicating the information that the custom
	 *  filter function needs.
	 * func =  callback function; if the function returns TRUE, then
	 *  the file will be displayed.
	 * data =  data to pass to func
	 * notify =  function to call to free data when it is no longer needed.
	 */
	public void addCustom(GtkFileFilterFlags needed, GtkFileFilterFunc func, void* data, GDestroyNotify notify)
	{
		// void gtk_file_filter_add_custom (GtkFileFilter *filter,  GtkFileFilterFlags needed,  GtkFileFilterFunc func,  gpointer data,  GDestroyNotify notify);
		gtk_file_filter_add_custom(gtkFileFilter, needed, func, data, notify);
	}
	
	/**
	 * Gets the fields that need to be filled in for the structure
	 * passed to gtk_file_filter_filter()
	 * This function will not typically be used by applications; it
	 * is intended principally for use in the implementation of
	 * GtkFileChooser.
	 * Since 2.4
	 * Returns: bitfield of flags indicating needed fields when calling gtk_file_filter_filter()
	 */
	public GtkFileFilterFlags getNeeded()
	{
		// GtkFileFilterFlags gtk_file_filter_get_needed (GtkFileFilter *filter);
		return gtk_file_filter_get_needed(gtkFileFilter);
	}
	
	/**
	 * Tests whether a file should be displayed according to filter.
	 * The GtkFileFilterInfo structure filter_info should include
	 * the fields returned from gtk_file_filter_get_needed().
	 * This function will not typically be used by applications; it
	 * is intended principally for use in the implementation of
	 * GtkFileChooser.
	 * Since 2.4
	 * Params:
	 * filter =  a GtkFileFilter
	 * filterInfo =  a GtkFileFilterInfo structure containing information
	 *  about a file.
	 * Returns: TRUE if the file should be displayed
	 */
	public int filter(GtkFileFilterInfo* filterInfo)
	{
		// gboolean gtk_file_filter_filter (GtkFileFilter *filter,  const GtkFileFilterInfo *filter_info);
		return gtk_file_filter_filter(gtkFileFilter, filterInfo);
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
