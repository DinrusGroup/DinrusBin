//============================================================================
// BaseImporter.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 *  Implements the baseclass for IOManager importer modules
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
module auxd.OpenMesh.Core.IO.importer.BaseImporter;

//=== INCLUDES ================================================================


// OpenMesh
import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Geometry.VectorTypes;
import auxd.OpenMesh.Core.Mesh.BaseKernel;
import auxd.OpenMesh.Core.Mesh.Handles;


//=== IMPLEMENTATION ==========================================================


/**  Base class for importer modules. Importer modules provide an
 *   interface between the loader modules and the target data
 *   structure. This is basically a wrapper providing virtual versions
 *   for the required mesh functions.
 */
class BaseImporter
{
public:

    /// add a vertex with coordinate \c _point
    abstract VertexHandle add_vertex(/*const*/ ref Vec3f _point);

    /// add a vertex with unspecified coordinate
    abstract VertexHandle add_vertex();
   
    alias VertexHandle[] VHandles;

    /// add a face with indices _indices refering to vertices
    /// Optionally return a list of added faces 
    /// (for trimeshes, which triangulate every face)
    abstract FaceHandle add_face(/*const*/ VHandles _indices, FaceHandle[]* _fhout=null);

    /// set vertex position
    abstract void set_point(VertexHandle _vh, /*const*/ ref Vec3f _point);

    /// set vertex normal
    abstract void set_normal(VertexHandle _vh, /*const*/ ref Vec3f _normal);

    /// set vertex color
    abstract void set_color(VertexHandle _vh, /*const*/ ref Vec3ub _color);

    /// set vertex texture coordinate
    abstract void set_texcoord(VertexHandle _vh, /*const*/ ref Vec2f _texcoord);

    /// set face normal
    abstract void set_normal(FaceHandle _fh, /*const*/ ref Vec3f _normal);

    /// set face color
    abstract void set_color(FaceHandle _fh, /*const*/ ref Vec3ub _color);

    /// set a general vertex property
    abstract void set_property(VertexHandle _fh, string _propname, ...);

    /// set a general face property
    abstract void set_property(FaceHandle _fh, string _propname, ...);

    /// check if a property type is supported
    abstract bool supports_property_data_type(TypeInfo _ti);

    /// get reference to base kernel
    BaseKernel kernel() { return null; }

    bool is_triangle_mesh()     /*const*/ { return false; }

    // reserve mem for elements
    void reserve(uint nV, uint nE, uint nF) {}

    // query number of faces, vertices, normals, texcoords
    abstract size_t n_vertices()   /*const*/ ;
    abstract size_t n_faces()      /*const*/ ;
    abstract size_t n_edges()      /*const*/ ;


    // pre-processing
    void prepare()  {}

    // post-processing
    void finish()  {}
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
