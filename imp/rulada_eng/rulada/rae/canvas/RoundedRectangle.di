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

module rae.canvas.RoundedRectangle;

import rae.core.globals;
import rae.core.IRaeMain;

public import rae.canvas.Rectangle;
import rae.canvas.Image;

/*
//REMOVE HackyRect.
//Not needed anymore is this is now done in
//Rectangle. See how applyColour checks for texture is null.
class HackyRect : Rectangle
{
public:

	this()
	{
		super();
	}

	override protected void applyColour()
	{
		if( followAlpha is null || followAlpha is this )
			glColor4f( r, g, b, a );
		else glColor4f( followAlpha.a * r, followAlpha.a * g, followAlpha.a * b, followAlpha.a * a );
	}
}
*/

class RoundedRectangle : Rectangle
{
public:

	//e.g. in HORIZONTAL this is
	//the width of leftRect and rightRect.
	//This must be correct for the given dpi
	//because otherwise the rounded curve will
	//get clipped too soon.
	float sideSize()
	{
		//if( xPackOptions == PackOptions.SHRINK )//Hack for button.
			//return g_rae.curveSideSize()*0.5f;
		//else if( xPackOptions == PackOptions.EXPAND )//Hack for SubWindow header.
			return g_rae.curveSideSize();
	}

	this(char[] set_theme_texture, OrientationType set_orientation = OrientationType.HORIZONTAL )//dchar[] set_label)
	{
		super();
		
		type = "RoundedRectangle";
		
		orientation = set_orientation;
		
		//isOutline = true;
		
		isClipping = false;
		renderMethod = RenderMethod.BYPASS;
		
		xPackOptions = PackOptions.EXPAND;
		//xPackOptions = PackOptions.SHRINK;
		yPackOptions = PackOptions.SHRINK;
		
		//defaultHeight = g_rae.getValueFromTheme("Rae.Button.defaultHeight");
		//minHeight = g_rae.getValueFromTheme("Rae.Button.defaultHeight");
		
		leftRect = new Rectangle();//Rectangle();
		leftRect.name = "left"d;
		leftRect.arrangeType = ArrangeType.LAYER;
		//leftRect.defaultWidth = 0.5f * g_rae.getValueFromTheme("Rae.Button.defaultHeight");
		
		//leftRect.colour(0.7f, 0.7f, 0.7f, 0.3f);
		////////leftRect.isOutline = true;
		leftRect.renderMethod = RenderMethod.PIXELS;
		leftRect.shape.themeTexture = set_theme_texture;
		leftRect.shape.texCoordOneRight = sideSize;//0.3125f;
		leftRect.shape.orientation = orientation;
		
		//hardcoded pixel sizes.
		if( orientation == OrientationType.HORIZONTAL )
		{
			arrangeType = ArrangeType.HBOX;
		
			leftRect.xPackOptions = PackOptions.SHRINK;
			leftRect.yPackOptions = PackOptions.EXPAND;
		
			leftRect.defaultWidth = 1.0f * (sideSize*64.0f*g_rae.pixel);
			leftRect.minWidth = 1.0f * (sideSize*64.0f*g_rae.pixel);
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			arrangeType = ArrangeType.VBOX;
		
			leftRect.xPackOptions = PackOptions.EXPAND;
			leftRect.yPackOptions = PackOptions.SHRINK;
		
			leftRect.defaultHeight = 1.0f * (sideSize*64.0f*g_rae.pixel);
			leftRect.minHeight = 1.0f * (sideSize*64.0f*g_rae.pixel);
			
			////////leftRect.shape.texCoordOneBottom = 0.25f;//0.3125f;
		}
		
		centerRect = new Rectangle();//Rectangle();
		centerRect.name = "center"d;
		centerRect.arrangeType = ArrangeType.LAYER;
		centerRect.shape.themeTexture = set_theme_texture;
		centerRect.shape.orientation = orientation;
		
		centerRect.shape.texCoordOneLeft = sideSize;
		centerRect.shape.texCoordOneRight = 1.0f - sideSize;
		
		if( orientation == OrientationType.HORIZONTAL )
		{
			centerRect.renderMethod = RenderMethod.PIXELS_VERTICAL;
			
			centerRect.xPackOptions = PackOptions.SHRINK;
			//centerRect.xPackOptions = PackOptions.EXPAND;
			centerRect.yPackOptions = PackOptions.EXPAND;
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			centerRect.renderMethod = RenderMethod.PIXELS_HORIZONTAL;
		
			centerRect.xPackOptions = PackOptions.EXPAND;
			centerRect.yPackOptions = PackOptions.SHRINK;
			//centerRect.yPackOptions = PackOptions.EXPAND;
			
			//////centerRect.shape.texCoordOneTop = sideSize;
			//////centerRect.shape.texCoordOneBottom = 1.0f - sideSize;
		}
		
		
		//centerRect.colour(0.7f, 0.7f, 0.7f, 0.3f);
		//////////centerRect.isOutline = true;
		
		rightRect = new Rectangle();//Rectangle();
		rightRect.name = "right"d;
		rightRect.arrangeType = ArrangeType.LAYER;
		//rightRect.colour(1.0f, 0.0f, 0.0f, 0.5f);
		//rightRect.defaultWidth = 0.5f * g_rae.getValueFromTheme("Rae.Button.defaultHeight");
		
		rightRect.renderMethod = RenderMethod.PIXELS;
		rightRect.shape.themeTexture = set_theme_texture;
		rightRect.shape.orientation = orientation;
		
		rightRect.shape.texCoordOneLeft = 1.0f - sideSize;//0.6875f;
		
		//hardcoded pixel sizes.
		if( orientation == OrientationType.HORIZONTAL )
		{
			rightRect.xPackOptions = PackOptions.SHRINK;
			rightRect.yPackOptions = PackOptions.EXPAND;
		
			rightRect.defaultWidth = 1.0f * (sideSize*64.0f*g_rae.pixel);
			rightRect.minWidth = 1.0f * (sideSize*64.0f*g_rae.pixel);
			
			//Now this is important.
			//Here we add the rects to this widget.
			//In horizontal we do it in this order: left, center, right.
			//But in vertical it's reversed, so that we'll get
			//e.g. text to run from down to up, and the light
			//direction to be from nort-west (that means up-left).
			//Light direction will be visible in textures which
			//mimic lighting with a gradient.
			super.add(leftRect);
			super.add(centerRect);
			super.add(rightRect);
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			rightRect.xPackOptions = PackOptions.EXPAND;
			rightRect.yPackOptions = PackOptions.SHRINK;
		
			rightRect.defaultHeight = 1.0f * (sideSize*64.0f*g_rae.pixel);
			rightRect.minHeight = 1.0f * (sideSize*64.0f*g_rae.pixel);
			
			//////rightRect.shape.texCoordOneTop = 0.75f;//0.6875f;
			
			//As discussed before... Here they are in reversed order.
			super.add(rightRect);
			super.add(centerRect);
			super.add(leftRect);
		}
		
		//////////rightRect.isOutline = true;
		
		
		
	/*
		label = new Label(set_label);
		label.textColour = g_rae.getColourFromTheme("Rae.Button.text");
		label.outPaddingX = 0.0f;
		label.outPaddingY = 0.0f;
		centerRect.add( label );
	*/	
	}
	
	/*bool onMouseButtonPress( InputState input )
	{
		Trace.formatln("leftRect.w: {} in pix: {}", cast(double) leftRect.w, leftRect.w/g_rae.pixel);
		Trace.formatln("centerRect.w: {} in pix: {}", cast(double) centerRect.w, centerRect.w/g_rae.pixel);
		Trace.formatln("rightRect.w: {} in pix: {}", cast(double) rightRect.w, rightRect.w/g_rae.pixel);
		
		return super.onMouseButtonPress(input);
	}*/
	
	override void arrange()
	{
		if( leftRect is null || centerRect is null || rightRect is null )
			return;
	
		if( orientation == OrientationType.HORIZONTAL )
		{
			Image tex;
			float magic_add;
			
			if( leftRect.shape !is null && leftRect.shape.texture !is null )
			{
				tex = leftRect.shape.texture;
				magic_add = (tex.width/20.0f) * g_rae.pixel;
				leftRect.wN = (sideSize * tex.width * g_rae.pixel);
				leftRect.h = h;
				leftRect.yPosN = 0.0f;
				leftRect.xPos = (-w*0.5f) + (leftRect.w*0.5f) - magic_add;
			}
			
			//We presume texture is the same on all of these.
			if( tex !is null )
			{
				//if( rightRect.shape !is null && rightRect.shape.texture !is null )
					//we presume texture is the same... tex = rightRect.shape.texture;
					rightRect.wN = (sideSize * tex.width * g_rae.pixel);
					rightRect.h = h;
					rightRect.yPosN = 0.0f;
					rightRect.xPos = -leftRect.xPos;//(w*0.5f) + (rightRect.w*0.5f) + magic_add; //OPTIMIZED.
				
				//if( centerRect.shape !is null && centerRect.shape.texture !is null )
					//we presume texture is the same...tex = centerRect.shape.texture;
					centerRect.wN = w - (leftRect.w + rightRect.w) + (2.0f*magic_add);//magic addition of 3 pixels on both sides, because of theme shadows.
					centerRect.h = h;
					centerRect.yPosN = 0.0f;
					centerRect.xPos = 0.0f;
			}
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			Image tex;
			float magic_add;
			
			if( rightRect.shape !is null && rightRect.shape.texture !is null )
			{
				tex = rightRect.shape.texture;
				magic_add = (tex.width/20.0f) * g_rae.pixel;
				rightRect.wN = w;
				rightRect.h = (sideSize * tex.width * g_rae.pixel);
				rightRect.xPosN = 0.0f;
				rightRect.yPos = (-h*0.5f) + (rightRect.h*0.5f) - magic_add;
			}
			
			//We presume texture is the same on all of these.
			if( tex !is null )
			{
				//if( leftRect.shape !is null && leftRect.shape.texture !is null )
					//we presume texture is the same... tex = leftRect.shape.texture;
					leftRect.wN = w;
					leftRect.h = (sideSize * tex.width * g_rae.pixel);
					leftRect.xPosN = 0.0f;
					leftRect.yPos = -rightRect.yPos;//(w*0.5f) + (leftRect.w*0.5f) + magic_add; //OPTIMIZED.
				
				//if( centerRect.shape !is null && centerRect.shape.texture !is null )
					//we presume texture is the same...tex = centerRect.shape.texture;
					centerRect.wN = w;
					centerRect.h = h - (leftRect.h + rightRect.h) + (2.0f*magic_add);//magic addition of 3 pixels on both sides, because of theme shadows.
					centerRect.xPosN = 0.0f;
					centerRect.yPos = 0.0f;
			}
		}
		
		//In both cases we do an arrange on the centerRect,
		//because it might have some children who need to be arranged
		//e.g. text.
		//centerRect.arrange();
	}
	
	override void add( Rectangle a_widget )
	{
		if( centerRect !is null )
		{
			centerRect.add( a_widget );
		}
	}
	
	override void append( Rectangle a_widget )
	{
		if( centerRect !is null )
		{
			centerRect.append( a_widget );
		}
	}
	
	override void prepend( Rectangle a_widget )
	{
		if( centerRect !is null )
		{
			centerRect.prepend( a_widget );
		}
	}
	
	override void remove( Rectangle a_widget )
	{
		if( centerRect !is null )
		{
			centerRect.remove( a_widget );
		}
	}
	
	override void clear()
	{
		if( centerRect !is null )
		{
			centerRect.clear();
		}
	}
	
	override public PackOptions xPackOptions() { return m_xPackOptions; };
	override public void xPackOptions(PackOptions set)
	{
		m_xPackOptions = set;
		if( centerRect !is null ) centerRect.xPackOptions = set;
	};
	
	override public PackOptions yPackOptions() { return m_yPackOptions; };
	override public void yPackOptions(PackOptions set)
	{
		m_yPackOptions = set;
		if( centerRect !is null ) centerRect.yPackOptions = set;
	};
	
	public void themeTexture( char[] set )
	{
		if( leftRect !is null && leftRect.shape !is null)
			leftRect.shape.themeTexture = set;
		if( centerRect !is null && centerRect.shape !is null)
			centerRect.shape.themeTexture = set;
		if( rightRect !is null && rightRect.shape !is null)
			rightRect.shape.themeTexture = set;
	}
	
	bool prelight()
	{
		leftRect.prelight();
		centerRect.prelight();
		rightRect.prelight();
		return true;
	}
	
	bool unprelight()
	{
		leftRect.unprelight();
		centerRect.unprelight();
		rightRect.unprelight();
		return false;
	}
	
	//Colour
	float r() { return (centerRect is null)? super.r : centerRect.r; }
	float g() { return (centerRect is null)? super.g : centerRect.g; }
	float b() { return (centerRect is null)? super.b : centerRect.b; }
	float a() { return (centerRect is null)? super.a : centerRect.a; }
	/*float a()
	{
		if( followAlpha is null || followAlpha is this || centerRect is null )
			return super.a();
		//else
			return followAlpha.a * centerRect.a();
	}*/
	
	void r( float set )
	{
		if( leftRect is null || centerRect is null || rightRect is null )
			return;
		leftRect.r(set);
		centerRect.r(set);
		rightRect.r(set);
	}
	void g( float set )
	{
		if( leftRect is null || centerRect is null || rightRect is null )
			return;
		leftRect.g(set);
		centerRect.g(set);
		rightRect.g(set);
	}
	void b( float set )
	{
		if( leftRect is null || centerRect is null || rightRect is null )
			return;
		leftRect.b(set);
		centerRect.b(set);
		rightRect.b(set);
	}
	void a( float set )
	{
		if( leftRect is null || centerRect is null || rightRect is null )
			return;
		leftRect.a(set);
		centerRect.a(set);
		rightRect.a(set);
	}
	
	void colour( float sr, float sg, float sb, float sa )
	{
		if( leftRect is null || centerRect is null || rightRect is null )
			return;
		leftRect.colour(sr,sg,sb,sa);
		centerRect.colour(sr,sg,sb,sa);
		rightRect.colour(sr,sg,sb,sa);
	}

	void colour( float[] set )
	{
		if( leftRect is null || centerRect is null || rightRect is null )
			return;
		leftRect.colour(set);
		centerRect.colour(set);
		rightRect.colour(set);
	}
	
protected:

	//Rectangle leftRect;
	//Rectangle centerRect;
	//Rectangle rightRect;
	Rectangle leftRect;
	Rectangle centerRect;
	Rectangle rightRect;

	//Label label;

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
