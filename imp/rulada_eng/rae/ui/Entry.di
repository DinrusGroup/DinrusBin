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

module rae.ui.Entry;

import tango.util.log.Trace;//Thread safe console output.

import tango.math.Math;
import tango.util.container.LinkedList;
import tango.core.Signal;
import Float = tango.text.convert.Float;
import Utf = tango.text.convert.Utf;
import Unicode = tango.text.Unicode;

import rae.core.globals;
import rae.core.IRaeMain;
import rae.ui.InputState;
import rae.ui.Widget;
import rae.canvas.Rectangle;
import rae.canvas.Draw;
import rae.canvas.Image;
import rae.canvas.ShapeRoundRectangle;
import rae.ui.Label;
import rae.ui.KeySym;


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

class Entry : Widget
{
public:

	protected this()
	{
		super();
	}

	this( dchar[] set_label )
	{
		super();
		
		type = "Entry";
		
		//shape = new ShapeRoundRectangle(ix1, iy1, ix2, iy2);
		//shape.themeTexture = "Rae.Button";
		
		arrangeType = ArrangeType.LAYER;//was HBOX
		alignType = AlignType.BEGIN;
		
		name = set_label;
		
		colour = g_rae.getColourArrayFromTheme("Rae.Button");
		//rectangle.
		//colour(0.7f, 0.7f, 0.7f, 1.0f);//Light grey
		//colour(0.1f, 0.1f, 0.1f, 1.0f);//dark grey
		//rectangle.
		//set( 0.0f, 0.0f, 0.6f, 0.2f );
		
		isOutline = true;
		
		outPaddingX = 0.005f;
		outPaddingY = 0.005f;
		inPaddingX = 0.015f;
		inPaddingY = 0.015f;
		
		//xPackOptions = PackOptions.SHRINK;
		xPackOptions = PackOptions.EXPAND;
		yPackOptions = PackOptions.SHRINK;
		defaultHeight = g_rae.getValueFromTheme("Rae.Button.defaultHeight");
		
		//texture = g_rae.getTextureFromTheme("Rae.Button");
				
		label = new Label(set_label);
		//label.colour = g_rae.getColourArrayFromTheme("Rae.Text");
		//label.colour(0.0, 0.0, 0.0, 1.0);//Black
		//label.colour(1.0, 1.0, 1.0, 1.0);//White
		label.xPackOptions = PackOptions.EXPAND;
		label.alignType = alignType;//copy our alignType to that of label's.

		//buttonDraw = new ButtonDraw();

		//Now that we have the label set up, it knows it's
		//width, and we can use it to set our defaultWidth.
		//using padding here is just funny. We should really have
		//a system with inPadding and outPadding.
		
		//defaultWidth = label.textWidth + (padding * 6.0f);
		//followsChildWidth = true;
		
		//add(buttonDraw);
		
		add(label);

		signalMouseButtonPress.attach(&buttonHandler);
		signalMouseButtonRelease.attach(&buttonHandler);
		//signalMouseMotion.attach(&buttonHandler);
		signalEnterNotify.attach(&buttonHandler);
		signalLeaveNotify.attach(&buttonHandler);
		
	}
	
	/*
	void render(Draw draw)
	{
		//TODO Naturally we'd want to get rid of these hardcoded sizes...
		//renderPixelPerPixel( draw, 128.0f, 64.0f );
		//a = 0.5f;
		
		//102.0f is from (256.0f / 5) * 2.0f = 102.4f ~ in pixels 102.0f.
		//So (256 / 5) is the size of the button texture's left and right side.
		
		//6.4 --- (64.0f / 20) * 2 = 6.4f
		
		
		//renderImmediateMode(draw);
		
		version(zoomGL)
		{
			//renderPixelPerPixel( draw, (w / g_rae.pixel)+102.0f, texture.height * 0.25f );
			renderPixelPerPixel( draw, (w / g_rae.pixel)+6.0f, texture.height );
		}
		version(zoomCairo)
		{
			renderPixelPerPixel( draw, (tr_w_i2l(w) / g_rae.pixel)+102.0f, texture.height );
		}
		
		
		//super.render(draw);
		//renderPixelPerPixelHeight( draw, 64.0f );
	}
	*/
	
	
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
					//onActivate();
					gotoEditMode();
				}
				
				/*if( wid.parent !is null && wid.parent.hasAnimators == false )
				{
					wid.parent.addDefaultAnimator( DefaultAnimator.ROTATE_360 );
				}*/
			break;
		}
	}
	
	void gotoEditMode()
	{
		colour(0.0f, 0.0f, 0.0f, 1.0f);
		grabKeyInput();
	}
	
	void leaveEditMode()
	{
		colour(0.18f, 0.18f, 0.18f, 1.0f);
		ungrabKeyInput();
		onEntryChanged();//call the signal so that listeners know we've changed.
		onTextChanged();
	}
	
	bool keyEvent( InputState input )
	{
		debug(Entry) Trace.formatln("Entry.keyEvent.");
	
		if( input.eventType != SEventType.KEY_PRESS )
			return false;
	
		switch(input.key.value)
		{
			default:
			break;
			case KeySym.Delete://This doesn't belong here. Delete should delete next char.
			case KeySym.BackSpace:
				if( label.name.length > 0 )
					label.name = label.name[0..length-1]; //Take out the last dchar with slicing.
			return true;
			case KeySym.Return:
			case KeySym.KP_Enter:
				leaveEditMode();
			return true;
		}
	
		debug(Entry) Trace.formatln("Entry. Got unicode: {}", input.key.unicode );
	
		//int inc = InputState.convertKeyToChar(input.eventKey);
		//if( inc == -1 )
			//return true;
		
		if( Unicode.isPrintable(input.key.unicode) )
			label.name = label.name ~ input.key.unicode;//Add the dchar that was pressed.
	
		debug(Entry) Trace.formatln("entry: {}", Utf.toString(label.name) );
	
		//TODO make keyfocus!
		/*switch(input.eventKey)
		{
			default:
			break;
			
		}*/
		return true;
	}
	
	//Two signals about the state change.
	//signalEntryChanged gives you the entry.
	//and signalTextChanged gives you the dchar[] text if
	//that's all you need.
	void onEntryChanged()
	{
		signalEntryChanged.call(this);
	}
	Signal!(Entry) signalEntryChanged;
	
	void onTextChanged()
	{
		signalTextChanged.call(text);
	}
	Signal!(dchar[]) signalTextChanged;
	
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
	
	
	///Just adds an "alias" called text for the label.name.
	public dchar[] text(){ return label.name; }
	public void text(dchar[] set){ label.name = set; }
	
	//also sets labels alignType, when setting it for entry.
	public AlignType alignType() { return m_alignType; }
	public AlignType alignType(AlignType set)
	{
		m_alignType = set;
		if( m_label !is null ) m_label.alignType = set;
		return m_alignType;
	}
	
protected:

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
