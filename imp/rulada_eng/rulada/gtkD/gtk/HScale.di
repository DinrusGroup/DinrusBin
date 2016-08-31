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
 * inFile  = GtkHScale.html
 * outPack = gtk
 * outFile = HScale
 * strct   = GtkHScale
 * realStrct=
 * ctorStrct=
 * clss    = HScale
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_hscale_
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

module gtkD.gtk.HScale;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Adjustment;



private import gtkD.gtk.Scale;

/**
 * Description
 * The GtkHScale widget is used to allow the user to select a value using
 * a horizontal slider. To create one, use gtk_hscale_new_with_range().
 * The position to show the current value, and the number of decimal places
 * shown can be set using the parent GtkScale class's functions.
 */
public class HScale : Scale
{
	
	/** the main Gtk struct */
	protected GtkHScale* gtkHScale;
	
	
	public GtkHScale* getHScaleStruct()
	{
		return gtkHScale;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkHScale;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkHScale* gtkHScale)
	{
		if(gtkHScale is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkHScale);
		if( ptr !is null )
		{
			this = cast(HScale)ptr;
			return;
		}
		super(cast(GtkScale*)gtkHScale);
		this.gtkHScale = gtkHScale;
	}
	
	/**
	 */
	
	/**
	 * Creates a new GtkHScale.
	 * Params:
	 * adjustment = the GtkAdjustment which sets the range of the scale.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Adjustment adjustment)
	{
		// GtkWidget* gtk_hscale_new (GtkAdjustment *adjustment);
		auto p = gtk_hscale_new((adjustment is null) ? null : adjustment.getAdjustmentStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_hscale_new((adjustment is null) ? null : adjustment.getAdjustmentStruct())");
		}
		this(cast(GtkHScale*) p);
	}
	
	/**
	 * Creates a new horizontal scale widget that lets the user input a
	 * number between min and max (including min and max) with the
	 * increment step. step must be nonzero; it's the distance the
	 * slider moves when using the arrow keys to adjust the scale value.
	 * Note that the way in which the precision is derived works best if step
	 * is a power of ten. If the resulting precision is not suitable for your
	 * needs, use gtk_scale_set_digits() to correct it.
	 * Params:
	 * min =  minimum value
	 * max =  maximum value
	 * step =  step increment (tick size) used with keyboard shortcuts
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (double min, double max, double step)
	{
		// GtkWidget* gtk_hscale_new_with_range (gdouble min,  gdouble max,  gdouble step);
		auto p = gtk_hscale_new_with_range(min, max, step);
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_hscale_new_with_range(min, max, step)");
		}
		this(cast(GtkHScale*) p);
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
