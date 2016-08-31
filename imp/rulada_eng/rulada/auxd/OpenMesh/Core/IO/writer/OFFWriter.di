//============================================================================
// OFFWriter.d
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 *   This module implements a writer for the OFF File Format.
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
module auxd.OpenMesh.Core.IO.writer.OFFWriter;

//=== INCLUDES ================================================================


import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Utils.SingletonT;
import auxd.OpenMesh.Core.IO.exporter.BaseExporter;
import auxd.OpenMesh.Core.IO.writer.BaseWriter;

import auxd.OpenMesh.Core.Geometry.VectorT;
import auxd.OpenMesh.Core.Utils.color_cast;
import auxd.OpenMesh.Core.Mesh.Handles;
import auxd.OpenMesh.Core.IO.BinaryHelper;
import auxd.OpenMesh.Core.Utils.Endian;
import auxd.OpenMesh.Core.IO.IOManager;
import auxd.OpenMesh.Core.IO.Streams;
import auxd.OpenMesh.Core.IO.Options;

import std.string : c_str=toStringz;

import std.c;

//=== IMPLEMENTATION ==========================================================


/**
    Implementation of the OFF format writer. This class is singleton'ed by
    SingletonT to OFFWriter.
*/
class _OFFWriter_ : public BaseWriter
{
  public:

    this() { IOManager().register_module(this); }

    string get_description() /*const*/ { return "no description"; }
    string get_extensions() /*const*/  { return "off"; }

    void update_options(string _filename, ref Options _opt) {
        _opt -= Options.VertexColor;
        _opt -= Options.FaceNormal;
    }

    bool write(/*const*/ string _filename, BaseExporter _be, Options _opt) /*const*/
    {
        // check exporter features
        if ( !check( _be, _opt ) )
            return false;


        // check writer features
        if ( _opt.check(Options.VertexColor) || // not supported by module
             _opt.check(Options.FaceNormal)  )   // not supported by module
            return false;


        // open file
        char[] fmode = (_opt.check(Options.Binary)) ? "wb" : "w";
        FILE* fout = fopen(_filename.c_str(), fmode.ptr);
        if (!fout)
        {
            derr.writefln("[OFFWriter] : cannot open file ", _filename).flush;
            return false;
        }


        // write header line
        if (_opt.check(Options.VertexTexCoord)) fprintf(fout, "ST");
        if (_opt.check(Options.VertexColor))    fprintf(fout, "C");
        if (_opt.check(Options.VertexNormal))   fprintf(fout, "N");
        fprintf(fout, "OFF");
        if (_opt.check(Options.Binary))         fprintf(fout, " BINARY");
        fprintf(fout, "\n");


        // write to file
        bool result = (_opt.check(Options.Binary) ?
                       write_binary(fout, _be, _opt) :
                       write_ascii(fout, _be, _opt));


        // return result
        fclose(fout);
        return result;
    }

    size_t binary_size(BaseExporter _be, Options _opt) /*const*/
    {
        size_t header = 0;
        size_t data = 0;
        size_t _3longs = 3*uint.sizeof;   // spec says 32bit integers
        size_t _3floats = 3*float.sizeof; // spec says 32bit IEEE floats

        if ( !_opt.check(Options.Binary) )
            return 0;
        else
        {
            header += 11;                             // 'OFF BINARY\n'
            header += _3longs;                        // #V #F #E
            data   += _be.n_vertices() * _3floats;    // vertex data
        }

        if ( _opt.check(Options.VertexNormal) && _be.has_vertex_normals() )
        {
            header += 1; // N
            data   += _be.n_vertices() * _3floats;
        }

        if ( _opt.check(Options.VertexTexCoord) && _be.has_vertex_texcoords() )
        {
            size_t _2floats = 2*float.sizeof;
            header += 2; // ST
            data   += _be.n_vertices() * _2floats;
        }


        // topology
        if (_be.is_triangle_mesh())
        {
            size_t _4ui = 4*uint.sizeof;
            data += _be.n_faces() * _4ui;
        }
        else
        {
            uint i, nV, nF;
            VertexHandle[] vhandles;

            for (i=0, nF=_be.n_faces(); i<nF; ++i)
            {
                nV = _be.get_vhandles(FaceHandle(i), vhandles);
                data += nV * uint.sizeof;
            }
        }

        return header+data;

    }


  protected:

    bool write_ascii(FILE* _out, BaseExporter _be, Options _opt) /*const*/
    {
        //dlog.writefln("[OFFWriter] : write ascii file");


        uint i, j, nV, nF;
        Vec3f v, n;
        Vec2f t;
        VertexHandle vh;
        VertexHandle[] vhandles;


        // #vertices, #faces
        fprintf(_out, "%d %d 0\n", _be.n_vertices(), _be.n_faces());


        // vertex data (point, normals, texcoords)
        if (_opt.check(Options.VertexTexCoord) &&
            _opt.check(Options.VertexNormal))
        {
            for (i=0, nV=_be.n_vertices(); i<nV; ++i)
            {

                vh = VertexHandle(i);
                v  = _be.point(vh);
                n  = _be.normal(vh);
                t  = _be.texcoord(vh);
                fprintf(_out, "%.10f %.10f %.10f %.10f %.10f %.10f %f %f\n",
                        v[0], v[1], v[2], n[0], n[1], n[2], t[0], t[1]);
            }
        }
        else if (_opt.check(Options.VertexTexCoord))
        {
            for (i=0, nV=_be.n_vertices(); i<nV; ++i)
            {
                vh = VertexHandle(i);
                v  = _be.point(vh);
                t  = _be.texcoord(vh);
                fprintf(_out, "%.10f %.10f %.10f %f %f\n",
                        v[0], v[1], v[2], t[0], t[1]);
            }
        }
        else if (_opt.check(Options.VertexNormal))
        {
            for (i=0, nV=_be.n_vertices(); i<nV; ++i)
            {
                vh = VertexHandle(i);
                v  = _be.point(vh);
                n  = _be.normal(vh);
                fprintf(_out, "%.10f %.10f %.10f %.10f %.10f %.10f\n",
                        v[0], v[1], v[2], n[0], n[1], n[2]);
            }
        }
        else
        {
            for (i=0, nV=_be.n_vertices(); i<nV; ++i)
            {
                vh = VertexHandle(i);
                v  = _be.point(vh);
                fprintf(_out, "%.10f %.10f %.10f\n", v[0], v[1], v[2]);
            }
        }


        // faces (indices starting at 0)
        bool fcolor = _opt.check(Options.FaceColor) && _be.has_face_colors();
        if (_be.is_triangle_mesh())
        {
            if (fcolor) {
                float cscale = 1.0f/255.0f;
                for (i=0, nF=_be.n_faces(); i<nF; ++i)
                {
                    _be.get_vhandles(FaceHandle(i), vhandles);
                    Vec3ub color = _be.color(FaceHandle(i));
                    fprintf(_out, "3 %d %d %d %f %f %f\n",
                            vhandles[0].idx,vhandles[1].idx,vhandles[2].idx,
                            color[0]*cscale,color[1]*cscale,color[2]*cscale
                            );
                }
            }
            else {
                for (i=0, nF=_be.n_faces(); i<nF; ++i)
                {
                    _be.get_vhandles(FaceHandle(i), vhandles);
                    fprintf(_out, "3 %d %d %d\n",
                            vhandles[0].idx,
                            vhandles[1].idx,
                            vhandles[2].idx);
                }
            }
        }
        else
        {
            float cscale = 1.0f/255.0f;
            for (i=0, nF=_be.n_faces(); i<nF; ++i)
            {
                nV = _be.get_vhandles(FaceHandle(i), vhandles);
                fprintf(_out, "%d", nV);
                for (j=0; j<vhandles.length; ++j)
                    fprintf(_out, " %d", vhandles[j].idx);
                if (fcolor) { 
                    Vec3ub color = _be.color(FaceHandle(i));
                    fprintf(_out, " %f %f %f", 
                            color[0]*cscale,color[1]*cscale,color[2]*cscale);
                }                    
                fprintf(_out, "\n");
            }
        }


        return true;
    }


    bool write_binary(FILE* _out, BaseExporter _be, Options _opt) /*const*/
    {
        //omlog() << "[OFFWriter] : write bindary file\n";


        uint i, j, nV, nF;
        Vec3f v, n;
        Vec2f t;
        VertexHandle vh;
        VertexHandle[] vhandles;

        bool swap =
            ( (_opt.check(Options.MSB) && Endian.local()==Endian.LSB) ||
              (_opt.check(Options.LSB) && Endian.local()==Endian.MSB) );


        // header: #vertices, #faces, #edges
        write_int(_be.n_vertices(), _out, swap);
        write_int(_be.n_faces(),    _out, swap);
        write_int(0,                _out, swap);


        // vertex data (point, normals, texcoords)
        if (_opt.check(Options.VertexTexCoord) &&
            _opt.check(Options.VertexNormal))
        {
            for (i=0, nV=_be.n_vertices(); i<nV; ++i)
            {
                vh = VertexHandle(i);
                v  = _be.point(vh);
                n  = _be.normal(vh);
                t  = _be.texcoord(vh);
                write_float(v[0], _out, swap);
                write_float(v[1], _out, swap);
                write_float(v[2], _out, swap);
                write_float(n[0], _out, swap);
                write_float(n[1], _out, swap);
                write_float(n[2], _out, swap);
                write_float(t[0], _out, swap);
                write_float(t[1], _out, swap);
            }
        }
        else if (_opt.check(Options.VertexTexCoord))
        {
            for (i=0, nV=_be.n_vertices(); i<nV; ++i)
            {
                vh = VertexHandle(i);
                v  = _be.point(vh);
                t  = _be.texcoord(vh);
                write_float(v[0], _out, swap);
                write_float(v[1], _out, swap);
                write_float(v[2], _out, swap);
                write_float(t[0], _out, swap);
                write_float(t[1], _out, swap);
            }
        }
        else if (_opt.check(Options.VertexNormal))
        {
            for (i=0, nV=_be.n_vertices(); i<nV; ++i)
            {
                vh = VertexHandle(i);
                v  = _be.point(vh);
                n  = _be.normal(vh);
                write_float(v[0], _out, swap);
                write_float(v[1], _out, swap);
                write_float(v[2], _out, swap);
                write_float(n[0], _out, swap);
                write_float(n[1], _out, swap);
                write_float(n[2], _out, swap);
            }
        }
        else
        {
            for (i=0, nV=_be.n_vertices(); i<nV; ++i)
            {
                vh = VertexHandle(i);
                v  = _be.point(vh);
                write_float(v[0], _out, swap);
                write_float(v[1], _out, swap);
                write_float(v[2], _out, swap);
            }
        }


        // faces (indices starting at 0)
        bool fcolor = _opt.check(Options.FaceColor) && _be.has_face_colors();
        if (_be.is_triangle_mesh())
        {
            for (i=0, nF=_be.n_faces(); i<nF; ++i)
            {
                _be.get_vhandles(FaceHandle(i), vhandles);
                write_int(3, _out, swap);
                write_int(vhandles[0].idx(), _out, swap);
                write_int(vhandles[1].idx(), _out, swap);
                write_int(vhandles[2].idx(), _out, swap);
                // According to the spec linked above, the binary
                // version must have a # of color components after 
                // each face, for face colors.  0 of no face colors.
                if (fcolor) {
                    write_int(3, _out, swap);
                    Vec3f color = color_cast!(Vec3f)(_be.color(FaceHandle(i)));
                    write_float(color[0],_out, swap);
                    write_float(color[1],_out, swap);
                    write_float(color[2],_out, swap);
                } else {
                    write_int(0, _out, swap);
                }
            }
        }
        else
        {
            for (i=0, nF=_be.n_faces(); i<nF; ++i)
            {
                nV = _be.get_vhandles(FaceHandle(i), vhandles);
                write_int(nV, _out, swap);
                foreach(vhn; vhandles)
                    write_int(vhn.idx, _out, swap);
                if (fcolor) {
                    write_int(3, _out, swap);
                    Vec3f color = color_cast!(Vec3f)(_be.color(FaceHandle(i)));
                    write_float(color[0],_out, swap);
                    write_float(color[1],_out, swap);
                    write_float(color[2],_out, swap);
                } else {
                    write_int(0, _out, swap);
                }

            }
        }


        return true;
    }
}


//== TYPE DEFINITION ==========================================================

static this()
{
    // creates and registers the default instance;
    OFFWriter();
}



/// Declare the single entity of the OFF writer
private _OFFWriter_  __OFFWriterInstance = null;
// register the OFFLoader singleton with MeshLoader
_OFFWriter_ OFFWriter() {
    if (__OFFWriterInstance is null) {
        __OFFWriterInstance = new _OFFWriter_();
    }
    return __OFFWriterInstance;
}

unittest {
    auto x = OFFWriter();
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
