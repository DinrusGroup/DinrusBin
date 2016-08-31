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
 * inFile  = GtkColorSelectionDialog.html
 * outPack = gtk
 * outFile = ColorSelectionDialog
 * strct   = GtkColorSelectionDialog
 * realStrct=
 * ctorStrct=
 * clss    = ColorSelectionDialog
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_color_selection_dialog_
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

module gtkD.gtk.ColorSelectionDialog;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Widget;



private import gtkD.gtk.Dialog;

/**
 * Description
 * The GtkColorSelectionDialog provides a standard dialog which
 * allows the user to select a color much like the GtkFileSelection
 * provides a standard dialog for file selection.
 * GtkColorSelectionDialog as GtkBuildable
 * The GtkColorSelectionDialog implementation of the GtkBuildable interface
 * exposes the embedded GtkColorSelection as internal child with the
 * name "color_selection". It also exposes the buttons with the names
 * "ok_button", "cancel_button" and "help_button".
 */
public class ColorSelectionDialog : Dialog
{
	
	/** the main Gtk struct */
	protected GtkColorSelectionDialog* gtkColorSelectionDialog;
	
	
	public GtkColorSelectionDialog* getColorSelectionDialogStruct()
	{
		return gtkColorSelectionDialog;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkColorSelectionDialog;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkColorSelectionDialog* gtkColorSelectionDialog)
	{
		if(gtkColorSelectionDialog is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkColorSelectionDialog);
		if( ptr !is null )
		{
			this = cast(ColorSelectionDialog)ptr;
			return;
		}
		super(cast(GtkDialog*)gtkColorSelectionDialog);
		this.gtkColorSelectionDialog = gtkColorSelectionDialog;
	}
	
	/**
	 */
	
	/**
	 * Creates a new GtkColorSelectionDialog.
	 * Params:
	 * title = a string containing the title text for the dialog.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string title)
	{
		// GtkWidget* gtk_color_selection_dialog_new (const gchar *title);
		auto p = gtk_color_selection_dialog_new(Str.toStringz(title));
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_color_selection_dialog_new(Str.toStringz(title))");
		}
		this(cast(GtkColorSelectionDialog*) p);
	}
	
	/**
	 * Retrieves the GtkColorSelection widget embedded in the dialog.
	 * Since 2.14
	 * Returns: the embedded GtkColorSelection
	 */
	public Widget getColorSelection()
	{
		// GtkWidget* gtk_color_selection_dialog_get_color_selection  (GtkColorSelectionDialog *colorsel);
		auto p = gtk_color_selection_dialog_get_color_selection(gtkColorSelectionDialog);
		if(p is null)
		{
			return null;
		}
		return new Widget(cast(GtkWidget*) p);
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
