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
 * inFile  = GtkIMMulticontext.html
 * outPack = gtk
 * outFile = IMMulticontext
 * strct   = GtkIMMulticontext
 * realStrct=
 * ctorStrct=
 * clss    = IMMulticontext
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_im_multicontext_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gtk.IMContext
 * 	- gtkD.gtk.MenuShell
 * structWrap:
 * 	- GtkIMContext* -> IMContext
 * 	- GtkMenuShell* -> MenuShell
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.IMMulticontext;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.IMContext;
private import gtkD.gtk.MenuShell;



private import gtkD.gtk.IMContext;

/**
 * Description
 */
public class IMMulticontext : IMContext
{
	
	/** the main Gtk struct */
	protected GtkIMMulticontext* gtkIMMulticontext;
	
	
	public GtkIMMulticontext* getIMMulticontextStruct()
	{
		return gtkIMMulticontext;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkIMMulticontext;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkIMMulticontext* gtkIMMulticontext)
	{
		if(gtkIMMulticontext is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkIMMulticontext);
		if( ptr !is null )
		{
			this = cast(IMMulticontext)ptr;
			return;
		}
		super(cast(GtkIMContext*)gtkIMMulticontext);
		this.gtkIMMulticontext = gtkIMMulticontext;
	}
	
	/**
	 */
	
	/**
	 * Creates a new GtkIMMulticontext.
	 * Returns: a new GtkIMMulticontext.
	 */
	public static IMContext newIMMulticontext()
	{
		// GtkIMContext * gtk_im_multicontext_new (void);
		auto p = gtk_im_multicontext_new();
		if(p is null)
		{
			return null;
		}
		return new IMContext(cast(GtkIMContext*) p);
	}
	
	/**
	 * Add menuitems for various available input methods to a menu;
	 * the menuitems, when selected, will switch the input method
	 * for the context and the global default input method.
	 * Params:
	 * menushell =  a GtkMenuShell
	 */
	public void appendMenuitems(MenuShell menushell)
	{
		// void gtk_im_multicontext_append_menuitems  (GtkIMMulticontext *context,  GtkMenuShell *menushell);
		gtk_im_multicontext_append_menuitems(gtkIMMulticontext, (menushell is null) ? null : menushell.getMenuShellStruct());
	}
	
	/**
	 * Gets the id of the currently active slave of the context.
	 * Since 2.16
	 * Returns: the id of the currently active slave
	 */
	public string getContextId()
	{
		// const char * gtk_im_multicontext_get_context_id (GtkIMMulticontext *context);
		return Str.toString(gtk_im_multicontext_get_context_id(gtkIMMulticontext));
	}
	
	/**
	 * Sets the context id for context.
	 * This causes the currently active slave of context to be
	 * replaced by the slave corresponding to the new context id.
	 * Since 2.16
	 * Params:
	 * context =  a GtkIMMulticontext
	 * contextId =  the id to use
	 */
	public void setContextId(string contextId)
	{
		// void gtk_im_multicontext_set_context_id (GtkIMMulticontext *context,  const char *context_id);
		gtk_im_multicontext_set_context_id(gtkIMMulticontext, Str.toStringz(contextId));
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gtk");
        } else version (DigitalMars) {
            pragma(link, "DD-gtk");
        } else {
            pragma(link, "DO-gtk");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gtk");
        } else version (DigitalMars) {
            pragma(link, "DD-gtk");
        } else {
            pragma(link, "DO-gtk");
        }
    }
}
