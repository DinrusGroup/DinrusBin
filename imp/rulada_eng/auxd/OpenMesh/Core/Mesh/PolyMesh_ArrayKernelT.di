//============================================================================
// PolyMesh_ArrayKernelT.d -
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description:
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 31 Aug 2007
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

module auxd.OpenMesh.Core.Mesh.PolyMesh_ArrayKernelT;

//=============================================================================
//
//  CLASS PolyMesh_ArrayKernelT
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Mesh.PolyConnectivity;
import auxd.OpenMesh.Core.Mesh.Traits;
import auxd.OpenMesh.Core.Mesh.FinalMeshItemsT;
import auxd.OpenMesh.Core.Mesh.AttribKernelT;
import auxd.OpenMesh.Core.Mesh.PolyMeshT;


//== CLASS DEFINITION =========================================================

/// Helper class to build a PolyMesh-type
struct PolyMesh_ArrayKernel_GeneratorT(Traits)
{
    alias FinalMeshItemsT!(Traits, false)              MeshItems;
    alias AttribKernelT!(MeshItems, PolyConnectivity)  AttribKernel;
    alias PolyMeshT!(AttribKernel)                     Mesh;
}


/** \class PolyMesh_ArrayKernelT PolyMesh_ArrayKernelT.hh <OpenMesh/Mesh/Types/PolyMesh_ArrayKernelT.hh>

    \ingroup mesh_types_group
    Polygonal mesh based on the ArrayKernel.
    See_Also: auxd.OpenMesh.PolyMeshT, auxd.OpenMesh.ArrayKernel
*/
class PolyMesh_ArrayKernelT(Traits = DefaultTraits)
    : PolyMesh_ArrayKernel_GeneratorT!(Traits).Mesh
{
    /** Create a fresh copy of this mesh.
        This is a deep copy duplicating all data.
    */
    typeof(this) dup()
    {
        auto ret = new typeof(this);
        ret.copy(this);
        return ret;
    }
}


unittest {
    alias DefaultTraits Tr;
    alias FinalMeshItemsT!(Tr,false) MeshI;
    alias AttribKernelT!(MeshI, PolyConnectivity) AttrKern;
    alias PolyMesh_ArrayKernelT!() MyMesh;
    MyMesh x = new MyMesh;

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
