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
 * inFile  = GtkVolumeButton.html
 * outPack = gtk
 * outFile = VolumeButton
 * strct   = GtkVolumeButton
 * realStrct=
 * ctorStrct=
 * clss    = VolumeButton
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_volume_button_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gtk.Widget
 * structWrap:
 * 	- GtkWidget* -> Widget
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.VolumeButton;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Widget;



private import gtkD.gtk.ScaleButton;

/**
 * Description
 * GtkVolumeButton is a subclass of GtkScaleButton that has
 * been tailored for use as a volume control widget with suitable
 * icons, tooltips and accessible labels.
 */
public class VolumeButton : ScaleButton
{
	
	/** the main Gtk struct */
	protected GtkVolumeButton* gtkVolumeButton;
	
	
	public GtkVolumeButton* getVolumeButtonStruct()
	{
		return gtkVolumeButton;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkVolumeButton;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkVolumeButton* gtkVolumeButton)
	{
		if(gtkVolumeButton is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkVolumeButton);
		if( ptr !is null )
		{
			this = cast(VolumeButton)ptr;
			return;
		}
		super(cast(GtkScaleButton*)gtkVolumeButton);
		this.gtkVolumeButton = gtkVolumeButton;
	}
	
	/**
	 */
	
	/**
	 * Creates a GtkVolumeButton, with a range between 0.0 and 1.0, with
	 * a stepping of 0.02. Volume values can be obtained and modified using
	 * the functions from GtkScaleButton.
	 * Since 2.12
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GtkWidget* gtk_volume_button_new (void);
		auto p = gtk_volume_button_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_volume_button_new()");
		}
		this(cast(GtkVolumeButton*) p);
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
