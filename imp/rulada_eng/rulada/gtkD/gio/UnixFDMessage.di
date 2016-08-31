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
 * inFile  = GUnixFDMessage.html
 * outPack = gio
 * outFile = UnixFDMessage
 * strct   = GUnixFDMessage
 * realStrct=
 * ctorStrct=GSocketControlMessage
 * clss    = UnixFDMessage
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_unix_fd_message_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.ErrorG
 * 	- gtkD.glib.GException
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.UnixFDMessage;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;



private import gtkD.gio.SocketControlMessage;

/**
 * Description
 * This GSocketControlMessage contains a list of file descriptors.
 * It may be sent using g_socket_send_message() and received using
 * g_socket_receive_message() over UNIX sockets (ie: sockets in the
 * G_SOCKET_ADDRESS_UNIX family).
 * For an easier way to send and receive file descriptors over
 * stream-oriented UNIX sockets, see g_unix_connection_send_fd() and
 * g_unix_connection_receive_fd().
 */
public class UnixFDMessage : SocketControlMessage
{
	
	/** the main Gtk struct */
	protected GUnixFDMessage* gUnixFDMessage;
	
	
	public GUnixFDMessage* getUnixFDMessageStruct()
	{
		return gUnixFDMessage;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gUnixFDMessage;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GUnixFDMessage* gUnixFDMessage)
	{
		if(gUnixFDMessage is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gUnixFDMessage);
		if( ptr !is null )
		{
			this = cast(UnixFDMessage)ptr;
			return;
		}
		super(cast(GSocketControlMessage*)gUnixFDMessage);
		this.gUnixFDMessage = gUnixFDMessage;
	}
	
	/**
	 */
	
	/**
	 * Creates a new GUnixFDMessage containing no file descriptors.
	 * Since 2.22
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GSocketControlMessage * g_unix_fd_message_new (void);
		auto p = g_unix_fd_message_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by g_unix_fd_message_new()");
		}
		this(cast(GUnixFDMessage*) p);
	}
	
	/**
	 * Adds a file descriptor to message.
	 * The file descriptor is duplicated using dup(). You keep your copy
	 * of the descriptor and the copy contained in message will be closed
	 * when message is finalized.
	 * A possible cause of failure is exceeding the per-process or
	 * system-wide file descriptor limit.
	 * Since 2.22
	 * Params:
	 * fd =  a valid open file descriptor
	 * Returns: TRUE in case of success, else FALSE (and error is set)
	 * Throws: GException on failure.
	 */
	public int appendFd(int fd)
	{
		// gboolean g_unix_fd_message_append_fd (GUnixFDMessage *message,  gint fd,  GError **error);
		GError* err = null;
		
		auto p = g_unix_fd_message_append_fd(gUnixFDMessage, fd, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Returns the array of file descriptors that is contained in this
	 * object.
	 * After this call, the descriptors are no longer contained in
	 * message. Further calls will return an empty list (unless more
	 * descriptors have been added).
	 * The return result of this function must be freed with g_free().
	 * The caller is also responsible for closing all of the file
	 * descriptors.
	 * If length is non-NULL then it is set to the number of file
	 * descriptors in the returned array. The returned array is also
	 * terminated with -1.
	 * This function never returns NULL. In case there are no file
	 * descriptors contained in message, an empty array is returned.
	 * Since 2.22
	 * Returns: an array of file descriptors
	 */
	public int[] stealFds()
	{
		// gint * g_unix_fd_message_steal_fds (GUnixFDMessage *message,  gint *length);
		int length;
		auto p = g_unix_fd_message_steal_fds(gUnixFDMessage, &length);
		return p[0 .. length];
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
