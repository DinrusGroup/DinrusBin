//============================================================================
// BaseReader.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *  Implements the baseclass for IOManager file access modules
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

module auxd.OpenMesh.Core.IO.reader.BaseReader;

//=== IMPORTS ================================================================

// OpenMesh
import auxd.OpenMesh.Core.IO.Streams;
import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.IO.Options;
import auxd.OpenMesh.Core.IO.importer.BaseImporter;
import auxd.OpenMesh.Core.Utils.SingletonT;


//=== IMPLEMENTATION ==========================================================


/**
   Base class for reader modules.
   Reader modules access persistent data and pass them to the desired
   data structure by the means of a BaseImporter derivative.
   All reader modules must be derived from this class.
*/
class BaseReader
{
public:

    /// Returns a brief description of the file type that can be parsed.
    abstract string get_description() /*const*/;
  
    /** Returns a string with the accepted file extensions separated by a 
        whitespace and in small caps.
    */
    abstract string get_extensions() /*const*/;

    /// Return magic bits used to determine file format
    string get_magic() /*const*/ { return ""; }


    /** Reads a mesh given by a filename. Usually this method opens a stream
        and passes it to stream read method. Acceptance checks by filename
        extension can be placed here.
    */
    abstract bool read(/*const*/ string _filename, 
                       BaseImporter _bi,
                       ref Options _opt);


    /// Returns true if reader can parse _filename (checks extension)
    bool can_u_read(/*const*/ string _filename) /*const*/
    {
        // get file extension
        string extension;
        int pos = std.string.rfind(_filename,".");

        if (pos != -1)
        { 
            extension = std.string.tolower(_filename[pos+1..$]);
        }

        // locate extension in extension string
        return (std.string.find(get_extensions(), extension) != -1);
    }


protected:

    // case insensitive search for _ext in _fname.
    bool check_extension(/*const*/ string _fname, 
                         /*const*/ string _ext) /*const*/
    {
        string cmpExt = std.string.tolower(_ext);

        int pos = std.string.rfind(_fname, ".");

        if (pos != -1 && _ext.length != 0 )
        { 
            string ext;

            // extension without dot!
            ext = std.string.tolower(_fname[pos+1..$]);
            return ext == cmpExt;
        }
        return false;  
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
