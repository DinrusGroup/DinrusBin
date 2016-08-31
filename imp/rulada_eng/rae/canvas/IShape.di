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

module rae.canvas.IShape;

import tango.util.log.Trace;//Thread safe console output.

import rae.core.globals;
import rae.canvas.Image;
import rae.canvas.Draw;

public import rae.canvas.RenderMethod;

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

interface IShape
{
	bool isTextureCoordsOne();
	bool isTextureCoordsOne(bool set);
	char[] themeTexture();
	char[] themeTexture(char[] set);
	void updateThemeTexture(float set_width, float set_height);
	Image texture();
	Image texture(Image set);

	float texCoordOneTop();
	float texCoordOneBottom();
	float texCoordOneLeft();
	float texCoordOneRight();
	
	void texCoordOneTop(float set);
	void texCoordOneBottom(float set);
	void texCoordOneLeft(float set);
	void texCoordOneRight(float set);

	OrientationType orientation();
	OrientationType orientation(OrientationType set);

	void clip(float set_left_clip, float set_right_clip, float set_up_clip, float set_down_clip);
	void bounds( Draw draw, float ix1, float iy1, float ix2, float iy2, float iz = 0.0f);
	void fill();
	void stroke();
	void renderPixels( Draw draw, RenderMethod render_method, float centerX, float centerY, float ix1, float iy1, float ix2, float iy2, float iz = 0.0f );
	void render( Draw draw, float ix1, float iy1, float ix2, float iy2, float iz = 0.0f);
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
