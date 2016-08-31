//============================================================================
// TriMesh_ArrayKernelT.d - 
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

module auxd.OpenMesh.Core.Mesh.TriMesh_ArrayKernelT;

//=============================================================================
//
//  CLASS TriMesh_ArrayKernelT
//
//=============================================================================


//== INCLUDES =================================================================


import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Mesh.TriConnectivity;
import auxd.OpenMesh.Core.Mesh.Traits;
import auxd.OpenMesh.Core.Mesh.FinalMeshItemsT;
import auxd.OpenMesh.Core.Mesh.AttribKernelT;
import auxd.OpenMesh.Core.Mesh.TriMeshT;


//== CLASS DEFINITION =========================================================


/// Helper class to create a TriMesh-type based on ArrayKernelT
struct TriMesh_ArrayKernel_GeneratorT(Traits)
{
    alias FinalMeshItemsT!(Traits, true)               MeshItems;
    alias AttribKernelT!(MeshItems, TriConnectivity)   AttribKernel;
    alias TriMeshT!(AttribKernel)                      Mesh;
}



/** \ingroup mesh_types_group
    Triangle mesh based on the ArrayKernel.
    See_Also: auxd.OpenMesh.TriMeshT, auxd.OpenMesh.ArrayKernelT
*/
class TriMesh_ArrayKernelT(Traits = DefaultTraits)
    : TriMesh_ArrayKernel_GeneratorT!(Traits).Mesh
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
    //alias DefaultTraits Tr;
    //alias FinalMeshItemsT!(Tr,false) MeshI;
    //alias AttribKernelT!(MeshI, TriConnectivity) AttrKern;
    alias TriMesh_ArrayKernelT!() MyMesh;
    //MyMesh x = new MyMesh;
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
