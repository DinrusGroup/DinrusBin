/**
	Copyright: Copyright (c) 2007, Artyom Shalkhakov. All rights reserved.
	License: BSD

	This module implements Euler angles.

	Version: Aug 2007: initial release
	Authors: Artyom Shalkhakov
*/
module auxd.ray.base.Angles;

import Math = auxd.ray.base.Math;
import auxd.ray.base.Vector;
import auxd.ray.base.Quat;

const Angles	ang_zero = { pitch : 0.0f, yaw : 0.0f, roll : 0.0f };
/// angle indices
enum : int {
	PITCH	= 0,	/// up/down
	YAW		= 1,	/// left/right
	ROLL	= 2		/// fall over
}

/// Euler angles
struct Angles {
	static Angles opCall( float pitch, float yaw, float roll ) {
		Angles	dst;

		dst.pitch	= pitch;
		dst.yaw		= yaw;
		dst.roll	= roll;

		return dst;
	}

	static Angles opCall( ref Vec3 v ) {
		Angles	dst;

		dst.pitch	= v.x;
		dst.yaw		= v.y;
		dst.roll	= v.z;

		return dst;
	}

	float opIndex( size_t index )
	in {
		assert( index >= 0 && index < 3 );
	}
	body {
		return ( &pitch )[index];
	}

	float opIndexAssign( float angle, size_t index )
	in {
		assert( index >= 0 && index < 3 );
	}
	body {
		return ( &pitch )[index] = angle;
	}

	/// negate angles, in general not the inverse rotation
	Angles opNeg() {
		return Angles( -pitch, -yaw, -roll );
	}

	Angles opAdd( ref Angles a ) {
		return Angles( pitch + a.pitch, yaw + a.yaw, roll + a.roll );
	}

	Angles opSub( ref Angles a ) {
		return Angles( pitch - a.pitch, yaw - a.yaw, roll - a.roll );
	}

	Angles opMul( float f )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( f ) );
		}
	}
	body {
		return Angles( pitch * f, yaw * f, roll * f );
	}

	Angles opDiv( float f )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( f ) );
			assert( Math.abs( f - 0.0f ) > 1e-14 );
		}
	}
	body {
		float	invF = 1.0f / f;

		return Angles( pitch * invF, yaw * invF, roll * invF );
	}

	void opAddAssign( ref Angles a ) {
		pitch += a.pitch;
		yaw += a.yaw;
		roll += a.roll;
	}

	void opSubAssign( ref Angles a ) {
		pitch -= a.pitch;
		yaw -= a.yaw;
		roll -= a.roll;
	}

	void opMulAssign( float f )
	in {
		debug ( FLOAT_PARANOID ) {
			assert( Math.isValid( f ) );
		}
	}
	body {
		pitch *= f;
		yaw *= f;
		roll *= f;
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

		pitch *= invF;
		yaw *= invF;
		roll *= invF;
	}

	/// exact compare
	bool opEquals( ref Angles a ) {
		return ( pitch == a.pitch && yaw == a.yaw && roll == a.roll );
	}

	/// _compare with epsilon
	bool compare( ref Angles a, float epsilon ) {
		if ( Math.abs( pitch - a.pitch ) > epsilon ) {
			return false;
		}
		if ( Math.abs( yaw - a.yaw ) > epsilon ) {
			return false;
		}
		if ( Math.abs( roll - a.roll ) > epsilon ) {
			return false;
		}

		return true;
	}

	/// _zero angles
	void zero() {
		*this = ang_zero;
	}

	void set( float pitch, float yaw, float roll ) {
		this.pitch	= pitch;
		this.yaw	= yaw;
		this.roll	= roll;
	}

	/// clamps angles
	void clampSelf( ref Angles min, ref Angles max ) {
		pitch = Math.clamp( pitch, min.pitch, max.pitch );
		yaw	= Math.clamp( yaw, min.yaw, max.yaw );
		roll = Math.clamp( roll, min.roll, max.roll );
	}

	static private float lerpAngle( float from, float to, float f ) {
		if ( to - from > 180.0f ) {
			return ( from + ( ( to - 360.0f ) - from ) * f );
		}
		if ( to - from < -180.0f ) {
			return ( from + ( ( to + 360.0f ) - from ) * f );
		}
		return ( from + ( to - from ) * f );
	}

	/// linearly interpolate from a1 to a2
	void lerpSelf( ref Angles a1, ref Angles a2, float f ) {
		if ( f <= 0.0f ) {
			*this = a1;
		}
		else if ( f >= 1.0f ) {
			*this = a2;
		}
		else {
			pitch = lerpAngle( a1.pitch, a2.pitch, f );
			yaw = lerpAngle( a1.yaw, a2.yaw, f );
			roll = lerpAngle( a1.roll, a2.roll, f );
		}
	}

	/// returns angles linearly interpolated from this to a2
	Angles lerp( ref Angles a2, float f ) {
		if ( f <= 0.0f ) {
			return *this;
		}
		else if ( f >= 1.0f ) {
			return a2;
		}
		return Angles( lerpAngle( pitch, a2.pitch, f ), lerpAngle( yaw, a2.yaw, f ), lerpAngle( roll, a2.roll, f ) );
	}

	/// normalizes angles to the range [-180 < angle <= 180]
	void normalize180() {
		normalize360();

		if ( pitch > 180.0f ) {
			pitch -= 180.0f;
		}
		if ( yaw > 180.0f ) {
			yaw -= 180.0f;
		}
		if ( roll > 180.0f ) {
			roll -= 180.0f;
		}
	}

	/// normalizes angles to the range [0 <= angle < 360]
	void normalize360() {
		static float normalize( float angle ) {
			if ( angle >= 360.0f || angle < 0.0f ) {
				angle -= Math.floor( angle / 360.0f ) * 360.0f;

				if ( angle >= 360.0f ) {
					angle -= 360.0f;
				}
				if ( angle < 0.0f ) {
					angle += 360.0f;
				}
			}

			return angle;
		}

		pitch	= normalize( pitch );
		yaw		= normalize( yaw );
		roll	= normalize( roll );
	}

	debug ( UNITTESTS ) {
		unittest {
			Angles	t = Angles( 1080.0f, 0.0f, -240.0f );

			t.normalize360();

			assert( Math.abs( t.pitch - 0.0f ) < 0.01f );
			assert( Math.abs( t.yaw - 0.0f ) < 0.01f );
			assert( Math.abs( t.roll - 120.0f ) < 0.01f );
		}
	}

	/// converts angles to three directional vectors
	void toVectors( ref Vec3 forward, ref Vec3 right, ref Vec3 up ) {
		float	sp, cp, sy, cy, sr, cr;

		Math.sinCos( Math.deg2rad( pitch ), sp, cp );
		Math.sinCos( Math.deg2rad( yaw ), sy, cy );
		Math.sinCos( Math.deg2rad( roll ), sr, cr );

		forward.set( cp * cy, cp * sy, -sp );
		right.set( -sr * sp * cy + cr * sy, -sr * sp * sy + -cr * cy, -sr * cp );
		up.set( cr * sp * cy + -sr * -sy, cr * sp * sy + -sr * cy, cr * cp );
	}

	/// converts yaw and pitch to direction
	Vec3 toForward() {
		float	sp, sy, cp, cy;

		Math.sinCos( Math.deg2rad( yaw ), sy, cy );
		Math.sinCos( Math.deg2rad( pitch ), sp, cp );

		return Vec3( cp * cy, cp * sy, -sp );
	}

	/// converts to 3x3 matrix
	Mat3 toMat3() {
		Mat3	dst;
		float	sr, sp, sy, cr, cp, cy;

		Math.sinCos( Math.deg2rad( yaw ), sy, cy );
		Math.sinCos( Math.deg2rad( pitch ), sp, cp );
		Math.sinCos( Math.deg2rad( roll ), sr, cr );

		dst.cols[0] = Vec3( cp * cy, cp * sy, -sp );
		dst.cols[1] = Vec3( sr * sp * cy + cr * -sy, sr * sp * sy + cr * cy, sr * cp );
		dst.cols[2] = Vec3( cr * sp * cy + -sr * -sy, cr * sp * sy + -sr * cy, cr * cp );

		return dst;
	}

	/// converts to quaternion
	Quat toQuat() {
		float	sx, cx, sy, cy, sz, cz;
		float	sxcy, cxcy, sxsy, cxsy;

		Math.sinCos( Math.deg2rad( yaw ) * 0.5f, sz, cz );
		Math.sinCos( Math.deg2rad( pitch ) * 0.5f, sy, cy );
		Math.sinCos( Math.deg2rad( roll ) * 0.5f, sx, cx );

		sxcy = sx * cy;
		cxcy = cx * cy;
		sxsy = sx * sy;
		cxsy = cx * sy;

		return Quat( cxsy * sz - sxcy * cz, -cxsy * cz - sxcy * sz, sxsy * cz - cxcy * sz, cxcy * cz + sxsy * sz ); 
	}

	/// converts to string; just a convenience function
	char[] toUtf8() {
		return Math.toUtf8( "( p:{0:E} y:{1:E} r:{2:E} )", pitch, yaw, roll );
	}

	/// returns the number of components
	size_t length() {
		return 3;
	}

	/// returns raw pointer
	float *ptr() {
		return ( &pitch );
	}

	debug ( FLOAT_PARANOID ) {
		invariant() {
			assert( Math.isValid( pitch ) );
			assert( Math.isValid( yaw ) );
			assert( Math.isValid( roll ) );
		}
	}

	float	pitch;
	float	yaw;
	float	roll;
}

version (build) {
    debug {
        pragma(link, "ray");
    } else {
        pragma(link, "ray");
    }
}
