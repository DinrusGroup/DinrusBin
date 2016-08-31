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
 * inFile  = GNetworkService.html
 * outPack = gio
 * outFile = NetworkService
 * strct   = GNetworkService
 * realStrct=
 * ctorStrct=GSocketConnectable
 * clss    = NetworkService
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * 	- SocketConnectableIF
 * prefixes:
 * 	- g_network_service_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gio.SocketConnectableT
 * 	- gtkD.gio.SocketConnectableIF
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.NetworkService;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gio.SocketConnectableT;
private import gtkD.gio.SocketConnectableIF;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * Like GNetworkAddress does with hostnames, GNetworkService
 * provides an easy way to resolve a SRV record, and then attempt to
 * connect to one of the hosts that implements that service, handling
 * service priority/weighting, multiple IP addresses, and multiple
 * address families.
 * See GSrvTarget for more information about SRV records, and see
 * GSocketConnectable for and example of using the connectable
 * interface.
 */
public class NetworkService : ObjectG, SocketConnectableIF
{
	
	/** the main Gtk struct */
	protected GNetworkService* gNetworkService;
	
	
	public GNetworkService* getNetworkServiceStruct()
	{
		return gNetworkService;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gNetworkService;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GNetworkService* gNetworkService)
	{
		if(gNetworkService is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gNetworkService);
		if( ptr !is null )
		{
			this = cast(NetworkService)ptr;
			return;
		}
		super(cast(GObject*)gNetworkService);
		this.gNetworkService = gNetworkService;
	}
	
	// add the SocketConnectable capabilities
	mixin SocketConnectableT!(GNetworkService);
	
	/**
	 */
	
	/**
	 * Creates a new GNetworkService representing the given service,
	 * protocol, and domain. This will initially be unresolved; use the
	 * GSocketConnectable interface to resolve it.
	 * Since 2.22
	 * Params:
	 * service =  the service type to look up (eg, "ldap")
	 * protocol =  the networking protocol to use for service (eg, "tcp")
	 * domain =  the DNS domain to look up the service in
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string service, string protocol, string domain)
	{
		// GSocketConnectable * g_network_service_new (const gchar *service,  const gchar *protocol,  const gchar *domain);
		auto p = g_network_service_new(Str.toStringz(service), Str.toStringz(protocol), Str.toStringz(domain));
		if(p is null)
		{
			throw new ConstructionException("null returned by g_network_service_new(Str.toStringz(service), Str.toStringz(protocol), Str.toStringz(domain))");
		}
		this(cast(GNetworkService*) p);
	}
	
	/**
	 * Gets srv's service name (eg, "ldap").
	 * Since 2.22
	 * Returns: srv's service name
	 */
	public string getService()
	{
		// const gchar * g_network_service_get_service (GNetworkService *srv);
		return Str.toString(g_network_service_get_service(gNetworkService));
	}
	
	/**
	 * Gets srv's protocol name (eg, "tcp").
	 * Since 2.22
	 * Returns: srv's protocol name
	 */
	public string getProtocol()
	{
		// const gchar * g_network_service_get_protocol (GNetworkService *srv);
		return Str.toString(g_network_service_get_protocol(gNetworkService));
	}
	
	/**
	 * Gets the domain that srv serves. This might be either UTF-8 or
	 * ASCII-encoded, depending on what srv was created with.
	 * Since 2.22
	 * Returns: srv's domain name
	 */
	public string getDomain()
	{
		// const gchar * g_network_service_get_domain (GNetworkService *srv);
		return Str.toString(g_network_service_get_domain(gNetworkService));
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
