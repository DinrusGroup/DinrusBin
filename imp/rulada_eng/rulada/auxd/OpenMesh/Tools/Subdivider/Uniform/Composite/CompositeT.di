//============================================================================
// CompositeT.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
//
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

module auxd.OpenMesh.Tools.Subdivider.Uniform.Composite.CompositeT;

/** \file Uniform/Composite/CompositeT.hh
    
 */

//=============================================================================
//
//  CLASS CompositeT
//
//=============================================================================

//== INCLUDES =================================================================

import auxd.OpenMesh.Tools.Subdivider.Uniform.SubdividerT;


private {
    void clear(T)(T[]x) {
        x.length = 0;
    }
    bool empty(T)(T[]x) {
        return x.length == 0;
    }
    void pop_back(T)(ref T[]x) {
        x.length = x.length - 1;
    }
    void push_back(T)(ref T[]x, ref T el) {
        x ~= el;
    }
}

//== CLASS DEFINITION =========================================================

/** This class provides the composite subdivision rules for the uniform case.
 *
 *  To create a subdivider derive from this class and overload the functions
 *  name() and apply_rules(). In the latter one call the wanted rules.
 *
 *  For details on the composite scheme refer to
 *  - <a
 *  href="http://cm.bell-labs.com/who/poswald/sqrt3.pdf">P. Oswald,
 *  P. Schroeder "Composite primal/dual sqrt(3)-subdivision schemes",
 *  CAGD 20, 3, 2003, 135--164</a>

 *  \note Not all rules are implemented!
 *  See_Also: class Adaptive.CompositeT
 */
class CompositeT(MeshType,RealType=float) : SubdividerT!( MeshType, RealType )
{
  public:

    alias RealType                                real_t;
    alias MeshType                                mesh_t;
    alias SubdividerT!( mesh_t, real_t )          parent_t;

  public:

    this() { super(); p_mesh_=null; }
    this(MeshType _mesh) { p_mesh_=null; super(_mesh); }

  public: // inherited interface

    abstract /*const*/ string name( ) /*const*/;

  protected: // inherited interface

    bool prepare( MeshType _m ) 
    {
        // store mesh for later usage in subdivide(), cleanup() and all rules.
        p_mesh_ = _m;
        
        MeshType.VertexIter v_it=(_m.vertices_begin());

        for (; v_it != _m.vertices_end(); ++v_it){
            _m.data_ptr(v_it.handle).set_position(_m.point(v_it.handle));
        }

        return true;
    }

    bool subdivide( MeshType _m, size_t _n )
    {
        assert( p_mesh_ is _m );

        while(_n--)
        {
            apply_rules();
            commit(_m);
        }
   
        return true;
    }

    bool cleanup( MeshType _m ) 
    { 
        assert( p_mesh_ is _m );
        p_mesh_=null; 
        return true; 
    }

  protected:

    /// Assemble here the rule sequence, by calling the /*const*/ructor
    /// of the wanted rules.
    abstract void apply_rules();

  protected:

    /// Move vertices to new positions after the rules have been applied
    /// to the mesh (called by subdivide()).
    void commit( MeshType _m)
    {
        MeshType.VertexIter v_it;

        for (v_it=_m.vertices_begin(); v_it != _m.vertices_end(); ++v_it)
            _m.set_point(v_it.handle(), _m.data_ptr(v_it.handle).position());
    }

  
  public:

    /// Abstract base class for coefficient functions
    static class Coeff
    {
        abstract double opCall(size_t _valence);
    }


  protected:

    alias MeshType.Scalar         scalar_t;
    alias MeshType.VertexHandle   VertexHandle;
    alias MeshType.FaceHandle     FaceHandle;
    alias MeshType.EdgeHandle     EdgeHandle;
    alias MeshType.HalfedgeHandle HalfedgeHandle;

    /// \name Uniform composite subdivision rules
    //@{

  
    ///< Split Face, using Vertex information (1-3 split)
    void Tvv3()
    {
        assert(p_mesh_!is null); MeshType mesh_ = p_mesh_;

        MeshType.VertexHandle vh;
        MeshType.FaceIter     f_it;
        MeshType.EdgeIter     e_it;
        MeshType.VertexIter   v_it;
        auto                  zero_point = MeshType.Point(0.0, 0.0, 0.0);
        size_t                          n_edges, n_faces, n_vertices, j;

        // Store number of original edges
        n_faces    = mesh_.n_faces();
        n_edges    = mesh_.n_edges();
        n_vertices = mesh_.n_vertices();

        // reserve enough memory for iterator
        mesh_.reserve(n_vertices + n_faces, n_edges + 3 * n_faces, 3 * n_faces);

        // set new positions for vertices
        v_it = mesh_.vertices_begin();
        for (j = 0; j < n_vertices; ++j) {
            mesh_.data_ptr(v_it.handle).set_position(mesh_.data_ptr(v_it.handle).position() * 3.0);
            ++v_it;
        }

        // Split each face
        f_it = mesh_.faces_begin();
        for (j = 0; j < n_faces; ++j) {

            vh = mesh_.add_vertex(zero_point);

            mesh_.data_ptr(vh).set_position(zero_point);

            mesh_.split(f_it.handle(), vh);

            ++f_it;
        }

        // Flip each old edge
        MeshType.EdgeHandle[] edge_vector;
        edge_vector.length = 0;

        e_it = mesh_.edges_begin();
        for (j = 0; j < n_edges; ++j) {
            if (mesh_.is_flip_ok(e_it.handle())) {
                mesh_.flip(e_it.handle());
            } else {
                edge_vector ~= (e_it.handle());
            }
            ++e_it;
        }

        // split all boundary edges
        while (!edge_vector.empty()) {
            vh = mesh_.add_vertex(zero_point);
            mesh_.data_ptr(vh).set_position(zero_point);
            mesh_.split(edge_vector[$-1], vh);
            edge_vector.length = edge_vector.length - 1;
        }

    } 

    ///< Split Face, using Vertex information (1-4 split)
    void Tvv4() 
    {

        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        MeshType.VertexHandle     vh;
        MeshType.FaceIter         f_it;
        MeshType.EdgeIter         e_it;
        MeshType.VertexIter       v_it;
        auto                      zero_point = MeshType.Point(0.0, 0.0, 0.0);
        uint                    n_edges, n_faces, n_vertices, j;

        // Store number of original edges
        n_faces    = mesh_.n_faces();
        n_edges    = mesh_.n_edges();
        n_vertices = mesh_.n_vertices();

        // reserve memory ahead for the succeeding operations
        mesh_.reserve(n_vertices + n_edges, 2 * n_edges + 3 * n_faces, 4 * n_faces);

        // set new positions for vertices
        v_it = mesh_.vertices_begin();
        for (j = 0; j < n_vertices; ++j) {
            auto ptz = mesh_.point_ptr(v_it.handle);
            auto p = mesh_.data_ptr(v_it.handle);
            mesh_.data_ptr(v_it.handle).set_position(mesh_.data_ptr(v_it.handle).position() * 4.0);
            ++v_it;
        }

        // Split each edge
        e_it = mesh_.edges_begin();
        for (j = 0; j < n_edges; ++j) {

            vh = split_edge(mesh_.halfedge_handle(e_it.handle(), 0));
            mesh_.data_ptr(vh).set_position(zero_point);

            ++e_it;
        }

        // Corner Cutting of Each Face
        f_it = mesh_.faces_begin();
        for (j = 0; j < n_faces; ++j) {
            MeshType.HalfedgeHandle heh1=(mesh_.halfedge_handle(f_it.handle()));
            MeshType.HalfedgeHandle heh2=(mesh_.next_halfedge_handle(mesh_.next_halfedge_handle(heh1)));
            MeshType.HalfedgeHandle heh3=(mesh_.next_halfedge_handle(mesh_.next_halfedge_handle(heh2)));

            // Cutting off every corner of the 6_gon

            corner_cutting(heh1);
            corner_cutting(heh2);
            corner_cutting(heh3);

            ++f_it;
        }
    }

    ///< Split Face, using Face Information
    void Tfv() 
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        MeshType.VertexHandle     vh;
        MeshType.FaceIter         f_it;
        MeshType.EdgeIter         e_it;
        MeshType.VertexIter       v_it;
        MeshType.VertexFaceIter   vf_it;
        MeshType.FaceFaceIter     ff_it;
        MeshType.Point            cog;
        /*const*/auto             zero_point = MeshType.Point(0.0, 0.0, 0.0);
        uint                    n_edges, n_faces, n_vertices, j, valence;

        // Store number of original edges
        n_faces = mesh_.n_faces();
        n_edges = mesh_.n_edges();
        n_vertices = mesh_.n_vertices();

        // reserve enough space for iterator
        mesh_.reserve(n_vertices + n_faces, n_edges + 3 * n_faces, 3 * n_faces);

        // set new positions for vertices
        v_it = mesh_.vertices_begin();
        for (j = 0; j < n_vertices; ++j) {
            valence = 0;
            cog = zero_point;
            for (vf_it = mesh_.vf_iter(v_it.handle()); vf_it.is_active; ++vf_it) {
                ++valence;
                cog += mesh_.data_ptr(vf_it.handle).position();
            }
            cog /= valence;

            mesh_.data_ptr(v_it.handle).set_position(cog);
            ++v_it;
        }

        // Split each face, insert new vertex and calculate position
        f_it = mesh_.faces_begin();
        for (j = 0; j < n_faces; ++j) {

            vh = mesh_.add_vertex(zero_point);

            valence = 0;
            cog = zero_point;
            for (ff_it = mesh_.ff_iter(f_it.handle()); ff_it.is_active; ++ff_it) {
                ++valence;
                cog += mesh_.data_ptr(ff_it.handle).position();
            }
            cog /= valence;

            mesh_.split(f_it.handle(), vh);

            for (vf_it = mesh_.vf_iter(vh); vf_it.is_active; ++vf_it) {
                mesh_.data_ptr(vf_it.handle).set_position(mesh_.data_ptr(f_it.handle).position());
            }

            mesh_.data_ptr(vh).set_position(cog);

            mesh_.set_point(vh, cog);

            ++f_it;
        }

        // Flip each old edge
        e_it = mesh_.edges_begin();
        for (j = 0; j < n_edges; ++j) {
            if (mesh_.is_flip_ok(e_it.handle()))
                mesh_.flip(e_it.handle());
            ++e_it;
        }
    }

    ///< Face to face averaging.
    void FF()
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        uint valence;
        MeshType.Point              cog;
        auto  zero_point = MeshType.Point(0.0, 0.0, 0.0);
        MeshType.FaceFaceIter       ff_it;
        MeshType.FaceIter           f_it;
        MeshType.Point[] point_vector;

        point_vector.clear();

        for (f_it = mesh_.faces_begin(); f_it != mesh_.faces_end(); ++f_it)
        {
            valence = 0;
            cog = zero_point;

            for (ff_it = mesh_.ff_iter(f_it.handle()); ff_it.is_active; ++ff_it)
            {
                cog += mesh_.data_ptr(ff_it.handle).position();
                ++valence;
            }
            cog /= valence;
            point_vector ~= (cog);
        }

        for (f_it = mesh_.faces_end(); f_it != mesh_.faces_begin(); )
        {
            --f_it;
            mesh_.data_ptr(f_it.handle).set_position(point_vector[$-1]);
            point_vector.length = point_vector.length - 1;
        }
    }

    ///< Weighted face to face averaging.
    void FFc(Coeff _coeff)
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        uint                   valence;
        MeshType.Point           cog;
        auto zero_point = MeshType.Point(0.0, 0.0, 0.0);
        MeshType.FaceFaceIter    ff_it;
        MeshType.FaceIter        f_it;
        MeshType.Scalar          c;
        MeshType.Point[] point_vector;

        for (f_it = mesh_.faces_begin(); f_it != mesh_.faces_end(); ++f_it) {

            valence = 0;
            cog = zero_point;

            for (ff_it = mesh_.ff_iter(f_it.handle()); ff_it.is_active; ++ff_it) {
                cog += mesh_.data_ptr(ff_it.handle).position();
                ++valence;
            }
            cog /= valence;

            c = _coeff(valence);

            cog = cog * (1.0 - c) + mesh_.data_ptr(f_it.handle).position() * c;

            point_vector ~= (cog);

        }
        for (f_it = mesh_.faces_end(); f_it != mesh_.faces_begin(); ) {

            --f_it;
            mesh_.data_ptr(f_it.handle).set_position(point_vector[$-1]);
            point_vector.length = point_vector.length - 1;

        }
    }

    ///< Weighted face to face averaging.
    void FFc(scalar_t _c)
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        uint                   valence;
        MeshType.Point           cog;
        auto             zero_point = MeshType.Point(0.0, 0.0, 0.0);
        MeshType.FaceFaceIter    ff_it;
        MeshType.FaceIter        f_it;
        MeshType.Point[] point_vector;

        for (f_it = mesh_.faces_begin(); f_it != mesh_.faces_end(); ++f_it) {

            valence = 0;
            cog = zero_point;

            for (ff_it = mesh_.ff_iter(f_it.handle()); ff_it.is_active; ++ff_it) {
                cog += mesh_.data_ptr(ff_it.handle).position();
                ++valence;
            }
            cog /= valence;

            cog = cog * (1.0 - _c) + mesh_.data_ptr(f_it.handle).position() * _c;

            point_vector ~= (cog);

        }
        for (f_it = mesh_.faces_end(); f_it != mesh_.faces_begin(); ) {

            --f_it;
            mesh_.data_ptr(f_it.handle).set_position(point_vector[$-1]);
            point_vector.length = point_vector.length - 1;
        }
    } 

    ///< Face to vertex averaging.
    void FV()
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        uint                  valence;
        MeshType.Point          cog;
        auto             zero_point = MeshType.Point(0.0, 0.0, 0.0);
        MeshType.VertexFaceIter vf_it;
        MeshType.VertexIter     v_it;

        for (v_it = mesh_.vertices_begin(); v_it != mesh_.vertices_end(); ++v_it) {

            valence = 0;
            cog = zero_point;

            for (vf_it = mesh_.vf_iter(v_it.handle()); vf_it.is_active; ++vf_it) {
                cog += mesh_.data_ptr(vf_it.handle).position();
                ++valence;
            }
            cog /= valence;
            mesh_.data_ptr(v_it.handle).set_position(cog);
        }
    }

    ///< Weighted face to vertex Averaging with flaps 
    void FVc(Coeff _coeff)
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        uint                        valence;
        MeshType.Point              cog;
        MeshType.Point              zero_point = MeshType.Point(0.0, 0.0, 0.0);
        scalar_t               c;
        MeshType.VertexOHalfedgeIter  voh_it;
        MeshType.VertexIter           v_it;

        for (v_it = mesh_.vertices_begin(); v_it != mesh_.vertices_end(); ++v_it) {

            valence = 0;
            cog = zero_point;

            for (voh_it = mesh_.voh_iter(v_it.handle()); voh_it.is_active; ++voh_it) {
                ++valence;
            }

            c = _coeff(valence);

            for (voh_it = mesh_.voh_iter(v_it.handle()); voh_it.is_active; ++voh_it) {

                if (mesh_.face_handle(voh_it.handle()).is_valid()) {

                    if (mesh_.face_handle(mesh_.opposite_halfedge_handle(mesh_.next_halfedge_handle(voh_it.handle()))).is_valid()) {
                        cog += mesh_.data_ptr(mesh_.face_handle(voh_it.handle())).position() * c;
                        cog += mesh_.data_ptr(mesh_.face_handle(mesh_.opposite_halfedge_handle(mesh_.next_halfedge_handle(voh_it.handle())))).position() * (1.0 - c);
                    } else {
                        cog += mesh_.data_ptr(mesh_.face_handle(voh_it.handle())).position();
                    }
                } else {
                    --valence;
                }
            }

            if (valence > 0)
                cog /= valence;

            mesh_.data_ptr(v_it.handle).set_position(cog);
        }
    }

    ///< Weighted face to vertex Averaging with flaps 
    void FVc(scalar_t _c)
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        uint                       valence;
        MeshType.Point               cog;
        auto             zero_point = MeshType.Point(0.0, 0.0, 0.0);
        MeshType.VertexOHalfedgeIter voh_it;
        MeshType.VertexIter          v_it;

        for (v_it = mesh_.vertices_begin(); v_it != mesh_.vertices_end(); ++v_it) {

            valence = 0;
            cog = zero_point;

            for (voh_it = mesh_.voh_iter(v_it.handle()); voh_it.is_active; ++voh_it) {
                ++valence;
            }

            for (voh_it = mesh_.voh_iter(v_it.handle()); voh_it.is_active; ++voh_it) {

                if (mesh_.face_handle(voh_it.handle()).is_valid()) {

                    if (mesh_.face_handle(mesh_.opposite_halfedge_handle(mesh_.next_halfedge_handle(voh_it.handle()))).is_valid()) {
                        cog += mesh_.data_ptr(mesh_.face_handle(voh_it.handle())).position() * _c;
                        cog += mesh_.data_ptr(mesh_.face_handle(mesh_.opposite_halfedge_handle(mesh_.next_halfedge_handle(voh_it.handle())))).position() * (1.0 - _c);
                    } else {
                        cog += mesh_.data_ptr(mesh_.face_handle(voh_it.handle())).position();
                    }
                } else {
                    --valence;
                }
            }

            if (valence > 0)
                cog /= valence;

            mesh_.data_ptr(v_it.handle).set_position(cog);
        }
    }

    ///< Face to edge averaging.
    void FE()
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        MeshType.EdgeIter       e_it;
        uint                  valence;
        MeshType.Point          cog;
        auto             zero_point = MeshType.Point(0.0, 0.0, 0.0);

        for (e_it = mesh_.edges_begin(); e_it != mesh_.edges_end(); ++e_it) {
            valence = 0;
            cog = zero_point;

            if (mesh_.face_handle(mesh_.halfedge_handle(e_it.handle(), 0)).is_valid()) {
                cog += mesh_.data_ptr(mesh_.face_handle(mesh_.halfedge_handle(e_it.handle(), 0))).position();
                ++valence;
            }

            if (mesh_.face_handle(mesh_.halfedge_handle(e_it.handle(), 1)).is_valid()) {
                cog += mesh_.data_ptr(mesh_.face_handle(mesh_.halfedge_handle(e_it.handle(), 1))).position();
                ++valence;
            }

            cog /= valence;
            mesh_.data_ptr(e_it.handle).set_position(cog);
        }
    }

    ///< Vertex to Face Averaging.
    void VF()
    {
        assert(p_mesh_!is null); MeshType mesh_ = p_mesh_;

        uint                  valence;
        MeshType.Point          cog;
        MeshType.Point          zero_point = MeshType.Point(0.0, 0.0, 0.0);
        MeshType.FaceVertexIter fv_it;
        MeshType.FaceIter       f_it;

        for (f_it = mesh_.faces_begin(); f_it != mesh_.faces_end(); ++f_it) {

            valence = 0;
            cog = zero_point;

            for (fv_it = mesh_.fv_iter(f_it.handle()); fv_it.is_active; ++fv_it) {
                cog += mesh_.data_ptr(fv_it.handle).position();
                ++valence;
            }
            cog /= valence;
            mesh_.data_ptr(f_it.handle).set_position(cog);
        }

    }

    ///< Vertex to Face Averaging, weighted.
    void VFa(Coeff _coeff)
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        uint[3]                       valence;
        uint                          i;
        MeshType.Point                cog;
        MeshType.Point          zero_point = MeshType.Point(0.0, 0.0, 0.0);
        MeshType.Scalar               alpha;
        MeshType.FaceIter             f_it;
        MeshType.HalfedgeHandle       heh;
        MeshType.VertexHandle[3]      vh;
        MeshType.VertexOHalfedgeIter  voh_it;
        MeshType.FaceVertexIter       fv_it;

        for (f_it = mesh_.faces_begin(); f_it != mesh_.faces_end(); ++f_it) {

            heh = mesh_.halfedge_handle(f_it.handle());
            for (i = 0; i <= 2; ++i) {

                valence[i] = 0;
                vh[i] = mesh_.to_vertex_handle(heh);

                for (voh_it = mesh_.voh_iter(vh[i]); voh_it.is_active; ++voh_it) {
                    ++valence[i];
                }

                heh = mesh_.next_halfedge_handle(heh);
            }

            if (valence[0] <= valence[1])
                if (valence[0] <= valence[2])
                    i = 0;
                else
                    i = 2;
            else
                if (valence[1] <= valence[2])
                    i = 1;
                else
                    i = 2;

            alpha = _coeff(valence[i]);

            cog = zero_point;

            for (fv_it = mesh_.fv_iter(f_it.handle()); fv_it.is_active; ++fv_it) {
                if (fv_it.handle() == vh[i]) {
                    cog += mesh_.data_ptr(fv_it.handle).position() * alpha;
                } else {
                    cog += mesh_.data_ptr(fv_it.handle).position() * (1.0 - alpha) / 2.0;
                }
            }

            mesh_.data_ptr(f_it.handle).set_position(cog);
        }
    }

    ///< Vertex to Face Averaging, weighted.
    void VFa(scalar_t _alpha)
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        uint[3] valence;
        uint    i;
        MeshType.Point                cog;
        MeshType.Point          zero_point = MeshType.Point(0.0, 0.0, 0.0);
        MeshType.FaceIter             f_it;
        MeshType.HalfedgeHandle       heh;
        MeshType.VertexHandle[3]      vh;
        MeshType.VertexOHalfedgeIter  voh_it;
        MeshType.FaceVertexIter       fv_it;

        for (f_it = mesh_.faces_begin(); f_it != mesh_.faces_end(); ++f_it) {

            heh = mesh_.halfedge_handle(f_it.handle());
            for (i = 0; i <= 2; ++i) {

                valence[i] = 0;
                vh[i] = mesh_.to_vertex_handle(heh);

                for (voh_it = mesh_.voh_iter(vh[i]); voh_it.is_active; ++voh_it) {
                    ++valence[i];
                }

                heh = mesh_.next_halfedge_handle(heh);
            }

            if (valence[0] <= valence[1])
                if (valence[0] <= valence[2])
                    i = 0;
                else
                    i = 2;
            else
                if (valence[1] <= valence[2])
                    i = 1;
                else
                    i = 2;

            cog = zero_point;

            for (fv_it = mesh_.fv_iter(f_it.handle()); fv_it.is_active; ++fv_it) {
                if (fv_it.handle() == vh[i]) {
                    cog += mesh_.data_ptr(fv_it.handle).position() * _alpha;
                } else {
                    cog += mesh_.data_ptr(fv_it.handle).position() * (1.0 - _alpha) / 2.0;
                }
            }

            mesh_.data_ptr(f_it.handle).set_position(cog);
        }
    }
 

    ///< Vertex to vertex averaging.
    void VV()
    {
        assert(p_mesh_!is null); MeshType mesh_ = p_mesh_;

        uint                        valence;
        MeshType.Point                cog;
        MeshType.Point          zero_point = MeshType.Point(0.0, 0.0, 0.0);
        MeshType.VertexVertexIter     vv_it;
        MeshType.VertexIter           v_it;
        MeshType.Point[]   point_vector;

        point_vector.clear();

        for (v_it = mesh_.vertices_begin(); v_it != mesh_.vertices_end(); ++v_it) {

            valence = 0;
            cog = zero_point;

            for (vv_it = mesh_.vv_iter(v_it.handle()); vv_it.is_active; ++vv_it) {
                cog += mesh_.data_ptr(vv_it.handle).position();
                ++valence;
            }
            cog /= valence;
            point_vector ~= (cog);
        }

        for (v_it = mesh_.vertices_end(); v_it != mesh_.vertices_begin(); )
        {
            --v_it;
            mesh_.data_ptr(v_it.handle).set_position(point_vector[$-1]);
            point_vector.length = point_vector.length - 1;
        }
    }
    ///< Vertex to vertex averaging, weighted.
    void VVc(Coeff _coeff)
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        uint                      valence;
        MeshType.Point              cog;
        MeshType.Point          zero_point = MeshType.Point(0.0, 0.0, 0.0);
        MeshType.VertexVertexIter   vv_it;
        MeshType.VertexIter         v_it;
        scalar_t             c;
        MeshType.Point[] point_vector;

        for (v_it = mesh_.vertices_begin(); v_it != mesh_.vertices_end(); ++v_it)
        {
            valence = 0;
            cog = zero_point;

            for (vv_it = mesh_.vv_iter(v_it.handle()); vv_it.is_active; ++vv_it)
            {
                cog += mesh_.data_ptr(vv_it.handle).position();
                ++valence;
            }
            cog /= valence;
            c = _coeff(valence);
            cog = cog * (1 - c) + mesh_.data_ptr(v_it.handle).position() * c;
            point_vector ~= (cog);
        }
        for (v_it = mesh_.vertices_end(); v_it != mesh_.vertices_begin(); )
        {
            --v_it;
            mesh_.data_ptr(v_it.handle).set_position(point_vector[$-1]);
            point_vector.length = point_vector.length - 1;
        }
    }
    ///< Vertex to vertex averaging, weighted.
    void VVc(scalar_t _c)
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        uint                      valence;
        MeshType.Point              cog;
        MeshType.Point          zero_point = MeshType.Point(0.0, 0.0, 0.0);
        MeshType.VertexVertexIter   vv_it;
        MeshType.VertexIter         v_it;
        MeshType.Point[] point_vector;

        for (v_it = mesh_.vertices_begin(); v_it != mesh_.vertices_end(); ++v_it) {

            valence = 0;
            cog = zero_point;

            for (vv_it = mesh_.vv_iter(v_it.handle()); vv_it.is_active; ++vv_it) {
                cog += mesh_.data_ptr(vv_it.handle).position();
                ++valence;
            }
            cog /= valence;

            cog = cog * (1.0 - _c) + mesh_.data_ptr(v_it.handle).position() * _c;

            point_vector ~= (cog);

        }
        for (v_it = mesh_.vertices_end(); v_it != mesh_.vertices_begin(); ) {

            --v_it;
            mesh_.data_ptr(v_it.handle).set_position(point_vector[$-1]);
            point_vector.length = point_vector.length - 1;

        }
    }

    ///< VE Step (Vertex to Edge Averaging)
    void VE()
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        MeshType.EdgeIter      e_it;
        MeshType.Point         cog;

        for (e_it = mesh_.edges_begin(); e_it != mesh_.edges_end(); ++e_it)
        {
            cog = mesh_.data_ptr(mesh_.to_vertex_handle(mesh_.halfedge_handle(e_it.handle(), 0))).position();
            cog += mesh_.data_ptr(mesh_.to_vertex_handle(mesh_.halfedge_handle(e_it.handle(), 1))).position();
            cog /= 2.0;
            mesh_.data_ptr(e_it.handle).set_position(cog);
        }
    }

  
    ///< Vertex to edge averaging, using diamond of edges.
    void VdE()
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        MeshType.EdgeIter             e_it;
        MeshType.Point                cog;
        MeshType.Point          zero_point = MeshType.Point(0.0, 0.0, 0.0);
        MeshType.HalfedgeHandle       heh1, heh2;
        uint                        valence;

        for (e_it = mesh_.edges_begin(); e_it != mesh_.edges_end(); ++e_it) {

            cog = zero_point;
            valence = 2;

            heh1 = mesh_.halfedge_handle(e_it.handle(), 0);
            heh2 = mesh_.opposite_halfedge_handle(heh1);
            cog += mesh_.data_ptr(mesh_.to_vertex_handle(heh1)).position();
            cog += mesh_.data_ptr(mesh_.to_vertex_handle(heh2)).position();

            if (!mesh_.is_boundary(heh1)) {
                cog += mesh_.data_ptr(mesh_.to_vertex_handle(mesh_.next_halfedge_handle(heh1))).position();
                ++valence;
            }

            if (!mesh_.is_boundary(heh2)) {
                cog += mesh_.data_ptr(mesh_.to_vertex_handle(mesh_.next_halfedge_handle(heh2))).position();
                ++valence;
            }

            cog /= valence;

            mesh_.data_ptr(e_it.handle).set_position(cog);
        }
    }

    ///< Weighted vertex to edge averaging, using diamond of edges
    void VdEc(scalar_t _c)
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        MeshType.EdgeIter           e_it;
        MeshType.Point              cog;
        MeshType.Point          zero_point = MeshType.Point(0.0, 0.0, 0.0);
        MeshType.HalfedgeHandle     heh;

        for (e_it = mesh_.edges_begin(); e_it != mesh_.edges_end(); ++e_it) {

            cog = zero_point;

            for (int i = 0; i <= 1; ++i) {

                heh = mesh_.halfedge_handle(e_it.handle(), i);
                if (!mesh_.is_boundary(heh))
                {
                    cog += mesh_.point(mesh_.to_vertex_handle(mesh_.next_halfedge_handle(heh))) * (0.5 - _c);
                    cog += mesh_.data_ptr(mesh_.to_vertex_handle(heh)).position() * _c;
                }
                else
                {
                    cog += mesh_.data_ptr(mesh_.to_vertex_handle(heh)).position();
                }
            }

            mesh_.data_ptr(e_it.handle).set_position(cog);
        }
    }
  
    /// Weigthed vertex to edge averaging, using diamond of edges for
    /// irregular vertices.
    void VdEg(Coeff _coeff)
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        MeshType.EdgeIter             e_it;
        MeshType.Point                cog;
        MeshType.Point          zero_point = MeshType.Point(0.0, 0.0, 0.0);
        MeshType.HalfedgeHandle       heh;
        MeshType.VertexOHalfedgeIter  voh_it;
        uint                        valence[2];
        uint i;
        scalar_t               gamma;

        for (e_it = mesh_.edges_begin(); e_it != mesh_.edges_end(); ++e_it) {

            cog = zero_point;

            for (i = 0; i <= 1; ++i) {

                heh = mesh_.halfedge_handle(e_it.handle(), i);
                valence[i] = 0;

                // look for lowest valence vertex
                for (voh_it = mesh_.voh_iter(mesh_.to_vertex_handle(heh)); voh_it.is_active; ++voh_it)
                {
                    ++valence[i];
                }
            }

            if (valence[0] < valence[1])
                i = 0;
            else
                i = 1;

            gamma = _coeff(valence[i]);

            heh = mesh_.halfedge_handle(e_it.handle(), i);

            if (!mesh_.is_boundary(heh))
            {
                cog += mesh_.point(mesh_.to_vertex_handle(mesh_.next_halfedge_handle(heh))) * (gamma);
                cog += mesh_.data_ptr(mesh_.to_vertex_handle(heh)).position() * (1.0 - 3.0 * gamma);
            }
            else
            {
                cog += mesh_.data_ptr(mesh_.to_vertex_handle(heh)).position() * (1.0 - 2.0 * gamma);
            }


            heh = mesh_.halfedge_handle(e_it.handle(), 1-i);

            if (!mesh_.is_boundary(heh)) {
                cog += mesh_.point(mesh_.to_vertex_handle(mesh_.next_halfedge_handle(heh))) * (gamma);
                cog += mesh_.data_ptr(mesh_.to_vertex_handle(heh)).position() * gamma;
            } else {
                cog += mesh_.data_ptr(mesh_.to_vertex_handle(heh)).position() * 2.0 * gamma;
            }

            mesh_.data_ptr(e_it.handle).set_position(cog);
        }
    }

    /// Weigthed vertex to edge averaging, using diamond of edges for
    /// irregular vertices.
    void VdEg(scalar_t _gamma)
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        MeshType.EdgeIter             e_it;
        MeshType.Point                cog;
        MeshType.Point          zero_point = MeshType.Point(0.0, 0.0, 0.0);
        MeshType.HalfedgeHandle       heh;
        MeshType.VertexOHalfedgeIter  voh_it;
        uint[2]                       valence;
        uint i;

        for (e_it = mesh_.edges_begin(); e_it != mesh_.edges_end(); ++e_it) {

            cog = zero_point;

            for (i = 0; i <= 1; ++i)
            {
                heh = mesh_.halfedge_handle(e_it.handle(), i);
                valence[i] = 0;

                // look for lowest valence vertex
                for (voh_it = mesh_.voh_iter(mesh_.to_vertex_handle(heh)); voh_it.is_active; ++voh_it)
                {
                    ++valence[i];
                }
            }

            if (valence[0] < valence[1])
                i = 0;
            else
                i = 1;

            heh = mesh_.halfedge_handle(e_it.handle(), i);

            if (!mesh_.is_boundary(heh)) {
                cog += mesh_.point(mesh_.to_vertex_handle(mesh_.next_halfedge_handle(heh))) * (_gamma);
                cog += mesh_.data_ptr(mesh_.to_vertex_handle(heh)).position() * (1.0 - 3.0 * _gamma);
            } else {
                cog += mesh_.data_ptr(mesh_.to_vertex_handle(heh)).position() * (1.0 - 2.0 * _gamma);
            }


            heh = mesh_.halfedge_handle(e_it.handle(), 1-i);

            if (!mesh_.is_boundary(heh))
            {
                cog += mesh_.point(mesh_.to_vertex_handle(mesh_.next_halfedge_handle(heh))) * (_gamma);
                cog += mesh_.data_ptr(mesh_.to_vertex_handle(heh)).position() * _gamma;
            }
            else
            {
                cog += mesh_.data_ptr(mesh_.to_vertex_handle(heh)).position() * 2.0 * _gamma;
            }

            mesh_.data_ptr(e_it.handle).set_position(cog);
        }
    }


    ///< Edge to face averaging.
    void EF()
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        MeshType.FaceIter         f_it;
        MeshType.FaceEdgeIter     fe_it;
        uint                    valence;
        MeshType.Point            cog;
        MeshType.Point          zero_point = MeshType.Point(0.0, 0.0, 0.0);

        for (f_it = mesh_.faces_begin(); f_it != mesh_.faces_end(); ++f_it) {
            valence = 0;
            cog = zero_point;

            for (fe_it = mesh_.fe_iter(f_it.handle()); fe_it.is_active; ++fe_it) {
                ++valence;
                cog += mesh_.data_ptr(fe_it.handle).position();
            }

            cog /= valence;
            mesh_.data_ptr(f_it.handle).set_position(cog);
        }
    }
  
    ///< Edge to vertex averaging.
    void EV()
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        MeshType.VertexIter       v_it;
        MeshType.Point            cog;
        MeshType.Point          zero_point = MeshType.Point(0.0, 0.0, 0.0);
        uint                    valence;
        MeshType.VertexEdgeIter   ve_it;

        for (v_it = mesh_.vertices_begin(); v_it != mesh_.vertices_end(); ++v_it)
        {
            valence = 0;
            cog = zero_point;

            for (ve_it = mesh_.ve_iter(v_it.handle()); ve_it.is_active; ++ve_it) {
                cog += mesh_.data_ptr(ve_it.handle).position();
                ++valence;
            }

            cog /= valence;

            mesh_.data_ptr(v_it.handle).set_position(cog);
        }
    }

    ///< Weighted edge to vertex averaging.
    void EVc(Coeff _coeff)
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        MeshType.VertexIter            v_it;
        MeshType.Point                 cog;
        MeshType.Point          zero_point = MeshType.Point(0.0, 0.0, 0.0);
        uint                         valence;
        MeshType.VertexOHalfedgeIter   voh_it;
        scalar_t                c;

        for (v_it = mesh_.vertices_begin(); v_it != mesh_.vertices_end(); ++v_it)
        {
            valence = 0;
            cog = zero_point;

            for (voh_it = mesh_.voh_iter(v_it.handle()); voh_it.is_active; ++voh_it)
            {
                ++valence;
            }

            c = _coeff(valence);

            for (voh_it = mesh_.voh_iter(v_it.handle()); voh_it.is_active; ++voh_it) {
                cog += mesh_.data_ptr(mesh_.edge_handle(voh_it.handle())).position() * c;
                cog += mesh_.data_ptr(mesh_.edge_handle(mesh_.next_halfedge_handle(voh_it.handle()))).position() * (1.0 - c);
            }

            cog /= valence;

            mesh_.data_ptr(v_it.handle).set_position(cog);
        }
    }

    ///< Weighted edge to vertex averaging.
    void EVc(scalar_t _c)
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;
        MeshType.VertexIter           v_it;
        MeshType.Point                cog;
        MeshType.Point          zero_point = MeshType.Point(0.0, 0.0, 0.0);
        uint                        valence;
        MeshType.VertexOHalfedgeIter  voh_it;

        for (v_it = mesh_.vertices_begin(); v_it != mesh_.vertices_end(); ++v_it) {
            valence = 0;
            cog = zero_point;

            for (voh_it = mesh_.voh_iter(v_it.handle()); voh_it.is_active; ++voh_it) {
                ++valence;
            }

            for (voh_it = mesh_.voh_iter(v_it.handle()); voh_it.is_active; ++voh_it) {
                cog += mesh_.data_ptr(mesh_.edge_handle(voh_it.handle())).position() * _c;
                cog += mesh_.data_ptr(mesh_.edge_handle(mesh_.next_halfedge_handle(voh_it.handle()))).position() * (1.0 - _c);
            }

            cog /= valence;

            mesh_.data_ptr(v_it.handle).set_position(cog);
        }
    }

    ///< Edge to edge averaging w/ flap rule.
    void EdE()
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        uint                      valence;
        MeshType.Point              cog;
        MeshType.Point          zero_point = MeshType.Point(0.0, 0.0, 0.0);
        MeshType.EdgeIter           e_it;
        MeshType.HalfedgeHandle     heh;
        MeshType.Point[] point_vector;

        point_vector.clear();

        for (e_it = mesh_.edges_begin(); e_it != mesh_.edges_end(); ++e_it) {

            valence = 0;
            cog = zero_point;

            for (int i = 0; i <= 1; ++i) {
                heh = mesh_.halfedge_handle(e_it.handle(), i);
                if (mesh_.face_handle(heh).is_valid())
                {
                    cog += mesh_.data_ptr(mesh_.edge_handle(mesh_.next_halfedge_handle(heh))).position();
                    cog += mesh_.data_ptr(mesh_.edge_handle(mesh_.next_halfedge_handle(mesh_.next_halfedge_handle(heh)))).position();
                    ++valence;
                    ++valence;
                }
            }

            cog /= valence;
            point_vector ~= (cog);
        }

        for (e_it = mesh_.edges_end(); e_it != mesh_.edges_begin(); )
        {
            --e_it;
            mesh_.data_ptr(e_it.handle).set_position(point_vector[$-1]);
            point_vector.length = point_vector.length - 1;
        }
    }

    ///< Weighted edge to edge averaging w/ flap rule.
    void EdEc(scalar_t _c)
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        uint                         valence;
        MeshType.Point                 cog, zero_point=MeshType.Point(0.0, 0.0, 0.0);
        MeshType.EdgeIter              e_it;
        MeshType.HalfedgeHandle        heh;
        MeshType.Point[]               point_vector;

        point_vector.clear();

        for (e_it = mesh_.edges_begin(); e_it != mesh_.edges_end(); ++e_it)
        {
            valence = 0;
            cog = zero_point;

            for (int i = 0; i <= 1; ++i) {
                heh = mesh_.halfedge_handle(e_it.handle(), i);
                if (mesh_.face_handle(heh).is_valid())
                {
                    cog += mesh_.data_ptr(mesh_.edge_handle(mesh_.next_halfedge_handle(heh))).position() * (1.0 - _c);
                    cog += mesh_.data_ptr(mesh_.edge_handle(mesh_.next_halfedge_handle(mesh_.next_halfedge_handle(heh)))).position() * (1.0 - _c);
                    ++valence;
                    ++valence;
                }
            }

            cog /= valence;
            cog += mesh_.data_ptr(e_it.handle).position() * _c;
            point_vector ~= (cog);
        }

        for (e_it = mesh_.edges_end(); e_it != mesh_.edges_begin(); ) {

            --e_it;
            mesh_.data_ptr(e_it.handle).set_position(point_vector[$-1]);
            point_vector.length = point_vector.length - 1;
        }
    }


    //@}

    void corner_cutting(HalfedgeHandle _heh)
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        // Define Halfedge Handles
        MeshType.HalfedgeHandle heh5=(_heh);
        MeshType.HalfedgeHandle heh6=(mesh_.next_halfedge_handle(_heh));

        // Cycle around the polygon to find correct Halfedge
        for (; mesh_.next_halfedge_handle(mesh_.next_halfedge_handle(heh5)) != _heh;
             heh5 = mesh_.next_halfedge_handle(heh5)) { }

        MeshType.HalfedgeHandle heh2=(mesh_.next_halfedge_handle(heh5));
        MeshType.HalfedgeHandle
            heh3=(mesh_.new_edge(mesh_.to_vertex_handle(_heh),
                                mesh_.to_vertex_handle(heh5)));
        MeshType.HalfedgeHandle heh4=(mesh_.opposite_halfedge_handle(heh3));

        // Old and new Face
        MeshType.FaceHandle     fh_old=(mesh_.face_handle(heh6));
        MeshType.FaceHandle     fh_new=(mesh_.new_face());

        // Init new face
        mesh_.data_ptr(fh_new).set_position(mesh_.data_ptr(fh_old).position());

        // Re-Set Handles around old Face
        mesh_.set_next_halfedge_handle(heh4, heh6);
        mesh_.set_next_halfedge_handle(heh5, heh4);

        mesh_.set_face_handle(heh4, fh_old);
        mesh_.set_face_handle(heh5, fh_old);
        mesh_.set_face_handle(heh6, fh_old);
        mesh_.set_halfedge_handle(fh_old, heh4);

        // Re-Set Handles around new Face
        mesh_.set_next_halfedge_handle(_heh, heh3);
        mesh_.set_next_halfedge_handle(heh3, heh2);

        mesh_.set_face_handle(_heh, fh_new);
        mesh_.set_face_handle(heh2, fh_new);
        mesh_.set_face_handle(heh3, fh_new);

        mesh_.set_halfedge_handle(fh_new, _heh);
    }


    VertexHandle split_edge(HalfedgeHandle _heh)
    {
        assert(p_mesh_ !is null); MeshType mesh_ = p_mesh_;

        HalfedgeHandle heh1;
        HalfedgeHandle heh2;
        HalfedgeHandle heh3;
        HalfedgeHandle temp_heh;

        VertexHandle
            vh,
            vh1=(mesh_.to_vertex_handle(_heh)),
            vh2=(mesh_.from_vertex_handle(_heh));

        // Calculate and Insert Midpoint of Edge
        vh = mesh_.add_vertex((mesh_.point(vh2) + mesh_.point(vh1)) / 2.0);
        // Re-Set Handles
        heh2 = mesh_.opposite_halfedge_handle(_heh);

        if (!mesh_.is_boundary(mesh_.edge_handle(_heh))) {

            for (temp_heh = mesh_.next_halfedge_handle(heh2);
                 mesh_.next_halfedge_handle(temp_heh) != heh2;
                 temp_heh = mesh_.next_halfedge_handle(temp_heh) ) {}
        } else {
            for (temp_heh = _heh;
                 mesh_.next_halfedge_handle(temp_heh) != heh2;
                 temp_heh = mesh_.opposite_halfedge_handle(mesh_.next_halfedge_handle(temp_heh))) {}
        }

        heh1 = mesh_.new_edge(vh, vh1);
        heh3 = mesh_.opposite_halfedge_handle(heh1);
        mesh_.set_vertex_handle(_heh, vh);
        mesh_.set_next_halfedge_handle(temp_heh, heh3);
        mesh_.set_next_halfedge_handle(heh1, mesh_.next_halfedge_handle(_heh));
        mesh_.set_next_halfedge_handle(_heh, heh1);
        mesh_.set_next_halfedge_handle(heh3, heh2);
        if (mesh_.face_handle(heh2).is_valid()) {
            mesh_.set_face_handle(heh3, mesh_.face_handle(heh2));
            mesh_.set_halfedge_handle(mesh_.face_handle(heh3), heh3);
        }
        mesh_.set_face_handle(heh1, mesh_.face_handle(_heh));
        mesh_.set_halfedge_handle(vh, heh1);
        mesh_.set_halfedge_handle(mesh_.face_handle(_heh), _heh);
        mesh_.set_halfedge_handle(vh1, heh3);

        return vh;
    }


  private:

    MeshType p_mesh_;

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
