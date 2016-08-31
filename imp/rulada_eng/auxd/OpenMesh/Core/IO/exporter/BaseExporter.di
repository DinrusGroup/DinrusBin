//============================================================================
// BaseExporter.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *  Implements the baseclass for MeshWriter exporter modules
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

module auxd.OpenMesh.Core.IO.exporter.BaseExporter;

//=== INCLUDES ================================================================


// OpenMesh
import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Geometry.VectorT;
import auxd.OpenMesh.Core.Mesh.BaseKernel;
import auxd.OpenMesh.Core.Mesh.Handles;


//=== EXPORTER ================================================================


/**
   Base class for exporter modules.
   The exporter modules provide an interface between the writer modules and
   the target data structure. 
*/

class BaseExporter
{
public:

    // get vertex data
    abstract Vec3f  point(VertexHandle _vh)    /*const*/ ;
    abstract Vec3f  normal(VertexHandle _vh)   /*const*/ ;
    abstract Vec3ub color(VertexHandle _vh)    /*const*/ ;
    abstract Vec2f  texcoord(VertexHandle _vh) /*const*/ ;

    
    // get face data
    abstract uint   get_vhandles(FaceHandle _fh, ref VertexHandle[] _vhandles) /*const*/;
    abstract Vec3f  normal(FaceHandle _fh)     /*const*/ ;
    abstract Vec3ub color(FaceHandle _fh)      /*const*/ ;
  

    // get reference to base kernel
    /*const*/ BaseKernel kernel() { return null; }


    // query number of faces, vertices, normals, texcoords
    abstract size_t n_vertices()   /*const*/ ;
    abstract size_t n_faces()      /*const*/ ;
    abstract size_t n_edges()      /*const*/ ;


    // property information
    bool is_triangle_mesh()     /*const*/ { return false; }
    bool has_vertex_normals()   /*const*/ { return false; }
    bool has_vertex_colors()    /*const*/ { return false; }
    bool has_vertex_texcoords() /*const*/ { return false; }      
    bool has_face_normals()     /*const*/ { return false; }
    bool has_face_colors()      /*const*/ { return false; }

    

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
