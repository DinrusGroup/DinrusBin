module rae.canvas.Colour;

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


interface IColour
{
	float r();
	float g();
	float b();
	float a();
	
	void r( float set );
	void g( float set );
	void b( float set );
	void a( float set );	
}



class Colour : IColour
{
public:

	this()
	{
		set(1.0f, 1.0f, 1.0f, 1.0f);
	}

	this( float sr, float sg, float sb, float sa = 1.0f )
	{
		set(sr, sg, sb, sa);
	}

	char[] toString()
	{
		char[] ret;
		ret ~= "r: ";
		ret ~= Float.toString(r);
		ret ~= " g: ";
		ret ~= Float.toString(g);
		ret ~= " b: ";
		ret ~= Float.toString(b);
		ret ~= " a: ";
		ret ~= Float.toString(a);
		return ret;
	}

	void set( float sr, float sg, float sb, float sa = 1.0f )
	{
		r = sr; g = sg; b = sb; a = sa;
	}
	
	void set( float[] set_to )
	{
		if( set_to.length > 3 )
		{
			r = set_to[0];
			g = set_to[1];
			b = set_to[2];
			a = set_to[3];
		}
	}
	
	float[] get()
	{
		float[] result = new float[4];
		result[0] = r;
		result[1] = g;
		result[2] = b;
		result[3] = a;
		return result;
	}

	float r() { return _colour_data[0]; }
	float g() { return _colour_data[1]; }
	float b() { return _colour_data[2]; }
	float a() { return _colour_data[3]; }
	
	void r( float set ) { return _colour_data[0] = set; }
	void g( float set ) { return _colour_data[1] = set; }
	void b( float set ) { return _colour_data[2] = set; }
	void a( float set ) { return _colour_data[3] = set; }
		
	void apply()
	{
		glColor4f( r, g, b, a );
	}
		
	protected float[4] _colour_data;
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
