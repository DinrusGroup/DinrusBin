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
 * inFile  = GtkPageSetupUnixDialog.html
 * outPack = gtk
 * outFile = PageSetupUnixDialog
 * strct   = GtkPageSetupUnixDialog
 * realStrct=
 * ctorStrct=
 * clss    = PageSetupUnixDialog
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_page_setup_unix_dialog_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gtk.Widget
 * 	- gtkD.gtk.Window
 * 	- gtkD.gtk.PageSetup
 * 	- gtkD.gtk.PrintSettings
 * structWrap:
 * 	- GtkPageSetup* -> PageSetup
 * 	- GtkPrintSettings* -> PrintSettings
 * 	- GtkWidget* -> Widget
 * 	- GtkWindow* -> Window
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.PageSetupUnixDialog;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Widget;
private import gtkD.gtk.Window;
private import gtkD.gtk.PageSetup;
private import gtkD.gtk.PrintSettings;



private import gtkD.gtk.Dialog;

/**
 * Description
 * GtkPageSetupUnixDialog implements a page setup dialog for platforms
 * which don't provide a native page setup dialog, like Unix. It can
 * be used very much like any other GTK+ dialog, at the cost of
 * the portability offered by the high-level printing API
 * Printing support was added in GTK+ 2.10.
 */
public class PageSetupUnixDialog : Dialog
{
	
	/** the main Gtk struct */
	protected GtkPageSetupUnixDialog* gtkPageSetupUnixDialog;
	
	
	public GtkPageSetupUnixDialog* getPageSetupUnixDialogStruct()
	{
		return gtkPageSetupUnixDialog;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkPageSetupUnixDialog;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkPageSetupUnixDialog* gtkPageSetupUnixDialog)
	{
		if(gtkPageSetupUnixDialog is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkPageSetupUnixDialog);
		if( ptr !is null )
		{
			this = cast(PageSetupUnixDialog)ptr;
			return;
		}
		super(cast(GtkDialog*)gtkPageSetupUnixDialog);
		this.gtkPageSetupUnixDialog = gtkPageSetupUnixDialog;
	}
	
	/**
	 */
	
	/**
	 * Creates a new page setup dialog.
	 * Since 2.10
	 * Params:
	 * title =  the title of the dialog, or NULL
	 * parent =  transient parent of the dialog, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string title, Window parent)
	{
		// GtkWidget * gtk_page_setup_unix_dialog_new (const gchar *title,  GtkWindow *parent);
		auto p = gtk_page_setup_unix_dialog_new(Str.toStringz(title), (parent is null) ? null : parent.getWindowStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_page_setup_unix_dialog_new(Str.toStringz(title), (parent is null) ? null : parent.getWindowStruct())");
		}
		this(cast(GtkPageSetupUnixDialog*) p);
	}
	
	/**
	 * Sets the GtkPageSetup from which the page setup
	 * dialog takes its values.
	 * Since 2.10
	 * Params:
	 * pageSetup =  a GtkPageSetup
	 */
	public void setPageSetup(PageSetup pageSetup)
	{
		// void gtk_page_setup_unix_dialog_set_page_setup  (GtkPageSetupUnixDialog *dialog,  GtkPageSetup *page_setup);
		gtk_page_setup_unix_dialog_set_page_setup(gtkPageSetupUnixDialog, (pageSetup is null) ? null : pageSetup.getPageSetupStruct());
	}
	
	/**
	 * Gets the currently selected page setup from the dialog.
	 * Since 2.10
	 * Returns: the current page setup
	 */
	public PageSetup getPageSetup()
	{
		// GtkPageSetup * gtk_page_setup_unix_dialog_get_page_setup  (GtkPageSetupUnixDialog *dialog);
		auto p = gtk_page_setup_unix_dialog_get_page_setup(gtkPageSetupUnixDialog);
		if(p is null)
		{
			return null;
		}
		return new PageSetup(cast(GtkPageSetup*) p);
	}
	
	/**
	 * Sets the GtkPrintSettings from which the page setup dialog
	 * takes its values.
	 * Since 2.10
	 * Params:
	 * printSettings =  a GtkPrintSettings
	 */
	public void setPrintSettings(PrintSettings printSettings)
	{
		// void gtk_page_setup_unix_dialog_set_print_settings  (GtkPageSetupUnixDialog *dialog,  GtkPrintSettings *print_settings);
		gtk_page_setup_unix_dialog_set_print_settings(gtkPageSetupUnixDialog, (printSettings is null) ? null : printSettings.getPrintSettingsStruct());
	}
	
	/**
	 * Gets the current print settings from the dialog.
	 * Since 2.10
	 * Returns: the current print settings
	 */
	public PrintSettings getPrintSettings()
	{
		// GtkPrintSettings * gtk_page_setup_unix_dialog_get_print_settings  (GtkPageSetupUnixDialog *dialog);
		auto p = gtk_page_setup_unix_dialog_get_print_settings(gtkPageSetupUnixDialog);
		if(p is null)
		{
			return null;
		}
		return new PrintSettings(cast(GtkPrintSettings*) p);
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
