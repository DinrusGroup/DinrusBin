/******************************************************************************* 

	Circle shape class derived from body.

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	The contents of this file are based on E. Catto's Box2d, which is 
	Copyright (c) 2006 Erin Catto http://www.gphysics.com. 

	Description:    
		Circle shape class derived from body.

	Examples:      
	---------------------
	None provided 
	---------------------

*******************************************************************************/

module arc.physics.shapes.circle;

public import arc.physics.mybody;

import 
	arc.physics.colliders.circle,
	arc.math.point,
	arc.math.matrix,
	arc.math.routines,
	arc.math.rect,
	arc.types;

import std.math;

/// circle shape class derives from body clsas 
class Circle : Body
{
public:
	/// create new circle with given radius 
	this(arcfl aradius, arcfl amass)
	{
		radius_ = aradius;
		super(amass);
	}
	
	/// surfaceFactor
	override arcfl getSurfaceFactor()
	{
		return 0.5f * radius_ * radius_ * scale_.x * scale_.y;
	}
	
	/// bounding radius 
	override arcfl getBoundingRadius()
	in
	{
		assert(scale_.x == scale_.y, "Circle does not allow arbitrary scaling.");
	}
	body
	{
		return radius_ * scale_.x;
	}
	
	/// bounding box
	override Rect getBoundingBox()
	{
		return Rect(-radius_ * scale_.x + translation.x, -radius_ * scale_.y + translation.y, 2*getRadius*scale_.x, 2*getRadius*scale_.y);
	}
	
	/// radius 
	arcfl getRadius()
	in
	{
		assert(scale_.x == scale_.y, "Circle does not allow arbitrary scaling.");
	}
	body
	{
		return radius_ * scale_.x;
	}
	
	/// set radius of the circle 
	void setRadius(arcfl rad)
	{
		radius_ = rad; 
	}
	
	// bring in the base class scaling
	alias Body.scale scale;
	
protected:
	arcfl radius_;
	
private:
	/// disallow arbitrary scaling
	override void scale(inout Point s) {}
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
