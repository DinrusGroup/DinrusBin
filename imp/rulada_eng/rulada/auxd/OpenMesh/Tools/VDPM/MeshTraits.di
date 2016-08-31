/*===========================================================================
 * MeshTraits.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/****************************************************************************
 * Mesh traits for View Dependent Progressive Meshes
 *
 * <TODO: Description>
 *
 * Authors:  William V. Baxter III, OLM Digital, Inc.
 * Date: 12 Oct 2007
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
//===========================================================================

module auxd.OpenMesh.Tools.VDPM.MeshTraits;

//=============================================================================
//
//  CLASS VDPMTraits
//
//=============================================================================


//== IMPORTS ==================================================================


import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Mesh.Traits;
import auxd.OpenMesh.Core.Mesh.Attributes;
import auxd.OpenMesh.Tools.VDPM.VHierarchy;

//== FORWARD DECLARATIONS =====================================================


//== CLASS DEFINITION =========================================================

	      
/** 
    Mesh traits for View Dependent Progressive Meshes  
*/

class MeshTraits : DefaultTraits
{
    // VertexTraits
    struct VertexT(Base, Refs) //: Base
    {
      public:

        VHierarchyNodeHandle vhierarchy_node_handle()
        {
            return node_handle_; 
        }

        void set_vhierarchy_node_handle(VHierarchyNodeHandle _node_handle)
        {
            node_handle_ = _node_handle; 
        }
    
        bool is_ancestor(/*const ref*/ VHierarchyNodeIndex _other)
        {
            return false; 
        }

      private:

        VHierarchyNodeHandle  node_handle_;
   
    }
  
    const uint 
        VertexAttributes = AttributeBits.Status | AttributeBits.Normal,
        HalfedgeAttributes = AttributeBits.PrevHalfedge,
        EdgeAttributes  = AttributeBits.Status,
        FaceAttributes = AttributeBits.Status | AttributeBits.Normal;
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
