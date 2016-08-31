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
 * inFile  = GladeXML.html
 * outPack = glade
 * outFile = Glade
 * strct   = GladeXML
 * realStrct=
 * ctorStrct=
 * clss    = Glade
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- glade_xml_
 * omit structs:
 * omit prefixes:
 * omit code:
 * 	- glade_xml_signal_autoconnect
 * 	- glade_xml_signal_connect_data
 * 	- glade_xml_signal_connect
 * 	- glade_xml_signal_connect_full
 * 	- glade_xml_signal_autoconnect_full
 * 	- GladeXMLConnectFunc
 * 	- GladeXMLCustomWidgetHandler
 * 	- glade_set_custom_handler
 * 	- glade_xml_get_widget
 * 	- glade_xml_new
 * 	- glade_xml_get_widget_prefix
 * omit signals:
 * imports:
 * 	- gtkD.gtk.Widget
 * 	- gtkD.gobject.ObjectG
 * 	- gtkD.glib.ListG
 * 	- gtkD.glib.Str
 * structWrap:
 * 	- GList* -> ListG
 * 	- GObject* -> ObjectG
 * 	- GladeXML* -> Glade
 * 	- GtkWidget* -> Widget
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.glade.Glade;

public  import gtkD.gtkc.gladetypes;

private import gtkD.gtkc.glade;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Widget;
private import gtkD.gobject.ObjectG;
private import gtkD.glib.ListG;
private import gtkD.glib.Str;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * This object represents an `instantiation' of an XML interface description.
 * When one of these objects is created, the XML file is read, and the
 * interface is created. The GladeXML object then provides an interface for
 * accessing the widgets in the interface by the names assigned to them
 * inside the XML description.
 * The GladeXML object can also be used to connect handlers to the named
 * signals in the description. Libglade also provides an interface by which
 * it can look up the signal handler names in the program's symbol table and
 * automatically connect as many handlers up as it can that way.
 */
public class Glade : ObjectG
{
	
	/** the main Gtk struct */
	protected GladeXML* gladeXML;
	
	
	public GladeXML* getGladeStruct()
	{
		return gladeXML;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gladeXML;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GladeXML* gladeXML)
	{
		if(gladeXML is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gladeXML);
		if( ptr !is null )
		{
			this = cast(Glade)ptr;
			return;
		}
		super(cast(GObject*)gladeXML);
		this.gladeXML = gladeXML;
	}
	
	/**
	 * This function is used to get a pointer to the GtkWidget corresponding to
	 * name in the interface description. You would use this if you have to do
	 * anything to the widget after loading.
	 * Params:
	 *  name = the name of the widget.
	 * Returns:
	 *  the widget matching name, or NULL if none exists.
	 */
	public Widget getWidget(string name)
	{
		// GtkWidget* glade_xml_get_widget (GladeXML *self,  const char *name);
		return newFromWidget( glade_xml_get_widget(gladeXML, Str.toStringz(name)) );
	}
	
	
	
	
	
	
	/**
	 * Creates a new GladeXML object (and the corresponding widgets) from the
	 * XML file fname. Optionally it will only build the interface from the
	 * widget node root (if it is not NULL). This feature is useful if you
	 * only want to build say a toolbar or menu from the XML file, but not the
	 * window it is embedded in. Note also that the XML parse tree is cached
	 * to speed up creating another GladeXML object for the same file
	 * Params:
	 *  fname = the XML file name.
	 *  root = the widget node in fname to start building from (or NULL)
	 *  domain = the translation domain for the XML file (or NULL for default)
	 */
	public this (string fname, string root = null, string domain=null)
	{
		// GladeXML* glade_xml_new (const char *fname,  const char *root,  const char *domain);
		this(cast(GladeXML*)glade_xml_new(Str.toStringz(fname),
		root ? Str.toStringz(root) : null,
		domain ? Str.toStringz(domain) : null) );
	}
	
	/**
	 * This function is used to get a list of pointers to the GtkWidget(s)
	 * with names that start with the string name in the interface description.
	 * You would use this if you have to do something to all of these widgets
	 * after loading.
	 * Params:
	 *  name = the name of the widget.
	 * Returns:
	 *  A list of the widget that match name as the start of their
	 *  name, or NULL if none exists.
	 */
	public Widget[] getWidgetPrefix(string name)
	{
		// GList* glade_xml_get_widget_prefix (GladeXML *self,  const char *name);
		Widget[] ret;
		ListG widgets = new ListG( glade_xml_get_widget_prefix(gladeXML, Str.toStringz(name)) );
		
		if (widgets  is null)
		return null;
		
		for (int i=0;i < widgets.length; i++)
		{
			ret ~= newFromWidget( cast(GtkWidget*)widgets.nthData(i) );
		}
		return ret;
	}
	
	
	private import gtkD.gobject.Type;
	private import gtkD.gtk.AboutDialog;
	private import gtkD.gtk.AccelLabel;
	private import gtkD.gtk.Alignment;
	private import gtkD.gtk.Arrow;
	private import gtkD.gtk.AspectFrame;
	private import gtkD.gtk.Assistant;
	private import gtkD.gtk.Bin;
	private import gtkD.gtk.Box;
	private import gtkD.gtk.ButtonBox;
	private import gtkD.gtk.Button;
	private import gtkD.gtk.Calendar;
	private import gtkD.gtk.CellView;
	private import gtkD.gtk.CheckButton;
	private import gtkD.gtk.CheckMenuItem;
	private import gtkD.gtk.ColorButton;
	private import gtkD.gtk.ColorSelection;
	private import gtkD.gtk.ColorSelectionDialog;
	private import gtkD.gtk.ComboBox;
	private import gtkD.gtk.ComboBoxEntry;
	private import gtkD.gtk.Container;
	private import gtkD.gtk.Curve;
	private import gtkD.gtk.Dialog;
	private import gtkD.gtk.DrawingArea;
	private import gtkD.gtk.Entry;
	private import gtkD.gtk.EventBox;
	private import gtkD.gtk.Expander;
	private import gtkD.gtk.FileChooserButton;
	private import gtkD.gtk.FileChooserDialog;
	private import gtkD.gtk.FileChooserWidget;
	private import gtkD.gtk.FileSelection;
	private import gtkD.gtk.Fixed;
	private import gtkD.gtk.FontButton;
	private import gtkD.gtk.FontSelection;
	private import gtkD.gtk.FontSelectionDialog;
	private import gtkD.gtk.Frame;
	private import gtkD.gtk.GammaCurve;
	private import gtkD.gtk.HandleBox;
	private import gtkD.gtk.HBox;
	private import gtkD.gtk.HButtonBox;
	private import gtkD.gtk.HPaned;
	private import gtkD.gtk.HRuler;
	private import gtkD.gtk.HScale;
	private import gtkD.gtk.HScrollbar;
	private import gtkD.gtk.HSeparator;
	private import gtkD.gtk.IconView;
	private import gtkD.gtk.Image;
	private import gtkD.gtk.ImageMenuItem;
	private import gtkD.gtk.InputDialog;
	private import gtkD.gtk.Invisible;
	private import gtkD.gtk.Item;
	private import gtkD.gtk.Label;
	private import gtkD.gtk.Layout;
	private import gtkD.gtk.LinkButton;
	private import gtkD.gtk.MenuBar;
	private import gtkD.gtk.Menu;
	private import gtkD.gtk.MenuItem;
	private import gtkD.gtk.MenuShell;
	private import gtkD.gtk.MenuToolButton;
	private import gtkD.gtk.MessageDialog;
	private import gtkD.gtk.Misc;
	private import gtkD.gtk.Notebook;
	private import gtkD.gtk.PageSetupUnixDialog;
	private import gtkD.gtk.Paned;
	private import gtkD.gtk.Plug;
	private import gtkD.gtk.PrintUnixDialog;
	private import gtkD.gtk.ProgressBar;
	private import gtkD.gtk.Progress;
	private import gtkD.gtk.RadioButton;
	private import gtkD.gtk.RadioMenuItem;
	private import gtkD.gtk.RadioToolButton;
	private import gtkD.gtk.Range;
	private import gtkD.gtk.RecentChooserDialog;
	private import gtkD.gtk.RecentChooserMenu;
	private import gtkD.gtk.RecentChooserWidget;
	private import gtkD.gtk.Ruler;
	private import gtkD.gtk.ScaleButton;
	private import gtkD.gtk.Scale;
	private import gtkD.gtk.Scrollbar;
	private import gtkD.gtk.ScrolledWindow;
	private import gtkD.gtk.Separator;
	private import gtkD.gtk.SeparatorMenuItem;
	private import gtkD.gtk.SeparatorToolItem;
	private import gtkD.gtk.Socket;
	private import gtkD.gtk.SpinButton;
	private import gtkD.gtk.Statusbar;
	private import gtkD.gtk.Table;
	private import gtkD.gtk.TearoffMenuItem;
	private import gtkD.gtk.TextView;
	private import gtkD.gtk.ToggleButton;
	private import gtkD.gtk.ToggleToolButton;
	private import gtkD.gtk.Toolbar;
	private import gtkD.gtk.ToolButton;
	private import gtkD.gtk.ToolItem;
	private import gtkD.gtk.TreeView;
	private import gtkD.gtk.VBox;
	private import gtkD.gtk.VButtonBox;
	private import gtkD.gtk.Viewport;
	private import gtkD.gtk.VolumeButton;
	private import gtkD.gtk.VPaned;
	private import gtkD.gtk.VRuler;
	private import gtkD.gtk.VScale;
	private import gtkD.gtk.VScrollbar;
	private import gtkD.gtk.VSeparator;
	private import gtkD.gtk.Widget;
	private import gtkD.gtk.Window;
	
	/**
	 * Utilitiy method to create objects that are castable.
	 *
	 */
	Widget newFromWidget(GtkWidget* ptr)
	{
		if (ptr is null) {
			return null;
		}
		
		GTypeInstance* gTypeInstance = cast(GTypeInstance*)(ptr);
		string tname = Type.name(gTypeInstance.gClass.gType);
		
		switch(tname) {
			case "GtkAboutDialog": return new AboutDialog(cast(GtkAboutDialog *)ptr);
			case "GtkAccelLabel": return new AccelLabel(cast(GtkAccelLabel *)ptr);
			case "GtkAlignment": return new Alignment(cast(GtkAlignment *)ptr);
			case "GtkArrow": return new Arrow(cast(GtkArrow *)ptr);
			case "GtkAspectFrame": return new AspectFrame(cast(GtkAspectFrame *)ptr);
			case "GtkAssistant": return new Assistant(cast(GtkAssistant *)ptr);
			case "GtkBin": return new Bin(cast(GtkBin *)ptr);
			case "GtkBox": return new Box(cast(GtkBox *)ptr);
			case "GtkButtonBox": return new ButtonBox(cast(GtkButtonBox *)ptr);
			case "GtkButton": return new Button(cast(GtkButton *)ptr);
			case "GtkCalendar": return new Calendar(cast(GtkCalendar *)ptr);
			case "GtkCellView": return new CellView(cast(GtkCellView *)ptr);
			case "GtkCheckButton": return new CheckButton(cast(GtkCheckButton *)ptr);
			case "GtkCheckMenuItem": return new CheckMenuItem(cast(GtkCheckMenuItem *)ptr);
			case "GtkColorButton": return new ColorButton(cast(GtkColorButton *)ptr);
			case "GtkColorSelection": return new ColorSelection(cast(GtkColorSelection *)ptr);
			case "GtkColorSelectionDialog": return new ColorSelectionDialog(cast(GtkColorSelectionDialog *)ptr);
			case "GtkComboBox": return new ComboBox(cast(GtkComboBox *)ptr);
			case "GtkComboBoxEntry": return new ComboBoxEntry(cast(GtkComboBoxEntry *)ptr);
			case "GtkContainer": return new Container(cast(GtkContainer *)ptr);
			case "GtkCurve": return new Curve(cast(GtkCurve *)ptr);
			case "GtkDialog": return new Dialog(cast(GtkDialog *)ptr);
			case "GtkDrawingArea": return new DrawingArea(cast(GtkDrawingArea *)ptr);
			case "GtkEntry": return new Entry(cast(GtkEntry *)ptr);
			case "GtkEventBox": return new EventBox(cast(GtkEventBox *)ptr);
			case "GtkExpander": return new Expander(cast(GtkExpander *)ptr);
			case "GtkFileChooserButton": return new FileChooserButton(cast(GtkFileChooserButton *)ptr);
			case "GtkFileChooserDialog": return new FileChooserDialog(cast(GtkFileChooserDialog *)ptr);
			case "GtkFileChooserWidget": return new FileChooserWidget(cast(GtkFileChooserWidget *)ptr);
			case "GtkFileSelection": return new FileSelection(cast(GtkFileSelection *)ptr);
			case "GtkFixed": return new Fixed(cast(GtkFixed *)ptr);
			case "GtkFontButton": return new FontButton(cast(GtkFontButton *)ptr);
			case "GtkFontSelection": return new FontSelection(cast(GtkFontSelection *)ptr);
			case "GtkFontSelectionDialog": return new FontSelectionDialog(cast(GtkFontSelectionDialog *)ptr);
			case "GtkFrame": return new Frame(cast(GtkFrame *)ptr);
			case "GtkGammaCurve": return new GammaCurve(cast(GtkGammaCurve *)ptr);
			case "GtkHandleBox": return new HandleBox(cast(GtkHandleBox *)ptr);
			case "GtkHBox": return new HBox(cast(GtkHBox *)ptr);
			case "GtkHButtonBox": return new HButtonBox(cast(GtkHButtonBox *)ptr);
			case "GtkHPaned": return new HPaned(cast(GtkHPaned *)ptr);
			case "GtkHRuler": return new HRuler(cast(GtkHRuler *)ptr);
			case "GtkHScale": return new HScale(cast(GtkHScale *)ptr);
			case "GtkHScrollbar": return new HScrollbar(cast(GtkHScrollbar *)ptr);
			case "GtkHSeparator": return new HSeparator(cast(GtkHSeparator *)ptr);
			case "GtkIconView": return new IconView(cast(GtkIconView *)ptr);
			case "GtkImage": return new Image(cast(GtkImage *)ptr);
			case "GtkImageMenuItem": return new ImageMenuItem(cast(GtkImageMenuItem *)ptr);
			case "GtkInputDialog": return new InputDialog(cast(GtkInputDialog *)ptr);
			case "GtkInvisible": return new Invisible(cast(GtkInvisible *)ptr);
			case "GtkItem": return new Item(cast(GtkItem *)ptr);
			case "GtkLabel": return new Label(cast(GtkLabel *)ptr);
			case "GtkLayout": return new Layout(cast(GtkLayout *)ptr);
			case "GtkLinkButton": return new LinkButton(cast(GtkLinkButton *)ptr);
			case "GtkMenuBar": return new MenuBar(cast(GtkMenuBar *)ptr);
			case "GtkMenu": return new Menu(cast(GtkMenu *)ptr);
			case "GtkMenuItem": return new MenuItem(cast(GtkMenuItem *)ptr);
			case "GtkMenuShell": return new MenuShell(cast(GtkMenuShell *)ptr);
			case "GtkMenuToolButton": return new MenuToolButton(cast(GtkMenuToolButton *)ptr);
			case "GtkMessageDialog": return new MessageDialog(cast(GtkMessageDialog *)ptr);
			case "GtkMisc": return new Misc(cast(GtkMisc *)ptr);
			case "GtkNotebook": return new Notebook(cast(GtkNotebook *)ptr);
			case "GtkPageSetupUnixDialog": return new PageSetupUnixDialog(cast(GtkPageSetupUnixDialog *)ptr);
			case "GtkPaned": return new Paned(cast(GtkPaned *)ptr);
			case "GtkPlug": return new Plug(cast(GtkPlug *)ptr);
			case "GtkPrintUnixDialog": return new PrintUnixDialog(cast(GtkPrintUnixDialog *)ptr);
			case "GtkProgressBar": return new ProgressBar(cast(GtkProgressBar *)ptr);
			case "GtkProgress": return new Progress(cast(GtkProgress *)ptr);
			case "GtkRadioButton": return new RadioButton(cast(GtkRadioButton *)ptr);
			case "GtkRadioMenuItem": return new RadioMenuItem(cast(GtkRadioMenuItem *)ptr);
			case "GtkRadioToolButton": return new RadioToolButton(cast(GtkRadioToolButton *)ptr);
			case "GtkRange": return new Range(cast(GtkRange *)ptr);
			case "GtkRecentChooserDialog": return new RecentChooserDialog(cast(GtkRecentChooserDialog *)ptr);
			case "GtkRecentChooserMenu": return new RecentChooserMenu(cast(GtkRecentChooserMenu *)ptr);
			case "GtkRecentChooserWidget": return new RecentChooserWidget(cast(GtkRecentChooserWidget *)ptr);
			case "GtkRuler": return new Ruler(cast(GtkRuler *)ptr);
			case "GtkScaleButton": return new ScaleButton(cast(GtkScaleButton *)ptr);
			case "GtkScale": return new Scale(cast(GtkScale *)ptr);
			case "GtkScrollbar": return new Scrollbar(cast(GtkScrollbar *)ptr);
			case "GtkScrolledWindow": return new ScrolledWindow(cast(GtkScrolledWindow *)ptr);
			case "GtkSeparator": return new Separator(cast(GtkSeparator *)ptr);
			case "GtkSeparatorMenuItem": return new SeparatorMenuItem(cast(GtkSeparatorMenuItem *)ptr);
			case "GtkSeparatorToolItem": return new SeparatorToolItem(cast(GtkSeparatorToolItem *)ptr);
			case "GtkSocket": return new Socket(cast(GtkSocket *)ptr);
			case "GtkSpinButton": return new SpinButton(cast(GtkSpinButton *)ptr);
			case "GtkStatusbar": return new Statusbar(cast(GtkStatusbar *)ptr);
			case "GtkTable": return new Table(cast(GtkTable *)ptr);
			case "GtkTearoffMenuItem": return new TearoffMenuItem(cast(GtkTearoffMenuItem *)ptr);
			case "GtkTextView": return new TextView(cast(GtkTextView *)ptr);
			case "GtkToggleButton": return new ToggleButton(cast(GtkToggleButton *)ptr);
			case "GtkToggleToolButton": return new ToggleToolButton(cast(GtkToggleToolButton *)ptr);
			case "GtkToolbar": return new Toolbar(cast(GtkToolbar *)ptr);
			case "GtkToolButton": return new ToolButton(cast(GtkToolButton *)ptr);
			case "GtkToolItem": return new ToolItem(cast(GtkToolItem *)ptr);
			case "GtkTreeView": return new TreeView(cast(GtkTreeView *)ptr);
			case "GtkVBox": return new VBox(cast(GtkVBox *)ptr);
			case "GtkVButtonBox": return new VButtonBox(cast(GtkVButtonBox *)ptr);
			case "GtkViewport": return new Viewport(cast(GtkViewport *)ptr);
			case "GtkVolumeButton": return new VolumeButton(cast(GtkVolumeButton *)ptr);
			case "GtkVPaned": return new VPaned(cast(GtkVPaned *)ptr);
			case "GtkVRuler": return new VRuler(cast(GtkVRuler *)ptr);
			case "GtkVScale": return new VScale(cast(GtkVScale *)ptr);
			case "GtkVScrollbar": return new VScrollbar(cast(GtkVScrollbar *)ptr);
			case "GtkVSeparator": return new VSeparator(cast(GtkVSeparator *)ptr);
			case "GtkWidget": return new Widget(cast(GtkWidget *)ptr);
			case "GtkWindow": return new Window(cast(GtkWindow *)ptr);
			default: return null;
		}
		
	}
	
	
	/**
	 * Description
	 * These routines are used to initialise libglade, and to load addon modules
	 * that recognise extra widget sets. The glade_init
	 * routine must be called before any libglade routines are used, and the
	 * glade_load_module routine would be used to load
	 * extra modules.
	 */
	
	/**
	 * Creates a new GladeXML object (and the corresponding widgets) from the
	 * buffer buffer. Optionally it will only build the interface from the
	 * widget node root (if it is not NULL). This feature is useful if you
	 * only want to build say a toolbar or menu from the XML document, but not the
	 * window it is embedded in.
	 * Params:
	 * buffer =  the memory buffer containing the XML document.
	 * size =  the size of the buffer.
	 * root =  the widget node in buffer to start building from (or NULL)
	 * domain =  the translation domain to use for this interface (or NULL)
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string buffer, int size, string root, string domain)
	{
		// GladeXML* glade_xml_new_from_buffer (const char *buffer,  int size,  const char *root,  const char *domain);
		auto p = glade_xml_new_from_buffer(Str.toStringz(buffer), size, Str.toStringz(root), Str.toStringz(domain));
		if(p is null)
		{
			throw new ConstructionException("null returned by glade_xml_new_from_buffer(Str.toStringz(buffer), size, Str.toStringz(root), Str.toStringz(domain))");
		}
		this(cast(GladeXML*) p);
	}
	
	/**
	 * This routine can be used by bindings (such as gtk--) to help construct
	 * a GladeXML object, if it is needed.
	 * Params:
	 * fname =  the XML filename
	 * root =  the root widget node (or NULL for none)
	 * domain =  the translation domain (or NULL for the default)
	 * Returns: TRUE if the construction succeeded.
	 */
	public int construct(string fname, string root, string domain)
	{
		// gboolean glade_xml_construct (GladeXML *self,  const char *fname,  const char *root,  const char *domain);
		return glade_xml_construct(gladeXML, Str.toStringz(fname), Str.toStringz(root), Str.toStringz(domain));
	}
	
	/**
	 * Used to get the name of a widget that was generated by a GladeXML object.
	 * Params:
	 * widget =  the widget
	 * Returns: the name of the widget.
	 */
	public static string gladeGetWidgetName(Widget widget)
	{
		// const char* glade_get_widget_name (GtkWidget *widget);
		return Str.toString(glade_get_widget_name((widget is null) ? null : widget.getWidgetStruct()));
	}
	
	/**
	 * This function is used to get the GladeXML object that built this widget.
	 * Params:
	 * widget =  the widget
	 * Returns: the GladeXML object that built this widget.
	 */
	public static Glade gladeGetWidgetTree(Widget widget)
	{
		// GladeXML* glade_get_widget_tree (GtkWidget *widget);
		auto p = glade_get_widget_tree((widget is null) ? null : widget.getWidgetStruct());
		if(p is null)
		{
			return null;
		}
		return new Glade(cast(GladeXML*) p);
	}
	
	/**
	 * It used to be necessary to call glade_init() before creating
	 * GladeXML objects. This is now no longer the case, as libglade will
	 * be initialised on demand now. Calling glade_init() manually will
	 * not cause any problems though.
	 */
	public static void init()
	{
		// void glade_init (void);
		glade_init();
	}
	
	/**
	 * Ensure that a required library is available. If it is not already
	 * available, libglade will attempt to dynamically load a module that
	 * contains the handlers for that library.
	 * Params:
	 * library =  the required library
	 */
	public static void require(string library)
	{
		// void glade_require (const gchar *library);
		glade_require(Str.toStringz(library));
	}
	
	/**
	 * This function should be called by a module to assert that it
	 * provides wrappers for a particular library. This should be called
	 * by the register_widgets() function of a libglade module so that it
	 * isn't loaded twice, for instance.
	 * Params:
	 * library =  the provided library
	 */
	public static void provide(string library)
	{
		// void glade_provide (const gchar *library);
		glade_provide(Str.toStringz(library));
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-glade");
        } else version (DigitalMars) {
            pragma(link, "DD-glade");
        } else {
            pragma(link, "DO-glade");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-glade");
        } else version (DigitalMars) {
            pragma(link, "DD-glade");
        } else {
            pragma(link, "DO-glade");
        }
    }
}
