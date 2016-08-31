module rae.canvas.Point;

//private import std.string;
private import Float = tango.text.convert.Float;

//private import ptl.string;//public alias char[] String;

//private import ptl.exception.illegalargumentexception;

/*
void arraycopy!(T)) ( in T[] from, int some1 = 0, inout T[] to, int some2 = 0, uint arra.size)
{
	for( uint i = 0; i < to.size; i++ )
	{
		to[i] = from[i];
	}
}*/

/**
 * A point in the n-dimensional space. All dimensions are stored in an array of floats.
 * <p>
 * Created: Tue May 18 15:01:38 1999
 * <p>
 * @author Hadjieleftheriou Marios
 * @version 1.1
 */

//Cloneable is some sort of abstract base class or interface????

public class Point// : Object implements Cloneable
{
public:

	this(float set_x, float set_y)
	{
		data = new float[2];
		data[0] = set_x;
		data[1] = set_y;
		//debug(1) assert(data.size == 2);
	}

	private float[] data;


	public this(float[] d)
	{
		if (d is null) throw new Exception("Coordinates cannot be null.");
		//IllegalArgument

		if (d.length < 2) throw new Exception("Point dimension should be greater than 1.");
		//IllegalArgument

		//copy d to data.
		data = d.dup;//new float[d.size];

		debug(1) assert(data.length == 2);
		//ptl.system.arraycopy( d, 0, data, 0, d.size );

		/*for( uint i = 0; i < data.size; i++ )
		{
			data[i] = d[i];
		}*/
	}

	public this(int[] d)
	{
		if (d is null) throw new Exception("Coordinates cannot be null.");
		//IllegalArgumentException("Coordinates cannot be null.");

		if (d.length < 2) throw new Exception("Point dimension should be greater than 1.");
		//IllegalArgumentException("Point dimension should be greater than 1.");

		data = new float[2];//[d.size];

		for (int i = 0; i < 2; i++)//d.size; i++)
		{
			data[i] = cast(float) d[i];
		}

		debug(1) assert(data.length == 2);
	}

	double x() { return data[0]; }
	double x( double set ) { return data[0] = set; }

	double y() { return data[1]; }
	double y( double set ) { return data[1] = set; }

	public float getFloatCoordinate(int i)
	{
		return data[i];
	}

	public int getIntCoordinate(int i)
	{
		return cast(int) data[i];
	}

	public int getDimension()
	{
		return 2;//data.size;
	}

	public bool equals(Point p)
	{
		if (p.getDimension() != getDimension())
		{
			throw new Exception("Points must be of equal dimensions to be compared.");
			//IllegalArgument
		}

		bool ret = true;
		for (int i = 0; i < getDimension(); i++)
		{
			if (getFloatCoordinate(i) != p.getFloatCoordinate(i))
			{
				ret = false;
				break;
			}
		}
		return ret;
	}

	public Point clone()//Object clone()
	{
		float[] f = data.dup;//new float[data.size];
		//ptl.system.arraycopy(data, 0, f, 0, data.size);
		/*for( uint i = 0; i < data.size; i++ )
		{
			f[i] = data[i];
		}*/

		return new Point(f);
	}

	public char[] toString()
	{
		char[] s = "(" ~ Float.toString( data[0] );

		debug(1) assert(data.size == 2);

		//for (int i = 1; i < 2; i++)//data.size; i++)
		//{
			s ~= " : " ~ Float.toString( data[1] );
		//}

		return s ~ ")";
	}

} // Point

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
