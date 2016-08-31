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

module rae.ui.Button;

import tango.util.log.Trace;//Thread safe console output.

import tango.math.Math;
import tango.util.container.LinkedList;
import tango.core.Signal;
import Float = tango.text.convert.Float;

import rae.core.globals;
import rae.core.IRaeMain;
import rae.ui.InputState;
import rae.ui.Widget;
//import rae.canvas.Rectangle;
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


/*

//OK, maybe ButtonDraw wasn't such a great idea.

class ButtonDraw : Rectangle
{
	this()
	{
		super();
		
		arrangeType = ArrangeType.HBOX;
		
		name = "ButtonDraw";
		
		colour = g_rae.getColourArrayFromTheme("Rae.Button");
		
		isOutline = false;
		
		//inPadding = 0.015f;
		//padding = 0.005f;
		xPackOptions = PackOptions.SHRINK;
		yPackOptions = PackOptions.SHRINK;
		//xPackOptions = PackOptions.EXPAND;
		//yPackOptions = PackOptions.EXPAND;
		//defaultHeight = g_rae.getValueFromTheme("Rae.Button.defaultHeight");
		
		//texture = g_rae.getTextureFromTheme("Rae.Button");
		
		leftRoundRect = new Rectangle();
		//leftRoundRect.colour(1.0f, 0.0f, 0.0f, 1.0f);
		leftRoundRect.colour = g_rae.getColourArrayFromTheme("Rae.Button");
		leftRoundRect.texture = g_rae.getTextureFromTheme("Rae.ButtonDraw.leftRoundRect");
		leftRoundRect.isOutline = false;
		leftRoundRect.xPackOptions = PackOptions.SHRINK;
		leftRoundRect.yPackOptions = PackOptions.EXPAND;
		leftRoundRect.defaultWidth = g_rae.getValueFromTheme("Rae.Button.defaultHeight") * 0.5f;
		add(leftRoundRect);
		
		centerFlatRect = new Rectangle();
		//centerFlatRect.colour(0.0f, 1.0f, 0.0f, 1.0f);
		centerFlatRect.colour = g_rae.getColourArrayFromTheme("Rae.Button");
		centerFlatRect.texture = g_rae.getTextureFromTheme("Rae.Button");
		centerFlatRect.isOutline = false;
		centerFlatRect.xPackOptions = PackOptions.EXPAND;
		centerFlatRect.yPackOptions = PackOptions.EXPAND;
		add(centerFlatRect);
		
		rightRoundRect = new Rectangle();
		//rightRoundRect.colour(0.0f, 0.0f, 1.0f, 1.0f);
		rightRoundRect.colour = g_rae.getColourArrayFromTheme("Rae.Button");
		rightRoundRect.texture = g_rae.getTextureFromTheme("Rae.ButtonDraw.rightRoundRect");
		rightRoundRect.isOutline = false;
		rightRoundRect.xPackOptions = PackOptions.SHRINK;
		rightRoundRect.yPackOptions = PackOptions.EXPAND;
		rightRoundRect.defaultWidth = g_rae.getValueFromTheme("Rae.Button.defaultHeight") * 0.5f;
		add(rightRoundRect);
	}
	
	protected Rectangle leftRoundRect;
	protected Rectangle centerFlatRect;
	protected Rectangle rightRoundRect;
}

*/

template ButtonHandlerMixin()
{
	void buttonHandlerInit()
	{
		signalMouseButtonPress.attach(&buttonHandler);
		signalMouseButtonRelease.attach(&buttonHandler);
		//signalMouseMotion.attach(&buttonHandler);
		signalEnterNotify.attach(&buttonHandler);
		signalLeaveNotify.attach(&buttonHandler);
	}

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
				bool is_the_same = wid.ungrabInput();
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
				if( is_the_same == true && wid.enclosureLocal( input.mouse.xLocal, input.mouse.yLocal ) )
				{
					//Trace.formatln("Doing activate.");
					onActivate();
					onActivateData();
				}
				
				/*if( wid.parent !is null && wid.parent.hasAnimators == false )
				{
					wid.parent.addDefaultAnimator( DefaultAnimator.ROTATE_360 );
				}*/
			break;
		}
	}
	
	Signal!() signalActivate;
	void onActivate()
	{
		signalActivate.call();
		//return true;//This doesn't actually go to the parents...
	}
	
	Signal!(Rectangle) signalActivateData;
	void onActivateData()
	{
		signalActivateData.call(this);
		//return true;//This doesn't actually go to the parents...
	}
}

template ButtonLabelMixin()
{
	//dchar[] is an UTF-32 unicode string.
	public dchar[] name(){ return m_name; }
	public void name(dchar[] set)
	{
		m_name = set;
		if( label !is null )
			label.name = set;
		//return m_name;
	}
	
	/*
	//We don't want this for button, but for entry...
	//also sets labels alignType, when setting it for button.
	public AlignType alignType() { return m_alignType; }
	public AlignType alignType(AlignType set)
	{
		m_alignType = set;
		if( m_label !is null ) m_label.alignType = set;
		return m_alignType;
	}
	*/

	public Label label() { return m_label; }
	protected void label(Label set) { m_label = set; }
	protected Label m_label;
	
	///Just adds an "alias" called text for the label.name.
	public dchar[] text(){ return label.name; }
	public void text(dchar[] set){ label.name = set; }
}

template BackgroundMixin()
{
	void backgroundInit( char[] set_theme_image )
	{
		background = new RoundedRectangle(set_theme_image);
		background.colour = g_rae.getColourArrayFromTheme(set_theme_image);
		background.xPackOptions = PackOptions.EXPAND;
		background.yPackOptions = PackOptions.EXPAND;
		
	}
	
	void colour( GLfloat sr, GLfloat sg, GLfloat sb, GLfloat sa )
	{
		if( background is null )
		{
			super.colour(sr,sg,sb,sa);
		}
		else
		{
			background.r = sr;
			background.g = sg;
			background.b = sb;
			background.a = sa;
		}
	}
}

enum ButtonType
{
	RECTANGLE,
	SQUARE
}

class Button : public Rectangle
{
public:

	mixin ButtonHandlerMixin;
	mixin ButtonLabelMixin;
	mixin BackgroundMixin;
	mixin IsSelectedMixin;

	
	protected this()//Remove?
	{
		//super();//"Rae.Button");
		
		this(""d);
		
		type = "Button";
		
		//background = new RoundedRectangle("Rae.Button");
		//background.colour = g_rae.getColourArrayFromTheme("Rae.Button");
	}
	
	this( dchar[] set_label, ButtonType set_button_type = ButtonType.RECTANGLE )
	{
		this( set_label, null, set_button_type );
	}

	this( dchar[] set_label, void delegate() set_on_activate, ButtonType set_button_type = ButtonType.RECTANGLE )
	{
		super();//"Rae.Button");
		
		type = "Button";
		
		float default_height;
		
		if( set_button_type == ButtonType.RECTANGLE )
		{
			default_height = g_rae.getValueFromTheme("Rae.Button.rectangle.defaultHeight");
		
			backgroundInit("Rae.Button");
			renderMethod = RenderMethod.BYPASS;
			defaultHeight = default_height;
			minHeight = default_height;
			
			label = new Label(set_label, g_rae.getValueFromTheme("Rae.Font.normal") );
		}
		else if( set_button_type == ButtonType.SQUARE )
		{
			default_height = g_rae.getValueFromTheme("Rae.Button.square.defaultHeight");
		
			renderMethod = RenderMethod.PIXELS;
			shape.themeTexture = "Rae.SquareButton";
		
			defaultSize(default_height, default_height);
			maxWidth = default_height;
			maxHeight = default_height;
			
			label = new Label(set_label, g_rae.getValueFromTheme("Rae.Font.small") );
		}
		
		label.textColour = g_rae.getColourArrayFromTheme("Rae.Button.text");
		//label.colour = g_rae.getColourArrayFromTheme("Rae.Text");
		//label.colour(0.0, 0.0, 0.0, 1.0);//Black
		//label.colour(1.0, 1.0, 1.0, 1.0);//White
		label.xPackOptions = PackOptions.EXPAND;
		//label.yPackOptions = PackOptions.EXPAND;
		
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
		
		name = set_label;
		
		//colour = g_rae.getColourArrayFromTheme("Rae.Button");
		
		//rectangle.
		//colour(0.7f, 0.7f, 0.7f, 1.0f);//Light grey
		//colour(0.1f, 0.1f, 0.1f, 1.0f);//dark grey
		//rectangle.
		//set( 0.0f, 0.0f, 0.6f, 0.2f );
		
		arrangeType = ArrangeType.HBOX;
		
		xPackOptions = PackOptions.SHRINK;
		yPackOptions = PackOptions.SHRINK;
		
		
		isOutline = false;
		
		outPaddingX = 0.005f;
		outPaddingY = 0.005f;
		inPaddingX = 0.015f;
		inPaddingY = 0.015f;
		
		
		
		/////////////xPackOptions = PackOptions.SHRINK;
		/////////////yPackOptions = PackOptions.SHRINK;
		
		//texture = g_rae.getTextureFromTheme("Rae.Button");
				
		

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
		
		add(label);
		
		buttonHandlerInit();
		
		if( set_on_activate !is null )
			signalActivate.attach(set_on_activate);
	}
	
	/*
	//A funny override of renderNormal with a custom renderPixelPerPixel...
	override void renderNormal(Draw draw)
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
			if( texture !is null )
				renderPixelPerPixel( draw, (w / g_rae.pixel)+6.0f, texture.height );
			else super.renderNormal(draw);
		}
		version(zoomCairo)
		{
			if( texture !is null )
				renderPixelPerPixel( draw, (tr_w_i2l(w) / g_rae.pixel)+102.0f, texture.height );
			else super.renderNormal(draw);
		}
		
		
		//super.render(draw);
		//renderPixelPerPixelHeight( draw, 64.0f );
	}
	*/
	
	
	
	/*void renderChildren()
	{
		super.renderChildren();
		
		//Draw.showText(name);
	}*/
	
	/*
	void renderImmediateMode(Draw draw)
	{
		//Trace.formatln("	PlainRectangle.render() START.");
		glPushMatrix();
		
			applyPosition();
			applyRotation();
			applyScale();
			
			applyCulling();
			
			//float zero = 0.0f;
			
			//glTranslatef( -cx, -cy, 0.0f );
			
			//glTranslatef( -(w*0.5f), -(h*0.5f), 0.0f );
			
			float posx1 = ix1;
			float posx2 = ix1 + (h*0.5f);
			float posy1 = iy1;
			float posy2 = iy2;
			
			float posx3 = ix2;
			float posx4 = ix2 - (h*0.5f);
			
			float cir_wid = h * 0.5f;
			float cir_hei = h * 0.5f;
			
			float what_pi = PI - (PI*0.5f);
			
			float step = what_pi / 8.0f;
			
			
			//Shadows
			
			float shad_wid = cir_wid * 1.3f;// * 0.5f;
			float shad_hei_top = cir_hei * 1.1f;// * 0.5f;
			float shad_hei_bottom = cir_hei * 1.5f;// * 0.5f;
			
			//Left shadow:
			glBegin(GL_QUAD_STRIP);
				for( float a = (-PI*0.5f); a <= what_pi; a += step )
				{
					applyShadowColour();
					glVertex3f( posx2 - cos(a) * cir_wid, icy - sin(a) * cir_hei, iz );
					glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
					if( a < 0.0f )
						glVertex3f( posx2 - cos(a) * shad_wid, icy - sin(a) * shad_hei_bottom, iz );
					else
						glVertex3f( posx2 - cos(a) * shad_wid, icy - sin(a) * shad_hei_top, iz );
				}
			glEnd();
			
			//Right shadow:
			glBegin(GL_QUAD_STRIP);
				for( float a = what_pi; a >= (-PI*0.5f); a -= step )
				{
					applyShadowColour();
					glVertex3f( posx4 + cos(a) * cir_wid, icy - sin(a) * cir_hei, iz );
					glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
					if( a < 0.0f )
						glVertex3f( posx4 + cos(a) * shad_wid, icy - sin(a) * shad_hei_bottom, iz );
					else
						glVertex3f( posx4 + cos(a) * shad_wid, icy - sin(a) * shad_hei_top, iz );
				}
			glEnd();
			
			//Top shadow:
			glBegin(GL_QUADS);
					applyShadowColour();//glColor4f(0.0f, 0.0f, 0.0f, 0.5f);
					glVertex3f( posx2, iy1, iz );
					glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
					glVertex3f( posx2, iy1 - (shad_hei_top-cir_hei), iz );
					glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
					glVertex3f( posx4, iy1 - (shad_hei_top-cir_hei), iz );
					applyShadowColour();//glColor4f(0.0f, 0.0f, 0.0f, 0.5f);
					glVertex3f( posx4, iy1, iz );
					
				//Bottom shadow:
					applyShadowColour();//glColor4f(0.0f, 0.0f, 0.0f, 0.5f);
					glVertex3f( posx4, iy2, iz );
					glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
					glVertex3f( posx4, iy2 + (shad_hei_bottom-cir_hei), iz );
					glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
					glVertex3f( posx2, iy2 + (shad_hei_bottom-cir_hei), iz );
					applyShadowColour();//glColor4f(0.0f, 0.0f, 0.0f, 0.5f);
					glVertex3f( posx2, iy2, iz );
			glEnd();
			
			
			//Visible elements:
			applyColour();
			applyTexture();
			//Left side:
			
			glBegin(GL_TRIANGLE_FAN);
			
					//First the center
					glTexCoord2f( 0.0f, 0.5f );//Wow! Assumptions here... (Texture is a "1D" gradient... only height matters...)
					glVertex3f( posx2, icy, iz );
				
					for( float a = (-PI*0.5f); a <= what_pi; a += step )
					{
						glTexCoord2f( 0.0f, 0.5 + (-0.5f * sin(a)) );
						glVertex3f( posx2 - cos(a) * cir_wid, icy - sin(a) * cir_hei, iz );
					}
					
			glEnd();
			
			//Right side:
			
			//applyColour();
			
			glBegin(GL_TRIANGLE_FAN);
			
					//First the center
					glTexCoord2f( 0.0f, 0.5f );//Wow! Assumptions here... (Texture is a "1D" gradient... only height matters...)
					glVertex3f( posx4, icy, iz );
				
					for( float a = what_pi; a >= (-PI*0.5f); a -= step )
					{
						glTexCoord2f( 0.0f, 0.5 + (-0.5f * sin(a)) );
						glVertex3f( posx4 + cos(a) * cir_wid, icy - sin(a) * cir_hei, iz );
					}
					
			glEnd();
			
			//The middle:
			
			//applyColour();
			
			glBegin(GL_QUADS);
				
				glNormal3f( 0.0f, 0.0f, 1.0f );
				glTexCoord2f( 0.0f, 0.0f );
				glVertex3f( posx2, iy1, iz );
				
				//glNormal3f( 0.0f, 0.0f, 1.0f );
				glTexCoord2f( 1.0f, 0.0f );
				glVertex3f( posx4, iy1, iz );
				
				//glNormal3f( 0.0f, 0.0f, 1.0f );
				glTexCoord2f( 1.0f, 1.0f );
				glVertex3f( posx4, iy2, iz );
				
				//glNormal3f( 0.0f, 0.0f, 1.0f );
				glTexCoord2f( 0.0f, 1.0f );
				glVertex3f( posx2, iy2, iz );	
			glEnd();
			
			
			endTexture();
			
			//Outlines
			
			//left:
			if( isOutline == true )
			{
				glColor4f(r*0.2f, g*0.2f, b*0.2f, a);
				glBegin(GL_LINE_STRIP);
					for( float a = (-PI*0.5f); a <= what_pi; a += step )
					{
						glVertex3f( posx2 - cos(a) * cir_wid, icy - sin(a) * cir_hei, iz );
					}
				glEnd();
			}
			
			//right:
			
			if( isOutline == true )
			{
				glColor4f(r*0.2f, g*0.2f, b*0.2f, a);
				glBegin(GL_LINE_STRIP);
					for( float a = (-PI*0.5f); a <= what_pi; a += step )
					{
						glVertex3f( posx4 + cos(a) * cir_wid, icy - sin(a) * cir_hei, iz );
					}
				glEnd();
			}
			
			//middle:
			
			if( isOutline == true )
			{
				glColor4f(r*0.2f, g*0.2f, b*0.2f, a);
				
				//glBegin(GL_LINE_STRIP);
				glBegin(GL_LINES);
					//glNormal3f( 0.0f, 0.0f, 1.0f );
					glVertex3f( posx2, iy1, iz );
					glVertex3f( posx4, iy1, iz );
					
					glVertex3f( posx2, iy2, iz );
					glVertex3f( posx4, iy2, iz );
				glEnd();
			}
			
				
			applyClipping();
			
				renderChildren(draw);
			
			endClipping();
			
		glPopMatrix();
		
	}
	*/
	
protected:
	
	//protected ButtonDraw buttonDraw;
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
