//============================================================================
// PolyMeshT.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 30 Aug 2007
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

module auxd.OpenMesh.Core.Mesh.PolyMeshT;

//=============================================================================
//
//  CLASS PolyMeshT
//
//=============================================================================


//== INCLUDES =================================================================


import auxd.OpenMesh.Core.System.config;
import Math = auxd.OpenMesh.Core.Geometry.MathDefs;
import auxd.OpenMesh.Core.Geometry.VectorT;
import auxd.OpenMesh.Core.Utils.vector_cast;
import auxd.OpenMesh.Core.Mesh.PolyConnectivity;

version(linux){} else {
   // not sure why, but this singleton causes the linker
   //  trouble on linux
   version = LoopSingletonWorks;
}
version (LoopSingletonWorks) {
import auxd.OpenMesh.Core.Geometry.LoopSchemeMaskT;
}

import std.io;

//== CLASS DEFINITION =========================================================


/** \class PolyMeshT PolyMeshT.hh <OpenMesh/Mesh/PolyMeshT.hh>

    Base type for a polygonal mesh.

    This is the base class for a polygonal mesh. It is parameterized
    by a mesh kernel that is given as a template argument. This class
    inherits all methods from its mesh kernel.

    \param Kernel: template argument for the mesh kernel
    \note You should use the predefined mesh-kernel combinations in
    \ref mesh_types_group
    See_Also: \ref mesh_type
*/

class PolyMeshT(Kernel) : public Kernel
{
  public:

    /// Self type. Used to specify iterators/circulators.
    alias PolyMeshT!(Kernel)                   This;
    //--- item types ---
  
    //@{
    /// Determine whether this is a PolyMeshT or TriMeshT
    enum { IsPolyMesh = 1 };
    enum { IsTriMesh  = 0 };
    static bool is_polymesh() { return true;  }
    static bool is_trimesh()  { return false; }
    //@}

    /// \name Mesh Items
    //@{
    /// Scalar type
    alias Kernel.Scalar    Scalar;
    /// Coordinate type
    alias Kernel.Point     Point;
    /// Normal type
    alias Kernel.Normal    Normal;
    /// Color type
    alias Kernel.Color     Color;
    /// TexCoord1D type
    alias Kernel.TexCoord1D  TexCoord1D;
    /// TexCoord2D type
    alias Kernel.TexCoord2D  TexCoord2D;
    /// TexCoord3D type
    alias Kernel.TexCoord3D  TexCoord3D;
    /// Vertex type
    alias Kernel.Vertex    Vertex;
    /// Halfedge type
    alias Kernel.Halfedge  Halfedge;
    /// Edge type
    alias Kernel.Edge      Edge;
    /// Face type
    alias Kernel.Face      Face;
    //@}

    //--- handle types ---

    /// Handle for referencing the corresponding item
    alias Kernel.VertexHandle       VertexHandle;
    alias Kernel.HalfedgeHandle     HalfedgeHandle;
    alias Kernel.EdgeHandle         EdgeHandle;
    alias Kernel.FaceHandle         FaceHandle;



    alias Kernel.VertexIter                 VertexIter;
    alias Kernel.HalfedgeIter               HalfedgeIter;
    alias Kernel.EdgeIter                   EdgeIter;
    alias Kernel.FaceIter                   FaceIter;

    alias Kernel.ConstVertexIter            ConstVertexIter;
    alias Kernel.ConstHalfedgeIter          ConstHalfedgeIter;
    alias Kernel.ConstEdgeIter              ConstEdgeIter;
    alias Kernel.ConstFaceIter              ConstFaceIter;
    //@}

    //--- circulators ---

    /** \name Mesh Circulators
        Refer to auxd.OpenMesh.Mesh.Iterators or \ref mesh_iterators
        for documentation.
    */
    //@{
    /// Circulator
    alias Kernel.VertexVertexIter          VertexVertexIter;
    alias Kernel.VertexOHalfedgeIter       VertexOHalfedgeIter;
    alias Kernel.VertexIHalfedgeIter       VertexIHalfedgeIter;
    alias Kernel.VertexEdgeIter            VertexEdgeIter;
    alias Kernel.VertexFaceIter            VertexFaceIter;
    alias Kernel.FaceVertexIter            FaceVertexIter;
    alias Kernel.FaceHalfedgeIter          FaceHalfedgeIter;
    alias Kernel.FaceEdgeIter              FaceEdgeIter;
    alias Kernel.FaceFaceIter              FaceFaceIter;

    alias Kernel.ConstVertexVertexIter     ConstVertexVertexIter;
    alias Kernel.ConstVertexOHalfedgeIter  ConstVertexOHalfedgeIter;
    alias Kernel.ConstVertexIHalfedgeIter  ConstVertexIHalfedgeIter;
    alias Kernel.ConstVertexEdgeIter       ConstVertexEdgeIter;
    alias Kernel.ConstVertexFaceIter       ConstVertexFaceIter;
    alias Kernel.ConstFaceVertexIter       ConstFaceVertexIter;
    alias Kernel.ConstFaceHalfedgeIter     ConstFaceHalfedgeIter;
    alias Kernel.ConstFaceEdgeIter         ConstFaceEdgeIter;
    alias Kernel.ConstFaceFaceIter         ConstFaceFaceIter;
    //@}


    // --- constructor/destructor
    this() {}
    ~this() {}

    /** Copy one mesh over top of another.  
        This is a deep copy duplicating all data.
        If the mesh types vary, use PolyMeshT.assign() instead. 
    */
    void copy(PolyMeshT _other) 
    {
        super.copy(_other);
    }

    /** Create a fresh copy of this mesh.
        This is a deep copy duplicating all data.
    */
    PolyMeshT dup() 
    {
        auto ret = new PolyMeshT;
        ret.copy(this);
        return ret;
    }

    // --- creation ---
    VertexHandle new_vertex()
    { return Kernel.new_vertex(); }

    VertexHandle new_vertex(/*const*/ ref Point _p)
    {
        VertexHandle vh = Kernel.new_vertex();
        //writefln("handle index now: ", vh.idx());
        set_point(vh, _p);
        return vh;
    }

    VertexHandle add_vertex(/*const*/ ref Point _p)
    { return new_vertex(_p); }

    // --- normal vectors ---

    /** \name Normal vector computation
     */
    //@{

    /** Calls update_face_normals() and update_vertex_normals() if
        these normals (i.e. the properties) exist */
    void update_normals() {
        if (Kernel.has_face_normals())    update_face_normals();
        if (Kernel.has_vertex_normals())  update_vertex_normals();
    }

    /// Update normal for face _fh
    void update_normal(FaceHandle _fh)
    { set_normal(_fh, calc_face_normal(_fh)); }

    /** Update normal vectors for all faces.
        \attention Needs the Attributes.Normal attribute for faces. */
    void update_face_normals() {
        FaceIter f_it=(Kernel.faces_begin()), f_end=(Kernel.faces_end());

        for (; f_it != f_end; ++f_it)
            set_normal(f_it.handle(), calc_face_normal(f_it.handle()));
    }

    /** Calculate normal vector for face _fh. */
    Normal calc_face_normal(FaceHandle _fh) /*const*/
    {
        assert(halfedge_handle(_fh).is_valid());
        ConstFaceVertexIter fv_it = cfv_iter(_fh);

        Point p0 = point(fv_it.handle);  ++fv_it;
        Point p1 = point(fv_it.handle);  ++fv_it;
        Point p2 = point(fv_it.handle);

        return calc_face_normal(p0, p1, p2);
    }

    /** Calculate normal vector for face (_p0, _p1, _p2). */
    Normal calc_face_normal(/*const*/ ref Point _p0, /*const*/ ref Point _p1,
                            /*const*/ ref Point _p2) /*const*/
    {
        version(all) {
            // The OpenSG <Vector>.operator -= () does not support the type Point
            // as rhs. Therefore use vector_cast at this point!!!
            // Note! OpenSG distinguishes between Normal and Point!!!
            Normal p1p0=(_p0);  p1p0 -= vector_cast!(Normal)(_p1);
            Normal p1p2=(_p2);  p1p2 -= vector_cast!(Normal)(_p1);

            Normal n    = cross(p1p2, p1p0);
            Scalar norm = n.norm();

            // The expression ((n *= (1.0/norm)),n) is used because the OpenSG
            // vector class does not return self after component-wise
            // self-multiplication with a scalar!!!
            return (norm != cast(Scalar)0) ? ((n *= ((cast(Scalar)1)/norm)),n) : Normal(0,0,0);
        } else {
            Point p1p0 = _p0;  p1p0 -= _p1;
            Point p1p2 = _p2;  p1p2 -= _p1;

            Normal n = vector_cast!(Normal)(cross(p1p2, p1p0));
            Scalar norm = n.length();

            return (norm != 0.0) ? n *= (1.0/norm) : Normal(0,0,0);
        }
    }
    // calculates the average of the vertices defining _fh 
    void calc_face_centroid(FaceHandle _fh, ref Point _pt) /*const*/
    {
        _pt.vectorize(0);
        uint valence = 0;
        for (ConstFaceVertexIter cfv_it = cfv_iter(_fh); cfv_it.is_active; ++cfv_it, ++valence)
        {
            _pt += point(cfv_it.handle);
        }
        _pt /= valence;
    }

    /// Update normal for vertex _vh
    void update_normal(VertexHandle _vh)
    { set_normal(_vh, calc_vertex_normal(_vh)); }

    /** Update normal vectors for all vertices. \attention Needs the
        Attributes.Normal attribute for faces and vertices. */
    void update_vertex_normals()
    {
        VertexIter  v_it = (Kernel.vertices_begin()), v_end = (Kernel.vertices_end());

        for (; v_it!=v_end; ++v_it)
            set_normal(v_it.handle(), calc_vertex_normal(v_it.handle()));

    }

    /** Calculate normal vector for vertex _vh by averaging normals
        of adjacent faces. Face normals have to be computed first.
        \attention Needs the Attributes.Normal attribute for faces. */
    Normal calc_vertex_normal(VertexHandle _vh) /*const*/ {
        Normal n;
        calc_vertex_normal_fast(_vh,n);

        Scalar norm = n.norm();
        if (norm != cast(Scalar)(0.0)) n *= (cast(Scalar)(1.0)/norm);

        return n;
    }

    /** Different methods for calculation of the normal at _vh:
        - -"-_fast    - the default one - the same as calc vertex_normal()
        - needs the Attributes.Normal attribute for faces
        - -"-_correct - works properly for non-triangular meshes
        - does not need any attributes
        - -"-_loop    - calculates loop surface normals
        - does not need any attributes */
    void calc_vertex_normal_fast(VertexHandle _vh, ref Normal _n) /*const*/
    {
        _n.vectorize(0.0);
        for (ConstVertexFaceIter vf_it=cvf_iter(_vh); vf_it.is_active; ++vf_it) {
            _n += normal(vf_it.handle);
        }
    }


    void calc_vertex_normal_correct(VertexHandle _vh, ref Normal _n) /*const*/
    {
        _n.vectorize(0.0);
        ConstVertexIHalfedgeIter cvih_it = cvih_iter(_vh);
        if (!cvih_it.is_active)
        {//don't crash on isolated vertices
            return;
        }
        Normal in_he_vec;
        calc_edge_vector(cvih_it.handle, in_he_vec);
        for ( ; cvih_it.is_active; ++cvih_it)
        {//calculates the sector normal defined by cvih_it and adds it to _n
            if (is_boundary(cvih_it.handle))
            {
                continue;
            }
            HalfedgeHandle out_heh = (next_halfedge_handle(cvih_it.handle));
            Normal out_he_vec;
            calc_edge_vector(out_heh, out_he_vec);
            _n += cross(in_he_vec, out_he_vec);//sector area is taken into account
            in_he_vec = out_he_vec;
            in_he_vec *= -1;//change the orientation
        }
    }

version(LoopSingletonWorks) {
    static LoopSchemeMaskDouble loop_scheme_mask__ = null;
}
    void calc_vertex_normal_loop(VertexHandle _vh, ref Normal _n) /*const*/
    {
version(LoopSingletonWorks) {
        if (!loop_scheme_mask__) 
            loop_scheme_mask__ = 
                LoopSchemeMaskDoubleSingleton.Instance();

        auto t_v = Normal(0.0, 0.0, 0.0);
        auto t_w = Normal(0.0, 0.0, 0.0);
        uint vh_val = valence(_vh);
        uint i = 0;
        for (ConstVertexOHalfedgeIter cvoh_it = cvoh_iter(_vh); cvoh_it.is_active; ++cvoh_it, ++i)
        {
            VertexHandle r1_v = (to_vertex_handle(cvoh_it.handle));
            t_v += cast(Point.value_type)(loop_scheme_mask__.tang0_weight(vh_val, i))*point(r1_v);
            t_w += cast(Point.value_type)(loop_scheme_mask__.tang1_weight(vh_val, i))*point(r1_v);
        }
        _n = cross(t_w, t_v);//hack: should be cross(t_v, t_w), but then the normals are reversed?
} else {
  assert(false, "Due to linker bug, this function is commented out");
}
    }


    //@}

    // --- Geometry API - still in development ---

    /** Calculates the edge vector as the vector defined by
        the halfedge with id #0 (see below)  */
    void calc_edge_vector(EdgeHandle _eh, ref Normal _edge_vec) /*const*/
    { calc_edge_vector(halfedge_handle(_eh,0), _edge_vec); }

    /** Calculates the edge vector as the difference of the
        the points defined by to_vertex_handle() and from_vertex_handle() */
    void calc_edge_vector(HalfedgeHandle _heh, ref Normal _edge_vec) /*const*/
    {
        _edge_vec = point(to_vertex_handle(_heh));
        _edge_vec -= point(from_vertex_handle(_heh));
    }

    // Calculates the length of the edge _eh
    Scalar calc_edge_length(EdgeHandle _eh) /*const*/
    { return calc_edge_length(halfedge_handle(_eh,0)); }

    /** Calculates the length of the edge _heh
     */
    Scalar calc_edge_length(HalfedgeHandle _heh) /*const*/
    { return cast(Scalar)Math.sqrt(calc_edge_sqr_length(_heh)); }

    Scalar calc_edge_sqr_length(EdgeHandle _eh) /*const*/
    { return calc_edge_sqr_length(halfedge_handle(_eh,0)); }

    Scalar calc_edge_sqr_length(HalfedgeHandle _heh) /*const*/
    {
        Normal edge_vec;
        calc_edge_vector(_heh, edge_vec);
        return edge_vec.sqrnorm();
    }

    /** defines a consistent representation of a sector geometry:
        the halfedge _in_heh defines the sector orientation
        the vertex pointed by _in_heh defines the sector center
        _vec0 and _vec1 are resp. the first and the second vectors defining the sector */
    void calc_sector_vectors(HalfedgeHandle _in_heh, ref Normal _vec0, ref Normal _vec1) /*const*/
    {
        calc_edge_vector(next_halfedge_handle(_in_heh), _vec0);//p2 - p1
        calc_edge_vector(opposite_halfedge_handle(_in_heh), _vec1);//p0 - p1
    }

    /** calculates the sector angle
        NOTE: only boundary concave sectors are treated correctly */
    Scalar calc_sector_angle(HalfedgeHandle _in_heh) /*const*/
    {
        Normal v0, v1;
        calc_sector_vectors(_in_heh, v0, v1);
        Scalar denom = v0.norm()*v1.norm();
        if (Math.is_zero(denom))
        {
            return 0;
        }
        Scalar cos_a = dot(v0,v1)/denom;
        if (is_boundary(_in_heh))
        {//determine if the boundary sector is concave or convex
            FaceHandle fh = face_handle(opposite_halfedge_handle(_in_heh));
            Normal f_n = calc_face_normal(fh);//this normal is (for convex fh) OK
            Scalar sign_a = dot(cross(v0, v1), f_n);
            return Math.angle(cos_a, sign_a);
        }
        else
        {
            return Math.acos(Math.sane_aarg(cos_a));
        }
    }

    // calculate the cos and the sin of angle <(_in_heh,next_halfedge(_in_heh))
    /+
     void calc_sector_angle_cos_sin(HalfedgeHandle _in_heh, Scalar& _cos_a, Scalar& _sin_a) /*const*/
     {
     Normal in_vec, out_vec;
     calc_edge_vector(_in_heh, in_vec);
     calc_edge_vector(next_halfedge_handle(_in_heh), out_vec);
     Scalar denom = in_vec.norm()*out_vec.norm();
     if (is_zero(denom))
     {
     _cos_a = 1;
     _sin_a = 0;
     }
     else
     {
     _cos_a = dot(in_vec, out_vec)/denom;
     _sin_a = cross(in_vec, out_vec).norm()/denom;
     }
     }
     +/
    /** calculates the normal (non-normalized) of the face sector defined by
        the angle <(_in_heh,next_halfedge(_in_heh)) */
    void calc_sector_normal(HalfedgeHandle _in_heh, ref Normal _sector_normal) /*const*/
    {
        Normal vec0, vec1;
        calc_sector_vectors(_in_heh, vec0, vec1);
        _sector_normal = cross(vec0, vec1);//(p2-p1)^(p0-p1)
    }

    /** calculates the area of the face sector defined by
        the angle <(_in_heh,next_halfedge(_in_heh))
        NOTE: special cases (e.g. concave sectors) are not handled correctly */
    Scalar calc_sector_area(HalfedgeHandle _in_heh) /*const*/
    {
        Normal sector_normal;
        calc_sector_normal(_in_heh, sector_normal);
        return sector_normal.norm()/2;
    }

    /** calculates the dihedral angle on the halfedge _heh
        \attention Needs the Attributes.Normal attribute for faces */
    Scalar calc_dihedral_angle_fast(HalfedgeHandle _heh) /*const*/
    {
        assert(Kernel.has_face_normals());
        if (is_boundary(edge_handle(_heh)))
        {//the dihedral angle at a boundary edge is 0
            return 0;
        }
        /*const*/ Normal n0 = normal(face_handle(_heh));
        /*const*/ Normal n1 = normal(face_handle(opposite_halfedge_handle(_heh)));
        Normal he;
        calc_edge_vector(_heh, he);
        Scalar da_cos = dot(n0, n1);
        //should be normalized, but we need only the sign
        Scalar da_sin_sign = dot(cross(n0, n1), he);
        return Math.angle(da_cos, da_sin_sign);
    }

    /** calculates the dihedral angle on the edge _eh
        \attention Needs the Attributes.Normal attribute for faces */
    Scalar calc_dihedral_angle_fast(EdgeHandle _eh) /*const*/
    { return calc_dihedral_angle_fast(halfedge_handle(_eh,0)); }

    // calculates the dihedral angle on the halfedge _heh
    Scalar calc_dihedral_angle(HalfedgeHandle _heh) /*const*/
    {
        if (is_boundary(edge_handle(_heh)))
        {//the dihedral angle at a boundary edge is 0
            return 0;
        }
        Normal n0, n1, he;
        calc_sector_normal(_heh, n0);
        calc_sector_normal(opposite_halfedge_handle(_heh), n1);
        calc_edge_vector(_heh, he);
        Scalar denom = n0.norm()*n1.norm();
        if (denom == cast(Scalar)0)
        {
            return 0;
        }
        Scalar da_cos = dot(n0, n1)/denom;
        //should be normalized, but we need only the sign
        Scalar da_sin_sign = dot(cross(n0, n1), he);
        return Math.angle(da_cos, da_sin_sign);
    }

    // calculates the dihedral angle on the edge _eh
    Scalar calc_dihedral_angle(EdgeHandle _eh) /*const*/
    { return calc_dihedral_angle(halfedge_handle(_eh,0)); }

    /** tags an edge as a feature if its dihedral angle is larger than _angle_tresh
        returns the number of the found feature edges, requires edge_status property*/
    uint find_feature_edges(Scalar _angle_tresh = Math.deg_to_rad(44.0))
    {
        assert(Kernel.has_edge_status());//this function needs edge status property
        uint n_feature_edges = 0;
        for (EdgeIter e_it = Kernel.edges_begin(); e_it != Kernel.edges_end(); ++e_it)
        {
            if (Math.fabs(calc_dihedral_angle(e_it.handle)) > _angle_tresh)
            {//note: could be optimized by comparing cos(dih_angle) vs. cos(_angle_tresh)
                estatus_ptr(e_it.handle).set_feature(true);
                n_feature_edges++;
            }
            else
            {
                estatus_ptr(e_it.handle).set_feature(false);
            }
        }
        return n_feature_edges;
    }
    // --- misc ---

    /// Face split (= 1-to-n split)
    void split(FaceHandle _fh, /*const*/ ref Point _p)
    { Kernel.split(_fh, add_vertex(_p)); }

    void split(FaceHandle _fh, VertexHandle _vh)
    { Kernel.split(_fh, _vh); }

    void split(EdgeHandle _eh, /*const*/ ref Point _p)
    // only TriConnectivity has this one
    { Kernel.split(_eh, add_vertex(_p)); }

    void split(EdgeHandle _eh, VertexHandle _vh)
    // only TriConnectivity has this one
    { Kernel.split(_eh, _vh); }
}

unittest
{
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
