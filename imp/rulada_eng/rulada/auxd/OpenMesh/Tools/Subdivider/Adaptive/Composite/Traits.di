//============================================================================
// Traits.d - 
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
 */
//============================================================================

module auxd.OpenMesh.Tools.Subdivider.Adaptive.Composite.Traits;


/** \file Traits.hh
    
 */

//=============================================================================
//
//  CLASS Traits
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Core.Mesh.TriMesh_ArrayKernelT;
import auxd.OpenMesh.Core.Mesh.Traits;
import auxd.OpenMesh.Core.Mesh.Attributes;

//== CLASS DEFINITION =========================================================

/** Adaptive Composite Subdivision framework.
 */

// typedef unsigned short state_t;
// const state_t mask_final = 1 << ((sizeof(state_t)*8)-1);
// const state_t mask_state = ~mask_final;

alias int  state_t;
alias bool finale_t;
   
struct State
{
    // Note in C++ this was two bitfields split 31/1
    int   state; // : 31; 
    bool  finale; // : 1;
}
   
class Traits : DefaultTraits
{
   
    // add face normals
    const uint FaceAttributes =  AttributeBits.Normal;
  
    // add vertex normals
    const uint VertexAttributes = AttributeBits.Normal;

    // add previous halfedge handle
    const uint HalfedgeAttributes = AttributeBits.PrevHalfedge;
   
    //FaceTraits
    struct FaceT(Base,Refs) // : Base
    {
      private:

        alias Refs.Point Point;
        alias Refs.HalfedgeHandle HalfedgeHandle;
        alias Point[state_t] PositionHistory;

        State                state_;
        HalfedgeHandle       red_halfedge_;

        PositionHistory      pos_map_;
    
      public:

        // face state
        state_t state() /*const*/ { return cast(state_t)(state_.state); }
        void    set_state(/*const*/ state_t _s) { state_.state = _s; }
        void    inc_state() { ++state_.state; }

        // face not final if divided (loop) or edge not flipped (sqrt(3))
        finale_t finale() /*const*/   { return cast(finale_t)(state_.finale); }
        void    set_finale()     { state_.finale = true; }
        void    set_not_finale() { state_.finale = false; }

        // halfedge of dividing edge (red-green triangulation)
        /*const*/ HalfedgeHandle red_halfedge() /*const*/ { return red_halfedge_; }
        void  set_red_halfedge(/*const*/ HalfedgeHandle _h) { red_halfedge_ = _h; }

        // position of face, depending on generation _i. 
        void set_position(/*const*/ int _i, /*const*/ ref Point _p) { pos_map_[_i] = _p; }
        /*const*/ Point position(/*const*/ int _i) { 
            if (_i in pos_map_)
                return pos_map_[_i];
            else {
                if (_i <= 0) {
                    return Point(0,0,0);
                }

                return position(_i - 1);
            }
        }
    } // end class FaceTraits


    //EdgeTraits
    struct EdgeT(Base,Refs) // : Base
    {

      private:

        alias Refs.Point Point;
        alias Point[state_t] PositionHistory;

        State           state_;
        PositionHistory pos_map_;

      public: 

        alias Refs.Scalar Scalar;

        // Scalar weight_;

        // state of edge
        state_t state() /*const*/ { return cast(state_t)(state_.state); }
        void    set_state(/*const*/ state_t _s) { state_.state = _s; }
        void    inc_state() { ++state_.state; }

        // edge not finale if dividing face (Loop) or edge not flipped (SQRT(3))
        finale_t finale() /*const*/   { return cast(finale_t)(state_.finale); }
        void    set_finale()     { state_.finale = true; }
        void    set_not_finale() { state_.finale = false; }

        // position of edge, depending on generation _i. 
        void set_position(/*const*/ int _i, /*const*/ ref Point _p) { pos_map_[_i] = _p; }
        /*const*/ Point position(/*const*/ int _i) {

            if (_i in pos_map_) 
            {
                return pos_map_[_i];
            }
            else 
            {
                if (_i <= 0) 
                {
                    return Point(0.0,0.0,0.0);
                }

                return position(_i - 1);
            }
        }
    } // end class EdgeTraits


    //VertexTraits
    struct VertexT(Base,Refs) // : Base
    {

      private:

        alias Refs.Point Point;
        alias Point[state_t] PositionHistory;

        State   state_;

        PositionHistory pos_map_;

      public:

        // state of vertex
        state_t state() /*const*/ { return state_.state; }
        void    set_state(/*const*/ state_t _s) { state_.state = _s; }
        void    inc_state() { ++state_.state; }


        // usually not needed by loop or sqrt(3)
        finale_t finale() /*const*/   { return state_.finale; }
        void    set_finale()     { state_.finale = true; }
        void    set_not_finale() { state_.finale = false; }

        // position of vertex, depending on generation _i. (not for display)
        void set_position(/*const*/ int _i, /*const*/ ref Point _p) { pos_map_[_i] = _p; }
        /*const*/ Point position(/*const*/ int _i) { 

            if (_i in pos_map_)

                return pos_map_[_i];

            else {

                if (_i <= 0) {

                    return Point(0.0, 0.0, 0.0);
                }

                return position(_i - 1);
            }
        }
    } // end class VertexTraits
} // end class Traits



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
