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
 * inFile  = GtkAction.html
 * outPack = gtk
 * outFile = Action
 * strct   = GtkAction
 * realStrct=
 * ctorStrct=
 * clss    = Action
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * 	- BuildableIF
 * prefixes:
 * 	- gtk_action_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * 	- gtk_action_get_stock_id
 * 	- gtk_action_set_stock_id
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gio.Icon
 * 	- gtkD.gio.IconIF
 * 	- gtkD.gtk.Widget
 * 	- gtkD.glib.ListSG
 * 	- gtkD.gobject.Closure
 * 	- gtkD.gtk.AccelGroup
 * 	- gtkD.gtk.BuildableIF
 * 	- gtkD.gtk.BuildableT
 * structWrap:
 * 	- GClosure* -> Closure
 * 	- GIcon* -> IconIF
 * 	- GSList* -> ListSG
 * 	- GtkAccelGroup* -> AccelGroup
 * 	- GtkWidget* -> Widget
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.Action;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gio.Icon;
private import gtkD.gio.IconIF;
private import gtkD.gtk.Widget;
private import gtkD.glib.ListSG;
private import gtkD.gobject.Closure;
private import gtkD.gtk.AccelGroup;
private import gtkD.gtk.BuildableIF;
private import gtkD.gtk.BuildableT;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * Actions represent operations that the user can be perform, along with
 * some information how it should be presented in the interface. Each action
 * provides methods to create icons, menu items and toolbar items representing
 * itself.
 * As well as the callback that is called when the action gets activated, the
 * following also gets associated with the action:
 * a name (not translated, for path lookup)
 * a label (translated, for display)
 * an accelerator
 * whether label indicates a stock id
 * a tooltip (optional, translated)
 * a toolbar label (optional, shorter than label)
 * The action will also have some state information:
 * visible (shown/hidden)
 * sensitive (enabled/disabled)
 * Apart from regular actions, there are toggle
 * actions, which can be toggled between two states and radio actions, of which only one in a group
 * can be in the "active" state. Other actions can be implemented as GtkAction
 * subclasses.
 * Each action can have one or more proxy menu item, toolbar button or
 * other proxy widgets. Proxies mirror the state of the action (text
 * label, tooltip, icon, visible, sensitive, etc), and should change when
 * the action's state changes. When the proxy is activated, it should
 * activate its action.
 */
public class Action : ObjectG, BuildableIF
{
	
	/** the main Gtk struct */
	protected GtkAction* gtkAction;
	
	
	public GtkAction* getActionStruct()
	{
		return gtkAction;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkAction;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkAction* gtkAction)
	{
		if(gtkAction is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkAction);
		if( ptr !is null )
		{
			this = cast(Action)ptr;
			return;
		}
		super(cast(GObject*)gtkAction);
		this.gtkAction = gtkAction;
	}
	
	// add the Buildable capabilities
	mixin BuildableT!(GtkAction);
	
	/**
	 * Creates a new GtkAction object. To add the action to a
	 * GtkActionGroup and set the accelerator for the action,
	 * call gtk_action_group_add_action_with_accel().
	 * See the section called UI Definitions for information on allowed action
	 * names.
	 * Since 2.4
	 * Params:
	 * name =  A unique name for the action
	 * label =  the label displayed in menu items and on buttons, or NULL
	 * tooltip =  a tooltip for the action, or NULL
	 * stockId =  the stock icon to display in widgets representing the
	 *  action.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, string label, string tooltip, StockID stockId)
	{
		this(name, label, tooltip, StockDesc[stockId]);
	}
	
	/**
	 * Gets the stock id of action.
	 * Since 2.16
	 * Returns: the stock id
	 */
	public StockID getStockId()
	{
		// const gchar * gtk_action_get_stock_id (GtkAction *action);
		string id = Str.toString(gtk_action_get_stock_id(gtkAction));
		
		foreach(i, desc; StockDesc)
		{
			if(desc == id)
			return cast(StockID)i;
		}
		
		return StockID.DISCARD;
	}
	
	/**
	 * Sets the stock id on action
	 * Since 2.16
	 * Params:
	 * stockId =  the stock id
	 */
	public void setStockId(StockID stockId)
	{
		// void gtk_action_set_stock_id (GtkAction *action,  const gchar *stock_id);
		gtk_action_set_stock_id(gtkAction, Str.toStringz(StockDesc[stockId]));
	}
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Action)[] onActivateListeners;
	/**
	 * The "activate" signal is emitted when the action is activated.
	 * Since 2.4
	 * See Also
	 * GtkActionGroup, GtkUIManager
	 */
	void addOnActivate(void delegate(Action) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		if ( !("activate" in connectedSignals) )
		{
			Signals.connectData(
			getStruct(),
			"activate",
			cast(GCallback)&callBackActivate,
			cast(void*)this,
			null,
			connectFlags);
			connectedSignals["activate"] = 1;
		}
		onActivateListeners ~= dlg;
	}
	extern(C) static void callBackActivate(GtkAction* actionStruct, Action action)
	{
		foreach ( void delegate(Action) dlg ; action.onActivateListeners )
		{
			dlg(action);
		}
	}
	
	
	/**
	 * Creates a new GtkAction object. To add the action to a
	 * GtkActionGroup and set the accelerator for the action,
	 * call gtk_action_group_add_action_with_accel().
	 * See the section called “UI Definitions” for information on allowed action
	 * names.
	 * Since 2.4
	 * Params:
	 * name =  A unique name for the action
	 * label =  the label displayed in menu items and on buttons, or NULL
	 * tooltip =  a tooltip for the action, or NULL
	 * stockId =  the stock icon to display in widgets representing the
	 *  action, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, string label, string tooltip, string stockId)
	{
		// GtkAction * gtk_action_new (const gchar *name,  const gchar *label,  const gchar *tooltip,  const gchar *stock_id);
		auto p = gtk_action_new(Str.toStringz(name), Str.toStringz(label), Str.toStringz(tooltip), Str.toStringz(stockId));
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_action_new(Str.toStringz(name), Str.toStringz(label), Str.toStringz(tooltip), Str.toStringz(stockId))");
		}
		this(cast(GtkAction*) p);
	}
	
	/**
	 * Returns the name of the action.
	 * Since 2.4
	 * Returns: the name of the action. The string belongs to GTK+ and should not be freed.
	 */
	public string getName()
	{
		// const gchar* gtk_action_get_name (GtkAction *action);
		return Str.toString(gtk_action_get_name(gtkAction));
	}
	
	/**
	 * Returns whether the action is effectively sensitive.
	 * Since 2.4
	 * Returns: TRUE if the action and its associated action group are both sensitive.
	 */
	public int isSensitive()
	{
		// gboolean gtk_action_is_sensitive (GtkAction *action);
		return gtk_action_is_sensitive(gtkAction);
	}
	
	/**
	 * Returns whether the action itself is sensitive. Note that this doesn't
	 * necessarily mean effective sensitivity. See gtk_action_is_sensitive()
	 * for that.
	 * Since 2.4
	 * Returns: TRUE if the action itself is sensitive.
	 */
	public int getSensitive()
	{
		// gboolean gtk_action_get_sensitive (GtkAction *action);
		return gtk_action_get_sensitive(gtkAction);
	}
	
	/**
	 * Sets the ::sensitive property of the action to sensitive. Note that
	 * this doesn't necessarily mean effective sensitivity. See
	 * gtk_action_is_sensitive()
	 * for that.
	 * Since 2.6
	 * Params:
	 * sensitive =  TRUE to make the action sensitive
	 */
	public void setSensitive(int sensitive)
	{
		// void gtk_action_set_sensitive (GtkAction *action,  gboolean sensitive);
		gtk_action_set_sensitive(gtkAction, sensitive);
	}
	
	/**
	 * Returns whether the action is effectively visible.
	 * Since 2.4
	 * Returns: TRUE if the action and its associated action group are both visible.
	 */
	public int isVisible()
	{
		// gboolean gtk_action_is_visible (GtkAction *action);
		return gtk_action_is_visible(gtkAction);
	}
	
	/**
	 * Returns whether the action itself is visible. Note that this doesn't
	 * necessarily mean effective visibility. See gtk_action_is_sensitive()
	 * for that.
	 * Since 2.4
	 * Returns: TRUE if the action itself is visible.
	 */
	public int getVisible()
	{
		// gboolean gtk_action_get_visible (GtkAction *action);
		return gtk_action_get_visible(gtkAction);
	}
	
	/**
	 * Sets the ::visible property of the action to visible. Note that
	 * this doesn't necessarily mean effective visibility. See
	 * gtk_action_is_visible()
	 * for that.
	 * Since 2.6
	 * Params:
	 * visible =  TRUE to make the action visible
	 */
	public void setVisible(int visible)
	{
		// void gtk_action_set_visible (GtkAction *action,  gboolean visible);
		gtk_action_set_visible(gtkAction, visible);
	}
	
	/**
	 * Emits the "activate" signal on the specified action, if it isn't
	 * insensitive. This gets called by the proxy widgets when they get
	 * activated.
	 * It can also be used to manually activate an action.
	 * Since 2.4
	 */
	public void activate()
	{
		// void gtk_action_activate (GtkAction *action);
		gtk_action_activate(gtkAction);
	}
	
	/**
	 * This function is intended for use by action implementations to
	 * create icons displayed in the proxy widgets.
	 * Since 2.4
	 * Params:
	 * iconSize =  the size of the icon that should be created.
	 * Returns: a widget that displays the icon for this action.
	 */
	public Widget createIcon(GtkIconSize iconSize)
	{
		// GtkWidget * gtk_action_create_icon (GtkAction *action,  GtkIconSize icon_size);
		auto p = gtk_action_create_icon(gtkAction, iconSize);
		if(p is null)
		{
			return null;
		}
		return new Widget(cast(GtkWidget*) p);
	}
	
	/**
	 * Creates a menu item widget that proxies for the given action.
	 * Since 2.4
	 * Returns: a menu item connected to the action.
	 */
	public Widget createMenuItem()
	{
		// GtkWidget * gtk_action_create_menu_item (GtkAction *action);
		auto p = gtk_action_create_menu_item(gtkAction);
		if(p is null)
		{
			return null;
		}
		return new Widget(cast(GtkWidget*) p);
	}
	
	/**
	 * Creates a toolbar item widget that proxies for the given action.
	 * Since 2.4
	 * Returns: a toolbar item connected to the action.
	 */
	public Widget createToolItem()
	{
		// GtkWidget * gtk_action_create_tool_item (GtkAction *action);
		auto p = gtk_action_create_tool_item(gtkAction);
		if(p is null)
		{
			return null;
		}
		return new Widget(cast(GtkWidget*) p);
	}
	
	/**
	 * If action provides a GtkMenu widget as a submenu for the menu
	 * item or the toolbar item it creates, this function returns an
	 * instance of that menu.
	 * Since 2.12
	 * Returns: the menu item provided by the action, or NULL.
	 */
	public Widget createMenu()
	{
		// GtkWidget * gtk_action_create_menu (GtkAction *action);
		auto p = gtk_action_create_menu(gtkAction);
		if(p is null)
		{
			return null;
		}
		return new Widget(cast(GtkWidget*) p);
	}
	
	/**
	 * Warning
	 * gtk_action_connect_proxy has been deprecated since version 2.16 and should not be used in newly-written code. Use gtk_activatable_set_related_action() instead.
	 * Connects a widget to an action object as a proxy. Synchronises
	 * various properties of the action with the widget (such as label
	 * text, icon, tooltip, etc), and attaches a callback so that the
	 * action gets activated when the proxy widget does.
	 * If the widget is already connected to an action, it is disconnected
	 * first.
	 * Since 2.4
	 * Params:
	 * proxy =  the proxy widget
	 */
	public void connectProxy(Widget proxy)
	{
		// void gtk_action_connect_proxy (GtkAction *action,  GtkWidget *proxy);
		gtk_action_connect_proxy(gtkAction, (proxy is null) ? null : proxy.getWidgetStruct());
	}
	
	/**
	 * Warning
	 * gtk_action_disconnect_proxy has been deprecated since version 2.16 and should not be used in newly-written code. Use gtk_activatable_set_related_action() instead.
	 * Disconnects a proxy widget from an action.
	 * Does not destroy the widget, however.
	 * Since 2.4
	 * Params:
	 * proxy =  the proxy widget
	 */
	public void disconnectProxy(Widget proxy)
	{
		// void gtk_action_disconnect_proxy (GtkAction *action,  GtkWidget *proxy);
		gtk_action_disconnect_proxy(gtkAction, (proxy is null) ? null : proxy.getWidgetStruct());
	}
	
	/**
	 * Returns the proxy widgets for an action.
	 * See also gtk_widget_get_action().
	 * Since 2.4
	 * Returns: a GSList of proxy widgets. The list is owned by GTK+and must not be modified.
	 */
	public ListSG getProxies()
	{
		// GSList * gtk_action_get_proxies (GtkAction *action);
		auto p = gtk_action_get_proxies(gtkAction);
		if(p is null)
		{
			return null;
		}
		return new ListSG(cast(GSList*) p);
	}
	
	/**
	 * Installs the accelerator for action if action has an
	 * accel path and group. See gtk_action_set_accel_path() and
	 * gtk_action_set_accel_group()
	 * Since multiple proxies may independently trigger the installation
	 * of the accelerator, the action counts the number of times this
	 * function has been called and doesn't remove the accelerator until
	 * gtk_action_disconnect_accelerator() has been called as many times.
	 * Since 2.4
	 */
	public void connectAccelerator()
	{
		// void gtk_action_connect_accelerator (GtkAction *action);
		gtk_action_connect_accelerator(gtkAction);
	}
	
	/**
	 * Undoes the effect of one call to gtk_action_connect_accelerator().
	 * Since 2.4
	 */
	public void disconnectAccelerator()
	{
		// void gtk_action_disconnect_accelerator (GtkAction *action);
		gtk_action_disconnect_accelerator(gtkAction);
	}
	
	/**
	 * Disable activation signals from the action
	 * This is needed when updating the state of your proxy
	 * GtkActivatable widget could result in calling gtk_action_activate(),
	 * this is a convenience function to avoid recursing in those
	 * cases (updating toggle state for instance).
	 * Since 2.16
	 */
	public void blockActivate()
	{
		// void gtk_action_block_activate (GtkAction *action);
		gtk_action_block_activate(gtkAction);
	}
	
	/**
	 * Reenable activation signals from the action
	 * Since 2.16
	 */
	public void unblockActivate()
	{
		// void gtk_action_unblock_activate (GtkAction *action);
		gtk_action_unblock_activate(gtkAction);
	}
	
	/**
	 * Warning
	 * gtk_action_block_activate_from has been deprecated since version 2.16 and should not be used in newly-written code. activatables are now responsible for activating the
	 * action directly so this doesnt apply anymore.
	 * Disables calls to the gtk_action_activate()
	 * function by signals on the given proxy widget. This is used to
	 * break notification loops for things like check or radio actions.
	 * This function is intended for use by action implementations.
	 * Since 2.4
	 * Params:
	 * proxy =  a proxy widget
	 */
	public void blockActivateFrom(Widget proxy)
	{
		// void gtk_action_block_activate_from (GtkAction *action,  GtkWidget *proxy);
		gtk_action_block_activate_from(gtkAction, (proxy is null) ? null : proxy.getWidgetStruct());
	}
	
	/**
	 * Warning
	 * gtk_action_unblock_activate_from has been deprecated since version 2.16 and should not be used in newly-written code. activatables are now responsible for activating the
	 * action directly so this doesnt apply anymore.
	 * Re-enables calls to the gtk_action_activate()
	 * function by signals on the given proxy widget. This undoes the
	 * blocking done by gtk_action_block_activate_from().
	 * This function is intended for use by action implementations.
	 * Since 2.4
	 * Params:
	 * proxy =  a proxy widget
	 */
	public void unblockActivateFrom(Widget proxy)
	{
		// void gtk_action_unblock_activate_from (GtkAction *action,  GtkWidget *proxy);
		gtk_action_unblock_activate_from(gtkAction, (proxy is null) ? null : proxy.getWidgetStruct());
	}
	
	/**
	 * Returns the accel path for this action.
	 * Since 2.6
	 * Returns: the accel path for this action, or NULL if none is set. The returned string is owned by GTK+  and must not be freed or modified.
	 */
	public string getAccelPath()
	{
		// const gchar * gtk_action_get_accel_path (GtkAction *action);
		return Str.toString(gtk_action_get_accel_path(gtkAction));
	}
	
	/**
	 * Sets the accel path for this action. All proxy widgets associated
	 * with the action will have this accel path, so that their
	 * accelerators are consistent.
	 * Note that accel_path string will be stored in a GQuark. Therefore, if you
	 * pass a static string, you can save some memory by interning it first with
	 * g_intern_static_string().
	 * Since 2.4
	 * Params:
	 * accelPath =  the accelerator path
	 */
	public void setAccelPath(string accelPath)
	{
		// void gtk_action_set_accel_path (GtkAction *action,  const gchar *accel_path);
		gtk_action_set_accel_path(gtkAction, Str.toStringz(accelPath));
	}
	
	/**
	 * Returns the accel closure for this action.
	 * Since 2.8
	 * Returns: the accel closure for this action. The returned closure is owned by GTK+ and must not be unreffed or modified.
	 */
	public Closure getAccelClosure()
	{
		// GClosure * gtk_action_get_accel_closure (GtkAction *action);
		auto p = gtk_action_get_accel_closure(gtkAction);
		if(p is null)
		{
			return null;
		}
		return new Closure(cast(GClosure*) p);
	}
	
	/**
	 * Sets the GtkAccelGroup in which the accelerator for this action
	 * will be installed.
	 * Since 2.4
	 * Params:
	 * accelGroup =  a GtkAccelGroup or NULL
	 */
	public void setAccelGroup(AccelGroup accelGroup)
	{
		// void gtk_action_set_accel_group (GtkAction *action,  GtkAccelGroup *accel_group);
		gtk_action_set_accel_group(gtkAction, (accelGroup is null) ? null : accelGroup.getAccelGroupStruct());
	}
	
	/**
	 * Sets the label of action.
	 * Since 2.16
	 * Params:
	 * label =  the label text to set
	 */
	public void setLabel(string label)
	{
		// void gtk_action_set_label (GtkAction *action,  const gchar *label);
		gtk_action_set_label(gtkAction, Str.toStringz(label));
	}
	
	/**
	 * Gets the label text of action.
	 * Since 2.16
	 * Returns: the label text
	 */
	public string getLabel()
	{
		// const gchar * gtk_action_get_label (GtkAction *action);
		return Str.toString(gtk_action_get_label(gtkAction));
	}
	
	/**
	 * Sets a shorter label text on action.
	 * Since 2.16
	 * Params:
	 * shortLabel =  the label text to set
	 */
	public void setShortLabel(string shortLabel)
	{
		// void gtk_action_set_short_label (GtkAction *action,  const gchar *short_label);
		gtk_action_set_short_label(gtkAction, Str.toStringz(shortLabel));
	}
	
	/**
	 * Gets the short label text of action.
	 * Since 2.16
	 * Returns: the short label text.
	 */
	public string getShortLabel()
	{
		// const gchar * gtk_action_get_short_label (GtkAction *action);
		return Str.toString(gtk_action_get_short_label(gtkAction));
	}
	
	/**
	 * Sets the tooltip text on action
	 * Since 2.16
	 * Params:
	 * tooltip =  the tooltip text
	 */
	public void setTooltip(string tooltip)
	{
		// void gtk_action_set_tooltip (GtkAction *action,  const gchar *tooltip);
		gtk_action_set_tooltip(gtkAction, Str.toStringz(tooltip));
	}
	
	/**
	 * Gets the tooltip text of action.
	 * Since 2.16
	 * Returns: the tooltip text
	 */
	public string getTooltip()
	{
		// const gchar * gtk_action_get_tooltip (GtkAction *action);
		return Str.toString(gtk_action_get_tooltip(gtkAction));
	}
	
	/**
	 * Sets the icon of action.
	 * Since 2.16
	 * Params:
	 * icon =  the GIcon to set
	 */
	public void setGicon(IconIF icon)
	{
		// void gtk_action_set_gicon (GtkAction *action,  GIcon *icon);
		gtk_action_set_gicon(gtkAction, (icon is null) ? null : icon.getIconTStruct());
	}
	
	/**
	 * Gets the gicon of action.
	 * Since 2.16
	 * Returns: The action's GIcon if one is set.
	 */
	public IconIF getGicon()
	{
		// GIcon * gtk_action_get_gicon (GtkAction *action);
		auto p = gtk_action_get_gicon(gtkAction);
		if(p is null)
		{
			return null;
		}
		return new Icon(cast(GIcon*) p);
	}
	
	/**
	 * Sets the icon name on action
	 * Since 2.16
	 * Params:
	 * iconName =  the icon name to set
	 */
	public void setIconName(string iconName)
	{
		// void gtk_action_set_icon_name (GtkAction *action,  const gchar *icon_name);
		gtk_action_set_icon_name(gtkAction, Str.toStringz(iconName));
	}
	
	/**
	 * Gets the icon name of action.
	 * Since 2.16
	 * Returns: the icon name
	 */
	public string getIconName()
	{
		// const gchar * gtk_action_get_icon_name (GtkAction *action);
		return Str.toString(gtk_action_get_icon_name(gtkAction));
	}
	
	/**
	 * Sets whether action is visible when horizontal
	 * Since 2.16
	 * Params:
	 * visibleHorizontal =  whether the action is visible horizontally
	 */
	public void setVisibleHorizontal(int visibleHorizontal)
	{
		// void gtk_action_set_visible_horizontal (GtkAction *action,  gboolean visible_horizontal);
		gtk_action_set_visible_horizontal(gtkAction, visibleHorizontal);
	}
	
	/**
	 * Checks whether action is visible when horizontal
	 * Since 2.16
	 * Returns: whether action is visible when horizontal
	 */
	public int getVisibleHorizontal()
	{
		// gboolean gtk_action_get_visible_horizontal (GtkAction *action);
		return gtk_action_get_visible_horizontal(gtkAction);
	}
	
	/**
	 * Sets whether action is visible when vertical
	 * Since 2.16
	 * Params:
	 * visibleVertical =  whether the action is visible vertically
	 */
	public void setVisibleVertical(int visibleVertical)
	{
		// void gtk_action_set_visible_vertical (GtkAction *action,  gboolean visible_vertical);
		gtk_action_set_visible_vertical(gtkAction, visibleVertical);
	}
	
	/**
	 * Checks whether action is visible when horizontal
	 * Since 2.16
	 * Returns: whether action is visible when horizontal
	 */
	public int getVisibleVertical()
	{
		// gboolean gtk_action_get_visible_vertical (GtkAction *action);
		return gtk_action_get_visible_vertical(gtkAction);
	}
	
	/**
	 * Sets whether the action is important, this attribute is used
	 * primarily by toolbar items to decide whether to show a label
	 * or not.
	 * Since 2.16
	 * Params:
	 * isImportant =  TRUE to make the action important
	 */
	public void setIsImportant(int isImportant)
	{
		// void gtk_action_set_is_important (GtkAction *action,  gboolean is_important);
		gtk_action_set_is_important(gtkAction, isImportant);
	}
	
	/**
	 * Checks whether action is important or not
	 * Since 2.16
	 * Returns: whether action is important
	 */
	public int getIsImportant()
	{
		// gboolean gtk_action_get_is_important (GtkAction *action);
		return gtk_action_get_is_important(gtkAction);
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
