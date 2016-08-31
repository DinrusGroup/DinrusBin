//============================================================================
// CompositeTraits.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 02 Sep 2007
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
//============================================================================

/** 
    Mesh traits for uniform composite subdivision.
 */
module auxd.OpenMesh.Tools.Subdivider.Uniform.Composite.CompositeTraits;


//=============================================================================
//
//  CLASS Traits
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Core.Mesh.Traits;
import auxd.OpenMesh.Core.Mesh.Attributes;


//== CLASS DEFINITION =========================================================
	      

/** Uniform Composite Subdivision framework.
*/

class CompositeTraits : DefaultTraits
{
    const uint FaceAttributes = AttributeBits.Normal;
    
    const uint VertexAttributes =  AttributeBits.Normal;
  
    //HalfedgeAttributes( auxd.OpenMesh.Attributes.PrevHalfedge );

    //FaceTraits
    struct FaceT(Base, Refs) //: Base
    {
      private:
        alias Refs.HalfedgeHandle HalfedgeHandle;
        alias Refs.Scalar Scalar;
        alias Refs.Point Point;
        HalfedgeHandle red_halfedge_handle_;
        uint generation_;
        bool red_;
        Scalar quality_;
        Point midpoint_;
        Point position_;
    
      public:
        /*const*/ uint generation() { return generation_; }
        void set_generation(/*const*/ uint _g) { generation_ = _g; }
        void inc_generation() { ++generation_; }
        void set_red() { red_ = 1; }
        void set_green() {red_ = 0; }
        bool is_red() { return red_; }
        bool is_green() { return !red_; }
        void set_red_halfedge_handle(HalfedgeHandle _heh) 
        { red_halfedge_handle_ = _heh; }
        HalfedgeHandle red_halfedge_handle() { return red_halfedge_handle_; }
        void set_quality(Scalar _q) { quality_ = _q; }
        Scalar quality() { return quality_; }
        /*const*/ Point midpoint() /*const*/ { return midpoint_; }
        void set_midpoint(/*const*/ ref Point _p) { midpoint_ = _p; }
        /*const*/ Point position() /*const*/ { return position_; }
        void set_position(/*const*/ ref Point _p) { position_ = _p; }
    }

    //EdgeTraits
    struct EdgeT(Base, Refs) //: Base
    {
      private:
        alias Refs.Point Point;
        alias Refs.Scalar Scalar;
        Point midpoint_;
        Scalar length_;
        Point position_;
      public: 
        /*const*/ Point midpoint() /*const*/ { return midpoint_; }
        void set_midpoint(/*const*/ ref Point _vh) { midpoint_ = _vh; }
        /*const*/ Scalar length() /*const*/ { return length_; }
        void set_length(/*const*/ ref Scalar _s) { length_ = _s; }
        /*const*/ Point position() /*const*/ { return position_; }
        void set_position(/*const*/ ref Point _p) { position_ = _p; }
    }

    //VertexTraits
    struct VertexT(Base, Refs) //: Base
    {
      private:
        alias Refs.Point Point;
        Point new_pos_;
        Point orig_pos_;
        Point position_;
        uint generation_;
      public:
        /*const*/ Point new_pos() /*const*/ { return new_pos_; }
        void set_new_pos(/*const*/ ref Point _p) { new_pos_ = _p; }
        /*const*/ uint generation() /*const*/ { return generation_; }
        void set_generation(/*const*/ ref uint _i) { generation_ = _i; }
        /*const*/ Point orig_pos() /*const*/ { return orig_pos_; }
        void set_orig_pos(/*const*/ ref Point _p) { orig_pos_ = _p; }
        /*const*/ Point position() /*const*/ { return position_; }
        void set_position(/*const*/ ref Point _p) { position_ = _p; }
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
