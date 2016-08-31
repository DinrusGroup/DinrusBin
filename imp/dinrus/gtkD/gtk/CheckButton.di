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
 * inFile  = GtkCheckButton.html
 * outPack = gtk
 * outFile = CheckButton
 * strct   = GtkCheckButton
 * realStrct=
 * ctorStrct=
 * clss    = CheckButton
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_check_button_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * 	- gtk_check_button_new_with_label
 * 	- gtk_check_button_new_with_mnemonic
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gtk.Button
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.CheckButton;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Button;



private import gtkD.gtk.ToggleButton;

/**
 * Description
 * A GtkCheckButton places a discrete GtkToggleButton next to a widget, (usually a GtkLabel). See the section on GtkToggleButton widgets for more information about toggle/check buttons.
 * The important signal ('toggled') is also inherited from GtkToggleButton.
 */
public class CheckButton : ToggleButton
{
	
	/** the main Gtk struct */
	protected GtkCheckButton* gtkCheckButton;
	
	
	public GtkCheckButton* getCheckButtonStruct()
	{
		return gtkCheckButton;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkCheckButton;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkCheckButton* gtkCheckButton)
	{
		if(gtkCheckButton is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkCheckButton);
		if( ptr !is null )
		{
			this = cast(CheckButton)ptr;
			return;
		}
		super(cast(GtkToggleButton*)gtkCheckButton);
		this.gtkCheckButton = gtkCheckButton;
	}
	
	/**
	 * Creates a new GtkCheckButton with a GtkLabel to the right of it.
	 * If mnemonic is true the label
	 * will be created using gtk_label_new_with_mnemonic(), so underscores
	 * in label indicate the mnemonic for the check button.
	 * Params:
	 *  label = The text of the button, with an underscore in front of the
	 *  mnemonic character
	 *  mnemonic = true if the button has an mnemnonic
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string label, bool mnemonic=true)
	{
		GtkCheckButton* p;
		
		if ( mnemonic )
		{
			// GtkWidget* gtk_check_button_new_with_mnemonic  (const gchar *label);
			p = cast(GtkCheckButton*)gtk_check_button_new_with_mnemonic(Str.toStringz(label));
		}
		else
		{
			// GtkWidget* gtk_check_button_new_with_label (const gchar *label);
			p = cast(GtkCheckButton*)gtk_check_button_new_with_label(Str.toStringz(label));
		}
		
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_check_button_new_");
		}
		
		this(p);
	}
	
	/** */
	public this(string label, void delegate(CheckButton) onClicked, bool mnemonic=true)
	{
		this(label, mnemonic);
		addOnClicked(cast(void delegate(Button))onClicked);
	}
	
	
	/**
	 */
	
	/**
	 * Creates a new GtkCheckButton.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GtkWidget* gtk_check_button_new (void);
		auto p = gtk_check_button_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_check_button_new()");
		}
		this(cast(GtkCheckButton*) p);
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
