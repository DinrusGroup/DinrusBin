// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.richtextbox;

private import os.win.gui.textbox, os.win.gui.x.winapi, os.win.gui.event, os.win.gui.application;
private import os.win.gui.base, os.win.gui.drawing, os.win.gui.data;
private import os.win.gui.control, os.win.gui.x.utf, os.win.gui.x.dlib;

version(DFL_NO_MENUS)
{
}
else
{
	private import os.win.gui.menu;
}


private extern(C) char* strcpy(char*, char*);


private extern(Windows) void _initRichtextbox();


///
class LinkClickedEventArgs: EventArgs
{
	///
	this(Dstring linkText);
	
	
	///
	final Dstring linkText() ;
	
	
	private:
	Dstring _linktxt;
}


///
enum RichTextBoxScrollBars: ubyte
{
	NONE, ///
	HORIZONTAL, /// ditto
	VERTICAL, /// ditto
	BOTH, /// ditto
	FORCED_HORIZONTAL, /// ditto
	FORCED_VERTICAL, /// ditto
	FORCED_BOTH, /// ditto
}


///
class RichTextBox: TextBoxBase // docmain
{
	this();
	
	
	private
	{
		version(DFL_NO_MENUS)
		{
		}
		else
		{
			void menuRedo(Object sender, EventArgs ea);
			
			
			void menuPopup2(Object sender, EventArgs ea);
			
			
			MenuItem miredo;
		}
	}
	
	
	override Cursor cursor() ;
	alias TextBoxBase.cursor cursor; // Overload.
	
	
	override Dstring selectedText() ;
	alias TextBoxBase.selectedText selectedText; // Overload.
	
	
	override void selectionLength(uint len);
	
	// Current selection length, in characters.
	// This does not necessarily correspond to the length of chars; some characters use multiple chars.
	// An end of line (\r\n) takes up 2 characters.
	override uint selectionLength() ;
	
	override void selectionStart(uint pos) ;
	
	// Current selection starting index, in characters.
	// This does not necessarily correspond to the index of chars; some characters use multiple chars.
	// An end of line (\r\n) takes up 2 characters.
	override uint selectionStart() ;
	
	override void maxLength(uint len) ;
	alias TextBoxBase.maxLength maxLength; // Overload.
	
	
	override Size defaultSize() ;
	
	private void _setbk(Color c);
	
	override void backColor(Color c) ;
	alias TextBoxBase.backColor backColor; // Overload.
	
	
	private void _setfc(Color c);
	
	override void foreColor(Color c) ;
	alias TextBoxBase.foreColor foreColor; // Overload.
	
	
	///
	final bool canRedo();
	
	///
	final bool canPaste(DataFormats.Format df);
	
	///
	final void redo();
	
	///
	// "Paste special."
	final void paste(DataFormats.Format df);
	alias TextBoxBase.paste paste; // Overload.
	
	
	///
	final void selectionCharOffset(int yoffset) ;
	/// ditto
	final int selectionCharOffset();
	
	///
	final void selectionColor(Color c) ;
	/// ditto
	final Color selectionColor() ;
	///
	final void selectionBackColor(Color c);
	/// ditto
	final Color selectionBackColor() ;
	
	///
	final void selectionSubscript(bool byes) ;
	
	/// ditto
	final bool selectionSubscript();
	
	///
	final void selectionSuperscript(bool byes);
	/// ditto
	final bool selectionSuperscript() ;
	
	
	private const DWORD FONT_MASK = CFM_BOLD | CFM_ITALIC | CFM_STRIKEOUT |
		CFM_UNDERLINE | CFM_CHARSET | CFM_FACE | CFM_SIZE | CFM_UNDERLINETYPE | CFM_WEIGHT;
	
	///
	final void selectionFont(Font f) ;
	/// ditto
	// Returns null if the selection has different fonts.
	final Font selectionFont();
	
	///
	final void selectionBold(bool byes) ;
	/// ditto
	final bool selectionBold() ;
	
	
	///
	final void selectionUnderline(bool byes) ;
	
	/// ditto
	final bool selectionUnderline() ;
	
	///
	final void scrollBars(RichTextBoxScrollBars sb) ;
	/// ditto
	final RichTextBoxScrollBars scrollBars();
	
	///
	override int getLineFromCharIndex(int charIndex);
	
	private void _getFormat(CHARFORMAT2A* cf, BOOL selection = TRUE);
	private void _setFormat(CHARFORMAT2A* cf, WPARAM scf = SCF_SELECTION);
	
	private struct _StreamStr
	{
		Dstring str;
	}
	
	
	// Note: RTF should only be ASCII so no conversions are necessary.
	// TODO: verify this; I'm not certain.
	
	private void _streamIn(UINT fmt, Dstring str);
	
	private Dstring _streamOut(UINT fmt);
	
	///
	final void selectedRtf(Dstring rtf) ;
	/// ditto
	final Dstring selectedRtf();
	///
	final void rtf(Dstring newRtf);
	/// ditto
	final Dstring rtf() ;
	
	///
	final void detectUrls(bool byes);
	/// ditto
	final bool detectUrls() ;
	
	/+
	override void createHandle();
	+/
	
	
	/+
	override void createHandle();
	+/
	
	
	protected override void createParams(inout CreateParams cp);
	
	//LinkClickedEventHandler linkClicked;
	Event!(RichTextBox, LinkClickedEventArgs) linkClicked; ///
	
	
	protected:
	
	///
	void onLinkClicked(LinkClickedEventArgs ea);
	
	private Dstring _getRange(LONG min, LONG max);
	
	protected override void onReflectedMessage(inout Message m);
	
	override void onHandleCreated(EventArgs ea);
	
	private:
	bool autoUrl = true;
}


private extern(Windows) DWORD _streamingInStr(DWORD dwCookie, LPBYTE pbBuff, LONG cb, LONG* pcb);

private extern(Windows) DWORD _streamingOutStr(DWORD dwCookie, LPBYTE pbBuff, LONG cb, LONG* pcb);
