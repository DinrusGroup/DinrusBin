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
 * inFile  = GstGhostPad.html
 * outPack = gstreamer
 * outFile = GhostPad
 * strct   = GstGhostPad
 * realStrct=
 * ctorStrct=
 * clss    = GhostPad
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = Pad
 * implements:
 * prefixes:
 * 	- gst_ghost_pad_
 * 	- gst_
 * omit structs:
 * omit prefixes:
 * omit code:
 * 	- gst_ghost_pad_new
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gstreamer.Pad
 * structWrap:
 * 	- GstGhostPad* -> GhostPad
 * 	- GstPad* -> Pad
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gstreamer.GhostPad;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gstreamer.Pad;




/**
 * Description
 * GhostPads are useful when organizing pipelines with GstBin like elements.
 * The idea here is to create hierarchical element graphs. The bin element
 * contains a sub-graph. Now one would like to treat the bin-element like other
 * GstElements. This is where GhostPads come into play. A GhostPad acts as a
 * proxy for another pad. Thus the bin can have sink and source ghost-pads that
 * are associated with sink and source pads of the child elements.
 * If the target pad is known at creation time, gst_ghost_pad_new() is the
 * function to use to get a ghost-pad. Otherwise one can use gst_ghost_pad_new_no_target()
 * to create the ghost-pad and use gst_ghost_pad_set_target() to establish the
 * association later on.
 * Note that GhostPads add overhead to the data processing of a pipeline.
 * Last reviewed on 2005-11-18 (0.9.5)
 */
public class GhostPad : Pad
{
	
	/** the main Gtk struct */
	protected GstGhostPad* gstGhostPad;
	
	
	public GstGhostPad* getGhostPadStruct()
	{
		return gstGhostPad;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gstGhostPad;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstGhostPad* gstGhostPad)
	{
		if(gstGhostPad is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gstGhostPad);
		if( ptr !is null )
		{
			this = cast(GhostPad)ptr;
			return;
		}
		super(cast(GstPad*)gstGhostPad);
		this.gstGhostPad = gstGhostPad;
	}
	
	/**
	 * Create a new ghostpad with target as the target. The direction and
	 * padtemplate will be taken from the target pad.
	 * Will ref the target.
	 * Params:
	 *  name = the name of the new pad, or NULL to assign a default name.
	 *  target = the pad to ghost.
	 * Returns:
	 *  a new GstPad, or NULL in case of an error.
	 */
	public this(string name, Pad target)
	{
		// GstPad* gst_ghost_pad_new (const gchar *name,  GstPad *target);
		this( cast(GstGhostPad*) gst_ghost_pad_new(Str.toStringz(name), (target is null) ? null : target.getPadStruct()) );
	}
	
	/**
	 */
	
	/**
	 * Create a new ghostpad without a target with the given direction.
	 * A target can be set on the ghostpad later with the
	 * gst_ghost_pad_set_target() function.
	 * The created ghostpad will not have a padtemplate.
	 * Params:
	 * name =  the name of the new pad, or NULL to assign a default name.
	 * dir =  the direction of the ghostpad
	 * Returns: a new GstPad, or NULL in case of an error.
	 */
	public static Pad newNoTarget(string name, GstPadDirection dir)
	{
		// GstPad* gst_ghost_pad_new_no_target (const gchar *name,  GstPadDirection dir);
		auto p = gst_ghost_pad_new_no_target(Str.toStringz(name), dir);
		if(p is null)
		{
			return null;
		}
		return new Pad(cast(GstPad*) p);
	}
	
	/**
	 * Create a new ghostpad with target as the target. The direction will be taken
	 * from the target pad. The template used on the ghostpad will be template.
	 * Will ref the target.
	 * Params:
	 * name =  the name of the new pad, or NULL to assign a default name.
	 * target =  the pad to ghost.
	 * templ =  the GstPadTemplate to use on the ghostpad.
	 * Returns: a new GstPad, or NULL in case of an error.Since 0.10.10
	 */
	public static Pad newFromTemplate(string name, Pad target, GstPadTemplate* templ)
	{
		// GstPad* gst_ghost_pad_new_from_template (const gchar *name,  GstPad *target,  GstPadTemplate *templ);
		auto p = gst_ghost_pad_new_from_template(Str.toStringz(name), (target is null) ? null : target.getPadStruct(), templ);
		if(p is null)
		{
			return null;
		}
		return new Pad(cast(GstPad*) p);
	}
	
	/**
	 * Create a new ghostpad based on templ, without setting a target. The
	 * direction will be taken from the templ.
	 * Params:
	 * name =  the name of the new pad, or NULL to assign a default name.
	 * templ =  the GstPadTemplate to create the ghostpad from.
	 * Returns: a new GstPad, or NULL in case of an error.Since 0.10.10
	 */
	public static Pad newNoTargetFromTemplate(string name, GstPadTemplate* templ)
	{
		// GstPad* gst_ghost_pad_new_no_target_from_template  (const gchar *name,  GstPadTemplate *templ);
		auto p = gst_ghost_pad_new_no_target_from_template(Str.toStringz(name), templ);
		if(p is null)
		{
			return null;
		}
		return new Pad(cast(GstPad*) p);
	}
	
	/**
	 * Set the new target of the ghostpad gpad. Any existing target
	 * is unlinked and links to the new target are established.
	 * Params:
	 * newtarget =  the new pad target
	 * Returns: TRUE if the new target could be set. This function can return FALSEwhen the internal pads could not be linked.
	 */
	public int setTarget(Pad newtarget)
	{
		// gboolean gst_ghost_pad_set_target (GstGhostPad *gpad,  GstPad *newtarget);
		return gst_ghost_pad_set_target(gstGhostPad, (newtarget is null) ? null : newtarget.getPadStruct());
	}
	
	/**
	 * Get the target pad of gpad. Unref target pad after usage.
	 * Returns: the target GstPad, can be NULL if the ghostpadhas no target set. Unref target pad after usage.
	 */
	public Pad getTarget()
	{
		// GstPad* gst_ghost_pad_get_target (GstGhostPad *gpad);
		auto p = gst_ghost_pad_get_target(gstGhostPad);
		if(p is null)
		{
			return null;
		}
		return new Pad(cast(GstPad*) p);
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gstreamer");
        } else version (DigitalMars) {
            pragma(link, "DD-gstreamer");
        } else {
            pragma(link, "DO-gstreamer");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gstreamer");
        } else version (DigitalMars) {
            pragma(link, "DD-gstreamer");
        } else {
            pragma(link, "DO-gstreamer");
        }
    }
}
