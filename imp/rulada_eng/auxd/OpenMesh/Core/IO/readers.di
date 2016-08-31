//============================================================================
// readers.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   Public import module, just imports all the known file format readers.
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 01 Sep 2007
 * Copyright: (C) 2007-2008 William Baxter, OLM Digital, Inc.
 * License: ZLIB/LIBPNG
 */
//============================================================================

module auxd.OpenMesh.Core.IO.readers;

public import auxd.OpenMesh.Core.IO.MeshIO;
public import auxd.OpenMesh.Core.IO.reader.OBJReader;
public import auxd.OpenMesh.Core.IO.reader.OFFReader;
public import auxd.OpenMesh.Core.IO.reader.STLReader;
public import auxd.OpenMesh.Core.IO.reader.PLYReader;

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
