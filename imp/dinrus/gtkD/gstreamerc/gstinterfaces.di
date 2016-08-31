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


module gtkD.gstreamerc.gstinterfaces;

version(Rulada)
	private import tango.stdc.stdio;
else
	private import std.stdio;

private import gtkD.gstreamerc.gstinterfacestypes;
private import gtkD.gtkc.Loader;
private import gtkD.gtkc.paths;

private import gtkD.gtkc.glibtypes;
private import gtkD.gtkc.gobjecttypes;
private import gtkD.gtkc.gthreadtypes;
private import gtkD.glib.Str;


static this()
{

	// gtkD.gstinterfaces.XOverlay

	Linker.link(gst_x_overlay_set_xwindow_id, "gst_x_overlay_set_xwindow_id", LIBRARY.GSTINTERFACES);
	Linker.link(gst_x_overlay_got_xwindow_id, "gst_x_overlay_got_xwindow_id", LIBRARY.GSTINTERFACES);
	Linker.link(gst_x_overlay_prepare_xwindow_id, "gst_x_overlay_prepare_xwindow_id", LIBRARY.GSTINTERFACES);
	Linker.link(gst_x_overlay_expose, "gst_x_overlay_expose", LIBRARY.GSTINTERFACES);

}

extern(C)
{
	// gtkD.gstinterfaces.XOverlay
	
	void function(GstXOverlay* overlay, gulong xwindowId) c_gst_x_overlay_set_xwindow_id;
	void function(GstXOverlay* overlay, gulong xwindowId) c_gst_x_overlay_got_xwindow_id;
	void function(GstXOverlay* overlay) c_gst_x_overlay_prepare_xwindow_id;
	void function(GstXOverlay* overlay) c_gst_x_overlay_expose;
	
}

// gtkD.gstinterfaces.XOverlay

alias c_gst_x_overlay_set_xwindow_id  gst_x_overlay_set_xwindow_id;
alias c_gst_x_overlay_got_xwindow_id  gst_x_overlay_got_xwindow_id;
alias c_gst_x_overlay_prepare_xwindow_id  gst_x_overlay_prepare_xwindow_id;
alias c_gst_x_overlay_expose  gst_x_overlay_expose;



version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gstreamerc");
        } else version (DigitalMars) {
            pragma(link, "DD-gstreamerc");
        } else {
            pragma(link, "DO-gstreamerc");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gstreamerc");
        } else version (DigitalMars) {
            pragma(link, "DD-gstreamerc");
        } else {
            pragma(link, "DO-gstreamerc");
        }
    }
}
