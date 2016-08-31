// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.panel;

private import os.win.gui.control, os.win.gui.base, os.win.gui.x.winapi;


///
class Panel: ContainerControl // docmain
{
	///
	void borderStyle(BorderStyle bs);
	/// ditto
	BorderStyle borderStyle() ;
	
	this();
}

