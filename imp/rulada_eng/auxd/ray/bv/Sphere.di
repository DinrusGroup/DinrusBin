/**
	Copyright: Copyright (c) 2007, Artyom Shalkhakov. All rights reserved.
	License: BSD

	Version: Aug 2007: initial release
	Authors: Artyom Shalkhakov
*/
module auxd.ray.bv.Sphere;

import auxd.ray.base.Math;
import auxd.ray.base.Vector;
import auxd.ray.base.Plane;

import auxd.ray.bv.Frustum;

/**
	Bounding sphere
*/
struct Sphere {
	/// returns degenerate sphere with 0.0f radius
	static Sphere opCall( ref Vec3 origin ) {
		Sphere	dst;

		dst.origin = origin;
		dst.radius = 0.0f;

		return dst;
	}

	static Sphere opCall( ref Vec3 origin, float radius ) {
		Sphere	dst;

		dst.origin = origin;
		dst.radius = radius;

		return dst;
	}

	/// returns translated sphere
	Sphere opAdd( ref Vec3 t ) {
		return Sphere( origin + t, radius );
	}

	/// translates the sphere
	void opAddAssign( ref Vec3 t ) {
		origin += t;
	}

	/// compare with epsilon
	bool compare( ref Sphere s, float epsilon ) {
		if ( !origin.compare( s.origin, epsilon ) ) {
			return false;
		}
		if ( Math.abs( radius - s.radius ) > epsilon ) {
			return false;
		}
		return true;
	}

	/// inside-out sphere
	void clear() {
		origin.zero();
		radius = -1.0f;
	}

	/// returns true if sphere is inside-out
	bool isCleared() {
		return ( radius < 0.0f );
	}

	void zero() {
		origin.zero();
		radius = 0.0f;
	}

	/**
		Expands the sphere so that point p is within the sphere,
		returns true if sphere expanded.
	*/
	bool addPoint( ref Vec3 p ) {
		Vec3	dir;
		float	r;

		if ( radius < 0.0f ) {
			origin = p;
			radius = 0.0f;
			return true;
		}

		dir = p - origin;
		r = dir.magnitudeSquared;

		if ( r > radius * radius ) {
			r = Math.sqrt( r );
			origin += dir * 0.5f * ( 1.0f - radius / r );
			radius += 0.5f * ( r - radius );
			return true;
		}

		return false;
	}

	/**
		Expands the sphere so that another sphere s is within the sphere,
		returns true if sphere expanded.
	*/
	bool addSphere( ref Sphere s ) {
		Vec3	dir;
		float	dr, r;

		if ( radius < 0.0f ) {
			origin = s.origin;
			radius = s.radius;
			return true;
		}

		dir = s.origin - origin;
		dr = dir.magnitudeSquared;
		r = radius + s.radius;

		if ( dr > r * r ) {
			dr = Math.sqrt( dr );
			origin += dir * 0.5f * ( 1.0f - radius / ( dr + s.radius ) );
			radius += 0.5f * ( ( dr + s.radius ) - radius );
			return true;
		}

		return false;
	}

	/// returns sphere expanded by the given value
	Sphere expand( float d ) {
		return Sphere( origin, radius + d );
	}

	/// expands sphere by the given value
	void expandSelf( float d ) {
		radius += d;
	}

	/// returns translated sphere
	Sphere translate( ref Vec3 t ) {
		return Sphere( origin + t, radius );
	}

	/// translates the sphere
	void translateSelf( ref Vec3 t ) {
		origin += t;
	}

	/// returns distance from plane to sphere
	float planeDistance( ref Plane p, float epsilon ) {
		float	d = p.distance( origin );

		if ( d > radius ) {
			return d - radius;
		}
		if ( d < -radius ) {
			return d + radius;
		}

		return 0.0f;
	}

	/// classifies sphere with respect to plane
	int planeSide( ref Plane p, float epsilon ) {
		float	d = p.distance( origin );

		if ( d > radius + epsilon ) {
			return PLANESIDE.FRONT;
		}
		if ( d < -radius - epsilon ) {
			return PLANESIDE.BACK;
		}

		return PLANESIDE.CROSS;
	}

	/**
		Returns true if the sphere contains the point,
		including touching.
	*/
	bool containsPoint( ref Vec3 p ) {
		if ( ( p - origin ).magnitudeSquared > radius * radius ) {
			return false;
		}

		return true;
	}

	/**
		Returns true if the sphere contains the given sphere,
		including touching.
	*/
	bool intersectsSphere( ref Sphere s ) {
		float	r = s.radius + radius;

		if ( ( s.origin - origin ).magnitudeSquared > r * r ) {
			return false;
		}

		return true;
	}

	/**
		Ray-sphere intersection test, returns true if ray intersects sphere.
		The ray can intersect the sphere in both directions from the start point.

		If start is inside the sphere then scale1 < 0 and scale2 > 0.
	*/
	bool rayIntersection( ref Vec3 start, ref Vec3 dir, out float scale1, out float scale2 ) {
		Vec3	p = start - origin;
		double	a = dir * dir;
		double	b = dir * p;
		double	c = p * p - radius * radius;
		double	d = b * b - c * a;
		double	sqrtD;

		if ( d < 0.0f ) {
			return false;
		}

		sqrtD = Math.sqrt( d );
		a = 1.0f / a;

		scale1 = ( -b + sqrtD ) * a;
		scale2 = ( -b - sqrtD ) * a;

		return true;
	}

	/**
		Ray-sphere intersection test.
		Returns intersection time if ray intersections sphere, or float.infinity otherwise.
	*/
	float rayIntersection( ref Vec3 start, ref Vec3 dir ) {
		Vec3	v = origin - start;
		double	b = dir * v;
		double	disc = b * b - v.magnitudeSquared + radius * radius;

		if ( disc < 0.0f ) {
			return float.infinity;
		}

		double	d = Math.sqrt( disc );
		double	t2 = b + d;
		double	t1 = b - d;

		if ( t2 < 0.0f ) {
			return float.infinity;
		}

		return ( t1 > 0.0f ? t1 : t2 );
	}

	/// most tight sphere for a point set
	void fromPoints( Vec3[] points ) {
		clear();

		foreach ( ref Vec3 p; points ) {
			addPoint( p );
		}
	}

	/// returns string, just a convenience function
	char[] toUtf8() {
		return Math.toUtf8( "( O:{0} R:{1,4E} )", origin.toUtf8, radius );
	}

	/// calculates the projection of the sphere onto the given axis
	void axisProjection( int axis, out float min, out float max ) {
		min = origin[axis] - radius;
		max = origin[axis] + radius;
	}

	/// ditto
	void axisProjection( ref Vec3 dir, out float min, out float max ) {
		float	d = dir * origin;

		min = d - radius;
		max = d + radius;
	}

	Vec3	origin;		/// center of sphere
	float	radius;		/// sphere radius
}

version (build) {
    debug {
        pragma(link, "ray");
    } else {
        pragma(link, "ray");
    }
}
