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

module rae.ui.SubWindow;

import tango.util.log.Trace;//Thread safe console output.

import tango.util.container.LinkedList;
import tango.math.Math;
import tango.core.Signal;
import Float = tango.text.convert.Float;
//import Integer = tango.text.convert.Integer;
import Util = tango.text.Util;

import rae.core.globals;
import rae.core.IRaeMain;
public import rae.ui.InputState;
import rae.ui.Widget;
import rae.canvas.RoundedRectangle;
import rae.ui.Animator;
import rae.ui.Button;
import rae.ui.CircleButton;
import rae.ui.Label;
public import rae.canvas.Rectangle;
import rae.canvas.Image;
import rae.canvas.Draw;
import rae.canvas.ShapeRoundRectangle;

import rae.gl.gl;
import rae.gl.glu;
import rae.gl.GLExtensions;

/*
version(sdl)
{
	import derelict.opengl.gl;
	import derelict.opengl.glu;
	//import derelict.sdl.sdl;
}//end version(sdl)
version(gtk)
{
	import gtkglc.gl;
	import gtkglc.glu;
}
*/


/*
//I've decided that Widget's should be versatile containers
//so that you can use any widget as a vbox or any other layout
//you want and add child widget's to any other widget.
class Container : Widget
{
public:
	LinkedList!(Widget) child;
	
	this()
	{
		child = new LinkedList!(Widget);
	}
	
	void add( Widget a_widget )
	{
		child.append( a_widget );
	}
	
	void render()
	{
		glPushMatrix();
			glTranslatef( x, y, 0.0f );
			glRotatef( rotate_y, 0.0f, 1.0f, 0.0f );
			Rectangle.render();
			
			foreach(Widget wid; child)
			{
				wid.render();
			}
			
			if( isRotate == true )
			{
				rotate_y += 0.3f;
				//Trace.formatln("rotate_y: ")(rotate_y);
			}
			if( rotate_y >= 180.0f )
			{
				isRotate = false;
				rotate_y = 0.0f;
			}
		glPopMatrix();
	}
}

///A Container that only has one child item.
class Bin : Container
{
	this()
	{
		super();
	}
}
*/

class Separator : public Rectangle
{
	this(float set_width, float set_height)
	{
		super();
		name = "Separator";
		type = "Separator";
		defaultWidth = set_width;//0.025f;
		maxWidth = set_width;//0.025f;
		defaultHeight = set_height;//0.025f;
		maxHeight = set_height;//0.025f;
		xPackOptions = PackOptions.SHRINK;
		yPackOptions = PackOptions.SHRINK;
		colour(1.0f, 1.0f, 1.0f, 0.0f);//transparent!
		isOutline = false;
	}
}


class ResizeButton : Rectangle
{
public:
	mixin ButtonHandlerMixin;
	mixin ButtonLabelMixin;

	this(dchar[] set_name)//ResizeButton has no label.
	{
		super();
		
		type = "ResizeButton";
		
		arrangeType = ArrangeType.LAYER;
		
		name = set_name;
		
		renderMethod = RenderMethod.PIXELS;
		isOutline = false;
		
		shape = ShapeType.RECTANGLE;
		shape.themeTexture = "Rae.ResizeButton";
		
		//rectangle.
		//colour(63.0f/255.0f, 128.0f/255.0f, 74.0f/255.0f, 1.0f);
		colour = g_rae.getColourArrayFromTheme("Rae.ResizeButton");
		//rectangle.
		//set( 0.0f, 0.0f, 0.6f, 0.2f );
		
		outPaddingX = 0.0f;
		outPaddingY = 0.0f;
		inPaddingX = 0.0f;
		inPaddingY = 0.0f;
		
		//float[4] m_textColourData = [1.0f, 1.0f, 1.0f, 1.0f];
		//texture = Image.createCircle(m_textColourData);
		//texture.blendDestination = GL_ONE;
		/*
		label = new Label(set_label);
		label.colour(0.0, 0.0, 0.0, 1.0);
		label.xPackOptions = PackOptions.EXPAND;
		add(label);
		*/
		
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
	void render(Draw draw)
	{
		Widget.render(draw);
	}
	
	void renderImmediateMode(Draw draw)
	{
		
		//Trace.formatln("	PlainRectangle.render() START.");
		glPushMatrix();
		
			applyPosition();
			applyRotation();
			applyScale();
			
			applyCulling();
			applyTexture();
			applyColour();
			
			float cir_wid = h;// * 0.5f;
			float cir_hei = h;// * 0.5f;
			
			float what_pi = PI/2.0f;
			
			float step = what_pi / 8.0f;
			
			//Right side:
			
			applyColour();
			
			float posx3 = ix2;
			float posx4 = ix1;
			float posy3 = iy1;
			float posy4 = iy2;
			
			//float cir_wid = h;// * 0.5f;
			//float cir_hei = h;// * 0.5f;
			
			//float what_pi = PI/2.0f;
			
			glBegin(GL_TRIANGLE_FAN);
			//glBegin(GL_POINTS);
			
				//First the center
				glTexCoord2f( 0.0f, 0.0f );//Wow! Assumptions here... (Texture is a "1D" gradient... only height matters...)
				glVertex3f( icx, icy, iz );
					
				for( float a = 0.0f; a <= what_pi; a += step )
				{
					glTexCoord2f( 0.0f, sin(a) );
					glVertex3f( posx4 + cos(a) * cir_wid, posy3 + sin(a) * cir_hei, iz );
				}
			//}
			
			//glEnd();
			
			//glBegin(GL_TRIANGLE_FAN);
			
			
				//First the center
				//glTexCoord2f( 0.0f, 0.0f );//Wow! Assumptions here... (Texture is a "1D" gradient... only height matters...)
				//glVertex3f( icx, icy, iz );
					
				for( float a = 0.0f; a <= what_pi + step; a += step )
				{
					glTexCoord2f( 0.0f, sin(a) );
					glVertex3f( posx3 - cos(a) * cir_wid, posy4 - sin(a) * cir_hei, iz );
				}
			//}
			
			glEnd();
			
			endTexture();
			
			if( isOutline == true )
			{
				glColor4f(r*0.5f, g*0.5f, b*0.5f, a);
				glBegin(GL_LINE_STRIP);
				//glBegin(GL_POINTS);
				
					//float step = what_pi / 8.0f;
				
					for( float a = 0.0f; a <= what_pi; a += step )
					{
						glVertex3f( posx4 + cos(a) * cir_wid, posy3 + sin(a) * cir_hei, iz );
					}
				
				//glEnd();
				
				//glBegin(GL_LINE_STRIP);
				
					//float step = what_pi / 8.0f;
				
					for( float a = 0.0f; a <= what_pi + step; a += step )
					{
						glVertex3f( posx3 - cos(a) * cir_wid, posy4 - sin(a) * cir_hei, iz );
					}
				
				glEnd();
			}
			
			
			applyClipping();
				renderChildren(draw);
			endClipping();
			
		glPopMatrix();
		
		
		//if( texture !is null )
		//	texture.popTexture();
		
	}
	
*/
	
}

enum WindowHeaderType
{
	NONE,
	NORMAL,
	SMALL
}

/*

class WindowHeader : public Button
{
	this(char[] set_label, WindowHeaderType set_type, bool set_is_top )
	{
		super(set_label);
		followsChildWidth = false;
		arrangeType = ArrangeType.HBOX;
	}

}

*/


class WindowHeader : Rectangle//Button
{
public:

	mixin ButtonHandlerMixin;
	mixin ButtonLabelMixin;

	bool isTop = true;
	
	/*
	//TEMP override of button.
	void render(Draw draw)
	{
		Widget.render( draw );
	}
	*/
	
	//RoundedRectangle background123;
	//Rectangle foreground;
	
	this(dchar[] set_label, WindowHeaderType set_type, bool set_is_top)
	{
		//super(set_label);
		isTop = set_is_top;
		
		type = "WindowHeader";
		
		if( isTop == true )
		{
			super();
			
			background = new RoundedRectangle("Rae.WindowHeader.Top");
			//super.add(background123);
			
			/*
			foreground = new Rectangle();
			foreground.arrangeType = ArrangeType.HBOX;
			foreground.renderMethod = RenderMethod.BYPASS;
			super.add(foreground);
			*/
			
			//super(set_label);
			////////themeTexture = "Rae.WindowHeader.Top";
			background.colour = g_rae.getColourArrayFromTheme("Rae.WindowHeader.Top");
			//colour(0.1, 0.1, 0.1, 1.0);//dark
			//colour(1.0, 1.0, 1.0, 0.9);//white
			//texture = new Image( Image.GRADIENT_2 );
			//texture = g_rae.getTextureFromTheme("Rae.WindowHeader.Top");
			//shape.themeTexture = "Rae.WindowHeader.Top";
			//texture = g_rae.getTextureFromTheme("Rae.Button");
		}
		else
		{
			super();
			
			background = new RoundedRectangle("Rae.WindowHeader.Bottom");
			//super.add(background);
			
			/*
			foreground = new Rectangle();
			foreground.arrangeType = ArrangeType.HBOX;
			foreground.renderMethod = RenderMethod.BYPASS;
			super.add(foreground);
			*/
			
			//super(set_label);
			////////7themeTexture = "Rae.WindowHeader.Bottom";
			background.colour = g_rae.getColourArrayFromTheme("Rae.WindowHeader.Bottom");
			//texture = g_rae.getTextureFromTheme("Rae.WindowHeader.Bottom");
			//shape.themeTexture = "Rae.WindowHeader.Bottom";
			//colour(7.0f/255.0f, 7.0f/255.0f, 7.0f/255.0f, 1.0f);//dark
			//colour(0.7, 0.7, 0.7, 0.9);//white
		}
		
		background.xPackOptions = PackOptions.EXPAND;
		background.yPackOptions = PackOptions.EXPAND;
		//background123.yPackOptions = PackOptions.SHRINK;
		
		//arrangeType = ArrangeType.LAYER;
		arrangeType = ArrangeType.HBOX;
		
		renderMethod = RenderMethod.BYPASS;
		
		xPackOptions = PackOptions.EXPAND;
		yPackOptions = PackOptions.SHRINK;
		
		
		name = set_label;
		
		/////////////shape = ShapeType.ROUND_RECTANGLE;
		//shape = new ShapeRoundRectangle(ix1, iy1, ix2, iy2);
		
		
		label = new Label(set_label);
		label.textColour = g_rae.getColourArrayFromTheme("Rae.WindowHeader.text");
		//label.colour = g_rae.getColourArrayFromTheme("Rae.Text");
		//label.colour(1.0, 1.0, 1.0, 1.0);//white
		//label.colour(0.0, 0.0, 0.0, 1.0);//black
		label.xPackOptions = PackOptions.EXPAND;
		//foreground.
		add(label);
		
		if( set_type == WindowHeaderType.NORMAL )
		{
			defaultHeight = g_rae.getValueFromTheme("Rae.WindowHeader.NORMAL.defaultHeight");
			maxHeight = g_rae.getValueFromTheme("Rae.WindowHeader.NORMAL.defaultHeight");
		}
		else if ( set_type == WindowHeaderType.SMALL )
		{
			defaultHeight = g_rae.getValueFromTheme("Rae.WindowHeader.SMALL.defaultHeight");
			maxHeight = g_rae.getValueFromTheme("Rae.WindowHeader.SMALL.defaultHeight");
		}
		
		
		outPaddingX = 0.0f;
		outPaddingY = 0.0f;
		inPaddingX = 0.0f;
		inPaddingY = 0.0f;
		
		//isClipping = true;
		
		buttonHandlerInit();
		//signalMouseButtonPress.attach(&buttonHandler);
		//signalMouseButtonRelease.attach(&buttonHandler);
		//signalMouseMotion.attach(&buttonHandler);
		//signalEnterNotify.detach(&Button.buttonHandler);//detach doesn't work?
		//signalLeaveNotify.detach(&Button.buttonHandler);//detach doesn't work?
		
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
	
	/*
	override void add( Rectangle a_widget )
	{
// 		if( foreground !is null )
// 		{
// 			foreground.add( a_widget );
// 		}
	}
	
	override void append( Rectangle a_widget )
	{
// 		if( foreground !is null )
// 		{
// 			foreground.append( a_widget );
// 		}
	}
	
	override void prepend( Rectangle a_widget )
	{
// 		if( foreground !is null )
// 		{
// 			foreground.prepend( a_widget );
// 		}
	}
	
	override void remove( Rectangle a_widget )
	{
// 		if( foreground !is null )
// 		{
// 			foreground.remove( a_widget );
// 		}
	}
	
	override void clear()
	{
// 		if( foreground !is null )
// 		{
// 			foreground.clear();
// 		}
	}
	*/
	
	
	//detach doesn't work for signalEnterNotify
	//so I'm going to override prelights so that
	//there is no prelight in WindowHeader.
	//OH, I guess it does work.
	/*
	override bool prelight()
	{
		m_isPrelight = true;
		
		//colourMem( r, g, b, a );
		
		///////colourAnim( prelightColour.r, prelightColour.g, prelightColour.b, prelightColour.a );
		
		
		//////////invalidate();
		return m_isPrelight;
	}
	override bool unprelight()
	{
		m_isPrelight = false;
		
		//colourAnim( rMem, gMem, bMem, aMem );
		////////////colourAnim( mainColour.r, mainColour.g, mainColour.b, mainColour.a );
		
		///////////invalidate();
		return m_isPrelight;
	}
	*/
	
	/*
	//This is really deprecated:
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
			float posx2 = ix1 + h;
			float posy1 = iy1;
			float posy2 = iy2;
			
			float cir_wid = h;// * 0.5f;
			float cir_hei = h;// * 0.5f;
			
			float what_pi = PI/2.0f;
			float step = what_pi / 8.0f;
			
			float posx3 = ix2;
			float posx4 = ix2 - h;
			float posy3 = iy1;
			float posy4 = iy2;
			
			//Left shadow:
			
			//float shadx1 = ix1;
			//float shadx2 = ix1 + h;
			//float shady1 = iy1;
			//float shady2 = iy2;
			
			float shad_wid = cir_wid * 1.5f;//2.0f;// * 0.5f;
			float shad_hei_top = cir_hei * 1.1f;//1.5f;// * 0.5f;
			float shad_hei_bottom = cir_hei * 1.7f;//2.5f;// * 0.5f;
			
			glBegin(GL_QUAD_STRIP);
			
				//float step = what_pi / 8.0f;
				
				if( isTop == true )
				{
					for( float a = 0.0f; a <= what_pi; a += step )
					{
						//glTexCoord2f( 0.0f, 1.0f - sin(a) );
						applyShadowColour();//glColor4f(0.0f, 0.0f, 0.0f, 0.5f);
						glVertex3f( posx2 - cos(a) * cir_wid, posy2 - sin(a) * cir_hei, iz );
						glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
						glVertex3f( posx2 - cos(a) * shad_wid, posy2 - sin(a) * shad_hei_top, iz );
					}
				}
				else
				{
					for( float a = what_pi; a >= 0.0f; a -= step )
					{
						//glTexCoord2f( 0.0f, sin(a) );
						applyShadowColour();//glColor4f(0.0f, 0.0f, 0.0f, 0.5f);
						glVertex3f( posx2 - cos(a) * cir_wid, posy1 + sin(a) * cir_hei, iz );
						glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
						glVertex3f( posx2 - cos(a) * shad_wid, posy1 + sin(a) * shad_hei_bottom, iz );
					}
				}
			
			glEnd();
			
			//Right shadow:
			
			glBegin(GL_QUAD_STRIP);
			
			if( isTop == true )
			{
				for( float a = what_pi; a >= 0.0f; a -= step )
				{
					//glTexCoord2f( 0.0f, 1.0f - sin(a) );
					applyShadowColour();//glColor4f(0.0f, 0.0f, 0.0f, 0.5f);
					glVertex3f( posx4 + cos(a) * cir_wid, posy4 - sin(a) * cir_hei, iz );
					glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
					glVertex3f( posx4 + cos(a) * shad_wid, posy4 - sin(a) * shad_hei_top, iz );
				}
			}
			else
			{
				for( float a = 0.0f; a <= what_pi; a += step )
				{
					//glTexCoord2f( 0.0f, sin(a) );
					applyShadowColour();//glColor4f(0.0f, 0.0f, 0.0f, 0.5f);
					glVertex3f( posx4 + cos(a) * cir_wid, posy3 + sin(a) * cir_hei, iz );
					glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
					glVertex3f( posx4 + cos(a) * shad_wid, posy3 + sin(a) * shad_hei_bottom, iz );
				}
			}
			
			glEnd();
			
			//Top or bottom shadow:
			if( isTop == true )
			{
				glBegin(GL_QUADS);
					applyShadowColour();//glColor4f(0.0f, 0.0f, 0.0f, 0.5f);
					glVertex3f( posx2, iy1, iz );
					glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
					glVertex3f( posx2, iy1 - (shad_hei_top-cir_hei), iz );
					glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
					glVertex3f( posx4, iy1 - (shad_hei_top-cir_hei), iz );
					applyShadowColour();//glColor4f(0.0f, 0.0f, 0.0f, 0.5f);
					glVertex3f( posx4, iy1, iz );
				glEnd();
			}
			else
			{
				glBegin(GL_QUADS);
					applyShadowColour();//glColor4f(0.0f, 0.0f, 0.0f, 0.5f);
					glVertex3f( posx4, iy2, iz );
					glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
					glVertex3f( posx4, iy2 + (shad_hei_bottom-cir_hei), iz );
					glColor4f(0.0f, 0.0f, 0.0f, 0.0f);
					glVertex3f( posx2, iy2 + (shad_hei_bottom-cir_hei), iz );
					applyShadowColour();//glColor4f(0.0f, 0.0f, 0.0f, 0.5f);
					glVertex3f( posx2, iy2, iz );
				glEnd();
			}
			
			//End shadows.
			
			
			//Visible elements:
			applyTexture();
			applyColour();
			
			//Left side:
			
			glBegin(GL_TRIANGLE_FAN);
			//glBegin(GL_POINTS);
			
				if( isTop == true )
				{
					//First the center
					glTexCoord2f( 0.0f, 1.0f );//Wow! Assumptions here... (Texture is a "1D" gradient... only height matters...)
					glVertex3f( posx2, posy2, iz );
				
					for( float a = 0.0f; a <= what_pi; a += step )
					{
						glTexCoord2f( 0.0f, 1.0f - sin(a) );
						glVertex3f( posx2 - cos(a) * cir_wid, posy2 - sin(a) * cir_hei, iz );
					}
				}
				else
				{
					//First the center
					glTexCoord2f( 0.0f, 0.0f );//Wow! Assumptions here... (Texture is a "1D" gradient... only height matters...)
					glVertex3f( posx2, posy1, iz );
				
					for( float a = what_pi; a >= 0.0f; a -= step )
					{
						glTexCoord2f( 0.0f, sin(a) );
						glVertex3f( posx2 - cos(a) * cir_wid, posy1 + sin(a) * cir_hei, iz );
					}
				}
			
			glEnd();
			
			
			
			//Right side:
			
			//applyColour();
			
			//float cir_wid = h;// * 0.5f;
			//float cir_hei = h;// * 0.5f;
			
			//float what_pi = PI/2.0f;
			
			glBegin(GL_TRIANGLE_FAN);
			//glBegin(GL_POINTS);
			
			
			if( isTop == true )
			{
				//First the center
				glTexCoord2f( 0.0f, 1.0f );//Wow! Assumptions here... (Texture is a "1D" gradient... only height matters...)
				glVertex3f( posx4, posy4, iz );
					
				for( float a = what_pi; a >= 0.0f; a -= step )
				{
					glTexCoord2f( 0.0f, 1.0f - sin(a) );
					glVertex3f( posx4 + cos(a) * cir_wid, posy4 - sin(a) * cir_hei, iz );
				}
			}
			else
			{
				//First the center
				glTexCoord2f( 0.0f, 0.0f );//Wow! Assumptions here... (Texture is a "1D" gradient... only height matters...)
				glVertex3f( posx4, posy3, iz );
					
				for( float a = 0.0f; a <= what_pi; a += step )
				{
					glTexCoord2f( 0.0f, sin(a) );
					glVertex3f( posx4 + cos(a) * cir_wid, posy3 + sin(a) * cir_hei, iz );
				}
			}
			
			glEnd();
			
			//The middle:
			
			//applyColour();
			
			glBegin(GL_QUADS);
				
				glNormal3f( 0.0f, 0.0f, 1.0f );
				glTexCoord2f( 0.0f, 0.0f );
				glVertex3f( ix1 + h, iy1, iz );
				
				//glNormal3f( 0.0f, 0.0f, 1.0f );
				glTexCoord2f( 1.0f, 0.0f );
				glVertex3f( ix2 - h, iy1, iz );
				
				//glNormal3f( 0.0f, 0.0f, 1.0f );
				glTexCoord2f( 1.0f, 1.0f );
				glVertex3f( ix2 - h, iy2, iz );
				
				//glNormal3f( 0.0f, 0.0f, 1.0f );
				glTexCoord2f( 0.0f, 1.0f );
				glVertex3f( ix1 + h, iy2, iz );
				
				
// 				glNormal3f( 0.0f, 0.0f, 1.0f );
// 				glTexCoord2f( 0.0f, 0.0f );
// 				glVertex3f( x, y, z );
// 				
// 				//glNormal3f( 0.0f, 0.0f, 1.0f );
// 				glTexCoord2f( 1.0f, 0.0f );
// 				glVertex3f( x2, y, z );
// 				
// 				//glNormal3f( 0.0f, 0.0f, 1.0f );
// 				glTexCoord2f( 1.0f, 1.0f );
// 				glVertex3f( x2, y2, z );
// 				
// 				//glNormal3f( 0.0f, 0.0f, 1.0f );
// 				glTexCoord2f( 0.0f, 1.0f );
// 				glVertex3f( x, y2, z );
				
				
			glEnd();
			
			endTexture();
			
			
			
			//Outlines:
			
			if( isOutline == true )
			{
				glColor4f(r*0.5f, g*0.5f, b*0.5f, a);
				glBegin(GL_LINE_STRIP);
				//glBegin(GL_POINTS);
				
					//float step = what_pi / 8.0f;
					
				if( isTop == true )
				{
					for( float a = 0.0f; a <= what_pi; a += step )
					{
						glVertex3f( posx2 - cos(a) * cir_wid, posy2 - sin(a) * cir_hei, iz );
					}
				}
				else
				{
					for( float a = 0.0f; a <= what_pi; a += step )
					{
						glVertex3f( posx2 - cos(a) * cir_wid, posy1 + sin(a) * cir_hei, iz );
					}
				}
				
				glEnd();
			}
			
			if( isOutline == true )
			{
				glColor4f(r*0.5f, g*0.5f, b*0.5f, a);
				glBegin(GL_LINE_STRIP);
				//glBegin(GL_POINTS);
				
					//float step = what_pi / 8.0f;
					
				if( isTop == true )
				{
					for( float a = 0.0f; a <= what_pi; a += step )
					{
						glVertex3f( posx4 + cos(a) * cir_wid, posy4 - sin(a) * cir_hei, iz );
					}
				}
				else
				{
					for( float a = 0.0f; a <= what_pi; a += step )
					{
						glVertex3f( posx4 + cos(a) * cir_wid, posy3 + sin(a) * cir_hei, iz );
					}
				}
				
				glEnd();
			}
			
			float outx1;
			float outx2;
			float outx3;
			float outx4;
			
			if( isTop == true )
			{
				outx1 = ix1 + h;
				outx2 = ix2 - h;
				outx3 = ix1;
				outx4 = ix2;
			}
			else
			{
				outx1 = ix1;
				outx2 = ix2;
				outx3 = ix1 + h;
				outx4 = ix2 - h;
			}
			
			//Outline:
			if( isOutline == true )
			{
				glColor4f(r*0.5f, g*0.5f, b*0.5f, a);
				
				//glBegin(GL_LINE_STRIP);
				glBegin(GL_LINES);
					glNormal3f( 0.0f, 0.0f, 1.0f );
					glVertex3f( outx1, iy1, iz );
					glVertex3f( outx2, iy1, iz );
					
					glVertex3f( outx3, iy2, iz );
					glVertex3f( outx4, iy2, iz );
				glEnd();
			}
			
			
			
// 			glBegin(GL_LINES);
// 				glNormal3f( 0.0f, 0.0f, 1.0f );
// 				//glTexCoord2f( 0.0f, 0.0f );
// 				glVertex3f( x, y, z );
// 				glVertex3f( x2, y2, z );
// 				glVertex3f( x, y2, z );
// 			glEnd();
// 			
			
			applyClipping();
				renderChildren(draw);
			endClipping();
			
		glPopMatrix();
		
		
	}
*/	
	
}


	//FBOS are not used anymore.
	
		//Currently fullscreen FBO's are used for windows containers,
		//so the GPU can't handle more than about 15 windows
		//on a i945GM. Better GPU's will propably handle more,
		//but the solution would be to either resize the FBO's
		//on demand, or limit the amount of windows that can
		//be on the screen at the same time. Possibly both.
		
enum WindowState
{
	NORMAL,
	MAXIMIZED,
	MINIMIZED,
	SHADED
}

//char[] set_buttons = "cxns" : c = Close, a = maXimize, n = miNimize, s = Settings.
struct WindowButtonType
{
	static char[] NONE() { return ""; }
	static char[] DEFAULTS() { return "cx"; }
	static char[] DEFAULTS2() { return "cxs"; }
	static char[] CLOSE() { return "c"; }
	static char[] MINIMIZE() { return "n"; }
	static char[] MAXIMIZE() { return "x"; }
	static char[] SETTINGS() { return "s"; }	
}


class PlainWindow : Widget
{
	float xPosMem;
	float yPosMem;
	float wMem;
	float hMem;
	
	bool isClosingHides = true;//default
	
	void close()
	{
		if( isClosingHides == true )
		{
			controlWidget.hide();
			//aAnim( 0.0f, &controlWidget.hide );
			return;
		}
		//else really close the window by removing it.
	
		//Trace.formatln("Close.");
		if( controlWidget !is null )// && controlWidget.parent !is null)
		{
			//Trace.formatln("controlWidget name: {}", controlWidget.name );
			//Trace.formatln("controlWidget.panret name: {}", controlWidget.parent.name );
			//controlWidget.parent.remove(controlWidget);
			
			//controlWidget.
			//super.
			//container.aAnim( 0.0f, &controlWidget.removeFromParent );
			
			controlWidget.removeFromParent();
		}
	}
	
	void maximize()
	{
		if( windowState == WindowState.MAXIMIZED )
			windowState = WindowState.NORMAL;
		else
			windowState = WindowState.MAXIMIZED;
	}
	
	public WindowState windowState(WindowState set)
	{
		if( m_windowState == WindowState.NORMAL && set == WindowState.MAXIMIZED )
		{
			//If there's already some animation running, we don't propably
			//want to maximize it... This might have to be reviewed...
			//If a widget doesn't have a parent we can't maximize it.
			if( controlWidget.hasAnimators == true || controlWidget.parent is null )
			{
				return WindowState.NORMAL;
			}
			xPosMem = controlWidget.xPos;//This mem should actually be in Sides widget -> controlWidget...
			yPosMem = controlWidget.yPos;
			wMem = controlWidget.w;
			hMem = controlWidget.h;
			
			controlWidget.sendToTop();
			
			//Trace.formatln("Adding maximize animations.");
			
			//The simplified API:
			controlWidget.parent.maximizeChild( controlWidget );
			//////////controlWidget.moveToAnim(0.0f, 0.0f, 0.0f);
			//////////controlWidget.sizeAnim( controlWidget.parent.w, controlWidget.parent.h );
			
			//The more detailed API: BROKEN... needs Rectangle.add(Animator).
			/*
			Animator to_anim = new Animator(controlWidget, &controlWidget.xPos, &controlWidget.xPos, &controlWidget.yPos, &controlWidget.yPos, null, null );
			to_anim.animateTo( 0.0f, 0.0f, 0.0f );
			
			Animator wh_anim = new Animator(controlWidget, &controlWidget.w, &controlWidget.w, &controlWidget.h, &controlWidget.h, null, null );
			wh_anim.animateTo( controlWidget.parent.w, controlWidget.parent.h, 0.0f );
			*/
			
			/*
			controlWidget.xPos = 0.0f;
			controlWidget.yPos = 0.0f;
			controlWidget.w = controlWidget.parent.w;
			controlWidget.h = controlWidget.parent.h;
			*/
		}
		else if( m_windowState == WindowState.MAXIMIZED && set == WindowState.NORMAL )
		{
			if( controlWidget.hasAnimators == true )
			{
				return WindowState.MAXIMIZED;
			}
			
			Animator to_anim = new Animator(controlWidget, &controlWidget.xPos, &controlWidget.xPos, &controlWidget.yPos, &controlWidget.yPos, null, null );
			to_anim.animateTo( xPosMem, yPosMem, 0.0f );
			controlWidget.add(to_anim);
			
			Animator wh_anim = new Animator(controlWidget, &controlWidget.w, &controlWidget.w, &controlWidget.h, &controlWidget.h, null, null );
			wh_anim.animateTo( wMem, hMem, 0.0f );
			controlWidget.add(wh_anim);
			/*
			controlWidget.xPos = xPosMem;
			controlWidget.yPos = yPosMem;
			controlWidget.w = wMem;
			controlWidget.h = hMem;
			*/
		}
		
		m_windowState = set;
		return m_windowState;
	}
	public WindowState windowState() { return m_windowState; }
	protected WindowState m_windowState;
	
	//char[] set_buttons = "" : default
	//char[] set_buttons = "cxns" : c = Close, n = miNimize, a = maXimize, s = Settings.
	
	this( dchar[] set_name, char[] set_buttons = WindowButtonType.DEFAULTS, WindowHeaderType set_top_header_type = WindowHeaderType.NORMAL, WindowHeaderType set_bottom_header_type = WindowHeaderType.NORMAL, bool set_is_frontside = true, bool use_fbo_clipping = true )
	{
		debug(SubWindow) Trace.formatln("PlainWindow.this() START. {}", set_name );
		debug(SubWindow) scope(exit) Trace.formatln("PlainWindow.this() END. {}", set_name );
		
		
		super();
		
		debug(SubWindow) Trace.formatln("PlainWindow.this() After super().");
		
		type = "PlainWindow";
		name = set_name;
		isFrontSide = set_is_frontside;
		
		if( set_bottom_header_type == WindowHeaderType.NONE )//&& set_top_header_type == WindowHeaderType.NONE )
		{
			//We only evaluate bottomheader for the shadow roundness, for now.
			//Because we only have round or square from both ends shadows.
			//And because the bottom is where the shadow is shown most.
			//shadowType = ShadowType.SQUARE;
			shadowType = ShadowType.ROUND;
		}
		else
		{
			shadowType = ShadowType.ROUND;
		}
		
		
		/*
		if( g_rae.getValueFromTheme("Rae.SubWindow.isDrawContainer") == false )
		{
			
		}*/
		
		//renderMethod = renderMethod.BYPASS;//We can't use this because we want to render the shadow anyway.
		
		
		//g_rae.registerWindow(this);
		
		//colour( 0.2f, 0.3f, 0.2f, 1.0f );
		//colour( 0.18f, 0.18f, 0.18f, 1.0f );
		//Widget.colour( 1.0f, 1.0f, 1.0f, 1.0f );
		
		//---
		float header_default_height = 0.025f;
		float small_font_size = g_rae.getValueFromTheme("Rae.Font.small");
		
		if( set_top_header_type != WindowHeaderType.NONE )
		{
			topHeader = new WindowHeader(name, set_top_header_type, true );
			
			if( set_top_header_type == WindowHeaderType.NORMAL )
			{
				header_default_height = g_rae.getValueFromTheme("Rae.WindowHeader.NORMAL.defaultHeight");
			}
			else if ( set_top_header_type == WindowHeaderType.SMALL )
			{
				header_default_height = g_rae.getValueFromTheme("Rae.WindowHeader.SMALL.defaultHeight");
			}
			
			//This will make topHeader to be drawn on top of other stuff.
			topHeader.layer = 4900;
			
			
			/*
			//topHeader.texture = Image.createTopHeader();
			//topHeader.set( 0.0, -h/2.0, w, 0.1 );
			//topHeader.defaultHeight = 0.1f;
			topHeader.defaultHeight = 0.03f;
			topHeader.maxHeight = 0.03f;
			topHeader.padding = 0.0f;
			//topHeader.colour(0.1,0.1,0.1,1.0);
			topHeader.label.colour(1.0, 1.0, 1.0, 1.0);
			topHeader.xPackOptions = PackOptions.EXPAND;
			topHeader.yPackOptions = PackOptions.SHRINK;
			*/
			super.add(topHeader);
			
			
			if( Util.containsPattern( set_buttons, WindowButtonType.MINIMIZE ) )
			{
				minimizeButton = new CircleButton("");
			//minimizeButton.maxWidth = 24.0f * g_rae.pixel();
			//minimizeButton.maxHeight = 24.0f * g_rae.pixel();
			//minimizeButton.maxWidth = 0.025f;
			//minimizeButton.maxHeight = 0.025f;//Symmetrical option TODO.
			//minimizeButton.xPackOptions = PackOptions.SHRINK;
			//minimizeButton.yPackOptions = PackOptions.SHRINK;
				//minimizeButton.hide();//until we figure what to do with it.
				topHeader.prepend(minimizeButton);
			
				Separator separator1 = new Separator(header_default_height*0.2f, header_default_height);
				topHeader.prepend(separator1);
			}
			
			if( Util.containsPattern( set_buttons, WindowButtonType.MAXIMIZE ) )
			{
				maximizeButton = new CircleButton("");
			//maximizeButton.maxWidth = 0.025f;
			//maximizeButton.maxHeight = 0.025f;
			//maximizeButton.xPackOptions = PackOptions.SHRINK;
			//maximizeButton.yPackOptions = PackOptions.SHRINK;
				maximizeButton.texture = g_rae.getTextureFromTheme("Rae.Button.maximize");
				maximizeButton.signalActivate.attach(&maximize);
				topHeader.prepend(maximizeButton);
			
				Separator separator2 = new Separator(header_default_height*0.2f, header_default_height);
				topHeader.prepend(separator2);
			}
			
			if( Util.containsPattern( set_buttons, WindowButtonType.CLOSE ) )
			{
				closeButton = new CircleButton("");
			//closeButton = new CircleButton("x");
			//closeButton = new CircleButton("<span font_desc=\"" ~ Float.toString32(small_font_size) ~ "\">x</span>");//" Crappy syntax highlighting...
				closeButton.signalActivate.attach(&close);
			//closeButton.maxWidth = 0.025f;
			//closeButton.maxHeight = 0.025f;
			//closeButton.xPackOptions = PackOptions.SHRINK;
			//closeButton.yPackOptions = PackOptions.SHRINK;
				closeButton.texture = g_rae.getTextureFromTheme("Rae.Button.close");
				topHeader.prepend(closeButton);
			}
			
			/*
			leftSeparator = new Rectangle();
			leftSeparator.name = "leftSeparator";//TEMP
			//leftSeparator.maxWidth = 0.012f;
			leftSeparator.defaultWidth = header_default_height;//0.025f;
			leftSeparator.maxWidth = header_default_height;//0.025f;
			//leftSeparator.maxHeight = 0.025f;
			leftSeparator.xPackOptions = PackOptions.SHRINK;
			leftSeparator.yPackOptions = PackOptions.SHRINK;
			leftSeparator.colour(1.0f, 1.0f, 1.0f, 0.0f);//transparent!
			leftSeparator.isOutline = false;
			*/
			leftSeparator = new Separator(header_default_height, header_default_height);
			topHeader.prepend(leftSeparator);
			
			
			//---
			
			
			
			topHeader.signalMouseButtonPress.attach(&headerHandler);
			topHeader.signalMouseButtonRelease.attach(&headerHandler);
			topHeader.signalMouseMotion.attach(&headerHandler);
			//topHeader.signalEnterNotify.attach(&headerHandler);
			//topHeader.signalLeaveNotify.attach(&headerHandler);
		}//if has_topheader
			
		//---
		
		container = new Rectangle();
		
		//TODO make container into a Container class
		//which has this automatically set:
		container.verticalScrollbarSetting = ScrollbarSetting.AUTO;
		container.horizontalScrollbarSetting = ScrollbarSetting.AUTO;
		
		container.name = "Container";
		container.xPackOptions = PackOptions.EXPAND;
		container.yPackOptions = PackOptions.EXPAND;
		container.outPaddingX = 0.0f;
		container.outPaddingY = 0.0f;
		container.inPaddingX = 0.0f;
		container.inPaddingY = 0.0f;
		//container.renderMethod = renderMethod.BYPASS;//We dont' want to render this.
		//container.isClipping = true;
		//container.colour(0.18f, 0.18f, 0.18f, 1.0f);
		container.colour = g_rae.getColourArrayFromTheme("Rae.SubWindow.background");
		
		//debug(SubWindow) Trace.formatln("PlainWindow.this() .");
		debug(SubWindow) Trace.formatln("PlainWindow.this() After setting the container colour to SubWindow.background.");
		
		super.add(container);
		
		debug(SubWindow) Trace.formatln("PlainWindow.this() After adding the container.");
		
		//---
		
		if( set_bottom_header_type != WindowHeaderType.NONE )
		{
			debug(SubWindow) Trace.formatln("PlainWindow.this() Creating bottomHeader.");
		
			bottomHeader = new WindowHeader(name, set_bottom_header_type, false);
			
			bottomHeader.layer = 4900;
			
			/*
			//bottomHeader.set( 0.0, h/2.0, w, 0.1 );
			//bottomHeader.defaultHeight = 0.1f;
			bottomHeader.defaultHeight = 0.03f;
			bottomHeader.maxHeight = 0.03f;
			bottomHeader.padding = 0.0f;
			//bottomHeader.colour(0.1f, 0.1f, 0.1f, 1.0f);
			bottomHeader.label.colour(1.0f, 1.0f, 1.0f, 1.0f);
			bottomHeader.packOptions( PackOptions.EXPAND, PackOptions.SHRINK );
			*/
			super.add(bottomHeader);
			
			resizeButton = new ResizeButton("");
			//resizeButton.maxWidth = 0.025f;
			//resizeButton.maxHeight = 0.025f;//Symmetrical option TODO.
			//resizeButton.defaultSize( 0.03f, 0.03f );
			if( set_bottom_header_type == WindowHeaderType.NORMAL )
			{
				resizeButton.defaultHeight = g_rae.getValueFromTheme("Rae.WindowHeader.NORMAL.defaultHeight");
				resizeButton.defaultWidth = g_rae.getValueFromTheme("Rae.WindowHeader.NORMAL.defaultHeight");
			}
			else if ( set_bottom_header_type == WindowHeaderType.SMALL )
			{
				resizeButton.defaultHeight = g_rae.getValueFromTheme("Rae.WindowHeader.SMALL.defaultHeight");
				resizeButton.defaultWidth = g_rae.getValueFromTheme("Rae.WindowHeader.SMALL.defaultHeight");
			}
			resizeButton.xPackOptions = PackOptions.SHRINK;
			resizeButton.yPackOptions = PackOptions.SHRINK;
			bottomHeader.add(resizeButton);
			resizeButton.signalMouseButtonPress.attach(&resizeHandler);
			resizeButton.signalMouseButtonRelease.attach(&resizeHandler);
			resizeButton.signalMouseMotion.attach(&resizeHandler);
			
			bottomHeader.signalMouseButtonPress.attach(&headerHandler);
			bottomHeader.signalMouseButtonRelease.attach(&headerHandler);
			bottomHeader.signalMouseMotion.attach(&headerHandler);
			//bottomHeader.signalEnterNotify.attach(&headerHandler);
			//bottomHeader.signalLeaveNotify.attach(&headerHandler);
		}//if has_bottomheader

		//signalEnterNotify.attach(&windowHandler);
		//signalLeaveNotify.attach(&windowHandler);

		debug(SubWindow) Trace.formatln("PlainWindow.this() Setting followAlpha.");

		//This will make the child widgets of this window to follow the alpha
		//value of this window.
		setFollowAlpha( true );

		if( use_fbo_clipping == true && GLExtensions.checkExtension("GL_EXT_framebuffer_object") && g_rae.allowFBO == true )
		{
			container.isFBO = true;
		}
	}
	
	
	void renderBody( Draw draw )
	{
		//We use this override instead of renderMethod.BYPASS,
		//because otherwise the shadow wouldn't be shown.
	}
	
	
	override void add( Rectangle a_widget )
	{
		container.add( a_widget );
	}
	
	override void append( Rectangle a_widget )
	{
		container.append( a_widget );
	}
	
	override void prepend( Rectangle a_widget )
	{
		container.prepend( a_widget );
	}
	
	override void remove( Rectangle a_widget )
	{
		container.remove( a_widget );
	}
	
	override void clear()
	{
		container.clear();
	}
	
	/*
	
	//FIXME Defining these will segfault. Why?
	
	void append( Rectangle a_widget )
	{
		container.append( a_widget );
	}
	
	void prepend( Rectangle a_widget )
	{
		container.prepend( a_widget );
	}
	
	*/
	
	/*
	void windowHandler( InputState input, Rectangle wid )
	{
		input.isHandled = true;
	
		switch( input.eventType )
		{
			default:
			break;
			case SEventType.ENTER_NOTIFY:
				//wid.colour( 0.9f, 0.6f, 0.4f, 0.7f );
				prelight();
				//wid.
				
				//sendToTop();
				
				//if( hasAnimators == false )
				//{
				//	addDefaultAnimator( DefaultAnimator.RAISE );
				//}
			break;
			case SEventType.LEAVE_NOTIFY:
				unprelight();
				//wid.colour( 0.8f, 0.3f, 0.2f, 1.0f );
				//if( wid.hasAnimators == false )
				//{
					//addDefaultAnimator( DefaultAnimator.LOWER );
				//}
			break;
		}
	}
	*/
	
	void headerHandler( InputState input, Rectangle wid )
	{
		/*Rectangle controlWidget;
		//Trace.formatln( parent.classinfo.name );
		if( parent !is null && parent.classinfo.name == "rae.ui.SubWindow.SubWindow" )
		{
			controlWidget = parent;
		}
		else
		{
			controlWidget = this;
		}*/
	
		switch( input.eventType )
		{
			default:
			break;
			case SEventType.ENTER_NOTIFY:
				input.isHandled = true;
				wid.prelight();
			break;
			case SEventType.LEAVE_NOTIFY:
				input.isHandled = true;
				wid.unprelight();
			break;
			case SEventType.MOUSE_BUTTON_PRESS:
				if( input.mouse.button[MouseButton.LEFT] == true )
				{
					input.isHandled = true;
					wid.grabInput();
					controlWidget.sendToTop();
				}
			break;
			case SEventType.MOUSE_BUTTON_RELEASE:
				if( input.mouse.eventButton == MouseButton.LEFT )
				{
					input.isHandled = true;
					wid.ungrabInput();
				}
			break;
		}
	
		if( input.mouse.button[MouseButton.LEFT] == true )
		{
			input.isHandled = true;//This is wrong.
			
			//myWindow4.moveTo( input.mouse.x, input.mouse.y );
			//controlWidget.move( input.mouse.xRel, input.mouse.yRel );
			//Trace.formatln( "xrel: {} yrel: {}", input.mouse.xRel, input.mouse.yRel );
			
			if( controlWidget.parent !is null )
				controlWidget.move( controlWidget.parent.tr_wc2i( input.mouse.xRel ), controlWidget.parent.tr_hc2i( input.mouse.yRel ) );
		}
	}
	
	
	//internal:
	//This is a way to use the Sides Widget
	//from inside the PlainWindow. This has to be done
	//because a side widget has two sides, two PlainWindows.
	//So we want to be able to control them both from one
	//PlainWindow.
	protected Rectangle controlWidget()
	{
		//Trace.formatln( parent.classinfo.name );
		
		//Well, using classinfo.name means that we can't derive from SubWindow,
		//as deriving from a class also changes it's classinfo.name.
		//So this following line is not an option here:
		//if( parent !is null && parent.classinfo.name == "rae.ui.SubWindow.SubWindow" )
		
		//instead of that, I made m_controlWidget, which
		//is protected so you can't set it. SubWindow will set it to
		//point to itself,
		//and so all is well.
		
		if( m_controlWidget !is null )
		{
			return m_controlWidget;
		}
		else
		{
			return this;
		}
	}
	//internal:
	public void controlWidget( Rectangle set )
	{
		m_controlWidget = set;
	}
	protected Rectangle m_controlWidget;
	
	void resizeHandler( InputState input, Rectangle wid )
	{
		//input.isHandled = true;
	
		/*Rectangle controlWidget;
		//Trace.formatln( parent.classinfo.name );
		if( parent !is null && parent.classinfo.name == "rae.ui.SubWindow.SubWindow" )
		{
			controlWidget = parent;
		}
		else
		{
			controlWidget = this;
		}*/
	
		switch( input.eventType )
		{
			default:
			break;
			case SEventType.ENTER_NOTIFY:
				input.isHandled = true;
				//wid.colour( 0.9f, 0.6f, 0.4f, 0.7f );
				wid.prelight();
			break;
			case SEventType.LEAVE_NOTIFY:
				input.isHandled = true;
				wid.unprelight();
			break;
			case SEventType.MOUSE_BUTTON_PRESS:
				input.isHandled = true;
				//Trace.formatln("press.");
				wid.grabInput();
				//sendToTop();
			break;
			case SEventType.MOUSE_BUTTON_RELEASE:
				input.isHandled = true;
				//Trace.formatln("release.");
				wid.ungrabInput();
			break;
		}
	
		if( input.mouse.button[MouseButton.LEFT] == true )
		{
			input.isHandled = true;//This is wrong.
			
			if( controlWidget.parent !is null )
			{
				controlWidget.x2N = controlWidget.x2 + controlWidget.parent.tr_wc2i( input.mouse.xRel );
				controlWidget.y2 = controlWidget.y2 + controlWidget.parent.tr_hc2i( input.mouse.yRel );
			}
			else
			{
				controlWidget.x2N = controlWidget.x2 + input.mouse.xRel;
				controlWidget.y2 = controlWidget.y2 + input.mouse.yRel;
			}
			//myWindow4.moveTo( input.mouse.x, input.mouse.y );
			//move( input.mouse.xRel, input.mouse.yRel );
			//Trace.formatln( "xrel: {} yrel: {}", input.mouse.xRel, input.mouse.yRel );
		}
	}
	
	void flipButtonHandler()
	{
		if( hasAnimators == false )
		{
			/*Rectangle controlWidget;
			//Trace.formatln( parent.classinfo.name );
			if( parent !is null && parent.classinfo.name == "rae.ui.SubWindow.SubWindow" )
			{
				controlWidget = parent;
			}
			else
			{
				controlWidget = this;
			}*/
		
			//TODO Should be 180 degree flip, but we'll have 360
			//until Beziers and Animators are fixed.
			
			//This is a temp way to get it to make a full rotation from
			//the backside of a Sides window. This should propably be 
			//fixed with a way to make animations relative to the
			//current rotation value, instead of the animation setting
			//absolute values.
			if( controlWidget.hasAnimators == false )
			{
				if( isFrontSide == true )
					controlWidget.addDefaultAnimator( DefaultAnimator.ROTATE_180 );
				else controlWidget.addDefaultAnimator( DefaultAnimator.ROTATE_180_TO_360 );
				//addDefaultAnimator( DefaultAnimator.ROTATE_360 );
			}
		}
	}
	
	/*
	void renderChildren()
	{
		super.renderChildren();
		topHeader.render();
		bottomHeader.render();
	}
	*/
	
	/*
	protected void arrange()
	{
		super.arrange();
		
		//if( container !is null )
			//container.sendToBottom();
		
		//topHeader.wx = w;
		//bottomHeader.wx = w;
		//topHeader.set( 0.0, -h/2.0, w, 0.1 );
		//bottomHeader.set( 0.0, h/2.0, w, 0.1 );
	}
	*/
	
	
	bool isDoubleSided() { return m_isDoubleSided; }
	bool isDoubleSided(bool set)
	{
		if( container !is null )
			container.isDoubleSided(set);
		return m_isDoubleSided = set;
	}
	
	//Colour is overridden to control container widget.
	//float r() { return ((container is null) ? _colour_data[0] : container.r); }
	//float g() { return ((container is null) ? _colour_data[1] : container.g); }
	//float b() { return ((container is null) ? _colour_data[2] : container.b); }
	/*
	float a()
	{
		if( container !is null )
			return container.a();
		//else
			return super.a();
		//return ((container is null) ? _colour_data[3] : container.a);
	}
	
	//float r( float set ) { return ((container is null) ? (_colour_data[0] = set) : (container.r = set)); }
	//float g( float set ) { return ((container is null) ? (_colour_data[1] = set) : (container.g = set)); }
	//float b( float set ) { return ((container is null) ? (_colour_data[2] = set) : (container.b = set)); }
	float a( float set )
	{
		if( container !is null )
			container.a(set);
		//invalidate();
		return super.a(set);
		//return ((container is null) ? (_colour_data[3] = set) : (container.a = set));
	}
	*/
	
	
	//br stands for "background red". So these are background colours,
	//or container background colours.
	float br() { return ((container is null) ? _colour_data[0] : container.r); }
	float bg() { return ((container is null) ? _colour_data[1] : container.g); }
	float bb() { return ((container is null) ? _colour_data[2] : container.b); }
	float ba() { return ((container is null) ? _colour_data[3] : container.a); }
	
	void br( float set ) { ((container is null) ? (_colour_data[0] = set) : (container.r = set)); }
	void bg( float set ) { ((container is null) ? (_colour_data[1] = set) : (container.g = set)); }
	void bb( float set ) { ((container is null) ? (_colour_data[2] = set) : (container.b = set)); }
	void ba( float set ) { ((container is null) ? (_colour_data[3] = set) : (container.a = set)); }
	
	void backgroundColour( float set_r, float set_g, float set_b, float set_a )
	{
		if( container !is null )
			container.colour( set_r, set_g, set_b, set_a );
		else colour( set_r, set_g, set_b, set_a );
	}
	
	void setBottomHeaderText(dchar[] set)
	{
		if( bottomHeader !is null )
			bottomHeader.name = set;
	}
	
	//class Header?
	WindowHeader topHeader;
		Separator leftSeparator;
		CircleButton closeButton;
		CircleButton maximizeButton;
		CircleButton minimizeButton;
		//---Label is here.
		CircleButton flipButton;
		Separator rightSeparator;
	Rectangle container;
	WindowHeader bottomHeader;
		ResizeButton resizeButton;

	bool isFrontSide = true;

	/*void pick()
	{
		glPushMatrix();
			glRotatef( rotate_y, 0.0f, 1.0f, 0.0f );
			m_rectangle.render();
			rotate_y += 0.1f;
		glPopMatrix();
	}*/
	

}



class Sides : public Widget
{
	this()
	{
		super();
		type = "Sides";
		name = "Sides";
		
		outPaddingX = 0.0f;
		outPaddingY = 0.0f;
		inPaddingX = 0.0f;
		inPaddingY = 0.0f;
		
		arrangeType = ArrangeType.LAYER;
		
		//sides = new LinkedList!(Rectangle);
	}
	
	/*void arrangeParent()
	{
		
	}*/
	
	void render(Draw draw)
	{
		if( isHidden == true )
			return;
	
		int whichToDraw = 0;
	
		//This is not so generic... It only works on two sided stuff:
		if( yRot >= -90.0f && yRot <= 90.0f || yRot >= 270.0f && yRot <= 450.0f )
		{
			whichToDraw = 0;
		}
		else if( yRot > 90.0f && yRot < 270.0f )
		{
			whichToDraw = 1;
		}
	
		
		angle = (360.0f / itemList.size);
		
		glPushMatrix();
		
			applyPosition();
			applyRotation();
			applyScale();
			
			uint i = 0;
			foreach( Rectangle rect; itemList )
			{
				if( i > 0 )
					glRotatef( angle, 0.0f, 1.0f, 0.0f );
				
				if( i == whichToDraw )
					rect.render(draw);
				i++;
			}
			
		glPopMatrix();
	}
	
	//synchronized 
	override bool mouseEvent( InputState input, bool dive_lower = true )//THIS , bool bypass_hittest = false )
	{
		debug(mouse) Trace.formatln("Sides.mouseEvent() START. {}", name );
		debug(mouse) scope(exit) Trace.formatln("Sides.mouseEvent() END. {}", name );
		
		
		//TODO why does this crash...?
		if( sendToTopOnMouseButtonPress == true )
		{
			//Trace.formatln("Sides.mouseEvent() this is a sendToTopOnMouseButtonPress...");
			
			if( input !is null )
			{
				switch( input.eventType )
				{
					default:
					break;
					case SEventType.MOUSE_BUTTON_PRESS:
						sendToTop();
					break;
				}
			}
			//else Trace.formatln("Sides.mouseEvent() input is null.");
		}
		
		ICanvasItem top_hit;
	
		if( yRot >= -90.0f && yRot <= 90.0f || yRot >= 270.0f && yRot <= 450.0f )
		{
			if( itemList.size > 0 )
				top_hit = itemList.head;
		}
		else if( yRot > 90.0f && yRot < 270.0f )
		{
			if( itemList.size > 1 )
				top_hit = itemList.get(1);
		}
		
		lastHitWidget = top_hit;
		
		if( top_hit !is null )
		{
			return top_hit.mouseEvent(input);
		}
		
		return false;
	}
	
	//protected 
	/*
	void arrange()
	{
	}
	*/
	/*
	void add( Rectangle a_widget )
	{
		append(a_widget);
	}
	
	void append( Rectangle a_widget )
	{
		if( a_widget.parent !is null )
			a_widget.parent.remove( a_widget );
		a_widget.parent = this;
		if( rootWindow !is null )
			a_widget.rootWindow = rootWindow;
		sides.append( a_widget );
		//a_widget.arrange();
		invalidate();
	}
	
	void prepend( Rectangle a_widget )
	{
		if( a_widget.parent !is null )
			a_widget.parent.remove( a_widget );
		a_widget.parent = this;
		if( rootWindow !is null )
			a_widget.rootWindow = rootWindow;
		sides.prepend( a_widget );
		//a_widget.arrange();
		invalidate();
	}*/
	
	float angle = 0.0f;
	
	//protected LinkedList!(Rectangle) sides;
}

class SubWindow : Sides
{
	this(dchar[] set_name, char[] set_buttons = WindowButtonType.DEFAULTS2, WindowHeaderType set_top_header_type = WindowHeaderType.NORMAL, WindowHeaderType set_bottom_header_type = WindowHeaderType.NORMAL, bool use_fbo_clipping = true )
	{
		debug(SubWindow) Trace.formatln("SubWindow.this() START. {}", set_name );
		debug(SubWindow) scope(exit) Trace.formatln("SubWindow.this() END. {}", set_name );
	
		super();
		
		type = "SubWindow";
		
		sendToTopOnMouseButtonPress = true;
		
		side1 = new PlainWindow(set_name, set_buttons, set_top_header_type, set_bottom_header_type, true, use_fbo_clipping );
		side2 = new PlainWindow(set_name ~ " Settings", set_buttons, set_top_header_type, set_bottom_header_type, false, use_fbo_clipping );//isFrontSide:false
		//side3 = new PlainWindow(set_name ~ " Testing 3");
		//side4 = new PlainWindow(set_name ~ " Testing 4");
		
		float header_default_height = 0.025f;
		float small_font_size = g_rae.getValueFromTheme("Rae.Font.small");
		if( set_top_header_type != WindowHeaderType.NONE )
		{
			if( set_top_header_type == WindowHeaderType.NORMAL )
			{
				header_default_height = g_rae.getValueFromTheme("Rae.WindowHeader.NORMAL.defaultHeight");
			}
			else if ( set_top_header_type == WindowHeaderType.SMALL )
			{
				header_default_height = g_rae.getValueFromTheme("Rae.WindowHeader.SMALL.defaultHeight");
			}
		}
	
		//Add flipbuttons:
		if( side1.topHeader !is null && Util.containsPattern( set_buttons, WindowButtonType.SETTINGS ) )
		{
			side1.flipButton = new CircleButton("<span font_desc=\"" ~ Float.toString32(small_font_size) ~ "\"><i>i</i></span>");//" Crappy syntax highlighting...
			side1.flipButton.signalActivate.attach(&side1.flipButtonHandler);
			side1.topHeader.append(side1.flipButton);
			side1.rightSeparator = new Separator(header_default_height, header_default_height);
			side1.topHeader.append(side1.rightSeparator);
		}
		
		if( side2.topHeader !is null && Util.containsPattern( set_buttons, WindowButtonType.SETTINGS ) )
		{
			side2.flipButton = new CircleButton("<span font_desc=\"" ~ Float.toString32(small_font_size) ~ "\"><i>i</i></span>");//" Crappy syntax highlighting...
			side2.flipButton.signalActivate.attach(&side2.flipButtonHandler);
			side2.topHeader.append(side2.flipButton);
			side2.rightSeparator = new Separator(header_default_height, header_default_height);
			side2.topHeader.append(side2.rightSeparator);
		}
		
		//Set the controlWidget hack, so they both get
		//resized at the same time, and also our Sides widget
		//will get resized.
		side1.controlWidget = this;
		side2.controlWidget = this;
		
		side1.xPackOptions = PackOptions.EXPAND;
		side1.yPackOptions = PackOptions.EXPAND;
		
		Sides.append(side1);
		Sides.append(side2);
		//Sides.append(side3);
		//Sides.append(side4);
		
		//This will make the child widgets of this window to follow the alpha
		//value of this window.
		setFollowAlpha( true );
	}

	void isClosingHides(bool set)
	{
		if( side1 !is null ) side1.isClosingHides = set;
		if( side2 !is null ) side2.isClosingHides = set;
	}

	void maximize()
	{
		if( side1 !is null ) side1.maximize;
		if( side2 !is null ) side2.maximize;
	}

	//NOT USED ATM:
	public bool isClipByParent() { return m_isClipByParent; }
	public bool isClipByParent(bool set)
	{
		if( side1 !is null ) side1.isClipByParent = set;
		if( side2 !is null ) side2.isClipByParent = set;
		return m_isClipByParent = set;
	}

	void add( Rectangle a_widget )
	{
		side1.append( a_widget );
	}

	void append( Rectangle a_widget )
	{
		side1.append( a_widget );
	}
	
	void prepend( Rectangle a_widget )
	{
		side1.prepend( a_widget );
	}
	
	void add2( Rectangle a_widget )
	{
		side2.append( a_widget );
	}

	void append2( Rectangle a_widget )
	{
		side2.append( a_widget );
	}
	
	void prepend2( Rectangle a_widget )
	{
		side2.prepend( a_widget );
	}

	void clear()
	{
		side1.clear();
	}
	
	void clear2()
	{
		side2.clear();
	}

	public ShadowType shadowType(ShadowType set)
	{
		side2.shadowType = set;
		return side1.shadowType = set;
	}
	public ShadowType shadowType() { return side1.shadowType; }

	PlainWindow side1;
	PlainWindow side2;
	//PlainWindow side3;
	//PlainWindow side4;

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
