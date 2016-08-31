//============================================================================
// LoopT.d - 
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

module auxd.OpenMesh.Tools.Subdivider.Uniform.LoopT;


/** \file LoopT.hh

 */

//=============================================================================
//
//  CLASS LoopT
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Core.System.config;
public import auxd.OpenMesh.Tools.Subdivider.Uniform.SubdividerT;
import auxd.OpenMesh.Core.Utils.vector_cast;
import auxd.OpenMesh.Core.Utils.Property;
import math = auxd.OpenMesh.Core.Geometry.MathDefs;
debug {
    import auxd.OpenMesh.Tools.Utils.MeshCheckerT;
}

//== CLASS DEFINITION =========================================================

/** %Uniform Loop subdivision algorithm.
 *
 *  Implementation as described in
 *
 *  C. T. Loop, "Smooth Subdivision Surfaces Based on Triangles",
 *  M.S. Thesis, Department of Mathematics, University of Utah, August 1987.
 *
 */
class LoopT(MeshType,RealType=float) : SubdividerT!(MeshType, RealType)
{
  public:

    alias RealType                               real_t;
    alias MeshType                               mesh_t;
    alias SubdividerT!( mesh_t, real_t )         parent_t;

    struct Pair{ 
        static Pair opCall(real_t w1, real_t w2) {
            Pair P; P.first = w1; P.second = w2; return P;
        }
        real_t first,second; 
    }
    alias Pair                                   weight_t;
    alias Pair[]                                 weights_t;

  public:


    this() {
        super(); _1over8 = ( 1.0/8.0 ); _3over8 = ( 3.0/8.0 );
        init_weights();
    }


    this( mesh_t _m ) {
        super(_m); _1over8=( 1.0/8.0 ); _3over8=( 3.0/8.0 );
        init_weights(); 
    }


  public:


    /*const*/ string name() /*const*/ { return "Uniform Loop"; }


    /// Pre-compute weights
    void init_weights(size_t _max_valence=50)
    {
        weights_.length = _max_valence;
        compute_weight cw;
        foreach(ref w; weights_) { w = cw(); }
    }


protected:


    bool prepare( mesh_t _m )
    {
        _m.add_property( vp_pos_ );
        _m.add_property( ep_pos_ );
        return true;
    }


    bool cleanup( mesh_t _m )
    {
        _m.remove_property( vp_pos_ );
        _m.remove_property( ep_pos_ );
        return true;
    }


    bool subdivide( mesh_t _m, size_t _n)
    {
        mesh_t.FaceIter   fit, f_end;
        mesh_t.EdgeIter   eit, e_end;
        mesh_t.VertexIter vit;

        // Do _n subdivisions
        for (size_t i=0; i < _n; ++i)
        {
            // compute new positions for old vertices
            for ( vit  = _m.vertices_begin();
                  vit != _m.vertices_end(); ++vit)
                smooth( _m, vit.handle() );


            // Compute position for new vertices and store them in the edge property
            for (eit=_m.edges_begin(); eit != _m.edges_end(); ++eit)
                compute_midpoint( _m, eit.handle() );


            // Split each edge at midpoint and store precomputed positions (stored in
            // edge property ep_pos_) in the vertex property vp_pos_;

            // Attention! Creating new edges, hence make sure the loop ends correctly.
            e_end = _m.edges_end();
            for (eit=_m.edges_begin(); eit != e_end; ++eit)
                split_edge(_m, eit.handle() );


            // Commit changes in topology and reconsitute consistency

            // Attention! Creating new faces, hence make sure the loop ends correctly.
            f_end   = _m.faces_end();
            for (fit = _m.faces_begin(); fit != f_end; ++fit)
                split_face(_m, fit.handle() );


            // Commit changes in geometry
            for ( vit  = _m.vertices_begin();
                  vit != _m.vertices_end(); ++vit)
                _m.set_point(vit.handle, *_m.property_ptr( vp_pos_, vit.handle ) );

            debug {
                // Now we have an consistent mesh!
                assert( MeshCheckerT!(mesh_t)(_m).check() );
            }
        }

        return true;
    }

private:

    /// Helper functor to compute weights for Loop-subdivision
    /// \internal
    struct compute_weight
    {
        weight_t opCall()
        {
            //              1
            // alpha(n) = ---- * (40 - ( 3 + 2 cos( 2 Pi / n ) )^2   )
            //             64

            if (++valence)
            {
                double   inv_v  = 1.0/cast(double)valence;
                double   t      = (3.0 + 2.0 * math.cos( 2.0 * math.PI * inv_v) );
                double   alpha  = (40.0 - t * t)/64.0;

                return weight_t( 1.0-alpha, inv_v*alpha);
            }
            return weight_t(0.0, 0.0);
        }
        int valence = -1;
    };

private: // topological modifiers

    void split_face(mesh_t _m, /*const ref*/ mesh_t.FaceHandle _fh)
    {
        mesh_t.HalfedgeHandle
            heh1 = (_m.halfedge_handle(_fh)),
            heh2 = (_m.next_halfedge_handle(_m.next_halfedge_handle(heh1))),
            heh3 = (_m.next_halfedge_handle(_m.next_halfedge_handle(heh2)));

        // Cutting off every corner of the 6_gon
        corner_cutting( _m, heh1 );
        corner_cutting( _m, heh2 );
        corner_cutting( _m, heh3 );
    }


    void corner_cutting(mesh_t _m, /*const ref*/ mesh_t.HalfedgeHandle _he)
    {
        // Define Halfedge Handles
        mesh_t.HalfedgeHandle
            heh1 = (_he),
            heh5 = (heh1),
            heh6 = (_m.next_halfedge_handle(heh1));

        // Cycle around the polygon to find correct Halfedge
        for (; _m.next_halfedge_handle(_m.next_halfedge_handle(heh5)) != heh1;
             heh5 = _m.next_halfedge_handle(heh5))
        {}

        mesh_t.VertexHandle
            vh1 = _m.to_vertex_handle(heh1),
            vh2 = _m.to_vertex_handle(heh5);

        mesh_t.HalfedgeHandle
            heh2 = (_m.next_halfedge_handle(heh5)),
            heh3 = (_m.new_edge( vh1, vh2)),
            heh4 = (_m.opposite_halfedge_handle(heh3));

        /* Intermediate result
         *
         *            *
         *         5 /|\
         *          /_  \
         *    vh2> *     *
         *        /|\3   |\
         *       /_  \|4   \
         *      *----\*----\*
         *          1 ^   6
         *            vh1 (adjust_outgoing halfedge!)
         */

        // Old and new Face
        mesh_t.FaceHandle     fh_old=(_m.face_handle(heh6));
        mesh_t.FaceHandle     fh_new=(_m.new_face());


        // Re-Set Handles around old Face
        _m.set_next_halfedge_handle(heh4, heh6);
        _m.set_next_halfedge_handle(heh5, heh4);

        _m.set_face_handle(heh4, fh_old);
        _m.set_face_handle(heh5, fh_old);
        _m.set_face_handle(heh6, fh_old);
        _m.set_halfedge_handle(fh_old, heh4);

        // Re-Set Handles around new Face
        _m.set_next_halfedge_handle(heh1, heh3);
        _m.set_next_halfedge_handle(heh3, heh2);

        _m.set_face_handle(heh1, fh_new);
        _m.set_face_handle(heh2, fh_new);
        _m.set_face_handle(heh3, fh_new);

        _m.set_halfedge_handle(fh_new, heh1);
    }


    void split_edge(mesh_t _m, /*const ref */ mesh_t.EdgeHandle _eh)
    {
        mesh_t.HalfedgeHandle
            heh     = _m.halfedge_handle(_eh, 0),
            opp_heh = _m.halfedge_handle(_eh, 1);

        mesh_t.HalfedgeHandle new_heh, opp_new_heh, t_heh;
        mesh_t.VertexHandle   vh;
        mesh_t.VertexHandle   vh1 = (_m.to_vertex_handle(heh));
        auto                  zero = mesh_t.Point(0,0,0);

        // new vertex
        vh                = _m.new_vertex( zero );

        // memorize position, will be set later
        *_m.property_ptr( vp_pos_, vh ) = *_m.property_ptr( ep_pos_, _eh );


        // Re-link mesh entities
        if (_m.is_boundary(_eh))
        {
            for (t_heh = heh;
                 _m.next_halfedge_handle(t_heh) != opp_heh;
                 t_heh = _m.opposite_halfedge_handle(_m.next_halfedge_handle(t_heh)))
            {}
        }
        else
        {
            for (t_heh = _m.next_halfedge_handle(opp_heh);
                 _m.next_halfedge_handle(t_heh) != opp_heh;
                 t_heh = _m.next_halfedge_handle(t_heh) )
            {}
        }

        new_heh     = _m.new_edge(vh, vh1);
        opp_new_heh = _m.opposite_halfedge_handle(new_heh);
        _m.set_vertex_handle( heh, vh );

        _m.set_next_halfedge_handle(t_heh, opp_new_heh);
        _m.set_next_halfedge_handle(new_heh, _m.next_halfedge_handle(heh));
        _m.set_next_halfedge_handle(heh, new_heh);
        _m.set_next_halfedge_handle(opp_new_heh, opp_heh);

        if (_m.face_handle(opp_heh).is_valid())
        {
            _m.set_face_handle(opp_new_heh, _m.face_handle(opp_heh));
            _m.set_halfedge_handle(_m.face_handle(opp_new_heh), opp_new_heh);
        }

        _m.set_face_handle( new_heh, _m.face_handle(heh) );
        _m.set_halfedge_handle( vh, new_heh);
        _m.set_halfedge_handle( _m.face_handle(heh), heh );
        _m.set_halfedge_handle( vh1, opp_new_heh );

        // Never forget this, when playing with the topology
        _m.adjust_outgoing_halfedge( vh );
        _m.adjust_outgoing_halfedge( vh1 );
    }

private: // geometry helper

    void compute_midpoint(mesh_t _m, /*const ref */ mesh_t.EdgeHandle _eh)
    {
        mesh_t.HalfedgeHandle heh, opp_heh;

        heh      = _m.halfedge_handle( _eh, 0);
        opp_heh  = _m.halfedge_handle( _eh, 1);

        mesh_t.Point
            pos = (_m.point(_m.to_vertex_handle(heh)));

        alias vector_cast!(mesh_t.Normal) V;
        pos += V( _m.point(_m.to_vertex_handle(opp_heh)) );

        // boundary edge: just average vertex positions
        if (_m.is_boundary(_eh) )
        {
            pos *= 0.5;
        }
        else // inner edge: add neighbouring Vertices to sum
        {
            pos *= cast(real_t)(3.0);
            pos += V(_m.point(_m.to_vertex_handle(_m.next_halfedge_handle(heh))));
            pos += V(_m.point(_m.to_vertex_handle(_m.next_halfedge_handle(opp_heh))));
            pos *= _1over8;
        }
        *_m.property_ptr( ep_pos_, _eh ) = pos;
    }


    void smooth(mesh_t _m, /*const ref */ mesh_t.VertexHandle _vh)
    {
        auto pos    = mesh_t.Point(0.0, 0.0, 0.0);

        if (_m.is_boundary(_vh)) // if boundary: Point 1-6-1
        {
            mesh_t.HalfedgeHandle heh, prev_heh;
            heh      = _m.halfedge_handle( _vh );

            if ( heh.is_valid() )
            {
                assert( _m.is_boundary( _m.edge_handle( heh ) ) );

                prev_heh = _m.prev_halfedge_handle( heh );

                mesh_t.VertexHandle
                    to_vh   = _m.to_vertex_handle( heh ),
                    from_vh = _m.from_vertex_handle( prev_heh );

                // ( v_l + 6 v + v_r ) / 8
                pos  = _m.point( _vh );
                pos *= cast(real_t)(6.0);
                pos += vector_cast!( mesh_t.Normal )( _m.point( to_vh ) );
                pos += vector_cast!( mesh_t.Normal )( _m.point( from_vh ) );
                pos *= _1over8;

            }
            else
                return;
        }
        else // inner vertex: (1-a) * p + a/n * Sum q, q in one-ring of p
        {
            alias mesh_t.Normal   Vec;
            mesh_t.VertexVertexIter vvit;
            size_t                            valence=(0);

            // Calculate Valence and sum up neighbour points
            for (vvit=_m.vv_iter(_vh); vvit.is_active; ++vvit) {
                ++valence;
                pos += vector_cast!( Vec )( _m.point(vvit.handle) );
            }
            pos *= weights_[valence].second; // alpha(n)/n * Sum q, q in one-ring of p
            pos += weights_[valence].first
                * vector_cast!(Vec)(_m.point(_vh)); // + (1-a)*p
        }

        *_m.property_ptr( vp_pos_, _vh ) = pos;
    }

private: // data

    VPropHandleT!( mesh_t.Point ) vp_pos_;
    EPropHandleT!( mesh_t.Point ) ep_pos_;

    weights_t     weights_;

    /*const*/ real_t _1over8;
    /*const*/ real_t _3over8;

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
