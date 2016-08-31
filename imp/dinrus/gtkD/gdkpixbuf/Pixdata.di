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
 * inFile  = gdk-pixbuf-inline.html
 * outPack = gdkpixbuf
 * outFile = Pixdata
 * strct   = GdkPixdata
 * realStrct=
 * ctorStrct=
 * clss    = Pixdata
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gdk_pixdata_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.gdk.Pixbuf
 * 	- gtkD.glib.ErrorG
 * 	- gtkD.glib.GException
 * 	- gtkD.glib.StringG
 * 	- gtkD.glib.Str
 * structWrap:
 * 	- GString* -> StringG
 * 	- GdkPixbuf* -> Pixbuf
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gdkpixbuf.Pixdata;

public  import gtkD.gtkc.gdkpixbuftypes;

private import gtkD.gtkc.gdkpixbuf;
private import gtkD.glib.ConstructionException;


private import gtkD.gdk.Pixbuf;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.glib.StringG;
private import gtkD.glib.Str;




/**
 * Description
 * Using GdkPixdata, images can be compiled into an application,
 * making it unnecessary to refer to external image files at runtime.
 * gdk-pixbuf includes a utility named gdk-pixbuf-csource, which
 * can be used to convert image files into GdkPixdata structures suitable
 * for inclusion in C sources. To convert the GdkPixdata structures back
 * into GdkPixbufs, use gdk_pixbuf_from_pixdata.
 */
public class Pixdata
{
	
	/** the main Gtk struct */
	protected GdkPixdata* gdkPixdata;
	
	
	public GdkPixdata* getPixdataStruct()
	{
		return gdkPixdata;
	}
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct()
	{
		return cast(void*)gdkPixdata;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkPixdata* gdkPixdata)
	{
		if(gdkPixdata is null)
		{
			this = null;
			return;
		}
		this.gdkPixdata = gdkPixdata;
	}
	
	/**
	 */
	
	/**
	 * Converts a GdkPixbuf to a GdkPixdata. If use_rle is TRUE, the
	 * pixel data is run-length encoded into newly-allocated memory and a
	 * pointer to that memory is returned.
	 * Params:
	 * pixbuf =  the data to fill pixdata with.
	 * useRle =  whether to use run-length encoding for the pixel data.
	 * Returns: If ure_rle is TRUE, a pointer to the newly-allocated memory  for the run-length encoded pixel data, otherwise NULL.
	 */
	public void* fromPixbuf(Pixbuf pixbuf, int useRle)
	{
		// gpointer gdk_pixdata_from_pixbuf (GdkPixdata *pixdata,  const GdkPixbuf *pixbuf,  gboolean use_rle);
		return gdk_pixdata_from_pixbuf(gdkPixdata, (pixbuf is null) ? null : pixbuf.getPixbufStruct(), useRle);
	}
	
	/**
	 * Converts a GdkPixdata to a GdkPixbuf. If copy_pixels is TRUE or
	 * if the pixel data is run-length-encoded, the pixel data is copied into
	 * newly-allocated memory; otherwise it is reused.
	 * Params:
	 * copyPixels =  whether to copy raw pixel data; run-length encoded
	 *  pixel data is always copied.
	 * Returns: a new GdkPixbuf.
	 * Throws: GException on failure.
	 */
	public Pixbuf gdkPixbufFromPixdata(int copyPixels)
	{
		// GdkPixbuf* gdk_pixbuf_from_pixdata (const GdkPixdata *pixdata,  gboolean copy_pixels,  GError **error);
		GError* err = null;
		
		auto p = gdk_pixbuf_from_pixdata(gdkPixdata, copyPixels, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			return null;
		}
		return new Pixbuf(cast(GdkPixbuf*) p);
	}
	
	/**
	 * Serializes a GdkPixdata structure into a byte stream.
	 * The byte stream consists of a straightforward writeout of the
	 * GdkPixdata fields in network byte order, plus the pixel_data
	 * bytes the structure points to.
	 * Returns: A newly-allocated string containing the serializedGdkPixdata structure.
	 */
	public ubyte[] serialize()
	{
		// guint8* gdk_pixdata_serialize (const GdkPixdata *pixdata,  guint *stream_length_p);
		uint streamLengthP;
		auto p = gdk_pixdata_serialize(gdkPixdata, &streamLengthP);
		return p[0 .. streamLengthP];
	}
	
	/**
	 * Deserializes (reconstruct) a GdkPixdata structure from a byte stream.
	 * The byte stream consists of a straightforward writeout of the
	 * GdkPixdata fields in network byte order, plus the pixel_data
	 * bytes the structure points to.
	 * The pixdata contents are reconstructed byte by byte and are checked
	 * for validity. This function may fail with GDK_PIXBUF_CORRUPT_IMAGE
	 * or GDK_PIXBUF_ERROR_UNKNOWN_TYPE.
	 * Params:
	 * stream =  stream of bytes containing a serialized GdkPixdata structure.
	 * Returns: Upon successful deserialization TRUE is returned,FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int deserialize(ubyte[] stream)
	{
		// gboolean gdk_pixdata_deserialize (GdkPixdata *pixdata,  guint stream_length,  const guint8 *stream,  GError **error);
		GError* err = null;
		
		auto p = gdk_pixdata_deserialize(gdkPixdata, stream.length, stream.ptr, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Generates C source code suitable for compiling images directly
	 * into programs.
	 * GTK+ ships with a program called gdk-pixbuf-csource
	 * which offers a command line interface to this function.
	 * Params:
	 * name =  used for naming generated data structures or macros.
	 * dumpType =  a GdkPixdataDumpType determining the kind of C
	 *  source to be generated.
	 * Returns: a newly-allocated string containing the C source form of pixdata.
	 */
	public StringG toCsource(string name, GdkPixdataDumpType dumpType)
	{
		// GString* gdk_pixdata_to_csource (GdkPixdata *pixdata,  const gchar *name,  GdkPixdataDumpType dump_type);
		auto p = gdk_pixdata_to_csource(gdkPixdata, Str.toStringz(name), dumpType);
		if(p is null)
		{
			return null;
		}
		return new StringG(cast(GString*) p);
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gdkpixbuf");
        } else version (DigitalMars) {
            pragma(link, "DD-gdkpixbuf");
        } else {
            pragma(link, "DO-gdkpixbuf");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gdkpixbuf");
        } else version (DigitalMars) {
            pragma(link, "DD-gdkpixbuf");
        } else {
            pragma(link, "DO-gdkpixbuf");
        }
    }
}
