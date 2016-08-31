/*==========================================================================
 * STLWriter.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * An OpenMesh writer for models in the STL format.
 *
 * From Wikipedia ( http://en.wikipedia.org/wiki/STL_(file_format) ).
 *
 * "STL is a file format native to the stereolithography CAD software
 * created by 3D Systems. This file format is supported by many other
 * software packages; it is widely used for rapid prototyping and
 * computer-aided manufacturing. STL files describe only the surface
 * geometry of a three dimensional object without any representation
 * of color, texture or other common CAD model attributes. The STL
 * format specifies both ASCII and binary representations. Binary
 * files are more common, since they are more compact.
 *
 * "An STL file describes a raw unstructured triangulated surface by
 * the unit normal and vertices (ordered by the right-hand rule) of
 * the triangles using a three-dimensional Cartesian coordinate
 * system."
 *
 * Authors:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 15 Oct 2007 (ported to D)
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
//===========================================================================

module auxd.OpenMesh.Core.IO.writer.STLWriter;

//=== INCLUDES ================================================================

import auxd.OpenMesh.Core.IO.Streams;

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Utils.SingletonT;
import auxd.OpenMesh.Core.IO.exporter.BaseExporter;
import auxd.OpenMesh.Core.IO.writer.BaseWriter;
import auxd.OpenMesh.Core.Mesh.Handles;
import auxd.OpenMesh.Core.Geometry.VectorT;
import auxd.OpenMesh.Core.IO.IOManager;
import auxd.OpenMesh.Core.IO.Options;
import binary = auxd.OpenMesh.Core.IO.BinaryHelper;

static import std.path;
import strlib = std.string;
import math = std.math;

import std.c;

//=== IMPLEMENTATION ==========================================================

private char* c_str(string s) {
    return strlib.toStringz(s);
}


/** 
    Implementation of the STL format writer. This class is singleton'ed by 
    SingletonT to STLWriter.
*/
class _STLWriter_ : BaseWriter
{
  public:
  
    this() { IOManager().register_module(this); }
  
    string get_description() /*const*/ { return "Stereolithography Format"; }
    string get_extensions()  /*const*/ { return "stla stlb"; }
  
    void update_options(string _filename, ref Options _opt) {
        // doesn't support much of anything, just face normals
        auto unsupported = Options(Options.AllProperties);
        unsupported -= Options.FaceNormal;
        _opt -= unsupported.flags;
    }

    bool write(/*const*/ string _filename, BaseExporter _be, Options _opt) /*const*/
    {
        // check exporter features
        if (!check(_be, _opt)) return false;


        // check writer features
        if (_opt.check(Options.VertexNormal)   ||
            _opt.check(Options.VertexTexCoord) ||
            _opt.check(Options.FaceColor))
            return false;


        // binary or ascii ?
        
        string ext = std.path.getExt(_filename);
        if (ext == "stla")
        {
            _opt -= Options.Binary;
            return write_stla(_filename, _be, _opt);
        }
        else if (ext == "stlb")
        {
            _opt += Options.Binary;
            return write_stlb(_filename, _be, _opt);
        }
        else if (ext == "stl")
        {
            return (_opt.check( Options.Binary ) 
                    ? write_stlb(_filename, _be, _opt)
                    : write_stla(_filename, _be, _opt) );
        }

        return false;
    }
  
    size_t binary_size(BaseExporter _be, Options _opt) /*const*/
    {
        size_t bytes = 0;
        size_t _12floats = 12*float.sizeof;

        bytes += 80; // header
        bytes += 4;  // #faces


        uint i, nF=_be.n_faces();
        VertexHandle[] vhandles;

        for (i=0; i<nF; ++i)
            if (_be.get_vhandles(FaceHandle(i), vhandles) == 3)
                bytes += _12floats + short.sizeof;
            else
                derr.writefln("[STLWriter] : Warning: Skipped non-triangle data!").flush;

        return bytes;
    }

  private:

    bool write_stla(/*const*/ string _filename, BaseExporter _be, Options _opt) /*const*/
    {
        //dlog.writefln("[STLWriter] : write ascii file").flush;


        // open file
        FILE* fout = fopen(_filename.c_str(), "w");
        if (!fout)
        {
            derr.writefln("[STLWriter] : cannot open file %s", _filename).flush;
            return false;
        }




        uint i, nF=_be.n_faces(), nV;
        Vec3f  a, b, c, n;
        VertexHandle[] vhandles;
        FaceHandle fh;


        // header
        fprintf(fout, "solid\n");

        Vec3f calc_normal(Vec3f _a, Vec3f _b, Vec3f _c)
        {
            Vec3f tmp1 = _c-_b;
            Vec3f tmp2 = _a-_b;
            Vec3f N = cross(tmp1,tmp2);
            N.normalize();
            return N;
        }


        // write face set
        for (i=0; i<nF; ++i)
        {
            fh = FaceHandle(i);
            nV = _be.get_vhandles(fh, vhandles);

            if (nV == 3)
            {
                a = _be.point(vhandles[0]);
                b = _be.point(vhandles[1]);
                c = _be.point(vhandles[2]);
                if (_be.has_face_normals()) {
                    n = _be.normal(fh);
                    if (math.isnan(n[0]) || n.sqrnorm < float.epsilon) {
                        // that's not a good normal!
                        n = calc_normal(a,b,c);
                    }
                } else {
                    n = calc_normal(a,b,c);
                }

                fprintf(fout, "facet normal %f %f %f\nouter loop\n", n[0], n[1], n[2]);
                fprintf(fout, "vertex %.10f %.10f %.10f\n", a[0], a[1], a[2]);
                fprintf(fout, "vertex %.10f %.10f %.10f\n", b[0], b[1], b[2]);
                fprintf(fout, "vertex %.10f %.10f %.10f",   c[0], c[1], c[2]);
            }
            else
                derr.writefln("[STLWriter] : Warning non-triangle data!").flush;

            fprintf(fout, "\nendloop\nendfacet\n");
        }



        fclose(fout);

        return true;
    }

    bool write_stlb(/*const*/ string _filename, BaseExporter _be, Options _opt) /*const*/
    {
        //dlog.writefln( "[STLWriter] : write binary file").flush;


        // open file
        FILE* fout = fopen(_filename.c_str(), "wb");
        if (!fout)
        {
            derr.writefln("[STLWriter] : cannot open file ", _filename).flush;
            return false;
        }


        uint i, nF=_be.n_faces(), nV;
        Vec3f  a, b, c, n;
        VertexHandle[] vhandles;
        FaceHandle fh;


        // write header
        static char[80] header =
            "binary stl file"
            " Output by OpenMesh/D, http://www.dsource.org/projects/openmeshd";
        fwrite(header.ptr, 1, 80, fout);


        // number of faces
        binary.write_int(_be.n_faces(), fout);


        Vec3f calc_normal(Vec3f _a, Vec3f _b, Vec3f _c)
        {
            Vec3f tmp1 = _c-_b;
            Vec3f tmp2 = _a-_b;
            Vec3f N = cross(tmp1,tmp2);
            N.normalize();
            return N;
        }

        // write face set
        for (i=0; i<nF; ++i)
        {
            fh = FaceHandle(i);
            nV = _be.get_vhandles(fh, vhandles);

            if (nV == 3)
            {
                a = _be.point(vhandles[0]);
                b = _be.point(vhandles[1]);
                c = _be.point(vhandles[2]);
                if (_be.has_face_normals()) {
                    n = _be.normal(fh);
                    if (math.isnan(n[0]) || n.sqrnorm < float.epsilon) {
                        // that's not a good normal!
                        n = calc_normal(a,b,c);
                    }
                } else {
                    n = calc_normal(a,b,c);
                }

                // face normal
                binary.write_float(n[0], fout);
                binary.write_float(n[1], fout);
                binary.write_float(n[2], fout);

                // face vertices
                binary.write_float(a[0], fout);
                binary.write_float(a[1], fout);
                binary.write_float(a[2], fout);

                binary.write_float(b[0], fout);
                binary.write_float(b[1], fout);
                binary.write_float(b[2], fout);

                binary.write_float(c[0], fout);
                binary.write_float(c[1], fout);
                binary.write_float(c[2], fout);

                // space filler
                binary.write_short(0, fout);
            }
            else
                derr.writefln("[STLWriter] : Warning: Skipped non-triangle data!").flush;
        }


        fclose(fout);
        return true;

    }
}


//== TYPE DEFINITION ==========================================================


static this()
{
    // creates and registers the default instance;
    STLWriter();
}


/// Declare the single entity of the STL writer
private _STLWriter_  __STLWriterInstance = null;
// register the STLLoader singleton with MeshLoader
_STLWriter_ STLWriter() { 
    if (__STLWriterInstance is null) { 
        __STLWriterInstance = new _STLWriter_();
    }
    return __STLWriterInstance; 
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
