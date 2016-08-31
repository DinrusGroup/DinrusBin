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
 * outPack = pango
 * outFile = PgFontset
 * strct   = PangoFontset
 * realStrct=
 * ctorStrct=
 * clss    = PgFontset
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = GObject
 * implements:
 * prefixes:
 * 	- pango_fontset_
 * omit structs:
 * omit prefixes:
 * 	- pango_fontset_simple_
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.pango.PgFont
 * 	- gtkD.pango.PgFontMetrics
 * structWrap:
 * 	- PangoFont* -> PgFont
 * 	- PangoFontMetrics* -> PgFontMetrics
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.pango.PgFontset;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.pango.PgFont;
private import gtkD.pango.PgFontMetrics;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * Pango supports a flexible architecture where a
 * particular rendering architecture can supply an
 * implementation of fonts. The PangoFont structure
 * represents an abstract rendering-system-independent font.
 * Pango provides routines to list available fonts, and
 * to load a font of a given description.
 */
public class PgFontset : ObjectG
{
	
	/** the main Gtk struct */
	protected PangoFontset* pangoFontset;
	
	
	public PangoFontset* getPgFontsetStruct()
	{
		return pangoFontset;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)pangoFontset;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoFontset* pangoFontset)
	{
		if(pangoFontset is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)pangoFontset);
		if( ptr !is null )
		{
			this = cast(PgFontset)ptr;
			return;
		}
		super(cast(GObject*)pangoFontset);
		this.pangoFontset = pangoFontset;
	}
	
	/**
	 */
	
	/**
	 * Returns the font in the fontset that contains the best glyph for the
	 * Unicode character wc.
	 * Params:
	 * wc =  a Unicode character
	 * Returns: a PangoFont. The caller must call g_object_unref when finished with the font.
	 */
	public PgFont getFont(uint wc)
	{
		// PangoFont * pango_fontset_get_font (PangoFontset *fontset,  guint wc);
		auto p = pango_fontset_get_font(pangoFontset, wc);
		if(p is null)
		{
			return null;
		}
		return new PgFont(cast(PangoFont*) p);
	}
	
	/**
	 * Get overall metric information for the fonts in the fontset.
	 * Returns: a PangoFontMetrics object. The caller must call pango_font_metrics_unref() when finished using the object.
	 */
	public PgFontMetrics getMetrics()
	{
		// PangoFontMetrics * pango_fontset_get_metrics (PangoFontset *fontset);
		auto p = pango_fontset_get_metrics(pangoFontset);
		if(p is null)
		{
			return null;
		}
		return new PgFontMetrics(cast(PangoFontMetrics*) p);
	}
	
	/**
	 * Iterates through all the fonts in a fontset, calling func for
	 * each one. If func returns TRUE, that stops the iteration.
	 * Since 1.4
	 * Params:
	 * func =  Callback function
	 * data =  data to pass to the callback function
	 */
	public void foreac(PangoFontsetForeachFunc func, void* data)
	{
		// void pango_fontset_foreach (PangoFontset *fontset,  PangoFontsetForeachFunc func,  gpointer data);
		pango_fontset_foreach(pangoFontset, func, data);
	}
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
