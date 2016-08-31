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
 * inFile  = GtkImage.html
 * outPack = gtk
 * outFile = Image
 * strct   = GtkImage
 * realStrct=
 * ctorStrct=
 * clss    = Image
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_image_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * 	- gtk_image_new_from_stock
 * 	- gtk_image_new_from_icon_name
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gio.Icon
 * 	- gtkD.gio.IconIF
 * 	- gtkD.gtk.IconSet
 * 	- gtkD.gdk.ImageGdk
 * 	- gtkD.gdk.Bitmap
 * 	- gtkD.gdk.Pixbuf
 * 	- gtkD.gdk.Pixmap
 * 	- gtkD.gdkpixbuf.PixbufAnimation
 * 	- gtkD.gtk.IconSet
 * 	- gtkD.gdk.ImageGdk
 * 	- gtkD.gdk.Bitmap
 * 	- gtkD.gdk.Pixmap
 * structWrap:
 * 	- GIcon* -> IconIF
 * 	- GdkBitmap* -> Bitmap
 * 	- GdkImage* -> ImageGdk
 * 	- GdkPixbuf* -> Pixbuf
 * 	- GdkPixbufAnimation* -> PixbufAnimation
 * 	- GdkPixmap* -> Pixmap
 * 	- GtkIconSet* -> IconSet
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.Image;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gio.Icon;
private import gtkD.gio.IconIF;
private import gtkD.gtk.IconSet;
private import gtkD.gdk.ImageGdk;
private import gtkD.gdk.Bitmap;
private import gtkD.gdk.Pixbuf;
private import gtkD.gdk.Pixmap;
private import gtkD.gdkpixbuf.PixbufAnimation;
private import gtkD.gtk.IconSet;
private import gtkD.gdk.ImageGdk;
private import gtkD.gdk.Bitmap;
private import gtkD.gdk.Pixmap;



private import gtkD.gtk.Misc;

/**
 * Description
 * The GtkImage widget displays an image. Various kinds of object
 * can be displayed as an image; most typically, you would load a
 * GdkPixbuf ("pixel buffer") from a file, and then display that.
 * There's a convenience function to do this, gtk_image_new_from_file(),
 * used as follows:
 *  GtkWidget *image;
 *  image = gtk_image_new_from_file ("myfile.png");
 * If the file isn't loaded successfully, the image will contain a
 * "broken image" icon similar to that used in many web browsers.
 * If you want to handle errors in loading the file yourself,
 * for example by displaying an error message, then load the image with
 * gdk_pixbuf_new_from_file(), then create the GtkImage with
 * gtk_image_new_from_pixbuf().
 * The image file may contain an animation, if so the GtkImage will
 * display an animation (GdkPixbufAnimation) instead of a static image.
 * GtkImage is a subclass of GtkMisc, which implies that you can
 * align it (center, left, right) and add padding to it, using
 * GtkMisc methods.
 * GtkImage is a "no window" widget (has no GdkWindow of its own),
 * so by default does not receive events. If you want to receive events
 * on the image, such as button clicks, place the image inside a
 * GtkEventBox, then connect to the event signals on the event box.
 * Example 12. Handling button press events on a
 * GtkImage.
 *  static gboolean
 *  button_press_callback (GtkWidget *event_box,
 *  GdkEventButton *event,
 *  gpointer data)
 *  {
	 *  g_print ("Event box clicked at coordinates %f,%f\n",
	 *  event->x, event->y);
	 *  /+* Returning TRUE means we handled the event, so the signal
	 *  * emission should be stopped (don't call any further
	 *  * callbacks that may be connected). Return FALSE
	 *  * to continue invoking callbacks.
	 *  +/
	 *  return TRUE;
 *  }
 *  static GtkWidget*
 *  create_image (void)
 *  {
	 *  GtkWidget *image;
	 *  GtkWidget *event_box;
	 *  image = gtk_image_new_from_file ("myfile.png");
	 *  event_box = gtk_event_box_new ();
	 *  gtk_container_add (GTK_CONTAINER (event_box), image);
	 *  g_signal_connect (G_OBJECT (event_box),
	 *  "button_press_event",
	 *  G_CALLBACK (button_press_callback),
	 *  image);
	 *  return image;
 *  }
 * When handling events on the event box, keep in mind that coordinates
 * in the image may be different from event box coordinates due to
 * the alignment and padding settings on the image (see GtkMisc).
 * The simplest way to solve this is to set the alignment to 0.0
 * (left/top), and set the padding to zero. Then the origin of
 * the image will be the same as the origin of the event box.
 * Sometimes an application will want to avoid depending on external data
 * files, such as image files. GTK+ comes with a program to avoid this,
 * called gdk-pixbuf-csource. This program
 * allows you to convert an image into a C variable declaration, which
 * can then be loaded into a GdkPixbuf using
 * gdk_pixbuf_new_from_inline().
 */
public class Image : Misc
{
	
	/** the main Gtk struct */
	protected GtkImage* gtkImage;
	
	
	public GtkImage* getImageStruct()
	{
		return gtkImage;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkImage;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkImage* gtkImage)
	{
		if(gtkImage is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkImage);
		if( ptr !is null )
		{
			this = cast(Image)ptr;
			return;
		}
		super(cast(GtkMisc*)gtkImage);
		this.gtkImage = gtkImage;
	}
	
	// this will be an enum
	/**
	 * Creates a GtkImage displaying a stock icon. Sample stock icon
	 * names are GTK_STOCK_OPEN, GTK_STOCK_EXIT. Sample stock sizes
	 * are GTK_ICON_SIZE_MENU, GTK_ICON_SIZE_SMALL_TOOLBAR. If the stock
	 * icon name isn't known, the image will be empty.
	 * You can register your own stock icon names, see
	 * gtk_icon_factory_add_default() and gtk_icon_factory_add().
	 * Params:
	 *  StockID = a stock icon name
	 *  size = a stock icon size
	 * Returns:
	 *  a new GtkImage displaying the stock icon
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (StockID stockID, GtkIconSize size)
	{
		// GtkWidget* gtk_image_new_from_stock (const gchar *stock_id,  GtkIconSize size);
		auto p = gtk_image_new_from_stock(Str.toStringz(StockDesc[stockID]), size);
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_image_new_from_stock(Str.toStringz(StockDesc[stockID]), size)");
		}
		this(cast(GtkImage*)p);
	}
	
	/**
	 * Creates a GtkImage displaying an icon from the current icon theme.
	 * If the icon name isn't known, a "broken image" icon will be
	 * displayed instead. If the current icon theme is changed, the icon
	 * will be updated appropriately. Since 2.6
	 * Params:
	 *  iconName = an icon name
	 *  size = a stock icon size
	 * Returns:
	 *  a new GtkImage displaying the themed icon
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string iconName, GtkIconSize size)
	{
		// GtkWidget* gtk_image_new_from_icon_name (const gchar *icon_name,  GtkIconSize size);
		auto p = gtk_image_new_from_icon_name(Str.toStringz(iconName), size);
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_image_new_from_icon_name(Str.toStringz(iconName), size)");
		}
		this(cast(GtkImage*)p);
	}
	
	
	/**
	 */
	
	/**
	 * Gets the icon set and size being displayed by the GtkImage.
	 * The storage type of the image must be GTK_IMAGE_EMPTY or
	 * GTK_IMAGE_ICON_SET (see gtk_image_get_storage_type()).
	 * Params:
	 * iconSet =  location to store a GtkIconSet, or NULL
	 * size =  location to store a stock icon size, or NULL
	 */
	public void getIconSet(out IconSet iconSet, out GtkIconSize size)
	{
		// void gtk_image_get_icon_set (GtkImage *image,  GtkIconSet **icon_set,  GtkIconSize *size);
		GtkIconSet* outiconSet = null;
		
		gtk_image_get_icon_set(gtkImage, &outiconSet, &size);
		
		iconSet = new IconSet(outiconSet);
	}
	
	/**
	 * Gets the GdkImage and mask being displayed by the GtkImage.
	 * The storage type of the image must be GTK_IMAGE_EMPTY or
	 * GTK_IMAGE_IMAGE (see gtk_image_get_storage_type()).
	 * The caller of this function does not own a reference to the
	 * returned image and mask.
	 * Params:
	 * gdkImage =  return location for a GtkImage, or NULL
	 * mask =  return location for a GdkBitmap, or NULL
	 */
	public void getImage(out ImageGdk gdkImage, out Bitmap mask)
	{
		// void gtk_image_get_image (GtkImage *image,  GdkImage **gdk_image,  GdkBitmap **mask);
		GdkImage* outgdkImage = null;
		GdkBitmap* outmask = null;
		
		gtk_image_get_image(gtkImage, &outgdkImage, &outmask);
		
		gdkImage = new ImageGdk(outgdkImage);
		mask = new Bitmap(outmask);
	}
	
	/**
	 * Gets the GdkPixbuf being displayed by the GtkImage.
	 * The storage type of the image must be GTK_IMAGE_EMPTY or
	 * GTK_IMAGE_PIXBUF (see gtk_image_get_storage_type()).
	 * The caller of this function does not own a reference to the
	 * returned pixbuf.
	 * Returns: the displayed pixbuf, or NULL if the image is empty
	 */
	public Pixbuf getPixbuf()
	{
		// GdkPixbuf* gtk_image_get_pixbuf (GtkImage *image);
		auto p = gtk_image_get_pixbuf(gtkImage);
		if(p is null)
		{
			return null;
		}
		return new Pixbuf(cast(GdkPixbuf*) p);
	}
	
	/**
	 * Gets the pixmap and mask being displayed by the GtkImage.
	 * The storage type of the image must be GTK_IMAGE_EMPTY or
	 * GTK_IMAGE_PIXMAP (see gtk_image_get_storage_type()).
	 * The caller of this function does not own a reference to the
	 * returned pixmap and mask.
	 * Params:
	 * pixmap =  location to store the pixmap, or NULL
	 * mask =  location to store the mask, or NULL
	 */
	public void getPixmap(out Pixmap pixmap, out Bitmap mask)
	{
		// void gtk_image_get_pixmap (GtkImage *image,  GdkPixmap **pixmap,  GdkBitmap **mask);
		GdkPixmap* outpixmap = null;
		GdkBitmap* outmask = null;
		
		gtk_image_get_pixmap(gtkImage, &outpixmap, &outmask);
		
		pixmap = new Pixmap(outpixmap);
		mask = new Bitmap(outmask);
	}
	
	/**
	 * Gets the stock icon name and size being displayed by the GtkImage.
	 * The storage type of the image must be GTK_IMAGE_EMPTY or
	 * GTK_IMAGE_STOCK (see gtk_image_get_storage_type()).
	 * The returned string is owned by the GtkImage and should not
	 * be freed.
	 * Params:
	 * stockId =  place to store a stock icon name, or NULL
	 * size =  place to store a stock icon size, or NULL
	 */
	public void getStock(out string stockId, out GtkIconSize size)
	{
		// void gtk_image_get_stock (GtkImage *image,  gchar **stock_id,  GtkIconSize *size);
		char* outstockId = null;
		
		gtk_image_get_stock(gtkImage, &outstockId, &size);
		
		stockId = Str.toString(outstockId);
	}
	
	/**
	 * Gets the GdkPixbufAnimation being displayed by the GtkImage.
	 * The storage type of the image must be GTK_IMAGE_EMPTY or
	 * GTK_IMAGE_ANIMATION (see gtk_image_get_storage_type()).
	 * The caller of this function does not own a reference to the
	 * returned animation.
	 * Returns: the displayed animation, or NULL if the image is empty
	 */
	public PixbufAnimation getAnimation()
	{
		// GdkPixbufAnimation* gtk_image_get_animation (GtkImage *image);
		auto p = gtk_image_get_animation(gtkImage);
		if(p is null)
		{
			return null;
		}
		return new PixbufAnimation(cast(GdkPixbufAnimation*) p);
	}
	
	/**
	 * Gets the icon name and size being displayed by the GtkImage.
	 * The storage type of the image must be GTK_IMAGE_EMPTY or
	 * GTK_IMAGE_ICON_NAME (see gtk_image_get_storage_type()).
	 * The returned string is owned by the GtkImage and should not
	 * be freed.
	 * Since 2.6
	 * Params:
	 * iconName =  place to store an icon name, or NULL
	 * size =  place to store an icon size, or NULL
	 */
	public void getIconName(out string iconName, out GtkIconSize size)
	{
		// void gtk_image_get_icon_name (GtkImage *image,  G_CONST_RETURN gchar **icon_name,  GtkIconSize *size);
		char* outiconName = null;
		
		gtk_image_get_icon_name(gtkImage, &outiconName, &size);
		
		iconName = Str.toString(outiconName);
	}
	
	/**
	 * Gets the GIcon and size being displayed by the GtkImage.
	 * The storage type of the image must be GTK_IMAGE_EMPTY or
	 * GTK_IMAGE_GICON (see gtk_image_get_storage_type()).
	 * The caller of this function does not own a reference to the
	 * returned GIcon.
	 * Since 2.14
	 * Params:
	 * gicon =  place to store a GIcon, or NULL
	 * size =  place to store an icon size, or NULL
	 */
	public void getGicon(out IconIF gicon, out GtkIconSize size)
	{
		// void gtk_image_get_gicon (GtkImage *image,  GIcon **gicon,  GtkIconSize *size);
		GIcon* outgicon = null;
		
		gtk_image_get_gicon(gtkImage, &outgicon, &size);
		
		gicon = new Icon(outgicon);
	}
	
	/**
	 * Gets the type of representation being used by the GtkImage
	 * to store image data. If the GtkImage has no image data,
	 * the return value will be GTK_IMAGE_EMPTY.
	 * Returns: image representation being used
	 */
	public GtkImageType getStorageType()
	{
		// GtkImageType gtk_image_get_storage_type (GtkImage *image);
		return gtk_image_get_storage_type(gtkImage);
	}
	
	/**
	 * Creates a new GtkImage displaying the file filename. If the file
	 * isn't found or can't be loaded, the resulting GtkImage will
	 * display a "broken image" icon. This function never returns NULL,
	 * it always returns a valid GtkImage widget.
	 * If the file contains an animation, the image will contain an
	 * animation.
	 * If you need to detect failures to load the file, use
	 * gdk_pixbuf_new_from_file() to load the file yourself, then create
	 * the GtkImage from the pixbuf. (Or for animations, use
	 * gdk_pixbuf_animation_new_from_file()).
	 * The storage type (gtk_image_get_storage_type()) of the returned
	 * image is not defined, it will be whatever is appropriate for
	 * displaying the file.
	 * Params:
	 * filename =  a filename
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string filename)
	{
		// GtkWidget* gtk_image_new_from_file (const gchar *filename);
		auto p = gtk_image_new_from_file(Str.toStringz(filename));
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_image_new_from_file(Str.toStringz(filename))");
		}
		this(cast(GtkImage*) p);
	}
	
	/**
	 * Creates a GtkImage displaying an icon set. Sample stock sizes are
	 * GTK_ICON_SIZE_MENU, GTK_ICON_SIZE_SMALL_TOOLBAR. Instead of using
	 * this function, usually it's better to create a GtkIconFactory, put
	 * your icon sets in the icon factory, add the icon factory to the
	 * list of default factories with gtk_icon_factory_add_default(), and
	 * then use gtk_image_new_from_stock(). This will allow themes to
	 * override the icon you ship with your application.
	 * The GtkImage does not assume a reference to the
	 * icon set; you still need to unref it if you own references.
	 * GtkImage will add its own reference rather than adopting yours.
	 * Params:
	 * iconSet =  a GtkIconSet
	 * size =  a stock icon size
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (IconSet iconSet, GtkIconSize size)
	{
		// GtkWidget* gtk_image_new_from_icon_set (GtkIconSet *icon_set,  GtkIconSize size);
		auto p = gtk_image_new_from_icon_set((iconSet is null) ? null : iconSet.getIconSetStruct(), size);
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_image_new_from_icon_set((iconSet is null) ? null : iconSet.getIconSetStruct(), size)");
		}
		this(cast(GtkImage*) p);
	}
	
	/**
	 * Creates a GtkImage widget displaying a image with a mask.
	 * A GdkImage is a client-side image buffer in the pixel format of the
	 * current display. The GtkImage does not assume a reference to the
	 * image or mask; you still need to unref them if you own references.
	 * GtkImage will add its own reference rather than adopting yours.
	 * Params:
	 * image =  a GdkImage, or NULL
	 * mask =  a GdkBitmap, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ImageGdk image, Bitmap mask)
	{
		// GtkWidget* gtk_image_new_from_image (GdkImage *image,  GdkBitmap *mask);
		auto p = gtk_image_new_from_image((image is null) ? null : image.getImageGdkStruct(), (mask is null) ? null : mask.getBitmapStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_image_new_from_image((image is null) ? null : image.getImageGdkStruct(), (mask is null) ? null : mask.getBitmapStruct())");
		}
		this(cast(GtkImage*) p);
	}
	
	/**
	 * Creates a new GtkImage displaying pixbuf.
	 * The GtkImage does not assume a reference to the
	 * pixbuf; you still need to unref it if you own references.
	 * GtkImage will add its own reference rather than adopting yours.
	 * Note that this function just creates an GtkImage from the pixbuf. The
	 * GtkImage created will not react to state changes. Should you want that,
	 * you should use gtk_image_new_from_icon_set().
	 * Params:
	 * pixbuf =  a GdkPixbuf, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Pixbuf pixbuf)
	{
		// GtkWidget* gtk_image_new_from_pixbuf (GdkPixbuf *pixbuf);
		auto p = gtk_image_new_from_pixbuf((pixbuf is null) ? null : pixbuf.getPixbufStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_image_new_from_pixbuf((pixbuf is null) ? null : pixbuf.getPixbufStruct())");
		}
		this(cast(GtkImage*) p);
	}
	
	/**
	 * Creates a GtkImage widget displaying pixmap with a mask.
	 * A GdkPixmap is a server-side image buffer in the pixel format of the
	 * current display. The GtkImage does not assume a reference to the
	 * pixmap or mask; you still need to unref them if you own references.
	 * GtkImage will add its own reference rather than adopting yours.
	 * Params:
	 * pixmap =  a GdkPixmap, or NULL
	 * mask =  a GdkBitmap, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Pixmap pixmap, Bitmap mask)
	{
		// GtkWidget* gtk_image_new_from_pixmap (GdkPixmap *pixmap,  GdkBitmap *mask);
		auto p = gtk_image_new_from_pixmap((pixmap is null) ? null : pixmap.getPixmapStruct(), (mask is null) ? null : mask.getBitmapStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_image_new_from_pixmap((pixmap is null) ? null : pixmap.getPixmapStruct(), (mask is null) ? null : mask.getBitmapStruct())");
		}
		this(cast(GtkImage*) p);
	}
	
	/**
	 * Creates a GtkImage displaying the given animation.
	 * The GtkImage does not assume a reference to the
	 * animation; you still need to unref it if you own references.
	 * GtkImage will add its own reference rather than adopting yours.
	 * Note that the animation frames are shown using a timeout with
	 * G_PRIORITY_DEFAULT. When using animations to indicate busyness,
	 * keep in mind that the animation will only be shown if the main loop
	 * is not busy with something that has a higher priority.
	 * Params:
	 * animation =  an animation
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (PixbufAnimation animation)
	{
		// GtkWidget* gtk_image_new_from_animation (GdkPixbufAnimation *animation);
		auto p = gtk_image_new_from_animation((animation is null) ? null : animation.getPixbufAnimationStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_image_new_from_animation((animation is null) ? null : animation.getPixbufAnimationStruct())");
		}
		this(cast(GtkImage*) p);
	}
	
	/**
	 * Creates a GtkImage displaying an icon from the current icon theme.
	 * If the icon name isn't known, a "broken image" icon will be
	 * displayed instead. If the current icon theme is changed, the icon
	 * will be updated appropriately.
	 * Since 2.14
	 * Params:
	 * icon =  an icon
	 * size =  a stock icon size
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (IconIF icon, GtkIconSize size)
	{
		// GtkWidget* gtk_image_new_from_gicon (GIcon *icon,  GtkIconSize size);
		auto p = gtk_image_new_from_gicon((icon is null) ? null : icon.getIconTStruct(), size);
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_image_new_from_gicon((icon is null) ? null : icon.getIconTStruct(), size)");
		}
		this(cast(GtkImage*) p);
	}
	
	/**
	 * See gtk_image_new_from_file() for details.
	 * Params:
	 * filename =  a filename or NULL
	 */
	public void setFromFile(string filename)
	{
		// void gtk_image_set_from_file (GtkImage *image,  const gchar *filename);
		gtk_image_set_from_file(gtkImage, Str.toStringz(filename));
	}
	
	/**
	 * See gtk_image_new_from_icon_set() for details.
	 * Params:
	 * iconSet =  a GtkIconSet
	 * size =  a stock icon size
	 */
	public void setFromIconSet(IconSet iconSet, GtkIconSize size)
	{
		// void gtk_image_set_from_icon_set (GtkImage *image,  GtkIconSet *icon_set,  GtkIconSize size);
		gtk_image_set_from_icon_set(gtkImage, (iconSet is null) ? null : iconSet.getIconSetStruct(), size);
	}
	
	/**
	 * See gtk_image_new_from_image() for details.
	 * Params:
	 * gdkImage =  a GdkImage or NULL
	 * mask =  a GdkBitmap or NULL
	 */
	public void setFromImage(ImageGdk gdkImage, Bitmap mask)
	{
		// void gtk_image_set_from_image (GtkImage *image,  GdkImage *gdk_image,  GdkBitmap *mask);
		gtk_image_set_from_image(gtkImage, (gdkImage is null) ? null : gdkImage.getImageGdkStruct(), (mask is null) ? null : mask.getBitmapStruct());
	}
	
	/**
	 * See gtk_image_new_from_pixbuf() for details.
	 * Params:
	 * pixbuf =  a GdkPixbuf or NULL
	 */
	public void setFromPixbuf(Pixbuf pixbuf)
	{
		// void gtk_image_set_from_pixbuf (GtkImage *image,  GdkPixbuf *pixbuf);
		gtk_image_set_from_pixbuf(gtkImage, (pixbuf is null) ? null : pixbuf.getPixbufStruct());
	}
	
	/**
	 * See gtk_image_new_from_pixmap() for details.
	 * Params:
	 * pixmap =  a GdkPixmap or NULL
	 * mask =  a GdkBitmap or NULL
	 */
	public void setFromPixmap(Pixmap pixmap, Bitmap mask)
	{
		// void gtk_image_set_from_pixmap (GtkImage *image,  GdkPixmap *pixmap,  GdkBitmap *mask);
		gtk_image_set_from_pixmap(gtkImage, (pixmap is null) ? null : pixmap.getPixmapStruct(), (mask is null) ? null : mask.getBitmapStruct());
	}
	
	/**
	 * See gtk_image_new_from_stock() for details.
	 * Params:
	 * stockId =  a stock icon name
	 * size =  a stock icon size
	 */
	public void setFromStock(string stockId, GtkIconSize size)
	{
		// void gtk_image_set_from_stock (GtkImage *image,  const gchar *stock_id,  GtkIconSize size);
		gtk_image_set_from_stock(gtkImage, Str.toStringz(stockId), size);
	}
	
	/**
	 * Causes the GtkImage to display the given animation (or display
	 * nothing, if you set the animation to NULL).
	 * Params:
	 * animation =  the GdkPixbufAnimation
	 */
	public void setFromAnimation(PixbufAnimation animation)
	{
		// void gtk_image_set_from_animation (GtkImage *image,  GdkPixbufAnimation *animation);
		gtk_image_set_from_animation(gtkImage, (animation is null) ? null : animation.getPixbufAnimationStruct());
	}
	
	/**
	 * See gtk_image_new_from_icon_name() for details.
	 * Since 2.6
	 * Params:
	 * iconName =  an icon name
	 * size =  an icon size
	 */
	public void setFromIconName(string iconName, GtkIconSize size)
	{
		// void gtk_image_set_from_icon_name (GtkImage *image,  const gchar *icon_name,  GtkIconSize size);
		gtk_image_set_from_icon_name(gtkImage, Str.toStringz(iconName), size);
	}
	
	/**
	 * See gtk_image_new_from_gicon() for details.
	 * Since 2.14
	 * Params:
	 * icon =  an icon
	 * size =  an icon size
	 */
	public void setFromGicon(IconIF icon, GtkIconSize size)
	{
		// void gtk_image_set_from_gicon (GtkImage *image,  GIcon *icon,  GtkIconSize size);
		gtk_image_set_from_gicon(gtkImage, (icon is null) ? null : icon.getIconTStruct(), size);
	}
	
	/**
	 * Resets the image to be empty.
	 * Since 2.8
	 */
	public void clear()
	{
		// void gtk_image_clear (GtkImage *image);
		gtk_image_clear(gtkImage);
	}
	
	/**
	 * Creates a new empty GtkImage widget.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GtkWidget* gtk_image_new (void);
		auto p = gtk_image_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_image_new()");
		}
		this(cast(GtkImage*) p);
	}
	
	/**
	 * Warning
	 * gtk_image_set is deprecated and should not be used in newly-written code.
	 * Sets the GtkImage.
	 * Params:
	 * val = a GdkImage
	 * mask = a GdkBitmap that indicates which parts of the image should be transparent.
	 */
	public void set(ImageGdk val, Bitmap mask)
	{
		// void gtk_image_set (GtkImage *image,  GdkImage *val,  GdkBitmap *mask);
		gtk_image_set(gtkImage, (val is null) ? null : val.getImageGdkStruct(), (mask is null) ? null : mask.getBitmapStruct());
	}
	
	/**
	 * Warning
	 * gtk_image_get is deprecated and should not be used in newly-written code.
	 * Gets the GtkImage.
	 * Params:
	 * val = return location for a GdkImage
	 * mask = a GdkBitmap that indicates which parts of the image should be transparent.
	 */
	public void get(out ImageGdk val, out Bitmap mask)
	{
		// void gtk_image_get (GtkImage *image,  GdkImage **val,  GdkBitmap **mask);
		GdkImage* outval = null;
		GdkBitmap* outmask = null;
		
		gtk_image_get(gtkImage, &outval, &outmask);
		
		val = new ImageGdk(outval);
		mask = new Bitmap(outmask);
	}
	
	/**
	 * Sets the pixel size to use for named icons. If the pixel size is set
	 * to a value != -1, it is used instead of the icon size set by
	 * gtk_image_set_from_icon_name().
	 * Since 2.6
	 * Params:
	 * pixelSize =  the new pixel size
	 */
	public void setPixelSize(int pixelSize)
	{
		// void gtk_image_set_pixel_size (GtkImage *image,  gint pixel_size);
		gtk_image_set_pixel_size(gtkImage, pixelSize);
	}
	
	/**
	 * Gets the pixel size used for named icons.
	 * Since 2.6
	 * Returns: the pixel size used for named icons.
	 */
	public int getPixelSize()
	{
		// gint gtk_image_get_pixel_size (GtkImage *image);
		return gtk_image_get_pixel_size(gtkImage);
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gtk");
        } else version (DigitalMars) {
            pragma(link, "DD-gtk");
        } else {
            pragma(link, "DO-gtk");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gtk");
        } else version (DigitalMars) {
            pragma(link, "DD-gtk");
        } else {
            pragma(link, "DO-gtk");
        }
    }
}
