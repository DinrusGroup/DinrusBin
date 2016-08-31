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

module rae.ui.Scrollbar;

import tango.util.log.Trace;//Thread safe console output.

import tango.util.container.LinkedList;
import tango.core.Signal;
import Float = tango.text.convert.Float;

import rae.core.globals;
import rae.core.IRaeMain;
import rae.ui.InputState;
import rae.ui.Widget;
import rae.canvas.Rectangle;
import rae.canvas.RoundedRectangle;
import rae.canvas.Draw;
import rae.canvas.Image;
import rae.canvas.Gradient;
import rae.canvas.ShapeRoundRectangle;
import rae.ui.Label;
import rae.ui.Button;

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


//This is an obvious TODO. We shouldn't have to subclass
//just to be able to draw PixelPerPixel. We should just
//be able to set a parameter:
//Rectangle.isRenderPixelPerPixel = true;
//On the other hand, this class seems to fill a specific case,
//and it's wrongly named. It has a dynamic width or height depending
//on it's orientation, and it's used for the scrollbars controller rectangle.
//Only the width or height is rendered pixelperpixel according to the
//textures size. So, I guess we'll have to subclass anyway.
//But it would be nice to make a property that would allow rendering
//pixelperpixel and use the textures size for that.

/*
class PixelPerPixelRectangle : Rectangle
{
	this()
	{
		super();
	}

	void render(Draw draw)
	{
		//TODO Naturally we'd want to get rid of these hardcoded sizes...
		//renderPixelPerPixel( draw, 128.0f, 64.0f );
		//a = 0.5f;
		
		//102.0f is from (256.0f / 5) * 2.0f = 102.4f ~ in pixels 102.0f.
		//So (256 / 5) is the size of the button texture's left and right side.
		if( orientation == OrientationType.HORIZONTAL )
		{
			renderPixelPerPixel( draw, (w / g_rae.pixel)+6.0f, texture.height );
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			renderPixelPerPixel( draw, texture.height, (h / g_rae.pixel)+6.0f );
		}
		//super.render(draw);
		//renderPixelPerPixelHeight( draw, 64.0f );
	}

}
*/


class TriangleButton : Rectangle//Button
{
public:
	mixin ButtonHandlerMixin;
	mixin ButtonLabelMixin;

	DirectionType direction = DirectionType.LEFT;

	this(DirectionType set_direction)
	{
		super();
		
		direction = set_direction;
		
		switch(direction)
		{
			default:
			case DirectionType.LEFT:
				
			break;
			case DirectionType.RIGHT:
				zRot = 180.0f;
			break;
			case DirectionType.UP:
				zRot = 90.0f;
			break;
			case DirectionType.DOWN:
				zRot = 270.0f;
			break;
			case DirectionType.UP_LEFT:
				zRot = 45.0f;
			break;
			case DirectionType.UP_RIGHT:
				zRot = 135.0f;
			break;
			case DirectionType.DOWN_RIGHT:
				zRot = 225.0f;
			break;
			case DirectionType.DOWN_LEFT:
				zRot = 315.0f;
			break;
			
		}
		
		arrangeType = ArrangeType.HBOX;
		
		xPackOptions = PackOptions.SHRINK;
		yPackOptions = PackOptions.SHRINK;
		
		defaultHeight = g_rae.getValueFromTheme("Rae.HScrollbar.defaultHeight");
		defaultWidth = g_rae.getValueFromTheme("Rae.VScrollbar.defaultWidth");
		//defaultSize(0.021f, 0.021f);
		//maxWidth = 0.021f;
		//maxHeight = 0.021f;
		
		name = "TriangleButton";
		type = "TriangleButton";
		
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
		
		texture = g_rae.getTextureFromTheme("Rae.Button.triangle");
		
		buttonHandlerInit();
		/*
		signalMouseButtonPress.attach(&buttonHandler);
		signalMouseButtonRelease.attach(&buttonHandler);
		//signalMouseMotion.attach(&buttonHandler);
		signalEnterNotify.attach(&buttonHandler);
		signalLeaveNotify.attach(&buttonHandler);
		*/
	}
		
	/*
	//REMOVE replaced by RenderMethod.PIXELS.
	void render(Draw draw)
	{
		//TODO Naturally we'd want to get rid of these hardcoded sizes...
		
		renderPixelPerPixel( draw, texture.width, texture.height );
	}
	*/
	
}


class Slider : Widget
{
public:
		
	this( OrientationType set_orientation )
	{
		super();
		//super("Rae.Slider.background", set_orientation);
		
		type = "Slider";
		
		orientation = set_orientation;
		
		/////////shape = ShapeType.ROUND_RECTANGLE;
		//shape = new ShapeRoundRectangle(ix1, iy1, ix2, iy2);
		//shape.orientation = orientation;
		/////////shape.texture = g_rae.getTextureFromTheme("Rae.Slider.background");
		
		background = new RoundedRectangle("Rae.Slider.background", orientation );
		background.xPackOptions = PackOptions.EXPAND;
		background.yPackOptions = PackOptions.EXPAND;
		
		renderMethod = RenderMethod.BYPASS;
		
		//arrangeType = ArrangeType.LAYER;
		if( orientation == OrientationType.HORIZONTAL )
		{
			arrangeType = ArrangeType.HBOX;
			xPackOptions = PackOptions.EXPAND;
			yPackOptions = PackOptions.SHRINK;
			//defaultHeight = 0.021;//TODO getValueFromTheme
			defaultHeight = g_rae.getValueFromTheme("Rae.HSlider.defaultHeight");
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			arrangeType = ArrangeType.VBOX;
			xPackOptions = PackOptions.SHRINK;
			yPackOptions = PackOptions.EXPAND;
			//defaultWidth = 0.021;//TODO getValueFromTheme
			defaultWidth = g_rae.getValueFromTheme("Rae.VSlider.defaultWidth");
		}
		
		name = "Slider";
		
		//rectangle.
		//colour(0.12f, 0.12f, 0.12f, 1.0f);
		colour = g_rae.getColourArrayFromTheme("Rae.Slider.background");
		//rectangle.
		//set( 0.0f, 0.0f, 0.6f, 0.2f );
		
		outPaddingX = 0.0f;
		outPaddingY = 0.0f;
		inPaddingX = 0.0f;
		inPaddingY = 0.0f;
		
		controlRect = new RoundedRectangle("Rae.Slider.control", orientation );//PixelPerPixelRectangle();
		
		
		if( orientation == OrientationType.HORIZONTAL )
		{
			controlRect.xPos = -1.0f;
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			controlRect.yPos = -1.0f;
		}
		
		
		/////////controlRect.orientation = orientation;
		////////controlRect.shape = ShapeType.ROUND_RECTANGLE;
		//controlRect.shape = new ShapeRoundRectangle(controlRect.ix1, controlRect.iy1, controlRect.ix2, controlRect.iy2);
		//controlRect.shape.orientation = orientation;
		//////////controlRect.shape.texture = g_rae.getTextureFromTheme("Rae.Slider.control");
		
		//controlRect.isOutline = true;
		//controlRect.colour(0.1914f, 0.5195f, 0.16406f, 1.0f);
		//controlRect.colour(0.1214f, 0.4195f, 0.11406f, 1.0f);
		controlRect.colour = g_rae.getColourArrayFromTheme("Rae.Slider.control");
		//controlRect.colour(0.4914f, 0.7195f, 0.46406f, 1.0f);
		//controlRect.yPackOptions = PackOptions.SHRINK;
		add(controlRect);
		
		controlRect.signalMouseButtonPress.attach(&controlRectHandler);
		controlRect.signalMouseButtonRelease.attach(&controlRectHandler);
		controlRect.signalMouseMotion.attach(&controlRectHandler);
		controlRect.signalEnterNotify.attach(&controlRectHandler);
		controlRect.signalLeaveNotify.attach(&controlRectHandler);
		
		fraction = 0.3f;
		
		signalMouseButtonPress.attach(&sliderMouseHandler);
		signalMouseButtonRelease.attach(&sliderMouseHandler);
		signalMouseMotion.attach(&sliderMouseHandler);
		
		signalScrollUp.attach(&sliderMouseHandler);
		signalScrollDown.attach(&sliderMouseHandler);
		
		//updateControlRectFromValue();
		
		/*
		//This will bring you textures:
		if( orientation == OrientationType.HORIZONTAL )
		{
			texture = g_rae.getTextureFromTheme("Rae.HScrollbar.background");
			controlRect.texture = g_rae.getTextureFromTheme("Rae.HScrollbar.controlRect");
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			texture = g_rae.getTextureFromTheme("Rae.VScrollbar.background");
			controlRect.texture = g_rae.getTextureFromTheme("Rae.VScrollbar.controlRect");
		}
		*/
		
	}
	
	
	/*
	void render(Draw draw)
	{
		//TODO Naturally we'd want to get rid of these hardcoded sizes...
		//renderPixelPerPixel( draw, 128.0f, 64.0f );
		//a = 0.5f;
		
		//102.0f is from (256.0f / 5) * 2.0f = 102.4f ~ in pixels 102.0f.
		//So (256 / 5) is the size of the button texture's left and right side.
		if( orientation == OrientationType.HORIZONTAL )
		{
			renderPixelPerPixel( draw, (w / g_rae.pixel)+6.0f, texture.height );
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			renderPixelPerPixel( draw, texture.height, (h / g_rae.pixel)+6.0f );
		}
		//super.render(draw);
		//renderPixelPerPixelHeight( draw, 64.0f );
	}
	*/
	
	void beforeArrange()
	{
		//we'll save the value.
		//and use it later to get the same value
		//even after a resize or any thing that
		//caused the arrange.
		isStoreValueSet = true;
		storeValue = value;
	}
	
	void arrange()
	{
		//We won't do an arrange.
		//as that will just center the controlRect, which
		//we don't want.
		//super.arrange();
		
		checkZOrder();
		
		if( background !is null )
		{
			//Trace.formatln("Arranging background. {}", fullName );
			arrangeLayer(background, w, h);
		}
		
		//We'll make the controlRect to be as wide as
		//the fraction tells us.
		
		//float delt = (controlRect.w * fraction) - controlRect.w;
		//controlRect.x2 = controlRect.x2 - delt;
		
		if( orientation == OrientationType.HORIZONTAL )
		{
			if( controlRect !is null )
				controlRect.w = w * fraction;
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			if( controlRect !is null )
				controlRect.h = h * fraction;
		}
		
		/*
		if( isStoreValueSet == true )
		{
			value = storeValue;
			isStoreValueSet = false;
		}
		*/
		
		//checkControlRect(); //NO no no, very slow.
		updateControlRectFromValue();
	}
	
	//ICanvasItem set_owner
	void attach( float delegate() get_follow_value, void delegate(float) set_follow_value, float set_min, float set_max )
	{
		//owner = set_owner;
		getFollowValue = get_follow_value;
		setFollowValue = set_follow_value;
		followMin = set_min;
		followMax = set_max;
		updateControlRectFromValue();
	}
	
	//TODO howabout if we'd make the following
	//stuff into somekind of a class DualSignal, TwoWaySignal, LinkedSignal, 
	//DoublyLinkedSignal, DoubleSignal, FollowSignal,
	/*
	//Removed owner for now. Hope we don't need it.
	protected ICanvasItem owner( ICanvasItem set_owner ) { return m_owner = set_owner; }
	protected ICanvasItem owner() { return m_owner; }
	protected ICanvasItem m_owner;
	*/
	protected float delegate() getFollowValue;
	protected void delegate(float) setFollowValue;
	protected float followMin;
	protected float followMax;
	//-----
	
	
	public float value() { return m_value; }
	public void value(float set)
	{
		m_value = set;
		if( m_value < 0.0f )
			m_value = 0.0f;
		else if( m_value > 1.0f )
			m_value = 1.0f;
		//arrange();
		//invalidate();
		
		if( setFollowValue !is null )
			setFollowValue( weightedAverage(followMin, followMax, m_value)  );
		
		debug(Scrollbar)
		{
			Trace.formatln("value(set): {}", cast(double)m_value );
			if( getFollowValue !is null )
				Trace.formatln("followValue: {}", cast(double)getFollowValue() );
		}
		
		updateControlRectFromValue();
		
		//return m_value;
	}
	protected float m_value = 0.0f;
	
	void updateValue()
	{
		if( getFollowValue !is null )
		{
			debug(Scrollbar)
			{
				Trace.formatln("updateValue() m_value before update: {}", cast(double)m_value );
				Trace.formatln("getFollowValue: {}", cast(double)getFollowValue() );
			}
			
			m_value = getFollowValue();
			
			if( m_value < 0.0f )
				m_value = 0.0f;
			else if( m_value > 1.0f )
				m_value = 1.0f;
			updateControlRectFromValue();
		}
	}
	
	protected bool isStoreValueSet = false;
	protected float storeValue = 0.0f;
	
	public void valuePlus()
	{
		value = value + 0.01f;//TODO decide the increment...
		//updateControlRectFromValue();
	}
	
	public void valueMinus()
	{
		Trace.formatln("ScrollbarControlRect.valueMinus() CALLED. {}", fullName );
		value = value - 0.01f;//TODO decide the increment...
		//updateControlRectFromValue();
	}
	
	void updateValueFromControlRect()
	{
		if( orientation == OrientationType.HORIZONTAL )
		{
			if( controlRect !is null )
			{
				float diff = (-(w*0.5f)+(controlRect.w*0.5)) - controlRect.xPos;
				value = (diff / ((w*0.5f)-(controlRect.w*0.5))) * -0.5f;//That * -0.5f just shows
				//how bad I'm with mathematics. Someone could make this nicer but it works
				//this way too. Thank you.
				debug(Scrollbar) Trace.formatln("HORIZONTAL value: {}", cast(double) value );
			}
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			if( controlRect !is null )
			{
				float diff = (-(h*0.5f)+(controlRect.h*0.5)) - controlRect.yPos;
				value = (diff / ((h*0.5f)-(controlRect.h*0.5))) * -0.5f;
				debug(Scrollbar) Trace.formatln("VERTICAL value: {}", cast(double) value );
			}
		}
	}
	
	void updateControlRectFromValue()
	{
		if( orientation == OrientationType.HORIZONTAL )
		{
			if( controlRect !is null )
			{
				float multiple = (value - 0.5f) * 2.0f;//range -1.0f -> 1.0f.
				controlRect.xPos = (multiple * (w*0.5f)) - (multiple * (controlRect.w*0.5));
				
				debug(Scrollbar) Trace.formatln("HORIZONTAL value: {} multiple: {}", cast(double) value, cast(double) multiple );
			}
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			if( controlRect !is null )
			{
				float multiple = (value - 0.5f) * 2.0f;//range -1.0f -> 1.0f.
				controlRect.yPos = (multiple * (h*0.5f)) - (multiple * (controlRect.h*0.5));
				
				debug(Scrollbar) Trace.formatln("VERTICAL value: {} multiple: {}", cast(double) value, cast(double) multiple );
			}
		}
	}
	
	//TODO maybe RENAME to something like controlRectSize...
	///Accepts values from 0.0f to 1.0f.
	public float fraction() { return m_fraction; }
	public float fraction(float set)
	{
		m_fraction = set;
		arrange();
		invalidate();
		return m_fraction;
	}
	protected float m_fraction = 0.0f;
	
	protected void checkControlRect()
	{
		if( controlRect !is null )
		{
			if( orientation == OrientationType.HORIZONTAL )
			{
				if( controlRect.x2 > (w*0.5f) ) controlRect.xPos = (w*0.5f)-(controlRect.w*0.5f);
				else if( controlRect.x1 < -(w*0.5f) ) controlRect.xPos = -(w*0.5f)+(controlRect.w*0.5f);
			}
			else if( orientation == OrientationType.VERTICAL )
			{
				if( controlRect.y2 > (h*0.5f) ) controlRect.yPos = (h*0.5f)-(controlRect.h*0.5f);
				else if( controlRect.y1 < -(h*0.5f) ) controlRect.yPos = -(h*0.5f)+(controlRect.h*0.5f);
			}
		}
		
		updateValueFromControlRect();
	}
	
	void sliderMouseHandler( InputState input, Rectangle wid )
	{
		input.isHandled = true;
		
		switch( input.eventType )
		{
			default:
			break;
			case SEventType.MOUSE_BUTTON_PRESS:
				//Trace.formatln("Slider GRAB.");
				wid.grabInput();
				
				//wid.sendToTop();
			break;
			case SEventType.MOUSE_BUTTON_RELEASE:
				//Trace.formatln("Slider UNGRAB.");
				wid.ungrabInput();
			break;
			
			case SEventType.SCROLL_UP:
				//if( orientation == OrientationType.HORIZONTAL )
				//	valuePlus();
				//else if( orientation == OrientationType.VERTICAL )
					valueMinus();
			break;
			case SEventType.SCROLL_DOWN:
				//if( orientation == OrientationType.HORIZONTAL )
				//	valueMinus();
				//else if( orientation == OrientationType.VERTICAL )
					valuePlus();
			break;
		}
		
		if( input.mouse.button[MouseButton.LEFT] == true && wid !is null )
		{
			//myWindow4.moveTo( input.mouse.x, input.mouse.y );
			if( orientation == OrientationType.HORIZONTAL )
			{
				value = (input.mouse.xLocal + (wid.w*0.5f) ) / wid.w;
				//Trace.formatln("input.mouse.xLocal: {}", cast(double) input.mouse.xLocal );
				//wid.move( input.mouse.xRelOnButtonPress[MouseButton.LEFT], 0.0f );
				//////////wid.moveTo( widXPosOnButtonPress + input.mouse.xRelOnButtonPress[MouseButton.LEFT], wid.yPos );
			}
			else if( orientation == OrientationType.VERTICAL )
			{
				value = (input.mouse.yLocal + (wid.h*0.5f) ) / wid.h;
				//Trace.formatln("input.mouse.yLocal: {}", cast(double) input.mouse.yLocal );
				//wid.move( 0.0f, input.mouse.yRelOnButtonPress[MouseButton.LEFT] );
				//////////wid.moveTo( wid.xPos, widYPosOnButtonPress + input.mouse.yRelOnButtonPress[MouseButton.LEFT] );
			}
			
			//Trace.formatln( "\nmouse: xrel: {} yrel: {}", input.mouse.xRel, input.mouse.yRel );
			//Trace.formatln( "mouse: xOnButtonPress: {} yOnButtonPress: {}", input.mouse.xOnButtonPress[MouseButton.LEFT], input.mouse.yOnButtonPress[MouseButton.LEFT] );
			//Trace.formatln( "mouse: xRelOnButtonPress: {} yRelOnButtonPress: {}", input.mouse.xRelOnButtonPress[MouseButton.LEFT], input.mouse.yRelOnButtonPress[MouseButton.LEFT] );
			
			////////checkControlRect();
		}
		
		//Trace.formatln("Slider YES.");
	}
	
	void controlRectHandler( InputState input, Rectangle wid )
	{
		input.isHandled = true;
		
		//Trace.formatln("Control AARRG.");
		
		static float widXPosOnButtonPress = 0.0f;
		static float widYPosOnButtonPress = 0.0f;
		
		switch( input.eventType )
		{
			default:
			break;
			case SEventType.ENTER_NOTIFY:
				//wid.colour( 0.9f, 0.6f, 0.4f, 0.7f );
				wid.prelight();
				//wid.sendToTop();
				/*if( wid.hasAnimators == false )
				{
					wid.addDefaultAnimator( DefaultAnimator.RAISE );
				}*/
			break;
			case SEventType.LEAVE_NOTIFY:
				wid.unprelight();
				//wid.colour( 0.8f, 0.3f, 0.2f, 1.0f );
				//if( wid.hasAnimators == false )
				//{
					//wid.addDefaultAnimator( DefaultAnimator.LOWER );
				//}
			break;
			case SEventType.MOUSE_BUTTON_PRESS:
				//Trace.formatln("Control GRAB.");
				wid.grabInput();
				if( input.mouse.eventButton == MouseButton.LEFT )
				{
					widXPosOnButtonPress = wid.xPos;
					widYPosOnButtonPress = wid.yPos;
				}
				//wid.sendToTop();
			break;
			case SEventType.MOUSE_BUTTON_RELEASE:
				//Trace.formatln("Control UNGRAB.");
				wid.ungrabInput();
			break;
		}
	
		if( input.mouse.button[MouseButton.LEFT] == true )
		{
			//myWindow4.moveTo( input.mouse.x, input.mouse.y );
			if( orientation == OrientationType.HORIZONTAL )
			{
				//wid.move( input.mouse.xRelOnButtonPress[MouseButton.LEFT], 0.0f );
				wid.moveTo( widXPosOnButtonPress + input.mouse.xRelOnButtonPress[MouseButton.LEFT], wid.yPos );
			}
			else if( orientation == OrientationType.VERTICAL )
			{
				//wid.move( 0.0f, input.mouse.yRelOnButtonPress[MouseButton.LEFT] );
				wid.moveTo( wid.xPos, widYPosOnButtonPress + input.mouse.yRelOnButtonPress[MouseButton.LEFT] );
			}
			
			//Trace.formatln( "\nmouse: xrel: {} yrel: {}", input.mouse.xRel, input.mouse.yRel );
			//Trace.formatln( "mouse: xOnButtonPress: {} yOnButtonPress: {}", input.mouse.xOnButtonPress[MouseButton.LEFT], input.mouse.yOnButtonPress[MouseButton.LEFT] );
			//Trace.formatln( "mouse: xRelOnButtonPress: {} yRelOnButtonPress: {}", input.mouse.xRelOnButtonPress[MouseButton.LEFT], input.mouse.yRelOnButtonPress[MouseButton.LEFT] );
			
			checkControlRect();
			
		}
	}
	
	debug( Scrollbar )
	{
	//This is an example value, that you can use for debugging like this:
	//auto my_slider = new VSlider();
	//my_slider.attach( &my_slider.getExample, &my_slider.setExample, -1.0f, 1.0f );
	float getExample()
	{
		Trace.formatln("getExample: {}", cast(double)m_example);
		return m_example;
	}
	void setExample(float set)
	{
		m_example = set;
		Trace.formatln("setExample: {}", cast(double)m_example);
	}
	float m_example = 0.0f;
	}
		
protected:

	protected Rectangle controlRect() { return m_controlRect; }
	protected Rectangle controlRect(Rectangle set) { return m_controlRect = set; }
	protected Rectangle m_controlRect;

}

class HSlider : public Slider
{
	this()
	{
		super(OrientationType.HORIZONTAL);
		type = "HSlider";
	}
}

class VSlider : public Slider
{
	this()
	{
		super(OrientationType.VERTICAL);
		type = "VSlider";
	}
}


class Scrollbar : Widget
{
public:
	
	//OrientationType orientation = OrientationType.VERTICAL;
		
	this( OrientationType set_orientation )
	{
		super();
		
		type = "Scrollbar";
		
		orientation = set_orientation;
		
		//NOTICE:
		skipParentZoomAndMoveScreen = true;
		
		///////shape = new ShapeRoundRectangle(ix1, iy1, ix2, iy2);
		///////shape.texture = g_rae.getTextureFromTheme("Rae.Scrollbar.background");
		
		background = new RoundedRectangle("Rae.Scrollbar.background", orientation );
		background.xPackOptions = PackOptions.EXPAND;
		background.yPackOptions = PackOptions.EXPAND;
		
		renderMethod = RenderMethod.BYPASS;
		
		//arrangeType = ArrangeType.LAYER;
		if( orientation == OrientationType.HORIZONTAL )
		{
			arrangeType = ArrangeType.HBOX;
			yPackOptions = PackOptions.SHRINK;
			defaultHeight = g_rae.getValueFromTheme("Rae.HScrollbar.defaultHeight");
			
			Rectangle topSeparator = new Rectangle();
			topSeparator.defaultWidth = defaultHeight * 0.5f;
			topSeparator.maxWidth = defaultHeight * 0.5;
			topSeparator.xPackOptions = PackOptions.SHRINK;
			topSeparator.yPackOptions = PackOptions.SHRINK;
			topSeparator.colour(1.0f, 1.0f, 1.0f, 0.0f);//transparent!
			append(topSeparator);
			
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			arrangeType = ArrangeType.VBOX;
			xPackOptions = PackOptions.SHRINK;
			defaultWidth = g_rae.getValueFromTheme("Rae.VScrollbar.defaultWidth");
			
			Rectangle topSeparator = new Rectangle();
			topSeparator.defaultHeight = defaultWidth * 0.5f;
			topSeparator.maxHeight = defaultWidth * 0.5f;
			topSeparator.xPackOptions = PackOptions.SHRINK;
			topSeparator.yPackOptions = PackOptions.SHRINK;
			topSeparator.colour(1.0f, 1.0f, 1.0f, 0.0f);//transparent!
			append(topSeparator);
		}
		
		name = "Scrollbar";
		
		//rectangle.
		colour = g_rae.getColourArrayFromTheme("Rae.Scrollbar");
		//colour(0.12f, 0.12f, 0.12f, 1.0f);
		//rectangle.
		//set( 0.0f, 0.0f, 0.6f, 0.2f );
		
		outPaddingX = 0.0f;
		outPaddingY = 0.0f;
		inPaddingX = 0.0f;
		inPaddingY = 0.0f;
		
		slider = new Slider(set_orientation);
		
		add(slider);
			
		/*
		//This will bring you textures:
		if( orientation == OrientationType.HORIZONTAL )
		{
			texture = g_rae.getTextureFromTheme("Rae.ui.HScrollbar.background");
			controlRect.texture = g_rae.getTextureFromTheme("Rae.ui.HScrollbar.controlRect");
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			texture = g_rae.getTextureFromTheme("Rae.ui.VScrollbar.background");
			controlRect.texture = g_rae.getTextureFromTheme("Rae.ui.VScrollbar.controlRect");
		}
		*/
		
		DirectionType up_direction;
		DirectionType down_direction;
		if( orientation == OrientationType.HORIZONTAL )
		{
			up_direction = DirectionType.LEFT;
			down_direction = DirectionType.RIGHT;
		}
		else
		{
			up_direction = DirectionType.UP;
			down_direction = DirectionType.DOWN;
		}
		
		upButton = new TriangleButton(up_direction);
		upButton.signalActivate.attach(&slider.valueMinus);
		add(upButton);
		downButton = new TriangleButton(down_direction);
		downButton.signalActivate.attach(&slider.valuePlus);
		add(downButton);
		
		/*
		label = new Label(set_label);
		label.colour(1.0, 1.0, 1.0, 1.0);
		label.xPackOptions = PackOptions.EXPAND;
		add(label);
		*/
		
		/*
		signalMouseButtonPress.attach(&buttonHandler);
		signalMouseButtonRelease.attach(&buttonHandler);
		//signalMouseMotion.attach(&buttonHandler);
		signalEnterNotify.attach(&buttonHandler);
		signalLeaveNotify.attach(&buttonHandler);
		*/
	}
	
	void attach( float delegate() get_follow_value, void delegate(float) set_follow_value, float set_min, float set_max )
	{
		if( slider !is null )
			slider.attach(get_follow_value, set_follow_value, set_min, set_max);
	}
	
	
	/*
	void render(Draw draw)
	{
		//TODO Naturally we'd want to get rid of these hardcoded sizes...
		//renderPixelPerPixel( draw, 128.0f, 64.0f );
		//a = 0.5f;
		
		//102.0f is from (256.0f / 5) * 2.0f = 102.4f ~ in pixels 102.0f.
		//So (256 / 5) is the size of the button texture's left and right side.
		
		version(zoomCairo)
		{
			if( orientation == OrientationType.HORIZONTAL )
			{
				//renderPixelPerPixel( draw, (tr_w_i2l(w) / g_rae.pixel)+102.0f, texture.height );
				renderPixelPerPixel( draw, (tr_w_i2l(w) / g_rae.pixel)+102.0f, texture.height );
			}
			else if( orientation == OrientationType.VERTICAL )
			{
				//renderPixelPerPixel( draw, texture.height, (tr_h_i2l(h) / g_rae.pixel)+102.0f );
				renderPixelPerPixel( draw, texture.height, (tr_h_i2l(h) / g_rae.pixel)+102.0f );
			}
		}
		version(zoomGL)
		{
			if( orientation == OrientationType.HORIZONTAL )
			{
				renderPixelPerPixel( draw, (w / g_rae.pixel)+6.0f, texture.height );
			}
			else if( orientation == OrientationType.VERTICAL )
			{
				renderPixelPerPixel( draw, texture.height, (h / g_rae.pixel)+6.0f );
			}
		}
		//super.render(draw);
		//renderPixelPerPixelHeight( draw, 64.0f );
	}
	*/
	
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

	public Slider slider() { return m_slider; }
	protected Slider slider(Slider set) { return m_slider = set; }
	protected Slider m_slider;

	TriangleButton upButton;
	TriangleButton downButton;

}


class HScrollbar : public Scrollbar
{
	this()
	{
		super(OrientationType.HORIZONTAL);
		type = "HScrollbar";
	}
}

class VScrollbar : public Scrollbar
{
	this()
	{
		super(OrientationType.VERTICAL);
		type = "VScrollbar";
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
