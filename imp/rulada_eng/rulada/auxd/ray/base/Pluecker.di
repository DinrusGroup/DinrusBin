/**
	Copyright: Copyright (c) 2007, Artyom Shalkhakov. All rights reserved.
	License: BSD

	This module implements pluecker coordinates for line segments.

	Version: Aug 2007: initial release
	Authors: Artyom Shalkhakov
*/
module auxd.ray.base.Pluecker;

import Math = auxd.ray.base.Math;
import auxd.ray.base.Vector;
import auxd.ray.base.Plane;

const Pluecker	pluecker_zero = { p : [ 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f ] };

/// Pluecker coordinate
struct Pluecker {
	static Pluecker opCall( float[6] p );

	static Pluecker opCall( ref Vec3 start, ref Vec3 end ) ;

	static Pluecker opCall( float a1, float a2, float a3, float a4, float a5, float a6 );

	/// returns Pluecker coordinate with flipped direction
	Pluecker opNeg() ;

	Pluecker opAdd( ref Pluecker a );
	
	Pluecker opSub( ref Pluecker a ) ;
	Pluecker opMul( float f );
	
	/// permuted inner product
	float opMul( Pluecker a );

	Pluecker opDiv( float f );

	void opAddAssign( ref Pluecker a ) ;
	
	void opSubAssign( ref Pluecker a ) ;

	void opMulAssign( float f );

	void opDivAssign( float f );

	/// exact compare
	bool opEquals( ref Pluecker a );
	
	/// compare with epsilon
	bool compare( ref Pluecker a, float epsilon ) ;

	void set( float a1, float a2, float a3, float a4, float a5, float a6 ) ;
	
	void zero() ;

	float magnitude();

	float magnitudeSquared();

	Pluecker normalize() ;

	/// returns magnitude
	float normalizeSelf(); ;
	
	float permutedInnerProduct( ref Pluecker a ) ;
	
	void fromLineSegment( ref Vec3 start, ref Vec3 end ) ;
	
	void fromRay( ref Vec3 start, ref Vec3 dir ) ;

	/// pluecker coordinate for the intersection of two planes
	bool fromPlanes( ref Plane p1, ref Plane p2 );

	/**
		Convert pluecker coordinate to line segment.
		Returns false if pluecker coodinate does not represent a line.
	*/
	bool toLineSegment( ref Vec3 start, ref Vec3 end ) ;

	/**
		Convert pluecker coordinate to auxd.ray.
		Returns false if pluecker coordinate does not represent a line.
	*/
	bool toRay( ref Vec3 start, ref Vec3 dir );

	/// convert pluecker coordinate to direction vector
	void toDir( ref Vec3 dir );

	/// converts to string; just a convenience function
	char[] toUtf8() ;
	
	size_t length() ;

	float *ptr();

	debug ( FLOAT_PARANOID ) {
		invariant() {
			assert( Math.isValid( p[0] ) );
			assert( Math.isValid( p[1] ) );
			assert( Math.isValid( p[2] ) );
			assert( Math.isValid( p[3] ) );
			assert( Math.isValid( p[4] ) );
			assert( Math.isValid( p[5] ) );
		}
	}

	float[6]	p;
}

version (build) {
    debug {
        pragma(link, "ray");
    } else {
        pragma(link, "ray");
    }
}
