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
 * inFile  = GtkHScrollbar.html
 * outPack = gtk
 * outFile = HScrollbar
 * strct   = GtkHScrollbar
 * realStrct=
 * ctorStrct=
 * clss    = HScrollbar
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_hscrollbar_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.gtk.Adjustment
 * structWrap:
 * 	- GtkAdjustment* -> Adjustment
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.HScrollbar;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Adjustment;



private import gtkD.gtk.Scrollbar;

/**
 * Description
 * The GtkHScrollbar widget is a widget arranged horizontally creating a
 * scrollbar. See GtkScrollbar for details on
 * scrollbars. GtkAdjustment pointers may be added to handle the
 * adjustment of the scrollbar or it may be left NULL in which case one
 * will be created for you. See GtkScrollbar for a description of what the
 * fields in an adjustment represent for a scrollbar.
 */
public class HScrollbar : Scrollbar
{
	
	/** the main Gtk struct */
	protected GtkHScrollbar* gtkHScrollbar;
	
	
	public GtkHScrollbar* getHScrollbarStruct()
	{
		return gtkHScrollbar;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkHScrollbar;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkHScrollbar* gtkHScrollbar)
	{
		if(gtkHScrollbar is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkHScrollbar);
		if( ptr !is null )
		{
			this = cast(HScrollbar)ptr;
			return;
		}
		super(cast(GtkScrollbar*)gtkHScrollbar);
		this.gtkHScrollbar = gtkHScrollbar;
	}
	
	/**
	 */
	
	/**
	 * Creates a new horizontal scrollbar.
	 * Params:
	 * adjustment =  the GtkAdjustment to use, or NULL to create a new adjustment
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Adjustment adjustment)
	{
		// GtkWidget* gtk_hscrollbar_new (GtkAdjustment *adjustment);
		auto p = gtk_hscrollbar_new((adjustment is null) ? null : adjustment.getAdjustmentStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_hscrollbar_new((adjustment is null) ? null : adjustment.getAdjustmentStruct())");
		}
		this(cast(GtkHScrollbar*) p);
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
