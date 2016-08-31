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
 * inFile  = GSocket.html
 * outPack = gio
 * outFile = Socket
 * strct   = GSocket
 * realStrct=
 * ctorStrct=
 * clss    = Socket
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * 	- InitableIF
 * prefixes:
 * 	- g_socket_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ErrorG
 * 	- gtkD.glib.GException
 * 	- gtkD.glib.Source
 * 	- gtkD.gio.SocketAddress
 * 	- gtkD.gio.Cancellable
 * 	- gtkD.gio.SocketControlMessage
 * 	- gtkD.gio.InitableT
 * 	- gtkD.gio.InitableIF
 * structWrap:
 * 	- GCancellable* -> Cancellable
 * 	- GSocketAddress* -> SocketAddress
 * 	- GSocketControlMessage* -> SocketControlMessage
 * 	- GSource* -> Source
 * module aliases:
 * local aliases:
 * 	- GLIB_SYSDEF_MSG_DONTROUTE -> 4
 * 	- GLIB_SYSDEF_MSG_OOB -> 1
 * 	- GLIB_SYSDEF_MSG_PEEK -> 2
 * overrides:
 */

module gtkD.gio.Socket;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.glib.Source;
private import gtkD.gio.SocketAddress;
private import gtkD.gio.Cancellable;
private import gtkD.gio.SocketControlMessage;
private import gtkD.gio.InitableT;
private import gtkD.gio.InitableIF;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * A GSocket is a low-level networking primitive. It is a more or less
 * direct mapping of the BSD socket API in a portable GObject based API.
 * It supports both the UNIX socket implementations and winsock2 on Windows.
 * GSocket is the platform independent base upon which the higher level
 * network primitives are based. Applications are not typically meant to
 * use it directly, but rather through classes like GSocketClient,
 * GSocketService and GSocketConnection. However there may be cases where
 * direct use of GSocket is useful.
 * GSocket implements the GInitable interface, so if it is manually constructed
 * by e.g. g_object_new() you must call g_initable_init() and check the
 * results before using the object. This is done automatically in
 * g_socket_new() and g_socket_new_from_fd(), so these functions can return
 * NULL.
 * Sockets operate in two general modes, blocking or non-blocking. When
 * in blocking mode all operations block until the requested operation
 * is finished or there is an error. In non-blocking mode all calls that
 * would block return immediately with a G_IO_ERROR_WOULD_BLOCK error.
 * To know when a call would successfully run you can call g_socket_condition_check(),
 * or g_socket_condition_wait(). You can also use g_socket_create_source() and
 * attach it to a GMainContext to get callbacks when I/O is possible.
 * Note that all sockets are always set to non blocking mode in the system, and
 * blocking mode is emulated in GSocket.
 * When working in non-blocking mode applications should always be able to
 * handle getting a G_IO_ERROR_WOULD_BLOCK error even when some other
 * function said that I/O was possible. This can easily happen in case
 * of a race condition in the application, but it can also happen for other
 * reasons. For instance, on Windows a socket is always seen as writable
 * until a write returns G_IO_ERROR_WOULD_BLOCK.
 * GSockets can be either connection oriented or datagram based.
 * For connection oriented types you must first establish a connection by
 * either connecting to an address or accepting a connection from another
 * address. For connectionless socket types the target/source address is
 * specified or received in each I/O operation.
 * All socket file descriptors are set to be close-on-exec.
 * Note that creating a GSocket causes the signal SIGPIPE to be
 * ignored for the remainder of the program. If you are writing a
 * command-line utility that uses GSocket, you may need to take into
 * account the fact that your program will not automatically be killed
 * if it tries to write to stdout after it has been closed.
 */
public class Socket : ObjectG, InitableIF
{
	
	/** the main Gtk struct */
	protected GSocket* gSocket;
	
	
	public GSocket* getSocketStruct()
	{
		return gSocket;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gSocket;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GSocket* gSocket)
	{
		if(gSocket is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gSocket);
		if( ptr !is null )
		{
			this = cast(Socket)ptr;
			return;
		}
		super(cast(GObject*)gSocket);
		this.gSocket = gSocket;
	}
	
	// add the Initable capabilities
	mixin InitableT!(GSocket);
	
	/**
	 */
	
	/**
	 * Creates a new GSocket with the defined family, type and protocol.
	 * If protocol is 0 (G_SOCKET_PROTOCOL_DEFAULT) the default protocol type
	 * for the family and type is used.
	 * The protocol is a family and type specific int that specifies what
	 * kind of protocol to use. GSocketProtocol lists several common ones.
	 * Many families only support one protocol, and use 0 for this, others
	 * support several and using 0 means to use the default protocol for
	 * the family and type.
	 * The protocol id is passed directly to the operating
	 * system, so you can use protocols not listed in GSocketProtocol if you
	 * know the protocol number used for it.
	 * Since 2.22
	 * Params:
	 * family =  the socket family to use, e.g. G_SOCKET_FAMILY_IPV4.
	 * type =  the socket type to use.
	 * protocol =  the id of the protocol to use, or 0 for default.
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GSocketFamily family, GSocketType type, GSocketProtocol protocol)
	{
		// GSocket * g_socket_new (GSocketFamily family,  GSocketType type,  GSocketProtocol protocol,  GError **error);
		GError* err = null;
		
		auto p = g_socket_new(family, type, protocol, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			throw new ConstructionException("null returned by g_socket_new(family, type, protocol, &err)");
		}
		this(cast(GSocket*) p);
	}
	
	/**
	 * Creates a new GSocket from a native file descriptor
	 * or winsock SOCKET handle.
	 * This reads all the settings from the file descriptor so that
	 * all properties should work. Note that the file descriptor
	 * will be set to non-blocking mode, independent on the blocking
	 * mode of the GSocket.
	 * Since 2.22
	 * Params:
	 * fd =  a native socket file descriptor.
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (int fd)
	{
		// GSocket * g_socket_new_from_fd (gint fd,  GError **error);
		GError* err = null;
		
		auto p = g_socket_new_from_fd(fd, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			throw new ConstructionException("null returned by g_socket_new_from_fd(fd, &err)");
		}
		this(cast(GSocket*) p);
	}
	
	/**
	 * When a socket is created it is attached to an address family, but it
	 * doesn't have an address in this family. g_socket_bind() assigns the
	 * address (sometimes called name) of the socket.
	 * It is generally required to bind to a local address before you can
	 * receive connections. (See g_socket_listen() and g_socket_accept() ).
	 * In certain situations, you may also want to bind a socket that will be
	 * used to initiate connections, though this is not normally required.
	 * allow_reuse should be TRUE for server sockets (sockets that you will
	 * eventually call g_socket_accept() on), and FALSE for client sockets.
	 * (Specifically, if it is TRUE, then g_socket_bind() will set the
	 * SO_REUSEADDR flag on the socket, allowing it to bind address even if
	 * that address was previously used by another socket that has not yet been
	 * fully cleaned-up by the kernel. Failing to set this flag on a server
	 * socket may cause the bind call to return G_IO_ERROR_ADDRESS_IN_USE if
	 * the server program is stopped and then immediately restarted.)
	 * Since 2.22
	 * Params:
	 * address =  a GSocketAddress specifying the local address.
	 * allowReuse =  whether to allow reusing this address
	 * Returns: TRUE on success, FALSE on error.
	 * Throws: GException on failure.
	 */
	public int bind(SocketAddress address, int allowReuse)
	{
		// gboolean g_socket_bind (GSocket *socket,  GSocketAddress *address,  gboolean allow_reuse,  GError **error);
		GError* err = null;
		
		auto p = g_socket_bind(gSocket, (address is null) ? null : address.getSocketAddressStruct(), allowReuse, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Marks the socket as a server socket, i.e. a socket that is used
	 * to accept incoming requests using g_socket_accept().
	 * Before calling this the socket must be bound to a local address using
	 * g_socket_bind().
	 * To set the maximum amount of outstanding clients, use
	 * g_socket_set_listen_backlog().
	 * Since 2.22
	 * Returns: TRUE on success, FALSE on error.
	 * Throws: GException on failure.
	 */
	public int listen()
	{
		// gboolean g_socket_listen (GSocket *socket,  GError **error);
		GError* err = null;
		
		auto p = g_socket_listen(gSocket, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Accept incoming connections on a connection-based socket. This removes
	 * the first outstanding connection request from the listening socket and
	 * creates a GSocket object for it.
	 * The socket must be bound to a local address with g_socket_bind() and
	 * must be listening for incoming connections (g_socket_listen()).
	 * If there are no outstanding connections then the operation will block
	 * or return G_IO_ERROR_WOULD_BLOCK if non-blocking I/O is enabled.
	 * To be notified of an incoming connection, wait for the G_IO_IN condition.
	 * Since 2.22
	 * Params:
	 * cancellable =  a GCancellable or NULL
	 * Returns: a new GSocket, or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public GSocket* accept(Cancellable cancellable)
	{
		// GSocket * g_socket_accept (GSocket *socket,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_socket_accept(gSocket, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Connect the socket to the specified remote address.
	 * For connection oriented socket this generally means we attempt to make
	 * a connection to the address. For a connection-less socket it sets
	 * the default address for g_socket_send() and discards all incoming datagrams
	 * from other sources.
	 * Generally connection oriented sockets can only connect once, but
	 * connection-less sockets can connect multiple times to change the
	 * default address.
	 * If the connect call needs to do network I/O it will block, unless
	 * non-blocking I/O is enabled. Then G_IO_ERROR_PENDING is returned
	 * and the user can be notified of the connection finishing by waiting
	 * for the G_IO_OUT condition. The result of the connection can then be
	 * checked with g_socket_check_connect_result().
	 * Since 2.22
	 * Params:
	 * address =  a GSocketAddress specifying the remote address.
	 * cancellable =  a GCancellable or NULL
	 * Returns: TRUE if connected, FALSE on error.
	 * Throws: GException on failure.
	 */
	public int connect(SocketAddress address, Cancellable cancellable)
	{
		// gboolean g_socket_connect (GSocket *socket,  GSocketAddress *address,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_socket_connect(gSocket, (address is null) ? null : address.getSocketAddressStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Checks and resets the pending connect error for the socket.
	 * This is used to check for errors when g_socket_connect() is
	 * used in non-blocking mode.
	 * Since 2.22
	 * Returns: TRUE if no error, FALSE otherwise, setting error to the error
	 * Throws: GException on failure.
	 */
	public int checkConnectResult()
	{
		// gboolean g_socket_check_connect_result (GSocket *socket,  GError **error);
		GError* err = null;
		
		auto p = g_socket_check_connect_result(gSocket, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Receive data (up to size bytes) from a socket. This is mainly used by
	 * connection-oriented sockets; it is identical to g_socket_receive_from()
	 * with address set to NULL.
	 * For G_SOCKET_TYPE_DATAGRAM and G_SOCKET_TYPE_SEQPACKET sockets,
	 * g_socket_receive() will always read either 0 or 1 complete messages from
	 * the socket. If the received message is too large to fit in buffer, then
	 * the data beyond size bytes will be discarded, without any explicit
	 * indication that this has occurred.
	 * For G_SOCKET_TYPE_STREAM sockets, g_socket_receive() can return any
	 * number of bytes, up to size. If more than size bytes have been
	 * received, the additional data will be returned in future calls to
	 * g_socket_receive().
	 * If the socket is in blocking mode the call will block until there is
	 * some data to receive or there is an error. If there is no data available
	 * and the socket is in non-blocking mode, a G_IO_ERROR_WOULD_BLOCK error
	 * will be returned. To be notified when data is available, wait for the
	 * G_IO_IN condition.
	 * On error -1 is returned and error is set accordingly.
	 * Since 2.22
	 * Params:
	 * buffer =  a buffer to read data into (which should be at least size
	 *  bytes long).
	 * size =  the number of bytes you want to read from the socket
	 * cancellable =  a GCancellable or NULL
	 * Returns: Number of bytes read, or -1 on error
	 * Throws: GException on failure.
	 */
	public int receive(string buffer, uint size, Cancellable cancellable)
	{
		// gssize g_socket_receive (GSocket *socket,  gchar *buffer,  gsize size,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_socket_receive(gSocket, Str.toStringz(buffer), size, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Receive data (up to size bytes) from a socket.
	 * If address is non-NULL then address will be set equal to the
	 * source address of the received packet.
	 * address is owned by the caller.
	 * See g_socket_receive() for additional information.
	 * Since 2.22
	 * Params:
	 * address =  a pointer to a GSocketAddress pointer, or NULL
	 * buffer =  a buffer to read data into (which should be at least size
	 *  bytes long).
	 * size =  the number of bytes you want to read from the socket
	 * cancellable =  a GCancellable or NULL
	 * Returns: Number of bytes read, or -1 on error
	 * Throws: GException on failure.
	 */
	public int receiveFrom(inout SocketAddress address, char[] buffer, Cancellable cancellable)
	{
		// gssize g_socket_receive_from (GSocket *socket,  GSocketAddress **address,  gchar *buffer,  gsize size,  GCancellable *cancellable,  GError **error);
		GSocketAddress* outaddress = (address is null) ? null : address.getSocketAddressStruct();
		GError* err = null;
		
		auto p = g_socket_receive_from(gSocket, &outaddress, buffer.ptr, buffer.length, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		address = new SocketAddress(outaddress);
		return p;
	}
	
	/**
	 * Receive data from a socket. This is the most complicated and
	 * fully-featured version of this call. For easier use, see
	 * g_socket_receive() and g_socket_receive_from().
	 * If address is non-NULL then address will be set equal to the
	 * source address of the received packet.
	 * address is owned by the caller.
	 * vector must point to an array of GInputVector structs and
	 * num_vectors must be the length of this array. These structs
	 * describe the buffers that received data will be scattered into.
	 * If num_vectors is -1, then vectors is assumed to be terminated
	 * by a GInputVector with a NULL buffer pointer.
	 * As a special case, if num_vectors is 0 (in which case, vectors
	 * may of course be NULL), then a single byte is received and
	 * discarded. This is to facilitate the common practice of sending a
	 * single '\0' byte for the purposes of transferring ancillary data.
	 * messages, if non-NULL, will be set to point to a newly-allocated
	 * array of GSocketControlMessage instances. These correspond to the
	 * control messages received from the kernel, one
	 * GSocketControlMessage per message from the kernel. This array is
	 * NULL-terminated and must be freed by the caller using g_free(). If
	 * messages is NULL, any control messages received will be
	 * discarded.
	 * num_messages, if non-NULL, will be set to the number of control
	 * messages received.
	 * If both messages and num_messages are non-NULL, then
	 * num_messages gives the number of GSocketControlMessage instances
	 * in messages (ie: not including the NULL terminator).
	 * flags is an in/out parameter. The commonly available arguments
	 * for this are available in the GSocketMsgFlags enum, but the
	 * values there are the same as the system values, and the flags
	 * are passed in as-is, so you can pass in system-specific flags too
	 * (and g_socket_receive_message() may pass system-specific flags out).
	 * As with g_socket_receive(), data may be discarded if socket is
	 * G_SOCKET_TYPE_DATAGRAM or G_SOCKET_TYPE_SEQPACKET and you do not
	 * provide enough buffer space to read a complete message. You can pass
	 * G_SOCKET_MSG_PEEK in flags to peek at the current message without
	 * removing it from the receive queue, but there is no portable way to find
	 * out the length of the message other than by reading it into a
	 * sufficiently-large buffer.
	 * If the socket is in blocking mode the call will block until there
	 * is some data to receive or there is an error. If there is no data
	 * available and the socket is in non-blocking mode, a
	 * G_IO_ERROR_WOULD_BLOCK error will be returned. To be notified when
	 * data is available, wait for the G_IO_IN condition.
	 * On error -1 is returned and error is set accordingly.
	 * Since 2.22
	 * Params:
	 * address =  a pointer to a GSocketAddress pointer, or NULL
	 * vectors =  an array of GInputVector structs
	 * messages =  a pointer which will be filled with an array of
	 *  GSocketControlMessages, or NULL
	 * flags =  a pointer to an int containing GSocketMsgFlags flags
	 * cancellable =  a GCancellable or NULL
	 * Returns: Number of bytes read, or -1 on error
	 * Throws: GException on failure.
	 */
	public int receiveMessage(inout SocketAddress address, GInputVector[] vectors, inout SocketControlMessage[] messages, inout int flags, Cancellable cancellable)
	{
		// gssize g_socket_receive_message (GSocket *socket,  GSocketAddress **address,  GInputVector *vectors,  gint num_vectors,  GSocketControlMessage ***messages,  gint *num_messages,  gint *flags,  GCancellable *cancellable,  GError **error);
		GSocketAddress* outaddress = (address is null) ? null : address.getSocketAddressStruct();
		
		GSocketControlMessage*[] inoutmessages = new GSocketControlMessage*[messages.length];
		for ( int i = 0; i < messages.length ; i++ )
		{
			inoutmessages[i] = messages[i].getSocketControlMessageStruct();
		}
		
		GSocketControlMessage** outmessages = inoutmessages.ptr;
		int numMessages = messages.length;
		GError* err = null;
		
		auto p = g_socket_receive_message(gSocket, &outaddress, vectors.ptr, vectors.length, &outmessages, &numMessages, &flags, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		address = new SocketAddress(outaddress);
		
		messages = new SocketControlMessage[numMessages];
		for(int i = 0; i < numMessages; i++)
		{
			messages[i] = new SocketControlMessage(cast(GSocketControlMessage*) outmessages[i]);
		}
		return p;
	}
	
	/**
	 * Tries to send size bytes from buffer on the socket. This is
	 * mainly used by connection-oriented sockets; it is identical to
	 * g_socket_send_to() with address set to NULL.
	 * If the socket is in blocking mode the call will block until there is
	 * space for the data in the socket queue. If there is no space available
	 * and the socket is in non-blocking mode a G_IO_ERROR_WOULD_BLOCK error
	 * will be returned. To be notified when space is available, wait for the
	 * G_IO_OUT condition. Note though that you may still receive
	 * G_IO_ERROR_WOULD_BLOCK from g_socket_send() even if you were previously
	 * notified of a G_IO_OUT condition. (On Windows in particular, this is
	 * very common due to the way the underlying APIs work.)
	 * On error -1 is returned and error is set accordingly.
	 * Since 2.22
	 * Params:
	 * buffer =  the buffer containing the data to send.
	 * size =  the number of bytes to send
	 * cancellable =  a GCancellable or NULL
	 * Returns: Number of bytes written (which may be less than size), or -1on error
	 * Throws: GException on failure.
	 */
	public int send(string buffer, uint size, Cancellable cancellable)
	{
		// gssize g_socket_send (GSocket *socket,  const gchar *buffer,  gsize size,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_socket_send(gSocket, Str.toStringz(buffer), size, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Tries to send size bytes from buffer to address. If address is
	 * NULL then the message is sent to the default receiver (set by
	 * g_socket_connect()).
	 * See g_socket_send() for additional information.
	 * Since 2.22
	 * Params:
	 * address =  a GSocketAddress, or NULL
	 * buffer =  the buffer containing the data to send.
	 * size =  the number of bytes to send
	 * cancellable =  a GCancellable or NULL
	 * Returns: Number of bytes written (which may be less than size), or -1on error
	 * Throws: GException on failure.
	 */
	public int sendTo(SocketAddress address, string buffer, uint size, Cancellable cancellable)
	{
		// gssize g_socket_send_to (GSocket *socket,  GSocketAddress *address,  const gchar *buffer,  gsize size,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_socket_send_to(gSocket, (address is null) ? null : address.getSocketAddressStruct(), Str.toStringz(buffer), size, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Send data to address on socket. This is the most complicated and
	 * fully-featured version of this call. For easier use, see
	 * g_socket_send() and g_socket_send_to().
	 * If address is NULL then the message is sent to the default receiver
	 * (set by g_socket_connect()).
	 * vectors must point to an array of GOutputVector structs and
	 * num_vectors must be the length of this array. (If num_vectors is -1,
	 * then vectors is assumed to be terminated by a GOutputVector with a
	 * NULL buffer pointer.) The GOutputVector structs describe the buffers
	 * that the sent data will be gathered from. Using multiple
	 * GOutputVectors is more memory-efficient than manually copying
	 * data from multiple sources into a single buffer, and more
	 * network-efficient than making multiple calls to g_socket_send().
	 * messages, if non-NULL, is taken to point to an array of num_messages
	 * GSocketControlMessage instances. These correspond to the control
	 * messages to be sent on the socket.
	 * If num_messages is -1 then messages is treated as a NULL-terminated
	 * array.
	 * flags modify how the message is sent. The commonly available arguments
	 * for this are available in the GSocketMsgFlags enum, but the
	 * values there are the same as the system values, and the flags
	 * are passed in as-is, so you can pass in system-specific flags too.
	 * If the socket is in blocking mode the call will block until there is
	 * space for the data in the socket queue. If there is no space available
	 * and the socket is in non-blocking mode a G_IO_ERROR_WOULD_BLOCK error
	 * will be returned. To be notified when space is available, wait for the
	 * G_IO_OUT condition. Note though that you may still receive
	 * G_IO_ERROR_WOULD_BLOCK from g_socket_send() even if you were previously
	 * notified of a G_IO_OUT condition. (On Windows in particular, this is
	 * very common due to the way the underlying APIs work.)
	 * On error -1 is returned and error is set accordingly.
	 * Since 2.22
	 * Params:
	 * address =  a GSocketAddress, or NULL
	 * vectors =  an array of GOutputVector structs
	 * messages =  a pointer to an array of GSocketControlMessages, or
	 *  NULL.
	 * flags =  an int containing GSocketMsgFlags flags
	 * cancellable =  a GCancellable or NULL
	 * Returns: Number of bytes written (which may be less than size), or -1on error
	 * Throws: GException on failure.
	 */
	public int sendMessage(SocketAddress address, GOutputVector[] vectors, inout GSocketControlMessage[] messages, int flags, Cancellable cancellable)
	{
		// gssize g_socket_send_message (GSocket *socket,  GSocketAddress *address,  GOutputVector *vectors,  gint num_vectors,  GSocketControlMessage **messages,  gint num_messages,  gint flags,  GCancellable *cancellable,  GError **error);
		GSocketControlMessage* outmessages = messages.ptr;
		int numMessages = messages.length;
		GError* err = null;
		
		auto p = g_socket_send_message(gSocket, (address is null) ? null : address.getSocketAddressStruct(), vectors.ptr, vectors.length, &outmessages, numMessages, flags, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		messages = outmessages[0 .. numMessages];
		return p;
	}
	
	/**
	 * Closes the socket, shutting down any active connection.
	 * Closing a socket does not wait for all outstanding I/O operations
	 * to finish, so the caller should not rely on them to be guaranteed
	 * to complete even if the close returns with no error.
	 * Once the socket is closed, all other operations will return
	 * G_IO_ERROR_CLOSED. Closing a socket multiple times will not
	 * return an error.
	 * Sockets will be automatically closed when the last reference
	 * is dropped, but you might want to call this function to make sure
	 * resources are released as early as possible.
	 * Beware that due to the way that TCP works, it is possible for
	 * recently-sent data to be lost if either you close a socket while the
	 * G_IO_IN condition is set, or else if the remote connection tries to
	 * send something to you after you close the socket but before it has
	 * finished reading all of the data you sent. There is no easy generic
	 * way to avoid this problem; the easiest fix is to design the network
	 * protocol such that the client will never send data "out of turn".
	 * Another solution is for the server to half-close the connection by
	 * calling g_socket_shutdown() with only the shutdown_write flag set,
	 * and then wait for the client to notice this and close its side of the
	 * connection, after which the server can safely call g_socket_close().
	 * (This is what GTcpConnection does if you call
	 * g_tcp_connection_set_graceful_disconnect(). But of course, this
	 * only works if the client will close its connection after the server
	 * does.)
	 * Since 2.22
	 * Returns: TRUE on success, FALSE on error
	 * Throws: GException on failure.
	 */
	public int close()
	{
		// gboolean g_socket_close (GSocket *socket,  GError **error);
		GError* err = null;
		
		auto p = g_socket_close(gSocket, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Checks whether a socket is closed.
	 * Since 2.22
	 * Returns: TRUE if socket is closed, FALSE otherwise
	 */
	public int isClosed()
	{
		// gboolean g_socket_is_closed (GSocket *socket);
		return g_socket_is_closed(gSocket);
	}
	
	/**
	 * Shut down part of a full-duplex connection.
	 * If shutdown_read is TRUE then the recieving side of the connection
	 * is shut down, and further reading is disallowed.
	 * If shutdown_write is TRUE then the sending side of the connection
	 * is shut down, and further writing is disallowed.
	 * It is allowed for both shutdown_read and shutdown_write to be TRUE.
	 * One example where this is used is graceful disconnect for TCP connections
	 * where you close the sending side, then wait for the other side to close
	 * the connection, thus ensuring that the other side saw all sent data.
	 * Since 2.22
	 * Params:
	 * shutdownRead =  whether to shut down the read side
	 * shutdownWrite =  whether to shut down the write side
	 * Returns: TRUE on success, FALSE on error
	 * Throws: GException on failure.
	 */
	public int shutdown(int shutdownRead, int shutdownWrite)
	{
		// gboolean g_socket_shutdown (GSocket *socket,  gboolean shutdown_read,  gboolean shutdown_write,  GError **error);
		GError* err = null;
		
		auto p = g_socket_shutdown(gSocket, shutdownRead, shutdownWrite, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Check whether the socket is connected. This is only useful for
	 * connection-oriented sockets.
	 * Since 2.22
	 * Returns: TRUE if socket is connected, FALSE otherwise.
	 */
	public int isConnected()
	{
		// gboolean g_socket_is_connected (GSocket *socket);
		return g_socket_is_connected(gSocket);
	}
	
	/**
	 * Creates a GSource that can be attached to a GMainContext to monitor
	 * for the availibility of the specified condition on the socket.
	 * The callback on the source is of the GSocketSourceFunc type.
	 * It is meaningless to specify G_IO_ERR or G_IO_HUP in condition;
	 * these conditions will always be reported output if they are true.
	 * cancellable if not NULL can be used to cancel the source, which will
	 * cause the source to trigger, reporting the current condition (which
	 * is likely 0 unless cancellation happened at the same time as a
	 * condition change). You can check for this in the callback using
	 * g_cancellable_is_cancelled().
	 * Since 2.22
	 * Params:
	 * condition =  a GIOCondition mask to monitor
	 * cancellable =  a GCancellable or NULL
	 * Returns: a newly allocated GSource, free with g_source_unref().
	 */
	public Source createSource(GIOCondition condition, Cancellable cancellable)
	{
		// GSource * g_socket_create_source (GSocket *socket,  GIOCondition condition,  GCancellable *cancellable);
		auto p = g_socket_create_source(gSocket, condition, (cancellable is null) ? null : cancellable.getCancellableStruct());
		if(p is null)
		{
			return null;
		}
		return new Source(cast(GSource*) p);
	}
	
	/**
	 * Checks on the readiness of socket to perform operations.
	 * The operations specified in condition are checked for and masked
	 * against the currently-satisfied conditions on socket. The result
	 * is returned.
	 * It is meaningless to specify G_IO_ERR or G_IO_HUP in condition;
	 * these conditions will always be set in the output if they are true.
	 * This call never blocks.
	 * Since 2.22
	 * Params:
	 * condition =  a GIOCondition mask to check
	 * Returns: the GIOCondition mask of the current state
	 */
	public GIOCondition conditionCheck(GIOCondition condition)
	{
		// GIOCondition g_socket_condition_check (GSocket *socket,  GIOCondition condition);
		return g_socket_condition_check(gSocket, condition);
	}
	
	/**
	 * Waits for condition to become true on socket. When the condition
	 * is met, TRUE is returned.
	 * If cancellable is cancelled before the condition is met then FALSE
	 * is returned and error, if non-NULL, is set to G_IO_ERROR_CANCELLED.
	 * Since 2.22
	 * Params:
	 * condition =  a GIOCondition mask to wait for
	 * cancellable =  a GCancellable, or NULL
	 * Returns: TRUE if the condition was met, FALSE otherwise
	 * Throws: GException on failure.
	 */
	public int conditionWait(GIOCondition condition, Cancellable cancellable)
	{
		// gboolean g_socket_condition_wait (GSocket *socket,  GIOCondition condition,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_socket_condition_wait(gSocket, condition, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Sets the maximum number of outstanding connections allowed
	 * when listening on this socket. If more clients than this are
	 * connecting to the socket and the application is not handling them
	 * on time then the new connections will be refused.
	 * Note that this must be called before g_socket_listen() and has no
	 * effect if called after that.
	 * Since 2.22
	 * Params:
	 * backlog =  the maximum number of pending connections.
	 */
	public void setListenBacklog(int backlog)
	{
		// void g_socket_set_listen_backlog (GSocket *socket,  gint backlog);
		g_socket_set_listen_backlog(gSocket, backlog);
	}
	
	/**
	 * Gets the listen backlog setting of the socket. For details on this,
	 * see g_socket_set_listen_backlog().
	 * Since 2.22
	 * Returns: the maximum number of pending connections.
	 */
	public int getListenBacklog()
	{
		// gint g_socket_get_listen_backlog (GSocket *socket);
		return g_socket_get_listen_backlog(gSocket);
	}
	
	/**
	 * Gets the blocking mode of the socket. For details on blocking I/O,
	 * see g_socket_set_blocking().
	 * Since 2.22
	 * Returns: TRUE if blocking I/O is used, FALSE otherwise.
	 */
	public int getBlocking()
	{
		// gboolean g_socket_get_blocking (GSocket *socket);
		return g_socket_get_blocking(gSocket);
	}
	
	/**
	 * Sets the blocking mode of the socket. In blocking mode
	 * all operations block until they succeed or there is an error. In
	 * non-blocking mode all functions return results immediately or
	 * with a G_IO_ERROR_WOULD_BLOCK error.
	 * All sockets are created in blocking mode. However, note that the
	 * platform level socket is always non-blocking, and blocking mode
	 * is a GSocket level feature.
	 * Since 2.22
	 * Params:
	 * blocking =  Whether to use blocking I/O or not.
	 */
	public void setBlocking(int blocking)
	{
		// void g_socket_set_blocking (GSocket *socket,  gboolean blocking);
		g_socket_set_blocking(gSocket, blocking);
	}
	
	/**
	 * Gets the keepalive mode of the socket. For details on this,
	 * see g_socket_set_keepalive().
	 * Since 2.22
	 * Returns: TRUE if keepalive is active, FALSE otherwise.
	 */
	public int getKeepalive()
	{
		// gboolean g_socket_get_keepalive (GSocket *socket);
		return g_socket_get_keepalive(gSocket);
	}
	
	/**
	 * Sets or unsets the SO_KEEPALIVE flag on the underlying socket. When
	 * this flag is set on a socket, the system will attempt to verify that the
	 * remote socket endpoint is still present if a sufficiently long period of
	 * time passes with no data being exchanged. If the system is unable to
	 * verify the presence of the remote endpoint, it will automatically close
	 * the connection.
	 * This option is only functional on certain kinds of sockets. (Notably,
	 * G_SOCKET_PROTOCOL_TCP sockets.)
	 * The exact time between pings is system- and protocol-dependent, but will
	 * normally be at least two hours. Most commonly, you would set this flag
	 * on a server socket if you want to allow clients to remain idle for long
	 * periods of time, but also want to ensure that connections are eventually
	 * garbage-collected if clients crash or become unreachable.
	 * Since 2.22
	 * Params:
	 * keepalive =  Value for the keepalive flag
	 */
	public void setKeepalive(int keepalive)
	{
		// void g_socket_set_keepalive (GSocket *socket,  gboolean keepalive);
		g_socket_set_keepalive(gSocket, keepalive);
	}
	
	/**
	 * Gets the socket family of the socket.
	 * Since 2.22
	 * Returns: a GSocketFamily
	 */
	public GSocketFamily getFamily()
	{
		// GSocketFamily g_socket_get_family (GSocket *socket);
		return g_socket_get_family(gSocket);
	}
	
	/**
	 * Returns the underlying OS socket object. On unix this
	 * is a socket file descriptor, and on windows this is
	 * a Winsock2 SOCKET handle. This may be useful for
	 * doing platform specific or otherwise unusual operations
	 * on the socket.
	 * Since 2.22
	 * Returns: the file descriptor of the socket.
	 */
	public int getFd()
	{
		// int g_socket_get_fd (GSocket *socket);
		return g_socket_get_fd(gSocket);
	}
	
	/**
	 * Try to get the local address of a bound socket. This is only
	 * useful if the socket has been bound to a local address,
	 * either explicitly or implicitly when connecting.
	 * Since 2.22
	 * Returns: a GSocketAddress or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public SocketAddress getLocalAddress()
	{
		// GSocketAddress * g_socket_get_local_address (GSocket *socket,  GError **error);
		GError* err = null;
		
		auto p = g_socket_get_local_address(gSocket, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			return null;
		}
		return new SocketAddress(cast(GSocketAddress*) p);
	}
	
	/**
	 * Gets the socket protocol id the socket was created with.
	 * In case the protocol is unknown, -1 is returned.
	 * Since 2.22
	 * Returns: a protocol id, or -1 if unknown
	 */
	public GSocketProtocol getProtocol()
	{
		// GSocketProtocol g_socket_get_protocol (GSocket *socket);
		return g_socket_get_protocol(gSocket);
	}
	
	/**
	 * Try to get the remove address of a connected socket. This is only
	 * useful for connection oriented sockets that have been connected.
	 * Since 2.22
	 * Returns: a GSocketAddress or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public SocketAddress getRemoteAddress()
	{
		// GSocketAddress * g_socket_get_remote_address (GSocket *socket,  GError **error);
		GError* err = null;
		
		auto p = g_socket_get_remote_address(gSocket, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			return null;
		}
		return new SocketAddress(cast(GSocketAddress*) p);
	}
	
	/**
	 * Gets the socket type of the socket.
	 * Since 2.22
	 * Returns: a GSocketType
	 */
	public GSocketType getSocketType()
	{
		// GSocketType g_socket_get_socket_type (GSocket *socket);
		return g_socket_get_socket_type(gSocket);
	}
	
	/**
	 * Checks if a socket is capable of speaking IPv4.
	 * IPv4 sockets are capable of speaking IPv4. On some operating systems
	 * and under some combinations of circumstances IPv6 sockets are also
	 * capable of speaking IPv4. See RFC 3493 section 3.7 for more
	 * information.
	 * No other types of sockets are currently considered as being capable
	 * of speaking IPv4.
	 * Since 2.22.
	 * Returns: TRUE if this socket can be used with IPv4.
	 */
	public int speaksIpv4()
	{
		// gboolean g_socket_speaks_ipv4 (GSocket *socket);
		return g_socket_speaks_ipv4(gSocket);
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
