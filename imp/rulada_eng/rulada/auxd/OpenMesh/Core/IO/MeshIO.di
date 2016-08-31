//============================================================================
// MeshIO.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
//============================================================================

/** Mesh Reading / Writing
 *
 *   Convenience functions that map to IOManager functions.
 *
 *   See_Also: auxd.OpenMesh.Core.IO.IOManager
 *
 *   Authors: Bill Baxter and the Computer Graphics Group, RWTH Aaachen
 *   Date: 28 Aug 2007
 *   License: LGPL 2.1
 */
module auxd.OpenMesh.Core.IO.MeshIO;

/*===========================================================================*\
 *                                                                           *
 *                               OpenMesh                                    *
 *        Copyright (C) 2003 by Computer Graphics Group, RWTH Aachen         *
 *                           www.openmesh.org                                *
 *                                                                           *
 *---------------------------------------------------------------------------* 
 *                                                                           *
 *                                License                                    *
 *                                                                           *
 *  This library is free software; you can redistribute it and/or modify it  *
 *  under the terms of the GNU Lesser General Public License as published    *
 *  by the Free Software Foundation, version 2.1.                            *
 *                                                                           *
 *  This library is distributed in the hope that it will be useful, but      *
 *  WITHOUT ANY WARRANTY; without even the implied warranty of               *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        *
 *  Lesser General Public License for more details.                          *
 *                                                                           *
 *  You should have received a copy of the GNU Lesser General Public         *
 *  License along with this library; if not, write to the Free Software      *
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.                *
 *                                                                           *
\*===========================================================================*/

//=== IMPORTS ================================================================

// -------------------- system settings
import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.IO.SR_store;
import auxd.OpenMesh.Core.IO.IOManager;
import auxd.OpenMesh.Core.IO.importer.ImporterT;
import auxd.OpenMesh.Core.IO.exporter.ExporterT;
import auxd.OpenMesh.Core.Utils.Exceptions : invalid_argument;

// This is important because it causes the reader and writer static
// constructors to be called, thus populating the global list of supported
// formats.
import auxd.OpenMesh.Core.IO.readers;
import auxd.OpenMesh.Core.IO.writers;

public import auxd.OpenMesh.Core.IO.Options : IO_Options;

//=== IMPLEMENTATION ==========================================================

//-----------------------------------------------------------------------------


/** Read a mesh from file _filename. 
 *
 *   Params:
 *    _mesh = The mesh. If you pass in a null _mesh, the function creates one for
 *            you using the default constructor.
 *    _filename = The name of the file to read from.
 *                The file format is guessed from the file extension.
 *    _optout = if non-null set to the options provided by the file loaded.
 */
bool read_mesh(MeshT)(ref MeshT _mesh, /*const*/ string _filename, IO_Options* _optout = null)
{
    IO_Options opt = IO_Options.All;
    return read_mesh(_mesh, _filename, opt);
    if (_optout) *_optout = opt;
}


/** Read a mesh from file _filename. 
 *
 *   Params:
 *    _mesh = The mesh. If you pass in a null _mesh, the function creates one for
 *            you using the default constructor.
 *    _filename = The name of the file to read from.
 *                The file format is guessed from the file extension.
 *    _opt_inout = This will be filled in with information about the file read.
 *                 On input, it specifies which properties you are want to read.
 *                 Set this to IO_Options.All if you want all available)
 *                 This can be used to later write a mesh with the same options as 
 *                 the one read.
 */
bool read_mesh(MeshT,dummy=void)(ref MeshT _mesh, string _filename, inout IO_Options _opt_inout)
{
    if (_mesh) {
        _mesh.clear();
    } 
    else {
        static if(is(typeof(new MeshT))) {
            _mesh = new MeshT;
        }
        else {
            throw new invalid_argument("Mesh is null and has no default constructor");
        }
    }
    scope importer = new ImporterT!(MeshT)(_mesh);
    return IOManager().read(_filename, importer, _opt_inout);
}


//-----------------------------------------------------------------------------


/** Write a mesh to the file _filename. 

    The file format is guessed from _filename's extension. 
*/
bool write_mesh(Mesh)(/*const*/ Mesh _mesh, /*const*/ string _filename,
                      IO_Options _opt = IO_Options(IO_Options.Default))
{ 
    scope exporter = new ExporterT!(Mesh)(_mesh);
    return IOManager().write(_filename, exporter, _opt);
}


/** Ask the IOManager to update _opt by removing options that the target writer
 *  does not support.
 *
 *  Just calls the method of the same name in the IOManager class.
 */
bool supported_writer_options(string _filename, ref IO_Options _opt) {
    return IOManager().supported_writer_options(_filename, _opt);
}

/** Ask the IOManager for the full set of options supported by the target writer.
 *
 *  Just calls the method of the same name in the IOManager class.
 */
IO_Options supported_writer_options(string _filename) {
    return IOManager().supported_writer_options(_filename);
}


//-----------------------------------------------------------------------------


size_t binary_size(Mesh)(/*const*/ Mesh _mesh, /*const*/ string _format,
                         IO_Options _opt = IO_Options(IO_Options.Default))
{
    scope exporter = new ExporterT!(Mesh)(_mesh);
    return IOManager().binary_size(_format, exporter, _opt);
}


//-----------------------------------------------------------------------------


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
