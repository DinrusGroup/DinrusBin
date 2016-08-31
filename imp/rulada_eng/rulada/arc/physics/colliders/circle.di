/******************************************************************************* 

	Code that computes circle circle collision.

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	The contents of this file are based on E. Catto's Box2d, which is 
	Copyright (c) 2006 Erin Catto http://www.gphysics.com. 

	Description:    
		Code that computes circle circle collision.

	Examples:      
	---------------------
	None provided 
	---------------------

*******************************************************************************/

module arc.physics.colliders.circle;

import 
	arc.physics.mybody,
	arc.physics.shapes.circle,
	arc.physics.collide,
	arc.math.point,
	arc.math.matrix,
	arc.math.routines,
	arc.types;

import std.math;

bool registered = false; 
void register()
{
	if (!registered)
	{
		registerCollider!(Circle, Circle)(&collideCircleCircle);
		registered = true;
	}
}

private
{
	static this()
	{
		register();
	}
	
	int collideCircleCircle(inout Contact[] contacts, Body bodyA, Body bodyB)
	{
		Circle circleA = cast(Circle) bodyA;
		Circle circleB = cast(Circle) bodyB;
		
		assert(circleA !is null && circleB !is null);
		
		bool touches = touchCircleCircle(bodyA.translation, circleA.getRadius, bodyB.translation, circleB.getRadius);
	
		if (!touches) {
			return 0;
		}
		
		Point normal = bodyB.translation - bodyA.translation;
		arcfl sep = (circleA.getRadius + circleB.getRadius) - normal.length();

		normal.normalise();
		Point pt = normal * circleA.getRadius;
		pt += bodyA.translation; 

		contacts[0].separation = -sep;
		contacts[0].position = pt;
		contacts[0].normal = normal;
		
		return 1;
	}
}

// returns true when two circles at c1, c2 with radii r1, r2 touch
bool touchCircleCircle(inout Point c1, arcfl r1, inout Point c2, arcfl r2)
{
	arcfl totalRad2 = r1 + r2;
		
	if (fabs(c2.x - c1.x) > totalRad2) {
		return false;
	}
	if (fabs(c2.y - c1.y) > totalRad2) {
		return false;
	}
		
	totalRad2 *= totalRad2;
		
	arcfl dx = fabs(c2.x - c1.x);
	arcfl dy = fabs(c2.y - c1.y);
		
	return totalRad2 >= ((dx*dx) + (dy*dy));
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
