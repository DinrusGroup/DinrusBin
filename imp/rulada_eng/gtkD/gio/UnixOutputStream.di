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
 * inFile  = GUnixOutputStream.html
 * outPack = gio
 * outFile = UnixOutputStream
 * strct   = GUnixOutputStream
 * realStrct=
 * ctorStrct=GOutputStream
 * clss    = UnixOutputStream
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_unix_output_stream_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.UnixOutputStream;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;





private import gtkD.gio.OutputStream;

/**
 * Description
 * GUnixOutputStream implements GOutputStream for writing to a
 * unix file descriptor, including asynchronous operations. The file
 * descriptor must be selectable, so it doesn't work with opened files.
 * Note that <gio/gunixoutputstream.h> belongs
 * to the UNIX-specific GIO interfaces, thus you have to use the
 * gio-unix-2.0.pc pkg-config file when using it.
 */
public class UnixOutputStream : OutputStream
{
	
	/** the main Gtk struct */
	protected GUnixOutputStream* gUnixOutputStream;
	
	
	public GUnixOutputStream* getUnixOutputStreamStruct()
	{
		return gUnixOutputStream;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gUnixOutputStream;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GUnixOutputStream* gUnixOutputStream)
	{
		if(gUnixOutputStream is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gUnixOutputStream);
		if( ptr !is null )
		{
			this = cast(UnixOutputStream)ptr;
			return;
		}
		super(cast(GOutputStream*)gUnixOutputStream);
		this.gUnixOutputStream = gUnixOutputStream;
	}
	
	/**
	 */
	
	/**
	 * Creates a new GUnixOutputStream for the given fd.
	 * If close_fd, is TRUE, the file descriptor will be closed when
	 * the output stream is destroyed.
	 * Params:
	 * fd =  a UNIX file descriptor
	 * closeFd =  TRUE to close the file descriptor when done
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (int fd, int closeFd)
	{
		// GOutputStream * g_unix_output_stream_new (gint fd,  gboolean close_fd);
		auto p = g_unix_output_stream_new(fd, closeFd);
		if(p is null)
		{
			throw new ConstructionException("null returned by g_unix_output_stream_new(fd, closeFd)");
		}
		this(cast(GUnixOutputStream*) p);
	}
	
	/**
	 * Sets whether the file descriptor of stream shall be closed
	 * when the stream is closed.
	 * Since 2.20
	 * Params:
	 * closeFd =  TRUE to close the file descriptor when done
	 */
	public void setCloseFd(int closeFd)
	{
		// void g_unix_output_stream_set_close_fd (GUnixOutputStream *stream,  gboolean close_fd);
		g_unix_output_stream_set_close_fd(gUnixOutputStream, closeFd);
	}
	
	/**
	 * Returns whether the file descriptor of stream will be
	 * closed when the stream is closed.
	 * Since 2.20
	 * Returns: TRUE if the file descriptor is closed when done
	 */
	public int getCloseFd()
	{
		// gboolean g_unix_output_stream_get_close_fd (GUnixOutputStream *stream);
		return g_unix_output_stream_get_close_fd(gUnixOutputStream);
	}
	
	/**
	 * Return the UNIX file descriptor that the stream writes to.
	 * Since 2.20
	 * Returns: The file descriptor of stream
	 */
	public int getFd()
	{
		// gint g_unix_output_stream_get_fd (GUnixOutputStream *stream);
		return g_unix_output_stream_get_fd(gUnixOutputStream);
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
