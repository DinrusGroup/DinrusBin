//============================================================================
// ImporterT.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *  Implements an importer module for arbitrary OpenMesh meshes
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 01 Sep 2007
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

module auxd.OpenMesh.Core.IO.importer.ImporterT;

//=== INCLUDES ================================================================


import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.IO.importer.BaseImporter;
import auxd.OpenMesh.Core.Utils.vector_cast;
import auxd.OpenMesh.Core.Mesh.Attributes;
import auxd.OpenMesh.Core.Mesh.Handles;
import auxd.OpenMesh.Core.Mesh.BaseKernel;
import auxd.OpenMesh.Core.Utils.Property;
import auxd.OpenMesh.Core.Geometry.VectorTypes;
//import auxd.OpenMesh.Core.System.omstream;
import auxd.OpenMesh.Core.IO.Streams;
import std.stdarg;

import std.io;

//=== IMPLEMENTATION ==========================================================

private {
    const string[] supported_types = 
        ["byte","ubyte","short","ushort","int","uint","float","double",
         "Vec3f","Vec3d","Vec3ub","Vec2f","Vec2d","Vec2ub","Vec4f","Vec4d","Vec4ub"];
    // Very simple compile-time pattern subsitution.  
    // Just replaces all % chars with sub
    string ctfe_subs(string str, string sub) {
        string ret;
        foreach(c; str) {
            if (c=='%') { ret ~= sub; }
            else { ret ~= c; }
        }
        return ret;
    }
    // Assumes calling code has a TypeInfo ti variable.
    // Assumes templ uses '%' as a stand-in for the type name
    string do_type_cases(string templ) {
        // Generates a big if-else block of the form
        //     if(false) {}
        //     else if(ti == typeid(int)) { <templ> }
        //     else if(ti == typeid(float)) { <templ> }
        //     ...
        string ret = "if(false){}\n";
        foreach(t; supported_types) {
            ret ~= "else if (ti == typeid("~t~")) { ";
            ret ~= ctfe_subs(templ,t);
            ret ~= " }\n";
        }
        ret ~= "else assert(false, \"Unsupported type: \"~ti.toString);";
        return ret;
    }
}

/**
 *  This class template provides an importer module for OpenMesh meshes.
 */
class ImporterT(Mesh) : public BaseImporter
{
  public:

    alias Mesh.Point       Point;
    alias Mesh.Normal      Normal;
    alias Mesh.Color       Color;
    alias Mesh.TexCoord2D  TexCoord2D;
    alias VertexHandle[]   VHandles;
    //alias Mesh.VPropHandleT VPropHandleT;
    //alias Mesh.FPropHandleT FPropHandleT;


    this(Mesh _mesh) {  mesh_= (_mesh); }


    VertexHandle add_vertex(/*const*/ ref Vec3f _point) 
    {
        return mesh_.add_vertex(vector_cast!(Point)(_point));
    }
   

    VertexHandle add_vertex() 
    {
        return mesh_.new_vertex();
    }
   

    FaceHandle add_face(/*const*/ VHandles _indices, FaceHandle[]* _fh_out = null) 
    {
        FaceHandle fh;

        if (_indices.length > 2)
        {
            // test for valid vertex indices
            foreach(it; _indices)
                if (! mesh_.is_valid_handle(it))
                {
                    derr.writefln("ImporterT: Face contains invalid vertex index: %s", it).flush;
                    return fh;
                }


            // don't allow double vertices
            foreach(i, it; _indices)
                foreach(it2; _indices[i+1..$])
                    if (it == it2)
                    {
                        derr.writefln("ImporterT: Face %s has duplicate vertex %s",fh,it).flush;
                        failed_faces_ ~= _indices;
                        return fh;
                    }


            // try to add face
            fh = mesh_.add_face(_indices, _fh_out);
            if (!fh.is_valid()) 
            {
                derr.writefln("ImporterT: Face failed").flush;
                failed_faces_ ~= _indices;
                return fh;
            }
        }
    
        return fh;
    }


    // vertex attributes

    void set_point(VertexHandle _vh, /*const*/ ref Vec3f _point)
    {
        mesh_.set_point(_vh, vector_cast!(Point)(_point));
    }



    void set_normal(VertexHandle _vh, /*const*/ ref Vec3f _normal)
    {
        if (!mesh_.has_vertex_normals())
            mesh_.request_vertex_normals();
        mesh_.set_normal(_vh, vector_cast!(Normal)(_normal));
    }


    void set_color(VertexHandle _vh, /*const*/ ref Vec3ub _color)
    {
        if (!mesh_.has_vertex_colors())
            mesh_.request_vertex_colors();
        mesh_.set_color(_vh, vector_cast!(Color)(_color));
    }


    void set_texcoord(VertexHandle _vh, /*const*/ ref Vec2f _texcoord)
    {
        if (!mesh_.has_vertex_texcoords2D())
            mesh_.request_vertex_texcoords2D();
        mesh_.set_texcoord2D(_vh, vector_cast!(TexCoord2D)(_texcoord));
    }


    // face attributes

    void set_normal(FaceHandle _fh, /*const*/ ref Vec3f _normal)
    {
        if (!mesh_.has_face_normals())
            mesh_.request_face_normals();
        mesh_.set_normal(_fh, vector_cast!(Normal)(_normal));
    }

    void set_color(FaceHandle _fh, /*const*/ ref Vec3ub _color)
    {
        if (!mesh_.has_face_colors())
            mesh_.request_face_colors();
        mesh_.set_color(_fh, vector_cast!(Color)(_color));
    }


    /// check if a property type is supported
    bool supports_property_data_type(TypeInfo ti) {
        bool ok=false;
        
        mixin(do_type_cases( "ok=true;" ));

        return ok;
    }


    void set_vpropertyT(T)(VertexHandle _vh, string _propname, T _value) {
        VPropHandleT!(T) ph;
        mesh_.get_property_handle(ph, _propname);
        if (!ph.is_valid) {
            mesh_.add_property(ph, _propname);
        }
        *mesh_.property_ptr(ph, _vh) = _value;
    }
    void set_fpropertyT(T)(FaceHandle _fh, string _propname,  T _value) {
        FPropHandleT!(T) ph;
        mesh_.get_property_handle(ph, _propname);
        if (!ph.is_valid) {
            mesh_.add_property(ph, _propname);
        }
        *mesh_.property_ptr(ph, _fh) = _value;
    }

    /// set a general vertex property, creating it if it doesn't exist yet
    void set_property(VertexHandle _vh, string _propname, ...)
    {
        if (_arguments.length == 0) {
            throw new Exception("set_property takes 1 value argument, or a typeinfo and a void*");
        }
        TypeInfo ti = _arguments[0];
        void *aptr = _argptr;
        if (_arguments.length == 2) {
            if (ti == typeid(TypeInfo)) {
                ti = va_arg!(TypeInfo)(_argptr);
                aptr = va_arg!(void*)(_argptr);
            }
            else {
                throw new Exception("set_property with 2 arguments should have a typeinfo as arg 1");
            }
        }
        else if (_arguments.length>2 ) {
            throw new Exception("set_property takes 1 value argument, or a typeinfo and a void*");
        }
        
        mixin(do_type_cases( "set_vpropertyT!( % )(_vh, _propname, va_arg!( % )(aptr));" ));

    }

    /// set a general face property, creating it if it doesn't exist yet
    void set_property(FaceHandle _fh, string _propname, ...)
    {
        if (_arguments.length == 0) 
            throw new Exception("set_property takes 1 value argument, or a typeinfo and a void*");

        TypeInfo ti = _arguments[0];
        void *aptr = _argptr;
        if (_arguments.length == 2) {
            if (ti == typeid(TypeInfo)) {
                ti = va_arg!(TypeInfo)(_argptr);
                aptr = va_arg!(void*)(_argptr);
            }
            else {
                throw new Exception("set_property with 2 arguments should have a typeinfo as arg 1");
            }
        }
        else if (_arguments.length>2 ) {
            throw new Exception("set_property takes 1 value argument, or a typeinfo and a void*");
        }

        mixin(do_type_cases( "set_fpropertyT!( % )(_fh, _propname, va_arg!( % )(aptr));" ));
    }


    // low-level access to mesh

    BaseKernel kernel() { return mesh_; }

    bool is_triangle_mesh() /*const*/
    { return Mesh.is_triangles(); }

    void reserve(uint nV, uint nE, uint nF)
    {
        mesh_.reserve(nV, nE, nF);
    }

    // query number of faces, vertices, normals, texcoords
    size_t n_vertices()  /*const*/ { return mesh_.n_vertices(); }   
    size_t n_faces()     /*const*/ { return mesh_.n_faces(); }
    size_t n_edges()     /*const*/ { return mesh_.n_edges(); }


    void prepare() { failed_faces_.length = 0; }


    void finish() 
    {
        if (failed_faces_)
        {
            derr.writefln(failed_faces_.length, " faces failed, adding them as isolated faces");

            for (uint i=0; i<failed_faces_.length; ++i)
            {
                VHandles vhandles = failed_faces_[i];

                // double vertices
                for (uint j=0; j<vhandles.length; ++j)
                {
                    Point p = mesh_.point(vhandles[j]);
                    vhandles[j] = mesh_.add_vertex(p);
                    // DO STORE p, reference may not work since vertex array
                    // may be relocated after adding a new vertex !
                }

                // add face
                mesh_.add_face(vhandles);      
            }

            failed_faces_.length = 0;
        }
    }



  private:

    Mesh mesh_;
    VHandles[]  failed_faces_;
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
