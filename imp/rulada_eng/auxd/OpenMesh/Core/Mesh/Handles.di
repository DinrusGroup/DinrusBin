//============================================================================
// Handles.d - 
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

module auxd.OpenMesh.Core.Mesh.Handles;

//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.config;
static import std.string;


//== CLASS DEFINITION =========================================================


/// Base class for all handle types
template HandleMixin()
{ 
public:
  
    alias typeof(*this) Self;

    static Self opCall(int _idx=-1) { 
        Self M; with(M) {
            idx_=_idx; 
        } return M;
    }

    /// Get the underlying index of this handle
    int idx() /*const*/ { return idx_; }

    /// The handle is valid iff the index is not equal to -1.
    bool is_valid() /*const*/ { return idx_ != -1; }

    /// reset handle to be invalid
    void reset() { idx_=-1; }
    /// reset handle to be invalid
    void invalidate() { idx_ = -1; }

    bool opEquals(ref Self _rhs) { 
        return idx_ == _rhs.idx_; 
    }

    int opCmp(Self* _rhs) {
        if (idx_==_rhs.idx_) return 0;
        else return (idx_ < _rhs.idx_) ? -1 : 1;
    }
    int opCmp(Self _rhs) {
        return opCmp(&_rhs);
    }

    // this is to be used only by the iterators
    void __increment() { ++idx_; }
    void __decrement() { --idx_; }

    string toString() {
        return std.string.format(idx_);
    }

private:

    int idx_ = -1; 
}


//-----------------------------------------------------------------------------

// Original code used struct inheritance and trivially derived 
// the handle types from BaseHandle.
// Here we make them distinct types by using a mixin for the guts.
// TODO: could we use a typedef here instead?
// TODO: D2.0 is supposed to fix this limitation of D structs at some point.

/// Handle for a vertex entity
struct VertexHandle {
    mixin HandleMixin!();
}

/// Handle for a halfedge entity
struct HalfedgeHandle {
    mixin HandleMixin!();
}


/// Handle for a edge entity
struct EdgeHandle {
    mixin HandleMixin!();
}


/// Handle for a face entity
struct FaceHandle {
    mixin HandleMixin!();
}


unittest {
    VertexHandle x = 10;
    auto y = VertexHandle(15);
    assert(std.string.format(x) == "10");
    assert(std.string.format(y) == "15");
    assert(x<y);
    assert(y>x);
    y.__increment();
    x.__decrement();
    assert(std.string.format(x) == "9");
    assert(std.string.format(y) == "16");

    VertexHandle z = x;
    assert(std.string.format(z.idx()) == "9");
    
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
