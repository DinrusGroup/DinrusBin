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

module rae.ui.Paned;

import tango.util.log.Trace;//Thread safe console output.

import tango.util.container.LinkedList;
import tango.core.Signal;
import Float = tango.text.convert.Float;

import rae.core.globals;
//import rae.Rae;
import rae.ui.Widget;
import rae.ui.InputState;
//import rae.canvas.Rectangle;
import rae.canvas.Draw;
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

//TODO make all these circle classes sane.
class CircleForPaned : Widget
{
	this()
	{
		super();
		
		arrangeType = ArrangeType.HBOX;
		
		xPackOptions = PackOptions.SHRINK;
		yPackOptions = PackOptions.SHRINK;
		
		//0.025f
		float val = g_rae.getValueFromTheme("Rae.Button.circle.defaultHeight"); 
		defaultSize(val, val);
		maxWidth = val;
		maxHeight = val;
		
		name = "Rae.CircleForPaned";
		type = "CircleButton";
		
		outPaddingX = 0.0f;
		outPaddingY = 0.0f;
		inPaddingX = 0.0f;
		inPaddingY = 0.0f;
		
		renderMethod = RenderMethod.PIXELS;
		isOutline = false;
		
		colour(1.0f, 1.0f, 1.0f, 1.0f);
		texture = g_rae.getTextureFromTheme("Rae.PanedCircleButton");
	}
	
	/*REMOVE
	void render(Draw draw)
	{
		//TODO Naturally we'd want to get rid of these hardcoded sizes...
		renderPixelPerPixel( draw, 64.0f, 64.0f );
	}
	*/
}


class PanedController : Widget
{
public:
	
	//OrientationType orientation = OrientationType.VERTICAL;
		
	this( OrientationType set_orientation )
	{
		super();
		
		orientation = set_orientation;
		
		//arrangeType = ArrangeType.LAYER;
		if( orientation == OrientationType.HORIZONTAL )
		{
			arrangeType = ArrangeType.LAYER;
			yPackOptions = PackOptions.SHRINK;
			defaultHeight = g_rae.getValueFromTheme("Rae.PanedController.defaultSize");
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			arrangeType = ArrangeType.LAYER;
			xPackOptions = PackOptions.SHRINK;
			defaultWidth = g_rae.getValueFromTheme("Rae.PanedController.defaultSize");
		}
		
		name = "PanedController";
		
		layer = 1000;//Make this to be rendered a bit more upper
		//in the stack.
		
		//rectangle.
		//colour(0.12f, 0.12f, 0.12f, 1.0f);
		colour = g_rae.getColourArrayFromTheme("Rae.PanedController");
		isOutline = false;
		//rectangle.
		//set( 0.0f, 0.0f, 0.6f, 0.2f );
		
		//texture = g_rae.getTextureFromTheme("Rae.Button");
		
		outPaddingX = 0.0f;
		outPaddingY = 0.0f;
		inPaddingX = 0.0f;
		inPaddingY = 0.0f;
		
		CircleForPaned panedControllerCircle = new CircleForPaned();
		add( panedControllerCircle );
		
		
	}
	
	//value tells the position of the PanedController
	//it's from 0.0f to 1.0f.
	public float value() { return m_value; }
	public float value(float set)
	{
		m_value = set;
		if( m_value < 0.0f )
			m_value = 0.0f;
		else if( m_value > 1.0f )
			m_value = 1.0f;
		//arrange();
		//invalidate();
		return m_value;
	}
	protected float m_value = 0.0f;
	
}

class Paned : Widget
{
	this( OrientationType set_orientation )
	{
		super();
		
		orientationType = set_orientation;
		
		if( orientationType == OrientationType.VERTICAL )
		{
			arrangeType = ArrangeType.VBOX;
			name = "VPaned";
		}
		else if( orientationType == OrientationType.HORIZONTAL )
		{
			arrangeType = ArrangeType.HBOX;
			name = "HPaned";
		}
		xPackOptions = PackOptions.EXPAND;
		yPackOptions = PackOptions.EXPAND;
		
		outPaddingX = 0.0f;
		outPaddingY = 0.0f;
		inPaddingX = 0.0f;
		inPaddingY = 0.0f;
		
		isOutline = false;
		colour = g_rae.getColourArrayFromTheme("Rae.Paned");
		//colour(0.18f, 0.18f, 0.18f, 1.0f);
		
		panedControllers = new LinkedList!(PanedController);
	}
	
	LinkedList!(PanedController) panedControllers;
	
	void add( Rectangle a_widget )
	{
		if( itemList.size > 0 )
		{
			PanedController p_cont = new PanedController(orientationType);
			p_cont.signalMouseButtonPress.attach(&panedControllerHandler);
			p_cont.signalMouseButtonRelease.attach(&panedControllerHandler);
			p_cont.signalMouseMotion.attach(&panedControllerHandler);
			p_cont.signalEnterNotify.attach(&panedControllerHandler);
			p_cont.signalLeaveNotify.attach(&panedControllerHandler);
			numOfControllers++;
			super.append( p_cont );
			panedControllers.append( p_cont );
			arrangeControllersEqually();
		}
		
		super.append( a_widget );
	}
	
	void append( Rectangle a_widget )
	{
		if( itemList.size > 0 )
		{
			PanedController p_cont = new PanedController(orientationType);
			p_cont.signalMouseButtonPress.attach(&panedControllerHandler);
			p_cont.signalMouseButtonRelease.attach(&panedControllerHandler);
			p_cont.signalMouseMotion.attach(&panedControllerHandler);
			p_cont.signalEnterNotify.attach(&panedControllerHandler);
			p_cont.signalLeaveNotify.attach(&panedControllerHandler);
			numOfControllers++;
			super.append( p_cont );
			panedControllers.append( p_cont );
			arrangeControllersEqually();
		}
		
		super.append( a_widget );
	}
	
	void prepend( Rectangle a_widget )
	{
		if( itemList.size > 0 )
		{
			PanedController p_cont = new PanedController(orientationType);
			p_cont.signalMouseButtonPress.attach(&panedControllerHandler);
			p_cont.signalMouseButtonRelease.attach(&panedControllerHandler);
			p_cont.signalMouseMotion.attach(&panedControllerHandler);
			p_cont.signalEnterNotify.attach(&panedControllerHandler);
			p_cont.signalLeaveNotify.attach(&panedControllerHandler);
			numOfControllers++;
			super.prepend( p_cont );
			panedControllers.prepend( p_cont );
			arrangeControllersEqually();
		}
		
		super.prepend( a_widget );
	}
	
	int numOfControllers = 0;
	
	void arrangeControllersEqually()
	{
		//bool is_controller = false;
		
		float use_as_size;
		if( orientationType == OrientationType.VERTICAL )
		{
			use_as_size = w;
		}
		else if( orientationType == OrientationType.HORIZONTAL )
		{
			use_as_size = h;
		}
		
		float space_for_controller = use_as_size / (numOfControllers+1);
		float cur_pos = -(use_as_size*0.5f);
		
		foreach(PanedController wid; panedControllers )//itemList)
		{
			//if( is_controller == true )
			//{
				cur_pos = cur_pos + space_for_controller;
				if( orientationType == OrientationType.VERTICAL )
					wid.xPos = cur_pos;
				else if( orientationType == OrientationType.HORIZONTAL )
					wid.yPos = cur_pos;
			//}
		
			/*
			//Swap is_controller every other time,
			//as every other child widget in this paned
			//system is supposed to be a PanedController
			//and every other is any type of child widget
			//that the user has put there.
			if( is_controller == false )
				is_controller = true;
			else is_controller = false;
			*/
		}
		
		updatePanedControllersValueFromXPos();
	}
	
	void panedControllerHandler( InputState input, Rectangle wid )
	{
		input.isHandled = true;
		
		switch( input.eventType )
		{
			default:
			break;
			case SEventType.ENTER_NOTIFY:
				wid.prelight();
			break;
			case SEventType.LEAVE_NOTIFY:
				wid.unprelight();
			break;
			case SEventType.MOUSE_BUTTON_PRESS:
				wid.grabInput();
			break;
			case SEventType.MOUSE_BUTTON_RELEASE:
				wid.ungrabInput();
			break;
		}
	
		if( input.mouse.button[MouseButton.LEFT] == true )
		{
			//myWindow4.moveTo( input.mouse.x, input.mouse.y );
			if( orientationType == OrientationType.HORIZONTAL )
			{
				wid.move( 0.0f, input.mouse.yRel );
			}
			else if( orientationType == OrientationType.VERTICAL )
			{
				wid.move( input.mouse.xRel, 0.0f );
				//wid.moveTo( wid.xPos, input.mouse.xRelOnButtonPress );
			}
			//Trace.formatln( "xrel: {} yrel: {}", input.mouse.xRel, input.mouse.yRel );
			
			checkPanedController(wid);
			updatePanedControllersValueFromXPos();
		}
	}
	
	protected void updatePanedControllersValueFromXPos()
	{
		debug(Paned) Trace.formatln("updatePanedControllersValueFromXPos" );
		
		foreach( PanedController iter; panedControllers )
		{
			if( orientationType == OrientationType.VERTICAL )
			{
				iter.value = (iter.xPos + (w*0.5f) ) / w;
				debug(Paned) Trace.formatln("iter.value: {}", cast(double) iter.value );
			}
			else if( orientationType == OrientationType.HORIZONTAL )
			{
				iter.value = (iter.yPos + (h*0.5f) ) / h;
			}
		}
	}
	
	protected void updatePanedControllersXPosFromValue()
	{
		debug(Paned) Trace.formatln("updatePanedControllersXPosFromValue" );
		foreach( PanedController iter; panedControllers )
		{
			if( orientationType == OrientationType.VERTICAL )
			{
				iter.xPos = (iter.value * w) - (w*0.5f);
				debug(Paned) Trace.formatln("iter.value: {}", cast(double) iter.value );
			}
			else if( orientationType == OrientationType.HORIZONTAL )
			{
				iter.yPos = (iter.value * h) - (h*0.5f);
			}
		}
		
		//Legalize them:
		checkPanedControllers();
	}
	
	//Override w(set) and h(set) so that the
	//PanedControllers get updated as a percentage, which
	//is stored in the value. This way they will update
	//sanely when the width or height changes.
	//Inorder for that override to work, we'll also have
	//to override float w().
	float w() { return super.w(); }
	void w( float set )
	{
		debug(Paned) Trace.formatln("Paned.w(set)." );
		//float ret = 
		super.w(set);
		updatePanedControllersXPosFromValue();
		//return ret;
	}
	
	float h() { return super.h(); }
	void h( float set )
	{
		debug(Paned) Trace.formatln("Paned.h(set)." );
		//float ret = 
		super.h(set);
		updatePanedControllersXPosFromValue();
		//return ret;
	}
	
	//N versions
	void wN( float set )
	{
		debug(Paned) Trace.formatln("Paned.w(set)." );
		//float ret = 
		super.wN(set);
		updatePanedControllersXPosFromValue();
		//return ret;
	}
	
	void hN( float set )
	{
		debug(Paned) Trace.formatln("Paned.h(set)." );
		//float ret = 
		super.hN(set);
		updatePanedControllersXPosFromValue();
		//return ret;
	}
	
	/**
	* No effect because it would screw up the Paned system.
	*/
	void sendToTop( Rectangle wid )
	{
		debug(Paned) Trace.formatln("Paned.sendToTop(Widget) START.");
		debug(Paned) scope(exit) Trace.formatln("Paned.sendToTop(Widget) STOP.");
		
		//No effect because it would screw up the Paned system.
	}
	
	/**
	* Bring this widget to be the lowest widget
	* in it's container. No effect because it would screw up the Paned system.
	*/
	void sendToBottom( Rectangle wid )
	{
		debug(Paned) Trace.formatln("Paned.sendToBottom(Widget) START.");
		debug(Paned) scope(exit) Trace.formatln("Paned.sendToBottom(Widget) STOP.");
		
		//No effect because it would screw up the Paned system.
	}
	
	protected void checkPanedControllers()
	{
		//bool is_controller = false;
		PanedController last_controller;
		//PanedController next_controller;
		//bool found_our_controller = false;
		//bool all_set = false;

		foreach( PanedController wid; panedControllers )//itemList )
		{
		
			//Basic bounds checking. So that a PanedController won't
			//be outside this Paned widget.
			if( orientationType == OrientationType.VERTICAL )
			{
				if( wid.x2 > (w*0.5f) ) wid.xPos = (w*0.5f)-(wid.w*0.5f);
				else if( wid.x1 < -(w*0.5f) ) wid.xPos = -(w*0.5f)+(wid.w*0.5f);
				
				//Adjust the PanedController so that it
				//won't overlap the ones right next to it:
				
				//Check left PanedController
				if( last_controller !is null && (wid.xPos-(wid.w*0.5f)) < (last_controller.xPos+(last_controller.w*0.5f)) )
				{
					wid.xPos = (last_controller.xPos+(last_controller.w*0.5f)) + (wid.w*0.5f);
				}
				
				//Check right PanedController
				/*
				if( next_controller !is null && (wid.xPos+(wid.w*0.5f)) > (next_controller.xPos-(next_controller.w*0.5f)) )
				{
					wid.xPos = (next_controller.xPos-(next_controller.w*0.5f)) - (wid.w*0.5f);
				}
				*/
			}
			else if( orientationType == OrientationType.HORIZONTAL )
			{
				if( wid.y2 > (h*0.5f) ) wid.yPos = (h*0.5f)-(wid.h*0.5f);
				else if( wid.y1 < -(h*0.5f) ) wid.yPos = -(h*0.5f)+(wid.h*0.5f);
				
				//Check upper PanedController
				if( last_controller !is null && (wid.yPos-(wid.h*0.5f)) < (last_controller.yPos+(last_controller.h*0.5f)) )
				{
					wid.yPos = (last_controller.yPos+(last_controller.h*0.5f)) + (wid.h*0.5f);
				}
			}
			
			last_controller = wid;
		}
			
		arrange();
		invalidate();
		
	}
	
	
	//This OLD version only checked one PanedController.
	//I thought it might even be faster to just check all of them,
	//as this OLD version used foreach anyway.
	
	//I think we still need this version, because otherwise
	//we don't know which one of them moved. The one that moved
	//is the one that is potentially wrongly placed. Others
	//are presumed to be ok.
	protected void checkPanedController(Rectangle wid)
	{
		if( wid !is null )
		{
			if( orientationType == OrientationType.VERTICAL )
			{
				if( wid.x2 > (w*0.5f) ) wid.xPos = (w*0.5f)-(wid.w*0.5f);
				else if( wid.x1 < -(w*0.5f) ) wid.xPos = -(w*0.5f)+(wid.w*0.5f);
			}
			else if( orientationType == OrientationType.HORIZONTAL )
			{
				if( wid.y2 > (h*0.5f) ) wid.yPos = (h*0.5f)-(wid.h*0.5f);
				else if( wid.y1 < -(h*0.5f) ) wid.yPos = -(h*0.5f)+(wid.h*0.5f);
			}
			
			
			//Adjust the PanedController so that it
			//won't overlap the ones right next to it:
			
			//bool is_controller = false;
			Rectangle last_controller;
			Rectangle next_controller;
			bool found_our_controller = false;
			bool all_set = false;
			
			foreach( PanedController iter; panedControllers )//itemList )
			{
				if( all_set == false )
				{
					//if( is_controller == true )
					//{
						if( found_our_controller == true )
						{
							next_controller = iter;
							
							//Now we've found all we need.
							
							all_set = true;
							
							//All set. Now we could just terminate this foreach, if I just knew how.
							//So that's TODO.
						}
						else
						{
							if( iter is wid )
							{
								found_our_controller = true;
							}
							else last_controller = iter;
						}
					//}
					
					/*
					//Swap is_controller every other time,
					//as every other child widget in this paned
					//system is supposed to be a PanedController
					//and every other is any type of child widget
					//that the user has put there.
					if( is_controller == false )
						is_controller = true;
					else is_controller = false;
					*/
				}
			}
			
			if( orientationType == OrientationType.VERTICAL )
			{
				//Check left PanedController
				if( last_controller !is null && (wid.xPos-(wid.w*0.5f)) < (last_controller.xPos+(last_controller.w*0.5f)) )
				{
					wid.xPos = (last_controller.xPos+(last_controller.w*0.5f)) + (wid.w*0.5f);
				}
				
				//Check right PanedController
				if( next_controller !is null && (wid.xPos+(wid.w*0.5f)) > (next_controller.xPos-(next_controller.w*0.5f)) )
				{
					wid.xPos = (next_controller.xPos-(next_controller.w*0.5f)) - (wid.w*0.5f);
				}
			}
			else if( orientationType == OrientationType.HORIZONTAL )
			{
				//Check up PanedController
				if( last_controller !is null && (wid.yPos-(wid.h*0.5f)) < (last_controller.yPos+(last_controller.h*0.5f)) )
				{
					wid.yPos = (last_controller.yPos+(last_controller.h*0.5f)) + (wid.h*0.5f);
				}
				
				//Check dohn PanedController
				if( next_controller !is null && (wid.yPos+(wid.h*0.5f)) > (next_controller.yPos-(next_controller.h*0.5f)) )
				{
					wid.yPos = (next_controller.yPos-(next_controller.h*0.5f)) - (wid.h*0.5f);
				}
			}
			
			arrange();
			invalidate();
		}
	}
	
	void arrange()
	{
		debug(arrange) Trace.formatln("arrange() {}", fullName() );
	
		checkZOrder();
	
		if( itemList.size < 3 )
			super.arrange();
	
		float use_width = w;
		float use_height = h;
		
		bool is_controller = false;
		
		Rectangle to_set_wid;
		Rectangle last_controller;
		
		foreach( Rectangle wid; itemList )
		{
			if( is_controller == false )
			{
				//We use to_set_wid as a memory.
				//We'll adjust this widget when we'll
				//get to the next PanedController.
				//That code is below.
				to_set_wid = wid;
			}
			else
			{
					//Set the height and arrange the PanedController.
					//Arranging it doesn't make much sense, but let's
					//do it for completeness sake. Or for fun and
					//the computer cycles it consumes.
					
				if( orientationType == OrientationType.VERTICAL )
				{
					wid.hN = use_height;
					wid.yPos = 0.0f;
				}
				else if( orientationType == OrientationType.HORIZONTAL )
				{
					wid.wN = use_width;
					wid.xPos = 0.0f;
				}
					
				wid.arrange();
					
				//Then we'll set the to_set_wid that
				//is our memory of the actual child widget
				//we want to adjust.
				
				if( last_controller is null )
				{
					//This is the first PanedController.
				
					//the width we want is
					//half the width of this Paned widget.
					//+
					//PanedControllers position
					//-
					//half the width of the PanedController.
					
					if( orientationType == OrientationType.VERTICAL )
					{
						to_set_wid.wN = (use_width*0.5f) + wid.xPos - (wid.w*0.5f);
						to_set_wid.hN = use_height;
						
						//Adjust the position
						to_set_wid.xPos = (wid.xPos - (wid.w*0.5f)) - (to_set_wid.w*0.5f);
					}
					else if( orientationType == OrientationType.HORIZONTAL )
					{
						to_set_wid.hN = (use_height*0.5f) + wid.yPos - (wid.h*0.5f);
						to_set_wid.wN = use_width;
						
						//Adjust the position
						to_set_wid.yPos = (wid.yPos - (wid.h*0.5f)) - (to_set_wid.h*0.5f);
					}
				}
				else
				{
					//There already was a PanedController that we put into
					//memory in last_controller.
					
					//the width is what's left between the last_controller
					//PanedController and wid PanedController. We minus
					//wid.w, which effectively is the size of half of last_controller.w
					//and half of wid.w. But we don't handle 
					if( orientationType == OrientationType.VERTICAL )
					{
						to_set_wid.wN = (wid.xPos - last_controller.xPos) - (wid.w);
						to_set_wid.hN = use_height;
						
						//Adjust the position to be in the center of the PanedControllers.
						to_set_wid.xPos = (last_controller.xPos + wid.xPos) * 0.5f;
					}
					else if( orientationType == OrientationType.HORIZONTAL )
					{
						to_set_wid.hN = (wid.yPos - last_controller.yPos) - (wid.h);
						to_set_wid.wN = use_width;
						
						//Adjust the position to be in the center of the PanedControllers.
						to_set_wid.yPos = (last_controller.yPos + wid.yPos) * 0.5f;
					}
				}
				
				if( orientationType == OrientationType.VERTICAL )
				{
					//yPos should be 0.0f i.e. middle.
					to_set_wid.yPos = 0.0f;
				}
				else if( orientationType == OrientationType.HORIZONTAL )
				{
					to_set_wid.xPos = 0.0f;
				}
				
				to_set_wid.arrange();
				
				//Put the last_controller also to memory.
				//We'll use it to adjust the last child widget later.
				last_controller = wid;
			}
			
			
			//Swap is_controller every other time,
			//as every other child widget in this paned
			//system is supposed to be a PanedController
			//and every other is any type of child widget
			//that the user has put there.
			if( is_controller == false )
				is_controller = true;
			else is_controller = false;
		}
		
		//Adjust the last child widget.
		if( to_set_wid !is null )//There's something to adjust.
		{
			if( last_controller !is null )//There was a controller
			{
				if( orientationType == OrientationType.VERTICAL )
				{
					to_set_wid.wN = (use_width*0.5f) - last_controller.xPos - (last_controller.w*0.5f);	
					to_set_wid.hN = use_height;
					to_set_wid.xPos = (last_controller.xPos + (last_controller.w*0.5f)) + (to_set_wid.w*0.5f);
					to_set_wid.yPos = 0.0f;
					to_set_wid.arrange();
				}
				else if( orientationType == OrientationType.HORIZONTAL )
				{
					to_set_wid.hN = (use_height*0.5f) - last_controller.yPos - (last_controller.h*0.5f);	
					to_set_wid.wN = use_width;
					to_set_wid.yPos = (last_controller.yPos + (last_controller.h*0.5f)) + (to_set_wid.h*0.5f);
					to_set_wid.xPos = 0.0f;
					to_set_wid.arrange();
				}
			}
			else //There's no controller. Just use whole width and height.
			{
				to_set_wid.wN = use_width;
				to_set_wid.hN = use_height;
				to_set_wid.xPos = 0.0f;
				to_set_wid.yPos = 0.0f;
				to_set_wid.arrange();
			}
		}
		
	}
	
	OrientationType orientationType = OrientationType.VERTICAL;
}

class VPaned : public Paned
{
	this()
	{
		super(OrientationType.VERTICAL);
	}
}

class HPaned : public Paned
{
	this()
	{
		super(OrientationType.HORIZONTAL);
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
