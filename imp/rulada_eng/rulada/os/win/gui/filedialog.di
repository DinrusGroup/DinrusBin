// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.filedialog;

private import os.win.gui.x.dlib;

private import os.win.gui.control, os.win.gui.x.winapi, os.win.gui.base, os.win.gui.drawing;
private import os.win.gui.application, os.win.gui.commondialog, os.win.gui.event, os.win.gui.x.utf;


///
abstract class FileDialog: CommonDialog // docmain
{
	private this();
	
	override DialogResult showDialog();
	
	override DialogResult showDialog(IWindow owner);
	
	override void reset();
	
	
	private void initInstance();
	
	/+
	final void addExtension(bool byes) ;
	
	final bool addExtension() ;
	+/
	
	
	///
	void checkFileExists(bool byes);
	/// ditto
	bool checkFileExists() ;
	///
	final void checkPathExists(bool byes) ;
	
	/// ditto
	final bool checkPathExists();
	
	///
	final void defaultExt(Dstring ext) ;
	
	/// ditto
	final Dstring defaultExt() ;
	
	///
	final void dereferenceLinks(bool byes) ;
	
	/// ditto
	final bool dereferenceLinks() ;
	
	///
	final void fileName(Dstring fn) ;
	
	/// ditto
	final Dstring fileName();
	
	///
	final Dstring[] fileNames() ;
	
	///
	// The format string is like "Text files (*.txt)|*.txt|All files (*.*)|*.*".
	final void filter(Dstring filterString) ;
	
	/// ditto
	final Dstring filter() ;
	
	///
	// Note: index is 1-based.
	final void filterIndex(int index);
	/// ditto
	final int filterIndex() ;
	
	
	///
	final void initialDirectory(Dstring dir);
	
	/// ditto
	final Dstring initialDirectory();
	
	// Should be instance(), but conflicts with D's old keyword.
	
	///
	protected void inst(HINSTANCE hinst) ;
	
	/// ditto
	protected HINSTANCE inst() ;
	///
	protected DWORD options() ;
	
	///
	final void restoreDirectory(bool byes) ;
	/// ditto
	final bool restoreDirectory();
	
	///
	final void showHelp(bool byes) ;
	
	/// ditto
	final bool showHelp() ;
	
	///
	final void title(Dstring newTitle);
	/// ditto
	final Dstring title() ;
	
	///
	final void validateNames(bool byes) ;
	/// ditto
	final bool validateNames() ;
	///
	Event!(FileDialog, CancelEventArgs) fileOk;
	
	
	protected:
	
	override bool runDialog(HWND owner);
	
	///
	void onFileOk(CancelEventArgs ea);
	
	override LRESULT hookProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam);
	
	private:
	union
	{
		OPENFILENAMEW ofnw;
		OPENFILENAMEA ofna;
		alias ofnw ofn;
		
		static assert(OPENFILENAMEW.sizeof == OPENFILENAMEA.sizeof);
		static assert(OPENFILENAMEW.Flags.offsetof == OPENFILENAMEA.Flags.offsetof);
	}
	Dstring[] _fileNames;
	Dstring _filter;
	Dstring _initDir;
	Dstring _defext;
	Dstring _title;
	//bool addext = true;
	bool needRebuildFiles = false;
	
	const DWORD INIT_FLAGS = OFN_EXPLORER | OFN_PATHMUSTEXIST | OFN_HIDEREADONLY |
		OFN_ENABLEHOOK | OFN_ENABLESIZING;
	const int INIT_FILTER_INDEX = 0;
	const int FILE_BUF_LEN = 4096; // ? 12288 ? 12800 ?
	
	
	void beginOfn(HWND owner);
	
	// Populate -_fileNames- from -ofn.lpstrFile-.
	void populateFiles();
	
	// Call only if the dialog succeeded.
	void finishOfn();
	
	
	// Call only if dialog fail or cancel.
	void cancelOfn();
}


private extern(Windows)
{
	alias BOOL function(LPOPENFILENAMEW lpofn) GetOpenFileNameWProc;
	alias BOOL function(LPOPENFILENAMEW lpofn) GetSaveFileNameWProc;
}


///
class OpenFileDialog: FileDialog // docmain
{
	this();
	
	override void reset();
	
	///
	final void multiselect(bool byes) ;
	
	/// ditto
	final bool multiselect() ;
	
	///
	final void readOnlyChecked(bool byes) ;
	/// ditto
	final bool readOnlyChecked();
	
	///
	final void showReadOnly(bool byes);
	/// ditto
	final bool showReadOnly() ;
	
	version(Tango)
	{
		// TO-DO: not implemented yet.
	}
	else
	{
		private import std.stream; // TO-DO: remove this import; use os.win.gui.x.dlib.
		
		///
		final Stream openFile();
	}
	
	
	protected:
	
	override bool runDialog(HWND owner);
	
	private BOOL _runDialog(HWND owner);
}


///
class SaveFileDialog: FileDialog // docmain
{
	this();
	
	override void reset();
	
	///
	final void createPrompt(bool byes) ;
	
	/// ditto
	final bool createPrompt() ;
	///
	final void overwritePrompt(bool byes) ;
	
	/// ditto
	final bool overwritePrompt();
	
	version(Tango)
	{
		// TO-DO: not implemented yet.
	}
	else
	{
		private import std.stream; // TO-DO: remove this import; use os.win.gui.x.dlib.
			
		///
		// Opens and creates with read and write access.
		// Warning: if file exists, it's truncated.
		final Stream openFile();
	}
	
	
	protected:
	
	override bool runDialog(HWND owner);
}


private extern(Windows) LRESULT ofnHookProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam);

