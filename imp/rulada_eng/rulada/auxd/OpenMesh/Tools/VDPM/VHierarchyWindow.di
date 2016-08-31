/*==========================================================================
 * VHierarchyWindow.d
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

module auxd.OpenMesh.Tools.VDPM.VHierarchyWindow;



//=============================================================================
//
//  CLASS newClass
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Tools.VDPM.VHierarchy;
import auxd.OpenMesh.Tools.VDPM.VHierarchyNode;
import stdutil = auxd.OpenMesh.Core.Utils.Std;


//== CLASS DEFINITION =========================================================

	      
/** 
    VHierarchyWindow
*/
class VHierarchyWindow
{
private:

    /// reference of vertex hierarchy
    VHierarchy    vhierarchy_    = null;

    /// bits buffer (byte units)
    ubyte[]       buffer_        = null;  
    int           buffer_min_    = 0;    /// ditto
    int           buffer_max_    = 0;    /// ditto
    int           current_pos_   = 0;    /// ditto

    /// window (byte units)
    int           window_min_    = 0;
    int           window_max_    = 0;  /// ditto
  

    /// # of right shift (bit units) [0,7]
    ubyte n_shift_               = 0;

    ubyte flag8(ubyte n_shift) /*const*/
    { return 0x80 >> n_shift; }  

    ubyte flag8(VHierarchyNodeHandle _node_handle) /*const*/
    {
        assert(_node_handle.idx >= 0);
        return  0x80 >> (_node_handle.idx % 8);
    }
    int byte_idx(VHierarchyNodeHandle _node_handle) /*const*/
    {
        assert(_node_handle.idx >= 0);
        return  _node_handle.idx / 8;
    }
    int buffer_idx(VHierarchyNodeHandle _node_handle) /*const*/
    { return  byte_idx(_node_handle) - buffer_min_; } 

    bool before_window(VHierarchyNodeHandle _node_handle) /*const*/
    { return (_node_handle.idx/8 < window_min_) ? true : false; }

    bool after_window(VHierarchyNodeHandle _node_handle) /*const*/
    { return (_node_handle.idx/8 < window_max_) ? false : true; }

    bool underflow(VHierarchyNodeHandle _node_handle) /*const*/
    { return (_node_handle.idx/8 < buffer_min_) ? true : false; }

    bool overflow(VHierarchyNodeHandle _node_handle) /*const*/
    { return (_node_handle.idx/8 < buffer_max_) ? false : true; }  

    bool update_buffer(VHierarchyNodeHandle _node_handle) 
    {
        if (underflow(_node_handle) != true && overflow(_node_handle) != true)
            return  false;

        // tightly update window_min_ & window_max_
        int none_zero_pos;
        for (none_zero_pos=buffer_size()-1; none_zero_pos >= 0; --none_zero_pos)
        {
            if (buffer_[none_zero_pos] != 0)  break;
        }
        window_max_ = buffer_min_ + none_zero_pos + 1;
        for(none_zero_pos=0; none_zero_pos < buffer_size(); ++none_zero_pos)
        {
            if (buffer_[none_zero_pos] != 0)  break;
        }
        window_min_ = buffer_min_ + none_zero_pos;
  
        assert(window_min_ < window_max_);
  
        while (underflow(_node_handle) == true)   buffer_min_ /= 2;
        while (overflow(_node_handle) == true)
        {
            buffer_max_ *= 2;
            if (buffer_max_ > vhierarchy_.num_nodes / 8)
                buffer_max_ = (1 + vhierarchy_.num_nodes / 8);
        }
  
        // Feels like there's probably a much cleaner way to do this in D...

        ubyte[] new_buffer; new_buffer.length = buffer_size;
        // new_buffer[] = 0; should be default
        int nb_min = window_min_ - buffer_min_;
        int wsz = window_size();
        new_buffer[nb_min .. nb_min + wsz] = buffer_[none_zero_pos..none_zero_pos+wsz];
            /*
        memcpy(&(new_buffer[window_min_-buffer_min_]), 
               &(buffer_[none_zero_pos]), 
               window_size()); */
        buffer_.length = 0;
        buffer_ = new_buffer;

        return  true;
    }

public:
    this() {
    }

    this(VHierarchy _vhierarchy) {
        vhierarchy_ = _vhierarchy;
    }

    void set_vertex_hierarchy(VHierarchy _vhierarchy)
    { vhierarchy_ = _vhierarchy; }

    void begin()
    {
        int new_window_min = window_min_;
        for (current_pos_=window_min_-buffer_min_; 
             current_pos_ < window_size(); ++current_pos_)
        {
            if (buffer_[current_pos_] == 0)   
                ++new_window_min;
            else
            {
                n_shift_ = 0;
                while ((buffer_[current_pos_] & flag8(n_shift_)) == 0)
                    ++n_shift_;
                break;
            }
        }
        window_min_ = new_window_min;
    }

    void next()
    {
        ++n_shift_;
        if (n_shift_ == 8)
        {
            n_shift_ = 0;
            ++current_pos_;
        }

        while (current_pos_ < window_max_-buffer_min_)
        {
            if (buffer_[current_pos_] != 0) // if the current byte has non-zero bits
            {
                while (n_shift_ != 8)
                {
                    if ((buffer_[current_pos_] & flag8(n_shift_)) != 0)
                        return;                     // find 1 bit in the current byte
                    ++n_shift_;
                }
            }
            n_shift_ = 0;
            ++current_pos_;
        }
    }
    bool end() { return !(current_pos_ < window_max_-buffer_min_); }

    int window_size() /*const*/      { return  window_max_ - window_min_; }
    int buffer_size() /*const*/      { return  buffer_max_ - buffer_min_; }

    VHierarchyNodeHandle node_handle()
    {
        return  VHierarchyNodeHandle(8*(buffer_min_+current_pos_) + n_shift_);
    }

    void activate(VHierarchyNodeHandle _node_handle)
    {
        update_buffer(_node_handle);
        buffer_[buffer_idx(_node_handle)] |= flag8(_node_handle);
        window_min_ = stdutil.min(window_min_, byte_idx(_node_handle));
        window_max_ = stdutil.max(window_max_, 1+byte_idx(_node_handle));
    }


    void inactivate(VHierarchyNodeHandle _node_handle)
    {
        if (is_active(_node_handle) != true)  return;
        buffer_[buffer_idx(_node_handle)] ^= flag8(_node_handle);
    }


    bool is_active(VHierarchyNodeHandle _node_handle) /*const*/
    {
        if (before_window(_node_handle) == true ||
            after_window(_node_handle) == true)
            return  false;
        return ((buffer_[buffer_idx(_node_handle)] & flag8(_node_handle)) > 0);
    }

    void init(ref VHierarchyNodeHandleContainer _roots)
    {
        buffer_.length = 0;

        buffer_min_ = 0;
        buffer_max_ = _roots.length / 8;
        if (_roots.length % 8 > 0)
            ++buffer_max_;

        buffer_.length = buffer_size();
        // buffer_[] = 0;  should be default

        window_min_ = 0;
        window_max_= 0;
        current_pos_ = 0;
        n_shift_ = 0;
  
        foreach(i,r; _roots) {
            activate(VHierarchyNodeHandle(i));
        }
    }

    void update_with_vsplit(VHierarchyNodeHandle _parent_handle)
    {
        VHierarchyNodeHandle  
            lchild_handle = vhierarchy_.lchild_handle(_parent_handle),
            rchild_handle = vhierarchy_.rchild_handle(_parent_handle);

        assert(is_active(_parent_handle) == true);
        assert(is_active(lchild_handle) != true);
        assert(is_active(rchild_handle) != true);

        inactivate(_parent_handle);
        activate(rchild_handle);
        activate(lchild_handle);
    }

    void update_with_ecol(VHierarchyNodeHandle _parent_handle)
    {

        VHierarchyNodeHandle 
            lchild_handle = vhierarchy_.lchild_handle(_parent_handle),
            rchild_handle = vhierarchy_.rchild_handle(_parent_handle);

        assert(is_active(_parent_handle) != true);
        assert(is_active(lchild_handle) == true);
        assert(is_active(rchild_handle) == true);
  
        activate(_parent_handle);
        inactivate(rchild_handle);
        inactivate(lchild_handle);
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
