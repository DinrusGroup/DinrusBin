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

module rae.canvas.ShapeRectangle;

import tango.util.log.Trace;//Thread safe console output.

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

public import rae.gl.gl;
public import rae.gl.glu;
public import rae.gl.glext;

import rae.core.globals;
import rae.core.IRaeMain;
public import rae.canvas.IShape;
import rae.canvas.Image;
import rae.canvas.Draw;

class ShapeRectangle : IShape
{
public:
	
	this(float ix1, float iy1, float ix2, float iy2, float iz = 0.0f)
	{
		init();
		//bounds(ix1, iy1, ix2, iy2, iz);
		textureWidth = ix2 - ix1;//this assumes an initial zoom of 1.0f in all parents...
		textureHeight = iy2 - iy1;
	}
	
	/*static Mesh createRectangle(float ix1, float iy1, float ix2, float iy2, float iz = 0.0f)
	{
		Mesh empty = new Mesh();
		empty.init();
		empty.fillDrawData(ix1, iy1, ix2, iy2, iz);
		return empty;
	}*/
	
	~this()
	{
		debug(ShapeRectangle) Stdout("ShapeRectangle.~this().").newline;
		delete vertices;
		delete indices;
		delete normals;
		delete textureCoords;
		
	}
	
	public OrientationType orientation() { return m_orientation; }
	public OrientationType orientation(OrientationType set) { return m_orientation = set; }
	protected OrientationType m_orientation = OrientationType.HORIZONTAL;
	
	//Texture handling is moved here, inside Shape.
	
	//protected 
	void updateThemeTexture( float set_width, float set_height )
	{
		debug(ShapeRectangle) Trace.formatln("ShapeRectangle.updateThemeTexture() START.");
		debug(ShapeRectangle) scope(exit) Trace.formatln("ShapeRectangle.updateThemeTexture() END.");
		
		textureWidth = set_width;
		textureHeight = set_height;
		
		if( themeTexture != "" && texture !is null )
		{
			debug(ShapeRectangle) Trace.formatln("ShapeRectangle.updateThemeTexture() Test is Ok Doin it..");
			if( orientation == OrientationType.HORIZONTAL )
				texture = g_rae.getTextureFromTheme( themeTexture, set_height, texture );
			else if( orientation == OrientationType.VERTICAL )
				texture = g_rae.getTextureFromTheme( themeTexture, set_width, texture );
		}
		
		debug(ShapeRectangle)
		{
			if( themeTexture == "" )
				Trace.formatln("ShapeRectangle.updateThemeTexture() themeTexture == not");
		
			if( texture is null )
				Trace.formatln("ShapeRectangle.updateThemeTexture() texture is null.");
		}
			
	}
	public char[] themeTexture() { return m_themeTexture; }
	public char[] themeTexture( char[] set )
	{
		//if( texture is null )
		//{
			if( orientation == OrientationType.HORIZONTAL )
				texture = g_rae.getTextureFromTheme(set, textureHeight, texture);
			else if( orientation == OrientationType.VERTICAL )
				texture = g_rae.getTextureFromTheme(set, textureWidth, texture);
		//}
		return m_themeTexture = set;
	}
	protected char[] m_themeTexture = "";
	protected float textureWidth;
	protected float textureHeight;
	
	public Image texture()
	{
		return m_texture;
	}
	public Image texture( Image set )
	{
		return m_texture = set;
	}
	protected Image m_texture;
	
	protected void* verticesP() { return cast(void*)vertices; }
	protected GLfloat[] vertices;
	
	protected void* indicesP() { return cast(void*)indices; }
	protected GLushort[] indices;
	
	protected void* strokeIndicesP() { return cast(void*)strokeIndices; }
	protected GLushort[] strokeIndices;
	
	protected void* normalsP() { return cast(void*)normals; }
	protected GLfloat[] normals;
	//protected GLfloat[] faceNormals;
	
	protected void* textureCoordsP() { return cast(void*)textureCoords; }
	protected GLfloat[] textureCoords;
	
	public bool isTextureCoordsOne() { return m_isTextureCoordsOne; }
	public bool isTextureCoordsOne(bool set) { return m_isTextureCoordsOne = set; }
	protected bool m_isTextureCoordsOne = true;

	uint numVerts = 0;
	uint numFaces = 0;
	//GLuint idxStart = 0;
	//GLuint idxEnd = 0;
	
	protected uint drawType = GL_QUAD_STRIP;
	
	float leftClip = 0.0f;
	float rightClip = 0.0f;
	float upClip = 0.0f;
	float downClip = 0.0f;
	
	float texCoordOneTop() { return m_texCoordOneTop; }
	float texCoordOneBottom() { return m_texCoordOneBottom; }
	float texCoordOneLeft() { return m_texCoordOneLeft; }
	float texCoordOneRight() { return m_texCoordOneRight; }
	
	void texCoordOneTop(float set) { m_texCoordOneTop = set; }
	void texCoordOneBottom(float set) { m_texCoordOneBottom = set; }
	void texCoordOneLeft(float set) { m_texCoordOneLeft = set; }
	void texCoordOneRight(float set) { m_texCoordOneRight = set; }
	
	float m_texCoordOneTop = 0.0f;
	float m_texCoordOneBottom = 1.0f;
	float m_texCoordOneLeft = 0.0f;
	float m_texCoordOneRight = 1.0f;
	
	protected void init()
	{
		drawType = GL_QUAD_STRIP;
	
		numVerts = 4;
		numFaces = 2;
		//idxStart = 0;
		//idxEnd = 5;
	
		vertices = new GLfloat[12];
		
		//GLfloat num = set_size;//1.0f;
		
		//fillDrawData();
		
		/*m_vertices = [
							-1.0f, -1.0f, 0.0f,
							1.0f, -1.0f, 0.0f,
							-1.0f, 1.0f, 0.0f,
							1.0f, 1.0f, 0.0f
						];*/
				
		//indices = new GLushort[4];
		//This makes them static for this class,
		//all the instances will share these
		//but that's ok...
		indices = [ 0, 1, 2, 3 ];
		
		strokeIndices = [ 0, 1, 3, 2, 0 ];
		
		//normals = new GLfloat[12];
		normals = [
							0.0f, 0.0f, 1.0f,
							0.0f, 0.0f, 1.0f,
							0.0f, 0.0f, 1.0f,
							0.0f, 0.0f, 1.0f
						];
						
		//textureCoords = new GLfloat[8];
		textureCoords = [
								0.0f, 0.0f,
								0.0f, 1.0f,
								1.0f, 0.0f,
								1.0f, 1.0f
							];

	}
	
	void render( Draw draw, float ix1, float iy1, float ix2, float iy2, float iz = 0.0f)
	{
		bounds( draw, ix1, iy1, ix2, iy2, iz);
		fill();
	}
	
	void clip(float set_left_clip, float set_right_clip, float set_up_clip, float set_down_clip)
	{
		leftClip = set_left_clip;
		rightClip = set_right_clip;
		upClip = set_up_clip;
		downClip = set_down_clip;
	}
	
	protected bool isShown = true;
	
	protected void handleClipping(Draw draw, float ix1, float iy1, float ix2, float iy2 )
	{
		if( draw is null || draw.clipStack is null )
			return;
		/*
		float leftClip = 0.0f;
		float rightClip = 0.0f;
		float upClip = 0.0f;
		float downClip = 0.0f;
		*/
		leftClip = 0.0f;
		rightClip = 0.0f;
		upClip = 0.0f;
		downClip = 0.0f;
		
		//We clip here. This is so funny.
		if( draw.clipStack.size > 0 )
		{
			ClippingInfo cl = draw.clipStack.tail;
			if( ix1 < cl.ix1 )
			{
				leftClip = cl.ix1 - ix1;
				//ix1 = cl.ix1;
			}
				
			if( iy1 < cl.iy1 )
			{
				upClip = cl.iy1 - iy1;
				//iy1 = cl.iy1;
			}
				
			if( ix2 > cl.ix2 )
			{
				rightClip = cl.ix2 - ix2;
				//ix2 = cl.ix2;
			}
				
			if( iy2 > cl.iy2 )
			{
				downClip = cl.iy2 - iy2;
				//iy2 = cl.iy2;
			}
		}
		//clip(leftClip, rightClip, upClip, downClip);
	}
	
	void bounds( Draw draw, float ix1, float iy1, float ix2, float iy2, float iz = 0.0f)
	{
		if( g_rae is null ) return;//if we don't have a global rae, then
		//we aren't yet able to render anything.
		//This is to get unittests working.
		
		handleClipping( draw, ix1, iy1, ix2, iy2 );
		
		isShown = true;
		
		float ix1clip = ix1 + leftClip;
		float ix2clip = ix2 + rightClip;
		float iy1clip = iy1 + upClip;
		float iy2clip = iy2 + downClip;
	
		if( ix1clip > ix2clip || iy1clip > iy2clip )
		{
			isShown = false;
			return;
		}
	
		/*ix1 = ix1clip;
		ix2 = ix2clip;
		iy1 = iy1clip;
		iy2 = iy2clip;*/
	
		vertices[0] = ix1clip;// + leftClip;//-num;
		vertices[1] = iy1clip;// + upClip;//-num;
		vertices[2] = iz;//0.0f;
		vertices[3] = ix1clip;// + leftClip;//num;
		vertices[4] = iy2clip;// + downClip;//-num;
		vertices[5] = iz;//0.0f;
		vertices[6] = ix2clip;// + rightClip;//-num;
		vertices[7] = iy1clip;// + upClip;//num;
		vertices[8] = iz;//0.0f;
		vertices[9] = ix2clip;// + rightClip;//num;
		vertices[10] = iy2clip;// + downClip;//num;
		vertices[11] = iz;//0.0f;

		if( texture !is null && texture.isTextureCoordsOne == false )
		{
			isTextureCoordsOne = false;//HACkity hack. clean this.
		}
		
		//Well. This is also for the FBO case, and then
		//texture is null. This is also for the texture case...
		//Bad. Clean this mess.
		if(isTextureCoordsOne == false )
		{
			//If is FBO or a texture with pixelPerPixel set to true.
			if( texture is null || texture.isPixelPerPixel == true )
			{
				//So we want to draw a GL_TEXTURE_RECTANGLE_ARB
				//texture as pixelPerPixel. We divide the size with
				//the size of one pixel.
				
				/*
				textureCoords[0] = leftClip / g_rae.pixel;
				textureCoords[1] = upClip / g_rae.pixel;
				textureCoords[2] = leftClip / g_rae.pixel;
				textureCoords[3] = (iy2 - iy1 + downClip) / g_rae.pixel;
				textureCoords[4] = (ix2 - ix1 + rightClip) / g_rae.pixel;
				textureCoords[5] = upClip / g_rae.pixel;
				textureCoords[6] = (ix2 - ix1 + rightClip) / g_rae.pixel;
				textureCoords[7] = (iy2 - iy1 + downClip) / g_rae.pixel;
				*/
				
				textureCoords[0] = 0.0f;
				textureCoords[1] = 0.0f;
				textureCoords[2] = 0.0f;
				textureCoords[3] = (iy2 - iy1) / g_rae.pixel;
				textureCoords[4] = (ix2 - ix1) / g_rae.pixel;
				textureCoords[5] = 0.0f;
				textureCoords[6] = (ix2 - ix1) / g_rae.pixel;
				textureCoords[7] = (iy2 - iy1) / g_rae.pixel;
			}
			else //this is not pixel per pixel, this is
			//varying according to the size of the rectangle being
			//drawn. Just for GL_TEXTURE_RECTANGLE_ARB.
			//This could be e.g. a Rectangle which shows an image or video image
			//that the user is able to zoom.
			{
				/*
				//Without cropping it looks like this:
				textureCoords[0] = 0.0f;
				textureCoords[1] = 0.0f;
				textureCoords[2] = 0.0f;
				textureCoords[3] = texture.height;
				textureCoords[4] = texture.width;
				textureCoords[5] = 0.0f;
				textureCoords[6] = texture.width;
				textureCoords[7] = texture.height;
				*/
				/*
				textureCoords[0] = texture.leftCrop;
				textureCoords[1] = texture.topCrop;
				textureCoords[2] = texture.leftCrop;
				textureCoords[3] = texture.height - texture.bottomCrop;
				textureCoords[4] = texture.width - texture.rightCrop;
				textureCoords[5] = texture.topCrop;
				textureCoords[6] = texture.width - texture.rightCrop;
				textureCoords[7] = texture.height - texture.bottomCrop;
				*/
				/*
				textureCoords[0] = texture.leftCrop + (leftClip / g_rae.pixel);
				textureCoords[1] = texture.topCrop + (upClip / g_rae.pixel);
				textureCoords[2] = texture.leftCrop + (leftClip / g_rae.pixel);
				textureCoords[3] = texture.height - texture.bottomCrop + (downClip / g_rae.pixel);
				textureCoords[4] = texture.width - texture.rightCrop + (rightClip / g_rae.pixel);
				textureCoords[5] = texture.topCrop + (upClip / g_rae.pixel);
				textureCoords[6] = texture.width - texture.rightCrop + (rightClip / g_rae.pixel);
				textureCoords[7] = texture.height - texture.bottomCrop + (downClip / g_rae.pixel);
				*/
				
				/*
				textureCoords[0] = texture.leftCrop + ((leftClip/(ix2 - ix1))*(texture.width));
				textureCoords[1] = texture.topCrop + ((upClip/(iy2 - iy1))*(texture.height));
				textureCoords[2] = texture.leftCrop + ((leftClip/(ix2 - ix1))*(texture.width));
				textureCoords[3] = texture.height - texture.bottomCrop + ((downClip/(iy2 - iy1))*(texture.height));
				textureCoords[4] = texture.width - texture.rightCrop + ((rightClip/(ix2 - ix1))*(texture.width));
				textureCoords[5] = texture.topCrop + ((upClip/(iy2 - iy1))*(texture.height));
				textureCoords[6] = texture.width - texture.rightCrop + ((rightClip/(ix2 - ix1))*(texture.width));
				textureCoords[7] = texture.height - texture.bottomCrop + ((downClip/(iy2 - iy1))*(texture.height));
				*/
				
				/*
				The cropping system is wierd, but I got no other idea, than to implement it
				with the opengl textures coordinates. Here's some odd precalculation which
				takes into consideration the effect of cropping on the height and width of the
				texture coordinates, and the effect of clipping (by parent objects).
				*/
				
				float temphei = (texture.height*(1.0f-texture.bottomCropPercent-texture.topCropPercent));
				float tempwid = (texture.width*(1.0f-texture.leftCropPercent-texture.rightCropPercent));
				
				textureCoords[0] = ((leftClip/(ix2 - ix1))*tempwid);
				textureCoords[1] = ((upClip/(iy2 - iy1))*temphei);
				textureCoords[2] = ((leftClip/(ix2 - ix1))*tempwid);
				textureCoords[3] = temphei + ((downClip/(iy2 - iy1))*temphei);
				textureCoords[4] = tempwid + ((rightClip/(ix2 - ix1))*tempwid);
				textureCoords[5] = ((upClip/(iy2 - iy1))*temphei);
				textureCoords[6] = tempwid + ((rightClip/(ix2 - ix1))*tempwid);
				textureCoords[7] = temphei + ((downClip/(iy2 - iy1))*temphei);
			}
			//Trace.formatln("bounds: tc3:{}", textureCoords[3]);
		}
		else if( texture !is null )
		{
			//texcoords is one. Check cropping:
			
			textureCoords[0] = texCoordOneLeft + (leftClip/(ix2 - ix1)) + texture.leftCropPercent;
			textureCoords[1] = texCoordOneTop + (upClip/(iy2 - iy1)) + texture.topCropPercent;
			textureCoords[2] = texCoordOneLeft + (leftClip/(ix2 - ix1)) + texture.leftCropPercent;
			textureCoords[3] = texCoordOneBottom + (downClip/(iy2 - iy1)) + texture.bottomCropPercent;
			textureCoords[4] = texCoordOneRight + (rightClip/(ix2 - ix1)) + texture.rightCropPercent;
			textureCoords[5] = texCoordOneTop + (upClip/(iy2 - iy1)) + texture.topCropPercent;
			textureCoords[6] = texCoordOneRight + (rightClip/(ix2 - ix1)) + texture.rightCropPercent;
			textureCoords[7] = texCoordOneBottom + (downClip/(iy2 - iy1)) + texture.bottomCropPercent;
			
			
			/*
			textureCoords[0] = texture.leftCropPercent;
			textureCoords[1] = texture.topCropPercent;
			textureCoords[2] = texture.leftCropPercent;
			textureCoords[3] = 1.0f - texture.bottomCropPercent;
			textureCoords[4] = 1.0f - texture.rightCropPercent;
			textureCoords[5] = texture.topCropPercent;
			textureCoords[6] = 1.0f - texture.rightCropPercent;
			textureCoords[7] = 1.0f - texture.bottomCropPercent;
			*/
		}
	}
	
	//This might be better as this requires no preprocessing
	//like the bounds method.
	//Also it should make it easier to clip.
	
	//But, as it's too hard to do, this is unfinished. Use the bounds() and fill()
	//methods instead.
	
	void renderPixels( Draw draw, RenderMethod render_method, float centerX, float centerY, float ix1, float iy1, float ix2, float iy2, float iz = 0.0f )
	{
		if( g_rae is null || texture is null )
			return;
			
		isShown = true;
	
		float half_tex_w;
		float half_tex_h;
	
		if( orientation == OrientationType.HORIZONTAL )
		{
			half_tex_w = g_rae.pixel * ( (texture.width*(texCoordOneRight-texCoordOneLeft)) * 0.5f);
			half_tex_h = g_rae.pixel * ( (texture.height*(texCoordOneBottom-texCoordOneTop)) * 0.5f);
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			//In VERTICAL these are swapped. The texture will be rotated 90 degrees (or -90??)
			//but the texCoordOneLeft will still be the left of the texture, but it will then
			//correspond to the bottom of the rectangle... So all kinds of swapping will come
			//from that... Mainly into the texture coordinates calculation...
			half_tex_h = g_rae.pixel * ( (texture.width*(texCoordOneRight-texCoordOneLeft)) * 0.5f);
			half_tex_w = g_rae.pixel * ( (texture.height*(texCoordOneBottom-texCoordOneTop)) * 0.5f);
		}
		
		if( render_method == RenderMethod.PIXELS )
		{
			//Render the texture pixel per pixel.
			ix1 = centerX - half_tex_w;
			ix2 = centerX + half_tex_w;
			iy1 = centerY - half_tex_h;
			iy2 = centerY + half_tex_h;
		}
		else if( render_method == RenderMethod.PIXELS_HORIZONTAL )
		{
			//Stretch vertically but keep horizontal in pixels.
			ix1 = centerX - half_tex_w;
			ix2 = centerX + half_tex_w;
		}
		else if( render_method == RenderMethod.PIXELS_VERTICAL )
		{
			//Stretch horizontally but keep vertical in pixels.
			iy1 = centerY - half_tex_h;
			iy2 = centerY + half_tex_h;
		}
	
		
		
	
		//This is just daft. This should just change
		//the values of ix1... etc. in place.
		//Instead of putting the results in leftClip...
		//Maybe? Or do we need them later on???
		//...The answer: Yes we need them later.
		
		
		handleClipping( draw, ix1, iy1, ix2, iy2 );
	
		float ix1clip = ix1 + leftClip;
		float ix2clip = ix2 + rightClip;
		float iy1clip = iy1 + upClip;
		float iy2clip = iy2 + downClip;
	
		if( ix1clip > ix2clip || iy1clip > iy2clip )
		{
			isShown = false;
			return;
		}
		
		if( orientation == OrientationType.HORIZONTAL )
		{
			//0------------------2
			//|                  |
			//|                  |
			//|                  |
			//|                  |
			//|                  |
			//|                  |
			//|                  |
			//|                  |
			//1------------------3
			
			//0
			vertices[0] = ix1clip;//ix1
			vertices[1] = iy1clip;// + upClip;//-num;
			vertices[2] = iz;//0.0f;
			//1
			vertices[3] = vertices[0];//ix1clip;// + leftClip;//num;
			vertices[4] = iy2clip;// + downClip;//-num;
			vertices[5] = iz;//0.0f;
			//2
			vertices[6] = ix2clip;// + rightClip;//-num;
			vertices[7] = vertices[1];//iy1clip;// + upClip;//num;
			vertices[8] = iz;//0.0f;
			//3
			vertices[9] = vertices[6];//ix2clip;// + rightClip;//num;
			vertices[10] = vertices[4];//iy2clip;// + downClip;//num;
			vertices[11] = iz;//0.0f;
			
			if( texture.isTextureCoordsOne == true )
			{
				isTextureCoordsOne = true;
			
				/*
				textureCoords[0] = texture.leftCropPercent;
				textureCoords[1] = texture.topCropPercent;
				textureCoords[2] = texture.leftCropPercent;
				textureCoords[3] = 1.0f - texture.bottomCropPercent;
				textureCoords[4] = 1.0f - texture.rightCropPercent;
				textureCoords[5] = texture.topCropPercent;
				textureCoords[6] = 1.0f - texture.rightCropPercent;
				textureCoords[7] = 1.0f - texture.bottomCropPercent;
				*/
				
				//0
				textureCoords[0] = texCoordOneLeft + ((leftClip/(ix2 - ix1))*(texCoordOneRight-texCoordOneLeft)) + texture.leftCropPercent;
				textureCoords[1] = texCoordOneTop + ((upClip/(iy2 - iy1))*(texCoordOneBottom-texCoordOneTop)) + texture.topCropPercent;
				//1
				textureCoords[2] = textureCoords[0];//texCoordOneLeft + (leftClip/(ix2 - ix1)) + texture.leftCropPercent;
				textureCoords[3] = texCoordOneBottom + ((downClip/(iy2 - iy1))*(texCoordOneBottom-texCoordOneTop)) + texture.bottomCropPercent;
				//2
				textureCoords[4] = texCoordOneRight + ((rightClip/(ix2 - ix1))*(texCoordOneRight-texCoordOneLeft)) + texture.rightCropPercent;
				textureCoords[5] = textureCoords[1];//texCoordOneTop + (upClip/(iy2 - iy1)) + texture.topCropPercent;
				//3
				textureCoords[6] = textureCoords[4];//texCoordOneRight + (rightClip/(ix2 - ix1)) + texture.rightCropPercent;
				textureCoords[7] = textureCoords[3];//texCoordOneBottom + (downClip/(iy2 - iy1)) + texture.bottomCropPercent;
				
				//a silly fix for blurry borders when the texture
				//is smaller than it's pixel size in x or y axis.
				//The mipmapping will use too small versions
				//of the texture in these cases, and that will
				//make it blurry. This hack kind of fixes the
				//issue, but it introduces another, where
				//the texture is clipped if it is rendered too
				//small.
				
				if( render_method == RenderMethod.PIXELS_VERTICAL )
				{
					//tex_co_pix is the width (or height) in pixels of the to be rendered texture area according to texCoords.
					//orig_pix is the width (or height) of what actually fits to the area we're rendering in pixels.
					float tex_co_pix = ((textureCoords[4]*texture.width)-(textureCoords[0]*texture.width));
					float orig_pix = g_rae.screenHeightP*(ix2clip-ix1clip);
					
					//Trace.format("fix vertical. tex_co_pix: {} orig_pix: {} minus: {}", cast(double)tex_co_pix, cast(double)orig_pix, cast(double)(tex_co_pix-orig_pix) );
						
					//So if the number of pixels that we are going to render
					//is bigger than what fits there, then we clip the texture coordinates
					//accordingly, so that the result will fit there (in pixels.)
					if( orig_pix < tex_co_pix )
					{
						//Trace.formatln(" yes fix.");
						textureCoords[4] = textureCoords[4] - ((tex_co_pix - orig_pix)/texture.width);
						textureCoords[6] = textureCoords[4];
					}
					//else Trace.formatln(" no fix.");
				}
				
				if( render_method == RenderMethod.PIXELS_HORIZONTAL )
				{
					//tex_co_pix is the width (or height) in pixels of the to be rendered texture area according to texCoords.
					//orig_pix is the width (or height) of what actually fits to the area we're rendering in pixels.
					float tex_co_pix = ((textureCoords[3]*texture.height)-(textureCoords[1]*texture.height));
					float orig_pix = g_rae.screenHeightP*(iy2clip-iy1clip);
					
					//Trace.format("fix vertical. tex_co_pix: {} orig_pix: {} minus: {}", cast(double)tex_co_pix, cast(double)orig_pix, cast(double)(tex_co_pix-orig_pix) );
						
					//So if the number of pixels that we are going to render
					//is bigger than what fits there, then we clip the texture coordinates
					//accordingly, so that the result will fit there (in pixels.)
					if( orig_pix < tex_co_pix )
					{
						//Trace.formatln(" yes fix.");
						textureCoords[3] = textureCoords[3] - ((tex_co_pix - orig_pix)/texture.height);
						textureCoords[7] = textureCoords[3];
					}
					//else Trace.formatln(" no fix.");
				}
				
				/*
				//debug:
				if( leftClip > 0.0f )
				{
					Trace.formatln("leftClip: {}", cast(double)leftClip );
					Trace.formatln("rightClip: {}", cast(double)rightClip );
					Trace.formatln("leftClip percent: {}", cast(double)(leftClip/(ix2 - ix1)) );
					Trace.formatln("rightClip percent: {}", cast(double)(rightClip/(ix2 - ix1)) );
					Trace.formatln("texCoordLeft: {}", cast(double)textureCoords[0] );
					Trace.formatln("texCoordRIght: {}", cast(double)textureCoords[4] );
				}
				*/	
			}
			else
			{
				isTextureCoordsOne = false;
				//Without cropping it looks like this:
				/*
				textureCoords[0] = 0.0f;
				textureCoords[1] = 0.0f;
				textureCoords[2] = 0.0f;
				textureCoords[3] = texture.height;
				textureCoords[4] = texture.width;
				textureCoords[5] = 0.0f;
				textureCoords[6] = texture.width;
				textureCoords[7] = texture.height;
				*/
				
				float temphei = (texture.height*(1.0f-texture.bottomCropPercent-texture.topCropPercent));
				float tempwid = (texture.width*(1.0f-texture.leftCropPercent-texture.rightCropPercent));
				
				textureCoords[0] = ((leftClip/(ix2 - ix1))*tempwid);
				textureCoords[1] = ((upClip/(iy2 - iy1))*temphei);
				textureCoords[2] = ((leftClip/(ix2 - ix1))*tempwid);
				textureCoords[3] = temphei + ((downClip/(iy2 - iy1))*temphei);
				textureCoords[4] = tempwid + ((rightClip/(ix2 - ix1))*tempwid);
				textureCoords[5] = ((upClip/(iy2 - iy1))*temphei);
				textureCoords[6] = tempwid + ((rightClip/(ix2 - ix1))*tempwid);
				textureCoords[7] = temphei + ((downClip/(iy2 - iy1))*temphei);
			}
		
		}
		else if( orientation == OrientationType.VERTICAL )
		{	
			//2------------------3
			//|                  |
			//|                  |
			//|                  |
			//|                  |
			//|                  |
			//|                  |
			//|                  |
			//|                  |
			//0------------------1
			
			//0
			vertices[0] = ix1clip;//ix1
			vertices[1] = iy2clip;// + upClip;//-num;
			vertices[2] = iz;//0.0f;
			//1
			vertices[3] = ix2clip;//ix1clip;// + leftClip;//num;
			vertices[4] = vertices[1];// + downClip;//-num;
			vertices[5] = iz;//0.0f;
			//2
			vertices[6] = vertices[0];// + rightClip;//-num;
			vertices[7] = iy1clip;//iy1clip;// + upClip;//num;
			vertices[8] = iz;//0.0f;
			//3
			vertices[9] = vertices[3];//ix2clip;// + rightClip;//num;
			vertices[10] = vertices[7];//iy2clip;// + downClip;//num;
			vertices[11] = iz;//0.0f;
			
			if( texture.isTextureCoordsOne == true )
			{
				isTextureCoordsOne = true;
			
				/*
				textureCoords[0] = texture.leftCropPercent;
				textureCoords[1] = texture.topCropPercent;
				textureCoords[2] = texture.leftCropPercent;
				textureCoords[3] = 1.0f - texture.bottomCropPercent;
				textureCoords[4] = 1.0f - texture.rightCropPercent;
				textureCoords[5] = texture.topCropPercent;
				textureCoords[6] = 1.0f - texture.rightCropPercent;
				textureCoords[7] = 1.0f - texture.bottomCropPercent;
				*/
				
				
				//For a split second I actually understood this while doing
				//textureCoords[0] and [1]. But the bottom line is that leftCoord
				//still goes to x, but it is clipped with downClip, because that's
				//where it will be drawn. So, here's the fun swapping which I talked
				//about earlier. But it works.
				
				//One other thing was that the leftCoord/downClip and rightCoord/upClip pairs
				//had to minus, while on the horizontal they are summed. This is propably
				//clear to a lot of people, but for me it's just why I never quite grasped
				//mathematics.
				
				//0
				textureCoords[0] = texCoordOneLeft - ((downClip/(iy2 - iy1))*(texCoordOneRight-texCoordOneLeft)) + texture.leftCropPercent;
				textureCoords[1] = texCoordOneTop + ((leftClip/(ix2 - ix1))*(texCoordOneBottom-texCoordOneTop)) + texture.topCropPercent;
				//1
				textureCoords[2] = textureCoords[0];//texCoordOneLeft + ((downClip/(iy2 - iy1))*(texCoordOneRight-texCoordOneLeft)) + texture.leftCropPercent;
				textureCoords[3] = texCoordOneBottom + ((rightClip/(ix2 - ix1))*(texCoordOneBottom-texCoordOneTop)) + texture.bottomCropPercent;
				//2
				textureCoords[4] = texCoordOneRight - ((upClip/(iy2 - iy1))*(texCoordOneRight-texCoordOneLeft)) + texture.rightCropPercent;
				textureCoords[5] = textureCoords[1];//texCoordOneTop + ((leftClip/(ix2 - ix1))*(texCoordOneBottom-texCoordOneTop)) + texture.topCropPercent;
				//3
				textureCoords[6] = textureCoords[4];//texCoordOneRight + ((upClip/(iy2 - iy1))*(texCoordOneRight-texCoordOneLeft)) + texture.rightCropPercent;
				textureCoords[7] = textureCoords[3];//texCoordOneBottom + ((rightClip/(ix2 - ix1))*(texCoordOneBottom-texCoordOneTop)) + texture.bottomCropPercent;
				
				
				
				//a silly fix for blurry borders when the texture
				//is smaller than it's pixel size in x or y axis.
				//The mipmapping will use too small versions
				//of the texture in these cases, and that will
				//make it blurry. This hack kind of fixes the
				//issue, but it introduces another, where
				//the texture is clipped if it is rendered too
				//small.
				
				/*
				
				//Didn't have time to figure this one out, or test it:
				
				if( render_method == RenderMethod.PIXELS_VERTICAL )
				{
					//tex_co_pix is the width (or height) in pixels of the to be rendered texture area according to texCoords.
					//orig_pix is the width (or height) of what actually fits to the area we're rendering in pixels.
					float tex_co_pix = ((textureCoords[4]*texture.width)-(textureCoords[0]*texture.width));
					float orig_pix = g_rae.screenHeightP*(ix2clip-ix1clip);
					
					//Trace.format("fix vertical. tex_co_pix: {} orig_pix: {} minus: {}", cast(double)tex_co_pix, cast(double)orig_pix, cast(double)(tex_co_pix-orig_pix) );
						
					//So if the number of pixels that we are going to render
					//is bigger than what fits there, then we clip the texture coordinates
					//accordingly, so that the result will fit there (in pixels.)
					if( orig_pix < tex_co_pix )
					{
						//Trace.formatln(" yes fix.");
						textureCoords[4] = textureCoords[4] - ((tex_co_pix - orig_pix)/texture.width);
						textureCoords[6] = textureCoords[4];
					}
					//else Trace.formatln(" no fix.");
				}
				else
				*/ 
				if( render_method == RenderMethod.PIXELS_HORIZONTAL )
				{
					//tex_co_pix is the width (or height) in pixels of the to be rendered texture area according to texCoords.
					//orig_pix is the width (or height) of what actually fits to the area we're rendering in pixels.
					float tex_co_pix = ((textureCoords[4]*texture.width)-(textureCoords[0]*texture.width));
					float orig_pix = g_rae.screenHeightP*(iy2clip-iy1clip);
					
					//Trace.format("fix vertical. tex_co_pix: {} orig_pix: {} minus: {}", cast(double)tex_co_pix, cast(double)orig_pix, cast(double)(tex_co_pix-orig_pix) );
						
					//So if the number of pixels that we are going to render
					//is bigger than what fits there, then we clip the texture coordinates
					//accordingly, so that the result will fit there (in pixels.)
					if( orig_pix < tex_co_pix )
					{
						//Trace.formatln(" yes fix.");
						textureCoords[4] = textureCoords[4] - ((tex_co_pix - orig_pix)/texture.width);
						textureCoords[6] = textureCoords[4];
					}
					//else Trace.formatln(" no fix.");
				}
				
			}
			else
			{
				isTextureCoordsOne = false;
				
				float temphei = (texture.height*(1.0f-texture.bottomCropPercent-texture.topCropPercent));
				float tempwid = (texture.width*(1.0f-texture.leftCropPercent-texture.rightCropPercent));
				
				textureCoords[0] = ((leftClip/(ix2 - ix1))*tempwid);
				textureCoords[1] = ((upClip/(iy2 - iy1))*temphei);
				textureCoords[2] = ((leftClip/(ix2 - ix1))*tempwid);
				textureCoords[3] = temphei + ((downClip/(iy2 - iy1))*temphei);
				textureCoords[4] = tempwid + ((rightClip/(ix2 - ix1))*tempwid);
				textureCoords[5] = ((upClip/(iy2 - iy1))*temphei);
				textureCoords[6] = tempwid + ((rightClip/(ix2 - ix1))*tempwid);
				textureCoords[7] = temphei + ((downClip/(iy2 - iy1))*temphei);
			}
		
		}//if orientation == VERTICAL.
		
		fill();
	}
	
	void fill()
	{
		if( isShown == false ) return;
	
		drawType = GL_QUAD_STRIP;
		if( texture !is null )
			texture.pushTexture();
		draw();
		if( texture !is null )
			texture.popTexture();
	}
	
	void stroke()
	{
		if( isShown == false ) return;
		
		drawType = GL_LINE_STRIP;
		draw(true);
	}
	
	protected void draw(bool doStroke = false)
	{
		//TODO use Vertex buffer objects when available. Help would be needed there too.
			
			glPushClientAttrib( GL_CLIENT_VERTEX_ARRAY_BIT );

				//Enable vertex arrays for the data we're sending: vertices and
				//normals.
				glEnableClientState( GL_VERTEX_ARRAY );
				glEnableClientState( GL_NORMAL_ARRAY );
				//glEnableClientState( GL_COLOR_ARRAY );
				glEnableClientState( GL_TEXTURE_COORD_ARRAY );
			
				// Specify the data to be used for rendering, along with its
				//   format. OpenGL immediately copies the data into client
				//   memory.
				glVertexPointer( 3, GL_FLOAT, 0, verticesP );
				glNormalPointer( GL_FLOAT, 0, normalsP );
				glTexCoordPointer( 2, GL_FLOAT, 0, textureCoordsP);
			
				//Draw
				if( doStroke )
					glDrawElements( drawType, strokeIndices.length, GL_UNSIGNED_SHORT, strokeIndicesP );
				else
					glDrawElements( drawType, indices.length, GL_UNSIGNED_SHORT, indicesP );
				//glDrawElements( GL_TRIANGLES, m_numVerts, GL_UNSIGNED_SHORT, m_indicesP );
				//This would be faster, if we could get it to work. Help appreciated:
				//glDrawRangeElements( GL_TRIANGLE_STRIP, _idxStart, _idxEnd, m_numVerts, GL_UNSIGNED_SHORT, m_indicesP );
				
			glPopClientAttrib();
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
