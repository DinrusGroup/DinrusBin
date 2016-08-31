// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.picturebox;

private import os.win.gui.control, os.win.gui.base, os.win.gui.drawing, os.win.gui.event;
private import os.win.gui.x.winapi;


///
enum PictureBoxSizeMode: ubyte
{
	///
	NORMAL, // Image at upper left of control.
	/// ditto
	AUTO_SIZE, // Control sizes to fit image size.
	/// ditto
	CENTER_IMAGE, // Image at center of control.
	/// ditto
	STRETCH_IMAGE, // Image stretched to fit control.
}


///
class PictureBox: Control // docmain
{
	this();
	
	///
	final void image(Image img) ;
	
	/// ditto
	final Image image();
	
	///
	final void sizeMode(PictureBoxSizeMode sm) ;
	/// ditto
	final PictureBoxSizeMode sizeMode() ;
	///
	void borderStyle(BorderStyle bs) ;
	
	/// ditto
	BorderStyle borderStyle();
	
	//EventHandler sizeModeChanged;
	Event!(PictureBox, EventArgs) sizeModeChanged; ///
	//EventHandler imageChanged;
	Event!(PictureBox, EventArgs) imageChanged; ///
	
	
	protected:
	
	///
	void onSizeModeChanged(EventArgs ea);
	
	///
	void onImageChanged(EventArgs ea);
	
	override void onPaint(PaintEventArgs ea);
	
	override void onResize(EventArgs ea);
	
	private:
	PictureBoxSizeMode _mode = PictureBoxSizeMode.NORMAL;
	Image img = null;
}

