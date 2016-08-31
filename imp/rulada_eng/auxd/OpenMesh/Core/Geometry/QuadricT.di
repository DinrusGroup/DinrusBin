//============================================================================
// QuadricT.d - 
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

module auxd.OpenMesh.Core.Geometry.QuadricT;

/** \file QuadricT.hh

 */

//=============================================================================
//
//  CLASS QuadricT
//
//=============================================================================


//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Geometry.VectorT;
static import std.string;

//== CLASS DEFINITION =========================================================


/** /class QuadricT QuadricT.hh <OSG/Geometry/Types/QuadricT.hh>

    Stores a quadric as a 4x4 symmetrix matrix. Used by the
    error quadric based mesh decimation algorithms.
**/

struct QuadricT(Scalar)
{
public:
    alias Scalar           value_type;
    alias QuadricT!(Scalar) type;
    alias QuadricT!(Scalar) Self;
    //   alias VectorInterface<Scalar, VecStorage3<Scalar> > Vec3;
    //   alias VectorInterface<Scalar, VecStorage4<Scalar> > Vec4;
    //alias Vector3Elem      Vec3;
    //alias Vector4Elem      Vec4;

    /// construct with upper triangle of symmetrix 4x4 matrix
    static QuadricT opCall(Scalar _a, Scalar _b, Scalar _c, Scalar _d,
                           /*      */ Scalar _e, Scalar _f, Scalar _g,
                           /*                 */ Scalar _h, Scalar _i,
                           /*                            */ Scalar _j)
    {
        QuadricT M; with(M) {
            a_=(_a), b_=(_b), c_=(_c), d_=(_d),
                e_=(_e), f_=(_f), g_=(_g),
                h_=(_h), i_=(_i),
                j_=(_j);
        } return M;
    }


    /// constructor from given plane equation: ax+by+cz+d_=0
    static QuadricT opCall( Scalar _a=0.0, Scalar _b=0.0, Scalar _c=0.0, Scalar _d=0.0 )
    {
        QuadricT M; with(M) {
            a_=(_a*_a), b_=(_a*_b),  c_=(_a*_c),  d_=(_a*_d),
                e_=(_b*_b),  f_=(_b*_c),  g_=(_b*_d),
                h_=(_c*_c),  i_=(_c*_d),
                j_=(_d*_d);
        } return M;
    }

    /// constructor from given plane equation: ax+by+cz+d_=0
    ///          or from distance to a point: x,y,z
    ///          or from upper triangle of 4x4 symmetric matrix.
    static QuadricT opCall( Scalar[] v )
    {
        if (v.length == 10) {
            return QuadricT(v[0],v[1],v[2],v[3],
                            /**/ v[4],v[5],v[6],
                            /**/      v[7],v[8],
                            /**/           v[9]);
        }
        else if (v.length == 4) {
            return QuadricT(v[0],v[1],v[2],v[3]);
        }
        else if (v.length == 3) {
            return from_point(VectorT!(Scalar,3)(v));
        }
        assert(false, "Number of elements must be 3,4, or 10");
    }


    //static QuadricT opCall(_Point)(/*const*/ ref _Point _pt)
    static QuadricT from_point(_Point)(/*const*/ ref _Point _pt)
    {
        QuadricT M; with(M) {
            set_distance_to_point(_pt);
        } return M;
    }


    //QuadricT(_Normal,_Point)(/*const*/ _Normal& _n, /*const*/ _Point& _p)
    static QuadricT from_normal_and_point(_Normal,_Point)(/*const*/ ref _Normal _n, /*const*/ ref _Point _p)
    {
        QuadricT M; with(M) {
            set_distance_to_plane(_n,_p);
        } return M;
    }

    //set operator
    void set(Scalar _a, Scalar _b, Scalar _c, Scalar _d,
             Scalar _e, Scalar _f, Scalar _g,
             Scalar _h, Scalar _i,
             Scalar _j)
    {
        a_ = _a; b_ = _b; c_ = _c; d_ = _d;
        e_ = _e; f_ = _f; g_ = _g;
        h_ = _h; i_ = _i;
        j_ = _j;
    }

    //sets the quadric representing the squared distance to _pt
    void set_distance_to_point(_Point)(/*const*/ ref _Point _pt)
    {
        set(1, 0, 0, -_pt[0],
            1, 0, -_pt[1],
            1, -_pt[2],
            dot(_pt,_pt));
    }

    //sets the quadric representing the squared distance to the plane [_a,_b,_c,_d]
    void set_distance_to_plane(T=void)(Scalar _a, Scalar _b, Scalar _c, Scalar _d)
    {
        a_ = _a*_a; b_ = _a*_b; c_ = _a*_c;  d_ = _a*_d;
        /*       */ e_ = _b*_b; f_ = _b*_c;  g_ = _b*_d;
        /**/                    h_ = _c*_c;  i_ = _c*_d;
        /**/                                 j_ = _d*_d;
    }

    //sets the quadric representing the squared distance to the plane
    //determined by the normal _n and the point _p
    void set_distance_to_plane(_Normal,_Point)(/*const*/ ref _Normal  _n, /*const*/ ref _Point _p)
    {
        set_distance_to_plane(_n[0], _n[1], _n[2], -dot(_n,_p));
    }

    /// set all entries to zero
    void clear()  { a_ = b_ = c_ = d_ = e_ = f_ = g_ = h_ = i_ = j_ = 0.0; }

    /// add quadrics
    void opAddAssign( /*const*/ ref QuadricT _q )
    {
        a_ += _q.a_;  b_ += _q.b_;  c_ += _q.c_;  d_ += _q.d_;
        /**/          e_ += _q.e_;  f_ += _q.f_;  g_ += _q.g_;
        /**/                        h_ += _q.h_;  i_ += _q.i_;
        /**/                                      j_ += _q.j_;
        //return *this;
    }


    /// multiply by scalar
    void opMulAssign( Scalar _s)
    {
        a_ *= _s;  b_ *= _s;  c_ *= _s;  d_ *= _s;
        /**/       e_ *= _s;  f_ *= _s;  g_ *= _s;
        /**/                  h_ *= _s;  i_ *= _s;
        /**/                             j_ *= _s;
        //return *this;
    }


    /// multiply 4D vector from right: Q*v
    _Vec4 opMul(_Vec4)(/*const*/ ref _Vec4 _v) /*const*/
    {
        Scalar x=_v[0], y=_v[1], z=_v[2], w=_v[3];
        return _Vec4(x*a_ + y*b_ + z*c_ + w*d_,
                     x*b_ + y*e_ + z*f_ + w*g_,
                     x*c_ + y*f_ + z*h_ + w*i_,
                     x*d_ + y*g_ + z*i_ + w*j_);
    }

    /// evaluate quadric Q at (3D or 4D) vector v: v*Q*v
    //Scalar opCall(_Vec)(/*const*/ ref _Vec _v) /*const*/
    Scalar eval(_Vec)(/*const*/ ref _Vec _v) /*const*/
    {
        return evaluate!(_Vec,_Vec.size_)(_v);
    }

    Scalar a() /*const*/ { return a_; }
    Scalar b() /*const*/ { return b_; }
    Scalar c() /*const*/ { return c_; }
    Scalar d() /*const*/ { return d_; }
    Scalar e() /*const*/ { return e_; }
    Scalar f() /*const*/ { return f_; }
    Scalar g() /*const*/ { return g_; }
    Scalar h() /*const*/ { return h_; }
    Scalar i() /*const*/ { return i_; }
    Scalar j() /*const*/ { return j_; }

    Scalar xx() /*const*/ { return a_; }
    Scalar xy() /*const*/ { return b_; }
    Scalar xz() /*const*/ { return c_; }
    Scalar xw() /*const*/ { return d_; }
    Scalar yy() /*const*/ { return e_; }
    Scalar yz() /*const*/ { return f_; }
    Scalar yw() /*const*/ { return g_; }
    Scalar zz() /*const*/ { return h_; }
    Scalar zw() /*const*/ { return i_; }
    Scalar ww() /*const*/ { return j_; }

    string toString() {
        return std.string.format("[%s, %s, %s, %s;  %s, %s, %s;  %s, %s;  %s]",
                                 a_,b_,c_,d_,e_,f_,g_,h_,i_,j_);
    }
protected:

    /// evaluate quadric Q at 3D vector v: v*Q*v
    Scalar evaluate(_Vec3,uint N)(/*const*/ref _Vec3 _v) /*const*/
    {
        static if(N==3) {
            Scalar x=_v[0], y=_v[1], z=_v[2];
            return a_*x*x + 2.0*b_*x*y + 2.0*c_*x*z + 2.0*d_*x
                /**/      +     e_*y*y + 2.0*f_*y*z + 2.0*g_*y
                /**/                   +     h_*z*z + 2.0*i_*z
                /**/                                +     j_;
        }
        else static if(N==4) {
            Scalar x=_v[0], y=_v[1], z=_v[2], w=_v[3];
            return a_*x*x + 2.0*b_*x*y + 2.0*c_*x*z + 2.0*d_*x*w
                /**/      +     e_*y*y + 2.0*f_*y*z + 2.0*g_*y*w
                /**/                   +     h_*z*z + 2.0*i_*z*w
                /**/                                +     j_*w*w;
        }
        else {
            static assert(false, "Vector size must be 3 or 4");
        }
    }


private:

    Scalar a_=0, b_=0, c_=0, d_=0,
        /**/     e_=0, f_=0, g_=0,
        /**/           h_=0, i_=0,
        /**/                 j_=0;
}


/// Quadric using floats
alias QuadricT!(float) Quadricf;

/// Quadric using double
alias QuadricT!(double) Quadricd;


import auxd.OpenMesh.Core.Geometry.VectorTypes;

unittest
{
    Quadricf qf;
    Quadricd qd = [1,2,3,4];

    qf.eval(Vec3f(0,1,2));
    qd * Vec4f(0,1,2,4);
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
