//============================================================================
// ExporterT.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *  Implements an exporter module for arbitrary OpenMesh meshes
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

module auxd.OpenMesh.Core.IO.exporter.ExporterT;

//=== INCLUDES ================================================================

// OpenMesh
import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Geometry.VectorT;
import auxd.OpenMesh.Core.Utils.GenProg;
import auxd.OpenMesh.Core.Utils.vector_cast;
import auxd.OpenMesh.Core.Utils.color_cast;
import auxd.OpenMesh.Core.IO.exporter.BaseExporter;
import auxd.OpenMesh.Core.Mesh.Handles;
import auxd.OpenMesh.Core.Mesh.BaseKernel;


//=== EXPORTER CLASS ==========================================================

/**
 *  This class template provides an exporter module for OpenMesh meshes.
 */
class ExporterT(Mesh) : public BaseExporter
{
  public:

    // Constructor
    this(/*const*/ Mesh _mesh) { mesh_=(_mesh); }
   

    // get vertex data

    Vec3f  point(VertexHandle _vh)    /*const*/ 
    { 
        return vector_cast!(Vec3f)(mesh_.point(_vh)); 
    }

    Vec3f  normal(VertexHandle _vh)   /*const*/ 
    { 
        return (mesh_.has_vertex_normals() 
                ? vector_cast!(Vec3f)(mesh_.normal(_vh)) 
                : Vec3f(0.0f, 0.0f, 0.0f));
    }

    Vec3ub color(VertexHandle _vh)    /*const*/
    {
        return (mesh_.has_vertex_colors() 
                ? color_cast!(Vec3ub)(mesh_.color(_vh)) 
                : Vec3ub(0, 0, 0));
    }

    Vec2f  texcoord(VertexHandle _vh) /*const*/
    {
        return (mesh_.has_vertex_texcoords2D() 
                ? vector_cast!(Vec2f)(mesh_.texcoord2D(_vh)) 
                : Vec2f(0.0f, 0.0f));
    }

  
    // get face data

    uint get_vhandles(FaceHandle _fh, 
                      ref VertexHandle[] _vhandles) /*const*/
    {
        uint count=(0);
        _vhandles.length = 0;
        for (Mesh.CFVIter fv_it=mesh_.cfv_iter(_fh); fv_it.is_active; ++fv_it)
        {
            _vhandles ~= (fv_it.handle());
            ++count;
        }
        return count;
    }

    Vec3f  normal(FaceHandle _fh)   /*const*/ 
    { 
        return (mesh_.has_face_normals() 
                ? vector_cast!(Vec3f)(mesh_.normal(_fh)) 
                : Vec3f(0.0f, 0.0f, 0.0f));
    }

    Vec3ub  color(FaceHandle _fh)   /*const*/ 
    { 
        return (mesh_.has_face_colors() 
                ? vector_cast!(Vec3ub)(mesh_.color(_fh)) 
                : Vec3ub(0, 0, 0));
    }

    /*const*/ BaseKernel kernel() { return mesh_; }


    // query number of faces, vertices, normals, texcoords
    size_t n_vertices()  /*const*/ { return mesh_.n_vertices(); }   
    size_t n_faces()     /*const*/ { return mesh_.n_faces(); }
    size_t n_edges()     /*const*/ { return mesh_.n_edges(); }


    // property information
    bool is_triangle_mesh() /*const*/
    { return Mesh.is_triangles(); }
  
    bool has_vertex_normals()   /*const*/ { return mesh_.has_vertex_normals();   }
    bool has_vertex_colors()    /*const*/ { return mesh_.has_vertex_colors();    }
    bool has_vertex_texcoords() /*const*/ { return mesh_.has_vertex_texcoords2D(); }
    bool has_face_normals()     /*const*/ { return mesh_.has_face_normals();     }
    bool has_face_colors()      /*const*/ { return mesh_.has_face_colors();      }

  private:
  
    /*const*/ Mesh mesh_;
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
