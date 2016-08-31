// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.button;

private import os.win.gui.base, os.win.gui.control, os.win.gui.application, os.win.gui.x.winapi;
private import os.win.gui.event, os.win.gui.drawing, os.win.gui.x.dlib;


private extern(Windows) void _initButton();


///
abstract class ButtonBase: ControlSuperClass // docmain
{
	///
	void textAlign(ContentAlignment calign);
	
	/// ditto
	ContentAlignment textAlign();
	
	
	// Border stuff...
	
	
	/+
	override void createHandle();
	+/
	
	
	protected override void createParams(inout CreateParams cp);
	
	
	protected override void prevWndProc(inout Message msg);
	
	protected override void onReflectedMessage(inout Message m);
	
	
	protected override void wndProc(inout Message msg);
	
	
	/+
	protected override void onHandleCreated(EventArgs ea)
	{
		super.onHandleCreated(ea);
		
		/+
		// Done in createParams() now.
		if(isdef)
			SetWindowLongA(handle, GWL_ID, IDOK);
		+/
	}
	+/
	
	
	this();
	
	protected:
	
	///
	final void isDefault(bool byes);
	
	/// ditto
	final bool isDefault() ;
	
	
	protected override bool processMnemonic(dchar charCode);
	
	
	///
	Size defaultSize();
	
	
	private:
	bool isdef = false;
	
	
	package:
	final:
	// Automatically redraws button styles, unlike _style().
	// Don't use with regular window styles ?
	void _bstyle(LONG newStyle);
	
	
	LONG _bstyle();
}


///
class Button: ButtonBase, IButtonControl // docmain
{
	this();
	
	///
	DialogResult dialogResult() ;
	
	/// ditto
	void dialogResult(DialogResult dr) ;
	
	
	///
	// True if default button.
	void notifyDefault(bool byes);
	
	///
	void performClick();
	
	protected override void onClick(EventArgs ea);
	
	
	protected override void wndProc(inout Message m);
	
	override void text(Dstring txt) ;
	
	alias Control.text text; // Overload.
	
	
	///
	final Image image() ;
	
	/// ditto
	final void image(Image img);
	
	
	private void setImg(LONG bsImageStyle);
	
	protected override void onHandleCreated(EventArgs ea);
	
	protected override void onHandleDestroyed(EventArgs ea);
	
	private:
	DialogResult dresult = DialogResult.NONE;
	Image _img = null;
	//Bitmap _picbm = null; // If -_img- is a Picture, need to keep a separate Bitmap.
}


///
class CheckBox: ButtonBase // docmain
{
	///
	final void appearance(Appearance ap);
	/// ditto
	final Appearance appearance();
	
	///
	final void autoCheck(bool byes);
	
	/// ditto
	final bool autoCheck();
	
	this();
	
	/+
	protected override void onClick(EventArgs ea);
	+/
	
	
	///
	final void checked(bool byes);
	/// ditto
	// Returns true for indeterminate too.
	final bool checked() ;
	
	///
	final void checkState(CheckState st) ;
	
	/// ditto
	final CheckState checkState() ;
	
	protected override void onHandleCreated(EventArgs ea);
	
	
	private:
	CheckState _check = CheckState.UNCHECKED; // Not always accurate.
	bool _autocheck = true;
	
	
	void _updateState();
}


///
class RadioButton: ButtonBase // docmain
{
	///
	final void appearance(Appearance ap) ;
	
	/// ditto
	final Appearance appearance() ;
	
	///
	final void autoCheck(bool byes) ;
	
	/// ditto
	final bool autoCheck();
	
	this();
	
	
	protected override void onClick(EventArgs ea);
	
	
	/+
	protected override void onClick(EventArgs ea);
	+/
	
	
	///
	final void checked(bool byes) ;
	
	/// ditto
	// Returns true for indeterminate too.
	final bool checked();
	
	///
	final void checkState(CheckState st);
	
	/// ditto
	final CheckState checkState();
	
	
	///
	void performClick();
	
	protected override void onHandleCreated(EventArgs ea);
	
	/+
	protected override void onReflectedMessage(inout Message m);
	+/
	
	
	/+ package +/ /+ protected +/ override int _rtype() // package
	{
		if(autoCheck)
			return 1 | 8; // Radio button + auto check.
		return 1; // Radio button.
	}
	
	
	private:
	CheckState _check = CheckState.UNCHECKED; // Not always accurate.
	bool _autocheck = true;
	
	
	void _updateState();
}

