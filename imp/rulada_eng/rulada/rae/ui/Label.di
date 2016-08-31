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

module rae.ui.Label;

import tango.util.log.Trace;//Thread safe console output.

//import tango.util.container.LinkedList;
//import tango.core.Signal;
//import Float = tango.text.convert.Float;

import rae.core.globals;
import rae.core.IRaeMain;
import rae.ui.InputState;
import rae.ui.Widget;
import rae.canvas.Rectangle;
import rae.canvas.Draw;
import rae.canvas.Image;

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

public import rae.gl.gl;
public import rae.gl.glu;
public import rae.gl.glext;

class Label : Widget
{
public:
	this( dchar[] set_label, float set_font_size = -1.0f )
	{
		super();
		
		type = "Label";
		name = set_label;
		
		renderMethod = RenderMethod.PIXELS;
		
		//rectangle.
		super.colour(1.0f, 1.0f, 1.0f, 1.0f);
		//super.colour(0.0f, 0.0f, 0.0f, 1.0f);
		//rectangle.
		//set( 0.0f, 0.0f, 0.6f, 0.2f );
		
		m_textColourData[0] = 0.0f;
		m_textColourData[1] = 0.0f;
		m_textColourData[2] = 0.0f;
		m_textColourData[3] = 1.0f;
		
		if( set_font_size == -1.0f )
			m_fontSize = g_rae.getValueFromTheme("Rae.Font.normal");
		else m_fontSize = set_font_size;
		
		textColour = g_rae.getColourArrayFromTheme("Rae.Text");
		
		//isWhite = g_rae.getBoolFromTheme("Rae.Text.isWhite");
		
		//Setting the textColour will also call the following:
		//texture = Image.createFromText( name, m_textColourData, textWidth, textHeight );
		//Image gives the text size in pixels, we'll have to convert them to
		//Height Coordinates.
		//textWidth = textWidth * pixel;
		//textHeight = textHeight * pixel;
		
		xPackOptions = PackOptions.SHRINK;
		yPackOptions = PackOptions.SHRINK;
		
		defaultWidth = textWidth;
		defaultHeight = textHeight;
		
		debug(Label) Trace.formatln("textWidth: {}", cast(double) textWidth );
		debug(Label) Trace.formatln("textHeight: {}", cast(double) textHeight );
		
		outPaddingX = 0.005f;
		outPaddingY = 0.005f;
		inPaddingX = 0.0f;
		inPaddingY = 0.0f;
		
		/*
		maxHeight = 0.03f;
		maxWidth = 0.16f;
		minHeight = 0.03f;
		minWidth = 0.16f;
		*/
		
		
	}
	
	dchar[] name()
	{
		return super.name();
	}
	
	void name(dchar[] set)
	{
		super.name(set);
		updateText();
		//return m_name;
	}
	
	public dchar[] text(){ return super.name; }
	dchar[] text(dchar[] set)
	{
		super.name(set);
		updateText();
		return m_name;
	}
	
	version(zoomCairo)
	{
		protected void updateThemeTexture()
		{
			super.updateThemeTexture();
			updateText();
		}
	}
	
	void updateText()
	{
		debug(Label) Trace.formatln("Label.updateText() START.");
		debug(Label) scope(exit) Trace.formatln("Label.updateText() END.");
	
		if( texture is null )
		{
			texture = Image.createFromText( name, m_textColourData, alignType, fontSize, zoomParent, textWidth, textHeight );
		}
		else
		{
			texture.showText( name, m_textColourData, alignType, fontSize, zoomParent, textWidth, textHeight );
		}
		
		//Image gives the text size in pixels, we'll have to convert them to
		//Height Coordinates.
		textWidth = textWidth * pixel;
		textHeight = textHeight * pixel;
		
		invalidate();
	}
	
	float textWidth = 0.0f;
	float textHeight = 0.0f;
	
	/+public Widget root(Widget set)///Don't use this yourself.
	{
		super.root(set);
		//root.onHeightChangedSignal... attach this to it...
		/*WHAT maxHeight = 24.0 / root.h;
		maxWidth = 128.0 / root.h;
		minHeight = 24.0 / root.h;
		minWidth = 128.0 / root.h;*/
		maxHeight = 24.0 / set.h;
		maxWidth = 128.0 / set.h;
		minHeight = 24.0 / set.h;
		minWidth = 128.0 / set.h;
		return m_root;
	}+/
	
	/*
	void setScalingMode(bool set_nearest)
	{
		if( set_nearest == true )
		{
			//nearest = false;
			glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
			glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			
		}
		else
		{
			//nearest = true;
			glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
			glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		}
	}
	*/

	/*REMOVE
	void render(Draw draw)
	{
		//TODO Naturally we'd want to get rid of these hardcoded sizes...
		//renderPixelPerPixel( draw, 128.0f, 128.0f );
		renderPixelPerPixel( draw, texture.width, texture.height );
		
	}
	*/
		
	override void renderPixelPerPixel( Draw draw, float hard_tex_width, float hard_tex_height )
	{
		debug(PlainRectangle) Trace.formatln("Rectangle.renderPixelPerPixel() START. name: {}", fullName() );
		debug(PlainRectangle) scope(exit) Trace.formatln("Rectangle.renderPixelPerPixel() END. name: {}", fullName() );
	
		beginRender(draw);
		
			//draw.pushTexture( texture );
				//These should be handled by the Shape:
				//draw.colour();
				//draw.gradient( gradient );
				
				//TODO
				//glColor4f(r, g, b, a);
				applyColour();
 
 			
			//float hard_tex_width = 128.0f;
			//float hard_tex_height = 64.0f;
				
				//Normally: shape.bounds(ix1, iy1, ix2, iy2, iz);
			
			/+
			//version bounds:
			
				switch( alignType )
				{
					default:
					case AlignType.CENTER:
					case AlignType.TOP:
					case AlignType.BOTTOM:
						shape.bounds(
							draw,
						//draw.bounds( shape,
							//roundToPixels( 
							icx - (pixel*hard_tex_width*0.5f), 
							//roundToPixels( 
							icy - (pixel*hard_tex_height*0.5f),
							//roundToPixels( 
							icx + (pixel*hard_tex_width*0.5f),
							//roundToPixels( 
							icy + (pixel*hard_tex_height*0.5f),
							iz);
						
					break;
					case AlignType.BEGIN:
						shape.bounds(
							draw,
						//draw.bounds( shape,
							//roundToPixels( 
							ix1, 
							//roundToPixels( 
							icy - (pixel*hard_tex_height*0.5f),
							//roundToPixels( 
							ix1 + (pixel*hard_tex_width),
							//roundToPixels( 
							icy + (pixel*hard_tex_height*0.5f),
							iz);
						//draw.bounds( shape, ix1, iy1, ix2, iy2, iz );
					break;
				}
				
				shape.fill();
				//draw.fill( shape );
			+/
			
			//version renderPixels:
			
			//shape.renderPixels( draw, renderMethod, icx, icy, ix1, iy1, ix2, iy2, iz );
			
			//This one is overridden in Label, because text textures are a bit messy
			//and they tend to grow big and get aligned funnily otherwise:
			
			switch( alignType )
				{
					default:
					case AlignType.CENTER:
					case AlignType.TOP:
					case AlignType.BOTTOM:
						shape.renderPixels( draw, renderMethod, icx, icy, ix1, iy1, ix2, iy2, iz );
					break;
					//case AlignType.END:
					case AlignType.BEGIN:
						shape.renderPixels( draw, renderMethod, ix1 + (g_rae.pixel*texture.width*0.5f), icy, ix1, iy1, ix2, iy2, iz );// - (texture.height*0.5f) );
						//shape.renderPixels(draw, icx, icy, iz);	
					break;
					case AlignType.END:
						shape.renderPixels( draw, renderMethod, ix2 - (g_rae.pixel*texture.width*0.5f), icy, ix1, iy1, ix2, iy2, iz );
						//shape.renderPixels(draw, ix2 - (*0.5f), icy);
					break;
				}
				
				
			
			
			
			
			
			
			
			//draw.popTexture();
				/*
				if(isOutline)
				{
					//TODO outlineColour...
					//glColor4f(r*0.5f, g*0.5f, b*0.5f, a);
					glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
					shape.stroke();
					//draw.stroke( shape );
				}
				*/
			
			//if( isClipping == true )
			//	draw.pushClipping(ix1, iy1, ix2, iy2, iz);
					
					renderChildren(draw);
					
		endRender(draw);//TEMP hack...
					
			//if( isClipping == true )
			//	draw.popClipping();
	}
		
/+ THE old one:
	void render(Draw draw)
	{
		//setScalingMode(true);
		//scope(exit) setScalingMode(false);
	
		if( texture !is null )
			texture.pushTexture();
		else glDisable(GL_TEXTURE_2D);
	
		//Trace.formatln("	Rectangle.render() START.");
		glPushMatrix();
			applyPosition();
			applyRotation();
			
			glColor4f( r, g, b, a );
		
			//float zero = 0.0f;
			
			//glTranslatef( -cx, -cy, 0.0f );
			
			//glTranslatef( -(w*0.5f), -(h*0.5f), 0.0f );
			
			glBegin(GL_QUADS);
				
				glNormal3f( 0.0f, 0.0f, 1.0f );
				glTexCoord2f( 0.0f, 0.0f );
				glVertex3f( roundToPixels( icx - (rpixel*128.0f*0.5f)), roundToPixels( icy - (rpixel*64.0f*0.5f)), iz );
				
				//glNormal3f( 0.0f, 0.0f, 1.0f );
				glTexCoord2f( 0.0f, 1.0f );
				glVertex3f( roundToPixels( icx - (rpixel*128.0f*0.5f)), roundToPixels( icy + (rpixel*64.0f*0.5f)), iz );
				
				//glNormal3f( 0.0f, 0.0f, 1.0f );
				glTexCoord2f( 1.0f, 1.0f );
				glVertex3f( roundToPixels( icx + (rpixel*128.0f*0.5f)), roundToPixels( icy + (rpixel*64.0f*0.5f)), iz );
				
				//glNormal3f( 0.0f, 0.0f, 1.0f );
				glTexCoord2f( 1.0f, 0.0f );
				glVertex3f( roundToPixels( icx + (rpixel*128.0f*0.5f)), roundToPixels( icy - (rpixel*64.0f*0.5f)), iz );
				
				
				
				
				
				/*
				glNormal3f( 0.0f, 0.0f, 1.0f );
				glTexCoord2f( 0.0f, 0.0f );
				glVertex3f( x, y, z );
				
				//glNormal3f( 0.0f, 0.0f, 1.0f );
				glTexCoord2f( 1.0f, 0.0f );
				glVertex3f( x2, y, z );
				
				//glNormal3f( 0.0f, 0.0f, 1.0f );
				glTexCoord2f( 1.0f, 1.0f );
				glVertex3f( x2, y2, z );
				
				//glNormal3f( 0.0f, 0.0f, 1.0f );
				glTexCoord2f( 0.0f, 1.0f );
				glVertex3f( x, y2, z );
				*/
				
			glEnd();
			
			glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
			
			/*
			glBegin(GL_LINES);
				glNormal3f( 0.0f, 0.0f, 1.0f );
				//glTexCoord2f( 0.0f, 0.0f );
				glVertex3f( x, y, z );
				glVertex3f( x2, y2, z );
				glVertex3f( x, y2, z );
			glEnd();
			*/
			
			renderChildren(draw);
			
		glPopMatrix();
		
		if( texture !is null )
			texture.popTexture();
	}
+/
	
	
	//Just awful way to do this:
	//bool isWhite = true;
	
	//The Colour methods are overloaded to affect
	//the text colour. The super.colour stuff
	//will affect the Textured rectangles color
	//which should always/usually be white.
	
	/*
	GLfloat r() { return m_textColourData[0]; }
	GLfloat g() { return m_textColourData[1]; }
	GLfloat b() { return m_textColourData[2]; }
	GLfloat a() { return m_textColourData[3]; }
	*/
	/*
	override float r()
	{
		if( followAlpha is null || followAlpha is this )
			return super.r();
		//else
		if( tr() < 0.5f )//if "black"...
			return super.r();
		//else
			return followAlpha.a * super.r();
	}
	override void r( float set ) { super.r(set); }
	override float g()
	{
		if( followAlpha is null || followAlpha is this )
			return super.g();
		//else
		if( tg() < 0.5f )//if "black"...
			return super.g();
		//else
			return followAlpha.a * super.g();
	}
	override void g( float set ) { super.g(set); }
	override float b()
	{
		if( followAlpha is null || followAlpha is this )
			return super.b();
		//else
		if( tb() < 0.5f )//if "black"...
			return super.b();	
		//else
			return followAlpha.a * super.b();
	}
	override void b( float set ) { super.b(set); }
	override float a()
	{
		if( followAlpha is null || followAlpha is this )
			return super.a();
		//else
			return followAlpha.a * super.a();
	}
	override void a( float set ) { super.a(set); }
	*/
	
	override protected void applyColour()
	{
		if( followAlpha is null || followAlpha is this )
			glColor4f( r, g, b, a );
		else glColor4f( followAlpha.a * r, followAlpha.a * g, followAlpha.a * b, followAlpha.a * a );
	}
	
	//TEMP textColour
	float tr() { return m_textColourData[0]; }
	float tg() { return m_textColourData[1]; }
	float tb() { return m_textColourData[2]; }
	float ta() { return m_textColourData[3]; }
	
	void tr( float set ) { m_textColourData[0] = set; }
	void tg( float set ) { m_textColourData[1] = set; }
	void tb( float set ) { m_textColourData[2] = set; }
	void ta( float set ) { m_textColourData[3] = set; }
		
	
	void textColour( float sr, float sg, float sb, float sa )
	{
		tr = sr; tg = sg; tb = sb; ta = sa;
		
		updateText();
		
		/*if( texture !is null )
		{
			texture.showText( name, m_textColourData, textWidth, textHeight );
			//Image gives the text size in pixels, we'll have to convert them to
			//Height Coordinates.
			textWidth = textWidth * pixel;
			textHeight = textHeight * pixel;
		}*/
	}
	
	void textColour( float[] set )
	{
		if( set.length >= 4 )
		{
			textColour( set[0], set[1], set[2], set[3] );
		}
	}
	
	
	
	protected float[4] m_textColourData;
	
	float fontSize() { return m_fontSize; }
	void fontSize(float set)
	{
		m_fontSize = set;
		updateText();
	}
	protected float m_fontSize = 12.0f;
	
	override AlignType alignType() { return m_alignType; }
	override AlignType alignType(AlignType set)
	{
		m_alignType = set;
		updateText();
		return m_alignType;
	}
	
	/*void renderChildren()
	{
		super.renderChildren();
		
		//Draw.showText(name);
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
