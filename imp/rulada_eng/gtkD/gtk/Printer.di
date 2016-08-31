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
 * inFile  = GtkPrinter.html
 * outPack = gtk
 * outFile = Printer
 * strct   = GtkPrinter
 * realStrct=
 * ctorStrct=
 * clss    = Printer
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_printer_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gtk.PageSetup
 * 	- gtkD.glib.ListG
 * structWrap:
 * 	- GList* -> ListG
 * 	- GtkPageSetup* -> PageSetup
 * 	- GtkPrinter* -> Printer
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.Printer;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.PageSetup;
private import gtkD.glib.ListG;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * A GtkPrinter object represents a printer. You only need to
 * deal directly with printers if you use the non-portable
 * GtkPrintUnixDialog API.
 * A GtkPrinter allows to get status information about the printer,
 * such as its description, its location, the number of queued jobs,
 * etc. Most importantly, a GtkPrinter object can be used to create
 * a GtkPrintJob object, which lets you print to the printer.
 * Printing support was added in GTK+ 2.10.
 */
public class Printer : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkPrinter* gtkPrinter;
	
	
	public GtkPrinter* getPrinterStruct()
	{
		return gtkPrinter;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkPrinter;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkPrinter* gtkPrinter)
	{
		if(gtkPrinter is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkPrinter);
		if( ptr !is null )
		{
			this = cast(Printer)ptr;
			return;
		}
		super(cast(GObject*)gtkPrinter);
		this.gtkPrinter = gtkPrinter;
	}
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(gboolean, Printer)[] onDetailsAcquiredListeners;
	/**
	 * Gets emitted in response to a request for detailed information
	 * about a printer from the print backend. The success parameter
	 * indicates if the information was actually obtained.
	 * Since 2.10
	 */
	void addOnDetailsAcquired(void delegate(gboolean, Printer) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		if ( !("details-acquired" in connectedSignals) )
		{
			Signals.connectData(
			getStruct(),
			"details-acquired",
			cast(GCallback)&callBackDetailsAcquired,
			cast(void*)this,
			null,
			connectFlags);
			connectedSignals["details-acquired"] = 1;
		}
		onDetailsAcquiredListeners ~= dlg;
	}
	extern(C) static void callBackDetailsAcquired(GtkPrinter* printerStruct, gboolean success, Printer printer)
	{
		foreach ( void delegate(gboolean, Printer) dlg ; printer.onDetailsAcquiredListeners )
		{
			dlg(success, printer);
		}
	}
	
	
	/**
	 * Creates a new GtkPrinter.
	 * Since 2.10
	 * Params:
	 * name =  the name of the printer
	 * backend =  a GtkPrintBackend
	 * virtual =  whether the printer is virtual
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, GtkPrintBackend* backend, int virtual)
	{
		// GtkPrinter * gtk_printer_new (const gchar *name,  GtkPrintBackend *backend,  gboolean virtual_);
		auto p = gtk_printer_new(Str.toStringz(name), backend, virtual);
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_printer_new(Str.toStringz(name), backend, virtual)");
		}
		this(cast(GtkPrinter*) p);
	}
	
	/**
	 * Returns the backend of the printer.
	 * Since 2.10
	 * Returns: the backend of printer
	 */
	public GtkPrintBackend* getBackend()
	{
		// GtkPrintBackend * gtk_printer_get_backend (GtkPrinter *printer);
		return gtk_printer_get_backend(gtkPrinter);
	}
	
	/**
	 * Returns the name of the printer.
	 * Since 2.10
	 * Returns: the name of printer
	 */
	public string getName()
	{
		// const gchar * gtk_printer_get_name (GtkPrinter *printer);
		return Str.toString(gtk_printer_get_name(gtkPrinter));
	}
	
	/**
	 * Returns the state message describing the current state
	 * of the printer.
	 * Since 2.10
	 * Returns: the state message of printer
	 */
	public string getStateMessage()
	{
		// const gchar * gtk_printer_get_state_message (GtkPrinter *printer);
		return Str.toString(gtk_printer_get_state_message(gtkPrinter));
	}
	
	/**
	 * Gets the description of the printer.
	 * Since 2.10
	 * Returns: the description of printer
	 */
	public string getDescription()
	{
		// const gchar * gtk_printer_get_description (GtkPrinter *printer);
		return Str.toString(gtk_printer_get_description(gtkPrinter));
	}
	
	/**
	 * Returns a description of the location of the printer.
	 * Since 2.10
	 * Returns: the location of printer
	 */
	public string getLocation()
	{
		// const gchar * gtk_printer_get_location (GtkPrinter *printer);
		return Str.toString(gtk_printer_get_location(gtkPrinter));
	}
	
	/**
	 * Gets the name of the icon to use for the printer.
	 * Since 2.10
	 * Returns: the icon name for printer
	 */
	public string getIconName()
	{
		// const gchar * gtk_printer_get_icon_name (GtkPrinter *printer);
		return Str.toString(gtk_printer_get_icon_name(gtkPrinter));
	}
	
	/**
	 * Gets the number of jobs currently queued on the printer.
	 * Since 2.10
	 * Returns: the number of jobs on printer
	 */
	public int getJobCount()
	{
		// gint gtk_printer_get_job_count (GtkPrinter *printer);
		return gtk_printer_get_job_count(gtkPrinter);
	}
	
	/**
	 * Returns whether the printer is currently active (i.e.
	 * accepts new jobs).
	 * Since 2.10
	 * Returns: TRUE if printer is active
	 */
	public int isActive()
	{
		// gboolean gtk_printer_is_active (GtkPrinter *printer);
		return gtk_printer_is_active(gtkPrinter);
	}
	
	/**
	 * Returns whether the printer is currently paused.
	 * A paused printer still accepts jobs, but it is not
	 * printing them.
	 * Since 2.14
	 * Returns: TRUE if printer is paused
	 */
	public int isPaused()
	{
		// gboolean gtk_printer_is_paused (GtkPrinter *printer);
		return gtk_printer_is_paused(gtkPrinter);
	}
	
	/**
	 * Returns whether the printer is accepting jobs
	 * Since 2.14
	 * Returns: TRUE if printer is accepting jobs
	 */
	public int isAcceptingJobs()
	{
		// gboolean gtk_printer_is_accepting_jobs (GtkPrinter *printer);
		return gtk_printer_is_accepting_jobs(gtkPrinter);
	}
	
	/**
	 * Returns whether the printer is virtual (i.e. does not
	 * represent actual printer hardware, but something like
	 * a CUPS class).
	 * Since 2.10
	 * Returns: TRUE if printer is virtual
	 */
	public int isVirtual()
	{
		// gboolean gtk_printer_is_virtual (GtkPrinter *printer);
		return gtk_printer_is_virtual(gtkPrinter);
	}
	
	/**
	 * Returns whether the printer is the default printer.
	 * Since 2.10
	 * Returns: TRUE if printer is the default
	 */
	public int isDefault()
	{
		// gboolean gtk_printer_is_default (GtkPrinter *printer);
		return gtk_printer_is_default(gtkPrinter);
	}
	
	/**
	 * Returns whether the printer accepts input in
	 * PostScript format.
	 * Since 2.10
	 * Returns: TRUE if printer accepts PostScript
	 */
	public int acceptsPs()
	{
		// gboolean gtk_printer_accepts_ps (GtkPrinter *printer);
		return gtk_printer_accepts_ps(gtkPrinter);
	}
	
	/**
	 * Returns whether the printer accepts input in
	 * PDF format.
	 * Since 2.10
	 * Returns: TRUE if printer accepts PDF
	 */
	public int acceptsPdf()
	{
		// gboolean gtk_printer_accepts_pdf (GtkPrinter *printer);
		return gtk_printer_accepts_pdf(gtkPrinter);
	}
	
	/**
	 * Lists all the paper sizes printer supports.
	 * This will return and empty list unless the printer's details are
	 * available, see gtk_printer_has_details() and gtk_printer_request_details().
	 * Since 2.12
	 * Returns: a newly allocated list of newly allocated GtkPageSetup s.
	 */
	public ListG listPapers()
	{
		// GList * gtk_printer_list_papers (GtkPrinter *printer);
		auto p = gtk_printer_list_papers(gtkPrinter);
		if(p is null)
		{
			return null;
		}
		return new ListG(cast(GList*) p);
	}
	
	/**
	 * Compares two printers.
	 * Since 2.10
	 * Params:
	 * a =  a GtkPrinter
	 * b =  another GtkPrinter
	 * Returns: 0 if the printer match, a negative value if a < b,  or a positive value if a > b
	 */
	public int compare(Printer b)
	{
		// gint gtk_printer_compare (GtkPrinter *a,  GtkPrinter *b);
		return gtk_printer_compare(gtkPrinter, (b is null) ? null : b.getPrinterStruct());
	}
	
	/**
	 * Returns whether the printer details are available.
	 * Since 2.12
	 * Returns: TRUE if printer details are available
	 */
	public int hasDetails()
	{
		// gboolean gtk_printer_has_details (GtkPrinter *printer);
		return gtk_printer_has_details(gtkPrinter);
	}
	
	/**
	 * Requests the printer details. When the details are available,
	 * the "details-acquired" signal will be emitted on printer.
	 * Since 2.12
	 */
	public void requestDetails()
	{
		// void gtk_printer_request_details (GtkPrinter *printer);
		gtk_printer_request_details(gtkPrinter);
	}
	
	/**
	 * Returns the printer's capabilities.
	 * This is useful when you're using GtkPrintUnixDialog's manual-capabilities
	 * setting and need to know which settings the printer can handle and which
	 * you must handle yourself.
	 * This will return 0 unless the printer's details are available, see
	 * gtk_printer_has_details() and gtk_printer_request_details().
	 *  *
	 * Since 2.12
	 * Returns: the printer's capabilities
	 */
	public GtkPrintCapabilities getCapabilities()
	{
		// GtkPrintCapabilities gtk_printer_get_capabilities (GtkPrinter *printer);
		return gtk_printer_get_capabilities(gtkPrinter);
	}
	
	/**
	 * Returns default page size of printer.
	 * Since 2.13
	 * Returns: a newly allocated GtkPageSetup with default page size of the printer.
	 */
	public PageSetup getDefaultPageSize()
	{
		// GtkPageSetup * gtk_printer_get_default_page_size (GtkPrinter *printer);
		auto p = gtk_printer_get_default_page_size(gtkPrinter);
		if(p is null)
		{
			return null;
		}
		return new PageSetup(cast(GtkPageSetup*) p);
	}
	
	/**
	 * Calls a function for all GtkPrinters.
	 * If func returns TRUE, the enumeration is stopped.
	 * Since 2.10
	 * Params:
	 * func =  a function to call for each printer
	 * data =  user data to pass to func
	 * destroy =  function to call if data is no longer needed
	 * wait =  if TRUE, wait in a recursive mainloop until
	 *  all printers are enumerated; otherwise return early
	 */
	public static void enumeratePrinters(GtkPrinterFunc func, void* data, GDestroyNotify destroy, int wait)
	{
		// void gtk_enumerate_printers (GtkPrinterFunc func,  gpointer data,  GDestroyNotify destroy,  gboolean wait);
		gtk_enumerate_printers(func, data, destroy, wait);
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
