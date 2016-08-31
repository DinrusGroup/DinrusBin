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

module rae.core.Theme;

import tango.util.log.Trace;//Thread safe console output.

import tango.math.Math;
import tango.core.Exception;

//import Float = tango.text.convert.Float;
	import Integer = tango.text.convert.Integer;

import rae.canvas.Colour;
import rae.canvas.Image;
import rae.canvas.Gradient;

version(pangocairo)
{
	import gtkD.cairo.FontOption;
	import gtkD.cairo.Context;
	import gtkD.cairo.Surface;
	import gtkD.cairo.ImageSurface;
	import gtkD.cairo.Pattern;
	import gtkD.cairo.Matrix;
}

import rae.core.globals;
import rae.core.IRaeMain;


class Theme
{
public:
	char[] name;

	this(char[] set_name)
	{
		name = set_name;
	}
	
	void addValue( char[] set_name, float set_value )
	{
		values[set_name] = set_value;
	}
	
	void addValueDpi( char[] set_name, float set_value )
	{
		values[set_name] = g_rae.dpiMul * set_value;
	}
	
	float getValue( char[] a_name )
	{
		debug(Theme) Trace.formatln("Theme.getValue() START. {}", a_name );
		debug(Theme) scope(exit) Trace.formatln("Theme.getValue() END.");
		//return values[a_name];
		
		float ret;
		
		try { ret = values[a_name]; } catch( Exception ex)
		{
			Trace.formatln("Value not defined in Theme: {} Using 0.1", a_name);
		}
		if( ret == float.nan )
			return 0.1f;
		return ret;
	}
	
	float getValueDpi( char[] a_name )
	{
		//Currently this is just an alias for getValue.
		//But this might change so that it will
		//add the dpi to the queried value.
		//I'll have to think, how this dpi system will work.
		//and how to change the dpi while the program is running.
		return values[a_name];
	}
	
	protected float[char[]] values;
	
	void addColour( char[] set_name, float sr, float sg, float sb, float sa)
	{
		debug(Theme) Trace.formatln("Theme.addColour() START.");
		debug(Theme) scope(exit) Trace.formatln("Theme.addColour() END.");
		Colour a_colour = new Colour(sr,sg,sb,sa);
		colours[set_name] = a_colour;
	}
	
	Colour getColour( char[] a_name )
	{
		debug(Theme) Trace.formatln("Theme.getColour() START. {}", a_name );
		debug(Theme) scope(exit) Trace.formatln("Theme.getColour() END.");
		Colour a_colour;
		try { a_colour = colours[a_name]; } catch(Exception ex)
		{
			Trace.formatln("Colour:{} not defined in Theme:{}. Using white.", a_name, name);
		}
		
		if( a_colour !is null )
		{
			return a_colour;
		}
		//else
		return new Colour();
	}
	
	float[] getColourArray( char[] a_name )
	{
		debug(Theme) Trace.formatln("Theme.getColourArray() START. {}", a_name );
		debug(Theme) scope(exit) Trace.formatln("Theme.getColourArray() END.");
		Colour a_colour;
		try { a_colour = colours[a_name]; } catch(Exception ex)
		{
			Trace.formatln("Colour:{} not defined in Theme:{}. Using white.", a_name, name);
		}
		if( a_colour !is null )
		{
			return a_colour.get();
		}
		//else
		float[] just_white = new float[4];
		just_white[0] = 1.0f;
		just_white[1] = 1.0f;
		just_white[2] = 1.0f;
		just_white[3] = 1.0f;
		return just_white;
	}
	
	protected Colour[char[]] colours;
	
	version(zoomCairo)
	{
		void addImage( Image set_image, char[] set_name, float set_size = 1.0f )
		{
			debug(Theme) Trace.formatln("Theme.addImage() START {}.", set_name);
			debug(Theme) scope(exit) Trace.formatln("Theme.addImage() END.");
			
			set_image.name = set_name;
			set_image.zoomKey = set_size;
			images[set_size][set_name] = set_image;
		}
	}
	//version(zoomGL)
	else
	{
		void addImage( Image set_image, char[] set_name )
		{
			debug(Theme) Trace.formatln("Theme.addImage() START {}.", set_name );
			debug(Theme) scope(exit) Trace.formatln("Theme.addImage() END.");
		
			set_image.name = set_name;
			//set_image.zoomKey = set_size;//REMOVE...?
			images[set_name] = set_image;
		}
	}
	/*
	Image getImage( char[] a_name )
	{
		debug(Theme) Trace.formatln("Theme.getImage() START. {}", a_name );
		debug(Theme) scope(exit) Trace.formatln("Theme.getImage() END.");
		return images[a_name][1.0f];
	}
	*/
	
version(zoomCairo)
{
	
	Image getImage( char[] set_name, float set_height = 1.0f, Image old_image = null )
	{
		debug(Theme) Trace.formatln("updateImage: set_name: {} set_height: {}", set_name, cast(double) set_height );
		
		Image ret;
		
		if( old_image !is null && old_image.name == set_name && old_image.zoomKey == set_height )
				return old_image;
		
		//HACK:
		if( set_height == 1.0f )
		{
			switch( set_name )
			{
				default:
					//Trace.formatln("Theme.getImageWithHeight() failed. No such image defined: {}", set_name );
				break;
				case "Rae.Button":
					set_height = getValue("Rae.Button.defaultHeight");
				break;
				case "Rae.Slider.control":
					set_height = getValue("Rae.HSlider.defaultHeight");
				break;
				case "Rae.WindowHeader.Top":
				case "Rae.WindowHeader.Bottom":
					set_height = getValue("Rae.WindowHeader.SMALL.defaultHeight");
				break;
			}
			/*try
			{
				set_height = getValue("Rae.Button.defaultHeight");
			}
			catch( ArrayBoundsException )
			{
				set_height = getValue("Rae.WindowHeader.SMALL.defaultHeight");
			}*/
		}
		//HACK
		
		try
		{
			ret = images[set_height][set_name];
		}
		catch( ArrayBoundsException )
		{
			/*if( ret !is null )
			{
				return ret;
			}
			else
			{
			*/
				switch( set_name )
				{
					default:
						Trace.formatln("Theme.getImageWithHeight() failed. No such image defined: {}", set_name );
					break;
					case "Rae.Button":
					case "Rae.Slider.control":
						ret = createGenericImage( set_name, set_height, /*set_gradient*/set_name, /*is_rounded:*/true, getValue(set_name ~ ".curveFactor"), /*is_shadow:*/true, /*set_shadow_blur_amount:*/2.0f );
					break;
					case "Rae.WindowHeader.Top":
						ret = createTopWindowHeaderImage( set_height );
					break;
					case "Rae.WindowHeader.Bottom":
						ret = createBottomWindowHeaderImage( set_height );
					break;
					case "Rae.ResizeButton":
						ret = createResizeButtonImage( set_height );
					break;
					case "Rae.ShapeShadow.round":
						ret = createWindowShadowImage( set_height, getColourArray("Rae.SubWindow.shadow"), true );
					break;
					case "Rae.ShapeShadow.square":
						ret = createWindowShadowImage( set_height, getColourArray("Rae.SubWindow.shadow"),false );
					break;
				}
			//}
			
			if( ret !is null )
			{
				addImage( ret, set_name, set_height );
			}
		}
		
		//Add reference count.
		if( ret !is null )
			ret.userCount++;
		
		//remove old_image if it doesn't have
		//any users.
		if( old_image !is null )
		{
			old_image.userCount--;
			
			if( old_image.userCount <= 0 )
			{
				//images.remove(old_image.zoomKey).remove(old_image.name);
				//images.remove(old_image.zoomKey).remove(old_image.name);
				//images.remove(old_image.name, old_image.zoomKey);
				if( (old_image.zoomKey in images) !is null )
				{
					if( (old_image.name in images[old_image.zoomKey]) !is null )
					{
						debug(Theme) Trace.formatln("Removing old_image.");
						images[old_image.zoomKey].remove(old_image.name);
					}
					else
					{
						debug(Theme) Trace.formatln("3 NOT Removing old_image.");
					}
				}
				else
				{
					debug(Theme) Trace.formatln("2 NOT Removing old_image.");
				}
			}
			else
			{
				debug(Theme) Trace.formatln("1 NOT Removing old_image.");
			}
		}

		return ret;
	}
}
//version(zoomGL)
else
{
	Image getImage( char[] set_name )
	{
		debug(Theme) Trace.formatln("updateImage: set_name: {}", set_name );
		
		Image ret;
		
		float set_height = 1.0f;
		
		try
		{
			ret = images[set_name];
		}
		catch( ArrayBoundsException )
		{
			/*if( ret !is null )
			{
				return ret;
			}
			else
			{
			*/
				switch( set_name )
				{
					default:
						Trace.formatln("Theme.getImageWithHeight() failed. No such image defined: {}", set_name );
					break;
					case "Rae.Button":
						set_height = getValue("Rae.Button.defaultHeight");
						ret = createGenericImage( set_name, set_height, /*set_gradient*/set_name, /*outline_colour*/ set_name ~ ".outline",/*is_rounded:*/true, getValue("Rae.Button.curveFactor"), /*is_shadow:*/true, /*set_shadow_blur_amount:*/2.0f );
					break;
					case "Rae.Slider.control":
						set_height = getValue("Rae.HSlider.defaultHeight");
						ret = createGenericImage( set_name, set_height, /*set_gradient*/set_name, /*outline_colour*/ set_name ~ ".outline", /*is_rounded:*/true, getValue("Rae.Slider.curveFactor"), /*is_shadow:*/true, /*set_shadow_blur_amount:*/2.0f );
					break;
					case "Rae.WindowHeader.Top":
						set_height = getValue("Rae.WindowHeader.SMALL.defaultHeight");
						ret = createTopWindowHeaderImage( set_height );
					break;
					case "Rae.WindowHeader.Bottom":
						set_height = getValue("Rae.WindowHeader.SMALL.defaultHeight");
						ret = createBottomWindowHeaderImage( set_height );
					break;
					case "Rae.ResizeButton":
						set_height = getValue("Rae.WindowHeader.SMALL.defaultHeight");
						ret = createResizeButtonImage( set_height );
					break;
					case "Rae.ShapeShadow.round":
						set_height = getValue("Rae.WindowHeader.SMALL.defaultHeight");
						ret = createWindowShadowImage( set_height, getColourArray("Rae.SubWindow.shadow"), true );
					break;
					case "Rae.ShapeShadow.square":
						set_height = getValue("Rae.WindowHeader.SMALL.defaultHeight");
						ret = createWindowShadowImage( set_height, getColourArray("Rae.SubWindow.shadow"), false );
					break;
				}
			//}
			
			if( ret !is null )
			{
				addImage( ret, set_name );
			}
		}
		
		//Add reference count. REMOVE from zoomGL version...?
		if( ret !is null )
			ret.userCount++;
		
		return ret;
	}
}//version zoomGL
	
	version(zoomCairo)
	{
		protected Image[char[]][float] images;
	}
	//version(zoomGL)
	else
	{
		protected Image[char[]] images;
	}
	
	void addGradient( char[] set_name, Gradient set_gradient )
	{
		gradients[set_name] = set_gradient;
	}
	
	Gradient getGradient( char[] a_name )
	{
		debug(Theme) Trace.formatln("Theme.getGradient() START. {}", a_name );
		debug(Theme) scope(exit) Trace.formatln("Theme.getGradient() END.");
		Gradient a_grad;
		try { a_grad = gradients[a_name]; } catch(Exception ex)
		{
			//Trace.formatln("Gradient:{} not defined in Theme:{}. Using white.", a_name, name );
			//If there's no such gradient we'll check the colours.
			//and if there's a match, then we'll use the colour as our
			//gradient.
			Colour a_colour;
			try { a_colour = colours[a_name]; } catch(Exception ex)
			{
				//Trace.formatln("Colour:{} not defined in Theme:{}. Using white.", a_name, name);
			}
			
			if( a_colour !is null )
			{
				a_grad = new Gradient(a_colour);
				addGradient(a_name, a_grad);//This also adds the colour to the gradient list
				//for using it again later.
				return a_grad;
			}
			
		}
		
		if( a_grad !is null )
			return a_grad;
		//else
			a_grad = new Gradient();
			a_grad.add(0.0f, 1.0f, 1.0f, 1.0f, 1.0f);
			return a_grad;
	}
	
	protected Gradient[char[]] gradients;
	
	//Images:
	
	void createImages()
	{
		debug(Theme) Trace.formatln("Theme.createImages() START. {}" );
		debug(Theme) scope(exit) Trace.formatln("Theme.createImages() END.");
		
		createMenuImage();
		//createButtonImage();
	version(zoomCairo)
	{
		getImage( "Rae.Button", getValue("Rae.Button.defaultHeight") );
		getImage( "Rae.ShapeShadow.round", getValue("Rae.WindowHeader.SMALL.defaultHeight") );
		getImage( "Rae.Slider.control", getValue("Rae.HSlider.defaultHeight") );
		createTopWindowHeaderImage( getValue("Rae.WindowHeader.SMALL.defaultHeight") );
		createBottomWindowHeaderImage( getValue("Rae.WindowHeader.SMALL.defaultHeight") );
		//createWindowShadowImage();
	}
	//version(zoomGL)
	else
	{
		getImage( "Rae.Button" );
		getImage( "Rae.ShapeShadow.round" );
		getImage( "Rae.Slider.control" );
		getImage( "Rae.WindowHeader.Top" );
		getImage( "Rae.WindowHeader.Bottom" );
		getImage( "Rae.ResizeButton" );
		getImage( "Rae.ShapeShadow.round" );
		getImage( "Rae.ShapeShadow.square" );
	}
		
		createCircleButtonImage();
		createTriangleButtonImage();
		createMaximizeButtonImage();
		createCloseButtonImage();
		createTickButtonBackgroundImage();
		createTickButtonForegroundImage();
		createSquareButtonImage();
		
		createSliderBackgroundImage();
		//createSliderControlImage();
		
		createScrollbarBackgroundImage();
		createProgressBarBackgroundImage();
	}
	
	void createMenuImage()
	{
		Image my_image = new Image(64, 64, 4);
		my_image.name = "Rae.Menu";
		my_image.fill( g_rae.getGradientFromTheme("Rae.Menu") );
		my_image.createTexture();
		addImage( my_image, "Rae.Menu" );
	}
	
	void createProgressBarBackgroundImage()
	{
		Image my_image = new Image(64, 64, 4);
		my_image.name = "Rae.ProgressBar.background";
		my_image.fill( getGradient("Rae.ProgressBar.background") );
		//drawRectangle(my_image, getGradient("Rae.ProgressBar.background"), getValue("Rae.HScrollbar.defaultHeight") );
		my_image.createTexture();
		addImage( my_image, "Rae.ProgressBar.background" );
	}
	
	Image createWindowShadowImage(float set_height, float[] set_shadow_colour, bool set_is_rounded)
	{
		Image my_image = new Image(256, 256, 4);
		if( set_is_rounded == true )
			my_image.name = "Rae.ShapeShadow.round";
		else my_image.name = "Rae.ShapeShadow.square";
		drawWindowShadow(my_image, set_height, set_shadow_colour, set_is_rounded);
		my_image.blur(6.0f);
		debug(ThemeToPng) my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/WindowShadow.png");
		my_image.createTexture();
		//addImage( my_image, "Rae.ShapeShadow.round" );
		return my_image;
	}
	
	void drawWindowShadow( Image an_image, float set_height, float[] set_shadow_colour, bool is_rounded = true )
	{
		version(pangocairo)
		{
		
			while(set_shadow_colour.length < 3)
				set_shadow_colour ~= 1.0f;
			while(set_shadow_colour.length < 4)
				set_shadow_colour ~= 0.5f;
		
		cairo_format_t form = cairo_format_t.ARGB32;
		
		if( an_image.channels == 4 )
			form = cairo_format_t.ARGB32;
		else if( an_image.channels == 3 )
			form = cairo_format_t.RGB24;
		else if( an_image.channels == 1 )
			form = cairo_format_t.A8;
		//TODO other cairo_format_t.
	
		ImageSurface imageSurface = ImageSurface.createForData(an_image.imageData.ptr, form, an_image.width, an_image.height, an_image.width * an_image.channels);
		scope(exit) delete imageSurface;	
		auto cr = Context.create(imageSurface);
		scope(exit) delete cr;
	
		//TODO theme the SMALL and NORMAL window sizes...
		//float hei = g_rae.getValueFromTheme("Rae.WindowHeader.SMALL.defaultHeight") / g_rae.pixel;
		float hei = set_height / g_rae.pixel;
	
		cr.save();
			cr.setLineWidth(1.0);
			float xRender = an_image.width/20;
			float yRender = an_image.height/20;//32.0f;//(an_image.height - hei) * 0.5f;//an_image.height/3;
			float x2Render = an_image.width - xRender;
			float y2Render = an_image.height - yRender;//(an_image.height - yRender) + hei;
			double curve_size = hei * 0.5f;//(y2Render - yRender) * 0.5f;
			
			
			//Clipping:
			
			//cr.rectangle( xRender, yRender, x2Render, y2Render );
			//cr.clip();
			
			/*
			Gradient gradient;
			//gradient = g_rae.getGradientFromTheme("Rae.Button");
			gradient = getGradient("Rae.WindowHeader.Top");
			
			scope Pattern linear = Pattern.createLinear( xRender, yRender, xRender, yRender + hei );//(0.0, 0.0, 0.0, 20.0) );
			ColourStop last_colourstop;
			foreach( ColourStop colstop; gradient )
			{
				//We store the last colourstop:
				last_colourstop = colstop;
			
				//BGRA
				//I checked, and with the current settings the cairo images
				//are BGRA and not RGBA. That's why I found it easiest to just
				//swap the order here, in the drawing phase:
			
				//linear.addColorStopRgba( colstop.position, colstop.colour.r, colstop.colour.g, colstop.colour.b, colstop.colour.a );
				linear.addColorStopRgba( colstop.position, colstop.colour.b, colstop.colour.g, colstop.colour.r, colstop.colour.a );
			}
	
			if( is_top == true )
			{
				cr.setSource( linear );
			}
			else
			{
				cr.setSourceRgba(last_colourstop.colour.b, last_colourstop.colour.g, last_colourstop.colour.r, last_colourstop.colour.a);
				cr.translate(0.0f, -hei);
			}
			*/
	
			cr.setSourceRgba( set_shadow_colour[0], set_shadow_colour[1], set_shadow_colour[2], set_shadow_colour[3] );
	
			if( is_rounded == true )
			{
				cr.moveTo(xRender, yRender + curve_size);//up-left, lowerpoint
							cr.curveTo(xRender, yRender + curve_size, xRender, yRender, xRender + curve_size, yRender);//up-left, upperpoint
							cr.lineTo(x2Render - curve_size, yRender);//up-right, upperpoint
							cr.curveTo(x2Render - curve_size, yRender, x2Render, yRender, x2Render, yRender + curve_size);//up-right, lowerpoint
							cr.lineTo(x2Render, y2Render - curve_size);//down-right, upperpoint
							cr.curveTo(x2Render, y2Render - curve_size, x2Render, y2Render, x2Render - curve_size, y2Render);//down-right, lowerpoint
							cr.lineTo(xRender + curve_size, y2Render);//down-left, lowerpoint
							cr.curveTo(xRender + curve_size, y2Render, xRender, y2Render, xRender, y2Render - curve_size);//down-left, upperpoint
							cr.lineTo(xRender, yRender + curve_size);//up-left, lowerpoint
			}
			else
			{
				cr.rectangle( xRender, yRender, x2Render-xRender, y2Render-yRender );
			}
			
			cr.fill;//Preserve();
					//cr.setSourceRgba(0.0, 0.0, 0.0, 1.0);
					//cr.setSourceRgba( outlineColour.r, outlineColour.g, outlineColour.b, outlineColour.a );
					//cr.stroke();
				
		cr.restore();
		
		cr.destroy();
		imageSurface.destroy();
		}
	}
	
	/*
	void createButtonImage()
	{
		Image my_image = new Image(256, 64, 4);
		my_image.name = "Rae.Button";
		//drawButton(my_image, true );
		drawRoundedRectangle(my_image, getGradient("Rae.Button"), getValue("Rae.Button.defaultHeight"), true );
		my_image.blur(2.0f);
		//drawButton(my_image);
		drawRoundedRectangle(my_image, getGradient("Rae.Button"), getValue("Rae.Button.defaultHeight"), false );
		my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/Button.png");
		my_image.createTexture();
		addImage( my_image, "Rae.Button" );
	}
	*/
	
	/+ REMOVE:
	void drawButton( Image an_image, bool is_shadow = false )
	{
		cairo_format_t form = cairo_format_t.ARGB32;
		
		if( an_image.channels == 4 )
			form = cairo_format_t.ARGB32;
		else if( an_image.channels == 3 )
			form = cairo_format_t.RGB24;
		else if( an_image.channels == 1 )
			form = cairo_format_t.A8;
		//TODO other cairo_format_t.
	
		ImageSurface imageSurface = ImageSurface.createForData(an_image.imageData.ptr, form, an_image.width, an_image.height, an_image.width * an_image.channels);
		//ImageSurface.createForData(ubyte* data, cairo_format_t format, int width, int height, int stride);
		scope(exit) delete imageSurface;//doesn't call destroy...BUG in gtkD.
	
		auto cr = Context.create(imageSurface);
		scope(exit) delete cr;
	
		cr.save();
			//cr.rotate(PI*0.1);
			//cr.scale(1.0, -1.0);
			//cr.translate(0, -2);
			//cr.translate(wid/2, hei/2);
			
			/*
			//A temporary rectangle
				cr.rectangle( 0.0, 0.0, an_image.width, an_image.height );
				cr.setSourceRgba(0.0, 0.0, 1.0, 1.0);
				cr.fill();
			//
			*/
			
			
			//cr.translate(0, 14);
			cr.setLineWidth(1.0);
			//cr.moveTo(0.0, 0.0);
				//cr.selectFontFace("Bitstream Vera Sans", cairo_font_slant_t.NORMAL,
							//cairo_font_weight_t.NORMAL);
							
			//cr.setSourceRgba(set_colour[0], set_colour[1], set_colour[2], set_colour[3]);
			
			float xRender = an_image.width/5;
			float yRender = an_image.height/3;
			float x2Render = an_image.width - xRender;
			float y2Render = an_image.height - yRender;
			
			double curve_size = (y2Render - yRender) * 0.5f;
			
			Gradient gradient;
			//gradient = g_rae.getGradientFromTheme("Rae.Button");
			gradient = getGradient("Rae.Button");
					
			scope Pattern linear = Pattern.createLinear( xRender, yRender, xRender, y2Render );//(0.0, 0.0, 0.0, 20.0) );
			//linear.addColorStopRgba( 0.3, 0.3, 0.6, 0.3, 1.0 );
			//linear.addColorStopRgba( 0.6, 0.5, 0.8, 0.5, 1.0 );
			foreach( ColourStop colstop; gradient )
			{
				//BGRA
				//I checked, and with the current settings the cairo images
				//are BGRA and not RGBA. That's why I found it easiest to just
				//swap the order here, in the drawing phase:
			
				//linear.addColorStopRgba( colstop.position, colstop.colour.r, colstop.colour.g, colstop.colour.b, colstop.colour.a );
				linear.addColorStopRgba( colstop.position, colstop.colour.b, colstop.colour.g, colstop.colour.r, colstop.colour.a );
			}
	
			if( is_shadow == false )
			{
				cr.setSource( linear );
			}
			else
			{
				cr.setSourceRgba(0.0f, 0.0f, 0.0f, 0.5f);
				cr.translate(0.0f, 3.5f);
			}
	
			cr.moveTo(xRender, yRender + curve_size);//up-left, lowerpoint
						//cr.setSourceRgba( colour.r, colour.g, colour.b, colour.a );
						cr.curveTo(xRender, yRender + curve_size, xRender, yRender, xRender + curve_size, yRender);//up-left, upperpoint
						cr.lineTo(x2Render - curve_size, yRender);//up-right, upperpoint
						//cr.setSourceRgba( colour.r - 0.2, colour.g - 0.2, colour.b - 0.2, colour.a );
						cr.curveTo(x2Render - curve_size, yRender, x2Render, yRender, x2Render, yRender + curve_size);//up-right, lowerpoint
						cr.lineTo(x2Render, y2Render - curve_size);//down-right, upperpoint
						cr.curveTo(x2Render, y2Render - curve_size, x2Render, y2Render, x2Render - curve_size, y2Render);//down-right, lowerpoint
						cr.lineTo(xRender + curve_size, y2Render);//down-left, lowerpoint
						cr.curveTo(xRender + curve_size, y2Render, xRender, y2Render, xRender, y2Render - curve_size);//down-left, upperpoint
						cr.lineTo(xRender, yRender + curve_size);//up-left, lowerpoint
			
			cr.fillPreserve();
					cr.setSourceRgba(0.0, 0.0, 0.0, 1.0);
					//cr.setSourceRgba( outlineColour.r, outlineColour.g, outlineColour.b, outlineColour.a );
	
					//new:
					cr.stroke();
			
			//cr.arc(0, 0, wid/6, 0, 2 * PI);
			//cr.fill();
		cr.restore();
		
		/*
		cr.save();
			cr.rectangle( 0.0, 0.0, 20.0, 20.0 );
				cr.setSourceRgba(0.3, 0.6, 0.3, 0.8);
				cr.fill();
		cr.restore();
		*/
		
		//imageSurface.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/Button.png");
		
		cr.destroy();
		imageSurface.destroy();
		
	}
	
	+/
	
	void createSliderBackgroundImage()
	{
		Image my_image = new Image(64, 64, 4);
		my_image.name = "Rae.Slider.background";
		drawRoundedRectangle(my_image, getGradient("Rae.Slider.background"), getColour("Rae.Slider.backgroundoutline"), getValue("Rae.HSlider.defaultHeight") );
		debug(ThemeToPng) my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/SliderBackground.png");
		my_image.createTexture();
		addImage( my_image, "Rae.Slider.background" );
	}
	
	//getValue("Rae.HSlider.defaultHeight")
	//addImage( my_image, "Rae.Slider.control" );
	
	Image createGenericImage( char[] set_name, float set_height, char[] set_gradient, char[] set_outline_colour, bool is_rounded, float set_curve_factor, bool is_shadow, float set_shadow_blur_amount )
	{
		Image my_image = new Image(64, 64, 4);
		my_image.name = set_name;
		//drawRoundedRectangle(my_image, getGradient(set_gradient), set_height );
		if( is_rounded )
		{
			if( is_shadow )
			{
				drawRoundedRectangle(my_image, getGradient(set_gradient), getColour(set_outline_colour), set_height, set_curve_factor, true );
				my_image.blur(set_shadow_blur_amount);
			}
			drawRoundedRectangle(my_image, getGradient(set_gradient), getColour(set_outline_colour), set_height, set_curve_factor, false );
		}
		else
		{
			if( is_shadow )
			{
				drawRectangle(my_image, getGradient(set_gradient), set_height, true );
				my_image.blur(set_shadow_blur_amount);
			}
			drawRectangle(my_image, getGradient(set_gradient), set_height, false );
		}
		
		debug(ThemeToPng) my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/" ~ set_name ~ ".png");
		
		my_image.createTexture();
		return my_image;
	}
	
	/+
	
	Image createGenericImage( char[] set_name, char[] set_gradient, bool is_rounded, float set_height, bool is_shadow, float set_shadow_blur_amount )
	{
		Image createMipMapLevel(uint set_tw, uint set_th, float lod_height, float lod_shadow_blur_amount)
		{ 
			Image my_image = new Image(set_tw, set_th, 4);
			my_image.name = set_name;
			if( is_rounded )
			{
				/*if( is_shadow )
				{
					drawRoundedRectangle(my_image, getGradient(set_gradient), lod_height, true );
					my_image.blur(lod_shadow_blur_amount);
				}
				*/
				
				drawRoundedRectangle(my_image, getGradient(set_gradient), lod_height, false );
			}
			else
			{
				/*if( is_shadow )
				{
					drawRectangle(my_image, getGradient(set_gradient), lod_height, true );
					my_image.blur(lod_shadow_blur_amount);
				}*/
				
				drawRectangle(my_image, getGradient(set_gradient), lod_height, false );
			}
				
			//my_image.createTexture();
				
			my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/" ~ set_name ~ Integer.toString(set_tw) ~ ".png");
			
			return my_image;
		}
		
		//Ok. The oversampled mipmapping thing gave me a bit 
		//blurry textures, so I'm now going for the no zooming option.
		//The mipmaps is only sharp in 100%.
		
		//NOPE: OLD oversampled version: Ok. Normal tex size is 64. That matches set_height.
		//But we wan't to be able to zoom a little. So we
		//make the mipmap level 0 to be 256. That's 4 times
		//64, so we make the first set_height to be 4 times bigger too.
		//oversampled: set_height = set_height * 4.0f;
		//oversampled: set_shadow_blur_amount = set_shadow_blur_amount * 4.0f;
		
		uint tex_wid = 64;//oversampled:256;//256;
		uint tex_hei = 64;//oversampled:256;//64;
		uint mipmap_level = 0;
		Image ret_image = createMipMapLevel(tex_wid, tex_hei, set_height, set_shadow_blur_amount);
		ret_image.addMipMapLevel(mipmap_level);//calling this without an Image argument will create the 0 level from ret_image.
		
		tex_hei = tex_hei / 2;//tex_hei 32 is where we start.
		tex_wid = tex_wid / 2;
		set_height = set_height * 0.5f;
		set_shadow_blur_amount = set_shadow_blur_amount * 0.5f;
		mipmap_level++;
		
		bool do_loop = true;
		
		while( do_loop )
		{
			if( tex_hei == 1 && tex_wid == 1 )
			{
				do_loop = false;
			}
			
			ret_image.addMipMapLevel( mipmap_level, createMipMapLevel(tex_wid, tex_hei, set_height, set_shadow_blur_amount) );
			
			if( tex_hei > 1 )
			{
				tex_hei = tex_hei / 2;
				set_height = set_height * 0.5f;
				set_shadow_blur_amount = set_shadow_blur_amount * 0.5f;
			}
			if( tex_wid > 1 ) tex_wid = tex_wid / 2;
			
			mipmap_level++;
		}
		
		return ret_image;
	}
	
	+/
	
	//give the size in height coordinates.
	Image createTextureForSize(float set)
	{
		return createTextureForSizeP( set/g_rae.pixel );
	}
	
	//give the size in pixels.
	Image createTextureForSizeP( float set )
	{
		uint texture_size = 16;
		while( (texture_size-2) < set )
		{
			texture_size = texture_size * 2;//make it bigger until it's big enough for set size.
		}
		return new Image(texture_size, texture_size, 4);
	}
	
	void createSquareButtonImage()
	{
		float def_height = getValue("Rae.Button.square.defaultHeight");
		Image my_image = createTextureForSize( def_height );
		
		my_image.name = "Rae.SquareButton";
		drawSquare( my_image, getGradient("Rae.Button"), getColour("Rae.Button.outline"), def_height, getValue("Rae.Button.square.curveFactor"), true );
		my_image.blur(2.0f);
		drawSquare( my_image, getGradient("Rae.Button"), getColour("Rae.Button.outline"), getValue("Rae.Button.square.defaultHeight"), getValue("Rae.Button.square.curveFactor"), false );
		
		debug(ThemeToPng) my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/SquareButton.png");
		my_image.createTexture();
		addImage( my_image, "Rae.SquareButton" );
	}
	
	void createTickButtonBackgroundImage()
	{
		float def_height = getValue("Rae.TickButton.defaultHeight");
		Image my_image = createTextureForSize(def_height);
		
		my_image.name = "Rae.TickButton.background";
		drawSquare( my_image, getGradient("Rae.Button"), getColour("Rae.Button.outline"), def_height, getValue("Rae.Button.curveFactor"), true );
		my_image.blur(2.0f);
		drawSquare( my_image, getGradient("Rae.Button"), getColour("Rae.Button.outline"), getValue("Rae.TickButton.defaultHeight"), getValue("Rae.Button.curveFactor"), false );
		
		debug(ThemeToPng) my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/TickButtonBackground.png");
		my_image.createTexture();
		addImage( my_image, "Rae.TickButton.background" );
	}
	
	void createTickButtonForegroundImage()
	{
		float def_height = getValue("Rae.TickButton.defaultHeight")*0.5f;//Notice that we just use half of the height.
		Image my_image = createTextureForSize(def_height);
		
		my_image.name = "Rae.TickButton.foreground";
		drawTick(my_image, def_height, getColour("Rae.Button.text") );
		
		debug(ThemeToPng) my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/TickButtonForeground.png");
		my_image.createTexture();
		addImage( my_image, "Rae.TickButton.foreground" );
	}
	
	void createScrollbarBackgroundImage()
	{
		float def_height = getValue("Rae.HScrollbar.defaultHeight");
		Image my_image = createTextureForSize(def_height);
		
		my_image.name = "Rae.Scrollbar.background";
		drawRectangle(my_image, getGradient("Rae.Scrollbar.background"), def_height );
		debug(ThemeToPng) my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/ScrollbarBackground.png");
		my_image.createTexture();
		addImage( my_image, "Rae.Scrollbar.background" );
	}
	
	void createTriangleButtonImage()
	{
		float def_height = getValue("Rae.Button.triangle.defaultHeight");
		Image my_image = createTextureForSize(def_height);
		
		my_image.name = "Rae.Button.triangle";
		//Too much to have a shadow on the triangles:
		//drawTriangle(my_image, getGradient("Rae.Button.triangle"), getValue("Rae.Button.triangle.defaultHeight"), true );
		//my_image.blur(2.0f);
		drawTriangle(my_image, getGradient("Rae.Button.triangle"), def_height, false );
		debug(ThemeToPng) my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/TriangleButton.png");
		my_image.createTexture();
		addImage( my_image, "Rae.Button.triangle" );
	}
	
	void createCircleButtonImage()
	{
		float def_height = getValue("Rae.Button.circle.defaultHeight");
		Image my_image = createTextureForSize(def_height);
		
		my_image.name = "Rae.Button.circle";
		drawCircle(my_image, getGradient("Rae.Button.circle"), def_height, true );
		my_image.blur(2.0f);
		drawCircle(my_image, getGradient("Rae.Button.circle"), def_height, false );
		debug(ThemeToPng) my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/CircleButton.png");
		my_image.createTexture();
		addImage( my_image, "Rae.Button.circle" );
	}
	
	void createCloseButtonImage()
	{
		float def_height = getValue("Rae.Button.circle.defaultHeight");
		Image my_image = createTextureForSize(def_height);
		
		my_image.name = "Rae.Button.close";
		drawCircle(my_image, getGradient("Rae.Button.circle"), def_height, true );
		my_image.blur(2.0f);
		drawCircle(my_image, getGradient("Rae.Button.circle"), def_height, false );
		drawCross( my_image, getValue("Rae.Button.circle.defaultHeight")*0.45f, getColour("Rae.Button.text") );
		
		debug(ThemeToPng) my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/CloseButton.png");
		my_image.createTexture();
		addImage( my_image, "Rae.Button.close" );
	}
	
	void createMaximizeButtonImage()
	{
		Image my_image = new Image(64, 64, 4);
		my_image.name = "Rae.Button.maximize";
		drawCircle(my_image, getGradient("Rae.Button.circle"), getValue("Rae.Button.circle.defaultHeight"), true );
		my_image.blur(2.0f);
		drawCircle(my_image, getGradient("Rae.Button.circle"), getValue("Rae.Button.circle.defaultHeight"), false );
		drawSquareStroke( my_image, getValue("Rae.Button.circle.defaultHeight")*0.45f, getColour("Rae.Button.text") );
		
		debug(ThemeToPng) my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/MaximizeButton.png");
		my_image.createTexture();
		addImage( my_image, "Rae.Button.maximize" );
	}
	
	void drawRoundedRectangle( Image an_image, Gradient gradient, Colour outline_colour, float set_height, float curve_factor = 1.0f, bool is_shadow = false )
	{
		version(pangocairo)
		{
		cairo_format_t form = cairo_format_t.ARGB32;
		
		if( an_image.channels == 4 )
			form = cairo_format_t.ARGB32;
		else if( an_image.channels == 3 )
			form = cairo_format_t.RGB24;
		else if( an_image.channels == 1 )
			form = cairo_format_t.A8;
		//TODO other cairo_format_t.
	
		ImageSurface imageSurface = ImageSurface.createForData(an_image.imageData.ptr, form, an_image.width, an_image.height, an_image.width * an_image.channels);
		scope(exit) delete imageSurface;//doesn't call destroy...BUG in gtkD.
	
		auto cr = Context.create(imageSurface);
		scope(exit) delete cr;
	
		cr.save();
			cr.setLineWidth(1.0);
			
			//NOPE: We minus two pixels from the value. Just a hack to get the outlines to show.
		//TODO find a better place to put this, or then fix it so that the outlines
		//will show without this kind of hacks. It's an OpenGL thing, and comes also from
		//the fact that we use this wierd height coordinate system...
		set_height = set_height / g_rae.pixel;// - (g_rae.pixel*2.0f);
			
			float xRender = an_image.width/20;//magic addition of 3 pixels on both sides, because of theme shadows.
			float yRender = (an_image.height - set_height) * 0.5f;//an_image.height/3;
			float x2Render = an_image.width - xRender;
			float y2Render = an_image.height - yRender;
			//double curve_size = (y2Render - yRender) * 0.5f;
			double curve_size = ((y2Render - yRender) * 0.5f) * curve_factor;
					
			scope Pattern linear = Pattern.createLinear( xRender, yRender, xRender, y2Render );//(0.0, 0.0, 0.0, 20.0) );
			//linear.addColorStopRgba( 0.3, 0.3, 0.6, 0.3, 1.0 );
			//linear.addColorStopRgba( 0.6, 0.5, 0.8, 0.5, 1.0 );
			foreach( ColourStop colstop; gradient )
			{
				//BGRA
				//I checked, and with the current settings the cairo images
				//are BGRA and not RGBA. That's why I found it easiest to just
				//swap the order here, in the drawing phase:
			
				//linear.addColorStopRgba( colstop.position, colstop.colour.r, colstop.colour.g, colstop.colour.b, colstop.colour.a );
				linear.addColorStopRgba( colstop.position, colstop.colour.b, colstop.colour.g, colstop.colour.r, colstop.colour.a );
			}

			if( is_shadow == false )
			{
				cr.setSource( linear );
			}
			else
			{
				cr.setSourceRgba(0.0f, 0.0f, 0.0f, 0.3f);
				//This is an offset for the shadow. We do a funny x offset too, because the blur function
				//will do an unwanted offset into the other direction.
				cr.translate(1.5f, 3.5f);
			}
			
			cr.moveTo(xRender, yRender + curve_size);//up-left, lowerpoint
						//cr.setSourceRgba( colour.r, colour.g, colour.b, colour.a );
						cr.curveTo(xRender, yRender + curve_size, xRender, yRender, xRender + curve_size, yRender);//up-left, upperpoint
						cr.lineTo(x2Render - curve_size, yRender);//up-right, upperpoint
						//cr.setSourceRgba( colour.r - 0.2, colour.g - 0.2, colour.b - 0.2, colour.a );
						cr.curveTo(x2Render - curve_size, yRender, x2Render, yRender, x2Render, yRender + curve_size);//up-right, lowerpoint
						cr.lineTo(x2Render, y2Render - curve_size);//down-right, upperpoint
						cr.curveTo(x2Render, y2Render - curve_size, x2Render, y2Render, x2Render - curve_size, y2Render);//down-right, lowerpoint
						cr.lineTo(xRender + curve_size, y2Render);//down-left, lowerpoint
						cr.curveTo(xRender + curve_size, y2Render, xRender, y2Render, xRender, y2Render - curve_size);//down-left, upperpoint
						cr.lineTo(xRender, yRender + curve_size);//up-left, lowerpoint
			
			cr.fillPreserve();
				
				if( outline_colour.a != 0.0f )
				{
					//cr.setSourceRgba(0.24, 0.24, 0.24, 1.0);
					cr.setSourceRgba( outline_colour.r, outline_colour.g, outline_colour.b, outline_colour.a );
					cr.stroke();
				}
		cr.restore();
		
		cr.destroy();
		imageSurface.destroy();
		}
	}
	
	void drawRectangle( Image an_image, Gradient gradient, float set_height, bool is_shadow = false )
	{
		version(pangocairo)
		{
		cairo_format_t form = cairo_format_t.ARGB32;
		
		if( an_image.channels == 4 )
			form = cairo_format_t.ARGB32;
		else if( an_image.channels == 3 )
			form = cairo_format_t.RGB24;
		else if( an_image.channels == 1 )
			form = cairo_format_t.A8;
		//TODO other cairo_format_t.
	
		ImageSurface imageSurface = ImageSurface.createForData(an_image.imageData.ptr, form, an_image.width, an_image.height, an_image.width * an_image.channels);
		scope(exit) delete imageSurface;//doesn't call destroy...BUG in gtkD.
	
		auto cr = Context.create(imageSurface);
		scope(exit) delete cr;
	
		cr.save();
			cr.setLineWidth(1.0);
			
			//NOPE: We minus two pixels from the value. Just a hack to get the outlines to show.
		//TODO find a better place to put this, or then fix it so that the outlines
		//will show without this kind of hacks. It's an OpenGL thing, and comes also from
		//the fact that we use this wierd height coordinate system...
		set_height = set_height / g_rae.pixel;// - (g_rae.pixel*2.0f);
			
			float xRender = an_image.width/20;
			float yRender = (an_image.height - set_height) * 0.5f;//an_image.height/3;
			float x2Render = an_image.width - xRender;
			float y2Render = an_image.height - yRender;
			//double curve_size = (y2Render - yRender) * 0.5f;
					
			scope Pattern linear = Pattern.createLinear( xRender, yRender, xRender, y2Render );//(0.0, 0.0, 0.0, 20.0) );
			//linear.addColorStopRgba( 0.3, 0.3, 0.6, 0.3, 1.0 );
			//linear.addColorStopRgba( 0.6, 0.5, 0.8, 0.5, 1.0 );
			foreach( ColourStop colstop; gradient )
			{
				//BGRA
				//I checked, and with the current settings the cairo images
				//are BGRA and not RGBA. That's why I found it easiest to just
				//swap the order here, in the drawing phase:
			
				//linear.addColorStopRgba( colstop.position, colstop.colour.r, colstop.colour.g, colstop.colour.b, colstop.colour.a );
				linear.addColorStopRgba( colstop.position, colstop.colour.b, colstop.colour.g, colstop.colour.r, colstop.colour.a );
			}

			if( is_shadow == false )
			{
				cr.setSource( linear );
			}
			else
			{
				cr.setSourceRgba(0.0f, 0.0f, 0.0f, 0.5f);
				cr.translate(0.0f, 3.5f);
			}
			
			cr.rectangle( xRender, yRender, x2Render-xRender, set_height );
			
			cr.fillPreserve();
					cr.setSourceRgba(0.0, 0.0, 0.0, 1.0);
					//cr.setSourceRgba( outlineColour.r, outlineColour.g, outlineColour.b, outlineColour.a );
					cr.stroke();		
		cr.restore();
		
		cr.destroy();
		imageSurface.destroy();
		}
	}
	
	void drawSquareStroke( Image an_image, float set_height, Colour set_colour )
	{
		version(pangocairo)
		{
		cairo_format_t form = cairo_format_t.ARGB32;
		
		if( an_image.channels == 4 )
			form = cairo_format_t.ARGB32;
		else if( an_image.channels == 3 )
			form = cairo_format_t.RGB24;
		else if( an_image.channels == 1 )
			form = cairo_format_t.A8;
		//TODO other cairo_format_t.
	
		ImageSurface imageSurface = ImageSurface.createForData(an_image.imageData.ptr, form, an_image.width, an_image.height, an_image.width * an_image.channels);
		scope(exit) delete imageSurface;//doesn't call destroy...BUG in gtkD.
	
		auto cr = Context.create(imageSurface);
		scope(exit) delete cr;
	
		cr.save();
			cr.setLineWidth(1.0);
			
			//NOPE: We minus two pixels from the value. Just a hack to get the outlines to show.
		//TODO find a better place to put this, or then fix it so that the outlines
		//will show without this kind of hacks. It's an OpenGL thing, and comes also from
		//the fact that we use this wierd height coordinate system...
		set_height = set_height / g_rae.pixel;// - (g_rae.pixel*2.0f);
			
			float xRender = (an_image.width - set_height) * 0.5f;//an_image.width/5;
			float yRender = (an_image.height - set_height) * 0.5f;//an_image.height/3;
			float x2Render = xRender + set_height;
			float y2Render = yRender + set_height;
			double curve_size = (y2Render - yRender) * 0.5f;
			
						//cr.setSourceRgba(1.0f, 1.0f, 1.0f, 1.0f);
			cr.setSourceRgba(set_colour.b, set_colour.g, set_colour.r, set_colour.a);
			
			cr.moveTo(xRender, yRender);
			cr.lineTo(x2Render, yRender);
			cr.lineTo(x2Render, y2Render);
			cr.lineTo(xRender, y2Render);
			cr.lineTo(xRender, yRender);
			
			//cr.fillPreserve();
			//		cr.setSourceRgba(0.0, 0.0, 0.0, 1.0);
			//cr.setSourceRgba( set_outline_colour.r, set_outline_colour.g, set_outline_colour.b, set_outline_colour.a );
			cr.stroke();		
		cr.restore();
		
		cr.destroy();
		imageSurface.destroy();
		}
	}
	
	void drawCross( Image an_image, float set_height, Colour set_colour )
	{
		version(pangocairo)
		{
		cairo_format_t form = cairo_format_t.ARGB32;
		
		if( an_image.channels == 4 )
			form = cairo_format_t.ARGB32;
		else if( an_image.channels == 3 )
			form = cairo_format_t.RGB24;
		else if( an_image.channels == 1 )
			form = cairo_format_t.A8;
		//TODO other cairo_format_t.
	
		ImageSurface imageSurface = ImageSurface.createForData(an_image.imageData.ptr, form, an_image.width, an_image.height, an_image.width * an_image.channels);
		scope(exit) delete imageSurface;//doesn't call destroy...BUG in gtkD.
	
		auto cr = Context.create(imageSurface);
		scope(exit) delete cr;
	
		cr.save();
			cr.setLineWidth(1.0);
			
			//NOPE: We minus two pixels from the value. Just a hack to get the outlines to show.
		//TODO find a better place to put this, or then fix it so that the outlines
		//will show without this kind of hacks. It's an OpenGL thing, and comes also from
		//the fact that we use this wierd height coordinate system...
		set_height = set_height / g_rae.pixel;// - (g_rae.pixel*2.0f);
			
			float xRender = (an_image.width - set_height) * 0.5f;//an_image.width/5;
			float yRender = (an_image.height - set_height) * 0.5f;//an_image.height/3;
			float x2Render = xRender + set_height;
			float y2Render = yRender + set_height;
			double curve_size = (y2Render - yRender) * 0.5f;
					
			//cr.setSourceRgba(1.0f, 1.0f, 1.0f, 1.0f);
			cr.setSourceRgba(set_colour.b, set_colour.g, set_colour.r, set_colour.a);
			
			cr.moveTo(xRender, yRender);
			cr.lineTo(x2Render, y2Render);
			cr.moveTo(xRender, y2Render);
			cr.lineTo(x2Render, yRender);
			
			//cr.fillPreserve();
			//		cr.setSourceRgba(0.0, 0.0, 0.0, 1.0);
					//cr.setSourceRgba( outlineColour.r, outlineColour.g, outlineColour.b, outlineColour.a );
			cr.stroke();		
		cr.restore();
		
		cr.destroy();
		imageSurface.destroy();
		}
	}
	
	void drawTick( Image an_image, float set_height, Colour set_colour )
	{
		version(pangocairo)
		{
		cairo_format_t form = cairo_format_t.ARGB32;
		
		if( an_image.channels == 4 )
			form = cairo_format_t.ARGB32;
		else if( an_image.channels == 3 )
			form = cairo_format_t.RGB24;
		else if( an_image.channels == 1 )
			form = cairo_format_t.A8;
		//TODO other cairo_format_t.
	
		ImageSurface imageSurface = ImageSurface.createForData(an_image.imageData.ptr, form, an_image.width, an_image.height, an_image.width * an_image.channels);
		scope(exit) delete imageSurface;//doesn't call destroy...BUG in gtkD.
	
		auto cr = Context.create(imageSurface);
		scope(exit) delete cr;
	
		cr.save();
			cr.setLineWidth(2.0);
			
			set_height = set_height / g_rae.pixel;// - (g_rae.pixel*2.0f);
			
			float xRender = (an_image.width - set_height) * 0.5f;//an_image.width/5;
			float yRender = (an_image.height - set_height) * 0.5f;//an_image.height/3;
			float x2Render = xRender + set_height;
			float y2Render = yRender + set_height;
			double curve_size = (x2Render - xRender) * 0.5f;
					
			//cr.setSourceRgba(1.0f, 1.0f, 1.0f, 1.0f);
			cr.setSourceRgba(set_colour.b, set_colour.g, set_colour.r, set_colour.a);
			
			cr.moveTo(xRender, yRender + (set_height*0.25f) );
			cr.lineTo(xRender + curve_size, y2Render - (set_height*0.15f) );
			cr.lineTo(x2Render, yRender - (set_height*0.25f) );// + (set_height*0.1f) );
			
			//cr.fillPreserve();
			//		cr.setSourceRgba(0.0, 0.0, 0.0, 1.0);
					//cr.setSourceRgba( outlineColour.r, outlineColour.g, outlineColour.b, outlineColour.a );
			cr.stroke();		
		cr.restore();
		
		cr.destroy();
		imageSurface.destroy();
		}
	}
	
	void drawCircle( Image an_image, Gradient gradient, float set_height, bool is_shadow = false )
	{
		version(pangocairo)
		{
		cairo_format_t form = cairo_format_t.ARGB32;
		
		if( an_image.channels == 4 )
			form = cairo_format_t.ARGB32;
		else if( an_image.channels == 3 )
			form = cairo_format_t.RGB24;
		else if( an_image.channels == 1 )
			form = cairo_format_t.A8;
		//TODO other cairo_format_t.
	
		ImageSurface imageSurface = ImageSurface.createForData(an_image.imageData.ptr, form, an_image.width, an_image.height, an_image.width * an_image.channels);
		scope(exit) delete imageSurface;//doesn't call destroy...BUG in gtkD.
	
		auto cr = Context.create(imageSurface);
		scope(exit) delete cr;
	
		cr.save();
			cr.setLineWidth(1.0);
			
			//NOPE: We minus two pixels from the value. Just a hack to get the outlines to show.
		//TODO find a better place to put this, or then fix it so that the outlines
		//will show without this kind of hacks. It's an OpenGL thing, and comes also from
		//the fact that we use this wierd height coordinate system...
		set_height = set_height / g_rae.pixel;// - (g_rae.pixel*2.0f);
			
			/*
			float xRender = (an_image.width - set_height) * 0.5f;//an_image.width/5;
			float yRender = (an_image.height - set_height) * 0.5f;//an_image.height/3;
			float x2Render = xRender + set_height;
			float y2Render = yRender + set_height;
			*/
			//double curve_size = (y2Render - yRender) * 0.5f;
			float half_height = set_height * 0.5f;
					
			cr.translate(an_image.width*0.5f, an_image.height*0.5f);
					
			//scope Pattern linear = Pattern.createLinear( xRender, yRender, xRender, y2Render );//(0.0, 0.0, 0.0, 20.0) );
			scope Pattern linear = Pattern.createLinear( 0.0f, -half_height, 0.0f, half_height );//(0.0, 0.0, 0.0, 20.0) );
			//linear.addColorStopRgba( 0.3, 0.3, 0.6, 0.3, 1.0 );
			//linear.addColorStopRgba( 0.6, 0.5, 0.8, 0.5, 1.0 );
			foreach( ColourStop colstop; gradient )
			{
				//BGRA
				//I checked, and with the current settings the cairo images
				//are BGRA and not RGBA. That's why I found it easiest to just
				//swap the order here, in the drawing phase:
			
				//linear.addColorStopRgba( colstop.position, colstop.colour.r, colstop.colour.g, colstop.colour.b, colstop.colour.a );
				linear.addColorStopRgba( colstop.position, colstop.colour.b, colstop.colour.g, colstop.colour.r, colstop.colour.a );
			}

			if( is_shadow == false )
			{
				cr.setSource( linear );
			}
			else
			{
				cr.setSourceRgba(0.0f, 0.0f, 0.0f, 0.5f);
				//offset for the shadow.
				cr.translate(1.5f, 3.5f);
			}
			
			cr.arc(0.0f, 0.0f, set_height * 0.5f, 0.0f, 2.0f * PI);
			
			cr.fillPreserve();
					cr.setSourceRgba(0.0, 0.0, 0.0, 1.0);
					//cr.setSourceRgba( outlineColour.r, outlineColour.g, outlineColour.b, outlineColour.a );
					cr.stroke();		
		cr.restore();
		
		cr.destroy();
		imageSurface.destroy();
		}
	}
	
	void drawSquare( Image an_image, Gradient gradient, Colour outline_colour, float set_height, float curve_factor = 0.0f, bool is_shadow = false )
	{
		version(pangocairo)
		{
		cairo_format_t form = cairo_format_t.ARGB32;
		
		if( an_image.channels == 4 )
			form = cairo_format_t.ARGB32;
		else if( an_image.channels == 3 )
			form = cairo_format_t.RGB24;
		else if( an_image.channels == 1 )
			form = cairo_format_t.A8;
		//TODO other cairo_format_t.
	
		ImageSurface imageSurface = ImageSurface.createForData(an_image.imageData.ptr, form, an_image.width, an_image.height, an_image.width * an_image.channels);
		scope(exit) delete imageSurface;//doesn't call destroy...BUG in gtkD.
	
		auto cr = Context.create(imageSurface);
		scope(exit) delete cr;
	
		cr.save();
			cr.setLineWidth(1.0);
			
			set_height = set_height / g_rae.pixel;
			
			float xRender = (an_image.width - set_height) * 0.5f;//an_image.width/5;
			float yRender = (an_image.height - set_height) * 0.5f;//an_image.height/3;
			float x2Render = xRender + set_height;
			float y2Render = yRender + set_height;
			double curve_size = ((y2Render - yRender) * 0.5f) * curve_factor;
					
			scope Pattern linear = Pattern.createLinear( xRender, yRender, xRender, y2Render );//(0.0, 0.0, 0.0, 20.0) );
			//linear.addColorStopRgba( 0.3, 0.3, 0.6, 0.3, 1.0 );
			//linear.addColorStopRgba( 0.6, 0.5, 0.8, 0.5, 1.0 );
			foreach( ColourStop colstop; gradient )
			{
				//BGRA
				//I checked, and with the current settings the cairo images
				//are BGRA and not RGBA. That's why I found it easiest to just
				//swap the order here, in the drawing phase:
			
				//linear.addColorStopRgba( colstop.position, colstop.colour.r, colstop.colour.g, colstop.colour.b, colstop.colour.a );
				linear.addColorStopRgba( colstop.position, colstop.colour.b, colstop.colour.g, colstop.colour.r, colstop.colour.a );
			}

			if( is_shadow == false )
			{
				cr.setSource( linear );
			}
			else
			{
				cr.setSourceRgba(0.0f, 0.0f, 0.0f, 0.5f);
				cr.translate(1.5f, 2.5f);
			}
			
			cr.moveTo(xRender, yRender + curve_size);//up-left, lowerpoint
						//cr.setSourceRgba( colour.r, colour.g, colour.b, colour.a );
						cr.curveTo(xRender, yRender + curve_size, xRender, yRender, xRender + curve_size, yRender);//up-left, upperpoint
						cr.lineTo(x2Render - curve_size, yRender);//up-right, upperpoint
						//cr.setSourceRgba( colour.r - 0.2, colour.g - 0.2, colour.b - 0.2, colour.a );
						cr.curveTo(x2Render - curve_size, yRender, x2Render, yRender, x2Render, yRender + curve_size);//up-right, lowerpoint
						cr.lineTo(x2Render, y2Render - curve_size);//down-right, upperpoint
						cr.curveTo(x2Render, y2Render - curve_size, x2Render, y2Render, x2Render - curve_size, y2Render);//down-right, lowerpoint
						cr.lineTo(xRender + curve_size, y2Render);//down-left, lowerpoint
						cr.curveTo(xRender + curve_size, y2Render, xRender, y2Render, xRender, y2Render - curve_size);//down-left, upperpoint
						cr.lineTo(xRender, yRender + curve_size);//up-left, lowerpoint
						
			cr.fillPreserve();
				if( outline_colour.a != 0.0f )
				{
					//cr.setSourceRgba(0.24, 0.24, 0.24, 1.0);
					cr.setSourceRgba( outline_colour.r, outline_colour.g, outline_colour.b, outline_colour.a );
					cr.stroke();
				}		
		cr.restore();
		
		cr.destroy();
		imageSurface.destroy();
		}
	}
	
	void drawTriangle( Image an_image, Gradient gradient, float set_height, bool is_shadow = false )
	{
		version(pangocairo)
		{
		cairo_format_t form = cairo_format_t.ARGB32;
		
		if( an_image.channels == 4 )
			form = cairo_format_t.ARGB32;
		else if( an_image.channels == 3 )
			form = cairo_format_t.RGB24;
		else if( an_image.channels == 1 )
			form = cairo_format_t.A8;
		//TODO other cairo_format_t.
	
		ImageSurface imageSurface = ImageSurface.createForData(an_image.imageData.ptr, form, an_image.width, an_image.height, an_image.width * an_image.channels);
		scope(exit) delete imageSurface;//doesn't call destroy...BUG in gtkD.
	
		auto cr = Context.create(imageSurface);
		scope(exit) delete cr;
	
		cr.save();
			cr.setLineWidth(1.0);
			
			//NOPE: We minus two pixels from the value. Just a hack to get the outlines to show.
		//TODO find a better place to put this, or then fix it so that the outlines
		//will show without this kind of hacks. It's an OpenGL thing, and comes also from
		//the fact that we use this wierd height coordinate system...
		set_height = set_height / g_rae.pixel;// - (g_rae.pixel*2.0f);
			
			float xRender = (an_image.width - set_height) * 0.5f;//an_image.width/5;
			float yRender = (an_image.height - set_height) * 0.5f;//an_image.height/3;
			float x2Render = xRender + set_height;
			float y2Render = yRender + set_height;
			double curve_size = (y2Render - yRender) * 0.5f;
					
			scope Pattern linear = Pattern.createLinear( xRender, yRender, xRender, y2Render );//(0.0, 0.0, 0.0, 20.0) );
			//linear.addColorStopRgba( 0.3, 0.3, 0.6, 0.3, 1.0 );
			//linear.addColorStopRgba( 0.6, 0.5, 0.8, 0.5, 1.0 );
			foreach( ColourStop colstop; gradient )
			{
				//BGRA
				//I checked, and with the current settings the cairo images
				//are BGRA and not RGBA. That's why I found it easiest to just
				//swap the order here, in the drawing phase:
			
				//linear.addColorStopRgba( colstop.position, colstop.colour.r, colstop.colour.g, colstop.colour.b, colstop.colour.a );
				linear.addColorStopRgba( colstop.position, colstop.colour.b, colstop.colour.g, colstop.colour.r, colstop.colour.a );
			}

			if( is_shadow == false )
			{
				cr.setSource( linear );
			}
			else
			{
				cr.setSourceRgba(0.0f, 0.0f, 0.0f, 0.5f);
				cr.translate(0.0f, 3.5f);
			}
			
			cr.moveTo(xRender, yRender + curve_size);
			cr.lineTo(x2Render, yRender);
			cr.lineTo(x2Render, y2Render);
			cr.lineTo(xRender, yRender + curve_size);
			
			cr.fillPreserve();
					cr.setSourceRgba(0.0, 0.0, 0.0, 1.0);
					//cr.setSourceRgba( outlineColour.r, outlineColour.g, outlineColour.b, outlineColour.a );
					cr.stroke();		
		cr.restore();
		
		cr.destroy();
		imageSurface.destroy();
		}
	}
	
	
	Image createTopWindowHeaderImage(float set_height)
	{
		//float guarantee_size = set_height;
		//if( (guarantee_size/g_rae.pixel) < 64.0f ) guarantee_size = g_rae.pixel * 64.0f;
		Image my_image = createTextureForSize( set_height * 2.0f );
		
		my_image.name = "Rae.WindowHeader.Top";
		drawWindowHeader(my_image, set_height, true);
		my_image.createTexture();
		debug(ThemeToPng) my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/TopWindowHeader.png");
		//addImage( my_image, "Rae.WindowHeader.Bottom" );
		return my_image;
		
		/*
		Image createMipMapLevel(uint set_tw, uint set_th, float lod_height)
		{ 
			Image my_image = new Image(set_tw, set_th, 4);
			my_image.name = "Rae.WindowHeader.Top";
			drawWindowHeader(my_image, lod_height, true);
			//my_image.createTexture();
			//my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/TopWindowHeader.png");
			//addImage( my_image, "Rae.WindowHeader.Top" );
			my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/" ~ my_image.name ~ Integer.toString(set_tw) ~ ".png");
			return my_image;
		}
		
		//Ok. Normal tex size is 64. That matches set_height.
		//But we wan't to be able to zoom a little. So we
		//make the mipmap level 0 to be 256. That's 4 times
		//64, so we make the first set_height to be 4 times bigger too.
		//set_height = set_height * 4.0f;
		
		uint tex_wid = 64;//256;//256;
		uint tex_hei = 64;//256;//64;
		uint mipmap_level = 0;
		Image ret_image = createMipMapLevel(tex_wid, tex_hei, set_height);
		ret_image.addMipMapLevel(mipmap_level);//calling this without an Image argument will create the 0 level from ret_image.
		
		tex_hei = tex_hei / 2;//tex_hei 32 is where we start. NOPE
		tex_wid = tex_wid / 2;
		set_height = set_height * 0.5f;
		mipmap_level++;
		
		bool do_loop = true;
		
		while( do_loop )
		{
			if( tex_hei == 1 && tex_wid == 1 )
			{
				do_loop = false;
			}
			
			ret_image.addMipMapLevel( mipmap_level, createMipMapLevel(tex_wid, tex_hei, set_height) );
			
			if( tex_hei > 1 )
			{
				tex_hei = tex_hei / 2;
				set_height = set_height * 0.5f;
			}
			if( tex_wid > 1 ) tex_wid = tex_wid / 2;
			
			mipmap_level++;
		}
		
		return ret_image;
		*/
	}
	
	Image createBottomWindowHeaderImage(float set_height)
	{
		Image my_image = createTextureForSize( set_height * 2.0f );
		
		my_image.name = "Rae.WindowHeader.Bottom";
		drawWindowHeader(my_image, set_height, false);
		my_image.createTexture();
		debug(ThemeToPng) my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/BottomWindowHeader.png");
		//addImage( my_image, "Rae.WindowHeader.Bottom" );
		return my_image;
	}
	
	void drawWindowHeader( Image an_image, float set_height, bool is_top )
	{
		version(pangocairo)
		{
		cairo_format_t form = cairo_format_t.ARGB32;
		
		if( an_image.channels == 4 )
			form = cairo_format_t.ARGB32;
		else if( an_image.channels == 3 )
			form = cairo_format_t.RGB24;
		else if( an_image.channels == 1 )
			form = cairo_format_t.A8;
		//TODO other cairo_format_t.
	
		ImageSurface imageSurface = ImageSurface.createForData(an_image.imageData.ptr, form, an_image.width, an_image.height, an_image.width * an_image.channels);
		scope(exit) delete imageSurface;	
		auto cr = Context.create(imageSurface);
		scope(exit) delete cr;
	
		//TODO theme the SMALL and NORMAL window sizes...
		float hei = set_height / g_rae.pixel;
	
		cr.save();
			cr.setLineWidth(1.0);
			float xRender = an_image.width/20;
			float yRender = (an_image.height - hei) * 0.5f;//an_image.height/3;
			float x2Render = an_image.width - xRender;
			float y2Render = (an_image.height - yRender) + hei;//Two times height...
			double curve_size = (y2Render - yRender) * 0.5f;
			
			//Clipping:
			
			//cr.rectangle( xRender, yRender, x2Render, y2Render );
			cr.rectangle( xRender, yRender, x2Render-xRender, hei );//y2Render-yRender );
			cr.clip();
			
			
			
			Gradient gradient;
			//gradient = g_rae.getGradientFromTheme("Rae.Button");
			gradient = getGradient("Rae.WindowHeader.Top");
					
			scope Pattern linear = Pattern.createLinear( xRender, yRender, xRender, yRender + hei );//(0.0, 0.0, 0.0, 20.0) );
			ColourStop last_colourstop;
			foreach( ColourStop colstop; gradient )
			{
				//We store the last colourstop:
				last_colourstop = colstop;
			
				//BGRA
				//I checked, and with the current settings the cairo images
				//are BGRA and not RGBA. That's why I found it easiest to just
				//swap the order here, in the drawing phase:
			
				//linear.addColorStopRgba( colstop.position, colstop.colour.r, colstop.colour.g, colstop.colour.b, colstop.colour.a );
				linear.addColorStopRgba( colstop.position, colstop.colour.b, colstop.colour.g, colstop.colour.r, colstop.colour.a );
			}
	
			if( is_top == true )
			{
				cr.setSource( linear );
			}
			else
			{
				cr.setSourceRgba(last_colourstop.colour.b, last_colourstop.colour.g, last_colourstop.colour.r, last_colourstop.colour.a);
				cr.translate(0.0f, -hei);
			}
	
			cr.moveTo(xRender, yRender + curve_size);//up-left, lowerpoint
						cr.curveTo(xRender, yRender + curve_size, xRender, yRender, xRender + curve_size, yRender);//up-left, upperpoint
						cr.lineTo(x2Render - curve_size, yRender);//up-right, upperpoint
						cr.curveTo(x2Render - curve_size, yRender, x2Render, yRender, x2Render, yRender + curve_size);//up-right, lowerpoint
						cr.lineTo(x2Render, y2Render - curve_size);//down-right, upperpoint
						cr.curveTo(x2Render, y2Render - curve_size, x2Render, y2Render, x2Render - curve_size, y2Render);//down-right, lowerpoint
						cr.lineTo(xRender + curve_size, y2Render);//down-left, lowerpoint
						cr.curveTo(xRender + curve_size, y2Render, xRender, y2Render, xRender, y2Render - curve_size);//down-left, upperpoint
						cr.lineTo(xRender, yRender + curve_size);//up-left, lowerpoint
			
			cr.fillPreserve();
					//cr.setSourceRgba(0.0, 0.0, 0.0, 1.0);
					
				Colour outline_colour = getColour("Rae.WindowHeader.outline");
				if( outline_colour.a != 0.0f )
				{
					//cr.setSourceRgba(0.24, 0.24, 0.24, 1.0);
					cr.setSourceRgba( outline_colour.r, outline_colour.g, outline_colour.b, outline_colour.a );
					cr.stroke();
				}
				
		cr.restore();
		
		cr.destroy();
		imageSurface.destroy();
		}
	}
	
	Image createResizeButtonImage(float set_height)
	{
		Image my_image = createTextureForSize( set_height );
		my_image.name = "Rae.ResizeButton";
		drawResizeButton(my_image, set_height, false);
		my_image.createTexture();
		debug(ThemeToPng) my_image.writeToPng(g_rae.homeDir ~ "rae_debug/" ~ name ~ "/ResizeButton.png");
		return my_image;
	}
	
	void drawResizeButton( Image an_image, float set_height, bool is_top )
	{
		version(pangocairo)
		{
		cairo_format_t form = cairo_format_t.ARGB32;
		
		if( an_image.channels == 4 )
			form = cairo_format_t.ARGB32;
		else if( an_image.channels == 3 )
			form = cairo_format_t.RGB24;
		else if( an_image.channels == 1 )
			form = cairo_format_t.A8;
		//TODO other cairo_format_t.
	
		ImageSurface imageSurface = ImageSurface.createForData(an_image.imageData.ptr, form, an_image.width, an_image.height, an_image.width * an_image.channels);
		scope(exit) delete imageSurface;	
		auto cr = Context.create(imageSurface);
		scope(exit) delete cr;
	
		//TODO theme the SMALL and NORMAL window sizes...
		float hei = set_height / g_rae.pixel;
	
		cr.save();
			cr.setLineWidth(1.0);
			float xRender = (an_image.width - hei) * 0.5f;
			float yRender = (an_image.height - hei) * 0.5f;//an_image.height/3;
			float x2Render = an_image.width - xRender;
			float y2Render = (an_image.height - yRender);//Two times height...
			double curve_size = hei;//(y2Render - yRender) * 0.5f;
			
			//Clipping:
			
			//cr.rectangle( xRender, yRender, x2Render, y2Render );
			//cr.rectangle( xRender, yRender, x2Render, y2Render );//y2Render-yRender );
			//cr.clip();
			
			
			
			//Gradient gradient;
			//gradient = g_rae.getGradientFromTheme("Rae.Button");
			//gradient = getGradient("Rae.WindowHeader.Top");
					
			//scope Pattern linear = Pattern.createLinear( xRender, yRender, xRender, yRender + hei );//(0.0, 0.0, 0.0, 20.0) );
			//ColourStop last_colourstop;
			/*
			foreach( ColourStop colstop; gradient )
			{
				//We store the last colourstop:
				last_colourstop = colstop;
			
				//BGRA
				//I checked, and with the current settings the cairo images
				//are BGRA and not RGBA. That's why I found it easiest to just
				//swap the order here, in the drawing phase:
			
				//linear.addColorStopRgba( colstop.position, colstop.colour.r, colstop.colour.g, colstop.colour.b, colstop.colour.a );
				linear.addColorStopRgba( colstop.position, colstop.colour.b, colstop.colour.g, colstop.colour.r, colstop.colour.a );
			}
			*/
	
			/*if( is_top == true )
			{
				cr.setSource( linear );
			}
			else
			{
				//cr.setSourceRgba(last_colourstop.colour.b, last_colourstop.colour.g, last_colourstop.colour.r, last_colourstop.colour.a);
				cr.translate(0.0f, -hei);
			}
			*/
			
			float[] set_colour = getColourArray("Rae.ResizeButton");
			cr.setSourceRgba(set_colour[2], set_colour[1], set_colour[0], set_colour[3]);
			
			/*
			cr.moveTo(xRender, yRender + curve_size);//up-left, lowerpoint
						cr.curveTo(xRender, yRender + curve_size, xRender, yRender, xRender + curve_size, yRender);//up-left, upperpoint
						cr.lineTo(x2Render - curve_size, yRender);//up-right, upperpoint
						cr.curveTo(x2Render - curve_size, yRender, x2Render, yRender, x2Render, yRender + curve_size);//up-right, lowerpoint
						cr.lineTo(x2Render, y2Render - curve_size);//down-right, upperpoint
						cr.curveTo(x2Render, y2Render - curve_size, x2Render, y2Render, x2Render - curve_size, y2Render);//down-right, lowerpoint
						cr.lineTo(xRender + curve_size, y2Render);//down-left, lowerpoint
						cr.curveTo(xRender + curve_size, y2Render, xRender, y2Render, xRender, y2Render - curve_size);//down-left, upperpoint
						cr.lineTo(xRender, yRender + curve_size);//up-left, lowerpoint
			*/
			cr.moveTo(x2Render, yRender);//up-right.
				cr.curveTo(x2Render, yRender, x2Render, y2Render, xRender, y2Render);
				cr.curveTo(xRender, y2Render, xRender, yRender, x2Render, yRender);
			cr.fillPreserve();
				
				Colour outline_colour = getColour("Rae.ResizeButton.outline");
				if( outline_colour.a != 0.0f )
				{
					//cr.setSourceRgba(0.24, 0.24, 0.24, 1.0);
					cr.setSourceRgba( outline_colour.r, outline_colour.g, outline_colour.b, outline_colour.a );
					cr.stroke();
				}
				
		cr.restore();
		
		cr.destroy();
		imageSurface.destroy();
		}
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
