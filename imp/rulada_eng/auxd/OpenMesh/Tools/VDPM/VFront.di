/*==========================================================================
 * VFront.d
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

module auxd.OpenMesh.Tools.VDPM.VFront;


//=============================================================================
//
//  CLASS VFront
//
//=============================================================================

//== IMPORTS ==================================================================

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Tools.VDPM.VHierarchyNode;


//== FORWARD DECLARATIONS =====================================================


//== CLASS DEFINITION =========================================================

	      
/** Active nodes in vertex hierarchy.
*/
class VFront
{
private:

    alias VHierarchyNodeHandleList.iterator  VHierarchyNodeHandleListIter;
    enum VHierarchyNodeStatus { kSplit, kActive, kCollapse };
  
    VHierarchyNodeHandleList                    front_;
    VHierarchyNodeHandleListIter                front_it_;
    VHierarchyNodeHandleListIter[]              front_location_;

public:

    this() {}

    void clear() { front_.clear(); front_location_.length=0; }
    void begin() { front_it_ = front_.begin(); }
    bool end()   { return (front_it_ == front_.end) ? true : false; }
    void next()  { ++front_it_; }
    uint length()   { return front_.length; }
    alias length size;
    VHierarchyNodeHandle node_handle()    { return  front_it_.val; }

    void add(VHierarchyNodeHandle _node_handle) {
        front_location_[_node_handle.idx] = front_.append(_node_handle);
    }
    void remove(VHierarchyNodeHandle _node_handle)
    {
        VHierarchyNodeHandleListIter node_it = front_location_[_node_handle.idx];
        VHierarchyNodeHandleListIter next_it = front_.erase(node_it);
        front_location_[_node_handle.idx()] = front_.end();

        if (front_it_ == node_it)
            front_it_ = next_it;

    }
    bool is_active(VHierarchyNodeHandle _node_handle)
    {
        return  (front_location_[_node_handle.idx] != front_.end) ? true : false;

    }
    void init(VHierarchyNodeHandleContainer _roots, uint _n_details)
    {
        front_location_.length = _roots.length + 2*_n_details;

        foreach(fl; front_location_)
            fl = front_.end;

        foreach(r; _roots)
            add(r);

    }
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
