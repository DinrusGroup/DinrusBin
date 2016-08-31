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
 * inFile  = GtkTearoffMenuItem.html
 * outPack = gtk
 * outFile = TearoffMenuItem
 * strct   = GtkTearoffMenuItem
 * realStrct=
 * ctorStrct=
 * clss    = TearoffMenuItem
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_tearoff_menu_item_
 * 	- gtk_
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

module gtkD.gtk.TearoffMenuItem;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;





private import gtkD.gtk.MenuItem;

/**
 * Description
 * A GtkTearoffMenuItem is a special GtkMenuItem which is used to
 * tear off and reattach its menu.
 * When its menu is shown normally, the GtkTearoffMenuItem is drawn as a
 * dotted line indicating that the menu can be torn off. Activating it
 * causes its menu to be torn off and displayed in its own window
 * as a tearoff menu.
 * When its menu is shown as a tearoff menu, the GtkTearoffMenuItem is drawn
 * as a dotted line which has a left pointing arrow graphic indicating that
 * the tearoff menu can be reattached. Activating it will erase the tearoff
 * menu window.
 */
public class TearoffMenuItem : MenuItem
{
	
	/** the main Gtk struct */
	protected GtkTearoffMenuItem* gtkTearoffMenuItem;
	
	
	public GtkTearoffMenuItem* getTearoffMenuItemStruct()
	{
		return gtkTearoffMenuItem;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkTearoffMenuItem;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTearoffMenuItem* gtkTearoffMenuItem)
	{
		if(gtkTearoffMenuItem is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkTearoffMenuItem);
		if( ptr !is null )
		{
			this = cast(TearoffMenuItem)ptr;
			return;
		}
		super(cast(GtkMenuItem*)gtkTearoffMenuItem);
		this.gtkTearoffMenuItem = gtkTearoffMenuItem;
	}
	
	/**
	 */
	
	/**
	 * Creates a new GtkTearoffMenuItem.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GtkWidget* gtk_tearoff_menu_item_new (void);
		auto p = gtk_tearoff_menu_item_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_tearoff_menu_item_new()");
		}
		this(cast(GtkTearoffMenuItem*) p);
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
