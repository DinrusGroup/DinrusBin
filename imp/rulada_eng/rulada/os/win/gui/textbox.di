// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.textbox;

private import os.win.gui.x.dlib;

private import os.win.gui.control, os.win.gui.base, os.win.gui.x.winapi, os.win.gui.application;
private import os.win.gui.drawing, os.win.gui.event, os.win.gui.x.utf;

version(DFL_NO_MENUS)
{
}
else
{
	private import os.win.gui.menu;
}


private extern(Windows) void _initTextBox();


// Note: ControlStyles.CACHE_TEXT might not work correctly with a text box.
// It's not actually a bug, but a limitation of this control.

///
abstract class TextBoxBase: ControlSuperClass // docmain
{
	///
	final void acceptsTab(bool byes) ;
	
	/// ditto
	final bool acceptsTab();
	
	///
	void borderStyle(BorderStyle bs);
	
	/// ditto
	BorderStyle borderStyle();
	
	///
	final bool canUndo() ;
	
	
	///
	final void hideSelection(bool byes) ;
	
	/// ditto
	final bool hideSelection() ;
	
	
	///
	final void lines(Dstring[] lns) ;
	
	/// ditto
	final Dstring[] lines();
	
	///
	void maxLength(uint len);
	
	/// ditto
	uint maxLength();
	
	///
	final uint getLineCount();
	
	
	///
	final void modified(bool byes);
	
	/// ditto
	final bool modified() ;
	
	
	///
	void multiline(bool byes) ;
	
	/// ditto
	bool multiline() ;
	
	///
	final void readOnly(bool byes) ;
	
	/// ditto
	final bool readOnly() ;
	
	///
	void selectedText(Dstring sel) ;
	
	/// ditto
	Dstring selectedText();
	
	
	///
	void selectionLength(uint len);
	
	/// ditto
	// Current selection length, in characters.
	// This does not necessarily correspond to the length of chars; some characters use multiple chars.
	// An end of line (\r\n) takes up 2 characters.
	uint selectionLength() ;
	
	///
	void selectionStart(uint pos) ;
	/// ditto
	// Current selection starting index, in characters.
	// This does not necessarily correspond to the index of chars; some characters use multiple chars.
	// An end of line (\r\n) takes up 2 characters.
	uint selectionStart() ;
	
	///
	// Number of characters in the textbox.
	// This does not necessarily correspond to the number of chars; some characters use multiple chars.
	// An end of line (\r\n) takes up 2 characters.
	// Return may be larger than the amount of characters.
	// This is a lot faster than retrieving the text, but retrieving the text is completely accurate.
	uint textLength();
	
	///
	final void wordWrap(bool byes);
	/// ditto
	final bool wordWrap();
	
	
	///
	final void appendText(Dstring txt);
	
	
	///
	final void clear();
	
	///
	final void clearUndo();
	
	///
	final void copy();
	
	
	///
	final void cut();
	
	///
	final void paste();
	
	
	///
	final void scrollToCaret();
	
	
	///
	final void select(uint start, uint length);
	
	alias Control.select select; // Overload.
	
	
	///
	final void selectAll();
	
	
	override Dstring toString();
	
	///
	final void undo();
	
	/+
	override void createHandle();
	+/
	
	
	override void createHandle();
	
	
	protected override void createParams(inout CreateParams cp);
	
	protected override void onHandleCreated(EventArgs ea);
	
	
	private
	{
		version(DFL_NO_MENUS)
		{
		}
		else
		{
			void menuUndo(Object sender, EventArgs ea);
			
			
			void menuCut(Object sender, EventArgs ea);
			
			void menuCopy(Object sender, EventArgs ea);
			
			
			void menuPaste(Object sender, EventArgs ea);
			
			
			void menuDelete(Object sender, EventArgs ea);
			
			void menuSelectAll(Object sender, EventArgs ea);
			
			bool isClipboardText();
			
			
			void menuPopup(Object sender, EventArgs ea);
			
			MenuItem miundo, micut, micopy, mipaste, midel, misel;
		}
	}
	
	
	this();
	
	override Color backColor() ;
	
	alias Control.backColor backColor; // Overload.
	
	
	static Color defaultBackColor();
	
	
	override Color foreColor() ;
	
	alias Control.foreColor foreColor; // Overload.
	
	
	static Color defaultForeColor() ;
	
	override Cursor cursor() ;
	alias Control.cursor cursor; // Overload.
	
	
	///
	int getFirstCharIndexFromLine(int line);
	
	/// ditto
	int getFirstCharIndexOfCurrentLine();
	
	///
	int getLineFromCharIndex(int charIndex);
	
	///
	Point getPositionFromCharIndex(int charIndex);
	/// ditto
	int getCharIndexFromPosition(Point pt);
	
	package static Cursor _defaultCursor() ;
	
	
	protected:
	protected override void onReflectedMessage(inout Message m);
	
	override void prevWndProc(inout Message msg);
	
	
	protected override bool processKeyEventArgs(inout Message msg) ;
	
	override void wndProc(inout Message msg);
	
	override Size defaultSize();
	
	private:
	package uint lim = 30_000; // Documented as default.
	bool _wrap = true;
	bool _hscroll;
	
	bool atab = false;
	
	/+
	bool atab() ;
	
	void atab(bool byes);
	+/
	
	
	void hscroll(bool byes);
	
	bool hscroll() ;
}


///
class TextBox: TextBoxBase // docmain
{
	///
	final void acceptsReturn(bool byes);
	
	/// ditto
	final bool acceptsReturn() ;
	
	///
	final void characterCasing(CharacterCasing cc) ;
	
	/// ditto
	final CharacterCasing characterCasing() ;
	
	///
	// Set to 0 (NUL) to remove.
	final void passwordChar(dchar pwc) ;
	/// ditto
	final dchar passwordChar() ;
	
	///
	final void scrollBars(ScrollBars sb);
	
	/// ditto
	final ScrollBars scrollBars() ;
	
	
	///
	final void textAlign(HorizontalAlignment ha) ;
	/// ditto
	final HorizontalAlignment textAlign();
	
	
	this();
	
	protected override void onHandleCreated(EventArgs ea);
	
	
	/+
	override void wndProc(inout Message msg);
	+/
	
	
	private:
	dchar passchar = 0;
}

