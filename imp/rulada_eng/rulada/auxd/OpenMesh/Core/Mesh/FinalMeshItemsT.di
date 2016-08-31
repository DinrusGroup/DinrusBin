//============================================================================
// FinalMeshItemsT.d - 
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

module auxd.OpenMesh.Core.Mesh.FinalMeshItemsT;

//== INCLUDES =================================================================


import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Mesh.Handles;
import auxd.OpenMesh.Core.Utils.GenProg;
import auxd.OpenMesh.Core.Utils.vector_traits;


//== CLASS DEFINITION =========================================================

/// Definition of the mesh entities (items).
struct FinalMeshItemsT(Traits, bool IsTriMesh)
{
    //--- build Refs structure ---
    struct Refs
    {
        alias Traits.Point            Point;
        alias vector_traits!(Point).value_type Scalar;

        alias Traits.Normal           Normal;
        alias Traits.Color            Color;
        alias Traits.TexCoord1D       TexCoord1D;
        alias Traits.TexCoord2D       TexCoord2D;
        alias Traits.TexCoord3D       TexCoord3D;
        alias auxd.OpenMesh.Core.Mesh.Handles.VertexHandle    VertexHandle;
        alias auxd.OpenMesh.Core.Mesh.Handles.FaceHandle      FaceHandle;
        alias auxd.OpenMesh.Core.Mesh.Handles.EdgeHandle      EdgeHandle;
        alias auxd.OpenMesh.Core.Mesh.Handles.HalfedgeHandle  HalfedgeHandle;
    }
    //--- export Refs types ---
    alias Refs.Point           Point;
    alias Refs.Scalar          Scalar;
    alias Refs.Normal          Normal;
    alias Refs.Color           Color;
    alias Refs.TexCoord1D      TexCoord1D;
    alias Refs.TexCoord2D      TexCoord2D;
    alias Refs.TexCoord3D      TexCoord3D;

    //--- get attribute bits from Traits ---
    //enum Attribs
    //{
    const    VAttribs = Traits.VertexAttributes;
    const    HAttribs = Traits.HalfedgeAttributes;
    const    EAttribs = Traits.EdgeAttributes;
    const    FAttribs = Traits.FaceAttributes;
    //}
    //--- merge internal items with traits items ---


/*
  alias GenProg.IF<
  (bool)(HAttribs & Attributes.PrevHalfedge),
  InternalItems.Halfedge_with_prev,
  InternalItems.Halfedge_without_prev
  >.Result   InternalHalfedge;
*/
    //alias InternalItems.Vertex                     InternalVertex;
    //alias InternalItems.template Edge<Halfedge>      InternalEdge;
    //alias InternalItems.template Face<IsTriMesh>     InternalFace;
    struct ITraits
    {}

    alias Traits.VertexT!(ITraits, Refs)      VertexData;
    alias Traits.HalfedgeT!(ITraits, Refs)    HalfedgeData;
    alias Traits.EdgeT!(ITraits, Refs)        EdgeData;
    alias Traits.FaceT!(ITraits, Refs)        FaceData;
}

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
