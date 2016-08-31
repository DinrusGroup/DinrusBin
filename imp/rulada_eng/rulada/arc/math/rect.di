/******************************************************************************* 

	A Rectangle Structure 

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

    Description:    
		A Rectangle Structure.

	Examples:
	--------------------
	import arc.math.rect;

	int main() 
	{
		Rect vec = Rect(topleft, size);

		return 0;
	}
	--------------------

*******************************************************************************/

module arc.math.rect;

import 
	arc.types,
	arc.math.point;

/// Rectangle Structure 
struct Rect
{
	Point topLeft;
	Size size;
	
	/// 'constructor'
	static Rect opCall(arcfl x, arcfl y, arcfl w, arcfl h)
	{
		Rect r;
		r.topLeft = Point(x,y);
		r.size = Size(w, h);
		return r;
	}
	
	/// 'constructor'
	static Rect opCall(Point topLeft_, Size size_)
	{
		Rect r;
		r.topLeft = topLeft_;
		r.size = size_;
		return r;
	}
	
	/// 'constructor'
	static Rect opCall(Size size_)
	{
		Rect r;
		r.size = size_;
		return r;
	}
	
	/// 'constructor'
	static Rect opCall(arcfl w, arcfl h)
	{
		Rect r;
		r.size = Size(w, h);
		return r;
	}
	
	/// bottom right getter
	Point getBottomRight()
	{
		return topLeft + size;
	}

	/// top getter	
	arcfl getTop()
	{
		return topLeft.y;
	}
	
	/// left getter
	arcfl getLeft()
	{
		return topLeft.x;
	}
	
	/// bottom
	arcfl getBottom()
	{
		return topLeft.y + size.h;
	}
	
	/// right
	arcfl getRight()
	{
		return topLeft.x + size.w;
	}
	
	///
	Point getPosition() { return topLeft; }
	
	///
	Size getSize() { return size; } 
	
	/// moves rect without altering size
	Rect move(inout Point by)
	{
		topLeft += by;
		return *this;
	}
	
	/***
		tests if a point is contained in rect.
		the rect is considered closed.
	*/
	bool contains(inout Point p)
	{
		return (p.x >= topLeft.x && p.y >= topLeft.y && p.x < topLeft.x + size.w && p.y < topLeft.y + size.h);
	}
	
	/// tests if two rects intersect. both are closed
	bool intersects(inout Rect r)
	{
		if(r.topLeft.x >= topLeft.x + size.w)
			return false;
		if(r.topLeft.y >= topLeft.y + size.h)
			return false;
		if(r.topLeft.x + r.size.w <= topLeft.x)
			return false;
		if(r.topLeft.y + r.size.h <= topLeft.y)
			return false;
		
		return true;
	}
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
