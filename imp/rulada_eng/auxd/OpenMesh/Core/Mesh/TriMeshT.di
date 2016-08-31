//============================================================================
// TriMeshT.d - 
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

module auxd.OpenMesh.Core.Mesh.TriMeshT;

//=============================================================================
//
//  CLASS TriMeshT
//
//=============================================================================


//== INCLUDES =================================================================


import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Mesh.PolyMeshT;


//== CLASS DEFINITION =========================================================


/** \class TriMeshT TriMeshT.hh <OpenMesh/Mesh/TriMeshT.hh>

    Base type for a triangle mesh.

    Base type for a triangle mesh, parameterized by a mesh kernel. The
    mesh inherits all methods from the kernel class and the
    more general polygonal mesh PolyMeshT. Therefore it provides
    the same types for items, handles, iterators and so on.

    \param Kernel: template argument for the mesh kernel
    \note You should use the predefined mesh-kernel combinations in
    \ref mesh_types_group
    See_Also: \ref mesh_type, auxd.OpenMesh.PolyMeshT
*/

class TriMeshT(Kernel) : PolyMeshT!(Kernel)
{

public:


  // self
    alias TriMeshT!(Kernel)                      This;
    alias PolyMeshT!(Kernel)                     PolyMesh;

  //@{
  /// Determine whether this is a PolyMeshT or TriMeshT
  enum { IsPolyMesh = 0 };
  enum { IsTriMesh  = 1 };
  static bool is_polymesh() { return false; }
  static bool is_trimesh()  { return  true; }
  //@}

  //--- items ---

  alias PolyMesh.Scalar             Scalar;
  alias PolyMesh.Point              Point;
  alias PolyMesh.Normal             Normal;
  alias PolyMesh.Color              Color;
  alias PolyMesh.TexCoord1D         TexCoord1D;
  alias PolyMesh.TexCoord2D         TexCoord2D;
  alias PolyMesh.TexCoord3D         TexCoord3D;
  alias PolyMesh.Vertex             Vertex;
  alias PolyMesh.Halfedge           Halfedge;
  alias PolyMesh.Edge               Edge;
  alias PolyMesh.Face               Face;


  //--- handles ---

  alias PolyMesh.VertexHandle       VertexHandle;
  alias PolyMesh.HalfedgeHandle     HalfedgeHandle;
  alias PolyMesh.EdgeHandle         EdgeHandle;
  alias PolyMesh.FaceHandle         FaceHandle;


  //--- iterators ---

  alias PolyMesh.VertexIter         VertexIter;
  alias PolyMesh.ConstVertexIter    ConstVertexIter;
  alias PolyMesh.EdgeIter           EdgeIter;
  alias PolyMesh.ConstEdgeIter      ConstEdgeIter;
  alias PolyMesh.FaceIter           FaceIter;
  alias PolyMesh.ConstFaceIter      ConstFaceIter;



  //--- circulators ---

  alias PolyMesh.VertexVertexIter         VertexVertexIter;
  alias PolyMesh.VertexOHalfedgeIter      VertexOHalfedgeIter;
  alias PolyMesh.VertexIHalfedgeIter      VertexIHalfedgeIter;
  alias PolyMesh.VertexEdgeIter           VertexEdgeIter;
  alias PolyMesh.VertexFaceIter           VertexFaceIter;
  alias PolyMesh.FaceVertexIter           FaceVertexIter;
  alias PolyMesh.FaceHalfedgeIter         FaceHalfedgeIter;
  alias PolyMesh.FaceEdgeIter             FaceEdgeIter;
  alias PolyMesh.FaceFaceIter             FaceFaceIter;
  alias PolyMesh.ConstVertexVertexIter    ConstVertexVertexIter;
  alias PolyMesh.ConstVertexOHalfedgeIter ConstVertexOHalfedgeIter;
  alias PolyMesh.ConstVertexIHalfedgeIter ConstVertexIHalfedgeIter;
  alias PolyMesh.ConstVertexEdgeIter      ConstVertexEdgeIter;
  alias PolyMesh.ConstVertexFaceIter      ConstVertexFaceIter;
  alias PolyMesh.ConstFaceVertexIter      ConstFaceVertexIter;
  alias PolyMesh.ConstFaceHalfedgeIter    ConstFaceHalfedgeIter;
  alias PolyMesh.ConstFaceEdgeIter        ConstFaceEdgeIter;
  alias PolyMesh.ConstFaceFaceIter        ConstFaceFaceIter;

  // --- constructor/destructor

  /// Default constructor
  this() { super(); }
  /// Destructor
  ~this() {}

  /** Copy one mesh over top of another.  
      This is a deep copy duplicating all data.
      If the mesh types vary, use PolyMeshT.assign() instead. 
  */
  void copy(TriMeshT _other) 
  {
      super.copy(_other);
  }

  /** Create a fresh copy of this mesh.
      This is a deep copy duplicating all data.
  */
  TriMeshT dup() 
  {
      auto ret = new TriMeshT;
      ret.copy(this);
      return ret;
  }


  //--- halfedge collapse / vertex split ---

  /// Vertex Split: inverse operation to collapse().
  HalfedgeHandle vertex_split(Point _v0_point,  VertexHandle _v1,
                                     VertexHandle _vl, VertexHandle _vr)
  { return super.vertex_split(add_vertex(_v0_point), _v1, _vl, _vr); }

  /// ditto
  HalfedgeHandle vertex_split(VertexHandle _v0, VertexHandle _v1,
                                     VertexHandle _vl, VertexHandle _vr)
  { return super.vertex_split(_v0, _v1, _vl, _vr); }

  /// Edge split (= 2-to-4 split)
  void split(EdgeHandle _eh, /*const*/ ref Point _p)
  { super.split(_eh, add_vertex(_p)); }

  /// dito
  void split(EdgeHandle _eh, VertexHandle _vh)
  { super.split(_eh, _vh); }

  /// Face split (= 1-to-3 split, calls corresponding PolyMeshT function).
  void split(FaceHandle _fh, /*const*/ ref Point _p)
  { super.split(_fh, _p); }

  /// ditto
  void split(FaceHandle _fh, VertexHandle _vh)
  { super.split(_fh, _vh); }
}


//=============================================================================

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
