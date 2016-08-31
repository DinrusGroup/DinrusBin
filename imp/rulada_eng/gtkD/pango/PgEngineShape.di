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
 * inFile  = PangoEngineShape.html
 * outPack = pango
 * outFile = PgEngineShape
 * strct   = PangoEngineShape
 * realStrct=
 * ctorStrct=
 * clss    = PgEngineShape
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- script_engine_shape_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.pango.PgEngineShape;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;





private import gtkD.pango.PgEngine;

/**
 * Description
 * The shape engines are rendering-system dependent
 * engines that convert character strings into glyph strings.
 * These engines are used in pango_shape().
 */
public class PgEngineShape : PgEngine
{
	
	/** the main Gtk struct */
	protected PangoEngineShape* pangoEngineShape;
	
	
	public PangoEngineShape* getPgEngineShapeStruct()
	{
		return pangoEngineShape;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)pangoEngineShape;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoEngineShape* pangoEngineShape)
	{
		if(pangoEngineShape is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)pangoEngineShape);
		if( ptr !is null )
		{
			this = cast(PgEngineShape)ptr;
			return;
		}
		super(cast(PangoEngine*)pangoEngineShape);
		this.pangoEngineShape = pangoEngineShape;
	}
	
	/**
	 */
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-pango");
        } else version (DigitalMars) {
            pragma(link, "DD-pango");
        } else {
            pragma(link, "DO-pango");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-pango");
        } else version (DigitalMars) {
            pragma(link, "DD-pango");
        } else {
            pragma(link, "DO-pango");
        }
    }
}
