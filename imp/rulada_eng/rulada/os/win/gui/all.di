// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


/// Imports all of DFL's public interface.
module os.win.gui.all;

version = Tango;

//version(bud)
	//version = build;
//version(DFL_NO_BUD_DEF)
	//version = DFL_NO_BUILD_DEF;
version(DFL_NO_LIB)
	version = DFL_NO_LIB;
	version = gui;
	version(DFL_UNICODE)
	version = DFL_UNICODE;
	
version(build)
{
	/*version(WINE)
	{
	}
	else
	{*/
		version(DFL_NO_LIB)
		{
		pragma(lib, "rulada.lib");
		pragma(build_def, "EXETYPE NT");
			version(gui)
			{
				pragma(build_def, "SUBSYSTEM WINDOWS,4.0");
			}
		}
		/*else
		{
			pragma(link, "dfl_build");
			
			pragma(link, "ws2_32");
			pragma(link, "gdi32");
			pragma(link, "comctl32");
			pragma(link, "advapi32");
			pragma(link, "comdlg32");
			pragma(link, "ole32");
			pragma(link, "uuid");
		}
		
		version(DFL_NO_BUILD_DEF)
		{
		}
		else
		{
			pragma(build_def, "EXETYPE NT");
			version(gui)
			{
				pragma(build_def, "SUBSYSTEM WINDOWS,4.0");
			}
			else
			{
				pragma(build_def, "SUBSYSTEM CONSOLE,4.0");
			}
		}
	}*/
}


public import os.win.gui.base, os.win.gui.menu, os.win.gui.control, os.win.gui.usercontrol,
	os.win.gui.form, os.win.gui.drawing, os.win.gui.panel, os.win.gui.event,
	os.win.gui.application, os.win.gui.button, os.win.gui.socket,
	os.win.gui.timer, os.win.gui.environment, os.win.gui.label, os.win.gui.textbox,
	os.win.gui.listbox, os.win.gui.splitter, os.win.gui.groupbox, os.win.gui.messagebox,
	os.win.gui.registry, os.win.gui.notifyicon, os.win.gui.collections, os.win.gui.data,
	os.win.gui.clipboard, os.win.gui.commondialog, os.win.gui.richtextbox, os.win.gui.tooltip,
	os.win.gui.combobox, os.win.gui.treeview, os.win.gui.picturebox, os.win.gui.tabcontrol,
	os.win.gui.listview, os.win.gui.statusbar, os.win.gui.progressbar, os.win.gui.resources,
	os.win.gui.imagelist, os.win.gui.toolbar;

