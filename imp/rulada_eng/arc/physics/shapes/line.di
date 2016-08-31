/******************************************************************************* 

	Line code to allow line collision with box and circle

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	The contents of this file are based on E. Catto's Box2d, which is 
	Copyright (c) 2006 Erin Catto http://www.gphysics.com. 

	Description:    
		Line code to allow line collision with box and circle

	Examples:      
	---------------------
	None provided 
	---------------------

*******************************************************************************/

module arc.physics.shapes.line;

import 
	arc.math.point,
	arc.math.matrix,
	arc.math.routines,
	arc.math.rect,
	arc.physics.collide,
	arc.physics.mybody,
	arc.types;

/+
/// line shape 
class Line : Shape
{
	public:
		/// create new line of length
		this(arcfl length_)
		{
			length = length_;
		}
		
		override arcfl surfaceFactor()
		{
			return 1.0f / 12.0f * length * length;
		}
		
		override arcfl boundingRadius()
		{			
			return length / 2.0f;
		}
		
		override Rect boundingBox()
		{
			arcfl r = boundingRadius();
			return Rect(-r, -r, 2*r, 2*r);
		}
		
		// gets untransformed vertices
		void getVertices(Point[2] vertices)
		{
			vertices[0].set(-length/2.0f, 0.0f);
			vertices[1].set(length/2.0f, 0.0f);
		}
		
	public:
		arcfl length;
}
+/

// returns the minimal distance of 'to' to the line between p1 and p2
// closest is set to the point on the line that is closest to 'to'
arcfl getDistanceToLine(inout Point lineStart, inout Point lineEnd, inout Point to, inout Point closest)
{
	Point loc = to;
	loc -= lineStart;
	
	Point vec = lineEnd - lineStart;
	Point v = vec;

	v.normalise();
	arcfl projectedLength = loc.dot(v);
	
	if (projectedLength * projectedLength > vec.lengthSquared()) 
	{
		closest = lineEnd;
	}
	else if (projectedLength < 0.0f) 
	{
		closest = lineStart;
	}
	else
	{	
		v *= projectedLength;
		closest = v;
		closest += lineStart;
	}
	
	return (closest - to).length;
}

/+
private
{
	static this()
	{
		//arc.physics.collide.registerCollider(Line.classinfo, Line.classinfo, &collideLineLine);
	}
	
	int collideLineLine(inout Contact[] contacts, Body* bodyA, Body* bodyB)
	{
/*		Line lineA = cast(Line) bodyA.shape;
		Line lineB = cast(Line) bodyB.shape;
		
		assert(lineA && lineB);
		
		Point dp = bodyB.position - bodyA.position;
		
		// if they can't possibly touch, we're done
		if(dp.lengthSquared() > 0.25f * (lineA.length + lineB.length)*(lineA.length + lineB.length))
			return 0;
		
		// get untransformed box vertices
		Point[2] verticesA, verticesB;
		lineA.getVertices(verticesA);
		lineB.getVertices(verticesB);
		
		// transform A
		Matrix rotA = Matrix(bodyA.rotation);
		foreach(inout vertex; verticesA)
		{
			vertex *= rotA;
			vertex += bodyA.position;
		}
		
		// transform B
		Matrix rotB = Matrix(bodyB.rotation);
		foreach(inout vertex; verticesB)
		{
			vertex *= rotB;
			vertex += bodyB.position;
		}
		
		Point mA = verticesA[1] - verticesA[0];
		Point mB = verticesB[1] - verticesB[0];
		
		// solve the 2x2 system for the collision point
		arcfl p = (verticesB[0].y - verticesA[0].y - mA.y / mA.x * (verticesB[0].x - verticesA[0].x)) / (mA.y * mB.x / mA.x - mB.y);
		
		if(p < 0.0f || p > 1.0f)
			return 0;
		
		contacts[0].position = verticesB[0] + p * mB;

		// the normal and separation are choosen as the closest distance from
		// the vertex with the smallest distance from the collision point to the other line
		
		// find line endpoint that is closest to contact
		Point closest_endpoint;
		if(p >= 0.5f)
			closest_endpoint = verticesB[1];
		else
			closest_endpoint = verticesB[0];
		bool useA = true;
		
		arcfl sep = (contacts[0].position - closest_endpoint).lengthSquared();
		foreach(v; verticesA)
			if(sep > (contacts[0].position - v).lengthSquared())
			{
				sep = (contacts[0].position - v).lengthSquared();
				closest_endpoint = v;
				useA = false;
			}
		
		// get point that is closest to the closest_endpoint
		Point closest_on_line;
		if(useA)
		{
			getDistanceToLine(verticesA[0], verticesA[1], bodyB.position, closest_on_line);
			// this normal doesn't make sense
			contacts[0].normal = bodyB.position - closest_on_line;
		}
		else
		{
			getDistanceToLine(verticesB[0], verticesB[1], bodyA.position, closest_on_line);
			// this normal doesn't make sense
			contacts[0].normal = bodyA.position - closest_on_line;
		}
		
		// is this distance sensible?
		contacts[0].separation = -(contacts[0].position - closest_endpoint).length();
		contacts[0].normal.normalize();
	*/	
		return 1;
	}
}
+/

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
