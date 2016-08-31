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

module rae.ui.MultiLineText;

import tango.util.log.Trace;//Thread safe console output.

import Util = tango.text.Util;

//import tango.util.container.LinkedList;
//import tango.core.Signal;
//import Float = tango.text.convert.Float;

import rae.ui.Label;
import rae.ui.Widget;
import rae.ui.Box;

class MultiLineText : VBox
{
	this()
	{
		super();
		signalScrollUp.attach(&defaultScrollMouseHandler);
		signalScrollDown.attach(&defaultScrollMouseHandler);
	}
	
	this( dchar[] set_text )
	{
		//alignType = AlignType.BEGIN;
		this();
		addLabelsFromText( set_text );
	}

	void addLabelsFromText( dchar[] set_text )
	{
		dchar[][] lines = Util.splitLines(set_text);
		foreach(dchar[] line; lines)
		{
			auto a_label = new Label(line);
			a_label.alignType = AlignType.BEGIN;
			add( a_label );
		}
	}

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
