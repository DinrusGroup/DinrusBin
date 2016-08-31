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

module rae.canvas.Draw;

import tango.util.log.Trace;//Thread safe console output.
import tango.math.Math;

import tango.util.container.LinkedList;
import Float = tango.text.convert.Float;
import Utf = tango.text.convert.Utf;

import rae.core.globals;
import rae.core.IRaeMain;

import rae.container.Stack;

//import rae.canvas.IShape;
import rae.canvas.Rectangle;
import rae.canvas.Image;
import rae.canvas.Gradient;

public import rae.canvas.AlignType;

version(pangocairo)
{
	import gtkD.cairo.FontOption;
	import gtkD.cairo.Context;
	import gtkD.cairo.Surface;
	import gtkD.cairo.ImageSurface;
	import gtkD.cairo.Pattern;
	import gtkD.cairo.Matrix;
	
	import gtkD.pango.PgContext;
	import gtkD.pango.PgLayout;
	import gtkD.pango.PgFontDescription;
	import gtkD.pango.PgCairo;
	import gtkD.pango.PgCairoFontMap;
	import gtkD.pango.PgFontMap;

}

public import rae.gl.gl;
public import rae.gl.glu;
public import rae.gl.glext;

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

version(glfw)
{
public import gl.gl;
public import gl.glu;
public import gl.glext;
}
*/

const real PI2 = PI * 2.0f;

class ClippingInfo
{	
public:
//protected:
	float ix1;
	float iy1;
	float ix2;
	float iy2;
	float iz;
	
public:
	
	this(float set_ix1, float set_iy1, float set_ix2, float set_iy2, float set_iz)
	{
		ix1 = set_ix1;
		iy1 = set_iy1;
		ix2 = set_ix2;
		iy2 = set_iy2;
		iz = set_iz;
	}
	
	void clip(ClippingInfo set)
	{
		if( set.ix1 < ix1 )
			set.ix1 = ix1;
			
		if( set.iy1 < iy1 )
			set.iy1 = iy1;
			
		if( set.ix2 > ix2 )
			set.ix2 = ix2;
			
		if( set.iy2 > iy2 )
			set.iy2 = iy2;
	}
	
	void startClipping()
	{
		/*
			glEnable(GL_STENCIL_TEST);
			
			glClearStencil(0);
			glClear(GL_STENCIL_BUFFER_BIT);
		
			glStencilFunc(GL_NEVER, 0x1, 0x1);
			glStencilOp(GL_INCR, GL_INCR, GL_INCR);
		
			glColor3f(1.0f, 1.0f, 1.0f);
		
			
			//This doesn't work anymore with GL_CCW?...
			//glRectf(ix1,
			//			iy1,
			//			ix2,
			//			iy2);
			
			glBegin(GL_QUADS);
				glNormal3f(0.0f, 0.0f, 1.0f);
				glVertex3f(ix1, iy1, iz);
				glVertex3f(ix1, iy2, iz);
				glVertex3f(ix2, iy2, iz);
				glVertex3f(ix2, iy1, iz);
			glEnd();
						
		
			glStencilFunc(GL_EQUAL, 0x1, 0x1);
			glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);
		*/
	}
	
	void endClipping()
	{
		//glDisable(GL_STENCIL_TEST);
	}
}


///This class is similar to gtkD.cairo.Context...
///It wraps some OpenGL functionality...
///TODO documentation... !

class Draw
{
	this()
	{
		clipStack = new Stack!(ClippingInfo);
	}
	

	int pushCounter = 0;

	void pushMatrix()
	{
		pushCounter++;
		glPushMatrix();
		
		if( clipStack.size > 0 )
		{
			//Copy the top of the clipstack.
			ClippingInfo clinfo = clipStack.tail;
			pushClipping( clinfo.ix1, clinfo.iy1, clinfo.ix2, clinfo.iy2 );
		}
	}
	
	void popMatrix()
	{
		pushCounter--;
		glPopMatrix();
		
		if( clipStack.size > 0 )
		{
			popClipping();
		}
	}
	
	void translate(float set_x, float set_y, float set_z)
	{
		//glTranslatef( cast(float)cast(uint)( set_x * g_rae.screenHeightP ), cast(float)cast(uint)( set_y * g_rae.screenHeightP ), set_z * g_rae.screenHeightP );
		glTranslatef( set_x, set_y, set_z );
		if( clipStack.size > 0 )
		{
			//Translate the top of the clipstack.
			ClippingInfo clinfo = clipStack.tail;
			clinfo.ix1 = clinfo.ix1 - set_x;
			clinfo.iy1 = clinfo.iy1 - set_y;
			clinfo.ix2 = clinfo.ix2 - set_x;
			clinfo.iy2 = clinfo.iy2 - set_y;
		}
	}
	
	
	
	void rotate(float set_x, float set_y, float set_z)
	{
		glRotatef( set_z, 0.0f, 0.0f, 1.0f );
		glRotatef( set_y, 0.0f, 1.0f, 0.0f );
		glRotatef( set_x, 1.0f, 0.0f, 0.0f );
	}
	
	///Use this only for effects.
	///It uses OpenGL glScalef, so
	///the coords will not get properly
	///mapped if scaling is applied.
	///You could still use it for animation...
	///Maybe we'll remove this in the future.
	void scale(float set_x, float set_y, float set_z = 1.0f)
	{
		glScalef( set_x, set_y, set_z );
		if( clipStack.size > 0 && set_x != 0.0f && set_y != 0.0f )
		{
			//Scale the top of the clipstack.
			ClippingInfo clinfo = clipStack.tail;
			clinfo.ix1 = clinfo.ix1 / set_x;
			clinfo.iy1 = clinfo.iy1 / set_y;
			clinfo.ix2 = clinfo.ix2 / set_x;
			clinfo.iy2 = clinfo.iy2 / set_y;
		}
	}
	
	void culling(bool set_culling)
	{
		if( set_culling == true )
			glEnable(GL_CULL_FACE);
		else glDisable(GL_CULL_FACE);
	}
	
	Stack!(ClippingInfo) clipStack;
	
	void pushClipping(float ix1, float iy1, float ix2, float iy2, float iz = 0.0f)
	{
		debug(clipping) 
		{
			Trace.formatln("Draw.pushClipping() START.");
		
			Trace.format("ix1:{}, ", cast(double) ix1 );
			Trace.format("iy1:{}, ", cast(double) iy1 );
			Trace.format("ix2:{}, ", cast(double) ix2 );
			Trace.format("iy2:{}, ", cast(double) iy2 );
		}
	
		ClippingInfo clipinfo = new ClippingInfo(ix1, iy1, ix2, iy2, iz);
		if( clipStack.size > 0 )
		{
			clipStack.tail.clip( clipinfo );//Wow! We clip it with the old clip.
		}
		clipStack.push( clipinfo );
		debug(clipping) Trace.formatln("Draw.pushClipping() push. size: {}", clipStack.size );
		//clipinfo.startClipping();
	}
	
	void popClipping()
	{
		debug(clipping) Trace.formatln("Draw.popClipping() START.");
	
		scope ClippingInfo clipinfo = clipStack.pop();
		
		/*
		debug(clipping) Trace.formatln("Draw.popClipping() pop. size: {}", clipStack.size );
		
		clipinfo.endClipping();
		
		if( clipStack.size > 0 )
		{
			clipStack.tail.startClipping();
		}
		//else clipinfo.endClipping();
		
		*/
	}
	
	protected Image texture;
	
	void pushTexture(Image set_texture)
	{
		if( texture !is set_texture )
		{
			texture = set_texture;
		}
	
		if( texture !is null )
			texture.pushTexture();
		//else glDisable(GL_TEXTURE_2D);
		
	}
	
	void popTexture()
	{
		if( texture !is null )
			texture.popTexture();
		texture = null;
	}

	//FBO
	public bool isFBOPushed()
	{
		if( framebufferObject is null )
			return false;
		//else
			return true;
	}
	
	protected Image framebufferObject;
	public char[] FBONameDebug = "";
	
	void pushFramebufferObject(Image set_framebufferObject)
	{
		if( framebufferObject !is null )
		{
			//assert(0);//TODO
			Trace.formatln("ERROR in draw.pushFramebufferObject(). No Pop. " ~ FBONameDebug );
		}

		if( framebufferObject !is set_framebufferObject )
		{
			framebufferObject = set_framebufferObject;
		}
	
		if( framebufferObject !is null )
			framebufferObject.pushFramebufferObject();
		//else glDisable(GL_TEXTURE_2D);
	}
	
	void popFramebufferObject()
	{
		if( framebufferObject !is null )
			framebufferObject.popFramebufferObject();
		else Trace.formatln("ERROR in draw.popFramebufferObject(). No Push.");
		framebufferObject = null;
	}
	
	
/*	
	void bounds(IShape set_shape, float ix1, float iy1, float ix2, float iy2, float iz = 0.0f)
	{
		float left_clip = 0.0f;
		float right_clip = 0.0f;
		float up_clip = 0.0f;
		float down_clip = 0.0f;
	
		//We clip here. This is so funny.
		if( clipStack.size > 0 )
		{
			ClippingInfo cl = clipStack.tail;
			if( ix1 < cl.ix1 )
			{
				left_clip = cl.ix1 - ix1;
				//ix1 = cl.ix1;
			}
				
			if( iy1 < cl.iy1 )
			{
				up_clip = cl.iy1 - iy1;
				//iy1 = cl.iy1;
			}
				
			if( ix2 > cl.ix2 )
			{
				right_clip = cl.ix2 - ix2;
				//ix2 = cl.ix2;
			}
				
			if( iy2 > cl.iy2 )
			{
				down_clip = cl.iy2 - iy2;
				//iy2 = cl.iy2;
			}
		}
		
		set_shape.clip(left_clip, right_clip, up_clip, down_clip);
		set_shape.bounds(ix1, iy1, ix2, iy2, iz);
	}
	
	void fill(IShape set_shape)
	{
		set_shape.fill();
	}
	
	void stroke(IShape set_shape)
	{
		set_shape.stroke();
	}
*/	


static void circle(float x, float y, float w, float h)
{
	//glColor4f(1.0f, 1.0f, 1.0f, 1.0f);

	w = w * 0.5f;
	h = h * 0.5f;

	glBegin(GL_TRIANGLE_FAN);
	//glBegin(GL_POINTS);
	
		glVertex3f( x, y, 0.0f );
		
		float step = PI2 / 24.0f;
		
		for( float a = 0.0f; a <= PI2 + step; a += step )
		{
			glVertex3f( x + cos(a) * w, y + sin(a) * h, 0.0f );
		}
	
	glEnd();
}



//static void drawCircle( GLubyte[] image, uint wid, uint hei, uint chan, float[4] set_colour )
static void drawCircle( ubyte[] image, uint wid, uint hei, uint chan, float[4] set_colour )
{
	debug(Draw) Trace.formatln("Draw.drawCircle() START.");
	debug(Draw) scope(exit) Trace.formatln("Draw.drawCircle() END.");
	
	version(pangocairo)
	{
	cairo_format_t form = cairo_format_t.ARGB32;
	 
	if( chan == 4 )
		form = cairo_format_t.ARGB32;
	else if( chan == 3 )
		form = cairo_format_t.RGB24;
	else if( chan == 1 )
		form = cairo_format_t.A8;
	//TODO other cairo_format_t.

	debug(Draw) Trace.formatln("Draw.drawCircle() Trying to create a Cairo surface.");
	
	Surface imageSurface = ImageSurface.createForData(image.ptr, form, wid, hei, wid * chan);
	//ImageSurface.createForData(ubyte* data, cairo_format_t format, int width, int height, int stride);
	scope(exit) delete imageSurface;//doesn't call destroy...BUG in gtkD.

	debug(Draw) Trace.formatln("Draw.drawCircle() Success in creating a Cairo surface.");
	
	auto cr = Context.create(imageSurface);
	scope(exit) delete cr;

	cr.save();
		//cr.rotate(PI*0.1);
		//cr.scale(1.0, -1.0);
		//cr.translate(0, -2);
		cr.translate(wid/2, hei/2);
		
		/*
		//A temporary rectangle
			cr.rectangle( 0.0, 0.0, wid, hei );
			cr.setSourceRgba(1.0, 0.1, 0.3, 0.8);
			cr.fill();
		//
		*/
		
		
		//cr.translate(0, 14);
		cr.setLineWidth(1.0);
		//cr.moveTo(0.0, 0.0);
			//cr.selectFontFace("Bitstream Vera Sans", cairo_font_slant_t.NORMAL,
						//cairo_font_weight_t.NORMAL);
						
		cr.setSourceRgba(set_colour[0], set_colour[1], set_colour[2], set_colour[3]);
		
		cr.arc(0, 0, 3.0, 0, 2 * PI);
		cr.fill();
	cr.restore();
	
	/*
	cr.save();
		cr.rectangle( 0.0, 0.0, 20.0, 20.0 );
			cr.setSourceRgba(0.3, 0.6, 0.3, 0.8);
			cr.fill();
	cr.restore();
	*/
	
	cr.destroy();
	imageSurface.destroy();
	}
}

static void showText( dchar[] set_text, float set_font_size, float set_zoom, GLubyte[] image, uint wid, uint hei, uint chan, float[4] set_colour, AlignType set_align, out float get_text_width, out float get_text_height )
{
	debug(Draw) Trace.formatln("Draw.showText() START.");
	debug(Draw) scope(exit) Trace.formatln("Draw.showText() END.");

	version(pangocairo)
	{
	cairo_format_t form = cairo_format_t.ARGB32;
	 
	if( chan == 4 )
		form = cairo_format_t.ARGB32;
	else if( chan == 3 )
		form = cairo_format_t.RGB24;
	else if( chan == 1 )
		form = cairo_format_t.A8;
	//TODO other cairo_format_t.

	int our_stride = ImageSurface.formatStrideForWidth( form, wid );
	
	//Trace.formatln("wid: {} stride: {}", wid, our_stride );

	debug(Draw) Trace.formatln("Draw.showText() going to call ImageSurface.createForData.");

	//Surface imageSurface = ImageSurface.createForData(image.ptr, form, wid, hei, our_stride );//wid * chan);
	ImageSurface imageSurface = ImageSurface.createForData(image.ptr, form, wid, hei, (wid * chan) );
	//ImageSurface.createForData(ubyte* data, cairo_format_t format, int width, int height, int stride);
	scope(exit)
	{
		imageSurface.destroy();
		delete imageSurface;//doesn't call destroy...BUG in gtkD.
	}

	debug(Draw) Trace.formatln("Draw.showText() going to create cairo context.");

	auto cr = Context.create(imageSurface);
	scope(exit) delete cr;



//Cairo font stuff:

	debug(Draw) Trace.formatln("Draw.showText() going to create font_options.");

	FontOption font_options = FontOption.create();
	
	//This is for blurry fonts:
	//font_options.setHintStyle(cairo_hint_style_t.NONE);
	
	//This will give us crisp sharp fonts (atleast most of the time):
	/*
	CAIRO_HINT_STYLE_DEFAULT,
    CAIRO_HINT_STYLE_NONE,
    CAIRO_HINT_STYLE_SLIGHT,
    CAIRO_HINT_STYLE_MEDIUM,
    CAIRO_HINT_STYLE_FULL
   */
	
	//font_options.setHintStyle(cairo_hint_style_t.DEFAULT);
	font_options.setHintStyle(cairo_hint_style_t.NONE);
  //font_options.setHintStyle(cairo_hint_style_t.SLIGHT);
	//font_options.setHintStyle(cairo_hint_style_t.MEDIUM);
	//font_options.setHintStyle(cairo_hint_style_t.FULL);
	
	//font_options.setHintMetrics(cairo_hint_metrics_t.DEFAULT);
	font_options.setHintMetrics(cairo_hint_metrics_t.OFF);
	//font_options.setHintMetrics(cairo_hint_metrics_t.ON);

	//font_options.setAntialias(cairo_antialias_t.DEFAULT);
	//font_options.setAntialias(cairo_antialias_t.GRAY);
	//font_options.setAntialias(cairo_antialias_t.NONE);
	font_options.setAntialias(cairo_antialias_t.SUBPIXEL);

	cr.setFontOptions(font_options);
	
	
	cairo_text_extents_t extents;
	
	
	cr.save();
		//cr.rotate(PI*0.1);
		//cr.scale(1.0, -1.0);
		//cr.translate(0, -2);
		
		
		//A temporary rectangle
		/*if( set_colour[0] < 0.5f )//if text is maybe black, make a white background. awful.
		{
			cr.rectangle( 0.0, 0.0, wid, hei );
			cr.setSourceRgba(1.0, 1.0, 1.0, 1.0);
			cr.fill();
		}*/
		//
	cr.restore();
		
	/*	
		//cr.translate(0, 14);
		cr.setLineWidth(2.0);
		//cr.moveTo(0.0, 0.0);
			//cr.selectFontFace("Bitstream Vera Sans", cairo_font_slant_t.NORMAL,
			//			cairo_font_weight_t.NORMAL);
			//cr.selectFontFace("Bitstream Vera Sans", cairo_font_slant_t.NORMAL,//OBLIQUE
			//			cairo_font_weight_t.BOLD);
			cr.setFontSize(15);
			
			
			cr.textExtents( set_text, &extents );
			//double x = wid-((extents.width/2.0) + extents.xBearing);
			//double y = hei-((extents.height/2.0) + extents.yBearing);
			
			//TODO What about + or - xBearing here??
			get_text_width = extents.width;
			get_text_height = extents.height;
			
			double x = (wid/2.0)-((extents.width/2.0) + extents.xBearing);
			//double y = (hei/2.0)-((extents.height/2.0) + extents.yBearing);
			double y = (hei/2.0)-((extents.height/2.0) + extents.yBearing);
			
			
			//Accidentally this is text right justified:
			//double x = wid-((extents.width) + extents.xBearing);
			//double y = hei-((extents.height) + extents.yBearing);
			
			cr.moveTo(x, y);
			
			cr.setSourceRgba(set_colour[0], set_colour[1], set_colour[2], set_colour[3]);
			//cr.setSourceRgba(1.0, 1.0, 1.0, 1.0);
			//cr.setSourceRgba(0.0, 0.0, 0.0, 1.0);
			
			//cr.showText(set_text);
			
	cr.restore();
	*/
	
	//
	
	/*
	//PgCairoFontMap fontMap = cast(PgCairoFontMap)PgCairoFontMap.getDefault();
	PgFontMap fontMap2 = PgCairoFontMap.getDefault();
	
	if( fontMap2 is null )
	{
		Trace.formatln("PgFontMap is null. Buhuu.");
	}
	else Trace.formatln("PgFontMap is OK. Yay.");
	
	//PgCairoFontMap fontMap = cast(PgCairoFontMap)PgCairoFontMap.getDefault();
	PgCairoFontMap fontMap = new PgCairoFontMap( cast(PangoCairoFontMap*)fontMap2.getPgFontMapStruct() );
	
	if( fontMap is null )
	{
		Trace.formatln("PgCairoFontMap is null. Buhuu.");
	}
	else Trace.formatln("PgCairoFontMap is OK. Yay.");
	
	Trace.formatln("Trying to create Context.");
	//PgContext pgcon = g_rae.getPangoContext();
	PgContext pgcon = fontMap.createContext();
	
	Trace.formatln("Yes. Context created.");
	
	if( pgcon is null )
	{
		Trace.formatln("PgContext is null. Buhuu.");
	}
	else Trace.formatln("PgContext is OK. Yay.");
	*/
	
	debug(Draw) Trace.formatln("Draw.showText() going to create PangoLayout.");
	
	PgLayout pLayout = PgCairo.createLayout(cr);
	
	debug(Draw) Trace.formatln("Draw.showText() going to getContext from layout.");
	
	PgContext pgcon = pLayout.getContext();
	
	debug(Draw) Trace.formatln("Draw.showText() going to updateContext.");
	
	PgCairo.updateContext(cr, pgcon );
	
	debug(Draw) Trace.formatln("Draw.showText() going to contextSetFontOptions.");
	
	PgCairo.contextSetFontOptions( pgcon, font_options );
	//PgCairo.contextSetResolution(pgcon, 52 );
	
	debug(Draw) Trace.formatln("Draw.showText() going to updateContext.");
	
	PgCairo.updateContext(cr, pgcon );
	pLayout.contextChanged();
	
	//float font_size = 11.0f * set_zoom;
	//float font_size = g_rae.getValueFromTheme("Rae.Font.normal") * set_zoom;
	
	version(Windows)
	{
		string m_font = "Arial " ~ Float.toString(set_font_size);
	}
	else version(darwin)
	{
		string m_font = "Helvetica " ~ Float.toString(set_font_size);
	}
	else //version(linux)
	{
		//string m_font = "Bitstream Vera Sans 11";
		string m_font = "Bitstream Vera Sans " ~ Float.toString(set_font_size);
		//debug(Label) Trace.formatln( "Font: " ~ m_font );
	}
	
	debug(Draw) Trace.formatln("Draw.showText() going to set PgFontDescription.");
	
	//PgFontDescription pDesc = new PgFontDescription("Sans", 12);
	PgFontDescription pDesc = PgFontDescription.fromString(m_font);
	
	//pDesc.setAbsoluteSize(12.0);
	//pDesc.setFamily("DejaVu LGC Sans Mono");
	//pDesc.setFamily("Bitstream Vera Sans");
	//pDesc.setFamily("Sans");
	//pDesc.setWeight( cast(PangoWeight)550 );
	//pDesc.setWeight( PangoWeight.NORMAL );
	//pDesc.setStyle( PangoStyle.NORMAL );
	
	pLayout.setFontDescription( pDesc );
	
	pDesc.free();
	
	debug(Draw) Trace.formatln("Draw.showText() going to setMarkup.");
	
	//Convert the dchar[] to char[]
	//to get from utf32 to utf8 for gtkD.pango.
	char[] to_text = Utf.toString(set_text);
	
	//Here we check if is markup or not, and then
	//we call the approriate pango method.
	//This is daft, but we do it because Pango will
	//give an error message to the command line,
	//if the setMarkup is called without any actual
	//markup in the string.
	//This checking is of course not very good,
	//as it only checks for any '<' in the string.
	bool does_contain_markup = false;
	foreach(char ch; to_text)
	{
		if( ch == '<' )
			does_contain_markup = true;
	}
	
	if( does_contain_markup == true )
	{
		pLayout.setMarkup( to_text, to_text.length );
	}
	else
	{
		pLayout.setText( to_text );
	}
	
	cr.save();
	
	//cr.setOperator( cairo_operator_t.OVER );
	//cr.setLineWidth( 2.0f );
	//cr.moveTo( x, y );
	
	//PgCairo.layoutPath( cr, pLayout );
	
	debug(Draw) Trace.formatln("Draw.showText() going to updateLayout.");
	
	PgCairo.updateLayout(cr, pLayout);
	
	int twidth, theight;
	pLayout.getPixelSize(twidth, theight);
	
	
	switch( set_align )
	{
		default:
		case AlignType.CENTER:
		case AlignType.TOP:
		case AlignType.BOTTOM:
			//This is the part which is responsible for the centering of the text:
			
			//cr.moveTo( (cast(double)twidth / PANGO_SCALE) / 2.0f, (cast(double)theight / PANGO_SCALE) / 2.0f );
			//cr.moveTo( (cast(double)twidth) / 2.0f, (cast(double)theight) / 2.0f );
			cr.moveTo( (wid/2.0)-((cast(double)twidth)/2.0), (hei/2.0)-((cast(double)theight)/2.0) );
		break;
		case AlignType.LEFT:
		case AlignType.BEGIN://TODO reading direction
			cr.moveTo( 0.0, (hei/2.0)-((cast(double)theight)/2.0) );
		break;
		case AlignType.RIGHT:
		case AlignType.END://TODO reading direction
			cr.moveTo( cast(double)(wid) - cast(double)twidth, (hei/2.0)-((cast(double)theight)/2.0) );
		break;
	}
	
	//cr.setSourceRgba( 0.0f, 0.0f, 0.0f, 1.0f );
	cr.setSourceRgba(set_colour[0], set_colour[1], set_colour[2], set_colour[3]);
	//cr.fill();
	
	debug(Draw) Trace.formatln("Draw.showText() going to showLayout.");
	
	PgCairo.showLayout(cr, pLayout);
	
	cr.restore();
	
	debug(Draw) Trace.formatln("Draw.showText() going to set get_text_width etc.");
	
	get_text_width = twidth;
	get_text_height = theight;
	
	debug(Draw) Trace.formatln("Draw.showText() all done, just destroy it all now.");
	
	//
	
	//A nice way to debug if the texts are ok.
	debug(ShowTextToPng) imageSurface.writeToPng( g_rae.homeDir ~ "rae_debug/showtext/" ~ Utf.toString(set_text) ~ ".png");
	//
	
	
	/*
	cr.save();
		cr.rectangle( 0.0, 0.0, 20.0, 20.0 );
			cr.setSourceRgba(0.3, 0.6, 0.3, 0.8);
			cr.fill();
	cr.restore();
	*/
	
	cr.destroy();
	//imageSurface.destroy();
	}
}


}//end class Draw

/+
void showText( char[] set_text )
{
	//Trace.formatln("Draw.showText() START.");

	glDisable(GL_TEXTURE_2D);

	glPushMatrix();

	const uint chan = 4;
	const uint wid = 128;
	const uint hei = 24;

	const uint buf_size = chan*wid*hei;
	GLubyte[buf_size] buf;
	
	/*	
	uint count = 0;
	GLubyte val = 45;
	for( uint i = 0; i < buf_size; i++ )
	{
		//Trace.formatln("i:{}", i);
		
		if( count == 48 )
		{
			count = 0;
			if( val == 150 )
				val = 45;
			else val = 150;
		}
		count++;
		buf[i] = val;
	}*/
	
	
	
	Surface imageSurface = ImageSurface.createForData(buf.ptr, cairo_format_t.ARGB32, wid, hei, wid * chan);
	//ImageSurface.createForData(ubyte* data, cairo_format_t format, int width, int height, int stride);
	scope(exit) delete imageSurface;//doesn't call destroy...BUG in gtkD.

	auto cr = Context.create(imageSurface);
	scope(exit) delete cr;

	FontOption font_options = FontOption.create();
	font_options.setHintStyle(cairo_hint_style_t.NONE);
	font_options.setHintMetrics(cairo_hint_metrics_t.OFF);
	font_options.setAntialias(cairo_antialias_t.GRAY);

	cr.setFontOptions(font_options);
	
	cr.save();
		//cr.rotate(PI*0.1);
		cr.scale(1.0, -1.0);//swap Y
		/*
		cr.save();
			cr.rectangle( 0.0, 0.0, 128.0, 24.0 );
			cr.setSourceRgba(1.0, 0.1, 0.3, 0.8);
			cr.fill();
		cr.restore();
		*/
		cr.translate(0, -2);
		cr.setLineWidth(1.0);
		//cr.moveTo(0.0, 0.0);
			//cr.selectFontFace("Bitstream Vera Sans", cairo_font_slant_t.NORMAL,
						//cairo_font_weight_t.NORMAL);
			cr.setFontSize(16);
			cr.setSourceRgba(1.0, 1.0, 1.0, 1.0);
			cr.showText(set_text);
	cr.restore();
	
	cr.destroy();
	imageSurface.destroy();
	
	
	/*
	bool its_empty = true;
	foreach(GLubyte b; buf)
	{
		if( b != 0 )
		{
			its_empty = false;
			//Trace.formatln("b:{}",b);
		}
	}
	
	if( its_empty == true )
		Trace.formatln("EMPTY.");
	else Trace.formatln("SOMETHING THERE.");
	*/
	
	glScalef(1.0f, 1.0f, 1.0f);
	
	glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
	//glRasterPos2f((-wid*0.5), (-hei*0.5));
	glRasterPos2f(-0.02f, 0.01f);
	//glDrawPixels(GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *pixels);
	glDrawPixels(wid, hei, GL_RGBA, GL_UNSIGNED_BYTE, buf.ptr);
	
	/*glBegin(GL_LINES);
				glNormal3f( 0.0f, 0.0f, 1.0f );
				//glTexCoord2f( 0.0f, 0.0f );
				glVertex3f( 0.0, 0.0, 0.0 );
				glVertex3f( 0.3, 0.3, 0.0 );
				glVertex3f( 0.0, 0.2, 0.0 );
			glEnd();*/
			
	glPopMatrix();
	
}
+/


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
