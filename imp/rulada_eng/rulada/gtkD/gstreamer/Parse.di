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
 * inFile  = gstreamer-GstParse.html
 * outPack = gstreamer
 * outFile = Parse
 * strct   = 
 * realStrct=
 * ctorStrct=
 * clss    = Parse
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gst_parse_
 * omit structs:
 * omit prefixes:
 * omit code:
 * 	- gst_parse_error_quark
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.Quark
 * 	- gtkD.glib.ErrorG
 * 	- gtkD.gstreamer.Element
 * structWrap:
 * 	- GError* -> ErrorG
 * 	- GQuark -> Quark
 * 	- GstElement* -> Element
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gstreamer.Parse;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.Quark;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gstreamer.Element;




/**
 * Description
 * These function allow to create a pipeline based on the syntax used in the
 * gst-launch utillity.
 */
public class Parse
{
	
	/**
	 * Get the error quark used by the parsing subsystem.
	 * Returns:
	 *  the quark of the parse errors.
	 */
	public static Quark errorQuark()
	{
		// GQuark gst_parse_error_quark (void);
		return new Quark( cast(uint*)gst_parse_error_quark() );
	}
	
	/**
	 */
	
	/**
	 * Create a new pipeline based on command line syntax.
	 * Please note that you might get a return value that is not NULL even though
	 * the error is set. In this case there was a recoverable parsing error and you
	 * can try to play the pipeline.
	 * Params:
	 * pipelineDescription =  the command line describing the pipeline
	 * Returns: a new element on success, NULL on failure. If more than one toplevelelement is specified by the pipeline_description, all elements are put intoa GstPipeline, which than is returned.
	 * Throws: GException on failure.
	 */
	public static Element launch(string pipelineDescription)
	{
		// GstElement* gst_parse_launch (const gchar *pipeline_description,  GError **error);
		GError* err = null;
		
		auto p = gst_parse_launch(Str.toStringz(pipelineDescription), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			return null;
		}
		return new Element(cast(GstElement*) p);
	}
	
	/**
	 * Create a new element based on command line syntax.
	 * error will contain an error message if an erroneuos pipeline is specified.
	 * An error does not mean that the pipeline could not be constructed.
	 * Params:
	 * argv =  null-terminated array of arguments
	 * Returns: a new element on success and NULL on failure.
	 * Throws: GException on failure.
	 */
	public static Element launchv(char** argv)
	{
		// GstElement* gst_parse_launchv (const gchar **argv,  GError **error);
		GError* err = null;
		
		auto p = gst_parse_launchv(argv, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			return null;
		}
		return new Element(cast(GstElement*) p);
	}
	
	/**
	 * This is a convenience wrapper around gst_parse_launch() to create a
	 * GstBin from a gst-launch-style pipeline description. See
	 * gst_parse_launch() and the gst-launch man page for details about the
	 * syntax. Ghost pads on the bin for unconnected source or sink pads
	 * within the bin can automatically be created (but only a maximum of
	 * one ghost pad for each direction will be created; if you expect
	 * multiple unconnected source pads or multiple unconnected sink pads
	 * and want them all ghosted, you will have to create the ghost pads
	 * yourself).
	 * Params:
	 * binDescription =  command line describing the bin
	 * ghostUnconnectedPads =  whether to automatically create ghost pads
	 *  for unconnected source or sink pads within
	 *  the bin
	 * Returns: a newly-created bin, or NULL if an error occurred.Since 0.10.3
	 * Throws: GException on failure.
	 */
	public static Element binFromDescription(string binDescription, int ghostUnconnectedPads)
	{
		// GstElement* gst_parse_bin_from_description (const gchar *bin_description,  gboolean ghost_unconnected_pads,  GError **err);
		GError* err = null;
		
		auto p = gst_parse_bin_from_description(Str.toStringz(binDescription), ghostUnconnectedPads, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			return null;
		}
		return new Element(cast(GstElement*) p);
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
