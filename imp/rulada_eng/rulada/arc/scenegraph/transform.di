/******************************************************************************* 

	Group node that moves, scales and rotates everything below it.

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
		Group node that moves, scales and rotates everything below it.



	Examples:      
	---------------------
	None provided 
	---------------------

*******************************************************************************/

module arc.scenegraph.transform;

import 
	arc.types, 
	arc.math.point, 
	arc.math.angle,
	arc.scenegraph.node,
	arc.scenegraph.drawable;

import derelict.opengl.gl; 

/***
	Group node that moves, scales and rotates everything below it.
	
	TODO: Find a better explanation, maybe just referring to glPushMatrix.
	When you think about the transform hierachy, start at a leaf node - a Frame for instance,
	then move through the parents until finding the first transform and apply it. Then go to
	the next and continue until the root node to get the coordinates the frame has in the window.
	
	In this sense, rotation and scaling are applied before the translation.
*/
class Transform : GroupNode, IDrawStateChange
{
	Point translation;

	/// apply transformation
	override void drawStateChangeApply()
	{
		glPushMatrix();
		glTranslatef(translation.x, translation.y, 0);
		glRotatef(radiansToDegrees(rotation_), 0, 0, 1);
		glScalef(scale_.x, scale_.y, 1);
	}
	
	/// restore transformation
	override void drawStateChangeRestore()
	{
		glPopMatrix();
	}
	
	/// apply transform 
	void applyTransform(inout Point p)
	{
		p.scale(scale_);
		p.rotate(rotation_);
		p += translation;
	}
	
	/// unapply transform
	void unapplyTransform(inout Point p)
	{
		p -= translation;
		p.rotate(-rotation_);
		p.scale(Point(1/scale_.x, 1/scale_.y));
	}
	
	/// apply rotation
	void rotation(Radians rot)
	{
		rotation_ = restrictRad(rot);
	}
	
	/// get rotation 
	Radians rotation()
	{
		return rotation_;
	}
	
	/// get scale 
	Point scale()
	{
		return scale_;
	}
	
	/// set scale 
	void scale(arcfl s)
	{
		scale_ = Point(s,s);
	}
	
	/// set scale 
	void scale(inout Point s)
	{
		scale_ = s;
	}
	
protected:
	Radians rotation_ = 0;
	Point scale_ = {1f,1f};
}


/***
	Transforms a vector between the coordinate systems of two nodes.
	Mostly useful for converting mouse coordinates to node coordinates.
	This function has to perform several rotations, so use with care.
*/
Point transformCoordinates(Point coord, Node from, Node to)
{
	Node commonBase = null;
	
	foreach(n; &from.traverseUp)
		foreach(m; &to.traverseUp)
			if(n is m)
			{
				commonBase = n;
				break;
			}
		
	if(commonBase is null)
		throw new Exception("In order to transform coordinates between nodes, there has to be a path between them");
	
	// transform coordinates from 'from' to commonBase
	foreach(n; &from.traverseUp)
	{
		Transform transform = cast(Transform) n;
		if(transform !is null)
			transform.applyTransform(coord);
		
		if(n is commonBase)
			break;
	}
	
	// transform coordinates from commonBase to 'to'
	bool start = false;
	foreach(n; &to.traverseUpReverse)
	{
		if(start)
		{
			Transform transform = cast(Transform) n;
			if(transform !is null)
				transform.unapplyTransform(coord);
		}
		
		if(n is commonBase)
			start = true;
	}
	
	return coord;
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
