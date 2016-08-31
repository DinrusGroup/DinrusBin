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
 * inFile  = GFileIcon.html
 * outPack = gio
 * outFile = FileIcon
 * strct   = GFileIcon
 * realStrct=
 * ctorStrct=GIcon
 * clss    = FileIcon
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * 	- IconIF
 * 	- LoadableIconIF
 * prefixes:
 * 	- g_file_icon_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.gio.IconT
 * 	- gtkD.gio.IconIF
 * 	- gtkD.gio.LoadableIconT
 * 	- gtkD.gio.LoadableIconIF
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.FileIcon;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gio.IconT;
private import gtkD.gio.IconIF;
private import gtkD.gio.LoadableIconT;
private import gtkD.gio.LoadableIconIF;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GFileIcon specifies an icon by pointing to an image file
 * to be used as icon.
 */
public class FileIcon : ObjectG, IconIF, LoadableIconIF
{
	
	/** the main Gtk struct */
	protected GFileIcon* gFileIcon;
	
	
	public GFileIcon* getFileIconStruct()
	{
		return gFileIcon;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gFileIcon;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GFileIcon* gFileIcon)
	{
		if(gFileIcon is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gFileIcon);
		if( ptr !is null )
		{
			this = cast(FileIcon)ptr;
			return;
		}
		super(cast(GObject*)gFileIcon);
		this.gFileIcon = gFileIcon;
	}
	
	// add the Icon capabilities
	mixin IconT!(GFileIcon);
	
	// add the LoadableIcon capabilities
	mixin LoadableIconT!(GFileIcon);
	
	/**
	 */
	
	/**
	 * Creates a new icon for a file.
	 * Params:
	 * file =  a GFile.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GFile* file)
	{
		// GIcon * g_file_icon_new (GFile *file);
		auto p = g_file_icon_new(file);
		if(p is null)
		{
			throw new ConstructionException("null returned by g_file_icon_new(file)");
		}
		this(cast(GFileIcon*) p);
	}
	
	/**
	 * Gets the GFile associated with the given icon.
	 * Returns: a GFile, or NULL.
	 */
	public GFile* getFile()
	{
		// GFile * g_file_icon_get_file (GFileIcon *icon);
		return g_file_icon_get_file(gFileIcon);
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gio");
        } else version (DigitalMars) {
            pragma(link, "DD-gio");
        } else {
            pragma(link, "DO-gio");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gio");
        } else version (DigitalMars) {
            pragma(link, "DD-gio");
        } else {
            pragma(link, "DO-gio");
        }
    }
}
