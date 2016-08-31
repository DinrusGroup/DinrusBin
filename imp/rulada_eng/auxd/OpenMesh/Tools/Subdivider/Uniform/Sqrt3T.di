//============================================================================
// Sqrt3T.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 11 Oct 2007
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

module auxd.OpenMesh.Tools.Subdivider.Uniform.Sqrt3T;

/** \file Sqrt3T.hh
    
 */

//=============================================================================
//
//  CLASS Sqrt3T
//
//=============================================================================

//== IMPORTS =================================================================

import auxd.OpenMesh.Core.Mesh.Handles;
import auxd.OpenMesh.Core.Utils.Property;
import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Tools.Subdivider.Uniform.SubdividerT;
import Std=auxd.OpenMesh.Core.Utils.Std : pair;

import std.math;

debug {
    // Makes life lot easier, when playing/messing around with low-level topology
    // changing methods of OpenMesh
    import  auxd.OpenMesh.Tools.Utils.MeshCheckerT;
    void ASSERT_CONSISTENCY(mesh_t) ( mesh_t m ) {
        assert(MeshCheckerT!(mesh_t)(m).check());
    }
}
else 
{
    void ASSERT_CONSISTENCY(mesh_t) ( mesh_t m ) {}
}

//== CLASS DEFINITION =========================================================


/** %Uniform Sqrt3 subdivision algorithm
 *
 *  Implementation as described in
 *
 *  L. Kobbelt, <a href="http://www-i8.informatik.rwth-aachen.de/publications/downloads/sqrt3.pdf">"Sqrt(3) subdivision"</a>, Proceedings of SIGGRAPH 2000.
 */
class Sqrt3T(MeshType,RealType=float) : public SubdividerT!( MeshType, RealType )
{
  public:

    alias RealType                           real_t;
    alias MeshType                           mesh_t;
    alias SubdividerT!( mesh_t, real_t )     parent_t;

    alias Std.pair!(real_t, real_t)          weight_t;
    alias weight_t[]                         weights_t;

  public:


    this()
    { 
        super();
        _1over3 =  1.0/3.0;
        _1over27 = 1.0/27.0;
        init_weights();
    }

    this(MeshType _m) {
        super(_m);
        _1over3 = 1.0/3.0;
        _1over27 = 1.0/27.0;
        init_weights();
    }

  public:


    string name() /*const*/ { return "Uniform Sqrt3"; }

  
    /// Pre-compute weights
    void init_weights(size_t _max_valence=50)
    {
        weights_.length = _max_valence;
        compute_weight cmp_wt;
        foreach(ref v; weights_) { v = cmp_wt(); }
    }


  protected:


    bool prepare( MeshType _m )
    {
        with (_m) {
            request_edge_status();
            add_property( vp_pos_ );
            add_property( ep_nv_ );
            add_property( mp_gen_ );
            *property_ptr( mp_gen_ ) = 0;

            return has_edge_status() && vp_pos_.is_valid() 
                &&   ep_nv_.is_valid() && mp_gen_.is_valid();
        }
    }


    bool cleanup( MeshType _m )
    {
        with (_m) {
            release_edge_status();
            remove_property( vp_pos_ );
            remove_property( ep_nv_ );
            add_property( mp_gen_ );
        }
        return true;
    }


    bool subdivide( MeshType _m, size_t _n )
    {
        MeshType.VertexIter       vit;
        MeshType.VertexVertexIter vvit;
        MeshType.EdgeIter         eit;
        MeshType.FaceIter         fit;
        MeshType.FaceVertexIter   fvit;
        MeshType.VertexHandle     vh;
        MeshType.HalfedgeHandle   heh;
        MeshType.Point            pos,zero;
        pos = [0,0,0];
        zero = [0,0,0];
        size_t                    *pgen = _m.property_ptr( mp_gen_ );
        size_t   gen = *pgen;

        for (size_t l=0; l<_n; ++l)
        {
            // tag existing edges
            for (eit=_m.edges_begin(); eit != _m.edges_end();++eit)
            {
                _m.estatus_ptr( eit.handle ).set_tagged( true );
                if ( (gen%2) && _m.is_boundary(eit.handle) )
                    compute_new_boundary_points( _m, eit.handle ); // *) creates new vertices
            }

            // do relaxation of old vertices, but store new pos in property vp_pos_

            for (vit=_m.vertices_begin(); vit!=_m.vertices_end(); ++vit)
            {
                if ( _m.is_boundary(vit.handle) )
                {
                    if ( gen%2 )
                    {
                        heh  = _m.halfedge_handle(vit.handle);
                        if (heh.is_valid()) // skip isolated newly inserted vertices *)
                        {
                            HalfedgeHandle 
                                prev_heh = _m.prev_halfedge_handle(heh);

                            assert( _m.is_boundary(heh     ) );
                            assert( _m.is_boundary(prev_heh) );
            
                            pos  = _m.point(_m.to_vertex_handle(heh));
                            pos += _m.point(_m.from_vertex_handle(prev_heh));
                            pos *= cast(real_t)4.0;

                            pos += cast(real_t)19.0 * _m.point( vit.handle );
                            pos *= _1over27;

                            *_m.property_ptr( vp_pos_, vit.handle ) = pos;
                        }
                    }
                    else
                        *_m.property_ptr( vp_pos_, vit.handle ) = _m.point( vit.handle );
                }
                else
                {
                    size_t valence=0;

                    pos = zero;
                    for ( vvit = _m.vv_iter(vit.handle); vvit.is_active; ++vvit)
                    {
                        pos += _m.point( vvit.handle );
                        ++valence;
                    }
                    pos *= weights_[ valence ].second;
                    pos += weights_[ valence ].first * _m.point(vit.handle);
                    *_m.property_ptr( vp_pos_, vit.handle ) =  pos;
                }
            }   

            // insert new vertices, but store pos in vp_pos_
            MeshType.FaceIter fend = _m.faces_end();
            for (fit = _m.faces_begin();fit != fend; ++fit)
            {
                if ( (gen%2) && _m.is_boundary(fit.handle))
                {
                    boundary_split( _m, fit.handle );
                }
                else
                {
                    fvit = _m.fv_iter( fit.handle );        
                    pos  = _m.point(fvit.handle); ++fvit;
                    pos += _m.point(fvit.handle); ++fvit;
                    pos += _m.point(fvit.handle);
                    pos *= _1over3;
                    vh   = _m.add_vertex( zero );
                    *_m.property_ptr( vp_pos_, vh ) = pos;
                    _m.split( fit.handle, vh );
                }
            }

            // commit new positions (now iterating over all vertices)
            for (vit=_m.vertices_begin();vit != _m.vertices_end(); ++vit)
                _m.set_point(vit.handle, *_m.property_ptr( vp_pos_, vit.handle ) );
      
            // flip old edges
            for (eit=_m.edges_begin(); eit != _m.edges_end(); ++eit)
                if ( _m.estatus_ptr( eit.handle ).tagged() && !_m.is_boundary( eit.handle ) )
                    _m.flip(eit.handle);

            // Now we have an consistent mesh!
            ASSERT_CONSISTENCY( _m );

            // increase generation by one
            ++(*pgen);
            gen = *pgen;
        }
        return true;
    }

  private:

    /// Helper functor to compute weights for sqrt(3)-subdivision
    /// \internal
    struct compute_weight 
    {
        weight_t opCall()
        { 
            if (++valence)
            {
                real_t alpha = (4.0-2.0*cos(2.0*PI / cast(double)valence))/9.0;
                return weight_t( cast(real_t)(1)-alpha, alpha/cast(real_t)(valence) );
            }
            return weight_t(0.0, 0.0);
        }    
        int valence = -1;
    }

  private:

    // Pre-compute location of new boundary points for odd generations
    // and store them in the edge property ep_nv_;
    void compute_new_boundary_points( MeshType _m, 
                                      /*const ref*/ MeshType.EdgeHandle _eh)
    {
        assert( _m.is_boundary(_eh) );

        MeshType.HalfedgeHandle heh;
        MeshType.VertexHandle   vh1, vh2, vh3, vh4, vhl, vhr;
        MeshType.Point          zero, P1, P2, P3, P4;
        zero = [0,0,0];
        /*
        //       *---------*---------*
        //      / \       / \       / \
        //     /   \     /   \     /   \
        //    /     \   /     \   /     \
        //   /       \ /       \ /       \
        //  *---------*--#---#--*---------*
        //                
        //  ^         ^  ^   ^  ^         ^
        //  P1        P2 pl  pr P3        P4
        */
        // get halfedge pointing from P3 to P2 (outer boundary halfedge)

        heh = _m.halfedge_handle(_eh, 
                                 _m.is_boundary(_m.halfedge_handle(_eh,1)));
    
        assert( _m.is_boundary( _m.next_halfedge_handle( heh ) ) );
        assert( _m.is_boundary( _m.prev_halfedge_handle( heh ) ) );

        vh1 = _m.to_vertex_handle( _m.next_halfedge_handle( heh ) );
        vh2 = _m.to_vertex_handle( heh );
        vh3 = _m.from_vertex_handle( heh );
        vh4 = _m.from_vertex_handle( _m.prev_halfedge_handle( heh ));
    
        P1  = _m.point(vh1);
        P2  = _m.point(vh2);
        P3  = _m.point(vh3);
        P4  = _m.point(vh4);
    
        vhl = _m.add_vertex(zero);
        vhr = _m.add_vertex(zero);

        *_m.property_ptr(vp_pos_, vhl ) = (P1 + 16.0f*P2 + 10.0f*P3) * _1over27;
        *_m.property_ptr(vp_pos_, vhr ) = (10.0f*P2 + 16.0f*P3 + P4) * _1over27;
        _m.property_ptr(ep_nv_, _eh).first  = vhl;
        _m.property_ptr(ep_nv_, _eh).second = vhr; 
    }


    void boundary_split( MeshType _m, /*const ref*/ MeshType.FaceHandle _fh )
    {
        assert( _m.is_boundary(_fh) );

        MeshType.VertexHandle     vhl, vhr;
        MeshType.FaceEdgeIter     fe_it;
        MeshType.HalfedgeHandle   heh;

        // find boundary edge
        for( fe_it=_m.fe_iter( _fh ); fe_it.is_active && !_m.is_boundary( fe_it.handle ); ++fe_it ) 
        {}

        // use precomputed, already inserted but not linked vertices
        vhl = _m.property_ptr(ep_nv_, fe_it.handle).first;
        vhr = _m.property_ptr(ep_nv_, fe_it.handle).second;

        /*
        //       *---------*---------*
        //      / \       / \       / \
        //     /   \     /   \     /   \
        //    /     \   /     \   /     \
        //   /       \ /       \ /       \
        //  *---------*--#---#--*---------*
        //                
        //  ^         ^  ^   ^  ^         ^
        //  P1        P2 pl  pr P3        P4
        */
        // get halfedge pointing from P2 to P3 (inner boundary halfedge)

        heh = _m.halfedge_handle(fe_it.handle, 
                                 _m.is_boundary(_m.halfedge_handle(fe_it.handle,0)));

        MeshType.HalfedgeHandle pl_P3;

        // split P2->P3 (heh) in P2->pl (heh) and pl->P3
        boundary_split( _m, heh, vhl );         // split edge
        pl_P3 = _m.next_halfedge_handle( heh ); // store next halfedge handle
        boundary_split( _m, heh );              // split face

        // split pl->P3 in pl->pr and pr->P3
        boundary_split( _m, pl_P3, vhr );
        boundary_split( _m, pl_P3 );

        assert( _m.is_boundary( vhl ) && _m.halfedge_handle(vhl).is_valid() );
        assert( _m.is_boundary( vhr ) && _m.halfedge_handle(vhr).is_valid() );
    }

    void boundary_split(MeshType _m, 
                        /*const ref*/ MeshType.HalfedgeHandle _heh,
                        /*const ref*/ MeshType.VertexHandle _vh)
    {
        assert( _m.is_boundary( _m.edge_handle(_heh) ) );

        MeshType.HalfedgeHandle 
            heh = _heh,
            opp_heh =  _m.opposite_halfedge_handle(_heh) ,
            new_heh, opp_new_heh;
        MeshType.VertexHandle   to_vh = _m.to_vertex_handle(heh);
        MeshType.HalfedgeHandle t_heh;
    
        /*
         *            P5
         *             *
         *            /|\
         *           /   \
         *          /     \
         *         /       \
         *        /         \
         *       /_ heh  new \
         *      *-----\*-----\*\-----*
         *             ^      ^ t_heh
         *            _vh     to_vh
         *
         *     P1     P2     P3     P4
         */
        // Re-Setting Handles
    
        // find halfedge point from P4 to P3
        for(t_heh = heh; 
            _m.next_halfedge_handle(t_heh) != opp_heh; 
            t_heh = _m.opposite_halfedge_handle(_m.next_halfedge_handle(t_heh)))
        {}
    
        assert( _m.is_boundary( t_heh ) );

        new_heh     = _m.new_edge( _vh, to_vh );
        opp_new_heh = _m.opposite_halfedge_handle(new_heh);

        // update halfedge connectivity

        _m.set_next_halfedge_handle(t_heh,   opp_new_heh); // P4-P3 -> P3-P2
        // P2-P3 -> P3-P5
        _m.set_next_halfedge_handle(new_heh, _m.next_halfedge_handle(heh));    
        _m.set_next_halfedge_handle(heh,         new_heh); // P1-P2 -> P2-P3
        _m.set_next_halfedge_handle(opp_new_heh, opp_heh); // P3-P2 -> P2-P1

        // both opposite halfedges point to same face
        _m.set_face_handle(opp_new_heh, _m.face_handle(opp_heh));

        // let heh finally point to new inserted vertex
        _m.set_vertex_handle(heh, _vh); 

        // let heh and new_heh point to same face
        _m.set_face_handle(new_heh, _m.face_handle(heh));

        // let opp_new_heh be the new outgoing halfedge for to_vh 
        // (replaces for opp_heh)
        _m.set_halfedge_handle( to_vh, opp_new_heh );

        // let opp_heh be the outgoing halfedge for _vh
        _m.set_halfedge_handle( _vh, opp_heh );
    }

    void boundary_split( MeshType _m, 
                         /*const ref*/ MeshType.HalfedgeHandle _heh)
    {
        assert( _m.is_boundary( _m.opposite_halfedge_handle( _heh ) ) );

        MeshType.HalfedgeHandle 
            heh = _heh,
            n_heh = _m.next_halfedge_handle(heh);

        MeshType.VertexHandle   
            to_vh = _m.to_vertex_handle(heh);

        MeshType.HalfedgeHandle 
            heh2 = _m.new_edge(to_vh,
                               _m.to_vertex_handle(_m.next_halfedge_handle(n_heh))),
            heh3 = _m.opposite_halfedge_handle(heh2);

        MeshType.FaceHandle
            new_fh = _m.new_face(),
            fh = _m.face_handle(heh);
    
        // Relink (half)edges    

        with (_m) {
            HalfedgeHandle next_heh(HalfedgeHandle h) { return next_halfedge_handle(h); }
            set_face_handle(heh,  new_fh);
            set_face_handle(heh2, new_fh);
            set_next_halfedge_handle(heh2, next_heh(next_heh(n_heh)));
            set_next_halfedge_handle(heh,  heh2);
            set_face_handle( next_heh(heh2), new_fh);

            // set_face_handle( next_heh(next_heh(heh2)), new_fh);

            set_next_halfedge_handle(heh3,                           n_heh);
            set_next_halfedge_handle(next_halfedge_handle(n_heh), heh3);
            set_face_handle(heh3,  fh);
            // set_face_handle(n_heh, fh);

            set_halfedge_handle(    fh, n_heh);
            set_halfedge_handle(new_fh, heh);
        }
    }

  private:

    weights_t     weights_;
    VPropHandleT!( MeshType.Point )                    vp_pos_;
    EPropHandleT!(Std.pair!(MeshType.VertexHandle, MeshType.VertexHandle)) ep_nv_;
    MPropHandleT!(size_t)                              mp_gen_;

    /*const*/ real_t _1over3;
    /*const*/ real_t _1over27;
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
