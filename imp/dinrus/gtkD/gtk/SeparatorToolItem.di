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
 * inFile  = GtkSeparatorToolItem.html
 * outPack = gtk
 * outFile = SeparatorToolItem
 * strct   = GtkSeparatorToolItem
 * realStrct=
 * ctorStrct=GtkToolItem
 * clss    = SeparatorToolItem
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_separator_tool_item_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.gtk.ToolItem
 * structWrap:
 * 	- GtkToolItem* -> ToolItem
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.SeparatorToolItem;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.ToolItem;



private import gtkD.gtk.ToolItem;

/**
 * Description
 *  A GtkSeparatorItem is a GtkToolItem that separates groups of other
 *  GtkToolItems. Depending on the theme, a GtkSeparatorToolItem will
 *  often look like a vertical line on horizontally docked toolbars.
 * If the property "expand" is TRUE and the property "draw" is FALSE, a
 * GtkSeparatorToolItem will act as a "spring" that forces other items
 * to the ends of the toolbar.
 *  Use gtk_separator_tool_item_new() to create a new GtkSeparatorToolItem.
 */
public class SeparatorToolItem : ToolItem
{
	
	/** the main Gtk struct */
	protected GtkSeparatorToolItem* gtkSeparatorToolItem;
	
	
	public GtkSeparatorToolItem* getSeparatorToolItemStruct()
	{
		return gtkSeparatorToolItem;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkSeparatorToolItem;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSeparatorToolItem* gtkSeparatorToolItem)
	{
		if(gtkSeparatorToolItem is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkSeparatorToolItem);
		if( ptr !is null )
		{
			this = cast(SeparatorToolItem)ptr;
			return;
		}
		super(cast(GtkToolItem*)gtkSeparatorToolItem);
		this.gtkSeparatorToolItem = gtkSeparatorToolItem;
	}
	
	/**
	 */
	
	/**
	 * Create a new GtkSeparatorToolItem
	 * Since 2.4
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GtkToolItem * gtk_separator_tool_item_new (void);
		auto p = gtk_separator_tool_item_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_separator_tool_item_new()");
		}
		this(cast(GtkSeparatorToolItem*) p);
	}
	
	/**
	 * Whether item is drawn as a vertical line, or just blank.
	 * Setting this to FALSE along with gtk_tool_item_set_expand() is useful
	 * to create an item that forces following items to the end of the toolbar.
	 * Since 2.4
	 * Params:
	 * draw =  whether item is drawn as a vertical line
	 */
	public void setDraw(int draw)
	{
		// void gtk_separator_tool_item_set_draw (GtkSeparatorToolItem *item,  gboolean draw);
		gtk_separator_tool_item_set_draw(gtkSeparatorToolItem, draw);
	}
	
	/**
	 * Returns whether item is drawn as a line, or just blank.
	 * See gtk_separator_tool_item_set_draw().
	 * Since 2.4
	 * Returns: TRUE if item is drawn as a line, or just blank.
	 */
	public int getDraw()
	{
		// gboolean gtk_separator_tool_item_get_draw (GtkSeparatorToolItem *item);
		return gtk_separator_tool_item_get_draw(gtkSeparatorToolItem);
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
