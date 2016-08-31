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

module rae.canvas.ShapeShadow;

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


class ShapeShadow : public ShapeRectangle
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
		debug(ShapeShadow) Stdout("ShapeShadow.~this().").newline;
		delete vertices;
		delete indices;
		delete normals;
		delete textureCoords;
		
	}
	/*
	//Texture handling is moved inside Shape.
	protected Image m_texture;
	public Image texture( Image set )
	{
		return m_texture = set;
	}
	public Image texture()
	{
		return m_texture;
	}
	
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

	//uint numVerts = 0;
	//uint numFaces = 0;
	//GLuint idxStart = 0;
	//GLuint idxEnd = 0;
	
	//protected uint drawType = GL_QUAD_STRIP;
	*/
	
	protected void init()
	{
		drawType = GL_QUADS;//GL_QUAD_STRIP;
	
		numVerts = 16;
		numFaces = 9;//? QUAD? //What?
		//idxStart = 0;
		//idxEnd = 5;
	
		vertices = new GLfloat[48];//3*16
		
		//GLfloat num = set_size;//1.0f;
		
		//fillDrawData();
		
		
				
		//indices = new GLushort[4];
		//This makes them static for this class,
		//all the instances will share these
		//but that's ok...
		indices = [
								0, 4, 5, 1,
								1, 5, 6, 2,
								2, 6, 7, 3,
								4, 8, 9, 5,
								5, 9, 10, 6, //It would be possible to skip this center tile. But we won't.
								6, 10, 11, 7,
								8, 12, 13, 9,
								9, 13, 14, 10,
								10, 14, 15, 11
							];
		
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
							0.0f, 0.0f, 1.0f,
							
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
								0.25f, 0.0f,
								0.75f, 0.0f,
								1.0f, 0.0f,
								
								0.0f, 0.25f,
								0.25f, 0.25f,
								0.75f, 0.25f,
								1.0f, 0.25f,
								
								0.0f, 0.75f,
								0.25f, 0.75f,
								0.75f, 0.75f,
								1.0f, 0.75f,
								
								0.0f, 1.0f,
								0.25f, 1.0f,
								0.75f, 1.0f,
								1.0f, 1.0f
							];

	}
	
	void render( Draw draw, float ix1, float iy1, float ix2, float iy2, float iz = 0.0f)
	{
		//bounds(ix1, iy1, ix2, iy2, iz);
		fill();
	}
	
	void bounds( Draw draw, float ix1, float iy1, float ix2, float iy2, float iz = 0.0f )
	{
		//Trace.formatln("Crap. ShapeShadow...API sucks.");
		//assert(0);
		bounds( draw, ix1,iy1,ix2,iy2,iz, g_rae.pixel*64.0f);
	}
	
	void bounds( Draw draw, float ix1, float iy1, float ix2, float iy2, float iz, float border_size )
	{
		//0----1----------2----3
		//|    |          |    |
		//|    |          |    |
		//4----5----------6----7
		//|    |          |    |
		//|    |          |    |
		//|    |          |    |
		//|    |          |    |
		//|    |          |    |
		//|    |          |    |
		//8----9---------10---11
		//|    |          |    |
		//|    |          |    |
		//12---13--------14---15
		
		if( g_rae is null ) return;//if we don't have a global rae, then
		//we aren't yet able to render anything.
		//This is to get unittests working.
		
		//Maybe this is some checking for the border_size*2
		//to be bigger than the window itself.
		float iwidth = (ix2 - ix1);
		float iheight = (iy2 - iy1);
		//float half_height = iheight;// * 0.5f;
		
		if( iwidth < iheight )
		{
			if( (border_size * 2.0f) > iwidth )
			{
				border_size = iwidth * 0.5f;
			}
		}
		else
		{
			if( (border_size * 2.0f) > iheight )
			{
				border_size = iheight * 0.5f;
			}
		}
		
		//HARDCODED PIXEL SIZE!
		//float border_size = (64.0f * g_rae.pixel);
		
		//0
		vertices[0] = ix1;
		vertices[1] = iy1;
		vertices[2] = iz;
		//1
		vertices[3] = (ix1 + border_size);
		vertices[4] = iy1;
		vertices[5] = iz;
		
		//2
		vertices[6] = (ix2 - border_size);
		vertices[7] = iy1;
		vertices[8] = iz;
		//3
		vertices[9] = ix2;
		vertices[10] = iy1;
		vertices[11] = iz;
		
		//4
		vertices[12] = ix1;
		vertices[13] = (iy1 + border_size);
		vertices[14] = iz;
		//5
		vertices[15] = (ix1 + border_size);
		vertices[16] = (iy1 + border_size);
		vertices[17] = iz;
		
		//6
		vertices[18] = (ix2 - border_size);
		vertices[19] = (iy1 + border_size);
		vertices[20] = iz;
		//7
		vertices[21] = ix2;
		vertices[22] = (iy1 + border_size);
		vertices[23] = iz;
		
		//8
		vertices[24] = ix1;
		vertices[25] = (iy2 - border_size);
		vertices[26] = iz;
		//9
		vertices[27] = (ix1 + border_size);
		vertices[28] = (iy2 - border_size);
		vertices[29] = iz;
		
		//10
		vertices[30] = (ix2 - border_size);
		vertices[31] = (iy2 - border_size);
		vertices[32] = iz;
		//11
		vertices[33] = ix2;
		vertices[34] = (iy2 - border_size);
		vertices[35] = iz;
		
		//12
		vertices[36] = ix1;
		vertices[37] = iy2;
		vertices[38] = iz;
		//13
		vertices[39] = (ix1 + border_size);
		vertices[40] = iy2;
		vertices[41] = iz;
		
		//14
		vertices[42] = (ix2 - border_size);
		vertices[43] = iy2;
		vertices[44] = iz;
		//15
		vertices[45] = ix2;
		vertices[46] = iy2;
		vertices[47] = iz;
		
/*
		if( isTextureCoordsOne == false )
		{
			
			//0
			textureCoords[0] = 0.0f;
			textureCoords[1] = 0.0f;
			//1
			textureCoords[2] = 0.0f;
			textureCoords[3] = iheight / g_rae.pixel;
			
			//2
			textureCoords[4] = half_height / g_rae.pixel;
			textureCoords[5] = 0.0f;
			//3
			textureCoords[6] = textureCoords[4];//half_height / g_rae.pixel;
			textureCoords[7] = textureCoords[3];//iheight / g_rae.pixel;
			
			//4
			textureCoords[8] = (iwidth - half_height) / g_rae.pixel;
			textureCoords[9] = 0.0f;
			//5
			textureCoords[10] = textureCoords[8];//(iwidth - half_height) / g_rae.pixel;
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
	
	void fill()
	{
		drawType = GL_QUADS;
		if( texture !is null )
			texture.pushTexture();
		draw();
		if( texture !is null )
			texture.popTexture();
	}
	
	void stroke()
	{
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
