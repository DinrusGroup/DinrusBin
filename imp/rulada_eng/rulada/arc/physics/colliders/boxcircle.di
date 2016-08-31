/******************************************************************************* 

	Code that computes box circle collision.

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:      ArcLib team 

	The contents of this file are based on E. Catto's Box2d, which is 
	Copyright (c) 2006 Erin Catto http://www.gphysics.com. 

	Description:    
		Code that computes box circle collision.

	Examples:      
	---------------------
	None provided 
	---------------------

*******************************************************************************/

module arc.physics.colliders.boxcircle;

import 
	arc.physics.mybody,
	arc.physics.shapes.box,
	arc.physics.shapes.circle,
	arc.physics.shapes.line,
	arc.physics.colliders.circle,
	arc.physics.collide,
	arc.math.point,
	arc.math.matrix,
	arc.math.routines,
	arc.types;

bool registered = false; 

// will only register them once 
void register()
{
	if (!registered)
	{
		registerCollider!(Box, Circle)(&collideBoxCircle);
		registerCollider!(Circle, Box)(&collideCircleBox);
		registered = true; 
	}
}

private
{
	// this will not be called as a static lib,
	static this()
	{
		register(); 
	}
	
	/// collide box and circle 
	int collideBoxCircle(inout Contact[] contacts, Body bodyBox, Body bodyCircle)
	{
		Box box = cast(Box) bodyBox;
		Circle circle = cast(Circle) bodyCircle;
		assert(box !is null && circle !is null);
		
		// check if they're close enough to touch
		if(!touchCircleCircle(bodyBox.translation, box.getBoundingRadius, bodyCircle.translation, circle.getRadius))
			return 0;
		
		// get untransformed box vertices
		Point[4] vertices;
		box.getVertices(vertices);
		
		// transform them
		Matrix rotBox = Matrix(bodyBox.rotation);
		foreach(inout vertex; vertices)
		{
			vertex.apply(rotBox);
			vertex += bodyBox.translation;
		}

		// get point closest to circle center and its distance
		arcfl closestDistance = arcfl.max, testDistance;
		Point closestPoint, testPoint;
		for(uint i = 0; i < 4; ++i)
		{
			uint j = (i + 1) % 4;
			testDistance = getDistanceToLine(vertices[i], vertices[j], bodyCircle.translation, testPoint);
			if(testDistance < closestDistance)
			{
				closestDistance = testDistance;
				closestPoint = testPoint;
			}
		}
		
		// check if circle center is inside or outside of box
		Point edgeNormal;
		bool inside = true;
		for(uint i = 0; i < 4; ++i)
		{
			uint j = (i + 1) % 4;
			edgeNormal.set(vertices[j].y - vertices[i].y, - (vertices[j].x - vertices[i].x));
			if(edgeNormal.dot(bodyCircle.translation - vertices[i]) > 0.0f)
			{
				inside = false;
				break;
			}
		}
		
		// make sure normal and distance are sane, no matter if the circle position
		// is inside the box or not
		if(inside)
		{
			closestDistance = - closestDistance - circle.getRadius;
			
			// normal points outside
			contacts[0].normal = closestPoint - bodyCircle.translation;
			contacts[0].normal.normalise();
		}
		else
		{
			// check for contact
			closestDistance -= circle.getRadius;
			if(closestDistance > 0)
				return 0;
		
			// normal points outside
			contacts[0].normal = bodyCircle.translation - closestPoint;
			contacts[0].normal.normalise();
		}
		
		// set contact info		
		contacts[0].position = closestPoint;
		contacts[0].separation = closestDistance;
		
		return 1;
	}

	/// collide circle and box 
	int collideCircleBox(inout Contact[] contacts, Body bodyCircle, Body bodyBox)
	{
		// reduce to known case
		int n_contacts = collideBoxCircle(contacts, bodyBox, bodyCircle);
		foreach(inout contact; contacts)
			contact.normal *= -1.0f;
		
		return n_contacts;
	}

}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
