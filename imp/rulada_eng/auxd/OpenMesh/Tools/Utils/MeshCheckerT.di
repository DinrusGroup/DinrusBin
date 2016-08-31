//============================================================================
// MeshCheckerT.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description:
 *   <TODO:>
 *
 * Author:  William V. Baxter III, OLM Digital, Inc.
 * Created: 03 Sep 2007
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
module auxd.OpenMesh.Tools.Utils.MeshCheckerT;

//== IMPORTS =================================================================

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Utils.GenProg;
import auxd.OpenMesh.Core.Mesh.Attributes;
import auxd.OpenMesh.Core.IO.Streams;


//== CLASS DEFINITION ========================================================

	      
/** Check integrity of mesh.
 *
 *  This class provides several functions to check the integrity of a mesh.
 */
struct MeshCheckerT(Mesh)
{
public:
   
    /// constructor
    static MeshCheckerT opCall(/*const*/ Mesh _mesh) { 
        MeshCheckerT M; M.mesh_=_mesh; return M;
    }
 
    /// what should be checked?
    enum CheckTargets
    {
        CHECK_EDGES     = 1,
        CHECK_VERTICES  = 2,
        CHECK_FACES     = 4,
        CHECK_ALL       = 255,
    }

  
    /// check it, return true iff ok
    bool check( uint _targets=CheckTargets.CHECK_ALL,
                ostream  _os=derr)
    {

        bool  ok=(true);

        //--- vertex checks ---

        if (_targets & CheckTargets.CHECK_VERTICES)
        {
            Mesh./*Const*/VertexIter v_it=(mesh_.vertices_begin()), 
                v_end=(mesh_.vertices_end());
            Mesh.VertexHandle    vh;
            Mesh.ConstVertexVertexIter vv_it;
            Mesh.HalfedgeHandle  heh;
            uint                   count;
            /*const*/ uint             max_valence=(10000);


            for (; v_it != v_end; ++v_it)
            {
                if (!is_deleted(v_it.handle))
                {
                    vh = v_it.handle();


                    /* The outgoing halfedge of a boundary vertex has to be a 
                       boundary halfedge */
                    heh = mesh_.halfedge_handle(vh);
                    if (heh.is_valid() && !mesh_.is_boundary(heh))
                    {
                        for (auto  vh_it=Mesh.ConstVertexOHalfedgeIter(mesh_, vh);
                             vh_it.is_active; ++vh_it)
                        {
                            if (mesh_.is_boundary(vh_it.handle()))
                            {
                                _os.writefln("MeshChecker: vertex " , vh,
                                             ": outgoing halfedge not on boundary error").flush;
                                ok = false;
                            }
                        }
                    }

      
      
                    // outgoing halfedge has to refer back to vertex
                    if (mesh_.halfedge_handle(vh).is_valid() &&
                        mesh_.from_vertex_handle(mesh_.halfedge_handle(vh)) != vh)
                    {
                        _os.writefln("MeshChecker: vertex " , vh,
                                     ": outgoing halfedge does not reference vertex").flush;
                        ok = false;
                    }


                    // check whether circulators are still in order
                    vv_it = mesh_.cvv_iter(vh);
                    for (count=0; vv_it.is_active && (count < max_valence); ++vv_it, ++count) {}
                    if (count == max_valence)
                    {
                        _os.writefln( "MeshChecker: vertex " , vh,
                                      ": ++circulator problem, one ring corrupt").flush;
                        ok = false;
                    }
                    vv_it = mesh_.cvv_iter(vh);
                    for (count=0; vv_it.is_active && (count < max_valence); --vv_it, ++count) {}
                    if (count == max_valence)
                    {
                        _os.writefln( "MeshChecker: vertex " ,vh,
                                      ": --circulator problem, one ring corrupt").flush;
                        ok = false;
                    }
                }
            }
        }



        //--- halfedge checks ---

        if (_targets & CheckTargets.CHECK_EDGES)
        {
            Mesh./*Const*/HalfedgeIter  h_it=(mesh_.halfedges_begin()), 
                h_end=(mesh_.halfedges_end());
            Mesh.HalfedgeHandle     hh, hstart, hhh;
            uint                      count, n_halfedges = 2*mesh_.n_edges();

            for (; h_it != h_end; ++h_it)
            {
                if (!is_deleted(mesh_.edge_handle(h_it.handle())))
                {
                    hh = h_it.handle();


                    // degenerated halfedge ?
                    if (mesh_.from_vertex_handle(hh) == mesh_.to_vertex_handle(hh))
                    {
                        _os.writefln("MeshChecker: halfedge " , hh
                            , ": to-vertex == from-vertex").flush;
                        ok = false;
                    }


                    // next <-> prev check
                    if (mesh_.next_halfedge_handle(mesh_.prev_halfedge_handle(hh)) != hh)
                    {
                        _os.writefln("MeshChecker: halfedge " , hh
                            , ": prev->next != this").flush;
                        ok = false;
                    }


                    // halfedges should form a cycle
                    count=0; hstart=hhh=hh;
                    do 
                    {
                        hhh = mesh_.next_halfedge_handle(hhh);
                        ++count;
                    } while (hhh != hstart && count < n_halfedges);

                    if (count == n_halfedges)
                    {
                        _os.writefln("MeshChecker: halfedges starting from " , hh
                            , " do not form a cycle").flush;
                        ok = false;
                    }
                }
            }
        }



        //--- face checks ---

        if (_targets & CheckTargets.CHECK_FACES)
        {
            Mesh./*Const*/FaceIter          f_it=(mesh_.faces_begin()), 
                f_end=(mesh_.faces_end());
            Mesh.FaceHandle             fh;
            Mesh.ConstFaceHalfedgeIter  fh_it;
    
            for (; f_it != f_end; ++f_it)
            {
                if (!is_deleted(f_it.handle))
                {
                    fh = f_it.handle();

                    for (fh_it=mesh_.cfh_iter(fh); fh_it.is_active; ++fh_it)
                    {
                        if (mesh_.face_handle(fh_it.handle()) != fh)
                        {
                            _os.writefln("MeshChecker: face " , fh
                                , ": its halfedge does not reference face").flush;
                            ok = false;
                        }
                    }
                }
            }
        }



        return ok;

    }


private:

    bool is_deleted(Mesh.VertexHandle _vh) 
    { return (mesh_.has_vertex_status() ? mesh_.status_ptr(_vh).deleted() : false); }

    bool is_deleted(Mesh.EdgeHandle _eh) 
    { return (mesh_.has_edge_status() ? mesh_.status_ptr(_eh).deleted() : false); }

    bool is_deleted(Mesh.FaceHandle _fh) 
    { return (mesh_.has_face_status() ? mesh_.status_ptr(_fh).deleted() : false); }


    // ref to mesh
    /*const*/ Mesh  mesh_;
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
