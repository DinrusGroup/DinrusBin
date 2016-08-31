/******************************************************************************* 

	Code for drawing of physics bodies.

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	The contents of this file are based on E. Catto's Box2d, which is 
	Copyright (c) 2006 Erin Catto http://www.gphysics.com. 

	Description:    
		Code for drawing of physics bodies.

	Examples:      
	---------------------
	None provided 
	---------------------

*******************************************************************************/

module arc.physics.drawphysics;

import 
	arc.physics.mybody,
	arc.physics.shapes.box,
	arc.physics.shapes.circle,
	arc.scenegraph.node,
	arc.math.matrix,
	arc.math.point,
	arc.math.angle,
	arc.types,
	arc.draw.color;

import 
	derelict.opengl.gl,
	derelict.opengl.glu;

import std.math;

private
{
	const arcfl lineWidth = 2.0f;
	const uint circleSegments = 20;
	Color color = Color.White;
}

/// Draw Body 
void drawBody(Body b);
/// Draw box 
void drawBox(Box box);
/// Draw circle 
void drawCircle(Circle circle);

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
