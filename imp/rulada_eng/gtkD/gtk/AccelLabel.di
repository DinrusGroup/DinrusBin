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
 * inFile  = GtkAccelLabel.html
 * outPack = gtk
 * outFile = AccelLabel
 * strct   = GtkAccelLabel
 * realStrct=
 * ctorStrct=
 * clss    = AccelLabel
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_accel_label_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gobject.Closure
 * 	- gtkD.gtk.Widget
 * 	- gtkD.pango.PgAttributeList
 * 	- gtkD.pango.PgLayout
 * structWrap:
 * 	- GClosure* -> Closure
 * 	- GtkWidget* -> Widget
 * 	- PangoAttrList* -> PgAttributeList
 * 	- PangoLayout* -> PgLayout
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.AccelLabel;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gobject.Closure;
private import gtkD.gtk.Widget;
private import gtkD.pango.PgAttributeList;
private import gtkD.pango.PgLayout;



private import gtkD.gtk.Label;

/**
 * Description
 * The GtkAccelLabel widget is a subclass of GtkLabel that also displays an
 * accelerator key on the right of the label text, e.g. 'Ctl+S'.
 * It is commonly used in menus to show the keyboard short-cuts for commands.
 * The accelerator key to display is not set explicitly.
 * Instead, the GtkAccelLabel displays the accelerators which have been added to
 * a particular widget. This widget is set by calling
 * gtk_accel_label_set_accel_widget().
 * For example, a GtkMenuItem widget may have an accelerator added to emit the
 * "activate" signal when the 'Ctl+S' key combination is pressed.
 * A GtkAccelLabel is created and added to the GtkMenuItem, and
 * gtk_accel_label_set_accel_widget() is called with the GtkMenuItem as the
 * second argument. The GtkAccelLabel will now display 'Ctl+S' after its label.
 * Note that creating a GtkMenuItem with gtk_menu_item_new_with_label() (or
 * one of the similar functions for GtkCheckMenuItem and GtkRadioMenuItem)
 * automatically adds a GtkAccelLabel to the GtkMenuItem and calls
 * gtk_accel_label_set_accel_widget() to set it up for you.
 * A GtkAccelLabel will only display accelerators which have GTK_ACCEL_VISIBLE
 * set (see GtkAccelFlags).
 * A GtkAccelLabel can display multiple accelerators and even signal names,
 * though it is almost always used to display just one accelerator key.
 * Example 11. Creating a simple menu item with an accelerator key.
 *  GtkWidget *save_item;
 *  GtkAccelGroup *accel_group;
 *  /+* Create a GtkAccelGroup and add it to the window. +/
 *  accel_group = gtk_accel_group_new ();
 *  gtk_window_add_accel_group (GTK_WINDOW (window), accel_group);
 *  /+* Create the menu item using the convenience function. +/
 *  save_item = gtk_menu_item_new_with_label ("Save");
 *  gtk_widget_show (save_item);
 *  gtk_container_add (GTK_CONTAINER (menu), save_item);
 *  /+* Now add the accelerator to the GtkMenuItem. Note that since we called
 *  gtk_menu_item_new_with_label() to create the GtkMenuItem the
 *  GtkAccelLabel is automatically set up to display the GtkMenuItem
 *  accelerators. We just need to make sure we use GTK_ACCEL_VISIBLE here. +/
 *  gtk_widget_add_accelerator (save_item, "activate", accel_group,
 *  GDK_s, GDK_CONTROL_MASK, GTK_ACCEL_VISIBLE);
 */
public class AccelLabel : Label
{
	
	/** the main Gtk struct */
	protected GtkAccelLabel* gtkAccelLabel;
	
	
	public GtkAccelLabel* getAccelLabelStruct()
	{
		return gtkAccelLabel;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkAccelLabel;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkAccelLabel* gtkAccelLabel)
	{
		if(gtkAccelLabel is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkAccelLabel);
		if( ptr !is null )
		{
			this = cast(AccelLabel)ptr;
			return;
		}
		super(cast(GtkLabel*)gtkAccelLabel);
		this.gtkAccelLabel = gtkAccelLabel;
	}
	
	/**
	 */
	
	/**
	 * Creates a new GtkAccelLabel.
	 * Params:
	 * string = the label string. Must be non-NULL.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string string)
	{
		// GtkWidget* gtk_accel_label_new (const gchar *string);
		auto p = gtk_accel_label_new(Str.toStringz(string));
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_accel_label_new(Str.toStringz(string))");
		}
		this(cast(GtkAccelLabel*) p);
	}
	
	/**
	 * Sets the closure to be monitored by this accelerator label. The closure
	 * must be connected to an accelerator group; see gtk_accel_group_connect().
	 * Params:
	 * accelClosure =  the closure to monitor for accelerator changes.
	 */
	public void setAccelClosure(Closure accelClosure)
	{
		// void gtk_accel_label_set_accel_closure (GtkAccelLabel *accel_label,  GClosure *accel_closure);
		gtk_accel_label_set_accel_closure(gtkAccelLabel, (accelClosure is null) ? null : accelClosure.getClosureStruct());
	}
	
	/**
	 * Fetches the widget monitored by this accelerator label. See
	 * gtk_accel_label_set_accel_widget().
	 * Returns: the object monitored by the accelerator label, or NULL.
	 */
	public Widget getAccelWidget()
	{
		// GtkWidget* gtk_accel_label_get_accel_widget (GtkAccelLabel *accel_label);
		auto p = gtk_accel_label_get_accel_widget(gtkAccelLabel);
		if(p is null)
		{
			return null;
		}
		return new Widget(cast(GtkWidget*) p);
	}
	
	/**
	 * Sets the widget to be monitored by this accelerator label.
	 * Params:
	 * accelWidget =  the widget to be monitored.
	 */
	public void setAccelWidget(Widget accelWidget)
	{
		// void gtk_accel_label_set_accel_widget (GtkAccelLabel *accel_label,  GtkWidget *accel_widget);
		gtk_accel_label_set_accel_widget(gtkAccelLabel, (accelWidget is null) ? null : accelWidget.getWidgetStruct());
	}
	
	/**
	 * Returns the width needed to display the accelerator key(s).
	 * This is used by menus to align all of the GtkMenuItem widgets, and shouldn't
	 * be needed by applications.
	 * Returns:the width needed to display the accelerator key(s).
	 */
	public uint getAccelWidth()
	{
		// guint gtk_accel_label_get_accel_width (GtkAccelLabel *accel_label);
		return gtk_accel_label_get_accel_width(gtkAccelLabel);
	}
	
	/**
	 * Recreates the string representing the accelerator keys.
	 * This should not be needed since the string is automatically updated whenever
	 * accelerators are added or removed from the associated widget.
	 * Returns:always returns FALSE.
	 */
	public int refetch()
	{
		// gboolean gtk_accel_label_refetch (GtkAccelLabel *accel_label);
		return gtk_accel_label_refetch(gtkAccelLabel);
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
