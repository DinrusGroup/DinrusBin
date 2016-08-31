//============================================================================
// ModIndependentSetsT.d -
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

module auxd.OpenMesh.Tools.Decimater.ModIndependentSetsT;

/** \file ModQuadricT.hh

 */

//=============================================================================
//
//  CLASS ModQuadricT
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Tools.Decimater.ModBaseT;


//== CLASS DEFINITION =========================================================


/** Lock one-ring around remaining vertex after a collapse to prevent
 *  further collapses of halfedges incident to the one-ring vertices.
 */
class ModIndependentSetsT(DecimaterType) : public ModBaseT!(DecimaterType)
{
  public:
    mixin DECIMATING_MODULE!( DecimaterType, "IndependentSets" );

    /// Constructor
    this( DecimaterType _dec ) {
        super(_dec, true) ;
    }


    /// override
    void postprocess_collapse(/*const*/ref CollapseInfo _ci)
    {
        Mesh.VertexVertexIter vv_it;

        super.mesh().vstatus_ptr(_ci.v1).set_locked(true);
        vv_it = super.mesh().vv_iter(_ci.v1);
        for (; vv_it.is_active; ++vv_it)
            super.mesh().vstatus_ptr(vv_it.handle).set_locked(true);
    }


  private:

    /// hide this method
    void set_binary(bool _b) {}
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
