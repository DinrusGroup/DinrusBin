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
 * inFile  = GInputStream.html
 * outPack = gio
 * outFile = InputStream
 * strct   = GInputStream
 * realStrct=
 * ctorStrct=
 * clss    = InputStream
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_input_stream_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.ErrorG
 * 	- gtkD.glib.GException
 * 	- gtkD.gio.AsyncResultIF
 * 	- gtkD.gio.Cancellable
 * structWrap:
 * 	- GAsyncResult* -> AsyncResultIF
 * 	- GCancellable* -> Cancellable
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.InputStream;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.AsyncResultIF;
private import gtkD.gio.Cancellable;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GInputStream has functions to read from a stream (g_input_stream_read()),
 * to close a stream (g_input_stream_close()) and to skip some content
 * (g_input_stream_skip()).
 * To copy the content of an input stream to an output stream without
 * manually handling the reads and writes, use g_output_stream_splice().
 * All of these functions have async variants too.
 */
public class InputStream : ObjectG
{
	
	/** the main Gtk struct */
	protected GInputStream* gInputStream;
	
	
	public GInputStream* getInputStreamStruct()
	{
		return gInputStream;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gInputStream;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GInputStream* gInputStream)
	{
		if(gInputStream is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gInputStream);
		if( ptr !is null )
		{
			this = cast(InputStream)ptr;
			return;
		}
		super(cast(GObject*)gInputStream);
		this.gInputStream = gInputStream;
	}
	
	/**
	 */
	
	/**
	 * Tries to read count bytes from the stream into the buffer starting at
	 * buffer. Will block during this read.
	 * If count is zero returns zero and does nothing. A value of count
	 * larger than G_MAXSSIZE will cause a G_IO_ERROR_INVALID_ARGUMENT error.
	 * On success, the number of bytes read into the buffer is returned.
	 * It is not an error if this is not the same as the requested size, as it
	 * can happen e.g. near the end of a file. Zero is returned on end of file
	 * (or if count is zero), but never otherwise.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned. If an
	 * operation was partially finished when the operation was cancelled the
	 * partial result will be returned, without an error.
	 * On error -1 is returned and error is set accordingly.
	 * Params:
	 * buffer =  a buffer to read data into (which should be at least count bytes long).
	 * count =  the number of bytes that will be read from the stream
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: Number of bytes read, or -1 on error
	 * Throws: GException on failure.
	 */
	public int read(void* buffer, uint count, Cancellable cancellable)
	{
		// gssize g_input_stream_read (GInputStream *stream,  void *buffer,  gsize count,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_input_stream_read(gInputStream, buffer, count, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Tries to read count bytes from the stream into the buffer starting at
	 * buffer. Will block during this read.
	 * This function is similar to g_input_stream_read(), except it tries to
	 * read as many bytes as requested, only stopping on an error or end of stream.
	 * On a successful read of count bytes, or if we reached the end of the
	 * stream, TRUE is returned, and bytes_read is set to the number of bytes
	 * read into buffer.
	 * If there is an error during the operation FALSE is returned and error
	 * is set to indicate the error status, bytes_read is updated to contain
	 * the number of bytes read into buffer before the error occurred.
	 * Params:
	 * buffer =  a buffer to read data into (which should be at least count bytes long).
	 * count =  the number of bytes that will be read from the stream
	 * bytesRead =  location to store the number of bytes that was read from the stream
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE on success, FALSE if there was an error
	 * Throws: GException on failure.
	 */
	public int readAll(void* buffer, uint count, out uint bytesRead, Cancellable cancellable)
	{
		// gboolean g_input_stream_read_all (GInputStream *stream,  void *buffer,  gsize count,  gsize *bytes_read,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_input_stream_read_all(gInputStream, buffer, count, &bytesRead, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Tries to skip count bytes from the stream. Will block during the operation.
	 * This is identical to g_input_stream_read(), from a behaviour standpoint,
	 * but the bytes that are skipped are not returned to the user. Some
	 * streams have an implementation that is more efficient than reading the data.
	 * This function is optional for inherited classes, as the default implementation
	 * emulates it using read.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned. If an
	 * operation was partially finished when the operation was cancelled the
	 * partial result will be returned, without an error.
	 * Params:
	 * count =  the number of bytes that will be skipped from the stream
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: Number of bytes skipped, or -1 on error
	 * Throws: GException on failure.
	 */
	public int skip(uint count, Cancellable cancellable)
	{
		// gssize g_input_stream_skip (GInputStream *stream,  gsize count,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_input_stream_skip(gInputStream, count, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Closes the stream, releasing resources related to it.
	 * Once the stream is closed, all other operations will return G_IO_ERROR_CLOSED.
	 * Closing a stream multiple times will not return an error.
	 * Streams will be automatically closed when the last reference
	 * is dropped, but you might want to call this function to make sure
	 * resources are released as early as possible.
	 * Some streams might keep the backing store of the stream (e.g. a file descriptor)
	 * open after the stream is closed. See the documentation for the individual
	 * stream for details.
	 * On failure the first error that happened will be reported, but the close
	 * operation will finish as much as possible. A stream that failed to
	 * close will still return G_IO_ERROR_CLOSED for all operations. Still, it
	 * is important to check and report the error to the user.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Cancelling a close will still leave the stream closed, but some streams
	 * can use a faster close that doesn't block to e.g. check errors.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE on success, FALSE on failure
	 * Throws: GException on failure.
	 */
	public int close(Cancellable cancellable)
	{
		// gboolean g_input_stream_close (GInputStream *stream,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_input_stream_close(gInputStream, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Request an asynchronous read of count bytes from the stream into the buffer
	 * starting at buffer. When the operation is finished callback will be called.
	 * You can then call g_input_stream_read_finish() to get the result of the
	 * operation.
	 * During an async request no other sync and async calls are allowed on stream, and will
	 * result in G_IO_ERROR_PENDING errors.
	 * A value of count larger than G_MAXSSIZE will cause a G_IO_ERROR_INVALID_ARGUMENT error.
	 * On success, the number of bytes read into the buffer will be passed to the
	 * callback. It is not an error if this is not the same as the requested size, as it
	 * can happen e.g. near the end of a file, but generally we try to read
	 * as many bytes as requested. Zero is returned on end of file
	 * (or if count is zero), but never otherwise.
	 * Any outstanding i/o request with higher priority (lower numerical value) will
	 * be executed before an outstanding request with lower priority. Default
	 * priority is G_PRIORITY_DEFAULT.
	 * The asyncronous methods have a default fallback that uses threads to implement
	 * asynchronicity, so they are optional for inheriting classes. However, if you
	 * override one you must override all.
	 * Params:
	 * buffer =  a buffer to read data into (which should be at least count bytes long).
	 * count =  the number of bytes that will be read from the stream
	 * ioPriority =  the I/O priority
	 * of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  callback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void readAsync(void* buffer, uint count, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		// void g_input_stream_read_async (GInputStream *stream,  void *buffer,  gsize count,  int io_priority,  GCancellable *cancellable,  GAsyncReadyCallback callback,  gpointer user_data);
		g_input_stream_read_async(gInputStream, buffer, count, ioPriority, (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}
	
	/**
	 * Finishes an asynchronous stream read operation.
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: number of bytes read in, or -1 on error.
	 * Throws: GException on failure.
	 */
	public int readFinish(AsyncResultIF result)
	{
		// gssize g_input_stream_read_finish (GInputStream *stream,  GAsyncResult *result,  GError **error);
		GError* err = null;
		
		auto p = g_input_stream_read_finish(gInputStream, (result is null) ? null : result.getAsyncResultTStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Request an asynchronous skip of count bytes from the stream.
	 * When the operation is finished callback will be called.
	 * You can then call g_input_stream_skip_finish() to get the result of the
	 * operation.
	 * During an async request no other sync and async calls are allowed, and will
	 * result in G_IO_ERROR_PENDING errors.
	 * A value of count larger than G_MAXSSIZE will cause a G_IO_ERROR_INVALID_ARGUMENT error.
	 * On success, the number of bytes skipped will be passed to the
	 * callback. It is not an error if this is not the same as the requested size, as it
	 * can happen e.g. near the end of a file, but generally we try to skip
	 * as many bytes as requested. Zero is returned on end of file
	 * (or if count is zero), but never otherwise.
	 * Any outstanding i/o request with higher priority (lower numerical value) will
	 * be executed before an outstanding request with lower priority. Default
	 * priority is G_PRIORITY_DEFAULT.
	 * The asyncronous methods have a default fallback that uses threads to implement
	 * asynchronicity, so they are optional for inheriting classes. However, if you
	 * override one you must override all.
	 * Params:
	 * count =  the number of bytes that will be skipped from the stream
	 * ioPriority =  the I/O priority
	 * of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  callback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void skipAsync(uint count, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		// void g_input_stream_skip_async (GInputStream *stream,  gsize count,  int io_priority,  GCancellable *cancellable,  GAsyncReadyCallback callback,  gpointer user_data);
		g_input_stream_skip_async(gInputStream, count, ioPriority, (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}
	
	/**
	 * Finishes a stream skip operation.
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: the size of the bytes skipped, or -1 on error.
	 * Throws: GException on failure.
	 */
	public int skipFinish(AsyncResultIF result)
	{
		// gssize g_input_stream_skip_finish (GInputStream *stream,  GAsyncResult *result,  GError **error);
		GError* err = null;
		
		auto p = g_input_stream_skip_finish(gInputStream, (result is null) ? null : result.getAsyncResultTStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Requests an asynchronous closes of the stream, releasing resources related to it.
	 * When the operation is finished callback will be called.
	 * You can then call g_input_stream_close_finish() to get the result of the
	 * operation.
	 * For behaviour details see g_input_stream_close().
	 * The asyncronous methods have a default fallback that uses threads to implement
	 * asynchronicity, so they are optional for inheriting classes. However, if you
	 * override one you must override all.
	 * Params:
	 * ioPriority =  the I/O priority
	 * of the request.
	 * cancellable =  optional cancellable object
	 * callback =  callback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void closeAsync(int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		// void g_input_stream_close_async (GInputStream *stream,  int io_priority,  GCancellable *cancellable,  GAsyncReadyCallback callback,  gpointer user_data);
		g_input_stream_close_async(gInputStream, ioPriority, (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}
	
	/**
	 * Finishes closing a stream asynchronously, started from g_input_stream_close_async().
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if the stream was closed successfully.
	 * Throws: GException on failure.
	 */
	public int closeFinish(AsyncResultIF result)
	{
		// gboolean g_input_stream_close_finish (GInputStream *stream,  GAsyncResult *result,  GError **error);
		GError* err = null;
		
		auto p = g_input_stream_close_finish(gInputStream, (result is null) ? null : result.getAsyncResultTStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Checks if an input stream is closed.
	 * Returns: TRUE if the stream is closed.
	 */
	public int isClosed()
	{
		// gboolean g_input_stream_is_closed (GInputStream *stream);
		return g_input_stream_is_closed(gInputStream);
	}
	
	/**
	 * Checks if an input stream has pending actions.
	 * Returns: TRUE if stream has pending actions.
	 */
	public int hasPending()
	{
		// gboolean g_input_stream_has_pending (GInputStream *stream);
		return g_input_stream_has_pending(gInputStream);
	}
	
	/**
	 * Sets stream to have actions pending. If the pending flag is
	 * already set or stream is closed, it will return FALSE and set
	 * error.
	 * Returns: TRUE if pending was previously unset and is now set.
	 * Throws: GException on failure.
	 */
	public int setPending()
	{
		// gboolean g_input_stream_set_pending (GInputStream *stream,  GError **error);
		GError* err = null;
		
		auto p = g_input_stream_set_pending(gInputStream, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		return p;
	}
	
	/**
	 * Clears the pending flag on stream.
	 */
	public void clearPending()
	{
		// void g_input_stream_clear_pending (GInputStream *stream);
		g_input_stream_clear_pending(gInputStream);
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
