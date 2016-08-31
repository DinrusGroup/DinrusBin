//============================================================================
// ArrayKernel.d -
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

module auxd.OpenMesh.Core.Mesh.ArrayKernel;


//=============================================================================
//
//  CLASS ArrayKernel
//
//=============================================================================


//== INCLUDES =================================================================
import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Utils.GenProg;
import util = auxd.OpenMesh.Core.Utils.Std;
alias util.array_iterator array_iterator;
alias util.array_iter_begin array_iter_begin;
alias util.array_iter_end   array_iter_end;

import auxd.OpenMesh.Core.Mesh.ArrayItems;
import auxd.OpenMesh.Core.Utils.Property;
import auxd.OpenMesh.Core.Mesh.BaseKernel;
import auxd.OpenMesh.Core.Mesh.Status;
import auxd.OpenMesh.Core.Mesh.IteratorsT;
import auxd.OpenMesh.Core.Mesh.Handles;

import std.io;

//== CLASS DEFINITION =========================================================
/** \ingroup mesh_kernels_group

    Mesh kernel using arrays for mesh item storage.

    This mesh kernel uses the std.vector as container to store the
    mesh items. Therefore all handle types are internally represented
    by integers. To get the index from a handle use the handle's \c
    idx() method.

    \note For a description of the minimal kernel interface see
    auxd.OpenMesh.Mesh.BaseKernel.
    \note You do not have to use this class directly, use the predefined
    mesh-kernel combinations in \ref mesh_types_group.
    See_Also: auxd.OpenMesh.Concepts.KernelT, \ref mesh_type
*/

/+
private template RefcountPropMixin(PropHandleT, char[] propname="v:status")
{
    PropHandleT prop;
    uint  refcount = 0;
    void request(ArrayKernel kern) {
        if (!refcount++)
            kern.add_property( prop, propname );
    }
    void release(ArrayKernel kern) {
        if ((refcount > 0) && (! --refcount))
            kern.remove_property(prop);
    }
    bool is_valid() { return prop.is_valid(); }
} +/


class ArrayKernel : public BaseKernel
{
  public:

    mixin ArrayItemsMixin!(); // defines Vertex,Face,Edge,Halfedge etc types

    // handles
    alias auxd.OpenMesh.Core.Mesh.Handles.VertexHandle            VertexHandle;
    alias auxd.OpenMesh.Core.Mesh.Handles.HalfedgeHandle          HalfedgeHandle;
    alias auxd.OpenMesh.Core.Mesh.Handles.EdgeHandle              EdgeHandle;
    alias auxd.OpenMesh.Core.Mesh.Handles.FaceHandle              FaceHandle;
    alias auxd.OpenMesh.Core.Mesh.Status.StatusInfo               StatusInfo;
    alias VPropHandleT!(StatusInfo) VertexStatusPropertyHandle;
    alias HPropHandleT!(StatusInfo) HalfedgeStatusPropertyHandle;
    alias EPropHandleT!(StatusInfo) EdgeStatusPropertyHandle;
    alias FPropHandleT!(StatusInfo) FaceStatusPropertyHandle;

  public:

    // --- constructor/destructor ---
    this() {
        init_bit_masks(); //Status bit masks initialization
    }
    ~this() {
        // not a good idea in a gc world?
        // clear();
    }

    template _copy_status(alias status, alias ostatus)
    {
        void exec(ArrayKernel This, ArrayKernel That) {
            if (ostatus.is_valid) {
                if (!status.is_valid) {
                    status.request(This);
                }
                status.refcount = 1;
                This[status.prop] = That.property(ostatus.prop).dup;
            } 
            else if(status.is_valid) {
                status.refcount = 0;
                This.remove_property(status.prop);
            }
        }
    }

    /** Deep copy of the ArrayKernel */
    void copy(ArrayKernel _other) 
    {
        // BaseKernel will copy all the properties for us.
        super.copy(_other);

        //mixin _copy_status!(vstatus_, _other.vstatus_) v_; v_.exec(this,_other);

        // Since BaseKernel copied the actual properties, we just have to 
        // update our handles and refcounts to reflect reality here
        if (get_property_handle( vstatus_, "v:status" )) {
            refcount_vstatus_ = 1;
        }
        if (get_property_handle( hstatus_, "h:status" )) {
            refcount_hstatus_ = 1;
        }
        if (get_property_handle( vstatus_, "e:status" )) {
            refcount_estatus_ = 1;
        }
        if (get_property_handle( vstatus_, "f:status" )) {
            refcount_fstatus_ = 1;
        }
        
        // Copy connectivity info
        vertices_ = _other.vertices_.dup;
        edges_ = _other.edges_.dup;
        faces_ = _other.faces_.dup;

        // Copy bitmasks
        halfedge_bit_masks_ = _other.halfedge_bit_masks_.dup;
        edge_bit_masks_     = _other.edge_bit_masks_.dup;
        vertex_bit_masks_   = _other.vertex_bit_masks_.dup;
        face_bit_masks_     = _other.face_bit_masks_.dup;
    }

    /** ArrayKernel uses the default copy constructor and assignment operator, which means
        that the connectivity and all properties are copied, including reference
        counters, allocated bit status masks, etc.. In contrast assign_connectivity
        copies only the connectivity, i.e. vertices, edges, faces and their status fields.
        NOTE: The geometry (the points property) is NOT copied. Poly/TriConnectivity
        override(and hide) that function to provide connectivity consistence.*/
    void assign_connectivity(/*const*/ ArrayKernel _other)
    {
        vertices_ = _other.vertices_.dup;
        edges_ = _other.edges_.dup;
        faces_ = _other.faces_.dup;

        vprops_resize(n_vertices());
        hprops_resize(n_halfedges());
        eprops_resize(n_edges());
        fprops_resize(n_faces());

        /+
        if (_other.vstatus_.is_valid()) {
            if (!vstatus_.is_valid()) {
                request_vertex_status();
            }
            (this)[vstatus_] = _other.property(_other.vstatus_).dup;
        }

        if (_other.hstatus_.is_valid()) {
            if (!hstatus_.is_valid()) {
                request_halfedge_status();
            }
            (this)[hstatus_] = _other.property(_other.hstatus_).dup;
        }

        if (_other.estatus_.is_valid()) {
            if (!estatus_.is_valid()) {
                request_edge_status();
            }
            (this)[estatus_] = _other.property(_other.estatus_).dup;
        }

        if (_other.fstatus_.is_valid()) {
            if (!fstatus_.is_valid()) {
                request_face_status();
            }
            (this)[fstatus_] = _other.property(_other.fstatus_).dup;
        }
        +/
    }

    // --- handle -> item ---
    VertexHandle handle(/*const*/ Vertex* _v) /*const*/
    {
        return VertexHandle(_v - vertices_.ptr); 
    }

    HalfedgeHandle handle(/*const*/ Halfedge* _he) /*const*/
    {
        uint eh = ((cast(char*)&edges_[0] - cast(char*)&_he) % (Edge.sizeof));
        assert((_he == &edges_[eh].halfedges_[0]) ||
               (_he == &edges_[eh].halfedges_[1]));
        return ((_he == &edges_[eh].halfedges_[0]) ?
                HalfedgeHandle(eh<<1) : HalfedgeHandle((eh<<1)+1));
    }

    EdgeHandle handle(/*const*/ Edge* _e) /*const*/
    { return EdgeHandle(_e - &edges_[0]); }

    FaceHandle handle(/*const*/ Face* _f) /*const*/
    { return FaceHandle(_f - &faces_[0]); }

    //checks handle validity - useful for debugging
    bool is_valid_handle(VertexHandle _vh) /*const*/
    { return is_valid_vhandle(_vh); }

    bool is_valid_handle(HalfedgeHandle _heh) /*const*/
    { return is_valid_hhandle(_heh); }

    bool is_valid_handle(EdgeHandle _eh) /*const*/
    { return is_valid_ehandle(_eh); }

    bool is_valid_handle(FaceHandle _fh) /*const*/
    { return is_valid_fhandle(_fh); }

    //checks handle validity - useful for debugging
    bool is_valid_vhandle(VertexHandle _vh) /*const*/
    { return 0 <= _vh.idx() && _vh.idx() < cast(int)(n_vertices()); }

    bool is_valid_hhandle(HalfedgeHandle _heh) /*const*/
    { return 0 <= _heh.idx() && _heh.idx() < cast(int)(n_edges()*2); }

    bool is_valid_ehandle(EdgeHandle _eh) /*const*/
    { return 0 <= _eh.idx() && _eh.idx() < cast(int)(n_edges()); }

    bool is_valid_fhandle(FaceHandle _fh) /*const*/
    { return 0 <= _fh.idx() && _fh.idx() < cast(int)(n_faces()); }

    // --- item -> handle ---
    Vertex* vertex_ptr(VertexHandle _vh)
    {
        assert(is_valid_vhandle(_vh), "VertexHandle is not valid");
        return &vertices_[_vh.idx()];
    }

    Halfedge* halfedge_ptr(HalfedgeHandle _heh)
    {
        assert(is_valid_hhandle(_heh), "HalfedgeHandle is not valid");
        return &edges_[_heh.idx() >> 1].halfedges_[_heh.idx() & 1];
    }

    Edge* edge_ptr(EdgeHandle _eh)
    {
        assert(is_valid_ehandle(_eh), "EdgeHandle is not valid");
        return &edges_[_eh.idx()];
    }

    Face* face_ptr(FaceHandle _fh)
    {
        assert(is_valid_fhandle(_fh), "FaceHandle is not valid");
        return &faces_[_fh.idx()];
    }

    /+
    /*const*/ Vertex* vertex_ptr(VertexHandle _vh) /*const*/
    {
        assert(is_valid_vhandle(_vh));
        return &vertices_[_vh.idx()];
    }

    /*const*/ Halfedge* halfedge_ptr(HalfedgeHandle _heh) /*const*/
    {
        assert(is_valid_hhandle(_heh));
        return &edges_[_heh.idx() >> 1].halfedges_[_heh.idx() & 1];
    }

    /*const*/ Edge* edge_ptr(EdgeHandle _eh) /*const*/
    {
        assert(is_valid_handle(_eh));
        return &edges_[_eh.idx()];
    }

    /*const*/ Face* face_ptr(FaceHandle _fh) /*const*/
    {
        assert(is_valid_handle(_fh));
        return &faces_[_fh.idx()];
    }
    +/

    // --- get i'th items ---

    VertexHandle vertex_handle(uint _i) /*const*/
    { return (_i < n_vertices()) ? handle( &vertices_[_i] ) : VertexHandle(); }

    HalfedgeHandle halfedge_handle(uint _i) /*const*/
    {
        return (_i < n_halfedges()) ?
            halfedge_handle(edge_handle(_i/2), _i%2) : HalfedgeHandle();
    }

    EdgeHandle edge_handle(uint _i) /*const*/
    { return (_i < n_edges()) ? handle(&edges_[_i]) : EdgeHandle(); }

    FaceHandle face_handle(uint _i) /*const*/
    { return (_i < n_faces()) ? handle(&faces_[_i]) : FaceHandle(); }

  public:

    VertexHandle new_vertex()
    {
        Vertex v;
        vertices_ ~= v;
        vprops_resize(n_vertices());//TODO:should it be push_back()?

        VertexHandle hdl =  handle(&vertices_[$-1]);
        return hdl;
    }

    HalfedgeHandle new_edge(VertexHandle _start_vh, VertexHandle _end_vh)
    {
//     assert(_start_vh != _end_vh);
        Edge e;
        edges_ ~= e;
        eprops_resize(n_edges());//TODO:should it be push_back()?
        hprops_resize(n_halfedges());//TODO:should it be push_back()?

        EdgeHandle eh = (handle(&edges_[$-1]));
        HalfedgeHandle heh0 = (halfedge_handle(eh, 0));
        HalfedgeHandle heh1 = (halfedge_handle(eh, 1));
        set_vertex_handle(heh0, _end_vh);
        set_vertex_handle(heh1, _start_vh);
        return heh0;
    }

    FaceHandle new_face()
    {
        Face f;
        faces_ ~= f;
        fprops_resize(n_faces());
        return handle(&faces_[$-1]);
    }

    FaceHandle new_face(/*const*/ ref Face _f)
    {
        faces_ ~= _f;
        fprops_resize(n_faces());
        return handle(&faces_[$-1]);
    }

  public:
    // --- resize/reserve ---
    void resize( uint _n_vertices, uint _n_edges, uint _n_faces ) {
        vertices_.length = _n_vertices;
        edges_.length = _n_edges;
        faces_.length = _n_faces;

        vprops_resize(n_vertices());
        hprops_resize(n_halfedges());
        eprops_resize(n_edges());
        fprops_resize(n_faces());
    }
    void reserve(uint _n_vertices, uint _n_edges, uint _n_faces ) {
        util.reserve(vertices_, _n_vertices);
        util.reserve(edges_, _n_edges);
        util.reserve(faces_, _n_faces);

        vprops_reserve(_n_vertices);
        hprops_reserve(_n_edges*2);
        eprops_reserve(_n_edges);
        fprops_reserve(_n_faces);
    }

    // --- deletion ---
    void garbage_collection(bool _v=true, bool _e=true, bool _f=true) 
    {
        int i, i0, i1, nV=(n_vertices()), nE=(n_edges()), nH=(2*n_edges()), nF=(n_faces());

        VertexHandle[]    vh_map;
        HalfedgeHandle[]  hh_map;
        FaceHandle[]      fh_map;

        // setup handle mapping:
        util.reserve(vh_map,cast(uint)nV);
        for (i=0; i<nV; ++i) vh_map ~= VertexHandle(i);

        util.reserve(hh_map, cast(uint)nH);
        for (i=0; i<nH; ++i) hh_map ~= HalfedgeHandle(i);

        util.reserve(fh_map,cast(uint)nF);
        for (i=0; i<nF; ++i) fh_map ~= FaceHandle(i);

        // remove deleted vertices
        if (_v && n_vertices() > 0)
        {
            i0=0;  i1=nV-1;

            while (1)
            {
                // find 1st deleted and last un-deleted
                while (!vstatus_ptr(VertexHandle(i0)).deleted() && i0 < i1)  ++i0;
                while ( vstatus_ptr(VertexHandle(i1)).deleted() && i0 < i1)  --i1;
                if (i0 >= i1) break;

                // swap
                util.swap(vertices_[i0], vertices_[i1]);
                util.swap(vh_map[i0],  vh_map[i1]);
                vprops_swap(i0, i1);
            };

            vertices_.length = (vstatus_ptr(VertexHandle(i0)).deleted() ? i0 : i0+1);
            vprops_resize(n_vertices());
        }


        // remove deleted edges
        if (_e && n_edges() > 0)
        {
            i0=0;  i1=nE-1;

            while (1)
            {
                // find 1st deleted and last un-deleted
                while (!estatus_ptr(EdgeHandle(i0)).deleted() && i0 < i1)  ++i0;
                while ( estatus_ptr(EdgeHandle(i1)).deleted() && i0 < i1)  --i1;
                if (i0 >= i1) break;

                // swap
                util.swap(edges_[i0], edges_[i1]);
                util.swap(hh_map[2*i0], hh_map[2*i1]);
                util.swap(hh_map[2*i0+1], hh_map[2*i1+1]);
                eprops_swap(i0, i1);
                hprops_swap(2*i0,   2*i1);
                hprops_swap(2*i0+1, 2*i1+1);
            };

            edges_.length = (estatus_ptr(EdgeHandle(i0)).deleted() ? i0 : i0+1);
            eprops_resize(n_edges());
            hprops_resize(n_halfedges());
        }


        // remove deleted faces
        if (_f && n_faces() > 0)
        {
            i0=0;  i1=nF-1;

            while (1)
            {
                // find 1st deleted and last un-deleted
                while (!fstatus_ptr(FaceHandle(i0)).deleted() && i0 < i1)  ++i0;
                while ( fstatus_ptr(FaceHandle(i1)).deleted() && i0 < i1)  --i1;
                if (i0 >= i1) break;

                // swap
                util.swap(faces_[i0], faces_[i1]);
                util.swap(fh_map[i0], fh_map[i1]);
                fprops_swap(i0, i1);
            };

            faces_.length = (fstatus_ptr(FaceHandle(i0)).deleted() ? i0 : i0+1);
            fprops_resize(n_faces());
        }


        // update handles of vertices
        if (_e)
        {
            KernelVertexIter v_it=(vertices_begin()), v_end=(vertices_end());
            VertexHandle     vh;

            for (; v_it!=v_end; ++v_it)
            {
                vh = handle(v_it.ptr);
                if (!is_isolated(vh))
                {
                    set_halfedge_handle(vh, hh_map[halfedge_handle(vh).idx()]);
                }
            }
        }

        HalfedgeHandle hh;
        // update handles of halfedges
        for (KernelEdgeIter e_it=(edges_begin()); e_it != edges_end(); ++e_it)
        {//in the first pass update the (half)edges vertices
            hh = halfedge_handle(handle(e_it.ptr), 0);
            set_vertex_handle(hh, vh_map[to_vertex_handle(hh).idx()]);
            hh = halfedge_handle(handle(e_it.ptr), 1);
            set_vertex_handle(hh, vh_map[to_vertex_handle(hh).idx()]);
        }
        for (KernelEdgeIter e_it=(edges_begin()); e_it != edges_end(); ++e_it)
        {//in the second pass update the connectivity of the (half)edges
            hh = halfedge_handle(handle(e_it.ptr), 0);
            set_next_halfedge_handle(hh, hh_map[next_halfedge_handle(hh).idx()]);
            if (!is_boundary(hh))
            {
                set_face_handle(hh, fh_map[face_handle(hh).idx()]);
            }
            hh = halfedge_handle(handle(e_it.ptr), 1);
            set_next_halfedge_handle(hh, hh_map[next_halfedge_handle(hh).idx()]);
            if (!is_boundary(hh))
            {
                set_face_handle(hh, fh_map[face_handle(hh).idx()]);
            }
        }

        // update handles of faces
        if (_e)
        {
            KernelFaceIter  f_it=(faces_begin()), f_end=(faces_end());
            FaceHandle      fh;

            for (; f_it!=f_end; ++f_it)
            {
                fh = handle(f_it.ptr);
                set_halfedge_handle(fh, hh_map[halfedge_handle(fh).idx()]);
            }
        }
    }
    void clear() {
        vertices_.length = 0;
        edges_.length = 0;
        faces_.length = 0;

        vprops_resize(0);
        eprops_resize(0);
        hprops_resize(0);
        fprops_resize(0);
    }

    // --- number of items ---
    uint n_vertices()  /*const*/ { return vertices_.length; }
    uint n_halfedges() /*const*/ { return 2*edges_.length; }
    uint n_edges()     /*const*/ { return edges_.length; }
    uint n_faces()     /*const*/ { return faces_.length; }

    bool vertices_empty()  /*const*/ { return vertices_.length == 0; }
    bool halfedges_empty() /*const*/ { return edges_.length == 0; }
    bool edges_empty()     /*const*/ { return edges_.length == 0; }
    bool faces_empty()     /*const*/ { return faces_.length == 0; }

    // --- vertex connectivity ---

    HalfedgeHandle halfedge_handle(VertexHandle _vh) /*const*/
    { return vertex_ptr(_vh).halfedge_handle_; }

    void set_halfedge_handle(VertexHandle _vh, HalfedgeHandle _heh)
    {
//     assert(is_valid_handle(_heh));
        vertex_ptr(_vh).halfedge_handle_ = _heh;
    }

    bool is_isolated(VertexHandle _vh) /*const*/
    { return !halfedge_handle(_vh).is_valid(); }

    void set_isolated(VertexHandle _vh)
    { vertex_ptr(_vh).halfedge_handle_.invalidate(); }

    uint delete_isolated_vertices() {
        assert(has_vertex_status());//this function requires vertex status property
        uint n_isolated = 0;
        for (KernelVertexIter v_it = vertices_begin(); v_it != vertices_end(); ++v_it)
        {
            if (is_isolated(handle(v_it.ptr)))
            {
                vstatus_ptr(handle(v_it.ptr)).set_deleted(true);
                n_isolated++;
            }
        }
        return n_isolated;
    }

    // --- halfedge connectivity ---
    VertexHandle to_vertex_handle(HalfedgeHandle _heh) /*const*/
    { return halfedge_ptr(_heh).vertex_handle_; }

    VertexHandle from_vertex_handle(HalfedgeHandle _heh) /*const*/
    { return to_vertex_handle(opposite_halfedge_handle(_heh)); }

    void set_vertex_handle(HalfedgeHandle _heh, VertexHandle _vh)
    {
//     assert(is_valid_handle(_vh));
        halfedge_ptr(_heh).vertex_handle_ = _vh;
    }

    FaceHandle face_handle(HalfedgeHandle _heh) /*const*/
    { return halfedge_ptr(_heh).face_handle_; }

    void set_face_handle(HalfedgeHandle _heh, FaceHandle _fh)
    {
//     assert(is_valid_handle(_fh));
        halfedge_ptr(_heh).face_handle_ = _fh;
    }

    void set_boundary(HalfedgeHandle _heh)
    { halfedge_ptr(_heh).face_handle_.invalidate(); }

    /// Is halfedge _heh a boundary halfedge (is its face handle invalid) ?
    bool is_boundary(HalfedgeHandle _heh) /*const*/
    { return !face_handle(_heh).is_valid(); }

    HalfedgeHandle next_halfedge_handle(HalfedgeHandle _heh) /*const*/
    { return halfedge_ptr(_heh).next_halfedge_handle_; }

    void set_next_halfedge_handle(HalfedgeHandle _heh, HalfedgeHandle _nheh)
    {
        assert(is_valid_hhandle(_nheh));
//     assert(to_vertex_handle(_heh) == from_vertex_handle(_nheh));
        halfedge_ptr(_heh).next_halfedge_handle_ = _nheh;
        set_prev_halfedge_handle(_nheh, _heh);
    }


    void set_prev_halfedge_handle(HalfedgeHandle _heh, HalfedgeHandle _pheh)
    {
        assert(is_valid_hhandle(_pheh));
        set_prev_halfedge_handle(_heh, _pheh, HasPrevHalfedge());
    }

    void set_prev_halfedge_handle(HalfedgeHandle _heh, HalfedgeHandle _pheh,
                                  GenProg.True)
    { halfedge_ptr(_heh).prev_halfedge_handle_ = _pheh; }

    void set_prev_halfedge_handle(HalfedgeHandle _heh, HalfedgeHandle _pheh,
                                  GenProg.False)
    {}

    HalfedgeHandle prev_halfedge_handle(HalfedgeHandle _heh) /*const*/
    { return prev_halfedge_handle(_heh, HasPrevHalfedge() ); }

    HalfedgeHandle prev_halfedge_handle(HalfedgeHandle _heh, GenProg.True) /*const*/
    { return halfedge_ptr(_heh).prev_halfedge_handle_; }

    HalfedgeHandle prev_halfedge_handle(HalfedgeHandle _heh, GenProg.False) /*const*/
    {
        if (is_boundary(_heh))
        {//iterating around the vertex should be faster than iterating the boundary
            HalfedgeHandle curr_heh = (opposite_halfedge_handle(_heh));
            HalfedgeHandle next_heh = (next_halfedge_handle(curr_heh));
            do
            {
                curr_heh = opposite_halfedge_handle(next_heh);
                next_heh = next_halfedge_handle(curr_heh);
            }
            while (next_heh != _heh);
            return curr_heh;
        }
        else
        {
            HalfedgeHandle  heh = (_heh);
            HalfedgeHandle  next_heh = (next_halfedge_handle(heh));
            while (next_heh != _heh) {
                heh = next_heh;
                next_heh = next_halfedge_handle(next_heh);
            }
            return heh;
        }
    }


    HalfedgeHandle opposite_halfedge_handle(HalfedgeHandle _heh) /*const*/
    { return HalfedgeHandle((_heh.idx() & 1) ? _heh.idx()-1 : _heh.idx()+1); }


    HalfedgeHandle ccw_rotated_halfedge_handle(HalfedgeHandle _heh) /*const*/
    { return opposite_halfedge_handle(prev_halfedge_handle(_heh)); }


    HalfedgeHandle cw_rotated_halfedge_handle(HalfedgeHandle _heh) /*const*/
    { return next_halfedge_handle(opposite_halfedge_handle(_heh)); }

    // --- edge connectivity ---
    HalfedgeHandle halfedge_handle(EdgeHandle _eh, uint _i) /*const*/
    {
        assert(_i<=1);
        return HalfedgeHandle((_eh.idx() << 1) + _i);
    }

    EdgeHandle edge_handle(HalfedgeHandle _heh) /*const*/
    { return EdgeHandle(_heh.idx() >> 1); }

    // --- face connectivity ---
    HalfedgeHandle halfedge_handle(FaceHandle _fh) /*const*/
    { return face_ptr(_fh).halfedge_handle_; }

    void set_halfedge_handle(FaceHandle _fh, HalfedgeHandle _heh)
    {
//     assert(is_valid_handle(_heh));
        face_ptr(_fh).halfedge_handle_ = _heh;
    }

    /// Status Query API
    //------------------------------------------------------------ vertex status
    ///*const*/ StatusInfo* vstatus(VertexHandle _vh) /*const*/
    //{ return property(vstatus_, _vh); }

    StatusInfo* vstatus_ptr(VertexHandle _vh)
    { return property_ptr(vstatus_, _vh); }

    StatusInfo* status_ptr(VertexHandle _vh)
    { return property_ptr(vstatus_, _vh); }

    //----------------------------------------------------------- halfedge status
    ///*const*/ StatusInfo* hstatus(HalfedgeHandle _hh) /*const*/
    //{ return property(hstatus_, _hh);  }

    StatusInfo* hstatus_ptr(HalfedgeHandle _hh)
    { return property_ptr(hstatus_, _hh); }

    StatusInfo* status_ptr(HalfedgeHandle _hh)
    { return property_ptr(hstatus_, _hh); }

    //--------------------------------------------------------------- edge status
    ///*const*/ StatusInfo* estatus(EdgeHandle _eh) /*const*/
    //{ return property(estatus_, _eh); }

    StatusInfo* estatus_ptr(EdgeHandle _eh)
    { return property_ptr(estatus_, _eh); }

    StatusInfo* status_ptr(EdgeHandle _eh)
    { return property_ptr(estatus_, _eh); }

    //--------------------------------------------------------------- face status
    ///*const*/ StatusInfo* fstatus(FaceHandle _fh) /*const*/
    //{ return property(fstatus_, _fh); }

    StatusInfo* fstatus_ptr(FaceHandle _fh)
    { return property_ptr(fstatus_, _fh); }

    StatusInfo* status_ptr(FaceHandle _fh)
    { return property_ptr(fstatus_, _fh); }

    bool has_vertex_status() /*const*/
    { return vstatus_.is_valid();    }

    bool has_halfedge_status() /*const*/
    { return hstatus_.is_valid();  }

    bool has_edge_status() /*const*/
    { return estatus_.is_valid(); }

    bool has_face_status() /*const*/
    { return fstatus_.is_valid(); }

    VertexStatusPropertyHandle vertex_status_pph() /*const*/
    { return vstatus_;  }

    HalfedgeStatusPropertyHandle halfedge_status_pph() /*const*/
    { return hstatus_; }

    EdgeStatusPropertyHandle edge_status_pph() /*const*/
    { return estatus_;  }

    FaceStatusPropertyHandle face_status_pph() /*const*/
    { return fstatus_; }

    /// status property by handle
    VertexStatusPropertyHandle         status_pph(VertexHandle /*_hnd*/) /*const*/
    { return vertex_status_pph(); }

    HalfedgeStatusPropertyHandle       status_pph(HalfedgeHandle /*_hnd*/) /*const*/
    { return halfedge_status_pph(); }

    EdgeStatusPropertyHandle           status_pph(EdgeHandle /*_hnd*/) /*const*/
    { return edge_status_pph();  }

    FaceStatusPropertyHandle           status_pph(FaceHandle /*_hnd*/) /*const*/
    { return face_status_pph();  }

    /// Status Request API
    void request_vertex_status()
    {
       if (!refcount_vstatus_++)
           add_property( vstatus_, "v:status" );
    }

    void request_halfedge_status()
    {
       if (!refcount_hstatus_++)
           add_property( hstatus_, "h:status" );
    }

    void request_edge_status()
    {
       if (!refcount_estatus_++)
           add_property( estatus_, "e:status" );
    }

    void request_face_status()
    {
       if (!refcount_fstatus_++)
           add_property( fstatus_, "f:status" );
    }

    /// Status Release API
    void release_vertex_status()
    {
        if ((refcount_vstatus_ > 0) && (! --refcount_vstatus_))
            remove_property(vstatus_);
    }

    void release_halfedge_status()
    {
        if ((refcount_hstatus_ > 0) && (! --refcount_hstatus_))
            remove_property(hstatus_);
    }

    void release_edge_status()
    {
        if ((refcount_estatus_ > 0) && (! --refcount_estatus_))
            remove_property(estatus_);
    }

    void release_face_status()
    {
        if ((refcount_fstatus_ > 0) && (! --refcount_fstatus_))
            remove_property(fstatus_);
    }

    /// --- StatusSet API ---

    class StatusSetT(Handle)
    {
    protected:
        ArrayKernel*                            kernel_;

    public:
        /*const*/ uint                              bit_mask_;

    public:
        this(ref ArrayKernel _kernel, uint _bit_mask) {
            kernel_=(&_kernel), bit_mask_=(_bit_mask);
        }


        bool is_in(Handle _hnd) /*const*/
        { return kernel_.status_ptr(_hnd).is_bit_set(bit_mask_); }

        void insert(Handle _hnd)
        { return kernel_.status_ptr(_hnd).set_bit(bit_mask_); }

        void erase(Handle _hnd)
        { return kernel_.status_ptr(_hnd).unset_bit(bit_mask_); }

        /// Note: 0(n) complexity
        uint size() /*const*/
        {
            uint n_elements = kernel_.status_pph(Handle()).is_valid() ?
                kernel_.property(kernel_.status_pph(Handle())).n_elements() : 0;
            uint sz = 0;
            for (uint i = 0; i < n_elements; ++i)
            {
                sz += cast(uint)is_in(Handle(i));
            }
            return sz;
        }

        /// Note: O(n) complexity
        void                                    clear()
        {
            uint n_elements = kernel_.status_pph(Handle()).is_valid() ?
                kernel_.property(kernel_.status_pph(Handle())).n_elements() : 0;
            for (uint i = 0; i < n_elements; ++i)
            {
                erase(Handle(i));
            }
        }
    }

    /// --- AutoStatusSet API ---
    class AutoStatusSetT(Handle) : StatusSetT!(Handle)
    {
      private:
        alias StatusSetT!(Handle)              Base;
      public:
        this(ref ArrayKernel _kernel)
        { /*assert(size() == 0);*/
            super(_kernel, _kernel.pop_bit_mask(Handle()));
        } //the set should be empty on creation

        ~this()
        {
            //assert(size() == 0);//the set should be empty on leave?
            Base.kernel_.push_bit_mask(Handle(), Base.bit_mask_);
        }
    }

    alias AutoStatusSetT!(VertexHandle)      VertexStatusSet;
    alias AutoStatusSetT!(EdgeHandle)        EdgeStatusSet;
    alias AutoStatusSetT!(FaceHandle)        FaceStatusSet;
    alias AutoStatusSetT!(HalfedgeHandle)    HalfedgeStatusSet;

    /// --- ExtStatusSet API --- (hybrid between a set and an array)


    /*scope*/ class ExtStatusSetT(Handle) : AutoStatusSetT!(Handle)
    {
      public:
        alias AutoStatusSetT!(Handle)          Base;

      protected:
        alias Handle[]                          HandleContainer;
        HandleContainer                         handles_;

      public:
        alias array_iterator!(HandleContainer)  iterator;
        alias array_iterator!(HandleContainer)  const_iterator;
      public:
        this(ref ArrayKernel _kernel, uint _capacity_hint = 0)
        {
            super(_kernel);
            util.reserve(handles_, _capacity_hint);
        }

        ~this()
        { clear(); }

        //set API
        // Complexity: O(1)
        void insert(Handle _hnd)
        {
            if (!is_in(_hnd))
            {
                Base.insert(_hnd);
                handles_ ~= _hnd;
            }
        }

        /+
        // Complexity: O(k), (k - number of the elements in the set)
        void erase(Handle _hnd)
        {
            if (is_in(_hnd))
            {
                
                iterator it = begin(), _end = end();
                for(;it!=end; ++it) {
                    if (it.val == _hnd) break;
                }
                erase(it);
            }
        }
        +/

        // Complexity: O(1)
        /+
        void erase(iterator _it)
        {
            assert(_it != end() && is_in(_it.val));
            clear(_it.val);
            *_it.ptr = handles_[$-1];
            (*_it.ptr).pop_back();
        }
        +/

        void clear()
        {
            for (iterator it = begin(); it != end(); ++it)
            {
                assert(is_in(it.val));
                Base.erase(it.val);
            }
            handles_.length = 0;
        }

        /// Complexity: 0(1)
        uint size() /*const*/
        { return handles_.length; }
        bool empty() /*const*/
        { return handles_.length == 0; }

        //Vector API
        iterator begin()
        { return array_iter_begin(handles_); }

        iterator end()
        { return array_iter_end(handles_); }

        Handle front()
        { return handles_[0]; }

        Handle back()
        { return handles_[$-1]; }

        /+
        const_iterator                   begin() /*const*/
        { return handles_.begin(); }
        const_iterator                   end() /*const*/
        { return handles_.end(); }
        /*const*/ Handle*                    front() /*const*/
        { return handles_[0]; }
        /*const*/ Handle*                    back() /*const*/
        { return handles_[$-1]; }
        +/
    }

    alias ExtStatusSetT!(FaceHandle)         ExtFaceStatusSet;
    alias ExtStatusSetT!(VertexHandle)       ExtVertexStatusSet;
    alias ExtStatusSetT!(EdgeHandle)         ExtEdgeStatusSet;
    alias ExtStatusSetT!(HalfedgeHandle)     ExtHalfedgeStatusSet;

  private:
    // iterators
    alias Vertex[]                VertexContainer;
    alias Edge[]                  EdgeContainer;
    alias Face[]                  FaceContainer;
    alias array_iterator!(VertexContainer)  KernelVertexIter;
    alias array_iterator!(EdgeContainer)    KernelEdgeIter;
    alias array_iterator!(FaceContainer)    KernelFaceIter;

    alias array_iterator!(VertexContainer)  KernelConstVertexIter;
    alias array_iterator!(EdgeContainer)    KernelConstEdgeIter;
    alias array_iterator!(FaceContainer)    KernelConstFaceIter;

    alias uint[]                            BitMaskContainer;


    KernelVertexIter      vertices_begin()        { return array_iter_begin(vertices_); }
    KernelVertexIter      vertices_end()          { return array_iter_end(vertices_); }

    KernelEdgeIter        edges_begin()           { return array_iter_begin(edges_); }
    KernelEdgeIter        edges_end()             { return array_iter_end(edges_); }

    KernelFaceIter        faces_begin()           { return array_iter_begin(faces_); }
    KernelFaceIter        faces_end()             { return array_iter_end(faces_); }

    //KernelConstVertexIter vertices_begin() /*const*/  { return vertices_.begin(); }
    //KernelConstVertexIter vertices_end() /*const*/    { return vertices_.end(); }

    //KernelConstEdgeIter   edges_begin() /*const*/     { return edges_.begin(); }
    //KernelConstEdgeIter   edges_end() /*const*/       { return edges_.end(); }

    //KernelConstFaceIter   faces_begin() /*const*/     { return faces_.begin(); }
    //KernelConstFaceIter   faces_end() /*const*/       { return faces_.end(); }

    /// bit mask container by handle
    BitMaskContainer                  bit_masks(VertexHandle /*_dummy_hnd*/)
    { return vertex_bit_masks_; }
    BitMaskContainer                  bit_masks(EdgeHandle /*_dummy_hnd*/)
    { return edge_bit_masks_; }
    BitMaskContainer                  bit_masks(FaceHandle /*_dummy_hnd*/)
    { return face_bit_masks_; }
    BitMaskContainer                  bit_masks(HalfedgeHandle /*_dummy_hnd*/)
    { return halfedge_bit_masks_; }

    BitMaskContainer*                  bit_masks_ptr(VertexHandle /*_dummy_hnd*/)
    { return &vertex_bit_masks_; }
    BitMaskContainer*                  bit_masks_ptr(EdgeHandle /*_dummy_hnd*/)
    { return &edge_bit_masks_; }
    BitMaskContainer*                  bit_masks_ptr(FaceHandle /*_dummy_hnd*/)
    { return &face_bit_masks_; }
    BitMaskContainer*                  bit_masks_ptr(HalfedgeHandle /*_dummy_hnd*/)
    { return &halfedge_bit_masks_; }


    uint pop_bit_mask(Handle)(Handle _hnd)
    {
        assert(!bit_masks(_hnd).length==0);//check if the client request too many status sets
        uint bit_mask = bit_masks(_hnd)[$-1];
        auto pBM = bit_masks_ptr(_hnd);
        pBM.length = pBM.length -1;
        return bit_mask;
    }

    void push_bit_mask(Handle)(Handle _hnd, uint _bit_mask)
        in {
            //this mask should be not already used
            foreach(bm;  bit_masks(_hnd)) {
                assert(_bit_mask != bm);
            }
        }
    body
    {
        *(bit_masks_ptr(_hnd)) ~= _bit_mask;
    }

    void init_bit_masks(ref BitMaskContainer _bmc) {
        for (uint i = Attributes.UNUSED; i != 0; i <<= 1)
        {
            _bmc ~= i;
        }
    }
    void init_bit_masks() {
        init_bit_masks(vertex_bit_masks_);
        edge_bit_masks_ = vertex_bit_masks_;//init_bit_masks(edge_bit_masks_);
        face_bit_masks_ = vertex_bit_masks_;//init_bit_masks(face_bit_masks_);
        halfedge_bit_masks_= vertex_bit_masks_;//init_bit_masks(halfedge_bit_masks_);
    }

  private:
    VertexContainer                           vertices_;
    EdgeContainer                             edges_;
    FaceContainer                             faces_;
    
    VertexStatusPropertyHandle                vstatus_;
    HalfedgeStatusPropertyHandle              hstatus_;
    EdgeStatusPropertyHandle                  estatus_;
    FaceStatusPropertyHandle                  fstatus_;

    uint                                      refcount_vstatus_;
    uint                                      refcount_hstatus_;
    uint                                      refcount_estatus_;
    uint                                      refcount_fstatus_;
    /+
    mixin RefcountPropMixin!(VertexStatusPropertyHandle, "v:status")   vstatus_;
    mixin RefcountPropMixin!(HalfedgeStatusPropertyHandle, "h:status") hstatus_;
    mixin RefcountPropMixin!(EdgeStatusPropertyHandle, "e:status")     estatus_;
    mixin RefcountPropMixin!(FaceStatusPropertyHandle, "f:status")     fstatus_;
    +/
    BitMaskContainer                          halfedge_bit_masks_;
    BitMaskContainer                          edge_bit_masks_;
    BitMaskContainer                          vertex_bit_masks_;
    BitMaskContainer                          face_bit_masks_;
}

unittest{

    ArrayKernel k = new ArrayKernel;

    k.request_vertex_status();
    k.request_edge_status();
    k.request_halfedge_status();
    k.request_face_status();

    k.release_vertex_status();
    k.release_edge_status();
    k.release_halfedge_status();
    k.release_face_status();

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
