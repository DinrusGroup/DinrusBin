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
 * inFile  = 
 * outPack = gio
 * outFile = UnixMountPoint
 * strct   = GUnixMountPoint
 * realStrct=
 * ctorStrct=
 * clss    = UnixMountPoint
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_unix_mount_point_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * 	- mountpoints-changed
 * 	- mounts-changed
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gio.Icon
 * 	- gtkD.gio.IconIF
 * structWrap:
 * 	- GIcon* -> IconIF
 * 	- GUnixMountPoint* -> UnixMountPoint
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.UnixMountPoint;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gio.Icon;
private import gtkD.gio.IconIF;




/**
 * Description
 * Routines for managing mounted UNIX mount points and paths.
 * Note that <gio/gunixmounts.h> belongs to the
 * UNIX-specific GIO interfaces, thus you have to use the
 * gio-unix-2.0.pc pkg-config file when using it.
 */
public class UnixMountPoint
{
	
	/** the main Gtk struct */
	protected GUnixMountPoint* gUnixMountPoint;
	
	
	public GUnixMountPoint* getUnixMountPointStruct()
	{
		return gUnixMountPoint;
	}
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct()
	{
		return cast(void*)gUnixMountPoint;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GUnixMountPoint* gUnixMountPoint)
	{
		if(gUnixMountPoint is null)
		{
			this = null;
			return;
		}
		this.gUnixMountPoint = gUnixMountPoint;
	}
	
	/**
	 */
	
	/**
	 * Frees a unix mount point.
	 */
	public void free()
	{
		// void g_unix_mount_point_free (GUnixMountPoint *mount_point);
		g_unix_mount_point_free(gUnixMountPoint);
	}
	
	/**
	 * Compares two unix mount points.
	 * Params:
	 * mount2 =  a GUnixMount.
	 * Returns: 1, 0 or -1 if mount1 is greater than, equal to,or less than mount2, respectively.
	 */
	public int compare(UnixMountPoint mount2)
	{
		// gint g_unix_mount_point_compare (GUnixMountPoint *mount1,  GUnixMountPoint *mount2);
		return g_unix_mount_point_compare(gUnixMountPoint, (mount2 is null) ? null : mount2.getUnixMountPointStruct());
	}
	
	/**
	 * Gets the mount path for a unix mount point.
	 * Returns: a string containing the mount path.
	 */
	public string getMountPath()
	{
		// const char * g_unix_mount_point_get_mount_path (GUnixMountPoint *mount_point);
		return Str.toString(g_unix_mount_point_get_mount_path(gUnixMountPoint));
	}
	
	/**
	 * Gets the device path for a unix mount point.
	 * Returns: a string containing the device path.
	 */
	public string getDevicePath()
	{
		// const char * g_unix_mount_point_get_device_path (GUnixMountPoint *mount_point);
		return Str.toString(g_unix_mount_point_get_device_path(gUnixMountPoint));
	}
	
	/**
	 * Gets the file system type for the mount point.
	 * Returns: a string containing the file system type.
	 */
	public string getFsType()
	{
		// const char * g_unix_mount_point_get_fs_type (GUnixMountPoint *mount_point);
		return Str.toString(g_unix_mount_point_get_fs_type(gUnixMountPoint));
	}
	
	/**
	 * Checks if a unix mount point is read only.
	 * Returns: TRUE if a mount point is read only.
	 */
	public int isReadonly()
	{
		// gboolean g_unix_mount_point_is_readonly (GUnixMountPoint *mount_point);
		return g_unix_mount_point_is_readonly(gUnixMountPoint);
	}
	
	/**
	 * Checks if a unix mount point is mountable by the user.
	 * Returns: TRUE if the mount point is user mountable.
	 */
	public int isUserMountable()
	{
		// gboolean g_unix_mount_point_is_user_mountable  (GUnixMountPoint *mount_point);
		return g_unix_mount_point_is_user_mountable(gUnixMountPoint);
	}
	
	/**
	 * Checks if a unix mount point is a loopback device.
	 * Returns: TRUE if the mount point is a loopback. FALSE otherwise.
	 */
	public int isLoopback()
	{
		// gboolean g_unix_mount_point_is_loopback (GUnixMountPoint *mount_point);
		return g_unix_mount_point_is_loopback(gUnixMountPoint);
	}
	
	/**
	 * Guesses the icon of a Unix mount point.
	 * Returns: a GIcon
	 */
	public IconIF guessIcon()
	{
		// GIcon * g_unix_mount_point_guess_icon (GUnixMountPoint *mount_point);
		auto p = g_unix_mount_point_guess_icon(gUnixMountPoint);
		if(p is null)
		{
			return null;
		}
		return new Icon(cast(GIcon*) p);
	}
	
	/**
	 * Guesses the name of a Unix mount point.
	 * The result is a translated string.
	 * Returns: A newly allocated string that must  be freed with g_free()
	 */
	public string guessName()
	{
		// char * g_unix_mount_point_guess_name (GUnixMountPoint *mount_point);
		return Str.toString(g_unix_mount_point_guess_name(gUnixMountPoint));
	}
	
	/**
	 * Guesses whether a Unix mount point can be ejected.
	 * Returns: TRUE if mount_point is deemed to be ejectable.
	 */
	public int guessCanEject()
	{
		// gboolean g_unix_mount_point_guess_can_eject (GUnixMountPoint *mount_point);
		return g_unix_mount_point_guess_can_eject(gUnixMountPoint);
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gio");
        } else version (DigitalMars) {
            pragma(link, "DD-gio");
        } else {
            pragma(link, "DO-gio");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gio");
        } else version (DigitalMars) {
            pragma(link, "DD-gio");
        } else {
            pragma(link, "DO-gio");
        }
    }
}
