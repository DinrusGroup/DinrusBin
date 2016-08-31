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
 * inFile  = GtkScrollbar.html
 * outPack = gtk
 * outFile = Scrollbar
 * strct   = GtkScrollbar
 * realStrct=
 * ctorStrct=
 * clss    = Scrollbar
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_scrollbar_
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

module gtkD.gtk.Scrollbar;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;





private import gtkD.gtk.Range;

/**
 * Description
 * The GtkScrollbar widget is an abstract base class for GtkHScrollbar and
 * GtkVScrollbar. It is not very useful in itself.
 * The position of the thumb in a scrollbar is controlled by the scroll
 * adjustments. See GtkAdjustment for the fields in an adjustment - for
 * GtkScrollbar, the "value" field represents the position of the
 * scrollbar, which must be between the "lower" field and "upper -
 * page_size." The "page_size" field represents the size of the visible
 * scrollable area. The "step_increment" and "page_increment" fields are
 * used when the user asks to step down (using the small stepper arrows)
 * or page down (using for example the PageDown key).
 */
public class Scrollbar : Range
{
	
	/** the main Gtk struct */
	protected GtkScrollbar* gtkScrollbar;
	
	
	public GtkScrollbar* getScrollbarStruct()
	{
		return gtkScrollbar;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkScrollbar;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkScrollbar* gtkScrollbar)
	{
		if(gtkScrollbar is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkScrollbar);
		if( ptr !is null )
		{
			this = cast(Scrollbar)ptr;
			return;
		}
		super(cast(GtkRange*)gtkScrollbar);
		this.gtkScrollbar = gtkScrollbar;
	}
	
	/**
	 */
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
