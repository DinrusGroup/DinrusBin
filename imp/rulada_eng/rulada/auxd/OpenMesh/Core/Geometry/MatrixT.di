/*==========================================================================
 * MatrixT.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * Fixed size matrix class (value type)
 *
 * The number of rows and columns is fixed at compile time.
 * Storage is column major like FORTRAN or OpenGL.
 *
 * Authors:  William V. Baxter III (OLM Digital, Inc.)
 * Date: 23 Nov 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 * License: ZLIB/LIBPNG
 */
//===========================================================================

module auxd.OpenMesh.Core.Geometry.MatrixT;

public import auxd.linalg.MatrixT;


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
