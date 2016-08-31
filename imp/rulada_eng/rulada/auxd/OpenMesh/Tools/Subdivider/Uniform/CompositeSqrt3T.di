//============================================================================
// CompositeSqrt3T.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 02 Sep 2007
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

module auxd.OpenMesh.Tools.Subdivider.Uniform.CompositeSqrt3T;

/** \file CompositeSqrt3T.hh
    
 */

//=============================================================================
//
//  CLASS SQRT3T
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Tools.Subdivider.Uniform.Composite.CompositeT;
import auxd.OpenMesh.Tools.Subdivider.Uniform.Composite.CompositeTraits;

import math=auxd.OpenMesh.Core.Geometry.MathDefs;

//== CLASS DEFINITION =========================================================

/** Uniform composite sqrt(3) subdivision algorithm
 */
class CompositeSqrt3T(MeshType,RealType=float) : CompositeT!(MeshType, RealType)
{
  public:

    this() { super(); coeffs_=new FVCoeff(); }
    this(MeshType _mesh) { super(_mesh); coeffs_= new FVCoeff(); }

  public:
   
    /*const*/ string name() /*const*/ { return "Uniform Composite Sqrt3"; }

  protected: // inherited interface

    void apply_rules()  
    {
        super.Tvv3(); 
        super.VF(); 
        super.FF(); 
        super.FVc(coeffs_); 
    }

  protected:
   
    alias typeof(super).Coeff Coeff;

    /** Helper class
     *  \internal
     */
    class FVCoeff :  Coeff
    {
        this() {
            init(50); 
        }

        void init(size_t _max_valence)
        {
            weights_.length = _max_valence;
            compute_weight comp; 
            foreach(ref w; weights_) { w = comp(); }
        }
    
        double opCall(size_t _valence) { return weights_[_valence]; }

        /** \internal
         */
        struct compute_weight 
        {
            double opCall() // sqrt(3) weights for non-boundary vertices
            { 
                return 2.0/3.0 * (math.cos(2.0*math.PI/val_++)+1.0); 
            }
            size_t val_ = 0;
        };

        double[] weights_;
    
    } 
    FVCoeff coeffs_;

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
