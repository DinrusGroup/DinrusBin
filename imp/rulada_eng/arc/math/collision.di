/******************************************************************************* 

    Static collision detection methods for arc. 

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		Static collision detection methods for arc. Collision detection methods
	include box-box, box-circle, and circle-circle methods. Also includes point
	collision with all the above methods. Includes line-line collision and 
	line-point collision detection as well. 
		

	Examples:
	--------------------
	// these codes return true or false depending on collision status 
	bool boxBoxCollision(Point pos1, Size size1, Point pos2, Size size2);
	bool boxCircleCollision(Point boxPos, Size boxSize, Point circlePos, arcfl radius);
	bool boxXYCollision(Point point, Point boxPos, Size boxSize) 
	bool circleCircleCollision(	Point c1, arcfl rad1, Point c2, arcfl rad2)
	bool circleXYCollision(Point pos, Point c, arcfl rad)
	bool inSegment( inout Point P, inout Point S0, inout Point S1)
	bool polygonPointCollision(inout Point p, Point[] points)

	// this function returns gives you the point of intersection beween the two lines, 
	// and returns 0 if disjoint, 1 if intersect, and 2 if overlap
	int lineLineCollision(Point S1P0, Point S1P1, Point S2P0, Point S2P1, inout Point I0)
	--------------------

*******************************************************************************/

module arc.math.collision; 

// Static Box, Radius, and Polygon Collision detection algorithms 
import 
	arc.math.routines,
	arc.math.angle,
	arc.math.point,
	arc.types;
		
import 
	std.math, 
	std.io; 

// BOXES //////////////////////////////////////////////////////////////


/// whether 2 boxes collide with each other
bool boxBoxCollision(Point pos1, Size size1, Point pos2, Size size2);

/// whether a box and circle collide with each other
bool boxCircleCollision(Point boxPos, Size boxSize, Point circlePos, arcfl radius);

/// determine whether x and y are within given box
bool boxXYCollision(Point point, Point boxPos, Size boxSize) ;

// CIRCLES ///////////////////////////////////////////////////////////

/// determines whether or not 2 circles have collided
bool circleCircleCollision(	Point c1, arcfl rad1, Point c2, arcfl rad2);
/// determine whether point x, y is within circle
bool circleXYCollision(Point pos, Point c, arcfl rad);

// LINE ///////////////////////////////////////////////////////////


// Line Line Collision /////////////////////////////////
// http://www.geometryalgorithms.com/Archive/algorithm_0104/algorithm_0104B.htm#intersect2D_SegSeg()
// intersect2D_2Segments(): the intersection of 2 finite 2D segments
//    Input:  two finite segments S1 and S2
//    Output: *I0 = intersect point (when it exists)
//    Return: 0=disjoint (no intersect)
//            1=intersect in unique point I0
//            2=overlap in segment from I0 to I1
int lineLineCollision(Point S1P0, Point S1P1, Point S2P0, Point S2P1, inout Point I0);
//===================================================================

// inSegment(): determine if a point is inside a segment
//    Input:  a point P, and a collinear segment S
//    Return: true = P is inside S
//            false = P is not inside S
bool inSegment( Point P, Point S0, Point S1);


// POINT //////////////////////////////////////////////////////////

/// returns true if this point is inside of this polygon
bool polygonXYCollision(Point p, Point[] points);


version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
