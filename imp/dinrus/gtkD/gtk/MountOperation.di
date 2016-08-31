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
 * inFile  = gtk-Filesystem-utilities.html
 * outPack = gtk
 * outFile = MountOperation
 * strct   = GtkMountOperation
 * realStrct=
 * ctorStrct=GMountOperation
 * clss    = MountOperation
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = GioMountOperation
 * implements:
 * prefixes:
 * 	- gtk_mount_operation_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ErrorG
 * 	- gtkD.glib.GException
 * 	- gtkD.gtk.Window
 * 	- gtkD.gdk.Screen
 * 	- gtkD.gio.MountOperation : GioMountOperation = MountOperation
 * structWrap:
 * 	- GdkScreen* -> Screen
 * 	- GtkWindow* -> Window
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.MountOperation;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gtk.Window;
private import gtkD.gdk.Screen;
private import gtkD.gio.MountOperation : GioMountOperation = MountOperation;




/**
 * Description
 * The functions and objects described here make working with GTK+ and
 * GIO more convenient. GtkMountOperation is needed when mounting volumes
 * and gtk_show_uri() is a convenient way to launch applications for URIs.
 * Another object that is worth mentioning in this context is
 * GdkAppLaunchContext, which provides visual feedback when lauching
 * applications.
 */
public class MountOperation : GioMountOperation
{
	
	/** the main Gtk struct */
	protected GtkMountOperation* gtkMountOperation;
	
	
	public GtkMountOperation* getGtkMountOperationStruct()
	{
		return gtkMountOperation;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkMountOperation;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkMountOperation* gtkMountOperation)
	{
		if(gtkMountOperation is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkMountOperation);
		if( ptr !is null )
		{
			this = cast(MountOperation)ptr;
			return;
		}
		super(cast(GMountOperation*)gtkMountOperation);
		this.gtkMountOperation = gtkMountOperation;
	}
	
	/**
	 */
	
	/**
	 * Creates a new GtkMountOperation
	 * Since 2.14
	 * Params:
	 * parent =  transient parent of the window, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Window parent)
	{
		// GMountOperation * gtk_mount_operation_new (GtkWindow *parent);
		auto p = gtk_mount_operation_new((parent is null) ? null : parent.getWindowStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_mount_operation_new((parent is null) ? null : parent.getWindowStruct())");
		}
		this(cast(GtkMountOperation*) p);
	}
	
	/**
	 * Returns whether the GtkMountOperation is currently displaying
	 * a window.
	 * Since 2.14
	 * Returns: TRUE if op is currently displaying a window
	 */
	public int isShowing()
	{
		// gboolean gtk_mount_operation_is_showing (GtkMountOperation *op);
		return gtk_mount_operation_is_showing(gtkMountOperation);
	}
	
	/**
	 * Sets the transient parent for windows shown by the
	 * GtkMountOperation.
	 * Since 2.14
	 * Params:
	 * parent =  transient parent of the window, or NULL
	 */
	public void setParent(Window parent)
	{
		// void gtk_mount_operation_set_parent (GtkMountOperation *op,  GtkWindow *parent);
		gtk_mount_operation_set_parent(gtkMountOperation, (parent is null) ? null : parent.getWindowStruct());
	}
	
	/**
	 * Gets the transient parent used by the GtkMountOperation
	 * Since 2.14
	 * Returns: the transient parent for windows shown by op
	 */
	public Window getParent()
	{
		// GtkWindow * gtk_mount_operation_get_parent (GtkMountOperation *op);
		auto p = gtk_mount_operation_get_parent(gtkMountOperation);
		if(p is null)
		{
			return null;
		}
		return new Window(cast(GtkWindow*) p);
	}
	
	/**
	 * Sets the screen to show windows of the GtkMountOperation on.
	 * Since 2.14
	 * Params:
	 * screen =  a GdkScreen
	 */
	public void setScreen(Screen screen)
	{
		// void gtk_mount_operation_set_screen (GtkMountOperation *op,  GdkScreen *screen);
		gtk_mount_operation_set_screen(gtkMountOperation, (screen is null) ? null : screen.getScreenStruct());
	}
	
	/**
	 * Gets the screen on which windows of the GtkMountOperation
	 * will be shown.
	 * Since 2.14
	 * Returns: the screen on which windows of op are shown
	 */
	public Screen getScreen()
	{
		// GdkScreen * gtk_mount_operation_get_screen (GtkMountOperation *op);
		auto p = gtk_mount_operation_get_screen(gtkMountOperation);
		if(p is null)
		{
			return null;
		}
		return new Screen(cast(GdkScreen*) p);
	}
	
	/**
	 * This is a convenience function for launching the default application
	 * to show the uri. The uri must be of a form understood by GIO. Typical
	 * examples are
	 * file:///home/gnome/pict.jpg
	 * http://www.gnome.org
	 * mailto:me@gnome.org
	 * Ideally the timestamp is taken from the event triggering
	 * the gtk_show_uri() call. If timestamp is not known you can take
	 * GDK_CURRENT_TIME.
	 * This function can be used as a replacement for gnome_vfs_url_show()
	 * and gnome_url_show().
	 * Since 2.14
	 * Params:
	 * screen =  screen to show the uri on or NULL for the default screen
	 * uri =  the uri to show
	 * timestamp =  a timestamp to prevent focus stealing.
	 * Returns: TRUE on success, FALSE on error.
	 * Throws: GException on failure.
	 */
	public static int showUri(Screen screen, string uri, uint timestamp)
	{
		// gboolean gtk_show_uri (GdkScreen *screen,  const gchar *uri,  guint32 timestamp,  GError **error);
		GError* err = null;
		
		auto p = gtk_show_uri((screen is null) ? null : screen.getScreenStruct(), Str.toStringz(uri), timestamp, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
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
