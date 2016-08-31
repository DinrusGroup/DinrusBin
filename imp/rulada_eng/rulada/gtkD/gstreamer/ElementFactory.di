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
 * inFile  = GstElementFactory.html
 * outPack = gstreamer
 * outFile = ElementFactory
 * strct   = GstElementFactory
 * realStrct=
 * ctorStrct=
 * clss    = ElementFactory
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gst_element_factory_
 * 	- gst_element_
 * 	- gst_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gstreamer.Element
 * 	- gtkD.gstreamer.Plugin
 * 	- gtkD.gstreamer.Caps
 * 	- gtkD.glib.ListG
 * structWrap:
 * 	- GList* -> ListG
 * 	- GstCaps* -> Caps
 * 	- GstElement* -> Element
 * 	- GstElementFactory* -> ElementFactory
 * 	- GstPlugin* -> Plugin
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gstreamer.ElementFactory;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gstreamer.Element;
private import gtkD.gstreamer.Plugin;
private import gtkD.gstreamer.Caps;
private import gtkD.glib.ListG;



private import gtkD.gstreamer.PluginFeature;

/**
 * Description
 * GstElementFactory is used to create instances of elements. A
 * GstElementfactory can be added to a GstPlugin as it is also a
 * GstPluginFeature.
 * Use the gst_element_factory_find() and gst_element_factory_create()
 * functions to create element instances or use gst_element_factory_make() as a
 * convenient shortcut.
 * The following code example shows you how to create a GstFileSrc element.
 * Example6.Using an element factory
 *  include <gst/gst.h>
 *  GstElement *src;
 *  GstElementFactory *srcfactory;
 *  gst_init(argc,argv);
 *  srcfactory = gst_element_factory_find("filesrc");
 *  g_return_if_fail(srcfactory != NULL);
 *  src = gst_element_factory_create(srcfactory,"src");
 *  g_return_if_fail(src != NULL);
 *  ...
 * Last reviewed on 2005-11-23 (0.9.5)
 */
public class ElementFactory : PluginFeature
{
	
	/** the main Gtk struct */
	protected GstElementFactory* gstElementFactory;
	
	
	public GstElementFactory* getElementFactoryStruct()
	{
		return gstElementFactory;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gstElementFactory;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstElementFactory* gstElementFactory)
	{
		if(gstElementFactory is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gstElementFactory);
		if( ptr !is null )
		{
			this = cast(ElementFactory)ptr;
			return;
		}
		super(cast(GstPluginFeature*)gstElementFactory);
		this.gstElementFactory = gstElementFactory;
	}
	
	/**
	 * Create a new element of the type defined by the given element factory.
	 * The element will receive a guaranteed unique name,
	 * consisting of the element factory name and a number.
	 * Params:
	 *  factoryname = a named factory to instantiate
	 * Returns:
	 *  new GstElement or NULL if unable to create element
	 */
	public static Element make( string factoryname )
	{
		// GstElement* gst_element_factory_make (const gchar *factoryname,  const gchar *name);
		return new Element( gst_element_factory_make(Str.toStringz(factoryname), null ) );
	}
	
	/**
	 */
	
	/**
	 * Create a new elementfactory capable of instantiating objects of the
	 * type and add the factory to plugin.
	 * Params:
	 * plugin =  GstPlugin to register the element with
	 * name =  name of elements of this type
	 * rank =  rank of element (higher rank means more importance when autoplugging)
	 * type =  GType of element to register
	 * Returns: TRUE, if the registering succeeded, FALSE on error
	 */
	public static int register(Plugin plugin, string name, uint rank, GType type)
	{
		// gboolean gst_element_register (GstPlugin *plugin,  const gchar *name,  guint rank,  GType type);
		return gst_element_register((plugin is null) ? null : plugin.getPluginStruct(), Str.toStringz(name), rank, type);
	}
	
	/**
	 * Search for an element factory of the given name. Refs the returned
	 * element factory; caller is responsible for unreffing.
	 * Params:
	 * name =  name of factory to find
	 * Returns: GstElementFactory if found, NULL otherwise
	 */
	public static ElementFactory find(string name)
	{
		// GstElementFactory* gst_element_factory_find (const gchar *name);
		auto p = gst_element_factory_find(Str.toStringz(name));
		if(p is null)
		{
			return null;
		}
		return new ElementFactory(cast(GstElementFactory*) p);
	}
	
	/**
	 * Get the GType for elements managed by this factory. The type can
	 * only be retrieved if the element factory is loaded, which can be
	 * assured with gst_plugin_feature_load().
	 * Returns: the GType for elements managed by this factory or 0 ifthe factory is not loaded.
	 */
	public GType getElementType()
	{
		// GType gst_element_factory_get_element_type  (GstElementFactory *factory);
		return gst_element_factory_get_element_type(gstElementFactory);
	}
	
	/**
	 * Gets the longname for this factory
	 * Returns: the longname
	 */
	public string getLongname()
	{
		// const gchar* gst_element_factory_get_longname  (GstElementFactory *factory);
		return Str.toString(gst_element_factory_get_longname(gstElementFactory));
	}
	
	/**
	 * Gets the class for this factory.
	 * Returns: the class
	 */
	public string getKlass()
	{
		// const gchar* gst_element_factory_get_klass (GstElementFactory *factory);
		return Str.toString(gst_element_factory_get_klass(gstElementFactory));
	}
	
	/**
	 * Gets the description for this factory.
	 * Returns: the description
	 */
	public string getDescription()
	{
		// const gchar* gst_element_factory_get_description  (GstElementFactory *factory);
		return Str.toString(gst_element_factory_get_description(gstElementFactory));
	}
	
	/**
	 * Gets the author for this factory.
	 * Returns: the author
	 */
	public string getAuthor()
	{
		// const gchar* gst_element_factory_get_author (GstElementFactory *factory);
		return Str.toString(gst_element_factory_get_author(gstElementFactory));
	}
	
	/**
	 * Gets the number of pad_templates in this factory.
	 * Returns: the number of pad_templates
	 */
	public uint getNumPadTemplates()
	{
		// guint gst_element_factory_get_num_pad_templates  (GstElementFactory *factory);
		return gst_element_factory_get_num_pad_templates(gstElementFactory);
	}
	
	/**
	 * Gets the type of URIs the element supports or GST_URI_UNKNOWN if none.
	 * Returns: type of URIs this element supports
	 */
	public int getUriType()
	{
		// gint gst_element_factory_get_uri_type  (GstElementFactory *factory);
		return gst_element_factory_get_uri_type(gstElementFactory);
	}
	
	/**
	 * Gets a NULL-terminated array of protocols this element supports or NULL if
	 * no protocols are supported. You may not change the contents of the returned
	 * array, as it is still owned by the element factory. Use g_strdupv() to
	 * make a copy of the protocol string array if you need to.
	 * Returns: the supported protocols or NULL
	 */
	public string[] getUriProtocols()
	{
		// gchar** gst_element_factory_get_uri_protocols  (GstElementFactory *factory);
		return Str.toStringArray(gst_element_factory_get_uri_protocols(gstElementFactory));
	}
	
	/**
	 * Create a new element of the type defined by the given elementfactory.
	 * It will be given the name supplied, since all elements require a name as
	 * their first argument.
	 * Params:
	 * name =  name of new element
	 * Returns: new GstElement or NULL if the element couldn't be created
	 */
	public Element create(string name)
	{
		// GstElement* gst_element_factory_create (GstElementFactory *factory,  const gchar *name);
		auto p = gst_element_factory_create(gstElementFactory, Str.toStringz(name));
		if(p is null)
		{
			return null;
		}
		return new Element(cast(GstElement*) p);
	}
	
	/**
	 * Create a new element of the type defined by the given element factory.
	 * If name is NULL, then the element will receive a guaranteed unique name,
	 * consisting of the element factory name and a number.
	 * If name is given, it will be given the name supplied.
	 * Params:
	 * factoryname =  a named factory to instantiate
	 * name =  name of new element
	 * Returns: new GstElement or NULL if unable to create element
	 */
	public static Element make(string factoryname, string name)
	{
		// GstElement* gst_element_factory_make (const gchar *factoryname,  const gchar *name);
		auto p = gst_element_factory_make(Str.toStringz(factoryname), Str.toStringz(name));
		if(p is null)
		{
			return null;
		}
		return new Element(cast(GstElement*) p);
	}
	
	/**
	 * Checks if the factory can sink the given capability.
	 * Params:
	 * caps =  the caps to check
	 * Returns: true if it can sink the capabilities
	 */
	public int canSinkCaps(Caps caps)
	{
		// gboolean gst_element_factory_can_sink_caps  (GstElementFactory *factory,  const GstCaps *caps);
		return gst_element_factory_can_sink_caps(gstElementFactory, (caps is null) ? null : caps.getCapsStruct());
	}
	
	/**
	 * Checks if the factory can source the given capability.
	 * Params:
	 * caps =  the caps to check
	 * Returns: true if it can src the capabilities
	 */
	public int canSrcCaps(Caps caps)
	{
		// gboolean gst_element_factory_can_src_caps  (GstElementFactory *factory,  const GstCaps *caps);
		return gst_element_factory_can_src_caps(gstElementFactory, (caps is null) ? null : caps.getCapsStruct());
	}
	
	/**
	 * Gets the GList of GstStaticPadTemplate for this factory.
	 * Returns: the padtemplates
	 */
	public ListG getStaticPadTemplates()
	{
		// const GList* gst_element_factory_get_static_pad_templates  (GstElementFactory *factory);
		auto p = gst_element_factory_get_static_pad_templates(gstElementFactory);
		if(p is null)
		{
			return null;
		}
		return new ListG(cast(GList*) p);
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gstreamer");
        } else version (DigitalMars) {
            pragma(link, "DD-gstreamer");
        } else {
            pragma(link, "DO-gstreamer");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gstreamer");
        } else version (DigitalMars) {
            pragma(link, "DD-gstreamer");
        } else {
            pragma(link, "DO-gstreamer");
        }
    }
}
