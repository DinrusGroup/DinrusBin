//============================================================================
// ArrayItems.d - 
//   Written in the D Programming Language (http://www.digitalmars.com/d)
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

module auxd.OpenMesh.Core.Mesh.ArrayItems;


//== INCLUDES =================================================================


import auxd.OpenMesh.Core.System.config;
import GenProg=auxd.OpenMesh.Core.Utils.GenProg;
import auxd.OpenMesh.Core.Mesh.Handles;


//== CLASS DEFINITION =========================================================

template ArrayItemsMixin()
{

    //------------------------------------------------------ internal vertex type

    /// The vertex item
    struct Vertex
    {
        HalfedgeHandle  halfedge_handle_;
    }


    //---------------------------------------------------- internal halfedge type

    struct Halfedge_without_prev
    {
        FaceHandle      face_handle_;
        VertexHandle    vertex_handle_;
        HalfedgeHandle  next_halfedge_handle_;
    }

    struct Halfedge_with_prev
    {
        // Inherit from Halfedge_with_prev
        // alias Halfedge_without_prev this; // in a Future D
        FaceHandle      face_handle_;
        VertexHandle    vertex_handle_;
        HalfedgeHandle  next_halfedge_handle_;

        HalfedgeHandle  prev_halfedge_handle_;
    }

    //TODO: should be selected with config.h define
    alias Halfedge_with_prev                Halfedge;
    alias GenProg.Bool2Type!(true)          HasPrevHalfedge;

    //-------------------------------------------------------- internal edge type
    struct Edge
    {
        Halfedge[2]  halfedges_;
    }

    //-------------------------------------------------------- internal face type
    struct Face
    {
        HalfedgeHandle  halfedge_handle_;
    }
}



/// Definition of mesh items for use in the ArrayKernel
struct ArrayItems
{
    mixin auxd.OpenMesh.Core.Mesh.ArrayItems.ArrayItemsMixin!();
}

unittest {
    ArrayItems foo;
    ArrayItems.Halfedge_with_prev bar;

    bar.face_handle_ = FaceHandle(10);
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
