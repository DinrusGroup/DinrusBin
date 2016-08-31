/*==========================================================================
 * VHierarchyNode.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/****************************************************************************
 * <TODO: Module Summary>
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

module auxd.OpenMesh.Tools.VDPM.VHierarchyNode;

//== IMPORTS  =================================================================

import auxd.OpenMesh.Core.Geometry.VectorT;
import auxd.OpenMesh.Core.Mesh.Handles;
import auxd.OpenMesh.Tools.VDPM.VHierarchyNodeIndex;
import auxd.OpenMesh.Tools.Utils.ListT;
import std.math;

//== CLASS DEFINITION =========================================================

	      
/** Handle for vertex hierarchy nodes  
 */
struct VHierarchyNodeHandle
{
    mixin auxd.OpenMesh.Core.Mesh.Handles.HandleMixin!();
}


/// Invalid handle
static const VHierarchyNodeHandle InvalidVHierarchyNodeHandle;


/** Vertex hierarchy node
 *  \todo Complete documentation
 */
class VHierarchyNode
{
public:

    this() { }

    /// Returns true, if node is root else false.
    bool is_root() /*const*/
    { return (parent_handle_.is_valid == false) ? true : false; }

    /// Returns true, if node is leaf else false.
    bool is_leaf() /*const*/
    { return (lchild_handle_.is_valid == false) ? true : false; }
  
    /// Returns parent handle.
    VHierarchyNodeHandle parent_handle() { return parent_handle_; }
  
    /// Returns handle to left child.
    VHierarchyNodeHandle lchild_handle() { return lchild_handle_; }

    /// Returns handle to right child.
    VHierarchyNodeHandle rchild_handle() 
    { return VHierarchyNodeHandle(lchild_handle_.idx+1); }

    void set_parent_handle(VHierarchyNodeHandle _parent_handle)
    { parent_handle_ = _parent_handle; }

    void set_children_handle(VHierarchyNodeHandle _lchild_handle)
    { lchild_handle_ = _lchild_handle; }

    VertexHandle vertex_handle() /*const*/                  { return vh_; }
    float radius() /*const*/                                { return radius_; }
    /*const ref*/ Vec3f normal() /*const*/                  { return normal_; }
    float sin_square() /*const*/                            { return sin_square_; }
    float mue_square() /*const*/                            { return mue_square_; }
    float sigma_square() /*const*/                          { return sigma_square_; }

    void set_vertex_handle(VertexHandle _vh)                { vh_     = _vh; }
    void set_radius(float _radius)                          { radius_ = _radius; }
    void set_normal(/*const */ ref Vec3f _normal)           { normal_ = _normal; }
  
    void set_sin_square(float _sin_square)      { sin_square_ = _sin_square; }
    void set_mue_square(float _mue_square)      { mue_square_ = _mue_square; }
    void set_sigma_square(float _sigma_square)  { sigma_square_ = _sigma_square; }
  
    void set_semi_angle(float _semi_angle) 
    { float f=sin(_semi_angle); sin_square_ = f*f; }

    void set_mue(float _mue)                        { mue_square_ = _mue * _mue; }
    void set_sigma(float _sigma)              { sigma_square_ = _sigma * _sigma; }

    /*const ref*/ VHierarchyNodeIndex node_index() /*const*/         { return  node_index_; }
    /*const ref*/ VHierarchyNodeIndex fund_lcut_index() /*const*/ 
    { return  fund_cut_node_index_[0]; }

    /*const ref*/ VHierarchyNodeIndex fund_rcut_index() /*const*/
    { return  fund_cut_node_index_[1]; }

    VHierarchyNodeIndex* node_index_ptr()
    { return  &node_index_; }

    VHierarchyNodeIndex* fund_lcut_index_ptr()   { return  &fund_cut_node_index_[0]; }
    VHierarchyNodeIndex* fund_rcut_index_ptr()   { return  &fund_cut_node_index_[1]; }

    void set_index(/*const ref*/ VHierarchyNodeIndex _node_index)
    { node_index_ = _node_index; }

    void set_fund_lcut(/*const ref*/ VHierarchyNodeIndex _node_index)
    { fund_cut_node_index_[0] = _node_index; }

    void set_fund_rcut(/*const ref*/ VHierarchyNodeIndex _node_index)
    { fund_cut_node_index_[1] = _node_index; }

private:
    VertexHandle            vh_;
    float                   radius_;
    Vec3f                   normal_;
    float                   sin_square_;
    float                   mue_square_;
    float                   sigma_square_;

    VHierarchyNodeHandle    parent_handle_;
    VHierarchyNodeHandle    lchild_handle_;


    VHierarchyNodeIndex     node_index_;
    VHierarchyNodeIndex[2]  fund_cut_node_index_;
}

/// Container for vertex hierarchy nodes
alias VHierarchyNode[]         VHierarchyNodeContainer;

/// Container for vertex hierarchy node handles
alias VHierarchyNodeHandle[]   VHierarchyNodeHandleContainer;

/// Container for vertex hierarchy node handles
alias ListT!(VHierarchyNodeHandle)  VHierarchyNodeHandleList;



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
