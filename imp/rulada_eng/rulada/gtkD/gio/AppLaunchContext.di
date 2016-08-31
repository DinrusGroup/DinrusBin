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
 * outFile = AppLaunchContext
 * strct   = GAppLaunchContext
 * realStrct=
 * ctorStrct=
 * clss    = AppLaunchContext
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_app_launch_context_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ListG
 * 	- gtkD.gio.AppInfoIF
 * structWrap:
 * 	- GAppInfo* -> AppInfoIF
 * 	- GList* -> ListG
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.AppLaunchContext;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.gio.AppInfoIF;




/**
 */
public class AppLaunchContext
{
	
	/** the main Gtk struct */
	protected GAppLaunchContext* gAppLaunchContext;
	
	
	public GAppLaunchContext* getAppLaunchContextStruct()
	{
		return gAppLaunchContext;
	}
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct()
	{
		return cast(void*)gAppLaunchContext;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GAppLaunchContext* gAppLaunchContext)
	{
		if(gAppLaunchContext is null)
		{
			this = null;
			return;
		}
		this.gAppLaunchContext = gAppLaunchContext;
	}
	
	/**
	 */
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
