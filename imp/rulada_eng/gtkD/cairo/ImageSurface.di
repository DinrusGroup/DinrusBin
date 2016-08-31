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
 * inFile  = cairo-image-surface.html
 * outPack = cairo
 * outFile = ImageSurface
 * strct   = cairo_surface_t
 * realStrct=
 * ctorStrct=
 * clss    = ImageSurface
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = cairo_surface_t
 * implements:
 * prefixes:
 * 	- cairo_image_surface_
 * 	- cairo_surface_
 * 	- cairo_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * structWrap:
 * 	- cairo_surface_t* -> ImageSurface
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.cairo.ImageSurface;

public  import gtkD.gtkc.cairotypes;

private import gtkD.gtkc.cairo;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;



private import gtkD.cairo.Surface;

/**
 * Description
 * Image surfaces provide the ability to render to memory buffers
 * either allocated by cairo or by the calling code. The supported
 * image formats are those defined in cairo_format_t.
 */
public class ImageSurface : Surface
{
	
	/** the main Gtk struct */
	protected cairo_surface_t* cairo_surface;
	
	
	public cairo_surface_t* getImageSurfaceStruct()
	{
		return cairo_surface;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)cairo_surface;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (cairo_surface_t* cairo_surface)
	{
		if(cairo_surface is null)
		{
			this = null;
			return;
		}
		super(cast(cairo_surface_t*)cairo_surface);
		this.cairo_surface = cairo_surface;
	}
	
	/**
	 * Description
	 * The PNG functions allow reading PNG images into image surfaces, and writing
	 * any surface to a PNG file.
	 */
	
	/**
	 * This function provides a stride value that will respect all
	 * alignment requirements of the accelerated image-rendering code
	 * Since 1.6
	 * Params:
	 * format =  A cairo_format_t value
	 * width =  The desired width of an image surface to be created.
	 * Returns: the appropriate stride to use given the desiredformat and width, or -1 if either the format is invalid or the widthtoo large.
	 */
	public static int formatStrideForWidth(cairo_format_t format, int width)
	{
		// int cairo_format_stride_for_width (cairo_format_t format,  int width);
		return cairo_format_stride_for_width(format, width);
	}
	
	/**
	 * Creates an image surface of the specified format and
	 * dimensions. Initially the surface contents are all
	 * 0. (Specifically, within each pixel, each color or alpha channel
	 * belonging to format will be 0. The contents of bits within a pixel,
	 * but not belonging to the given format are undefined).
	 * Params:
	 * format =  format of pixels in the surface to create
	 * width =  width of the surface, in pixels
	 * height =  height of the surface, in pixels
	 * Returns: a pointer to the newly created surface. The callerowns the surface and should call cairo_surface_destroy() when donewith it.This function always returns a valid pointer, but it will return apointer to a "nil" surface if an error such as out of memoryoccurs. You can use cairo_surface_status() to check for this.
	 */
	public static ImageSurface create(cairo_format_t format, int width, int height)
	{
		// cairo_surface_t* cairo_image_surface_create (cairo_format_t format,  int width,  int height);
		auto p = cairo_image_surface_create(format, width, height);
		if(p is null)
		{
			return null;
		}
		return new ImageSurface(cast(cairo_surface_t*) p);
	}
	
	/**
	 * Creates an image surface for the provided pixel data. The output
	 * buffer must be kept around until the cairo_surface_t is destroyed
	 * or cairo_surface_finish() is called on the surface. The initial
	 * contents of buffer will be used as the initial image contents; you
	 * must explicitly clear the buffer, using, for example,
	 * cairo_rectangle() and cairo_fill() if you want it cleared.
	 * Note that the stride may be larger than
	 * width*bytes_per_pixel to provide proper alignment for each pixel
	 * and row. This alignment is required to allow high-performance rendering
	 * within gtkD.cairo. The correct way to obtain a legal stride value is to
	 * call cairo_format_stride_for_width() with the desired format and
	 * maximum image width value, and the use the resulting stride value
	 * to allocate the data and to create the image surface. See
	 * cairo_format_stride_for_width() for example code.
	 * Params:
	 * data =  a pointer to a buffer supplied by the application in which
	 *  to write contents. This pointer must be suitably aligned for any
	 *  kind of variable, (for example, a pointer returned by malloc).
	 * format =  the format of pixels in the buffer
	 * width =  the width of the image to be stored in the buffer
	 * height =  the height of the image to be stored in the buffer
	 * stride =  the number of bytes between the start of rows in the
	 *  buffer as allocated. This value should always be computed by
	 *  cairo_format_stride_for_width() before allocating the data
	 *  buffer.
	 * Returns: a pointer to the newly created surface. The callerowns the surface and should call cairo_surface_destroy() when donewith it.This function always returns a valid pointer, but it will return apointer to a "nil" surface in the case of an error such as out ofmemory or an invalid stride value. In case of invalid stride valuethe error status of the returned surface will beCAIRO_STATUS_INVALID_STRIDE. You can usecairo_surface_status() to check for this.See cairo_surface_set_user_data() for a means of attaching adestroy-notification fallback to the surface if necessary.
	 */
	public static ImageSurface createForData(ubyte* data, cairo_format_t format, int width, int height, int stride)
	{
		// cairo_surface_t* cairo_image_surface_create_for_data (unsigned char *data,  cairo_format_t format,  int width,  int height,  int stride);
		auto p = cairo_image_surface_create_for_data(data, format, width, height, stride);
		if(p is null)
		{
			return null;
		}
		return new ImageSurface(cast(cairo_surface_t*) p);
	}
	
	/**
	 * Get a pointer to the data of the image surface, for direct
	 * inspection or modification.
	 * Since 1.2
	 * Returns: a pointer to the image data of this surface or NULLif surface is not an image surface.
	 */
	public ubyte* getData()
	{
		// unsigned char* cairo_image_surface_get_data (cairo_surface_t *surface);
		return cairo_image_surface_get_data(cairo_surface);
	}
	
	/**
	 * Get the format of the surface.
	 * Since 1.2
	 * Returns: the format of the surface
	 */
	public cairo_format_t getFormat()
	{
		// cairo_format_t cairo_image_surface_get_format (cairo_surface_t *surface);
		return cairo_image_surface_get_format(cairo_surface);
	}
	
	/**
	 * Get the width of the image surface in pixels.
	 * Returns: the width of the surface in pixels.
	 */
	public int getWidth()
	{
		// int cairo_image_surface_get_width (cairo_surface_t *surface);
		return cairo_image_surface_get_width(cairo_surface);
	}
	
	/**
	 * Get the height of the image surface in pixels.
	 * Returns: the height of the surface in pixels.
	 */
	public int getHeight()
	{
		// int cairo_image_surface_get_height (cairo_surface_t *surface);
		return cairo_image_surface_get_height(cairo_surface);
	}
	
	/**
	 * Get the stride of the image surface in bytes
	 * Since 1.2
	 * Returns: the stride of the image surface in bytes (or 0 ifsurface is not an image surface). The stride is the distance inbytes from the beginning of one row of the image data to thebeginning of the next row.
	 */
	public int getStride()
	{
		// int cairo_image_surface_get_stride (cairo_surface_t *surface);
		return cairo_image_surface_get_stride(cairo_surface);
	}
	
	/**
	 * Creates a new image surface and initializes the contents to the
	 * given PNG file.
	 * Params:
	 * filename =  name of PNG file to load
	 * Returns: a new cairo_surface_t initialized with the contentsof the PNG file, or a "nil" surface if any error occurred. A nilsurface can be checked for with cairo_surface_status(surface) which
	 */
	public static ImageSurface createFromPng(string filename)
	{
		// cairo_surface_t* cairo_image_surface_create_from_png (const char *filename);
		auto p = cairo_image_surface_create_from_png(Str.toStringz(filename));
		if(p is null)
		{
			return null;
		}
		return new ImageSurface(cast(cairo_surface_t*) p);
	}
	
	/**
	 * Creates a new image surface from PNG data read incrementally
	 * via the read_func function.
	 * Params:
	 * readFunc =  function called to read the data of the file
	 * closure =  data to pass to read_func.
	 * Returns: a new cairo_surface_t initialized with the contentsof the PNG file or NULL if the data read is not a valid PNG image ormemory could not be allocated for the operation.
	 */
	public static ImageSurface createFromPngStream(cairo_read_func_t readFunc, void* closure)
	{
		// cairo_surface_t* cairo_image_surface_create_from_png_stream  (cairo_read_func_t read_func,  void *closure);
		auto p = cairo_image_surface_create_from_png_stream(readFunc, closure);
		if(p is null)
		{
			return null;
		}
		return new ImageSurface(cast(cairo_surface_t*) p);
	}
	
	/**
	 * Writes the contents of surface to a new file filename as a PNG
	 * image.
	 * Params:
	 * filename =  the name of a file to write to
	 * Returns: CAIRO_STATUS_SUCCESS if the PNG file was writtensuccessfully. Otherwise, CAIRO_STATUS_NO_MEMORY if memory could notbe allocated for the operation orCAIRO_STATUS_SURFACE_TYPE_MISMATCH if the surface does not havepixel contents, or CAIRO_STATUS_WRITE_ERROR if an I/O error occurswhile attempting to write the file.
	 */
	public cairo_status_t writeToPng(string filename)
	{
		// cairo_status_t cairo_surface_write_to_png (cairo_surface_t *surface,  const char *filename);
		return cairo_surface_write_to_png(cairo_surface, Str.toStringz(filename));
	}
	
	/**
	 * Writes the image surface to the write function.
	 * Params:
	 * writeFunc =  a cairo_write_func_t
	 * closure =  closure data for the write function
	 * Returns: CAIRO_STATUS_SUCCESS if the PNG file was writtensuccessfully. Otherwise, CAIRO_STATUS_NO_MEMORY is returned ifmemory could not be allocated for the operation,CAIRO_STATUS_SURFACE_TYPE_MISMATCH if the surface does not havepixel contents.
	 */
	public cairo_status_t writeToPngStream(cairo_write_func_t writeFunc, void* closure)
	{
		// cairo_status_t cairo_surface_write_to_png_stream (cairo_surface_t *surface,  cairo_write_func_t write_func,  void *closure);
		return cairo_surface_write_to_png_stream(cairo_surface, writeFunc, closure);
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-cairo");
        } else version (DigitalMars) {
            pragma(link, "DD-cairo");
        } else {
            pragma(link, "DO-cairo");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-cairo");
        } else version (DigitalMars) {
            pragma(link, "DD-cairo");
        } else {
            pragma(link, "DO-cairo");
        }
    }
}
