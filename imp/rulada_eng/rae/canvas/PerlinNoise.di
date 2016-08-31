module rae.canvas.PerlinNoise;

// perlinNoise.d
// Class to implement coherent noise over 1, 2, or 3 dimensions.
// Implementation based on the Perlin noise function. Thanks to
// Ken Perlin of NYU for publishing his algorithm online.
// Copyright (c) 2001, Matt Zucker
// You may use this source code as you wish, but it is provided
// with no warranty. Please email me at mazucker@vassar.edu if
// you find it useful.

//Modified to D programming language from original C++ by Jonas Kivi

//private import std.stdio;//#include <stdio.h>
//private import std.date;//#include <time.h>
//private import std.math;//#include <math.h>
//private import std.c.stdlib; //rand() and srand()
//private import std.random;//slower rand() and rand_seed()
//#include "PerlinNoise.h"

import tango.math.Math;
import tango.math.Random;

// It must be true that (x % NOISE_WRAP_INDEX) == (x & NOISE_MOD_MASK)
// so NOISE_WRAP_INDEX must be a power of two, and NOISE_MOD_MASK must be
// that power of 2 - 1.  as indices are implemented, as unsigned chars,
// NOISE_WRAP_INDEX shoud be less than or equal to 256.
// There's no good reason to change it from 256, really.

const int NOISE_WRAP_INDEX = 256;
const int NOISE_MOD_MASK = 255;

const int NOISE_LARGE_PWR2 = 4096;

Random random;

// TODO: change these preprocessor macros into inline functions

// S curve is (3x^2 - 2x^3) because it's quick to calculate
// though -cos(x * PI) * 0.5 + 0.5 would work too
/*
	static float easeCurve(float t)
	{
		return t * t * (3.0 - 2.0 * t);
	}

	static float linearInterp(float t, float a, float b)
	{
		return a + t * (b - a);
	}

	static float dot2(float rx, float ry, float* q)//float q[2]
	{
		//if(q !is null && q.size >= 2)
			return rx * q[0] + ry * q[1];
		//writefln("dot2 error. line 125. perlinnoise.d.");
		//return 0.0f;
	}

	static float dot3(float rx, float ry, float rz, float* q)//float q[3]
	{
		//if(q !is null && q.size >= 3)
			return rx * q[0] + ry * q[1] + rz * q[2];
		//writefln("dot3 error. line 133. perlinnoise.d.");
		//return 0.0f;
	}
*/
	/*static void setupValues(float* t, uint axis, int* g0, int* g1, float* d0, float* d1, float pos[])
	{
		//writefln("DURING.pos[0]:", pos[axis]);
		*t = pos[axis] + NOISE_LARGE_PWR2;
		*g0 = (cast(int)*t) & NOISE_MOD_MASK;
		*g1 = (*g0 + 1) & NOISE_MOD_MASK;
		*d0 = *t - cast(int)*t;
		*d1 = *d0 - 1.0;
	}*/

	static void setupValues(out float t, in uint axis, out int g0, out int g1, out float d0, out float d1, in float pos[])
	{
		//writefln("DURING.pos[0]:", pos[axis]);
		t = pos[axis] + NOISE_LARGE_PWR2;
		g0 = (cast(int)t) & NOISE_MOD_MASK;
		g1 = (g0 + 1) & NOISE_MOD_MASK;
		d0 = t - cast(int)t;
		d1 = d0 - 1.0;
	}


//class PerlinNoise
//{

//protected:


	// initialize static variables

	static uint initialized = 0;
	static uint permutationTable[ NOISE_WRAP_INDEX*2 + 2 ];// = 0;
	static float gradientTable1d[ NOISE_WRAP_INDEX*2 + 2 ];// = 0;
	static float gradientTable2d[ NOISE_WRAP_INDEX*2 + 2 ][ 2 ];// = 0;
	static float gradientTable3d[ NOISE_WRAP_INDEX*2 + 2 ][ 3 ];// = 0;

	// return a random float in [-1,1]

	static float randNoiseFloat()
	{
		//float temp = cast( float ) (( ( cast(float)rand() % ( NOISE_WRAP_INDEX + NOISE_WRAP_INDEX ) ) -
		//	NOISE_WRAP_INDEX )) / NOISE_WRAP_INDEX;

		//writefln("randNoiseFloat:", temp);
		//return temp;
		return 0.45f;
		//RANDOM HACK
		//return cast( float ) (( random.next() % ( NOISE_WRAP_INDEX + NOISE_WRAP_INDEX ) ) -
		//	NOISE_WRAP_INDEX ) / NOISE_WRAP_INDEX;
	}

	// convert a 2D vector into unit.size

	static void normalize2d( float vector[ 2 ] )
	{
		float length = sqrt( ( vector[ 0 ] * vector[ 0 ] ) + ( vector[ 1 ] * vector[ 1 ] ) );
		vector[ 0 ] /= length;
		vector[ 1 ] /= length;
	}

	// convert a 3D vector into unit.size

	static void normalize3d( float vector[ 3 ] )
	{
		float length = sqrt( ( vector[ 0 ] * vector[ 0 ] ) +
			( vector[ 1 ] * vector[ 1 ] ) +
			( vector[ 2 ] * vector[ 2 ] ) );
		vector[ 0 ] /= length;
		vector[ 1 ] /= length;
		vector[ 2 ] /= length;
	}

	static void normalize3d( inout float x, inout float y, inout float z )
	{
		float length = sqrt( ( x * x ) +
			( y * y ) +
			( y * y ) );
		x /= length;
		y /= length;
		z /= length;
	}

//public:
/*
	this();
	~this();

	static void reseed();
	static void reseed( unsigned int rSeed );

	float Noise1d( float pos[ 1 ] );
	float Noise2d( float pos[ 2 ] );
	float Noise3d( float pos[ 3 ] );

	float Noise( float );
	float Noise( float, float );
	float Noise( float, float, float );

	//  float Turbulence( Vec3f &p, int oct, bool hard = false );

//};
*/




	// Konstruktor
	/*this()
	{
		reseed();
		//generateLookupTables();
	}
	// Destruktor
	~this()
	{
	}*/


	//
	// Mnemonics used in the following 3 functions:
	//   L = left(-X direction)
	//   R = right  (+X direction)
	//   D = down   (-Y direction)
	//   U = up     (+Y direction)
	//   B = backwards(-Z direction)
	//   F = forwards       (+Z direction)
	//
	// Not that it matters to the math, but a reader might want to know.
	//
	// noise1d - create 1-dimensional coherent noise
	//   if you want to learn about how noise works, look at this
	//   and then look at noise2d.

	float noise1d( float pos[ 1 ] )
	{
		int gridPointL, gridPointR;
		float distFromL, distFromR, sX, t, u, v;

		if ( ! initialized ) { reseed(); }

		//writefln("BEFORE.pos[0]:", pos[0]);

		// find out neighboring grid points to pos and signed distances from pos to them.
		//old: setupValues( &t, 0, &gridPointL, &gridPointR, &distFromL, &distFromR, pos );
		setupValues( t, 0, gridPointL, gridPointR, distFromL, distFromR, pos );
		/*opt:
		t = pos[0] + NOISE_LARGE_PWR2;
		gridPointL = (cast(int)t) & NOISE_MOD_MASK;
		gridPointR = (gridPointL + 1) & NOISE_MOD_MASK;
		distFromL = t - cast(int)t;
		distFromR = distFromL - 1.0;
		*/

		//writefln("AFTER.pos[0]:", pos[0]);
/*
		writefln("t:", t);
		writefln("gridPointL:", gridPointL);
		writefln("gridPointR:", gridPointR);
		writefln("distFromL:", distFromL);
*/
		//sX = easeCurve( distFromL );
		sX = distFromL * distFromL * (3.0 - 2.0 * distFromL);
		//writefln("sX:", sX);

		// u, v, are the vectors from the grid pts. times the random gradients for the grid points
		// they are actually dot products, but this looks like scalar multiplication
		u = distFromL * gradientTable1d[ permutationTable[ gridPointL ] ];
		v = distFromR * gradientTable1d[ permutationTable[ gridPointR ] ];

		// return the linear interpretation between u and v (0 = u, 1 = v) at sX.
		return u + sX * (v - u);//linearInterp( sX, u, v );
	}

	// create 2d coherent noise

	float noise2d( float pos[ 2 ] )
	{
		int gridPointL, gridPointR, gridPointD, gridPointU;
		int indexLD, indexRD, indexLU, indexRU;
		float distFromL, distFromR, distFromD, distFromU;
		float* q;
		float sX, sY, a, b, t, u, v;
		uint indexL, indexR;

		if ( !initialized ) { reseed(); }

		// find out neighboring grid points to pos and signed distances from pos to them.
		//old:setupValues( &t, 0, &gridPointL, &gridPointR, &distFromL, &distFromR, pos );
		//old:setupValues( &t, 1, &gridPointD, &gridPointU, &distFromD, &distFromU, pos );
		setupValues( t, 0, gridPointL, gridPointR, distFromL, distFromR, pos );
		setupValues( t, 1, gridPointD, gridPointU, distFromD, distFromU, pos );

		/*opt:
		t = pos[0] + NOISE_LARGE_PWR2;
		gridPointL = (cast(int)t) & NOISE_MOD_MASK;
		gridPointR = (gridPointL + 1) & NOISE_MOD_MASK;
		distFromL = t - cast(int)t;
		distFromR = distFromL - 1.0;

		t = pos[1] + NOISE_LARGE_PWR2;
		gridPointD = (cast(int)t) & NOISE_MOD_MASK;
		gridPointU = (gridPointD + 1) & NOISE_MOD_MASK;
		distFromD = t - cast(int)t;
		distFromU = distFromD - 1.0;*/
		/*
		writefln("t:", t);
		writefln("gridPointL:", gridPointL);
		writefln("gridPointR:", gridPointR);
		writefln("gridPointD:", gridPointD);
		writefln("gridPointU:", gridPointU);
		writefln("distFromL:", distFromL);
		writefln("distFromR:", distFromR);
		writefln("distFromD:", distFromD);
		writefln("distFromU:", distFromU);
*/
		// Generate some temporary indexes associated with the left and right grid values
		indexL = permutationTable[ gridPointL ];
		indexR = permutationTable[ gridPointR ];
/*
		writefln("indexL:", indexL);
		writefln("indexR:", indexR);
*/
		// Generate indexes in the permutation table for all 4 corners
		indexLD = permutationTable[ indexL + gridPointD ];
		indexRD = permutationTable[ indexR + gridPointD ];
		indexLU = permutationTable[ indexL + gridPointU ];
		indexRU = permutationTable[ indexR + gridPointU ];
/*
		writefln("indexLD:", indexLD);
		writefln("indexRD:", indexRD);
		writefln("indexLU:", indexLU);
		writefln("indexRU:", indexRU);
*/
		// Get the s curves at the proper values
		sX = distFromL * distFromL * (3.0 - 2.0 * distFromL);
		//sX = easeCurve( distFromL );
		sY = distFromD * distFromD * (3.0 - 2.0 * distFromD);
		//sY = easeCurve( distFromD );
/*
		writefln("sX:", sX);
		writefln("sY:", sY);
*/
		// Do the dot products for the lower left corner and lower right corners.
		// Interpolate between those dot products value sX to get a.
		//q = gradientTable2d[ indexLD ]; u = dot2( distFromL, distFromD, q );
		//q = gradientTable2d[ indexRD ]; v = dot2( distFromR, distFromD, q );
		//a = linearInterp( sX, u, v );
		q = cast(float*)gradientTable2d[ indexLD ];
		//writefln("q0:", q[0], "q1:", q[1]);
		u = distFromL * q[0] + distFromD * q[1];//dot2( distFromL, distFromD, q );
		//writefln("u:", u);
		q = cast(float*)gradientTable2d[ indexRD ];
		//writefln("q0:", q[0], "q1:", q[1]);
		v = distFromR * q[0] + distFromD * q[1];//dot2( distFromR, distFromD, q );
		//writefln("v:", v);
		a = u + sX * (v - u);//linearInterp( sX, u, v );
		//writefln("a:", a);

		// Do the dot products for the upper left corner and upper right corners.
		// Interpolate between those dot products at value sX to get b.
		//q = gradientTable2d[ indexLU ]; u = dot2( distFromL, distFromU, q );
		//q = gradientTable2d[ indexRU ]; v = dot2( distFromR, distFromU, q );
		//b = linearInterp( sX, u, v );
		q = cast(float*)gradientTable2d[ indexLU ];
		//writefln("q0:", q[0], "q1:", q[1]);
		u = distFromL * q[0] + distFromU * q[1];//dot2( distFromL, distFromU, q );
		//writefln("u:", u);
		q = cast(float*)gradientTable2d[ indexRU ];
		//writefln("q0:", q[0], "q1:", q[1]);
		v = distFromR * q[0] + distFromU * q[1];//dot2( distFromR, distFromU, q );
		//writefln("v:", v);
		b = u + sX * (v - u);//linearInterp( sX, u, v );
		//writefln("b:", b);
		// Interpolate between a and b at value sY to get the noise return value.
		//writefln("return:", linearInterp( sY, a, b ));
		return a + sY * (b - a);//linearInterp( sY, a, b );
	}

	// you guessed it -- 3D coherent noise

	float noise3d( float pos[ 3 ] )
	{
		int gridPointL, gridPointR, gridPointD, gridPointU, gridPointB, gridPointF;
		int indexLD, indexLU, indexRD, indexRU;
		float distFromL, distFromR, distFromD, distFromU, distFromB, distFromF;
		float* q;
		float sX, sY, sZ, a, b, c, d, t, u, v;
		uint indexL, indexR;

		if ( ! initialized ) { reseed(); }

		// find out neighboring grid points to pos and signed distances from pos to them.
		//old:setupValues( &t, 0, &gridPointL, &gridPointR, &distFromL, &distFromR, pos );
		//old:setupValues( &t, 1, &gridPointD, &gridPointU, &distFromD, &distFromU, pos );
		//old:setupValues( &t, 2, &gridPointB, &gridPointF, &distFromB, &distFromF, pos );
		setupValues( t, 0, gridPointL, gridPointR, distFromL, distFromR, pos );
		setupValues( t, 1, gridPointD, gridPointU, distFromD, distFromU, pos );
		setupValues( t, 2, gridPointB, gridPointF, distFromB, distFromF, pos );
		/*opt:
		t = pos[0] + NOISE_LARGE_PWR2;
		gridPointL = (cast(int)t) & NOISE_MOD_MASK;
		gridPointR = (gridPointL + 1) & NOISE_MOD_MASK;
		distFromL = t - cast(int)t;
		distFromR = distFromL - 1.0;

		t = pos[1] + NOISE_LARGE_PWR2;
		gridPointD = (cast(int)t) & NOISE_MOD_MASK;
		gridPointU = (gridPointD + 1) & NOISE_MOD_MASK;
		distFromD = t - cast(int)t;
		distFromU = distFromD - 1.0;

		t = pos[2] + NOISE_LARGE_PWR2;
		gridPointB = (cast(int)t) & NOISE_MOD_MASK;
		gridPointF = (gridPointB + 1) & NOISE_MOD_MASK;
		distFromB = t - cast(int)t;
		distFromF = distFromB - 1.0;
		*/
		indexL = permutationTable[ gridPointL ];
		indexR = permutationTable[ gridPointR ];

		indexLD = permutationTable[ indexL + gridPointD ];
		indexRD = permutationTable[ indexR + gridPointD ];
		indexLU = permutationTable[ indexL + gridPointU ];
		indexRU = permutationTable[ indexR + gridPointU ];

		sX = distFromL * distFromL * (3.0 - 2.0 * distFromL);//easeCurve( distFromL );
		sY = distFromD * distFromD * (3.0 - 2.0 * distFromD);//easeCurve( distFromD );
		sZ = distFromB * distFromB * (3.0 - 2.0 * distFromB);//easeCurve( distFromB );

		q = cast(float*)gradientTable3d[ indexLD + gridPointB ]; u = distFromL * q[0] + distFromD * q[1] + distFromB * q[2];//dot3( distFromL, distFromD, distFromB, q );
		q = cast(float*)gradientTable3d[ indexRD + gridPointB ]; v = distFromR * q[0] + distFromD * q[1] + distFromB * q[2];//dot3( distFromR, distFromD, distFromB, q );
		a = u + sX * (v - u);//linearInterp( sX, u, v );

		q = cast(float*)gradientTable3d[ indexLU + gridPointB ]; u = distFromL * q[0] + distFromU * q[1] + distFromB * q[2];//dot3( distFromL, distFromU, distFromB, q );
		q = cast(float*)gradientTable3d[ indexRU + gridPointB ]; v = distFromR * q[0] + distFromU * q[1] + distFromB * q[2];//dot3( distFromR, distFromU, distFromB, q );
		b = u + sX * (v - u);//linearInterp( sX, u, v );

		c = a + sY * (b - a);//linearInterp( sY, a, b );

		q = cast(float*)gradientTable3d[ indexLD + gridPointF ]; u = distFromL * q[0] + distFromD * q[1] + distFromF * q[2];//dot3( distFromL, distFromD, distFromF, q );
		q = cast(float*)gradientTable3d[ indexRD + gridPointF ]; v = distFromR * q[0] + distFromD * q[1] + distFromF * q[2];//dot3( distFromR, distFromD, distFromF, q );
		a = u + sX * (v - u);//linearInterp( sX, u, v );

		q = cast(float*)gradientTable3d[ indexLU + gridPointF ]; u = distFromL * q[0] + distFromU * q[1] + distFromF * q[2];//dot3( distFromL, distFromU, distFromF, q );
		q = cast(float*)gradientTable3d[ indexRU + gridPointF ]; v = distFromR * q[0] + distFromU * q[1] + distFromF * q[2];//dot3( distFromR, distFromU, distFromF, q );
		b = u + sX * (v - u);//linearInterp( sX, u, v );

		d = a + sY * (b - a);//linearInterp( sY, a, b );

		return c + sZ * (d - c);//linearInterp( sZ, c, d );
	}

	// you can call noise component-wise, too.

	float noise( float x )
	{
		float p[ 1 ];
		p[0] = x;
		return noise1d( p );
	}

	float noise( float x, float y )
	{
		//writefln("x:", x);
		//writefln("y:", y);
		float p[ 2 ];// = { x, y };
		p[0] = x;
		p[1] = y;
		return noise2d( p );
	}

	float noise( float x, float y, float z )
	{
		float p[ 3 ];// = { x, y, z };
		p[0] = x;
		p[1] = y;
		p[2] = z;
		return noise3d( p );
	}

	// reinitialize with new, random values.

	void reseed()
	{
		if(random is null) random = new Random();
		random.seed();
		//writefln("noise.reseed()");
		//srand( cast(uint) ( std.date.getUTCtime() + rand() ) );
		//rand_seed(cast(uint) ( std.date.getUTCtime() + rand() ), 0);
		generateLookupTables();
	}

	// reinitialize using a user-specified random seed.

	void reseed( uint rSeed )
	{
		if(random is null) random = new Random();
		random.seed(rSeed);
		//srand( rSeed );
		//rand_seed(rSeed, 0);
		generateLookupTables();
		
	}

	// initialize everything during constructor or reseed -- note
	// that space was already allocated for the gradientTable
	// during the constructor

	void generateLookupTables()
	{
		//debug(2) writefln("PerlinNoise.generateLookupTables() START.");
		uint i, j, temp;

		if(random is null) random = new Random();

		//for( uint k = 0; k < 10; k++ )
		//writefln("randNoiseFloat()", randNoiseFloat());

		for ( i = 0; i < NOISE_WRAP_INDEX; i++ )
		{
			// put index into permutationTable[index], we will shuffle later
			permutationTable[ i ] = i;
			//writefln(" perm_i:", permutationTable[ i ]);

			gradientTable1d[ i ] = randNoiseFloat();
			//writefln("gradientTable_i:", gradientTable1d[ i ]);

			for ( j = 0; j < 2; j++ )
			{
				gradientTable2d[ i ][ j ] = randNoiseFloat();
				//writefln(" grad1d_ij:", gradientTable2d[ i ][ j ]);
			}
			normalize2d( gradientTable2d[ i ] );
			//writefln(" norm_grad1d_i:", gradientTable1d[ i ]);
			//writef(" normgrad1d j:", gradientTable2d[ i ][ j ]);

			for ( j = 0; j < 3; j++ )
			{
				gradientTable3d[ i ][ j ] = randNoiseFloat();
				//writefln(" grad3d_ij:", gradientTable3d[ i ][ j ]);

			}
			normalize3d( gradientTable3d[ i ] );
		}

		// Shuffle permutation table up to NOISE_WRAP_INDEX
		for ( i = 0; i < NOISE_WRAP_INDEX; i++ )
		{
			j = 3 & NOISE_MOD_MASK;
			//RANDOM HACK
			//j = random.next() & NOISE_MOD_MASK;
			temp = permutationTable[ i ];
			permutationTable[ i ] = permutationTable[ j ];
			permutationTable[ j ] = temp;
			//writefln("permshuffle_i:", permutationTable[ i ]);
		}

		// Add the rest of the table entries in, duplicating
		// indices and entries so that they can effectively be indexed
		// by unsigned chars.  I think.  Ask Perlin what this is really doing.
		//
		// This is the only part of the algorithm that I don't understand 100%.

		for ( i = 0; i < NOISE_WRAP_INDEX + 2; i++ )
		{
			permutationTable[ NOISE_WRAP_INDEX + i ] = permutationTable[ i ];

			gradientTable1d[ NOISE_WRAP_INDEX + i ] = gradientTable1d[ i ];


			for ( j = 0; j < 2; j++ )
			{
				gradientTable2d[ NOISE_WRAP_INDEX + i ][ j ] = gradientTable2d[ i ][ j ];
				//writefln("grad2d_ij:", gradientTable2d[ i ][ j ]);
			}

			for ( j = 0; j < 3; j++ )
			{
				gradientTable3d[ NOISE_WRAP_INDEX + i ][ j ] = gradientTable3d[ i ][ j ];
				//writefln("j:", j, " grad3d_ij:", gradientTable3d[ i ][ j ]);
			}
		}

		// And we're done. Set initialized to true
		initialized = 1;
	}

	// ----------------------------------------------------------------------------------------------------
	// ----------------------------------------------------------------------------------------------------
	/*float
	PerlinNoise::Turbulence( Vec3f &p, int oct, bool hard ) {

	Vec3f tp = p;
	float f_tp[ 3 ] = { tp.x, tp.y, tp.z };

	float val, amp = 1.0, sum = 0.0;
	for ( int i = 0;i < oct;i++, amp *= 0.5, tp *= 2.0 ) {
	val = Noise3d( f_tp );
	if ( hard ) val = fabs( val );
	sum += amp * val;
	}
	return 0.5 + 0.5*( sum * ( ( float ) ( 1 ,  oct ) / ( float ) ( ( 1 ,  ( oct + 1 ) ) - 1 ) ) );
	}*/
//}



version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    }
}
