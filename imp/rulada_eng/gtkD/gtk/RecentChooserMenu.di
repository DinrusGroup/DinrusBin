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
 * inFile  = GtkRecentChooserMenu.html
 * outPack = gtk
 * outFile = RecentChooserMenu
 * strct   = GtkRecentChooserMenu
 * realStrct=
 * ctorStrct=
 * clss    = RecentChooserMenu
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * 	- ActivatableIF
 * 	- RecentChooserIF
 * prefixes:
 * 	- gtk_recent_chooser_menu_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gtk.Widget
 * 	- gtkD.gtk.RecentManager
 * 	- gtkD.gtk.ActivatableT
 * 	- gtkD.gtk.ActivatableIF
 * 	- gtkD.gtk.RecentChooserIF
 * 	- gtkD.gtk.RecentChooserT
 * structWrap:
 * 	- GtkRecentManager* -> RecentManager
 * 	- GtkWidget* -> Widget
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.RecentChooserMenu;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Widget;
private import gtkD.gtk.RecentManager;
private import gtkD.gtk.ActivatableT;
private import gtkD.gtk.ActivatableIF;
private import gtkD.gtk.RecentChooserIF;
private import gtkD.gtk.RecentChooserT;



private import gtkD.gtk.Menu;

/**
 * Description
 * GtkRecentChooserMenu is a widget suitable for displaying recently used files
 * inside a menu. It can be used to set a sub-menu of a GtkMenuItem using
 * gtk_menu_item_set_submenu(), or as the menu of a GtkMenuToolButton.
 * Note that GtkRecentChooserMenu does not have any methods of its own. Instead,
 * you should use the functions that work on a GtkRecentChooser.
 * Note also that GtkRecentChooserMenu does not support multiple filters, as it
 * has no way to let the user choose between them as the GtkRecentChooserWidget
 * and GtkRecentChooserDialog widgets do. Thus using gtk_recent_chooser_add_filter()
 * on a GtkRecentChooserMenu widget will yield the same effects as using
 * gtk_recent_chooser_set_filter(), replacing any currently set filter
 * with the supplied filter; gtk_recent_chooser_remove_filter() will remove
 * any currently set GtkRecentFilter object and will unset the current filter;
 * gtk_recent_chooser_list_filters() will return a list containing a single
 * GtkRecentFilter object.
 * Recently used files are supported since GTK+ 2.10.
 */
public class RecentChooserMenu : Menu, ActivatableIF, RecentChooserIF
{
	
	/** the main Gtk struct */
	protected GtkRecentChooserMenu* gtkRecentChooserMenu;
	
	
	public GtkRecentChooserMenu* getRecentChooserMenuStruct()
	{
		return gtkRecentChooserMenu;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkRecentChooserMenu;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkRecentChooserMenu* gtkRecentChooserMenu)
	{
		if(gtkRecentChooserMenu is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkRecentChooserMenu);
		if( ptr !is null )
		{
			this = cast(RecentChooserMenu)ptr;
			return;
		}
		super(cast(GtkMenu*)gtkRecentChooserMenu);
		this.gtkRecentChooserMenu = gtkRecentChooserMenu;
	}
	
	// add the Activatable capabilities
	mixin ActivatableT!(GtkRecentChooserMenu);
	
	// add the RecentChooser capabilities
	mixin RecentChooserT!(GtkRecentChooserMenu);
	
	/**
	 */
	
	/**
	 * Creates a new GtkRecentChooserMenu widget.
	 * This kind of widget shows the list of recently used resources as
	 * a menu, each item as a menu item. Each item inside the menu might
	 * have an icon, representing its MIME type, and a number, for mnemonic
	 * access.
	 * This widget implements the GtkRecentChooser interface.
	 * This widget creates its own GtkRecentManager object. See the
	 * gtk_recent_chooser_menu_new_for_manager() function to know how to create
	 * a GtkRecentChooserMenu widget bound to another GtkRecentManager object.
	 * Since 2.10
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GtkWidget * gtk_recent_chooser_menu_new (void);
		auto p = gtk_recent_chooser_menu_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_recent_chooser_menu_new()");
		}
		this(cast(GtkRecentChooserMenu*) p);
	}
	
	/**
	 * Creates a new GtkRecentChooserMenu widget using manager as
	 * the underlying recently used resources manager.
	 * This is useful if you have implemented your own recent manager,
	 * or if you have a customized instance of a GtkRecentManager
	 * object or if you wish to share a common GtkRecentManager object
	 * among multiple GtkRecentChooser widgets.
	 * Since 2.10
	 * Params:
	 * manager =  a GtkRecentManager
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (RecentManager manager)
	{
		// GtkWidget * gtk_recent_chooser_menu_new_for_manager  (GtkRecentManager *manager);
		auto p = gtk_recent_chooser_menu_new_for_manager((manager is null) ? null : manager.getRecentManagerStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_recent_chooser_menu_new_for_manager((manager is null) ? null : manager.getRecentManagerStruct())");
		}
		this(cast(GtkRecentChooserMenu*) p);
	}
	
	/**
	 * Returns the value set by gtk_recent_chooser_menu_set_show_numbers().
	 * Since 2.10
	 * Returns: TRUE if numbers should be shown.
	 */
	public int getShowNumbers()
	{
		// gboolean gtk_recent_chooser_menu_get_show_numbers  (GtkRecentChooserMenu *menu);
		return gtk_recent_chooser_menu_get_show_numbers(gtkRecentChooserMenu);
	}
	
	/**
	 * Sets whether a number should be added to the items of menu. The
	 * numbers are shown to provide a unique character for a mnemonic to
	 * be used inside ten menu item's label. Only the first the items
	 * get a number to avoid clashes.
	 * Since 2.10
	 * Params:
	 * showNumbers =  whether to show numbers
	 */
	public void setShowNumbers(int showNumbers)
	{
		// void gtk_recent_chooser_menu_set_show_numbers  (GtkRecentChooserMenu *menu,  gboolean show_numbers);
		gtk_recent_chooser_menu_set_show_numbers(gtkRecentChooserMenu, showNumbers);
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
