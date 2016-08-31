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
 * inFile  = gtk-gtkbuildable.html
 * outPack = gtk
 * outFile = BuildableT
 * strct   = GtkBuildable
 * realStrct=
 * ctorStrct=
 * clss    = BuildableT
 * interf  = BuildableIF
 * class Code: No
 * interface Code: No
 * template for:
 * 	- TStruct
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_buildable_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gobject.ObjectG
 * 	- gtkD.gobject.Value
 * 	- gtkD.gtk.Builder
 * structWrap:
 * 	- GObject* -> ObjectG
 * 	- GValue* -> Value
 * 	- GtkBuilder* -> Builder
 * module aliases:
 * local aliases:
 * 	- getName -> buildableGetName
 * 	- setName -> buildableSetName
 * overrides:
 */

module gtkD.gtk.BuildableT;

public  import gtkD.gtkc.gtktypes;

public import gtkD.gtkc.gtk;
public import gtkD.glib.ConstructionException;


public import gtkD.glib.Str;
public import gtkD.gobject.ObjectG;
public import gtkD.gobject.Value;
public import gtkD.gtk.Builder;




/**
 * Description
 * In order to allow construction from a GtkBuilder
 * UI description, an object class must implement the
 * GtkBuildable interface. The interface includes methods for setting
 * names and properties of objects, parsing custom tags, constructing
 * child objects.
 * The GtkBuildable interface is implemented by all widgets and
 * many of the non-widget objects that are provided by GTK+. The
 * main user of this interface is GtkBuilder, there should be
 * very little need for applications to call any
 * gtk_buildable_... functions.
 */
public template BuildableT(TStruct)
{
	
	/** the main Gtk struct */
	protected GtkBuildable* gtkBuildable;
	
	
	public GtkBuildable* getBuildableTStruct()
	{
		return cast(GtkBuildable*)getStruct();
	}
	
	
	/**
	 */
	
	/**
	 * Sets the name of the buildable object.
	 * Since 2.12
	 * Params:
	 * name =  name to set
	 */
	public void buildableSetName(string name)
	{
		// void gtk_buildable_set_name (GtkBuildable *buildable,  const gchar *name);
		gtk_buildable_set_name(getBuildableTStruct(), Str.toStringz(name));
	}
	
	/**
	 * Gets the name of the buildable object.
	 * GtkBuilder sets the name based on the the
	 * GtkBuilder UI definition
	 * used to construct the buildable.
	 * Since 2.12
	 * Returns: the name set with gtk_buildable_set_name()
	 */
	public string buildableGetName()
	{
		// const gchar * gtk_buildable_get_name (GtkBuildable *buildable);
		return Str.toString(gtk_buildable_get_name(getBuildableTStruct()));
	}
	
	/**
	 * Adds a child to buildable. type is an optional string
	 * describing how the child should be added.
	 * Since 2.12
	 * Params:
	 * builder =  a GtkBuilder
	 * child =  child to add
	 * type =  kind of child or NULL
	 */
	public void addChild(Builder builder, ObjectG child, string type)
	{
		// void gtk_buildable_add_child (GtkBuildable *buildable,  GtkBuilder *builder,  GObject *child,  const gchar *type);
		gtk_buildable_add_child(getBuildableTStruct(), (builder is null) ? null : builder.getBuilderStruct(), (child is null) ? null : child.getObjectGStruct(), Str.toStringz(type));
	}
	
	/**
	 * Sets the property name name to value on the buildable object.
	 * Since 2.12
	 * Params:
	 * builder =  a GtkBuilder
	 * name =  name of property
	 * value =  value of property
	 */
	public void setBuildableProperty(Builder builder, string name, Value value)
	{
		// void gtk_buildable_set_buildable_property  (GtkBuildable *buildable,  GtkBuilder *builder,  const gchar *name,  const GValue *value);
		gtk_buildable_set_buildable_property(getBuildableTStruct(), (builder is null) ? null : builder.getBuilderStruct(), Str.toStringz(name), (value is null) ? null : value.getValueStruct());
	}
	
	/**
	 * Constructs a child of buildable with the name name.
	 * GtkBuilder calls this function if a "constructor" has been
	 * specified in the UI definition.
	 * Since 2.12
	 * Params:
	 * builder =  GtkBuilder used to construct this object
	 * name =  name of child to construct
	 * Returns: the constructed child
	 */
	public ObjectG constructChild(Builder builder, string name)
	{
		// GObject * gtk_buildable_construct_child (GtkBuildable *buildable,  GtkBuilder *builder,  const gchar *name);
		auto p = gtk_buildable_construct_child(getBuildableTStruct(), (builder is null) ? null : builder.getBuilderStruct(), Str.toStringz(name));
		if(p is null)
		{
			return null;
		}
		return new ObjectG(cast(GObject*) p);
	}
	
	/**
	 * This is called for each unknown element under <child>.
	 * Since 2.12
	 * Params:
	 * builder =  a GtkBuilder used to construct this object
	 * child =  child object or NULL for non-child tags
	 * tagname =  name of tag
	 * parser =  a GMarkupParser structure to fill in
	 * data =  return location for user data that will be passed in
	 *  to parser functions
	 * Returns: TRUE if a object has a custom implementation, FALSE if it doesn't.
	 */
	public int customTagStart(Builder builder, ObjectG child, string tagname, GMarkupParser* parser, void** data)
	{
		// gboolean gtk_buildable_custom_tag_start (GtkBuildable *buildable,  GtkBuilder *builder,  GObject *child,  const gchar *tagname,  GMarkupParser *parser,  gpointer *data);
		return gtk_buildable_custom_tag_start(getBuildableTStruct(), (builder is null) ? null : builder.getBuilderStruct(), (child is null) ? null : child.getObjectGStruct(), Str.toStringz(tagname), parser, data);
	}
	
	/**
	 * This is called at the end of each custom element handled by
	 * the buildable.
	 * Since 2.12
	 * Params:
	 * builder =  GtkBuilder used to construct this object
	 * child =  child object or NULL for non-child tags
	 * tagname =  name of tag
	 * data =  user data that will be passed in to parser functions
	 */
	public void customTagEnd(Builder builder, ObjectG child, string tagname, void** data)
	{
		// void gtk_buildable_custom_tag_end (GtkBuildable *buildable,  GtkBuilder *builder,  GObject *child,  const gchar *tagname,  gpointer *data);
		gtk_buildable_custom_tag_end(getBuildableTStruct(), (builder is null) ? null : builder.getBuilderStruct(), (child is null) ? null : child.getObjectGStruct(), Str.toStringz(tagname), data);
	}
	
	/**
	 * This is similar to gtk_buildable_parser_finished() but is
	 * called once for each custom tag handled by the buildable.
	 * Since 2.12
	 * Params:
	 * builder =  a GtkBuilder
	 * child =  child object or NULL for non-child tags
	 * tagname =  the name of the tag
	 * data =  user data created in custom_tag_start
	 */
	public void customFinished(Builder builder, ObjectG child, string tagname, void* data)
	{
		// void gtk_buildable_custom_finished (GtkBuildable *buildable,  GtkBuilder *builder,  GObject *child,  const gchar *tagname,  gpointer data);
		gtk_buildable_custom_finished(getBuildableTStruct(), (builder is null) ? null : builder.getBuilderStruct(), (child is null) ? null : child.getObjectGStruct(), Str.toStringz(tagname), data);
	}
	
	/**
	 * Called when the builder finishes the parsing of a
	 * GtkBuilder UI definition.
	 * Note that this will be called once for each time
	 * gtk_builder_add_from_file() or gtk_builder_add_from_string()
	 * is called on a builder.
	 * Since 2.12
	 * Params:
	 * builder =  a GtkBuilder
	 */
	public void parserFinished(Builder builder)
	{
		// void gtk_buildable_parser_finished (GtkBuildable *buildable,  GtkBuilder *builder);
		gtk_buildable_parser_finished(getBuildableTStruct(), (builder is null) ? null : builder.getBuilderStruct());
	}
	
	/**
	 * Get the internal child called childname of the buildable object.
	 * Since 2.12
	 * Params:
	 * builder =  a GtkBuilder
	 * childname =  name of child
	 * Returns: the internal child of the buildable object
	 */
	public ObjectG getInternalChild(Builder builder, string childname)
	{
		// GObject * gtk_buildable_get_internal_child (GtkBuildable *buildable,  GtkBuilder *builder,  const gchar *childname);
		auto p = gtk_buildable_get_internal_child(getBuildableTStruct(), (builder is null) ? null : builder.getBuilderStruct(), Str.toStringz(childname));
		if(p is null)
		{
			return null;
		}
		return new ObjectG(cast(GObject*) p);
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
