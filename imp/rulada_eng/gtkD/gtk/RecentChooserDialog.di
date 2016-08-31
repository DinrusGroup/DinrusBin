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
 * inFile  = GtkRecentChooserDialog.html
 * outPack = gtk
 * outFile = RecentChooserDialog
 * strct   = GtkRecentChooserDialog
 * realStrct=
 * ctorStrct=
 * clss    = RecentChooserDialog
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * 	- RecentChooserIF
 * prefixes:
 * 	- gtk_recent_chooser_dialog_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * 	- gtk_recent_chooser_dialog_new
 * 	- gtk_recent_chooser_dialog_new_for_manager
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gtk.Widget
 * 	- gtkD.gtk.Window
 * 	- gtkD.gtk.RecentManager
 * 	- gtkD.gtk.RecentChooserIF
 * 	- gtkD.gtk.RecentChooserT
 * structWrap:
 * 	- GtkRecentManager* -> RecentManager
 * 	- GtkWidget* -> Widget
 * 	- GtkWindow* -> Window
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.RecentChooserDialog;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Widget;
private import gtkD.gtk.Window;
private import gtkD.gtk.RecentManager;
private import gtkD.gtk.RecentChooserIF;
private import gtkD.gtk.RecentChooserT;



private import gtkD.gtk.Dialog;

/**
 * Description
 * GtkRecentChooserDialog is a dialog box suitable for displaying the recently
 * used documents. This widgets works by putting a GtkRecentChooserWidget inside
 * a GtkDialog. It exposes the GtkRecentChooserIface interface, so you can use
 * all the GtkRecentChooser functions on the recent chooser dialog as well as
 * those for GtkDialog.
 * Note that GtkRecentChooserDialog does not have any methods of its own.
 * Instead, you should use the functions that work on a GtkRecentChooser.
 * Example 57. Typical usage
 *  In the simplest of cases, you can use the following code to use
 *  a GtkRecentChooserDialog to select a recently used file:
 * GtkWidget *dialog;
 * dialog = gtk_recent_chooser_dialog_new ("Recent Documents",
 * 					parent_window,
 * 					GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL,
 * 					GTK_STOCK_OPEN, GTK_RESPONSE_ACCEPT,
 * 					NULL);
 * if (gtk_dialog_run (GTK_DIALOG (dialog)) == GTK_RESPONSE_ACCEPT)
 *  {
	 *  GtkRecentInfo *info;
	 *  info = gtk_recent_chooser_get_current_item (GTK_RECENT_CHOOSER (dialog));
	 *  open_file (gtk_recent_info_get_uri (info));
	 *  gtk_recent_info_unref (info);
 *  }
 * gtk_widget_destroy (dialog);
 * Recently used files are supported since GTK+ 2.10.
 */
public class RecentChooserDialog : Dialog, RecentChooserIF
{
	
	/** the main Gtk struct */
	protected GtkRecentChooserDialog* gtkRecentChooserDialog;
	
	
	public GtkRecentChooserDialog* getRecentChooserDialogStruct()
	{
		return gtkRecentChooserDialog;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkRecentChooserDialog;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkRecentChooserDialog* gtkRecentChooserDialog)
	{
		if(gtkRecentChooserDialog is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkRecentChooserDialog);
		if( ptr !is null )
		{
			this = cast(RecentChooserDialog)ptr;
			return;
		}
		super(cast(GtkDialog*)gtkRecentChooserDialog);
		this.gtkRecentChooserDialog = gtkRecentChooserDialog;
	}
	
	// add the RecentChooser capabilities
	mixin RecentChooserT!(GtkRecentChooserDialog);
	
	/**
	 * Creates a new GtkRecentChooserDialog with a specified recent manager.
	 * This is useful if you have implemented your own recent manager, or if you
	 * have a customized instance of a GtkRecentManager object.
	 * Since 2.10
	 * Params:
	 *  title =  Title of the dialog, or null
	 *  parent =  Transient parent of the dialog, or null,
	 *  manager =  a GtkRecentManager, or null
	 *  buttonsText = text to go in the buttons
	 *  responses = response ID's for the buttons
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string title, Window parent, RecentManager manager,  string[] buttonsText=null, ResponseType[] responses=null )
	{
		// GtkWidget* gtk_recent_chooser_dialog_new_for_manager  (const gchar *title,  GtkWindow *parent,  GtkRecentManager *manager, const gchar *first_button_text,  ...);
		auto p = gtk_recent_chooser_dialog_new_for_manager(Str.toStringz(title), (parent is null) ? null : parent.getWindowStruct(), (manager is null) ? null : manager.getRecentManagerStruct(), null);
		{
			throw new ConstructionException("null returned by gtk_recent_chooser_dialog_new_for_manager");
		}
		this(cast(GtkRecentChooserDialog*) p);
		addButtons(buttonsText, responses);
	}
	
	/**
	 * Creates a new GtkRecentChooserDialog with a specified recent manager.
	 * This is useful if you have implemented your own recent manager, or if you
	 * have a customized instance of a GtkRecentManager object.
	 * Since 2.10
	 * Params:
	 *  title =  Title of the dialog, or null
	 *  parent =  Transient parent of the dialog, or null,
	 *  manager =  a GtkRecentManager, or null
	 *  stockIDs = stockIDs of the buttons
	 *  responses = response ID's for the buttons
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string title, Window parent, RecentManager manager,  StockID[] stockIDs, ResponseType[] responses=null )
	{
		// GtkWidget* gtk_recent_chooser_dialog_new_for_manager  (const gchar *title,  GtkWindow *parent,  GtkRecentManager *manager, const gchar *first_button_text,  ...);
		auto p = gtk_recent_chooser_dialog_new_for_manager(Str.toStringz(title), (parent is null) ? null : parent.getWindowStruct(), (manager is null) ? null : manager.getRecentManagerStruct(), null);
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_recent_chooser_dialog_new_for_manager");
		}
		this(cast(GtkRecentChooserDialog*) p);
		addButtons(stockIDs, responses);
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
