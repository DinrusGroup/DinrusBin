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
 * inFile  = GtkWindowGroup.html
 * outPack = gtk
 * outFile = WindowGroup
 * strct   = GtkWindowGroup
 * realStrct=
 * ctorStrct=
 * clss    = WindowGroup
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_window_group_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.ListG
 * 	- gtkD.gtk.Window
 * structWrap:
 * 	- GList* -> ListG
 * 	- GtkWindow* -> Window
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.WindowGroup;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ListG;
private import gtkD.gtk.Window;



private import gtkD.gobject.ObjectG;

/**
 * Description
 */
public class WindowGroup : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkWindowGroup* gtkWindowGroup;
	
	
	public GtkWindowGroup* getWindowGroupStruct()
	{
		return gtkWindowGroup;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkWindowGroup;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkWindowGroup* gtkWindowGroup)
	{
		if(gtkWindowGroup is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkWindowGroup);
		if( ptr !is null )
		{
			this = cast(WindowGroup)ptr;
			return;
		}
		super(cast(GObject*)gtkWindowGroup);
		this.gtkWindowGroup = gtkWindowGroup;
	}
	
	/**
	 */
	
	/**
	 * Creates a new GtkWindowGroup object. Grabs added with
	 * gtk_grab_add() only affect windows within the same GtkWindowGroup.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GtkWindowGroup * gtk_window_group_new (void);
		auto p = gtk_window_group_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_window_group_new()");
		}
		this(cast(GtkWindowGroup*) p);
	}
	
	/**
	 * Adds a window to a GtkWindowGroup.
	 * Params:
	 * window =  the GtkWindow to add
	 */
	public void addWindow(Window window)
	{
		// void gtk_window_group_add_window (GtkWindowGroup *window_group,  GtkWindow *window);
		gtk_window_group_add_window(gtkWindowGroup, (window is null) ? null : window.getWindowStruct());
	}
	
	/**
	 * Removes a window from a GtkWindowGroup.
	 * Params:
	 * window =  the GtkWindow to remove
	 */
	public void removeWindow(Window window)
	{
		// void gtk_window_group_remove_window (GtkWindowGroup *window_group,  GtkWindow *window);
		gtk_window_group_remove_window(gtkWindowGroup, (window is null) ? null : window.getWindowStruct());
	}
	
	/**
	 * Returns a list of the GtkWindows that belong to window_group.
	 * Since 2.14
	 * Returns: A newly-allocated list of windows inside the group.
	 */
	public ListG listWindows()
	{
		// GList * gtk_window_group_list_windows (GtkWindowGroup *window_group);
		auto p = gtk_window_group_list_windows(gtkWindowGroup);
		if(p is null)
		{
			return null;
		}
		return new ListG(cast(GList*) p);
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
