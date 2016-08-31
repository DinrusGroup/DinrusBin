/*
* The X11/MIT License
* 
* Copyright (c) 2008-2009, Jonas Kivi
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

module rae.canvas.IRootWindow;

import tango.util.log.Trace;//Thread safe console output.

import tango.time.StopWatch;

//import tango.util.container.LinkedList;
import rae.canvas.Rectangle;

interface IRootWindow
{
public:
	void grabInputRootWindow( Rectangle set );
	bool ungrabInputRootWindow( Rectangle set );
	void grabKeyInputRootWindow( Rectangle set );
	void ungrabKeyInputRootWindow( Rectangle set );
	
	///Asks to redraw the whole rootWindow:
	void invalidate();
	
	
	//High precision timing:
	double frameTime();	
	
	//float pixel();

	//For to be able to create MenuWindows...
	void addFloating( Rectangle a_widget );
	void removeFromCanvas( Rectangle a_widget );
	//void add( Rectangle a_widget );
	//void remove( Rectangle a_widget );
}


version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    }
}
