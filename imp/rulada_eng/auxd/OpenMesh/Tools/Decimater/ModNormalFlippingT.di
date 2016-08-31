//============================================================================
// ModNormalFlippingT.d - 
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

module auxd.OpenMesh.Tools.Decimater.ModNormalFlippingT;


/** \file ModNormalFlippingT.hh
    
 */

//=============================================================================
//
//  CLASS ModNormalFlipping
//
//=============================================================================


//== INCLUDES =================================================================

import auxd.OpenMesh.Tools.Decimater.ModBaseT;
import auxd.OpenMesh.Core.Geometry.VectorT;
import math = auxd.OpenMesh.Core.Geometry.MathDefs;

//== CLASS DEFINITION =========================================================

/** Decimating module to avoid flipping of faces.
 *  
 *  This module can be used only as a binary module. The criterion
 *  of allowing/disallowing the collapse is the angular deviation between
 *  the face normal of the orignal faces and normals of the faces after the
 *  collapse. The collapse will pass the test, if the deviation is below
 *  a given threshold.
 */	      
class ModNormalFlippingT(DecimaterT) : public ModBaseT!( DecimaterT )
{ 
  public:

    mixin DECIMATING_MODULE!( DecimaterT, "NormalFlipping" );

  public:
  
    /// Constructor
    this( DecimaterT _dec) 
    {
        super(_dec, true); 
        set_max_normal_deviation( 90.0f );
    }
  

  public:
  
    /** Compute collapse priority due to angular deviation of face normals
     *  before and after a collapse.
     *
     *  -# Compute for each adjacent face of \c _ci.v0 the face
     *  normal if the collpase would be executed.  
     *
     *  -# Prevent the collapse, if the angle between the original and the
     *  new normal is below a given threshold.
     *  
     *  \param _ci The collapse description
     *  \return LEGAL_COLLAPSE or ILLEGAL_COLLAPSE
     *
     *  See_Also: set_max_normal_deviation()
     */
    float collapse_priority(/*const*/ ref CollapseInfo _ci)
    {
        // simulate collapse
        super.mesh().set_point(_ci.v0, _ci.p1);
    
        // check for flipping normals
        auto vf_it = Mesh.ConstVertexFaceIter(super.mesh(), _ci.v0);
        Mesh.FaceHandle          fh;
        Mesh.Scalar              c=1.0;
    
        for (; vf_it.is_active; ++vf_it) 
        {
            fh = vf_it.handle();
            if (fh != _ci.fl && fh != _ci.fr)
            {
                Mesh.Normal n1 = super.mesh().normal(fh);
                Mesh.Normal n2 = super.mesh().calc_face_normal(fh);

                c = dot(n1, n2);
        
                if (c < min_cos_)
                    break;
            }
        }
      
        // undo simulation changes
        super.mesh().set_point(_ci.v0, _ci.p0);

        return cast(float)( (c < min_cos_) ? super.ILLEGAL_COLLAPSE : super.LEGAL_COLLAPSE );
    }



public:
   
  /// get normal deviation
  float max_normal_deviation() /*const*/ { return max_deviation_ / math.PI * 180.0; }
  
  /// \deprecated
  float normal_deviation() /*const*/ { return max_normal_deviation(); }
  
  /** Set normal deviation
   *  
   *  Set the maximum angular deviation of the orignal normal and the new
   *  normal in degrees.
   */
  void set_max_normal_deviation(float _f) { 
    max_deviation_ = _f / 180.0 * math.PI; 
    min_cos_       = math.cos(max_deviation_);
  }

  /// \deprecated
  void set_normal_deviation(float _f) 
  { set_max_normal_deviation(_f); }
  
private:

  // hide this method
  void set_binary(bool _b) {}
   
private:

  // maximum normal deviation
  double max_deviation_, min_cos_;
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
