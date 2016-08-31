/**
	Copyright: Copyright (c) 2007, Artyom Shalkhakov. All rights reserved.
	License: BSD

	This module implements quaternion.

	Version: Aug 2007: initial release
	Authors: Artyom Shalkhakov
*/
module auxd.ray.base.Quat;

import Math = auxd.ray.base.Math;
import auxd.ray.base.Vector;
import auxd.ray.base.Angles;

/**
	Unit quaternions are used in to represent rotation about an axis.
	Any 3x3 rotation matrix can be stored as a quaternion.
*/
struct Quat {
	static Quat opCall( float x, float y, float z, float w ) ;
	
	float opIndex( size_t index );
	
	void opIndexAssign( float f, size_t index );

	Quat opNeg() ;
	
	Quat opAdd( ref Quat q );
	
	Quat opSub( ref Quat q );
	
	Quat opMul( float f );

	Vec3 opMul( ref Vec3 v ) ;

	Quat opMul( ref Quat q );
	
	void opAddAssign( ref Quat q );

	void opSubAssign( ref Quat q );

	void opMulAssign( float f );
	
	void opMulAssign( ref Quat q ) ;
	
	bool opEquals( ref Quat q ) ;
	
	bool compare( ref Quat q, float epsilon );

	void set( float x, float y, float z, float w ) ;

	void zero();
	
	Quat inverse() ;
	
	float magnitude();

	void normalize() ;
	
	/// spherical linear interpolation between to quaternions
	Quat slerp( ref Quat to, float t );

	/// ditto
	void slerpSelf( ref Quat from, ref Quat to, float t );
	
	Angles toAngles();

	Mat3 toMat3();
	
	Mat4 toMat4() ;
	
	/// returns string, just a convenience function
	char[] toUtf8() ;
	
	size_t length() ;

	float *ptr() ;

	debug ( FLOAT_PARANOID ) {
		invariant() {
			assert( Math.isValid( x ) );
			assert( Math.isValid( y ) );
			assert( Math.isValid( z ) );
			assert( Math.isValid( w ) );
		}
	}

	float	x, y, z, w;
}

version (build) {
    debug {
        pragma(link, "ray");
    } else {
        pragma(link, "ray");
    }
}
