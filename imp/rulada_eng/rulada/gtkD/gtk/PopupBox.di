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
 * inFile  = 
 * outPack = gtk
 * outFile = PopupBox
 * strct   = 
 * realStrct=
 * ctorStrct=
 * clss    = PopupBox
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.gtk.MessageDialog;
 * 	- gtkD.gtk.Window;
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.PopupBox;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.MessageDialog;;
private import gtkD.gtk.Window;;




/**
 */
public class PopupBox
{
	
	/**
	 * Create an information popup dialog.
	 * Params:
	 *  message = The message to show on the dialog
	 *  title = The title of the dialog
	 */
	public static void information(string message, string title)
	{
		information(null, message, title);
	}
	
	/**
	 * Create an information popup dialog.
	 * Params:
	 *  parent = The parent window of this popup dialog
	 *  message = The message to show on the dialog
	 *  title = The title of the dialog
	 */
	public static void information(Window parent, string message, string title)
	{
		MessageDialog d = new MessageDialog(parent, cast(GtkDialogFlags)0,
		MessageType.INFO,
		ButtonsType.OK ,
		message);
		d.setTitle(title);
		//d.addButton("gtk-dialog-info",GtkResponseType.GTK_RESPONSE_OK);
		d.run();
		d.destroy();
	}
	
	
	/**
	 * Create an error popup dialog.
	 * Params:
	 *  message = The message to show on the dialog
	 *  title = The title of the dialog
	 */
	public static void error(string message, string title)
	{
		error(null, message, title);
	}
	
	/**
	 * Create an error popup dialog.
	 * Params:
	 *  parent = The parent window of this popup dialog
	 *  message = The message to show on the dialog
	 *  title = The title of the dialog
	 */
	public static void error(Window parent, string message, string title)
	{
		MessageDialog d = new MessageDialog(parent, cast(GtkDialogFlags)0,
		MessageType.ERROR,
		ButtonsType.CANCEL ,
		message);
		d.setTitle(title);
		//d.addButton("gtk-dialog-error",ResponseType.GTK_RESPONSE_CANCEL);
		d.run();
		d.destroy();
	}
	
	
	
	/**
	 * Create an 'yes' or 'no' popup dialog.
	 * Params:
	 *  message = The message to show on the dialog
	 *  title = The title of the dialog
	 */
	public static bool yesNo(string message, string title)
	{
		return yesNo(null, message, title);
	}
	
	/**
	 * Create an 'yes' or 'no' popup dialog.
	 * Params:
	 *  parent = The parent window of this popup dialog
	 *  message = The message to show on the dialog
	 *  title = The title of the dialog
	 */
	public static bool yesNo(Window parent, string message, string title)
	{
		MessageDialog d = new MessageDialog(
		parent, cast(GtkDialogFlags)0,
		MessageType.QUESTION,
		ButtonsType.NONE ,
		message);
		d.setTitle(title);
		d.addButton("gtk-no",ResponseType.GTK_RESPONSE_NO);
		d.addButton("gtk-yes",ResponseType.GTK_RESPONSE_YES);
		int responce = d.run();
		d.destroy();
		return responce == ResponseType.GTK_RESPONSE_YES;
	}
	
	
	/**
	 * Create an 'yes', 'no' or 'cancel' popup dialog.
	 * Params:
	 *  message = The message to show on the dialog
	 *  title = The title of the dialog
	 */
	public static ResponseType yesNoCancel(string message, string title)
	{
		return yesNoCancel(null, message, title);
	}
	
	/**
	 * Create an 'yes', 'no' or 'cancel' popup dialog.
	 * Params:
	 *  parent = The parent window of this popup dialog
	 *  message = The message to show on the dialog
	 *  title = The title of the dialog
	 */
	public static ResponseType yesNoCancel(Window parent, string message, string title)
	{
		MessageDialog d = new MessageDialog(
		parent, cast(GtkDialogFlags)0,
		MessageType.QUESTION,
		ButtonsType.NONE ,
		message);
		d.setTitle(title);
		d.addButton("gtk-no",ResponseType.GTK_RESPONSE_NO);
		d.addButton("gtk-yes",ResponseType.GTK_RESPONSE_YES);
		d.addButton("gtk-cancel",ResponseType.GTK_RESPONSE_CANCEL);
		ResponseType responce = cast(ResponseType)d.run();
		d.destroy();
		return responce;
	}
	
	/**
	 */
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
