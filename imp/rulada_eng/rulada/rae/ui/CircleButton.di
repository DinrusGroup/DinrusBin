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

module rae.ui.CircleButton;

import tango.util.log.Trace;//Thread safe console output.

import tango.core.Signal;

import rae.core.globals;
import rae.core.IRaeMain;
import rae.canvas.Rectangle;
import rae.ui.Label;
import rae.ui.InputState;
import rae.ui.Button;


class CircleButton : public Rectangle
{
	mixin ButtonHandlerMixin;
	mixin ButtonLabelMixin;

	this(dchar[] set_name)//CircleButton has no label.
	{
		super();
		
		type = "CircleButton";
		
		arrangeType = ArrangeType.HBOX;
		
		xPackOptions = PackOptions.SHRINK;
		yPackOptions = PackOptions.SHRINK;
		
		//0.025f
		float val = g_rae.getValueFromTheme("Rae.WindowHeader.SMALL.defaultHeight");
		defaultSize(val, val);
		maxWidth = val;
		maxHeight = val;
		
		//defaultSize( 64.0f * g_rae.pixel(), 64.0f * g_rae.pixel() );
		//maxWidth = 64.0f * g_rae.pixel();
		//maxHeight = 64.0f * g_rae.pixel();
		
		name = set_name;
		
		outPaddingX = 0.0f;
		outPaddingY = 0.0f;
		inPaddingX = 0.0f;
		inPaddingY = 0.0f;
		
		renderMethod = RenderMethod.PIXELS;
		isOutline = false;
		
		//rectangle.
		//colour(0.7f, 0.7f, 0.7f, 1.0f);
		colour(1.0f, 1.0f, 1.0f, 1.0f);
		//rectangle.
		//set( 0.0f, 0.0f, 0.6f, 0.2f );
		
		texture = g_rae.getTextureFromTheme("Rae.Button.circle");//TODO zoomedcircles:, maxWidth);
		
		//float[4] m_textColourData = [1.0f, 1.0f, 1.0f, 1.0f];
		//texture = Image.createCircle(m_textColourData);
		//texture.blendDestination = GL_ONE;
		if( name != "" )
		{
			m_label = new Label(name);
			label.textColour = g_rae.getColourArrayFromTheme("Rae.CircleButton.text");
			//label.textColour(1.0, 1.0, 1.0, 1.0);
			label.xPackOptions = PackOptions.EXPAND;
			add(label);
		}
		
		signalMouseButtonPress.attach(&buttonHandler);
		signalMouseButtonRelease.attach(&buttonHandler);
		//signalMouseMotion.attach(&buttonHandler);
		signalEnterNotify.attach(&buttonHandler);
		signalLeaveNotify.attach(&buttonHandler);
	}
	
	/*void render(Draw draw)
	{
		Widget.render(draw);
	}*/
	
	/*
	//REMOVE this is replaced with renderMethod.PIXELS.
	void render(Draw draw)
	{
		if( texture !is null )
			renderPixelPerPixel( draw, texture.width, texture.height );
		//else //TODO Naturally we'd want to get rid of these hardcoded sizes...
			//renderPixelPerPixel( draw, 64.0f, 64.0f );
	}
	*/
	
	
	/*void render()
	{
		
		if( texture !is null )
			texture.pushTexture();
		else glDisable(GL_TEXTURE_2D);
	
		//Trace.formatln("	PlainRectangle.render() START.");
		glPushMatrix();
		
			applyPosition();
			applyRotation();
			applyScale();
			//applyClipping();
			applyColour();
			
			Draw.circle(0.0f, 0.0f, h*0.5f, h*0.5f );
			
		glPopMatrix();
	}*/
	
	/*void renderChildren()
	{
		super.renderChildren();
		applyColour();
		Draw.circle(0.0f, 0.0f, h*0.5f, h*0.5f );
	}*/
	
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
