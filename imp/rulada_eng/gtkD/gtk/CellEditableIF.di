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
 * inFile  = GtkCellEditable.html
 * outPack = gtk
 * outFile = CellEditableIF
 * strct   = GtkCellEditable
 * realStrct=
 * ctorStrct=
 * clss    = CellEditableT
 * interf  = CellEditableIF
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_cell_editable_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.gdk.Event
 * structWrap:
 * 	- GdkEvent* -> Event
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.CellEditableIF;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gdk.Event;




/**
 * Description
 * The GtkCellEditable interface must be implemented for widgets
 * to be usable when editing the contents of a GtkTreeView cell.
 */
public interface CellEditableIF
{
	
	
	public GtkCellEditable* getCellEditableTStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	
	/**
	 */
	
	void delegate(CellEditableIF)[] onEditingDoneListeners();
	/**
	 * This signal is a sign for the cell renderer to update its
	 * value from the cell_editable.
	 * Implementations of GtkCellEditable are responsible for
	 * emitting this signal when they are done editing, e.g.
	 * GtkEntry is emitting it when the user presses Enter.
	 * gtk_cell_editable_editing_done() is a convenience method
	 * for emitting ::editing-done.
	 */
	void addOnEditingDone(void delegate(CellEditableIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	void delegate(CellEditableIF)[] onRemoveWidgetListeners();
	/**
	 * This signal is meant to indicate that the cell is finished
	 * editing, and the widget may now be destroyed.
	 * Implementations of GtkCellEditable are responsible for
	 * emitting this signal when they are done editing. It must
	 * be emitted after the "editing-done" signal,
	 * to give the cell renderer a chance to update the cell's value
	 * before the widget is removed.
	 * gtk_cell_editable_remove_widget() is a convenience method
	 * for emitting ::remove-widget.
	 */
	void addOnRemoveWidget(void delegate(CellEditableIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	
	/**
	 * Begins editing on a cell_editable. event is the GdkEvent that began
	 * the editing process. It may be NULL, in the instance that editing was
	 * initiated through programatic means.
	 * Params:
	 * event =  A GdkEvent, or NULL
	 */
	public void startEditing(Event event);
	
	/**
	 * Emits the "editing-done" signal.
	 */
	public void editingDone();
	
	/**
	 * Emits the "remove-widget" signal.
	 */
	public void removeWidget();
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
