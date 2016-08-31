module mesh.Traits;

public import mesh.Attributes;
import linalg.VectorTypes;
import mesh.Handles;


//== CLASS DEFINITION =========================================================


/// Macro for defining the vertex attributes. See \ref mesh_type.
//template VertexAttributes(бцел _i) {  enum { VertexAttributes = _i } }
//  const бцел VertexAttributes = _i;

/// Macro for defining the halfedge attributes. See \ref mesh_type.
//template HalfedgeAttributesMix(бцел _i) { enum { HalfedgeAttributes = _i } }
//  const бцел HalfedgeAttributes = _i;

/// Macro for defining the edge attributes. See \ref mesh_type.
//template EdgeAttributesMix(бцел _i) { enum { EdgeAttributes = _i } }
//  const бцел EdgeAttributes = _i;

/// Macro for defining the face attributes. See \ref mesh_type.
//template FaceAttributesMix(бцел _i) { enum { FaceAttributes = _i } }
//  const бцел FaceAttributes = _i;

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


/** \class ДефолтныеТрэты Traits.hh <OpenMesh/Mesh/Traits.hh>
    
    Base class for all traits.  All user traits should be derived from
    this class. You may enrich all basic items by additional
    properties or define one or more of the types \c Точка, \c Нормаль,
    \c ТексКоорд, or \c Цвет.

    See_Also: The Mesh doc section on \ref mesh_type,
              Traits.d for a list of macros for traits classes.
*/
class ДефолтныеТрэты
{
    /// The default coordinate type is auxd.OpenMesh.Век3п.
    alias Век3п  Точка;

    /// The default normal type is auxd.OpenMesh.Век3п.
    alias Век3п  Нормаль;

    /// The default 1D texture coordinate type is float.
    alias float  ТексКоорд1Д;
    /// The default 2D texture coordinate type is auxd.OpenMesh.Век2п.
    alias Век2п  ТексКоорд2Д;
    /// The default 3D texture coordinate type is auxd.OpenMesh.Век3п.
    alias Век3п  ТексКоорд3Д;

    /// The default color type is auxd.OpenMesh.Vec3uc.
    alias Век3бб Цвет;

    struct VertexT(Base,Refs) /* : Base */{}
    struct HalfedgeT(Base,Refs) /* : Base */ {}
    struct EdgeT(Base,Refs)  /* : Base */ {}
    struct FaceT(Base,Refs)  /* : Base */ {}
  
    const бцел VertexAttributes = 0;
    const бцел HalfedgeAttributes = АтрибутныеБиты.ПредшПолукрай;
    const бцел EdgeAttributes = 0;
    const бцел FaceAttributes = 0;
}

/// TODO: Currently there isn't a way to extend the traits
/// The original код inherited from Base but we can't do that 
/// because structs can't inherit.  I can't think of a good way to do it
/// и still maintain the value-type semantics in текущ D


//== CLASS DEFINITION =========================================================


/** Helper class to merge two mesh traits. 
 *  \internal
 *
 *  With the помощь of this class it's possible to merge two mesh traits.
 *  Whereby \c _Traits1 overrides equally named symbols of \c _Traits2.
 *
 *  For your convenience use the provided defines \c OM_Merge_Traits
 *  и \c OM_Merge_Traits_In_Template instead.
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


        alias T1.Точка    Точка;
        alias T1.Нормаль   Нормаль;
        alias T1.Цвет    Цвет;
        alias T1.ТексКоорд ТексКоорд;

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
    Macro for merging two traits classes _S1 и _S2 into one traits class _D.
    Note that in case of ambiguities class _S1 overrides _S2, especially
    the point/normal/color/texcoord type to be использован is taken from _S1.Точка/
    _S1.Нормаль/_S1.Цвет/_S1.ТексКоорд.
*/
template OM_Merge_Traits(_S1, _S2, alias _D) {
    alias mesh.Traits.MergeTraits!(_S1, _S2).Result _D;
}


/** 
    Macro for merging two traits classes _S1 и _S2 into one traits class _D.
    Same as OM_Merge_Traits, but this can be использован inside template classes.
*/
template OM_Merge_Traits_In_Template(_S1, _S2, alias _D) {
    alias mesh.Traits.MergeTraits!(_S1, _S2).Result _D;
}