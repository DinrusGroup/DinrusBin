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

module rae.ui.ProgressBar;

import tango.util.log.Trace;//Thread safe console output.

import tango.util.container.LinkedList;
import tango.core.Signal;
import Float = tango.text.convert.Float;

import rae.core.globals;
import rae.core.IRaeMain;
import rae.ui.InputState;
import rae.ui.Animator;
import rae.ui.Widget;
import rae.canvas.Rectangle;
import rae.canvas.Draw;
import rae.canvas.Image;
import rae.canvas.Gradient;
import rae.ui.Label;


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

/+
//REMOVE not needed anymore. Just set the gradient on a PlainRectangle.
class GradientRect : Rectangle
{
	this()
	{
		super();
		
		type = "GradientRect";
		name = "GradientRect";
		
		colour( 25.0f/255.0f, 35.0f/255.0f, 19.0f/255.0f, 1.0f);
		isOutline = true;
		
		gradient = g_rae.getGradientFromTheme("Rae.ProgressBar.foreground");
		
		/*
		gradient = new Gradient();
		gradient.add( 0.0f, 139.0f/255.0f, 213.0f/255.0f, 172.0f/255.0f, 1.0f );
		gradient.add( 0.26f, 58.0f/255.0f, 152.0f/255.0f, 50.0f/255.0f, 1.0f );
		gradient.add( 0.43f, 40.0f/255.0f, 113.0f/255.0f, 35.0f/255.0f, 1.0f );
		gradient.add( 0.5f, 49.0f/255.0f, 107.0f/255.0f, 45.0f/255.0f, 1.0f );
		gradient.add( 0.64f, 80.0f/255.0f, 122.0f/255.0f, 50.0f/255.0f, 1.0f );
		gradient.add( 0.71f, 67.0f/255.0f, 111.0f/255.0f, 42.0f/255.0f, 1.0f );
		gradient.add( 1.0f, 24.0f/255.0f, 41.0f/255.0f, 12.0f/255.0f, 1.0f );
		*/
	}
	
	void render(Draw draw)
	{
		renderGradient(draw, gradient);
	}
	
	Gradient gradient;
}
+/

class ProgressBar : Widget
{
public:

	protected this()
	{
		//super();
		//name = "ProgressBar";
		this("ProgressBar"d);
	}

	this( dchar[] set_label )
	{
		super();
		
		type = "ProgressBar";
		
		arrangeType = ArrangeType.LAYER;
		
		name = set_label;
		
		isOutline = true;
		
		//rectangle.
		//colour(0.12f, 0.12f, 0.12f, 1.0f);
		colour = g_rae.getColourArrayFromTheme("Rae.ProgressBar");
		//rectangle.
		//set( 0.0f, 0.0f, 0.6f, 0.2f );
		
		texture = g_rae.getTextureFromTheme("Rae.ProgressBar.background");
		
		outPaddingX = 0.005f;
		outPaddingY = 0.005f;
		inPaddingX = 0.0f;
		inPaddingY = 0.0f;
		
		xPackOptions = PackOptions.EXPAND;
		
		//SHOULD BE:
		yPackOptions = PackOptions.SHRINK;
		//TEMPORARY FOR TESTING:
		//yPackOptions = PackOptions.EXPAND;
		
		progressRect = new Rectangle();
		progressRect.gradient = g_rae.getGradientFromTheme("Rae.ProgressBar.foreground");
		//progressRect = new GradientRect();
		//progressRect.texture = new Image( Image.NOISE_GLASS );
		progressRect.isOutline = true;
		//progressRect.xPackOptions = PackOptions.EXPAND;
		//progressRect.yPackOptions = PackOptions.EXPAND;
		//progressRect.colour( 25.0f/255.0f, 35.0f/255.0f, 19.0f/255.0f, 1.0f);
		//progressRect.colour(0.1914f, 0.5195f, 0.16406f, 1.0f);
		//progressRect.colour(0.1214f, 0.4195f, 0.11406f, 1.0f);
		//progressRect.colour(0.4914f, 0.7195f, 0.46406f, 1.0f);
		add(progressRect);
		
		label = new Label(set_label);
		label.textColour = g_rae.getColourArrayFromTheme("Rae.ProgressBar.text");
		//label.colour(1.0, 1.0, 1.0, 1.0);
		//label.xPackOptions = PackOptions.EXPAND;
		//label.yPackOptions = PackOptions.EXPAND;
		add(label);
		/*
		signalMouseButtonPress.attach(&buttonHandler);
		signalMouseButtonRelease.attach(&buttonHandler);
		//signalMouseMotion.attach(&buttonHandler);
		signalEnterNotify.attach(&buttonHandler);
		signalLeaveNotify.attach(&buttonHandler);
		*/
	}
	
	protected void arrange()
	{
		super.arrange();
		
		//After a normal LAYER arrange, we'll
		//make the progressRect to be as wide as
		//the fraction tells us.
		
		//float delt = (progressRect.w * fraction) - progressRect.w;
		//progressRect.x2 = progressRect.x2 - delt;
		if( progressRect !is null )
		{
			progressRect.w = (progressRect.w * fraction);
			progressRect.xPos = -((w*0.5f) - (progressRect.w*0.5f) );
		}
	}
	
	///Causes the progress bar to "fill in" the given fraction of the bar.
	///Accepts values from 0.0f to 1.0f.
	public float fraction() { return m_fraction; }
	public void fraction(float set)
	{
		m_fraction = set;
		arrange();
		invalidate();
		//return m_fraction;
	}
	protected float m_fraction = 0.0f;
	
	void fractionAnim( float to_set, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &fraction, &fraction, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
	}
	
	//orientation - left to right etc.
	
	/+
	void buttonHandler( InputState input, Rectangle wid  )
	{
		input.isHandled = true;
	
		switch( input.eventType )
		{
			default:
			break;
			case SEventType.ENTER_NOTIFY:
				wid.prelight();
				//wid.colour(0.9f, 0.9f, 0.9f, 0.7f);
			break;
			case SEventType.LEAVE_NOTIFY:
				wid.unprelight();//?
				//wid.colour(0.7f, 0.7f, 0.7f, 1.0f);
			break;
			case SEventType.MOUSE_BUTTON_PRESS:
				if( input.mouse.button[MouseButton.LEFT] == true )
				{
					//wid.move( input.mouse.xRel, input.mouse.yRel );
					//Trace.formatln("You pressed me {}.", wid.name);
					wid.grabInput();
					//wid.sendToTop();
				}
			break;
			case SEventType.MOUSE_BUTTON_RELEASE:
				//Not optimal. Doesn't check which button was released...
			
				//Trace.formatln("You released me {}.", wid.name);
				wid.ungrabInput();
				/*
				Trace.formatln("m.x: {}", cast(double)input.mouse.x );
				Trace.formatln("m.y: {}", cast(double)input.mouse.y );
				Trace.formatln("x1: {}", cast(double)x1 );
				Trace.formatln("y1: {}", cast(double)y1 );
				Trace.formatln("x2: {}", cast(double)x2 );
				Trace.formatln("y2: {}", cast(double)y2 );
				Trace.formatln("m.xLocal: {}", cast(double)input.mouse.xLocal );
				Trace.formatln("m.yLocal: {}", cast(double)input.mouse.yLocal );
				Trace.formatln("ix1: {}", cast(double)ix1 );
				Trace.formatln("iy1: {}", cast(double)iy1 );
				Trace.formatln("ix2: {}", cast(double)ix2 );
				Trace.formatln("iy2: {}", cast(double)iy2 );
				*/
				if( wid.enclosureLocal( input.mouse.xLocal, input.mouse.yLocal ) )
				{
					//Trace.formatln("Doing activate.");
					onActivate();
				}
				
				/*if( wid.parent !is null && wid.parent.hasAnimators == false )
				{
					wid.parent.addDefaultAnimator( DefaultAnimator.ROTATE_360 );
				}*/
			break;
		}
	}
	+/
	
	/*
	Signal!() signalActivate;
	void onActivate()
	{
		signalActivate.call();
		//return true;//This doesn't actually go to the parents...
	}
	*/
	
	/*void renderChildren()
	{
		super.renderChildren();
		
		//Draw.showText(name);
	}*/
	
protected:

	protected Rectangle progressRect() { return m_progressRect; }
	protected Rectangle progressRect(Rectangle set) { return m_progressRect = set; }
	protected Rectangle m_progressRect;

	//TODO make property: (Umm, it look like it is a property already. DONE?)
	public Label label() { return m_label; }
	protected Label label(Label set) { return m_label = set; }
	protected Label m_label;
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
