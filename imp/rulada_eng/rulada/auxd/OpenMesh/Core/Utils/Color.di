/*==========================================================================
 * Color.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * <TODO: Module Summary>
 *
 * <TODO: Description>
 *
 * Authors:  William V. Baxter III
 * Date: 11 Nov 2007
 * Copyright: (C) 2007  William Baxter
 */
//===========================================================================

module auxd.OpenMesh.Core.Utils.Color;

import auxd.OpenMesh.Core.Geometry.VectorTypes;
import math=std.math;

alias Vec3ub  Color3ub;
alias Vec3f   Color3f;
alias Vec3d   Color3d;


/** convert hsv color to rgb color 
   From: http://www.cs.rit.edu/~ncs/color/t_convert.html
   HSV and RGB components all on [0,1] interval.
*/
void HSV_to_RGB(/*const*/ref Color3f hsv,  Color3f* rgb)
{
    int i;
    float h = hsv[0]*6.0f; // h sector in [0.0, 6.0]
    float s = hsv[1];
    float v = hsv[2];
    if( s <= 0 ) {
        // achromatic (grey)
        (*rgb)[0]=v;
        (*rgb)[1]=v;
        (*rgb)[2]=v;
        return;
    }

    i = cast(int)math.floor( h );
    float f = h - i;          // fractional part of h
    float p = v * ( 1 - s );
    float q = v * ( 1 - s * f );
    float t = v * ( 1 - s * ( 1 - f ) );

    float r,g,b;
    switch( i ) {
    case 0:
        r = v;
        g = t;
        b = p;
        break;
    case 1:
        r = q;
        g = v;
        b = p;
        break;
    case 2:
        r = p;
        g = v;
        b = t;
        break;
    case 3:
        r = p;
        g = q;
        b = v;
        break;
    case 4:
        r = t;
        g = p;
        b = v;
        break;
    default:        // case 5:
        r = v;
        g = p;
        b = q;
        break;
    }
    (*rgb)[0]=r;
    (*rgb)[1]=g;
    (*rgb)[2]=b;
}

/** convert rgb color to hsv color 
 *   From: http://www.cs.rit.edu/~ncs/color/t_convert.html 
 *   h = [0,1], s = [0,1], v = [0,1]
 *		if s == 0, then h = -1 (undefined)
 */
void RGB_to_HSV(/*const*/ ref Color3f rgb, Color3f *hsv)
{
	float cmin = rgb[0]; 
    if (rgb[1]<cmin) { cmin = rgb[1]; }
    if (rgb[2]<cmin) { cmin = rgb[2]; }

	float cmax = rgb[0]; 
    int   imax = 0;
    if (rgb[1]>cmax) { cmax = rgb[1]; imax=1; }
    if (rgb[2]>cmax) { cmax = rgb[2]; imax=2; }

	(*hsv)[2] = cmax;				// v

	float delta = cmax - cmin;

	if( cmax > 0 )
		(*hsv)[1] = delta / cmax;		// s
	else {
		// rgb = (0,0,0)		// s = 0, v is undefined
		(*hsv)[1] = 0;
		(*hsv)[0] = -1;
		return;
	}

    float h;
	if( 0 == imax )
		h = ( rgb[1] - rgb[2] ) / delta;		// between yellow & magenta
	else if( 1 == imax )
		h = 2. + ( rgb[1] - rgb[0] ) / delta;	// between cyan & yellow
	else
		h = 4. + ( rgb[0] - rgb[1] ) / delta;	// between magenta & cyan

	h /= 6.0;				// [0,1] interval
	if( h < 0 )
		h += 1.0;

    (*hsv)[0] = h;
}



//--- Emacs setup ---
// Local Variables:
// c-basic-offset: 4
// indent-tabs-mode: nil
// End:


version (build) {
    debug {
        pragma(link, "auxd");
    } else {
        pragma(link, "auxd");
    }
}
