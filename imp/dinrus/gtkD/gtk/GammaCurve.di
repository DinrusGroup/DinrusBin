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
 * inFile  = GtkGammaCurve.html
 * outPack = gtk
 * outFile = GammaCurve
 * strct   = GtkGammaCurve
 * realStrct=
 * ctorStrct=
 * clss    = GammaCurve
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_gamma_curve_
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

module gtkD.gtk.GammaCurve;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;





private import gtkD.gtk.VBox;

/**
 * Description
 * Note
 *  This widget is considered too specialized/little-used for
 *  GTK+, and will in the future be moved to some other package. If
 *  your application needs this widget, feel free to use it, as the
 *  widget does work and is useful in some applications; it's just not
 *  of general interest. However, we are not accepting new features for
 *  the widget, and it will eventually move out of the GTK+
 *  distribution.
 * The GtkGammaCurve widget is a variant of GtkCurve specifically for
 * editing gamma curves, which are used in graphics applications such as the
 * Gimp.
 * The GtkGammaCurve widget shows a curve which the user can edit with the
 * mouse just like a GtkCurve widget. On the right of the curve it also displays
 * 5 buttons, 3 of which change between the 3 curve modes (spline, linear and
 * free), and the other 2 set the curve to a particular gamma value, or reset it
 * to a straight line.
 */
public class GammaCurve : VBox
{
	
	/** the main Gtk struct */
	protected GtkGammaCurve* gtkGammaCurve;
	
	
	public GtkGammaCurve* getGammaCurveStruct()
	{
		return gtkGammaCurve;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkGammaCurve;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkGammaCurve* gtkGammaCurve)
	{
		if(gtkGammaCurve is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkGammaCurve);
		if( ptr !is null )
		{
			this = cast(GammaCurve)ptr;
			return;
		}
		super(cast(GtkVBox*)gtkGammaCurve);
		this.gtkGammaCurve = gtkGammaCurve;
	}
	
	/**
	 */
	
	/**
	 * Creates a new GtkGammaCurve.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GtkWidget* gtk_gamma_curve_new (void);
		auto p = gtk_gamma_curve_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_gamma_curve_new()");
		}
		this(cast(GtkGammaCurve*) p);
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
