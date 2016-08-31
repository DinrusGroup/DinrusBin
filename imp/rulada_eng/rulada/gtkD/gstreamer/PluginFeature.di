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
 * inFile  = GstPluginFeature.html
 * outPack = gstreamer
 * outFile = PluginFeature
 * strct   = GstPluginFeature
 * realStrct=
 * ctorStrct=
 * clss    = PluginFeature
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gst_plugin_feature_
 * 	- gst_
 * omit structs:
 * omit prefixes:
 * omit code:
 * 	- gst_plugin_feature_set_name
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ListG
 * structWrap:
 * 	- GList* -> ListG
 * 	- GstPluginFeature* -> PluginFeature
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gstreamer.PluginFeature;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;



private import gtkD.gstreamer.ObjectGst;

/**
 * Description
 * This is a base class for anything that can be added to a GstPlugin.
 */
public class PluginFeature : ObjectGst
{
	
	/** the main Gtk struct */
	protected GstPluginFeature* gstPluginFeature;
	
	
	public GstPluginFeature* getPluginFeatureStruct()
	{
		return gstPluginFeature;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gstPluginFeature;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstPluginFeature* gstPluginFeature)
	{
		if(gstPluginFeature is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gstPluginFeature);
		if( ptr !is null )
		{
			this = cast(PluginFeature)ptr;
			return;
		}
		super(cast(GstObject*)gstPluginFeature);
		this.gstPluginFeature = gstPluginFeature;
	}
	
	/**
	 * Sets the name of a plugin feature. The name uniquely identifies a feature
	 * within all features of the same type. Renaming a plugin feature is not
	 * allowed. A copy is made of the name so you should free the supplied name
	 * after calling this function.
	 * Params:
	 *  name = the name to set
	 */
	public void setFeatureName(string name)
	{
		// void gst_plugin_feature_set_name (GstPluginFeature *feature,  const gchar *name);
		gst_plugin_feature_set_name(gstPluginFeature, Str.toStringz(name));
	}
	
	/**
	 */
	
	/**
	 * Compares type and name of plugin feature. Can be used with gst_filter_run().
	 * Params:
	 * data =  the type and name to check against
	 * Returns: TRUE if equal.
	 */
	public int typeNameFilter(GstTypeNameData* data)
	{
		// gboolean gst_plugin_feature_type_name_filter  (GstPluginFeature *feature,  GstTypeNameData *data);
		return gst_plugin_feature_type_name_filter(gstPluginFeature, data);
	}
	
	/**
	 * Specifies a rank for a plugin feature, so that autoplugging uses
	 * the most appropriate feature.
	 * Params:
	 * rank =  rank value - higher number means more priority rank
	 */
	public void setRank(uint rank)
	{
		// void gst_plugin_feature_set_rank (GstPluginFeature *feature,  guint rank);
		gst_plugin_feature_set_rank(gstPluginFeature, rank);
	}
	
	/**
	 * Gets the rank of a plugin feature.
	 * Returns: The rank of the feature
	 */
	public uint getRank()
	{
		// guint gst_plugin_feature_get_rank (GstPluginFeature *feature);
		return gst_plugin_feature_get_rank(gstPluginFeature);
	}
	
	/**
	 * Gets the name of a plugin feature.
	 * Returns: the name
	 */
	public string getName()
	{
		// const gchar* gst_plugin_feature_get_name (GstPluginFeature *feature);
		return Str.toString(gst_plugin_feature_get_name(gstPluginFeature));
	}
	
	/**
	 * Loads the plugin containing feature if it's not already loaded. feature is
	 * unaffected; use the return value instead.
	 * Returns: A reference to the loaded feature, or NULL on error.
	 */
	public PluginFeature load()
	{
		// GstPluginFeature* gst_plugin_feature_load (GstPluginFeature *feature);
		auto p = gst_plugin_feature_load(gstPluginFeature);
		if(p is null)
		{
			return null;
		}
		return new PluginFeature(cast(GstPluginFeature*) p);
	}
	
	/**
	 * Unrefs each member of list, then frees the list.
	 * Params:
	 * list =  list of GstPluginFeature
	 */
	public static void listFree(ListG list)
	{
		// void gst_plugin_feature_list_free (GList *list);
		gst_plugin_feature_list_free((list is null) ? null : list.getListGStruct());
	}
	
	/**
	 * Checks whether the given plugin feature is at least
	 *  the required version
	 * Params:
	 * minMajor =  minimum required major version
	 * minMinor =  minimum required minor version
	 * minMicro =  minimum required micro version
	 * Returns: TRUE if the plugin feature has at least the required version, otherwise FALSE.
	 */
	public int checkVersion(uint minMajor, uint minMinor, uint minMicro)
	{
		// gboolean gst_plugin_feature_check_version  (GstPluginFeature *feature,  guint min_major,  guint min_minor,  guint min_micro);
		return gst_plugin_feature_check_version(gstPluginFeature, minMajor, minMinor, minMicro);
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
