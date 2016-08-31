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
 * inFile  = gio-Unix-Mounts.html
 * outPack = gio
 * outFile = UnixMountEntry
 * strct   = GUnixMountEntry
 * realStrct=
 * ctorStrct=
 * clss    = UnixMountEntry
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_unix_mount_
 * 	- g_unix_
 * omit structs:
 * omit prefixes:
 * 	- g_unix_mount_point_
 * 	- g_unix_mount_monitor_
 * omit code:
 * omit signals:
 * 	- mountpoints-changed
 * 	- mounts-changed
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ListG
 * 	- gtkD.gio.Icon
 * 	- gtkD.gio.IconIF
 * structWrap:
 * 	- GIcon* -> IconIF
 * 	- GList* -> ListG
 * 	- GUnixMountEntry* -> UnixMountEntry
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.UnixMountEntry;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.gio.Icon;
private import gtkD.gio.IconIF;




/**
 * Description
 * Routines for managing mounted UNIX mount points and paths.
 * Note that <gio/gunixmounts.h> belongs to the
 * UNIX-specific GIO interfaces, thus you have to use the
 * gio-unix-2.0.pc pkg-config file when using it.
 */
public class UnixMountEntry
{
	
	/** the main Gtk struct */
	protected GUnixMountEntry* gUnixMountEntry;
	
	
	public GUnixMountEntry* getUnixMountEntryStruct()
	{
		return gUnixMountEntry;
	}
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct()
	{
		return cast(void*)gUnixMountEntry;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GUnixMountEntry* gUnixMountEntry)
	{
		if(gUnixMountEntry is null)
		{
			this = null;
			return;
		}
		this.gUnixMountEntry = gUnixMountEntry;
	}
	
	/**
	 */
	
	/**
	 * Frees a unix mount.
	 */
	public void free()
	{
		// void g_unix_mount_free (GUnixMountEntry *mount_entry);
		g_unix_mount_free(gUnixMountEntry);
	}
	
	/**
	 * Compares two unix mounts.
	 * Params:
	 * mount2 =  second GUnixMountEntry to compare.
	 * Returns: 1, 0 or -1 if mount1 is greater than, equal to,or less than mount2, respectively.
	 */
	public int compare(UnixMountEntry mount2)
	{
		// gint g_unix_mount_compare (GUnixMountEntry *mount1,  GUnixMountEntry *mount2);
		return g_unix_mount_compare(gUnixMountEntry, (mount2 is null) ? null : mount2.getUnixMountEntryStruct());
	}
	
	/**
	 * Gets the mount path for a unix mount.
	 * Returns: the mount path for mount_entry.
	 */
	public string getMountPath()
	{
		// const char * g_unix_mount_get_mount_path (GUnixMountEntry *mount_entry);
		return Str.toString(g_unix_mount_get_mount_path(gUnixMountEntry));
	}
	
	/**
	 * Gets the device path for a unix mount.
	 * Returns: a string containing the device path.
	 */
	public string getDevicePath()
	{
		// const char * g_unix_mount_get_device_path (GUnixMountEntry *mount_entry);
		return Str.toString(g_unix_mount_get_device_path(gUnixMountEntry));
	}
	
	/**
	 * Gets the filesystem type for the unix mount.
	 * Returns: a string containing the file system type.
	 */
	public string getFsType()
	{
		// const char * g_unix_mount_get_fs_type (GUnixMountEntry *mount_entry);
		return Str.toString(g_unix_mount_get_fs_type(gUnixMountEntry));
	}
	
	/**
	 * Checks if a unix mount is mounted read only.
	 * Returns: TRUE if mount_entry is read only.
	 */
	public int isReadonly()
	{
		// gboolean g_unix_mount_is_readonly (GUnixMountEntry *mount_entry);
		return g_unix_mount_is_readonly(gUnixMountEntry);
	}
	
	/**
	 * Checks if a unix mount is a system path.
	 * Returns: TRUE if the unix mount is for a system path.
	 */
	public int isSystemInternal()
	{
		// gboolean g_unix_mount_is_system_internal (GUnixMountEntry *mount_entry);
		return g_unix_mount_is_system_internal(gUnixMountEntry);
	}
	
	/**
	 * Guesses the icon of a Unix mount.
	 * Returns: a GIcon
	 */
	public IconIF guessIcon()
	{
		// GIcon * g_unix_mount_guess_icon (GUnixMountEntry *mount_entry);
		auto p = g_unix_mount_guess_icon(gUnixMountEntry);
		if(p is null)
		{
			return null;
		}
		return new Icon(cast(GIcon*) p);
	}
	
	/**
	 * Guesses the name of a Unix mount.
	 * The result is a translated string.
	 * Returns: A newly allocated string that must be freed with g_free()
	 */
	public string guessName()
	{
		// char * g_unix_mount_guess_name (GUnixMountEntry *mount_entry);
		return Str.toString(g_unix_mount_guess_name(gUnixMountEntry));
	}
	
	/**
	 * Guesses whether a Unix mount can be ejected.
	 * Returns: TRUE if mount_entry is deemed to be ejectable.
	 */
	public int guessCanEject()
	{
		// gboolean g_unix_mount_guess_can_eject (GUnixMountEntry *mount_entry);
		return g_unix_mount_guess_can_eject(gUnixMountEntry);
	}
	
	/**
	 * Guesses whether a Unix mount should be displayed in the UI.
	 * Returns: TRUE if mount_entry is deemed to be displayable.
	 */
	public int guessShouldDisplay()
	{
		// gboolean g_unix_mount_guess_should_display (GUnixMountEntry *mount_entry);
		return g_unix_mount_guess_should_display(gUnixMountEntry);
	}
	
	/**
	 * Gets a GList of strings containing the unix mount points.
	 * If time_read is set, it will be filled with the mount timestamp,
	 * allowing for checking if the mounts have changed with
	 * g_unix_mounts_points_changed_since().
	 * Params:
	 * timeRead =  guint64 to contain a timestamp.
	 * Returns: a GList of the UNIX mountpoints.
	 */
	public static ListG pointsGet(ulong* timeRead)
	{
		// GList * g_unix_mount_points_get (guint64 *time_read);
		auto p = g_unix_mount_points_get(timeRead);
		if(p is null)
		{
			return null;
		}
		return new ListG(cast(GList*) p);
	}
	
	/**
	 * Gets a GList of strings containing the unix mounts.
	 * If time_read is set, it will be filled with the mount
	 * timestamp, allowing for checking if the mounts have changed
	 * with g_unix_mounts_changed_since().
	 * Params:
	 * timeRead =  guint64 to contain a timestamp.
	 * Returns: a GList of the UNIX mounts.
	 */
	public static ListG mountsGet(inout ulong timeRead)
	{
		// GList * g_unix_mounts_get (guint64 *time_read);
		auto p = g_unix_mounts_get(&timeRead);
		if(p is null)
		{
			return null;
		}
		return new ListG(cast(GList*) p);
	}
	
	/**
	 * Gets a GUnixMountEntry for a given mount path. If time_read
	 * is set, it will be filled with a unix timestamp for checking
	 * if the mounts have changed since with g_unix_mounts_changed_since().
	 * Params:
	 * mountPath =  path for a possible unix mount.
	 * timeRead =  guint64 to contain a timestamp.
	 * Returns: a GUnixMount.
	 */
	public static UnixMountEntry at(string mountPath, inout ulong timeRead)
	{
		// GUnixMountEntry * g_unix_mount_at (const char *mount_path,  guint64 *time_read);
		auto p = g_unix_mount_at(Str.toStringz(mountPath), &timeRead);
		if(p is null)
		{
			return null;
		}
		return new UnixMountEntry(cast(GUnixMountEntry*) p);
	}
	
	/**
	 * Checks if the unix mounts have changed since a given unix time.
	 * Params:
	 * time =  guint64 to contain a timestamp.
	 * Returns: TRUE if the mounts have changed since time.
	 */
	public static int mountsChangedSince(ulong time)
	{
		// gboolean g_unix_mounts_changed_since (guint64 time);
		return g_unix_mounts_changed_since(time);
	}
	
	/**
	 * Checks if the unix mount points have changed since a given unix time.
	 * Params:
	 * time =  guint64 to contain a timestamp.
	 * Returns: TRUE if the mount points have changed since time.
	 */
	public static int pointsChangedSince(ulong time)
	{
		// gboolean g_unix_mount_points_changed_since (guint64 time);
		return g_unix_mount_points_changed_since(time);
	}
	
	/**
	 * Determines if mount_path is considered an implementation of the
	 * OS. This is primarily used for hiding mountable and mounted volumes
	 * that only are used in the OS and has little to no relevance to the
	 * casual user.
	 * Params:
	 * mountPath =  a mount path, e.g. /media/disk
	 *  or /usr
	 * Returns: TRUE if mount_path is considered an implementation detail  of the OS.Signal DetailsThe "mountpoints-changed" signalvoid user_function (GUnixMountMonitor *monitor, gpointer user_data) : Run LastEmitted when the unix mount points have changed.
	 */
	public static int isMountPathSystemInternal(string mountPath)
	{
		// gboolean g_unix_is_mount_path_system_internal  (const char *mount_path);
		return g_unix_is_mount_path_system_internal(Str.toStringz(mountPath));
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
