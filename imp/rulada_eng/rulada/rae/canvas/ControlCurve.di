//From http://www.cse.unsw.edu.au/~lambert/splines/source.html
//Most propably written by Tim Lambert

/** This class represents a curve defined by a sequence of control points */

module rae.canvas.ControlCurve;


import tango.util.log.Trace;//Thread safe console output.

import Float = tango.text.convert.Float;

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

class Point
{
	this(float set_x, float set_y, float set_z)
	{
		x = set_x;
		y = set_y;
		z = set_z;
	}
	
	//~this() {}
	
	float x;
	float y;
	float z;
}

class Polygon
{
	uint npoints = 0;
	float[] xpoints;
	float[] ypoints;
	float[] zpoints;
	
	this()
	{
		//xpoints = new float[1];
		//ypoints = new float[1];
		//zpoints = new float[1];
	}
	
	~this()
	{
		delete xpoints;
		delete ypoints;
		delete zpoints;
	}
	
	void addPoint( float set_x, float set_y, float set_z = 0.0f )
	{
		npoints++;
		xpoints ~= set_x;
		ypoints ~= set_y;
		zpoints ~= set_z;
	}
	
	void removePoint(int to_remove)
	{
		if( to_remove < npoints )
		{
			npoints--;
			for( uint i = to_remove; i < npoints; i++ )
			{
				xpoints[i] = xpoints[i+1];
				ypoints[i] = ypoints[i+1];
				zpoints[i] = zpoints[i+1];
			}
			//TODO update the size of xpoints and ypoints
			//dynamic arrays...
			
		}
	}
	
	void renderLine()
	{
		glPushMatrix();
	
		glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		
		glBegin(GL_LINE_STRIP);
		glNormal3f( 0.0f, 0.0f, 1.0f );
		
			for(uint i = 0; i < npoints; i++)
			{
				//glTexCoord2f( 0.0f, 0.0f );
				glVertex3f( xpoints[i], ypoints[i], zpoints[i] );
			}
			
		glEnd();
		
		glPopMatrix();
	}
	
}

class ControlCurve
{
	protected Polygon pts;
	protected int selection = -1;
	
	public this()
	{
		pts = new Polygon();
	}

	//static Font f = new Font("Courier",Font.PLAIN,12);

	/** paint this curve into g.*/
	public void render()
	{
		//FontMetrics fm = g.getFontMetrics(f);
		//g.setFont(f);
		//int h = fm.getAscent()/2;
		
		/*for(uint i = 0; i < pts.npoints; i++)
		{
			//String s = Integer.toString(i);
			//int w = fm.stringWidth(s)/2;
			//g.drawString(Integer.toString(i),pts.xpoints[i]-w,pts.ypoints[i]+h);
		}*/
	}

	static final int EPSILON = 36;  /* square of distance for picking */

	/** return index of control point near to (x,y) or -1 if nothing near */
	public int selectPoint(float set_x, float set_y, float set_z = 0.0f )
	{
		//int mind = Integer.MAX_VALUE;
		float mind = float.max;
		selection = -1;
		for (uint i = 0; i < pts.npoints; i++)
		{
			float d = sqr(pts.xpoints[i]-set_x) + sqr(pts.ypoints[i]-set_y) + sqr(pts.zpoints[i]-set_z);
			if (d < mind && d < EPSILON)
			{
				mind = d;
				selection = i;
			}
		}
		return selection;
	}

	// square of a float
	static float sqr(float x)
	{
		return x*x;
	}
	
	/** add a control point, return index of new control point */
	public int addPoint(float set_x, float set_y, float set_z = 0.0f)
	{
		pts.addPoint(set_x,set_y,set_z);
		return selection = pts.npoints - 1;
	}

	/** set selected control point */
	public void setPoint(float set_x, float set_y, float set_z = 0.0f)
	{
		if (selection >= 0)
		{
			pts.xpoints[selection] = set_x;
			pts.ypoints[selection] = set_y;
			pts.zpoints[selection] = set_z;
		}
	}

	/** remove selected control point */
	public void removePoint()
	{
		if (selection >= 0)
		{
			pts.removePoint(selection);
		}
	}

	public char[] toString()
	{
		//StringBuffer result = new StringBuffer();
		char[] result = "";
		for( uint i = 0; i < pts.npoints; i++ )
		{
			result ~= " " ~ Float.toString(pts.xpoints[i]) ~ " " ~ Float.toString(pts.ypoints[i]) ~ " " ~ Float.toString(pts.zpoints[i]);
		}
		return result;
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
