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

module rae.ui.ImageView;

import tango.util.log.Trace;//Thread safe console output.

public import rae.gl.gl;
public import rae.gl.glu;
public import rae.gl.glext;
import rae.gl.util;

import rae.core.globals;
import rae.core.IRaeMain;

import rae.canvas.ICanvasItem;
import rae.canvas.PlainRectangle;
import rae.canvas.Rectangle;
import rae.canvas.IRootWindow;
import rae.canvas.Draw;
import rae.canvas.Image;
import rae.ui.InputState;
import rae.ui.Widget;

class ImageView : public Widget
{
	this()
	{
		super();
		type = "ImageView";
		name = "empty"d;
		renderMethod = RenderMethod.ASPECT;
		//isClipping = false;
		//isClipByParent = false;
	}
	
	this( char[] set_filename )
	{
		this();
		openFile( set_filename );
	}

	bool openFile(char[] set_filename)
	{
		filename = set_filename;
		//name = set_filename;
		//if( image is null ) return false;
		if( image !is null ) delete image;
		image = new Image(2048, 2048, 4);
		//AAArrgh...image.createGLTexture();
		
		bool is_file_ok = image.load( filename );
		if( is_file_ok == true )
		{
			texture = image;
		
			float aspectrat = cast(float)image.width / cast(float)image.height;
			//h = h * aspectrat;
			xAspect(aspectrat);
			//xAspect(1.0f);
		}
		return is_file_ok;
	}
	
	char[] filename = "";
	Image image;
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
