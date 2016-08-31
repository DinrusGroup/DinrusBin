/**
	Copyright: Copyright (c) 2007, Artyom Shalkhakov. All rights reserved.
	License: BSD

	Version: Aug 2007: initial release
	Authors: Artyom Shalkhakov
*/
module auxd.ray.base.Plane;

import Math = auxd.ray.base.Math;
import auxd.ray.base.Vector;

const Plane	plane_zero = { normal : { x : 0.0f, y : 0.0f, z : 0.0f }, dist : 0.0f };

/// classification
enum PLANESIDE : int {
	FRONT	= 0,		/// in front of plane
	BACK	= 1,		/// behind plane
	ON		= 2,		/// lies on plane
	CROSS	= 3			/// crosses plane
}

/**
	Plane defined through normal vector and signed distance to origin of coordinates.
*/
struct Plane {
	/// construct plane given normal and distance
	static Plane opCall( ref Vec3 normal, float dist ) ;
	
	float opIndex( size_t index );

	void opIndexAssign( float f, size_t index );

	Plane opNeg() ;

	/// add plane equations
	Plane opAdd( ref Plane p );

	/// subtract plane equations
	Plane opSub( ref Plane p );

	/// returns rotated plane
	Plane opMul( ref Mat3 axis ) ;

	/// add plane equations
	void opAddAssign( ref Plane p );

	/// subtract plane equations in place
	void opSubAssign( ref Plane p );
	
	/// rotate plane in place
	void opMulAssign( ref Mat3 axis );

	/// exact compare
	bool opEquals( Plane p );

	/// compare with epsilon
	bool compare( ref Plane p, float epsilon );

	/// compare with separate normal/dist epsilon
	bool compare( ref Plane p, float normalEps, float distEps ) ;

	/// make _zero plane
	void zero();

	/// initialize plane using three points, returns true if plane is valid
	bool fromPoints( ref Vec3 p1, ref Vec3 p2, ref Vec3 p3 ) ;

	/// initialize plane from direction vectors, returns true if plane is valid
	bool fromVecs( ref Vec3 dir1, ref Vec3 dir2, ref Vec3 p );

	/// returns translated plane
	Plane translate( ref Vec3 translation ) ;

	/// translate plane
	void translateSelf( ref Vec3 translation );

	/// returns rotated plane
	Plane rotate( ref Vec3 origin, ref Mat3 axis );

	/// rotate plane
	void rotateSelf( ref Vec3 origin, ref Mat3 axis ) ;

	/// sets plane distance using provided point
	// assumes normal is valid
	void fitThroughPoint( ref Vec3 p ) ;

	/// compute distance from point to plane
	float distance( Vec3 p ) ;

	/// classify point against plane
	int side( ref Vec3 p, float epsilon = 0.0f );

	/**
		Returns intersection time if ray intersects plane, float.infinity otherwise.
	*/
	float rayIntersection( ref Vec3 start, ref Vec3 dir ) ;

	/**
		Returns true if ray intersects plane.
		Intersection point is start + scale * dir.
	*/
	bool rayIntersection( ref Vec3 start, ref Vec3 dir, out float scale ) ;

	/// returns true if plane intersects plane
	bool planeIntersection( ref Plane p, ref Vec3 start, ref Vec3 dir );

	/// converts to string; just a convenience function
	char[] toUtf8() ;

	/// returns the number of components
	size_t length();

	/// returns raw pointer
	float *ptr() ;

	debug ( FLOAT_PARANOID ) {
		invariant() {
			assert( Math.isValid( normal.x ) );
			assert( Math.isValid( normal.y ) );
			assert( Math.isValid( normal.z ) );
			assert( Math.isValid( dist ) );
		}
	}

	Vec3	normal;		/// plane normal
	float	dist;		/// distance from origin of coordinate frame
}

version (build) {
    debug {
        pragma(link, "ray");
    } else {
        pragma(link, "ray");
    }
}
