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
 * inFile  = GtkMenuBar.html
 * outPack = gtk
 * outFile = MenuBar
 * strct   = GtkMenuBar
 * realStrct=
 * ctorStrct=
 * clss    = MenuBar
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_menu_bar_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.gtk.Widget
 * 	- gtkD.gtk.Menu;
 * 	- gtkD.gtk.MenuItem;
 * structWrap:
 * 	- GtkMenu* -> Menu
 * 	- GtkMenuItem* -> MenuItem
 * 	- GtkWidget* -> Widget
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.MenuBar;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Widget;
private import gtkD.gtk.Menu;;
private import gtkD.gtk.MenuItem;;



private import gtkD.gtk.MenuShell;

/**
 * Description
 * The GtkMenuBar is a subclass of GtkMenuShell which contains one to many GtkMenuItem. The result is a standard menu bar which can hold many menu items. GtkMenuBar allows for a shadow type to be set for aesthetic purposes. The shadow types are defined in the gtk_menu_bar_set_shadow_type function.
 */
public class MenuBar : MenuShell
{
	
	/** the main Gtk struct */
	protected GtkMenuBar* gtkMenuBar;
	
	
	public GtkMenuBar* getMenuBarStruct()
	{
		return gtkMenuBar;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkMenuBar;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkMenuBar* gtkMenuBar)
	{
		if(gtkMenuBar is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkMenuBar);
		if( ptr !is null )
		{
			this = cast(MenuBar)ptr;
			return;
		}
		super(cast(GtkMenuShell*)gtkMenuBar);
		this.gtkMenuBar = gtkMenuBar;
	}
	
	/** */
	Menu append(string label, bool rightJustify=false)
	{
		MenuItem item = new MenuItem(label);
		super.append(item);
		item.setRightJustified(rightJustify);
		Menu menu= new Menu();
		item.setSubmenu(menu);
		return menu;
	}
	
	/** */
	public override void append(Widget widget)
	{
		super.append(widget);
	}
	
	/**
	 */
	
	/**
	 * Creates the new GtkMenuBar
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GtkWidget* gtk_menu_bar_new (void);
		auto p = gtk_menu_bar_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_menu_bar_new()");
		}
		this(cast(GtkMenuBar*) p);
	}
	
	/**
	 * Sets how items should be packed inside a menubar.
	 * Since 2.8
	 * Params:
	 * packDir =  a new GtkPackDirection
	 */
	public void setPackDirection(GtkPackDirection packDir)
	{
		// void gtk_menu_bar_set_pack_direction (GtkMenuBar *menubar,  GtkPackDirection pack_dir);
		gtk_menu_bar_set_pack_direction(gtkMenuBar, packDir);
	}
	
	/**
	 * Retrieves the current pack direction of the menubar.
	 * See gtk_menu_bar_set_pack_direction().
	 * Since 2.8
	 * Returns: the pack direction
	 */
	public GtkPackDirection getPackDirection()
	{
		// GtkPackDirection gtk_menu_bar_get_pack_direction (GtkMenuBar *menubar);
		return gtk_menu_bar_get_pack_direction(gtkMenuBar);
	}
	
	/**
	 * Sets how widgets should be packed inside the children of a menubar.
	 * Since 2.8
	 * Params:
	 * childPackDir =  a new GtkPackDirection
	 */
	public void setChildPackDirection(GtkPackDirection childPackDir)
	{
		// void gtk_menu_bar_set_child_pack_direction  (GtkMenuBar *menubar,  GtkPackDirection child_pack_dir);
		gtk_menu_bar_set_child_pack_direction(gtkMenuBar, childPackDir);
	}
	
	/**
	 * Retrieves the current child pack direction of the menubar.
	 * See gtk_menu_bar_set_child_pack_direction().
	 * Since 2.8
	 * Returns: the child pack direction
	 */
	public GtkPackDirection getChildPackDirection()
	{
		// GtkPackDirection gtk_menu_bar_get_child_pack_direction  (GtkMenuBar *menubar);
		return gtk_menu_bar_get_child_pack_direction(gtkMenuBar);
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
