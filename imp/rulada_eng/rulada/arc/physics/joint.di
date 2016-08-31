/******************************************************************************* 

	Code for joint. 

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	The contents of this file are based on E. Catto's Box2d, which is 
	Copyright (c) 2006 Erin Catto http://www.gphysics.com. 

	Description:    
		Code for joint. 

	Examples:      
	---------------------
	None provided 
	---------------------

*******************************************************************************/
module arc.physics.joint; 

import arc.physics.mybody; 

import 
	arc.math.point,
	arc.math.matrix,
	arc.math.routines,
	arc.scenegraph.node,
	arc.types;

/// joint structure 
class Joint : Node
{
	/// set joint between two bodies with a certain point
	this(Body b1, Body b2, inout Point anchor)
	{
		body1 = b1;
		body2 = b2;

		Matrix Rot1 = Matrix(body1.rotation);
		Matrix Rot2 = Matrix(body2.rotation);
		Matrix Rot1T = Rot1.transposeCopy();
		Matrix Rot2T = Rot2.transposeCopy();

		localAnchor1 = Rot1T * (anchor - body1.translation);
		localAnchor2 = Rot2T * (anchor - body2.translation);

		relaxation = 1.0f;
	}

	/// prestep 
	void preStep(arcfl inv_dt);
	/// apply impulse 
	void applyImpulse();


	Matrix M;
	Point localAnchor1, localAnchor2;
	Point r1, r2;
	Point bias;
	Point accumulatedImpulse;
	Body body1;
	Body body2;
	arcfl relaxation=0;
}


version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
