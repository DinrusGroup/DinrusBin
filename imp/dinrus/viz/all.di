//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


/// Imports все of DFL's public interface.
module viz.all;

version = Dinrus;

	version = VIZ_NO_LIB;
	version = gui;
	version = VIZ_UNICODE;
	
version(build)
{
		version(VIZ_NO_LIB)
		{
		pragma(lib, "dinrus.lib");
		pragma(build_def, "EXETYPE NT");
			version(gui)
			{
				pragma(build_def, "SUBSYSTEM WINDOWS,4.0");
			}
		}

}

/+
public import viz.common, viz.menu, viz.control, viz.usercontrol,
	viz.form, viz.graphics, viz.panel, viz.event,
	viz.app, viz.button, viz.socket,
	viz.timer, viz.environment, viz.label, viz.textbox,
	viz.listbox, viz.splitter, viz.groupbox, viz.messagebox,
	viz.registry, viz.notifyicon, viz.collections, viz.data,
	viz.clipboard, viz.commondialog, viz.richtextbox, viz.tooltip,
	viz.combobox, viz.treeview, viz.picturebox, viz.tabcontrol,
	viz.listview, viz.statusbar, viz.progressbar, viz.resources,
	viz.imagelist, viz.toolbar;

+/