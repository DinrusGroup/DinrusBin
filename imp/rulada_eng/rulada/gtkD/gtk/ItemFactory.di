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
 * inFile  = GtkItemFactory.html
 * outPack = gtk
 * outFile = ItemFactory
 * strct   = GtkItemFactory
 * realStrct=
 * ctorStrct=
 * clss    = ItemFactory
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_item_factory_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * 	- gtk_item_factory_create_menu_entries
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gtk.AccelGroup
 * 	- gtkD.gtk.Widget
 * structWrap:
 * 	- GtkAccelGroup* -> AccelGroup
 * 	- GtkItemFactory* -> ItemFactory
 * 	- GtkWidget* -> Widget
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.ItemFactory;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.AccelGroup;
private import gtkD.gtk.Widget;



private import gtkD.gtk.ObjectGtk;

/**
 * Description
 * As of GTK+ 2.4, GtkItemFactory has been deprecated in favour of GtkUIManager.
 */
public class ItemFactory : ObjectGtk
{
	
	/** the main Gtk struct */
	protected GtkItemFactory* gtkItemFactory;
	
	
	public GtkItemFactory* getItemFactoryStruct()
	{
		return gtkItemFactory;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkItemFactory;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkItemFactory* gtkItemFactory)
	{
		if(gtkItemFactory is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkItemFactory);
		if( ptr !is null )
		{
			this = cast(ItemFactory)ptr;
			return;
		}
		super(cast(GtkObject*)gtkItemFactory);
		this.gtkItemFactory = gtkItemFactory;
	}
	
	/**
	 */
	
	/**
	 * Warning
	 * gtk_item_factory_new has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Creates a new GtkItemFactory.
	 * Beware that the returned object does not have a floating reference.
	 * Params:
	 * containerType =  the kind of menu to create; can be
	 *  GTK_TYPE_MENU_BAR, GTK_TYPE_MENU or GTK_TYPE_OPTION_MENU
	 * path =  the factory path of the new item factory, a string of the form
	 *  "<name>"
	 * accelGroup =  a GtkAccelGroup to which the accelerators for the
	 *  menu items will be added, or NULL to create a new one
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GType containerType, string path, AccelGroup accelGroup)
	{
		// GtkItemFactory* gtk_item_factory_new (GType container_type,  const gchar *path,  GtkAccelGroup *accel_group);
		auto p = gtk_item_factory_new(containerType, Str.toStringz(path), (accelGroup is null) ? null : accelGroup.getAccelGroupStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_item_factory_new(containerType, Str.toStringz(path), (accelGroup is null) ? null : accelGroup.getAccelGroupStruct())");
		}
		this(cast(GtkItemFactory*) p);
	}
	
	/**
	 * Warning
	 * gtk_item_factory_construct has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Initializes an item factory.
	 * Params:
	 * containerType =  the kind of menu to create; can be
	 *  GTK_TYPE_MENU_BAR, GTK_TYPE_MENU or GTK_TYPE_OPTION_MENU
	 * path =  the factory path of ifactory, a string of the form
	 *  "<name>"
	 * accelGroup =  a GtkAccelGroup to which the accelerators for the
	 *  menu items will be added, or NULL to create a new one
	 */
	public void construct(GType containerType, string path, AccelGroup accelGroup)
	{
		// void gtk_item_factory_construct (GtkItemFactory *ifactory,  GType container_type,  const gchar *path,  GtkAccelGroup *accel_group);
		gtk_item_factory_construct(gtkItemFactory, containerType, Str.toStringz(path), (accelGroup is null) ? null : accelGroup.getAccelGroupStruct());
	}
	
	/**
	 * Warning
	 * gtk_item_factory_add_foreign has been deprecated since version 2.4 and should not be used in newly-written code. The recommended API for this purpose are the functions
	 * gtk_menu_item_set_accel_path() and gtk_widget_set_accel_path(); don't
	 * use gtk_item_factory_add_foreign() in new code, since it is likely to
	 * be removed in the future.
	 * Installs an accelerator for accel_widget in accel_group, that causes
	 * the ::activate signal to be emitted if the accelerator is activated.
	 * This function can be used to make widgets participate in the accel
	 * saving/restoring functionality provided by gtk_accel_map_save() and
	 * gtk_accel_map_load(), even if they haven't been created by an item
	 * factory.
	 * Params:
	 * accelWidget =  widget to install an accelerator on
	 * fullPath = 	 the full path for the accel_widget
	 * accelGroup =  the accelerator group to install the accelerator in
	 * keyval =  key value of the accelerator
	 * modifiers =  modifier combination of the accelerator
	 */
	public static void addForeign(Widget accelWidget, string fullPath, AccelGroup accelGroup, uint keyval, GdkModifierType modifiers)
	{
		// void gtk_item_factory_add_foreign (GtkWidget *accel_widget,  const gchar *full_path,  GtkAccelGroup *accel_group,  guint keyval,  GdkModifierType modifiers);
		gtk_item_factory_add_foreign((accelWidget is null) ? null : accelWidget.getWidgetStruct(), Str.toStringz(fullPath), (accelGroup is null) ? null : accelGroup.getAccelGroupStruct(), keyval, modifiers);
	}
	
	/**
	 * Warning
	 * gtk_item_factory_from_widget has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Obtains the item factory from which a widget was created.
	 * Params:
	 * widget =  a widget
	 * Returns: the item factory from which widget was created, or NULL
	 */
	public static ItemFactory fromWidget(Widget widget)
	{
		// GtkItemFactory* gtk_item_factory_from_widget (GtkWidget *widget);
		auto p = gtk_item_factory_from_widget((widget is null) ? null : widget.getWidgetStruct());
		if(p is null)
		{
			return null;
		}
		return new ItemFactory(cast(GtkItemFactory*) p);
	}
	
	/**
	 * Warning
	 * gtk_item_factory_path_from_widget has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * If widget has been created by an item factory, returns the full path
	 * to it. (The full path of a widget is the concatenation of the factory
	 * path specified in gtk_item_factory_new() with the path specified in the
	 * GtkItemFactoryEntry from which the widget was created.)
	 * Params:
	 * widget =  a widget
	 * Returns: the full path to widget if it has been created by an item factory, NULL otherwise. This value is owned by GTK+ and must not be modified or freed.
	 */
	public static string pathFromWidget(Widget widget)
	{
		// const gchar* gtk_item_factory_path_from_widget (GtkWidget *widget);
		return Str.toString(gtk_item_factory_path_from_widget((widget is null) ? null : widget.getWidgetStruct()));
	}
	
	/**
	 * Warning
	 * gtk_item_factory_get_item has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Obtains the menu item which corresponds to path.
	 * If the widget corresponding to path is a menu item which opens a
	 * submenu, then the item is returned. If you are interested in the submenu,
	 * use gtk_item_factory_get_widget() instead.
	 * Params:
	 * path =  the path to the menu item
	 * Returns: the menu item for the given path, or NULL if path doesn't lead to a menu item
	 */
	public Widget getItem(string path)
	{
		// GtkWidget* gtk_item_factory_get_item (GtkItemFactory *ifactory,  const gchar *path);
		auto p = gtk_item_factory_get_item(gtkItemFactory, Str.toStringz(path));
		if(p is null)
		{
			return null;
		}
		return new Widget(cast(GtkWidget*) p);
	}
	
	/**
	 * Warning
	 * gtk_item_factory_get_widget has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Obtains the widget which corresponds to path.
	 * If the widget corresponding to path is a menu item which opens a
	 * submenu, then the submenu is returned. If you are interested in the menu
	 * item, use gtk_item_factory_get_item() instead.
	 * Params:
	 * path =  the path to the widget
	 * Returns: the widget for the given path, or NULL if path doesn't lead to a widget
	 */
	public Widget getWidget(string path)
	{
		// GtkWidget* gtk_item_factory_get_widget (GtkItemFactory *ifactory,  const gchar *path);
		auto p = gtk_item_factory_get_widget(gtkItemFactory, Str.toStringz(path));
		if(p is null)
		{
			return null;
		}
		return new Widget(cast(GtkWidget*) p);
	}
	
	/**
	 * Warning
	 * gtk_item_factory_get_widget_by_action has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Obtains the widget which was constructed from the GtkItemFactoryEntry
	 * with the given action.
	 * If there are multiple items with the same action, the result is
	 * undefined.
	 * Params:
	 * action =  an action as specified in the callback_action field
	 *  of GtkItemFactoryEntry
	 * Returns: the widget which corresponds to the given action, or NULL if no widget was found
	 */
	public Widget getWidgetByAction(uint action)
	{
		// GtkWidget* gtk_item_factory_get_widget_by_action  (GtkItemFactory *ifactory,  guint action);
		auto p = gtk_item_factory_get_widget_by_action(gtkItemFactory, action);
		if(p is null)
		{
			return null;
		}
		return new Widget(cast(GtkWidget*) p);
	}
	
	/**
	 * Warning
	 * gtk_item_factory_get_item_by_action has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Obtains the menu item which was constructed from the first
	 * GtkItemFactoryEntry with the given action.
	 * Params:
	 * action =  an action as specified in the callback_action field
	 *  of GtkItemFactoryEntry
	 * Returns: the menu item which corresponds to the given action, or NULL if no menu item was found
	 */
	public Widget getItemByAction(uint action)
	{
		// GtkWidget* gtk_item_factory_get_item_by_action (GtkItemFactory *ifactory,  guint action);
		auto p = gtk_item_factory_get_item_by_action(gtkItemFactory, action);
		if(p is null)
		{
			return null;
		}
		return new Widget(cast(GtkWidget*) p);
	}
	
	/**
	 * Warning
	 * gtk_item_factory_create_item has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Creates an item for entry.
	 * Params:
	 * entry =  the GtkItemFactoryEntry to create an item for
	 * callbackData =  data passed to the callback function of entry
	 * callbackType =  1 if the callback function of entry is of type
	 *  GtkItemFactoryCallback1, 2 if it is of type GtkItemFactoryCallback2
	 */
	public void createItem(GtkItemFactoryEntry* entry, void* callbackData, uint callbackType)
	{
		// void gtk_item_factory_create_item (GtkItemFactory *ifactory,  GtkItemFactoryEntry *entry,  gpointer callback_data,  guint callback_type);
		gtk_item_factory_create_item(gtkItemFactory, entry, callbackData, callbackType);
	}
	
	/**
	 * Warning
	 * gtk_item_factory_create_items has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Creates the menu items from the entries.
	 * Params:
	 * nEntries =  the length of entries
	 * entries =  an array of GtkItemFactoryEntrys whose callback members
	 *  must by of type GtkItemFactoryCallback1
	 * callbackData =  data passed to the callback functions of all entries
	 */
	public void createItems(uint nEntries, GtkItemFactoryEntry* entries, void* callbackData)
	{
		// void gtk_item_factory_create_items (GtkItemFactory *ifactory,  guint n_entries,  GtkItemFactoryEntry *entries,  gpointer callback_data);
		gtk_item_factory_create_items(gtkItemFactory, nEntries, entries, callbackData);
	}
	
	/**
	 * Warning
	 * gtk_item_factory_create_items_ac has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Creates the menu items from the entries.
	 * Params:
	 * nEntries =  the length of entries
	 * entries =  an array of GtkItemFactoryEntrys
	 * callbackData =  data passed to the callback functions of all entries
	 * callbackType =  1 if the callback functions in entries are of type
	 *  GtkItemFactoryCallback1, 2 if they are of type GtkItemFactoryCallback2
	 */
	public void createItemsAc(uint nEntries, GtkItemFactoryEntry* entries, void* callbackData, uint callbackType)
	{
		// void gtk_item_factory_create_items_ac (GtkItemFactory *ifactory,  guint n_entries,  GtkItemFactoryEntry *entries,  gpointer callback_data,  guint callback_type);
		gtk_item_factory_create_items_ac(gtkItemFactory, nEntries, entries, callbackData, callbackType);
	}
	
	/**
	 * Warning
	 * gtk_item_factory_delete_item has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Deletes the menu item which was created for path by the given
	 * item factory.
	 * Params:
	 * path =  a path
	 */
	public void deleteItem(string path)
	{
		// void gtk_item_factory_delete_item (GtkItemFactory *ifactory,  const gchar *path);
		gtk_item_factory_delete_item(gtkItemFactory, Str.toStringz(path));
	}
	
	/**
	 * Warning
	 * gtk_item_factory_delete_entry has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Deletes the menu item which was created from entry by the given
	 * item factory.
	 * Params:
	 * entry =  a GtkItemFactoryEntry
	 */
	public void deleteEntry(GtkItemFactoryEntry* entry)
	{
		// void gtk_item_factory_delete_entry (GtkItemFactory *ifactory,  GtkItemFactoryEntry *entry);
		gtk_item_factory_delete_entry(gtkItemFactory, entry);
	}
	
	/**
	 * Warning
	 * gtk_item_factory_delete_entries has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Deletes the menu items which were created from the entries by the given
	 * item factory.
	 * Params:
	 * nEntries =  the length of entries
	 * entries =  an array of GtkItemFactoryEntrys
	 */
	public void deleteEntries(uint nEntries, GtkItemFactoryEntry* entries)
	{
		// void gtk_item_factory_delete_entries (GtkItemFactory *ifactory,  guint n_entries,  GtkItemFactoryEntry *entries);
		gtk_item_factory_delete_entries(gtkItemFactory, nEntries, entries);
	}
	
	/**
	 * Warning
	 * gtk_item_factory_popup has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Pops up the menu constructed from the item factory at (x, y).
	 * The mouse_button parameter should be the mouse button pressed to initiate
	 * the menu popup. If the menu popup was initiated by something other than
	 * a mouse button press, such as a mouse button release or a keypress,
	 * mouse_button should be 0.
	 * The time_ parameter should be the time stamp of the event that
	 * initiated the popup. If such an event is not available, use
	 * gtk_get_current_event_time() instead.
	 * The operation of the mouse_button and the time_ parameter is the same
	 * as the button and activation_time parameters for gtk_menu_popup().
	 * Params:
	 * x =  the x position
	 * y =  the y position
	 * mouseButton =  the mouse button which was pressed to initiate the popup
	 * time =  the time at which the activation event occurred
	 */
	public void popup(uint x, uint y, uint mouseButton, uint time)
	{
		// void gtk_item_factory_popup (GtkItemFactory *ifactory,  guint x,  guint y,  guint mouse_button,  guint32 time_);
		gtk_item_factory_popup(gtkItemFactory, x, y, mouseButton, time);
	}
	
	/**
	 * Warning
	 * gtk_item_factory_popup_with_data has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Pops up the menu constructed from the item factory at (x, y). Callbacks
	 * can access the popup_data while the menu is posted via
	 * gtk_item_factory_popup_data() and gtk_item_factory_popup_data_from_widget().
	 * The mouse_button parameter should be the mouse button pressed to initiate
	 * the menu popup. If the menu popup was initiated by something other than
	 * a mouse button press, such as a mouse button release or a keypress,
	 * mouse_button should be 0.
	 * The time_ parameter should be the time stamp of the event that
	 * initiated the popup. If such an event is not available, use
	 * gtk_get_current_event_time() instead.
	 * The operation of the mouse_button and the time_ parameters is the same
	 * as the button and activation_time parameters for gtk_menu_popup().
	 * Params:
	 * popupData =  data available for callbacks while the menu is posted
	 * destroy =  a GDestroyNotify function to be called on popup_data when
	 *  the menu is unposted
	 * x =  the x position
	 * y =  the y position
	 * mouseButton =  the mouse button which was pressed to initiate the popup
	 * time =  the time at which the activation event occurred
	 */
	public void popupWithData(void* popupData, GDestroyNotify destroy, uint x, uint y, uint mouseButton, uint time)
	{
		// void gtk_item_factory_popup_with_data (GtkItemFactory *ifactory,  gpointer popup_data,  GDestroyNotify destroy,  guint x,  guint y,  guint mouse_button,  guint32 time_);
		gtk_item_factory_popup_with_data(gtkItemFactory, popupData, destroy, x, y, mouseButton, time);
	}
	
	/**
	 * Warning
	 * gtk_item_factory_popup_data has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Obtains the popup_data which was passed to
	 * gtk_item_factory_popup_with_data(). This data is available until the menu
	 * is popped down again.
	 * Returns: popup_data associated with ifactory
	 */
	public void* popupData()
	{
		// gpointer gtk_item_factory_popup_data (GtkItemFactory *ifactory);
		return gtk_item_factory_popup_data(gtkItemFactory);
	}
	
	/**
	 * Warning
	 * gtk_item_factory_popup_data_from_widget has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Obtains the popup_data which was passed to
	 * gtk_item_factory_popup_with_data(). This data is available until the menu
	 * is popped down again.
	 * Params:
	 * widget =  a widget
	 * Returns: popup_data associated with the item factory from which widget was created, or NULL if widget wasn't created by an item factory
	 */
	public static void* popupDataFromWidget(Widget widget)
	{
		// gpointer gtk_item_factory_popup_data_from_widget  (GtkWidget *widget);
		return gtk_item_factory_popup_data_from_widget((widget is null) ? null : widget.getWidgetStruct());
	}
	
	/**
	 * Warning
	 * gtk_item_factory_from_path has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Finds an item factory which has been constructed using the
	 * "<name>" prefix of path as the path argument
	 * for gtk_item_factory_new().
	 * Params:
	 * path =  a string starting with a factory path of the form
	 *  "<name>"
	 * Returns: the GtkItemFactory created for the given factory path, or NULL
	 */
	public static ItemFactory fromPath(string path)
	{
		// GtkItemFactory* gtk_item_factory_from_path (const gchar *path);
		auto p = gtk_item_factory_from_path(Str.toStringz(path));
		if(p is null)
		{
			return null;
		}
		return new ItemFactory(cast(GtkItemFactory*) p);
	}
	
	/**
	 * Warning
	 * gtk_item_factories_path_delete has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Deletes all widgets constructed from the specified path.
	 * Params:
	 * ifactoryPath =  a factory path to prepend to path. May be NULL if path
	 *  starts with a factory path
	 * path =  a path
	 */
	public static void itemFactoriesPathDelete(string ifactoryPath, string path)
	{
		// void gtk_item_factories_path_delete (const gchar *ifactory_path,  const gchar *path);
		gtk_item_factories_path_delete(Str.toStringz(ifactoryPath), Str.toStringz(path));
	}
	
	/**
	 * Warning
	 * gtk_item_factory_set_translate_func has been deprecated since version 2.4 and should not be used in newly-written code. Use GtkUIManager instead.
	 * Sets a function to be used for translating the path elements before they
	 * are displayed.
	 * Params:
	 * func =  the GtkTranslateFunc function to be used to translate path elements
	 * data =  data to pass to func and notify
	 * notify =  a GDestroyNotify function to be called when ifactory is
	 *  destroyed and when the translation function is changed again
	 */
	public void setTranslateFunc(GtkTranslateFunc func, void* data, GDestroyNotify notify)
	{
		// void gtk_item_factory_set_translate_func (GtkItemFactory *ifactory,  GtkTranslateFunc func,  gpointer data,  GDestroyNotify notify);
		gtk_item_factory_set_translate_func(gtkItemFactory, func, data, notify);
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
