/*==========================================================================
 * STLReader.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * An OpenMesh reader for models in the STL format.
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
 * Created: 13 Oct 2007 (ported to D)
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

module auxd.OpenMesh.Core.IO.reader.STLReader;

//=== IMPORTS =================================================================


import auxd.OpenMesh.Core.IO.Streams;

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Utils.SingletonT;
import auxd.OpenMesh.Core.IO.importer.BaseImporter;
import auxd.OpenMesh.Core.IO.reader.BaseReader;
import binary = auxd.OpenMesh.Core.IO.BinaryHelper;
import auxd.OpenMesh.Core.IO.Options : IO_Options;
import auxd.OpenMesh.Core.IO.IOManager;
import auxd.OpenMesh.Core.Mesh.Handles;
import auxd.OpenMesh.Core.Geometry.VectorT;
import auxd.OpenMesh.Tools.Utils.MapT;
import endian = auxd.OpenMesh.Core.Utils.Endian;

import strlib = std.string;
import math = std.math;

import std.c;
import std.ctype;

//== IMPLEMENTATION ===========================================================


/** 
    Implementation of the STL format reader. This class is singleton'ed by 
    SingletonT to STLReader.
*/
private class _STLReader_ : public BaseReader
{
  public:

    // constructor
    this() { IOManager().register_module(this); }


    string get_description() /*const*/ 
    { return "Stereolithography Interface Format"; }

    string get_extensions() /*const*/ { return "stl stla stlb"; }

    bool read(/*const*/ string _filename, BaseImporter _bi, inout IO_Options _opt)
    {
        bool result = false;

        // build options to be returned.  Start with requested properties.
        IO_Options opt_ret = _opt.flags & IO_Options.AllProperties;
        opt_ret += IO_Options.LSB;

        // STL basically ONLY supports face normals

        //opt_ret -= IO_Options.FaceNormal;
        opt_ret -= IO_Options.VertexNormal;
        opt_ret -= IO_Options.VertexColor;
        opt_ret -= IO_Options.VertexTexCoord;
        opt_ret -= IO_Options.FaceColor;

        STL_Type file_type = STL_Type.NONE;

        if ( check_extension( _filename, "stla" ) )
        {
            file_type = STL_Type.STLA;
        }

        else if ( check_extension( _filename, "stlb" ) )
        {
            file_type = STL_Type.STLB;
        }

        else if ( check_extension( _filename, "stl" ) )
        {
            file_type = check_stl_type(_filename);
        }

        switch (file_type)
        {
        case STL_Type.STLA:
        {
            opt_ret -= IO_Options.Binary;
            result = read_stla(_filename, _bi, opt_ret);
            break;
        }
    
        case STL_Type.STLB:
        {
            opt_ret += IO_Options.Binary;
            result = read_stlb(_filename, _bi, opt_ret);
            break;
        }
    
        default: 
        {
            result = false;
            break;
        }
        }

        _opt = opt_ret;
        return result;

    }


    /** Set the threshold to be used for considering two points to be equal.
     *
     *   This can be used to merge small gaps 
     */
    void set_epsilon(float _eps) { eps_=_eps; }

    /// Returns the threshold to be used for considering two points to be equal.
    float epsilon() /*const*/ { return eps_; }

  
  private:

    enum STL_Type { STLA, STLB, NONE };
    STL_Type check_stl_type(/*const*/ string _filename) /*const*/
    {
        // assume it's binary stl, then file size is known from #triangles
        // if size matches, it's really binary


        // open file
        FILE* fin = fopen(strlib.toStringz(_filename), "rb");
        if (!fin) return STL_Type.NONE;


        // determine endian mode STL supposedly always little endian according
        // to wikipedia: http://en.wikipedia.org/wiki/STL_(file_format)
        bool swapFlag = !endian.is_little_endian();

        // read number of triangles
        char[128] dummy;
        fread(dummy.ptr, 1, 80, fin);
        uint nT = binary.read_int(fin, swapFlag);


        // compute file size from nT
        uint binary_size = 84 + nT*50;


        // get actual file size
        uint file_size = 0;
        rewind(fin);
        while (!feof(fin))
            file_size += fread(dummy.ptr, 1, 128, fin);
        fclose(fin);


        // if sizes match -> it's STLB
        return (binary_size == file_size ? STL_Type.STLB : STL_Type.STLA);
    }

    bool read_stla(/*const*/ string _filename, BaseImporter _bi, IO_Options _opt) /*const*/
    {
        //dlog.writefln("[STLReader] : read ascii file").flush;


        FILE*  fin = fopen(strlib.toStringz(_filename), "r");
        if (!fin)
        {
            derr.writefln("[STLReader] : cannot not open file '%s'", _filename).flush;
            return false;
        }

        char[128] line;
        char*   p;
        uint    i;
        Vec3f   v;
        Vec3f   normal;
        bool    normal_set = false;
        uint    cur_idx=0;
        BaseImporter.VHandles vhandles;

        alias MapT!(Vec3f, VertexHandle, CmpVec) Map;

        auto comp = CmpVec(eps_);
        auto vMap = Map(comp);
        Map.iterator vMapIt;

        bool want_fnorm  = _opt.check(IO_Options.FaceNormal);
  
        void skip_space() {
            for (p=line.ptr; isspace(*p) && *p!='\0'; ++p) {} // skip white-space
        }

        while (fin && !feof(fin) && fgets(line.ptr, 128, fin))
        {
            skip_space();
            
            if (want_fnorm && strncmp(p, "facet normal", 12)==0 || strncmp(p, "FACET NORMAL", 12)==0)
            {
                sscanf(p+12, "%f %f %f", &normal.ptr[0], &normal.ptr[1], &normal.ptr[2]);
                normal_set = true;
            }
            else if ((strncmp(p, "outer", 5) == 0) || (strncmp(p, "OUTER", 5) == 0))
            { 
                vhandles.length = 0;
      
                for (i=0; i<3; ++i)
                {
                    fgets(line.ptr, 128, fin);
                    skip_space();
                    sscanf(p+6, "%f %f %f", &v.ptr[0], &v.ptr[1], &v.ptr[2]);

                    // has vector been referenced before?
                    if ((vMapIt=vMap.find(v)) == vMap.end())
                    {
                        // No : add vertex and remember idx/vector mapping
                        _bi.add_vertex(v);
                        vhandles ~= VertexHandle(cur_idx);
                        vMap[v] = VertexHandle(cur_idx++);
                    }
                    else 
                        // Yes : get index from map
                        vhandles ~= vMapIt.value;
                }

                // Add face only if it is not degenerate
                if ((vhandles[0] != vhandles[1]) &&
                    (vhandles[0] != vhandles[2]) &&
                    (vhandles[1] != vhandles[2]))
                {
                    FaceHandle fh = _bi.add_face(vhandles);
                    if (want_fnorm && normal_set) {
                        _bi.set_normal(fh, normal);
                        normal_set = false;
                    }
                }
            }
        }


        fclose(fin);


        // In general a file has data, there the number of vertices cannot be 0.
        return _bi.n_vertices() != 0;

    }

    bool read_stlb(/*const*/ string _filename, BaseImporter _bi, IO_Options _opt) /*const*/
    {
        dlog.writefln("[STLReader] : read binary file").flush;


        FILE*  fin = fopen(strlib.toStringz(_filename), "rb");
        if (!fin)
        {
            derr.writefln("[STLReader] : cannot not open file '%s'", _filename).flush;
            return false;
        }


        char[80]           dummy;
        BaseImporter.VHandles     vhandles;

        auto comp = CmpVec(eps_);
        alias MapT!(Vec3f, VertexHandle, CmpVec) Map;

        auto vMap = Map(comp);
        Map.iterator vMapIt;

        bool want_fnorm  = _opt.check(IO_Options.FaceNormal);

        // determine endian mode (STL always little endian)
        bool swapFlag = !endian.is_little_endian();
    
        // read number of triangles
        fread(dummy.ptr, 1, 80, fin);
        int nT = binary.read_int(fin, swapFlag);

        uint               cur_idx=0;
        Vec3f v, normal;

        // read triangles
        while (nT>0)
        {
            vhandles.length = 0;

            if (want_fnorm) {
                normal[0] = binary.read_float(fin, swapFlag);
                normal[1] = binary.read_float(fin, swapFlag);
                normal[2] = binary.read_float(fin, swapFlag);
            } else {
                // skip triangle normal
                fread(dummy.ptr, 1, 12, fin);
            }

            // triangle's vertices
            for (int i=0; i<3; ++i)
            {
                v[0] = binary.read_float(fin, swapFlag);
                v[1] = binary.read_float(fin, swapFlag);
                v[2] = binary.read_float(fin, swapFlag);

                // has vector been referenced before?
                if ((vMapIt=vMap.find(v)) == vMap.end)
                {
                    // No : add vertex and remember idx/vector mapping
                    _bi.add_vertex(v);
                    vhandles ~= VertexHandle(cur_idx);
                    vMap[v] = VertexHandle(cur_idx++);
                }
                else 
                    // Yes : get index from map
                    vhandles ~= vMapIt.value;
            }
    

            // Add face only if it is not degenerated
            if ((vhandles[0] != vhandles[1]) &&
                (vhandles[0] != vhandles[2]) &&
                (vhandles[1] != vhandles[2])) 
            {
                FaceHandle fh = _bi.add_face(vhandles);
                if (want_fnorm)
                    _bi.set_normal(fh, normal);
            }
    
            fread(dummy.ptr, 1, 2, fin);
            --nT;
        }

        return true;

    }

  private:
    float eps_ = float.epsilon;
}


private struct CmpVec
{
public:

    static CmpVec opCall(float _eps=float.epsilon) { 
        CmpVec R;
        R.eps_=_eps;
        return R;
    }

    bool opCall( /*const*/ ref Vec3f _v0, /*const*/ ref Vec3f _v1 ) /*const*/
    {
        if (math.abs(_v0[0] - _v1[0]) <= eps_) 
        {
            if (math.abs(_v0[1] - _v1[1]) <= eps_) 
            {
                return (_v0[2] < _v1[2] - eps_);
            }
            else return (_v0[1] < _v1[1] - eps_);
        }
        else return (_v0[0] < _v1[0] - eps_);
    }

private:
    float eps_;
}


//== TYPE DEFINITION ==========================================================


static this() {
    // creates and registers the default instance;
    STLReader();
}



private _STLReader_  __STLReaderInstance = null;
_STLReader_ STLReader() { 
    if (__STLReaderInstance is null) { 
        __STLReaderInstance = new _STLReader_();
    }
    return __STLReaderInstance; 
}


unittest {
    auto reader = STLReader() ;
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
