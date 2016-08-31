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
 * inFile  = gdk-Cairo-Interaction.html
 * outPack = gdk
 * outFile = GdkCairo
 * strct   = 
 * realStrct=
 * ctorStrct=
 * clss    = 
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gdk_cairo_
 * omit structs:
 * omit prefixes:
 * omit code:
 * 	- gdk_cairo_create
 * 	- gdk_cairo_set_source_color
 * 	- gdk_cairo_set_source_pixbuf
 * 	- gdk_cairo_set_source_pixmap
 * 	- gdk_cairo_rectangle
 * 	- gdk_cairo_region
 * 	- gdk_cairo_reset_clip
 * omit signals:
 * imports:
 * 	- gtkD.cairo.Context
 * structWrap:
 * 	- GdkColor* -> Color
 * 	- GdkDrawable* -> Drawable
 * 	- GdkPixbuf* -> Pixbuf
 * 	- GdkPixmap* -> Pixmap
 * 	- GdkRectangle* -> Rectangle
 * 	- GdkRegion* -> Region
 * 	- cairo_t* -> Context
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gdk.GdkCairo;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;


private import gtkD.cairo.Context;




/**
 * This file is not used,
 *
 * It is here just to tell you to look at
 * gtkD.cairo.Context class for the methods that where here..
 */


/**
 */


version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gdk");
        } else version (DigitalMars) {
            pragma(link, "DD-gdk");
        } else {
            pragma(link, "DO-gdk");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gdk");
        } else version (DigitalMars) {
            pragma(link, "DD-gdk");
        } else {
            pragma(link, "DO-gdk");
        }
    }
}
