
module wx.HtmlHelpController;
public import wx.common;

public import wx.Config;
public import wx.Frame;

		//! \cond EXTERN
		static extern (C) IntPtr wxHtmlHelpController_ctor(int style);
		static extern (C) void   wxHtmlHelpController_SetTitleFormat(IntPtr self, string format);
		static extern (C) void   wxHtmlHelpController_SetTempDir(IntPtr self, string path);
		static extern (C) bool   wxHtmlHelpController_AddBook(IntPtr self, string book_url);
		static extern (C) bool   wxHtmlHelpController_Display(IntPtr self, string x);
		static extern (C) bool   wxHtmlHelpController_DisplayInt(IntPtr self, int id);
		static extern (C) bool   wxHtmlHelpController_DisplayContents(IntPtr self);
		static extern (C) bool   wxHtmlHelpController_DisplayIndex(IntPtr self);
		static extern (C) bool   wxHtmlHelpController_KeywordSearch(IntPtr self, string keyword, int mode);
		static extern (C) void   wxHtmlHelpController_UseConfig(IntPtr self, IntPtr config, string rootpath);
		static extern (C) void   wxHtmlHelpController_ReadCustomization(IntPtr self, IntPtr cfg, string path);
		static extern (C) void   wxHtmlHelpController_WriteCustomization(IntPtr self, IntPtr cfg, string path);
		static extern (C) IntPtr wxHtmlHelpController_GetFrame(IntPtr self);
		//! \endcond
		
		//-----------------------------------------------------------------------------
		
	alias HtmlHelpController wxHtmlHelpController;
	public class HtmlHelpController : wxObject
	{
		enum {
			wxHF_TOOLBAR =	0x0001,
			wxHF_CONTENTS =	0x0002,
			wxHF_INDEX =		0x0004,
			wxHF_SEARCH =		0x0008,
			wxHF_BOOKMARKS =	0x0010,
			wxHF_OPEN_FILES =	0x0020,
			wxHF_PRINT = 		0x0040,
			wxHF_FLAT_TOOLBAR =	0x0080,
			wxHF_MERGE_BOOKS =	0x0100,
			wxHF_ICONS_BOOK =	0x0200,
			wxHF_ICONS_BOOK_CHAPTER = 0x0400,
			wxHF_ICONS_FOLDER = 0x0000,
			wxHF_DEFAULT_STYLE =		(wxHF_TOOLBAR | wxHF_CONTENTS | 
					wxHF_INDEX | wxHF_SEARCH | 
					wxHF_BOOKMARKS | wxHF_PRINT),
			wxHF_OPENFILES =	wxHF_OPEN_FILES,
			wxHF_FLATTOOLBAR = 	wxHF_FLAT_TOOLBAR,
			wxHF_DEFAULTSTYLE =	wxHF_DEFAULT_STYLE,
		}
		//-----------------------------------------------------------------------------
	
		public this(IntPtr wxobj);
		public this(int style = wxHF_DEFAULT_STYLE);
		public void TitleFormat(string value);
		public void TempDir(string value);
		public bool AddBook(string book_url);
		public bool Display(string x);
		public bool Display(int id);
		public bool DisplayContents();
		public bool DisplayIndex();
		public bool KeywordSearch(string keyword);
		public bool KeywordSearch(string keyword, HelpSearchMode mode);
		public void UseConfig(Config config);
		public void UseConfig(Config config, string rootpath);
		public void ReadCustomization(Config cfg);
		public void ReadCustomization(Config cfg, string path);
		public void WriteCustomization(Config cfg);
		public void WriteCustomization(Config cfg, string path);
		public Frame frame() ;
	}
