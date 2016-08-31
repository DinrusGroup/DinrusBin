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
 * inFile  = AtkNoOpObject.html
 * outPack = atk
 * outFile = NoOpObject
 * strct   = AtkNoOpObject
 * realStrct=
 * ctorStrct=
 * clss    = NoOpObject
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- atk_no_op_object_
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

module gtkD.atk.NoOpObject;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;


private import gtkD.atk.ObjectAtk;
private import gtkD.gobject.ObjectG;



private import gtkD.atk.ObjectAtk;

/**
 * Description
 * An AtkNoOpObject is an AtkObject which purports to implement all ATK
 * interfaces. It is the type of AtkObject which is created if an accessible
 * object is requested for an object type for which no factory type is specified.
 */
public class NoOpObject : ObjectAtk
{
	
	/** the main Gtk struct */
	protected AtkNoOpObject* atkNoOpObject;
	
	
	public AtkNoOpObject* getNoOpObjectStruct()
	{
		return atkNoOpObject;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)atkNoOpObject;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkNoOpObject* atkNoOpObject)
	{
		if(atkNoOpObject is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)atkNoOpObject);
		if( ptr !is null )
		{
			this = cast(NoOpObject)ptr;
			return;
		}
		super(cast(AtkObject*)atkNoOpObject);
		this.atkNoOpObject = atkNoOpObject;
	}
	
	/**
	 */
	
	/**
	 * Provides a default (non-functioning stub) AtkObject.
	 * Application maintainers should not use this method.
	 * Params:
	 * obj =  a GObject
	 * Returns: a default (non-functioning stub) AtkObject
	 */
	public static ObjectAtk newNoOpObject(ObjectG obj)
	{
		// AtkObject * atk_no_op_object_new (GObject *obj);
		auto p = atk_no_op_object_new((obj is null) ? null : obj.getObjectGStruct());
		if(p is null)
		{
			return null;
		}
		return new ObjectAtk(cast(AtkObject*) p);
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
