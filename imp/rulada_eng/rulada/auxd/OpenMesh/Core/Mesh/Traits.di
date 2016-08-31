//============================================================================
// Traits.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   This file defines the default traits.
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

module auxd.OpenMesh.Core.Mesh.Traits;

//=============================================================================
//
//  CLASS Traits
//
//=============================================================================

//== INCLUDES =================================================================


import auxd.OpenMesh.Core.System.config;
public import auxd.OpenMesh.Core.Mesh.Attributes;
import auxd.OpenMesh.Core.Geometry.VectorTypes;
import auxd.OpenMesh.Core.Mesh.Handles;


//== CLASS DEFINITION =========================================================


/// Macro for defining the vertex attributes. See \ref mesh_type.
//template VertexAttributes(uint _i) {  enum { VertexAttributes = _i } }
//  const uint VertexAttributes = _i;

/// Macro for defining the halfedge attributes. See \ref mesh_type.
//template HalfedgeAttributesMix(uint _i) { enum { HalfedgeAttributes = _i } }
//  const uint HalfedgeAttributes = _i;

/// Macro for defining the edge attributes. See \ref mesh_type.
//template EdgeAttributesMix(uint _i) { enum { EdgeAttributes = _i } }
//  const uint EdgeAttributes = _i;

/// Macro for defining the face attributes. See \ref mesh_type.
//template FaceAttributesMix(uint _i) { enum { FaceAttributes = _i } }
//  const uint FaceAttributes = _i;

/+
/// Macro for defining the vertex traits. See \ref mesh_type.
template VertexTraits(defs... ) 
{
    struct VertexT(Base, Refs) : public Base { defs; }
}

/// Macro for defining the halfedge traits. See \ref mesh_type.
template HalfedgeTraits(defs...)
{
    struct HalfedgeT(Base,Refs) : public Base { defs; }
}

/// Macro for defining the edge traits. See \ref mesh_type.
template EdgeTraits(defs...) {
    struct EdgeT(Base,Refs) : public Base { defs; }
}

/// Macro for defining the face traits. See \ref mesh_type.
template FaceTraits(defs...) {
    struct FaceT(Base,Refs) : public Base { defs }
}
+/

//== CLASS DEFINITION =========================================================


/** \class DefaultTraits Traits.hh <OpenMesh/Mesh/Traits.hh>
    
    Base class for all traits.  All user traits should be derived from
    this class. You may enrich all basic items by additional
    properties or define one or more of the types \c Point, \c Normal,
    \c TexCoord, or \c Color.

    See_Also: The Mesh doc section on \ref mesh_type,
              Traits.d for a list of macros for traits classes.
*/
class DefaultTraits
{
    /// The default coordinate type is auxd.OpenMesh.Vec3f.
    alias Vec3f  Point;

    /// The default normal type is auxd.OpenMesh.Vec3f.
    alias Vec3f  Normal;

    /// The default 1D texture coordinate type is float.
    alias float  TexCoord1D;
    /// The default 2D texture coordinate type is auxd.OpenMesh.Vec2f.
    alias Vec2f  TexCoord2D;
    /// The default 3D texture coordinate type is auxd.OpenMesh.Vec3f.
    alias Vec3f  TexCoord3D;

    /// The default color type is auxd.OpenMesh.Vec3uc.
    alias Vec3ub Color;

    struct VertexT(Base,Refs) /* : Base */{}
    struct HalfedgeT(Base,Refs) /* : Base */ {}
    struct EdgeT(Base,Refs)  /* : Base */ {}
    struct FaceT(Base,Refs)  /* : Base */ {}
  
    const uint VertexAttributes = 0;
    const uint HalfedgeAttributes = AttributeBits.PrevHalfedge;
    const uint EdgeAttributes = 0;
    const uint FaceAttributes = 0;
}

/// TODO: Currently there isn't a way to extend the traits
/// The original code inherited from Base but we can't do that 
/// because structs can't inherit.  I can't think of a good way to do it
/// and still maintain the value-type semantics in current D


//== CLASS DEFINITION =========================================================


/** Helper class to merge two mesh traits. 
 *  \internal
 *
 *  With the help of this class it's possible to merge two mesh traits.
 *  Whereby \c _Traits1 overrides equally named symbols of \c _Traits2.
 *
 *  For your convenience use the provided defines \c OM_Merge_Traits
 *  and \c OM_Merge_Traits_In_Template instead.
 *
 *  See_Also: OM_Merge_Traits, OM_Merge_Traits_In_Template
 */
struct MergeTraits(_Traits1,_Traits2)
{
    class Result
    {
        alias _Traits1  T1;
        alias _Traits2  T2;


        mixin VertexAttributes   !( T1.VertexAttributes   | T2.VertexAttributes   );
        mixin HalfedgeAttributes !( T1.HalfedgeAttributes | T2.HalfedgeAttributes );
        mixin EdgeAttributes     !( T1.EdgeAttributes     | T2.EdgeAttributes     );
        mixin FaceAttributes     !( T1.FaceAttributes     | T2.FaceAttributes     );


        alias T1.Point    Point;
        alias T1.Normal   Normal;
        alias T1.Color    Color;
        alias T1.TexCoord TexCoord;

        struct VertexT(Base,Refs)
        {
            mixin T1.VertexT!(T2.VertexT!(Base, Refs), Refs);
        }

        struct HalfedgeT(Base,Refs)
        {
            mixin T1.HalfedgeT!(T2.HalfedgeT!(Base, Refs), Refs);
        }

        struct EdgeT(Base,Refs) {
            mixin T1.EdgeT!(T2.EdgeT!(Base, Refs), Refs);
        }

        struct FaceT(Base,Refs) {
            mixin T1.FaceT!(T2.FaceT!(Base, Refs), Refs);
        }
    }
}


/** 
    Macro for merging two traits classes _S1 and _S2 into one traits class _D.
    Note that in case of ambiguities class _S1 overrides _S2, especially
    the point/normal/color/texcoord type to be used is taken from _S1.Point/
    _S1.Normal/_S1.Color/_S1.TexCoord.
*/
template OM_Merge_Traits(_S1, _S2, alias _D) {
    alias auxd.OpenMesh.Core.Mesh.Traits.MergeTraits!(_S1, _S2).Result _D;
}


/** 
    Macro for merging two traits classes _S1 and _S2 into one traits class _D.
    Same as OM_Merge_Traits, but this can be used inside template classes.
*/
template OM_Merge_Traits_In_Template(_S1, _S2, alias _D) {
    alias auxd.OpenMesh.Core.Mesh.Traits.MergeTraits!(_S1, _S2).Result _D;
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
