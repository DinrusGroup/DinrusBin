/**
	Copyright: Copyright (c) 2007, Artyom Shalkhakov. All rights reserved.
	License: BSD

	Version: Aug 2007: initial release
	Authors: Artyom Shalkhakov
*/
module auxd.ray.bv.Frustum;

import auxd.ray.base.Math;
import auxd.ray.base.Vector;
import auxd.ray.base.Plane;
import auxd.ray.base.Transformation;

/**
	Orthogonal symmetric frustum.

	The structure has to be properly initialized before use, either manually, or
	using one of provided static functions.
*/
struct Frustum {
	///	construct frustum using specified values; default values correspond to pyramidal frustum
	static Frustum opCall( ref Transformation tr, float near, float far, float up = far, float left = far ) {
		return Frustum( tr.origin, tr.axis, near, far, up, left );
	}

	///	construct frustum using specified values; default values correspond to pyramidal frustum
	static Frustum opCall( ref Vec3 origin, ref Mat3 axis, float near, float far, float up = far, float left = far )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( near ) );
			assert( Math.isValid( far ) );
			assert( Math.isValid( up ) );
			assert( Math.isValid( left ) );
		}
		assert( near >= 0.0f && far > near );
		assert( left > 0.0f && up > 0.0f );
	}
	body {
		Frustum	dst;

		dst.tr.origin = origin;
		dst.tr.axis = axis;
		dst.near = near;
		dst.far = far;
		dst.left = left;
		dst.up = up;
		dst.invFar = 1.0f / far;

		return dst;
	}

	/// construct frustum using specified values; also sets identity transformation matrix
	static Frustum opCall( float near, float far, float left, float up )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( near ) );
			assert( Math.isValid( far ) );
			assert( Math.isValid( up ) );
			assert( Math.isValid( left ) );
		}
		assert( near >= 0.0f && far > near );
		assert( left > 0.0f && up > 0.0f );
	}
	body {
		Frustum	dst;

		dst.tr = transform_zero;
		dst.near = near;
		dst.far = far;
		dst.left = left;
		dst.up = up;
		dst.invFar = 1.0f / far;

		return dst;
	}

	/// set-up for arbitrary-sized frustum
	void set( float near, float far, float left, float up )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( near ) );
			assert( Math.isValid( far ) );
			assert( Math.isValid( up ) );
			assert( Math.isValid( left ) );
		}
	}
	body {
		this.near = near;
		this.far = far;
		this.left = left;
		this.up = up;
		this.invFar = 1.0f / far;
	}

	/// set-up for pyramidal frustum
	void set( float near, float far )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( near ) );
			assert( Math.isValid( far ) );
		}
	}
	body {
		this.near = near;
		this.far = far;
		this.left = far;
		this.up = far;
		this.invFar = 1.0f / far;
	}

	/// set new _near plane distance
	void moveNear( float near )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( near ) );
		}
		assert( near >= 0.0f && near < far );
	}
	body {
		this.near = near;
	}

	/// set new _far plane distance
	void moveFar( float far )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( far ) );
		}
		assert( far > near );
	}
	body {
		float	scale = far / this.far;

		this.far = far;
		this.left *= scale;
		this.up *= scale;
		this.invFar = 1.0f / far;
	}

	/// returns frustum expanded by the given value
	Frustum expand( float d )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( d ) );
		}
	}
	body {
		Frustum	dst = *this;

		dst.tr -= d * dst.tr.axis.cols[0];
		dst.far += 2.0f * d;
		dst.left = dst.far * left * invFar;
		dst.up = dst.far * up * invFar;
		dst.invFar = 1.0f / dst.far;

		return dst;
	}

	/// expand frustum by the given value
	void expandSelf( float d )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( d ) );
		}
	}
	body {
		tr -= d * tr.axis.cols[0];
		far += 2.0f * d;
		left = far * left * invFar;
		up = far * left * invFar;
		invFar = 1.0f / far;
	}

	/// returns geometrical _center of frustum
	Vec3 center() {
		return ( tr.origin + tr.axis.cols[0] * ( ( far - near ) * 0.5f ) );
	}

	/// returns distance to plane
	float planeDistance( ref Plane p ) {
		float	min, max;

		axisProjection( p.normal, min, max );
		if ( min - p.dist > 0.0f ) {
			return min - p.dist;
		}
		if ( max - p.dist < 0.0f ) {
			return max - p.dist;
		}

		return 0.0f;
	}

	/// classifies frustum with respect to plane
	int planeSide( ref Plane p, float epsilon ) {
		float	min, max;

		axisProjection( p.normal, min, max );
		if ( min - p.dist > 0.0f ) {
			return PLANESIDE.FRONT;
		}
		if ( max - p.dist < 0.0f ) {
			return PLANESIDE.BACK;
		}

		return PLANESIDE.CROSS;
	}

	/// test if point is completely outside of frustum
	bool cullPoint( ref Vec3 p ) {
		Vec3	pl;
		float	scale;

		// transform point to frustum space
		tr.untransformPoint( p, pl );

		// test whether or not the point is within the frustum
		if ( p.x < near || p.x > far ) {
			return true;
		}

		scale = p.x * invFar;
		if ( Math.abs( p.y ) > left * scale ) {
			return true;
		}
		if ( Math.abs( p.z ) > up * scale ) {
			return true;
		}

		return false;
	}

	/**
		Test if bounding box is completely outside of frustum,
		bounding box is given by it's minimum and maximum vertices.
	*/
	bool cullBounds( ref Vec3 mins, ref Vec3 maxs ) {
		Vec3	center = ( mins + maxs ) * 0.5f;
		Vec3	extents = maxs - center;

		return cullExtents( center, extents );
	}

	/**
		Test if bounding box is completely outside of frustum,
		bounding box is given by it's center and extents.
	*/
	bool cullExtents( ref Vec3 center, ref Vec3 extents ) {
		Mat3	localAxis = tr.axis.transpose;
		Vec3	localOrigin;

		// transform the bounds into the space of this frustum
		localOrigin = ( center - tr.origin ) * localAxis;

		return cullLocalBox( localOrigin, extents, localAxis );
	}

	/// tests if any of the planes of the frustum can be used as separating plane
	bool cullSphere( ref Vec3 center, float radius ) {
		float	d, sr, sFar;
		Vec3 	localCenter = ( center - tr.origin ) * tr.axis.transpose;

		// test near plane
		if ( near - localCenter.x > radius ) {
			return true;
		}

		// test far plane
		if ( localCenter.x - far > radius ) {
			return true;
		}

		sr = radius * radius;
		sFar = far * far;

		// test left/right planes
		d = far * Math.abs( localCenter.y ) - left * localCenter.x;
		if ( ( d * d ) > sr * ( sFar + left * left ) ) {
			return true;
		}

		// test up/down planes
		d = far * Math.abs( localCenter.z ) - up * localCenter.x;
		if ( ( d * d ) > sr * ( sFar + up * up ) ) {
			return true;
		}

		return false;
	}

	/// calculate _near plane frustum _corners
	void toCornerVecs( Vec3[4] corners ) {
		Mat3	scaled;

		scaled.cols[0] = tr.axis.cols[0] * near;
		scaled.cols[1] = tr.axis.cols[1] * left * near * invFar;
		scaled.cols[2] = tr.axis.cols[2] * up * near * invFar;

		corners[0] = scaled.cols[0] - scaled.cols[1];
		corners[2] = scaled.cols[0] + scaled.cols[1];
		corners[1] = corners[0] + scaled.cols[2];
		corners[3] = corners[2] + scaled.cols[2];
		corners[0] -= scaled.cols[2];
		corners[2] -= scaled.cols[2];
	}

	/// calculates 8 corners of the frustum
	void toPoints( Vec3[8] points ) {
		Mat3	scaled;

		scaled.cols[0] = tr.origin + tr.axis.cols[0] * near;
		scaled.cols[1] = tr.axis.cols[1] * ( left * near * invFar );
		scaled.cols[2] = tr.axis.cols[2] * ( up * near * invFar );

		points[0] = scaled.cols[0] + scaled.cols[1];
		points[1] = scaled.cols[0] - scaled.cols[1];
		points[2] = points[1] - scaled.cols[2];
		points[3] = points[0] - scaled.cols[2];
		points[0] += scaled.cols[2];
		points[1] += scaled.cols[2];

		scaled.cols[0] = tr.origin + tr.axis.cols[0] * far;
		scaled.cols[1] = tr.axis.cols[1] * left;
		scaled.cols[2] = tr.axis.cols[2] * up;

		points[4] = scaled.cols[0] + scaled.cols[1];
		points[5] = scaled.cols[0] - scaled.cols[1];
		points[6] = points[5] - scaled.cols[2];
		points[7] = points[4] - scaled.cols[2];
		points[4] += scaled.cols[2];
		points[5] += scaled.cols[2];
	}

	/// convert frustum to 6 _planes; plane normals point outwards
	void toPlanes( Plane[6] planes ) {
		Vec3	scaled[2];
		Vec3	points[4];

		planes[0].normal = -tr.axis.cols[0];
		planes[0].dist = near;
		planes[1].normal = tr.axis.cols[0];
		planes[1].dist = -far;

		scaled[0] = tr.axis.cols[1] * left;
		scaled[1] = tr.axis.cols[2] * up;
		points[0] = scaled[0] + scaled[1];
		points[1] = -scaled[0] + scaled[1];
		points[2] = -scaled[0] - scaled[1];
		points[3] = scaled[0] - scaled[1];

		for ( int i = 0; i < 4; i++ ) {
			planes[i + 2].normal = points[i].cross( points[( i + 1 ) & 3] - points[i] ).normalize;
			planes[i + 2].fitThroughPoint( points[i] );
		}
	}

	/// returns string, just a convenience function
	char[] toUtf8() {
		return Math.toUtf8( "( O:{0} R:{1} N:{2,4E} F:{3,4E} L:{4,4E} U:{5,4E} )", tr.origin.toUtf8, tr.axis.toUtf8, near, far, left, up );
	}

	/// returns projection onto given axis
	void axisProjection( ref Vec3 dir, out float min, out float max ) {
		Vec3[8]	indexPoints;
		Vec3[4]	cornerVecs;

		toIndexPointsAndCornerVecs( indexPoints, cornerVecs );
		axisProjection( indexPoints, cornerVecs, dir, min, max );
	}

	invariant() {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( near ) );
			assert( Math.isValid( far ) );
			assert( Math.isValid( up ) );
			assert( Math.isValid( left ) );
		}
		assert( near >= 0.0f );
		assert( far > near );
		assert( left > 0.0f );
		assert( up > 0.0f );
	}

	Transformation	tr;			/// frustum transformation
	float			near;		/// distance of _near plane, near >= 0.0f
	float			far;		/// distance of _far plane, far > near
	float			left;		/// half the width at the _far plane
	float			up;			/// half the height at the _far plane
	float			invFar;		/// 1.0f / far

private:
	// test for intersection with axis-aligned bounding box given in local (frustum) space
	bool cullLocalBox( ref Vec3 localOrigin, ref Vec3 extents, ref Mat3 localAxis ) {
		float	d1, d2;
		Vec3	testOrigin;
		Mat3	testAxis;

		// near plane
		d1 = near - localOrigin.x;
		d2 = Math.abs( extents.x * localAxis.cols[0].x )
			+ Math.abs( extents.y * localAxis.cols[1].x )
			+ Math.abs( extents.z * localAxis.cols[2].x );
		if ( d1 - d2 > 0.0f ) {
			return true;
		}

		// far plane
		d1 = localOrigin.x - far;
		if ( d1 - d2 > 0.0f ) {
			return true;
		}

		testOrigin = localOrigin;
		testAxis = localAxis;

		if ( testOrigin.y < 0.0f ) {
			testOrigin.y = -testOrigin.y;
			testAxis.cols[0].y = -testAxis.cols[0].y;
			testAxis.cols[1].y = -testAxis.cols[1].y;
			testAxis.cols[2].y = -testAxis.cols[2].y;
		}

		// test left/right planes
		d1 = far * testOrigin.y - left * testOrigin.x;
		d2 = Math.abs( extents.x * ( far * testAxis.cols[0].y - left * testAxis.cols[0].x ) )
			+ Math.abs( extents.y * ( far * testAxis.cols[1].y - left * testAxis.cols[1].x ) )
			+ Math.abs( extents.z * ( far * testAxis.cols[2].y - left * testAxis.cols[2].x ) );
		if ( d1 - d2 > 0.0f ) {
			return true;
		}

		if ( testOrigin.z < 0.0f ) {
			testOrigin.z = -testOrigin.z;
			testAxis.cols[0].z = -testAxis.cols[0].z;
			testAxis.cols[1].z = -testAxis.cols[1].z;
			testAxis.cols[2].z = -testAxis.cols[2].z;
		}

		// test up/down planes
		d1 = far * testOrigin.z - up * testOrigin.x;
		d2 = Math.abs( extents.x * ( far * testAxis.cols[0].z - up * testAxis.cols[0].x ) )
			+ Math.abs( extents.y * ( far * testAxis.cols[1].z - up * testAxis.cols[1].x ) )
			+ Math.abs( extents.z * ( far * testAxis.cols[2].z - up * testAxis.cols[2].x ) );
		if ( d1 - d2 > 0.0f ) {
			return true;
		}

		return false;
	}

	void axisProjection( Vec3[8] indexPoints, Vec3[4] cornerVecs, ref Vec3 dir, out float min, out float max ) {
		float	dx, dy, dz;
		int		index;

		dy = dir.x * tr.axis.cols[1].x + dir.y * tr.axis.cols[1].y + dir.z * tr.axis.cols[1].z;
		dz = dir.x * tr.axis.cols[2].x + dir.y * tr.axis.cols[2].y + dir.z * tr.axis.cols[2].z;
		index = ( Math.signbit( dy ) << 1 ) | Math.signbit( dz );

		dx = dir.x * cornerVecs[index].x + dir.y * cornerVecs[index].y + dir.z * cornerVecs[index].z;
		index |= ( Math.signbit( dx ) << 2 );

		min = indexPoints[index] * dir;
		index = ~index & 3;
		dx = -dir.x * cornerVecs[index].x - dir.y * cornerVecs[index].y - dir.z * cornerVecs[index].z;
		index |= ( Math.signbit( dx ) << 2 );
		max = indexPoints[index] * dir;
	}

	void toIndexPoints( Vec3[8] points ) {
		Mat3	scaled;

		scaled.cols[0] = tr.origin + tr.axis.cols[0] * near;
		scaled.cols[1] = tr.axis.cols[1] * ( left * near * invFar );
		scaled.cols[2] = tr.axis.cols[2] * ( up * near * invFar );

		points[0] = scaled.cols[0] - scaled.cols[1];
		points[2] = scaled.cols[0] + scaled.cols[1];
		points[1] = points[0] + scaled.cols[2];
		points[3] = points[2] + scaled.cols[2];
		points[0] -= scaled.cols[2];
		points[2] -= scaled.cols[2];

		scaled.cols[0] = tr.origin + tr.axis.cols[0] * far;
		scaled.cols[1] = tr.axis.cols[1] * left;
		scaled.cols[2] = tr.axis.cols[2] * up;

		points[4] = scaled.cols[0] - scaled.cols[1];
		points[6] = scaled.cols[0] + scaled.cols[1];
		points[5] = points[4] + scaled.cols[2];
		points[7] = points[6] + scaled.cols[2];
		points[4] -= scaled.cols[2];
		points[6] -= scaled.cols[2];
	}

	void toIndexPointsAndCornerVecs( Vec3[8] points, Vec3[4] corners ) {
		Mat3	scaled;

		scaled.cols[0] = tr.origin + tr.axis.cols[0] * near;
		scaled.cols[1] = tr.axis.cols[1] * ( left * near * invFar );
		scaled.cols[2] = tr.axis.cols[2] * ( up * near * invFar );

		points[0] = scaled.cols[0] - scaled.cols[1];
		points[2] = scaled.cols[0] + scaled.cols[1];
		points[1] = points[0] + scaled.cols[2];
		points[3] = points[2] + scaled.cols[2];
		points[0] -= scaled.cols[2];
		points[2] -= scaled.cols[2];

		scaled.cols[0] = tr.axis.cols[0] * far;
		scaled.cols[1] = tr.axis.cols[1] * left;
		scaled.cols[2] = tr.axis.cols[2] * up;

		corners[0] = scaled.cols[0] - scaled.cols[1];
		corners[2] = scaled.cols[0] + scaled.cols[1];
		corners[1] = corners[0] + scaled.cols[2];
		corners[3] = corners[2] + scaled.cols[2];
		corners[0] -= scaled.cols[2];
		corners[2] -= scaled.cols[2];

		points[4] = corners[0] + tr.origin;
		points[5] = corners[1] + tr.origin;
		points[6] = corners[2] + tr.origin;
		points[7] = corners[3] + tr.origin;
	}
}

version (build) {
    debug {
        pragma(link, "ray");
    } else {
        pragma(link, "ray");
    }
}
