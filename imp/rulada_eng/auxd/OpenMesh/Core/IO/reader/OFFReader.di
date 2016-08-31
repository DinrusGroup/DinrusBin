//============================================================================
// OFFReader.d
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 *   This module implements a reader for the OFF File Format.
 *
 *   For details on the format see:
 *      http://people.scs.fsu.edu/~burkardt/html/off_format.html
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 05 Oct 2007
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
module auxd.OpenMesh.Core.IO.reader.OFFReader;

//=== INCLUDES ================================================================


import auxd.OpenMesh.Core.IO.Streams;

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Utils.SingletonT;
import auxd.OpenMesh.Core.IO.importer.BaseImporter;
import auxd.OpenMesh.Core.IO.reader.BaseReader;
import auxd.OpenMesh.Core.IO.Options;
import auxd.OpenMesh.Core.IO.IOManager;
import auxd.OpenMesh.Core.IO.BinaryHelper;
import auxd.OpenMesh.Core.Geometry.VectorT;
import auxd.OpenMesh.Core.Utils.color_cast;
import auxd.OpenMesh.Core.Mesh.Handles;
import util = auxd.OpenMesh.Core.Utils.Std;
import endian = auxd.OpenMesh.Core.Utils.Endian;

import std.c;
import std.ctype;

//== IMPLEMENTATION ===========================================================

//import std.io;
//alias writefln debugfln;

/** 
    Implementation of the OFF format reader. This class is singleton'ed by 
    SingletonT to OFFReader.
*/
class _OFFReader_ : public BaseReader
{
  public:

    private alias std.string.toStringz c_str;
    const LINE_LEN = 1024;

    this() {   IOManager().register_module(this); }

    string get_description() /*const*/ { return "Object File Format"; }
    string get_extensions()  /*const*/ { return "off"; }
    string get_magic()       /*const*/ { return "OFF"; }

    bool read(/*const*/ string _filename, 
              BaseImporter _bi, 
              ref IO_Options _opt)
    {
        FILE* fin = fopen(c_str(_filename),  c_str("rb"));

        if (!fin)
        {
            derr.writefln("[OFFReader] : cannot not open file ", _filename).flush;
            return false;
        }

        bool result = read(fin, _bi, _opt);

        fclose(fin);
        return result;
    }

    bool can_u_read(/*const*/ string _filename) /*const*/
    {
        // !!! Assuming BaseReader.can_u_parse( std.string& )
        // does not call BaseReader.read_magic()!!!
        if (super.can_u_read(_filename))
        {
            auto ifs = new BufferedFile(_filename);
            scope(exit) { delete ifs; }
            return (ifs.isOpen() && can_u_read(ifs));
        }
        return false;
    }



  private:

    bool can_u_read(InputStream _is) /*const*/
    {
        // read 1st line
        char[] line;
        char*  p;
        line = _is.readLine();
        p = line.ptr;

        // check header: [ST][C][N][4][n]OFF BINARY
        file_props_ = _FileProperties();

        int vert_dim = 3;

        if (p[0] == 'S' && p[1] == 'T')
        { file_props_.vertex_has_texcoord = true; p += 2; }

        if (p[0] == 'C')
        { file_props_.vertex_has_color = true; ++p; }

        if (p[0] == 'N')
        { file_props_.vertex_has_normal = true; ++p; }

        if (p[0] == '4')
        { file_props_.vertex_has_hcoord = true; vert_dim = 4; ++p; }

        if (p[0] == 'n')
        { file_props_.has_vertex_dim = true; ++p; }
  
        if (!(p[0..3] == "OFF"))
            return false;

        if (strncmp(p+4, "BINARY", 6) == 0)
            file_props_.is_binary = true;

        if (file_props_.has_vertex_dim) {
            if (file_props_.is_binary) {
                // OFF binary is supposed to always be big endian
                bool swap = !endian.is_big_endian();
                vert_dim = read_int(_is, swap);
            }
            else {
                line = std.string.strip(line);
                vert_dim = std.conv.toInt(line);
            }
        }

        if (vert_dim != 3) return false;

        return true;

    }

    bool read(FILE* _in, BaseImporter _bi, ref IO_Options _opt ) /*const*/
    {
        // filter relevant options for reading
        bool swap = !endian.is_big_endian();

        // build options to be returned.  Start with requested properties.
        IO_Options opt_ret = _opt.flags & IO_Options.AllProperties;
        opt_ret += IO_Options.MSB;
        opt_ret -= IO_Options.FaceNormal;

        if (!file_props_.vertex_has_normal)   opt_ret -= IO_Options.VertexNormal;
        if (!file_props_.vertex_has_texcoord) opt_ret -= IO_Options.VertexTexCoord;
        if (!file_props_.vertex_has_color)    opt_ret -= IO_Options.VertexColor;

        if (file_props_.is_binary) {
            opt_ret += IO_Options.Binary;
            if (swap) opt_ret += IO_Options.Swap;
        }

        bool ret = (file_props_.is_binary ?
                    read_binary(_in, _bi, _opt, swap) :
                    read_ascii(_in, _bi, _opt));

        // Thanks to the foobar mess that is OFF format, 
        // You can't tell if there were face colors or not till after you read it.
        if (!file_props_.face_has_color) opt_ret -= IO_Options.FaceColor;
        _opt = opt_ret;
        return ret;
    }
    bool read_ascii(FILE* _in, BaseImporter _bi, IO_Options _want_opt) /*const*/
    {
        //dlog.writefln( "[OFFReader] : read ascii file").flush;
   
        uint          i, j, k, l, idx;
        uint          nV, nF, dummy;
        Vec3f         v, n;
        Vec2f         t;
        BaseImporter.VHandles vhandles;
        VertexHandle            vh;


        // read header line

        char[LINE_LEN] line;
        fgets(line.ptr, LINE_LEN, _in);
        int nread = strlen(line.ptr);

        // + optional space dimension
        if (file_props_.has_vertex_dim)
        {
            fscanf(_in, "%d", &i);
            if (i != 3) // cannot process more or less than 3 dimensions!
                return false;
        }

        // + skip comments
        do {
            fgets(line.ptr, LINE_LEN, _in);
            nread = strlen(line.ptr);
        } while(line[0] == '#');

        // + #Vertice, #Faces, #Edges
        sscanf(line.ptr, "%d %d %d", &nV, &nF, &dummy);
        _bi.reserve(nV, 3*nV, nF);

        bool want_vnorm  = _want_opt.check(IO_Options.VertexNormal);
        bool want_vcolor = _want_opt.check(IO_Options.VertexColor);
        bool want_vtexc  = _want_opt.check(IO_Options.VertexTexCoord);
        bool want_fcolor = _want_opt.check(IO_Options.FaceColor);
        bool has_vnorm = file_props_.vertex_has_normal;
        bool has_vcolor = file_props_.vertex_has_color;
        bool has_vtexc = file_props_.vertex_has_texcoord;

        // read vertices: coord [hcoord] [normal] [color] [texcoord] 
        if (has_vnorm && has_vtexc)
        {
            for (i=0; i<nV && !feof(_in); ++i)
            {
                fscanf(_in, "%f %f %f %f %f %f %f %f", 
                       &v.ptr[0], &v.ptr[1], &v.ptr[2], 
                       &n.ptr[0], &n.ptr[1], &n.ptr[2], 
                       &t.ptr[0], &t.ptr[1]);
                vh = _bi.add_vertex(v);
                if (want_vnorm) _bi.set_normal(vh, n);
                if (want_vtexc) _bi.set_texcoord(vh, t);
            }
        }

        else if (has_vnorm)
        {
            for (i=0; i<nV && !feof(_in); ++i)
            {
                fscanf(_in, "%f %f %f %f %f %f", 
                       &v.ptr[0], &v.ptr[1], &v.ptr[2], &n.ptr[0], &n.ptr[1], &n.ptr[2]);
                vh = _bi.add_vertex(v);
                if (want_vnorm) _bi.set_normal(vh, n);
            }
        }

        else if (has_vtexc)
        {
            for (i=0; i<nV && !feof(_in); ++i)
            {
                fscanf(_in, "%f %f %f %f %f", 
                       &v.ptr[0], &v.ptr[1], &v.ptr[2], &t.ptr[0], &t.ptr[1]);
                vh = _bi.add_vertex(v);
                if (want_vtexc) _bi.set_texcoord(vh, t);
            }
        }

        else
        {
            for (i=0; i<nV && !feof(_in); ++i)
            {
                fscanf(_in, "%f %f %f", &v.ptr[0], &v.ptr[1], &v.ptr[2]);
                _bi.add_vertex(v);
            }
        }


  
        // faces
        // #N <v1> <v2> .. <v(n-1)> [color spec]
        FaceHandle[] fh_list; fh_list.length = 10;
        for (i=0; i<nF; ++i)
        {
            char[][] parts;
            while(!parts) {
                fgets(line.ptr, LINE_LEN, _in);
                nread = strlen(line.ptr);
                parts = std.string.split(line[0..nread]);
            }
            int ipart = 0;
            nV = std.conv.toInt(parts[ipart++]);
                
            vhandles.length = nV;
            for (j=0; j<nV; ++j)
            {
                vhandles[j] = VertexHandle( std.conv.toInt(parts[ipart++]) );
            }
    
            fh_list.length = 0;
            _bi.add_face(vhandles, &fh_list);

            if (want_fcolor && parts.length-ipart>=3) {
                Vec3ub rgb = Vec3ub(255,255,255);
                // read face color
                file_props_.face_has_color = true;
                rgb[0] = cast(ubyte)((255.0 *std.conv.toDouble(parts[ipart++]))+0.5);
                rgb[1] = cast(ubyte)((255.0 *std.conv.toDouble(parts[ipart++]))+0.5);
                rgb[2] = cast(ubyte)((255.0 *std.conv.toDouble(parts[ipart++]))+0.5);
                foreach(fh; fh_list) {
                    _bi.set_color(fh,rgb);
                }
            }
        }

        // File was successfully parsed.
        return true;
    }

    bool read_binary(FILE* _in, BaseImporter _bi, IO_Options _want_opt, bool _swap) /*const*/
    {
        // dlog.writefln("[OFFReader] : read binary file").flush;

        uint           i, j;
        uint           nV, nF;
        uint           space_dim;
        Vec3f          v, n;
        Vec2f          t;
        BaseImporter.VHandles  vhandles;
        VertexHandle            vh;


        // header line
        char[LINE_LEN] line;
        fgets(line.ptr, LINE_LEN, _in);


        // vertex dimension
        if (file_props_.has_vertex_dim)
        {
            space_dim = read_int(_in, _swap);
            if (space_dim != 3) // cannot process more 3 dimensions!
                return false;
        }
  
        // #Vertice, #Faces, #Edges
        nV = read_int(_in, _swap);
        nF = read_int(_in, _swap);
        read_int(_in, _swap);
        _bi.reserve(nV, 3*nV, nF);

        bool want_vnorm  = _want_opt.check(IO_Options.VertexNormal);
        bool want_vcolor = _want_opt.check(IO_Options.VertexColor);
        bool want_vtexc  = _want_opt.check(IO_Options.VertexTexCoord);
        bool want_fcolor = _want_opt.check(IO_Options.FaceColor);
        bool has_vnorm = file_props_.vertex_has_normal;
        bool has_vcolor = file_props_.vertex_has_color;
        bool has_vtexc = file_props_.vertex_has_texcoord;

        // read vertices [hcoord] [normal] [color] [texcoord] 
        if (has_vnorm && has_vtexc)
        {
            for (i=0; i<nV && !feof(_in); ++i)
            {
                v[0] = read_float(_in, _swap);
                v[1] = read_float(_in, _swap);
                v[2] = read_float(_in, _swap);
                n[0] = read_float(_in, _swap);
                n[1] = read_float(_in, _swap);
                n[2] = read_float(_in, _swap);
                t[0] = read_float(_in, _swap);
                t[1] = read_float(_in, _swap);

                vh = _bi.add_vertex(v);
                if (want_vnorm) _bi.set_normal(vh, n);
                if (want_vtexc) _bi.set_texcoord(vh, t);
            }
        }

        else if (has_vnorm)
        {
            for (i=0; i<nV && !feof(_in); ++i)
            {
                v[0] = read_float(_in, _swap);
                v[1] = read_float(_in, _swap);
                v[2] = read_float(_in, _swap);
                n[0] = read_float(_in, _swap);
                n[1] = read_float(_in, _swap);
                n[2] = read_float(_in, _swap);

                vh = _bi.add_vertex(v);
                if (want_vnorm) _bi.set_normal(vh, n);
            }
        }

        else if (has_vtexc)
        {
            for (i=0; i<nV && !feof(_in); ++i)
            {
                v[0] = read_float(_in, _swap);
                v[1] = read_float(_in, _swap);
                v[2] = read_float(_in, _swap);
                t[0] = read_float(_in, _swap);
                t[1] = read_float(_in, _swap);

                vh = _bi.add_vertex(v);
                if (want_vtexc) _bi.set_texcoord(vh, t);
            }
        }

        else
        {
            for (i=0; i<nV && !feof(_in); ++i)
            {
                v[0] = read_float(_in, _swap);
                v[1] = read_float(_in, _swap);
                v[2] = read_float(_in, _swap);

                _bi.add_vertex(v);
            }
        }


  
        // faces
        // #N <v1> <v2> .. <v(n-1)> [color spec]
        FaceHandle[] fh_list; fh_list.length = 10;
        for (i=0; i<nF; ++i)
        {
            nV = read_int(_in, _swap);

            if (nV == 3)
            {
                vhandles.length = 3;
                vhandles[0] = VertexHandle(read_int(_in, _swap));
                vhandles[1] = VertexHandle(read_int(_in, _swap));
                vhandles[2] = VertexHandle(read_int(_in, _swap));
            }
            else 
            {
                vhandles.length = 0;
                for (j=0; j<nV; ++j)
                    vhandles ~= VertexHandle(read_int(_in, _swap));
            }

            // Spec says all OFF files must specify the number of face colors
            int nC = read_int(_in, _swap);
            Vec3ub rgb = Vec3ub(255,255,255);
            for (j=0; j<nC; ++j) {
                file_props_.face_has_color = true;
                ubyte cc = cast(ubyte)((read_float(_in, _swap)*255.0f)+0.5f);
                if (j<3) {
                    rgb[j] = cc;
                }
            }
            // Face added could be triangulated by actual mesh type, 
            // so get all handles back & set colors
            fh_list.length = 0;
            _bi.add_face(vhandles, &fh_list);
            if (want_fcolor && file_props_.face_has_color) {
                foreach(fh; fh_list) {
                    _bi.set_color(fh,rgb);
                }
            }
        }

        // File was successfully parsed.
        return true;
    }
   
    /// will be initialized, when calling can_u_parse()
    struct _FileProperties {
        bool has_vertex_dim = false; 
        bool vertex_has_normal = false;
        bool vertex_has_color = false;
        bool vertex_has_texcoord = false;
        bool vertex_has_hcoord = false;
        bool face_has_color = false;
        bool is_binary = false;
    } 
    _FileProperties file_props_;
}


//== TYPE DEFINITION ==========================================================


static this() {
    // creates and registers the default instance;
    OFFReader();
}


/// Declare the single entity of the OFF reader
private _OFFReader_  __OFFReaderInstance = null;
_OFFReader_ OFFReader() { 
    if (__OFFReaderInstance is null) { 
        __OFFReaderInstance = new _OFFReader_();
    }
    return __OFFReaderInstance; 
}


unittest {
    auto reader = OFFReader() ;
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
