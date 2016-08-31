//============================================================================
// MathDefs.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 29 Aug 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 *      Based on OpenMesh (C++) http://www.openmesh.org
 *      Copyright (C) 2001-2003 by Computer Graphics Group, RWTH Aachen
 * License: LGPL 2.1
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public License
 *  as published by the Free Software Foundation, version 2.1.
 *                                                                           
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *                                                                           
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free
 *  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
//============================================================================

module auxd.OpenMesh.Core.Geometry.MathDefs;

public import std.math;

/** comparison operators with user-selected precision control
*/
bool is_zero(T, Real)(/*const*/ T _a, Real _eps)
{ return fabs(_a) < _eps; }

bool is_eq(T1, T2, Real)(/*const*/ T1 a, /*const*/ T2 b, Real _eps)
{ return is_zero(a-b, _eps); }

bool is_gt(T1, T2, Real)(/*const*/ T1 a, /*const*/ T2 b, Real _eps)
{ return (a > b) && !is_eq(a,b,_eps); }

bool is_ge(T1, T2, Real)(/*const*/ T1 a, /*const*/ T2 b, Real _eps)
{ return (a > b) || is_eq(a,b,_eps); }

bool is_lt(T1, T2, Real)(/*const*/ T1 a, /*const*/ T2 b, Real _eps)
{ return (a < b) && !is_eq(a,b,_eps); }

bool is_le(T1, T2, Real)(/*const*/ T1 a, /*const*/ T2 b, Real _eps)
{ return (a < b) || is_eq(a,b,_eps); }

///*const*/ float flt_eps__ = 10*float.epsilon;
///*const*/ double dbl_eps__ = 10*double.epsilon;
/*const*/ float flt_eps__ = 1e-05f;
/*const*/ double dbl_eps__ = 1e-09;

float eps__(float) 
{ return flt_eps__; }

double eps__(double)
{ return dbl_eps__; }

bool is_zero(T)(/*const*/ T a)
{ return is_zero(a, eps__(a)); }

bool is_eq(T1, T2)(/*const*/ T1 a, /*const*/ T2 b)
{ return is_zero(a-b); }

bool is_gt(T1, T2)(/*const*/ T1 a, /*const*/ T2 b)
{ return (a > b) && !is_eq(a,b); }

bool is_ge(T1, T2)(/*const*/ T1 a, /*const*/ T2 b)
{ return (a > b) || is_eq(a,b); }

bool is_lt(T1, T2)(/*const*/ T1 a, /*const*/ T2 b)
{ return (a < b) && !is_eq(a,b); }

bool is_le(T1, T2)(/*const*/ T1 a, /*const*/ T2 b)
{ return (a < b) || is_eq(a,b); }

/// Trigonometry/angles - related

T sane_aarg(T)(T _aarg)
{
  if (_aarg < -1)
  {
    _aarg = -1;
  }
  else if (_aarg >  1)
  {
    _aarg = 1;
  }
  return _aarg;
}

/** returns the angle determined by its cos and the sign of its sin
    result is positive if the angle is in [0:pi]
    and negative if it is in [pi:2pi]
*/
T angle(T)(T _cos_angle, T _sin_angle)
{//sanity checks - otherwise acos will return nan
  _cos_angle = sane_aarg(_cos_angle);
  return cast(T) _sin_angle >= 0 ? acos(_cos_angle) : -acos(_cos_angle);
}

T positive_angle(T)(T _angle)
{ return _angle < 0 ? (2*PI + _angle) : _angle; }

T positive_angle(T)(T _cos_angle, T _sin_angle)
{ return positive_angle(angle(_cos_angle, _sin_angle)); }

T deg_to_rad(T)(/*const*/ T _angle)
{ return PI*(_angle/180); }

T rad_to_deg(T)(/*const*/ T _angle)
{ return 180*(_angle/PI); }

unittest {
    
    is_zero(2.0, 1e-3);
    is_eq(1.,2.,1e-3);
    is_gt(1.,2.,1e-3);
    is_ge(1.,2.,1e-3);
    is_lt(1.,2,1e-3);
    is_le(1.,2.,1e-3);

    eps__(32.0f) ;
    eps__(32.0);

    is_zero(1.2);
    is_eq(1.,2.);
    is_gt(1.,2.);
    is_ge(1.,2.);
    is_lt(1.,2.);
    is_le(1.,2.);

    sane_aarg(3.2);
    angle(cos(1.0), sin(1.0));

    positive_angle(-1.2);

    positive_angle(cos(1.0),sin(1.0));

    deg_to_rad(1.0);
    rad_to_deg(1.0);

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
