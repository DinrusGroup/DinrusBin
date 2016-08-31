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
 * inFile  = GtkImageMenuItem.html
 * outPack = gtk
 * outFile = ImageMenuItem
 * strct   = GtkImageMenuItem
 * realStrct=
 * ctorStrct=
 * clss    = ImageMenuItem
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_image_menu_item_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * 	- gtk_image_menu_item_new_with_label
 * 	- gtk_image_menu_item_new_with_mnemonic
 * 	- gtk_image_menu_item_new_from_stock
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gtk.Widget
 * 	- gtkD.gtk.AccelGroup
 * structWrap:
 * 	- GtkAccelGroup* -> AccelGroup
 * 	- GtkWidget* -> Widget
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.ImageMenuItem;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Widget;
private import gtkD.gtk.AccelGroup;



private import gtkD.gtk.MenuItem;

/**
 * Description
 * A GtkImageMenuItem is a menu item which has an icon next to the text label.
 * Note that the user can disable display of menu icons, so make sure to still
 * fill in the text label.
 */
public class ImageMenuItem : MenuItem
{
	
	/** the main Gtk struct */
	protected GtkImageMenuItem* gtkImageMenuItem;
	
	
	public GtkImageMenuItem* getImageMenuItemStruct()
	{
		return gtkImageMenuItem;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkImageMenuItem;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkImageMenuItem* gtkImageMenuItem)
	{
		if(gtkImageMenuItem is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkImageMenuItem);
		if( ptr !is null )
		{
			this = cast(ImageMenuItem)ptr;
			return;
		}
		super(cast(GtkMenuItem*)gtkImageMenuItem);
		this.gtkImageMenuItem = gtkImageMenuItem;
	}
	
	/**
	 * Creates a new GtkImageMenuItem containing a label.
	 * If mnemonic it true the label
	 * will be created using gtk_label_new_with_mnemonic(), so underscores
	 * in label indicate the mnemonic for the menu item.
	 * Params:
	 *  label = the text of the menu item.
	 * Returns:
	 *  a new GtkImageMenuItem.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string label, bool mnemonic=true)
	{
		GtkImageMenuItem* p;
		
		if ( mnemonic )
		{
			// GtkWidget* gtk_image_menu_item_new_with_mnemonic  (const gchar *label);
			p = cast(GtkImageMenuItem*)gtk_image_menu_item_new_with_mnemonic(Str.toStringz(label));
		}
		else
		{
			// GtkWidget* gtk_image_menu_item_new_with_label  (const gchar *label);
			p = cast(GtkImageMenuItem*)gtk_image_menu_item_new_with_label(Str.toStringz(label));
		}
		
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_image_menu_item_new_with_");
		}
		
		this(p);
	}
	
	/**
	 * Creates a new GtkImageMenuItem containing the image and text from a
	 * stock item. Some stock ids have preprocessor macros like GTK_STOCK_OK
	 * and GTK_STOCK_APPLY.
	 * If you want this menu item to have changeable accelerators, then pass in
	 * NULL for accel_group. Next call gtk_menu_item_set_accel_path() with an
	 * appropriate path for the menu item, use gtk_stock_lookup() to look up the
	 * standard accelerator for the stock item, and if one is found, call
	 * gtk_accel_map_add_entry() to register it.
	 * Params:
	 * StockID = the name of the stock item
	 * accelGroup =  the GtkAccelGroup to add the menu items accelerator to,
	 *  or NULL.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (StockID stockID, AccelGroup accelGroup)
	{
		// GtkWidget* gtk_image_menu_item_new_from_stock (const gchar *stock_id,  GtkAccelGroup *accel_group);
		auto p = gtk_image_menu_item_new_from_stock(Str.toStringz(StockDesc[stockID]), (accelGroup is null) ? null : accelGroup.getAccelGroupStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_image_menu_item_new_from_stock");
		}
		this(cast(GtkImageMenuItem*) p);
	}
	
	/**
	 */
	
	/**
	 * Sets the image of image_menu_item to the given widget.
	 * Note that it depends on the show-menu-images setting whether
	 * the image will be displayed or not.
	 * Params:
	 * image =  a widget to set as the image for the menu item.
	 */
	public void setImage(Widget image)
	{
		// void gtk_image_menu_item_set_image (GtkImageMenuItem *image_menu_item,  GtkWidget *image);
		gtk_image_menu_item_set_image(gtkImageMenuItem, (image is null) ? null : image.getWidgetStruct());
	}
	
	/**
	 * Gets the widget that is currently set as the image of image_menu_item.
	 * See gtk_image_menu_item_set_image().
	 * Returns: the widget set as image of image_menu_item.
	 */
	public Widget getImage()
	{
		// GtkWidget* gtk_image_menu_item_get_image (GtkImageMenuItem *image_menu_item);
		auto p = gtk_image_menu_item_get_image(gtkImageMenuItem);
		if(p is null)
		{
			return null;
		}
		return new Widget(cast(GtkWidget*) p);
	}
	
	/**
	 * Creates a new GtkImageMenuItem with an empty label.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GtkWidget* gtk_image_menu_item_new (void);
		auto p = gtk_image_menu_item_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_image_menu_item_new()");
		}
		this(cast(GtkImageMenuItem*) p);
	}
	
	/**
	 * Checks whether the label set in the menuitem is used as a
	 * stock id to select the stock item for the item.
	 * Since 2.16
	 * Returns: TRUE if the label set in the menuitem is used as a stock id to select the stock item for the item
	 */
	public int getUseStock()
	{
		// gboolean gtk_image_menu_item_get_use_stock (GtkImageMenuItem *image_menu_item);
		return gtk_image_menu_item_get_use_stock(gtkImageMenuItem);
	}
	
	/**
	 * If TRUE, the label set in the menuitem is used as a
	 * stock id to select the stock item for the item.
	 * Since 2.16
	 * Params:
	 * useStock =  TRUE if the menuitem should use a stock item
	 */
	public void setUseStock(int useStock)
	{
		// void gtk_image_menu_item_set_use_stock (GtkImageMenuItem *image_menu_item,  gboolean use_stock);
		gtk_image_menu_item_set_use_stock(gtkImageMenuItem, useStock);
	}
	
	/**
	 * Returns whether the menu item will ignore the "gtk-menu-images"
	 * setting and always show the image, if available.
	 * Since 2.16
	 * Returns: TRUE if the menu item will always show the image
	 */
	public int getAlwaysShowImage()
	{
		// gboolean gtk_image_menu_item_get_always_show_image  (GtkImageMenuItem *image_menu_item);
		return gtk_image_menu_item_get_always_show_image(gtkImageMenuItem);
	}
	
	/**
	 * If TRUE, the menu item will ignore the "gtk-menu-images"
	 * setting and always show the image, if available.
	 * Use this property if the menuitem would be useless or hard to use
	 * without the image.
	 * Since 2.16
	 * Params:
	 * alwaysShow =  TRUE if the menuitem should always show the image
	 */
	public void setAlwaysShowImage(int alwaysShow)
	{
		// void gtk_image_menu_item_set_always_show_image  (GtkImageMenuItem *image_menu_item,  gboolean always_show);
		gtk_image_menu_item_set_always_show_image(gtkImageMenuItem, alwaysShow);
	}
	
	/**
	 * Specifies an accel_group to add the menu items accelerator to
	 * (this only applies to stock items so a stock item must already
	 * be set, make sure to call gtk_image_menu_item_set_use_stock()
	 * and gtk_menu_item_set_label() with a valid stock item first).
	 * If you want this menu item to have changeable accelerators then
	 * you shouldnt need this (see gtk_image_menu_item_new_from_stock()).
	 * Since 2.16
	 * Params:
	 * accelGroup =  the GtkAccelGroup
	 */
	public void setAccelGroup(AccelGroup accelGroup)
	{
		// void gtk_image_menu_item_set_accel_group (GtkImageMenuItem *image_menu_item,  GtkAccelGroup *accel_group);
		gtk_image_menu_item_set_accel_group(gtkImageMenuItem, (accelGroup is null) ? null : accelGroup.getAccelGroupStruct());
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
