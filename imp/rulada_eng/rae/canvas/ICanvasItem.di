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

module rae.canvas.ICanvasItem;

//REMOVE this bug is propably fixed:
//Circular import/LinkedList/GDC bug is the reason
//for this insanity. ICanvasItem and stuff is all
//in Rectangle until that bug is fixed in GDC.


import tango.util.log.Trace;//Thread safe console output.

//import tango.util.container.LinkedList;

import rae.canvas.IHidable;
import rae.canvas.Colour;
import rae.ui.Animator;
import rae.canvas.Point;
import rae.canvas.rtree.Node;
import rae.canvas.rtree.RTree;
import rae.ui.InputState;
import rae.canvas.Draw;


/*


x1-y1                   w-x2-y
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
h-x-y2                  w-x2-y2

w = 
h = 

*/

interface ICanvasItem : IHidable//, IColour
{
public:
	
	//****************************************
//HyperCube compatibility stuff for RTree:


	/*this(Point p1, Point p2)
	{
		super();

		if (p1 is null || p2 is null) throw new IllegalArgumentException("Rectangle.this(p1, p2) Error: Points cannot be null.");

		if (p1.getDimension() != p2.getDimension()) throw new IllegalArgumentException("Rectangle.this(p1, p2) Error: Points must be of the same dimension.");

		for (int i = 0; i < p1.getDimension(); i++)
		{
			if (p1.getFloatCoordinate(i) > p2.getFloatCoordinate(i)) throw new IllegalArgumentException("Rectangle.this(p1, p2) Error: Give lower left corner first and upper right corner afterwards.");
		}

		//this.p1 = cast(Point) p1.clone();
		//this.p2 = cast(Point) p2.clone();

		setAlt( p1.x, p1.y, p2.x, p2.y );

	}*/

	int getDimension();

	//This is just stupid, but this is for HyperCube and RTree compatibility.
	//It should be changed.
	protected Point p1();
	protected Point p2();

	Point getP1();
	Point getP2();
	bool equals(ICanvasItem h);

	/**
	* Tests to see whether <B>h</B> has any common points with this Rectangle. If <B>h</B> is inside this
	* object (or vice versa), it returns true.
	*
	* @return True if <B>h</B> and this Rectangle intersect, false otherwise.
	*/
	bool intersection(ICanvasItem h);

	/**
	* Tests to see whether <B>h</B> is inside this Rectangle. If <B>h</B> is exactly the same shape
	* as this object, it is considered to be inside.
	*
	* @return True if <B>h</B> is inside, false otherwise.
	*/
	bool enclosure(ICanvasItem h);

	/**
	* Tests to see whether <B>p</B> is inside this Rectangle. If <B>p</B> lies on the boundary
	* of the Rectangle, it is considered to be inside the object.
	*
	* @return True if <B>p</B> is inside, false otherwise.
	*/
	bool enclosure(Point p);

	/**
	* Returns the area of the intersecting region between this Rectangle and the argument.
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
	* @param h Given Rectangle.
	* @return Area of intersecting region.
	*/
	float intersectingArea(ICanvasItem h);

	/**
	* Static impementation. Takes an array of Rectangles and calculates the mbb of their
	* union.
	*
	* @param  a The array of Rectangles.
	* @return The mbb of their union.
	*/
	static ICanvasItem getUnionMbb(ICanvasItem[] a);

	/**
	* Return a new Rectangle representing the mbb of the union of this Rectangle and <B>h</B>
	*
	* @param  h The Rectangle that we want to union with this Rectangle.
	* @return  A Rectangle representing the mbb of their union.
	*/
	public ICanvasItem getUnionMbb(ICanvasItem h);

	/**
	* Returns the area of this Rectangle.
	*
	* @return The area as a float.
	*/
	float getArea();

	/* The MINDIST criterion as described by Roussopoulos.
	FIXME: better description here...
	*/
	float getMinDist(Point p);

	///////////CanvasItem clone();//Object clone()

	/*String toString()
	{
		return "P1" ~ p1.toString() ~ ":P2" ~ p2.toString();
	}*/

	Node rtreeNode();//This is not quaranteed to be up to date at any time. It's only updated on a call to enclosureList().
	Node rtreeNode( Node set );

	void adjustTree();
	
	//LinkedList!(ICanvasItem) enclosureList( double tx, double ty, inout LinkedList!(ICanvasItem) hit_items = null );
	//LinkedList!(ICanvasItem) enclosureList( double tx, double ty, double tw, double th, inout LinkedList!(ICanvasItem) hit_items = null );
	ICanvasItem[] enclosureList( double tx, double ty, inout ICanvasItem[] hit_items = null );
	ICanvasItem[] enclosureList( double tx, double ty, double tw, double th, inout ICanvasItem[] hit_items = null );
	bool mouseEvent( InputState input, bool dive_lower = true );
	bool onEnterNotify( InputState input );
	bool onLeaveNotify( InputState input );

//END HyperCube compatibility stuff for RTree:
//*******************************************

	dchar[] name();
	void name(dchar[] set);

	bool isSelected();
	void isSelected(bool set);

	char[] toString();
	
	//Returns a newly allocated copy of this object.
	ICanvasItem dup();
	
	void setXYWH( float sx1, float sy1, float sw, float sh);
	void setXYXY( float sx1, float sy1, float sx2, float sy2);

	//Position
	float xPos();
	void xPos(float set);
	float yPos();
	void yPos(float set);
	float zPos();
	void zPos(float set);
	
	//Move pos with a delta value
	void move( float delta_x, float delta_y );
	//Moves the pos
	void moveTo( float to_x, float to_y );
	
	int layer();
	int layer(int set);
	
	//ZOrder
	uint zOrder();
	uint zOrder(uint set);
	
	//3D rotations
	float xRot();
	void xRot(float set);
	float yRot();
	void yRot(float set);
	float zRot();
	void zRot(float set);
	
	//Scale or Zoom.
	float scale();
	void scale(float set);
	
	//Parent coordinate wrappers for RectangleMesh:

	float cx();
	//float cx(float set);
	float cy();
	//float cy(float set);
	//x1(left)
	float x1();
	void x1(float set);
	//y1(top)
	float y1();
	void y1(float set);
	
	float x2();
	void x2(float set);
	
	float y2();
	void y2(float set);
	
	float z();
	void z(float set);
	
	//Width and X2(right)
	float w();
	void w(float set);
	
	//Height and Y2(bottom)
	float h();
	void h(float set);
	
	//Width and height at the same time:
	void wh( float setw, float seth );
	
	/*
	//move x and y in relation to w and h. (change w and h) rarely used.
	float yh(float set);
	//Change height while the center stays the same. Maybe hc()?
	float hc(float set);
	//move x and y in relation to w and h. (change w and h) rarely used.
	float xw(float set);
	//Change width while the center stays the same. Maybe wc()?
	float wc(float set);
	*/
	void colour( float sr, float sg, float sb, float sa );
	float r();
	void r(float set);
	float g();
	void g(float set);
	float b();
	void b(float set);
	float a();
	void a(float set);
	
	//Timing and animation:
	double frameTime();
	void idle();
	
	///Asks for redraw of the whole window.
	void invalidate();
	void render(Draw draw);
	//is the point (tx,ty) inside the rectangle
	bool enclosure( float tx, float ty );	
	//aspect ratio of the rectangle
	float aspect();
	
	void add( Animator set_anim );
	void remove( Animator set_anim );
	
	//LinkedList!(ICanvasItem) enclosureList( double tx, double ty, double tw, double th, inout LinkedList!(ICanvasItem) hit_items = null );
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
