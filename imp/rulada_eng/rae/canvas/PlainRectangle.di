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

module rae.canvas.PlainRectangle;

//Circular import/LinkedList/GDC bug is the reason
//for this insanity. ICanvasItem and stuff is all
//in Rectangle until that bug is fixed in GDC.

import tango.util.log.Trace;//Thread safe console output.
import Float = tango.text.convert.Float;
import Utf = tango.text.convert.Utf;

import tango.util.container.LinkedList;

public import rae.gl.gl;
public import rae.gl.glu;
public import rae.gl.glext;
import rae.gl.util;

import rae.core.globals;
import rae.core.IRaeMain;

import rae.canvas.Draw;
import rae.canvas.Colour;
import rae.canvas.ICanvasItem;
import rae.canvas.IShape;
import rae.canvas.ShapeRectangle;
import rae.canvas.ShapeRoundRectangle;
import rae.canvas.ShapeShadow;
import rae.canvas.Image;
import rae.canvas.Gradient;
import rae.ui.Animator;
import rae.canvas.Point;
import rae.canvas.rtree.RTree;
import rae.ui.InputState;

public import rae.canvas.RenderMethod;

import rae.canvas.rtree.AbstractNode;
import rae.canvas.rtree.Node;
import rae.canvas.rtree.Index;

public enum ShadowType
{
	NONE,
	SQUARE,
	ROUND
}


/*
x1-y1                 w-x2-y1
-------------------------
|                       |
|                       |
|                       |
|                       |
|                       |
|           +           |
|          cx,cy        |
|                       |
|                       |
|                       |
|                       |
-------------------------
h-x1-y2               w-x2-y2

*/


unittest
{
	debug(PlainRectangle) Trace.formatln("unittest PlainRectangle.");

	//scope PlainRectangle rect = new PlainRectangle(0.0f, 0.0f, -0.0f, 0.0f, 1.0f, 1.0f);
	scope PlainRectangle rect = new PlainRectangle();
	debug(PlainRectangle) Trace.formatln("rect: {}", rect.toString() );
	rect.setXYWH( 0.0, 0.0, 1.0, 1.0 );
	debug(PlainRectangle) Trace.formatln("rect: {}", rect.toString() );
	assert( rect.x1 == 0.0f );
	assert( rect.y1 == 0.0f );
	assert( rect.w == 1.0f );
	assert( rect.h == 1.0f );
	assert( rect.x2 == 1.0f );
	assert( rect.y2 == 1.0f );
	assert( rect.cx == 0.5f );
	assert( rect.cy == 0.5f );
	
	float xposbef = rect.xPos;
	rect.w = 0.5;
	debug(PlainRectangle) Trace.formatln("rect: {}", rect.toString() );
	assert( rect.w == 0.5f );
	assert( rect.xPos == xposbef );
	
	float yposbef = rect.yPos;
	rect.h = 0.5;
	debug(PlainRectangle) Trace.formatln("rect: {}", rect.toString() );
	assert( rect.h == 0.5f );
	assert( rect.xPos == yposbef );
	
	rect.setXYWH( 0.0, 0.0, 0.5, 0.5 );
	debug(PlainRectangle) Trace.formatln("rect: {}", rect.toString() );
	assert( rect.x1 == 0.0f );
	assert( rect.y1 == 0.0f );
	assert( rect.w == 0.5f );
	assert( rect.h == 0.5f );
	assert( rect.x2 == 0.5f );
	assert( rect.y2 == 0.5f );
	assert( rect.cx == 0.25f );
	assert( rect.cy == 0.25f );
	rect.setXYXY( -0.5f, -0.5f, 0.5f, 0.5f );
	assert( rect.x1 == -0.5f );
	assert( rect.y1 == -0.5f );
	assert( rect.w == 1.0f );
	assert( rect.h == 1.0f );
	assert( rect.x2 == 0.5f );
	assert( rect.y2 == 0.5f );
	assert( rect.cx == 0.0f );
	assert( rect.cy == 0.0f );
	
	float mem_x1 = 0.0f;
	float mem_y1 = 0.0f;
	float mem_x2 = 0.0f;
	float mem_y2 = 0.0f;
	
	//test x1:
	debug(PlainRectangle) Trace.formatln("test x1.");
	debug(PlainRectangle) Trace.formatln("before rect: {}", rect.toString() );
	mem_y1 = rect.y1;
	mem_x2 = rect.x2;
	mem_y2 = rect.y2;
	rect.x1 = -1.0f;
	debug(PlainRectangle) Trace.formatln("after rect: {}", rect.toString() );
	assert( rect.x1 == -1.0f );
	assert( mem_y1 == rect.y1 );
	assert( mem_x2 == rect.x2 );
	assert( mem_y2 == rect.y2 );
	
	//test y1:
	mem_x1 = rect.x1;
	mem_x2 = rect.x2;
	mem_y2 = rect.y2;
	rect.y1 = -1.0f;
	assert( rect.y1 == -1.0f );
	assert( mem_x1 == rect.x1 );
	assert( mem_x2 == rect.x2 );
	assert( mem_y2 == rect.y2 );
	
	//test x2:
	mem_y1 = rect.y1;
	mem_x1 = rect.x1;
	mem_y2 = rect.y2;
	rect.x2 = 2.0f;
	assert( rect.x2 == 2.0f );
	assert( mem_y1 == rect.y1 );
	assert( mem_x1 == rect.x1 );
	assert( mem_y2 == rect.y2 );
	
	//test y2:
	mem_y1 = rect.y1;
	mem_x1 = rect.x1;
	mem_x2 = rect.x2;
	rect.y2 = 2.0f;
	assert( rect.y2 == 2.0f );
	assert( mem_y1 == rect.y1 );
	assert( mem_x1 == rect.x1 );
	assert( mem_x2 == rect.x2 );
	
	/*
	rect.cx( -0.5f );
	rect.cy( -0.5f );
	assert( rect.x == -1.0f );
	assert( rect.y == -1.0f );
	assert( rect.w == 1.0f );
	assert( rect.h == 1.0f );
	assert( rect.x2 == 0.0f );
	assert( rect.y2 == 0.0f );
	assert( rect.cx == -0.5f );
	assert( rect.cy == -0.5f );
	rect.cx( 0.0f );
	rect.cy( 0.0f );
	rect.moveTo( -0.5, -0.5 );
	*/
	
	/*
	assert( rect.x == -1.0f );
	assert( rect.y == -1.0f );
	assert( rect.w == 1.0f );
	assert( rect.h == 1.0f );
	assert( rect.x2 == 0.0f );
	assert( rect.y2 == 0.0f );
	assert( rect.cx == -0.5f );
	assert( rect.cy == -0.5f );
	*/
	
	//assert(0);
	
}



template IsSelectedMixin()
{
	//isSelected or not.
	void toggleIsSelected()
	{
		if( isSelected == true )
			isSelected = false;
		else isSelected = true;
	}
	bool isSelected() { return m_isSelected; }
	void isSelected(bool set)
	{
		m_isSelected = set;
	} 
	bool m_isSelected = false;
}




//class ICanvasItem : public ICanvasItem //TODO
class PlainRectangle : public ICanvasItem, IColour
{
public:

	mixin IsSelectedMixin;


	//****************************************
//HyperCube compatibility stuff for RTree:


	this(Point p1, Point p2)
	{
		debug(PlainRectangle) Trace.formatln("PlainRectangle.this(p1,p2) START.");
		debug(PlainRectangle) scope(exit) Trace.formatln("PlainRectangle.this(p1,p2) END.");
		//super();

		mainColour = new Colour();
		prelightColour = new Colour();
		updatePrelightColour();

		if (p1 is null || p2 is null) throw new Exception("PlainRectangle.this(p1, p2) Error: Points cannot be null.");

		if (p1.getDimension() != p2.getDimension()) throw new Exception("PlainRectangle.this(p1, p2) Error: Points must be of the same dimension.");

		for (int i = 0; i < p1.getDimension(); i++)
		{
			if (p1.getFloatCoordinate(i) > p2.getFloatCoordinate(i)) throw new Exception("PlainRectangle.this(p1, p2) Error: Give lower left corner first and upper right corner afterwards.");
		}

		//this.p1 = cast(Point) p1.clone();
		//this.p2 = cast(Point) p2.clone();

		setXYXY( p1.x, p1.y, p2.x, p2.y );
		
	}

		int getDimension()
	{
		//We don't support other dimensions than 2D.
		return 2;//p1.getDimension();
	}

	//This is just stupid, but this is for HyperCube and RTree compatibility.
	//It should be changed in RTree.
	protected Point p1()
	{
		return new Point(x1, y1);//cast(Point) p1.clone();
	}

	protected Point p2()
	{
		return new Point(x2, y2);//cast(Point) p1.clone();
	}

	Point getP1()
	{
		return new Point(x1, y1);//cast(Point) p1.clone();
	}

	Point getP2()
	{
		return new Point(x2, y2);//cast(Point) p2.clone();
	}

	bool equals(ICanvasItem h)
	{
		if( h.x1 == x1 && h.y1 == y1 && h.x2 == x2 && h.y2 == y2) //(p1.equals(h.getP1()) && p2.equals(h.getP2()))
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	/**
	* Tests to see whether <B>h</B> has any common points with this PlainRectangle. If <B>h</B> is inside this
	* object (or vice versa), it returns true.
	*
	* @return True if <B>h</B> and this PlainRectangle intersect, false otherwise.
	*/
	bool intersection(ICanvasItem rect)
	{
		if (rect is null) throw new Exception("PlainRectangle.intersection(..) : PlainRectangle cannot be null.");

		//if (h.getDimension() != getDimension()) throw new Exception("PlainRectangle.intersection(..) : PlainRectangle dimension is different from current dimension.");
		/*
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
		return intersect;*/
		//return isOverlap( h );//I guess this is the same thing as the above???
		
		debug(PlainRectangle) Trace.formatln("PlainRectangle.isOverlap(PlainRectangle rect) START and END.");
		/*
		//This version thinks that if they are equal they overlap.
		//We don't want this for our edits.
		if( //this != rect &&
			x1 <= rect.x2
			&& rect.x1 <= x2
			&& 1y <= rect.y2
			&& rect.y1 <= y2
		)
		*/

		//Instead we want to have edit's that don't overlap,
		//even if they share points. This is important for checkOverlapping stuff.
		if( //this != rect &&
			x1 < rect.x2
			&& rect.x1 < x2
			&& y1 < rect.y2
			&& rect.y1 < y2
		)
			return true;
		//else
		return false;
	}

	/**
	* Tests to see whether <B>h</B> is inside this PlainRectangle. If <B>h</B> is exactly the same shape
	* as this object, it is considered to be inside.
	*
	* @return True if <B>h</B> is inside, false otherwise.
	*/
	bool enclosure(ICanvasItem rect)
	{
		//if (h is null)
		//	throw new Exception("PlainRectangle.enclosure(..) : PlainRectangle cannot be null.");

		//if (h.getDimension() != getDimension()) throw new
		//Exception("PlainRectangle.enclosure(..) : PlainRectangle dimension is different from current dimension.");

		/*bool inside = true;
		for (int i = 0; i < //getDimension(); i++)
		{
			if (p1.getFloatCoordinate(i) > h.p1.getFloatCoordinate(i) ||
				p2.getFloatCoordinate(i) < h.p2.getFloatCoordinate(i))
			{
				inside = false;
				break;
			}
		}*/

		//return isInside( h );//inside;
		
		if( this !is rect
			&& rect !is null
			&& ((x1 - rect.x1) < 0.001)//x <= rect.x //There's some wierd bug here sometimes when they are supposed to be equal.!
			&& ((rect.x2 - x2) < 0.001)//rect.x2 <= x2
			&& ((y1 - rect.y1) < 0.001)//y <= rect.y
			&& ((rect.y2 - y2) < 0.001)//rect.y2 <= y2
		)
		{
			debug(hitting) Trace.formatln("PlainRectangle.isInside() YES it is inside.");
			/*Trace.formatln("name: {}", name);
			
			Trace.formatln("r.x1: {}", cast(double)rect.x1);
			Trace.formatln("r.y1: {}", cast(double)rect.y1);
			Trace.formatln("r.x2: {}", cast(double)rect.x2);
			Trace.formatln("r.y2: {}", cast(double)rect.y2);
			Trace.formatln("xPos: {}", cast(double)xPos);
			Trace.formatln("yPos: {}", cast(double)yPos);
			Trace.formatln("x1: {}", cast(double)x1);
			Trace.formatln("y1: {}", cast(double)y1);
			Trace.formatln("x2: {}", cast(double)x2);
			Trace.formatln("y2: {}", cast(double)y2);
			Trace.formatln("w: {}", cast(double)w);
			Trace.formatln("h: {}", cast(double)h);
			*/
			return true;
		}
		//else
		debug(hitting) Trace.formatln("PlainRectangle.isInside() NO it isn't inside.");
		debug(hitting)
		{
			debug(RTree)
			{
				if( this !is rect ) Trace.formatln("The rects are different. OK.");
				else Trace.formatln("The rects are the same reference. This is NOT OK.");

				if( rect !is null ) Trace.formatln("The rect is not null. OK.");
				else Trace.formatln("The rect is null. This is NOT OK.");

				if( x1 <= rect.x1 ) Trace.formatln("x <= rect.x == true. OK.");
				else Trace.formatln("x <= rect.x == false. This is NOT OK.");

				if( rect.x1 >= x1 ) Trace.formatln("rect.x >= x == true. OK.");
				else Trace.formatln("rect.x >= x == false. This is NOT OK.");

				if( x1 == rect.x1 ) Trace.formatln("x == rect.x == true. OK.");
				else Trace.formatln("x == rect.x == false. This is NOT OK.");

				if( x1 >= rect.x1 ) Trace.formatln("x >= rect.x == true. This is NOT OK.");
				else Trace.formatln("x >= rect.x == false. OK.");

				double differ = x1 - rect.x1;
				Trace.formatln("The difference is: ", differ);

				if( (x1 - rect.x1) < 0.001 ) Trace.formatln("(x - rect.x) < 0.001 == true. OK.");
				else Trace.formatln("(x - rect.x) < 0.001 == false. This is NOT OK.");

				if( rect.x2 <= x2 ) Trace.formatln("rect.x2 <= x2 == true. OK.");
				else Trace.formatln("rect.x2 <= x2 == false. This is NOT OK.");

				if( y1 <= rect.y1 ) Trace.formatln("y <= rect.y == true. OK.");
				else Trace.formatln("y <= rect.y == false. This is NOT OK.");

				if( rect.y2 <= y2 ) Trace.formatln("rect.y2 <= y2 == true. OK.");
				else Trace.formatln("rect.y2 <= y2 == false. This is NOT OK.");

				Trace.formatln("x:", x1);
				Trace.formatln("y:", y1);
				Trace.formatln("x2:", x2);
				Trace.formatln("y2:", y2);
				Trace.formatln("w:", w);
				Trace.formatln("h:", h);

				Trace.formatln("rect.x:", rect.x1);
				Trace.formatln("rect.y:", rect.y1);
				Trace.formatln("rect.x2:", rect.x2);
				Trace.formatln("rect.y2:", rect.y2);
				Trace.formatln("rect.w:", rect.w);
				Trace.formatln("rect.h:", rect.h);

				//if(  ) Trace.formatln(". OK.");
				//else Trace.formatln(". This is NOT OK.");
			}
		}
		return false;
	}

	/**
	* Tests to see whether <B>p</B> is inside this PlainRectangle. If <B>p</B> lies on the boundary
	* of the PlainRectangle, it is considered to be inside the object.
	*
	* @return True if <B>p</B> is inside, false otherwise.
	*/
	bool enclosure(Point p)
	{
		if (p is null) throw new
			Exception("PlainRectangle.enclosure(Point p) Error: Point cannot be null.");

		if (p.getDimension() != getDimension()) throw new
			Exception("PlainRectangle.enclosure(Point p) Error: Point dimension is different from PlainRectangle dimension.");

		return enclosure( p.x, p.y );//enclosure(new PlainRectangle(p, p) );
	}

	/**
	* Returns the area of the intersecting region between this PlainRectangle and the argument.
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
	* @param h Given PlainRectangle.
	* @return Area of intersecting region.
	*/
	float intersectingArea(ICanvasItem h)
	{
		//This might all be wrong, as it seems that our PlainRectangle is
		//defined differently than the HyperCubes... Let's make a
		//unittest.

		if ( !intersection(h) )
		{
			return 0.0f;
		}
		else
		{
			float ret = 1.0f;
			for (int i = 0; i < getDimension(); i++)
			{
				float l1 = p1.getFloatCoordinate(i);
				float h1 = p2.getFloatCoordinate(i);
				float l2 = h.getP1.getFloatCoordinate(i);
				float h2 = h.getP2.getFloatCoordinate(i);

				if (l1 <= l2 && h1 <= h2)
				{
					// cube1 left of cube2.
					ret *= (h1 - l1) - (l2 - l1);
				}
				else if (l2 <= l1 && h2 <= h1)
				{
					// cube1 right of cube2.
					ret *= (h2 - l2) - (l1 - l2);
				}
				else if (l2 <= l1 && h1 <= h2)
				{
					// cube1 inside cube2.
					ret *= h1 - l1;
				}
				else if (l1 <= l2 && h2 <= h1)
				{
					// cube1 contains cube2.
					ret *= h2 - l2;
				}
				else if (l1 <= l2 && h2 <= h1)
				{
					// cube1 crosses cube2.
					ret *= h2 - l2;
				}
				else if (l2 <= l1 && h1 <= h2)
				{
					// cube1 crossed by cube2.
					ret *= h1 - l1;
				}
			}
			if (ret <= 0) throw new Exception("Intersecting area cannot be negative!");
			return ret;
		}
	}

	/**
	* Static impementation. Takes an array of Rectangles and calculates the mbb of their
	* union.
	*
	* @param  a The array of Rectangles.
	* @return The mbb of their union.
	*/
	static ICanvasItem getUnionMbb(ICanvasItem[] a)
	{
		debug(PlainRectangle) Trace.formatln("PlainRectangle.getUnionMbb(PlainRectangle[] a)...START.");
		debug(PlainRectangle) scope(exit) Trace.formatln("PlainRectangle.getUnionMbb(PlainRectangle[] a)...END.");
		
		if (a is null || a.length == 0) throw new
		Exception("PlainRectangle.getUnionMbb(PlainRectangle a[]) : PlainRectangle array is empty.");

		//PlainRectangle h = new PlainRectangle( a[0] );//cast(PlainRectangle) a[0].clone();
		PlainRectangle h = new PlainRectangle( a[0] );
		
		/*debug(PlainRectangle)
		{
			if( h is null) Trace.formatln("PlainRectangle.getUnionMbb(PlainRectangle a[]) : Error: h is null.");
			else if( h is a[0]) Trace.formatln("PlainRectangle.getUnionMbb(PlainRectangle a[]) : Error: h is a[0].");
			else Trace.formatln("PlainRectangle.getUnionMbb(PlainRectangle a[]) : h is OK.");
		}*/

		for (int i = 1; i < a.length; i++)
		{
			if(a[i] is null) Trace.formatln("a[i] is null i:", i);
			//h = cast(PlainRectangle) h.getUnionMbb(a[i]);
			h = cast(PlainRectangle) h.getUnionMbb(a[i]);
		}
		
		return h;
	}

	/**
	* Return a new PlainRectangle representing the mbb of the union of this PlainRectangle and <B>h</B>
	*
	* @param  h The PlainRectangle that we want to union with this PlainRectangle.
	* @return  A PlainRectangle representing the mbb of their union.
	*/
	public ICanvasItem getUnionMbb(ICanvasItem h)
	{
		if (h is null)
			throw new Exception("PlainRectangle.getUnionMbb(PlainRectangle h) : PlainRectangle cannot be null.");

		//debug(PlainRectangle) Trace.formatln( "this rect: ", toString(), " and test rect: ", h.toString() );

		//if (h.getDimension() != getDimension())
		//	throw new Exception("PlainRectangle.getUnionMbb(PlainRectangle h) : Rectangles must be of the same dimension.");

		float[2] min;// = new float[2];//getDimension()];//2
		float[2] max;// = new float[2];//getDimension()];//2

		/*for (int i = 0; i < getDimension(); i++)
		{
			min[i] = std.c.math.fminf(p1.getFloatCoordinate(i), h.p1.getFloatCoordinate(i));
			max[i] = std.c.math.fmaxf(p2.getFloatCoordinate(i), h.p2.getFloatCoordinate(i));
		}*/

		min[0] = tango.math.Math.min( x1, h.x1 );
		min[1] = tango.math.Math.min( y1, h.y1 );

		max[0] = tango.math.Math.max( x2, h.x2 );
		max[1] = tango.math.Math.max( y2, h.y2 );

		//PlainRectangle reslt = new PlainRectangle();
		PlainRectangle reslt = new PlainRectangle();
		reslt.setXYXY( min[0], min[1], max[0], max[1] );

		return reslt;//new PlainRectangle(min[0], min[1], max[0], max[1]);//new Point(min), new Point(max));
	}

	/**
	* Returns the area of this PlainRectangle.
	*
	* @return The area as a float.
	*/
	float getArea()
	{
		/*float area = 1;

		for (int i = 0; i < getDimension(); i++)
		{
			area *= p2.getFloatCoordinate(i) - p1.getFloatCoordinate(i);
		}*/

		//return calcArea();//area;
		
		return w * h;
	}

	/* The MINDIST criterion as described by Roussopoulos.
	FIXME: better description here...
	*/
	float getMinDist(Point p)
	{
		if (p is null) throw new
		Exception("PlainRectangle.getMinDist(Point p) Error: Point cannot be null.");

		if (p.getDimension() != getDimension()) throw new
		Exception("PlainRectangle.getMinDist(Point p) Error: Point dimension is different from PlainRectangle dimension.");

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

			ret += tango.math.Math.pow(tango.math.Math.abs(q - r), 2);
		}

		return ret;
	}

	//ICanvasItem clone()//Object clone()
	//{
	//	return new PlainRectangle(x, y, w, h);//cast(Point) p1.clone(), cast(Point) p2.clone());
	//}

	public Node rtreeNode() { return m_rtreeNode; }//This is not quaranteed to be up to date at any time. It's only updated on a call to enclosureList(). Well maybe it's up to date now. Hopefully.
	public Node rtreeNode( Node set )
	{
		debug(RTree) Trace.formatln("rtreeNode(set) START.");
		debug(RTree) scope(exit) Trace.formatln("rtreeNode(set) END.");
		
		m_rtreeNode = set;
		debug(RTree)
		{
			Trace.formatln("PlainRectangle.rtreeNode(Node set) This item:{}", toString() );
			if( m_rtreeNode !is null ) Trace.formatln(" new rtreeNode: {}", m_rtreeNode.toString() );
		}
		return m_rtreeNode;
	}
	protected Node m_rtreeNode;

	/**
	* This must be called EVERYTIME after a canvasItem (of any kind: Edit, Scene, Track...)
	* is moved in any way. BUT, because adjusting an RTree is such an expensive operation
	* this is not done automatically when one calls e.g. x = x + 526.0;
	* That's why the programmer must be VERY carefull to add a call to adjustTree after
	* any series of movements made to a CanvasItem.
	*/

	//MOVE TO RECTANGLE:
	void adjustTree()//Used to update the tree above this node after this CanvasItem has moved.
	{
		debug(AdjustTree) Trace.formatln("PlainRectangle.adjustTree() START. this.name: {}", name );
		debug(AdjustTree) scope(exit) Trace.formatln("PlainRectangle.adjustTree() END.");

		//There's a bug in RTree here. rtreeNode is not updated always.

		//There should be an error check here for, NO not this:
		//if( rtreeNode !is null)
		//	Stdout();
		//But I've left it out for the time being, because then
		//Arrg. The tree gets changed, when changing track.
		//rtreeNode should be updated too....

		if( rtreeNode is null )
		{
			debug(AdjustTree) Trace.formatln("PlainRectangle.adjustTree() Known BUG in RTree: rtreeNode is null.");
			//debug(AdjustTree) throw new Exception( "PlainRectangle.adjustTree() rtreeNode is null." );
		}
		else
		{
			Index p = cast(Index) rtreeNode.getParent();
			//Index p = cast(Index) rtreeNode;
			if (p !is null)
			{
				//debug(AdjustTree) Stdout("PlainRectangle.adjustTree() p !is null.");
				p.adjustTree( cast(AbstractNode) rtreeNode, null);
			}
			else
			{
				debug(AdjustTree) Trace.formatln("PlainRectangle.adjustTree() p is null ERROR here. rtreeNode: {}", rtreeNode.toString() );
				//debug(AdjustTree) throw new Exception( "PlainRectangle.adjustTree() p is null." );
			}
		}

		/*if( parent !is null )
		{
			debug(AdjustTree) Stdout("PlainRectangle.adjustTree() going to call parent.adjustTree().");
			//IS this necessary... They'are separate trees are they not.??
			parent.adjustTree();//e.g. if this is Edit, this calls the parent Scene to adjust it's Tree and so on recursively to the top Movie/Canvas.
		}
		else debug(AdjustTree) Stdout("PlainRectangle.adjustTree() Didn't have a parent.");
		*/

		
	}


//LinkedList!(ICanvasItem) enclosureList( double tx, double ty, inout LinkedList!(ICanvasItem) hit_items = null )
ICanvasItem[] enclosureList( double tx, double ty, inout ICanvasItem[] hit_items = null )
{
	return enclosureList( tx, ty, 0.0, 0.0, hit_items );
}

//LinkedList!(ICanvasItem) enclosureList( double tx, double ty, double tw, double th, inout LinkedList!(ICanvasItem) hit_items = null )
ICanvasItem[] enclosureList( double tx, double ty, double tw, double th, inout ICanvasItem[] hit_items = null )
{
	throw new Exception("PlainRectangle.enclosureList(...) is not implemented.");
	return null;
}

bool mouseEvent( InputState input, bool dive_lower = true )
{
	throw new Exception("PlainRectangle.mouseEvent(...) is not implemented.");
	return false;
}

bool onEnterNotify( InputState input )
{
	throw new Exception("PlainRectangle.onEnterNotify(...) is not implemented.");
	return false;
}

bool onLeaveNotify( InputState input )
{
	throw new Exception("PlainRectangle.onLeaveNotify(...) is not implemented.");
	return false;
}

//End hypercube compatibility stuff.
//********************************************



	this()
	{
		debug(PlainRectangle) Trace.formatln("PlainRectangle.this() START.");
		debug(PlainRectangle) scope(exit) Trace.formatln("PlainRectangle.this() END.");
		
		mainColour = new Colour();
		prelightColour = new Colour();
		updatePrelightColour();
		
		//This defines the default colour of all
		//widgets and everything. Let it be 18% grey...?
		//No, let it be white. That's the only obvious default.
		colour( 1.0f, 1.0f, 1.0f, 1.0f );
		//colour( 0.18f, 0.18f, 0.18f, 1.0f );
		
		shape = ShapeType.RECTANGLE;
		//shape = new ShapeRectangle(ix1, iy1, ix2, iy2);
	}

	//Set x1, x2, y1, y2 in parent coordinates.
	this( float sx1, float sy1, float sx2, float sy2 )
	{
		debug(PlainRectangle) Trace.formatln("PlainRectangle.this(4) START.");
		debug(PlainRectangle) scope(exit) Trace.formatln("PlainRectangle.this(4) END.");
		
		mainColour = new Colour();
		prelightColour = new Colour();
		updatePrelightColour();
		
		//These won't work as these will
		//change stuff on the way...
		//x1 = sx1;
		//y1 = sy1;
		//x2 = sx2;
		//y2 = sy2;
		
		
		setXYXY(sx1, sy1, sx2, sy2);
		
		colour( 1.0f, 1.0f, 1.0f, 1.0f );
		
		shape = ShapeType.RECTANGLE;
		//shape = new ShapeRectangle(ix1, iy1, ix2, iy2);
	}

	//Set xPos, yPos in parent coordinates
	//and set ix1, ix2, iy1, iy2 in local coordinates
	this( float set_pos_x, float set_pos_y, float six1, float siy1, float six2, float siy2 )
	{
		debug(PlainRectangle) Trace.formatln("PlainRectangle.this(6) START.");
		debug(PlainRectangle) scope(exit) Trace.formatln("PlainRectangle.this(6) END.");
		
		mainColour = new Colour();
		prelightColour = new Colour();
		updatePrelightColour();
		
		_xPos = set_pos_x;
		_yPos = set_pos_y;
		_zPos = 0.0f;
		
		_ix1 = six1;
		_iy1 = siy1;
		_ix2 = six2;
		_iy2 = siy2;
		
		colour( 1.0f, 1.0f, 1.0f, 1.0f );
		
		shape = ShapeType.RECTANGLE;
		//shape = new ShapeRectangle(ix1, iy1, ix2, iy2);
	}
	
	this( ICanvasItem setme )
	{
		mainColour = new Colour();
		prelightColour = new Colour();
		updatePrelightColour();
	
		_xPos = setme.xPos;
		_yPos = setme.yPos;
		_zPos = setme.zPos;
		
		setXYXY( setme.x1, setme.y1, setme.x2, setme.y2 );
		
		colour( setme.r, setme.g, setme.b, setme.a );
		
		shape = ShapeType.RECTANGLE;
		//shape = new ShapeRectangle(ix1, iy1, ix2, iy2);
	}
	
	this( PlainRectangle setme )
	{
		mainColour = new Colour();
		prelightColour = new Colour();
		updatePrelightColour();
		
		_xPos = setme.xPos;
		_yPos = setme.yPos;
		_zPos = setme.zPos;
		
		_ix1 = setme.ix1;
		_iy1 = setme.iy1;
		_ix2 = setme.ix2;
		_iy2 = setme.iy2;
		
		colour( setme.r, setme.g, setme.b, setme.a );
		
		shape = ShapeType.RECTANGLE;
		//shape = new ShapeRectangle(ix1, iy1, ix2, iy2);
	}
	
	~this()
	{
	}
	
	ICanvasItem dup()
	{
		return new PlainRectangle(this);
	}
	
	char[] toString()
	{
		
		char[] ret;// = "\nSTART ";
		ret ~= Utf.toString(name);
		ret ~= "\nxPos: ";
		ret ~= Float.toString(xPos);
		ret ~= " yPos: ";
		ret ~= Float.toString(yPos);
		ret ~= " x1: ";
		ret ~= Float.toString(x1);
		ret ~= " y1: ";
		ret ~= Float.toString(y1);
		ret ~= " x2: ";
		ret ~= Float.toString(x2);
		ret ~= " y2: ";
		ret ~= Float.toString(y2);
		ret ~= " w: ";
		ret ~= Float.toString(w);
		ret ~= " h: ";
		ret ~= Float.toString(h);
		
		//ret ~= "\nEND " ~ name;
		
		return ret;
	}

	//name
	
	//dchar[] is an UTF-32 unicode string.
	public dchar[] name(){ return m_name; }
	public void name(dchar[] set){ m_name = set; }
	protected dchar[] m_name = "";

	//Position
	public float xPos() { return _xPos; }
	public void xPos(float set)
	{
		_xPos = set;
		invalidate();
		//return _xPos;
	}
	public void xPosN(float set)
	{
		_xPos = set;
		//invalidate();
		//return _xPos;
	}
	protected float _xPos = 0.0f;
	
	public float yPos() { return _yPos; }
	public void yPos(float set)
	{
		_yPos = set;
		invalidate();
		//return _yPos;
	}
	public void yPosN(float set)
	{
		_yPos = set;
		//invalidate();
		//return _yPos;
	}
	protected float _yPos = 0.0f;
	
	public float zPos() { return _zPos; }
	public void zPos(float set)
	{
		_zPos = set;
		invalidate();
		//return _zPos;
	}
	public void zPosN(float set)
	{
		_zPos = set;
		//invalidate();
		//return _zPos;
	}
	protected float _zPos = 0.0f;

	void move( float delta_x, float delta_y )
	{
		_xPos += delta_x;
		_yPos += delta_y;
		invalidate();
	}
	
	void moveN( float delta_x, float delta_y )
	{
		_xPos += delta_x;
		_yPos += delta_y;
		//invalidate();
	}

	void moveTo( float to_x, float to_y )
	{
		_xPos = to_x;
		_yPos = to_y;
		invalidate();
	}
	
	void moveToN( float to_x, float to_y )
	{
		_xPos = to_x;
		_yPos = to_y;
		//invalidate();
	}

	
	//LAYER SYSTEM!?:
	//make the default layer to be numbered something like 5000.
	//and 0 to be the topmost. This way we can put 5000 layers above the
	//default setting. "That should be enough for everybody..."
	//This will basically affect the drawing order of the widgets.
	public int layer() { return m_layer; }
	public int layer(int set) { return m_layer = set; }
	protected int m_layer = 5000;

	//ZOrder.
	//The zPos() is the z position where the object should be
	//drawn. This is usually 0.0 in Rae. It doesn't reflect
	//which of the objects is topmost.
	//The z() is a z position for the actual PlainRectangle that
	//is drawn. It could be different than zPos, but usually
	//it's just 0.0. Maybe it is redundant? I don't know yet.
	//zOrder defines which object should be drawn topmost.
	//zOrder of 0 is the topmost object in the container Widget.
	//Update: see layer system above. We might use it instead.
	
	//internal
	public uint zOrder() { return _zOrder; }
	public uint zOrder(uint set) { return _zOrder = set; }
	protected uint _zOrder = 0;

	//3D rotations
	public float xRot() { return _xRot; }
	public void xRot(float set)
	{
		_xRot = set;
		invalidate();
		//return _xRot;
	}
	protected float _xRot = 0.0f;
	
	public float yRot() { return _yRot; }
	public void yRot(float set)
	{
		_yRot = set;
		invalidate();
		//return _yRot;
	}
	protected float _yRot = 0.0f;
	
	public float zRot() { return _zRot; }
	public void zRot(float set)
	{
		_zRot = set;
		invalidate();
		//return _zRot;
	}
	protected float _zRot = 0.0f;
	
	//Scale or Zoom.
	public float scale() { return _scale; }
	public void scale(float set)
	{
		_scale = set;
		invalidate();
		//return _scale;
	}
	protected float _scale = 1.0f;
	
	public OrientationType orientation() { return m_orientation; }
	public OrientationType orientation(OrientationType set)
	{
		m_orientation = set;
		if( shape !is null )
			shape.orientation = set;
		return m_orientation;
	}
	protected OrientationType m_orientation = OrientationType.HORIZONTAL;
	
	//If this Rectangle is double-sided or not.
	//If it is, we'll use OpenGL culling to remove
	//the back.
	bool isDoubleSided() { return m_isDoubleSided; }
	bool isDoubleSided(bool set) { return m_isDoubleSided = set; }
	protected bool m_isDoubleSided = false;
	
	//To draw an outline or not...
	bool isOutline() { debug(outline)return true; /*else*/ return m_isOutline; }
	bool isOutline(bool set)
	{
		if( set == true && outlineColour is null ) outlineColour = new Colour(0.0f, 0.0f, 0.0f, a);
		return m_isOutline = set;
	}
	protected bool m_isOutline = false;//false;
	
	double frameTime(){ return 0.0; }
	void idle(){}
	
	//public API:
	public void shape(ShapeType set_type)
	{
		if( m_shape !is null ) delete m_shape;
		switch(set_type)
		{
			case ShapeType.RECTANGLE:
				shape = new ShapeRectangle(ix1, iy1, ix2, iy2);
			break;
			case ShapeType.ROUND_RECTANGLE:
				shape = new ShapeRoundRectangle(ix1, iy1, ix2, iy2);
			break;
			case ShapeType.SHADOW://ShapeType.ROUND_CORNERS:
				shape = new ShapeShadow(ix1, iy1, ix2, iy2);
			break;
		}
	}
	
	//internal API:
	public IShape shape() { return m_shape; }
	public IShape shape(IShape set)
	{
		m_shape = set;
		m_shape.orientation = orientation;
		return m_shape;
	}
	protected IShape m_shape;
	
	//Shadows:
	public ShadowType shadowType(ShadowType set)
	{
		if( set == m_shadowType )
		{
			return m_shadowType;
		}
	
		m_shadowType = set;
	
		if( set == ShadowType.NONE )
		{
			if( shapeShadow !is null )
				delete shapeShadow;
		}
		else
		{
			if( shapeShadow is null )
			{
				shapeShadow = new ShapeShadow(ix1, iy1, ix2, iy2);
				//shapeShadow = new ShapeRectangle(ix1, iy1, ix2, iy2);
			}
			
			if( m_shadowType == ShadowType.SQUARE )
			{
				//shapeShadow.texture = g_rae.getTextureFromTheme("Rae.ShapeShadow.square");
				shapeShadow.themeTexture = "Rae.ShapeShadow.square";
			}
			else if( m_shadowType == ShadowType.ROUND )
			{
				//shapeShadow.texture = g_rae.getTextureFromTheme("Rae.ShapeShadow.round");
				shapeShadow.themeTexture = "Rae.ShapeShadow.round";
			}
			else Trace.formatln("PlainRectangle.updateShadowTexture() strange parameter for a shadow: ShadowType.NONE.");
		}
		return m_shadowType;
	}
	public ShadowType shadowType() { return m_shadowType; }
	protected ShadowType m_shadowType = ShadowType.NONE;
	//protected Shadow shadow;
	//protected IShape shapeShadow;
	protected ShapeShadow shapeShadow;
	
	protected void updateShadowTexture()
	{
		if( shapeShadow is null )
			return;
	
		shapeShadow.updateThemeTexture( tr_w_i2l(w), tr_h_i2l(h) );
	}
	
	/*
	TODO interface IShape
	{
		void bounds(xyz);
		void fill();
		void stroke();
	}
	
	/*
	These are not accurate for Rae, but just
	a reminder of how Clutter does it...
	From Clutter docs:
	1. Translation by actor x, y coords,
	2. Scaling by scale_x, scale_y,
	//Not in Rae: 3. Negative translation by anchor point x, y,
	4. Rotation around z axis,
	5. Rotation around y axis,
	6. Rotation around x axis,
	//Not in Rae: 7. Translation by actor depth (z),
	8. Clip stencil is applied (not an operation on the matrix as such, but done as part of the transform set up).
	*/
	
	void beginRender(Draw draw)
	{
		draw.pushMatrix();
			draw.translate( xPos, yPos, zPos );
			draw.rotate( xRot, yRot, zRot );
			//TODO later draw.rotate( rotationMatrix );
			draw.scale( scale, scale, scale ); //Maybe... only affects drawing and that's not so nice.
			draw.culling( !isDoubleSided );
			//draw.culling( false );
	}
	
	void endRender(Draw draw)
	{
		draw.popMatrix();
	}
	
	public dchar[] fullName(dchar[] recursive = "")
	{
		return name ~ "." ~ recursive; 
	}
	
	public bool isClipping() { return m_isClipping; }
	public bool isClipping(bool set) { return m_isClipping = set; }
	protected bool m_isClipping = true;
	
	public bool isClipByParent() { return m_isClipByParent; }
	public bool isClipByParent(bool set) { return m_isClipByParent = set; }
	protected bool m_isClipByParent = true;
	
	void renderBody( Draw draw )
	{
		//TODO
		//glColor4f(r, g, b, a);
		applyColour();
		
		shape.bounds( draw, ix1, iy1, ix2, iy2, iz);
		shape.fill();
		//draw.bounds( shape, ix1, iy1, ix2, iy2, iz );
		//draw.fill( shape );
		
		if(isOutline && outlineColour !is null)
		{
			//TODO outlineColour...
			//glColor4f(r*0.5f, g*0.5f, b*0.5f, a);
			//glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
			//glColor4f( outlineColour.r, outlineColour.g, outlineColour.b, outlineColour.a );
			applyOutlineColour();
			shape.stroke();
			//draw.stroke( shape );
		}
	}
	
	
	/**
	* These are the properties used for the RenderMethod.ASPECT
	* Which will render using a fixed aspectratio defined by
	* xAspect and yAspect. It will always draw a smaller rectangle
	* inside the area defined by x1,x2,y1,y2. In video this would
	* be called letterboxing.
	*/
	
	void aspectRatioAnim( float to_set_x, float to_set_y, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &xAspect, &xAspect, &yAspect, &yAspect, null, null, set_when_finished );
		to_anim.animateTo( to_set_x, to_set_y, 0.0f );
		add(to_anim);
	}
	
	public float xAspect() { return m_xAspect; }
	public void xAspect(float set)
	{
		m_xAspect = set;
		arrange();
		invalidate();
		//return m_xAspect;
	}
	void xAspectAnim( float to_set, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &xAspect, &xAspect, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
	}
	protected float m_xAspect = 1.78f;
	
	public float yAspect() { return m_yAspect; }
	public void yAspect(float set)
	{
		m_yAspect = set;
		arrange();
		invalidate();
		//return m_yAspect;
	}
	void yAspectAnim( float to_set, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &yAspect, &yAspect, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
	}
	protected float m_yAspect = 1.0f;
	
	
	RenderMethod renderMethod() { return m_renderMethod; }
	RenderMethod renderMethod(RenderMethod set) { return m_renderMethod = set; }
	RenderMethod m_renderMethod = RenderMethod.NORMAL;
	
	void render( Draw draw )
	{
		//We propably won't need these outputs, as all the renderMethods should have Trace.formatlns.
		//debug(PlainRectangle) Trace.formatln("PlainRectangle.render() START. name: {}", fullName );
		//debug(PlainRectangle) scope(exit) Trace.formatln("PlainRectangle.render() END. name: {}", fullName );
		
		if( isHidden == true )
			return;
		
		//This is a hackish additional rendermode, which will
		//draw the rectangle as a gradient if the gradient is set to
		//something.
		if( gradient !is null )
		{
			renderGradient(draw, gradient);
			return;
		}
		
		switch( renderMethod )
		{
			case RenderMethod.BYPASS:
				renderBypass(draw);
			break;
			default:
			case RenderMethod.NORMAL:
				renderNormal(draw);
			break;
			case RenderMethod.PIXELS:
			case RenderMethod.PIXELS_HORIZONTAL:
			case RenderMethod.PIXELS_VERTICAL:
				if( texture !is null )
					renderPixelPerPixel( draw, texture.width, texture.height );
				else renderNormal(draw);
			break;
			case RenderMethod.ASPECT:
				renderAspect(draw);
			break;
		}
	}
	
	void renderNormal( Draw draw )
	{
		debug(PlainRectangle) Trace.formatln("PlainRectangle.renderNormal() START. name: {}", fullName() );
		debug(PlainRectangle) scope(exit) Trace.formatln("PlainRectangle.renderNormal() END. name: {}", fullName() );
	
		beginRender(draw);
		
			//draw.pushTexture( texture );
			
				//These should be handled by the Shape:
				//draw.colour();
				//draw.gradient( gradient );
				
				renderShadow(draw);
				
				renderBody(draw);
					
				pushClipping(draw);
				
					renderChildren(draw);
					
					//renderChildrenNotClipped(draw);
					
				popClipping(draw);
					
		endRender(draw);//TEMP hack...
	}
	
	void renderBypass( Draw draw )
	{
		debug(PlainRectangle) Trace.formatln("PlainRectangle.renderBypass() START. name: {}", fullName() );
		debug(PlainRectangle) scope(exit) Trace.formatln("PlainRectangle.renderBypass() END. name: {}", fullName() );
	
		beginRender(draw);
		
			//draw.pushTexture( texture );
			
				//These should be handled by the Shape:
				//draw.colour();
				//draw.gradient( gradient );
				
				//renderShadow(draw);
				
				//renderBody(draw);
					
				pushClipping(draw);
				
					renderChildren(draw);
					
					//renderChildrenNotClipped(draw);
					
				popClipping(draw);
					
		endRender(draw);//TEMP hack...
	}
	
	void pushClipping( Draw draw )
	{
		if( isClipping == true )
				//draw.pushClipping( tr_w_i2l(ix1), tr_h_i2l(iy1), tr_w_i2l(ix2), tr_h_i2l(iy2) );
				draw.pushClipping( ix1, iy1, ix2, iy2 );
	}
	
	void popClipping( Draw draw )
	{
		if( isClipping == true )
				draw.popClipping();
	}
	
	//Overridden in Rectangle, because I didn't want yet another
	//member to be moved to PlainRectangle. (AlignType...)
	void renderPixelPerPixel( Draw draw, float hard_tex_width, float hard_tex_height )
	{
		debug(PlainRectangle) Trace.formatln("PlainRectangle.renderPixelPerPixel() START. name: {}", fullName() );
		debug(PlainRectangle) scope(exit) Trace.formatln("PlainRectangle.renderPixelPerPixel() END. name: {}", fullName() );
	
		beginRender(draw);
		
			//draw.pushTexture( texture );
				//These should be handled by the Shape:
				//draw.colour();
				//draw.gradient( gradient );
				
				//TODO
				//glColor4f(r, g, b, a);
				applyColour();
 
 			
			//float hard_tex_width = 128.0f;
			//float hard_tex_height = 64.0f;
				
				//Normally: shape.bounds(ix1, iy1, ix2, iy2, iz);
				
				shape.bounds(
					draw,
				//draw.bounds( shape,
					//roundToPixels( 
					icx - (pixel*hard_tex_width*0.5f), 
					//roundToPixels( 
					icy - (pixel*hard_tex_height*0.5f),
					//roundToPixels( 
					icx + (pixel*hard_tex_width*0.5f),
					//roundToPixels( 
					icy + (pixel*hard_tex_height*0.5f),
					iz);
					
				
				shape.fill();
				//draw.fill( shape );
			//draw.popTexture();
				
				/*if(isOutline)
				{
					//TODO
					//glColor4f(r*0.5f, g*0.5f, b*0.5f, a);
					glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
					draw.stroke( shape );
				}*/
			
			//if( isClipping == true )
			//	draw.pushClipping(ix1, iy1, ix2, iy2, iz);
					
					renderChildren(draw);
					
		endRender(draw);//TEMP hack...
					
			//if( isClipping == true )
			//	draw.popClipping();
	}
		
	void renderAspect( Draw draw )
	{
		debug(PlainRectangle) Trace.formatln("PlainRectangle.renderAspect() START. name: {}", fullName() );
		debug(PlainRectangle) scope(exit) Trace.formatln("PlainRectangle.renderAspect() END. name: {}", fullName() );
	
		beginRender(draw);	
				//renderShadow(draw); //I guess ASPECT renderMethod doesn't have shadows currently.
				//renderBody(draw); //Instead of renderBody we do the following:
				
				applyColour();
				
				float desired_aspect = xAspect / yAspect;
				
				//Check which has a wider aspectratio,
				//the current aspect or desired_aspect:
				if( desired_aspect <= aspect() )
				{
					//the current aspect is wider use height and y.
					//Normally: shape.bounds(ix1, iy1, ix2, iy2, iz);
					shape.bounds(
						draw,
					//draw.bounds( shape,
						icx - (desired_aspect*h*0.5f),
						iy1,
						icx + (desired_aspect*h*0.5f),
						iy2,
						iz);
				}
				else
				{
					//the desired_aspect is wider, use width and x.
					//shape.bounds(ix1, iy1, ix2, iy2, iz);
					
					shape.bounds(
						draw,
					//draw.bounds( shape,
						ix1,
						icy - (w/desired_aspect*0.5f),
						ix2,
						icy + (w/desired_aspect*0.5f),
						iz);
						
				}
				
				shape.fill();
				//draw.fill( shape );
				
				if(isOutline)
				{
					//TODO outlineColour
					//glColor4f(r*0.5f, g*0.5f, b*0.5f, a);
					//glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
					//glColor4f( outlineColour.r, outlineColour.g, outlineColour.b, outlineColour.a );
					applyOutlineColour();
					shape.stroke();
					//draw.stroke( shape );
					
				}
				
				//
				
				renderChildren(draw);
		endRender(draw);
	}
	
	//HOPEFULLY this is TEMPORARY:
	void renderPixelPerPixelHeight( Draw draw, float hard_tex_height )
	{
		debug(clipping) Trace.formatln("PlainRectangle.renderPixelPerPixelHeight() START. name: {}", fullName() );
	
		beginRender(draw);
		
			draw.pushTexture( texture );
				//These should be handled by the Shape:
				//draw.colour();
				//draw.gradient( gradient );
				
				//TODO
				//glColor4f(r, g, b, a);
				applyColour();
 
 			
			//float hard_tex_width = 128.0f;
			//float hard_tex_height = 64.0f;
				
				//Normally: shape.bounds(ix1, iy1, ix2, iy2, iz);
				
				shape.bounds(
					draw,
				//draw.bounds( shape,
					//roundToPixels( 
					//icx - (pixel*hard_tex_width*0.5f), 
					ix1,
					//roundToPixels( 
					icy - (pixel*hard_tex_height*0.5f),
					//roundToPixels( 
					//icx + (pixel*hard_tex_width*0.5f),
					ix2,
					//roundToPixels( 
					icy + (pixel*hard_tex_height*0.5f),
					iz);
				
				shape.fill();
				//draw.fill( shape );
			draw.popTexture();
				
				/*if(isOutline)
				{
					//TODO
					//glColor4f(r*0.5f, g*0.5f, b*0.5f, a);
					glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
					draw.stroke( shape );
				}*/
			
			//if( isClipping == true )
			//	draw.pushClipping(ix1, iy1, ix2, iy2, iz);
					
					renderChildren(draw);
					
		endRender(draw);//TEMP hack...
					
			//if( isClipping == true )
			//	draw.popClipping();
	}	
	
	//TODO: This seems to be a bit outdated and it uses IMMEADIATE MODE
	//so REMOVE this somehow. And replace it with something better.
	void renderGradient(Draw draw, Gradient set_gradient)
	{
		if( set_gradient is null || set_gradient.size == 0 )
		{
			PlainRectangle.render(draw);
			return;
		}
		
		//Trace.formatln("	PlainRectangle.render() START.");
		glPushMatrix();
		
			applyPosition();
			applyRotation();
			applyScale();
			
			applyCulling();
			applyTexture();
			applyColour();
			
			float stop_pos = set_gradient.colourStops.head.position;
			Colour cur_color = set_gradient.colourStops.head.colour;
			float cur_y = iy1;
			
			cur_color.apply();
			
			//Trace.formatln("stop_pos0: {}", cast(double) stop_pos );
			//Trace.formatln("cur_color0: {}", cur_color );
			
			glBegin(GL_QUAD_STRIP);
			
				glNormal3f( 0.0f, 0.0f, 1.0f );
				
				glTexCoord2f( 1.0f, 0.0f );
				glVertex3f( ix2, cur_y, iz );
				
				glTexCoord2f( 0.0f, 0.0f );
				glVertex3f( ix1, cur_y, iz );
				
			for( uint i = 1; i < set_gradient.size(); i++ )
			{
				stop_pos = set_gradient.colourStops.get(i).position;
				cur_color = set_gradient.colourStops.get(i).colour;
				cur_y = ((iy2 - iy1) * stop_pos) + iy1;
				
				//Trace.formatln("stop_pos{}: {}", i, cast(double) stop_pos );
				//Trace.formatln("cur_color{}: {}", i, cur_color );
				
				cur_color.apply();
					
					//glNormal3f( 0.0f, 0.0f, 1.0f );
					glTexCoord2f( 1.0f, stop_pos );
					glVertex3f( ix2, cur_y, iz );
				
					//glNormal3f( 0.0f, 0.0f, 1.0f );
					glTexCoord2f( 0.0f, stop_pos );
					glVertex3f( ix1, cur_y, iz );
					
			}
			
			glEnd();
			
			endTexture();
			
			//Outline:
			if( isOutline == true )
			{
				//glColor4f(r*0.5f, g*0.5f, b*0.5f, a);
				//glColor4f( outlineColour.r, outlineColour.g, outlineColour.b, outlineColour.a );
				applyOutlineColour();
				
				glBegin(GL_LINE_STRIP);
					glNormal3f( 0.0f, 0.0f, 1.0f );
					glVertex3f( ix1, iy1, iz );
					glVertex3f( ix2, iy1, iz );
					glVertex3f( ix2, iy2, iz );
					glVertex3f( ix1, iy2, iz );
					glVertex3f( ix1, iy1, iz );
				glEnd();
			}
			
			applyClipping();
				renderChildren(draw);
			endClipping();
			
		glPopMatrix();
		
		
	}
	
	//On PlainRectangle these are just passthrough,
	//but they're properly implemented on Rectangle.
	//because Rectangle has zoom and moveScreen and parent
	//which are needed for these to have any relevance.
	float tr_wc2i( float tr_set )
	{
			return tr_set;
	}
	float tr_hc2i( float tr_set )
	{
			return tr_set;
	}
	
	float tr_w_i2l( float tr_set )
	{
			return tr_set;
	}
	
	float tr_h_i2l( float tr_set )
	{
		return tr_set;
	}
	
	float zoomX() { return 1.0f; }
	float zoomY() { return 1.0f; }
	
	protected void applyShadowColour()
	{
		glColor4f(1.0f, 1.0f, 1.0f, a);
	}
	
	void renderShadow( Draw draw )
	{
		if( shadowType != ShadowType.NONE )
		{
			applyShadowColour();
			
			//HARDCODED PIXEL SIZE!
			//float hard_tex_width = ((tr_w_i2l(w)) / g_rae.pixel)+102.0f;//102.0f;
			//float hard_tex_height = ((tr_h_i2l(h)) / g_rae.pixel)+102.0f;//102.0f;
			
			//Original size was 6.4f now it's 6.0f.
			
			float hard_tex_width = (w / g_rae.pixel)+12.0f;//102.0f;
			float hard_tex_height = (h / g_rae.pixel)+12.0f;//102.0f;
			
			debug(shadow) Trace.formatln("hard_tex_width: {}", cast(double) hard_tex_width );
			debug(shadow) Trace.formatln("hard_tex_height: {}", cast(double) hard_tex_height );
			
			/*
			shapeShadow.bounds(
				//roundToPixels( 
				icx - (tr_hc2i(g_rae.pixel)*hard_tex_width*0.5f),
				//roundToPixels( 
				icy - (tr_hc2i(g_rae.pixel)*hard_tex_height*0.5f),//+ tr_h_i2l(0.005f)
				//roundToPixels( 
				icx + (tr_hc2i(g_rae.pixel)*hard_tex_width*0.5f),
				//roundToPixels( 
				icy + (tr_wc2i(g_rae.pixel)*hard_tex_height*0.5f),//+ tr_h_i2l(0.005f) 
				iz);
			*/
			
			shapeShadow.bounds(
				draw,
				//roundToPixels( 
				icx - 0.010f - (pixel*hard_tex_width*0.5f),
				//roundToPixels( 
				icy - 0.007f - (pixel*hard_tex_height*0.5f),//+ tr_h_i2l(0.005f)
				//roundToPixels( 
				icx + 0.010f + (pixel*hard_tex_width*0.5f),
				//roundToPixels( 
				icy + 0.012f + (pixel*hard_tex_height*0.5f),//+ tr_h_i2l(0.005f) 
				iz,
				(pixel*(shapeShadow.texture.height*0.25f))
				//(g_rae.pixel*(shapeShadow.texture.height/4.0f))
				);
			
			shapeShadow.fill();
			//draw.fill( shapeShadow );
		}
	}
	
	/*
	void render()
	{
		glPushMatrix();
			
			applyPosition();
			applyRotation();
			applyScale();
			
			applyCulling();
			applyTexture();
			applyColour();
			
				//if( shape !is null )
				//{
					shape.bounds(ix1, iy1, ix2, iy2, iz);
					shape.fill();
					
				endTexture();
					
					//TODO
					glColor4f(r*0.5f, g*0.5f, b*0.5f, a);
					if(isOutline)
						shape.stroke();
				//}
			
			
			
			applyClipping();
				renderChildren();
			endClipping();
		
		glPopMatrix();
	}
	*/
	
	void renderImmediateMode(Draw draw)
	{
		//Trace.formatln("	PlainRectangle.render() START.");
		glPushMatrix();
		
			applyPosition();
			applyRotation();
			applyScale();
			
			applyCulling();
			applyTexture();
			applyColour();
						
				glBegin(GL_QUADS);
					
					glNormal3f( 0.0f, 0.0f, 1.0f );
					glTexCoord2f( 0.0f, 0.0f );
					glVertex3f( ix1, iy1, iz );
					
					//glNormal3f( 0.0f, 0.0f, 1.0f );
					glTexCoord2f( 0.0f, 1.0f );
					glVertex3f( ix1, iy2, iz );	
					
					//glNormal3f( 0.0f, 0.0f, 1.0f );
					glTexCoord2f( 1.0f, 1.0f );
					glVertex3f( ix2, iy2, iz );
					
					//glNormal3f( 0.0f, 0.0f, 1.0f );
					glTexCoord2f( 1.0f, 0.0f );
					glVertex3f( ix2, iy1, iz );
					
				glEnd();
				
			endTexture();
			
			//Outline:
			if( isOutline == true )
			{
				//glColor4f(r*0.5f, g*0.5f, b*0.5f, a);
				//glColor4f( outlineColour.r, outlineColour.g, outlineColour.b, outlineColour.a );
				applyOutlineColour();
				
				glBegin(GL_LINE_STRIP);
					glNormal3f( 0.0f, 0.0f, 1.0f );
					glVertex3f( ix1, iy1, iz );
					glVertex3f( ix2, iy1, iz );
					glVertex3f( ix2, iy2, iz );
					glVertex3f( ix1, iy2, iz );
					glVertex3f( ix1, iy1, iz );
				glEnd();
			}
			
			applyClipping();
				renderChildren(draw);
				renderChildrenNotClipped(draw);
			endClipping();
			
		glPopMatrix();
		
		
	}
	
	void renderChildren(Draw draw)
	{
	
	}
	
	//REMOVE:
	void renderChildrenNotClipped(Draw draw)
	{
	
	}
	
	void applyCulling()
	{
		if( isDoubleSided == true )
			glDisable(GL_CULL_FACE);
		else glEnable(GL_CULL_FACE);
	}
	//TODO endCulling() ???
	
	void applyTexture()
	{
		if( texture !is null )
				texture.pushTexture();
			else glDisable(GL_TEXTURE_2D);
	}
	
	void endTexture()
	{
		if( texture !is null )
			texture.popTexture();
	}
	
	//Currently PlainRectangle doesn't keep it's animations...
	void add( Animator set_anim )
	{
		//animator.append( set_anim );
	}
	
	void remove( Animator set_anim )
	{
		//animator.remove( set_anim );
	}
	
	//Texture handling is moved inside Shape.
	//protected Image m_texture;
	public Image texture( Image set )
	{
		if( shape !is null )
			return shape.texture = set;
		//else
			return null;
		//return m_texture = set;
	}
	public Image texture()
	{
		if( shape !is null )
			return shape.texture;
		//else
			return null;
		//return m_texture;
	}
	
	public Gradient gradient() { return m_gradient; }
	public Gradient gradient( Gradient set ){ return m_gradient = set; }
	protected Gradient m_gradient;
	
protected:

	protected void applyClipping()
	{
		/*double[4] eq = [0.0f, iy2, 0.0f, 0.0f];
		glClipPlane(GL_CLIP_PLANE0, eq.ptr);
		glEnable(GL_CLIP_PLANE0);*/
	}
	
	protected void endClipping()
	{
		//glDisable(GL_CLIP_PLANE0);
	}

	
	protected void applyPosition()
	{
		//This is supposed to be very slow. Don't use this.
		//Use draw.translate instead.

		//glTranslatef( roundToPixels(xPos), roundToPixels(yPos), zPos );
		//glTranslatef( xPos * g_rae.screenHeightP, yPos * g_rae.screenHeightP, zPos * g_rae.screenHeightP );
		glTranslatef( xPos, yPos, zPos );
	}
	
	float pixel() { return g_rae.pixel(); }
	
	//This returns and accepts Height coordinates
	float roundToPixels( float set )
	{
		return g_rae.roundToPixels( set );
	}

	protected void applyRotation()
	{
		//glRotatef( 1.0f, xRot, yRot, zRot );
		glRotatef( xRot, 1.0f, 0.0f, 0.0f );
		glRotatef( yRot, 0.0f, 1.0f, 0.0f );
		glRotatef( zRot, 0.0f, 0.0f, 1.0f );
	}
	
	protected void applyScale()
	{
		glScalef( scale, scale, scale );
	}
	
	protected void applyColour()
	{
		glColor4f( r, g, b, a );
	}
	
	protected void applyOutlineColour()
	{
		glColor4f( outlineColour.r, outlineColour.g, outlineColour.b, outlineColour.a );
	}

	//LinkedList!(RectangleMesh) m_mesh; //How about something like this later on...
	//PlainRectangle should stay simple, but some inherited class
	//could do something like this.

public:
	//set with width and height:
	void setXYWH( float sx1, float sy1, float sw, float sh )
	{
		//first we have to move the xPos to be the center of
		//the new positions. That way the rest of the
		//methods will work as expected.
		xPos = sx1 + (sw*0.5);
		yPos = sy1 + (sh*0.5);
		
		ix1 = sx1 - xPos;
		debug(Rectangle) Trace.formatln("rect after x1: {}", toString() );
		iy1 = sy1 - yPos;
		debug(Rectangle) Trace.formatln("rect after y1: {}", toString() );
		
		float delt = sw - w;
		ix2 = ix2 + delt;
		debug(Rectangle) Trace.formatln("rect after w: {}", toString() );
		delt = sh - h;
		iy2 = iy2 + delt;
		debug(Rectangle) Trace.formatln("rect after h: {}", toString() );
	}

	//set with absolute points:
	void setXYXY( float sx1, float sy1, float sx2, float sy2 )
	{
		//first we have to move the xPos to be the center of
		//the new positions. That way the rest of the
		//methods will work as expected.
		xPos = (sx1 + sx2) * 0.5;
		yPos = (sy1 + sy2) * 0.5;
	
		ix1 = sx1 - xPos;
		iy1 = sy1 - yPos;
		ix2 = sx2 - xPos;
		iy2 = sy2 - yPos;
	}
	
	///This is just for quicly finding out if this item is hit.
	bool enclosure( float tx, float ty )
	{
		debug(PlainRectangle) Trace.formatln("PlainRectangle.enclosure( tx: {}{}{}{}", tx, " ty: ", ty, " ) START and END.\n");
		
		/*
		if( this !is rect
			&& rect !is null
			&& ((x - rect.x) < 0.001)//x <= rect.x //There's some wierd bug here sometimes when they are supposed to be equal.!
			&& ((rect.x2 - x2) < 0.001)//rect.x2 <= x2
			&& ((y - rect.y) < 0.001)//y <= rect.y
			&& ((rect.y2 - y2) < 0.001)//rect.y2 <= y2
		)
		*/
		
		/*
		if( //this != rect &&
			x <= tx
			&& tx <= x2
			&& y <= ty
			&& ty <= y2
		)
		*/
		
		//These will translate the incoming coordinates
		//into this widgets coordinates. It's the same
		//as xp2i() in the old system.
		//tx -= xPos;
		//ty -= yPos;
		
		/*Trace.formatln("name: {}", name);
		Trace.formatln("mousetx: {}", cast(double)tx);
		Trace.formatln("mousety: {}", cast(double)ty);
		Trace.formatln("ix1: {}", cast(double)ix1);
		Trace.formatln("iy1: {}", cast(double)iy1);
		Trace.formatln("ix2: {}", cast(double)ix2);
		Trace.formatln("iy2: {}", cast(double)iy2);
		Trace.formatln("xPos: {}", cast(double)xPos);
		Trace.formatln("yPos: {}", cast(double)yPos);
		Trace.formatln("x1: {}", cast(double)x1);
		Trace.formatln("y1: {}", cast(double)y1);
		Trace.formatln("x2: {}", cast(double)x2);
		Trace.formatln("y2: {}", cast(double)y2);
		Trace.formatln("w: {}", cast(double)w);
		Trace.formatln("h: {}", cast(double)h);
		*/
		
		/*
		if( //this != rect &&
			((ix1 - tx) < 0.001)//x <= rect.x //There's some wierd bug here sometimes when they are supposed to be equal.!
			&& ((tx - ix2) < 0.001)//rect.x2 <= x2
			&& ((iy1 - ty) < 0.001)//y <= rect.y
			&& ((ty - iy2) < 0.001)//rect.y2 <= y2
		)
		*/
		if( //this != rect &&
			((x1 - tx) < 0.001)//x <= rect.x //There's some wierd bug here sometimes when they are supposed to be equal.!
			&& ((tx - x2) < 0.001)//rect.x2 <= x2
			&& ((y1 - ty) < 0.001)//y <= rect.y
			&& ((ty - y2) < 0.001)//rect.y2 <= y2
		)
		{
			debug(hitting) Trace.formatln("enclosure(x,y) is true.");
			return true;
		}
		//else
		return false;
	}
	
	//Local coordinates version of enclosure.
	//If you have an InputState, that has correct
	//xLocal and yLocal, then if you are inside
	//"this" object, then you can test with those
	//and enclosureLocal() if you are hit.
	bool enclosureLocal( float tx, float ty )
	{
		debug(PlainRectangle) Trace.formatln("PlainRectangle.enclosureLocal( tx: {}{}{}{}", tx, " ty: ", ty, " ) START and END.\n");
	
		if( //this != rect &&
			((ix1 - tx) < 0.001)//x <= rect.x //There's some wierd bug here sometimes when they are supposed to be equal.!
			&& ((tx - ix2) < 0.001)//rect.x2 <= x2
			&& ((iy1 - ty) < 0.001)//y <= rect.y
			&& ((ty - iy2) < 0.001)//rect.y2 <= y2
		)
		{
			//Trace.formatln("hit is true.");
			return true;
		}
		//else
		return false;
	}
	
	
	Colour outlineColour;
	void setOutlineColour( float sr, float sg, float sb, float sa )
	{
		if( outlineColour is null )
		{
			outlineColour = new Colour(sr, sg, sb, sa);
			return;
		}
		outlineColour.set(sr,sg,sb,sa);
	}
	
	Colour mainColour;
	Colour prelightColour;
	void updatePrelightColour()
	{	
		if( mainColour.r > 0.8f )//If whitish...make darker.
		{
			prelightColour.set( 0.7f*mainColour.r, 0.7f*mainColour.g, 0.7f*mainColour.b, mainColour.a );
		}
		else //otherwise make lighter.
		{
			prelightColour.set( 1.3f*mainColour.r, 1.3f*mainColour.g, 1.3f*mainColour.b, mainColour.a );
		}
	}
	
	//Colour
	float r() { return _colour_data[0]; }
	float g() { return _colour_data[1]; }
	float b() { return _colour_data[2]; }
	float a() { debug(translucent)return 0.5f; /*else*/ return _colour_data[3]; }
	
	void r( float set )
	{
		_colour_data[0] = set;
		invalidate();
		//return _colour_data[0];
	}
	void g( float set )
	{
		_colour_data[1] = set;
		invalidate();
		//return _colour_data[1];
	}
	void b( float set )
	{
		_colour_data[2] = set;
		invalidate();
		//return _colour_data[2];
	}
	void a( float set )
	{
		_colour_data[3] = set;
		invalidate();
		//return _colour_data[3];
	}
	
	/*
	float r( float set ) { _colour_data[0] = set; invalidate(); return _colour_data[0]; }
	float g( float set ) { _colour_data[1] = set; invalidate(); return _colour_data[1]; }
	float b( float set ) { _colour_data[2] = set; invalidate(); return _colour_data[2]; }
	float a( float set ) { _colour_data[3] = set; invalidate(); return _colour_data[3]; }
	*/
	
	void colour( float sr, float sg, float sb, float sa )
	{
		mainColour.set(sr, sg, sb, sa);
		updatePrelightColour();
		r = sr; g = sg; b = sb; a = sa;
	}

	void colour( float[] set )
	{
		if( set.length >= 4 )
		{
			mainColour.set(set[0], set[1], set[2], set[3]);
			updatePrelightColour();
			r = set[0]; g = set[1]; b = set[2]; a = set[3];
		}
	}
	
	protected float[4] _colour_data;
		
	/*
	void createRectangle(float set_size)
	{
		m_numVerts = 4;
		m_numFaces = 2;
		_idxStart = 0;
		_idxEnd = 5;
	
		m_vertices = new GLfloat[12];
		GLfloat num = set_size;//1.0f;
		m_vertices[0] = -num;
		m_vertices[1] = -num;
		m_vertices[2] = 0.0f;
		m_vertices[3] = num;
		m_vertices[4] = -num;
		m_vertices[5] = 0.0f;
		m_vertices[6] = -num;
		m_vertices[7] = num;
		m_vertices[8] = 0.0f;
		m_vertices[9] = num;
		m_vertices[10] = num;
		m_vertices[11] = 0.0f;
		
		//m_indices = new GLushort[4];
		//This makes them static for this class,
		//all the instances will share these
		//(for some reason) but that's ok...
		m_indices = [ 0, 1, 2, 2, 1, 3 ];
									
		//m_normals = new GLfloat[12];
		m_normals = [
							0.0f, 0.0f, 1.0f,
							0.0f, 0.0f, 1.0f,
							0.0f, 0.0f, 1.0f,
							0.0f, 0.0f, 1.0f
						];
						
		//m_textureCoords = new GLfloat[8];
		
		m_textureCoords = [
								0.0f, 0.0f,
								1.0f, 0.0f,
								0.0f, 1.0f,
								1.0f, 1.0f
							];

	}
*/
	
	
	/*void move( float delta_x, float delta_y )
	{
		_x += delta_x;
		_y += delta_y;
	}

	//The center is the new center!
	//Not the topleft as it used to be.
	//This will set cx and cy!
	void moveTo( float to_x, float to_y )
	{
		cx = to_x;
		cy = to_y;
	}*/


	protected void arrange(){}

	void invalidate(){}
	
	//Internal coordinates
	//are relative to xPos, yPos
	//labeled e.g.
	//ix1()
	
	//Parent coordinates
	//these include the transform with xPos, yPos
	//labeled e.g.
	//x1()

	//x1(left)
	public float x1() { return _xPos + _ix1; }
	///Move parent coordinates x1. Keep x2 where it is. Adjust xPos half the delta.
	///(So that if it was centered it will stay centered).
	public void x1( float set )
	{
		float delt = set - x1;
		_ix1 = _ix1 + (delt*0.5);//Move _ix1 half the delta.
		_xPos = _xPos + (delt*0.5);//Move xPos half the delta.
		_ix2 = _ix2 - (delt*0.5);//Move _ix2 half the delta to the other orientation.
		arrange();
		invalidate();
		//return _xPos + _ix1;
	}
	public void x1N( float set )//N versions don't do arrange and invalidate automatically.
	{
		float delt = set - x1;
		_ix1 = _ix1 + (delt*0.5);//Move _ix1 half the delta.
		_xPos = _xPos + (delt*0.5);//Move xPos half the delta.
		_ix2 = _ix2 - (delt*0.5);//Move _ix2 half the delta to the other orientation.
		//arrange();
		//invalidate();
		//return _xPos + _ix1;
	}
	public float ix1() { return _ix1; }
	public void ix1( float set ) //{ return _ix1 = set; }
	{
		_ix1 = set;
		arrange();
		invalidate();
		//return _ix1;
	}
	public void ix1N( float set ) //{ return _ix1 = set; }
	{
		_ix1 = set;
		//arrange();
		//invalidate();
		//return _ix1;
	}
	protected float _ix1 = -0.5f;
	
	//y1(top)
	public float y1() { return _yPos + _iy1; }
	public void y1( float set )
	{
		float delt = set - y1;
		_iy1 = _iy1 + (delt*0.5);//Move _iy1 half the delta.
		_yPos = _yPos + (delt*0.5);//Move yPos half the delta.
		_iy2 = _iy2 - (delt*0.5);//Move _iy2 half the delta to the other orientation.
		arrange();
		invalidate();
		//return _yPos + _iy1;
	}
	public void y1N( float set )
	{
		float delt = set - y1;
		_iy1 = _iy1 + (delt*0.5);//Move _iy1 half the delta.
		_yPos = _yPos + (delt*0.5);//Move yPos half the delta.
		_iy2 = _iy2 - (delt*0.5);//Move _iy2 half the delta to the other orientation.
		//arrange();
		//invalidate();
		//return _yPos + _iy1;
	}
	public float iy1() { return _iy1; }
	public void iy1( float set ) //{ return _iy1 = set; }
	{
		_iy1 = set;
		arrange();
		invalidate();
		//return _iy1;
	}
	public void iy1N( float set ) //{ return _iy1 = set; }
	{
		_iy1 = set;
		//arrange();
		//invalidate();
		//return _iy1;
	}
	protected float _iy1 = -0.5f;
	
	//Width and X2(right)
	public float x2() { return _xPos + _ix2; }
	public void x2( float set )
	{
		float delt = set - x2;
		_ix2 = _ix2 + (delt*0.5);//Move _ix2 half the delta.
		_xPos = _xPos + (delt*0.5);//Move xPos half the delta.
		_ix1 = _ix1 - (delt*0.5);//Move _ix1 half the delta to the other orientation.
		arrange();
		invalidate();
		//return _xPos + _ix2;
	}
	public void x2N( float set )
	{
		float delt = set - x2;
		_ix2 = _ix2 + (delt*0.5);//Move _ix2 half the delta.
		_xPos = _xPos + (delt*0.5);//Move xPos half the delta.
		_ix1 = _ix1 - (delt*0.5);//Move _ix1 half the delta to the other orientation.
		//arrange();
		//invalidate();
		//return _xPos + _ix2;
	}
	
	public float ix2() { return _ix2; }
	public void ix2( float set ) //{ return _ix2 = set; }
	{
		_ix2 = set;
		arrange();
		invalidate();
		//return _ix2;
	}
	public void ix2N( float set ) //{ return _ix2 = set; }
	{
		_ix2 = set;
		//arrange();
		//invalidate();
		//return _ix2;
	}
	protected float _ix2 = 0.5f;
	
	///Width and height at the same time:
	void wh( float setw, float seth )
	{
		wN(setw);
		h(seth);
	}
	void whN( float setw, float seth )
	{
		wN(setw);
		hN(seth);
	}
	///Animate width and height at the same time.
	void whAnim( float to_set, float to_set_2, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &w, &w, &h, &h, null, null, set_when_finished );
		to_anim.animateTo( to_set, to_set_2, 0.0f );
		add(to_anim);
	}
	
	public float w() { return _ix2 - _ix1; }
	public void w( float set )
	{
		debug(geometry) Trace.formatln("PlainRectangle.w(set) START.");
		debug(geometry) scope(exit) Trace.formatln("PlainRectangle.w(set) END.");
		float delt = w - set;
		_ix1 = _ix1 + (delt*0.5);//Move _ix1 half the delta.
		_ix2 = _ix2 - (delt*0.5);//Move _ix2 half the delta.
		arrange();
		invalidate();
		//return _ix2 - _ix1;
	}
	public void wN( float set )
	{
		float delt = w - set;
		_ix1 = _ix1 + (delt*0.5);//Move _ix1 half the delta.
		_ix2 = _ix2 - (delt*0.5);//Move _ix2 half the delta.
		//arrange();
		//invalidate();
		//return _ix2 - _ix1;
	}
	void wAnim( float to_set, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &w, &w, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
	}
	//move x and y in relation to w and h. (change w and h) rarely used.
	//public float xw( float set ) { w = _w - (set - _x); return x = set; }
	/*public float wc( float set )//Change width while the center stays the same. Maybe wc()?
	{
		float delt = _w - set;
		_x += delt*0.5f;//half the delta.
		return _w -= delt;//the whole delta.
	}*/
	
	
	//Height and Y2(bottom)
	public float y2() { return _yPos + _iy2; }
	public void y2( float set )
	{
		float delt = set - y2;
		_iy2 = _iy2 + (delt*0.5);//Move _iy2 half the delta.
		_yPos = _yPos + (delt*0.5);//Move yPos half the delta.
		_iy1 = _iy1 - (delt*0.5);//Move _iy1 half the delta to the other orientation.
		arrange();
		invalidate();
		//return _yPos + _iy2;
	}
	public void y2N( float set )
	{
		float delt = set - y2;
		_iy2 = _iy2 + (delt*0.5);//Move _iy2 half the delta.
		_yPos = _yPos + (delt*0.5);//Move yPos half the delta.
		_iy1 = _iy1 - (delt*0.5);//Move _iy1 half the delta to the other orientation.
		//arrange();
		//invalidate();
		//return _yPos + _iy2;
	}
	
	public float iy2() { return _iy2; }
	public void iy2( float set ) //{ return _iy2 = set; }
	{
		_iy2 = set;
		arrange();
		invalidate();
		//return _iy2;
	}
	public void iy2N( float set ) //{ return _iy2 = set; }
	{
		_iy2 = set;
		//arrange();
		//invalidate();
		//return _iy2;
	}
	protected float _iy2 = 0.5f;
	
	public float h() { return _iy2 - _iy1; }
	public void h( float set )
	{
		debug(geometry) Trace.formatln("PlainRectangle.h(set) START.");
		debug(geometry) scope(exit) Trace.formatln("PlainRectangle.h(set) END.");
		float delt = h - set;
		_iy1 = _iy1 + (delt*0.5);//Move _iy1 half the delta.
		_iy2 = _iy2 - (delt*0.5);//Move _iy2 half the delta.
		arrange();
		invalidate();
		//return _iy2 - _iy1;
	}
	public void hN( float set )
	{
		float delt = h - set;
		_iy1 = _iy1 + (delt*0.5);//Move _iy1 half the delta.
		_iy2 = _iy2 - (delt*0.5);//Move _iy2 half the delta.
		//arrange();
		//invalidate();
		//return _iy2 - _iy1;
	}
	void hAnim( float to_set, void delegate() set_when_finished = null )
	{
		Animator to_anim = new Animator(this, &h, &h, null, null, null, null, set_when_finished );
		to_anim.animateTo( to_set, 0.0f, 0.0f );
		add(to_anim);
	}
	/*public float h() { return _h; }
	public float h( float set ) { return _h = set; }
	//move x and y in relation to w and h. (change w and h) rarely used.
	public float yh( float set ) { h = _h - (set - _y); return y = set; }
	public float hc( float set )//Change height while the center stays the same. Maybe hc()?
	{
		float delt = _h - set;
		_y += delt*0.5f;//half the delta.
		return _h -= delt;//the whole delta.
	}*/
	
	
	
	//Centers
	public float cx() { return (x1 + x2) * 0.5f; }
	public float cy() { return (y1 + y2) * 0.5f; }
	
	public float icx() { return (ix1 + ix2) * 0.5f; }
	public float icy() { return (iy1 + iy2) * 0.5f; }
	/*public float cx(float set)
	{
		float delt = set - cx;
		_x += delt;
		return (x + x2) * 0.5f;
	}
	public float cy(float set)
	{
		float delt = set - cy;
		_y += delt;
		return (y + y2) * 0.5f;
	}*/
	
	//Aspect
	public float aspect() { return (w == 0.0f) ? (1.0f/h) : (w/h); }
	
	public float z() { return _zPos + _iz; }
	public void z( float set )
	{
		float delt = z - set;
		_iz = _iz - (delt*0.5);//Move _iz half the delta.
		_zPos = _zPos - (delt*0.5);//Move zPos half the delta.
		invalidate();
		//return _zPos + _iz;
	}
	public float iz() { return _iz; }
	public void iz( float set )
	{
		_iz = set;
		invalidate();
		//return _iz;
	}
	protected float _iz = 0.0f;
	
	/*char[] toString()
	{
		char[] ret = "\nSTART ";
		ret ~= name;
		ret ~= "\nxPos: ";
		ret ~= Float.toString(xPos);
		ret ~= " yPos: ";
		ret ~= Float.toString(yPos);
		ret ~= " x: ";
		ret ~= Float.toString(x1);
		ret ~= " y: ";
		ret ~= Float.toString(y1);
		ret ~= " w: ";
		ret ~= Float.toString(w);
		ret ~= " h: ";
		ret ~= Float.toString(h);
		ret ~= "\nEND " ~ name;
		
		return ret;
	}*/
	
	//API:
	public void hide() { isHidden = true; }
	public void show() { isHidden = false; }
	public void present() { show(); }//show + sendToTop on Rectangle.
	//Internal:
	public bool isHidden() { return m_isHidden; }
	/*
	//This is the way this is overridden in Rectangle because
	//we need the parent arrange...
	protected void isHidden(bool set)
	{
		m_isHidden = set;
		invalidate();
		if( parent !is null )
			parent.arrange();
		else
			arrange();
		//arrange();//We'll do an additional arrange just in case.
		//I had some trouble with the FileChooser not being arranged
		//properly, so I added this.
		//return m_isHidden;
	}*/
	protected void isHidden(bool set)
	{
		m_isHidden = set;
		invalidate();
		arrange();//We'll do an additional arrange just in case.
		//I had some trouble with the FileChooser not being arranged
		//properly, so I added this.
		//return m_isHidden;
	}
	protected bool m_isHidden = false;
	
	//When signals support return types, then we'll
	//make this return bool isHidden.
	void toggleIsHidden()
	{
		if( isHidden == true )
			isHidden = false;
		else isHidden = true;
	}
	
	
	//From parent coordinates to item coordinates (this is parent, tr is child.)
	double xp2i( double tr_x )
	{
		//debug(PlainRectangle) Stdout("PlainRectangle.xp2i(.) START and END.\n");
		return tr_x - xPos;
	}
	double yp2i( double tr_y )
	{
		//debug(PlainRectangle) Stdout("PlainRectangle.yp2i(.) START and END.\n");
		return tr_y - yPos;
	}
	
	//Ignored in PlainRectangle:
	/*Huoh...
	LinkedList!(ICanvasItem) enclosureList( double tx, double ty, inout LinkedList!(Rectangle) hit_items = null ) { return null; }
	LinkedList!(ICanvasItem) enclosureList( double tx, double ty, double tw, double th, inout LinkedList!(ICanvasItem) hit_items = null ) { return null; }
	public Rectangle rootWindow(Rectangle set){ return null; }///Don't use this yourself.
	public Rectangle rootWindow() { return null; }///Don't use this yourself.
	public ICanvasItem parent() { return null; }
	public ICanvasItem parent(ICanvasItem set) { return null; }
	LinkedList!(ICanvasItem) itemList() { return null; }
	RTree itemTree() { return null; }
	void add( Animator a_anim ){}
	bool hasAnimators(){ false; }
	void addDefaultAnimator( DefaultAnimator def_anim ){}
	void grabInput(){}
	void ungrabInput(){}
	protected void grabInputRootWindow( ICanvasItem set ){}
	protected void ungrabInputRootWindow( ICanvasItem set ){}
	bool mouseEvent( InputState input, bool bypass_hittest = false ){ return false; }
	void checkZOrder(){}
	void sendToTop(){}
	void sendToBottom(){}
	*/
}

//OLD: Possibly usefull for edits!





/+
class PlainRectangle
{
public:
	
	this( float sx = 0.0f, float sy = 0.0f, float sw = 1.0f, float sh = 1.0f )
	{
		debug(Mesh) Trace.formatln("PlainRectangle.this() START.");
		debug(Mesh) scope(exit) Trace.formatln("PlainRectangle.this() END.");
		
		colour( 1.0f, 1.0f, 1.0f, 1.0f );
		
		_x = sx;
		_y = sy;
		_w = sw;
		_h = sh;
	}
	
	~this()
	{
	}
	
	//set with width and height:
	void set( float sx = 0.0f, float sy = 0.0f, float sw = 30.0f, float sh = 30.0f )
	{
		_x = sx;
		_y = sy;
		_w = sw;
		_h = sh;
	}

	//set with absolute points:
	void setAlt( float sx1 = 0.0f, float sy1 = 0.0f, float sx2 = 30.0f, float sy2 = 30.0f )
	{
		//old: _x = sx;
		//old: _y = sy;
		x1(sx1);
		y1(sy1);
		x2(sx2);
		y2(sy2);
	}
	
	///This is just for quicly finding out if this item is hit.
	bool enclosure( float tx, float ty )
	{
		debug(PlainRectangle) Trace.formatln("PlainRectangle.enclosure( tx: ", tx, " ty: ", ty, " ) START and END.\n");
		
		Trace.formatln("tx: ")(tx);
		Trace.formatln("ty: ")(ty);
		Trace.formatln("x1: ")(x1);
		Trace.formatln("y1: ")(y1);
		Trace.formatln("x2: ")(x2);
		Trace.formatln("y2: ")(y2);
		
		if( //this != rect &&
			x1 <= tx
			&& tx <= x2
			&& y1 <= ty
			&& ty <= y2
		)
			return true;
		//else
		return false;
	}
	
	void render()
	{
		//Trace.formatln("	PlainRectangle.render() START.");
	
		glPushMatrix();
		
		//glColor4f( r, g, b, a );
		applyColour();
		
		float zero = 0.0f;
		
		//glTranslatef( -cx, -cy, 0.0f );
		glTranslatef( -(w*0.5f), -(h*0.5f), 0.0f );
		glBegin(GL_QUADS);
			
			glNormal3f( 0.0f, 0.0f, 1.0f );
			glTexCoord2f( 0.0f, 0.0f );
			glVertex3f( zero, zero, z );
			
			//glNormal3f( 0.0f, 0.0f, 1.0f );
			glTexCoord2f( 1.0f, 0.0f );
			glVertex3f( w, zero, z );
			
			//glNormal3f( 0.0f, 0.0f, 1.0f );
			glTexCoord2f( 1.0f, 1.0f );
			glVertex3f( w, h, z );
			
			//glNormal3f( 0.0f, 0.0f, 1.0f );
			glTexCoord2f( 0.0f, 1.0f );
			glVertex3f( zero, h, z );
			
			/*
			glNormal3f( 0.0f, 0.0f, 1.0f );
			glTexCoord2f( 0.0f, 0.0f );
			glVertex3f( x, y, z );
			
			//glNormal3f( 0.0f, 0.0f, 1.0f );
			glTexCoord2f( 1.0f, 0.0f );
			glVertex3f( x2, y, z );
			
			//glNormal3f( 0.0f, 0.0f, 1.0f );
			glTexCoord2f( 1.0f, 1.0f );
			glVertex3f( x2, y2, z );
			
			//glNormal3f( 0.0f, 0.0f, 1.0f );
			glTexCoord2f( 0.0f, 1.0f );
			glVertex3f( x, y2, z );
			*/
			
		glEnd();
		glPopMatrix();
	}
	
	//Colour
	GLfloat r() { return _colour_data[0]; }
	GLfloat g() { return _colour_data[1]; }
	GLfloat b() { return _colour_data[2]; }
	GLfloat a() { return _colour_data[3]; }
	
	GLfloat r( GLfloat set ) { return _colour_data[0] = set; }
	GLfloat g( GLfloat set ) { return _colour_data[1] = set; }
	GLfloat b( GLfloat set ) { return _colour_data[2] = set; }
	GLfloat a( GLfloat set ) { return _colour_data[3] = set; }
	
	void colour( GLfloat sr, GLfloat sg, GLfloat sb, GLfloat sa )
	{
		r = sr; g = sg; b = sb; a = sa;
	}
	
	private GLfloat _colour_data[4];
		
	/*
	void createRectangle(float set_size)
	{
		m_numVerts = 4;
		m_numFaces = 2;
		_idxStart = 0;
		_idxEnd = 5;
	
		m_vertices = new GLfloat[12];
		GLfloat num = set_size;//1.0f;
		m_vertices[0] = -num;
		m_vertices[1] = -num;
		m_vertices[2] = 0.0f;
		m_vertices[3] = num;
		m_vertices[4] = -num;
		m_vertices[5] = 0.0f;
		m_vertices[6] = -num;
		m_vertices[7] = num;
		m_vertices[8] = 0.0f;
		m_vertices[9] = num;
		m_vertices[10] = num;
		m_vertices[11] = 0.0f;
		
		//m_indices = new GLushort[4];
		//This makes them static for this class,
		//all the instances will share these
		//(for some reason) but that's ok...
		m_indices = [ 0, 1, 2, 2, 1, 3 ];
									
		//m_normals = new GLfloat[12];
		m_normals = [
							0.0f, 0.0f, 1.0f,
							0.0f, 0.0f, 1.0f,
							0.0f, 0.0f, 1.0f,
							0.0f, 0.0f, 1.0f
						];
						
		//m_textureCoords = new GLfloat[8];
		
		m_textureCoords = [
								0.0f, 0.0f,
								1.0f, 0.0f,
								0.0f, 1.0f,
								1.0f, 1.0f
							];

	}
*/
	
	
	void move( float delta_x, float delta_y )
	{
		_x += delta_x;
		_y += delta_y;
	}

	void moveTo( float to_x, float to_y )
	{
		_x = to_x;
		_y = to_y;
	}

/*


x-y                   w-x2-y
-------------------------
|                       |
|                       |
|                       |
|                       |
|                       |
|           +           |
|                       |
|                       |
|                       |
|                       |
|                       |
-------------------------
h-x-y2                  w-x2-y2

w = 
h = 

*/


	//X top left corner
	public float x() { return _x; }
	public float x( float set ) { return _x = set; }
	protected float _x; //left
	
	//Y top left corner
	public float y() { return _y; }
	public float y( float set ) { return _y = set; }
	protected float _y; //top
	
	//Width and X2
	public float x2() { return _x + _w; }
	public float w() { return _w; }
	public float w( float set ) { return _w = set; }
	//move x and y in relation to w and h. (change w and h) rarely used.
	public float xw( float set ) { w = _w - (set - _x); return x = set; }
	public float x2( float set ) { return w = set - _x; }
	protected float _w; //width
	
	//Height and Y2
	public float y2() { return _y + _h; }
	public float h() { return _h; }
	public float h( float set ) { return _h = set; }
	//move x and y in relation to w and h. (change w and h) rarely used.
	public float yh( float set ) { h = _h - (set - _y); return y = set; }
	public float y2( float set ) { return h = set - _y; }
	protected float _h; //height
	
	//Centers
	public float cx() { return (x + x2) * 0.5f; }
	public float cy() { return (y + y2) * 0.5f; }
	
	//Aspect
	public float aspect() { return (w == 0.0f) ? (1.0f/h) : (w/h); }
	
	float z = 0.0f;
	
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
