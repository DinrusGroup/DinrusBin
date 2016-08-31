//============================================================================
// BaseWriter.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *  Implements the baseclass for IOManager writer modules
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

module auxd.OpenMesh.Core.IO.writer.BaseWriter;

//=== INCLUDES ================================================================


// OpenMesh
import auxd.OpenMesh.Core.IO.Streams;
import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.IO.Options;
import auxd.OpenMesh.Core.IO.exporter.BaseExporter;

import std.string : tolower, rfind, find;

//=== IMPLEMENTATION ==========================================================


/**
   Base class for all writer modules. The module should register itself at
   the IOManager by calling the register_module function.
*/
class BaseWriter
{
public:

    alias uint Option;
   
    /// Return short description of the supported file format.
    abstract string get_description() /*const*/ ;
  
    /// Return file format's extension.
    abstract string get_extensions() /*const*/ ;

    /// Returns true if writer can parse _filename (checks extension)
    bool can_u_write(/*const*/ string _filename) /*const*/
    {
        // get file extension
        string extension;
        int pos = rfind(_filename,".");

        if (pos != -1)
        { 
            extension = tolower( _filename[pos+1..$] );
        }

        // locate extension in extension string
        return (find(get_extensions(), extension) != -1);

    }

    /// Write to file _filename. Data source specified by BaseExporter _be.
    abstract bool write(/*const*/ string _filename, 
                        BaseExporter _be,
                        Options _opt) /*const*/;

    /// Returns expected size of file if binary format is supported else 0.
    size_t binary_size(BaseExporter, Options) /*const*/ { return 0; }

    /// Turn off any options that are not supported.
    /// For some formats there are options that depend on the filename
    /// (namely ascii/binary specific names) so the filename is passed as well.
    abstract void update_options(string _filename, ref Options opt);


protected:

  bool check(BaseExporter _be, Options _opt) /*const*/
  {
    return (_opt.check(Options.VertexNormal ) <= _be.has_vertex_normals())
       &&  (_opt.check(Options.VertexTexCoord)<= _be.has_vertex_texcoords())
       &&  (_opt.check(Options.VertexColor)   <= _be.has_vertex_colors())
       &&  (_opt.check(Options.FaceNormal)    <= _be.has_face_normals())
       &&  (_opt.check(Options.FaceColor)     <= _be.has_face_colors());
  }
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
