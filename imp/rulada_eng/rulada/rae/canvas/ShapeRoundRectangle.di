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

module rae.canvas.ShapeRoundRectangle;

import tango.util.log.Trace;//Thread safe console output.

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
 
import rae.core.globals;
import rae.core.IRaeMain;
public import rae.canvas.IShape;
import rae.canvas.ShapeRectangle;
import rae.canvas.Image;
import rae.canvas.Draw;


/*
class ShapeRoundRectangle : IShape
{
public:
	this(float ix1, float iy1, float ix2, float iy2, float iz = 0.0f)
	{
		ShapeRectangle rect0 = new ShapeRectangle(ix1, iy1, ix2, iy2, iz);
		rects ~= rect0;
		ShapeRectangle rect1 = new ShapeRectangle(ix1, iy1, ix2, iy2, iz);
		rects ~= rect1;
		ShapeRectangle rect2 = new ShapeRectangle(ix1, iy1, ix2, iy2, iz);
		rects ~= rect2;
	}
	
	~this()
	{
		delete rects;
	}
	
	uint set_text_counter = 0;
	
	public Image texture( Image set )
	{
		if( rects.size >= 3 )
		{
			Image ret = rects[set_text_counter].texture = set;
			set_text_counter++;
			if( set_text_counter == 3 ) set_text_counter = 0;
			return ret;
		}
		//return m_texture = set;
		return null;
	}
	public Image texture()
	{
		if( rects.size >= 3 )
		{
			return rects[set_text_counter].texture;
		}
		//return m_texture;
		return null;
	}
	
	public bool isTextureCoordsOne() { return m_isTextureCoordsOne; }
	public bool isTextureCoordsOne(bool set)
	{
		foreach( ShapeRectangle re; rects )
			re.isTextureCoordsOne = set;
		return m_isTextureCoordsOne = set;
	}
	protected bool m_isTextureCoordsOne = true;
	
	void render(float ix1, float iy1, float ix2, float iy2, float iz = 0.0f)
	{
		bounds(ix1, iy1, ix2, iy2, iz);
		fill();
	}
	
	void bounds(float ix1, float iy1, float ix2, float iy2, float iz = 0.0f)
	{
		//0----2----------4----6
		//|    |          |    |
		//|    |          |    |
		//1----3----------5----7
		
		//float iwidth = (ix2 - ix1);
		float iheight = (iy2 - iy1);
		float half_num = iheight * 0.5f;
		
		rects[0].bounds( ix1, iy1, ix1 + half_num, iy2, iz );
		rects[1].bounds( ix1 + half_num, iy1, ix2 - half_num, iy2, iz );
		rects[2].bounds( ix2 - half_num, iy1, ix2, iy2, iz );
	}
	
	void fill()
	{
		foreach( ShapeRectangle re; rects )
			re.fill();
	}
	
	void stroke()
	{
		foreach( ShapeRectangle re; rects )
			re.stroke();
	}
	
	protected ShapeRectangle[] rects;
}
*/

class ShapeRoundRectangle : public ShapeRectangle
{
public:
	
	this(float ix1, float iy1, float ix2, float iy2, float iz = 0.0f)
	{
		super(ix1, iy1, ix2, iy2, iz);
		//init();
		//bounds(ix1, iy1, ix2, iy2, iz);
	}
		
	~this()
	{
		debug(ShapeRoundRectangle) Trace.formatln("ShapeRoundRectangle.~this().");
		delete vertices;
		delete indices;
		delete normals;
		delete textureCoords;
		
	}
	
	protected void init()
	{
		drawType = GL_QUAD_STRIP;
	
		numVerts = 8;
		numFaces = 6;//? QUAD?
		//idxStart = 0;
		//idxEnd = 5;
	
		vertices = new GLfloat[24];
		
		//GLfloat num = set_size;//1.0f;
		
		//fillDrawData();
		
		
				
		//indices = new GLushort[4];
		//This makes them static for this class,
		//all the instances will share these
		//but that's ok...
		indices = [ 0, 1, 2, 3, 4, 5, 6, 7 ];
		
		strokeIndices = [ 0, 1, 3, 2, 0 ];
		
		//normals = new GLfloat[12];
		normals = [
							0.0f, 0.0f, 1.0f,
							0.0f, 0.0f, 1.0f,
							0.0f, 0.0f, 1.0f,
							0.0f, 0.0f, 1.0f,
							0.0f, 0.0f, 1.0f,
							0.0f, 0.0f, 1.0f,
							0.0f, 0.0f, 1.0f,
							0.0f, 0.0f, 1.0f
						];
						
		//textureCoords = new GLfloat[8];
		textureCoords = [
								0.0f, 0.0f,
								0.0f, 1.0f,
								
								0.25f, 0.0f,
								0.25f, 1.0f,
								
								0.75f, 0.0f,
								0.75f, 1.0f,
								
								1.0f, 0.0f,
								1.0f, 1.0f
							];

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
		
		if( ix1clip > ix2clip ) isShown = false;
		if( iy1clip > iy2clip ) isShown = false;
		
		if( isShown == false ) return;
		
		float iwidth = (ix2 - ix1);
		float iheight = (iy2 - iy1);
		
		if( orientation == OrientationType.HORIZONTAL )
		{
			//0----2----------4----6
			//|    |          |    |
			//|    |          |    |
			//|    |          |    |
			//|    |          |    |
			//|    |          |    |
			//|    |          |    |
			//|    |          |    |
			//|    |          |    |
			//|    |          |    |
			//1----3----------5----7
			
			float half_num = iheight * 0.25f;
		
			//This is so odd. And hackish.
			//But this makes it so that the
			//points 2 and 3 in the above picture
			//only get clipped if the leftClip
			//is big enough to eat them. Otherwise
			//they'll stay in their normal positions
			//and only the points 0 and 1 get clipped.
			//Oh my. This is so bad design.
			//Give me my GLSL shaders already.
			float ix1half_numclip;
			if( leftClip > half_num )
				ix1half_numclip = ix1clip;
			else ix1half_numclip = ix1 + half_num;
		
			float ix2half_numclip;
			if( rightClip > half_num )
				ix2half_numclip = ix2clip;
			else ix2half_numclip = ix2 - half_num;
		
			//0
			vertices[0] = ix1clip;//-num;
			vertices[1] = iy1clip;//-num;
			vertices[2] = iz;//0.0f;
			//1
			vertices[3] = ix1clip;//num;
			vertices[4] = iy2clip;//-num;
			vertices[5] = iz;//0.0f;
			
			//2
			vertices[6] = ix1half_numclip;//ix1 + half_num;
			vertices[7] = iy1clip;
			vertices[8] = iz;
			//3
			vertices[9] = ix1half_numclip;//ix1 + half_num;
			vertices[10] = iy2clip;
			vertices[11] = iz;
			
			//4
			vertices[12] = ix2half_numclip;//ix2 - half_num;
			vertices[13] = iy1clip;
			vertices[14] = iz;
			//5
			vertices[15] = ix2half_numclip;//ix2 - half_num;
			vertices[16] = iy2clip;
			vertices[17] = iz;
			
			//6
			vertices[18] = ix2clip;//-num;
			vertices[19] = iy1clip;//num;
			vertices[20] = iz;//0.0f;
			//7
			vertices[21] = ix2clip;//num;
			vertices[22] = iy2clip;//num;
			vertices[23] = iz;//0.0f;
			
			
			if( texture !is null && texture.isTextureCoordsOne == true )
			{
				if( ix1clip < ix1half_numclip )
				{
					//0
					textureCoords[0] = ((vertices[6]-vertices[0])/half_num) * half_num;
					textureCoords[1] = (upClip/(iy2 - iy1));
					
					//1
					textureCoords[2] = textureCoords[0];
					textureCoords[3] = 1.0f-(downClip/(iy2 - iy1));
					
					//2
					textureCoords[4] = 0.25f;
					textureCoords[5] = textureCoords[1];//up
					
					//3
					textureCoords[6] = 0.25f;
					textureCoords[7] = textureCoords[3];//down
				}
				else if( ix1clip >= ix1half_numclip )//ix1clip is never actually bigger than ix2half_numclip.
				{
					//0
					textureCoords[0] = 0.25f;
					textureCoords[1] = (upClip/(iy2 - iy1));
					
					//1
					textureCoords[2] = textureCoords[0];
					textureCoords[3] = 1.0f-(downClip/(iy2 - iy1));
					
					//2
					textureCoords[4] = 0.25f;
					textureCoords[5] = textureCoords[1];//up
					
					//3
					textureCoords[6] = 0.25f;
					textureCoords[7] = textureCoords[3];//down
				}
				
				if( ix2clip > ix2half_numclip )
				{
					//4
					textureCoords[8] = 0.75f;
					textureCoords[9] = textureCoords[1];//up
					
					//5
					textureCoords[10] = 0.75f;
					textureCoords[11] = textureCoords[3];//down
					
					//6
					textureCoords[12] = ((vertices[18]-vertices[12])/half_num) * half_num;
					textureCoords[13] = textureCoords[1];//up
					
					//7
					textureCoords[14] = textureCoords[12];
					textureCoords[15] = textureCoords[3];//down
					
				}
				
			}
			
			//A very special case to fix mipmapping issues, e.g. in scrollbars
			//and buttons when they are very thin. The center bar will get
			//different mipmapping level than the borders, and that looks ugly.
			//This ofcourse shows some clipping, if the button theme is anything
			//other than a plain gradient in the x direction.
			
			//AArgh. It's not possible to affect that issue, with
			//the texture coordinates. Because the borders need to be
			//the same aspect so that the corners will appear rounded
			//and not skewed. Hmm. There's got to be some other workaround.
			/*
			if( texture !is null && (iwidth - (half_num*2.0f) < texture.width )
			{
				//textureCoords[0] = 0.0f;
				//textureCoords[1] = 0.0f;
				
				//textureCoords[2] = 0.0f;
				//textureCoords[3] = 1.0f;
				
				//textureCoords[4] = 0.25f;
				//textureCoords[5] = 0.0f;
				
				//textureCoords[6] = 0.25f;
				//textureCoords[7] = 1.0f;
				
				textureCoords[8] = 0.75f;
				textureCoords[9] = 0.0f;
				
				textureCoords[10] = 0.75f;
				textureCoords[11] = 1.0f;
				
				//textureCoords[12] = 1.0f;
				//textureCoords[13] = 0.0f;
				
				//textureCoords[14] = 1.0f;
				//textureCoords[15] = 1.0f;
			}
			*/
			
			/*
			//Could we remove this. If I remember correctly
			//this is only used by FBO's and ShapeRectangle.
			if( isTextureCoordsOne == false )
			{
				
				//0
				textureCoords[0] = 0.0f;
				textureCoords[1] = 0.0f;
				//1
				textureCoords[2] = 0.0f;
				textureCoords[3] = iheight / g_rae.pixel;
				
				//2
				textureCoords[4] = half_num / g_rae.pixel;
				textureCoords[5] = 0.0f;
				//3
				textureCoords[6] = textureCoords[4];//half_num / g_rae.pixel;
				textureCoords[7] = textureCoords[3];//iheight / g_rae.pixel;
				
				//4
				textureCoords[8] = (iwidth - half_num) / g_rae.pixel;
				textureCoords[9] = 0.0f;
				//5
				textureCoords[10] = textureCoords[8];//(iwidth - half_num) / g_rae.pixel;
				textureCoords[11] = textureCoords[3];//iheight / g_rae.pixel;
				
				//6
				textureCoords[12] = iwidth / g_rae.pixel;
				textureCoords[13] = 0.0f;
				//7
				textureCoords[14] = iwidth / g_rae.pixel;
				textureCoords[15] = textureCoords[3];//iheight / g_rae.pixel;
				
			}
			*/
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			//6-----------------------7
			//|                       |
			//|                       |
			//4-----------------------5
			//|                       |
			//|                       |
			//|                       |
			//|                       |
			//|                       |
			//2-----------------------3
			//|                       |
			//|                       |
			//0-----------------------1
		
			float half_num = iwidth * 0.25f;
		
			//0
			vertices[0] = ix1;//-num;
			vertices[1] = iy2;//-num;
			vertices[2] = iz;//0.0f;
			//1
			vertices[3] = ix2;//num;
			vertices[4] = iy2;//-num;
			vertices[5] = iz;//0.0f;
			
			//2
			vertices[6] = ix1;
			vertices[7] = (iy2 - half_num);
			vertices[8] = iz;
			//3
			vertices[9] = ix2;
			vertices[10] = (iy2 - half_num);
			vertices[11] = iz;
			
			//4
			vertices[12] = ix1;
			vertices[13] = (iy1 + half_num);
			vertices[14] = iz;
			//5
			vertices[15] = ix2;
			vertices[16] = (iy1 + half_num);
			vertices[17] = iz;
			
			//6
			vertices[18] = ix1;
			vertices[19] = iy1;
			vertices[20] = iz;
			//7
			vertices[21] = ix2;
			vertices[22] = iy1;
			vertices[23] = iz;
		}
	}
}

/+
//This is the version of the bounds method,
//before I added the very obscure, hackish and
//bad design which is the software clipping code
//above. I'm not very proud of it, but
//I tried many methods of doing it, and none of them
//worked.
//-OpenGL stencil buffer was slow.
//-OpenGL clipping planes was fast, but only worked
//on 2D. I couldn't get them to rotate according to
//the rotation of the objects. It _should_ be possible (?)
//but the mathematics and concepts for rotating the
//clipping planes was too much for me.
//-framebuffer objects. fast or slow depending on
//drivers. Not available always. Messes with transparency
//in a non fixable way (?). Hard to implement.
//-I didn't try doing a clipping shader, which
//would be the best option. But GLSL shaders are
//not available on my laptop (on Linux).
//Once they are, I'll make a shader for clipping,
//and just forget about older machines.

	void bounds(float ix1, float iy1, float ix2, float iy2, float iz = 0.0f)
	{
		float iwidth = (ix2 - ix1);
		float iheight = (iy2 - iy1);
		
		if( orientation == OrientationType.HORIZONTAL )
		{
			//0----2----------4----6
			//|    |          |    |
			//|    |          |    |
			//|    |          |    |
			//|    |          |    |
			//|    |          |    |
			//|    |          |    |
			//|    |          |    |
			//|    |          |    |
			//|    |          |    |
			//1----3----------5----7
			
			float half_num = iheight * 0.25f;
		
			//0
			vertices[0] = ix1;//-num;
			vertices[1] = iy1;//-num;
			vertices[2] = iz;//0.0f;
			//1
			vertices[3] = ix1;//num;
			vertices[4] = iy2;//-num;
			vertices[5] = iz;//0.0f;
			
			//2
			vertices[6] = ix1 + half_num;
			vertices[7] = iy1;
			vertices[8] = iz;
			//3
			vertices[9] = ix1 + half_num;
			vertices[10] = iy2;
			vertices[11] = iz;
			
			//4
			vertices[12] = ix2 - half_num;
			vertices[13] = iy1;
			vertices[14] = iz;
			//5
			vertices[15] = ix2 - half_num;
			vertices[16] = iy2;
			vertices[17] = iz;
			
			//6
			vertices[18] = ix2;//-num;
			vertices[19] = iy1;//num;
			vertices[20] = iz;//0.0f;
			//7
			vertices[21] = ix2;//num;
			vertices[22] = iy2;//num;
			vertices[23] = iz;//0.0f;
			
			//A very special case to fix mipmapping issues, e.g. in scrollbars
			//and buttons when they are very thin. The center bar will get
			//different mipmapping level than the borders, and that looks ugly.
			//This ofcourse shows some clipping, if the button theme is anything
			//other than a plain gradient in the x direction.
			
			//AArgh. It's not possible to affect that issue, with
			//the texture coordinates. Because the borders need to be
			//the same aspect so that the corners will appear rounded
			//and not skewed. Hmm. There's got to be some other workaround.
			/*
			if( texture !is null && (iwidth - (half_num*2.0f) < texture.width )
			{
				//textureCoords[0] = 0.0f;
				//textureCoords[1] = 0.0f;
				
				//textureCoords[2] = 0.0f;
				//textureCoords[3] = 1.0f;
				
				//textureCoords[4] = 0.25f;
				//textureCoords[5] = 0.0f;
				
				//textureCoords[6] = 0.25f;
				//textureCoords[7] = 1.0f;
				
				textureCoords[8] = 0.75f;
				textureCoords[9] = 0.0f;
				
				textureCoords[10] = 0.75f;
				textureCoords[11] = 1.0f;
				
				//textureCoords[12] = 1.0f;
				//textureCoords[13] = 0.0f;
				
				//textureCoords[14] = 1.0f;
				//textureCoords[15] = 1.0f;
			}
			*/
			
			/*
			//Could we remove this. If I remember correctly
			//this is only used by FBO's and ShapeRectangle.
			if( isTextureCoordsOne == false )
			{
				
				//0
				textureCoords[0] = 0.0f;
				textureCoords[1] = 0.0f;
				//1
				textureCoords[2] = 0.0f;
				textureCoords[3] = iheight / g_rae.pixel;
				
				//2
				textureCoords[4] = half_num / g_rae.pixel;
				textureCoords[5] = 0.0f;
				//3
				textureCoords[6] = textureCoords[4];//half_num / g_rae.pixel;
				textureCoords[7] = textureCoords[3];//iheight / g_rae.pixel;
				
				//4
				textureCoords[8] = (iwidth - half_num) / g_rae.pixel;
				textureCoords[9] = 0.0f;
				//5
				textureCoords[10] = textureCoords[8];//(iwidth - half_num) / g_rae.pixel;
				textureCoords[11] = textureCoords[3];//iheight / g_rae.pixel;
				
				//6
				textureCoords[12] = iwidth / g_rae.pixel;
				textureCoords[13] = 0.0f;
				//7
				textureCoords[14] = iwidth / g_rae.pixel;
				textureCoords[15] = textureCoords[3];//iheight / g_rae.pixel;
				
			}
			*/
		}
		else if( orientation == OrientationType.VERTICAL )
		{
			//6-----------------------7
			//|                       |
			//|                       |
			//4-----------------------5
			//|                       |
			//|                       |
			//|                       |
			//|                       |
			//|                       |
			//2-----------------------3
			//|                       |
			//|                       |
			//0-----------------------1
		
			float half_num = iwidth * 0.25f;
		
			//0
			vertices[0] = ix1;//-num;
			vertices[1] = iy2;//-num;
			vertices[2] = iz;//0.0f;
			//1
			vertices[3] = ix2;//num;
			vertices[4] = iy2;//-num;
			vertices[5] = iz;//0.0f;
			
			//2
			vertices[6] = ix1;
			vertices[7] = iy2 - half_num;
			vertices[8] = iz;
			//3
			vertices[9] = ix2;
			vertices[10] = iy2 - half_num;
			vertices[11] = iz;
			
			//4
			vertices[12] = ix1;
			vertices[13] = iy1 + half_num;
			vertices[14] = iz;
			//5
			vertices[15] = ix2;
			vertices[16] = iy1 + half_num;
			vertices[17] = iz;
			
			//6
			vertices[18] = ix1;
			vertices[19] = iy1;
			vertices[20] = iz;
			//7
			vertices[21] = ix2;
			vertices[22] = iy1;
			vertices[23] = iz;
		}
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
