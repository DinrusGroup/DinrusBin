/******************************************************************************* 

	Code that computes box box collision.

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:      ArcLib team 

	The contents of this file are based on E. Catto's Box2d, which is 
	Copyright (c) 2006 Erin Catto http://www.gphysics.com. 

	Description:    
		Code that computes box box collision.

	Examples:      
	---------------------
	None provided 
	---------------------

*******************************************************************************/

module arc.physics.colliders.box;

import 
	arc.physics.mybody,
	arc.physics.shapes.box,
	arc.physics.collide,
	arc.math.point,
	arc.math.matrix,
	arc.math.routines,
	arc.types;

bool registered = false; 
void register()
{
	if (!registered)
	{
		registerCollider!(Box, Box)(&collideBoxBox);
		registered = true;
	}
}

private
{
	static this()
	{
		register();
	}
	
	// Box vertex and edge numbering:
	//
	//        ^ y
	//        |
	//        e1
	//   v2 ------ v1
	//    |        |
	// e2 |        | e4  -. x
	//    |        |
	//   v3 ------ v4
	//        e3
	
	const int FACE_A_X = 0;
	const int FACE_A_Y = 1;
	const int FACE_B_X = 2;
	const int FACE_B_Y = 3;
	
	const int NO_EDGE = 0;
	const int EDGE1 = 1;
	const int EDGE2 = 2;
	const int EDGE3 = 3;
	const int EDGE4 = 4;
	
	
	struct ClipVertex
	{
		Point v;
		FeaturePair fp;
	}
	
	void flip(inout FeaturePair fp)
	{
		swap!(int)(fp.inEdge1, fp.inEdge2);
		swap!(int)(fp.outEdge1, fp.outEdge2);
	}
	
	int clipSegmentToLine(inout ClipVertex[] vOut, ClipVertex[] vIn,
							inout Point normal, arcfl offset, char clipEdge)
	{
		// Start with no output points
		int numOut = 0;
	
		// Calculate the distance of end points to the line
		arcfl distance0 = normal.dot(vIn[0].v) - offset;
		arcfl distance1 = normal.dot(vIn[1].v) - offset;
	
		// If the points are behind the plane
		if (distance0 <= 0.0f) vOut[numOut++] = vIn[0];
		if (distance1 <= 0.0f) vOut[numOut++] = vIn[1];
	
		// If the points are on different sides of the plane
		if (distance0 * distance1 < 0.0f)
		{
			// Find intersection point of edge and plane
			arcfl interp = distance0 / (distance0 - distance1);
			vOut[numOut].v = vIn[0].v + interp * (vIn[1].v - vIn[0].v);
			if (distance0 > 0.0f)
			{
				vOut[numOut].fp = vIn[0].fp;
				vOut[numOut].fp.inEdge1 = clipEdge;
				vOut[numOut].fp.inEdge2 = NO_EDGE;
			}
			else
			{
				vOut[numOut].fp = vIn[1].fp;
				vOut[numOut].fp.outEdge1 = clipEdge;
				vOut[numOut].fp.outEdge2 = NO_EDGE;
			}
			++numOut;
		}
	
		return numOut;
	}
	
	static void computeIncidentEdge(inout ClipVertex[] c,  inout Point h,  inout Point pos,
									inout Matrix Rot,  inout Point normal)
	{
		// The normal is from the reference box. Convert it
		// to the incident boxe's frame and flip sign.
		Matrix RotT = Rot.transposeCopy();
		Point n = -(RotT * normal);
		Point nAbs = n.absCopy();
	
		if (nAbs.x > nAbs.y)
		{
			if (sign(n.x) > 0.0f)
			{
				c[0].v.set(h.x, -h.y);
				c[0].fp.inEdge2 = EDGE3;
				c[0].fp.outEdge2 = EDGE4;
	
				c[1].v.set(h.x, h.y);
				c[1].fp.inEdge2 = EDGE4;
				c[1].fp.outEdge2 = EDGE1;
			}
			else
			{
				c[0].v.set(-h.x, h.y);
				c[0].fp.inEdge2 = EDGE1;
				c[0].fp.outEdge2 = EDGE2;
	
				c[1].v.set(-h.x, -h.y);
				c[1].fp.inEdge2 = EDGE2;
				c[1].fp.outEdge2 = EDGE3;
			}
		}
		else
		{
			if (sign(n.y) > 0.0f)
			{
				c[0].v.set(h.x, h.y);
				c[0].fp.inEdge2 = EDGE4;
				c[0].fp.outEdge2 = EDGE1;
	
				c[1].v.set(-h.x, h.y);
				c[1].fp.inEdge2 = EDGE1;
				c[1].fp.outEdge2 = EDGE2;
			}
			else
			{
				c[0].v.set(-h.x, -h.y);
				c[0].fp.inEdge2 = EDGE2;
				c[0].fp.outEdge2 = EDGE3;
	
				c[1].v.set(h.x, -h.y);
				c[1].fp.inEdge2 = EDGE3;
				c[1].fp.outEdge2 = EDGE4;
			}
		}
	
		c[0].v = pos + Rot * c[0].v;
		c[1].v = pos + Rot * c[1].v;
	}
		
	
	// Box-Box collision
	//
	// The normal points from A to B
	// contacts is a array of size 2 or MAX_POINTS
	// bodyA is a Box instance in a Body
	// bodyB is a Box instance in a Body
	int collideBoxBox(inout Contact[] contacts, Body bodyA, Body bodyB)
	{
		// Setup
		Box boxA = cast(Box) bodyA;
		Box boxB = cast(Box) bodyB;
		
		assert(boxA !is null && boxB !is null);
		
		Point hA = Size.toPoint(0.5f * boxA.getSize);
		Point hB = Size.toPoint(0.5f * boxB.getSize);
	
		Point posA = bodyA.translation;
		Point posB = bodyB.translation;
	
		Matrix RotA = Matrix(bodyA.rotation);
		Matrix RotB = Matrix(bodyB.rotation);
		
		Matrix RotAT = RotA.transposeCopy();
		Matrix RotBT = RotB.transposeCopy();
	
		Point a1 = RotA.col1, a2 = RotA.col2;
		Point b1 = RotB.col1, b2 = RotB.col2;
	
		Point dp = posB - posA;
		Point dA = RotAT * dp;
		Point dB = RotBT * dp;
	
		Matrix C = RotB * RotAT;
		Matrix absC = C.absCopy();
		Matrix absCT = absC.transposeCopy();
	
		// Box A faces
		Point faceA = dA.absCopy() - hA - absC * hB;
		if (faceA.x > 0.0f || faceA.y > 0.0f)
			return 0;
	
		// Box B faces
		Point faceB = dB.absCopy() - absCT * hA - hB;
		if (faceB.x > 0.0f || faceB.y > 0.0f)
			return 0;
		
		// Find best axis
		int axis;
		arcfl separation=0;
		Point normal;
	
		// Box A faces
		axis = FACE_A_X;
		separation = faceA.x;
		normal = dA.x > 0.0f ? RotA.col1 : -RotA.col1;
	
		if (faceA.y > 1.05f * separation + 0.01f * hA.y)
		{
			axis = FACE_A_Y;
			separation = faceA.y;
			normal = dA.y > 0.0f ? RotA.col2 : -RotA.col2;
		}
	
		// Box B faces
		if (faceB.x > 1.05f * separation + 0.01f * hB.x)
		{
			axis = FACE_B_X;
			separation = faceB.x;
			normal = dB.x > 0.0f ? RotB.col1 : -RotB.col1;
		}
	
		if (faceB.y > 1.05f * separation + 0.01f * hB.y)
		{
			axis = FACE_B_Y;
			separation = faceB.y;
			normal = dB.y > 0.0f ? RotB.col2 : -RotB.col2;
		}
	
		// Setup clipping plane data based on the separating axis
		Point frontNormal, sideNormal;
		ClipVertex[] incidentEdge;incidentEdge.length=2;//[2];
		arcfl front=0, negSide=0, posSide=0;
		char negEdge, posEdge;
	
		// Compute the clipping lines and the line segment to be clipped.
		switch (axis)
		{
		case FACE_A_X:
			{
				frontNormal = normal;
				front = posA.dot(frontNormal) + hA.x;
				sideNormal = RotA.col2;
				arcfl side = posA.dot(sideNormal);
				negSide = -side + hA.y;
				posSide =  side + hA.y;
				negEdge = EDGE3;
				posEdge = EDGE1;
				computeIncidentEdge(incidentEdge, hB, posB, RotB, frontNormal);
			}
			break;
	
		case FACE_A_Y:
			{
				frontNormal = normal;
				front = posA.dot(frontNormal) + hA.y;
				sideNormal = RotA.col1;
				arcfl side = posA.dot(sideNormal);
				negSide = -side + hA.x;
				posSide =  side + hA.x;
				negEdge = EDGE2;
				posEdge = EDGE4;
				computeIncidentEdge(incidentEdge, hB, posB, RotB, frontNormal);
			}
			break;
	
		case FACE_B_X:
			{
				frontNormal = -normal;
				front = posB.dot(frontNormal) + hB.x;
				sideNormal = RotB.col2;
				arcfl side = posB.dot(sideNormal);
				negSide = -side + hB.y;
				posSide =  side + hB.y;
				negEdge = EDGE3;
				posEdge = EDGE1;
				computeIncidentEdge(incidentEdge, hA, posA, RotA, frontNormal);
			}
			break;
	
		case FACE_B_Y:
			{
				frontNormal = -normal;
				front = posB.dot(frontNormal) + hB.y;
				sideNormal = RotB.col1;
				arcfl side = posB.dot(sideNormal);
				negSide = -side + hB.x;
				posSide =  side + hB.x;
				negEdge = EDGE2;
				posEdge = EDGE4;
				computeIncidentEdge(incidentEdge, hA, posA, RotA, frontNormal);
			}
			break;
		}
	
		// clip other face with 5 box planes (1 face plane, 4 edge planes)
	
		ClipVertex[] clipPoints1;clipPoints1.length=2;//[2];
		ClipVertex[] clipPoints2;clipPoints2.length=2;//[2];
		int np;
	
		// Clip to box side 1
		np = clipSegmentToLine(clipPoints1, incidentEdge, -sideNormal, negSide, negEdge);
	
		if (np < 2)
			return 0;
	
		// Clip to negative box side 1
		np = clipSegmentToLine(clipPoints2, clipPoints1,  sideNormal, posSide, posEdge);
	
		if (np < 2)
			return 0;
	
		// Now clipPoints2 contains the clipping points.
		// Due to roundoff, it is possible that clipping removes all points.
	
		int numContacts = 0;
		for (int i = 0; i < 2; ++i)
		{
			separation = frontNormal.dot(clipPoints2[i].v) - front;
	
			if (separation <= 0)
			{
				contacts[numContacts].separation = separation;
				contacts[numContacts].normal = normal;
				// slide contact point onto reference face (easy to cull)
				contacts[numContacts].position = clipPoints2[i].v - separation * frontNormal;
				contacts[numContacts].feature = clipPoints2[i].fp;
				if (axis == FACE_B_X || axis == FACE_B_Y)
					flip(contacts[numContacts].feature);
				++numContacts;
			}
		}
	
		return numContacts;
	}
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
