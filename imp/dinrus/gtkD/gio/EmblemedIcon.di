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
 * inFile  = GEmblemedIcon.html
 * outPack = gio
 * outFile = EmblemedIcon
 * strct   = GEmblemedIcon
 * realStrct=
 * ctorStrct=GIcon
 * clss    = EmblemedIcon
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * 	- IconIF
 * prefixes:
 * 	- g_emblemed_icon_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.ListG
 * 	- gtkD.gio.Emblem
 * 	- gtkD.gio.Icon
 * 	- gtkD.gio.IconIF
 * 	- gtkD.gio.IconT
 * structWrap:
 * 	- GEmblem* -> Emblem
 * 	- GIcon* -> IconIF
 * 	- GList* -> ListG
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.EmblemedIcon;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ListG;
private import gtkD.gio.Emblem;
private import gtkD.gio.Icon;
private import gtkD.gio.IconIF;
private import gtkD.gio.IconT;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GEmblemedIcon is an implementation of GIcon that supports
 * adding an emblem to an icon. Adding multiple emblems to an
 * icon is ensured via g_emblemed_icon_add_emblem().
 * Note that GEmblemedIcon allows no control over the position
 * of the emblems. See also GEmblem for more information.
 */
public class EmblemedIcon : ObjectG, IconIF
{
	
	/** the main Gtk struct */
	protected GEmblemedIcon* gEmblemedIcon;
	
	
	public GEmblemedIcon* getEmblemedIconStruct()
	{
		return gEmblemedIcon;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gEmblemedIcon;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GEmblemedIcon* gEmblemedIcon)
	{
		if(gEmblemedIcon is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gEmblemedIcon);
		if( ptr !is null )
		{
			this = cast(EmblemedIcon)ptr;
			return;
		}
		super(cast(GObject*)gEmblemedIcon);
		this.gEmblemedIcon = gEmblemedIcon;
	}
	
	// add the Icon capabilities
	mixin IconT!(GEmblemedIcon);
	
	/**
	 */
	
	/**
	 * Creates a new emblemed icon for icon with the emblem emblem.
	 * Since 2.18
	 * Params:
	 * icon =  a GIcon
	 * emblem =  a GEmblem
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (IconIF icon, Emblem emblem)
	{
		// GIcon * g_emblemed_icon_new (GIcon *icon,  GEmblem *emblem);
		auto p = g_emblemed_icon_new((icon is null) ? null : icon.getIconTStruct(), (emblem is null) ? null : emblem.getEmblemStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by g_emblemed_icon_new((icon is null) ? null : icon.getIconTStruct(), (emblem is null) ? null : emblem.getEmblemStruct())");
		}
		this(cast(GEmblemedIcon*) p);
	}
	
	/**
	 * Gets the main icon for emblemed.
	 * Since 2.18
	 * Returns: a GIcon that is owned by emblemed
	 */
	public IconIF getIcon()
	{
		// GIcon * g_emblemed_icon_get_icon (GEmblemedIcon *emblemed);
		auto p = g_emblemed_icon_get_icon(gEmblemedIcon);
		if(p is null)
		{
			return null;
		}
		return new Icon(cast(GIcon*) p);
	}
	
	/**
	 * Gets the list of emblems for the icon.
	 * Since 2.18
	 * Returns: a GList of GEmblem s that is owned by emblemed
	 */
	public ListG getEmblems()
	{
		// GList * g_emblemed_icon_get_emblems (GEmblemedIcon *emblemed);
		auto p = g_emblemed_icon_get_emblems(gEmblemedIcon);
		if(p is null)
		{
			return null;
		}
		return new ListG(cast(GList*) p);
	}
	
	/**
	 * Adds emblem to the GList of GEmblem s.
	 * Since 2.18
	 * Params:
	 * emblem =  a GEmblem
	 */
	public void addEmblem(Emblem emblem)
	{
		// void g_emblemed_icon_add_emblem (GEmblemedIcon *emblemed,  GEmblem *emblem);
		g_emblemed_icon_add_emblem(gEmblemedIcon, (emblem is null) ? null : emblem.getEmblemStruct());
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
