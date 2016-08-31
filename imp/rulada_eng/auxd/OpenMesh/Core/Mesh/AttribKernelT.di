//============================================================================
// AttribKernelT.d - 
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

module auxd.OpenMesh.Core.Mesh.AttribKernelT;

import std.io;

//== INCLUDES =================================================================

import auxd.OpenMesh.Core.Mesh.Attributes;
import auxd.OpenMesh.Core.Utils.Property;
import auxd.OpenMesh.Core.Mesh.Handles;
import auxd.OpenMesh.Core.Utils.vector_traits;

//== CLASS DEFINITION =========================================================

/// This class adds the standard properties to the mesh type.
///
/// The attribute kernel adds all standard properties to the kernel. Therefore
/// the functions/types defined here provide a subset of the kernel
/// interface as described in Concepts.KernelT.
///
/// See_Also: Concepts.KernelT

class AttribKernelT(MeshItems, Connectivity) : Connectivity
{
  public:

    //---------------------------------------------------------------- item types

    alias Connectivity.Vertex     Vertex;
    alias Connectivity.Halfedge   Halfedge;
    alias Connectivity.Edge       Edge;
    alias Connectivity.Face       Face;

    alias MeshItems.Point         Point;
    alias MeshItems.Normal        Normal;
    alias MeshItems.Color         Color;
    alias MeshItems.TexCoord1D    TexCoord1D;
    alias MeshItems.TexCoord2D    TexCoord2D;
    alias MeshItems.TexCoord3D    TexCoord3D;
    alias MeshItems.Scalar        Scalar;

    alias MeshItems.VertexData    VertexData;
    alias MeshItems.HalfedgeData  HalfedgeData;
    alias MeshItems.EdgeData      EdgeData;
    alias MeshItems.FaceData      FaceData;

    alias AttribKernelT!(MeshItems,Connectivity)  AttribKernel;

    //enum Attribs  {
    static VAttribs = MeshItems/*.Attribs*/.VAttribs;
    static sHAttribs = MeshItems/*.Attribs*/.HAttribs;
    static EAttribs = MeshItems/*.Attribs*/.EAttribs;
    static FAttribs = MeshItems/*.Attribs*/.FAttribs;
    static HAttribs = MeshItems/*.Attribs*/.HAttribs;
    //}

    alias VPropHandleT!(VertexData)              DataVPropHandle;
    alias HPropHandleT!(HalfedgeData)            DataHPropHandle;
    alias EPropHandleT!(EdgeData)                DataEPropHandle;
    alias FPropHandleT!(FaceData)                DataFPropHandle;

  public:

    //-------------------------------------------------- constructor / destructor

    this() {
        add_property( points_, "v:points" );

        if (VAttribs & AttributeBits.Normal)
            request_vertex_normals();

        if (VAttribs & AttributeBits.Color)
            request_vertex_colors();

        if (VAttribs & AttributeBits.TexCoord1D)
            request_vertex_texcoords1D();

        if (VAttribs & AttributeBits.TexCoord2D)
            request_vertex_texcoords2D();

        if (VAttribs & AttributeBits.TexCoord3D)
            request_vertex_texcoords3D();

        if (VAttribs & AttributeBits.Status)
            Connectivity.request_vertex_status();

        if (HAttribs & AttributeBits.Status)
            Connectivity.request_halfedge_status();

        if (EAttribs & AttributeBits.Status)
            Connectivity.request_edge_status();

        if (FAttribs & AttributeBits.Normal)
            request_face_normals();

        if (FAttribs & AttributeBits.Color)
            request_face_colors();

        if (FAttribs & AttributeBits.Status)
            Connectivity.request_face_status();

        if (VertexData.sizeof>0) {
            add_property(data_vpph_, "v:vdata");
        }
        if (FaceData.sizeof>0) {
            add_property(data_fpph_, "f:fdata");
        }
        if (HalfedgeData.sizeof>0) {
            add_property(data_hpph_, "h:hdata");
        }
        if (EdgeData.sizeof>0) {
            add_property(data_epph_, "e:edata");
        }
    }

    ~this()
    {
        // should remove properties, but this will be done in
        // BaseKernel's destructor anyway...
    }

    // -------------------------------------------------------- copy & assignment
    void copy(/*const*/ AttribKernelT _other)
    {
        super.copy(_other);
        // BaseKernel will actually copy all the properties for us.
        // we just need to update our refcounts and handles to reflect reality

        if (!get_property_handle( points_, "v:points" )) {
            throw new Exception("AttribKernelT.copy: Mesh has no v:points property");
        }

        if (get_property_handle( vertex_normals_, "v:normals" )) {
          refcount_vnormals_ = 1;
        }
        if (get_property_handle( vertex_colors_, "v:colors" )) {
          refcount_vcolors_ = 1;
        }
        if (get_property_handle( vertex_texcoords1D_, "v:texcoords1D" )) {
          refcount_vtexcoords1D_ = 1;
        }
        if (get_property_handle( vertex_texcoords2D_, "v:texcoords2D" )) {
          refcount_vtexcoords2D_ = 1;
        }
        if (get_property_handle( vertex_texcoords3D_, "v:texcoords3D" )) {
          refcount_vtexcoords3D_ = 1;
        }
        if (get_property_handle( face_normals_, "f:normals" )) {
          refcount_fnormals_ = 1;
        }
        if (get_property_handle( face_colors_, "f:colors" )) {
          refcount_fcolors_ = 1;
        }

        if (VertexData.sizeof > 0)   get_property_handle( data_vpph_, "v:vdata" );
        if (HalfedgeData.sizeof > 0) get_property_handle( data_hpph_, "h:hdata" );
        if (EdgeData.sizeof > 0)     get_property_handle( data_epph_, "e:edata" );
        if (FaceData.sizeof > 0)     get_property_handle( data_fpph_, "f:fdata" );
    }

    /** Assignment from another mesh of \em another type.
        \note All that's copied is connectivity and vertex positions.
        All other information (like e.g. attributes or additional
        elements from traits classes) is not copied.
        \note If you want to copy all information, including *custom* properties,
        use AttribKernelT.copy() instead.  
        TODO: version which copies standard properties specified by the user
    */
    void assign(_AttribKernel)(/*const*/ _AttribKernel _other)
    {
        assign_connectivity(_other);
        for (Connectivity.VertexIter v_it = Connectivity.vertices_begin(); 
             v_it != Connectivity.vertices_end(); ++v_it)
        {//assumes Point constructor supports cast from _AttribKernel.Point
            set_point(v_it.handle, cast(Point)_other.point(v_it.handle));
        }    
    }

    //-------------------------------------------------------------------- points

    /*const*/ Point[] points() /*const*/ 
    { return property(points_).data(); }

    ///*const*/ Point point(VertexHandle _vh) /*const*/ 
    //{ return property(points_, _vh); }

    Point point(VertexHandle _vh) 
    { return property(points_, _vh); }

    Point* point_ptr(VertexHandle _vh) 
    { return property_ptr(points_, _vh); }

    void set_point(VertexHandle _vh, /*const*/ ref Point _p) 
    { 
        //writefln("set_point: Vh now: ", _vh.idx);
        *property_ptr(points_, _vh) = _p; 
    }


    //------------------------------------------------------------ vertex normals

    /*const*/ Normal[] vertex_normals() /*const*/ 
    { return property(vertex_normals_).data(); }

    /*const*/ Normal normal(VertexHandle _vh) /*const*/ 
    { return property(vertex_normals_, _vh); }

    /*const*/ Normal* normal_ptr(VertexHandle _vh) /*const*/ 
    { return property_ptr(vertex_normals_, _vh); }

    void set_normal(VertexHandle _vh, /*const*/ ref Normal _n) 
    { *property_ptr(vertex_normals_, _vh) = _n; }


    //------------------------------------------------------------- vertex colors

    /*const*/ Color[] vertex_colors() /*const*/ 
    { return property(vertex_colors_).data(); }

    /*const*/ Color color(VertexHandle _vh) /*const*/
    { return property(vertex_colors_, _vh); }

    /*const*/ Color* color_ptr(VertexHandle _vh) /*const*/
    { return property_ptr(vertex_colors_, _vh); }

    void set_color(VertexHandle _vh, /*const*/ ref Color _c) 
    { *property_ptr(vertex_colors_, _vh) = _c; }


    //------------------------------------------------------- vertex 1D texcoords

    /*const*/ TexCoord1D[] texcoords1D() /*const*/ {
        return property(vertex_texcoords1D_).data();
    }

    /*const*/ TexCoord1D texcoord1D(VertexHandle _vh) /*const*/ {
        return property(vertex_texcoords1D_, _vh);
    }

    /*const*/ TexCoord1D* texcoord1D_ptr(VertexHandle _vh) /*const*/ {
        return property_ptr(vertex_texcoords1D_, _vh);
    }

    void set_texcoord1D(VertexHandle _vh, /*const*/ ref TexCoord1D _t) {
        *property_ptr(vertex_texcoords1D_, _vh) = _t;
    }


    //------------------------------------------------------- vertex 2D texcoords

    /*const*/ TexCoord2D[] texcoords2D() /*const*/ {
        return property(vertex_texcoords2D_).data();
    }

    /*const*/ TexCoord2D texcoord2D(VertexHandle _vh) /*const*/ {
        return property(vertex_texcoords2D_, _vh);
    }

    /*const*/ TexCoord2D* texcoord2D_ptr(VertexHandle _vh) /*const*/ {
        return property_ptr(vertex_texcoords2D_, _vh);
    }

    void set_texcoord2D(VertexHandle _vh, /*const*/ ref TexCoord2D _t) {
        *property_ptr(vertex_texcoords2D_, _vh) =  _t;
    }


    //------------------------------------------------------- vertex 3D texcoords

    /*const*/ TexCoord3D[] texcoords3D() /*const*/ {
        return property(vertex_texcoords3D_).data();
    }

    /*const*/ TexCoord3D texcoord3D(VertexHandle _vh) /*const*/ {
        return property(vertex_texcoords3D_, _vh);
    }

    /*const*/ TexCoord3D* texcoord3D_ptr(VertexHandle _vh) /*const*/ {
        return property_ptr(vertex_texcoords3D_, _vh);
    }

    void set_texcoord3D(VertexHandle _vh, /*const*/ ref TexCoord3D _t) {
        *property_ptr(vertex_texcoords3D_, _vh) = _t;
    }
  
    //-------------------------------------------------------------- face normals

    /*const*/ Normal normal(FaceHandle _fh) /*const*/ 
    { return property(face_normals_, _fh); }

    /*const*/ Normal* normal_ptr(FaceHandle _fh) /*const*/ 
    { return property_ptr(face_normals_, _fh); }

    void set_normal(FaceHandle _fh, /*const*/ ref Normal _n) 
    { *property_ptr(face_normals_, _fh) = _n; }

    //--------------------------------------------------------------- face colors

    /*const*/ Color color(FaceHandle _fh) /*const*/
    { return property(face_colors_, _fh); }

    /*const*/ Color* color_ptr(FaceHandle _fh) /*const*/
    { return property_ptr(face_colors_, _fh); }

    void set_color(FaceHandle _fh, /*const*/ ref Color _c)
    { *property_ptr(face_colors_, _fh) = _c; }

    //------------------------------------------------ request / alloc properties

    void request_vertex_normals()
    {
        if (!refcount_vnormals_++)
            add_property( vertex_normals_, "v:normals" );
    }

    void request_vertex_colors()
    {
        if (!refcount_vcolors_++)
            add_property( vertex_colors_, "v:colors" );
    }

    void request_vertex_texcoords1D() 
    {
        if (!refcount_vtexcoords1D_++)
            add_property( vertex_texcoords1D_, "v:texcoords1D" );
    }

    void request_vertex_texcoords2D() 
    {
        if (!refcount_vtexcoords2D_++)
            add_property( vertex_texcoords2D_, "v:texcoords2D" );
    }

    void request_vertex_texcoords3D() 
    {
        if (!refcount_vtexcoords3D_++)
            add_property( vertex_texcoords3D_, "v:texcoords3D" );
    }

    void request_face_normals()
    {
        if (!refcount_fnormals_++)
            add_property( face_normals_, "f:normals" );
    }

    void request_face_colors()
    {
        if (!refcount_fcolors_++)
            add_property( face_colors_, "f:colors" );
    }

    //------------------------------------------------- release / free properties

    void release_vertex_normals()
    {
        if ((refcount_vnormals_ > 0) && (! --refcount_vnormals_))
            remove_property(vertex_normals_);
    }

    void release_vertex_colors()
    {
        if ((refcount_vcolors_ > 0) && (! --refcount_vcolors_))
            remove_property(vertex_colors_);
    }

    void release_vertex_texcoords1D() {
        if ((refcount_vtexcoords1D_ > 0) && (! --refcount_vtexcoords1D_))
            remove_property(vertex_texcoords1D_);
    }

    void release_vertex_texcoords2D() {
        if ((refcount_vtexcoords2D_ > 0) && (! --refcount_vtexcoords2D_))
            remove_property(vertex_texcoords2D_);
    }

    void release_vertex_texcoords3D() {
        if ((refcount_vtexcoords3D_ > 0) && (! --refcount_vtexcoords3D_))
            remove_property(vertex_texcoords3D_);
    }

    void release_face_normals()
    {
        if ((refcount_fnormals_ > 0) && (! --refcount_fnormals_))
            remove_property(face_normals_);
    }

    void release_face_colors()
    {
        if ((refcount_fcolors_ > 0) && (! --refcount_fcolors_))
            remove_property(face_colors_);
    }

    //---------------------------------------------- dynamic check for properties

    bool has_vertex_normals()   /*const*/ { return vertex_normals_.is_valid();   }
    bool has_vertex_colors()    /*const*/ { return vertex_colors_.is_valid();    }
    bool has_vertex_texcoords1D() /*const*/ { return vertex_texcoords1D_.is_valid();}
    bool has_vertex_texcoords2D() /*const*/ { return vertex_texcoords2D_.is_valid();}
    bool has_vertex_texcoords3D() /*const*/ { return vertex_texcoords3D_.is_valid();}
    bool has_face_normals()     /*const*/ { return face_normals_.is_valid();     }
    bool has_face_colors()      /*const*/ { return face_colors_.is_valid();      }


  public:

    alias VPropHandleT!(Point)               PointsPropertyHandle;
    alias VPropHandleT!(Normal)              VertexNormalsPropertyHandle;
    alias VPropHandleT!(Color)               VertexColorsPropertyHandle;
    alias VPropHandleT!(TexCoord1D)          VertexTexCoords1DPropertyHandle;
    alias VPropHandleT!(TexCoord2D)          VertexTexCoords2DPropertyHandle;
    alias VPropHandleT!(TexCoord3D)          VertexTexCoords3DPropertyHandle;
    alias FPropHandleT!(Normal)              FaceNormalsPropertyHandle;
    alias FPropHandleT!(Color)               FaceColorsPropertyHandle;

/+
public:
  //standard vertex properties
  PointsPropertyHandle                      points_pph() /*const*/
  { return points_; }

  VertexNormalsPropertyHandle               vertex_normals_pph() /*const*/
  { return vertex_normals_; }

  VertexColorsPropertyHandle                vertex_colors_pph() /*const*/
  { return vertex_colors_; }

  VertexTexCoords1DPropertyHandle           vertex_texcoords1D_pph() /*const*/
  { return vertex_texcoords1D_; }

  VertexTexCoords2DPropertyHandle           vertex_texcoords2D_pph() /*const*/
  { return vertex_texcoords2D_; }

  VertexTexCoords3DPropertyHandle           vertex_texcoords3D_pph() /*const*/
  { return vertex_texcoords3D_; }

  //standard face properties
  FaceNormalsPropertyHandle                 face_normals_pph() /*const*/
  { return face_normals_; }

  FaceColorsPropertyHandle                  face_colors_pph() /*const*/
  { return face_colors_; }

+/
    VertexData                                data(VertexHandle _vh)
    { return property(data_vpph_, _vh); }

    VertexData*                               data_ptr(VertexHandle _vh)
    { return property_ptr(data_vpph_, _vh); }

    /+
     /*const*/ VertexData*                         data(VertexHandle _vh) /*const*/
     { return property(data_vpph_, _vh); }
     +/

    FaceData                                  data(FaceHandle _fh)
    { return property(data_fpph_, _fh); }

    FaceData*                                 data_ptr(FaceHandle _fh)
    { return property_ptr(data_fpph_, _fh); }

    /+
     /*const*/ FaceData*                           data(FaceHandle _fh) /*const*/
     { return property(data_fpph_, _fh); }
     +/

    EdgeData                                 data(EdgeHandle _eh)
    { return property(data_epph_, _eh); }

    EdgeData*                                 data_ptr(EdgeHandle _eh)
    { return property_ptr(data_epph_, _eh); }

    /+
     /*const*/ EdgeData*                           data(EdgeHandle _eh) /*const*/
     { return property(data_epph_, _eh); }
     +/

    HalfedgeData                             data(HalfedgeHandle _heh)
    { return property(data_hpph_, _heh); }

    HalfedgeData*                             data_ptr(HalfedgeHandle _heh)
    { return property_ptr(data_hpph_, _heh); }

    /+
     /*const*/ HalfedgeData*                       data(HalfedgeHandle _heh) /*const*/
     { return property(data_hpph_, _heh); }
     +/

  private:
    //standard vertex properties
    PointsPropertyHandle                      points_;
    VertexNormalsPropertyHandle               vertex_normals_;
    VertexColorsPropertyHandle                vertex_colors_;
    VertexTexCoords1DPropertyHandle           vertex_texcoords1D_;
    VertexTexCoords2DPropertyHandle           vertex_texcoords2D_;
    VertexTexCoords3DPropertyHandle           vertex_texcoords3D_;
    //standard face properties
    FaceNormalsPropertyHandle                 face_normals_;
    FaceColorsPropertyHandle                  face_colors_;
    //data properties handles
    DataVPropHandle                           data_vpph_;
    DataHPropHandle                           data_hpph_;
    DataEPropHandle                           data_epph_;
    DataFPropHandle                           data_fpph_;

    uint   refcount_vnormals_ = 0;
    uint   refcount_vcolors_ = 0;
    uint   refcount_vtexcoords1D_ = 0;
    uint   refcount_vtexcoords2D_ = 0;
    uint   refcount_vtexcoords3D_ = 0;
    uint   refcount_fnormals_ = 0;
    uint   refcount_fcolors_ = 0;
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
