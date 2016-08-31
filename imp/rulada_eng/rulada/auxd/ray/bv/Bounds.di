/**
	Copyright: Copyright (c) 2007, Artyom Shalkhakov. All rights reserved.
	License: BSD

	Version: Aug 2007: initial release
	Authors: Artyom Shalkhakov
*/
module auxd.ray.bv.Bounds;

import auxd.ray.base.Math;
import auxd.ray.base.Vector;
import auxd.ray.base.Plane;
import auxd.ray.base.Ray;

import auxd.ray.bv.Frustum;
import auxd.ray.bv.Sphere;

/**
	Bounds represent axis-aligned bounding box.
*/
struct Bounds {
	static Bounds opCall( ref Vec3 mins, ref Vec3 maxs ) {
		Bounds	dst;

		dst.mins = mins;
		dst.maxs = maxs;

		return dst;
	}

	static Bounds opCall( ref Vec3 point ) {
		Bounds	dst;

		dst.mins = point;
		dst.maxs = point;

		return dst;
	}

	Vec3 opIndex( size_t index )
	in {
		assert( index >= 0 && index < 2 );
	}
	body {
		return ( &mins )[index];
	}

	Vec3 opIndexAssign( ref Vec3 v, size_t index )
	in {
		assert( index >= 0 && index < 2 );
	}
	body {
		return ( &mins )[index] = v;
	}

	/// returns translated bounds
	Bounds opAdd( ref Vec3 t ) {
		return Bounds( mins + t, maxs + t );
	}

	/// returns union of two bounds
	Bounds opAdd( ref Bounds b ) {
		return Bounds( mins + b.mins, maxs + b.maxs );
	}

	/// returns intersection of two bounds
	Bounds opSub( ref Bounds b )
	in {
		assert( maxs.x - mins.x > b.maxs.x - b.mins.x );
		assert( maxs.y - mins.y > b.maxs.y - b.mins.y );
		assert( maxs.z - mins.z > b.maxs.z - b.maxs.z );
	}
	body {
		return Bounds( mins + b.maxs, maxs + b.mins );
	}

	Bounds opMul( ref Mat3 r ) {
		Bounds	dst;

		// FIXME: this Vec3 should be replaced by vec3_zero
		dst.fromTransformedBounds( *this, Vec3( 0.0f, 0.0f, 0.0f ), r );

		return dst;
	}

	/// translates bounds
	void opAddAssign( ref Vec3 t ) {
		mins += t;
		maxs += t;
	}

	/// union of two bounds
	void opAddAssign( ref Bounds b ) {
		mins += b.mins;
		maxs += b.maxs;
	}

	/// intersection of two bounds
	void opSubAssign( ref Bounds b )
	in {
		assert( maxs.x - mins.x > b.maxs.x - b.mins.x );
		assert( maxs.y - mins.y > b.maxs.y - b.mins.y );
		assert( maxs.z - mins.z > b.maxs.z - b.maxs.z );
	}
	body {
		mins += b.maxs;
		maxs += b.mins;
	}

	void opMulAssign( ref Mat3 r ) {
		// FIXME: this Vec3 should be replaced by vec3_zero
		fromTransformedBounds( *this, Vec3( 0.0f, 0.0f, 0.0f ), r );
	}

	/// exact compare
	bool opEquals( ref Bounds b ) {
		return ( mins == b.mins && maxs == b.maxs );
	}

	/// _compare with epsilon
	bool compare( ref Bounds b, float epsilon ) {
		if ( !mins.compare( b.mins, epsilon ) ) {
			return false;
		}
		if ( !maxs.compare( b.maxs, epsilon ) ) {
			return false;
		}

		return true;
	}

	/// inside-out bounds
	void clear() {
		mins.x = float.max;
		mins.y = float.max;
		mins.z = float.max;
		maxs.x = -float.max;
		maxs.y = -float.max;
		maxs.z = -float.max;
	}

	/// returns true if bounds are inside-out
	bool isCleared() {
		return ( maxs.x < mins.x );
	}

	/// _zero bounds
	void zero() {
		mins.zero();
		maxs.zero();
	}

	/**
		Add point to bounds.
		Returns true if bounds expanded.
	*/
	bool addPoint( ref Vec3 p ) {
		bool	expanded;

		if ( p.x < mins.x ) {
			mins.x = p.x;
			expanded = true;
		}
		if ( p.y < mins.y ) {
			mins.y = p.y;
			expanded = true;
		}
		if ( p.z < mins.z ) {
			mins.z = p.z;
			expanded = true;
		}
		if ( p.x > maxs.x ) {
			maxs.x = p.x;
			expanded = true;
		}
		if ( p.y > maxs.y ) {
			maxs.y = p.y;
			expanded = true;
		}
		if ( p.z > maxs.z ) {
			maxs.z = p.z;
			expanded = true;
		}

		return expanded;
	}

	/**
		Add bounds to bounds.
		Returns true if bounds expanded.
	*/
	bool addBounds( ref Bounds b ) {
		bool	expanded;

		if ( b.mins.x < mins.x ) {
			mins.x = b.mins.x;
			expanded = true;
		}
		if ( b.mins.y < mins.y ) {
			mins.y = b.mins.y;
			expanded = true;
		}
		if ( b.mins.z < mins.z ) {
			mins.z = b.mins.z;
			expanded = true;
		}
		if ( b.maxs.x > maxs.x ) {
			maxs.x = b.maxs.x;
			expanded = true;
		}
		if ( b.maxs.y > maxs.y ) {
			maxs.y = b.maxs.y;
			expanded = true;
		}
		if ( b.maxs.z > maxs.z ) {
			maxs.z = b.maxs.z;
			expanded = true;
		}

		return expanded;
	}

	/// returns intersection of two bounds
	Bounds intersect( ref Bounds b ) {
		Bounds	dst;

		dst.mins.x = ( b.mins.x > mins.x ) ? b.mins.x : mins.x;
		dst.mins.y = ( b.mins.y > mins.y ) ? b.mins.y : mins.y;
		dst.mins.z = ( b.mins.z > mins.z ) ? b.mins.z : mins.z;
		dst.mins.x = ( b.maxs.x < maxs.x ) ? b.maxs.x : maxs.x;
		dst.mins.y = ( b.maxs.y < maxs.y ) ? b.maxs.y : maxs.y;
		dst.mins.z = ( b.maxs.z < maxs.z ) ? b.mins.z : maxs.z;

		return dst;
	}

	/// intersects bounds with given bounds
	void intersectSelf( ref Bounds b ) {
		if ( b.mins.x > mins.x ) {
			mins.x = b.mins.x;
		}
		if ( b.mins.y > mins.y ) {
			mins.y = b.mins.y;
		}
		if ( b.mins.z > mins.z ) {
			mins.z = b.mins.z;
		}
		if ( b.maxs.x < maxs.x ) {
			maxs.x = b.maxs.x;
		}
		if ( b.maxs.y < maxs.y ) {
			maxs.y = b.maxs.y;
		}
		if ( b.maxs.z < maxs.z ) {
			maxs.z = b.maxs.z;
		}
	}

	/// returns bounds expanded by the given value
	Bounds expand( float d ) {
		Bounds	dst = *this;

		dst.mins.x -= d;
		dst.mins.y -= d;
		dst.mins.z -= d;
		dst.maxs.x += d;
		dst.maxs.y += d;
		dst.maxs.z += d;

		return dst;
	}

	/// expands bounds by the given value
	void expandSelf( float d ) {
		mins.x -= d;
		mins.y -= d;
		mins.z -= d;
		maxs.x += d;
		maxs.y += d;
		maxs.z += d;
	}

	/// returns translated bounds
	Bounds translate( ref Vec3 t ) {
		return Bounds( mins + t, maxs + t );
	}

	/// translates bounds
	void translateSelf( ref Vec3 t ) {
		mins += t;
		maxs += t;
	}

	/// returns rotated bounds
	Bounds rotate( ref Mat3 r ) {
		Bounds	dst;

		// FIXME: this Vec3 should be replaced by vec3_zero
		dst.fromTransformedBounds( *this, Vec3( 0.0f, 0.0f, 0.0f ), r );

		return dst;
	}

	/// rotates bounds
	void rotateSelf( ref Mat3 r ) {
		// FIXME: this Vec3 should be replaced by vec3_zero
		fromTransformedBounds( *this, Vec3( 0.0f, 0.0f, 0.0f ), r );
	}

	/// returns distance to plane
	float planeDistance( ref Plane p ) {
		Vec3	center = ( mins + maxs ) * 0.5f;
		float	d1 = p.distance( center );
		float	d2 = Math.abs( maxs.x - center.x ) * p.normal.x
					+ Math.abs( maxs.y - center.y ) * p.normal.y
					+ Math.abs( maxs.z - center.z ) * p.normal.z;

		if ( d1 - d2 > 0.0f ) {
			return d1 - d2;
		}
		if ( d1 + d2 < 0.0f ) {
			return d1 + d2;
		}

		return 0.0f;
	}

	/// classifies bounds against plane
	int planeSide( ref Plane p, float epsilon ) {
		Vec3	center = ( mins + maxs ) * 0.5f;
		float	d1 = p.distance( center );
		float	d2 = Math.abs( maxs.x - center.x ) * p.normal.x
					+ Math.abs( maxs.y - center.y ) * p.normal.y
					+ Math.abs( maxs.z - center.z ) * p.normal.z;

		if ( d1 - d2 > epsilon ) {
			return PLANESIDE.FRONT;
		}
		if ( d1 + d2 < epsilon ) {
			return PLANESIDE.BACK;
		}

		return PLANESIDE.CROSS;
	}

	/// returns _radius of bounds
	float radius() {
		float	total = 0.0f;
		float	b0, b1;
		int		i;

		for ( i = 0; i < 3; i++ ) {
			b0 = Math.abs( mins[i] );
			b1 = Math.abs( maxs[i] );

			total += b0 > b1 ? b0 * b0 : b1 * b1;
		}

		return Math.sqrt( total );
	}

	/// returns _radius of bounds relative to specified center
	float radius( ref Vec3 c ) {
		float	total = 0.0f;
		float	b0, b1;
		int		i;

		for ( i = 0; i < 3; i++ ) {
			b0 = Math.abs( c[i] - mins[i] );
			b1 = Math.abs( maxs[i] - c[i] );

			total += b0 > b1 ? b0 * b0 : b1 * b1;
		}

		return Math.sqrt( total );
	}

	/// returns _center of bounds
	Vec3 center() {
		return ( ( maxs + mins ) * 0.5f );
	}

	/// returns maximum _extents of bounds
	Vec3 extents() {
		Vec3	center = ( maxs + mins ) * 0.5f;

		return ( maxs - center );
	}

	/// returns _extents of bounds relative to _center
	Vec3 extents( ref Vec3 center ) {
		return ( maxs - center );
	}

	/**
		Returns true if bounds contain the given point,
		including touching.
	*/
	bool containsPoint( ref Vec3 p ) {
		if ( p.x < mins.x || p.y < mins.y || p.z < mins.z
			|| p.x > maxs.x || p.y > maxs.y || p.z > maxs.z ) {
			return false;
		}
		return true;
	}

	/**
		Returns true if bounds contain the given point,
		including touching.
	*/
	bool intersectsBounds( ref Bounds b ) {
		if ( b.mins.x < mins.x || b.mins.y < mins.y || b.mins.z < mins.z
			|| b.maxs.x > maxs.x || b.maxs.y > maxs.y || b.maxs.z > maxs.z ) {
			return false;
		}
		return true;
	}

	/// returns true if ray intersects bounds
	bool rayIntersection( ref Vec3 start, ref Vec3 dir, ref float scale ) {
		int		ax0 = -1, side, inside;
		Vec3	hit = void;

		for ( size_t i = 0; i < 3; i++ ) {
			if ( start[i] < mins[i] ) {
				side = 0;
			}
			else if ( start[i] > maxs[i] ) {
				side = 1;
			}
			else {
				inside++;
				continue;
			}
			if ( dir[i] == 0.0f ) {
				continue;
			}
			float	f = ( start[i] - ( &mins )[side][i] );
			if ( ax0 < 0 || Math.abs( f ) > Math.abs( scale * dir[i] ) ) {
				scale = -( f / dir[i] );
				ax0 = i;
			}
		}

		if ( ax0 < 0 ) {
			scale = 0.0f;
			// return true if the start point is inside the bounds
			return ( inside == 3 );
		}

		int		ax1 = ( ax0 + 1 ) % 3;
		int		ax2 = ( ax0 + 2 ) % 3;

		hit[ax1] = start[ax1] + scale * dir[ax1];
		hit[ax2] = start[ax2] + scale * dir[ax2];

		return ( hit[ax1] >= mins[ax1] && hit[ax1] <= maxs[ax1] &&
					hit[ax2] >= mins[ax2] && hit[ax2] <= maxs[ax2] );
	}

	/**
		Ray-box intersection using IEEE numerical properties to ensure that the
		test is both robust and efficient, as described in:

		Amy Williams, Steve Barrus, R. Keith Morley, and Peter Shirley
		"An Efficient and Robust Ray-Box Intersection Algorithm"
		Journal of graphics tools, 10(1):49-54, 2005

		(t0, t1) is the interval for valid hits.
	*/
	bool rayIntersection( ref Ray ray, float t0 = 0.0f, float t1 = float.infinity ) {
		float	tmin = ( ( *this )[ray.signbits & 1].x - ray.origin.x ) * ray.invDir.x;
		float	tmax = ( ( *this )[~ray.signbits & 1].x - ray.origin.x ) * ray.invDir.x;
		float	tymin = ( ( *this )[( ray.signbits >> 1 ) & 1].y - ray.origin.y ) * ray.invDir.y;
		float	tymax = ( ( *this )[~( ( ray.signbits >> 1 ) & 1 )].y - ray.origin.y ) * ray.invDir.y;

		if ( ( tmin > tymax ) || ( tymin > tmax ) ) {
			return false;
		}
		if ( tymin > tmin ) {
			tmin = tymin;
		}
		if ( tymax < tmax ) {
			tmax = tymax;
		}

		float	tzmin = ( ( *this )[( ray.signbits >> 2 ) & 1].z - ray.origin.z ) * ray.invDir.z;
		float	tzmax = ( ( *this )[~( ( ray.signbits >> 2 ) & 1 )].z - ray.origin.z ) * ray.invDir.z;

		if ( ( tmin > tzmax ) || ( tzmin > tmax ) ) {
			return false;
		}
		if ( tzmin > tmin ) {
			tmin = tzmin;
		}
		if ( tzmax < tmax ) {
			tmax = tzmax;
		}

		return ( ( tmin < t1 ) && ( tmax > t0 ) );
	}

	/// most tight bounds for the given transformed bounds
	void fromTransformedBounds( ref Bounds b, ref Vec3 translation, ref Mat3 rotation ) {
		int		i;
		Vec3	center, extents, rotatedExtents;

		center = ( b.maxs + b.mins ) * 0.5f;
		extents = b.maxs - center;

		for ( i = 0; i < 3; i++ ) {
			rotatedExtents[i] = Math.abs( extents[0] * rotation.cols[0][i] )
								+ Math.abs( extents[1] * rotation.cols[1][i] )
								+ Math.abs( extents[2] * rotation.cols[2][i] );
		}

		center = translation + center * rotation;

		mins = center - rotatedExtents;
		maxs = center + rotatedExtents;
	}

	/// most tight bounds for the given transformed bounds
	void fromTransformedBounds( ref Vec3 center, ref Vec3 extents, ref Vec3 translation, ref Mat3 rotation ) {
		int		i;
		Vec3	origin, rotatedExtents;

		for ( i = 0; i < 3; i++ ) {
			rotatedExtents[i] = Math.abs( extents[0] * rotation.cols[0][i] )
								+ Math.abs( extents[1] * rotation.cols[1][i] )
								+ Math.abs( extents[2] * rotation.cols[2][i] );
		}

		origin = translation + center * rotation;

		mins = origin - rotatedExtents;
		maxs = origin + rotatedExtents;
	}

	/// most tight bounds for a point set
	void fromPoints( Vec3[] points ) {
		clear();

		foreach ( p; points ) {
			addPoint( p );
		}
	}

	/// converts bounds to 8 corner _points
	void toPoints( Vec3[8] points ) {
		foreach ( size_t i, ref Vec3 p; points ) {
			p.x = ( &mins )[( i ^ ( i >> 1 ) ) & 1].x;
			p.y = ( &mins )[( i >> 1 ) & 1].y;
			p.z = ( &mins )[( i >> 2 ) & 1].z;
		}
	}

	/**
		Converts bounds to 6 bounding _planes.
		Plane normals point out of the bounds.
	*/
	void toPlanes( Plane[6] planes ) {
		for ( size_t i = 0; i < 3; i++ ) {
			planes[i].normal.zero();
			planes[i].normal[i] = -1.0f;
			planes[i].dist = mins[i];

			planes[i + 3].normal.zero();
			planes[i + 3].normal[i] = 1.0f;
			planes[i + 3].dist = maxs[i];
		}
	}

	/// converts bounds to sphere
	Sphere toSphere() {
		Sphere	dst;

		dst.origin = ( mins + maxs ) * 0.5f;
		dst.radius = ( maxs - dst.origin ).magnitude;

		return dst;
	}

	/// returns string, just a convenience function
	char[] toUtf8() {
		return Math.toUtf8( "( mins:{0} maxs:{1} )", mins.toUtf8, maxs.toUtf8 );
	}

	/// calculates the projection of the bounds onto the given _axis
	void axisProjection( int axis, out float min, out float max ) {
		float	d1 = ( mins[axis] + maxs[axis] ) * 0.5f;
		float	d2 = Math.abs( maxs[axis] - d1 );

		min = d1 - d2;
		max = d1 + d2;
	}

	/// ditto
	void axisProjection( ref Vec3 dir, out float min, out float max ) {
		float	d1, d2;
		Vec3	center = ( mins + maxs ) * 0.5f;
		Vec3	extents = maxs - center;

		d1 = dir * center;
		d2 = Math.abs( extents.x * dir.x )
			+ Math.abs( extents.y * dir.y )
			+ Math.abs( extents.z * dir.z );

		min = d1 - d2;
		max = d1 + d2;
	}

	/// ditto
	void axisProjection( ref Vec3 origin, ref Mat3 axis, ref Vec3 dir, out float min, out float max ) {
		float	d1, d2;
		Vec3	center = ( mins + maxs ) * 0.5f;
		Vec3	extents = maxs - center;

		center = origin + center * axis;

		d1 = dir * center;
		d2 = Math.abs( extents.x * ( dir * axis.cols[0] ) )
			+ Math.abs( extents.y * ( dir * axis.cols[1] ) )
			+ Math.abs( extents.z * ( dir * axis.cols[2] ) );

		min = d1 - d2;
		max = d1 + d2;
	}

	Vec3	mins;	/// minimal point of bounds
	Vec3	maxs;	/// maximal point of bounds
}

version (build) {
    debug {
        pragma(link, "ray");
    } else {
        pragma(link, "ray");
    }
}
