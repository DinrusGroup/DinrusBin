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

module rae.ui.ToggleButton;

import tango.util.log.Trace;//Thread safe console output.

import tango.math.Math;
import tango.util.container.LinkedList;
import tango.core.Signal;
import Float = tango.text.convert.Float;

import rae.core.globals;
import rae.core.IRaeMain;
import rae.ui.InputState;
import rae.ui.Widget;
import rae.ui.Button;
import rae.ui.Box;
import rae.canvas.RoundedRectangle;
import rae.canvas.Draw;
import rae.canvas.Image;
import rae.canvas.IShape;
//import rae.canvas.ShapeRoundRectangle;
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


class TickButton : public Rectangle
{
	mixin ButtonHandlerMixin;
	mixin ButtonLabelMixin;
	//mixin IsSelectedMixin;

	this( bool set_tick )
	{
		m_isSelected = set_tick;
		this();
	}

	this( bool delegate() get_bool = null, void delegate(bool) set_bool = null )//TickButton has no label.
	{
		super();
		
		type = "TickButton";
	
		getFollowDlg = get_bool;
		setFollowDlg = set_bool;
				
		arrangeType = ArrangeType.LAYER;
		
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
		
		//name = "TickButton";
		
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
		
		texture = g_rae.getTextureFromTheme("Rae.TickButton.background");//TODO zoomedcircles:, maxWidth);
		
		foreground = new Rectangle();
		foreground.texture = g_rae.getTextureFromTheme("Rae.TickButton.foreground");
		foreground.defaultSize(val, val);
		foreground.maxWidth = val;
		foreground.maxHeight = val;
		foreground.renderMethod = RenderMethod.PIXELS;
		
		if( getFollowBool() == false )
			m_isSelected = false;
		else m_isSelected = true;
		if( m_isSelected == false ) foreground.hide();
		
		add(foreground);
		
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
		
		buttonHandlerInit();
		
		signalActivate.attach( &toggleIsSelected );
	}
	
	/*
	REMOVE: override void toggleIsSelected()
	{
		//Trace.formatln("Toggle tick.");
		if( isSelected == true )
			isSelected = false;
		else isSelected = true;
	}
	*/
	override bool isSelected() { return m_isSelected; }
	override void isSelected(bool set)
	{
		setFollowBool(set);
		if( set == true )
			foreground.show();
		else foreground.hide();
		m_isSelected = set;
	}
	void isSelectedReal(bool set)
	{
		if( set == true )
			foreground.show();
		else foreground.hide();
		m_isSelected = set;
	} 
	//bool m_isSelected = false;
	
	bool delegate() getFollowDlg;
	void delegate(bool) setFollowDlg;
	
	bool getFollowBool()
	{
		if( getFollowDlg !is null )
			return getFollowDlg();
		return m_isSelected;
	}
	
	void setFollowBool(bool set)
	{
		if( setFollowDlg !is null )
			setFollowDlg(set);
		return isSelectedReal( set );
	}
	
	Rectangle foreground;
}



class ToggleButton : HBox
{
public:

	mixin ButtonHandlerMixin;
	mixin ButtonLabelMixin;
	
	protected this()//Remove?
	{
		//super();//"Rae.Button");
		
		this(""d);
		
		//background = new RoundedRectangle("Rae.Button");
		//background.colour = g_rae.getColourArrayFromTheme("Rae.Button");
	}
	
	this( dchar[] set_label, bool set_tick )
	{
		super();
		
		tickButton = new TickButton(set_tick);
		add(tickButton);
		
		init(set_label);
	}
	
	this( dchar[] set_label, bool delegate() get_bool = null, void delegate(bool) set_bool = null )
	{
		super();
		
		tickButton = new TickButton(get_bool, set_bool);
		add(tickButton);
		
		init(set_label);
	}
		
	//You must first create tickButton before calling init().
	protected void init(dchar[] set_label)
	{	
		verticalScrollbarSetting = ScrollbarSetting.NEVER;
		horizontalScrollbarSetting = ScrollbarSetting.NEVER;
		
		type = "ToggleButton";
		name = set_label;
		
		/*background = new HBox();
		//background.colour = g_rae.getColourArrayFromTheme(set_theme_image);
		background.xPackOptions = PackOptions.EXPAND;
		background.yPackOptions = PackOptions.EXPAND;
		background.verticalScrollbarSetting = ScrollbarSetting.NEVER;
		background.horizontalScrollbarSetting = ScrollbarSetting.NEVER;
		*/
		
		//tickButton.colour();
		/*
		tickButton.defaultHeight = 0.01f;
		tickButton.defaultWidth = 0.01f;
		tickButton.maxWidth = 0.01f;
		tickButton.maxHeight = 0.01f;
		*/
		//tickButton.xPackOptions = PackOptions.EXPAND;
		//tickButton.yPackOptions = PackOptions.EXPAND;
		//background.
		
		
		
		/*
		if( orientation == OrientationType.HORIZONTAL )
		{
			centerRect.xPackOptions = PackOptions.SHRINK;
			//centerRect.xPackOptions = PackOptions.EXPAND;
			centerRect.yPackOptions = PackOptions.EXPAND;
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			centerRect.xPackOptions = PackOptions.EXPAND;
			centerRect.yPackOptions = PackOptions.SHRINK;
			//centerRect.yPackOptions = PackOptions.EXPAND;
		}
		*/
		
		//shape = new ShapeRoundRectangle(ix1, iy1, ix2, iy2);
		/////////////shape = ShapeType.ROUND_RECTANGLE;
		//shape = ShapeType.SHADOW;
		//shape.texture = g_rae.getTextureFromTheme("Rae.Button");
		/////////////shape.themeTexture = "Rae.Button";
		//shape.texture = g_rae.getTextureFromTheme("Rae.Button");
		//shape.isTextureCoordsOne = false;
		//shape.texture = g_rae.getTextureFromTheme("Rae.Button.leftRoundRect");
		
		//isClipping = true;
		
		/////////////arrangeType = ArrangeType.LAYER;//was HBOX
		
		
		
		//colour = g_rae.getColourArrayFromTheme("Rae.Button");
		
		//rectangle.
		//colour(0.7f, 0.7f, 0.7f, 1.0f);//Light grey
		//colour(0.1f, 0.1f, 0.1f, 1.0f);//dark grey
		//rectangle.
		//set( 0.0f, 0.0f, 0.6f, 0.2f );
		
		arrangeType = ArrangeType.HBOX;
		
		//renderMethod = RenderMethod.BYPASS;
		
		xPackOptions = PackOptions.SHRINK;
		yPackOptions = PackOptions.SHRINK;
		
		
		
		isOutline = true;
		
		/*
		outPaddingX = 0.005f;
		outPaddingY = 0.005f;
		inPaddingX = 0.015f;
		inPaddingY = 0.015f;
		
		colour(0.0f, 0.4f, 0.0f, 0.5f);
		*/
		
		
		/////////////xPackOptions = PackOptions.SHRINK;
		/////////////yPackOptions = PackOptions.SHRINK;
		defaultHeight = g_rae.getValueFromTheme("Rae.Button.defaultHeight");
		minHeight = g_rae.getValueFromTheme("Rae.Button.defaultHeight");
		
		//texture = g_rae.getTextureFromTheme("Rae.Button");
				
		label = new Label(set_label);
		label.textColour = g_rae.getColourArrayFromTheme("Rae.Button.text");
		//label.colour = g_rae.getColourArrayFromTheme("Rae.Text");
		//label.colour(0.0, 0.0, 0.0, 1.0);//Black
		//label.colour(1.0, 1.0, 1.0, 1.0);//White
		//label.xPackOptions = PackOptions.EXPAND;
		//label.yPackOptions = PackOptions.EXPAND;

		//buttonDraw = new ButtonDraw();

		//Now that we have the label set up, it knows it's
		//width, and we can use it to set our defaultWidth.
		//using padding here is just funny. We should really have
		//a system with inPadding and outPadding.
		
		//defaultWidth = label.textWidth + (padding * 6.0f);
		//minWidth = defaultWidth;
		
		/////////followsChildWidth = true;
		//AARGH: followsChildHeight = true;
		
		/*
		SHOULD REMOVE WHOLE followsChildWidth and followsChildHeight
		THEY JUST SHOW HOW BADLY THE SYSTEM WORKS NOW.
		PackOptions.SHRINK should do the same thing...
		*/
		
		
		//add(buttonDraw);
		
		//background.
		add(label);
		
		/*
		auto hackRect = new Rectangle();
		hackRect.colour(0.3f, 0.3f, 0.6f, 0.4f);
		add( hackRect );
		*/
		
		buttonHandlerInit();
		
		//signalActivate.attach( &tickButton.toggleIsSelected );
		signalActivate.attach( &tickButton.onActivate );
	}
	
	TickButton tickButton;
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
