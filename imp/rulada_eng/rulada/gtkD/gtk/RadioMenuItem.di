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
 * inFile  = GtkRadioMenuItem.html
 * outPack = gtk
 * outFile = RadioMenuItem
 * strct   = GtkRadioMenuItem
 * realStrct=
 * ctorStrct=
 * clss    = RadioMenuItem
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_radio_menu_item_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * 	- gtk_radio_menu_item_new_with_label
 * 	- gtk_radio_menu_item_new_with_mnemonic
 * 	- gtk_radio_menu_item_new_with_mnemonic_from_widget
 * 	- gtk_radio_menu_item_new_with_label_from_widget
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ListSG
 * structWrap:
 * 	- GSList* -> ListSG
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.RadioMenuItem;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.glib.ListSG;



private import gtkD.gtk.CheckMenuItem;

/**
 * Description
 * A radio menu item is a check menu item that belongs to a group. At each
 * instant exactly one of the radio menu items from a group is selected.
 * The group list does not need to be freed, as each GtkRadioMenuItem will
 * remove itself and its list item when it is destroyed.
 * The correct way to create a group of radio menu items is approximatively
 * this:
 * Example 32. How to create a group of radio menu items.
 * GSList *group = NULL;
 * GtkWidget *item;
 * gint i;
 * for (i = 0; i < 5; i++)
 * {
	 *  item = gtk_radio_menu_item_new_with_label (group, "This is an example");
	 *  group = gtk_radio_menu_item_get_group (GTK_RADIO_MENU_ITEM (item));
	 *  if (i == 1)
	 *  gtk_check_menu_item_set_active (GTK_CHECK_MENU_ITEM (item), TRUE);
 * }
 */
public class RadioMenuItem : CheckMenuItem
{
	
	/** the main Gtk struct */
	protected GtkRadioMenuItem* gtkRadioMenuItem;
	
	
	public GtkRadioMenuItem* getRadioMenuItemStruct()
	{
		return gtkRadioMenuItem;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkRadioMenuItem;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkRadioMenuItem* gtkRadioMenuItem)
	{
		if(gtkRadioMenuItem is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkRadioMenuItem);
		if( ptr !is null )
		{
			this = cast(RadioMenuItem)ptr;
			return;
		}
		super(cast(GtkCheckMenuItem*)gtkRadioMenuItem);
		this.gtkRadioMenuItem = gtkRadioMenuItem;
	}
	
	/**
	 * Creates a new GtkRadioMenuItem whose child is a simple GtkLabel.
	 * The new GtkRadioMenuItem is added to the same group as group.
	 * If mnemonic is true the label will be
	 * created using gtk_label_new_with_mnemonic(), so underscores in label
	 * indicate the mnemonic for the menu item.
	 * Since 2.4
	 * Params:
	 *  group = an existing GtkRadioMenuItem
	 *  label = the text for the label
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (RadioMenuItem radioMenuItem, string label, bool mnemonic=true)
	{
		GtkRadioMenuItem* p;
		
		if ( mnemonic )
		{
			// GtkWidget* gtk_radio_menu_item_new_with_mnemonic_from_widget  (GtkRadioMenuItem *group,  const gchar *label);
			p = cast(GtkRadioMenuItem*)gtk_radio_menu_item_new_with_mnemonic_from_widget(
			radioMenuItem.getRadioMenuItemStruct(), Str.toStringz(label));
		}
		else
		{
			// GtkWidget* gtk_radio_menu_item_new_with_label_from_widget  (GtkRadioMenuItem *group,  const gchar *label);
			p = cast(GtkRadioMenuItem*)gtk_radio_menu_item_new_with_label_from_widget(
			radioMenuItem.getRadioMenuItemStruct(), Str.toStringz(label));
		}
		
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_radio_menu_item_new_with_");
		}
		
		this(p);
	}
	
	/**
	 * Creates a new GtkRadioMenuItem whose child is a simple GtkLabel.
	 * Params:
	 *  group = the group to which the radio menu item is to be attached
	 *  label = the text for the label
	 *  mnemonic = if true the label
	 *  will be created using gtk_label_new_with_mnemonic(), so underscores
	 *  in label indicate the mnemonic for the menu item.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ListSG group, string label, bool mnemonic=true)
	{
		GtkRadioMenuItem* p;
		
		if ( mnemonic )
		{
			// GtkWidget* gtk_radio_menu_item_new_with_mnemonic  (GSList *group,  const gchar *label);
			p = cast(GtkRadioMenuItem*)gtk_radio_menu_item_new_with_mnemonic(
			group is null ? null : group.getListSGStruct(), Str.toStringz(label));
		}
		else
		{
			// GtkWidget* gtk_radio_menu_item_new_with_label  (GSList *group,  const gchar *label);
			p = cast(GtkRadioMenuItem*)gtk_radio_menu_item_new_with_label(
			group is null ? null : group.getListSGStruct(), Str.toStringz(label));
		}
		
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_radio_menu_item_new_with_");
		}
		
		this(p);
	}
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(RadioMenuItem)[] onGroupChangedListeners;
	/**
	 * See Also
	 * GtkMenuItem
	 * because a radio menu item is a menu item.
	 * GtkCheckMenuItem
	 * to know how to handle the check.
	 */
	void addOnGroupChanged(void delegate(RadioMenuItem) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		if ( !("group-changed" in connectedSignals) )
		{
			Signals.connectData(
			getStruct(),
			"group-changed",
			cast(GCallback)&callBackGroupChanged,
			cast(void*)this,
			null,
			connectFlags);
			connectedSignals["group-changed"] = 1;
		}
		onGroupChangedListeners ~= dlg;
	}
	extern(C) static void callBackGroupChanged(GtkRadioMenuItem* radiomenuitemStruct, RadioMenuItem radioMenuItem)
	{
		foreach ( void delegate(RadioMenuItem) dlg ; radioMenuItem.onGroupChangedListeners )
		{
			dlg(radioMenuItem);
		}
	}
	
	
	/**
	 * Creates a new GtkRadioMenuItem.
	 * Params:
	 * group = the group to which the radio menu item is to be attached
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ListSG group)
	{
		// GtkWidget* gtk_radio_menu_item_new (GSList *group);
		auto p = gtk_radio_menu_item_new((group is null) ? null : group.getListSGStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_radio_menu_item_new((group is null) ? null : group.getListSGStruct())");
		}
		this(cast(GtkRadioMenuItem*) p);
	}
	
	/**
	 * Creates a new GtkRadioMenuItem adding it to the same group as group.
	 * Since 2.4
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GtkWidget* gtk_radio_menu_item_new_from_widget (GtkRadioMenuItem *group);
		auto p = gtk_radio_menu_item_new_from_widget(gtkRadioMenuItem);
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_radio_menu_item_new_from_widget(gtkRadioMenuItem)");
		}
		this(cast(GtkRadioMenuItem*) p);
	}
	
	/**
	 * Sets the group of a radio menu item, or changes it.
	 * Params:
	 * group = the new group.
	 */
	public void setGroup(ListSG group)
	{
		// void gtk_radio_menu_item_set_group (GtkRadioMenuItem *radio_menu_item,  GSList *group);
		gtk_radio_menu_item_set_group(gtkRadioMenuItem, (group is null) ? null : group.getListSGStruct());
	}
	
	/**
	 * Returns the group to which the radio menu item belongs, as a GList of
	 * GtkRadioMenuItem. The list belongs to GTK+ and should not be freed.
	 * Returns:the group of radio_menu_item.
	 */
	public ListSG getGroup()
	{
		// GSList* gtk_radio_menu_item_get_group (GtkRadioMenuItem *radio_menu_item);
		auto p = gtk_radio_menu_item_get_group(gtkRadioMenuItem);
		if(p is null)
		{
			return null;
		}
		return new ListSG(cast(GSList*) p);
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
