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
 * inFile  = GMemoryOutputStream.html
 * outPack = gio
 * outFile = MemoryOutputStream
 * strct   = GMemoryOutputStream
 * realStrct=
 * ctorStrct=GOutputStream
 * clss    = MemoryOutputStream
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * 	- SeekableIF
 * prefixes:
 * 	- g_memory_output_stream_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.gio.SeekableT
 * 	- gtkD.gio.SeekableIF
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.MemoryOutputStream;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gio.SeekableT;
private import gtkD.gio.SeekableIF;



private import gtkD.gio.OutputStream;

/**
 * Description
 * GMemoryOutputStream is a class for using arbitrary
 * memory chunks as output for GIO streaming output operations.
 */
public class MemoryOutputStream : OutputStream, SeekableIF
{
	
	/** the main Gtk struct */
	protected GMemoryOutputStream* gMemoryOutputStream;
	
	
	public GMemoryOutputStream* getMemoryOutputStreamStruct()
	{
		return gMemoryOutputStream;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gMemoryOutputStream;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GMemoryOutputStream* gMemoryOutputStream)
	{
		if(gMemoryOutputStream is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gMemoryOutputStream);
		if( ptr !is null )
		{
			this = cast(MemoryOutputStream)ptr;
			return;
		}
		super(cast(GOutputStream*)gMemoryOutputStream);
		this.gMemoryOutputStream = gMemoryOutputStream;
	}
	
	// add the Seekable capabilities
	mixin SeekableT!(GMemoryOutputStream);
	
	/**
	 */
	
	/**
	 * Creates a new GMemoryOutputStream.
	 * If data is non-NULL, the stream will use that for its internal storage.
	 * If realloc_fn is non-NULL, it will be used for resizing the internal
	 * storage when necessary. To construct a fixed-size output stream,
	 * pass NULL as realloc_fn.
	 * /+* a stream that can grow +/
	 * stream = g_memory_output_stream_new (NULL, 0, realloc, free);
	 * /+* a fixed-size stream +/
	 * data = malloc (200);
	 * stream2 = g_memory_output_stream_new (data, 200, NULL, free);
	 * Params:
	 * data =  pointer to a chunk of memory to use, or NULL
	 * len =  the size of data
	 * reallocFn =  a function with realloc() semantics to be called when
	 *  data needs to be grown, or NULL
	 * destroy =  a function to be called on data when the stream is finalized,
	 *  or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (void* data, uint len, GReallocFunc reallocFn, GDestroyNotify destroy)
	{
		// GOutputStream * g_memory_output_stream_new (gpointer data,  gsize len,  GReallocFunc realloc_fn,  GDestroyNotify destroy);
		auto p = g_memory_output_stream_new(data, len, reallocFn, destroy);
		if(p is null)
		{
			throw new ConstructionException("null returned by g_memory_output_stream_new(data, len, reallocFn, destroy)");
		}
		this(cast(GMemoryOutputStream*) p);
	}
	
	/**
	 * Gets any loaded data from the ostream.
	 * Note that the returned pointer may become invalid on the next
	 * write or truncate operation on the stream.
	 * Returns: pointer to the stream's data
	 */
	public void* getData()
	{
		// gpointer g_memory_output_stream_get_data (GMemoryOutputStream *ostream);
		return g_memory_output_stream_get_data(gMemoryOutputStream);
	}
	
	/**
	 * Gets the size of the currently allocated data area (availible from
	 * g_memory_output_stream_get_data()). If the stream isn't
	 * growable (no realloc was passed to g_memory_output_stream_new()) then
	 * this is the maximum size of the stream and further writes
	 * will return G_IO_ERROR_NO_SPACE.
	 * Note that for growable streams the returned size may become invalid on
	 * the next write or truncate operation on the stream.
	 * If you want the number of bytes currently written to the stream, use
	 * g_memory_output_stream_get_data_size().
	 * Returns: the number of bytes allocated for the data buffer
	 */
	public uint getSize()
	{
		// gsize g_memory_output_stream_get_size (GMemoryOutputStream *ostream);
		return g_memory_output_stream_get_size(gMemoryOutputStream);
	}
	
	/**
	 * Returns the number of bytes from the start up
	 * to including the last byte written in the stream
	 * that has not been truncated away.
	 * Since 2.18
	 * Returns: the number of bytes written to the stream
	 */
	public uint getDataSize()
	{
		// gsize g_memory_output_stream_get_data_size  (GMemoryOutputStream *ostream);
		return g_memory_output_stream_get_data_size(gMemoryOutputStream);
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
