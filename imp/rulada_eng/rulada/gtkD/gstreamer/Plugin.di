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
 * inFile  = GstPlugin.html
 * outPack = gstreamer
 * outFile = Plugin
 * strct   = GstPlugin
 * realStrct=
 * ctorStrct=
 * clss    = Plugin
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gst_plugin_
 * 	- gst_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.Module
 * 	- gtkD.glib.ErrorG
 * 	- gtkD.glib.ListG
 * structWrap:
 * 	- GList* -> ListG
 * 	- GModule* -> Module
 * 	- GstPlugin* -> Plugin
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gstreamer.Plugin;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.Module;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.glib.ListG;



private import gtkD.gstreamer.ObjectGst;

/**
 * Description
 * GStreamer is extensible, so GstElement instances can be loaded at runtime.
 * A plugin system can provide one or more of the basic
 * GStreamer GstPluginFeature subclasses.
 * A plugin should export a symbol plugin_desc that is a
 * struct of type GstPluginDesc.
 * the plugin loader will check the version of the core library the plugin was
 * linked against and will create a new GstPlugin. It will then call the
 * GstPluginInitFunc function that was provided in the plugin_desc.
 * Once you have a handle to a GstPlugin (e.g. from the GstRegistryPool), you
 * can add any object that subclasses GstPluginFeature.
 * Use gst_plugin_find_feature() and gst_plugin_get_feature_list() to find
 * features in a plugin.
 * Usually plugins are always automaticlly loaded so you don't need to call
 * gst_plugin_load() explicitly to bring it into memory. There are options to
 * statically link plugins to an app or even use GStreamer without a plugin
 * repository in which case gst_plugin_load() can be needed to bring the plugin
 * into memory.
 */
public class Plugin : ObjectGst
{
	
	/** the main Gtk struct */
	protected GstPlugin* gstPlugin;
	
	
	public GstPlugin* getPluginStruct()
	{
		return gstPlugin;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gstPlugin;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstPlugin* gstPlugin)
	{
		if(gstPlugin is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gstPlugin);
		if( ptr !is null )
		{
			this = cast(Plugin)ptr;
			return;
		}
		super(cast(GstObject*)gstPlugin);
		this.gstPlugin = gstPlugin;
	}
	
	/**
	 */
	
	/**
	 * Get the error quark.
	 * Returns: The error quark used in GError messages
	 */
	public static GQuark errorQuark()
	{
		// GQuark gst_plugin_error_quark (void);
		return gst_plugin_error_quark();
	}
	
	/**
	 * Get the short name of the plugin
	 * Returns: the name of the plugin
	 */
	public string getName()
	{
		// const gchar* gst_plugin_get_name (GstPlugin *plugin);
		return Str.toString(gst_plugin_get_name(gstPlugin));
	}
	
	/**
	 * Get the long descriptive name of the plugin
	 * Returns: the long name of the plugin
	 */
	public string getDescription()
	{
		// const gchar* gst_plugin_get_description (GstPlugin *plugin);
		return Str.toString(gst_plugin_get_description(gstPlugin));
	}
	
	/**
	 * get the filename of the plugin
	 * Returns: the filename of the plugin
	 */
	public string getFilename()
	{
		// const gchar* gst_plugin_get_filename (GstPlugin *plugin);
		return Str.toString(gst_plugin_get_filename(gstPlugin));
	}
	
	/**
	 * get the license of the plugin
	 * Returns: the license of the plugin
	 */
	public string getLicense()
	{
		// const gchar* gst_plugin_get_license (GstPlugin *plugin);
		return Str.toString(gst_plugin_get_license(gstPlugin));
	}
	
	/**
	 * get the package the plugin belongs to.
	 * Returns: the package of the plugin
	 */
	public string getPackage()
	{
		// const gchar* gst_plugin_get_package (GstPlugin *plugin);
		return Str.toString(gst_plugin_get_package(gstPlugin));
	}
	
	/**
	 * get the URL where the plugin comes from
	 * Returns: the origin of the plugin
	 */
	public string getOrigin()
	{
		// const gchar* gst_plugin_get_origin (GstPlugin *plugin);
		return Str.toString(gst_plugin_get_origin(gstPlugin));
	}
	
	/**
	 * get the source module the plugin belongs to.
	 * Returns: the source of the plugin
	 */
	public string getSource()
	{
		// const gchar* gst_plugin_get_source (GstPlugin *plugin);
		return Str.toString(gst_plugin_get_source(gstPlugin));
	}
	
	/**
	 * get the version of the plugin
	 * Returns: the version of the plugin
	 */
	public string getVersion()
	{
		// const gchar* gst_plugin_get_version (GstPlugin *plugin);
		return Str.toString(gst_plugin_get_version(gstPlugin));
	}
	
	/**
	 * Gets the GModule of the plugin. If the plugin isn't loaded yet, NULL is
	 * returned.
	 * Returns: module belonging to the plugin or NULL if the plugin isn't loaded yet.
	 */
	public Module getModule()
	{
		// GModule* gst_plugin_get_module (GstPlugin *plugin);
		auto p = gst_plugin_get_module(gstPlugin);
		if(p is null)
		{
			return null;
		}
		return new Module(cast(GModule*) p);
	}
	
	/**
	 * queries if the plugin is loaded into memory
	 * Returns: TRUE is loaded, FALSE otherwise
	 */
	public int isLoaded()
	{
		// gboolean gst_plugin_is_loaded (GstPlugin *plugin);
		return gst_plugin_is_loaded(gstPlugin);
	}
	
	/**
	 * A standard filter that returns TRUE when the plugin is of the
	 * given name.
	 * Params:
	 * name =  the name of the plugin
	 * Returns: TRUE if the plugin is of the given name.
	 */
	public int nameFilter(string name)
	{
		// gboolean gst_plugin_name_filter (GstPlugin *plugin,  const gchar *name);
		return gst_plugin_name_filter(gstPlugin, Str.toStringz(name));
	}
	
	/**
	 * Loads the given plugin and refs it. Caller needs to unref after use.
	 * Params:
	 * filename =  the plugin filename to load
	 * Returns: a reference to the existing loaded GstPlugin, a reference to thenewly-loaded GstPlugin, or NULL if an error occurred.
	 * Throws: GException on failure.
	 */
	public static Plugin loadFile(string filename)
	{
		// GstPlugin* gst_plugin_load_file (const gchar *filename,  GError **error);
		GError* err = null;
		
		auto p = gst_plugin_load_file(Str.toStringz(filename), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		if(p is null)
		{
			return null;
		}
		return new Plugin(cast(GstPlugin*) p);
	}
	
	/**
	 * Loads plugin. Note that the *return value* is the loaded plugin; plugin is
	 * Returns: A reference to a loaded plugin, or NULL on error.
	 */
	public Plugin load()
	{
		// GstPlugin* gst_plugin_load (GstPlugin *plugin);
		auto p = gst_plugin_load(gstPlugin);
		if(p is null)
		{
			return null;
		}
		return new Plugin(cast(GstPlugin*) p);
	}
	
	/**
	 * Load the named plugin. Refs the plugin.
	 * Params:
	 * name =  name of plugin to load
	 * Returns: A reference to a loaded plugin, or NULL on error.
	 */
	public static Plugin loadByName(string name)
	{
		// GstPlugin* gst_plugin_load_by_name (const gchar *name);
		auto p = gst_plugin_load_by_name(Str.toStringz(name));
		if(p is null)
		{
			return null;
		}
		return new Plugin(cast(GstPlugin*) p);
	}
	
	/**
	 * Unrefs each member of list, then frees the list.
	 * Params:
	 * list =  list of GstPlugin
	 */
	public static void listFree(ListG list)
	{
		// void gst_plugin_list_free (GList *list);
		gst_plugin_list_free((list is null) ? null : list.getListGStruct());
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
