module wx.FileDialog;
public import wx.common;
public import wx.Dialog;
public import wx.ArrayString;


		//! \cond EXTERN
        static extern (C) IntPtr wxFileDialog_ctor(IntPtr parent, string message, string defaultDir, string defaultFile, string wildcard, uint style, inout Point pos);
        static extern (C) void   wxFileDialog_dtor(IntPtr self);

        static extern (C) IntPtr wxFileDialog_GetDirectory(IntPtr self);
        static extern (C) void   wxFileDialog_SetDirectory(IntPtr self, string dir);

        static extern (C) IntPtr wxFileDialog_GetFilename(IntPtr self);
        static extern (C) void   wxFileDialog_SetFilename(IntPtr self, string filename);

        static extern (C) IntPtr wxFileDialog_GetPath(IntPtr self);
        static extern (C) void   wxFileDialog_SetPath(IntPtr self, string path);

        static extern (C) void   wxFileDialog_SetFilterIndex(IntPtr self, int filterIndex);
        static extern (C) int    wxFileDialog_GetFilterIndex(IntPtr self);

        static extern (C) IntPtr wxFileDialog_GetWildcard(IntPtr self);
        static extern (C) void   wxFileDialog_SetWildcard(IntPtr self, string wildcard);

        static extern (C) void   wxFileDialog_SetMessage(IntPtr self, string message);
        static extern (C) IntPtr wxFileDialog_GetMessage(IntPtr self);

        static extern (C) int    wxFileDialog_ShowModal(IntPtr self);

        static extern (C) int    wxFileDialog_GetStyle(IntPtr self);
        static extern (C) void   wxFileDialog_SetStyle(IntPtr self, int style);

        static extern (C) IntPtr wxFileDialog_GetPaths(IntPtr self);
        static extern (C) IntPtr wxFileDialog_GetFilenames(IntPtr self);
		//! \endcond

        //---------------------------------------------------------------------

    alias FileDialog wxFileDialog;
    public class FileDialog : Dialog
    {
        public const int wxOPEN              = 0x0001;
        public const int wxSAVE              = 0x0002;
        public const int wxOVERWRITE_PROMPT  = 0x0004;
        public const int wxHIDE_READONLY     = 0x0008;
        public const int wxFILE_MUST_EXIST   = 0x0010;
        public const int wxMULTIPLE          = 0x0020;
        public const int wxCHANGE_DIR        = 0x0040;

	public const string wxFileSelectorPromptStr = "Выберите файл";
	version(__WXMSW__) {
		public const string wxFileSelectorDefaultWildcardStr = "*.*";
	} else {
		public const string wxFileSelectorDefaultWildcardStr = "*";
	}

        public this(IntPtr wxobj);
        public this(Window parent, string message = wxFileSelectorPromptStr, string defaultDir = "", string defaultFile = "", string wildcard = wxFileSelectorDefaultWildcardStr , int style = 0, Point pos = wxDefaultPosition);
        public string Directory();
        public void Directory(string value) ;
        public string Filename();
        public void Filename(string value);
        public string Path() ;
        public void Path(string value) ;
        public void FilterIndex(int value) ;
		public int FilterIndex() ;
        public void Message(string value);
        public string Message() ;
        public override int ShowModal();
        public string Wildcard();
        public void Wildcard(string value) ;
        public int Style() ;
        public void Style(int value) ;
        public string[] Paths() ;
        public string[] Filenames() ;
    }

	//! \cond EXTERN
	static extern (C) IntPtr wxFileSelector_func(string message, string default_path, string default_filename, string default_extension, string wildcard, int flags, IntPtr parent, int x, int y);
	static extern (C) IntPtr wxFileSelectorEx_func(string message, string default_path, string default_filename,int *indexDefaultExtension, string wildcard, int flags, IntPtr parent, int x, int y);
	static extern (C) IntPtr wxLoadFileSelector_func(string what, string extension, string default_name, IntPtr parent);
	static extern (C) IntPtr wxSaveFileSelector_func(string what, string extension, string default_name, IntPtr parent);
	//! \endcond

string FileSelector(
	string message = FileDialog.wxFileSelectorPromptStr,
	string default_path = null,
	string default_filename = null,
	string default_extension = null,
	string wildcard = FileDialog.wxFileSelectorDefaultWildcardStr,
	int flags = 0,
	Window parent = null, int x = -1, int y = -1);

string FileSelectorEx(
	string message = FileDialog.wxFileSelectorPromptStr,
	string default_path = null,
	string default_filename = null,
	int *indexDefaultExtension = null,
	string wildcard = FileDialog.wxFileSelectorDefaultWildcardStr,
	int flags = 0,
	Window parent = null, int x = -1, int y = -1);

string LoadFileSelector(
	string what,
	string extension,
	string default_name = null,
	Window parent = null);

string SaveFileSelector(
	string what,
	string extension,
	string default_name = null,
	Window parent = null);

