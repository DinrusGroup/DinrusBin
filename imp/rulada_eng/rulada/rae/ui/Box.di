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

module rae.ui.Box;

import tango.util.log.Trace;//Thread safe console output.

import tango.util.container.LinkedList;
import tango.core.Signal;
import Float = tango.text.convert.Float;

import rae.core.globals;
import rae.core.IRaeMain;
import rae.ui.Widget;
//import rae.canvas.Rectangle;
//import rae.canvas.Draw;
//import rae.canvas.Image;
//import rae.canvas.Gradient;

version(sdl)
{
	import derelict.opengl.gl;
	import derelict.opengl.glu;
	//import derelict.sdl.sdl;
}//end version(sdl)
version(gtk)
{
	import gtkD.gtkglc.gl;
	import gtkD.gtkglc.glu;
}

class VBox : Widget
{
	this()
	{
		super();
		arrangeType = ArrangeType.VBOX;
		xPackOptions = PackOptions.SHRINK;
		yPackOptions = PackOptions.EXPAND;
		name = "VBox";
		type = "VBox";
		outPaddingX = 0.0f;
		outPaddingY = 0.0f;
		inPaddingX = 0.0f;
		inPaddingY = 0.0f;
		
		verticalScrollbarSetting = ScrollbarSetting.AUTO;
		
		///////////followsChildWidth = true;
		//followsChildHeight = true;
		renderMethod = RenderMethod.BYPASS;
		isOutline = false;
		//colour(0.18f, 0.18f, 0.18f, 1.0f);
		colour = g_rae.getColourArrayFromTheme("Rae.Box");
	}
}

class HBox : Widget
{
	this()
	{
		super();
		arrangeType = ArrangeType.HBOX;
		xPackOptions = PackOptions.EXPAND;
		yPackOptions = PackOptions.SHRINK;
		name = "HBox";
		type = "HBox";
		outPaddingX = 0.0f;
		outPaddingY = 0.0f;
		inPaddingX = 0.0f;
		inPaddingY = 0.0f;
		
		horizontalScrollbarSetting = ScrollbarSetting.AUTO;
		
		//followsChildWidth = true;
		/////////followsChildHeight = true;
		renderMethod = RenderMethod.BYPASS;
		isOutline = false;
		//colour(0.18f, 0.18f, 0.18f, 1.0f);
		colour = g_rae.getColourArrayFromTheme("Rae.Box");
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
