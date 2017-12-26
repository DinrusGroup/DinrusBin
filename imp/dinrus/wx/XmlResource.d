module wx.XmlResource;
public import wx.common;
public import wx.Dialog;
public import wx.Window;
public import wx.Frame;
public import wx.Menu;
public import wx.MenuBar;
public import wx.Panel;
public import wx.ToolBar;

	public enum XmlResourceFlags : int
	{
		XRC_USE_LOCALE     = 1,
		XRC_NO_SUBCLASSING = 2
	};

		//! \cond EXTERN
		static extern (C) void wxXmlResource_InitAllHandlers(IntPtr self);
		static extern (C) bool wxXmlResource_Load(IntPtr self, string filemask);
		static extern (C) bool wxXmlResource_LoadFromByteArray(IntPtr self, string filemask, IntPtr data, int length);
		static extern (C) IntPtr wxXmlResource_LoadDialog(IntPtr self, IntPtr parent, string name);
		static extern (C) bool wxXmlResource_LoadDialogDlg(IntPtr self, IntPtr dlg, IntPtr parent, string name);
		static extern (C) int wxXmlResource_GetXRCID(string str_id);
		static extern (C) IntPtr wxXmlResource_ctorByFilemask(string filemask, int flags);
		static extern (C) IntPtr wxXmlResource_ctor(int flags);
		static extern (C) uint wxXmlResource_GetVersion(IntPtr self);
		static extern (C) bool wxXmlResource_LoadFrameWithFrame(IntPtr self, IntPtr frame, IntPtr parent, string name);
		static extern (C) IntPtr wxXmlResource_LoadFrame(IntPtr self, IntPtr parent, string name);
		static extern (C) IntPtr wxXmlResource_LoadBitmap(IntPtr self, string name);
		static extern (C) IntPtr wxXmlResource_LoadIcon(IntPtr self, string name);
		static extern (C) IntPtr wxXmlResource_LoadMenu(IntPtr self, string name);
		static extern (C) IntPtr wxXmlResource_LoadMenuBarWithParent(IntPtr self, IntPtr parent, string name);
		static extern (C) IntPtr wxXmlResource_LoadMenuBar(IntPtr self, string name);
		static extern (C) bool wxXmlResource_LoadPanelWithPanel(IntPtr self, IntPtr panel, IntPtr parent, string name);
		static extern (C) IntPtr wxXmlResource_LoadPanel(IntPtr self, IntPtr parent, string name);
		static extern (C) IntPtr wxXmlResource_LoadToolBar(IntPtr self, IntPtr parent, string name);
		static extern (C) int wxXmlResource_SetFlags(IntPtr self, int flags);
		static extern (C) int wxXmlResource_GetFlags(IntPtr self);
		static extern (C) void wxXmlResource_UpdateResources(IntPtr self);
		static extern (C) int wxXmlResource_CompareVersion(IntPtr self, int major, int minor, int release, int revision);
		static extern (C) bool wxXmlResource_AttachUnknownControl(IntPtr self, string name, IntPtr control, IntPtr parent);

		//---------------------------------------------------------------------

		extern (C) {
		alias IntPtr function(string className) XmlSubclassCreate;
		}

		static extern (C) bool wxXmlSubclassFactory_ctor(XmlSubclassCreate create);
		//! \endcond

	alias XmlResource wxXmlResource;
	public class XmlResource : wxObject
	{
		public static XmlResource globalXmlResource = null;

		//---------------------------------------------------------------------

		static this();
		private static void SetSubclassDefaults() ;

/+
		// Sets the default assembly/namespace based on the assembly from
		// which this method is called (i.e. your assembly!).
		//
		// Determines these by walking a stack trace. Normally
		// Assembly.GetCallingAssembly should work but in my tests it
		// returned the current assembly in the static constructor above.
		private static void SetSubclassDefaults()
		{
			string my_assembly = Assembly.GetExecutingAssembly().GetName().Name;
			StackTrace st = new StackTrace();

			for (int i = 0; i < st.FrameCount; ++i)
			{
				Type type = st.GetFrame(i).GetMethod().ReflectedType;
				string st_assembly = type.Assembly.GetName().Name;
				if (st_assembly != my_assembly)
				{
					_CallerNamespace = type.Namespace;
					_CallerAssembly = st_assembly;
					stdout.writeLine("Setting sub-class default assembly to {0}, namespace to {1}", _CallerAssembly, _CallerNamespace);
					break;
				}
			}
		}

		// Get/set the assembly used for sub-classing. If this is not set, the
		// assembly of the class that invokes one of the LoadXXX() methods
		// will be used. This property is only used if an assembly is not
		// specified in the XRC XML subclass property via the [assembly]class
		// syntax.
		static void SubclassAssembly(string value) { _SubclassAssembly = value; }
		static string SubclassAssembly() { return _SubclassAssembly; }
		static string _SubclassAssembly;

		// Get/set the namespace that is pre-pended to class names in sub-classing.
		// This is only used if class name does not have a dot (.) in it. If
		// this is not specified and the class does not already have a namespace
		// specified, the namespace of the class which invoked the LoadXXX() method
		// is used.
		static void SubclassNamespace(string value) { _SubclassNamespace = value; }
		static string SubclassNamespace() { return _SubclassNamespace; }
		static string _SubclassNamespace;

		// Defaults set via LoadXXX() methods
		private static string _CallerAssembly;
		private static string _CallerNamespace;
+/

		//---------------------------------------------------------------------

		public this();
		public this(IntPtr wxobj);
		public this(XmlResourceFlags flags);
		public this(string filemask, XmlResourceFlags flags);
		public static XmlResource Get();
		public static XmlResource Set(XmlResource res);
		public void InitAllHandlers();
		public bool Load(string filemask);
		public Dialog LoadDialog(Window parent, string name);
		public bool LoadDialog(Dialog dlg, Window parent, string name);
		public static int GetXRCID(string str_id);
		public static int XRCID(string str_id);
		public int Version() ;
		public bool LoadFrame(Frame frame, Window parent, string name);
		public Frame LoadFrame(Window parent, string name);
		public Menu LoadMenu(string name);
		public MenuBar LoadMenuBar(Window parent, string name);
		public MenuBar LoadMenuBar(string name);
		public bool LoadPanel(Panel panel, Window parent, string name);
		public Panel LoadPanel(Window parent, string name);
		public ToolBar LoadToolBar(Window parent, string name);
		public void Flags(XmlResourceFlags value);
		public XmlResourceFlags Flags();
		//public void UpdateResources();
		public Bitmap LoadBitmap(string name);
		public Icon LoadIcon(string name);
		public int CompareVersion(int major, int minor, int release, int revision);
		public bool AttachUnknownControl(string name, Window control);
		public bool AttachUnknownControl(string name, Window control, Window parent);
		public static wxObject XRCCTRL(Window window, string id, newfunc func);
		//---------------------------------------------------------------------
		// XmlResource control subclassing

		private static XmlSubclassCreate m_create; // = cast(XmlSubclassCreate)&XmlSubclassCreateCS;
		//private static IntPtr function(string className) m_create = &XmlSubclassCreateCS;

		extern(C) private static IntPtr XmlSubclassCreateCS(string className);

	}
