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
 * inFile  = AtkGObjectAccessible.html
 * outPack = atk
 * outFile = GObjectAccessible
 * strct   = AtkGObjectAccessible
 * realStrct=
 * ctorStrct=
 * clss    = GObjectAccessible
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- atk_gobject_accessible_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.atk.ObjectAtk
 * 	- gtkD.gobject.ObjectG
 * structWrap:
 * 	- AtkObject* -> ObjectAtk
 * 	- GObject* -> ObjectG
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.atk.GObjectAccessible;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;


private import gtkD.atk.ObjectAtk;
private import gtkD.gobject.ObjectG;



private import gtkD.atk.ObjectAtk;

/**
 * Description
 * This object class is derived from AtkObject. It can be used as a basis for
 * implementing accessible objects for GObjects which are not derived from
 * GtkWidget. One example of its use is in providing an accessible object
 * for GnomeCanvasItem in the GAIL library.
 */
public class GObjectAccessible : ObjectAtk
{
	
	/** the main Gtk struct */
	protected AtkGObjectAccessible* atkGObjectAccessible;
	
	
	public AtkGObjectAccessible* getGObjectAccessibleStruct()
	{
		return atkGObjectAccessible;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)atkGObjectAccessible;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkGObjectAccessible* atkGObjectAccessible)
	{
		if(atkGObjectAccessible is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)atkGObjectAccessible);
		if( ptr !is null )
		{
			this = cast(GObjectAccessible)ptr;
			return;
		}
		super(cast(AtkObject*)atkGObjectAccessible);
		this.atkGObjectAccessible = atkGObjectAccessible;
	}
	
	/**
	 */
	
	/**
	 * Gets the accessible object for the specified obj.
	 * Params:
	 * obj =  a GObject
	 * Returns: a AtkObject which is the accessible object for the obj
	 */
	public static ObjectAtk forObject(ObjectG obj)
	{
		// AtkObject * atk_gobject_accessible_for_object (GObject *obj);
		auto p = atk_gobject_accessible_for_object((obj is null) ? null : obj.getObjectGStruct());
		if(p is null)
		{
			return null;
		}
		return new ObjectAtk(cast(AtkObject*) p);
	}
	
	/**
	 * Gets the GObject for which obj is the accessible object.
	 * Returns: a GObject which is the object for which obj is the accessible object
	 */
	public ObjectG getObject()
	{
		// GObject * atk_gobject_accessible_get_object (AtkGObjectAccessible *obj);
		auto p = atk_gobject_accessible_get_object(atkGObjectAccessible);
		if(p is null)
		{
			return null;
		}
		return new ObjectG(cast(GObject*) p);
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-atk");
        } else version (DigitalMars) {
            pragma(link, "DD-atk");
        } else {
            pragma(link, "DO-atk");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-atk");
        } else version (DigitalMars) {
            pragma(link, "DD-atk");
        } else {
            pragma(link, "DO-atk");
        }
    }
}
