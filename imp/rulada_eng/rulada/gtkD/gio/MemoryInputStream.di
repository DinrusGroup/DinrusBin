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
 * inFile  = GMemoryInputStream.html
 * outPack = gio
 * outFile = MemoryInputStream
 * strct   = GMemoryInputStream
 * realStrct=
 * ctorStrct=GInputStream
 * clss    = MemoryInputStream
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * 	- SeekableIF
 * prefixes:
 * 	- g_memory_input_stream_
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

module gtkD.gio.MemoryInputStream;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gio.SeekableT;
private import gtkD.gio.SeekableIF;



private import gtkD.gio.InputStream;

/**
 * Description
 * GMemoryInputStream is a class for using arbitrary
 * memory chunks as input for GIO streaming input operations.
 */
public class MemoryInputStream : InputStream, SeekableIF
{
	
	/** the main Gtk struct */
	protected GMemoryInputStream* gMemoryInputStream;
	
	
	public GMemoryInputStream* getMemoryInputStreamStruct()
	{
		return gMemoryInputStream;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gMemoryInputStream;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GMemoryInputStream* gMemoryInputStream)
	{
		if(gMemoryInputStream is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gMemoryInputStream);
		if( ptr !is null )
		{
			this = cast(MemoryInputStream)ptr;
			return;
		}
		super(cast(GInputStream*)gMemoryInputStream);
		this.gMemoryInputStream = gMemoryInputStream;
	}
	
	// add the Seekable capabilities
	mixin SeekableT!(GMemoryInputStream);
	
	/**
	 */
	
	/**
	 * Creates a new empty GMemoryInputStream.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GInputStream * g_memory_input_stream_new (void);
		auto p = g_memory_input_stream_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by g_memory_input_stream_new()");
		}
		this(cast(GMemoryInputStream*) p);
	}
	
	/**
	 * Creates a new GMemoryInputStream with data in memory of a given size.
	 * Params:
	 * data =  input data
	 * len =  length of the data, may be -1 if data is a nul-terminated string
	 * destroy =  function that is called to free data, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (void* data, int len, GDestroyNotify destroy)
	{
		// GInputStream * g_memory_input_stream_new_from_data (const void *data,  gssize len,  GDestroyNotify destroy);
		auto p = g_memory_input_stream_new_from_data(data, len, destroy);
		if(p is null)
		{
			throw new ConstructionException("null returned by g_memory_input_stream_new_from_data(data, len, destroy)");
		}
		this(cast(GMemoryInputStream*) p);
	}
	
	/**
	 * Appends data to data that can be read from the input stream
	 * Params:
	 * data =  input data
	 * len =  length of the data, may be -1 if data is a nul-terminated string
	 * destroy =  function that is called to free data, or NULL
	 */
	public void addData(void* data, int len, GDestroyNotify destroy)
	{
		// void g_memory_input_stream_add_data (GMemoryInputStream *stream,  const void *data,  gssize len,  GDestroyNotify destroy);
		g_memory_input_stream_add_data(gMemoryInputStream, data, len, destroy);
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
