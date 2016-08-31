//============================================================================
// CollapseInfoT.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 31 Aug 2007
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

module auxd.OpenMesh.Tools.Decimater.CollapseInfoT;


/** \file CollapseInfoT.hh
    Provides data class CollapseInfoT for storing all information
    about a halfedge collapse.
 */

//=============================================================================
//
//  STRUCT CollpaseInfoT
//
//=============================================================================

//== INCLUDES =================================================================


//== CLASS DEFINITION =========================================================

/** Stores information about a halfedge collapse.

    The class stores information about a halfedge collapse. The most
    important information is \c v0v1, \c v1v0, \c v0, \c v1, \c vl,
    \c vr, which you can lookup in the following image:  
    \image html collapse_info.png
    See_Also: ModProgMeshT.Info
 */
struct CollapseInfoT(Mesh)
{
public:
    /** Initializing constructor.
     *
     *  Given a mesh and a halfedge handle of the halfedge to be collapsed
     *  all important information of a halfedge collapse will be stored.
     * \param _mesh Mesh source 
     * \param _heh Halfedge to collapse. The direction of the halfedge
     *        defines the direction of the collapse, i.e. the from-vertex
     *        will be removed and the to-vertex remains.
     */

    // CollapseInfoT.CollapseInfoT( _mesh, _heh )
    //
    //   Local configuration of halfedge collapse to be stored in CollapseInfoT:
    /* 
               vl
               * 
              / \
             /   \
            / fl  \
        v0 *------>* v1
            \ fr  /
             \   /
              \ /
               * 
               vr
    */
    // Parameters:
    //   _mesh               Reference to mesh
    //   _heh                The halfedge (v0 -> v1) defining the collapse
    //
    static CollapseInfoT opCall(Mesh _mesh, Mesh.HalfedgeHandle _heh)
    {
        CollapseInfoT M; with(M) {
            mesh=(_mesh);
            v0v1=(_heh);
            v1v0=(_mesh.opposite_halfedge_handle(v0v1));
            v0=(_mesh.to_vertex_handle(v1v0));
            v1=(_mesh.to_vertex_handle(v0v1));
            p0=(_mesh.point(v0));
            p1=(_mesh.point(v1));
            fl=(_mesh.face_handle(v0v1));
            fr=(_mesh.face_handle(v1v0));

            // get vl
            if (fl.is_valid())
            {
                vlv1 = mesh.next_halfedge_handle(v0v1);
                v0vl = mesh.next_halfedge_handle(vlv1);
                vl   = mesh.to_vertex_handle(vlv1);
                vlv1 = mesh.opposite_halfedge_handle(vlv1);
                v0vl = mesh.opposite_halfedge_handle(v0vl);
            }


            // get vr
            if (fr.is_valid())
            {
                vrv0 = mesh.next_halfedge_handle(v1v0);
                v1vr = mesh.next_halfedge_handle(vrv0);
                vr   = mesh.to_vertex_handle(vrv0);
                vrv0 = mesh.opposite_halfedge_handle(vrv0);
                v1vr = mesh.opposite_halfedge_handle(v1vr);
            }
        }
        return M;
    }

    Mesh                          mesh;

    Mesh.HalfedgeHandle  v0v1; ///< Halfedge to be collapsed
    Mesh.HalfedgeHandle  v1v0; ///< Reverse halfedge
    Mesh.VertexHandle    v0;   ///< Vertex to be removed
    Mesh.VertexHandle    v1;   ///< Remaining vertex
    Mesh.Point           p0;   ///< Position of removed vertex
    Mesh.Point           p1;   ///< Positions of remaining vertex
    Mesh.FaceHandle      fl;   ///< Left face
    Mesh.FaceHandle      fr;   ///< Right face
    Mesh.VertexHandle    vl;   ///< Left vertex
    Mesh.VertexHandle    vr;   ///< Right vertex
    //@{ 
    /** Outer remaining halfedge of diamond spanned by \c v0, \c v1, 
     *  \c vl, and \c vr
     */
    Mesh.HalfedgeHandle  vlv1, v0vl, vrv0, v1vr;
    //@}
}


//-----------------------------------------------------------------------------


unittest {
    
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
