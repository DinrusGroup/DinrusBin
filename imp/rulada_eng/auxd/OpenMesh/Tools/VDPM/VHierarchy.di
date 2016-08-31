/*==========================================================================
 * VHierarchy.d
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

module auxd.OpenMesh.Tools.VDPM.VHierarchy;


//== INCLUDES =================================================================

import auxd.OpenMesh.Core.Geometry.VectorT;
public import auxd.OpenMesh.Core.Mesh.Handles : VertexHandle;
import auxd.OpenMesh.Tools.VDPM.VHierarchyNode;
import auxd.OpenMesh.Tools.VDPM.VHierarchyNodeIndex;

//== CLASS DEFINITION =========================================================

	      
/** Keeps the vertex hierarchy built during analyzing a progressive mesh.
 */
class VHierarchy
{
public:

    alias uint    id_t; /// Type for tree and node ids

private:

    VHierarchyNodeContainer nodes_;
    uint            n_roots_;
    ubyte           tree_id_bits_; // node_id_bits_ = 32-tree_id_bits_;

public:
  
    this() { clear(); }

    void clear()                    { nodes_.length=0;   n_roots_ = 0; }
    ubyte tree_id_bits() /*const*/  { return tree_id_bits_; }
    uint num_roots() /*const*/      { return n_roots_; }
    uint num_nodes() /*const*/      { return nodes_.length; }

    VHierarchyNodeIndex generate_node_index(id_t _tree_id, id_t _node_id)
    {
        return  VHierarchyNodeIndex.make(_tree_id, _node_id, tree_id_bits_);
    }


    void set_num_roots(uint _n_roots) {
        n_roots_ = _n_roots;
  
        tree_id_bits_ = 0;
        while (n_roots_ > (0x00000001u << tree_id_bits_))
            ++tree_id_bits_;

    }
  
    VHierarchyNodeHandle root_handle(uint i) /*const*/
    {
        return  VHierarchyNodeHandle( i );
    }


    /+
    /*const ref*/ VHierarchyNode node(VHierarchyNodeHandle _vhierarchynode_handle) /*const*/
    {
        return nodes_[_vhierarchynode_handle.idx];
    }+/


    VHierarchyNode node(VHierarchyNodeHandle _vhierarchynode_handle)
    {
        return nodes_[_vhierarchynode_handle.idx];
    }

    VHierarchyNodeHandle add_node()
    { return  add_node(new VHierarchyNode); }

    VHierarchyNodeHandle add_node(/*const ref*/ VHierarchyNode _node)
    {
        nodes_ ~= _node;

        return  VHierarchyNodeHandle(nodes_.length - 1);
    }

    void make_children(VHierarchyNodeHandle _parent_handle)
    {
        VHierarchyNodeHandle lchild_handle = add_node();
        VHierarchyNodeHandle rchild_handle = add_node();    

        VHierarchyNode parent = node(_parent_handle);
        VHierarchyNode lchild = node(lchild_handle);
        VHierarchyNode rchild = node(rchild_handle);

        parent.set_children_handle(lchild_handle);
        lchild.set_parent_handle(_parent_handle);
        rchild.set_parent_handle(_parent_handle);

        lchild.set_index(VHierarchyNodeIndex.make(
                             parent.node_index.tree_id(tree_id_bits_), 
                             2*parent.node_index.node_id(tree_id_bits_), 
                             tree_id_bits_));
        rchild.set_index(VHierarchyNodeIndex.make(
                             parent.node_index.tree_id(tree_id_bits_),
                             2*parent.node_index.node_id(tree_id_bits_)+1,
                             tree_id_bits_));
    }

    bool is_ancestor(VHierarchyNodeIndex _ancestor_index, 
                     VHierarchyNodeIndex _descendent_index)
    {
        if (_ancestor_index.tree_id(tree_id_bits_) != _descendent_index.tree_id(tree_id_bits_))
            return  false;

        uint ancestor_node_id = _ancestor_index.node_id(tree_id_bits_);
        uint descendent_node_id = _descendent_index.node_id(tree_id_bits_);

        if (ancestor_node_id > descendent_node_id)
            return  false;

        while (descendent_node_id > 0)
        {
            if (ancestor_node_id == descendent_node_id)
                return  true;
            descendent_node_id >>= 1;       // descendent_node_id /= 2
        }

        return  false;
    }
  
    bool is_leaf_node(VHierarchyNodeHandle _node_handle)  
    { return nodes_[_node_handle.idx].is_leaf; }

    bool is_root_node(VHierarchyNodeHandle _node_handle)  
    { return nodes_[_node_handle.idx].is_root; }


    /*const*/ Vec3f normal(VHierarchyNodeHandle _node_handle) /*const*/ 
    {
        return  nodes_[_node_handle.idx].normal; 
    }

    /+
    /*const*/ VHierarchyNodeIndex 
    node_index(VHierarchyNodeHandle _node_handle) /*const*/
    { return  nodes_[_node_handle.idx].node_index; }

    /*const*/ VHierarchyNodeIndex 
    fund_lcut_index(VHierarchyNodeHandle _node_handle) /*const*/
    { return  nodes_[_node_handle.idx].fund_lcut_index; }

    /*const*/ VHierarchyNodeIndex 
    fund_rcut_index(VHierarchyNodeHandle _node_handle) /*const*/
    { return  nodes_[_node_handle.idx].fund_rcut_index; }
    +/

    VHierarchyNodeIndex node_index(VHierarchyNodeHandle _node_handle)
    { return  nodes_[_node_handle.idx].node_index; }

    VHierarchyNodeIndex fund_lcut_index(VHierarchyNodeHandle _node_handle)
    { return  nodes_[_node_handle.idx].fund_lcut_index; }

    VHierarchyNodeIndex fund_rcut_index(VHierarchyNodeHandle _node_handle)
    { return  nodes_[_node_handle.idx].fund_rcut_index; }     
  
    VertexHandle  vertex_handle(VHierarchyNodeHandle _node_handle)
    { return  nodes_[_node_handle.idx].vertex_handle; }

    VHierarchyNodeHandle  parent_handle(VHierarchyNodeHandle _node_handle)
    { return nodes_[_node_handle.idx].parent_handle; }

    VHierarchyNodeHandle  lchild_handle(VHierarchyNodeHandle _node_handle)
    { return nodes_[_node_handle.idx].lchild_handle; }

    VHierarchyNodeHandle  rchild_handle(VHierarchyNodeHandle _node_handle)
    { return nodes_[_node_handle.idx].rchild_handle; }

    VHierarchyNodeHandle  node_handle(VHierarchyNodeIndex _node_index)
    {
        if (_node_index.is_valid(tree_id_bits_) != true)
            return  InvalidVHierarchyNodeHandle;

        VHierarchyNodeHandle node_handle = root_handle(_node_index.tree_id(tree_id_bits_));
        uint node_id = _node_index.node_id(tree_id_bits_);
        uint flag = 0x80000000;

        while (!(node_id & flag))   
            flag >>= 1;
        flag >>= 1;

        while (flag > 0 && is_leaf_node(node_handle) != true)
        {
            if (node_id & flag)     // 1: rchild
            {
                node_handle = rchild_handle(node_handle);
            }
            else                    // 0: lchild
            {
                node_handle = lchild_handle(node_handle);
            }
            flag >>= 1;
        }

        return  node_handle;

    }

private:
  
    //VHierarchyNodeHandle compute_dependency(VHierarchyNodeIndex index0, 
    //                                        VHierarchyNodeIndex index1);

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
