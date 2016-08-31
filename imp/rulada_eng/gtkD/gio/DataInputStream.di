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
 * inFile  = GDataInputStream.html
 * outPack = gio
 * outFile = DataInputStream
 * strct   = GDataInputStream
 * realStrct=
 * ctorStrct=
 * clss    = DataInputStream
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_data_input_stream_
 * omit structs:
 * omit prefixes:
 * omit code:
 * 	- g_data_input_stream_read_byte
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ErrorG
 * 	- gtkD.glib.GException
 * 	- gtkD.gio.Cancellable
 * 	- gtkD.gio.InputStream
 * structWrap:
 * 	- GCancellable* -> Cancellable
 * 	- GInputStream* -> InputStream
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.DataInputStream;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.Cancellable;
private import gtkD.gio.InputStream;



private import gtkD.gio.BufferedInputStream;

/**
 * Description
 * Data input stream implements GInputStream and includes functions for
 * reading structured data directly from a binary input stream.
 */
public class DataInputStream : BufferedInputStream
{
	
	/** the main Gtk struct */
	protected GDataInputStream* gDataInputStream;
	
	
	public GDataInputStream* getDataInputStreamStruct()
	{
		return gDataInputStream;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gDataInputStream;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GDataInputStream* gDataInputStream)
	{
		if(gDataInputStream is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gDataInputStream);
		if( ptr !is null )
		{
			this = cast(DataInputStream)ptr;
			return;
		}
		super(cast(GBufferedInputStream*)gDataInputStream);
		this.gDataInputStream = gDataInputStream;
	}
	
	/**
	 */
	
	/**
	 * Creates a new data input stream for the base_stream.
	 * Params:
	 * baseStream =  a GInputStream.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (InputStream baseStream)
	{
		// GDataInputStream * g_data_input_stream_new (GInputStream *base_stream);
		auto p = g_data_input_stream_new((baseStream is null) ? null : baseStream.getInputStreamStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by g_data_input_stream_new((baseStream is null) ? null : baseStream.getInputStreamStruct())");
		}
		this(cast(GDataInputStream*) p);
	}
	
	/**
	 * This function sets the byte order for the given stream. All subsequent
	 * reads from the stream will be read in the given order.
	 * Params:
	 * order =  a GDataStreamByteOrder to set.
	 */
	public void setByteOrder(GDataStreamByteOrder order)
	{
		// void g_data_input_stream_set_byte_order (GDataInputStream *stream,  GDataStreamByteOrder order);
		g_data_input_stream_set_byte_order(gDataInputStream, order);
	}
	
	/**
	 * Gets the byte order for the data input stream.
	 * Returns: the stream's current GDataStreamByteOrder.
	 */
	public GDataStreamByteOrder getByteOrder()
	{
		// GDataStreamByteOrder g_data_input_stream_get_byte_order  (GDataInputStream *stream);
		return g_data_input_stream_get_byte_order(gDataInputStream);
	}
	
	/**
	 * Sets the newline type for the stream.
	 * Note that using G_DATA_STREAM_NEWLINE_TYPE_ANY is slightly unsafe. If a read
	 * chunk ends in "CR" we must read an additional byte to know if this is "CR" or
	 * "CR LF", and this might block if there is no more data availible.
	 * Params:
	 * type =  the type of new line return as GDataStreamNewlineType.
	 */
	public void setNewlineType(GDataStreamNewlineType type)
	{
		// void g_data_input_stream_set_newline_type  (GDataInputStream *stream,  GDataStreamNewlineType type);
		g_data_input_stream_set_newline_type(gDataInputStream, type);
	}
	
	/**
	 * Gets the current newline type for the stream.
	 * Returns: GDataStreamNewlineType for the given stream.
	 */
	public GDataStreamNewlineType getNewlineType()
	{
		// GDataStreamNewlineType g_data_input_stream_get_newline_type  (GDataInputStream *stream);
		return g_data_input_stream_get_newline_type(gDataInputStream);
	}
	
	/**
	 * Reads a 16-bit/2-byte value from stream.
	 * In order to get the correct byte order for this read operation,
	 * see g_data_stream_get_byte_order() and g_data_stream_set_byte_order().
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a signed 16-bit/2-byte value read from stream or 0 if an error occurred.
	 * Throws: GException on failure.
	 */
	public short readInt16(Cancellable cancellable)
	{
		// gint16 g_data_input_stream_read_int16 (GDataInputStream *stream,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_data_input_stream_read_int16(gDataInputStream, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Reads an unsigned 16-bit/2-byte value from stream.
	 * In order to get the correct byte order for this read operation,
	 * see g_data_stream_get_byte_order() and g_data_stream_set_byte_order().
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: an unsigned 16-bit/2-byte value read from the stream or 0 if an error occurred.
	 * Throws: GException on failure.
	 */
	public ushort readUint16(Cancellable cancellable)
	{
		// guint16 g_data_input_stream_read_uint16 (GDataInputStream *stream,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_data_input_stream_read_uint16(gDataInputStream, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Reads a signed 32-bit/4-byte value from stream.
	 * In order to get the correct byte order for this read operation,
	 * see g_data_stream_get_byte_order() and g_data_stream_set_byte_order().
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a signed 32-bit/4-byte value read from the stream or 0 if an error occurred.
	 * Throws: GException on failure.
	 */
	public int readInt32(Cancellable cancellable)
	{
		// gint32 g_data_input_stream_read_int32 (GDataInputStream *stream,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_data_input_stream_read_int32(gDataInputStream, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Reads an unsigned 32-bit/4-byte value from stream.
	 * In order to get the correct byte order for this read operation,
	 * see g_data_stream_get_byte_order() and g_data_stream_set_byte_order().
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: an unsigned 32-bit/4-byte value read from the stream or 0 if an error occurred.
	 * Throws: GException on failure.
	 */
	public uint readUint32(Cancellable cancellable)
	{
		// guint32 g_data_input_stream_read_uint32 (GDataInputStream *stream,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_data_input_stream_read_uint32(gDataInputStream, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Reads a 64-bit/8-byte value from stream.
	 * In order to get the correct byte order for this read operation,
	 * see g_data_stream_get_byte_order() and g_data_stream_set_byte_order().
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a signed 64-bit/8-byte value read from stream or 0 if an error occurred.
	 * Throws: GException on failure.
	 */
	public long readInt64(Cancellable cancellable)
	{
		// gint64 g_data_input_stream_read_int64 (GDataInputStream *stream,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_data_input_stream_read_int64(gDataInputStream, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Reads an unsigned 64-bit/8-byte value from stream.
	 * In order to get the correct byte order for this read operation,
	 * see g_data_stream_get_byte_order().
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: an unsigned 64-bit/8-byte read from stream or 0 if an error occurred.
	 * Throws: GException on failure.
	 */
	public ulong readUint64(Cancellable cancellable)
	{
		// guint64 g_data_input_stream_read_uint64 (GDataInputStream *stream,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_data_input_stream_read_uint64(gDataInputStream, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Reads a line from the data input stream.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * length =  a gsize to get the length of the data read in.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a string with the line that was read in (without the newlines). Set length to a gsize to get the length of the read line. On an error, it will return NULL and error will be set. If there's no content to read, it will still return NULL, but error won't be set.
	 * Throws: GException on failure.
	 */
	public string readLine(out uint length, Cancellable cancellable)
	{
		// char * g_data_input_stream_read_line (GDataInputStream *stream,  gsize *length,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = Str.toString(g_data_input_stream_read_line(gDataInputStream, &length, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err));
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * The asynchronous version of g_data_input_stream_read_line(). It is
	 * an error to have two outstanding calls to this function.
	 * When the operation is finished, callback will be called. You
	 * can then call g_data_input_stream_read_line_finish() to get
	 * the result of the operation.
	 * Since 2.20
	 * Params:
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  callback to call when the request is satisfied.
	 * userData =  the data to pass to callback function.
	 */
	public void readLineAsync(int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		// void g_data_input_stream_read_line_async (GDataInputStream *stream,  gint io_priority,  GCancellable *cancellable,  GAsyncReadyCallback callback,  gpointer user_data);
		g_data_input_stream_read_line_async(gDataInputStream, ioPriority, (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}
	
	/**
	 * Finish an asynchronous call started by
	 * g_data_input_stream_read_line_async().
	 * Since 2.20
	 * Params:
	 * result =  the GAsyncResult that was provided to the callback.
	 * length =  a gsize to get the length of the data read in.
	 * Returns: a string with the line that was read in (without the newlines). Set length to a gsize to get the length of the read line. On an error, it will return NULL and error will be set. If there's no content to read, it will still return NULL, but error won't be set.
	 * Throws: GException on failure.
	 */
	public string readLineFinish(out GAsyncResult result, uint* length)
	{
		// char * g_data_input_stream_read_line_finish  (GDataInputStream *stream,  GAsyncResult *result,  gsize *length,  GError **error);
		GError* err = null;
		
		auto p = Str.toString(g_data_input_stream_read_line_finish(gDataInputStream, &result, length, &err));
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Reads a string from the data input stream, up to the first
	 * occurrence of any of the stop characters.
	 * Params:
	 * stopChars =  characters to terminate the read.
	 * length =  a gsize to get the length of the data read in.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a string with the data that was read before encountering any of the stop characters. Set length to a gsize to get the length of the string. This function will return NULL on an error.
	 * Throws: GException on failure.
	 */
	public string readUntil(string stopChars, out uint length, Cancellable cancellable)
	{
		// char * g_data_input_stream_read_until (GDataInputStream *stream,  const gchar *stop_chars,  gsize *length,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = Str.toString(g_data_input_stream_read_until(gDataInputStream, Str.toStringz(stopChars), &length, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err));
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * The asynchronous version of g_data_input_stream_read_until().
	 * It is an error to have two outstanding calls to this function.
	 * When the operation is finished, callback will be called. You
	 * can then call g_data_input_stream_read_until_finish() to get
	 * the result of the operation.
	 * Since 2.20
	 * Params:
	 * stopChars =  characters to terminate the read.
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  callback to call when the request is satisfied.
	 * userData =  the data to pass to callback function.
	 */
	public void readUntilAsync(string stopChars, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		// void g_data_input_stream_read_until_async  (GDataInputStream *stream,  const gchar *stop_chars,  gint io_priority,  GCancellable *cancellable,  GAsyncReadyCallback callback,  gpointer user_data);
		g_data_input_stream_read_until_async(gDataInputStream, Str.toStringz(stopChars), ioPriority, (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}
	
	/**
	 * Finish an asynchronous call started by
	 * g_data_input_stream_read_until_async().
	 * Since 2.20
	 * Params:
	 * result =  the GAsyncResult that was provided to the callback.
	 * length =  a gsize to get the length of the data read in.
	 * Returns: a string with the data that was read before encountering any of the stop characters. Set length to a gsize to get the length of the string. This function will return NULL on an error.
	 * Throws: GException on failure.
	 */
	public string readUntilFinish(out GAsyncResult result, uint* length)
	{
		// char * g_data_input_stream_read_until_finish  (GDataInputStream *stream,  GAsyncResult *result,  gsize *length,  GError **error);
		GError* err = null;
		
		auto p = Str.toString(g_data_input_stream_read_until_finish(gDataInputStream, &result, length, &err));
		
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
