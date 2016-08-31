//============================================================================
// ModRoundnessT.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 28 Aug 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 *      Based on OpenMesh (C++) http://www.openmesh.org
 *      Copyright (C) 2001-2003 by Computer Graphics Group, RWTH Aachen
 * License:
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

module auxd.OpenMesh.Tools.Decimater.ModRoundnessT;

/** \file ModRoundnessT.hh
    
 */

//=============================================================================
//
//  CLASS ModRoundnessT
//
//=============================================================================


//== INCLUDES =================================================================

import auxd.OpenMesh.Tools.Decimater.ModBaseT;
import math=auxd.OpenMesh.Core.Geometry.MathDefs;
import auxd.OpenMesh.Core.Utils.vector_cast;
import auxd.OpenMesh.Core.Utils.vector_traits;
import util=auxd.OpenMesh.Core.Utils.Std;

//== CLASS DEFINITION =========================================================


/** Compute error value based on roundness criteria.
 */
class ModRoundnessT(DecimaterType) : public ModBaseT!(DecimaterType)
{
  public:
    mixin DECIMATING_MODULE!( DecimaterType, "Roundness" );

  public:

    // aliass
    alias Mesh.Point                      Point;
    alias vector_traits!(Point).value_type value_type;

  public:
   
    /// Constructor
    this( DecimaterType _dec ) {
        super(_dec, false); 
        min_r_=(-1.0);
    }
 
    /// Destructor
    ~this() { }

  public: // inherited
   
    /** Compute collapse priority due to roundness of triangle.
     *
     *  The roundness is computed by dividing the radius of the
     *  circumference by the length of the shortest edge. The result is
     *  normalized.  
     *
     * \return [0:1] or ILLEGAL_COLLAPSE in non-binary mode
     * \return LEGAL_COLLAPSE or ILLEGAL_COLLAPSE in binary mode
     * See_Also: set_min_roundness()
     */
    float collapse_priority(/*const*/ ref CollapseInfo _ci)  
    {    
//     using namespace OpenMesh;

        auto voh_it = Mesh.ConstVertexOHalfedgeIter(super.mesh(), _ci.v0);
        double                                  r;
        double                                  priority = 0.0; //==LEGAL_COLLAPSE
        Mesh.FaceHandle               fhC, fhB;
        Vec3f                                   B,C;
    
        if ( min_r_ < 0.0 ) // continues mode
        {      
            C   = vector_cast!(Vec3f)(super.mesh().point( super.mesh().to_vertex_handle(voh_it.handle)));
            fhC = super.mesh().face_handle( voh_it.handle() );

            for (++voh_it; voh_it.is_active; ++voh_it) 
            {
                B   = C;
                fhB = fhC;
                C   = vector_cast!(Vec3f)(super.mesh().point(super.mesh().to_vertex_handle(voh_it.handle)));
                fhC = super.mesh().face_handle( voh_it.handle() );

                if ( fhB == _ci.fl || fhB == _ci.fr )
                    continue;
      
                // simulate collapse using position of v1
                r = roundness( vector_cast!(Vec3f)(_ci.p1), B, C );
      
                // return the maximum non-roundness
                priority = util.max( priority, (1.0-r) );

            }
        }
        else // binary mode
        {
            C   = vector_cast!(Vec3f)(super.mesh().point( super.mesh().to_vertex_handle(voh_it.handle)));
            fhC = super.mesh().face_handle( voh_it.handle() );

            for (++voh_it; voh_it.is_active && (priority==super.LEGAL_COLLAPSE); ++voh_it) 
            {
                B   = C;
                fhB = fhC;
                C   = vector_cast!(Vec3f)(super.mesh().point(super.mesh().to_vertex_handle(voh_it.handle)));
                fhC = super.mesh().face_handle( voh_it.handle() );

                if ( fhB == _ci.fl || fhB == _ci.fr )
                    continue;

                priority = ( (r=roundness( vector_cast!(Vec3f)(_ci.p1), B, C )) < min_r_)
                    ? super.ILLEGAL_COLLAPSE 
                    : super.LEGAL_COLLAPSE;
            }
        }

        return cast(float) priority;
    }
  
   

  public: // specific methods

    void set_min_angle( float _angle, bool _binary=true )
    {
        assert( _angle > 0 && _angle < 60 );
        alias math.cos cos;
        alias math.sin sin;

        _angle = cast(float)(math.PI * _angle /180.0);

        Vec3f A,B,C;

        A = Vec3f(             0, 0,           0);
        B = Vec3f( 2*cos(_angle), 0,           0);
        C = Vec3f(   cos(_angle), sin(_angle), 0);

        double r1 = roundness(A,B,C);

        _angle = cast(float)(0.5 * ( math.PI - _angle ));

        A = Vec3f(             0, 0,           0);
        B = Vec3f( 2*cos(_angle), 0,           0);
        C = Vec3f(   cos(_angle), sin(_angle), 0);

        double r2 = roundness(A,B,C);

        set_min_roundness( cast(value_type)util.min(r1,r2), true ); 
    }

    /** Set a minimum roundness value.
     *  \param _min_roundness in range (0,1)
     *  \param _binary Set true, if the binary mode should be enabled, 
     *                 else false. In latter case the collapse_priority()
     *                 returns a float value if the constrain does not apply
     *                 and ILLEGAL_COLLAPSE else.
     */
    void set_min_roundness( value_type _min_roundness, bool _binary=true )
    {
        assert( 0.0 <= _min_roundness && _min_roundness <= 1.0 );
        min_r_  = _min_roundness;
        super.set_binary(_binary);
    }

    /// Unset minimum value constraint and enable non-binary mode.
    void unset_min_roundness()
    {
        min_r_  = -1.0;
        super.set_binary(false);
    }

    // Compute a normalized roundness of a triangle ABC
    //
    // Having
    //   A,B,C corner points of triangle
    //   a,b,c the vectors BC,CA,AB
    //   Area  area of triangle
    //
    // then define
    //
    //      radius of circumference 
    // R := -----------------------
    //      length of shortest edge
    //
    //       ||a|| * ||b|| * ||c||    
    //       ---------------------
    //             4 * Area                 ||a|| * ||b|| * ||c||
    //    = ----------------------- = -----------------------------------
    //      min( ||a||,||b||,||c||)   4 * Area * min( ||a||,||b||,||c|| )
    //
    //                      ||a|| * ||b|| * ||c||
    //    = -------------------------------------------------------
    //      4 *  1/2 * ||cross(B-A,C-A)||  * min( ||a||,||b||,||c|| )
    //
    //                         a'a * b'b * c'c
    // R^2 = ----------------------------------------------------------
    //       4 * cross(B-A,C-A)'cross(B-A,C-A) * min( a'a, b'b, c'c )
    //
    //                      a'a * b'b * c'c
    // R = 1/2 * sqrt(---------------------------)
    //                 AA * min( a'a, b'b, c'c )
    //
    // At angle 60-degrees R has it's minimum for all edge lengths = sqrt(1/3)
    //
    // Define normalized roundness 
    //
    // nR := sqrt(1/3) / R
    //
    //                         AA * min( a'a, b'b, c'c )
    //     = sqrt(4/3) * sqrt(---------------------------)
    //                              a'a * b'b * c'c
    //
    double roundness( /*const*/ ref Vec3f A, /*const*/ ref Vec3f B, /*const*/ ref Vec3f C )
    {
        value_type epsilon = cast(value_type)1e-15;

        value_type sqrt43 = cast(value_type)math.sqrt(4.0/3.0); // 60-deg,a=b=c, **)    

        Vec3f vecAC     = C-A;
        Vec3f vecAB     = B-A;

        // compute squared values to avoid sqrt-computations
        value_type aa = (B-C).sqrnorm();
        value_type bb = vecAC.sqrnorm();
        value_type cc = vecAB.sqrnorm();
        value_type AA = cross(vecAC,vecAB).sqrnorm(); // without factor 1/4   **)

        if ( AA < epsilon )
            return 0.0;

        double nom   = AA * util.min( util.min(aa,bb),cc );
        double denom = aa * bb * cc;    
        double nR    = sqrt43 * math.sqrt(nom/denom);

        return nR;
    }

private:
  
    value_type min_r_;
}


unittest {
    
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
