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
 * inFile  = gdk-Testing.html
 * outPack = gdk
 * outFile = Testing
 * strct   = 
 * realStrct=
 * ctorStrct=
 * clss    = Testing
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gdk_test_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.gdk.Window
 * structWrap:
 * 	- GdkWindow* -> Window
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gdk.Testing;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;


private import gtkD.gdk.Window;




/**
 * Description
 * The functions in this section are intended to be used in test programs.
 * They allow to simulate some user input.
 */
public class Testing
{
	
	/**
	 */
	
	/**
	 * This function retrives a pixel from window to force the windowing
	 * system to carry out any pending rendering commands.
	 * This function is intended to be used to syncronize with rendering
	 * pipelines, to benchmark windowing system rendering operations.
	 * Since 2.14
	 * Params:
	 * window =  a mapped GdkWindow
	 */
	public static void renderSync(Window window)
	{
		// void gdk_test_render_sync (GdkWindow *window);
		gdk_test_render_sync((window is null) ? null : window.getWindowStruct());
	}
	
	/**
	 * This function is intended to be used in Gtk+ test programs.
	 * It will warp the mouse pointer to the given (x,y) corrdinates
	 * within window and simulate a button press or release event.
	 * Because the mouse pointer needs to be warped to the target
	 * location, use of this function outside of test programs that
	 * run in their own virtual windowing system (e.g. Xvfb) is not
	 * recommended.
	 * Also, gtk_test_simulate_button() is a fairly low level function,
	 * for most testing purposes, gtk_test_widget_click() is the right
	 * function to call which will generate a button press event followed
	 * by its accompanying button release event.
	 * Since 2.14
	 * Params:
	 * window =  Gdk window to simulate a button event for.
	 * x =  x coordinate within window for the button event.
	 * y =  y coordinate within window for the button event.
	 * button =  Number of the pointer button for the event, usually 1, 2 or 3.
	 * modifiers =  Keyboard modifiers the event is setup with.
	 * buttonPressrelease =  either GDK_BUTTON_PRESS or GDK_BUTTON_RELEASE
	 * Returns: wether all actions neccessary for a button event simulation were carried out successfully.
	 */
	public static int simulateButton(Window window, int x, int y, uint button, GdkModifierType modifiers, GdkEventType buttonPressrelease)
	{
		// gboolean gdk_test_simulate_button (GdkWindow *window,  gint x,  gint y,  guint button,  GdkModifierType modifiers,  GdkEventType button_pressrelease);
		return gdk_test_simulate_button((window is null) ? null : window.getWindowStruct(), x, y, button, modifiers, buttonPressrelease);
	}
	
	/**
	 * This function is intended to be used in Gtk+ test programs.
	 * If (x,y) are > (-1,-1), it will warp the mouse pointer to
	 * the given (x,y) corrdinates within window and simulate a
	 * key press or release event.
	 * When the mouse pointer is warped to the target location, use
	 * of this function outside of test programs that run in their
	 * own virtual windowing system (e.g. Xvfb) is not recommended.
	 * If (x,y) are passed as (-1,-1), the mouse pointer will not
	 * be warped and window origin will be used as mouse pointer
	 * location for the event.
	 * Also, gtk_test_simulate_key() is a fairly low level function,
	 * for most testing purposes, gtk_test_widget_send_key() is the
	 * right function to call which will generate a key press event
	 * followed by its accompanying key release event.
	 * Since 2.14
	 * Params:
	 * window =  Gdk window to simulate a key event for.
	 * x =  x coordinate within window for the key event.
	 * y =  y coordinate within window for the key event.
	 * keyval =  A Gdk keyboard value.
	 * modifiers =  Keyboard modifiers the event is setup with.
	 * keyPressrelease =  either GDK_KEY_PRESS or GDK_KEY_RELEASE
	 * Returns: wether all actions neccessary for a key event simulation were carried out successfully.
	 */
	public static int simulateKey(Window window, int x, int y, uint keyval, GdkModifierType modifiers, GdkEventType keyPressrelease)
	{
		// gboolean gdk_test_simulate_key (GdkWindow *window,  gint x,  gint y,  guint keyval,  GdkModifierType modifiers,  GdkEventType key_pressrelease);
		return gdk_test_simulate_key((window is null) ? null : window.getWindowStruct(), x, y, keyval, modifiers, keyPressrelease);
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gdk");
        } else version (DigitalMars) {
            pragma(link, "DD-gdk");
        } else {
            pragma(link, "DO-gdk");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gdk");
        } else version (DigitalMars) {
            pragma(link, "DD-gdk");
        } else {
            pragma(link, "DO-gdk");
        }
    }
}
