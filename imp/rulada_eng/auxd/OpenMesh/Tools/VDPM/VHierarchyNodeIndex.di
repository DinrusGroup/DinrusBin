/*==========================================================================
 * VHierarchyNodeIndex.d
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

module auxd.OpenMesh.Tools.VDPM.VHierarchyNodeIndex;

//== CLASS DEFINITION =========================================================

	      
/** Index of vertex hierarchy node
 */
struct VHierarchyNodeIndex
{
private:
    uint value_ = 0;

public:

    static const VHierarchyNodeIndex  InvalidIndex;

public:

    static VHierarchyNodeIndex make(
        uint   _tree_id, 
        uint   _node_id, 
        ushort _tree_id_bits)
    {
        VHierarchyNodeIndex R; with (R) {
            assert(_tree_id < (0x00000001u << _tree_id_bits));
            assert(_node_id < (0x00000001u << (32 - _tree_id_bits)));
            value_ = (_tree_id << (32 - _tree_id_bits)) | _node_id;
        } return R;
    }

    bool is_valid(ushort _tree_id_bits) /*const*/
    { return  node_id(_tree_id_bits) != 0 ? true : false;  }

    uint tree_id(ushort _tree_id_bits) /*const*/
    { return  value_ >> (32 - _tree_id_bits); }
  
    uint node_id(ushort _tree_id_bits) /*const*/
    { return  value_ & (0xFFFFFFFFu >> _tree_id_bits); }

    int opCmp(VHierarchyNodeIndex other) /*const*/
    { return  (value_ < other.value_) ? true : false; }

    uint value() /*const*/
    { return  value_; }
}


/// Container for vertex hierarchy node indices
alias VHierarchyNodeIndex[]    VHierarchyNodeIndexContainer;



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
