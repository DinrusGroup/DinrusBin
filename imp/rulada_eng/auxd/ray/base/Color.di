/**
	Copyright: Copyright (c) 2007, Artyom Shalkhakov. All rights reserved.
	License: BSD

	Structures to represent colors.

	FIXME: byte-order selection should be done in compile-time.

	Version: Aug 2007: initial release
	Authors: Artyom Shalkhakov
*/
module auxd.ray.base.Color;

import Math = auxd.ray.base.Math;

/// byte-order conventions (for uint conversion)
enum BYTEORDER {
	ARGB8,
	ABGR8,
	RGBA8,
	BGRA8
}

const {
	Col3	col3_zero		= { r : 0.0f, g : 0.0f, b : 0.0f };
	Col3	col3_identity	= { r : 1.0f, g : 1.0f, b : 1.0f };
	Col4	col4_zero		= { r : 0.0f, g : 0.0f, b : 0.0f, a : 0.0f };
	Col4	col4_identity	= { r : 1.0f, g : 1.0f, b : 1.0f, a : 1.0f };
}

/**
	This structure represents RGB color. Red, green and blue components are stored in RGB order.
	Note that alpha component is assumed to be 1.0f.
	The color components can be accessed in array style, e.g.:

	---
		Col3	ambient;
		float	red;

		ambient.set( 0.5f, 1.0f, 0.0f );
		red = ambient[0];					// red contains 0.5f now
	---

	Basic operations (addition, subtraction, multiplication) are supported.

	---
		Col3	a, b, c;

		a.set( 1.0f, 0.0f, 0.4f );
		b.set( 0.0f, 1.0f, 0.5f );

		c = a + b;							// c is ( 1.0f, 1.0f, 0.9f )
		c = a * b;							// c is ( 0.0f, 0.0f, 0.2f )
	---
*/
struct Col3 {
	static Col3 opCall( float r, float g, float b );

	static Col3 opCall( float[3] rgb ) ;

	Col3 opCall( uint rgb, BYTEORDER order = BYTEORDER.RGBA8 );

	float opIndex( size_t index );
	
	float opIndexAssign( size_t index, float f );

	Col3 opNeg() ;

	Col3 opAdd( ref Col3 c ) ;

	Col3 opSub( ref Col3 c ) ;

	Col3 opMul( float f );

	Col3 opMul( ref Col3 c ) ;

	Col3 opDiv( float f );

	void opAddAssign( ref Col3 c );

	void opSubAssign( ref Col3 c );

	void opMulAssign( float f ) ;
	
	void opMulAssign( ref Col3 c ) ;
	
	void opDivAssign( float f ) ;

	/// make _zero (black) color
	void zero() ;

	/// make _identity (white) color
	void identity() ;

	/// set the new values for components
	void set( float r, float g, float b );

	/// clamp the color components to [0,1] range (inclusive)
	void clampSelf();

	/// _normalize the color, so it's components are in [0,1] range
	void normalize() ;

	/// linearly interpolates color from c1 to c2 by fraction f
	void lerpSelf( ref Col3 c1, Col3 c2, float f );

	/// returns color linearly interpolated from this to c2 by fraction f
	Col3 lerp( ref Col3 c2, float f );
	/// converts to RGBA color; alpha is assumed to be 1.0f
	Col4 toCol4() ;
	
	/// returns hash-code for color
	size_t toHash();

	/// packs RGB values into uint variable, alpha is assumed to be 1.0f
	uint toUint( BYTEORDER order = BYTEORDER.RGBA8 );

	/// returns string, just a convenience function
	char[] toUtf8();
	
	/// returns the number of components
	size_t length() ;

	/// returns raw pointer
	float *ptr();

	debug ( FLOAT_PARANOID ) {
		invariant() {
			assert( Math.isValid( r ) );
			assert( Math.isValid( g ) );
			assert( Math.isValid( b ) );
		}
	}

	float	r, g, b;		/// color components: red, green and blue
}

/**
	This structure represents RGBA color. Red, green, blue and alpha components are stored in RGB order.
	The color components can be accessed in array style, e.g.:

	---
		Col4	ambient;
		float	red;

		ambient.set( 0.5f, 1.0f, 0.0f, 1.0f );
		red = ambient[0];					// red contains 0.5f now
	---

	Basic operations (addition, subtraction, multiplication) are supported.

	---
		Col4	a, b, c;

		a.set( 1.0f, 0.0f, 0.4f );
		b.set( 0.0f, 1.0f, 0.5f );

		c = a + b;							// c is ( 1.0f, 1.0f, 0.9f )
		c = a * b;							// c is ( 0.0f, 0.0f, 0.2f )
	---
*/
struct Col4 {
	static Col4 opCall( float r, float g, float b, float a );

	static Col4 opCall( ref Col3 rgb, float a ) ;

	static Col4 opCall( float[4] rgba );

	static Col4 opCall( uint rgba, BYTEORDER order = BYTEORDER.RGBA8 );

	float opIndex( size_t index );

	float opIndexAssign( float f, size_t index );
	
	Col4 opAdd( ref Col4 c ) ;

	Col4 opSub( ref Col4 c ) ;

	Col4 opMul( float f );

	Col4 opMul( Col4 c ) ;

	Col4 opDiv( float f );

	void opAddAssign( Col4 c );
	
	void opSubAssign( Col4 c );
	
	void opMulAssign( float f ) ;

	void opMulAssign( Col4 c ) ;
	
	void opDivAssign( float f );

	/// make _zero (black) color
	void zero() ;

	/// make _identity (white) color
	void identity();

	/// functions for setting new value of color components
	void set( float r, float g, float b, float a );
	/// ditto
	void set( float r, float g, float b ) ;

	/// ditto
	void set( float a ) ;
	
	/// ditto
	void set( ref Col3 rgb );

	/// ditto
	void set( Col3 rgb, float a ) ;

	/// clamp the color components to [0,1] range (inclusive)
	void clampSelf();

	/**
		Normalize the color, so it's components are in [0,1] range.
		Alpha is only clamped to [0,1] range.
	*/
	void normalize();
	
	/// linearly interpolates color from c1 to c2 by fraction f
	void lerpSelf( ref Col4 c1, ref Col4 c2, float f ) ;

	/// returns color linearly interpolated from this to c2 by fraction f
	Col4 lerp( ref Col4 c2, float f ) ;
	
	/// returns hash-code for color
	size_t toHash() ;	

	/// packs RGBA values into uint variable
	uint toUint( BYTEORDER order = BYTEORDER.RGBA8 );

	/// returns string, just a convenience function
	char[] toUtf8();

	/// returns the number of components
	size_t length();

	/// returns raw pointer
	float *ptr() ;

	debug ( FLOAT_PARANOID ) {
		invariant() {
			assert( Math.isValid( r ) );
			assert( Math.isValid( g ) );
			assert( Math.isValid( b ) );
			assert( Math.isValid( a ) );
		}
	}

	float	r, g, b, a;		/// color components: red, green, blue and alpha
}

version (build) {
    debug {
        pragma(link, "ray");
    } else {
        pragma(link, "ray");
    }
}
