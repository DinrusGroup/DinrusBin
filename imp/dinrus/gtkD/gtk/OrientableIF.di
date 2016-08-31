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
 * inFile  = gtk-Orientable.html
 * outPack = gtk
 * outFile = OrientableIF
 * strct   = GtkOrientable
 * realStrct=
 * ctorStrct=
 * clss    = OrientableT
 * interf  = OrientableIF
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_orientable_
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

module gtkD.gtk.OrientableIF;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * The GtkOrientable interface is implemented by all widgets that can be
 * oriented horizontally or vertically. Historically, such widgets have been
 * realized as subclasses of a common base class (e.g GtkBox/GtkHBox/GtkVBox
 * and GtkScale/GtkHScale/GtkVScale). GtkOrientable is more flexible in that
 * it allows the orientation to be changed at runtime, allowing the widgets
 * to 'flip'.
 * GtkOrientable was introduced in GTK+ 2.16.
 */
public interface OrientableIF
{
	
	
	public GtkOrientable* getOrientableTStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	
	/**
	 */
	
	/**
	 * Retrieves the orientation of the orientable.
	 * Since 2.16
	 * Returns: the orientation of the orientable.
	 */
	public GtkOrientation getOrientation();
	
	/**
	 * Sets the orientation of the orientable.
	 * Since 2.16
	 * Params:
	 * orientation =  the orientable's new orientation.
	 */
	public void setOrientation(GtkOrientation orientation);
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
