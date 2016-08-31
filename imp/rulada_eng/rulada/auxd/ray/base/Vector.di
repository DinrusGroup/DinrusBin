/**
	Copyright: Copyright (c) 2007, Artyom Shalkhakov. All rights reserved.
	License: BSD

	This module implements vector and matrix classes.

	Vectors are implemented as flat structures, but indexing in array fashion
	is supported.

	Matrix row-major vs column-major memory layout is chosen to faciliate common
	operations.

	Version: Aug 2007: initial release
	Authors: Artyom Shalkhakov
*/
module auxd.ray.base.Vector;

import Math = auxd.ray.base.Math;
import auxd.ray.base.Angles;
import auxd.ray.base.Quat;

const {
	float	MATRIX_INVERSE_EPSILON	= 1e-14;
	float	MATRIX_EPSILON			= 1e-6;

	Vec2	vec2_zero				= { x : 0.0f, y : 0.0f };
	Vec3	vec3_zero				= { x : 0.0f, y : 0.0f, z : 0.0f };
	Vec4	vec4_zero				= { x : 0.0f, y : 0.0f, z : 0.0f, w : 0.0f };
	Mat2	mat2_zero				= { rows : [ { x : 0.0f, y : 0.0f }, { x : 0.0f, y : 0.0f } ] };
	Mat2	mat2_identity			= { rows : [ { x : 1.0f, y : 0.0f }, { x : 0.0f, y : 1.0f } ] };
	Mat3	mat3_zero				= { cols : [ { x : 0.0f, y : 0.0f, z : 0.0f },
										{ x : 0.0f, y : 0.0f, z : 0.0f },
										{ x : 0.0f, y : 0.0f, z : 0.0f } ] };
	Mat3	mat3_identity			= { cols : [ { x : 1.0f, y : 0.0f, z : 0.0f },
										{ x : 0.0f, y : 1.0f, z : 0.0f },
										{ x : 0.0f, y : 0.0f, z : 1.0f } ] };
	Mat4	mat4_zero				= { rows : [ { x : 0.0f, y : 0.0f, z : 0.0f, w : 0.0f },
										{ x : 0.0f, y : 0.0f, z : 0.0f, w : 0.0f },
										{ x : 0.0f, y : 0.0f, z : 0.0f, w : 0.0f },
										{ x : 0.0f, y : 0.0f, z : 0.0f, w : 0.0f } ] };
	Mat4	mat4_identity			= { rows : [ { x : 1.0f, y : 0.0f, z : 0.0f, w : 0.0f },
										{ x : 0.0f, y : 1.0f, z : 0.0f, w : 0.0f },
										{ x : 0.0f, y : 0.0f, z : 1.0f, w : 0.0f },
										{ x : 0.0f, y : 0.0f, z : 0.0f, w : 1.0f } ] };
}

/**
	Vec2 - a vector in R^2
*/
struct Vec2 {
	static Vec2 opCall( float x, float y );

	static Vec2 opCall( float[2] v ) ;

	float opIndex( size_t index );

	float opIndexAssign( float f, size_t index );

	Vec2 opNeg();

	Vec2 opAdd( ref Vec2 v ) ;

	Vec2 opSub( ref Vec2 v ) ;

	Vec2 opMul( float f );

	float opMul( ref Vec2 v );

	Vec2 opDiv( float f );
	
	Vec2 opDiv( ref Vec2 v );

	void opAddAssign( ref Vec2 v ) ;

	void opSubAssign( ref Vec2 v );
	
	void opMulAssign( float f );

	void opDivAssign( float f );

	void opDivAssign( ref Vec2 v );

	/// exact compare
	bool opEquals( ref Vec2 v ) ;
	
	/// _compare with epsilon
	bool compare( ref Vec2 v, float epsilon );

	/// _set new values for x and y
	void set( float x, float y ) ;

	/// make _zero vector
	void zero();

	/// returns vector magnitude
	float magnitude() ;

	/// returns squared magnitude of vector
	float magnitudeSquared() ;

	/// returns normalized vector
	Vec2 normalize() ;

	/// normalize vector
	float normalizeSelf();

	/// cap magnitude
	void truncateSelf( float maxMagnitude );

	/// bound vector
	void clampSelf( ref Vec2 min, ref Vec2 max );

	/// returns vector linearly interpolated from this to v2
	Vec2 lerp( ref Vec2 v2, float f ) ;
	
	/// linearly interpolate from v1 to v2
	void lerpSelf( ref Vec2 v1, ref Vec2 v2, float f ) ;

	/// returns hash-code for vector
	size_t toHash();

	/// returns string, just a convenience function
	char[] toUtf8() ;
	
	/// returns the number of components
	size_t length();

	/// returns raw pointer
	float *ptr();

	debug ( FLOAT_PARANOID ) {
		invariant() {
			assert( Math.isValid( x ) );
			assert( Math.isValid( y ) );
		}
	}

	float		x, y;
}

/**
	Vec3 - a vector in R^3
*/
struct Vec3 {
	static Vec3 opCall( float x, float y, float z ) {
		Vec3	dst;

		dst.x = x;
		dst.y = y;
		dst.z = z;

		return dst;
	}

	static Vec3 opCall( float[3] v ) {
		Vec3	dst;

		dst.x = v[0];
		dst.y = v[1];
		dst.z = v[2];

		return dst;
	}

	float opIndex( size_t index )
	in {
		assert( index >= 0 && index < 3 );
	}
	body {
		return ( &x )[index];
	}

	float opIndexAssign( float f, size_t index )
	in {
		assert( index >= 0 && index < 3 );
	}
	body {
		return ( &x )[index] = f;
	}

	Vec3 opNeg() {
		return Vec3( -x, -y, -z );
	}

	Vec3 opAdd( ref Vec3 v ) {
		return Vec3( x + v.x, y + v.y, z + v.z );
	}

	Vec3 opSub( ref Vec3 v ) {
		return Vec3( x - v.x, y - v.y, z - v.z );
	}

	Vec3 opMul( float f )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( f ) );
		}
	}
	body {
		return Vec3( x * f, y * f, z * f );
	}

	float opMul( ref Vec3 v ) {
		return ( x * v.x + y * v.y + z * v.z );
	}

	Vec3 opMul( ref Mat3 m ) {
		return m * ( *this );
	}

	Vec3 opDiv( float f )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( f ) );
			assert( Math.abs( f - 0.0f ) > 1e-14 );
		}
	}
	body {
		float	invF = 1.0f / f;

		return Vec3( x * invF, y * invF, z * invF );
	}

	Vec3 opDiv( ref Vec3 v )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( v.x ) && Math.isValid( v.y ) && Math.isValid( v.z ) );
			assert( Math.abs( v.x - 0.0f ) > 1e-14 && Math.abs( v.y - 0.0f ) > 1e-14 && Math.abs( v.z - 0.0f ) > 1e-14 );
		}
	}
	body {
		return Vec3( x / v.x, y / v.y, z / v.z );
	}

	void opAddAssign( ref Vec3 v ) {
		x += v.x;
		y += v.y;
		z += v.z;
	}

	void opSubAssign( ref Vec3 v ) {
		x -= v.x;
		y -= v.y;
		z -= v.z;
	}

	void opMulAssign( float f )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( f ) );
		}
	}
	body {
		x *= f;
		y *= f;
		z *= f;
	}

	void opMulAssign( ref Mat3 m ) {
		float	rx = m.cols[0].x * x + m.cols[1].x * y + m.cols[2].x * z;
		float	ry = m.cols[0].y * x + m.cols[1].y * y + m.cols[2].y * z;

		z = m.cols[0].z * x + m.cols[1].z * y + m.cols[2].z * z;
		x = rx;
		y = ry;
	}

	void opDivAssign( float f )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( f ) );
			assert( Math.abs( f - 0.0f ) > 1e-14 );
		}
	}
	body {
		float	invF = 1.0f / f;

		x *= f;
		y *= f;
		z *= f;
	}

	void opDivAssign( ref Vec3 v ) {
		x /= v.x;
		y /= v.y;
		z /= v.z;
	}

	/// exact compare
	bool opEquals( ref Vec3 v ) {
		return ( x == v.x && y == v.y && z == v.z );
	}

	/// _compare with epsilon
	bool compare( ref Vec3 v, float epsilon ) {
		if ( Math.abs( x - v.x ) > epsilon ) {
			return false;
		}
		if ( Math.abs( y - v.y ) > epsilon ) {
			return false;
		}
		if ( Math.abs( z - v.z ) > epsilon ) {
			return false;
		}

		return true;
	}

	/// returns cross product of vector and v
	Vec3 cross( ref Vec3 v ) {
		Vec3	dst;

		dst.x = y * v.z - z * v.y;
		dst.y = z * v.x - x * v.z;
		dst.z = x * v.y - y * v.x;

		return dst;
	}

	/// sets vector to cross product of v1 and v2
	void cross( ref Vec3 v1, ref Vec3 v2 ) {
		x = v1.y * v2.z - v1.z * v2.y;
		y = v1.z * v2.x - v1.x * v2.z;
		z = v1.x * v2.y - v1.y * v2.x;
	}

	/// make _zero vector
	void zero() {
		*this = vec3_zero;
	}

	/// set new values for x, y and z
	void set( float x, float y, float z ) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	/// returns vector magnitude
	float magnitude() {
		return Math.sqrt( x * x + y * y + z * z );
	}

	/// returns vector magnitude squared
	float magnitudeSquared() {
		return ( x * x + y * y + z * z );
	}

	/// returns normalized vector
	Vec3 normalize() {
		float	mag = magnitudeSquared;
		float	invMag = Math.invSqrt( mag );

		return Vec3( x * invMag, y * invMag, z * invMag );
	}

	/// normalizes vector
	float normalizeSelf() {
		float	mag = magnitudeSquared;
		float	invMag = Math.invSqrt( mag );

		x *= invMag;
		y *= invMag;
		z *= invMag;

		return mag * invMag;
	}

	/// cap magnitude
	void truncateSelf( float magnitude )
	in {
		assert( magnitude > 0.0f );
	}
	body {
		float	mag = magnitudeSquared;

		if ( mag > magnitude * magnitude ) {
			mag = magnitude / Math.sqrt( mag );
			x *= mag;
			y *= mag;
			z *= mag;
		}
	}

	/// bound vector
	void clampSelf( ref Vec3 min, ref Vec3 max ) {
		x = Math.clamp( x, min.x, max.x );
		y = Math.clamp( y, min.y, max.y );
		z = Math.clamp( z, min.z, max.z );
	}

	// vector should be normalized
	void normalVectors( ref Vec3 left, ref Vec3 down ) {
		float	d;

		d = x * x + y * y;
		if ( !d ) {
			left.x = 1.0f;
			left.y = left.z = 0.0f;
		}
		else {
			d = 1.0f / Math.sqrt( d );
			left.x = -y * d;
			left.y = x * d;
			left.z = 0;
		}
		down = left.cross( *this );
	}

	/// returns vector linearly interpolated from this to v2
	Vec3 lerp( ref Vec3 v2, float f ) {
		if ( f <= 0.0f ) {
			return *this;
		}
		else if ( f >= 1.0f ) {
			return v2;
		}
		return *this + f * ( v2 - ( *this ) );
	}

	/// linearly interpolate from v1 to v2
	void lerpSelf( ref Vec3 v1, ref Vec3 v2, float f ) {
		if ( f <= 0.0f ) {
			*this = v1;
		}
		else if ( f >= 1.0f ) {
			*this = v2;
		}
		else {
			*this = v1 + f * ( v2 - v1 );
		}
	}

	/// returns the number of components
	size_t length() {
		return 3;
	}

	/// returns raw pointer
	float *ptr() {
		return &x;
	}

	/// returns string, just a convenience function
	char[] toUtf8() {
		return Math.toUtf8( "( x:{0:E} y:{1:E} z:{2:E} )", x, y, z );
	}

	/// converts to 2-component vector
	Vec2 toVec2() {
		return Vec2( x, y );
	}

	// returns hash-code for vector
	size_t toHash() {
		size_t	xHash = *( cast( int * )cast( void * )( &x ) );
		size_t	yHash = *( cast( int * )cast( void * )( &y ) );
		size_t	zHash = *( cast( int * )cast( void * )( &z ) );

		return ( xHash + yHash * 37 + zHash * 101 );
	}

	debug ( FLOAT_PARANOID ) {
		invariant() {
			assert( Math.isValid( x ) );
			assert( Math.isValid( y ) );
			assert( Math.isValid( z ) );
		}
	}

	float		x, y, z;
}

/**
	Vec4 - a homogenous vector
*/
struct Vec4 {
	static Vec4 opCall( float x, float y, float z, float w ) {
		Vec4	dst;

		dst.x = x;
		dst.y = y;
		dst.z = z;
		dst.w = w;

		return dst;
	}

	static Vec4 opCall( ref Vec3 v, float w ) {
		Vec4	dst;

		dst.x = v.x;
		dst.y = v.y;
		dst.z = v.z;
		dst.w = w;

		return dst;
	}

	static Vec4 opCall( float[4] xyzw ) {
		Vec4	dst;

		dst.x = xyzw[0];
		dst.y = xyzw[1];
		dst.z = xyzw[2];
		dst.w = xyzw[3];

		return dst;
	}

	float opIndex( size_t index )
	in {
		assert( index >= 0 && index < 4 );
	}
	body {
		return ( &x )[index];
	}

	float opIndexAssign( float f, size_t index )
	in {
		assert( index >= 0 && index < 4 );
	}
	body {
		return ( &x )[index] = f;
	}

	Vec4 opNeg() {
		return Vec4( -x, -y, -z, -w );
	}

	Vec4 opAdd( ref Vec4 v ) {
		return Vec4( x + v.x, y + v.y, z + v.z, w + v.w );
	}

	Vec4 opSub( ref Vec4 v ) {
		return Vec4( x - v.x, y - v.y, z - v.z, w - v.w );
	}

	Vec4 opMul( float f )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( f ) );
		}
	}
	body {
		return Vec4( x * f, y * f, z * f, w * f );
	}

	float opMul( ref Vec4 v ) {
		return ( x * v.x + y * v.y + z * v.z + w * v.w );
	}

	Vec4 opDiv( float f )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( f ) );
			assert( Math.abs( f - 0.0f ) > 1e-14 );
		}
	}
	body {
		float	invF = 1.0f / f;

		return Vec4( x * invF, y * invF, z * invF, w * invF );
	}

	void opAddAssign( ref Vec4 v ) {
		x += v.x;
		y += v.y;
		z += v.z;
		w += v.w;
	}

	void opSubAssign( ref Vec4 v ) {
		x -= v.x;
		y -= v.y;
		z -= v.z;
		w -= v.w;
	}

	void opMulAssign( float f )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( f ) );
		}
	}
	body {
		x *= f;
		y *= f;
		z *= f;
		w *= f;
	}

	void opDivAssign( float f )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( f ) );
			assert( Math.abs( f - 0.0f ) > 1e-14 );
		}
	}
	body {
		float	invF = 1.0f / f;

		x *= invF;
		y *= invF;
		z *= invF;
		w *= invF;
	}

	void opDivAssign( ref Vec4 v ) {
		x /= v.x;
		y /= v.y;
		z /= v.z;
		w /= v.w;
	}

	/// exact compare
	bool opEquals( ref Vec4 v ) {
		return ( x == v.x && y == v.y && z == v.z && w == v.w );
	}

	/// _compare with epsilon
	bool compare( ref Vec4 v, float epsilon ) {
		if ( Math.abs( x - v.x ) > epsilon ) {
			return false;
		}
		if ( Math.abs( y - v.y ) > epsilon ) {
			return false;
		}
		if ( Math.abs( z - v.z ) > epsilon ) {
			return false;
		}
		if ( Math.abs( w - v.w ) > epsilon ) {
			return false;
		}
		return true;
	}

	/// _zero vector
	void zero() {
		*this = vec4_zero;
	}

	/// set new values for x, y, z, w
	void set( float x, float y, float z, float w ) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	/// returns vector magnitude
	float magnitude() {
		return Math.sqrt( x * x + y * y + z * z + w * w );
	}

	/// returns squared vector magnitude
	float magnitudeSquared() {
		return ( x * x + y * y + z * z + w * w );
	}

	/// returns normalized vector
	Vec4 normalize() {
		float	mag = magnitudeSquared;
		float	invMag = Math.invSqrt( mag );

		return Vec4( x * invMag, y * invMag, z * invMag, w * invMag );
	}

	/// normalizes vector
	float normalizeSelf() {
		float	mag = magnitudeSquared;
		float	invMag = Math.invSqrt( mag );

		x *= invMag;
		y *= invMag;
		z *= invMag;
		w *= invMag;

		return mag * invMag;
	}

	/// returns vector linearly interpolated from this to v2
	Vec4 lerp( ref Vec4 v2, float f ) {
		if ( f <= 0.0f ) {
			return *this;
		}
		else if ( f >= 1.0f ) {
			return v2;
		}
		return *this + f * ( v2 - ( *this ) );
	}

	/// linearly interpolate from v1 to v2
	void lerpSelf( ref Vec4 v1, ref Vec4 v2, float f ) {
		if ( f <= 0.0f ) {
			*this = v1;
		}
		else if ( f >= 1.0f ) {
			*this = v2;
		}
		else {
			*this = v1 + f * ( v2 - v1 );
		}
	}

	/// homogenizes the vector
	Vec3 homogenize() {
		float	iw = 1.0f / w;

		return Vec3( x * iw, y * iw, z * iw );
	}

	/// returns Vec3 components
	Vec3 toVec3() {
		return Vec3( x, y, z );
	}

	/// returns string, just a convenience function
	char[] toUtf8() {
		return Math.toUtf8( "( x:{0:E} y:{1:E} z:{2:E} w:{3:E} )", x, y, z, w );
	}

	/// returns the number of components
	size_t length() {
		return 4;
	}

	/// returns raw pointer
	float *ptr() {
		return &x;
	}

	debug ( FLOAT_PARANOID ) {
		invariant() {
			assert( Math.isValid( x ) );
			assert( Math.isValid( y ) );
			assert( Math.isValid( z ) );
			assert( Math.isValid( w ) );
		}
	}

	float		x, y, z, w;
}

//=====================================================================

/**
	Mat2 - a 2x2 matrix

	Memory layout is row-major.
*/
struct Mat2 {
	static Mat2 opCall( ref Vec2 x, ref Vec2 y ) {
		Mat2	dst;

		dst.rows[0] = x;
		dst.rows[1] = y;

		return dst;
	}

	static Mat2 opCall( float xx, float xy, float yx, float yy ) {
		Mat2	dst;

		dst.rows[0].x = xx;
		dst.rows[0].y = xy;
		dst.rows[1].x = yx;
		dst.rows[1].y = yy;

		return dst;
	}

	static Mat2 opCall( float[2][2] m ) {
		Mat2	dst;

		dst.rows[0].x = m[0][0];
		dst.rows[0].y = m[0][1];
		dst.rows[1].x = m[1][0];
		dst.rows[1].y = m[1][1];

		return dst;
	}

	Mat2 opNeg() {
		return Mat2( -rows[0].x, -rows[0].y, -rows[1].x, -rows[1].y );
	}

	Mat2 opAdd( ref Mat2 m ) {
		Mat2	dst;

		dst.rows[0].x = rows[0].x + m.rows[0].x,
		dst.rows[0].y = rows[0].y + m.rows[0].y,
		dst.rows[1].x = rows[1].x + m.rows[1].x,
		dst.rows[1].y = rows[1].y + m.rows[1].y;

		return dst;
	}

	Mat2 opSub( ref Mat2 m ) {
		Mat2	dst;

		dst.rows[0].x = rows[0].x - m.rows[0].x,
		dst.rows[0].y = rows[0].y - m.rows[0].y,
		dst.rows[1].x = rows[1].x - m.rows[1].x,
		dst.rows[1].y = rows[1].y - m.rows[1].y;

		return dst;
	}

	Mat2 opMul( float f )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( f ) );
		}
	}
	body {
		Mat2	dst;

		dst.rows[0].x = rows[0].x * f,
		dst.rows[0].y = rows[0].y * f,
		dst.rows[1].x = rows[1].x * f;
		dst.rows[1].y = rows[1].y * f;

		return dst;
	}

	Vec2 opMul( ref Vec2 v ) {
		Vec2	dst;

		dst.x = rows[0].x * v.x + rows[0].y * v.y;
		dst.y = rows[1].x * v.x + rows[1].y * v.y;

		return dst;
	}

	Mat2 opMul( ref Mat2 m ) {
		Mat2	dst;

		dst.rows[0].x = rows[0].x * m.rows[0].x + rows[0].y * m.rows[1].x;
		dst.rows[0].y = rows[0].x * m.rows[0].y + rows[0].y * m.rows[1].y;
		dst.rows[1].x = rows[1].x * m.rows[0].x + rows[1].y * m.rows[1].x;
		dst.rows[1].y = rows[1].x * m.rows[0].y + rows[1].y * m.rows[1].y;

		return dst;
	}

	void opAddAssign( ref Mat2 m ) {
		rows[0].x += m.rows[0].x;
		rows[0].y += m.rows[0].y;
		rows[1].x += m.rows[1].x;
		rows[1].y += m.rows[1].y;
	}

	void opSubAssign( ref Mat2 m ) {
		rows[0].x -= m.rows[0].x;
		rows[0].y -= m.rows[0].y;
		rows[1].x -= m.rows[1].x;
		rows[1].y -= m.rows[1].y;
	}

	void opMulAssign( float f )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( f ) );
		}
	}
	body {
		rows[0].x *= f;
		rows[0].y *= f;
		rows[1].x *= f;
		rows[1].y *= f;
	}

	void opMulAssign( ref Mat2 m ) {
		float	x, y;

		x = rows[0].x;
		y = rows[0].y;
		rows[0].x = x * m.rows[0].x + y * m.rows[1].x;
		rows[0].y = x * m.rows[0].y + y * m.rows[1].y;

		x = rows[1].x;
		y = rows[1].y;
		rows[1].x = x * m.rows[0].x + y * m.rows[1].x;
		rows[1].y = x * m.rows[0].y + y * m.rows[1].y;
	}

	/// exact compare
	bool opEquals( ref Mat2 m ) {
		return ( rows[0] == m.rows[0] && rows[1] == m.rows[1] );
	}

	/// _compare with epsilon
	bool compare( ref Mat2 m, float epsilon ) {
		if ( !rows[0].compare( m.rows[0], epsilon ) ) {
			return false;
		}
		if ( !rows[1].compare( m.rows[1], epsilon ) ) {
			return false;
		}

		return true;
	}

	/// _zero matrix
	void zero() {
		*this = mat2_zero;
	}

	/// _identity matrix
	void identity() {
		*this = mat2_identity;
	}

	// FIXME: can't compile: cannot modify final variable 'mat2_identity'
//	bool isIdentity( float epsilon = MATRIX_EPSILON ) {
//		return compare( mat2_identity, epsilon );
//	}

	bool isSymmetric( float epsilon = MATRIX_EPSILON ) {
		return ( Math.abs( rows[0].y - rows[1].x ) < epsilon );
	}

	bool isDiagonal( float epsilon = MATRIX_EPSILON ) {
		if ( Math.abs( rows[0].y ) > epsilon || Math.abs( rows[1].x ) > epsilon ) {
			return false;
		}

		return true;
	}

	void projectVector( ref Vec2 src, ref Vec2 dst ) {
		dst.x = src * rows[0];
		dst.y = src * rows[1];
	}

	void unprojectVector( ref Vec2 src, ref Vec2 dst ) {
		dst = rows[0] * src.x + rows[1] * src.y;
	}

	float trace() {
		return ( rows[0].x + rows[1].y );
	}

	float determinant() {
		return ( rows[0].x * rows[1].y - rows[0].y * rows[1].x );
	}

	/// returns transposed matrix
	Mat2 transpose() {
		Mat2	dst;

		dst.rows[0].x = rows[0].x;
		dst.rows[0].y = rows[1].x;
		dst.rows[1].x = rows[0].y;
		dst.rows[1].y = rows[1].y;

		return dst;
	}

	/// transposes the matrix
	void transposeSelf() {
		float	temp;

		temp = rows[0].y;
		rows[0].y = rows[1].x;
		rows[1].x = temp;
	}

	/// returns the inverse of the matrix
	Mat2 inverse() {
		Mat2	invMat = *this;
		bool	r;

		r = invMat.inverseSelf();
		assert( r );

		return invMat;
	}

	/// inverts the matrix
	bool inverseSelf() {
		double		det, invDet, a;

		det = rows[0].x * rows[1].y - rows[0].y * rows[1].x;

		if ( Math.abs( det ) < MATRIX_INVERSE_EPSILON ) {
			return false;
		}

		invDet = 1.0f / det;

		a = rows[0].x;
		rows[0].x = rows[1].y * invDet;
		rows[0].y = -rows[0].y * invDet;
		rows[1].x = -rows[1].x * invDet;
		rows[1].y = a * invDet;

		return true;
	}

	Mat2 transposeMultiply( ref Mat2 m ) {
		Mat2	dst;

		dst.rows[0].x = rows[0].x * m.rows[0].x + rows[0].y * m.rows[0].y;
		dst.rows[0].y = rows[0].x * m.rows[1].x + rows[0].y * m.rows[1].y;
		dst.rows[1].x = rows[1].x * m.rows[0].x + rows[1].y * m.rows[0].y;
		dst.rows[1].y = rows[1].x * m.rows[1].x + rows[1].y * m.rows[1].y;

		return dst;
	}

	/// returns string, just a convenience function
	char[] toUtf8() {
		return Math.toUtf8( "( X:{0} Y:{1} )", rows[0].toUtf8, rows[1].toUtf8 );
	}

	/// returns the number of components
	size_t length() {
		return 4;
	}

	/// returns raw pointer
	float *ptr() {
		return rows[0].ptr;
	}

	Vec2[2]	rows;
}

/**
	Mat3 - a 3x3 matrix

	Memory layout is column-major.
*/
struct Mat3 {
	static Mat3 opCall( ref Vec3 x, ref Vec3 y, ref Vec3 z ) {
		Mat3	dst;

		dst.cols[0] = x;
		dst.cols[1] = y;
		dst.cols[2] = z;

		return dst;
	}

	static Mat3 opCall( float xx, float xy, float xz, float yx, float yy, float yz, float zx, float zy, float zz ) {
		Mat3	dst;

		dst.cols[0].x = xx; dst.cols[0].y = xy; dst.cols[0].z = xz;
		dst.cols[1].x = yx; dst.cols[1].y = yy; dst.cols[1].z = yz;
		dst.cols[2].x = zx; dst.cols[2].y = zy; dst.cols[2].z = zz;

		return dst;
	}

	static Mat3 opCall( float[3][3] m ) {
		Mat3	dst;

		dst.cols[0].x = m[0][0]; dst.cols[0].y = m[1][0]; dst.cols[0].z = m[2][0];
		dst.cols[1].x = m[0][1]; dst.cols[1].y = m[1][1]; dst.cols[1].z = m[2][1];
		dst.cols[2].x = m[0][2]; dst.cols[2].y = m[2][1]; dst.cols[2].z = m[2][2];

		return dst;
	}

	Vec3 opIndex( size_t index ) {
		return cols[index];
	}

	Vec3 opIndexAssign( ref Vec3 column, size_t index ) {
		return cols[index] = column;
	}

	Mat3 opNeg() {
		Mat3	dst;

		dst.cols[0].x = -cols[0].x; dst.cols[0].y = -cols[0].y; dst.cols[0].z = -cols[0].z;
		dst.cols[1].x = -cols[1].x; dst.cols[1].y = -cols[1].y; dst.cols[1].z = -cols[1].z;
		dst.cols[2].x = -cols[2].x; dst.cols[2].y = -cols[2].y; dst.cols[2].z = -cols[2].z;

		return dst;
	}

	Mat3 opAdd( ref Mat3 m ) {
		Mat3	dst;

		dst.cols[0].x = cols[0].x + m.cols[0].x; dst.cols[0].y = cols[0].y + m.cols[0].y; dst.cols[0].z = cols[0].z + m.cols[0].z;
		dst.cols[1].x = cols[1].x + m.cols[1].x; dst.cols[1].y = cols[1].y + m.cols[1].y; dst.cols[1].z = cols[1].z + m.cols[1].z;
		dst.cols[2].x = cols[2].x + m.cols[2].x; dst.cols[2].y = cols[2].y + m.cols[2].y; dst.cols[2].z = cols[2].z + m.cols[2].z;

		return dst;
	}

	Mat3 opSub( ref Mat3 m ) {
		Mat3	dst;

		dst.cols[0].x = cols[0].x - m.cols[0].x; dst.cols[0].y = cols[0].y - m.cols[0].y; dst.cols[0].z = cols[0].z - m.cols[0].z;
		dst.cols[1].x = cols[1].x - m.cols[1].x; dst.cols[1].y = cols[1].y - m.cols[1].y; dst.cols[1].z = cols[1].z - m.cols[1].z;
		dst.cols[2].x = cols[2].x - m.cols[2].x; dst.cols[2].y = cols[2].y - m.cols[2].y; dst.cols[2].z = cols[2].z - m.cols[2].z;

		return dst;
	}

	Mat3 opMul( float f )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( f ) );
		}
	}
	body {
		Mat3	dst;

		dst.cols[0].x = cols[0].x * f; dst.cols[0].y = cols[0].y * f; dst.cols[0].z = cols[0].z * f;
		dst.cols[1].x = cols[1].x * f; dst.cols[1].y = cols[1].y * f; dst.cols[1].z = cols[1].z * f;
		dst.cols[2].x = cols[2].x * f; dst.cols[2].y = cols[2].y * f; dst.cols[2].z = cols[2].z * f;

		return dst;
	}

	Vec3 opMul( ref Vec3 v ) {
		Vec3	dst;

		dst[0] = cols[0].x * v.x + cols[1].x * v.y + cols[2].x * v.z;
		dst[1] = cols[0].y * v.x + cols[1].y * v.y + cols[2].y * v.z;
		dst[2] = cols[0].z * v.x + cols[1].z * v.y + cols[2].z * v.z;

		return dst;
	}

	Mat3 opMul( ref Mat3 m ) {
		Mat3	dst;
		float *	m1Ptr = ptr, m2Ptr =  m.ptr, dstPtr = dst.ptr;

		for ( size_t i = 0; i < 3; i++ ) {
			for ( size_t j; j < 3; j++ ) {
				*dstPtr = m1Ptr[0] * m2Ptr[0 * 3 + j]
						+ m1Ptr[1] * m2Ptr[1 * 3 + j]
						+ m1Ptr[2] * m2Ptr[2 * 3 + j];
				dstPtr++;
			}
			m1Ptr += 3;
		}

		return dst;
	}

	void opAddAssign( ref Mat3 m ) {
		cols[0].x += m.cols[0].x; cols[0].y += m.cols[0].y; cols[0].z += m.cols[0].z;
		cols[1].x += m.cols[1].x; cols[1].y += m.cols[1].y; cols[1].z += m.cols[1].z;
		cols[2].x += m.cols[2].x; cols[2].y += m.cols[2].y; cols[2].z += m.cols[2].z;
	}

	void opSubAssign( ref Mat3 m ) {
		cols[0].x += m.cols[0].x; cols[0].y += m.cols[0].y; cols[0].z += m.cols[0].z;
		cols[1].x += m.cols[1].x; cols[1].y += m.cols[1].y; cols[1].z += m.cols[1].z;
		cols[2].x += m.cols[2].x; cols[2].y += m.cols[2].y; cols[2].z += m.cols[2].z;
	}

	void opMulAssign( float f )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( f ) );
		}
	}
	body {
		cols[0].x *= f; cols[1].y *= f; cols[2].z *= f;
		cols[0].x *= f; cols[1].y *= f; cols[2].z *= f;
		cols[0].x *= f; cols[1].y *= f; cols[2].z *= f;
	}

	void opMulAssign( ref Mat3 m ) {
		*this = ( *this ) * m;
	}

	/// exact compare
	bool opEquals( ref Mat3 m ) {
		return ( cols[0] == m.cols[0] && cols[1] == m.cols[1] && cols[2] == m.cols[2] );
	}

	/// _compare with epsilon
	bool compare( ref Mat3 m, float epsilon ) {
		if ( !cols[0].compare( m.cols[0], epsilon ) ) {
			return false;
		}
		if ( !cols[1].compare( m.cols[1], epsilon ) ) {
			return false;
		}
		if ( !cols[2].compare( m.cols[2], epsilon ) ) {
			return false;
		}
		return true;
	}

	/// _zero matrix
	void zero() {
		*this = mat3_zero;
	}

	/// _identity matrix
	void identity() {
		*this = mat3_identity;
	}

	// FIXME: can't compile
//	bool isIdentity( float epsilon = MATRIX_EPSILON ) {
//		return compare( mat3_identity, epsilon );
//	}

	bool isSymmetric( float epsilon = MATRIX_EPSILON ) {
		if ( Math.abs( cols[0].y - cols[1].x ) > epsilon ) {
			return false;
		}
		if ( Math.abs( cols[0].z - cols[2].x ) > epsilon ) {
			return false;
		}
		if ( Math.abs( cols[1].z - cols[2].y ) > epsilon ) {
			return false;
		}

		return true;
	}

	bool isDiagonal( float epsilon = MATRIX_EPSILON ) {
		if ( Math.abs( cols[0].y ) > epsilon ||
				Math.abs( cols[0].z ) > epsilon ||
				Math.abs( cols[1].x ) > epsilon ||
				Math.abs( cols[1].z ) > epsilon ||
				Math.abs( cols[2].x ) > epsilon ||
				Math.abs( cols[2].y ) > epsilon ) {
			return false;
		}
		return true;
	}

	// FIXME: can't compile
//	bool isRotated() {
//		return ( *this != mat3_identity );
//	}

	void projectVector( ref Vec3 src, ref Vec3 dst ) {
		dst.x = src * cols[0];
		dst.y = src * cols[1];
		dst.z = src * cols[2];
	}

	void unprojectVector( ref Vec3 src, ref Vec3 dst ) {
		dst = cols[0] * src.x + cols[1] * src.y + cols[2] * src.z;
	}

	float trace() {
		return ( cols[0].x + cols[1].y + cols[2].z );
	}

	float determinant() {
		float det2_12_01 = cols[1][0] * cols[2][1] - cols[1][1] * cols[2][0];
		float det2_12_02 = cols[1][0] * cols[2][2] - cols[1][2] * cols[2][0];
		float det2_12_12 = cols[1][1] * cols[2][2] - cols[1][2] * cols[2][1];

		return cols[0][0] * det2_12_12 - cols[0][1] * det2_12_02 + cols[0][2] * det2_12_01;
	}

	/// returns ortho-normal basis
	Mat3 orthoNormalize() {
		Mat3	ortho = *this;

		ortho.cols[0].normalize();
		ortho.cols[2].cross( ortho.cols[0], ortho.cols[1] );
		ortho.cols[2].normalize();
		ortho.cols[1].cross( ortho.cols[2], ortho.cols[0] );
		ortho.cols[1].normalize();

		return ortho;
	}

	void orthoNormalizeSelf() {
		cols[0].normalize();
		cols[2].cross( cols[0], cols[1] );
		cols[2].normalize();
		cols[1].cross( cols[2], cols[0] );
		cols[1].normalize();
	}

	/// returns transposed matrix
	Mat3 transpose() {
		Mat3	dst;

		dst.cols[0].x = cols[0].x; dst.cols[0].y = cols[1].x; dst.cols[0].z = cols[2].x;
		dst.cols[1].x = cols[0].y; dst.cols[1].y = cols[1].y; dst.cols[1].z = cols[2].y;
		dst.cols[2].x = cols[0].z; dst.cols[2].y = cols[1].z; dst.cols[2].z = cols[2].z;

		return dst;
	}

	/// transpose matrix in-place
	void transposeSelf() {
		Vec3	tmp;

		tmp.x = cols[0].y;
		cols[0].y = cols[1].x;
		cols[1].x = tmp.x;
		tmp.y = cols[0].z;
		cols[0].z = cols[2].x;
		tmp.z = cols[1].z;
		cols[1].z = cols[2].y;
		cols[2].y = tmp.z;
	}

	/// returns _inverse of matrix (M * inverse(M) = identity)
	Mat3 inverse() {
		Mat3	dst = *this;
		bool	r;

		r = dst.inverseSelf();
		assert( r );

		return dst;
	}

	/// invert matrix in-place, returns false if determinant is zero
	bool inverseSelf() {
		Mat3	inverse = void;
		double	det, invDet;

		inverse.cols[0].x = cols[1].y * cols[2].z - cols[1].z * cols[2].y;
		inverse.cols[1].x = cols[1].z * cols[2].x - cols[1].x * cols[2].z;
		inverse.cols[2].x = cols[1].x * cols[2].y - cols[1].y * cols[2].x;

		det = cols[0].x * inverse.cols[0].x + cols[0].y * inverse.cols[1].x + cols[0].z * inverse.cols[2].x;

		if ( Math.abs( det ) < MATRIX_INVERSE_EPSILON ) {
			return false;
		}

		invDet = 1.0f / det;

		inverse.cols[0].y = cols[0].z * cols[2].y - cols[0].y * cols[2].z;
		inverse.cols[0].z = cols[0].y * cols[1].z - cols[0].z * cols[1].y;
		inverse.cols[1].y = cols[0].x * cols[2].z - cols[0].z * cols[2].x;
		inverse.cols[1].z = cols[0].z * cols[1].x - cols[0].x * cols[1].z;
		inverse.cols[2].y = cols[0].y * cols[2].x - cols[0].x * cols[2].y;
		inverse.cols[2].z = cols[0].x * cols[1].y - cols[0].y * cols[1].x;

		cols[0].x = inverse.cols[0].x * invDet;
		cols[0].y = inverse.cols[0].y * invDet;
		cols[0].z = inverse.cols[0].z * invDet;

		cols[1].x = inverse.cols[1].x * invDet;
		cols[1].y = inverse.cols[1].y * invDet;
		cols[1].z = inverse.cols[1].z * invDet;

		cols[2].x = inverse.cols[2].x * invDet;
		cols[2].y = inverse.cols[2].y * invDet;
		cols[2].z = inverse.cols[2].z * invDet;

		return true;
	}

	/// transpose and multiply
	Mat3 transposeMultiply( ref Mat3 m ) {
		Mat3	dst;

		dst.cols[0].x = cols[0].x * m.cols[0].x + cols[1].x * m.cols[1].x + cols[2].x * m.cols[2].x;
		dst.cols[0].y = cols[0].x * m.cols[0].y + cols[1].x * m.cols[1].y + cols[2].x * m.cols[2].y;
		dst.cols[0].z = cols[0].x * m.cols[0].z + cols[1].x * m.cols[1].z + cols[2].x * m.cols[2].z;
		dst.cols[1].x = cols[0].y * m.cols[0].x + cols[1].y * m.cols[1].x + cols[2].y * m.cols[2].x;
		dst.cols[1].y = cols[0].y * m.cols[0].y + cols[1].y * m.cols[1].y + cols[2].y * m.cols[2].y;
		dst.cols[1].z = cols[0].y * m.cols[0].z + cols[1].y * m.cols[1].z + cols[2].y * m.cols[2].z;
		dst.cols[2].x = cols[0].z * m.cols[0].x + cols[1].z * m.cols[1].x + cols[2].z * m.cols[2].x;
		dst.cols[2].y = cols[0].z * m.cols[0].y + cols[1].z * m.cols[1].y + cols[2].z * m.cols[2].y;
		dst.cols[2].z = cols[0].z * m.cols[0].z + cols[1].z * m.cols[1].z + cols[2].z * m.cols[2].z;

		return dst;
	}

	/// convert to Euler angles
	Angles toAngles() {
		// cap off our sin value so that we don't get any NANs
		float	sp = Math.clamp( cols[0].z );
		double	theta = -Math.asin( sp );
		double	cp = Math.cos( theta );
		Angles	angles;

		if ( cp > 8192.0f * float.epsilon ) {
			angles.pitch	= Math.rad2deg( theta );
			angles.yaw		= Math.rad2deg( Math.atan( cols[0].y, cols[0].x ) );
			angles.roll		= Math.rad2deg( Math.atan( cols[1].z, cols[2].z ) );
		}
		else {
			angles.pitch	= Math.rad2deg( theta );
			angles.yaw		= Math.rad2deg( -Math.atan( cols[1].x, cols[1].y ) );
			angles.roll		= 0.0f;
		}
		return angles;
	}

	/// convert to quaternion
	Quat toQuat() {
		const int[3]	next = [ 1, 2, 0 ];
		float			trace = cols[0].x + cols[1].y + cols[2].z;
		Quat			q;

		if ( trace > 0.0f ) {
			float	t = trace + 1.0f;
			float	s = Math.invSqrt( t ) * 0.5f;

			q.w = s * t;
			q.x = ( cols[2].y - cols[1].z ) * s;
			q.y = ( cols[0].z - cols[2].x ) * s;
			q.z = ( cols[1].x - cols[0].y ) * s;
		}
		else {
			int		i;

			if ( cols[1].y > cols[0].x ) {
				i = 1;
			}
			if ( cols[2].z > cols[i][i] ) {
				i = 2;
			}
			int		j = next[i];
			int		k = next[j];
			float	t = ( cols[i][i] - ( cols[j][j] + cols[k][k] ) ) + 1.0f;
			float	s = Math.invSqrt( t ) * 0.5f;

			q[i] = s * t;
			q[3] = ( cols[k][j] - cols[j][k] ) * s;
			q[j] = ( cols[j][i] + cols[i][j] ) * s;
			q[k] = ( cols[k][i] + cols[i][k] ) * s;
		}
		return q; 
	}

	// NOTE: matrix is transposed, because it is column-major
	Mat4 toMat4() {
		Mat4	dst;

		dst.rows[0].x = cols[0].x;
		dst.rows[0].y = cols[1].x;
		dst.rows[0].z = cols[2].x;
		dst.rows[0].w = 0.0f;
		dst.rows[1].x = cols[0].y;
		dst.rows[1].y = cols[1].y;
		dst.rows[1].z = cols[2].y;
		dst.rows[1].w = 0.0f;
		dst.rows[2].x = cols[0].z;
		dst.rows[2].y = cols[1].z;
		dst.rows[2].z = cols[2].z;
		dst.rows[2].w = 0.0f;
		dst.rows[3].x = 0.0f;
		dst.rows[3].y = 0.0f;
		dst.rows[3].z = 0.0f;
		dst.rows[3].w = 1.0f;

		return dst;
	}

	/// returns string, just a convenience function
	char[] toUtf8() {
		return Math.toUtf8( "( X:{0} Y:{1} Z:{2} )", cols[0].toUtf8, cols[1].toUtf8, cols[2].toUtf8 );
	}

	/// returns the number of components
	size_t length() {
		return 9;
	}

	/// returns raw pointer
	float *ptr() {
		return cols[0].ptr;
	}

	Vec3	cols[3];	/// columns of matrix
}

/**
	Mat4 - a 4x4 matrix class

	Memory layout is row-major.
*/
struct Mat4 {
	static Mat4 opCall( ref Vec4 x, ref Vec4 y, ref Vec4 z, ref Vec4 w ) {
		Mat4	dst;

		dst.rows[0] = x;
		dst.rows[1] = y;
		dst.rows[2] = z;
		dst.rows[3] = w;

		return dst;
	}

	static Mat4 opCall( float xx, float xy, float xz, float xw,
					float yx, float yy, float yz, float yw,
					float zx, float zy, float zz, float zw,
					float wx, float wy, float wz, float ww ) {
		Mat4	dst;

		dst.rows[0].set( xx, xy, xz, xw );
		dst.rows[1].set( yx, yy, yz, yw );
		dst.rows[2].set( zx, zy, zz, zw );
		dst.rows[3].set( wx, wy, wz, ww );

		return dst;
	}

	// NOTE: rotation matrix is transposed because it is column-major
	static Mat4 opCall( ref Mat3 rotation, ref Vec3 translation ) {
		Mat4	dst;

		dst.rows[0].x = rotation.cols[0].x;
		dst.rows[0].y = rotation.cols[1].x;
		dst.rows[0].z = rotation.cols[2].x;
		dst.rows[0].w = translation.x;
		dst.rows[1].x = rotation.cols[0].y;
		dst.rows[1].y = rotation.cols[1].y;
		dst.rows[1].z = rotation.cols[2].y;
		dst.rows[1].w = translation.y;
		dst.rows[2].x = rotation.cols[0].z;
		dst.rows[2].y = rotation.cols[1].z;
		dst.rows[2].z = rotation.cols[2].z;
		dst.rows[2].w = translation.z;
		dst.rows[3].x = 0.0f;
		dst.rows[3].y = 0.0f;
		dst.rows[3].z = 0.0f;
		dst.rows[3].w = 1.0f;

		return dst;
	}

	static Mat4 opCall( float[4][4] src ) {
		Mat4	dst;

		dst.rows[0].x = src[0][0];
		dst.rows[0].y = src[0][1];
		dst.rows[0].z = src[0][2];
		dst.rows[0].w = src[0][3];
		dst.rows[1].x = src[1][0];
		dst.rows[1].y = src[1][1];
		dst.rows[1].z = src[1][2];
		dst.rows[1].w = src[1][3];
		dst.rows[2].x = src[2][0];
		dst.rows[2].y = src[2][1];
		dst.rows[2].z = src[2][2];
		dst.rows[2].w = src[2][3];
		dst.rows[3].x = src[3][0];
		dst.rows[3].y = src[3][1];
		dst.rows[3].z = src[3][2];
		dst.rows[3].w = src[3][3];

		return dst;
	}

	Vec4 opIndex( size_t index ) {
		return rows[index];
	}

	Vec4 opIndexAssign( ref Vec4 row, size_t index ) {
		return rows[index] = row;
	}

	Mat4 opAdd( ref Mat4 m ) {
		Mat4	dst;

		dst.rows[0].x = rows[0].x + m.rows[0].x;
		dst.rows[0].y = rows[0].y + m.rows[0].y;
		dst.rows[0].z = rows[0].z + m.rows[0].z;
		dst.rows[0].w = rows[0].w + m.rows[0].w;
		dst.rows[1].x = rows[1].x + m.rows[1].x;
		dst.rows[1].y = rows[1].y + m.rows[1].y;
		dst.rows[1].z = rows[1].z + m.rows[1].z;
		dst.rows[1].w = rows[1].w + m.rows[1].w;
		dst.rows[2].x = rows[2].x + m.rows[2].x;
		dst.rows[2].y = rows[2].y + m.rows[2].y;
		dst.rows[2].z = rows[2].z + m.rows[2].z;
		dst.rows[2].w = rows[2].w + m.rows[2].w;
		dst.rows[3].x = rows[3].x + m.rows[3].x;
		dst.rows[3].y = rows[3].y + m.rows[3].y;
		dst.rows[3].z = rows[3].z + m.rows[3].z;
		dst.rows[3].w = rows[3].w + m.rows[3].w;

		return dst;
	}

	Mat4 opSub( ref Mat4 m ) {
		Mat4	dst;

		dst.rows[0].x = rows[0].x - m.rows[0].x;
		dst.rows[0].y = rows[0].y - m.rows[0].y;
		dst.rows[0].z = rows[0].z - m.rows[0].z;
		dst.rows[0].w = rows[0].w - m.rows[0].w;
		dst.rows[1].x = rows[1].x - m.rows[1].x;
		dst.rows[1].y = rows[1].y - m.rows[1].y;
		dst.rows[1].z = rows[1].z - m.rows[1].z;
		dst.rows[1].w = rows[1].w - m.rows[1].w;
		dst.rows[2].x = rows[2].x - m.rows[2].x;
		dst.rows[2].y = rows[2].y - m.rows[2].y;
		dst.rows[2].z = rows[2].z - m.rows[2].z;
		dst.rows[2].w = rows[2].w - m.rows[2].w;
		dst.rows[3].x = rows[3].x - m.rows[3].x;
		dst.rows[3].y = rows[3].y - m.rows[3].y;
		dst.rows[3].z = rows[3].z - m.rows[3].z;
		dst.rows[3].w = rows[3].w - m.rows[3].w;

		return dst;
	}

	Mat4 opMul( float f )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( f ) );
		}
	}
	body {
		Mat4	dst;

		dst.rows[0].x = rows[0].x * f;
		dst.rows[0].y = rows[0].y * f;
		dst.rows[0].z = rows[0].z * f;
		dst.rows[0].w = rows[0].w * f;
		dst.rows[1].x = rows[1].x * f;
		dst.rows[1].y = rows[1].y * f;
		dst.rows[1].z = rows[1].z * f;
		dst.rows[1].w = rows[1].w * f;
		dst.rows[2].x = rows[2].x * f;
		dst.rows[2].y = rows[2].y * f;
		dst.rows[2].z = rows[2].z * f;
		dst.rows[2].w = rows[2].w * f;
		dst.rows[3].x = rows[3].x * f;
		dst.rows[3].y = rows[3].y * f;
		dst.rows[3].z = rows[3].z * f;
		dst.rows[3].w = rows[3].w * f;

		return dst;
	}

	Vec4 opMul( ref Vec4 v ) {
		Vec4	dst;

		dst.x = v.x * rows[0].x + v.y * rows[0].y + v.z * rows[0].z + v.w * rows[0].w;
		dst.y = v.x * rows[1].x + v.y * rows[1].y + v.z * rows[1].z + v.w * rows[1].w;
		dst.z = v.x * rows[2].x + v.y * rows[2].y + v.z * rows[2].z + v.w * rows[2].w;
		dst.w = v.x * rows[3].x + v.y * rows[3].y + v.z * rows[3].z + v.w * rows[3].w;

		return dst;
	}

	Mat4 opMul( ref Mat4 m ) {
		Mat4	dst;

		dst.rows[0].x = rows[0].x * m.rows[0].x + rows[0].y * m.rows[1].x + rows[0].z * m.rows[2].x + rows[0].w * m.rows[3].x;
		dst.rows[0].y = rows[0].x * m.rows[0].y + rows[0].y * m.rows[1].y + rows[0].z * m.rows[2].y + rows[0].w * m.rows[3].y;
		dst.rows[0].z = rows[0].x * m.rows[0].z + rows[0].y * m.rows[1].z + rows[0].z * m.rows[2].z + rows[0].w * m.rows[3].z;
		dst.rows[0].w = rows[0].x * m.rows[0].w + rows[0].y * m.rows[1].w + rows[0].z * m.rows[2].w + rows[0].w * m.rows[3].w;
		dst.rows[1].x = rows[1].x * m.rows[0].x + rows[1].y * m.rows[1].x + rows[1].z * m.rows[2].x + rows[1].w * m.rows[3].x;
		dst.rows[1].y = rows[1].x * m.rows[0].y + rows[1].y * m.rows[1].y + rows[1].z * m.rows[2].y + rows[1].w * m.rows[3].y;
		dst.rows[1].z = rows[1].x * m.rows[0].z + rows[1].y * m.rows[1].z + rows[1].z * m.rows[2].z + rows[1].w * m.rows[3].z;
		dst.rows[1].w = rows[1].x * m.rows[0].w + rows[1].y * m.rows[1].w + rows[1].z * m.rows[2].w + rows[1].w * m.rows[3].w;
		dst.rows[2].x = rows[2].x * m.rows[0].x + rows[2].y * m.rows[1].x + rows[2].z * m.rows[2].x + rows[2].w * m.rows[3].x;
		dst.rows[2].y = rows[2].x * m.rows[0].y + rows[2].y * m.rows[1].y + rows[2].z * m.rows[2].y + rows[2].w * m.rows[3].y;
		dst.rows[2].z = rows[2].x * m.rows[0].z + rows[2].y * m.rows[1].z + rows[2].z * m.rows[2].z + rows[2].w * m.rows[3].z;
		dst.rows[2].w = rows[2].x * m.rows[0].w + rows[2].y * m.rows[1].w + rows[2].z * m.rows[2].w + rows[2].w * m.rows[3].w;
		dst.rows[3].x = rows[3].x * m.rows[0].x + rows[3].y * m.rows[1].x + rows[3].z * m.rows[2].x + rows[3].w * m.rows[3].x;
		dst.rows[3].y = rows[3].x * m.rows[0].y + rows[3].y * m.rows[1].y + rows[3].z * m.rows[2].y + rows[3].w * m.rows[3].y;
		dst.rows[3].z = rows[3].x * m.rows[0].z + rows[3].y * m.rows[1].z + rows[3].z * m.rows[2].z + rows[3].w * m.rows[3].z;
		dst.rows[3].w = rows[3].x * m.rows[0].w + rows[3].y * m.rows[1].w + rows[3].z * m.rows[2].w + rows[3].w * m.rows[3].w;

		return dst;
	}

	void opAddAssign( ref Mat4 m ) {
		rows[0].x += m.rows[0].x;
		rows[0].y += m.rows[0].y;
		rows[0].z += m.rows[0].z;
		rows[0].w += m.rows[0].w;
		rows[1].x += m.rows[1].x;
		rows[1].y += m.rows[1].y;
		rows[1].z += m.rows[1].z;
		rows[1].w += m.rows[1].w;
		rows[2].x += m.rows[2].x;
		rows[2].y += m.rows[2].y;
		rows[2].z += m.rows[2].z;
		rows[2].w += m.rows[2].w;
		rows[3].x += m.rows[3].x;
		rows[3].y += m.rows[3].y;
		rows[3].z += m.rows[3].z;
		rows[3].w += m.rows[3].w;
	}

	void opSubAssign( ref Mat4 m ) {
		rows[0].x -= m.rows[0].x;
		rows[0].y -= m.rows[0].y;
		rows[0].z -= m.rows[0].z;
		rows[0].w -= m.rows[0].w;
		rows[1].x -= m.rows[1].x;
		rows[1].y -= m.rows[1].y;
		rows[1].z -= m.rows[1].z;
		rows[1].w -= m.rows[1].w;
		rows[2].x -= m.rows[2].x;
		rows[2].y -= m.rows[2].y;
		rows[2].z -= m.rows[2].z;
		rows[2].w -= m.rows[2].w;
		rows[3].x -= m.rows[3].x;
		rows[3].y -= m.rows[3].y;
		rows[3].z -= m.rows[3].z;
		rows[3].w -= m.rows[3].w;
	}

	void opMulAssign( float f )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( f ) );
		}
	}
	body {
		rows[0].x *= f;
		rows[0].y *= f;
		rows[0].z *= f;
		rows[0].w *= f;
		rows[1].x *= f;
		rows[1].y *= f;
		rows[1].z *= f;
		rows[1].w *= f;
		rows[2].x *= f;
		rows[2].y *= f;
		rows[2].z *= f;
		rows[2].w *= f;
		rows[3].x *= f;
		rows[3].y *= f;
		rows[3].z *= f;
		rows[3].w *= f;
	}

	void opMulAssign( ref Mat4 m ) {
		*this = ( *this ) * m;
	}

	/// exact compare
	bool opEquals( ref Mat4 m ) {
		return ( rows[0] == m.rows[0] && rows[1] == m.rows[1] && rows[2] == m.rows[2] && rows[3] == m.rows[3] );
	}

	/// _compare with epsilon
	bool compare( ref Mat4 m, float epsilon ) {
		if ( !rows[0].compare( m.rows[0], epsilon ) ) {
			return false;
		}
		if ( !rows[1].compare( m.rows[1], epsilon ) ) {
			return false;
		}
		if ( !rows[2].compare( m.rows[2], epsilon ) ) {
			return false;
		}
		if ( !rows[3].compare( m.rows[3], epsilon ) ) {
			return false;
		}

		return true;
	}

	/// _zero matrix
	void zero() {
		*this = mat4_zero;
	}

	/// _identity matrix
	void identity() {
		*this = mat4_identity;
	}

	// FIXME: can't compile
//	bool isIdentity( float epsilon = MATRIX_EPSILON ) {
//		return compare( mat4_identity, epsilon );
//	}

	bool isSymmetric( float epsilon = MATRIX_EPSILON ) {
		for ( int i = 1; i < 4; i++ ) {
			for ( int j = 0; j < i; j++ ) {
				if ( Math.abs( rows[i][j] - rows[j][i] ) > epsilon ) {
					return false;
				}
			}
		}

		return true;
	}

	bool isDiagonal( float epsilon = MATRIX_EPSILON ) {
		for ( int i = 0; i < 4; i++ ) {
			for ( int j = 0; j < 4; j++ ) {
				if ( i != j && Math.abs( rows[i][j] ) > epsilon ) {
					return false;
				}
			}
		}

		return true;
	}

	bool isRotated() {
		if ( !rows[0].y && !rows[0].z && !rows[1].x && !rows[1].z && !rows[2].x && !rows[2].y ) {
			return false;
		}

		return true;
	}

	void projectVector( ref Vec4 src, ref Vec4 dst ) {
		dst.x = src * rows[0];
		dst.y = src * rows[1];
		dst.z = src * rows[2];
		dst.w = src * rows[3];
	}

	void unprojectVector( ref Vec4 src, ref Vec4 dst ) {
		dst = src.x * rows[0] + src.y * rows[1] + src.z * rows[2] + src.w * rows[3];
	}

	float trace() {
		return ( rows[0].x + rows[1].y + rows[2].z + rows[3].w );
	}

	float determinant() {
		// 2x2 sub-determinants
		float det2_01_01 = rows[0][0] * rows[1][1] - rows[0][1] * rows[1][0];
		float det2_01_02 = rows[0][0] * rows[1][2] - rows[0][2] * rows[1][0];
		float det2_01_03 = rows[0][0] * rows[1][3] - rows[0][3] * rows[1][0];
		float det2_01_12 = rows[0][1] * rows[1][2] - rows[0][2] * rows[1][1];
		float det2_01_13 = rows[0][1] * rows[1][3] - rows[0][3] * rows[1][1];
		float det2_01_23 = rows[0][2] * rows[1][3] - rows[0][3] * rows[1][2];

		// 3x3 sub-determinants
		float det3_201_012 = rows[2][0] * det2_01_12 - rows[2][1] * det2_01_02 + rows[2][2] * det2_01_01;
		float det3_201_013 = rows[2][0] * det2_01_13 - rows[2][1] * det2_01_03 + rows[2][3] * det2_01_01;
		float det3_201_023 = rows[2][0] * det2_01_23 - rows[2][2] * det2_01_03 + rows[2][3] * det2_01_02;
		float det3_201_123 = rows[2][1] * det2_01_23 - rows[2][2] * det2_01_13 + rows[2][3] * det2_01_12;

		return ( - det3_201_123 * rows[3][0] + det3_201_023 * rows[3][1] - det3_201_013 * rows[3][2] + det3_201_012 * rows[3][3] );
	}

	/// returns transposed matrix
	Mat4 transpose() {
		Mat4	dst;

		dst.rows[0].x = rows[0].x; dst.rows[0].y = rows[1].x; dst.rows[0].z = rows[2].x; dst.rows[0].w = rows[3].x;
		dst.rows[1].x = rows[0].y; dst.rows[1].y = rows[1].y; dst.rows[1].z = rows[2].y; dst.rows[1].w = rows[3].y;
		dst.rows[2].x = rows[0].z; dst.rows[2].y = rows[1].z; dst.rows[2].z = rows[2].z; dst.rows[2].w = rows[3].z;
		dst.rows[3].x = rows[0].w; dst.rows[3].y = rows[1].w; dst.rows[3].z = rows[2].w; dst.rows[3].w = rows[3].w;

		return dst;
	}

	/// transposes the matrix in place
	void transposeSelf() {
		float	temp;
		int		i, j;

		for ( i = 0; i < 4; i++ ) {
			for ( j = i + 1; j < 4; j++ ) {
				temp = rows[i][j];
				rows[i][j] = rows[j][i];
				rows[j][i] = temp;
			}
		}
	}

	/// returns the inverse of the matrix
	Mat4 inverse() {
		Mat4	invMat = *this;
		bool	r;

		r = invMat.inverseSelf();
		assert( r );

		return invMat;
	}

	/// invert matrix in-place, returns false if determinant is zero
	bool inverseSelf() {
		double	det, invDet;

		// 2x2 sub-determinants required to calculate 4x4 determinant
		float det2_01_01 = rows[0][0] * rows[1][1] - rows[0][1] * rows[1][0];
		float det2_01_02 = rows[0][0] * rows[1][2] - rows[0][2] * rows[1][0];
		float det2_01_03 = rows[0][0] * rows[1][3] - rows[0][3] * rows[1][0];
		float det2_01_12 = rows[0][1] * rows[1][2] - rows[0][2] * rows[1][1];
		float det2_01_13 = rows[0][1] * rows[1][3] - rows[0][3] * rows[1][1];
		float det2_01_23 = rows[0][2] * rows[1][3] - rows[0][3] * rows[1][2];

		// 3x3 sub-determinants required to calculate 4x4 determinant
		float det3_201_012 = rows[2][0] * det2_01_12 - rows[2][1] * det2_01_02 + rows[2][2] * det2_01_01;
		float det3_201_013 = rows[2][0] * det2_01_13 - rows[2][1] * det2_01_03 + rows[2][3] * det2_01_01;
		float det3_201_023 = rows[2][0] * det2_01_23 - rows[2][2] * det2_01_03 + rows[2][3] * det2_01_02;
		float det3_201_123 = rows[2][1] * det2_01_23 - rows[2][2] * det2_01_13 + rows[2][3] * det2_01_12;

		det = ( - det3_201_123 * rows[3][0] + det3_201_023 * rows[3][1] - det3_201_013 * rows[3][2] + det3_201_012 * rows[3][3] );

		if ( Math.abs( det ) < MATRIX_INVERSE_EPSILON ) {
			return false;
		}

		invDet = 1.0f / det;

		// remaining 2x2 sub-determinants
		float det2_03_01 = rows[0][0] * rows[3][1] - rows[0][1] * rows[3][0];
		float det2_03_02 = rows[0][0] * rows[3][2] - rows[0][2] * rows[3][0];
		float det2_03_03 = rows[0][0] * rows[3][3] - rows[0][3] * rows[3][0];
		float det2_03_12 = rows[0][1] * rows[3][2] - rows[0][2] * rows[3][1];
		float det2_03_13 = rows[0][1] * rows[3][3] - rows[0][3] * rows[3][1];
		float det2_03_23 = rows[0][2] * rows[3][3] - rows[0][3] * rows[3][2];

		float det2_13_01 = rows[1][0] * rows[3][1] - rows[1][1] * rows[3][0];
		float det2_13_02 = rows[1][0] * rows[3][2] - rows[1][2] * rows[3][0];
		float det2_13_03 = rows[1][0] * rows[3][3] - rows[1][3] * rows[3][0];
		float det2_13_12 = rows[1][1] * rows[3][2] - rows[1][2] * rows[3][1];
		float det2_13_13 = rows[1][1] * rows[3][3] - rows[1][3] * rows[3][1];
		float det2_13_23 = rows[1][2] * rows[3][3] - rows[1][3] * rows[3][2];

		// remaining 3x3 sub-determinants
		float det3_203_012 = rows[2][0] * det2_03_12 - rows[2][1] * det2_03_02 + rows[2][2] * det2_03_01;
		float det3_203_013 = rows[2][0] * det2_03_13 - rows[2][1] * det2_03_03 + rows[2][3] * det2_03_01;
		float det3_203_023 = rows[2][0] * det2_03_23 - rows[2][2] * det2_03_03 + rows[2][3] * det2_03_02;
		float det3_203_123 = rows[2][1] * det2_03_23 - rows[2][2] * det2_03_13 + rows[2][3] * det2_03_12;

		float det3_213_012 = rows[2][0] * det2_13_12 - rows[2][1] * det2_13_02 + rows[2][2] * det2_13_01;
		float det3_213_013 = rows[2][0] * det2_13_13 - rows[2][1] * det2_13_03 + rows[2][3] * det2_13_01;
		float det3_213_023 = rows[2][0] * det2_13_23 - rows[2][2] * det2_13_03 + rows[2][3] * det2_13_02;
		float det3_213_123 = rows[2][1] * det2_13_23 - rows[2][2] * det2_13_13 + rows[2][3] * det2_13_12;

		float det3_301_012 = rows[3][0] * det2_01_12 - rows[3][1] * det2_01_02 + rows[3][2] * det2_01_01;
		float det3_301_013 = rows[3][0] * det2_01_13 - rows[3][1] * det2_01_03 + rows[3][3] * det2_01_01;
		float det3_301_023 = rows[3][0] * det2_01_23 - rows[3][2] * det2_01_03 + rows[3][3] * det2_01_02;
		float det3_301_123 = rows[3][1] * det2_01_23 - rows[3][2] * det2_01_13 + rows[3][3] * det2_01_12;

		rows[0][0] = - det3_213_123 * invDet;
		rows[1][0] = + det3_213_023 * invDet;
		rows[2][0] = - det3_213_013 * invDet;
		rows[3][0] = + det3_213_012 * invDet;

		rows[0][1] = + det3_203_123 * invDet;
		rows[1][1] = - det3_203_023 * invDet;
		rows[2][1] = + det3_203_013 * invDet;
		rows[3][1] = - det3_203_012 * invDet;

		rows[0][2] = + det3_301_123 * invDet;
		rows[1][2] = - det3_301_023 * invDet;
		rows[2][2] = + det3_301_013 * invDet;
		rows[3][2] = - det3_301_012 * invDet;

		rows[0][3] = - det3_201_123 * invDet;
		rows[1][3] = + det3_201_023 * invDet;
		rows[2][3] = - det3_201_013 * invDet;
		rows[3][3] = + det3_201_012 * invDet;

		return true;
	}

	/// transpose and multiply
	Mat4 transposeMultiply( ref Mat4 m ) {
		Mat4	dst;

		dst.rows[0].x = rows[0].x * m.rows[0].x + rows[0].y * m.rows[0].y + rows[0].z * m.rows[0].z + rows[0].w * m.rows[0].w;
		dst.rows[1].x = rows[1].x * m.rows[1].x + rows[1].y * m.rows[1].y + rows[1].z * m.rows[1].z + rows[1].w * m.rows[1].w;
		dst.rows[2].x = rows[2].x * m.rows[2].x + rows[2].y * m.rows[2].y + rows[2].z * m.rows[2].z + rows[2].w * m.rows[2].w;
		dst.rows[3].x = rows[3].x * m.rows[3].x + rows[3].y * m.rows[3].y + rows[3].z * m.rows[3].z + rows[3].w * m.rows[3].w;

		return dst;
	}

	/// returns string, just a convenience function
	char[] toUtf8() {
		return Math.toUtf8( "( X:{0} Y:{1} Z:{2} W:{3} )", rows[0].toUtf8, rows[1].toUtf8, rows[2].toUtf8, rows[3].toUtf8 );
	}

	/// returns the number of components
	size_t length() {
		return 16;
	}

	/// returns raw pointer
	float *ptr() {
		return rows[0].ptr;
	}

	Vec4[4]		rows;	/// rows of matrix
}

version (build) {
    debug {
        pragma(link, "ray");
    } else {
        pragma(link, "ray");
    }
}
