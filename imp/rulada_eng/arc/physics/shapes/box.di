/******************************************************************************* 

	Box shape class derived from body.

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	The contents of this file are based on E. Catto's Box2d, which is 
	Copyright (c) 2006 Erin Catto http://www.gphysics.com. 

	Description:    
		Box shape class derived from body.

	Examples:      
	---------------------
	None provided 
	---------------------

*******************************************************************************/

module arc.physics.shapes.box;

public import arc.physics.mybody;

import 
	arc.physics.colliders.box,
	arc.types;
	
import 
	arc.math.point,
	arc.math.matrix,
	arc.math.routines,
	arc.math.rect;

import 
	std.math,
	std.io; 

/// box shape 
class Box : Body
{
public:
	/// create new box
	this(arcfl asize, arcfl amass)
	{
		size_.set(asize, asize);
		super(amass);		
	}

	/// create rectangle 
	this(inout Size asize, arcfl amass)
	{
		size_ = asize;
		super(amass);		
	}

	/// get surface factor 
	override arcfl getSurfaceFactor()
	{
		Size s = getSize();
		return 1.0f / 12.0f * (s.w * s.w + s.h * s.h);
	}
	
	/** 
	 * gets the maximum distance from the center that a 
	 * point of the box can be
	*/
	override arcfl getBoundingRadius()
	{
		//OPTIMIZATION possibly approximate with size.x + size.y for speed or cache the value
		Size s = getSize();
		return sqrt(0.25f * (s.w * s.w + s.h * s.h));
	}
	
	/// override for bounding box 
	override Rect getBoundingBox()
	{
		arcfl r = getBoundingRadius();
		return Rect(-r + translation.x, -r + translation.y, 2*r, 2*r);
	}
	
	/// gets untransformed vertices
	void getVertices(Point[4] vertices)
	{
		Size half = getSize() * 0.5f;
		
		vertices[0].set(+ half.w, + half.h);
		vertices[1].set(- half.w, + half.h);
		vertices[2].set(- half.w, - half.h);
		vertices[3].set(+ half.w, - half.h);
	}
	
	/// get size of the box 
	Size getSize()
	{
		return size_.scale(scale_);
	}
	
	/// set the size of the box
	void setSize(Size size)
	{
		size_ = size;
	}

protected:
	Size size_;
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
