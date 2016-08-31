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
 * inFile  = GtkSettings.html
 * outPack = gtk
 * outFile = Settings
 * strct   = GtkSettings
 * realStrct=
 * ctorStrct=
 * clss    = Settings
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_settings_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gtk.Settings
 * 	- gtkD.gdk.Screen
 * 	- gtkD.gobject.ParamSpec
 * 	- gtkD.glib.StringG
 * 	- gtkD.gobject.Value
 * structWrap:
 * 	- GParamSpec* -> ParamSpec
 * 	- GString* -> StringG
 * 	- GValue* -> Value
 * 	- GdkScreen* -> Screen
 * 	- GtkSettings* -> Settings
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.Settings;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Settings;
private import gtkD.gdk.Screen;
private import gtkD.gobject.ParamSpec;
private import gtkD.glib.StringG;
private import gtkD.gobject.Value;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GtkSettings provide a mechanism to share global settings between applications.
 * On the X window system, this sharing is realized by an XSettings
 * manager that is usually part of the desktop environment, along with utilities
 * that let the user change these settings. In the absence of an Xsettings manager,
 * settings can also be specified in RC files.
 * Applications can override system-wide settings with gtk_settings_set_string_property(),
 * gtk_settings_set_long_property(), etc. This should be restricted to special
 * cases though; GtkSettings are not meant as an application configuration
 * facility. When doing so, you need to be aware that settings that are specific
 * to individual widgets may not be available before the widget type has been
 * realized at least once. The following example demonstrates a way to do this:
 *  gtk_init (argc, argv);
 *  /+* make sure the type is realized +/
 *  g_type_class_unref (g_type_class_ref (GTK_TYPE_IMAGE_MENU_ITEM));
 *  g_object_set (gtk_settings_get_default (), "gtk-menu-images", FALSE, NULL);
 * There is one GtkSettings instance per screen. It can be obtained with
 * gtk_settings_get_for_screen(), but in many cases, it is more convenient
 * to use gtk_widget_get_settings(). gtk_settings_get_default() returns the
 * GtkSettings instance for the default screen.
 */
public class Settings : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkSettings* gtkSettings;
	
	
	public GtkSettings* getSettingsStruct()
	{
		return gtkSettings;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkSettings;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSettings* gtkSettings)
	{
		if(gtkSettings is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkSettings);
		if( ptr !is null )
		{
			this = cast(Settings)ptr;
			return;
		}
		super(cast(GObject*)gtkSettings);
		this.gtkSettings = gtkSettings;
	}
	
	/**
	 */
	
	/**
	 * Gets the GtkSettings object for the default GDK screen, creating
	 * it if necessary. See gtk_settings_get_for_screen().
	 * Returns: a GtkSettings object. If there is no default screen, then returns NULL.
	 */
	public static Settings getDefault()
	{
		// GtkSettings* gtk_settings_get_default (void);
		auto p = gtk_settings_get_default();
		if(p is null)
		{
			return null;
		}
		return new Settings(cast(GtkSettings*) p);
	}
	
	/**
	 * Gets the GtkSettings object for screen, creating it if necessary.
	 * Since 2.2
	 * Params:
	 * screen =  a GdkScreen.
	 * Returns: a GtkSettings object.
	 */
	public static Settings getForScreen(Screen screen)
	{
		// GtkSettings* gtk_settings_get_for_screen (GdkScreen *screen);
		auto p = gtk_settings_get_for_screen((screen is null) ? null : screen.getScreenStruct());
		if(p is null)
		{
			return null;
		}
		return new Settings(cast(GtkSettings*) p);
	}
	
	/**
	 * Params:
	 */
	public static void installProperty(ParamSpec pspec)
	{
		// void gtk_settings_install_property (GParamSpec *pspec);
		gtk_settings_install_property((pspec is null) ? null : pspec.getParamSpecStruct());
	}
	
	/**
	 * Params:
	 */
	public static void installPropertyParser(ParamSpec pspec, GtkRcPropertyParser parser)
	{
		// void gtk_settings_install_property_parser  (GParamSpec *pspec,  GtkRcPropertyParser parser);
		gtk_settings_install_property_parser((pspec is null) ? null : pspec.getParamSpecStruct(), parser);
	}
	
	/**
	 * A GtkRcPropertyParser for use with gtk_settings_install_property_parser()
	 * or gtk_widget_class_install_style_property_parser() which parses a
	 * color given either by its name or in the form
	 * { red, green, blue } where red, green and
	 * blue are integers between 0 and 65535 or floating-point numbers
	 * between 0 and 1.
	 * Params:
	 * pspec =  a GParamSpec
	 * gstring =  the GString to be parsed
	 * propertyValue =  a GValue which must hold GdkColor values.
	 * Returns: TRUE if gstring could be parsed and property_valuehas been set to the resulting GdkColor.
	 */
	public static int rcPropertyParseColor(ParamSpec pspec, StringG gstring, Value propertyValue)
	{
		// gboolean gtk_rc_property_parse_color (const GParamSpec *pspec,  const GString *gstring,  GValue *property_value);
		return gtk_rc_property_parse_color((pspec is null) ? null : pspec.getParamSpecStruct(), (gstring is null) ? null : gstring.getStringGStruct(), (propertyValue is null) ? null : propertyValue.getValueStruct());
	}
	
	/**
	 * A GtkRcPropertyParser for use with gtk_settings_install_property_parser()
	 * or gtk_widget_class_install_style_property_parser() which parses a single
	 * enumeration value.
	 * The enumeration value can be specified by its name, its nickname or
	 * its numeric value. For consistency with flags parsing, the value
	 * may be surrounded by parentheses.
	 * Params:
	 * pspec =  a GParamSpec
	 * gstring =  the GString to be parsed
	 * propertyValue =  a GValue which must hold enum values.
	 * Returns: TRUE if gstring could be parsed and property_valuehas been set to the resulting GEnumValue.
	 */
	public static int rcPropertyParseEnum(ParamSpec pspec, StringG gstring, Value propertyValue)
	{
		// gboolean gtk_rc_property_parse_enum (const GParamSpec *pspec,  const GString *gstring,  GValue *property_value);
		return gtk_rc_property_parse_enum((pspec is null) ? null : pspec.getParamSpecStruct(), (gstring is null) ? null : gstring.getStringGStruct(), (propertyValue is null) ? null : propertyValue.getValueStruct());
	}
	
	/**
	 * A GtkRcPropertyParser for use with gtk_settings_install_property_parser()
	 * or gtk_widget_class_install_style_property_parser() which parses flags.
	 * Flags can be specified by their name, their nickname or
	 * numerically. Multiple flags can be specified in the form
	 * "( flag1 | flag2 | ... )".
	 * Params:
	 * pspec =  a GParamSpec
	 * gstring =  the GString to be parsed
	 * propertyValue =  a GValue which must hold flags values.
	 * Returns: TRUE if gstring could be parsed and property_valuehas been set to the resulting flags value.
	 */
	public static int rcPropertyParseFlags(ParamSpec pspec, StringG gstring, Value propertyValue)
	{
		// gboolean gtk_rc_property_parse_flags (const GParamSpec *pspec,  const GString *gstring,  GValue *property_value);
		return gtk_rc_property_parse_flags((pspec is null) ? null : pspec.getParamSpecStruct(), (gstring is null) ? null : gstring.getStringGStruct(), (propertyValue is null) ? null : propertyValue.getValueStruct());
	}
	
	/**
	 * A GtkRcPropertyParser for use with gtk_settings_install_property_parser()
	 * or gtk_widget_class_install_style_property_parser() which parses a
	 * requisition in the form
	 * "{ width, height }" for integers width and height.
	 * Params:
	 * pspec =  a GParamSpec
	 * gstring =  the GString to be parsed
	 * propertyValue =  a GValue which must hold boxed values.
	 * Returns: TRUE if gstring could be parsed and property_valuehas been set to the resulting GtkRequisition.
	 */
	public static int rcPropertyParseRequisition(ParamSpec pspec, StringG gstring, Value propertyValue)
	{
		// gboolean gtk_rc_property_parse_requisition (const GParamSpec *pspec,  const GString *gstring,  GValue *property_value);
		return gtk_rc_property_parse_requisition((pspec is null) ? null : pspec.getParamSpecStruct(), (gstring is null) ? null : gstring.getStringGStruct(), (propertyValue is null) ? null : propertyValue.getValueStruct());
	}
	
	/**
	 * A GtkRcPropertyParser for use with gtk_settings_install_property_parser()
	 * or gtk_widget_class_install_style_property_parser() which parses
	 * borders in the form
	 * "{ left, right, top, bottom }" for integers
	 * left, right, top and bottom.
	 * Params:
	 * pspec =  a GParamSpec
	 * gstring =  the GString to be parsed
	 * propertyValue =  a GValue which must hold boxed values.
	 * Returns: TRUE if gstring could be parsed and property_valuehas been set to the resulting GtkBorder.
	 */
	public static int rcPropertyParseBorder(ParamSpec pspec, StringG gstring, Value propertyValue)
	{
		// gboolean gtk_rc_property_parse_border (const GParamSpec *pspec,  const GString *gstring,  GValue *property_value);
		return gtk_rc_property_parse_border((pspec is null) ? null : pspec.getParamSpecStruct(), (gstring is null) ? null : gstring.getStringGStruct(), (propertyValue is null) ? null : propertyValue.getValueStruct());
	}
	
	/**
	 * Params:
	 */
	public void setPropertyValue(string name, GtkSettingsValue* svalue)
	{
		// void gtk_settings_set_property_value (GtkSettings *settings,  const gchar *name,  const GtkSettingsValue *svalue);
		gtk_settings_set_property_value(gtkSettings, Str.toStringz(name), svalue);
	}
	
	/**
	 * Params:
	 */
	public void setStringProperty(string name, string vString, string origin)
	{
		// void gtk_settings_set_string_property (GtkSettings *settings,  const gchar *name,  const gchar *v_string,  const gchar *origin);
		gtk_settings_set_string_property(gtkSettings, Str.toStringz(name), Str.toStringz(vString), Str.toStringz(origin));
	}
	
	/**
	 * Params:
	 */
	public void setLongProperty(string name, int vLong, string origin)
	{
		// void gtk_settings_set_long_property (GtkSettings *settings,  const gchar *name,  glong v_long,  const gchar *origin);
		gtk_settings_set_long_property(gtkSettings, Str.toStringz(name), vLong, Str.toStringz(origin));
	}
	
	/**
	 * Params:
	 */
	public void setDoubleProperty(string name, double vDouble, string origin)
	{
		// void gtk_settings_set_double_property (GtkSettings *settings,  const gchar *name,  gdouble v_double,  const gchar *origin);
		gtk_settings_set_double_property(gtkSettings, Str.toStringz(name), vDouble, Str.toStringz(origin));
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
