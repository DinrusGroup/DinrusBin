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
 * inFile  = GDrive.html
 * outPack = gio
 * outFile = DriveIF
 * strct   = GDrive
 * realStrct=
 * ctorStrct=
 * clss    = DriveT
 * interf  = DriveIF
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_drive_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ErrorG
 * 	- gtkD.glib.GException
 * 	- gtkD.glib.ListG
 * 	- gtkD.gobject.Signals
 * 	- gtkD.gio.AsyncResultIF
 * 	- gtkD.gio.Cancellable
 * 	- gtkD.gio.Icon
 * 	- gtkD.gio.IconIF
 * 	- gtkD.gio.MountOperation
 * structWrap:
 * 	- GAsyncResult* -> AsyncResultIF
 * 	- GCancellable* -> Cancellable
 * 	- GIcon* -> IconIF
 * 	- GList* -> ListG
 * 	- GMountOperation* -> MountOperation
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.DriveIF;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.glib.ListG;
private import gtkD.gobject.Signals;
private import gtkD.gio.AsyncResultIF;
private import gtkD.gio.Cancellable;
private import gtkD.gio.Icon;
private import gtkD.gio.IconIF;
private import gtkD.gio.MountOperation;




/**
 * Description
 * GDrive - this represent a piece of hardware connected to the machine.
 * It's generally only created for removable hardware or hardware with
 * removable media.
 * GDrive is a container class for GVolume objects that stem from
 * the same piece of media. As such, GDrive abstracts a drive with
 * (or without) removable media and provides operations for querying
 * whether media is available, determing whether media change is
 * automatically detected and ejecting the media.
 * If the GDrive reports that media isn't automatically detected, one
 * can poll for media; typically one should not do this periodically
 * as a poll for media operation is potententially expensive and may
 * spin up the drive creating noise.
 * GDrive supports starting and stopping drives with authentication
 * support for the former. This can be used to support a diverse set
 * of use cases including connecting/disconnecting iSCSI devices,
 * powering down external disk enclosures and starting/stopping
 * multi-disk devices such as RAID devices. Note that the actual
 * semantics and side-effects of starting/stopping a GDrive may vary
 * according to implementation. To choose the correct verbs in e.g. a
 * file manager, use g_drive_get_start_stop_type().
 * For porting from GnomeVFS note that there is no equivalent of
 * GDrive in that API.
 */
public interface DriveIF
{
	
	
	public GDrive* getDriveTStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	
	/**
	 */
	
	void delegate(DriveIF)[] onChangedListeners();
	/**
	 * Emitted when the drive's state has changed.
	 */
	void addOnChanged(void delegate(DriveIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	void delegate(DriveIF)[] onDisconnectedListeners();
	/**
	 * This signal is emitted when the GDrive have been
	 * disconnected. If the recipient is holding references to the
	 * object they should release them so the object can be
	 * finalized.
	 */
	void addOnDisconnected(void delegate(DriveIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	void delegate(DriveIF)[] onEjectButtonListeners();
	/**
	 * Emitted when the physical eject button (if any) of a drive has
	 * been pressed.
	 */
	void addOnEjectButton(void delegate(DriveIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	void delegate(DriveIF)[] onStopButtonListeners();
	/**
	 * Emitted when the physical stop button (if any) of a drive has
	 * been pressed.
	 * Since 2.22
	 */
	void addOnStopButton(void delegate(DriveIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	
	/**
	 * Gets the name of drive.
	 * Returns: a string containing drive's name. The returned  string should be freed when no longer needed.
	 */
	public string getName();
	
	/**
	 * Gets the icon for drive.
	 * Returns: GIcon for the drive. Free the returned object with g_object_unref().
	 */
	public IconIF getIcon();
	
	/**
	 * Check if drive has any mountable volumes.
	 * Returns: TRUE if the drive contains volumes, FALSE otherwise.
	 */
	public int hasVolumes();
	
	/**
	 * Get a list of mountable volumes for drive.
	 * The returned list should be freed with g_list_free(), after
	 * its elements have been unreffed with g_object_unref().
	 * Returns: GList containing any GVolume objects on the given drive.
	 */
	public ListG getVolumes();
	
	/**
	 * Checks if a drive can be ejected.
	 * Returns: TRUE if the drive can be ejected, FALSE otherwise.
	 */
	public int canEject();
	
	/**
	 * Gets a hint about how a drive can be started/stopped.
	 * Since 2.22
	 * Returns: A value from the GDriveStartStopType enumeration.
	 */
	public GDriveStartStopType getStartStopType();
	
	/**
	 * Checks if a drive can be started.
	 * Since 2.22
	 * Returns: TRUE if the drive can be started, FALSE otherwise.
	 */
	public int canStart();
	
	/**
	 * Checks if a drive can be started degraded.
	 * Since 2.22
	 * Returns: TRUE if the drive can be started degraded, FALSE otherwise.
	 */
	public int canStartDegraded();
	
	/**
	 * Checks if a drive can be stopped.
	 * Since 2.22
	 * Returns: TRUE if the drive can be stopped, FALSE otherwise.
	 */
	public int canStop();
	
	/**
	 * Checks if a drive can be polled for media changes.
	 * Returns: TRUE if the drive can be polled for media changes, FALSE otherwise.
	 */
	public int canPollForMedia();
	
	/**
	 * Asynchronously polls drive to see if media has been inserted or removed.
	 * When the operation is finished, callback will be called.
	 * You can then call g_drive_poll_for_media_finish() to obtain the
	 * result of the operation.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback, or NULL.
	 * userData =  user data to pass to callback
	 */
	public void pollForMedia(Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an operation started with g_drive_poll_for_media() on a drive.
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if the drive has been poll_for_mediaed successfully, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int pollForMediaFinish(AsyncResultIF result);
	
	/**
	 * Checks if the drive has media. Note that the OS may not be polling
	 * the drive for media changes; see g_drive_is_media_check_automatic()
	 * for more details.
	 * Returns: TRUE if drive has media, FALSE otherwise.
	 */
	public int hasMedia();
	
	/**
	 * Checks if drive is capabable of automatically detecting media changes.
	 * Returns: TRUE if the drive is capabable of automatically detecting  media changes, FALSE otherwise.
	 */
	public int isMediaCheckAutomatic();
	
	/**
	 * Checks if the drive supports removable media.
	 * Returns: TRUE if drive supports removable media, FALSE otherwise.
	 */
	public int isMediaRemovable();
	
	/**
	 * Warning
	 * g_drive_eject has been deprecated since version 2.22 and should not be used in newly-written code. Use g_drive_eject_with_operation() instead.
	 * Asynchronously ejects a drive.
	 * When the operation is finished, callback will be called.
	 * You can then call g_drive_eject_finish() to obtain the
	 * result of the operation.
	 * Params:
	 * flags =  flags affecting the unmount if required for eject
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback, or NULL.
	 * userData =  user data to pass to callback
	 */
	public void eject(GMountUnmountFlags flags, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Warning
	 * g_drive_eject_finish has been deprecated since version 2.22 and should not be used in newly-written code. Use g_drive_eject_with_operation_finish() instead.
	 * Finishes ejecting a drive.
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if the drive has been ejected successfully, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int ejectFinish(AsyncResultIF result);
	
	/**
	 * Ejects a drive. This is an asynchronous operation, and is
	 * finished by calling g_drive_eject_with_operation_finish() with the drive
	 * and GAsyncResult data returned in the callback.
	 * Since 2.22
	 * Params:
	 * flags =  flags affecting the unmount if required for eject
	 * mountOperation =  a GMountOperation or NULL to avoid user interaction.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback, or NULL.
	 * userData =  user data passed to callback.
	 */
	public void ejectWithOperation(GMountUnmountFlags flags, MountOperation mountOperation, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes ejecting a drive. If any errors occurred during the operation,
	 * error will be set to contain the errors and FALSE will be returned.
	 * Since 2.22
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if the drive was successfully ejected. FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int ejectWithOperationFinish(AsyncResultIF result);
	
	/**
	 * Asynchronously starts a drive.
	 * When the operation is finished, callback will be called.
	 * You can then call g_drive_start_finish() to obtain the
	 * result of the operation.
	 * Since 2.22
	 * Params:
	 * flags =  flags affecting the start operation.
	 * mountOperation =  a GMountOperation or NULL to avoid user interaction.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback, or NULL.
	 * userData =  user data to pass to callback
	 */
	public void start(GDriveStartFlags flags, MountOperation mountOperation, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes starting a drive.
	 * Since 2.22
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if the drive has been started successfully, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int startFinish(AsyncResultIF result);
	
	/**
	 * Asynchronously stops a drive.
	 * When the operation is finished, callback will be called.
	 * You can then call g_drive_stop_finish() to obtain the
	 * result of the operation.
	 * Since 2.22
	 * Params:
	 * flags =  flags affecting the unmount if required for stopping.
	 * mountOperation =  a GMountOperation or NULL to avoid user interaction.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback, or NULL.
	 * userData =  user data to pass to callback
	 */
	public void stop(GMountUnmountFlags flags, MountOperation mountOperation, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes stopping a drive.
	 * Since 2.22
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if the drive has been stopped successfully, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int stopFinish(AsyncResultIF result);
	
	/**
	 * Gets the kinds of identifiers that drive has.
	 * Use g_drive_get_identifer() to obtain the identifiers
	 * themselves.
	 * Returns: a NULL-terminated array of strings containing kinds of identifiers. Use g_strfreev() to free.
	 */
	public string[] enumerateIdentifiers();
	
	/**
	 * Gets the identifier of the given kind for drive.
	 * Params:
	 * kind =  the kind of identifier to return
	 * Returns: a newly allocated string containing the requested identfier, or NULL if the GDrive doesn't have this kind of identifier.Signal DetailsThe "changed" signalvoid user_function (GDrive *drive, gpointer user_data) : Run LastEmitted when the drive's state has changed.
	 */
	public string getIdentifier(string kind);
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
