/**
	Copyright: Copyright (c) 2007, Artyom Shalkhakov. All rights reserved.
	License: BSD

	This module implements ray class.

	Version: Aug 2007: initial release
	Authors: Artyom Shalkhakov
*/
module auxd.ray.base.Ray;

import Math = auxd.ray.base.Math;
import auxd.ray.base.Vector;

const Ray	ray_zero = { origin : { x : 0.0f, y : 0.0f, z : 0.0f }, dir : { x : 0.0f, y : 0.0f, z : 0.0f } };

/// _Ray
struct Ray {
	static Ray opCall( ref Vec3 origin );

	static Ray opCall( ref Vec3 origin, ref Vec3 dir );

	/// returns the closest point on ray to point
	Vec3 closestPoint( ref Vec3 p );

	/// returns the closest distance between point and ray
	float distance( ref Vec3 p ) ;

	/**
		Returns ray refracted about the normal. The returned ray will have zero direction in case of
		total internal refraction.
		Inside is the index of refraction inside of the surface (on the positive _normal side).
		Outside is the index of refraction outside of the surface (on the positive _normal side).
	*/
	Ray refract( ref Vec3 normal, float inside, float outside ) ;

	/// refracts ray about the normal
	void refractSelf( ref Vec3 normal, float inside, float outside ) ;

	/// returns ray reflected about the normal
	Ray reflect( ref Vec3 normal );

	/// reflects ray about the normal
	void reflectSelf( ref Vec3 normal );

	/// returns string, just a convenience function
	char[] toUtf8() ;

	debug ( FLOAT_PARANOID ) {
		invariant() {
			assert( Math.isValid( origin.x ) );
			assert( Math.isValid( origin.y ) );
			assert( Math.isValid( origin.z ) );
			assert( Math.isValid( dir.x ) );
			assert( Math.isValid( dir.y ) );
			assert( Math.isValid( dir.z ) );
			if ( dir.x ) {
				assert( Math.isValid( invDir.x ) );
			}
			if ( dir.y ) {
				assert( Math.isValid( invDir.y ) );
			}
			if ( dir.z ) {
				assert( Math.isValid( invDir.z ) );
			}
		}
	}

	Vec3	origin;		/// ray origin
	Vec3	dir;		/// ray direction, may be non-normalized
	Vec3	invDir;		/// inverse of ray direction
	int		signbits;	/// signbits of invDir:  signX + ( signY << 1 ) + ( signZ << 2 )
}

version (build) {
    debug {
        pragma(link, "ray");
    } else {
        pragma(link, "ray");
    }
}
