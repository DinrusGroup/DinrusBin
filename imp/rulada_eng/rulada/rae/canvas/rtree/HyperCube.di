module rae.canvas.rtree.HyperCube;

//private import std.stdio;
//private import std.c.math;

import tango.util.container.LinkedList;
//private import rae.canvas.string;

import rae.canvas.Point;
//import rae.canvas.exception.illegalargumentexception;
//alias IllegalArgumentException ArithmeticException;

//private import ptl.plainrectangle;
//private 
///////////public import pihlaja.canvas.canvasitem;

//public alias PlainRectangle HyperCube;

///////////public alias CanvasItem HyperCube;


/+

//private import ptl.rtree.cloneable; //this must be some java thing...

/**
 * A HyperCube in the n-dimensional space. It is represented by two points of n dimensions each.
 * <p>
 * Implements basic calculation functions, like <B>getArea()</B> and <B>getUnionMbb()</B>.
 * <p>
 * Created: Tue May 18 14:33:37 1999
 * <p>
 * @author Hadjieleftheriou Marios
 * @version 1.1
 */
public class HyperCube// : Cloneable //this must be some java thing...
{
	private Point p1;

	private Point p2;

	public this(Point p1, Point p2)
	{
		if (p1 is null || p2 is null) throw new IllegalArgumentException("Points cannot be null.");

		if (p1.getDimension() != p2.getDimension()) throw new IllegalArgumentException("Points must be of the same dimension.");

		for (int i = 0; i < p1.getDimension(); i++)
		{
			if (p1.getFloatCoordinate(i) > p2.getFloatCoordinate(i)) throw new IllegalArgumentException("Give lower left corner first and upper right corner afterwards.");
		}

		this.p1 = cast(Point) p1.clone();
		this.p2 = cast(Point) p2.clone();
	}

	public int getDimension()
	{
		return p1.getDimension();
	}

	public Point getP1()
	{
		return cast(Point) p1.clone();
	}

	public Point getP2()
	{
		return cast(Point) p2.clone();
	}

	public bool equals(HyperCube h)
	{
		if (p1.equals(h.getP1()) && p2.equals(h.getP2()))
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	/**
	* Tests to see whether <B>h</B> has any common points with this HyperCube. If <B>h</B> is inside this
	* object (or vice versa), it returns true.
	*
	* @return True if <B>h</B> and this HyperCube intersect, false otherwise.
	*/
	public bool intersection(HyperCube h)
	{
		if (h is null) throw new IllegalArgumentException("HyperCube.intersection(..) : HyperCube cannot be null.");

		if (h.getDimension() != getDimension()) throw new IllegalArgumentException("HyperCube.intersection(..) : HyperCube dimension is different from current dimension.");

		bool intersect = true;
		for (int i = 0; i < getDimension(); i++)
		{
			if (p1.getFloatCoordinate(i) > h.p2.getFloatCoordinate(i) ||
				p2.getFloatCoordinate(i) < h.p1.getFloatCoordinate(i))
			{
				intersect = false;
				break;
			}
		}
		return intersect;
	}

	/**
	* Tests to see whether <B>h</B> is inside this HyperCube. If <B>h</B> is exactly the same shape
	* as this object, it is considered to be inside.
	*
	* @return True if <B>h</B> is inside, false otherwise.
	*/
	public bool enclosure(HyperCube h)
	{
		if (h is null) throw new
		IllegalArgumentException("HyperCube.enclosure(..) : HyperCube cannot be null.");

		if (h.getDimension() != getDimension()) throw new
		IllegalArgumentException("HyperCube.enclosure(..) : HyperCube dimension is different from current dimension.");

		bool inside = true;
		for (int i = 0; i < getDimension(); i++)
		{
			if (p1.getFloatCoordinate(i) > h.p1.getFloatCoordinate(i) ||
				p2.getFloatCoordinate(i) < h.p2.getFloatCoordinate(i))
			{
				inside = false;
				break;
			}
		}

		return inside;
	}

	/**
	* Tests to see whether <B>p</B> is inside this HyperCube. If <B>p</B> lies on the boundary
	* of the HyperCube, it is considered to be inside the object.
	*
	* @return True if <B>p</B> is inside, false otherwise.
	*/
	public bool enclosure(Point p)
	{
		if (p is null) throw new
		IllegalArgumentException("Point cannot be null.");

		if (p.getDimension() != getDimension()) throw new
		IllegalArgumentException("Point dimension is different from HyperCube dimension.");

		return enclosure(new HyperCube(p, p));
	}

	/**
	* Returns the area of the intersecting region between this HyperCube and the argument.
	*
	* Below, all possible situations are depicted.
	*
	*     -------   -------      ---------   ---------      ------         ------
	*    |2      | |2      |    |2        | |1        |    |2     |       |1     |
	*  --|--     | |     --|--  | ------  | | ------  |  --|------|--   --|------|--
	* |1 |  |    | |    |1 |  | ||1     | | ||2     | | |1 |      |  | |2 |      |  |
	*  --|--     | |     --|--  | ------  | | ------  |  --|------|--   --|------|--
	*     -------   -------      ---------   ---------      ------         ------
	*
	* @param h Given HyperCube.
	* @return Area of intersecting region.
	*/
	public float intersectingArea(HyperCube h)
	{
		if (!intersection(h))
		{
			return 0;
		}
		else
		{
		float ret = 1;
		for (int i = 0; i < getDimension(); i++)
		{
			float l1 = p1.getFloatCoordinate(i);
			float h1 = p2.getFloatCoordinate(i);
			float l2 = h.p1.getFloatCoordinate(i);
			float h2 = h.p2.getFloatCoordinate(i);

			if (l1 <= l2 && h1 <= h2) {
			// cube1 left of cube2.
			ret *= (h1 - l1) - (l2 - l1);
			} else if (l2 <= l1 && h2 <= h1) {
			// cube1 right of cube2.
			ret *= (h2 - l2) - (l1 - l2);
			} else if (l2 <= l1 && h1 <= h2) {
			// cube1 inside cube2.
			ret *= h1 - l1;
			} else if (l1 <= l2 && h2 <= h1) {
			// cube1 contains cube2.
			ret *= h2 - l2;
			} else if (l1 <= l2 && h2 <= h1) {
			// cube1 crosses cube2.
			ret *= h2 - l2;
			} else if (l2 <= l1 && h1 <= h2) {
			// cube1 crossed by cube2.
			ret *= h1 - l1;
			}
		}
		if (ret <= 0) throw new
			ArithmeticException("Intersecting area cannot be negative!");
		return ret;
		}
	}

	/**
	* Static impementation. Takes an array of HyperCubes and calculates the mbb of their
	* union.
	*
	* @param  a The array of HyperCubes.
	* @return The mbb of their union.
	*/
	public static HyperCube getUnionMbb(HyperCube[] a)
	{
		debug(0) writefln("HyperCube.getUnionMbb(HyperCube[] a)...START.").newline;
		if (a is null || a.size == 0) throw new
		IllegalArgumentException("HyperCube.getUnionMbb(HyperCube a[]) : HyperCube array is empty.");

		HyperCube h = cast(HyperCube) a[0].clone();

		if( h is null) writefln("HyperCube.getUnionMbb(HyperCube a[]) : Error: h is null.");
		else if( h is a[0]) writefln("HyperCube.getUnionMbb(HyperCube a[]) : Error: h is a[0].");
		else writefln("HyperCube.getUnionMbb(HyperCube a[]) : h is OK.");

		for (int i = 1; i < a.size; i++)
		{
			if(a[i] is null) writefln("a[i] is null i:", i);
			h = h.getUnionMbb(a[i]);
		}
		debug(0) writefln("HyperCube.getUnionMbb(HyperCube[] a)...END.").newline;
		return h;
	}

	/**
	* Return a new HyperCube representing the mbb of the union of this HyperCube and <B>h</B>
	*
	* @param  h The HyperCube that we want to union with this HyperCube.
	* @return  A HyperCube representing the mbb of their union.
	*/
	public HyperCube getUnionMbb(HyperCube h)
	{
		if (h is null)
			throw new IllegalArgumentException("HyperCube.getUnionMbb(HyperCube h) : HyperCube cannot be null.");

		if (h.getDimension() != getDimension())
			throw new IllegalArgumentException("HyperCube.getUnionMbb(HyperCube h) : HyperCubes must be of the same dimension.");

		debug(10) writefln( "this hyper: ", this, " and test hyper: ", h );

		float[] min = new float[getDimension()];
		float[] max = new float[getDimension()];

		for (int i = 0; i < getDimension(); i++)
		{
			min[i] = std.c.math.fminf(p1.getFloatCoordinate(i), h.p1.getFloatCoordinate(i));
			max[i] = std.c.math.fmaxf(p2.getFloatCoordinate(i), h.p2.getFloatCoordinate(i));
		}

		return new HyperCube(new Point(min), new Point(max));
	}

	/**
	* Returns the area of this HyperCube.
	*
	* @return The area as a float.
	*/
	public float getArea()
	{
		float area = 1;

		for (int i = 0; i < getDimension(); i++)
		{
			area *= p2.getFloatCoordinate(i) - p1.getFloatCoordinate(i);
		}

		return area;
	}

	/* The MINDIST criterion as described by Roussopoulos.
	FIXME: better description here...
	*/
	public float getMinDist(Point p)
	{
		if (p is null) throw new
		IllegalArgumentException("Point cannot be null.");

		if (p.getDimension() != getDimension()) throw new
		IllegalArgumentException("Point dimension is different from HyperCube dimension.");

		float ret = 0;
		for (int i = 0; i < getDimension(); i++)
		{
			float q = p.getFloatCoordinate(i);
			float s = p1.getFloatCoordinate(i);
			float t = p2.getFloatCoordinate(i);
			float r;

			if (q < s) r = s;
			else if (q > t) r = t;
			else r = q;

			ret += std.c.math.powf(std.c.math.fabsf(q - r), 2);
		}

		return ret;
	}

	public HyperCube clone()//Object clone()
	{
		return new HyperCube(cast(Point) p1.clone(), cast(Point) p2.clone());
	}

	public String toString()
	{
		return "P1" ~ p1.toString() ~ ":P2" ~ p2.toString();
	}

} // HyperCube

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
