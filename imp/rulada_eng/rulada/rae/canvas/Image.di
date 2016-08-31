/*
 * This file is part of Rae.
 *
 * Rae is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * Rae is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Rae; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * The functions boxBlur() and fastBlur() were taken from librsvg-2.15.90
 * rsvg-filter.c and are Copyright (C) 2004 Caleb Moore.
 * Author: Caleb Moore <c.moore@student.unsw.edu.au>
 * They are licenced as LGPL.
 */

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

module rae.canvas.Image;

import tango.util.log.Trace;//Thread safe console output.
import tango.math.Math;
import tango.math.Random;
import tango.io.File;
import tango.io.FileConduit;
import tango.io.FilePath;
import tango.core.Thread;
import stringz = tango.stdc.stringz;
import tango.stdc.string;//strcpy

version(noLodePng) {}
else
{
import lodepng.Decode;
import lodepng.Encode;
}

//import freeimage.freeimage;
//...Yes I've tried them all!

version(graphicsmagick)
{
	import Mag = magick.api;
}

version(pangocairo)
{
import gtkD.cairo.Surface;
import gtkD.cairo.ImageSurface;
}

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
	import rae.canvas.util.GLExtensions;
}
version(glfw)
{
public import gl.gl;
public import gl.glu;
public import gl.glext;
}
*/

public import rae.gl.gl;
public import rae.gl.glu;
public import rae.gl.glext;
import rae.gl.util;

import rae.core.IRaeMain;
import rae.core.globals;

import Noise = rae.canvas.PerlinNoise;
import rae.canvas.Draw;
import rae.canvas.Gradient;

public import rae.canvas.AlignType;

import rae.utils.Memory;

/*enum
{
	GL_TEXTURE_RECTANGLE_ARB = 1602
}*/




class Image
{
public:
	
	enum
	{
		EMPTY,
		FBO, //Framebuffer object
		FILE,
		STATIC,
		ROUND,
		ROUND_SALMIAC,
		GRADIENT,
		GRADIENT_2,
		GRADIENT_2_VERTICAL,
		GRADIENT_3,
		NOISE,
		NOISE_GLASS,
		NOISE_3,
		CHECKERBOARD,
		RGB_TEST,
		TWO_K_TEST
	}
	
	int type = EMPTY;
	
	this()
	{
		debug(Image) Trace.formatln("Image.this() START and END.");
		//m_id = used_id;
		//used_id++;
	}
	
	this(char[] filename)
	{
		version(graphicsmagick)
		{
			load(filename);
		}
		else
		{
			generator(ROUND, 256, 256);
	
			type = FILE;
			//this();
			//loadGLTexture(filename);
			if( doesFileExist(filename) == true ) 
			{
				load(filename);
			//some how lock this image.
			/*
			loadThread = new Thread( { loadPng(filename); } );
			loadThread.start();
			*/
			}
		}
	}
	
	//protected Thread loadThread;
	
	this(uint set_type)
	{
		type = set_type;
		this();

		switch(type)
		{
			case FBO:
				initFramebufferObject();
			break;
			case FILE:
			break;
			case TWO_K_TEST:
				//init(2048, 1240, 3);
				init(2048, 1240, 3);
				//fillRandom();
				fillRGBQuad();
				createTexture(GL_TEXTURE_RECTANGLE_ARB);
				//glTextureType = GL_TEXTURE_RECTANGLE_ARB;
				//minFilter = GL_NEAREST;
				//magFilter = GL_NEAREST;
				//generator(RGB_TEST, 2048, 1240);
			break;
			default:
				generator(type, 64, 64);
			break;
		}
	}
	
	this(uint set_width, uint set_height, uint set_channels )
	{
		init(set_width, set_height, set_channels );
	}
	
	~this()
	{
		if( type == FBO )
			deleteFramebufferObject();
		else
			cleanUpTexture();
			
		freeImageData();
	}
	
	void init(uint set_width, uint set_height, uint set_channels )
	{
		debug(Image) Trace.formatln("Image.init(width, height, channels) START.");
		debug(Image) scope(exit) Trace.formatln("Image.init(width, height, channels) END.");
		width = set_width;
		height = set_height;
		channels = set_channels;
		//imageData = new ubyte[width*height*channels];
		allocateImageData();
		
		//Now you'll have to draw something into this one, 
		//and then call createTexture().
	}
	
	void allocateImageData()
	{
		if( imageData is null )
			imageData.alloc(width*height*channels);
		else imageData.realloc(width*height*channels);
	}
	
	//Hmm. Currently this is just the same allocateImageData().
	void reallocateImageData()
	{
		if( imageData is null )
			imageData.alloc(width*height*channels);
		else imageData.realloc(width*height*channels);
	}
	
	void freeImageData()
	{
		/*if(imageData !is null)
		{
			delete imageData;
		}*/
		
		if( imageData !is null )
			imageData.free();
	}
	
	
	protected bool isGenTextures = false;
	
	protected void cleanUpTexture()
	{
		if( isGenTextures == true )
		{
			glDeleteTextures(1, &m_id);
			isGenTextures = false;
		}	
	}
	
	void initFramebufferObject()
	{
		//width = 1280;
		//height = 800;
		width = g_rae.screenWidthP;
		height = g_rae.screenHeightP;
		channels = 4;
	
		isPixelPerPixel = true;
	
		glTextureType = GL_TEXTURE_RECTANGLE_ARB;
		minFilter = GL_NEAREST;
		magFilter = GL_NEAREST;
	
		glGenFramebuffersEXT(1, &fbo);
		glGenTextures(1, &m_id);
		isGenTextures = true;
		//We don't need depth buffer:
		//glGenRenderbuffersEXT(1, &depth_rb);
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fbo);
		
		//initialize texture
		glBindTexture(glTextureType, id);
		glTexImage2D(glTextureType, 0, texInternalFormat, width, height, 0, 
								GL_RGBA, GL_FLOAT, null);
								
		glTexParameterf(glTextureType, GL_TEXTURE_MIN_FILTER, minFilter);
		glTexParameterf(glTextureType, GL_TEXTURE_MAG_FILTER, magFilter);
		glTexParameterf(glTextureType, GL_TEXTURE_WRAP_S, GL_REPEAT );//GL_CLAMP_TO_EDGE);
		glTexParameterf(glTextureType, GL_TEXTURE_WRAP_T, GL_REPEAT );//GL_CLAMP_TO_EDGE);

		glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, 
															glTextureType, id, 0);
															
		// initialize depth renderbuffer
		//glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, depth_rb);
		//glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, GL_DEPTH_COMPONENT24, texWidth, texHeight);
		//glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT, 
		//														GL_RENDERBUFFER_EXT, depth_rb);
		
		checkFramebufferStatus();
		
		//Bind nothing in the end.
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
	}

	void deleteFramebufferObject()
	{
			//glDeleteRenderbuffersEXT(1, &depth_rb);
			glDeleteTextures(1, &m_id);
			glDeleteFramebuffersEXT(1, &fbo);
	}

	void checkFramebufferStatus()
	{
			GLenum status = cast(GLenum) glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT);
			switch(status)
			{
					case GL_FRAMEBUFFER_COMPLETE_EXT:
					break;
					case GL_FRAMEBUFFER_UNSUPPORTED_EXT:
							Trace.formatln("Unsupported framebuffer format.");
					break;
					case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT_EXT:
							Trace.formatln("Framebuffer incomplete, missing attachment.");
					break;
					case GL_FRAMEBUFFER_INCOMPLETE_DUPLICATE_ATTACHMENT_EXT:
							Trace.formatln("Framebuffer incomplete, duplicate attachment.");
					break;
					case GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS_EXT:
							Trace.formatln("Framebuffer incomplete, attached images must have same dimensions.");
					break;
					case GL_FRAMEBUFFER_INCOMPLETE_FORMATS_EXT:
							Trace.formatln("Framebuffer incomplete, attached images must have same format.");
					break;
					case GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER_EXT:
							Trace.formatln("Framebuffer incomplete, missing draw buffer.");
					break;
					case GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER_EXT:
							Trace.formatln("Framebuffer incomplete, missing read buffer.");
					break;
					default:
						Trace.formatln("Unknown error occurred while initializing framebuffer object.");
							assert(0);
					break;
			}
	}
	
	float sx1;
	float sy1;
	float sx2;
	float sy2;
	float sw;
	float sh;
	
	float rw;
	float rh;
	
	void bounds(float tx1, float ty1, float tx2, float ty2)
	{
		sx1 = tx1;
		sy1 = ty1;
		sx2 = tx2;
		sy2 = ty2;
		sw = sx2 - sx1;
		sh = sy2 - sy1;
	}
 
	void pushFramebufferObject()//float sx, float sy, float sw, float sh)
	{
		glBindTexture(glTextureType, 0);
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fbo);
		
				glPushAttrib(GL_VIEWPORT_BIT); 
				//glViewport(0, 0, width, height);
				
				/*
				GLsizei vx = -cast(GLsizei)(screenWidth-w)/2;
				GLsizei vy = -cast(GLsizei)(screenHeight-h)/2;
				GLsizei vw = cast(GLsizei)screenWidth;
				GLsizei vh = cast(GLsizei)screenHeight;
				*/
				
				//Trace.formatln("rw: {}", cast(double) rw);
				//Trace.formatln("rh: {}", cast(double) rh);
				
				//rw = floor(rw);
				//rh = floor(rh);
				
				float roundx = ((g_rae.screenWidthP-rw)/2.0f);
				float roundy = ((g_rae.screenHeightP-rh)/2.0f);
				int inroux = cast(int) roundx;
				int inrouy = cast(int) roundy;
				
				//AAAAARGHHH!
				
				/*if( (roundx - cast(float)inroux) > 0.0f )
					inroux++;
				if( (roundy - cast(float)inrouy) > 0.0f )
					inrouy++;*/
				
				GLsizei vx = -cast(GLsizei)inroux;
				GLsizei vy = -cast(GLsizei)inrouy;
				GLsizei vw = cast(GLsizei)g_rae.screenWidthP;
				GLsizei vh = cast(GLsizei)g_rae.screenHeightP;
				
				/*
				Trace.formatln("vx: {}", cast(double) vx);
				Trace.formatln("vy: {}", cast(double) vy);
				Trace.formatln("vw: {}", cast(double) vw);
				Trace.formatln("vh: {}", cast(double) vh);
				*/
				glViewport(vx, vy, vw, vh);
				
				//glMatrixMode(GL_MODELVIEW);
				glPushMatrix();
				glLoadIdentity();
				
				//glScalef(1.0f, -1.0f, 1.0f);//Make Y-axis point down.
				glFrontFace(GL_CW);
				
				glTranslatef(0.0f, 0.0f, -1.0f);//Let's go one unit backwards in the Z-axis to see stuff
				//and to let the objects lie in the 0.0 z-plane.
				
				//glClearColor(0, 0, 0, 0);
				glClear(GL_COLOR_BUFFER_BIT );// | GL_DEPTH_BUFFER_BIT);
	}
	
	void popFramebufferObject()
	{
				glPopMatrix();
				glPopAttrib();
				glFrontFace(GL_CCW);
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
	}
	
	

	GLuint fbo;

	GLenum texInternalFormat = GL_RGBA8;
	//GLenum texTarget = GL_TEXTURE_2D;//or GL_TEXTURE_RECTANGLE_ARB
	//GLenum filterMode = GL_NEAREST; //GL_LINEAR;

	//static GLuint used_id;
	
	uint id() { return m_id; }
	uint m_id;
	
	public uint width() { return m_width; }
	public uint width(uint set) { return m_width = set; }
	protected uint m_width = 0;
	public uint height() { return m_height; }
	public uint height(uint set) { return m_height = set; }
	protected uint m_height = 0;
	
	public uint channels() { return m_channels; }
	public uint channels(uint set) { return m_channels = set; }
	protected uint m_channels = 0;


	//For texture coordinates 0.0-1.0
	//such as in GL_TEXTURE_2D
	public float texCoordOneLeft() { return leftCropPercent; }
	public float texCoordOneTop() { return topCropPercent; }
	public float texCoordOneRight() { return 1.0f - rightCropPercent; }
	public float texCoordOneBottom() { return 1.0f - bottomCropPercent; }
	
	//For texture coordinates 0.0-width
	//such as in GL_TEXTURE_RECTANGLE_ARB
	public float texCoordLeft() { return cast(float)leftCrop; }
	public float texCoordTop() { return cast(float)topCrop; }
	public float texCoordRight() { return cast(float)(width - rightCrop); }
	public float texCoordBottom() { return cast(float)(height - bottomCrop); }

	//These give the height and width of the texture
	//with the cropping applied.
	public float croppedWidth() { return width*(1.0f-(leftCropPercent+rightCropPercent)); }
	public float croppedHeight() { return height*(1.0f-(topCropPercent+bottomCropPercent)); }

	//Cropping:
	
	/*
	///This is a way to do letterboxing.
	///Just give this method an aspectratio e.g. 2.35f or 1.3333333f
	///and it will adjust the cropping parameters to make a letterboxed picture
	///of that. The cropping is achieved internally by manipulating the
	///OpenGL texture coordinates.
	public void aspectCrop(float set)
	{
		float cur_aspect = cast(float)width / cast(float)height;
		if( set > cur_aspect )
		{
			uint height_crop = height - (cast(float)width * (1.0f/set));
			
		}
	}
	*/
	public float topCropPercent() { return (cast(float)m_topCrop) / (cast(float)m_height); }
	public void topCropPercent(float set) { topCrop = cast(uint)(m_height * set); }
	public uint topCrop() { return m_topCrop; }
	public uint topCrop(uint set) { return m_topCrop = set; }
	protected uint m_topCrop = 0;
	
	public float bottomCropPercent() { return (cast(float)m_bottomCrop) / (cast(float)m_height); }
	public void bottomCropPercent(float set) { bottomCrop = cast(uint)(m_height * set); }
	public uint bottomCrop() { return m_bottomCrop; }
	public uint bottomCrop(uint set) { return m_bottomCrop = set; }
	protected uint m_bottomCrop = 0;
	
	public float leftCropPercent() { return (cast(float)m_leftCrop) / (cast(float)m_height); }
	public void leftCropPercent(float set) { leftCrop = cast(uint)(m_width * set); }
	public uint leftCrop() { return m_leftCrop; }
	public uint leftCrop(uint set) { return m_leftCrop = set; }
	protected uint m_leftCrop = 0;
	
	public float rightCropPercent() { return (cast(float)m_rightCrop) / (cast(float)m_height); }
	public void rightCropPercent(float set) { rightCrop = cast(uint)(m_width * set); }
	public uint rightCrop() { return m_rightCrop; }
	public uint rightCrop(uint set) { return m_rightCrop = set; }
	protected uint m_rightCrop = 0;
	

	char[] name = "empty";
	float zoomKey = 1.0f;//This is the set_height key in Theme.
	int userCount = 0;
	
	ubyte[] imageData;
	
	public bool isTextureCoordsOne()
	{
		if( glTextureType == GL_TEXTURE_2D )
		{
			return true;
		}
		else return false;
	}
	
	//This at the moment has effect on GL_TEXTURE_RECTANGLE_ARB
	//textures, and defines if they are drawn pixelperpixel, or
	//according to the size of the rectangle they are in.
	public bool isPixelPerPixel() { return m_isPixelPerPixel; }
	public bool isPixelPerPixel(bool set) { return m_isPixelPerPixel = set; }
	protected bool m_isPixelPerPixel = false;
	
	protected uint m_glTextureType = GL_TEXTURE_2D;
	public uint glTextureType(uint set){ return m_glTextureType = set; }
	public uint glTextureType(){ return m_glTextureType; }
	
	protected uint m_magFilter = GL_LINEAR;
	public uint magFilter(uint set){ return m_magFilter = set; }
	public uint magFilter(){ return m_magFilter; }
	
	protected uint m_minFilter = GL_LINEAR;
	public uint minFilter(uint set){ return m_minFilter = set; }
	public uint minFilter(){ return m_minFilter; }
	
	public void isFilterModeNearest( bool set )
	{
		if( set == true )
			magFilter = GL_NEAREST;
		else
			magFilter = GL_LINEAR;
		updateFilterMode();
	}
	public bool isFilterModeNearest()
	{
		if( magFilter == GL_NEAREST )
			return true;
		//else
			return false;
	}
	
	void updateFilterMode()
	{
		glBindTexture(glTextureType, m_id );//textures[0]);
		glTexParameteri(glTextureType, GL_TEXTURE_MAG_FILTER, magFilter);
		glTexParameteri(glTextureType, GL_TEXTURE_MIN_FILTER, minFilter);
	}
	
	
	//Usually GL_UNSIGNED_BYTE
	//and sometimes GL_UNSIGNED_INT_10_10_10_2_EXT
	public uint dataType() { return m_dataType; }
	public uint dataType(uint set) { return m_dataType = set; }
	protected uint m_dataType = GL_UNSIGNED_BYTE;
	
	public uint internalFormat() { return m_internalFormat; }
	public uint internalFormat(uint set) { return m_internalFormat = set; }
	protected uint m_internalFormat = GL_RGBA;
	
	//One of GL_RGBA, GL_RGB, GL_LUMINANCE or GL_ALPHA. or GL_INTENSITY...?
	public uint colourFormat() { return m_colourFormat; }
	public uint colourFormat(uint set) { return m_colourFormat = set; }
	protected uint m_colourFormat = GL_RGBA;
	
	//Also sets internalFormat.
	//protected 
	uint setColourFormatFromChannels()
	{
		if( channels == 4 )
		{
			internalFormat = GL_RGBA;
			return colourFormat(GL_RGBA);
		}
		else if( channels == 3 )
		{
			internalFormat = GL_RGB;
			return colourFormat(GL_RGB);
		}
		//else if( channels == 1 )
		//{
		//}
		
		internalFormat = GL_LUMINANCE;
		return colourFormat(GL_LUMINANCE);//GL_ALPHA is missing in this scenario.
		//Maybe you'll have to set it yourself.
	}
	
	//TODO maybe we put these to be in the
	//Rectangle????
	//public uint blendSource = GL_SRC_ALPHA;
	//public uint blendDestination = GL_ONE;
	
	//This is the ones we used to have, but they didn't work so well:
	//public uint blendSource = GL_SRC_ALPHA;
	//public uint blendDestination = GL_ONE_MINUS_SRC_ALPHA;//Normal
	//public uint blendDestination = GL_ONE;//transparent blacks for luminance textures.
	
	//Interesting pair:
	//public uint blendSource = GL_DST_ALPHA; //or 
	public uint blendSource = GL_ONE;
	//public uint blendDestination = GL_ONE_MINUS_SRC_COLOR;
	public uint blendDestination = GL_ONE_MINUS_SRC_ALPHA;
	
	public uint texEnvMode = GL_MODULATE;
	//public uint texEnvMode = GL_REPLACE;
	//texEnvMode can be GL_MODULATE, GL_DECAL, GL_BLEND or GL_REPLACE.
	
	public bool isBlending = true;
	///Set this before creating the OpenGL texture.
	///Automatically set to false if using GL_TEXTURE_RECTANGLE_ARB
	///by createGLTexture.
	public bool isMipmapping = true;
	
	void pushTexture()
	{
		//glEnable( GL_TEXTURE_2D );
		//glBindTexture(GL_TEXTURE_2D, m_id);
		glEnable( glTextureType );
		glBindTexture( glTextureType, m_id );
		
		glTexEnvf (GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, texEnvMode );
		
		//GLfloat[4] environmentColor = [ 1.0f, 1.0f, 1.0f, 1.0f ];
		GLfloat[4] environmentColor = [ 0.0f, 0.0f, 0.0f, 1.0f ];
		glTexEnvfv( GL_TEXTURE_ENV, GL_TEXTURE_ENV_COLOR, environmentColor.ptr );
		
		if( isBlending == false )
			glDisable(GL_BLEND);
		
		glBlendFunc( blendSource, blendDestination );
	}
	
	void popTexture()
	{
		//glDisable( GL_TEXTURE_2D );
		glDisable( glTextureType );
		
		if( isBlending == false )
			glEnable(GL_BLEND);
		
		//TEMP: return to normal.
		//TODO make better. Possibly use DOG for OpenGL binding and state tracking.
		glTexEnvf (GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE );
		glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
	}
	
	/*void generateStatic()
	{
		m_id = used_id;
		used_id++;
		
		width = 256;
		height = 256;
		
		scope ubyte[] image = new ubyte[(width*height)*3];
		
		for( uint i = 0; i < width; i++ )
		{
			for( uint j = 0; j < height; j++ )
			{
				uint ran = random.next(256);
				Stdout("ran: ")(ran).newline;
				image[(i*width*3) + (j*3) + 0] = ran;
				image[(i*width*3) + (j*3) + 1] = ran;
				image[(i*width*3) + (j*3) + 2] = ran;
			}
		}
		
		//assert(0);
		
		// Create The Texture
		glGenTextures(1, &m_id );
		// Create MipMapped Texture
		glBindTexture(GL_TEXTURE_2D, id );//textures[0]);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);
		gluBuild2DMipmaps(GL_TEXTURE_2D, 3, width, height, GL_RGB,
						GL_UNSIGNED_BYTE, image.ptr);
		
	}*/
	
	void fillRandom()
	{
		if( imageData !is null )
		{
			int red_val = 0;
			int green_val = 0;
			int blue_val = 0;
			int alpha_val = 255;
			for( uint i = 0; i < height; i++ )
			{
				for( uint j = 0; j < width; j++ )
				{
					if( channels >= 1 )//if we have atleast one channel.
					{
						float testi = Noise.noise( cast(float)i/252.273, cast(float)j/251.34789 );
						testi = (testi + 0.5f) * 255.0f;
						red_val = cast(uint)testi;
						imageData[(i*width*channels) + (j*channels) + 0] = red_val;
					}
					
					if( channels >= 3 )//if we also have green and blue channels...
					{
						float testi = Noise.noise( cast(float)i/25.273, cast(float)j/251.789 );
						testi = (testi + 0.5f) * 255.0f;
						green_val = cast(uint)testi;
						
						float testi2 = Noise.noise( cast(float)i/52.273, cast(float)j/51.34789 );
						testi2 = (testi2 + 0.5f) * 255.0f;
						blue_val = cast(uint)testi2;
						
						imageData[(i*width*channels) + (j*channels) + 1] = green_val;
						imageData[(i*width*channels) + (j*channels) + 2] = blue_val;
					}
					
					if( channels >= 4 )//if there's an alpha channel too.
					{
						imageData[(i*width*channels) + (j*channels) + 3] = alpha_val;
					}
					
						
				}
			}
		}
	}
	
	void fillRGBQuad()
	{
		if( imageData !is null )
		{
			int red_val = 0;
			int green_val = 0;
			int blue_val = 0;
			int alpha_val = 255;
			
			for( uint i = 0; i < height; i++ )
			{
				for( uint j = 0; j < width; j++ )
				{
					if( channels >= 3 )
					{
						red_val = 0;
						green_val = 0;
						blue_val = 0;
						
						if( i < (height / 2) )
						{
							if( j < (width / 3) )
								red_val = 255;
							else if( j < ((width / 3)*2) )
								green_val = 255;
							else //if( j < ((width / 3)*3) )
								blue_val = 255;
						}
						else
						{
							if( j < (width / 3) )
								green_val = 255;
							else if( j < ((width / 3)*2) )
								blue_val = 255;
							else //if( j < ((width / 3)*3) )
								red_val = 255;
						}
						
						imageData[(i*width*channels) + (j*channels) + 0] = red_val;
						imageData[(i*width*channels) + (j*channels) + 1] = green_val;
						imageData[(i*width*channels) + (j*channels) + 2] = blue_val;
					}
					
					if( channels >= 4 )//if there's an alpha channel too.
					{
						imageData[(i*width*channels) + (j*channels) + 3] = alpha_val;
					}
					
						
				}
			}
		}
	}
	
	void fill( Gradient gradient )
	{
		if( imageData !is null )
		{
			float[] grad_result;
			int red_val = 0;
			int green_val = 0;
			int blue_val = 0;
			int alpha_val = 0;
			
			for( uint i = 0; i < height; i++ )
			{
				grad_result = gradient.get( cast(float)i/cast(float)height );
				red_val = cast(uint)(255.0f * grad_result[0]);
				green_val = cast(uint)(255.0f * grad_result[1]);
				blue_val = cast(uint)(255.0f * grad_result[2]);
				alpha_val = cast(uint)(255.0f * grad_result[3]);
					
				for( uint j = 0; j < width; j++ )
				{
					if( channels >= 1 )//if we have atleast one channel.
					{
						imageData[(i*width*channels) + (j*channels) + 0] = red_val;
					}
					
					if( channels >= 3 )//if we also have green and blue channels...
					{
						imageData[(i*width*channels) + (j*channels) + 1] = green_val;
						imageData[(i*width*channels) + (j*channels) + 2] = blue_val;
					}
					
					if( channels >= 4 )//if there's an alpha channel too.
					{
						imageData[(i*width*channels) + (j*channels) + 3] = alpha_val;
					}
				}
			}
		}
	}
	
	void generator(uint type, uint set_width, uint set_height )
	{
		debug(Image) Trace.formatln("Image.generator() START.");
		debug(Image) scope(exit) Trace.formatln("Image.generator() END.");
		
		bool type_is_rgb = false;
		
		//HEHE. TODO.
		width = set_height;
		height = set_width;
		channels = 3;
		allocateImageData();
		//scope ubyte[] image = new ubyte[(width*height)*3];
		
		uint igrad = width / 2;
		
		Gradient gradient;
		float[] grad_result;
		
		if( type == GRADIENT_2 || type == GRADIENT_2_VERTICAL )
		{
			gradient = g_rae.getGradientFromTheme("Image.GRADIENT_2");
		
			//Trace.formatln("GRADIENT_2. creating gradient.");
			/*
			gradient = new Gradient();
			
			gradient.add( 0.0f, 224.0f/255.0f, 224.0f/255.0f, 224.0f/255.0f, 1.0f );
			gradient.add( 0.35f, 224.0f/255.0f, 224.0f/255.0f, 224.0f/255.0f, 1.0f );
			gradient.add( 0.66f, 190.0f/255.0f, 190.0f/255.0f, 190.0f/255.0f, 1.0f );
			gradient.add( 1.0f, 190.0f/255.0f, 190.0f/255.0f, 190.0f/255.0f, 1.0f );
			*/
			
			//This is a bit lighter version:
			/*
			gradient.add( 0.0f, 224.0f/255.0f, 224.0f/255.0f, 224.0f/255.0f, 1.0f );
			gradient.add( 0.35f, 224.0f/255.0f, 224.0f/255.0f, 224.0f/255.0f, 1.0f );
			gradient.add( 0.66f, 120.0f/255.0f, 120.0f/255.0f, 120.0f/255.0f, 1.0f );
			gradient.add( 1.0f, 120.0f/255.0f, 120.0f/255.0f, 120.0f/255.0f, 1.0f );
			*/
			
			//And this is almost pitch black, I hope...
			/*
			gradient.add( 0.0f, 224.0f/255.0f, 224.0f/255.0f, 224.0f/255.0f, 1.0f );
			gradient.add( 0.35f, 224.0f/255.0f, 224.0f/255.0f, 224.0f/255.0f, 1.0f );
			gradient.add( 0.66f, 0.0f/255.0f, 0.0f/255.0f, 0.0f/255.0f, 1.0f );
			gradient.add( 1.0f, 0.0f/255.0f, 0.0f/255.0f, 0.0f/255.0f, 1.0f );
			*/
			
		}
		else if( type == GRADIENT_3 )
		{
			gradient = new Gradient();
			gradient.add( 0.0f, 139.0f/255.0f, 213.0f/255.0f, 172.0f/255.0f, 1.0f );
			gradient.add( 0.26f, 58.0f/255.0f, 152.0f/255.0f, 50.0f/255.0f, 1.0f );
			gradient.add( 0.43f, 40.0f/255.0f, 113.0f/255.0f, 35.0f/255.0f, 1.0f );
			gradient.add( 0.5f, 49.0f/255.0f, 107.0f/255.0f, 45.0f/255.0f, 1.0f );
			gradient.add( 0.64f, 80.0f/255.0f, 122.0f/255.0f, 50.0f/255.0f, 1.0f );
			gradient.add( 0.71f, 67.0f/255.0f, 111.0f/255.0f, 42.0f/255.0f, 1.0f );
			gradient.add( 1.0f, 24.0f/255.0f, 41.0f/255.0f, 12.0f/255.0f, 1.0f );
		}
		
		int varia = 0;
		
		int red_val = 0;
		int green_val = 0;
		int blue_val = 0;
		
		for( uint i = 0; i < width; i++ )
		{
			if( type == CHECKERBOARD )
			{
				if( varia == 0 ) varia = 250;
				else varia = 0;
			}
		
			for( uint j = 0; j < height; j++ )
			{
				//progress=progress+0.0001f;
				//showProgress(progress);
			
				int ran = 0;
				int ran1 = 0;
				int ran2 = 0;
				//uint ran = random.next(256);
				
				//Round gradient:
				//uint ran = cast(uint)((sin(PI * (cast(float)i/cast(float)width)) +
				//			sin(PI * (cast(float)j/cast(float)height))) * 255.0f/2.0);
				switch(type)
				{
					case STATIC:
						//ran = random.next(256);
						//ran = Random.shared.next(256);
						ran = 128;
						//Stdout("ran: ")(ran).newline;
						imageData[(i*width*3) + (j*3) + 0] = ran;
						imageData[(i*width*3) + (j*3) + 1] = ran;
						imageData[(i*width*3) + (j*3) + 2] = ran;
					break;
					default:
					case ROUND:
						ran = cast(uint)((sin(PI * (((cast(float)i - (width/4.0))*2.0f)/cast(float)width)) +
							sin(PI * (((cast(float)j - (height/4.0))*2.0f)/cast(float)height))) * 255.0f/2.0);
						if( ran > 254 ) ran = 0;
						if( ran < 0 ) ran = 0;
					break;
					case ROUND_SALMIAC:
						ran = cast(uint)((sin(PI * (((cast(float)i)*2.0f)/cast(float)width)) +
							sin(PI * (((cast(float)j)*2.0f)/cast(float)height))) * 255.0f/2.0);
						if( ran > 255 ) ran = 255;
					break;
					case GRADIENT:
						igrad = i;
						if( igrad >= (width/2) )
						{
							igrad = width - igrad;
						}
						ran = cast(uint)((cast(float)igrad / width) * 700.0f);
						if( ran > 255 ) ran = 255;
					break;
					case GRADIENT_2:
					/+
						if( i < (width/3.0) )
							igrad = 20;
						else if( i > (width/3.0) && i < (2.0*(width/3.0)) )
							igrad = cast(uint)(i - (width/3.0));
						else if( i > (2.0*(width/3.0)) )
							igrad = cast(uint)(2.0*(width/3.0)) - 150;
						
						/*if( igrad >= (width/2) )
						{
							igrad = width - igrad;
						}*/
						ran = cast(uint)((cast(float)igrad / width) * 500.0f);
						if( ran > 255 ) ran = 255;
					+/
						grad_result = gradient.get( cast(float)i/cast(float)width );
						ran = cast(uint)(255.0f * grad_result[0]);
						
						//assert(i < 3 );
					break;
					case GRADIENT_2_VERTICAL:
						grad_result = gradient.get( cast(float)j/cast(float)height );
						ran = cast(uint)(255.0f * grad_result[0]);
					break;
					case GRADIENT_3:
					grad_result = gradient.get( cast(float)i/cast(float)width );
					ran = cast(uint)(255.0f * grad_result[0]);
					ran1 = cast(uint)(255.0f * grad_result[1]);
					ran2 = cast(uint)(255.0f * grad_result[2]);
						
					imageData[(i*width*3) + (j*3) + 0] = ran;
					imageData[(i*width*3) + (j*3) + 1] = ran1;
					imageData[(i*width*3) + (j*3) + 2] = ran2;
					
					break;
					case NOISE:
						float[2] pos;
						//pos[X] = cast(float)i/111.111f;
						//pos[X] = 0.01f;
						//pos[Y] = cast(float)j/111.111f;
						//Stdout("hmm:")(pos[X]).newline;
						//ran = cast(uint)Noise.noise2d(pos); //* 255.0f/2.0);
						//if( ran > 254 ) ran = 0;
						//ran = cast(uint)Noise.noise( cast(float)i, cast(float)j );
						
						//float testi = Noise.noise(1234.4321f, 4321.1234f);
						//float testi = Noise.noise( cast(float)i/13.5857f, cast(float)j/11.294f );
						float testi = Noise.noise( cast(float)i/10.5857f, cast(float)j/10.294f );
						//Stdout("hmm:")(testi).newline;
						
						testi = (testi + 0.5f) * 255.0f;
						ran = cast(uint)testi;
						
						//Stdout("i:")(i)(" j:")(j)(" ran: ")(ran).newline;
					break;
					case NOISE_GLASS:
						float testi = Noise.noise( cast(float)i/252.273, cast(float)j/251.34789 );
						testi = (testi + 0.5f) * 255.0f;
						ran = cast(uint)testi;
						
					break;
					case NOISE_3:
						float testi = Noise.noise( cast(float)i/252.273, cast(float)j/251.34789, cast(float)i/151.17789 );
						testi = testi + Noise.noise( cast(float)i/152.273, cast(float)j/151.34789 );
						testi = testi - Noise.noise( cast(float)i/552.273, cast(float)j/551.34789 );
						
						
						float testi2 = Noise.noise( cast(float)i/52.273, cast(float)j/51.34789, cast(float)i/51.17789 );
						testi = sin( testi * PI );
						float testi3 = Noise.noise( testi, testi2 );
						
						testi = (testi3 + 0.5f) * 255.0f;
						ran = cast(uint)testi;
						
					break;
					case CHECKERBOARD:
						
						/*if( i % 2 )
						{
							if( varia == 0 ) varia = 250;
							else varia = 0;
						}
						else
						{
							if( varia == 0 ) varia = 250;
							else varia = 0;
						}*/
											
					
						if( varia == 0 )
						{
							varia = 250;
							//Trace.formatln("varia to 250: {}", cast(double)varia);
						}
						else if( varia == 250 )
						{
							varia = 0;
							//Trace.formatln("varia to 0: {}", cast(double)varia);
						}
						//else Trace.formatln("varia NOT CHANGED.: {}", cast(double)varia);
						
						ran = varia;
					break;
					case RGB_TEST:
						type_is_rgb = true;//This is pretty awkward setting this each time.
						//I think all types should be RGB. So, TODO change all the other ran's
						//to be red_val, green_val, blue_val.
						
						if( j < (width / 3) )
						{
							red_val = 255;
							green_val = 0;
							blue_val = 0;
						}
						else if( j < ((width / 3)*2) )
						{
							red_val = 0;
							green_val = 255;
							blue_val = 0;
						}
						else //if( j < ((width / 3)*3) )
						{
							red_val = 0;
							green_val = 0;
							blue_val = 255;
						}
					break;
				}
				
				
				if( type != GRADIENT_3 && type_is_rgb == false )
				{
					//Stdout("i:")(i)(" j:")(j)(" ran: ")(ran).newline;
					imageData[(i*width*3) + (j*3) + 0] = ran;
					imageData[(i*width*3) + (j*3) + 1] = ran;
					imageData[(i*width*3) + (j*3) + 2] = ran;
				}
				else if( type_is_rgb == true )
				{
					//Trace.formatln("i:{} j:{} r:{} g:{} b:{}", i, j, red_val, green_val, blue_val );
					imageData[(i*width*3) + (j*3) + 0] = red_val;
					imageData[(i*width*3) + (j*3) + 1] = green_val;
					imageData[(i*width*3) + (j*3) + 2] = blue_val;
				}
				
				
				//Stdout("i:")(i)(" j:")(j)(" image: ")(image[(i*width*3) + (j*3) + 0]).newline;
			}
		}
		
		//After effects:
		switch(type)
		{
			default:
			break;
			case NOISE_GLASS:
				levelsAutoBlack();
			break;
			//case GRADIENT_2:
			//	invert(image);
			//break;
		}
		
		//assert(0);
		
		//glTextureType = GL_TEXTURE_RECTANGLE_ARB;
		
		//createTextureFromData( image, width, height, 3, glTextureType );
		createTextureFromData( width, height, 3, glTextureType );
	}
	
		
	///Create a new mipmaplevel for OpenGL.
	///calling addMipMapLevel without an Image argument will create the selected level from this image.
	///Usually that would be the 0 level.
	void addMipMapLevel( uint set_mipmap_level, Image from_image = null )
	{
		Trace.formatln("Image.addMipMapLevel() START. set_mipmap_level: {}", set_mipmap_level );
		scope(exit) Trace.formatln("Image.addMipMapLevel() END.");
		
		if( from_image is null )
		{
			Trace.formatln("Image.addMipMapLevel() from_image is null route.");
		
			cleanUpTexture();
		
			glTextureType = GL_TEXTURE_2D;
			
			//minFilter = GL_NEAREST; //nearest-neighbour
			//minFilter = GL_LINEAR; //too soft.
			//minFilter = GL_LINEAR_MIPMAP_NEAREST; //looks quite bad.
			minFilter = GL_LINEAR_MIPMAP_LINEAR; //quite soft. But somehow better.
			
			magFilter = GL_NEAREST;
			//magFilter = GL_LINEAR;
			
			// Create The Texture
			glGenTextures(1, &m_id );
			isGenTextures = true;
			// Create MipMapped Texture
			glBindTexture(glTextureType, m_id );//textures[0]);
			
			glTexParameteri(glTextureType, GL_TEXTURE_MAG_FILTER, magFilter);
			//glTexParameteri(glTextureType, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);
			glTexParameteri(glTextureType, GL_TEXTURE_MIN_FILTER, minFilter);
			
			//GL_EXT_texture_filter_anisotropic:
			/*
			float maximumAnisotropy;
			glGetFloatv(GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT, &maximumAnisotropy);
			glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAX_ANISOTROPY_EXT, maximumAnisotropy);
			
			glTexEnvf (GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, texEnvMode );//GL_MODULATE);
			*/
			
			//Generate mipmaps:
			//	gluBuild2DMipmaps(glTextureType, channels, width, height, m_format,
			//				GL_UNSIGNED_BYTE, image.ptr);
			//Or generate just one texture:
			
			glTexImage2D(glTextureType,
							set_mipmap_level,//mipmap level
							colourFormat,
							width,
							height,
							0,
							colourFormat,
							dataType,
							imageData.ptr);
							
			return;
		}
		
		//The general case where we use another Image...
		// Create MipMapped Texture
		glBindTexture(glTextureType, m_id );//textures[0]);
		
		glTexParameteri(glTextureType, GL_TEXTURE_MAG_FILTER, magFilter);
		//glTexParameteri(glTextureType, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);
		glTexParameteri(glTextureType, GL_TEXTURE_MIN_FILTER, minFilter);
		
		/*
		//GL_EXT_texture_filter_anisotropic:
		float maximumAnisotropy;
		glGetFloatv(GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT, &maximumAnisotropy);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAX_ANISOTROPY_EXT, maximumAnisotropy);
	
		glTexEnvf (GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, texEnvMode );//GL_MODULATE);
		*/
		//Generate mipmaps:
		//	gluBuild2DMipmaps(glTextureType, channels, width, height, m_format,
		//				GL_UNSIGNED_BYTE, image.ptr);
		//Or generate just one texture:
		
		glTexImage2D(glTextureType,
						set_mipmap_level,//mipmap level
						colourFormat,
						from_image.width,
						from_image.height,
						0,
						colourFormat,
						dataType,
						from_image.imageData.ptr);
	
	}
	
	void useAnisotropicFiltering()
	{
		//possible BUG here if your not careful.
		//glTextureType ... GL_TEXTURE_2D...must be.
		
		glBindTexture(glTextureType, m_id );
	
		//GL_EXT_texture_filter_anisotropic:
		float maximumAnisotropy;
		glGetFloatv(GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT, &maximumAnisotropy);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAX_ANISOTROPY_EXT, maximumAnisotropy);
	}
	
	//void createTextureFromData( ubyte[] image, uint set_width, uint set_height, uint set_channels, uint set_tex_type = GL_TEXTURE_2D, bool set_is_white = true )
	void createTextureFromData( uint set_width, uint set_height, uint set_channels, uint set_tex_type = GL_TEXTURE_2D, bool set_is_white = true )
	{
		debug(Image) Trace.formatln("Image.createTextureFromData() START.");
		debug(Image) scope(exit) Trace.formatln("Image.createTextureFromData() END.");
	
		cleanUpTexture();
		
		//nasty hack.REMOVE this. just use imageData for all.
		//////////imageData = image;
	
		channels = set_channels;
		width = set_width;
		height = set_height;
	
		glTextureType = set_tex_type;//GL_TEXTURE_2D;
		//minFilter = GL_NEAREST; //nearest-neighbour
		//minFilter = GL_LINEAR; //too soft.
		//minFilter = GL_LINEAR_MIPMAP_NEAREST; //looks quite bad.
		minFilter = GL_LINEAR_MIPMAP_LINEAR; //quite soft. But somehow better.
		
		magFilter = GL_NEAREST;
		//magFilter = GL_LINEAR;
	
		if( glTextureType == GL_TEXTURE_RECTANGLE_ARB )
		{
			debug(Image) Trace.formatln("Image.createTextureFromData() glTextureType == GL_TEXTURE_RECTANGLE_ARB.");
			minFilter = GL_LINEAR;//GL_NEAREST;
			magFilter = GL_NEAREST;
		}
	
		setColourFormatFromChannels();
		/*
		if( channels == 1 )
		{
			//set_is_white = false;//force for debugging.
		
			//blendDestination = GL_ONE_MINUS_SRC_ALPHA;//Normal
			if( set_is_white == true )
			{
				//m_format = GL_LUMINANCE;
			
				//blendSource = GL_SRC_ALPHA;
				//blendDestination = GL_ONE;//transparent blacks for luminance textures.
				//blendSource = GL_SRC_COLOR;
				//blendDestination = GL_ONE_MINUS_SRC_COLOR;
			
				//blendSource = GL_DST_ALPHA;
				
				blendSource = GL_ONE;
				blendDestination = GL_ONE_MINUS_SRC_COLOR;
			
				texEnvMode = GL_MODULATE;
			}
			else
			{
				//m_format = GL_ALPHA;
				//m_format = GL_LUMINANCE;
				//m_format = GL_INTENSITY;
				
				//isBlending = false;
				
				blendSource = GL_ZERO;
				blendDestination = GL_SRC_COLOR;
				
				//blendSource = GL_SRC_ALPHA;
				//blendDestination = GL_ZERO;
				//blendDestination = GL_ONE;
				//blendSource = GL_SRC_COLOR;
				//blendDestination = GL_ONE_MINUS_SRC_COLOR;//transparent whites for luminance textures.
				//blendSource = GL_ONE_MINUS_SRC_COLOR;
				
				//blendSource = GL_ONE_MINUS_SRC_ALPHA;
				//blendDestination = GL_SRC_ALPHA;
				//blendSource = GL_SRC_ALPHA;
				//blendDestination = GL_ONE_MINUS_SRC_ALPHA;
				//texEnvMode = GL_BLEND;
				//texEnvMode = GL_MODULATE;
				//texEnvMode = GL_DECAL;
			}
			
			
		}
		*/
		createGLTexture();
		
		updateGLTexture();
	}

	void createGLTexture()
	{
		// Create The Texture
		glGenTextures(1, &m_id );
		
		if( checkOpenGLError() == true )
		{
			Trace.formatln("Texture creation failed: id: {} name: {} ", m_id, name );
		}
		//else Trace.formatln("Created OpenGL texture id: {} name: {}", m_id, name );
		
		isGenTextures = true;
		
		glBindTexture(glTextureType, m_id );//textures[0]);
		
		glTexParameteri(glTextureType, GL_TEXTURE_MAG_FILTER, magFilter);
		//glTexParameteri(glTextureType, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);
		glTexParameteri(glTextureType, GL_TEXTURE_MIN_FILTER, minFilter);
		
		glTexEnvf (GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, texEnvMode );//GL_MODULATE);
		
		//if( glTextureType == GL_TEXTURE_2D )
		//	useAnisotropicFiltering();
		
		if( checkOpenGLError() == true )
		{
			Trace.formatln("Image.createGLTexture failed: id: {} name: {} ", m_id, name );
		}
	}

	///Creates an OpenGL texture for use in OpenGL with pushTexture() and popTexture().
	void createTexture(uint set_texture_type = GL_TEXTURE_2D)
	{
		debug(Image) Trace.formatln("Image.createTexture() START.");
		debug(Image) scope(exit) Trace.formatln("Image.createTexture() END.");
		
		//if( isGLTextureCreated == true )
		//	return;
		
		//createTextureFromData( imageData, width, height, channels, set_texture_type );
		createTextureFromData( width, height, channels, set_texture_type );
		//isGLTextureCreated = true;
	}


	bool glSwapEndian = false;
	uint glRowLength = 0;
	uint glImageHeight = 0;

	//protected 
	void updateGLTexture( bool do_bind = true )
	{	
		if( checkOpenGLError() == true )
		{
			Trace.formatln("Image.updateGLTexture failed: id: {} name: {} START.", m_id, name );
		}
	
		if( do_bind == true )
			glBindTexture(glTextureType, m_id );
		
		if( checkOpenGLError() == true )
		{
			Trace.formatln("Image.updateGLTexture failed: id: {} name: {} after bind.", m_id, name );
		}
		
		//glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
		//if( glSwapEndian == true )
			//glPixelStorei( GL_UNPACK_SWAP_BYTES, GL_TRUE );
		glPixelStorei( GL_UNPACK_SWAP_BYTES, glSwapEndian );
		
		//if( glRowLength > 0 )
			//glPixelStorei( GL_UNPACK_ROW_LENGTH, glRowLength);
		//glPixelStorei( GL_UNPACK_ROW_LENGTH, width );
		
		//if( glImageHeight > 0 )
		//	glPixelStorei( GL_UNPACK_IMAGE_HEIGHT, glImageHeight);
		
		if( glTextureType == GL_TEXTURE_RECTANGLE_ARB )
		{
			//Non-power of two (NPOT) == GL_TEXTURE_RECTANGLE_ARB
			//doesn't support mipmapping.
			isMipmapping = false;
		}
		
		if( isMipmapping == false )
		{
			
			glTexImage2D(glTextureType,
							0,//mipmap level
							internalFormat,
							width,
							height,
							0,
							colourFormat,
							dataType,
							imageData.ptr);
				
				/*
			glTexImage2D( GLenum target,
						GLint level,
						GLint internalformat,
						GLsizei width,
						GLsizei height,
						GLint border,
						GLenum format,
						GLenum type,
						const GLvoid *pixels )
			*/
		}
		else
		{
		//Generate mipmaps:
			gluBuild2DMipmaps(glTextureType, channels, width, height, colourFormat,
						GL_UNSIGNED_BYTE, imageData.ptr);
		}
		//Or generate just one texture:
		
		//Doesn't work with non-power-of-2:
		/*
		glPixelStorei (GL_UNPACK_ALIGNMENT, 1);
			glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
			glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
			glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magFilter);
			//glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
			glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minFilter);
			//glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
			glTexEnvf (GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
			glTexImage2D (GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, image.ptr);
		*/
		/*glTexImage2D(glTextureType,
						0,
						m_format,
						width,
						height,
						0,
						m_format,
						GL_UNSIGNED_BYTE,
						image.ptr);*/
		
		if( checkOpenGLError() == true )
		{
			Trace.formatln("Image.updateGLTexture failed: id: {} name: {} END.", m_id, name );
		}
	}
	
	
	
	static Image createFromText( dchar[] set_text, float[4] set_colour, AlignType set_align, float set_font_size, float set_zoom, out float get_text_width, out float get_text_height )
	{
		Image img = new Image();
		//img.glTextureType = GL_TEXTURE_RECTANGLE_ARB;
		//img.magFilter = GL_NEAREST;
		//img.minFilter = GL_NEAREST;
		
		img.showText(set_text, set_colour, set_align, set_font_size, set_zoom, get_text_width, get_text_height );
		
		return img;
	}
	/+
	void showText( dchar[] set_text, float[4] set_colour, AlignType set_align, float set_font_size, float set_zoom, out float get_text_width, out float get_text_height )
	{
		//We only create imageData the first time.
		if( imageData is null )
		{
			width = 128;
			height = 128;
			channels = 1;
			//scope ubyte[] image = new ubyte[(width*height)*channels];
			//imageData = new ubyte[(width*height)*channels];
			allocateImageData();
		}
		else //and on other times we just clear the imageData and reuse that
		//buffer.
		{
			clear();
		}
	
		Draw.showText( set_text, set_font_size, set_zoom, imageData, width, height, channels, set_colour, set_align, get_text_width, get_text_height );
		
		//To handle the case where 128 is not enough...
		if( get_text_width > width && width < 2048 )
		{
			debug(text) Trace.formatln("get_text_width: {} for string: {}", get_text_width, set_text );
			cleanUpTexture();
			//freeImageData();
			while( get_text_width > width )
				width = width * 2;
			if( width > 2048 ) width = 2048;
			//imageData = new ubyte[(width*height)*channels];
			reallocateImageData();
			//showText( set_text, set_colour, set_zoom, get_text_width, get_text_height );
			Draw.showText( set_text, set_font_size, set_zoom, imageData, width, height, channels, set_colour, set_align, get_text_width, get_text_height );
		}
		
		bool is_white = true;
		blendSource = GL_ONE;
		blendDestination = GL_ONE_MINUS_SRC_COLOR;
		if( set_colour[0] < 0.5f )//consider that to be black... according to red value... not that clean.
		{
			/*foreach( ubyte val; image )
			{
				val = 250;//make the whole background white then.
			}*/
			is_white = false;
			
			invert(imageData);//CRAP. CHECK. REMOVE. inverts in software for black on white...
				//or vice versa, don't remember.
			blendSource = GL_ZERO;
			blendDestination = GL_SRC_COLOR;
		}
		
		if( isGenTextures == false )//didn't work for some reason...???
		{
			//createTextureFromData( imageData, width, height, channels, GL_TEXTURE_2D, is_white );
			createTextureFromData( width, height, channels, GL_TEXTURE_2D, is_white );
		}
		else
		{
			updateGLTexture();
		}
	}
	+/
	void showText( dchar[] set_text, float[4] set_colour, AlignType set_align, float set_font_size, float set_zoom, out float get_text_width, out float get_text_height )
	{
		//We only create imageData the first time.
		if( imageData is null )
		{
			width = 128;
			height = 128;
			channels = 4;
			//scope ubyte[] image = new ubyte[(width*height)*channels];
			//imageData = new ubyte[(width*height)*channels];
			allocateImageData();
		}
		else //and on other times we just clear the imageData and reuse that
		//buffer.
		{
			clear();
		}
	
		Draw.showText( set_text, set_font_size, set_zoom, imageData, width, height, channels, set_colour, set_align, get_text_width, get_text_height );
		
		//To handle the case where 128 is not enough...
		if( get_text_width > width && width < 2048 )
		{
			debug(text) Trace.formatln("get_text_width: {} for string: {}", get_text_width, set_text );
			cleanUpTexture();
			//freeImageData();
			while( get_text_width > width )
				width = width * 2;
			if( width > 2048 ) width = 2048;
			//imageData = new ubyte[(width*height)*channels];
			reallocateImageData();
			//showText( set_text, set_colour, set_zoom, get_text_width, get_text_height );
			Draw.showText( set_text, set_font_size, set_zoom, imageData, width, height, channels, set_colour, set_align, get_text_width, get_text_height );
		}
		
		bool is_white = true;
		/+
		blendSource = GL_ONE;
		blendDestination = GL_ONE_MINUS_SRC_COLOR;
		if( set_colour[0] < 0.5f )//consider that to be black... according to red value... not that clean.
		{
			/*foreach( ubyte val; image )
			{
				val = 250;//make the whole background white then.
			}*/
			is_white = false;
			
			invert(imageData);//CRAP. CHECK. REMOVE. inverts in software for black on white...
				//or vice versa, don't remember.
			blendSource = GL_ZERO;
			blendDestination = GL_SRC_COLOR;
		}
		+/
		if( isGenTextures == false )//didn't work for some reason...???
		{
			//createTextureFromData( imageData, width, height, channels, GL_TEXTURE_2D, is_white );
			createTextureFromData( width, height, channels, GL_TEXTURE_2D, is_white );
		}
		else
		{
			updateGLTexture();
		}
	}
	
	
	//deprecated
	static Image createCircle( float[4] set_colour )
	{
		debug(Image) Trace.formatln("Image.createCircle() START.");
		debug(Image) scope(exit) Trace.formatln("Image.createCircle() END.");
		
		Image img = new Image();
		img.drawCircle(set_colour);
		return img;
	}
	
	//deprecated
	void drawCircle( float[4] set_colour )
	{
		debug(Image) Trace.formatln("Image.drawCircle() START.");
		debug(Image) scope(exit) Trace.formatln("Image.drawCircle() END.");
		
		width = 64;
		height = 64;
		channels = 1;
		//scope ubyte[] image = new ubyte[(width*height)*channels];
		//scope ubyte[] image = new ubyte[(width*height)*channels];
		allocateImageData();
		Draw.drawCircle( imageData, width, height, channels, set_colour );
		//createTextureFromData( image, width, height, channels, GL_TEXTURE_2D, true );
		createTextureFromData( width, height, channels, GL_TEXTURE_2D, true );
	}
	
	/*
	//REMOVE:
	static Image createHalfCircleLeft( float[4] set_colour )
	{
		Image img = new Image();
		img.drawHalfCircleLeft(set_colour);
		return img;
	}
	
	void drawHalfCircleLeft( float[4] set_colour )
	{
		width = 256;
		height = 64;
		channels = 4;
		scope ubyte[] image = new ubyte[(width*height)*channels];
		Draw.drawHalfCircleLeft( image, width, height, channels, set_colour );
		createTextureFromData( image, width, height, channels, GL_TEXTURE_2D, true );
	}
	*/
	
	
	/*
	static Image createTopHeader()
	{
		Image img = new Image();
			
		uint width = ;
		uint height = 24;
		uint channels = 4;
		scope ubyte[] image = new ubyte[(width*height)*channels];
		Draw.drawTopHeader( image, width, height, channels );
		img.createTextureFromData( image, width, height, GL_TEXTURE_2D, channels );
		
		return img;
	}
	*/
	
	uint findSmallestNumber()//ubyte[] image)
	{
		uint smallest = 256;
		//Go through all three color channels in one pass:
		for( uint i = 0; i < imageData.length; i++ )
		{
			if( imageData[i] < smallest ) smallest = imageData[i];
		}
		return smallest;
	}
	
	void shift(uint shif)
	{
		//Go through all three color channels in one pass:
		for( uint i = 0; i < imageData.length; i++ )
		{
			imageData[i] = imageData[i] + shif;
		}
		
	}
	
	void levelsAutoBlack()//ubyte[] image)
	{
		uint smallest = findSmallestNumber();
		
		shift(-smallest );	
	}
	
	void invert()
	{
		//Go through all three color channels in one pass:
		for( uint i = 0; i < imageData.length; i++ )
		{
			imageData[i] = cast(ubyte)(((cast(float)imageData[i]) * -1.0f) + 255.0f);
		}
	}
	
	void clear()
	{
		if( imageData is null ) return;
		
		for( uint i = 0; i < imageData.length; i++ )
		{
			imageData[i] = 0;
		}
	}
	
	void blur(float blur_amount)
	{
		fastBlur(this, this, blur_amount, blur_amount );
	}
	
	/*
	void blur(float blur_amount_todo)
	{
		float blur_amount = 30.0f;
		
		//We don't want it to be negative:
		if( blur_amount < 0.0f )
			blur_amount = blur_amount * -1.0f;
			
		if( blur_amount == 0.0f )
			return;
	
		if( imageData !is null )
		{
			float[] grad_result;
			int red_val = 0;
			int green_val = 0;
			int blue_val = 0;
			int alpha_val = 0;
			
			float[] gm = new float[(cast(uint)blur_amount)+1];//[0.1f, 0.2f, 0.3f, 0.4f, 0.5f, 0.4f, 0.3f, 0.2f, 0.1f];
			float half_len = (cast(float)gm.size)/2.0f;
			for( uint i = 0; i < gm.size; i++ )
			{
				gm[i] = ((cast(float)i) - half_len) / (half_len);//translate from 0...10 range to -5...5 and then to -1...1 range.
				//(and actually smaller because of half_len*3.0f)
				if( gm[i] < 0.0f )//swap negative to be positive. Now we got 1...0...1 range. kind of.
					gm[i] = gm[i] * -1.0f;
				gm[i] = (1.0f - gm[i]) * 0.4;//to 0...1...0 range. And then to 0...0.4...0 range.
				//This propably could be done earlier, but I'm no mathematician!
				
				Trace.formatln("gm: i:{} val: {}", i, cast(double)gm[i] );
			}
			int ind = 0;
			
			//assert(0);
			
			float val1 = 0;
			float val2 = 0;
			float val3 = 0;
			
			scope ubyte[] imageDataCopy = imageData.dup;
			
			
			//Horizontal blur:
			for( uint i = 0; i < height; i++ )
			{
				for( uint j = 0; j < width; j++ )
				{
					for( uint c = 0; c < gm.size; c++ )
					{
						//ind = (cast(int)j - (cast(int)half_len)) + cast(int)c;
						ind = (cast(int)j - (cast(int)(half_len/2))) + cast(int)c;
					
						for( uint chan = 0; chan < channels; chan++ )
						{
							if( ind >= 0 && ind < width )
							{
								val1 = gm[c] * imageData[(i*width*channels) + (j*channels) + chan] ;//our source pixel with weight gm[c].
								val2 = (1.0f-gm[c]) * imageDataCopy[(i*width*channels) + (ind*channels) + chan];//our target pixels current value
								//weighed so that the sum of the weights becomes 1.0.
								val3 = val1 + val2;//The result.
								
								imageDataCopy[(i*width*channels) + (ind*channels) + chan] = cast(uint) val3;
							}
						}
					}
				}
			}
			
			
			//Vertical blur:
			
			scope ubyte[] imageDataCopy2 = imageData.dup;
			
			for( uint j = 0; j < width; j++ )
			{
				for( uint i = 0; i < height; i++ )
				{
					for( uint c = 0; c < gm.size; c++ )
					{
						ind = (cast(int)i - (cast(int)(half_len/2))) + cast(int)c;
					
						for( uint chan = 0; chan < channels; chan++ )
						{
							if( ind >= 0 && ind < height )
							{
								val1 = gm[c] * imageData[(i*width*channels) + (j*channels) + chan] ;//our source pixel with weight gm[c].
								val2 = (1.0f-gm[c]) * imageDataCopy2[(ind*width*channels) + (j*channels) + chan];//our target pixels current value
								//weighed so that the sum of the weights becomes 1.0.
								val3 = val1 + val2;//The result.
								
								imageDataCopy2[(ind*width*channels) + (j*channels) + chan] = cast(uint) val3;
							}
						}
					}
				}
			}
			
			
			//And now an additional pass to combine the two buffers.
			
			for( uint i = 0; i < height; i++ )
			{
				for( uint j = 0; j < width; j++ )
				{
					for( uint chan = 0; chan < channels; chan++ )
					{
						val1 = imageDataCopy[(i*width*channels) + (j*channels) + chan];
						val2 = imageDataCopy2[(i*width*channels) + (j*channels) + chan];
						val3 = (val1 + val2) * 0.5f;//average.
						//val3 = val1;
						imageData[(i*width*channels) + (j*channels) + chan] = cast(uint) val3;
					}
				}
			}
			
		}
	}
	*/
	

static void
boxBlur (Image input, Image output, ubyte[] intermediate, int kw,
		  int kh )//, RsvgIRect boundarys, RsvgFilterPrimitiveOutput op)
{
	int ch;
	int x, y;
	//int rowstride;//, 
	int height = input.height;
	int width = input.width;
	int channels = input.channels;

	//ubyte* in_pixels;
	//ubyte* output_pixels;

	int sum;

	//height = gdk_pixbuf_get_height (in);
	//width = gdk_pixbuf_get_width (in);

	ubyte[] in_pixels = input.imageData;//gdk_pixbuf_get_pixels (in);
	ubyte[] output_pixels = output.imageData;//gdk_pixbuf_get_pixels (output);

	int rowstride = input.width * input.channels;//gdk_pixbuf_get_rowstride (in);

	//if (kw > boundarys.x1 - boundarys.x0)
	//	kw = boundarys.x1 - boundarys.x0;

	//if (kh > boundarys.y1 - boundarys.y0)
	//	kh = boundarys.y1 - boundarys.y0;

	if (kw > width)
		kw = width;

	if (kh > height)
		kh = height;


	if (kw >= 1)
	{
		for (ch = 0; ch < channels; ch++)
		{
					/*
					switch (ch)
						{
						case 0:
							if (!op.Rused)
								continue;
						case 1:
							if (!op.Gused)
								continue;
						case 2:
							if (!op.Bused)
								continue;
						case 3:
							if (!op.Aused)
								continue;
						}
						*/
					//for (y = boundarys.y0; y < boundarys.y1; y++)
					for (y = 0; y < height; y++)
					{
							sum = 0;
							//for (x = boundarys.x0; x < boundarys.x0 + kw; x++)
							for (x = 0; x < 0 + kw; x++)
							{
									sum += (intermediate[x % kw] = in_pixels[channels * x + y * rowstride + ch]);

									//if (x - kw / 2 >= 0 && x - kw / 2 < boundarys.x1)
									if (x - kw / 2 >= 0 && x - kw / 2 < width)
										output_pixels[channels * (x - kw / 2) + y * rowstride + ch] = sum / kw;
							}
							//for (x = boundarys.x0 + kw; x < boundarys.x1; x++)
							for (x = 0 + kw; x < width; x++)
							{
									sum -= intermediate[x % kw];
									sum += (intermediate[x % kw] = in_pixels[channels * x + y * rowstride + ch]);
									output_pixels[channels * (x - kw / 2) + y * rowstride + ch] = sum / kw;
							}
							//for (x = boundarys.x1; x < boundarys.x1 + kw; x++)
							for (x = width; x < width + kw; x++)
							{
									sum -= intermediate[x % kw];

									//if (x - kw / 2 >= 0 && x - kw / 2 < boundarys.x1)
									if (x - kw / 2 >= 0 && x - kw / 2 < width)
										output_pixels[channels * (x - kw / 2) + y * rowstride + ch] = sum / kw;
							}
					}
		}
		in_pixels = output_pixels;
	}

		if (kh >= 1)
		{
			for (ch = 0; ch < channels; ch++)
				{
					/*
					switch (ch)
						{
						case 0:
							if (!op.Rused)
								continue;
						case 1:
							if (!op.Gused)
								continue;
						case 2:
							if (!op.Bused)
								continue;
						case 3:
							if (!op.Aused)
								continue;
						}
					*/

					//for (x = boundarys.x0; x < boundarys.x1; x++)
					for (x = 0; x < width; x++)
						{
							sum = 0;

							//for (y = boundarys.y0; y < boundarys.y0 + kh; y++)
							for (y = 0; y < 0 + kh; y++)
								{
									sum += (intermediate[y % kh] = in_pixels[channels * x + y * rowstride + ch]);

									//if (y - kh / 2 >= 0 && y - kh / 2 < boundarys.y1)
									if (y - kh / 2 >= 0 && y - kh / 2 < height)
										output_pixels[channels * x + (y - kh / 2) * rowstride + ch] = sum / kh;
								}
							//for (; y < boundarys.y1; y++)
							for (; y < height; y++)
								{
									sum -= intermediate[y % kh];
									sum += (intermediate[y % kh] = in_pixels[channels * x + y * rowstride + ch]);
									output_pixels[channels * x + (y - kh / 2) * rowstride + ch] = sum / kh;
								}
							//for (; y < boundarys.y1 + kh; y++)
							for (; y < height + kh; y++)
								{
									sum -= intermediate[y % kh];

									//if (y - kh / 2 >= 0 && y - kh / 2 < boundarys.y1)
									if (y - kh / 2 >= 0 && y - kh / 2 < height)
										output_pixels[channels * x + (y - kh / 2) * rowstride + ch] = sum / kh;
								}
						}
				}
		}
}

static void fastBlur(Image input, Image output, float blur_amount_x,
		   float blur_amount_y )//, RsvgIRect boundarys, RsvgFilterPrimitiveOutput op)
{
	int kx, ky;
	
	kx = cast(int) floor(blur_amount_x * 3.0f * sqrt(2.0f*PI) / 4.0f + 0.5f);
	ky = cast(int) floor(blur_amount_y * 3.0f * sqrt(2.0f*PI) / 4.0f + 0.5f);

	if (kx < 1 && ky < 1)
		return;

	//scope ubyte[] intermediate = new ubyte[max(kx, ky)];
	ubyte[] intermediate;
	intermediate.alloc(max(kx, ky));

	boxBlur (input, output, intermediate, kx,
			  ky );//, boundarys, op);
	boxBlur (output, output, intermediate, kx,
			  ky );//, boundarys, op);
	boxBlur (output, output, intermediate, kx,
			  ky );//, boundarys, op);

	intermediate.free();
}



	
	void swapAR()
	{
		if( channels != 4 || imageData is null )
		{
			return;
		}
		
		ubyte temp_val1;
		ubyte temp_val2;
		
		for( uint i = 0; i < height; i++ )
		{
			for( uint j = 0; j < width; j++ )
			{
				Trace.formatln("wid: {} hei: {} i: {} j: {}", width, height, i, j);
				temp_val1 = imageData[(i*width*4) + (j*4) + 0];
				temp_val2 = imageData[(i*width*4) + (j*4) + 3];
				
				imageData[(i*width*4) + (j*4) + 0] = temp_val2;
				//imageData[(i*width*4) + (j*4) + 1] = ;
				//imageData[(i*width*4) + (j*4) + 2] = ;
				imageData[(i*width*4) + (j*4) + 3] = temp_val1;
			}
		}
	}
	
	//Just an ugly hack.
	void resize( uint set_width, uint set_height )
	{
		Trace.formatln("set_width: {}", set_width );
		Trace.formatln("set_height: {}", set_height );
	
		if( imageData is null ) return;
		
		//multiply width with these.
		float wid_rel = cast(float)set_width / cast(float)width;
		float hei_rel = cast(float)set_height / cast(float)height;
		
		//ubyte[] temp_buf = new ubyte[set_width * set_height * channels];
		ubyte[] temp_buf;
		temp_buf.alloc(set_width * set_height * channels);
		
		for( uint i = 0; i < height; i++ )
		{
			for( uint j = 0; j < width; j++ )
			{
				uint coord1 = ((cast(uint)(i*hei_rel))*set_width*channels) + ((cast(uint)(j*wid_rel))*channels);
				if( coord1 >= temp_buf.length ) coord1 = temp_buf.length-1;
				uint coord2 = coord1 + 1;
				if( coord2 >= temp_buf.length ) coord2 = temp_buf.length-1;
				uint coord3 = coord1 + 2;
				if( coord3 >= temp_buf.length ) coord3 = temp_buf.length-1;
				uint coord4 = coord1 + 3;
				if( coord4 >= temp_buf.length ) coord4 = temp_buf.length-1;
			
				//Trace.formatln("coord1: {}", coord1 );
			
				if( channels >= 1 )
					temp_buf[coord1] = imageData[(i*width*channels) + (j*channels)];
				if( channels >= 2 )
					temp_buf[coord2] = imageData[(i*width*channels) + (j*channels) + 1];
				if( channels >= 3 )
					temp_buf[coord3] = imageData[(i*width*channels) + (j*channels) + 2];
				if( channels >= 4 )
					temp_buf[coord4] = imageData[(i*width*channels) + (j*channels) + 3];
			}
		}
		
		//ubyte[] to_garbage = imageData;
		//imageData = temp_buf;
		freeImageData();
		width = set_width;
		height = set_height;
		imageData = temp_buf.clone();
		temp_buf.free();
		//delete to_garbage;
	}
	
	//MOVE to utils or Rae.FileChooser...
	bool doesFileExist( char[] filename )
	{
		scope FilePath a_path = new FilePath(filename);
		return a_path.exists;
	}
	
	///Loads a DPX file.
	bool loadDpx(char[] filename)
	{
		debug(Image) Trace.formatln("Image.loadDpx() START.");
		debug(Image) scope(exit) Trace.formatln("Image.loadDpx() END.");
	
		if( doesFileExist(filename) == false )
		{
			return false;
		}
		
		assert(0);
		
		//loadDPX( filename, this );
		
		return true;
	}
	
version(graphicsmagick)
{
	bool load(char[] set_filename)
	{
		//uses GraphicsMagick to load image files.
		if( doesFileExist(set_filename) == false )
		{
			Trace.formatln("Image.load() failed. File doesn't exist: {}", set_filename );
			return false;
		}
		
		name = set_filename;
	
		Mag.Image* image;
		Mag.Image* resize_image;
		Mag.ImageInfo* image_info;
		Mag.ExceptionInfo exception;
		
		Mag.GetExceptionInfo(&exception);
		
		image_info = Mag.CloneImageInfo( null );
		
		strcpy( &image_info.filename[0], stringz.toStringz(set_filename));
	//Trace.formatln("filename after: {}", image_info.filename );
	image = Mag.ReadImage(image_info,&exception);
	if (exception.severity != Mag.UndefinedException)
        Mag.CatchException(&exception);
	
	if( image is null )
	{
		Trace.formatln("Unsupported image type.");
		return false;
	}
	
	bool need_realloc = false;
	
	uint tempwidth = image.columns;
	uint tempheight = image.rows;
	uint tempchannels = 4;
	
		if( tempwidth != width || tempheight != height || tempchannels != channels )
			need_realloc = true;
		
		width = tempwidth;
		height = tempheight;
		channels = tempchannels;
		//bool do_bind_in_update = true;
		
		if( imageData is null )
		{
			//imageData = new ubyte[(width*height)*channels];
			allocateImageData();
			createGLTexture();
			//do_bind_in_update = false;
		}
		else if( need_realloc == true )
		{
			//delete imageData;
			//imageData = new ubyte[(width*height)*channels];
			reallocateImageData();
		}
		
		if( imageData is null )
		{
			Trace.formatln("Image.load() failed to allocate memory for imageData.");
		}
	/*
	PixelPacket* AcquireImagePixels(Image* image, int x,const int y,
                      uint columns,
                      uint rows, ExceptionInfo* exception);
	*/
	
	uint x1 = 0;
	uint y1 = 0;
	uint x2 = image.columns;
	uint y2 = 1;
	
	for( ; y1 < image.rows; )
	{
		Mag.PixelPacket* pixels = Mag.AcquireImagePixels(image, x1, y1, x2, y2, &exception);
		if (exception.severity != Mag.UndefinedException)
				Mag.CatchException(&exception);
			
		for( uint i = 0; i < image.columns; i++ )
		{
			//if( pixels[i].red != 0 || pixels[i].green != 0 || pixels[i].blue != 0 )
			//	Trace.format( "| y1:{} i {} r:{}, g:{}, b:{} ", y1, i, pixels[i].red, pixels[i].green, pixels[i].blue );
			
			imageData[(y1*width*channels) + (i*channels)] = pixels[i].red;
			imageData[(y1*width*channels) + (i*channels) + 1] = pixels[i].green;
			imageData[(y1*width*channels) + (i*channels) + 2] = pixels[i].blue;
			imageData[(y1*width*channels) + (i*channels) + 3] = pixels[i].opacity;
		}
		
		y1++;
		//y2++;
	}
		
		if( width > 2048 || height > 2048 )
		{
			if( width >= height )
			{
				float aspectrat = cast(float)height / cast(float)width;
				resize( 2048, cast(uint)(2048.0f * aspectrat) );
			}
			else
			{
				float aspectrat = cast(float)width / cast(float)height;
				resize( cast(uint)(2048.0f * aspectrat), 2048 );
			}
		}
		
		bool isPowerOfTwo( int val )
		{
			return ((val&(val-1))==0);
		}
		
		if( isPowerOfTwo(width) && isPowerOfTwo(height) )
		{
			glTextureType = GL_TEXTURE_2D;
			///////////minFilter = GL_LINEAR_MIPMAP_LINEAR;
			///////////magFilter = GL_NEAREST;
		}
		else
		{
			glTextureType = GL_TEXTURE_RECTANGLE_ARB;
			//////////minFilter = GL_LINEAR;//GL_NEAREST;
			//////////magFilter = GL_LINEAR;//GL_NEAREST;
		}
		
		dataType = GL_UNSIGNED_BYTE;
		texEnvMode = GL_REPLACE;
		//dstImage.glTextureType = GL_TEXTURE_2D;
		isBlending = false;
		isMipmapping = false;
		
		setColourFormatFromChannels();
		updateGLTexture();//do_bind_in_update);
		
		Mag.DestroyImage(image);
		Mag.DestroyImageInfo(image_info);
		Mag.DestroyExceptionInfo(&exception);
		
		return true;
	}
}//version graphicsmagick
else
{
	bool load(char[] filename)
	{
		Trace.formatln("This version of Rae is not compiled with GraphicsMagick enabled, therefore it can't load images.");
		return false;
	}
}
	
	/+
	bool load(char[] filename)
	{
		//uses freeimage to load image files.
		if( doesFileExist(filename) == false )
		{
			Trace.formatln("Image.load() failed. File doesn't exist: {}", filename );
			return false;
		}
	
		FIBITMAP* fibitmap = FreeImage_Load(FREE_IMAGE_FORMAT.FIF_PNG, stringz.toStringz(filename) );//,flags = 0
		if( fibitmap is null )
		{
			Trace.formatln("Image.load() failed for file: {}. Freeimage returned null.", filename );
			return false;
		}
		
		bool need_realloc = false;
		
		uint tempwidth = FreeImage_GetWidth(fibitmap);
		uint tempheight = FreeImage_GetHeight(fibitmap);
		
		uint tempchannels;
		
		//TODO if BPP == 8 -> channels = 1.
		if( FreeImage_GetBPP(fibitmap) == 24 )
			tempchannels = 3;
		else if( FreeImage_GetBPP(fibitmap) == 32 )
			tempchannels = 4;
		
		if( tempwidth != width || tempheight != height || tempchannels != channels )
			need_realloc = true;
		
		width = tempwidth;
		height = tempheight;
		channels = tempchannels;
		
		if( imageData is null )
		{
			//imageData = new ubyte[(width*height)*channels];
			allocateImageData();
			createGLTexture();
		
		}
		else if( need_realloc == true )
		{
			//delete imageData;
			//imageData = new ubyte[(width*height)*channels];
			reallocateImageData();
		}
		
		uint pitch = FreeImage_GetPitch(fibitmap);
		FREE_IMAGE_TYPE image_type = FreeImage_GetImageType(fibitmap);
		uint x, y;
		
		if((image_type == FREE_IMAGE_TYPE.FIT_BITMAP) && (FreeImage_GetBPP(fibitmap) == 24))
		{ 
			BYTE *bits = cast(BYTE*)FreeImage_GetBits(fibitmap); 
			for(y = 0; y < height; y++)
			{ 
				BYTE *pixel = cast(BYTE*)bits; 
				for(x = 0; x < width; x++)
				{ 
					imageData[(y*width*channels) + (x*channels)] = pixel[FI_RGBA_RED];
					imageData[(y*width*channels) + (x*channels) + 1] = pixel[FI_RGBA_GREEN];
					imageData[(y*width*channels) + (x*channels) + 2] = pixel[FI_RGBA_BLUE];
					pixel += 3;
				}
				// next line 
				bits += pitch;
			}
		}
		else if((image_type == FREE_IMAGE_TYPE.FIT_BITMAP) && (FreeImage_GetBPP(fibitmap) == 32))
		{ 
			BYTE *bits = cast(BYTE*)FreeImage_GetBits(fibitmap); 
			for(y = 0; y < height; y++)
			{ 
				BYTE *pixel = cast(BYTE*)bits; 
				for(x = 0; x < width; x++)
				{ 
					imageData[(y*width*channels) + (x*channels)] = pixel[FI_RGBA_RED];
					imageData[(y*width*channels) + (x*channels) + 1] = pixel[FI_RGBA_GREEN];
					imageData[(y*width*channels) + (x*channels) + 2] = pixel[FI_RGBA_BLUE];
					imageData[(y*width*channels) + (x*channels) + 3] = pixel[FI_RGBA_ALPHA];
					pixel += 4; 
				} 
				// next line 
				bits += pitch;
			}
		}
		else
		{
			Trace.formatln("Image.load() failed. We only support RGB 24bit and RGBA 32bit images. filename: {}", filename );
			FreeImage_Unload(fibitmap);
			return false;
		}
		
		/*
		
		switch(image_type)
		{
			default:
				Trace.formatln("Image.load() failed. We only support RGBA 32bit images. filename: {}", filename );
				return false;
			break;
			case FREE_IMAGE_TYPE.FIT_BITMAP: 
				if(FreeImage_GetBPP(fibitmap) == 8)
				{ 
					for(y = 0; y < height; y++)
					{ 
						BYTE *bits = cast(BYTE *)FreeImage_GetScanLine(image, y); 
						for(x = 0; x < width; x++)
						{ 
							//bits[x] = 128;
							imageData[(y*width*channels) + (x*channels)]
						} 
					} 
				} 
			break;
		}
		*/
		
		if( width > 2048 || height > 2048 )
		{
			if( width >= height )
			{
				float aspectrat = cast(float)height / cast(float)width;
				resize( 2048, cast(uint)(2048.0f * aspectrat) );
			}
			else
			{
				float aspectrat = cast(float)width / cast(float)height;
				resize( cast(uint)(2048.0f * aspectrat), 2048 );
			}
		}
		
		bool isPowerOfTwo( int val )
		{
			return ((val&(val-1))==0);
		}
		
		if( isPowerOfTwo(width) && isPowerOfTwo(height) )
		{
			glTextureType = GL_TEXTURE_2D;
			///////////minFilter = GL_LINEAR_MIPMAP_LINEAR;
			///////////magFilter = GL_NEAREST;
		}
		else
		{
			glTextureType = GL_TEXTURE_RECTANGLE_ARB;
			//////////minFilter = GL_LINEAR;//GL_NEAREST;
			//////////magFilter = GL_LINEAR;//GL_NEAREST;
		}
		
		setColourFormatFromChannels();
		updateGLTexture();
		
		FreeImage_Unload(fibitmap);
		
		return true;
	}
	+/
	
	
	
	/+
	protected char[] png_file_content;
	
	///Loads a PNG file.
	///Returns true on success and false on failure.
	///Crudely resizes pictures to fit 2048X2048 textures.
	bool loadPng(char[] filename)
	{
		if( doesFileExist(filename) == false )
		{
			Trace.formatln("Image.loadPng() failed. File doesn't exist: {}", filename );
			return false;
		}
	
		version(noLodePng)
		{
			Trace.formatln("This version of Rae can't load .png files, because it is not compiled with lodePng.");
			generator(NOISE_3, 512, 512);
		}
		else
		{
	
		//freeImageData();
	
		//scope File our_file = new File(filename);
		
	
		// open file for reading
		auto fc = new FileConduit(filename);

		// create an array to house the entire file
		if( png_file_content is null )
		{
			png_file_content = new char[fc.length];
		}
		else if( png_file_content.length != fc.length )
		{
			delete png_file_content;
			png_file_content = new char[fc.length];
		}

		// read the file content. Return value is the number of bytes read
		//auto bytesRead = 
		fc.input.read( png_file_content );
	
		fc.close();
	
		//Trace.formatln("btesread: {}", bytesRead);
	/*
		PngInfo info;
		//imageData = decode32(cast(ubyte[])our_file.read(), info, imageData );
		//if( imageData is null )
		imageData = decode32(cast(ubyte[])png_file_content, info, imageData );
		//else decode32(cast(ubyte[])png_file_content, info, imageData );
		
		channels = 4;
		width = info.image.width;
		height = info.image.height;
		
		if( width > 2048 || height > 2048 )
		{
			if( width >= height )
			{
				float aspectrat = cast(float)height / cast(float)width;
				resize( 2048, cast(uint)(2048.0f * aspectrat) );
			}
			else
			{
				float aspectrat = cast(float)width / cast(float)height;
				resize( cast(uint)(2048.0f * aspectrat), 2048 );
			}
		}
		
		bool isPowerOfTwo( int val )
		{
			return ((val&(val-1))==0);
		}
		
		if( isPowerOfTwo(width) && isPowerOfTwo(height) )
		{
			glTextureType = GL_TEXTURE_2D;
			///////////minFilter = GL_LINEAR_MIPMAP_LINEAR;
			///////////magFilter = GL_NEAREST;
		}
		else
		{
			glTextureType = GL_TEXTURE_RECTANGLE_ARB;
			//////////minFilter = GL_LINEAR;//GL_NEAREST;
			//////////magFilter = GL_LINEAR;//GL_NEAREST;
		}
		
		setColourFormatFromChannels();
		createGLTexture();
		updateGLTexture();
		*/
		}
		
		return true;
	}
+/
	
	void writeToPng( char[] set_filename )
	{
		if( imageData !is null )
			writeBufferToPng( set_filename, imageData, width, height, channels );
	}
	
	static void writeBufferToPng( char[] set_filename, ubyte[] image, uint wid, uint hei, uint chan )
	{
		version(Windows)
		{
			//A temp hack on Windows, to replace / with \.
			foreach( char c; set_filename )
			{
				if( c == '/' )
					c = '\\';
			}
			
			Trace.formatln("Going to writeToPng: {}", set_filename );
		}
		
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
		
		ImageSurface imageSurface = ImageSurface.createForData(image.ptr, form, wid, hei, (wid * chan) );
		scope(exit)
		{
			imageSurface.destroy();
			delete imageSurface;
		}
		
		imageSurface.writeToPng( set_filename );
		}
	}
	
	/**
	* function to load in bitmap as a GL texture.
	*/
	void loadGLTexture(char[] filename)
	{
		version(sdl)
		{
			// Create storage space for the texture
			SDL_Surface *textureImage;
			//SDL_Surface *textureImage2;
			//SDL_Surface *textureImage3;
		
			// Load The Bitmap, Check For Errors, If Bitmap's Not Found Quit
			if ((textureImage = SDL_LoadBMP(filename.ptr)) !is null)
			{
				// Free the surface when we exit the scope
				scope(exit) SDL_FreeSurface(textureImage);
		
				// Create The Texture
				glGenTextures(1, &m_id );//&textures[0]);
				isGenTextures = true;
		
				// Create Nearest Filtered Texture
				/*glBindTexture(GL_TEXTURE_2D, textures[0]);
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
				glTexImage2D(GL_TEXTURE_2D, 0, 3, textureImage.w, textureImage.h, 0, GL_BGR,
							GL_UNSIGNED_BYTE, textureImage.pixels);
		
				// Create Linear Filtered Texture
				glBindTexture(GL_TEXTURE_2D, textures[1]);
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
				glTexImage2D(GL_TEXTURE_2D, 0, 3, textureImage.w, textureImage.h, 0, GL_BGR,
							GL_UNSIGNED_BYTE, textureImage.pixels);
				*/
				// Create MipMapped Texture
				glBindTexture(GL_TEXTURE_2D, m_id );//textures[0]);
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);
				gluBuild2DMipmaps(GL_TEXTURE_2D, 3, textureImage.w, textureImage.h, GL_BGR,
								GL_UNSIGNED_BYTE, textureImage.pixels);
		
				//return;
			}
		}//version(sdl)
		//throw new Exception("Failed to load texture.");
	/+		
		if ((textureImage2 = SDL_LoadBMP("./data/reuna.bmp")) !is null)
		{
			// Free the surface when we exit the scope
			scope(exit) SDL_FreeSurface(textureImage2);
	
			// Create The Texture
			glGenTextures(1, &textures[1]);
	
			// Create Nearest Filtered Texture
			/*glBindTexture(GL_TEXTURE_2D, textures[0]);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
			glTexImage2D(GL_TEXTURE_2D, 0, 3, textureImage.w, textureImage.h, 0, GL_BGR,
						GL_UNSIGNED_BYTE, textureImage.pixels);
	
			// Create Linear Filtered Texture
			glBindTexture(GL_TEXTURE_2D, textures[1]);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			glTexImage2D(GL_TEXTURE_2D, 0, 3, textureImage.w, textureImage.h, 0, GL_BGR,
						GL_UNSIGNED_BYTE, textureImage.pixels);
			*/
			// Create MipMapped Texture
			glBindTexture(GL_TEXTURE_2D, textures[1]);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);
			gluBuild2DMipmaps(GL_TEXTURE_2D, 3, textureImage2.w, textureImage2.h, GL_BGR,
							GL_UNSIGNED_BYTE, textureImage2.pixels);
	
			//return;
		}
		
		if ((textureImage3 = SDL_LoadBMP("./data/font.bmp")) !is null)
		{
			// Free the surface when we exit the scope
			scope(exit) SDL_FreeSurface(textureImage3);
	
			// Create The Texture
			glGenTextures(2, &textures[2]);
	
			// Create MipMapped Texture
			glBindTexture(GL_TEXTURE_2D, textures[2]);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);
			gluBuild2DMipmaps(GL_TEXTURE_2D, 3, textureImage3.w, textureImage3.h, GL_BGR,
							GL_UNSIGNED_BYTE, textureImage3.pixels);
	
		
		}
	+/
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
