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
 * inFile  = GThemedIcon.html
 * outPack = gio
 * outFile = ThemedIcon
 * strct   = GThemedIcon
 * realStrct=
 * ctorStrct=GIcon
 * clss    = ThemedIcon
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * 	- IconIF
 * prefixes:
 * 	- g_themed_icon_
 * omit structs:
 * omit prefixes:
 * omit code:
 * 	- g_themed_icon_new
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gio.IconT
 * 	- gtkD.gio.IconIF
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.ThemedIcon;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gio.IconT;
private import gtkD.gio.IconIF;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GThemedIcon is an implementation of GIcon that supports icon themes.
 * GThemedIcon contains a list of all of the icons present in an icon
 * theme, so that icons can be looked up quickly. GThemedIcon does
 * not provide actual pixmaps for icons, just the icon names.
 * Ideally something like gtk_icon_theme_choose_icon() should be used to
 * resolve the list of names so that fallback icons work nicely with
 * themes that inherit other themes.
 */
public class ThemedIcon : ObjectG, IconIF
{
	
	/** the main Gtk struct */
	protected GThemedIcon* gThemedIcon;
	
	
	public GThemedIcon* getThemedIconStruct()
	{
		return gThemedIcon;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gThemedIcon;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GThemedIcon* gThemedIcon)
	{
		if(gThemedIcon is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gThemedIcon);
		if( ptr !is null )
		{
			this = cast(ThemedIcon)ptr;
			return;
		}
		super(cast(GObject*)gThemedIcon);
		this.gThemedIcon = gThemedIcon;
	}
	
	// add the Icon capabilities
	mixin IconT!(GThemedIcon);
	
	/**
	 */
	
	/**
	 * Creates a new themed icon for iconnames.
	 * Params:
	 * iconnames =  an array of strings containing icon names.
	 * len =  the length of the iconnames array, or -1 if iconnames is
	 *  NULL-terminated
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string[] iconnames, int len)
	{
		// GIcon * g_themed_icon_new_from_names (char **iconnames,  int len);
		auto p = g_themed_icon_new_from_names(Str.toStringzArray(iconnames), len);
		if(p is null)
		{
			throw new ConstructionException("null returned by g_themed_icon_new_from_names(Str.toStringzArray(iconnames), len)");
		}
		this(cast(GThemedIcon*) p);
	}
	
	/**
	 * Creates a new themed icon for iconname, and all the names
	 * that can be created by shortening iconname at '-' characters.
	 * Params:
	 * iconname =  a string containing an icon name
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string iconname)
	{
		// GIcon * g_themed_icon_new_with_default_fallbacks  (const char *iconname);
		auto p = g_themed_icon_new_with_default_fallbacks(Str.toStringz(iconname));
		if(p is null)
		{
			throw new ConstructionException("null returned by g_themed_icon_new_with_default_fallbacks(Str.toStringz(iconname))");
		}
		this(cast(GThemedIcon*) p);
	}
	
	/**
	 * Prepend a name to the list of icons from within icon.
	 * Note
	 * Note that doing so invalidates the hash computed by prior calls
	 * to g_icon_hash().
	 * Since 2.18
	 * Params:
	 * icon =  a GThemedIcon
	 * iconname =  name of icon to prepend to list of icons from within icon.
	 */
	public void prependName(string iconname)
	{
		// void g_themed_icon_prepend_name (GThemedIcon *icon,  const char *iconname);
		g_themed_icon_prepend_name(gThemedIcon, Str.toStringz(iconname));
	}
	
	/**
	 * Append a name to the list of icons from within icon.
	 * Note
	 * Note that doing so invalidates the hash computed by prior calls
	 * to g_icon_hash().
	 * Params:
	 * icon =  a GThemedIcon
	 * iconname =  name of icon to append to list of icons from within icon.
	 */
	public void appendName(string iconname)
	{
		// void g_themed_icon_append_name (GThemedIcon *icon,  const char *iconname);
		g_themed_icon_append_name(gThemedIcon, Str.toStringz(iconname));
	}
	
	/**
	 * Gets the names of icons from within icon.
	 * Returns: a list of icon names.
	 */
	public string[] getNames()
	{
		// const gchar* const * g_themed_icon_get_names (GThemedIcon *icon);
		return Str.toStringArray(g_themed_icon_get_names(gThemedIcon));
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
