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
 * inFile  = GFileInputStream.html
 * outPack = gio
 * outFile = FileInputStream
 * strct   = GFileInputStream
 * realStrct=
 * ctorStrct=
 * clss    = FileInputStream
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * 	- SeekableIF
 * prefixes:
 * 	- g_file_input_stream_
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

module gtkD.gio.FileInputStream;

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



private import gtkD.gio.InputStream;

/**
 * Description
 * GFileInputStream provides input streams that take their
 * content from a file.
 * GFileInputStream implements GSeekable, which allows the input
 * stream to jump to arbitrary positions in the file, provided the
 * filesystem of the file allows it. To find the position of a file
 * input stream, use g_seekable_tell(). To find out if a file input
 * stream supports seeking, use g_seekable_stream_can_seek().
 * To position a file input stream, use g_seekable_seek().
 */
public class FileInputStream : InputStream, SeekableIF
{
	
	/** the main Gtk struct */
	protected GFileInputStream* gFileInputStream;
	
	
	public GFileInputStream* getFileInputStreamStruct()
	{
		return gFileInputStream;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gFileInputStream;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GFileInputStream* gFileInputStream)
	{
		if(gFileInputStream is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gFileInputStream);
		if( ptr !is null )
		{
			this = cast(FileInputStream)ptr;
			return;
		}
		super(cast(GInputStream*)gFileInputStream);
		this.gFileInputStream = gFileInputStream;
	}
	
	// add the Seekable capabilities
	mixin SeekableT!(GFileInputStream);
	
	/**
	 */
	
	/**
	 * Queries a file input stream the given attributes. This function blocks
	 * while querying the stream. For the asynchronous (non-blocking) version
	 * of this function, see g_file_input_stream_query_info_async(). While the
	 * stream is blocked, the stream will set the pending flag internally, and
	 * any other operations on the stream will fail with G_IO_ERROR_PENDING.
	 * Params:
	 * attributes =  a file attribute query string.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GFileInfo, or NULL on error.
	 * Throws: GException on failure.
	 */
	public FileInfo queryInfo(string attributes, Cancellable cancellable)
	{
		// GFileInfo * g_file_input_stream_query_info (GFileInputStream *stream,  const char *attributes,  GCancellable *cancellable,  GError **error);
		GError* err = null;
		
		auto p = g_file_input_stream_query_info(gFileInputStream, Str.toStringz(attributes), (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
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
	 * Queries the stream information asynchronously.
	 * When the operation is finished callback will be called.
	 * You can then call g_file_input_stream_query_info_finish()
	 * to get the result of the operation.
	 * For the synchronous version of this function,
	 * see g_file_input_stream_query_info().
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be set
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
		// void g_file_input_stream_query_info_async  (GFileInputStream *stream,  const char *attributes,  int io_priority,  GCancellable *cancellable,  GAsyncReadyCallback callback,  gpointer user_data);
		g_file_input_stream_query_info_async(gFileInputStream, Str.toStringz(attributes), ioPriority, (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}
	
	/**
	 * Finishes an asynchronous info query operation.
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: GFileInfo.
	 * Throws: GException on failure.
	 */
	public FileInfo queryInfoFinish(AsyncResultIF result)
	{
		// GFileInfo * g_file_input_stream_query_info_finish  (GFileInputStream *stream,  GAsyncResult *result,  GError **error);
		GError* err = null;
		
		auto p = g_file_input_stream_query_info_finish(gFileInputStream, (result is null) ? null : result.getAsyncResultTStruct(), &err);
		
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
