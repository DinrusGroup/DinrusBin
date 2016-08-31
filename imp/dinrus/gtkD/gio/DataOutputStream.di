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
 * inFile  = GDataOutputStream.html
 * outPack = gio
 * outFile = DataOutputStream
 * strct   = GDataOutputStream
 * realStrct=
 * ctorStrct=
 * clss    = DataOutputStream
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_data_output_stream_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ErrorG
 * 	- gtkD.glib.GException
 * 	- gtkD.gio.Cancellable
 * 	- gtkD.gio.OutputStream
 * structWrap:
 * 	- GCancellable* -> Cancellable
 * 	- GOutputStream* -> OutputStream
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.DataOutputStream;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.Cancellable;
private import gtkD.gio.OutputStream;



private import gtkD.gio.FilterOutputStream;

/**
 * Description
 * Data output stream implements GOutputStream and includes functions for
 * writing data directly to an output stream.
 */
public class DataOutputStream : FilterOutputStream
{
	
	/** the main Gtk struct */
	protected GDataOutputStream* gDataOutputStream;
	
	
	public GDataOutputStream* getDataOutputStreamStruct()
	{
		return gDataOutputStream;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gDataOutputStream;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GDataOutputStream* gDataOutputStream)
	{
		if(gDataOutputStream is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gDataOutputStream);
		if( ptr !is null )
		{
			this = cast(DataOutputStream)ptr;
			return;
		}
		super(cast(GFilterOutputStream*)gDataOutputStream);
		this.gDataOutputStream = gDataOutputStream;
	}
	
	/**
	 */
	
	/**
	 * Creates a new data output stream for base_stream.
	 * Params:
	 * baseStream =  a GOutputStream.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (OutputStream baseStream)
	{
		// GDataOutputStream * g_data_output_stream_new (GOutputStream *base_stream);
		auto p = g_data_output_stream_new((baseStream is null) ? null : baseStream.getOutputStreamStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by g_data_output_stream_new((baseStream is null) ? null : baseStream.getOutputStreamStruct())");
		}
		this(cast(GDataOutputStream*) p);
	}
	
	/**
	 * Sets the byte order of the data output stream to order.
	 * Params:
	 * order =  a GDataStreamByteOrder.
	 */
	public void setByteOrder(GDataStreamByteOrder order)
	{
		// void g_data_output_stream_set_byte_order (GDataOutputStream *stream,  GDataStreamByteOrder order);
		g_data_output_stream_set_byte_order(gDataOutputStream, order);
	}
	
	/**
	 * Gets the byte order for the stream.
	 * Returns: the GDataStreamByteOrder for the stream.
	 */
	public GDataStreamByteOrder getByteOrder()
	{
		// GDataStreamByteOrder g_data_output_stream_get_byte_order  (GDataOutputStream *stream);
		return g_data_output_stream_get_byte_order(gDataOutputStream);
	}
	
	/**
	 * Puts a byte into the output stream.
	 * Params:
	 * data =  a guchar.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if data was successfully added to the stream.
	 * Throws: GException on failure.
	 */
	public int putByte(char data, Cancellable cancellable)
	{
		// gboolean g_data_output_stream_put_byte (GDataOutputStream *stream,  guchar data,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_data_output_stream_put_byte(gDataOutputStream, data, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Puts a signed 16-bit integer into the output stream.
	 * Params:
	 * data =  a gint16.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if data was successfully added to the stream.
	 * Throws: GException on failure.
	 */
	public int putInt16(short data, Cancellable cancellable)
	{
		// gboolean g_data_output_stream_put_int16 (GDataOutputStream *stream,  gint16 data,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_data_output_stream_put_int16(gDataOutputStream, data, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Puts an unsigned 16-bit integer into the output stream.
	 * Params:
	 * data =  a guint16.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if data was successfully added to the stream.
	 * Throws: GException on failure.
	 */
	public int putUint16(ushort data, Cancellable cancellable)
	{
		// gboolean g_data_output_stream_put_uint16 (GDataOutputStream *stream,  guint16 data,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_data_output_stream_put_uint16(gDataOutputStream, data, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Puts a signed 32-bit integer into the output stream.
	 * Params:
	 * data =  a gint32.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if data was successfully added to the stream.
	 * Throws: GException on failure.
	 */
	public int putInt32(int data, Cancellable cancellable)
	{
		// gboolean g_data_output_stream_put_int32 (GDataOutputStream *stream,  gint32 data,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_data_output_stream_put_int32(gDataOutputStream, data, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Puts an unsigned 32-bit integer into the stream.
	 * Params:
	 * data =  a guint32.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if data was successfully added to the stream.
	 * Throws: GException on failure.
	 */
	public int putUint32(uint data, Cancellable cancellable)
	{
		// gboolean g_data_output_stream_put_uint32 (GDataOutputStream *stream,  guint32 data,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_data_output_stream_put_uint32(gDataOutputStream, data, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Puts a signed 64-bit integer into the stream.
	 * Params:
	 * data =  a gint64.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if data was successfully added to the stream.
	 * Throws: GException on failure.
	 */
	public int putInt64(long data, Cancellable cancellable)
	{
		// gboolean g_data_output_stream_put_int64 (GDataOutputStream *stream,  gint64 data,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_data_output_stream_put_int64(gDataOutputStream, data, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Puts an unsigned 64-bit integer into the stream.
	 * Params:
	 * data =  a guint64.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if data was successfully added to the stream.
	 * Throws: GException on failure.
	 */
	public int putUint64(ulong data, Cancellable cancellable)
	{
		// gboolean g_data_output_stream_put_uint64 (GDataOutputStream *stream,  guint64 data,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_data_output_stream_put_uint64(gDataOutputStream, data, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Puts a string into the output stream.
	 * Params:
	 * str =  a string.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if string was successfully added to the stream.
	 * Throws: GException on failure.
	 */
	public int putString(string str, Cancellable cancellable)
	{
		// gboolean g_data_output_stream_put_string (GDataOutputStream *stream,  const char *str,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_data_output_stream_put_string(gDataOutputStream, Str.toStringz(str), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
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
