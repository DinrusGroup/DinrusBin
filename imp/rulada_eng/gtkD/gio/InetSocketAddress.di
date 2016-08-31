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
 * inFile  = GInetSocketAddress.html
 * outPack = gio
 * outFile = InetSocketAddress
 * strct   = GInetSocketAddress
 * realStrct=
 * ctorStrct=GSocketAddress
 * clss    = InetSocketAddress
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_inet_socket_address_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.gio.InetAddress
 * structWrap:
 * 	- GInetAddress* -> InetAddress
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.InetSocketAddress;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gio.InetAddress;



private import gtkD.gio.SocketAddress;

/**
 * Description
 * An IPv4 or IPv6 socket address; that is, the combination of a
 * GInetAddress and a port number.
 */
public class InetSocketAddress : SocketAddress
{
	
	/** the main Gtk struct */
	protected GInetSocketAddress* gInetSocketAddress;
	
	
	public GInetSocketAddress* getInetSocketAddressStruct()
	{
		return gInetSocketAddress;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gInetSocketAddress;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GInetSocketAddress* gInetSocketAddress)
	{
		if(gInetSocketAddress is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gInetSocketAddress);
		if( ptr !is null )
		{
			this = cast(InetSocketAddress)ptr;
			return;
		}
		super(cast(GSocketAddress*)gInetSocketAddress);
		this.gInetSocketAddress = gInetSocketAddress;
	}
	
	/**
	 */
	
	/**
	 * Creates a new GInetSocketAddress for address and port.
	 * Since 2.22
	 * Params:
	 * address =  a GInetAddress
	 * port =  a port number
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (InetAddress address, ushort port)
	{
		// GSocketAddress * g_inet_socket_address_new (GInetAddress *address,  guint16 port);
		auto p = g_inet_socket_address_new((address is null) ? null : address.getInetAddressStruct(), port);
		if(p is null)
		{
			throw new ConstructionException("null returned by g_inet_socket_address_new((address is null) ? null : address.getInetAddressStruct(), port)");
		}
		this(cast(GInetSocketAddress*) p);
	}
	
	/**
	 * Gets address's GInetAddress.
	 * Since 2.22
	 * Returns: the GInetAddress for address, which must beg_object_ref()'d if it will be stored
	 */
	public InetAddress getAddress()
	{
		// GInetAddress * g_inet_socket_address_get_address (GInetSocketAddress *address);
		auto p = g_inet_socket_address_get_address(gInetSocketAddress);
		if(p is null)
		{
			return null;
		}
		return new InetAddress(cast(GInetAddress*) p);
	}
	
	/**
	 * Gets address's port.
	 * Since 2.22
	 * Returns: the port for address
	 */
	public ushort getPort()
	{
		// guint16 g_inet_socket_address_get_port (GInetSocketAddress *address);
		return g_inet_socket_address_get_port(gInetSocketAddress);
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
