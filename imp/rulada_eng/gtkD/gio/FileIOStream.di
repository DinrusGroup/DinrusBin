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
 * inFile  = GFileIOStream.html
 * outPack = gio
 * outFile = FileIOStream
 * strct   = GFileIOStream
 * realStrct=
 * ctorStrct=
 * clss    = FileIOStream
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * 	- SeekableIF
 * prefixes:
 * 	- g_file_io_stream_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ErrorG
 * 	- gtkD.glib.GException
 * 	- gtkD.gio.AsyncResultIF
 * 	- gtkD.gio.Cancellable
 * 	- gtkD.gio.FileInfo
 * 	- gtkD.gio.SeekableT
 * 	- gtkD.gio.SeekableIF
 * structWrap:
 * 	- GAsyncResult* -> AsyncResultIF
 * 	- GCancellable* -> Cancellable
 * 	- GFileInfo* -> FileInfo
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.FileIOStream;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.AsyncResultIF;
private import gtkD.gio.Cancellable;
private import gtkD.gio.FileInfo;
private import gtkD.gio.SeekableT;
private import gtkD.gio.SeekableIF;



private import gtkD.gio.IOStream;

/**
 * Description
 * GFileIOStream provides io streams that both read and write to the same
 * file handle.
 * GFileIOStream implements GSeekable, which allows the io
 * stream to jump to arbitrary positions in the file and to truncate
 * the file, provided the filesystem of the file supports these
 * operations.
 * To find the position of a file io stream, use
 * g_seekable_tell().
 * To find out if a file io stream supports seeking, use g_seekable_can_seek().
 * To position a file io stream, use g_seekable_seek().
 * To find out if a file io stream supports truncating, use
 * g_seekable_can_truncate(). To truncate a file io
 * stream, use g_seekable_truncate().
 * The default implementation of all the GFileIOStream operations
 * and the implementation of GSeekable just call into the same operations
 * on the output stream.
 */
public class FileIOStream : IOStream, SeekableIF
{
	
	/** the main Gtk struct */
	protected GFileIOStream* gFileIOStream;
	
	
	public GFileIOStream* getFileIOStreamStruct()
	{
		return gFileIOStream;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gFileIOStream;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GFileIOStream* gFileIOStream)
	{
		if(gFileIOStream is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gFileIOStream);
		if( ptr !is null )
		{
			this = cast(FileIOStream)ptr;
			return;
		}
		super(cast(GIOStream*)gFileIOStream);
		this.gFileIOStream = gFileIOStream;
	}
	
	// add the Seekable capabilities
	mixin SeekableT!(GFileIOStream);
	
	/**
	 */
	
	/**
	 * Gets the entity tag for the file when it has been written.
	 * This must be called after the stream has been written
	 * and closed, as the etag can change while writing.
	 * Since 2.22
	 * Returns: the entity tag for the stream.
	 */
	public string getEtag()
	{
		// char * g_file_io_stream_get_etag (GFileIOStream *stream);
		return Str.toString(g_file_io_stream_get_etag(gFileIOStream));
	}
	
	/**
	 * Queries a file io stream for the given attributes.
	 * This function blocks while querying the stream. For the asynchronous
	 * version of this function, see g_file_io_stream_query_info_async().
	 * While the stream is blocked, the stream will set the pending flag
	 * internally, and any other operations on the stream will fail with
	 * G_IO_ERROR_PENDING.
	 * Can fail if the stream was already closed (with error being set to
	 * G_IO_ERROR_CLOSED), the stream has pending operations (with error being
	 * set to G_IO_ERROR_PENDING), or if querying info is not supported for
	 * the stream's interface (with error being set to G_IO_ERROR_NOT_SUPPORTED). I
	 * all cases of failure, NULL will be returned.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be set, and NULL will
	 * be returned.
	 * Since 2.22
	 * Params:
	 * attributes =  a file attribute query string.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GFileInfo for the stream, or NULL on error.
	 * Throws: GException on failure.
	 */
	public FileInfo queryInfo(string attributes, Cancellable cancellable)
	{
		// GFileInfo * g_file_io_stream_query_info (GFileIOStream *stream,  const char *attributes,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_file_io_stream_query_info(gFileIOStream, Str.toStringz(attributes), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			return null;
		}
		return new FileInfo(cast(GFileInfo*) p);
	}
	
	/**
	 * Asynchronously queries the stream for a GFileInfo. When completed,
	 * callback will be called with a GAsyncResult which can be used to
	 * finish the operation with g_file_io_stream_query_info_finish().
	 * For the synchronous version of this function, see
	 * g_file_io_stream_query_info().
	 * Since 2.22
	 * Params:
	 * attributes =  a file attribute query string.
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  callback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void queryInfoAsync(string attributes, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		// void g_file_io_stream_query_info_async (GFileIOStream *stream,  const char *attributes,  int io_priority,  GCancellable *cancellable,  GAsyncReadyCallback callback,  gpointer user_data);
		g_file_io_stream_query_info_async(gFileIOStream, Str.toStringz(attributes), ioPriority, (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}
	
	/**
	 * Finalizes the asynchronous query started
	 * by g_file_io_stream_query_info_async().
	 * Since 2.22
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: A GFileInfo for the finished query.
	 * Throws: GException on failure.
	 */
	public FileInfo queryInfoFinish(AsyncResultIF result)
	{
		// GFileInfo * g_file_io_stream_query_info_finish (GFileIOStream *stream,  GAsyncResult *result,  GError **error);
		GError* err = null;
		
		auto p = g_file_io_stream_query_info_finish(gFileIOStream, (result is null) ? null : result.getAsyncResultTStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			return null;
		}
		return new FileInfo(cast(GFileInfo*) p);
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
