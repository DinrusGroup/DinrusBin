//============================================================================
// IOManager.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *  Implements the OpenMesh IOManager singleton
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

module auxd.OpenMesh.Core.IO.IOManager;

//=== INCLUDES ================================================================


// STL
import auxd.OpenMesh.Core.IO.Streams;
//import auxd.OpenMesh.Core.Utils.Set;

import auxd.OpenMesh.Core.System.config;
import auxd.OpenMesh.Core.IO.Options;
import auxd.OpenMesh.Core.IO.reader.BaseReader;
import auxd.OpenMesh.Core.IO.writer.BaseWriter;
import auxd.OpenMesh.Core.IO.importer.BaseImporter;
import auxd.OpenMesh.Core.IO.exporter.BaseExporter;
import auxd.OpenMesh.Core.Utils.SingletonT;


//=== IMPLEMENTATION ==========================================================


/** This is the real IOManager class that is later encapsulated by 
    SingletonT to enforce its uniqueness. _IOManager_ is not meant to be used
    directly by the programmer - the IOManager alias exists for this task.

    All reader/writer modules register themselves at this class. For
    reading or writing data all modules are asked to do the job. If no
    suitable module is found, an error is returned.

    For the sake of reading, the target data structure is hidden
    behind the BaseImporter interface that takes care of adding
    vertices or faces.

    Writing from a source structure is encapsulate similarly behind a
    BaseExporter interface, providing iterators over vertices/faces to
    the writer modules.

    See_Also: \ref mesh_io
*/

class _IOManager_
{
private:
  
    this() {}
    //friend _IOManager_& IOManager();


public:


    /**
       Read a mesh from file _filename. The target data structure is specified
       by the given BaseImporter. The \c read method consecutively queries all
       of its reader modules. True is returned upon success, false if all 
       reader modules failed to interprete _filename.
    */
    bool read(/*const*/ string _filename, 
              BaseImporter _bi,
              ref Options _opt)
    {
        // Try all registered modules
        foreach(it,_; reader_modules_) {
            if (it.can_u_read(_filename))
            {
                _bi.prepare();
                bool ok = it.read(_filename, _bi, _opt);
                _bi.finish();
                return ok;
            }
        }
        // All modules failed to read
        return false;

    }


    /** Write a mesh to file _filename. The source data structure is specified
        by the given BaseExporter. The \c save method consecutively queries all
        of its writer modules. True is returned upon success, false if all 
        writer modules failed to write the requested format.
        Options is determined by _filename's extension.
    */
    bool write(/*const*/ string _filename, 
               BaseExporter _be,
               Options _opt=Options(Options.Default))
    {
        if (!writer_modules_) 
        {
            derr.writefln("[auxd.OpenMesh.IO._IOManager_] No writing modules available!");
            return false;
        }

        // Try all registered modules
        foreach(it,_; writer_modules_) 
        {
            if (it.can_u_write(_filename))
            {
                return it.write(_filename, _be, _opt); 
            }
        }
  
        // All modules failed to save
        return false;

    }

   
    /** Ask the writer that will be used to update the options passed in.
     *  Since writers fail if asked to write files in a format they aren't
     *  capable of it is necessary to get the closest set of options that
     *  the writer supports.  This will only turn off options in _opt, not
     *  enable new ones (unless the format is incapable of writing without
     *  that particular feature for some reason.)
     *
     *  Returns false if there's no writer that can handle a file of the given type.
     */
    bool supported_writer_options(string _filename, ref Options _opt) {
        if (!writer_modules_) 
        {
            derr.writefln("[auxd.OpenMesh.IO._IOManager_] No writing modules available!");
            return false;
        }

        // Try all registered modules
        foreach(it,_; writer_modules_) 
        {
            if (it.can_u_write(_filename))
            {
                it.update_options(_filename, _opt);
                return true;
            }
        }
  
        // All modules failed to recognize the filename.
        return false;
    }

    /** Get an option set containing all options supported by the writer.
     *  The writer checked is the same as the one used by write() 
     *  given the same filename.
     */
    Options supported_writer_options(string _filename) {
        auto opt = Options(Options.All);
        supported_writer_options(_filename, opt);
        return opt;
    }

    /// Returns true if the format is supported by one of the reader modules.
    bool can_read( /*const*/ string _format ) /*const*/
    {
        string filename = "dummy." ~ _format;
  
        foreach(it,_; reader_modules_)
            if (it.can_u_read(filename))
                return true;
  
        return false;
    }

    /// Returns true if the format is supported by one of the writer modules.
    bool can_write( /*const*/ string _format ) /*const*/
    {
        string filename = "dummy." ~ _format;
    
        // Try all registered modules
        foreach(it,_; writer_modules_)
            if (it.can_u_write(filename))
                return true;
    
        return false;
    }
   
    size_t binary_size(/*const*/ string _format, 
                       BaseExporter _be,
                       Options _opt = Options() )
    {
        /*const*/ BaseWriter bw = find_writer(_format);
        return bw ? bw.binary_size(_be,_opt) : 0;
    }    



public:


private:

    // collect all readable file extensions
    void update_read_filters()
    {
        char[] all, filters;
  
        foreach(it,_; reader_modules_)
        {
            filters ~= it.get_description() ~ " (";
    
            string[] exts = std.string.split(it.get_extensions());
            
            foreach(s; exts)
            { 
                s = " *." ~ s; 
                filters ~= s;
                all ~= s; 
            }
    
            filters ~= " );;";
        }

        all = "All files ( " ~ all ~ " );;";
  
        read_filters_ = all ~ filters;

    }


    // collect all writeable file extensions
    void update_write_filters()
    {
        char[] all, filters;
  
        foreach(it,_; writer_modules_)
        {
            filters ~= it.get_description() ~ " (";
    
            string[] exts = std.string.split(it.get_extensions());
            
            foreach(s; exts)
            { 
                s = " *." ~ s; 
                filters ~= s;
                all ~= s; 
            }
    
            filters ~= " );;";
        }

        all = "All files ( " ~ all ~ " );;";
  
        write_filters_ = all ~ filters;
    }
   


public:  //-- SYSTEM PART------------------------------------------------------


    /** Registers a new reader module. A call to this function should be
        implemented in the constructor of all classes derived from BaseReader. 
    */
    bool register_module(BaseReader _bl)
    {
        reader_modules_[_bl] = true;
        update_read_filters();
        return true;
    }


  
    /** Registers a new writer module. A call to this function should be
        implemented in the constructor of all classed derived from BaseWriter. 
    */
    bool register_module(BaseWriter _bw)
    {
        writer_modules_[_bw] = true;
        update_write_filters();
        return true;
    }

  
private:
  
    /*const*/ BaseWriter find_writer(/*const*/ string _format)
    {
        int dot =  std.string.rfind(_format, '.');

        string ext;
        if (dot == -1)
            ext = _format;
        else
            ext = _format[dot+1..$];
  
        string filename = "dummy." ~ ext;
  
        // Try all registered modules
        foreach(it,_; writer_modules_)
            if (it.can_u_write(filename))
                return it;

        return null;
    }
  
    // stores registered reader modules
    bool[BaseReader] reader_modules_;
  
    // stores registered writer modules
    bool[BaseWriter] writer_modules_;
  
    // input filters (e.g. for Qt file dialog)
    string read_filters_;
  
    // output filters (e.g. for Qt file dialog)
    string write_filters_;
}


//=============================================================================


private _IOManager_  __IOManager_instance = null;

_IOManager_ IOManager() {
    if (!__IOManager_instance)  __IOManager_instance = new _IOManager_();
    return __IOManager_instance;
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
