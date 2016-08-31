//============================================================================
// PolyConnectivity.d - 
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

module auxd.OpenMesh.Core.Mesh.PolyConnectivity;

import auxd.OpenMesh.Core.Mesh.ArrayKernel;
import Iterators = auxd.OpenMesh.Core.Mesh.IteratorsT;
import Circulators = auxd.OpenMesh.Core.Mesh.CirculatorsT;
import auxd.OpenMesh.Core.Mesh.Handles;
import auxd.OpenMesh.Core.IO.Streams;
import util = auxd.OpenMesh.Core.Utils.Std;
alias util.array_iter_begin array_iter_begin;
alias util.array_iter_end array_iter_end;
import auxd.OpenMesh.Core.Utils.Exceptions;


class PolyConnectivity : public ArrayKernel
{
  public:
    /// \name Mesh Handles
    //@{
    /// Invalid handle
    static VertexHandle       InvalidVertexHandle;
    /// Invalid handle
    static HalfedgeHandle     InvalidHalfedgeHandle;
    /// Invalid handle
    static EdgeHandle         InvalidEdgeHandle;
    /// Invalid handle
    static FaceHandle         InvalidFaceHandle;
    //@}

    alias PolyConnectivity    This;

    //--- iterators ---

    /** \name Mesh Iterators
      Refer to auxd.OpenMesh.Mesh.Iterators or \ref mesh_iterators for
      documentation.
     */
    //@{
    /// Linear iterator
    alias Iterators.VertexIterT!(This)                VertexIter;
    alias Iterators.HalfedgeIterT!(This)              HalfedgeIter;
    alias Iterators.EdgeIterT!(This)                  EdgeIter;
    alias Iterators.FaceIterT!(This)                  FaceIter;

    alias Iterators.ConstVertexIterT!(This)           ConstVertexIter;
    alias Iterators.ConstHalfedgeIterT!(This)         ConstHalfedgeIter;
    alias Iterators.ConstEdgeIterT!(This)             ConstEdgeIter;
    alias Iterators.ConstFaceIterT!(This)             ConstFaceIter;
    //@}

    //--- circulators ---

    /** \name Mesh Circulators
      Refer to auxd.OpenMesh.Mesh.Iterators or \ref mesh_iterators
      for documentation.
      */
    //@{
    /// Circulator
    alias Circulators.VertexVertexIterT!(This)          VertexVertexIter;
    alias Circulators.VertexOHalfedgeIterT!(This)       VertexOHalfedgeIter;
    alias Circulators.VertexIHalfedgeIterT!(This)       VertexIHalfedgeIter;
    alias Circulators.VertexEdgeIterT!(This)            VertexEdgeIter;
    alias Circulators.VertexFaceIterT!(This)            VertexFaceIter;
    alias Circulators.FaceVertexIterT!(This)            FaceVertexIter;
    alias Circulators.FaceHalfedgeIterT!(This)          FaceHalfedgeIter;
    alias Circulators.FaceEdgeIterT!(This)              FaceEdgeIter;
    alias Circulators.FaceFaceIterT!(This)              FaceFaceIter;

    alias Circulators.ConstVertexVertexIterT!(This)     ConstVertexVertexIter;
    alias Circulators.ConstVertexOHalfedgeIterT!(This)  ConstVertexOHalfedgeIter;
    alias Circulators.ConstVertexIHalfedgeIterT!(This)  ConstVertexIHalfedgeIter;
    alias Circulators.ConstVertexEdgeIterT!(This)       ConstVertexEdgeIter;
    alias Circulators.ConstVertexFaceIterT!(This)       ConstVertexFaceIter;
    alias Circulators.ConstFaceVertexIterT!(This)       ConstFaceVertexIter;
    alias Circulators.ConstFaceHalfedgeIterT!(This)     ConstFaceHalfedgeIter;
    alias Circulators.ConstFaceEdgeIterT!(This)         ConstFaceEdgeIter;
    alias Circulators.ConstFaceFaceIterT!(This)         ConstFaceFaceIter;
    //@}

    // --- shortcuts

    /** \name Alias Shortcuts
         Provided for convenience only
     */
    //@{
    /// Alias alias
    alias VertexHandle    VHandle;
    alias HalfedgeHandle  HHandle;
    alias EdgeHandle      EHandle;
    alias FaceHandle      FHandle;

    alias VertexIter    VIter;
    alias HalfedgeIter  HIter;
    alias EdgeIter      EIter;
    alias FaceIter      FIter;

    alias ConstVertexIter    CVIter;
    alias ConstHalfedgeIter  CHIter;
    alias ConstEdgeIter      CEIter;
    alias ConstFaceIter      CFIter;

    alias VertexVertexIter      VVIter;
    alias VertexOHalfedgeIter   VOHIter;
    alias VertexIHalfedgeIter   VIHIter;
    alias VertexEdgeIter        VEIter;
    alias VertexFaceIter        VFIter;
    alias FaceVertexIter        FVIter;
    alias FaceHalfedgeIter      FHIter;
    alias FaceEdgeIter          FEIter;
    alias FaceFaceIter          FFIter;

    alias ConstVertexVertexIter      CVVIter;
    alias ConstVertexOHalfedgeIter   CVOHIter;
    alias ConstVertexIHalfedgeIter   CVIHIter;
    alias ConstVertexEdgeIter        CVEIter;
    alias ConstVertexFaceIter        CVFIter;
    alias ConstFaceVertexIter        CFVIter;
    alias ConstFaceHalfedgeIter      CFHIter;
    alias ConstFaceEdgeIter          CFEIter;
    alias ConstFaceFaceIter          CFFIter;
    //@}

  public:

    this()  {}
    ~this() {}

    
    void copy(PolyConnectivity _other)
    {
        super.copy(_other);
    }


    static bool is_triangles()
    { return false; }

    /** assign_connectivity() method. See ArrayKernel.assign_connectivity()
      for more details. */
    void assign_connectivity(/*const*/ PolyConnectivity _other)
    { super.assign_connectivity(_other); }
  
    /** \name Adding items to a mesh
     */
    //@{
    /// Add a new vertex 
    VertexHandle add_vertex()
    { return new_vertex(); }

    struct NextCacheEntryT(_Handle)
    {
        _Handle first;
        _Handle second;
        static NextCacheEntryT opCall(_Handle _heh0, _Handle _heh1)
            
        {
            NextCacheEntryT M; with(M) {
                first = _heh0;
                second = _heh1;
                assert(_heh0.is_valid());
                assert(_heh1.is_valid());
            } return M;
        }
    }


    /// 

    /** Add and connect a new face. 
        A handle to the added face is returned.

        Subclasses like TriConnectivity override this method to
        triangulate any non-triangle faces added, and so may add
        more than one face with this one call.

        So If an array pointer is passed for _faces_out,
        handles to all newly added faces will be appended to it.
        It is the caller's responsibility to make sure 
        _faces_out is initially empty.
    */
    FaceHandle add_face(/*const*/ VertexHandle[] _vertex_handles,
                        FaceHandle[]* _faces_out=null)
    {
        uint _vhs_size  = _vertex_handles.length;
        VertexHandle                   vh;
        uint                           i, ii, n=(_vhs_size), id;
        HalfedgeHandle[]    halfedge_handles; halfedge_handles.length = n;
        bool[]              is_new, needs_adjust;
        is_new.length = n; 
        needs_adjust.length = n; needs_adjust[] = false;
        HalfedgeHandle
            inner_next, inner_prev,
            outer_next, outer_prev,
            boundary_next, boundary_prev,
            patch_start, patch_end;

        // cache for set_next_halfedge and vertex' set_halfedge
        alias NextCacheEntryT!(HalfedgeHandle)   NextCacheEntry;
        alias NextCacheEntry[]       NextCache;

        NextCache    next_cache;
        util.reserve(next_cache, 3*n);
        // don't allow degenerated faces
        assert (n > 2, "add_face: Degenerate face (n verts < 3)");

        // test for topological errors
        for (i=0, ii=1; i<n; ++i, ++ii, ii%=n)
        {
            if ( !is_boundary(_vertex_handles[i]) )
            {
                derr.writefln("PolyMeshT.add_face: complex vertex");
                return InvalidFaceHandle;
            }

            halfedge_handles[i] = find_halfedge(_vertex_handles[i],
                                                _vertex_handles[ii]);
            is_new[i] = !halfedge_handles[i].is_valid();

            if (!is_new[i] && !is_boundary(halfedge_handles[i]))
            {
                derr.writefln("PolyMeshT.add_face: complex edge");
                return InvalidFaceHandle;
            }
        }

        // re-link patches if necessary
        for (i=0, ii=1; i<n; ++i, ++ii, ii%=n)
        {
            if (!is_new[i] && !is_new[ii])
            {
                inner_prev = halfedge_handles[i];
                inner_next = halfedge_handles[ii];

                if (next_halfedge_handle(inner_prev) != inner_next)
                {
                    // here comes the ugly part... we have to relink a whole patch

                    // search a free gap
                    // free gap will be between boundary_prev and boundary_next
                    outer_prev = opposite_halfedge_handle(inner_next);
                    outer_next = opposite_halfedge_handle(inner_prev);
                    boundary_prev = outer_prev;
                    do
                        boundary_prev =
                            opposite_halfedge_handle(next_halfedge_handle(boundary_prev));
                    while (!is_boundary(boundary_prev) || boundary_prev==inner_prev);
                    boundary_next = next_halfedge_handle(boundary_prev);
                    assert(is_boundary(boundary_prev));
                    assert(is_boundary(boundary_next));
                    // ok ?
                    if (boundary_next == inner_next)
                    {
                        derr.writefln("PolyMeshT.add_face: patch re-linking failed");
                        return InvalidFaceHandle;
                    }

                    // other halfedges' handles
                    patch_start = next_halfedge_handle(inner_prev);
                    patch_end   = prev_halfedge_handle(inner_next);

                    // relink
                    next_cache ~= (NextCacheEntry(boundary_prev, patch_start));
                    next_cache ~= (NextCacheEntry(patch_end, boundary_next));
                    next_cache ~= (NextCacheEntry(inner_prev, inner_next));
                }
            }
        }

        // create missing edges
        for (i=0, ii=1; i<n; ++i, ++ii, ii%=n)
            if (is_new[i])
                halfedge_handles[i] = new_edge(_vertex_handles[i], _vertex_handles[ii]);

        // create the face
        FaceHandle fh=(new_face());
        set_halfedge_handle(fh, halfedge_handles[n-1]);

        // setup halfedges
        for (i=0, ii=1; i<n; ++i, ++ii, ii%=n)
        {
            vh         = _vertex_handles[ii];
            inner_prev = halfedge_handles[i];
            inner_next = halfedge_handles[ii];

            id = 0;
            if (is_new[i])  id |= 1;
            if (is_new[ii]) id |= 2;

            if (id)
            {
                outer_prev = opposite_halfedge_handle(inner_next);
                outer_next = opposite_halfedge_handle(inner_prev);

                // set outer links
                switch (id)
                {
                case 1: // prev is new, next is old
                    boundary_prev = prev_halfedge_handle(inner_next);
                    next_cache ~= (NextCacheEntry(boundary_prev, outer_next));
                    set_halfedge_handle(vh, outer_next);
                    break;

                case 2: // next is new, prev is old
                    boundary_next = next_halfedge_handle(inner_prev);
                    next_cache ~= (NextCacheEntry(outer_prev, boundary_next));
                    set_halfedge_handle(vh, boundary_next);
                    break;

                case 3: // both are new
                    if (!halfedge_handle(vh).is_valid())
                    {
                        set_halfedge_handle(vh, outer_next);
                        next_cache ~= (NextCacheEntry(outer_prev, outer_next));
                    }
                    else
                    {
                        boundary_next = halfedge_handle(vh);
                        boundary_prev = prev_halfedge_handle(boundary_next);
                        next_cache ~= (NextCacheEntry(boundary_prev, outer_next));
                        next_cache ~= (NextCacheEntry(outer_prev, boundary_next));
                    }
                    break;
                }

                // set inner link
                next_cache ~= (NextCacheEntry(inner_prev, inner_next));
            }
            else needs_adjust[ii] = (halfedge_handle(vh) == inner_next);

            // set face handle
            set_face_handle(halfedge_handles[i], fh);
        }

        // process next halfedge cache
        auto ncIt = array_iter_begin(next_cache);
        auto ncEnd = array_iter_end(next_cache);
        for (; ncIt != ncEnd; ++ncIt)
            set_next_halfedge_handle(ncIt.ptr.first, ncIt.ptr.second);

        // adjust vertices' halfedge handle
        for (i=0; i<n; ++i)
            if (needs_adjust[i])
                adjust_outgoing_halfedge(_vertex_handles[i]);

        if (_faces_out) (*_faces_out) ~= fh;
        return fh;

    }
    //@}

    /// \name Deleting mesh items and other connectivity/topology modifications
    //@{

    /** Mark vertex and all incident edges and faces deleted.
        Items marked deleted will be removed by garbageCollection().
        \attention Needs the Attributes.Status attribute for vertices,
        edges and faces.
    */
    void delete_vertex(VertexHandle _vh, bool _delete_isolated_vertices = true)
    {
        // store incident faces
        FaceHandle[] face_handles;
        util.reserve(face_handles,8u);
        for (VFIter vf_it=(vf_iter(_vh)); vf_it.is_active; ++vf_it)
            face_handles ~= (vf_it.handle());


        // delete collected faces
        auto fh_it = array_iter_begin(face_handles);
        auto fh_end = array_iter_end(face_handles);

        for (; fh_it!=fh_end; ++fh_it)
            delete_face(fh_it.val, _delete_isolated_vertices);

        assert(has_vertex_status(), "delete_vertex: This operation requires vertex_status.");
        status_ptr(_vh).set_deleted(true);
    }      

    /** Mark edge (two opposite halfedges) and incident faces deleted.
        Resulting isolated vertices are marked deleted if
        _delete_isolated_vertices is true. Items marked deleted will be
        removed by garbageCollection().

        \attention Needs the Attributes.Status attribute for vertices,
        edges and faces.
    */
    void delete_edge(EdgeHandle _eh, bool _delete_isolated_vertices=true)
    {
        FaceHandle fh0=(face_handle(halfedge_handle(_eh, 0)));
        FaceHandle fh1=(face_handle(halfedge_handle(_eh, 1)));

        if (fh0.is_valid())  delete_face(fh0, _delete_isolated_vertices);
        if (fh1.is_valid())  delete_face(fh1, _delete_isolated_vertices);
    }

    /** Delete face _fh and resulting degenerated empty halfedges as
        well.  Resultling isolated vertices will be deleted if
        _delete_isolated_vertices is true.

        \attention All item will only be marked to be deleted. They will
        actually be removed by calling garbage_collection().

        \attention Needs the Attributes.Status attribute for vertices,
        edges and faces.
    */
    void delete_face(FaceHandle _fh, bool _delete_isolated_vertices=true)
    {
        assert(_fh.is_valid() && !status_ptr(_fh).deleted());

        // mark face deleted
        status_ptr(_fh).set_deleted(true);


        // this vector will hold all boundary edges of face _fh
        // these edges will be deleted
        EdgeHandle[] deleted_edges;
        util.reserve(deleted_edges,3u);


        // this vector will hold all vertices of face _fh
        // for updating their outgoing halfedge
        VertexHandle[]  vhandles;
        util.reserve(vhandles,3u);


        // for all halfedges of face _fh do:
        //   1) invalidate face handle.
        //   2) collect all boundary halfedges, set them deleted
        //   3) store vertex handles
        HalfedgeHandle hh;
        for (FaceHalfedgeIter fh_it=(fh_iter(_fh)); fh_it.is_active; ++fh_it)
        {
            hh = fh_it.handle();

            set_boundary(hh);//set_face_handle(hh, InvalidFaceHandle);

            if (is_boundary(opposite_halfedge_handle(hh)))
                deleted_edges ~= (edge_handle(hh));

            vhandles ~= (to_vertex_handle(hh));
        }


        // delete all collected (half)edges
        // delete isolated vertices (if _delete_isolated_vertices is true)
        if (deleted_edges.length != 0)
        {
            auto del_it = array_iter_begin(deleted_edges);
            auto del_end = array_iter_end(deleted_edges);
            HalfedgeHandle h0, h1, next0, next1, prev0, prev1;
            VertexHandle   v0, v1;

            for (; del_it!=del_end; ++del_it)
            {
                h0    = halfedge_handle(del_it.val, 0);
                v0    = to_vertex_handle(h0);
                next0 = next_halfedge_handle(h0);
                prev0 = prev_halfedge_handle(h0);

                h1    = halfedge_handle(del_it.val, 1);
                v1    = to_vertex_handle(h1);
                next1 = next_halfedge_handle(h1);
                prev1 = prev_halfedge_handle(h1);

                // adjust next and prev handles
                set_next_halfedge_handle(prev0, next1);
                set_next_halfedge_handle(prev1, next0);

                // mark edge deleted
                status_ptr(del_it.val).set_deleted(true);

                // update v0
                if (halfedge_handle(v0) == h1)
                {
                    // isolated ?
                    if (next0 == h1)
                    {
                        if (_delete_isolated_vertices)
                            status_ptr(v0).set_deleted(true);
                        set_isolated(v0);
                    }
                    else set_halfedge_handle(v0, next0);
                }

                // update v1
                if (halfedge_handle(v1) == h0)
                {
                    // isolated ?
                    if (next1 == h0)
                    {
                        if (_delete_isolated_vertices)
                            vstatus_ptr(v1).set_deleted(true);
                        set_isolated(v1);
                    }
                    else  set_halfedge_handle(v1, next1);
                }
            }
        }

        // update outgoing halfedge handles of remaining vertices
        auto v_it = array_iter_begin(vhandles);
        auto v_end = array_iter_end(vhandles);
        for (; v_it!=v_end; ++v_it)
            adjust_outgoing_halfedge(v_it.val);
    }

    //@}

    /** \name Begin and end iterators
    */
    //@{

    /// Begin iterator for vertices
    VertexIter vertices_begin()
    { return VertexIter(this, VertexHandle(0)); }
    /// End iterator for vertices
    VertexIter vertices_end()
    { return VertexIter(this, VertexHandle(n_vertices())); }

    /// Begin iterator for halfedges
    HalfedgeIter halfedges_begin()
    { return HalfedgeIter(this, HalfedgeHandle(0)); }
    /// End iterator for halfedges
    HalfedgeIter halfedges_end()
    { return HalfedgeIter(this, HalfedgeHandle(n_halfedges())); }

    /// Begin iterator for edges
    EdgeIter edges_begin()
    { return EdgeIter(this, EdgeHandle(0)); }
    /// End iterator for edges
    EdgeIter edges_end()
    { return EdgeIter(this, EdgeHandle(n_edges())); }

    /// Begin iterator for faces
    FaceIter faces_begin()
    { return FaceIter(this, FaceHandle(0)); }
    /// End iterator for faces
    FaceIter faces_end()
    { return FaceIter(this, FaceHandle(n_faces())); }
  /+
    /// Const begin iterator for vertices
    ConstVertexIter vertices_begin() /*const*/
    { return ConstVertexIter(this, VertexHandle(0)); }
    /// Const end iterator for vertices
    ConstVertexIter vertices_end() /*const*/
    { return ConstVertexIter(this, VertexHandle(n_vertices())); }
    /// Const begin iterator for halfedges
    ConstHalfedgeIter halfedges_begin() /*const*/
    { return ConstHalfedgeIter(this, HalfedgeHandle(0)); }
    /// Const end iterator for halfedges
    ConstHalfedgeIter halfedges_end() /*const*/
    { return ConstHalfedgeIter(this, HalfedgeHandle(n_halfedges())); }
    /// Const begin iterator for edges
    ConstEdgeIter edges_begin() /*const*/
    { return ConstEdgeIter(this, EdgeHandle(0)); }
    /// Const end iterator for edges
    ConstEdgeIter edges_end() /*const*/
    { return ConstEdgeIter(this, EdgeHandle(n_edges())); }
    /// Const begin iterator for faces
    ConstFaceIter faces_begin() /*const*/
    { return ConstFaceIter(this, FaceHandle(0)); }
    /// Const end iterator for faces
    ConstFaceIter faces_end() /*const*/
    { return ConstFaceIter(this, FaceHandle(n_faces())); }
  +/

  //@}



    /** \name Begin for skipping iterators
    */
    //@{

    /// Begin iterator for vertices
    VertexIter vertices_sbegin()
    { return VertexIter(this, VertexHandle(0), true); }

    /// Begin iterator for halfedges
    HalfedgeIter halfedges_sbegin()
    { return HalfedgeIter(this, HalfedgeHandle(0), true); }

    /// Begin iterator for edges
    EdgeIter edges_sbegin()
    { return EdgeIter(this, EdgeHandle(0), true); }

    /// Begin iterator for faces
    FaceIter faces_sbegin()
    { return FaceIter(this, FaceHandle(0), true); }

  /+
    /// Const begin iterator for vertices
    ConstVertexIter vertices_sbegin() /*const*/
    { return ConstVertexIter(this, VertexHandle(0), true); }
    /// Const begin iterator for halfedges
    ConstHalfedgeIter halfedges_sbegin() /*const*/
    { return ConstHalfedgeIter(this, HalfedgeHandle(0), true); }
    /// Const begin iterator for edges
    ConstEdgeIter edges_sbegin() /*const*/
    { return ConstEdgeIter(this, EdgeHandle(0), true); }
    /// Const begin iterator for faces
    ConstFaceIter faces_sbegin() /*const*/
    { return ConstFaceIter(this, FaceHandle(0), true); }
  +/
    //@}

    //--- circulators ---

    /** \name Vertex and Face circulators
    */
    //@{

    /// vertex - vertex circulator
    VertexVertexIter vv_iter(VertexHandle _vh) {
      return VertexVertexIter(this, _vh); }
    /// vertex - incoming halfedge circulator
    VertexIHalfedgeIter vih_iter(VertexHandle _vh)
    { return VertexIHalfedgeIter(this, _vh); }
    /// vertex - outgoing halfedge circulator
    VertexOHalfedgeIter voh_iter(VertexHandle _vh)
    { return VertexOHalfedgeIter(this, _vh); }
    /// vertex - edge circulator
    VertexEdgeIter ve_iter(VertexHandle _vh)
    { return VertexEdgeIter(this, _vh); }
    /// vertex - face circulator
    VertexFaceIter vf_iter(VertexHandle _vh)
    { return VertexFaceIter(this, _vh); }

    /// const vertex circulator
    ConstVertexVertexIter cvv_iter(VertexHandle _vh) /*const*/
    { return ConstVertexVertexIter(this, _vh); }
    /// const vertex - incoming halfedge circulator
    ConstVertexIHalfedgeIter cvih_iter(VertexHandle _vh) /*const*/
    { return ConstVertexIHalfedgeIter(this, _vh); }
    /// const vertex - outgoing halfedge circulator
    ConstVertexOHalfedgeIter cvoh_iter(VertexHandle _vh) /*const*/
    { return ConstVertexOHalfedgeIter(this, _vh); }
    /// const vertex - edge circulator
    ConstVertexEdgeIter cve_iter(VertexHandle _vh) /*const*/
    { return ConstVertexEdgeIter(this, _vh); }
    /// const vertex - face circulator
    ConstVertexFaceIter cvf_iter(VertexHandle _vh) /*const*/
    { return ConstVertexFaceIter(this, _vh); }

    /// face - vertex circulator
    FaceVertexIter fv_iter(FaceHandle _fh)
    { return FaceVertexIter(this, _fh); }
    /// face - halfedge circulator
    FaceHalfedgeIter fh_iter(FaceHandle _fh)
    { return FaceHalfedgeIter(this, _fh); }
    /// face - edge circulator
    FaceEdgeIter fe_iter(FaceHandle _fh)
    { return FaceEdgeIter(this, _fh); }
    /// face - face circulator
    FaceFaceIter ff_iter(FaceHandle _fh)
    { return FaceFaceIter(this, _fh); }

    /// const face - vertex circulator
    ConstFaceVertexIter cfv_iter(FaceHandle _fh) /*const*/
    { return ConstFaceVertexIter(this, _fh); }
    /// const face - halfedge circulator
    ConstFaceHalfedgeIter cfh_iter(FaceHandle _fh) /*const*/
    { return ConstFaceHalfedgeIter(this, _fh); }
    /// const face - edge circulator
    ConstFaceEdgeIter cfe_iter(FaceHandle _fh) /*const*/
    { return ConstFaceEdgeIter(this, _fh); }
    /// const face - face circulator
    ConstFaceFaceIter cff_iter(FaceHandle _fh) /*const*/
    { return ConstFaceFaceIter(this, _fh); }
    //@}

    /** \name Boundary and manifold tests
    */
    //@{
    bool is_boundary(HalfedgeHandle _heh) /*const*/
    { return ArrayKernel.is_boundary(_heh); }

    /** Is the edge _eh a boundary edge, i.e. is one of its halfedges
        a boundary halfege ? */
    bool is_boundary(EdgeHandle _eh) /*const*/
    {
        return (is_boundary(halfedge_handle(_eh, 0)) ||
                is_boundary(halfedge_handle(_eh, 1)));
    }
    /// Is vertex _vh a boundary vertex ?
    bool is_boundary(VertexHandle _vh) /*const*/
    {
        auto heh = /*HalfedgeHandle*/(halfedge_handle(_vh));
        return (!(heh.is_valid() && face_handle(heh).is_valid()));
    }

    /** Is face _fh at boundary, i.e. is one of its edges (or vertices)
     *   a boundary edge?
     *  \param _fh Check this face
     *  \param _check_vertex If \c true, check the corner vertices of
     *         the face, too.
     */
    bool is_boundary(FaceHandle _fh, bool _check_vertex=false) /*const*/
    {
        for (ConstFaceEdgeIter cfeit = cfe_iter( _fh ); cfeit.is_active; ++cfeit)
            if (is_boundary( cfeit.handle() ) )
                return true;

        if (_check_vertex)
        {
            for (ConstFaceVertexIter cfvit = cfv_iter( _fh ); cfvit.is_active; ++cfvit)
                if (is_boundary( cfvit.handle() ) )
                    return true;
        }
        return false;

    }
    /// Is (the mesh at) vertex _vh  two-manifold ?
    bool is_manifold(VertexHandle _vh) /*const*/
    {
        /* The vertex is non-manifold if more than one gap exists, i.e.
           more than one outgoing boundary halfedge. If (at least) one
           boundary halfedge exists, the vertex' halfedge must be a
           boundary halfedge. If iterating around the vertex finds another
           boundary halfedge, the vertex is non-manifold. */

        auto vh_it = ConstVertexOHalfedgeIter(this, _vh);
        if (vh_it.is_active)
            for (++vh_it; vh_it.is_active; ++vh_it)
                if (is_boundary(vh_it.handle()))
                    return false;
        return true;
    }
    //@}

    // --- shortcuts ---

    /// returns the face handle of the opposite halfedge 
    FaceHandle opposite_face_handle(HalfedgeHandle _heh) /*const*/
    { return face_handle(opposite_halfedge_handle(_heh)); }

    // --- misc ---

    /** Adjust outgoing halfedge handle for vertices, so that it is a
        boundary halfedge whenever possible. 
    */
    void adjust_outgoing_halfedge(VertexHandle _vh) {
        for (ConstVertexOHalfedgeIter vh_it=cvoh_iter(_vh); vh_it.is_active; ++vh_it)
        {
            if (is_boundary(vh_it.handle()))
            {
                set_halfedge_handle(_vh, vh_it.handle());
                break;
            }
        }
    }
    /// Find halfedge from _vh0 to _vh1. Returns invalid handle if not found.
    HalfedgeHandle find_halfedge(VertexHandle _start_vh, VertexHandle _end_vh) /*const*/
    {
        assert(_start_vh.is_valid() && _end_vh.is_valid());

        for (ConstVertexVertexIter vvIt=cvv_iter(_start_vh); vvIt.is_active; ++vvIt)
            if (vvIt.handle() == _end_vh)
                return vvIt.current_halfedge_handle();

        return InvalidHalfedgeHandle;
    }

    /// Vertex valence
    uint valence(VertexHandle _vh) /*const*/
    {
        uint count=0;
        for (ConstVertexVertexIter vv_it=cvv_iter(_vh); vv_it.is_active; ++vv_it)
            ++count;
        return count;

    }


    /// Face valence
    uint valence(FaceHandle _fh) /*const*/
    {
        uint count = 0;
        for (ConstFaceVertexIter fv_it=cfv_iter(_fh); fv_it.is_active; ++fv_it)
            ++count;
        return count;
    }

    // --- connectivity operattions 

    /** Halfedge collapse: collapse the from-vertex of halfedge _heh
        into its to-vertex.

        \attention Needs vertex/edge/face status attribute in order to
        delete the items that degenerate.

        \note This function does not perform a garbage collection. It
        only marks degenerate items as deleted.

        \attention A halfedge collapse may lead to topological inconsistencies.
        Therefore you should check this using is_collapse_ok().  
        \TODO: implement is_collapse_ok() const for polygonal/triangle meshes
    */
    void collapse(HalfedgeHandle _heh) {
        HalfedgeHandle h0 = _heh;
        HalfedgeHandle h1 = next_halfedge_handle(h0);
        HalfedgeHandle o0 = opposite_halfedge_handle(h0);
        HalfedgeHandle o1 = next_halfedge_handle(o0);

        // remove edge
        collapse_edge(h0);

        // remove loops
        if (next_halfedge_handle(next_halfedge_handle(h1)) == h1)
            collapse_loop(next_halfedge_handle(h1));
        if (next_halfedge_handle(next_halfedge_handle(o1)) == o1)
            collapse_loop(o1);

    }
    /** return true if the this the only link between the faces adjacent to _eh.
        _eh is allowed to be boundary, in which case true is returned iff _eh is 
        the only boundary edge of its ajdacent face.
    */
    bool is_simple_link(EdgeHandle _eh) /*const*/
    {
        HalfedgeHandle heh0 = halfedge_handle(_eh, 0);
        HalfedgeHandle heh1 = halfedge_handle(_eh, 1);
  
        FaceHandle fh0 = face_handle(heh0);//fh0 or fh1 might be a invalid,
        FaceHandle fh1 = face_handle(heh1);//i.e., representing the boundary
  
        HalfedgeHandle next_heh = next_halfedge_handle(heh0);
        while (next_heh != heh0)
        {//check if there are no other edges shared between fh0 & fh1
            if (opposite_face_handle(next_heh) == fh1)
            {
                return false;
            }
            next_heh = next_halfedge_handle(next_heh);
        }
        return true;

    }
    /** return true if _fh shares only one edge with all of its adjacent faces.
        Boundary is treated as one face, i.e., the function false if _fh has more
        than one boundary edge.
    */
    bool is_simply_connected(FaceHandle _fh) /*const*/
    {
        bool[FaceHandle] nb_fhs;
        for (ConstFaceFaceIter cff_it = cff_iter(_fh); cff_it.is_active; ++cff_it)
        {
            if (cff_it.handle in nb_fhs)
            {//there is more than one link
                return false;
            }
            else {
                nb_fhs[cff_it.handle] = true;
            }
        }
        return true;

    }
    /** Removes the edge _eh. Its adjacent faces are merged. _eh and one of the 
        adjacent faces are set deleted. The handle of the remaining face is 
        returned (InvalidFaceHandle is returned if _eh is a boundary edge).

        \precondition is_simple_link(_eh). This ensures that there are no hole faces
        or isolated vertices appearing in result of the operation.

        \attention Needs the Attributes.Status attribute for edges and faces.

        \note This function does not perform a garbage collection. It
        only marks items as deleted.
    */
    FaceHandle remove_edge(EdgeHandle _eh)
    {
        //don't allow "dangling" vertices and edges
        assert(!estatus_ptr(_eh).deleted() && is_simple_link(_eh));
  
        HalfedgeHandle heh0 = halfedge_handle(_eh, 0);
        HalfedgeHandle heh1 = halfedge_handle(_eh, 1);
  
        //deal with the faces
        FaceHandle rem_fh = face_handle(heh0), del_fh = face_handle(heh1);
        if (!del_fh.is_valid())
        {//boundary case - we must delete the rem_fh
            util.swap(del_fh, rem_fh);
        }
        assert(del_fh.is_valid());
        /*  for (FaceHalfedgeIter fh_it = fh_iter(del_fh); fh_it; ++fh_it)
        {//set the face handle of the halfedges of del_fh to point to rem_fh
          set_face_handle(fh_it, rem_fh);  
        } */
        //fix the halfedge relations
        HalfedgeHandle prev_heh0 = prev_halfedge_handle(heh0);
        HalfedgeHandle prev_heh1 = prev_halfedge_handle(heh1);

        HalfedgeHandle next_heh0 = next_halfedge_handle(heh0);
        HalfedgeHandle next_heh1 = next_halfedge_handle(heh1);
  
        set_next_halfedge_handle(prev_heh0, next_heh1);
        set_next_halfedge_handle(prev_heh1, next_heh0);
        //correct outgoing vertex handles for the _eh vertices (if needed)
        VertexHandle vh0 = to_vertex_handle(heh0);
        VertexHandle vh1 = to_vertex_handle(heh1);
  
        if (halfedge_handle(vh0) == heh1)
        {
            set_halfedge_handle(vh0, next_heh0);
        }
        if (halfedge_handle(vh1) == heh0)
        {
            set_halfedge_handle(vh1, next_heh1);
        }
  
        //correct the hafledge handle of rem_fh if needed and preserve its first vertex
        if (halfedge_handle(rem_fh) == heh0)
        {//rem_fh is the face at heh0
            set_halfedge_handle(rem_fh, prev_heh1);
        }
        else if (halfedge_handle(rem_fh) == heh1)
        {//rem_fh is the face at heh1
            set_halfedge_handle(rem_fh, prev_heh0);
        }
        for (FaceHalfedgeIter fh_it = fh_iter(rem_fh); fh_it.is_active; ++fh_it)
        {//set the face handle of the halfedges of del_fh to point to rem_fh
            set_face_handle(fh_it.handle, rem_fh);  
        } 
  
        estatus_ptr(_eh).set_deleted(true);  
        fstatus_ptr(del_fh).set_deleted(true);  
        return rem_fh;//returns the remaining face handle

    }



    /** Inverse of remove_edge. _eh should be the handle of the edge and the
        vertex and halfedge handles pointed by edge(_eh) should be valid. 
    */
    void reinsert_edge(EdgeHandle _eh)
    {
        //this does not work without prev_halfedge_handle
        static assert(Halfedge.sizeof == Halfedge_with_prev.sizeof);
        //shoudl be deleted  
        assert(estatus_ptr(_eh).deleted());
        estatus_ptr(_eh).set_deleted(false);  
  
        HalfedgeHandle heh0 = halfedge_handle(_eh, 0);
        HalfedgeHandle heh1 = halfedge_handle(_eh, 1);
        FaceHandle rem_fh = face_handle(heh0), del_fh = face_handle(heh1);
        if (!del_fh.is_valid())
        {//boundary case - we must delete the rem_fh
            util.swap(del_fh, rem_fh);
        }
        assert(fstatus_ptr(del_fh).deleted());
        fstatus_ptr(del_fh).set_deleted(false); 
  
        //restore halfedge relations
        HalfedgeHandle prev_heh0 = prev_halfedge_handle(heh0);
        HalfedgeHandle prev_heh1 = prev_halfedge_handle(heh1);

        HalfedgeHandle next_heh0 = next_halfedge_handle(heh0);
        HalfedgeHandle next_heh1 = next_halfedge_handle(heh1);
  
        set_next_halfedge_handle(prev_heh0, heh0);
        set_prev_halfedge_handle(next_heh0, heh0);
  
        set_next_halfedge_handle(prev_heh1, heh1);
        set_prev_halfedge_handle(next_heh1, heh1);
  
        for (FaceHalfedgeIter fh_it = fh_iter(del_fh); fh_it.is_active; ++fh_it)
        {//reassign halfedges to del_fh  
            set_face_handle(fh_it.handle, del_fh);
        }
   
        if (face_handle(halfedge_handle(rem_fh)) == del_fh)
        {//correct the halfedge handle of rem_fh
            if (halfedge_handle(rem_fh) == prev_heh0)
            {//rem_fh is the face at heh1
                set_halfedge_handle(rem_fh, heh1);
            }
            else
            {//rem_fh is the face at heh0
                assert(halfedge_handle(rem_fh) == prev_heh1);
                set_halfedge_handle(rem_fh, heh0);
            }
        }

    }

    /** Inserts an edge between to_vh(_prev_heh) and from_vh(_next_heh).
        A new face is created started at heh0 of the inserted edge and
        its halfedges loop includes both _prev_heh and _next_heh. If an 
        old face existed which includes the argument halfedges, it is 
        split at the new edge. heh0 is returned. 

        \note assumes _prev_heh and _next_heh are either boundary or pointed
        to the same face
    */
    HalfedgeHandle insert_edge(HalfedgeHandle _prev_heh, HalfedgeHandle _next_heh)
    {
        assert(face_handle(_prev_heh) == face_handle(_next_heh));//only the manifold case
        assert(next_halfedge_handle(_prev_heh) != _next_heh);//this can not be done
        VertexHandle vh0 = to_vertex_handle(_prev_heh);
        VertexHandle vh1 = from_vertex_handle(_next_heh);
        //create the link between vh0 and vh1
        HalfedgeHandle heh0 = new_edge(vh0, vh1);
        HalfedgeHandle heh1 = opposite_halfedge_handle(heh0);
        HalfedgeHandle next_prev_heh = next_halfedge_handle(_prev_heh);
        HalfedgeHandle prev_next_heh = prev_halfedge_handle(_next_heh);
        set_next_halfedge_handle(_prev_heh, heh0);
        set_next_halfedge_handle(heh0, _next_heh);
        set_next_halfedge_handle(prev_next_heh, heh1);
        set_next_halfedge_handle(heh1, next_prev_heh);
  
        //now set the face handles - the new face is assigned to heh0
        FaceHandle new_fh = new_face();
        set_halfedge_handle(new_fh, heh0);
        for (FaceHalfedgeIter fh_it = fh_iter(new_fh); fh_it.is_active; ++fh_it)
        {
            set_face_handle(fh_it.handle, new_fh);
        }  
        FaceHandle old_fh = face_handle(next_prev_heh);
        set_face_handle(heh1, old_fh);   
        if (old_fh.is_valid() && face_handle(halfedge_handle(old_fh)) == new_fh)
        {//fh pointed to one of the halfedges now assigned to new_fh
            set_halfedge_handle(old_fh, heh1);
        }
        adjust_outgoing_halfedge(vh0);  
        adjust_outgoing_halfedge(vh1);  
        return heh0;

    }

    /** Edge split (= 2-to-4 split)
     *  For triangles this connects the split edge up to the opposite vertex
     *  (just like the split method of TriConnectivity).
     *  For a polymesh it connects to the next vertex after the edge one one side
     *  and to the next after the halfedge on the other side.
     *
     *  The two new faces added can be retrieved after the split using
     *    face_handle(
     *       opposite_halfedge_handle(
     *           prev_halfedge_handle(halfedge_handle(_eh,0))))
     *  and
     *    face_handle(
     *       opposite_halfedge_handle(
     *           next_halfedge_handle(halfedge_handle(_eh,1))))
     *    
     *  The two new half-edges can be retrieved by
     *    prev_halfedge_handle(
     *       opposite_halfedge_handle(
     *           prev_halfedge_handle(halfedge_handle(_eh,0))))
     *  and
     *    next_halfedge_handle(
     *       opposite_halfedge_handle(
     *           next_halfedge_handle(halfedge_handle(_eh,1))))
     *    
     *  (the first new half-edge uses the first new face.
     *   the second new half-edge uses the second.)
     */
    void split(EdgeHandle _eh, VertexHandle _vh)
    {
        HalfedgeHandle h0 = halfedge_handle(_eh, 0);
        HalfedgeHandle o0 = halfedge_handle(_eh, 1);

        VertexHandle   v2 = to_vertex_handle(o0);

        HalfedgeHandle e1 = new_edge(_vh, v2);
        HalfedgeHandle t1 = opposite_halfedge_handle(e1);

        FaceHandle     f0 = face_handle(h0);
        FaceHandle     f3 = face_handle(o0);

        set_halfedge_handle(_vh, h0);
        set_vertex_handle(o0, _vh);

        if (!is_boundary(h0))
        {
            HalfedgeHandle h1 = next_halfedge_handle(h0);
            HalfedgeHandle h2 = next_halfedge_handle(h1);
            HalfedgeHandle hN = prev_halfedge_handle(h0);
            assert(hN != t1);

            VertexHandle v1 = to_vertex_handle(h1);

            HalfedgeHandle e0 = new_edge(_vh, v1);
            HalfedgeHandle t0 = opposite_halfedge_handle(e0);

            FaceHandle f1 = new_face();
            set_halfedge_handle(f0, h0);
            set_halfedge_handle(f1, h2);

            set_face_handle(h1, f0);
            set_face_handle(t0, f0);
            set_face_handle(h0, f0);

            set_face_handle(t1, f1);
            set_face_handle(e0, f1);
            set_face_handle(h2, f1);
            if (hN!=h2) {
                HalfedgeHandle hh = next_halfedge_handle(h2);
                do
                {
                    set_face_handle(hh, f1);
                    hh = next_halfedge_handle(hh) ;
                } while (hh!=hN); 
            }            
            set_next_halfedge_handle(h0, h1);
            set_next_halfedge_handle(h1, t0);
            set_next_halfedge_handle(t0, h0);

            set_next_halfedge_handle(e0, h2);
            set_next_halfedge_handle(hN, t1);
            set_next_halfedge_handle(t1, e0);
        }
        else
        {
            set_next_halfedge_handle(prev_halfedge_handle(h0), t1);
            set_next_halfedge_handle(t1, h0);
            // halfedge handle of _vh already is h0
        }


        if (!is_boundary(o0))
        {
            HalfedgeHandle o1 = next_halfedge_handle(o0);
            HalfedgeHandle o2 = next_halfedge_handle(o1);
            HalfedgeHandle oN = prev_halfedge_handle(o0);

            VertexHandle v3 = to_vertex_handle(o1);

            HalfedgeHandle e2 = new_edge(_vh, v3);
            HalfedgeHandle t2 = opposite_halfedge_handle(e2);

            FaceHandle f2 = new_face();
            set_halfedge_handle(f2, o1);
            set_halfedge_handle(f3, o0);

            set_face_handle(o1, f2);
            set_face_handle(t2, f2);
            set_face_handle(e1, f2);

            set_face_handle(o0, f3);
            set_face_handle(e2, f3);
            set_face_handle(o2, f3);
            if (o2 != oN) {
                HalfedgeHandle oh = next_halfedge_handle(o2);
                do {
                    set_face_handle(oh, f3);
                    oh = next_halfedge_handle(oh);
                } while (oh!=oN);
            }
            set_next_halfedge_handle(e1, o1);
            set_next_halfedge_handle(o1, t2);
            set_next_halfedge_handle(t2, e1);

            set_next_halfedge_handle(o0, e2);
            set_next_halfedge_handle(e2, o2);
            set_next_halfedge_handle(oN, o0);
        }
        else
        {
            set_next_halfedge_handle(e1, next_halfedge_handle(o0));
            set_next_halfedge_handle(o0, e1);
            set_halfedge_handle(_vh, e1);
        }

        if (halfedge_handle(v2) == h0)
            set_halfedge_handle(v2, t1);


    }

    /// Face split (= 1-to-n split)
    void split(FaceHandle fh, VertexHandle vh)
    {
        /*
         Split an arbitrary face into triangles by connecting
         each vertex of fh to vh.

         - fh will remain valid (it will become one of the
           triangles)
         - the halfedge handles of the new triangles will
           point to the old halfeges
        */

        HalfedgeHandle hend = halfedge_handle(fh);
        HalfedgeHandle hh   = next_halfedge_handle(hend);

        HalfedgeHandle hold = new_edge(to_vertex_handle(hend), vh);

        set_next_halfedge_handle(hend, hold);
        set_face_handle(hold, fh);

        hold = opposite_halfedge_handle(hold);

        while (hh != hend) {

            HalfedgeHandle hnext = next_halfedge_handle(hh);

            FaceHandle fnew = new_face();
            set_halfedge_handle(fnew, hh);

            HalfedgeHandle hnew = new_edge(to_vertex_handle(hh), vh);

            set_next_halfedge_handle(hnew, hold);
            set_next_halfedge_handle(hold, hh);
            set_next_halfedge_handle(hh, hnew);

            set_face_handle(hnew, fnew);
            set_face_handle(hold, fnew);
            set_face_handle(hh,   fnew);

            hold = opposite_halfedge_handle(hnew);

            hh = hnext;
        }

        set_next_halfedge_handle(hold, hend);
        set_next_halfedge_handle(next_halfedge_handle(hend), hold);

        set_face_handle(hold, fh);

        set_halfedge_handle(vh, hold);
    }

    

    /// triangulate the face _fh
    void triangulate(FaceHandle _fh) {
        /*
    Split an arbitrary face into triangles by connecting
    each vertex of fh after its second to vh.

    - fh will remain valid (it will become one of the
      triangles)
    - the halfedge handles of the new triangles will
      point to the old halfedges
  */

        HalfedgeHandle base_heh = (halfedge_handle(_fh));
        VertexHandle start_vh = from_vertex_handle(base_heh);
        HalfedgeHandle next_heh = (next_halfedge_handle(base_heh));

        while (to_vertex_handle(next_halfedge_handle(next_heh)) != start_vh)
        {
            HalfedgeHandle next_next_heh = (next_halfedge_handle(next_heh));

            FaceHandle new_fh = new_face();
            set_halfedge_handle(new_fh, base_heh);

            HalfedgeHandle new_heh = new_edge(to_vertex_handle(next_heh), start_vh);

            set_next_halfedge_handle(base_heh, next_heh);
            set_next_halfedge_handle(next_heh, new_heh);
            set_next_halfedge_handle(new_heh, base_heh);

            set_face_handle(base_heh, new_fh);
            set_face_handle(next_heh, new_fh);
            set_face_handle(new_heh,  new_fh);

            base_heh = opposite_halfedge_handle(new_heh);
            next_heh = next_next_heh;
        }
        set_halfedge_handle(_fh, base_heh);  //the last face takes the handle _fh

        set_next_halfedge_handle(base_heh, next_heh);
        set_next_halfedge_handle(next_halfedge_handle(next_heh), base_heh);

        set_face_handle(base_heh, _fh);

    }
    /// triangulate the entire mesh
    void triangulate()
    {
        /* The iterators will stay valid, even though new faces are added,
            because they are now implemented index-based instead of
            pointer-based.
         */
        FaceIter f_it=(faces_begin()), f_end=(faces_end());
        for (; f_it!=f_end; ++f_it)
            triangulate(f_it.handle);
    }


    /** \name Generic handle derefertiation.
        Calls the respective vertex(), halfedge(), edge(), face()
        method of the mesh kernel.
    */
    //@{
    /// Get item from handle
    ///*const*/ Vertex*    deref(VertexHandle _h)   /*const*/ { return vertex(_h); }
    Vertex*          deref(VertexHandle _h)         { return vertex_ptr(_h); }
    ///*const*/ Halfedge*  deref(HalfedgeHandle _h) /*const*/ { return halfedge(_h); }
    Halfedge*        deref(HalfedgeHandle _h)       { return halfedge_ptr(_h); }
    ///*const*/ Edge*      deref(EdgeHandle _h)     /*const*/ { return edge(_h); }
    Edge*            deref(EdgeHandle _h)           { return edge_ptr(_h); }
    ///*const*/ Face*      deref(FaceHandle _h)     /*const*/ { return face(_h); }
    Face*            deref(FaceHandle _h)           { return face_ptr(_h); }
    //@}

  protected:  
    /// Helper for halfedge collapse
    void collapse_edge(HalfedgeHandle _hh) 
    {
        HalfedgeHandle  h  = _hh;
        HalfedgeHandle  hn = next_halfedge_handle(h);
        HalfedgeHandle  hp = prev_halfedge_handle(h);

        HalfedgeHandle  o  = opposite_halfedge_handle(h);
        HalfedgeHandle  on = next_halfedge_handle(o);
        HalfedgeHandle  op = prev_halfedge_handle(o);

        FaceHandle      fh = face_handle(h);
        FaceHandle      fo = face_handle(o);

        VertexHandle    vh = to_vertex_handle(h);
        VertexHandle    vo = to_vertex_handle(o);



        // halfedge -> vertex
        for (VertexIHalfedgeIter vih_it=(vih_iter(vo)); vih_it.is_active; ++vih_it)
            set_vertex_handle(vih_it.handle(), vh);


        // halfedge -> halfedge
        set_next_halfedge_handle(hp, hn);
        set_next_halfedge_handle(op, on);


        // face -> halfedge
        if (fh.is_valid())  set_halfedge_handle(fh, hn);
        if (fo.is_valid())  set_halfedge_handle(fo, on);


        // vertex -> halfedge
        if (halfedge_handle(vh) == o)  set_halfedge_handle(vh, hn);
        adjust_outgoing_halfedge(vh);
        set_isolated(vo);

        // delete stuff
        estatus_ptr(edge_handle(h)).set_deleted(true);
        vstatus_ptr(vo).set_deleted(true);
    }
    /// Helper for halfedge collapse
    void collapse_loop(HalfedgeHandle _hh)
    {
        HalfedgeHandle  h0 = _hh;
        HalfedgeHandle  h1 = next_halfedge_handle(h0);

        HalfedgeHandle  o0 = opposite_halfedge_handle(h0);
        HalfedgeHandle  o1 = opposite_halfedge_handle(h1);

        VertexHandle    v0 = to_vertex_handle(h0);
        VertexHandle    v1 = to_vertex_handle(h1);

        FaceHandle      fh = face_handle(h0);
        FaceHandle      fo = face_handle(o0);



        // is it a loop ?
        assert ((next_halfedge_handle(h1) == h0) && (h1 != o0));


        // halfedge -> halfedge
        set_next_halfedge_handle(h1, next_halfedge_handle(o0));
        set_next_halfedge_handle(prev_halfedge_handle(o0), h1);


        // halfedge -> face
        set_face_handle(h1, fo);


        // vertex -> halfedge
        set_halfedge_handle(v0, h1);  adjust_outgoing_halfedge(v0);
        set_halfedge_handle(v1, o1);  adjust_outgoing_halfedge(v1);


        // face -> halfedge
        if (fo.is_valid() && halfedge_handle(fo) == o0)
        {
            set_halfedge_handle(fo, h1);
        }

        // delete stuff
        if (fh.is_valid())  
        {
            set_halfedge_handle(fh, InvalidHalfedgeHandle);
            fstatus_ptr(fh).set_deleted(true);
        }
        estatus_ptr(edge_handle(h0)).set_deleted(true);
    }
}


unittest {
    auto pc = new PolyConnectivity;
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
