//============================================================================
// OBJWriter.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *  Implements an IOManager writer module for OBJ files
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

module auxd.OpenMesh.Core.IO.writer.OBJWriter;

//=== INCLUDES ================================================================


import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.Utils.SingletonT;
import auxd.OpenMesh.Core.IO.exporter.BaseExporter;
import auxd.OpenMesh.Core.IO.writer.BaseWriter;

import auxd.OpenMesh.Core.Geometry.VectorT;
import auxd.OpenMesh.Core.Mesh.Handles;
import auxd.OpenMesh.Core.IO.BinaryHelper;
import auxd.OpenMesh.Core.IO.IOManager;
import auxd.OpenMesh.Core.IO.Streams;
import auxd.OpenMesh.Core.IO.Options;

import std.string : toStringz;

import std.c;

//=== IMPLEMENTATION ==========================================================


/** 
    This class defines the OBJ writer. This class is further singleton'ed
    by SingletonT to OBJWriter.
*/
class _OBJWriter_ : public BaseWriter
{
  public:

    this() { IOManager().register_module(this); }

    string get_description() /*const*/  { return "Alias/Wavefront"; }
    string get_extensions()  /*const*/  { return "obj"; }

    bool write(/*const*/ string _filename, BaseExporter _be, Options _opt) /*const*/
    {
        FILE* fout = fopen(toStringz(_filename), "w");
        if (!fout)
        {
            derr.writefln("[OBJWriter] : cannot open file ", _filename);
            return false;
        }

        bool result = write(fout, _be, _opt);
  
        fclose(fout);
        return result;
    }

    size_t binary_size(BaseExporter, Options) /*const*/ { return 0; }

    void update_options(string _filename, ref Options _opt) {
        _opt -= Options.Binary;
        _opt -= Options.FaceNormal;
        _opt -= Options.FaceColor;
    }

  private:

    bool write(FILE* _out, BaseExporter _be, Options _opt) /*const*/
    {

        uint i, j, nV, nF, idx;
        Vec3f v, n;
        Vec2f t;
        VertexHandle vh;
        VertexHandle[] vhandles;


        //dlog.writefln("[OBJWriter] : write file").flush;


        // check exporter features
        if (!check( _be, _opt))
            return false;


        // check writer features
        if ( _opt.check(Options.Binary)     || // not supported by format
             _opt.check(Options.FaceNormal) || // ?
             _opt.check(Options.FaceColor)  )  // ?
            return false;
  

        // header
        fprintf(_out, "# %d vertices, %d faces\n", 
                _be.n_vertices(), _be.n_faces());


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
                fprintf(_out, "v %.10f %.10f %.10f\nvn %.10f %.10f %.10f\nvt %f %f\n", 
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
                fprintf(_out, "v %.10f %.10f %.10f\nvt %.10f %.10f\n", 
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
                fprintf(_out, "v %.10f %.10f %.10f\nvn %.10f %.10f %.10f\n", 
                        v[0], v[1], v[2], n[0], n[1], n[2]);
            }
        }
        else
        {
            for (i=0, nV=_be.n_vertices(); i<nV; ++i)
            {
                vh = VertexHandle(i);
                v  = _be.point(vh);
                fprintf(_out, "v %.10f %.10f %.10f\n", v[0], v[1], v[2]);
            }
        }




        // faces (indices starting at 1 not 0)
        if (_opt.check(Options.VertexTexCoord) && 
            _opt.check(Options.VertexNormal))
        {
            for (i=0, nF=_be.n_faces(); i<nF; ++i)
            {
                nV = _be.get_vhandles(FaceHandle(i), vhandles);
                fprintf(_out, "f");
                for (j=0; j<vhandles.length; ++j)
                {
                    idx = vhandles[j].idx() + 1;
                    fprintf(_out, " %d/%d/%d", idx, idx, idx);
                }
                fprintf(_out, "\n");
            }
        }
        else if (_opt.check(Options.VertexTexCoord))
        {
            for (i=0, nF=_be.n_faces(); i<nF; ++i)
            {
                nV = _be.get_vhandles(FaceHandle(i), vhandles);
                fprintf(_out, "f");
                for (j=0; j<vhandles.length; ++j)
                {
                    idx = vhandles[j].idx() + 1;
                    fprintf(_out, " %d/%d/", idx, idx);
                }
                fprintf(_out, "\n");
            }
        }
        else if (_opt.check(Options.VertexNormal))
        {
            for (i=0, nF=_be.n_faces(); i<nF; ++i)
            {
                nV = _be.get_vhandles(FaceHandle(i), vhandles);
                fprintf(_out, "f");
                for (j=0; j<vhandles.length; ++j)
                {
                    idx = vhandles[j].idx() + 1;
                    fprintf(_out, " %d//%d", idx, idx);
                }
                fprintf(_out, "\n");
            }
        }
        else
        {
            for (i=0, nF=_be.n_faces(); i<nF; ++i)
            {
                nV = _be.get_vhandles(FaceHandle(i), vhandles);
                fprintf(_out, "f");
                for (j=0; j<vhandles.length; ++j)
                    fprintf(_out, " %d", vhandles[j].idx() + 1);
                fprintf(_out, "\n");
            }
        }


        return true;
    }

}


//== TYPE DEFINITION ==========================================================

static this()
{
    // creates and registers the default instance;
    OBJWriter();
}


/// Declare the single entity of the OBJ writer
private _OBJWriter_  __OBJWriterInstance = null;
// register the OBJLoader singleton with MeshLoader
_OBJWriter_ OBJWriter() { 
    if (__OBJWriterInstance is null) { 
        __OBJWriterInstance = new _OBJWriter_();
    }
    return __OBJWriterInstance; 
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
