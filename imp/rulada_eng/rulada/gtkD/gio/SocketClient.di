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
 * inFile  = GSocketClient.html
 * outPack = gio
 * outFile = SocketClient
 * strct   = GSocketClient
 * realStrct=
 * ctorStrct=
 * clss    = SocketClient
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_socket_client_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ErrorG
 * 	- gtkD.glib.GException
 * 	- gtkD.gio.AsyncResultIF
 * 	- gtkD.gio.Cancellable
 * 	- gtkD.gio.SocketAddress
 * 	- gtkD.gio.SocketConnection
 * 	- gtkD.gio.SocketConnectableIF
 * structWrap:
 * 	- GAsyncResult* -> AsyncResultIF
 * 	- GCancellable* -> Cancellable
 * 	- GSocketAddress* -> SocketAddress
 * 	- GSocketConnectable* -> SocketConnectableIF
 * 	- GSocketConnection* -> SocketConnection
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.SocketClient;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.AsyncResultIF;
private import gtkD.gio.Cancellable;
private import gtkD.gio.SocketAddress;
private import gtkD.gio.SocketConnection;
private import gtkD.gio.SocketConnectableIF;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GSocketClient is a high-level utility class for connecting to a
 * network host using a connection oriented socket type.
 * You create a GSocketClient object, set any options you want, then
 * call a sync or async connect operation, which returns a GSocketConnection
 * subclass on success.
 * The type of the GSocketConnection object returned depends on the type of
 * the underlying socket that is in use. For instance, for a TCP/IP connection
 * it will be a GTcpConnection.
 */
public class SocketClient : ObjectG
{
	
	/** the main Gtk struct */
	protected GSocketClient* gSocketClient;
	
	
	public GSocketClient* getSocketClientStruct()
	{
		return gSocketClient;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gSocketClient;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GSocketClient* gSocketClient)
	{
		if(gSocketClient is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gSocketClient);
		if( ptr !is null )
		{
			this = cast(SocketClient)ptr;
			return;
		}
		super(cast(GObject*)gSocketClient);
		this.gSocketClient = gSocketClient;
	}
	
	/**
	 */
	
	/**
	 * Creates a new GSocketClient with the default options.
	 * Since 2.22
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GSocketClient * g_socket_client_new (void);
		auto p = g_socket_client_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by g_socket_client_new()");
		}
		this(cast(GSocketClient*) p);
	}
	
	/**
	 * Tries to resolve the connectable and make a network connection to it..
	 * Upon a successful connection, a new GSocketConnection is constructed
	 * and returned. The caller owns this new object and must drop their
	 * reference to it when finished with it.
	 * The type of the GSocketConnection object returned depends on the type of
	 * the underlying socket that is used. For instance, for a TCP/IP connection
	 * it will be a GTcpConnection.
	 * The socket created will be the same family as the the address that the
	 * connectable resolves to, unless family is set with g_socket_client_set_family()
	 * or indirectly via g_socket_client_set_local_address(). The socket type
	 * defaults to G_SOCKET_TYPE_STREAM but can be set with
	 * g_socket_client_set_socket_type().
	 * If a local address is specified with g_socket_client_set_local_address() the
	 * socket will be bound to this address before connecting.
	 * Since 2.22
	 * Params:
	 * connectable =  a GSocketConnectable specifying the remote address.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GSocketConnection on success, NULL on error.
	 * Throws: GException on failure.
	 */
	public SocketConnection connect(SocketConnectableIF connectable, Cancellable cancellable)
	{
		// GSocketConnection * g_socket_client_connect (GSocketClient *client,  GSocketConnectable *connectable,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_socket_client_connect(gSocketClient, (connectable is null) ? null : connectable.getSocketConnectableTStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			return null;
		}
		return new SocketConnection(cast(GSocketConnection*) p);
	}
	
	/**
	 * This is the asynchronous version of g_socket_client_connect().
	 * When the operation is finished callback will be
	 * called. You can then call g_socket_client_connect_finish() to get
	 * the result of the operation.
	 * Since 2.22
	 * Params:
	 * connectable =  a GSocketConnectable specifying the remote address.
	 * cancellable =  a GCancellable, or NULL
	 * callback =  a GAsyncReadyCallback
	 * userData =  user data for the callback
	 */
	public void connectAsync(SocketConnectableIF connectable, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		// void g_socket_client_connect_async (GSocketClient *client,  GSocketConnectable *connectable,  GCancellable *cancellable,  GAsyncReadyCallback callback,  gpointer user_data);
		g_socket_client_connect_async(gSocketClient, (connectable is null) ? null : connectable.getSocketConnectableTStruct(), (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}
	
	/**
	 * Finishes an async connect operation. See g_socket_client_connect_async()
	 * Since 2.22
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: a GSocketConnection on success, NULL on error.
	 * Throws: GException on failure.
	 */
	public SocketConnection connectFinish(AsyncResultIF result)
	{
		// GSocketConnection * g_socket_client_connect_finish (GSocketClient *client,  GAsyncResult *result,  GError **error);
		GError* err = null;
		
		auto p = g_socket_client_connect_finish(gSocketClient, (result is null) ? null : result.getAsyncResultTStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			return null;
		}
		return new SocketConnection(cast(GSocketConnection*) p);
	}
	
	/**
	 * This is a helper function for g_socket_client_connect().
	 * Attempts to create a TCP connection to the named host.
	 * host_and_port may be in any of a number of recognised formats: an IPv6
	 * address, an IPv4 address, or a domain name (in which case a DNS
	 * lookup is performed). Quoting with [] is supported for all address
	 * types. A port override may be specified in the usual way with a
	 * colon. Ports may be given as decimal numbers or symbolic names (in
	 * which case an /etc/services lookup is performed).
	 * If no port override is given in host_and_port then default_port will be
	 * used as the port number to connect to.
	 * In general, host_and_port is expected to be provided by the user (allowing
	 * them to give the hostname, and a port overide if necessary) and
	 * default_port is expected to be provided by the application.
	 * In the case that an IP address is given, a single connection
	 * attempt is made. In the case that a name is given, multiple
	 * connection attempts may be made, in turn and according to the
	 * number of address records in DNS, until a connection succeeds.
	 * Upon a successful connection, a new GSocketConnection is constructed
	 * and returned. The caller owns this new object and must drop their
	 * reference to it when finished with it.
	 * In the event of any failure (DNS error, service not found, no hosts
	 * connectable) NULL is returned and error (if non-NULL) is set
	 * accordingly.
	 * Since 2.22
	 * Params:
	 * hostAndPort =  the name and optionally port of the host to connect to
	 * defaultPort =  the default port to connect to
	 * cancellable =  a GCancellable, or NULL
	 * Returns: a GSocketConnection on success, NULL on error.
	 * Throws: GException on failure.
	 */
	public SocketConnection connectToHost(string hostAndPort, ushort defaultPort, Cancellable cancellable)
	{
		// GSocketConnection * g_socket_client_connect_to_host (GSocketClient *client,  const gchar *host_and_port,  guint16 default_port,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_socket_client_connect_to_host(gSocketClient, Str.toStringz(hostAndPort), defaultPort, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			return null;
		}
		return new SocketConnection(cast(GSocketConnection*) p);
	}
	
	/**
	 * This is the asynchronous version of g_socket_client_connect_to_host().
	 * When the operation is finished callback will be
	 * called. You can then call g_socket_client_connect_to_host_finish() to get
	 * the result of the operation.
	 * Since 2.22
	 * Params:
	 * hostAndPort =  the name and optionally the port of the host to connect to
	 * defaultPort =  the default port to connect to
	 * cancellable =  a GCancellable, or NULL
	 * callback =  a GAsyncReadyCallback
	 * userData =  user data for the callback
	 */
	public void connectToHostAsync(string hostAndPort, ushort defaultPort, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		// void g_socket_client_connect_to_host_async  (GSocketClient *client,  const gchar *host_and_port,  guint16 default_port,  GCancellable *cancellable,  GAsyncReadyCallback callback,  gpointer user_data);
		g_socket_client_connect_to_host_async(gSocketClient, Str.toStringz(hostAndPort), defaultPort, (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}
	
	/**
	 * Finishes an async connect operation. See g_socket_client_connect_to_host_async()
	 * Since 2.22
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: a GSocketConnection on success, NULL on error.
	 * Throws: GException on failure.
	 */
	public SocketConnection connectToHostFinish(AsyncResultIF result)
	{
		// GSocketConnection * g_socket_client_connect_to_host_finish  (GSocketClient *client,  GAsyncResult *result,  GError **error);
		GError* err = null;
		
		auto p = g_socket_client_connect_to_host_finish(gSocketClient, (result is null) ? null : result.getAsyncResultTStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			return null;
		}
		return new SocketConnection(cast(GSocketConnection*) p);
	}
	
	/**
	 * Attempts to create a TCP connection to a service.
	 * This call looks up the SRV record for service at domain for the
	 * "tcp" protocol. It then attempts to connect, in turn, to each of
	 * the hosts providing the service until either a connection succeeds
	 * or there are no hosts remaining.
	 * Upon a successful connection, a new GSocketConnection is constructed
	 * and returned. The caller owns this new object and must drop their
	 * reference to it when finished with it.
	 * In the event of any failure (DNS error, service not found, no hosts
	 * connectable) NULL is returned and error (if non-NULL) is set
	 * accordingly.
	 * Params:
	 * domain =  a domain name
	 * service =  the name of the service to connect to
	 * cancellable =  a GCancellable, or NULL
	 * Returns: a GSocketConnection if successful, or NULL on error
	 * Throws: GException on failure.
	 */
	public SocketConnection connectToService(string domain, string service, Cancellable cancellable)
	{
		// GSocketConnection * g_socket_client_connect_to_service (GSocketClient *client,  const gchar *domain,  const gchar *service,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_socket_client_connect_to_service(gSocketClient, Str.toStringz(domain), Str.toStringz(service), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			return null;
		}
		return new SocketConnection(cast(GSocketConnection*) p);
	}
	
	/**
	 * This is the asynchronous version of
	 * g_socket_client_connect_to_service().
	 * Since 2.22
	 * Params:
	 * domain =  a domain name
	 * service =  the name of the service to connect to
	 * cancellable =  a GCancellable, or NULL
	 * callback =  a GAsyncReadyCallback
	 * userData =  user data for the callback
	 */
	public void connectToServiceAsync(string domain, string service, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		// void g_socket_client_connect_to_service_async  (GSocketClient *client,  const gchar *domain,  const gchar *service,  GCancellable *cancellable,  GAsyncReadyCallback callback,  gpointer user_data);
		g_socket_client_connect_to_service_async(gSocketClient, Str.toStringz(domain), Str.toStringz(service), (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}
	
	/**
	 * Finishes an async connect operation. See g_socket_client_connect_to_service_async()
	 * Since 2.22
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: a GSocketConnection on success, NULL on error.
	 * Throws: GException on failure.
	 */
	public SocketConnection connectToServiceFinish(AsyncResultIF result)
	{
		// GSocketConnection * g_socket_client_connect_to_service_finish  (GSocketClient *client,  GAsyncResult *result,  GError **error);
		GError* err = null;
		
		auto p = g_socket_client_connect_to_service_finish(gSocketClient, (result is null) ? null : result.getAsyncResultTStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			return null;
		}
		return new SocketConnection(cast(GSocketConnection*) p);
	}
	
	/**
	 * Sets the socket family of the socket client.
	 * If this is set to something other than G_SOCKET_FAMILY_INVALID
	 * then the sockets created by this object will be of the specified
	 * family.
	 * This might be useful for instance if you want to force the local
	 * connection to be an ipv4 socket, even though the address might
	 * be an ipv6 mapped to ipv4 address.
	 * Since 2.22
	 * Params:
	 * family =  a GSocketFamily
	 */
	public void setFamily(GSocketFamily family)
	{
		// void g_socket_client_set_family (GSocketClient *client,  GSocketFamily family);
		g_socket_client_set_family(gSocketClient, family);
	}
	
	/**
	 * Sets the local address of the socket client.
	 * The sockets created by this object will bound to the
	 * specified address (if not NULL) before connecting.
	 * This is useful if you want to ensure the the local
	 * side of the connection is on a specific port, or on
	 * a specific interface.
	 * Since 2.22
	 * Params:
	 * address =  a GSocketAddress, or NULL
	 */
	public void setLocalAddress(SocketAddress address)
	{
		// void g_socket_client_set_local_address (GSocketClient *client,  GSocketAddress *address);
		g_socket_client_set_local_address(gSocketClient, (address is null) ? null : address.getSocketAddressStruct());
	}
	
	/**
	 * Sets the protocol of the socket client.
	 * The sockets created by this object will use of the specified
	 * protocol.
	 * If protocol is 0 that means to use the default
	 * protocol for the socket family and type.
	 * Since 2.22
	 * Params:
	 * protocol =  a GSocketProtocol
	 */
	public void setProtocol(GSocketProtocol protocol)
	{
		// void g_socket_client_set_protocol (GSocketClient *client,  GSocketProtocol protocol);
		g_socket_client_set_protocol(gSocketClient, protocol);
	}
	
	/**
	 * Sets the socket type of the socket client.
	 * The sockets created by this object will be of the specified
	 * type.
	 * It doesn't make sense to specify a type of G_SOCKET_TYPE_DATAGRAM,
	 * as GSocketClient is used for connection oriented services.
	 * Since 2.22
	 * Params:
	 * type =  a GSocketType
	 */
	public void setSocketType(GSocketType type)
	{
		// void g_socket_client_set_socket_type (GSocketClient *client,  GSocketType type);
		g_socket_client_set_socket_type(gSocketClient, type);
	}
	
	/**
	 * Gets the socket family of the socket client.
	 * See g_socket_client_set_family() for details.
	 * Since 2.22
	 * Returns: a GSocketFamily
	 */
	public GSocketFamily getFamily()
	{
		// GSocketFamily g_socket_client_get_family (GSocketClient *client);
		return g_socket_client_get_family(gSocketClient);
	}
	
	/**
	 * Gets the local address of the socket client.
	 * See g_socket_client_set_local_address() for details.
	 * Since 2.22
	 * Returns: a GSocketAddres or NULL. don't free
	 */
	public SocketAddress getLocalAddress()
	{
		// GSocketAddress * g_socket_client_get_local_address (GSocketClient *client);
		auto p = g_socket_client_get_local_address(gSocketClient);
		if(p is null)
		{
			return null;
		}
		return new SocketAddress(cast(GSocketAddress*) p);
	}
	
	/**
	 * Gets the protocol name type of the socket client.
	 * See g_socket_client_set_protocol() for details.
	 * Since 2.22
	 * Returns: a GSocketProtocol
	 */
	public GSocketProtocol getProtocol()
	{
		// GSocketProtocol g_socket_client_get_protocol (GSocketClient *client);
		return g_socket_client_get_protocol(gSocketClient);
	}
	
	/**
	 * Gets the socket type of the socket client.
	 * See g_socket_client_set_socket_type() for details.
	 * Since 2.22
	 * Returns: a GSocketFamily
	 */
	public GSocketType getSocketType()
	{
		// GSocketType g_socket_client_get_socket_type (GSocketClient *client);
		return g_socket_client_get_socket_type(gSocketClient);
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
